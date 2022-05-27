(ns bebot.api.channel)

(defprotocol IBebotChannelApi
  (send-post!           [self message])
  (mark-read!           [self])

  (last-read            [self])

  (get-new-posts!       [self])
  (peek-new-posts!      [self])
  (get-posts-since!     [self instant])

  (get-new-mentions!    [self])
  (peek-new-mentions!   [self])
  (get-mentions-since!  [self instant])

  (post-channel!        [self])
  (mention-channel!     [self]))
