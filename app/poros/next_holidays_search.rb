require './app/services/next_holidays_service.rb'
require_relative 'holiday'

class NextHolidaysSearch
  def self.holiday_information
    service.next_holidays.map do |data|
      Holiday.new(data)
    end
  end

  def self.service
    NextHolidaysService.new
  end
end