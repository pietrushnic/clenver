require 'rspec/expectations'
require 'clenver/link'

When /^I get help for "([^"]*)"$/ do |app_name|
  @app_name = app_name
  step %(I run `#{app_name} help`)
end

# Add more step definitions here

Then(/^the following links should exist:$/) do |files|
  files.raw.map{|file_row| file_row[0]}.each do |f|
    puts f
    if /\$\w+/.match(f)
      f_path = Link.new(f,"").expand_dst(Array.new().push(f))[0]
    elsif
      f_path = "tmp/aruba/" + f
    end
    puts f_path
    File.should be_symlink(f_path)
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
