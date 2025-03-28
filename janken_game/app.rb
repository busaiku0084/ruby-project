require "rack"
require_relative "./game"

class JankenApp
  def call(env)
    req = Rack::Request.new(env)

    if req.path == "/"
      res = Rack::Response.new
      res.write File.read("views/index.html")
      res.finish
    elsif req.path == "/play" && req.post?
      player_choice = req.params["choice"]
      result = JankenGame.play(player_choice)

      html = File.read("views/index.html")
      html.gsub!("<!--RESULT-->", "<p>あなた: #{result[:player]} / コンピュータ: #{result[:computer]}</p><h2>#{result[:result]}</h2>")
      res = Rack::Response.new
      res.write html
      res.finish
    else
      [404, { "Content-Type" => "text/plain" }, ["Not Found"]]
    end
  end
end
