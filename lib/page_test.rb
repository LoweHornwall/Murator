print "length: "
length = gets.to_i
range = (0...length).to_a

def offset(val, range)
  range[val..(val + 25)]
end

def paginate(page, range)
  if range.length < 25
    page_count = 1
  else
    page_count = range.length / 25
    page_count += 1 if range.length % 25 != 0
  end

  fetched = offset(((page - 1) * 25), range)
  puts "page_count: #{page_count}"
  puts "fetched: #{fetched}"
  puts "current page: #{current_page}"
end

page = gets.to_i
puts paginate(page, range)