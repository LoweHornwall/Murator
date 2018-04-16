class Musicbrainz
  ROOT = "http://musicbrainz.org/ws/2/"
  PAGE_LENGTH = 25
  class TooManyRequests < StandardError
  end

  def self.list_release_groups(search_term, options = {})
    options.reverse_merge!(search_by: "artist", page: 1)
    search = self.search_release_group(search_term, options[:search_by], 
                                       (options[:page] - 1) * PAGE_LENGTH)
    releases = {}
    if search && !search.empty?
      if search["count"] < 25
        releases[:pages_count] = 1
      else
        releases[:pages_count] = search["count"] / PAGE_LENGTH 
        releases[:pages_count] += 1 if search["count"] % PAGE_LENGTH != 0
      end
      releases[:page] = search["offset"] / PAGE_LENGTH + 1
      releases[:releases] = []
      search["release-groups"].each do |group|
        releases[:releases].push(self.format_release_group(group))
      end
      releases
    end
  end

  def self.display_release_group(search_term)
    release_group = self.get_release_group(search_term)
    if release_group
      self.format_release_group(release_group)
    end
  end

  private
    def self.search_release_group(search_term, search_by, offset)
      self.get("release-group/?query=#{search_by}:#{CGI.escape(search_term)}&offset=#{offset}")
    end

    def self.get_release_group(search_term)
      self.get("release-group/#{search_term}?inc=artist-credits+tags")
    end

    def self.get(url) 
      result = HTTP.headers("User-Agent" => "Murator/0.0.1 ( lowehorn@gmail.com )")
        .get("#{ROOT}#{url}&fmt=json")
      if result.code == 503
        raise TooManyRequests 
      elsif result.code == 200
        JSON.parse(result)
      end
    end

    def self.format_release_group(group)
      formated_group = {
        rgid: group["id"],
        release: group["title"],
        artist: group["artist-credit"][0]["artist"]["name"],
        tags: (group["tags"] || []).reduce([]) do |tags, tag|
          if tag["name"] != "improper discogs link"
            tags << tag["name"]
          end
          tags
        end
      }
    end
end