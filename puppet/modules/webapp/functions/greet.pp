# Custom function written in the Puppet language
function webapp::greet(String $who) >> String {
  "Hello, ${who}"
}
