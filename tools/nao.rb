require 'open-uri'
require 'icalendar'

url = 'https://calendar.google.com/calendar/ical/2bk907eqjut8imoorgq1qa4olc%40group.calendar.google.com/public/basic.ics'

strict_parser = Icalendar::Parser.new(open(url), true)
cals = strict_parser.parse

res = []
cals.first.events.each do |e|
  res << [e.dtstart, e.summary]
end

res.sort!{|a,b| a[0] <=> b[0]}
res.each do |row|
  puts row.join(',')
end
