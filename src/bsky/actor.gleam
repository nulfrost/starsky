import client/request
import gleam/result

pub fn get_profile(handle_or_did: String) {
  use response <- result.try(
    request.get("app.bsky.actor.getProfile", [#("actor", handle_or_did)]),
  )

  Ok(response)
}
