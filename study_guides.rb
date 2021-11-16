require "sinatra"
require "sinatra/reloader" if development?
require "tilt/erubis"

# TODO: Assign content path according to environment
def content_path
  File.expand_path("../content", __FILE__)
end

# Display all courses
get "/" do
  @courses = []
  Dir.children(content_path).each do |course|
    @courses << { name: course, 
      topics:  Dir.children(File.expand_path"../content/#{course}", __FILE__) }
  end

  erb :index
end