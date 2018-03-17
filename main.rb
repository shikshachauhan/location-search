#Run this file
require_relative './lib/location_search'

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
      location_search = LocationSearch.new(input[0], input[1], input[2])
      location_search.load
      puts '==============================================================================='
      if location_search.autocomplete_list.empty?
        puts "No Results found"
      else
        puts location_search.autocomplete_list
      end
    end

  end
end
