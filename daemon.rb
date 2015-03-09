require 'logger'
errors_count = 0

logger = Logger.new('daemon.log')
logger.level = Logger::ERROR
logger.level = Logger::INFO  if File.exist?('info')
logger.level = Logger::DEBUG if File.exist?('debug')

loop do
  begin
    if system('bundle exec ruby script.rb')
      logger.info("exec ruby script success")
    else
      logger.error("exec ruby script NOT-SUCCESSFUL")
    end

    errors_count = 0
  rescue => e
    errors_count += 1
    logger.error e
    sleep 5
    sleep 60 if errors_count > 10
    sleep 300 if errors_count > 50
  end
end
