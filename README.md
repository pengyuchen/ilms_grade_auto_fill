# watir-automation
use watir-webdriver to sautomatically do something

## how to install
```
bundle install
```

## ILMS Score Auto Fill
http://lms.nthu.edu.tw/
if you are a TA of some course on ILMS
you may need to fill score of every student's test or assignment
so I write this script
```
ruby ilms.rb demo.xls
```
note that if you don't have the same structure with 'demo.xls'
you need to customize the function 'read_score_from_file' in 'ilms.rb'