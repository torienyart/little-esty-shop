require 'httparty'

class NextHolidaysService

  def next_holidays
    get_url('https://date.nager.at/api/v3/NextPublicHolidays/US')
  end

  def get_url(url) #Make a Get request
    response = HTTParty.get(url)
    parsed = JSON.parse(response.body, symbolize_names: true)
  end
end

