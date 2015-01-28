require 'virus_scan_service'
require 'logger'
require 'yaml'
require 'pathname'

all_secrets = YAML.load(File.read('secrets.yml'))

secrets = all_secrets.fetch(:staging)

logger = Logger.new('virus_scan_service.log')
logger.level = Logger::DEBUG

courier = VirusScanService::Courier.new host: secrets.fetch(:host), token: secrets.fetch(:token)
courier.logger = logger
courier.call do |file_url|
  kaspersky = VirusScanService::KasperskyRunner.new(file_url)
  kaspersky.scan_folder = Pathname.new('.').join('scan_queue')
  kaspersky.scan_log_path = Pathname.new('.').join('kaspersky.log')
  kaspersky.call
  kaspersky.result
end
