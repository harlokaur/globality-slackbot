# globality-slackbot

Dockerfile to start working on slackbot

Things you'll need - 
SSH KEYS to perform git clone 
AWS credentials to login and assume role

Steps to run 
- Copy the credentials and config 
- Copy SSH keys to ssh folder
- run docker build -t slackbot .
- run docker exec -it <container_id> bash
- To run slack bot  - goto globality-bots/functions/ 
- run mkvirtualenv slackbot
- run eval($ botoenv -p automation)
- run your test case as = python-lambda-local -t 600 -f handler main.py test/fixtures/event-status.json 