DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"

_operation="some"
_container="gitea"
_build_image="gitea:1.0"
_volume=" -v /Users/guilhermefacanha/workspace/docker/gitea:/data "
_ports=" -p 3000:3000 -p 222:22 "

_USER="admin"
_PASSWORD="admin"

if (( $# <= 0 )); then
    echo "you must provide one operation: 
    [
    help - show data about connections and credentials, 
    build - build image $_build_image from Dockerfile, cat
    create - create a new container $_container from built image, 
    status - show container $_container status, 
    log - show container $_container log, 
    start - start the container $_container, 
    stop - stop the container $_container, 
    remove - remove the container $_container, 
    clean - remove the container $_container and clean all image data from hard drive, 
    clean-all - deletes any stopped containers and any non-tagged images which not in use by any tagged images
    space = show how much space the images and docker cache are using
    exec - open container $_container shell
    ]"
    read _operation
else
    _operation=$1
fi

echo ' ==== '
echo 'selected _operation: '$_operation
echo ' ==== '

showHelp(){
    
    echo ""
    echo "========= DOCKER FILE FOR GITEA SERVER ========="
    echo ""
    echo "Container: $_container"
    echo "Server URL: localhost:$_port"
    echo "Login: $_USER"
    echo "Password: $_PASSWORD"
    echo ""
    echo ""
    echo "========= DOCKER FILE FOR GITEA SERVER ========="
}

case "$_operation" in
    'help')
        showHelp
    ;;
    'create')
      echo "=>creating $_container container: "
	  showHelp
      docker run -it -d --cpus="1" $_ports $_volume --name $_container $_build_image
    ;;
    'remove')
        docker rm -f $_container
    ;;
    'build')
        docker build --rm --no-cache -t $_build_image .
    ;;
    'clean')
        docker rm -f $_container
        docker rmi -f $_build_image
        docker image prune -f
    ;;
    'clean-all')
        docker system prune -a
    ;;
    'space')
        docker system df
    ;;
    'log')
	docker logs -f $_container
    ;;
    'status')
        docker ps | grep ldap
    ;;
    'start')  
	docker start $_container
    ;;
    'stop')  
	docker stop $_container
    ;;
    'exec')  
        docker exec -it $_container bash
    ;;
    *)
        echo "operation '$_operation' not recognized"
    ;;
esac


echo finished!