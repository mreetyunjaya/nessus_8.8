import warnings
import requests
from urllib3.exceptions import InsecureRequestWarning
import random
import time
import json
import re
import os
import sys
import string
import time
from bs4 import BeautifulSoup

requests.packages.urllib3.disable_warnings(category=InsecureRequestWarning)
requests.packages.urllib3.disable_warnings()

GET_INBOX = 'https://getnada.com/api/v1/inboxes/'
GET_MESSAGE = 'https://getnada.com/api/v1/messages/'
mailx = str(random.randint(1, 9999999999))
domain = "getnada.com"
name = mailx

email = mailx + '@getnada.com' 
print ("Email Address: "+ email)
print ("Nessus Registeration Form")
ht=requests.get("https://www.tenable.com/products/nessus/nessus-essentials", verify=False)
bs=BeautifulSoup(ht.text,'html.parser')
for link in bs.findAll("input",{"name":"token"}):
 if 'name' in link.attrs:
   tkn=link.attrs['value']
 else:
   print("not found")
fname=("John")
lname=("Petrov")
params={"first_name":fname,"last_name":lname,"email":email,"country":"IN","Accept":"Agree","robot":"human","type":"homefeed","token":tkn,"submit":"Register"}
r = requests.post("https://www.tenable.com/products/nessus/nessus-essentials", data=params, verify=False)
all = mailx + "@" + domain
sleep = 15
print ("Go sleep for:" + str(sleep) + " seconds")
time.sleep(sleep)
data = None
r = requests.get(GET_INBOX + all)
uid = (r.json()['msgs'])[0]['uid']
print("UID of email is: " + uid)
data = None
r = requests.get(GET_MESSAGE + uid)
text = r.json()['html']
regex = r"\w{4}(?:-\w{4}){4}"
activation_code=re.search(regex,text)
print("Activation code: " + activation_code.group())
file = open("nessus.txt","w") 
file.write(activation_code.group())
file.close() 

cmd = ('curl -o register.out -k --header "Host: plugins.nessus.org" "https://52.16.241.207/register.php?serial=$(cat nessus.txt)"')
os.system(cmd)
