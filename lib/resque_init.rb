redis_host = ENV.fetch('REDIS_HOST', 'localhost')
redis_port = ENV.fetch('REDIS_PORT', 6379)

Resque.redis  = "#{ redis_host }:#{ redis_port }"
