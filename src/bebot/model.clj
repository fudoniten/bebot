(ns bebot.model
  (:require [clojure.string :as str])
  (:import (net.bis5.mattermost.model Channel
                                      ChannelViewResponse
                                      Post
                                      PostList
                                      User)))

(defn- to-instant [millis]
  (java.time.Instant/ofEpochMilli millis))

(defn- comma-split [str]
  (filter (comp not empty?)
          (str/split str #",")))

(defprotocol IBebotObject
  (id [self])
  (created-at [self])
  (updated-at [self])
  (deleted-at [self]))

(defprotocol IBebotUserOwnedObject
  (user-id [self]))

(defprotocol IBebotTeamOwnedObject
  (team-id [self]))

(defprotocol IBebotChannelObject
  (channel-id [self]))

(defprotocol IBebotChannel
  (channel-type [self])
  (channel-name [self])
  (display-name [self])
  (header [self])
  (purpose [self])
  (last-post-at [self])
  (message-count [self]))

(defprotocol IBebotPost
  (post-type [self])
  (pinned? [self])
  (parent-id [self])
  (message [self])
  (hashtags [self]))

(defprotocol IBebotUser
  (username [self])
  (email [self])
  (first-name [self])
  (last-name [self])
  (roles [self])
  (bot? [self]))

(defrecord BebotChannel [c]
  IBebotObject
  (id         [_] (.getId c))
  (created-at [_] (->     c (.getCreateAt) to-instant))
  (updated-at [_] (some-> c (.getUpdateAt) to-instant))
  (deleted-at [_] (some-> c (.getDeleteAt) to-instant))

  IBebotTeamOwnedObject
  (team-id    [_] (.getTeamId c))

  IBebotChannel
  (channel-type  [_] (.getType c))
  (channel-name  [_] (.getName c))
  (display-name  [_] (.getDisplayName c))
  (header        [_] (.getHeader c))
  (purpose       [_] (.getPurpose c))
  (last-post-at  [_] (-> c (.getLastPostat) to-instant))
  (message-count [_] (.getTotalMsgContut c)))

(defrecord BebotPost [p]
  IBebotObject
  (id         [_] (.getId p))
  (created-at [_] (->     p (.getCreateAt) to-instant))
  (updated-at [_] (some-> p (.getUpdateAt) to-instant))
  (deleted-at [_] (some-> p (.getDeleteAt) to-instant))

  IBebotUserOwnedObject
  (user-id [_] (.getUserId p))

  IBebotChannelObject
  (channel-id [_] (.getChannelId p))

  IBebotPost
  (post-type [_] (.getType p))
  (pinned?   [_] (.isPinned p))
  (parent-id [_] (.getParentId p))
  (message   [_] (.getMessage p))
  (hashtags  [_] (-> p (.getHashtags) comma-split)))

(defrecord BebotUser [u]
  IBebotUser
  (username   [_] (.getUsername u))
  (email      [_] (.getEmail u))
  (first-name [_] (.getFirstName u))
  (last-name  [_] (.getLastName u))
  (roles      [_] (-> u (.getRoles) comma-split))
  (bot?       [_] (.isBot u))

  IBebotObject
  (id         [_] (.getId u))
  (created-at [_] (->     u (.getCreateAt) to-instant))
  (updated-at [_] (some-> u (.getUpdateAt) to-instant))
  (deleted-at [_] (some-> u (.getDeleteAt) to-instant)))

(defprotocol IChannelViews
  (channel-last-view [self chan-id]))

(defrecord ChannelViews [o]
  IChannelViews
  (channel-last-view [_ chan-id]
    (some-> o (.getLastViewedAtTimes) (get chan-id) (to-instant))))

(defmulti to-model
  "Given a mattermost4j object, convert it to the appropriate internal representation."
  class)

(defmethod to-model User [o] (->BebotUser o))
(defmethod to-model Post [o] (->BebotPost o))
(defmethod to-model Channel [o] (->BebotChannel o))
(defmethod to-model PostList [o] (map ->BebotPost (vals (.getPosts o))))
(defmethod to-model ChannelViewResponse [o] (->ChannelViews o))
(defmethod to-model :default [o] (ex-info (str "unsupported class: " (class o))
                                          {:argument o}))

(defprotocol IOutgoingObject
  (from-model [self]))

(defrecord OutgoingPost [chan-id message]
  IOutgoingObject
  (from-model [_] (Post. chan-id message)))

(defn new-post [channel message]
  (->OutgoingPost (id channel) message))

(defn mentions-username? [username]
  (let [mention-rx (re-pattern (str "^@" username "( .+)?"))]
    (fn [post] (->> post message (re-matches mention-rx) nil? not))))

(defn mentions-user? [user]
  (mentions-username? (username user)))
