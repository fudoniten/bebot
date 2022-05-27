(ns bebot.api.client)

(defprotocol IBebotClientStubApi
  (initialize! [self])
  (get-me!     [self]))

(defprotocol IBebotClientApi
  (create-post!          [self post])
  (open-channel!         [self chan-id])
  (open-direct-channel!  [self user-id])
  (mark-read!            [self chan-id])
  (get-post!             [self post-id])
  (get-posts!            [self chan-id])
  (get-posts-since!      [self chan-id time])
  (get-channel!          [self chan-id])
  (get-user!             [self user-id])
  (get-user-by-username! [self username]))
