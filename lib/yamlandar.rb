require 'sinatra'
require 'yaml'
require 'erb'

class Yamlandar < Sinatra::Base
  def self.urls string_or_hash
    html = ''
    html
  end
  def self.generate
    weeknum = 1
    @html = ""
    days = YAML.load_file('schedule.yml')
    counter = 0
    start = Date.parse(days[0]["start-date"])
    @html += "<div><h2 class='sticky '>Week #{weeknum}</h2></div>"
    days[1]["days"].each_with_index do |day, index|
      is_saturday = (start + counter).wday == 6
      if is_saturday
	counter += 2
	weeknum += 1
	@html += "<div><h2 class='sticky'>Week #{weeknum}</h2></div>"
      end
      @html += "<div class='day'>"
      today = (start + counter).strftime("%A, %m/%d")
      yyyymmdd = Date.parse(today).strftime("%F")
      @html += "<h2 id='#{yyyymmdd}'><a href='##{yyyymmdd}'>#{today}</a></h2>"
      day["day"].each do |events|
        events.each do |time, details|
          title = details["title"]
	  if details["url"].class == String
	    urls = details["url"].split(",")
	  elsif details["url"].class == Array
	    urls = details["url"]
	  end
          lead = details["lead"]
          support = details["support"]
          @html += "<div class='event'>"
          @html += "<h3>"
          if urls && urls[0].class == String && urls[0] != ""
	    @html += "<a href='#{urls[0]}'>#{title}</a>"
          else
            @html += "#{title}"
          end
          @html += "</h3><small>#{time}</small>"
          if urls && urls.length > 1
            @html += "<ul>"
            urls.each do |url|
	      if url.class == Hash
                url.each_pair do |title, href|
		  @html += "<li><a href='#{href}'>#{title}</a></li>"
		end
	      else
		@html += "<li><a href='#{url}'>#{url}</a></li>"
	      end
    	end
            @html += "</ul>"
          end
          if lead != "" || support != ""
	    @html += "<ul>"
	      @html += "<li>#{lead}</li>" unless lead == ""
	      @html += "<li>#{support}</li>" unless support == ""
	    @html += "</ul>"
          end
          @html += "</div>"
        end
      end
      @html += "</div><hr>"
      counter += 1
    end
   erb = ERB.new(File.open("#{__dir__}/views/index.erb").read)
   erb.result binding
  end
  get '/' do
   @html = Yamlandar.generate
  end
end

