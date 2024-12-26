import bsky/actor.{type Error}
import gleam/httpc
import gleam/io
import gleam/string

pub fn main() {
  let request = actor.get_profile("dane.computer")

  let assert Ok(response) = httpc.send(request)

  let profile = actor.handle_profile_response(response)

  case profile {
    Ok(p) -> io.println(p.display_name)
    Error(e) -> io.println(string.inspect(e))
  }
}
