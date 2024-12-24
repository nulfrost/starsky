import constants.{public_api_endpoint}
import gleam/http/request
import gleam/httpc

pub type QueryParams =
  List(#(String, String))

pub fn get(path: String, query: QueryParams) {
  request.new()
  |> request.set_host(public_api_endpoint)
  |> request.set_path("xrpc/" <> path)
  |> request.set_query(query)
  |> httpc.send
}
