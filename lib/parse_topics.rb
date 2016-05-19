require 'httparty'

class ParseTopics

  # returns the topic id (tid) of the newest topic
  def self.newest_topic
    topics = recent_topics()

    newest = -1

    topics.each do |topic|
      if topic["tid"] > newest
        newest = topic["tid"]
      end
    end
    newest
  end

  # returns the topics from api/recent in a hash
  def self.recent_topics
    url = 'http://forum.qt.io/api/recent'

    response = HTTParty.get(url)
    topics = response.parsed_response["topics"]
  end

  # returns n amount of newest topics in a list
  def self.newest_topics(n)
    url_base = "http://forum.qt.io/api"
    first = newest_topic
    topics = []
    strings = 0
    i = 0
    while i < n
      url = url_base + "/topic/" + (first - i).to_s

      if (HTTParty.get(url).parsed_response.class != String)
        first -= 1
        next
      end
      real_url = url_base + HTTParty.get(url).parsed_response

      topic = HTTParty.get(real_url).parsed_response
      topics << topic
      i += 1
    end
    topics
  end

  # Adds n amount of newest topics to the database
  def self.add_newest_topics(n)
    topics = newest_topics(n)
    topics.each do |topic|
      Topic.create(tid:topic["tid"], slug:topic["slug"], raw_json:ActiveSupport::JSON.encode(topic))
    end
  end

  # Adds the topics from api/recent to the database.
  # Maybe don't use.
  def self.add_topics_from_recent
    topics = recent_topics

    topics.each do |topic|
      Topic.create(tid:topic["tid"], slug:topic["slug"], raw_json:ActiveSupport::JSON.encode(topic))
    end

  end
end
