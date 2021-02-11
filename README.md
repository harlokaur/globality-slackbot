# globality-slackbot

Dockerfile to start working on slackbot

Things you'll need - 
SSH KEYS to perform git clone 
    - generate ssh keys using putty keygen or run on cli -  `ssh-gen -t 4096 rsa`
    - paste your public key into github > settings > ssh keys 
AWS credentials to login and assume role
    - Login to AWS 
    - goto IAM service 
    - find your username > click on your username > goto security > generate credentials save the key and secret key 
env.json file - 
    - please contact team member
    
Steps to run 
- Copy the credentials and config 
- Copy SSH keys to ssh folder
- Clone Globality - globality-bot git repo into the src folder
- run `docker build -t slackbot .` ( This would build the image)
- run container as - ` docker run -d --name slackbot slackbot`
- get the container id via - `docker ps `
- run ` docker exec -it <container_id> bash `
- To run slack bot  - goto globality-bots/functions/slackbot 
- run  eval $(botoenv -p automation) // assume the role of automation
- run your test case as = python-lambda-local -t 600 -e env.json -f handler main.py test/fixtures/event-status.json 


NOTE - please use docker v19.03 and not the latest 
