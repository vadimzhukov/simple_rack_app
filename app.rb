require_relative 'time_formatter'
class App
  PROTOCOL = 'HTTP/1.1'
  PATH = '/time'
  METHOD = 'GET'

  def call(env)
    return response(404, headers, 'Bad request') if bad_request?(env)

    formatted_time = TimeFormatter.new(env)
    formatted_time.call
    if formatted_time.success?
      response(200, headers, formatted_time.current_time_string)
    else
      response(400, headers, formatted_time.invalid_string)
    end
  end

  private

  def response(status, headers, body)
    [status, headers, [body]]
  end

  def bad_request?(env)
    !(check_protocol(env) && check_path(env) && check_method(env))
  end

  def check_method(env)
    env['REQUEST_METHOD'] == METHOD
  end

  def check_path(env)
    env['PATH_INFO'] == PATH
  end

  def check_protocol(env)
    env['SERVER_PROTOCOL'] == PROTOCOL
  end

  def headers
    { 'Content-type' => 'text/plain' }
  end
end
