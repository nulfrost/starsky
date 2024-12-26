import client/request
import gleam/bool
import gleam/dynamic/decode
import gleam/http/response.{type Response}
import gleam/json
import gleam/result
import types.{Associated, Label, PinnedPost, Profile}

pub type Error {
  UnexpectedResponse(status: Int, body: String)
  UnexpectedPayload(json.DecodeError)
}

pub fn get_profile_request(handle_or_did: String) {
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

pub fn decode_pinned_post_result() {
  use cid <- decode.field("cid", decode.string)
  use uri <- decode.field("uri", decode.string)
  decode.success(PinnedPost(cid:, uri:))
}

pub fn decode_labels_result() {
  use src <- decode.field("src", decode.string)
  use uri <- decode.field("uri", decode.string)
  use cid <- decode.field("cid", decode.string)
  use val <- decode.field("val", decode.string)
  use cts <- decode.field("cts", decode.string)

  decode.success(Label(src:, uri:, cid:, val:, cts:))
}

pub fn decode_associated_result() {
  use lists <- decode.field("lists", decode.int)
  use feed_gens <- decode.field("feedgens", decode.int)
  use starter_packs <- decode.field("starterPacks", decode.int)
  use labeler <- decode.field("labeler", decode.bool)

  decode.success(Associated(lists:, feed_gens:, starter_packs:, labeler:))
}

pub fn decode_profile_result() {
  use did <- decode.field("did", decode.string)
  use handle <- decode.field("handle", decode.string)
  use display_name <- decode.field("displayName", decode.string)
  use description <- decode.field("description", decode.string)
  use avatar <- decode.field("avatar", decode.string)
  use banner <- decode.field("banner", decode.string)
  use followers_count <- decode.field("followersCount", decode.int)
  use follows_count <- decode.field("followsCount", decode.int)
  use posts_count <- decode.field("postsCount", decode.int)
  use indexed_at <- decode.field("indexedAt", decode.string)
  use created_at <- decode.field("createdAt", decode.string)

  use pinned_post <- decode.field("pinnedPost", decode_pinned_post_result())
  use labels <- decode.field("labels", decode.list(decode_labels_result()))
  use associated <- decode.field("associated", decode_associated_result())

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
