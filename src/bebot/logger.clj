(ns bebot.logger
  (:require [bebot.api.client :as client]
            [bebot.api.channel :as chan]
            [bebot.client :refer [connect]]
            [fudo-clojure.result :refer [let-result unwrap success]]
            [fudo-clojure.logging :as log :refer [level-to-int]]))

(defn make-logger [url access-token channel-id &
                   {:keys [error-level logic-level]
                    :or   {error-level :error
                           logic-level :notify}}]
  (unwrap
   (let-result [conn (connect url access-token)
                chan (client/open-channel! conn channel-id)]
     (success (log/log-to-function (partial chan/send-post! chan)
                                   error-level logic-level)))))

(defn make-logger [url access-token channel-id user &
                   {:keys [error-level
                           logic-level
                           error-mention-level
                           logic-mention-level]
                    :or   {error-level :error
                           logic-level :notify
                           error-mention-level :error
                           logic-mention-level :notify}}]
  (let [emit (unwrap
              (let-result [conn    (connect url access-token)
                           channel (client/open-channel! conn channel-id)]
                (success (fn [mention msg]
                           (if mention
                             (chan/send-post! channel (format "@%s %s" user msg))
                             (chan/send-post! channel msg))))))
        above-level?   (fn [lvl] (fn [tst] (>= (level-to-int tst) (level-to-int lvl))))
        emit-error?    (above-level? error-level)
        emit-logic?    (above-level? logic-level)
        mention-error? (above-level? error-mention-level)
        mention-logic? (above-level? logic-mention-level)
        error-stage    (fn [lvl msg]
                         (when (emit-error? lvl)
                           (emit (mention-error? lvl) msg)))
        logic-stage    (fn [lvl msg]
                         (when (emit-logic? lvl)
                           (emit (mention-logic? lvl) msg)))]
    (reify log/Logger
      (debug! [_ msg] (error-stage :debug msg))
      (warn!  [_ msg] (error-stage :warn  msg))
      (error! [_ msg] (error-stage :error msg))
      (fatal! [_ msg] (error-stage :fatal msg))

      (info!   [_ msg] (logic-stage :info   msg))
      (notify! [_ msg] (logic-stage :notify msg))
      (alert!  [_ msg] (logic-stage :alert  msg)))))
