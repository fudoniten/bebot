(ns bebot.logger
  (:require [bebot.api.client :as client]
            [bebot.api.channel :as chan]
            [bebot.client :refer [connect]]
            [fudo-clojure.result :refer [let-result unwrap success]]
            [fudo-clojure.logging :as log]))

(defn make-logger [url access-token channel-id &
                   {:keys [error-level logic-level]
                    :or   {error-level :error
                           logic-level :notify}}]
  (unwrap
   (let-result [conn (connect url access-token)
                chan (client/open-channel! conn channel-id)]
     (success (log/log-to-function (partial chan/send-post! chan)
                                   error-level logic-level)))))
