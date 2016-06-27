require 'yaml'
require 'erb'
require 'icalendar'

class Cal
  def self.generate
    cal = Icalendar::Calendar.new
    days = YAML.load_file('schedule.yml')
    start = Date.parse(days[0]['start-date'])
    counter = 0
    weeknum = 1
    days[1]['days'].each_with_index do |day, _index|
      is_saturday = (start + counter).wday == 6
      if is_saturday
        counter += 2
        weeknum += 1
      end
      today = Date.parse((start + counter).strftime('%A, %m/%d'))
      day['day'].each do |events|
        events.each do |time, details|
          title = details['title']
          lead = details['lead']
          support = details['support']
          urls = details['url']
          if lead.length > 0 && support.length > 0
            summary = "#{title} (#{lead}/#{support})"
          elsif lead.length > 0 
            summary = "#{title} (#{lead})"
          else
            summary = title
          end
          times = time.split(" - ")
          tstart = Time.parse(times[0])
          tendd  = Time.parse(times[1])
          cal.event do |e|
            e.dtstart     = DateTime.civil(today.year, today.month, today.day, tstart.hour, tstart.min, tstart.sec)
            e.dtend       = DateTime.civil(today.year, today.month, today.day, tendd.hour, tendd.min, tendd.sec)
            e.summary     = summary
            e.description = urls
          end
        end
      end
      counter += 1
    end
    cal_file = File.open("calendar.ics", "w")
    cal_file.puts cal.to_ical
    cal_file.close
  end
end

Cal.generate
