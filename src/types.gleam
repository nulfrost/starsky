pub type PinnedPost {
  PinnedPost(uri: String, cid: String)
}

pub type Label {
  Label(src: String, uri: String, cid: String, val: String, cts: String)
}

pub type JoinedViaStartedPack {
  JoinedViaStartedPack(uri: String, cid: String, record: String)
}

pub type Chat {
  Chat(allow_incoming: String)
}

pub type Associated {
  Associated(lists: Int, feed_gens: Int, starter_packs: Int, labeler: Bool)
}

pub type Profile {
  Profile(
    did: String,
    handle: String,
    display_name: String,
    description: String,
    avatar: String,
    banner: String,
    followers_count: Int,
    follows_count: Int,
    posts_count: Int,
    associated: Associated,
    indexed_at: String,
    created_at: String,
    labels: List(Label),
    pinned_post: PinnedPost,
  )
}
