worker_processes 2

root = File.expand_path '../', File.dirname(__FILE__)

listen      "#{root}/tmp/sockets/unicorn.sock"
pid         "#{root}/tmp/pids/unicorn.pid"
stdout_path "#{root}/log/unicorn.log"
stderr_path "#{root}/log/unicorn_error.log"