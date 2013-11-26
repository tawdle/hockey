LOCALES_PATH  = "#{Rails.root}/config/locales/*.yml"
MASTER_LOCALE = "#{Rails.root}/config/locales/en.yml"

require 'active_support'

def deeply_sort_hash(object)
  return object unless object.is_a?(Hash)
  hash = RUBY_VERSION >= '1.9' ? Hash.new : ActiveSupport::OrderedHash.new
  object.each { |k, v| hash[k] = deeply_sort_hash(v) }
  sorted = hash.sort { |a, b| a[0].to_s <=> b[0].to_s }
  hash.class[sorted]
end

namespace :locales do
  task :merge do
    require 'yaml'
    master = YAML::load_file MASTER_LOCALE
    master_language_code = File.basename(MASTER_LOCALE, '.yml')
    Dir[LOCALES_PATH].each do |file_name|
      if file_name == MASTER_LOCALE
        puts "=> skipping master locale #{File.basename(MASTER_LOCALE)}"
        next
      end
      language_code = File.basename(file_name, '.yml')
      slave = YAML::load_file(file_name)
      unless slave[language_code]
        puts "-> ERROR on #{File.basename(file_name)}: can't find key '#{language_code}'!"
        next
      end
      merged = master[master_language_code].deep_merge(slave[language_code])
      final = { language_code => merged } # remove other keys
      File.open(file_name, 'w') do |file|
        file.write deeply_sort_hash(final).to_yaml.gsub(/\s+$/, '')
      end
      puts "+ merged #{File.basename(file_name)} with master"
    end
  end
end
