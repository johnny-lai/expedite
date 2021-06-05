require 'test_helper.rb'
require 'expedite/server'

class ServerTest < Minitest::Test
  def setup
    @srv = Expedite::Server.new
  end

  def test_server_starts_and_stops
    #assert_equal @srv.running?, false

    child_pid = fork do
      @srv.boot
      exit 0
    end

    sleep 1
    assert_equal @srv.running?, true
    assert_equal @srv.pid, child_pid

    status = @srv.stop
    assert_equal status, :stopped
    assert_equal @srv.running?, false
  end
end
