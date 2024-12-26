import client/request
import gleam/bool
import gleam/dynamic/decode
import gleam/http/response.{type Response}
import gleam/json
import gleam/option.{None}
import gleam/result
import types.{Associated, Chat, Label, PinnedPost, Profile}

pub type Error {
  UnexpectedResponse(status: Int, body: String)
  UnexpectedPayload(json.DecodeError)
}

pub fn get_profile(handle_or_did: String) {
  request.get("app.bsky.actor.getProfile", [#("actor", handle_or_did)])
}

pub fn handle_profile_response(
  response: Response(String),
) -> Result(types.Profile, Error) {
  use <- bool.guard(
    when: response.status != 200,
    return: Error(UnexpectedResponse(response.status, response.body)),
  )

  response.body
  |> json.parse(decode_profile_result())
  |> result.map_error(UnexpectedPayload)
}

pub fn decode_profile_result() {
  use did <- decode.field("did", decode.string)
  use handle <- decode.field("handle", decode.string)
  use display_name <- decode.optional_field("displayName", "n/a", decode.string)

  use description <- decode.optional_field("description", "n/a", decode.string)
  use avatar <- decode.optional_field("avatar", "n/a", decode.string)
  use banner <- decode.optional_field("banner", "n/a", decode.string)
  use followers_count <- decode.optional_field("followersCount", 0, decode.int)
  use follows_count <- decode.optional_field("followsCount", 0, decode.int)
  use posts_count <- decode.optional_field("postsCount", 0, decode.int)
  use indexed_at <- decode.optional_field("indexedAt", "n/a", decode.string)
  use created_at <- decode.optional_field("createdAt", "n/a", decode.string)

  use pinned_post <- decode.field("pinnedPost", {
    use cid <- decode.field("cid", decode.string)
    use uri <- decode.field("uri", decode.string)
    decode.success(PinnedPost(cid:, uri:))
  })

  use labels <- decode.field(
    "labels",
    decode.list({
      // use ver <- decode.field("ver", decode.int)
      use src <- decode.field("src", decode.string)
      use uri <- decode.field("uri", decode.string)
      use cid <- decode.field("cid", decode.string)
      use val <- decode.field("val", decode.string)
      // use neg <- decode.optional_field("neg",None, decode.bool)
      use cts <- decode.field("cts", decode.string)
      // use exp <- decode.field("exp", decode.string)
      // use sig <- decode.field("sig", decode.int)

      decode.success(Label(src:, uri:, cid:, val:, cts:))
    }),
  )

  // use chat <- decode.field("chat", {
  //   use allow_incoming <- decode.field("allowIncoming", decode.string)
  //   decode.success(Chat(allow_incoming:))
  // })

  use associated <- decode.field("associated", {
    use lists <- decode.field("lists", decode.int)
    use feed_gens <- decode.field("feedgens", decode.int)
    use starter_packs <- decode.field("starterPacks", decode.int)
    use labeler <- decode.field("labeler", decode.bool)

    decode.success(Associated(
      lists:,
      feed_gens:,
      starter_packs:,
      labeler:,
      // chat:,
    ))
  })

  decode.success(Profile(
    did:,
    handle:,
    display_name:,
    description:,
    avatar:,
    banner:,
    followers_count:,
    follows_count:,
    posts_count:,
    associated:,
    indexed_at:,
    created_at:,
    labels:,
    pinned_post:,
  ))
}
