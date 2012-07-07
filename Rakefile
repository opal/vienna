require 'bundler'
Bundler.setup

require 'opal'

def build_to(file, &code)
  File.open("build/#{file}.js", 'w+') { |o| o.puts code.call }
end

desc "Build vienna, dependencies and specs"
task :build do
  FileUtils.mkdir_p 'build'

  build_to('opal') { Opal.runtime }
  build_to('opal-spec') { Opal.build_gem 'opal-spec' }
  build_to('opal-dom') { Opal.build_gem 'opal-dom' }
  build_to('vienna') { Opal.build_files 'lib' }
  build_to('specs') { Opal.build_files 'spec' }
end