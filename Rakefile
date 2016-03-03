@root = File.expand_path(File.dirname(__FILE__))

def require_doppler
  app = File.join(@root, 'lib', 'doppler.rb')
  require app
end

task :run do |t|
  require_doppler
  Doppler.run!
end
