require 'rspec/expectations'

When /^I get help for "([^"]*)"$/ do |app_name|
  @app_name = app_name
  step %(I run `#{app_name} help`)
end

# Add more step definitions here

Then(/^the following links should exist:$/) do |files|
  files.raw.map{|file_row| file_row[0]}.each do |f|
    File.should be_symlink("tmp/aruba/" + f)
  end
end


