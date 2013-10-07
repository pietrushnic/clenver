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

Then(/^the following remote (?:uris|branches) should be connected in "(.*?)":$/) do |arg1, table|
  table.raw.map{|repo| repo[0]}.each do |r|
    curr_pwd = Dir::pwd
    Dir::chdir("tmp/aruba" + "/" + arg1)
    res = %x[git remote -v| grep #{r}|wc -l].strip
    Dir::chdir(curr_pwd)
    res.to_i.should eq(2)
  end
end
