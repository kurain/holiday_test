bundle exec ruby -rdate -ryaml -e 'YAML.load(ARGF).keys.each{|d| puts d}' repos/holiday-jp-holyda-jp/holidays.yml > dump/holiday_jp.txt


bundle exec ruby -rdate -ryaml -e 'YAML.load(ARGF).keys.each{|d| puts d}' repos/k1low-holiday_jp/holidays.yml >  dump/k1low.txt
# cat repos/k1low-holiday_jp/holidays.yml | grep -e '^\d' | sed 's/://' > dump/k1low.txt

PYTHONPATH=./repos/japandas python tools/dump.py > dump/japandas.txt

bundle exec ruby tools/nao.rb > repos/nao/nao.csv
cut -d, -f1 repos/nao/nao.csv > dump/nao.txt
