Dir['./test/cases/*'].each do |file|
  system("ruby #{file}")
end
