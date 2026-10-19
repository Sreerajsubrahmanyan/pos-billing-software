# Minimal CORS support for the independently deployed Vite frontend.
class FrontendCors
  def initialize(app)
    @app = app
  end

  def call(env)
    origin = env["HTTP_ORIGIN"]
    allowed = ENV.fetch("FRONTEND_ORIGINS", "http://localhost:5173,http://127.0.0.1:5173")
                  .split(",").map(&:strip)
    if origin && allowed.include?(origin)
      headers = {
        "Access-Control-Allow-Origin" => origin,
        "Access-Control-Allow-Methods" => "GET, POST, PATCH, PUT, DELETE, OPTIONS",
        "Access-Control-Allow-Headers" => "Authorization, Content-Type",
        "Vary" => "Origin"
      }
      return [204, headers, []] if env["REQUEST_METHOD"] == "OPTIONS"

      status, response_headers, body = @app.call(env)
      return [status, response_headers.merge(headers), body]
    end

    @app.call(env)
  end
end
