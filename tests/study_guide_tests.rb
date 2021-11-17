ENV["RACK_ENV"] = "test"

require "minitest/autorun"
require "rack/test"
require "fileutils"
require_relative "../study_guides"

class StudyGuidesTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def session
    last_request.env["rack.session"]
  end

  def test_index
    get "/"
    assert_equal 200, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
    assert_includes last_response.body, "rb109"
    assert_includes last_response.body, "ls171"
  end

  def test_single_course
    get "/rb139"
    assert_equal 200, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
    assert_includes last_response.body, "core_ruby_tools.md"
    assert_includes last_response.body, "rvm.md"
    refute_includes last_response.body, "closures.jpg"
  end

  def test_error_for_nonexistent_course
    get "/not_a_course"
    assert_equal 302, last_response.status
    assert_equal "not_a_course does not exist.", session[:error]
  end
end