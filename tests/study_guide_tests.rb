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
    assert_includes last_response.body, '<form action="/search"'
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

  def test_render_single_topic
    get "/rb109/truthiness.md"
    assert_equal 200, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
    assert_includes last_response.body, '<h1>Truthiness</h1>'
    assert_includes last_response.body, "<h2>Truthiness and Falsiness</h2>"
    assert_includes last_response.body, "<p><code>nil</code> in Ruby is a "
  end

  def test_error_for_nonexistent_topic
    get "/rb109/wrong.md"
    assert_equal 302, last_response.status
    assert_equal "wrong.md does not exist.", session[:error]
  end

  def test_error_for_bad_file_extension
    get "/content/study_guides.rb"
    assert_equal 302, last_response.status
    assert_equal "content does not exist.", session[:error]

    get "/rb109/not_here.rb"
    assert_equal 302, last_response.status
    assert_equal "not_here.rb does not exist.", session[:error]
  end

  def test_search_with_results
    get "/search", query: "containers for information"
    assert_equal 200, last_response.status
    assert_includes last_response.body, "<p><strong>Variables</strong> are basically storage containers for information"
    assert_includes last_response.body, 'rb109'
  end
end