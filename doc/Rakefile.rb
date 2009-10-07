require 'pathname'

cwd = Pathname.new(Dir.pwd)
#$: << cwd.parent
require 'redcloth'
require 'hpricot'
require 'rake/clean'

INSTALL_TEXTILE = 'installation_instructions.textile'
INSTALL_HTML = INSTALL_TEXTILE.ext('html')
INSTALL = cwd.parent.join('INSTALL')

CLEAN.include(INSTALL_HTML)
CLOBBER.include(INSTALL)

def generate_html
  source = File.new(INSTALL_TEXTILE).read
  RedCloth.new(source).to_html
end

task :doc => [INSTALL, INSTALL_HTML]
task :default => :doc

file INSTALL_HTML => INSTALL_TEXTILE do
  puts "Generating #{INSTALL_HTML} from #{INSTALL_TEXTILE}..."
  output = File.new(INSTALL_HTML, 'w')
  output.print(generate_html)
  output.close
  puts "Done!"
end

file INSTALL => INSTALL_HTML do
  puts "Generating #{INSTALL} from #{INSTALL_TEXTILE}..."
  output = File.new(INSTALL, 'w')
  text = `python html2text.py #{INSTALL_HTML}`
  output.print(text.gsub(/\n\[!(\[?\d?\]?)+\s*/, ''))
  output.close
  puts "Done!"
end


