require 'sinatra/base'
require 'yaml'

class Yamlandar < Sinatra::Base
  def self.generate
    @html = ""
    days = YAML.load_file('schedule.yml')
    counter = 0
    start = Date.parse(days[0]["start-date"])
    days[1]["days"].each_with_index do |day, index|
      @html += "<div class='day container'>"
      is_saturday = (start + counter).wday == 6
      counter += 2 if is_saturday
      today = (start + counter).strftime("%A, %m/%d")
      yyyymmdd = Date.parse(today).strftime("%F")
      @html += "<h2 id='#{yyyymmdd}'><a href='##{yyyymmdd}'>#{today}</a></h2>"
      day["day"].each do |events|
        events.each do |time, details|
          title = details["title"]
          urls = details["url"].split(",")
          lead = details["lead"]
          support = details["support"]
          @html += "<div class='event'>"
          @html += "<h3>"
          if urls[0] != ""
    	@html += "<a href='#{urls[0]}'>#{title}</a>"
          else
            @html += "#{title}"
          end
          @html += "</h3><small>#{time}</small>"
          if urls.length > 1
            @html += "<ul>"
            urls.each do |url|
    	  @html += "<li><a href='#{url}'>#{url}</a></li>"
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
    @html
  end
  get '/' do
   @html = Yamlandar.generate
   erb :index
  end
end

Yamlandar.run!
