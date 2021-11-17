require "sinatra"
require "sinatra/reloader" if development?
require "tilt/erubis"
require "redcarpet"

configure do
  # TODO: figure out how to make this secure by storing in an ENV variable
  enable :sessions
  set :session_secret, 'extra secret'
end

# TODO: Assign content path according to environment
def content_path
  File.expand_path("../content", __FILE__)
end

def error_for_course(path)
  unless File.exist?(path) && File.directory?(path)
    "#{File.basename(path)} does not exist." 
  end
end

def error_for_topic(path)
  unless File.exist?(path) && File.extname(path) == ".md"
    "#{File.basename(path)} does not exist."
  end
end

def render_markdown_as_html(text)
  markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                                      no_intra_emphasis: true,
                                      tables: true,
                                      fenced_code_blocks: true,
                                      autolink: true,
                                      lax_spacing: true)
  markdown.render(text)
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

# Display a single course
get "/:course" do
  course_path = File.join(content_path, params[:course])
  error = error_for_course(course_path)

  if error
    session[:error] = error
    redirect "/"
  else
    @topics = Dir.children(course_path).select do |file|
                File.extname(file) == ".md"
              end
    erb :course
  end
end

# Render the markdown of a topic document
get "/:course/:topic" do
  path = File.join(content_path, params[:course])
  error = error_for_course(path)
  path = File.join(path, params[:topic])
  error ||= error_for_topic(path)

  if error
    session[:error] = error
    redirect "/"
  else
    erb render_markdown_as_html(IO.read(path))
  end
end