require 'json'
require_relative 'next_holidays_search'

holidays = NextHolidaysSearch.holiday_information

holidays.each do |holiday|
  puts "Holiday: #{holiday.name}"
  puts "Date: #{holiday.date}"
end