require 'httparty'

class GithubService

  def usernames
    get_url("https://api.github.com/repos/torienyart/little-esty-shop/collaborators", headers: {"Authorization" => "Bearer #{ENV["github_token"]}"})
  end

  def commits(username)
    get_url("https://api.github.com/repos/torienyart/little-esty-shop/commits?author=#{username}&per_page=100", headers: {"Authorization" => "Bearer #{ENV["github_token"]}"})
  end


  def pulls
    get_url("https://api.github.com/repos/torienyart/little-esty-shop/pulls?state=closed&per_page=100", headers: {"Authorization" => "Bearer #{ENV["github_token"]}"})
  end

  def repo
    get_url("https://api.github.com/repos/torienyart/little-esty-shop", headers: {"Authorization" => "Bearer #{ENV["github_token"]}"})
  end

  def collaborators
    get_url("https://api.github.com/repos/torienyart/little-esty-shop/collaborators", headers: {"Authorization" => "Bearer #{ENV["github_token"]}"})
  end

  def get_url(url, token) #Make a Get request
    response = HTTParty.get(url, token)
    parsed = JSON.parse(response.body, symbolize_names: true)
  end
end

