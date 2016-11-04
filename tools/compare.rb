require 'pp'
require 'date'

files = ARGV

data = {}
files.each do |f|
  data[f] = {}
  open(f).read.chomp.split("\n").each do |d|
    data[f][d] = true
  end
end

days = []
data.values.each{|v| days += v.keys}
days = days.sort.uniq


def is_tseholiday(d)
  date = Date.parse(d)
  return true if date.wday == 0
  return true if date.wday == 6
  if date.month == 1 and date.day <= 3
    return true
  end
  if date.month == 12 and date.day == 31
    return true
  end
  return false
end

puts (['date'] + files).join(',')
days.each do |d|
  next if ENV['START_YEAR'] and d.split('-').first < ENV['START_YEAR']
  break if ENV['END_YEAR'] and d.split('-').first > ENV['END_YEAR']
  row = files.map{|f| data[f][d] ? 'x' : '-'}
  unless row.all?{|e| e == 'x'}
    if ENV['IGNORE_TSE_HOLIDAY'] and is_tseholiday(d)
      next
    end
    puts ([d] + row).join(',')
  end
end
