# A sample Guardfile
# More info at https://github.com/guard/guard#readme

# guard 'livereload' do
#   watch(%r{app/.+\.(erb|haml)})
#   watch(%r{app/helpers/.+\.rb})
#   watch(%r{public/.+\.(css|js|html)})
#   watch(%r{config/locales/.+\.yml})
# end

if RUBY_PLATFORM =~ /darwin/
  require 'rb-fsevent'
  require 'growl'
elsif RUBY_PLATFORM =~ /linux/
  require 'rb-inotify'
  require 'libnotify'
else
  raise "uknown platform: #{RUBY_PLATFORM}"
end

# guard 'spork', :test_unit => false, :wait => 60, :cucumber_env => { 'RAILS_ENV' => 'test' }, :rspec_env => { 'RAILS_ENV' => 'test' } do
guard 'spork', :test_unit => false do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch(%r{^config/environments/.*\.rb$})
  watch(%r{^config/initializers/.*\.rb$})
  watch('spec/spec_helper.rb')
end

guard 'rspec', :version => 2, :all_on_start => false, :all_after_pass => false, :cli => '--drb' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb') { "spec" }

  watch(%r{^app/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$}) { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
  watch(%r{^spec/support/(.+)\.rb$}) { "spec" }
  watch('spec/spec_helper.rb') { "spec" }
  watch('config/routes.rb') { "spec/routing" }
  watch('app/controllers/application_controller.rb') { "spec/controllers" }
  # Capybara request specs
  watch(%r{^app/views/(.+)/.*\.(erb|haml)$}) { |m| "spec/requests/#{m[1]}_spec.rb" }
end

# guard 'cucumber', :cli => "--drb --color --profile guard", :all_on_start => true, :all_after_pass => false do
#   watch(%r{^features/.+\.feature$})
#   watch(%r{^features/support/.+$})          { 'features' }
#   # watch(%r{^features/step_definitions/(.+)_steps\.rb$}) { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'features' }
# end
