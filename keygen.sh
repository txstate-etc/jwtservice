ssh-keygen -t rsa -b 4096 -f keys/jwtservice.key
openssl rsa -in keys/jwtservice.key -pubout -outform PEM -out keys/jwtservice.key.pub

