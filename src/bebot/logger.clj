(ns bebot.logger
  (:require [bebot.api.client :as client]
            [bebot.api.channel :as chan]
            [bebot.client :refer [connect]]
            [fudo-clojure.result :refer [let-result unwrap success]]
            [fudo-clojure.logging :as log]))

(defrecord MatterLogger [channel verbosity]
  log/Logger
  (debug! [_ msg] (when (= :info @verbosity
                           (chan/send-post! channel (str "DEBUG: " msg)))))
  (warn!  [_ msg] (throw (ex-info "Not Implemented!" {})))
  (error! [_ msg] (throw (ex-info "Not Implemented!" {})))
  (fatal! [_ msg] (throw (ex-info "Not Implemented!" {})))

  (info!   [_ msg] (when (= :info @verbosity)
                     (chan/send-post! channel msg)))
  (notify! [_ msg] (when (or (= :notify @verbosity)
                             (= :info   @verbosity))
                     (chan/send-post! channel msg)))
  (alert!  [_ msg] (chan/send-post! channel msg)))

(defn make-logger [url access-token channel-id & {:keys [verbosity]
                                                  :or   {verbosity :info}}]
  (unwrap
   (let-result [conn (connect url access-token)
                chan (client/open-channel! conn channel-id)]
     (success (->MatterLogger chan (atom verbosity))))))
