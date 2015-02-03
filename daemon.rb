require 'virus_scan_service'
require 'logger'
require 'yaml'
require 'pathname'

all_secrets = YAML.load(File.read('secrets.yml'))

loop do
  logger = Logger.new('virus_scan_service.log')
  logger.level = Logger::ERROR
  logger.level = Logger::INFO  if File.exist?('info')
  logger.level = Logger::DEBUG if File.exist?('debug')

  begin
    all_secrets.each do |secret_key, secrets|
      logger.info "Run for #{secret_key}"
      courier = VirusScanService::Courier.new host: secrets.fetch(:host), token: secrets.fetch(:token)
      courier.logger = logger
      courier.call do |file_url|
        kaspersky = VirusScanService::KasperskyRunner.new(file_url)
        kaspersky.scan_log_path = Pathname.new('.').join('kaspersky.log')

        kaspersky.scan_folder = Pathname
          .new('.')
          .join('scan_queue')
          .tap { |path| FileUtils.mkdir_p(path) }

        kaspersky.archive_folder = Pathname
          .new('.')
          .join('scan_logs_archive')
          .tap { |path| FileUtils.mkdir_p(path) }

        kaspersky.antivirus_exec = VirusScanService::KasperskyRunner::WindowsExecutor.new
        # kaspersky.antivirus_exec = VirusScanService::KasperskyRunner::LinuxExecutor.new

        kaspersky.call
        kaspersky.result # return result to PUT request (E.g: Clean)
      end
    end
    sleep 2 # sleep between servers
  rescue => e
    logger.info e.to_s
    sleep 60
  end
  sleep 8 # sleep on new secret cycle
end
