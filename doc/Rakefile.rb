require 'redcloth'
require 'rake/clean'

INSTALL_TEXTILE = 'installation_instructions.textile'
INSTALL_HTML = INSTALL_TEXTILE.ext('html')

CLEAN.include(INSTALL_HTML)

task :doc => INSTALL_HTML
task :default => :doc

file INSTALL_HTML => INSTALL_TEXTILE do
  source = File.new(INSTALL_TEXTILE).read
  output = File.new(INSTALL_HTML, 'w')
  puts "Generating #{INSTALL_HTML} from #{INSTALL_TEXTILE}..."
  output.print(RedCloth.new(source).to_html)
  puts "Done!"
end



