require "rspec"
require "functions_framework/testing"

describe "app" do
  include FunctionsFramework::Testing

  it "returns hello" do
    load_temporary "app.rb" do
      request = make_post_request "/", "{}",
                                  ["Content-Type: application/json"]
      response = call_http "send_message", request
      expect(response.body).to eq ["Hello Hackathon Team from my local repository!!!"]
    end
  end
end