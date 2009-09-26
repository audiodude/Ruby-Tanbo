# Author: Travis Briggs, briggs.travis (at) gmail.com
# ===================================================
# Copyright (C) 2009 Travis Briggs
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program. See the COPYING file. If not, see
# <http://www.gnu.org/licenses/>.

require 'rbconfig'
require 'rake/clean'
require 'pathname'

INTERFACE_NAME = 'ruby_uct'

CLEAN.include('*.o')
CLEAN.include("#{INTERFACE_NAME}_wrap.cxx")
CLEAN.include('Makefile')
CLOBBER.include("#{INTERFACE_NAME}.bundle")
CLOBBER.include("run_tests")

SRC = FileList['*.cpp'] + FileList['*.h']
TEST_SRC = FileList['test/test_*.cpp', 'test/*_fixture.cpp']
COMPILED_TESTS = TEST_SRC.ext('o')
COMPILED_SRC = FileList['*.o']

task :compile => 'Makefile' do
  sh "make"
end

file "testrunner" => [:test_compile] + COMPILED_TESTS do
  sh "g++ -L/opt/local/lib/ -I#{Config::CONFIG['archdir']} -I/opt/local/include/ -I. -o testrunner #{COMPILED_SRC} #{COMPILED_TESTS} -lruby -lcppunit"
end

task :test => "testrunner" do
  sh "./testrunner"
end

task :test_compile => :compile do
  COMPILED_SRC.each do |obj|
    file obj do
      sh "g++ -c -I/opt/local/include/ -o #{obj} #{obj.ext('cpp')}"
    end
  end
end

task :default => ["#{INTERFACE_NAME}_wrap.bundle"]

file 'uct.o' do
  sh "g++ -c -o uct.o uct.cpp"
end

file "#{INTERFACE_NAME}_wrap.cxx" => ["#{INTERFACE_NAME}.cpp", "#{INTERFACE_NAME}.h", "#{INTERFACE_NAME}.i"] do
  sh "swig -c++ -ruby #{INTERFACE_NAME}.i"
end

file "Makefile" do
  sh "ruby extconfig.rb"
end

file "#{INTERFACE_NAME}_wrap.bundle" => ["#{INTERFACE_NAME}_wrap.cxx", 'uct.o'] + SRC + [:compile]

