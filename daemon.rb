require 'logger'
errors_count = 0
counter = 0

logger = Logger.new('daemon.log')
logger.level = Logger::ERROR
logger.level = Logger::INFO  if File.exist?('info')
logger.level = Logger::DEBUG if File.exist?('debug')

loop do
  counter += 1

  begin
    if counter % 50 == 0
      logger.info "running git pull"
      if system('git pull origin master')
        logger.info("git pull complete")
      else
        logger.error("git pull NOT-SUCCESSFUL")
      end

      logger.info "running bundle update"
      if system('bundle update')
        logger.info("update complete")
      else
        logger.error("update NOT-SUCCESSFUL")
      end

      counter = 0
    end

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
