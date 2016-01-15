require 'io/console'
require 'watir-webdriver'


def get_score(index,id)
  if index == 0 and id == '103062702'
    return '99'
  else
    return '-1'
  end
end

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
  print "start to grade assignment #{assignment_num}... "
  browser.goto(assignment)
  browser.table({id:'t1',:class =>"table"}).wait_until_present
  students = browser.table({id:'t1',:class =>"table"}).trs[1..-1]
  students.each do |student|
    student_id  = student.tds[2].div.text
    student_score =  get_score(assignment_num,student_id)
    if student_score != '-1' then
      student.tds[-1].a.click
      student.tds[-1].text_field.set(student_score)
      browser.send_keys :enter
    end
  end
  puts "done"
end

# done all jobs
puts 'successfully done!!!!'
