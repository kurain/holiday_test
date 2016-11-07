require 'date'
require 'minitest/unit'

MiniTest::Unit.autorun

class TestCalendar < MiniTest::Unit::TestCase
  def is_tse_holiday(d)
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

  def message(date, row)
    m = "Not Equal on #{date}\n"
    row.each_with_index do |val, i|
      m += "  #{@files[i]}\t#{val}\n"
    end
    m
  end

  def setup
    `rm -rf repos/*`
    `bash clone.sh`
    `bash dump.sh`
    @files = %w{holiday_jp.txt japandas.txt k1low.txt nao.txt}.map{|f| 'dump/'+f }
  end

  def test_holidays
    data = {}
    @files.each do |f|
      data[f] = {}
      open(f).read.chomp.split("\n").each do |d|
        data[f][d] = true
      end
    end

    days = []
    data.values.each{|v| days += v.keys}
    days = days.sort.uniq

    days.each do |d|
      next if ENV['START_YEAR'] and d.split('-').first < ENV['START_YEAR']
      break if ENV['END_YEAR'] and d.split('-').first > ENV['END_YEAR']
      next if ENV['IGNORE_TSE_HOLIDAY'] and is_tse_holiday(d)

      row = @files.map{|f| data[f][d] ? 'x' : '-'}
      assert(row.all?{|e| e == 'x'}, ->(){ message(d, row) })
    end
  end
end
