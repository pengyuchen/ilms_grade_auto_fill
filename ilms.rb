require 'io/console'
require 'spreadsheet'
require 'watir-webdriver'

# if you don't have the same structure with 'demo.xls'
# you need to customize this function to store all score to hash table 'result'
# result = {'103062600':[99, 80, 79, 91, ......],'103062601'=>[90,83,...] ...}
# notice that if score is -1, the script would ignore that assignment
def read_score_from_file(file_name, result= Hash.new { |h, k| h[k] = [] })
  sheet = Spreadsheet.open(file_name).worksheets[0]
  num_of_assignment = sheet.rows[0].length - 2
  sheet.rows[1..-1].each do |row|
    student_id = row[0].to_s
    row[2...2+num_of_assignment].each do |score|
      if score.nil? then result[student_id] << -1
      elsif score == 'OK' then result[student_id] << 80
      else result[student_id] << score.to_i end
    end
  end
  result
end

# readfile
total_score = read_score_from_file(ARGV[0])
ARGV.clear

# enter your account and password
print 'loginAccount:'; account = gets.chomp
print 'loginPasswd:' ; passwd = STDIN.noecho(&:gets).chomp
puts

# open a broswer and login
browser = Watir::Browser.new
browser.goto('http://lms.nthu.edu.tw/login_page.php?from=%2Fhome.php')
browser.text_field(id: 'loginAccount').set(account)
browser.text_field(id: 'loginPasswd').set(passwd)
browser.button({:text => '確定'}).click

# choose a course you want to grade and than go
browser.div(:class=>"mnuItem").wait_until_present
course_list = browser.elements({:class=>'mnuItem'}).map {|e| [e.a.text,e.a.title]}[0...-1]
puts 'select a course number'
course_list.each_with_index{ |course,i| puts "#{i} #{course}" }
course_num = gets.chomp.to_i
browser.a({title: course_list[course_num][1]}).click

# go to total score page and get all assignments' link
browser.div(:class=>"Escore").wait_until_present
browser.div(:class=>"Escore").a.click
browser.table({id:'t1',:class =>"table"}).wait_until_present
assignments = browser.table({id:'t1',:class =>"table"}).tr(:class => 'header').tds[4...-1].map{|td| td.a.href}

# for each assignments fill the score according to their id number
assignments.each_with_index do |assignment,assignment_num|
  print "start to fill grade of assignment #{assignment_num+1}... "
  browser.goto(assignment)
  browser.table({id:'t1',:class =>"table"}).wait_until_present
  students = browser.table({id:'t1',:class =>"table"}).trs[1..-1]
  students.each do |student|
    student_id  = student.tds[2].div.text
    student_score =  total_score[student_id][assignment_num]
    if student_score != -1 then
      student.tds[-1].a.click
      student.tds[-1].text_field.set(student_score.to_s)
      browser.send_keys :enter
    end
  end
  puts "done"
end

# done all jobs
puts 'successfully done!!!!'
