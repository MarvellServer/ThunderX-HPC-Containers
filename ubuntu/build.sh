if [ -z "$1" ]; then
	echo "Usage: build.sh <APP_NAME>"
	echo "APP_NAME can be anyone from the below list"
	APPS=`ls apps`
	echo $APPS
	exit	
fi
APP=$1

cd apps/$APP || exit
source ./config

# Create the Build Directory and Copy the data files
rm -rf build
mkdir -p build
cp -r data build
cd build

# Combine the Dockerfiles
for comp in $COMPONENTS; do
	cat ../../../$TOOLCHAIN/Dockerfile.$comp >> Dockerfile
done
cat ../Dockerfile.${APP_NAME}.${TOOLCHAIN} >> Dockerfile

DOCKERNAME=ubuntu/$TOOLCHAIN/$APP_NAME:$APP_TAG
BUILDCMD="docker build -t $DOCKERNAME ."
RUNCMD="docker run -it --rm --cap-add=SYS_PTRACE --cap-add=SYS_NICE --shm-size=1G $DOCKERNAME"

echo $BUILDCMD > docker_build.sh
echo $RUNCMD > docker_run.sh

sh docker_build.sh

echo "##########################################################################"
echo Run the following command to run the docker
echo $RUNCMD
echo "##########################################################################"
