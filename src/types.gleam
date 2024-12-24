pub type PinnedPost {
  PinnedPost(uri: String, cid: String)
}

pub type Label {
  Label(
    ver: Int,
    src: String,
    uri: String,
    cid: String,
    val: String,
    neg: Bool,
    cts: String,
    exp: String,
  )
}

pub type JoinedViaStartedPack {
  JoinedViaStartedPack(uri: String, cid: String, record: String)
}

pub type Chat {
  Chat(allow_incoming: String)
}

pub type Associated {
  Associated(lists: Int, feedgens: Int, starter_packs: Int, labeler: Bool)
}

pub type Actor {
  Actor(
    did: String,
    handle: String,
    display_name: String,
    description: String,
    avatar: String,
    banner: String,
    followers_count: Int,
    follows_count: Int,
    posts_count: Int,
    indexed_at: String,
    created_at: String,
  )
}
