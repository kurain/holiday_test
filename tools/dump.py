import japandas as jpd
for d in jpd.JapaneseHolidayCalendar().holidays():
    print(d.strftime('%Y-%m-%d'))
