# watir-automation
use watir-webdriver to automatically do something

## how to install
```
bundle install
```

## ILMS Score Auto Fill
If you are a TA of some course on [ILMS](http://lms.nthu.edu.tw/).  
You may need to fill score of every student's test or assignment.  
This is soooo boring, so I write this script.
```
ruby ilms.rb demo.xls
```
Note that if you don't have the same structure with 'demo.xls'.  
You need to customize the function 'read_score_from_file' in 'ilms.rb'.
