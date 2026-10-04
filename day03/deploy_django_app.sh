#!/bin/bash
#
#
#


<<task
Deploy a django app from github
task



code_clone(){

    echo "cloning the Django App...."
    git clone https://github.com/LondheShubham153/django-notes-app.git
     

}

install_requirements(){

   echo "Installing dependencies..."
   
   sudo apt-get install docker.io nginx -y 


}

required_restarts(){
    sudo chown $USER /var/run/docker.sock
    sudo systemctl enable docker
    sudo systemctl enable nginx
    sudo systemctl restart docker

}

deploy(){
	docker build notes-app .
	docker rm -f $(docker ps -aq)

    echo "Deploying on port: $PORT"
    docker run -d -p 8000:8000 --name notes-app notes-app:latestecho "Building and deploying..."
    
    # 1. Add the trailing dot '.' to specify current directory
    docker build -t notes-app . || return 1
    
    # 2. Assign dynamic port
    PORT=$(python3 -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
    
    # 3. Clean up old containers
    docker rm -f notes-app-container 2>/dev/null || true
    
    # 4. Run new container binding to 0.0.0.0
    docker run -d -p $PORT:8000 --name notes-app-container notes-app:latest python3 manage.py runserver 0.0.0.0:8000
    
    echo "Deployed successfully on port: $PORT"

}

echo "******DEPLOYMENT STARTS******"

if ! code_clone; then 
	echo "the code directory already exists"
	cd django-notes-app
fi

if ! install_requirements; then
	echo "Installation Failure...."
	exit 1
fi

if ! required_restarts; then 
	echo "System Fault Detected..."
	exit 1
fi

if ! deploy; then 
	echo "Deployment Failed, mailing the admin"
        #sendmail
	exit 1
fi
echo "******DEPLOYMENT DONE*******"





