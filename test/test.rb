require 'date'
require 'minitest/autorun'
require 'minitest/ci'

class TestCalendar < MiniTest::Test
  `rm -rf repos/*`
  `bash clone.sh`
  `bash dump.sh`
  @@files = %w{holiday_jp.txt japandas.txt k1low.txt nao.txt}.map{|f| 'dump/'+f }

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

  def gen_message(date, row)
    m = "Not Equal on #{date}\n"
    row.each_with_index do |val, i|
      m += sprintf "%-30s %s\n", @@files[i], val
    end
    m
  end

  def _test_holidays(files, test_name)
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

    message = ''
    days.each do |d|
      next if ENV['START_YEAR'] and d.split('-').first < ENV['START_YEAR']
      break if ENV['END_YEAR'] and d.split('-').first > ENV['END_YEAR']
      next if ENV['IGNORE_TSE_HOLIDAY'] and is_tse_holiday(d)

      row = files.map{|f| data[f][d] ? 'x' : '-'}

      if not row.all?{|e| e == 'x'}
        m = gen_message(d, row)
        message += m
      end
    end
    assert_empty(message, message)
  end

  def test_longterm
    files = @@files.select{|item| item !~ /nao.txt$/ }
    ENV['END_YEAR'] = '2030'
    _test_holidays(files, 'TEST LONGTERM')
  end

  def test_recent
    ENV['START_YEAR'] = '2001'
    ENV['END_YEAR'] = (Date.today.year + 1).to_s
    _test_holidays(@@files, 'TEST RECENT')
  end
end
