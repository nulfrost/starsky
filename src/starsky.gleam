import gleam/dynamic/decode
import gleam/http/request
import gleam/httpc
import gleam/io
import gleam/json
import types.{Actor}

pub fn actor_from_json(json: String) {
  let actor_decoder = {
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
    decode.success(Actor(
      did:,
      handle:,
      display_name:,
      description:,
      avatar:,
      banner:,
      followers_count:,
      follows_count:,
      posts_count:,
      indexed_at:,
      created_at:,
    ))
  }
  json.parse(from: json, using: actor_decoder)
}

pub fn main() {
  let request =
    request.new()
    |> request.set_host("public.api.bsky.app")
    |> request.set_path("xrpc/app.bsky.actor.getProfile")
    |> request.set_query([#("actor", "dane.computer")])
    |> httpc.send

  case request {
    Error(_) -> io.println("There's been an error fetching the profile")
    Ok(response) -> {
      case actor_from_json(response.body) {
        Error(_) -> io.println("There was an error parsing the json")
        Ok(actor) -> io.println(actor.handle)
      }
    }
  }
}
