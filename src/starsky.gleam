import bsky/actor
import gleam/httpc
import gleam/io

pub fn main() {
  let request = actor.get_profile_request("dane.computer")

  let assert Ok(response) = httpc.send(request)

  let assert Ok(profile) = actor.handle_profile_response(response)

  io.println(profile.did)
}
