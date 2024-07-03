Gem::Specification.new do |s|
  s.name        = "nxt_http_client"
  s.summary     = "NxtHttpClient"
  s.version     = "0.0.3"
  s.authors     = ["Aliaksandr Yakubenka"]
  s.email       = "alexandr.yakubenko@startdatelabs.com"
  s.files       = ["lib/nxt_http_client.rb"]
  s.license       = "MIT"
  s.add_dependency "typhoeus"
  s.add_dependency "faraday"
end
