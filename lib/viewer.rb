require 'sinatra/base'
require 'yaml'

class Viewer < Sinatra::Base
  get '/' do
    html = "<!doctype html>
<html>
  <head>
    <title>Schedule</title>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <link rel='stylesheet' type='text/css' href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css'>
    <style>
      h2 a{
        color:inherit;
      }
      h1 img{
        max-width:50px;
	margin-right:.5em;
      }
    </style>
    <script>
      function formatDate(date) {
	var d = new Date(date),
	month = '' + (d.getMonth() + 1),
	day = '' + d.getDate(),
	year = d.getFullYear();

	if (month.length < 2) month = '0' + month;
	if (day.length < 2) day = '0' + day;

	return [year, month, day].join('-');
      }

      window.onload = function(){
	var jump = document.querySelector('.js-jump')
	jump.addEventListener('click', function(event){
	  event.preventDefault()
	  var d = formatDate(new Date())
	  var target = document.getElementById(d);
	  window.scrollTo(target.offsetLeft,target.offsetTop);
	  window.location.hash = formatDate(new Date())
	})
      }
    </script>
  </head>
  <body>
  <div class='page-header'>
    <h1 class='container'><img src='https://avatars2.githubusercontent.com/u/11040407?v=3&s=200'>Schedule</h1>
  </div>
  <div class='container'>
    <a href='#' class='js-jump'>Jump to Today</a>
  </div>"
    days = YAML.load_file('schedule.yml')
    counter = 0
    start = Date.parse(days[0]["start-date"])
    days[1]["days"].each_with_index do |day, index|
      html += "<div class='day container'>"
      is_saturday = (start + counter).wday == 6
      counter += 2 if is_saturday
      today = (start + counter).strftime("%A, %m/%d")
      yyyymmdd = Date.parse(today).strftime("%F")
      html += "<h2 id='#{yyyymmdd}'><a href='##{yyyymmdd}'>#{today}</a></h2>"
      day["day"].each do |events|
        events.each do |time, details|
          title = details["title"]
          urls = details["url"].split(",")
          lead = details["lead"]
          support = details["support"]
          html += "<div class='event'>"
          html += "<h3>"
          if urls[0] != ""
    	html += "<a href='#{urls[0]}'>#{title}</a>"
          else
            html += "#{title}"
          end
          html += "</h3><small>#{time}</small>"
          if urls.length > 1
            html += "<ul>"
            urls.each do |url|
    	  html += "<li><a href='#{url}'>#{url}</a></li>"
    	end
            html += "</ul>"
          end
          if lead != "" && support != ""
    	html += "<ul>
    	  <li>#{lead}</li>
    	  <li>#{support}</li>
    	</ul>
    	"
          end
          html += "</div>"
        end
      end
      html += "</div><hr>"
      counter += 1
    end
   html
  end
end

Viewer.run!
