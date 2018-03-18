#Run this file
require_relative './lib/search_service'

while(1) do
  puts "Input `|` separated user lattitude, user longitude, destination. Press E to exit"
  input = gets.chomp
  if input == "E"
    exit
  else
    input = input.split('|')
    if input.length != 3
      puts "Invalid input"
    else
      puts '==============================================================================='
      puts SearchService.new.search_location(input[0], input[1], input[2])
    end

  end
end
