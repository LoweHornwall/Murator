class Coverartarchive
  ROOT = "http://coverartarchive.org/"

  def self.get_cover_art(rgid)
    self.get("release-group/#{rgid}/front-250")
  end

  private
    def self.get(url)
      result = HTTP.headers("User-Agent" => "Murator/0.0.1 ( lowehorn@gmail.com )")
        .get("#{ROOT}#{url}")
      if result.code == 503
        raise TooManyRequests
      elsif result.code == 307
        result.headers["Location"]
      end
    end

=begin
    def self.get(url)
      puts "#{ROOT}#{url}"
      result = HTTP.headers("User-Agent" => "Murator/0.0.1 ( lowehorn@gmail.com )")
        .follow.get("#{ROOT}#{url}")
      if result.code == 503
        raise TooManyRequests
      elsif result.code == 200
        JSON.parse(result)["images"][0]["thumbnails"]["small"]
      end
    end
=end
end

