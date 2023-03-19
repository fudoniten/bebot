(ns bebot.client
  (:require [bebot.model :refer [id user-id new-post to-model mentions-user? channel-last-view from-model created-at]]
            [bebot.api.client :as client]
            [bebot.api.channel :as chan]
            [fudo-clojure.result :refer [let-result exception-failure success failure map-success dispatch-result]]
            [clojure.core.async :as async :refer [go-loop chan timeout >! <!]])
  (:import net.bis5.mattermost.client4.MattermostClient
           net.bis5.mattermost.model.ChannelView))

(defn- to-result [resp]
  (if (.hasError resp)
    (let [err         (.readError resp)
          msg         (.getMessage err)
          status-code (.getStatusCode err)
          full-msg    (str "[" status-code "] " msg)]
      ;; A silly hack to catch the stack trace at this point
      (try
        (throw (ex-info full-msg
                        {:status-code status-code
                         :error       err}))
        (catch clojure.lang.ExceptionInfo e
          (exception-failure e))))
    (success (to-model (.readEntity resp)))))

(defn- to-millis [instant]
  (.toEpochMilli instant))

(defn- sort-by-create-date [objs]
  (letfn [(compare-dates [a b]
            (.isBefore (created-at a) (created-at b)))]
    (sort compare-dates objs)))

(defn- remove-posts-by [user posts]
  (letfn [(post-by-user? [post]
            (= (id user) (user-id post)))]
    (filter (complement post-by-user?) posts)))

(defn- yield-to-channel
  [coll-gen &
   {:keys [poll-delay buffer-size]
    :or   {poll-delay 30 buffer-size 10}}]
  (let [out-chan (chan buffer-size)]
    (go-loop [result (coll-gen)]
      (dispatch-result result
                       ([os] (doseq [o (sort-by-create-date os)]
                               (>! out-chan (success o))))
                       ([e]  (>! out-chan (exception-failure e))))
      (<! (timeout (* poll-delay 1000)))
      (recur (coll-gen)))
    out-chan))

(defrecord BebotChannel [client channel last-viewed me]
  chan/IBebotChannelApi
  (send-post! [_ message]
    (client/create-post! client (new-post channel message)))

  (mark-read! [_]
    (client/mark-read! client (id channel)))

  (last-read [_] @last-viewed)

  (get-new-posts! [self]
    (let-result [msgs (chan/peek-new-posts! self)
                 read-instant (client/mark-read! client (id channel))]
      (do (swap! last-viewed (fn [_] read-instant))
          (success (remove-posts-by me msgs)))))

  (peek-new-posts! [self]
    (chan/get-posts-since! self @last-viewed))

  (get-posts-since! [_ instant]
    (let-result [msgs (client/get-posts-since! client (id channel) instant)]
      (success (remove-posts-by me msgs))))

  (get-new-mentions! [self]
    (map-success (chan/get-new-posts! self)
                 (partial filter (mentions-user? me))))

  (peek-new-mentions! [self]
    (map-success (chan/peek-new-posts! self)
                 (partial filter (mentions-user? me))))

  (get-mentions-since! [self instant]
    (map-success (chan/get-posts-since! self instant)
                 (partial filter (mentions-user? me))))

  (post-channel! [self]
    (yield-to-channel (fn [] (chan/get-new-posts! self)) :poll-delay 5))

  (mention-channel! [self]
    (yield-to-channel (fn [] (chan/get-new-mentions! self)))))

(defrecord BebotClient [client me]
  client/IBebotClientApi
  (create-post! [_ post]
    (to-result (.createPost client (from-model post))))

  (get-channel! [_ chan-id]
    (to-result (.getChannel client chan-id nil)))

  (get-user! [_ user-id]
    (to-result (.getUser client user-id nil)))

  (get-user-by-username! [_ username]
    (to-result (.getUserByUsername client username nil)))

  (open-channel! [self chan-id]
    (let-result [chan         (client/get-channel! self chan-id)
                 read-instant (client/mark-read! self chan-id)]
      (success (->BebotChannel self chan (atom read-instant) me))))

  (open-direct-channel! [self user-id]
    (let-result [chan (to-result (.createDirectChannel client (id me) user-id))]
      (success (client/open-channel! self (id chan)))))

  (mark-read! [_ chan-id]
    (let [chan-view (ChannelView. chan-id)]
      (let-result [views (to-result (.viewChannel client (id me) chan-view))]
        (if-let [view-time (channel-last-view views chan-id)]
          (success view-time)
          (failure (str "unable to mark read, not found: " chan-id)
                   {:channel-views views})))))

  (get-post! [_ post-id]
    (to-result (.getPost client post-id nil)))

  (get-posts! [_ chan-id]
    (to-result (.getPostsForChannel client chan-id)))

  (get-posts-since! [_ chan-id instant]
    (to-result (.getPostsSince client chan-id (to-millis instant)))))

(defrecord BebotClientStub [client]
  client/IBebotClientStubApi
  (get-me! [_]
    (to-result (.getMe client nil)))
  (initialize! [self]
    (map-success (client/get-me! self) (fn [me] (->BebotClient client me)))))

(defn create-connection [url access-token]
  (->BebotClientStub (doto (MattermostClient. url)
                       (.setAccessToken access-token))))

(defn connect [url access-token]
  (client/initialize! (create-connection url access-token)))
