if [ -z "$1" ]; then
	echo "Usage: build.sh <APP_NAME>"
	echo "APP_NAME can be anyone from the below list"
	APPS=`ls apps`
	echo $APPS
	exit	
fi
# Get the build version number
BUILD_VERSION=`cat ../BUILD_VERSION`

APP=$1

# If the application directory does not exist, exit
cd apps/$APP || exit

# If application has prerequisites that are not satisifed, exit
if [ -f ./prerequisites.sh ]; then
	sh ./prerequisites.sh `pwd` || exit
fi

# Read the application config
source ./config

# Create the Build Directory and Copy the data files
rm -rf build
mkdir -p build
cp -r data build
cd build

# Combine the Dockerfiles of the components required
for comp in $COMPONENTS; do
	cat ../../../$TOOLCHAIN/Dockerfile.$comp >> Dockerfile || exit 1
done
cat ../Dockerfile.${APP_NAME} >> Dockerfile

DOCKERNAME=$APP_TYPE/$APP_NAME

# Add build_version and docker name labels into the Dockerfile
echo "LABEL BUILD_VERSION=$BUILD_VERSION" >> Dockerfile
echo "LABEL DOCKERNAME=$DOCKERNAME" >> Dockerfile

# Add the library versions into the Dockerfile
for comp in $COMPONENTS; do
	lib_version=`cat ../../../$TOOLCHAIN/LIB_VERSIONS | grep $comp`
	if [ ! -z "$lib_version" ]; then
		label=`echo $lib_version | awk '{print toupper($1) "_VERSION=" $2}'`
		echo "LABEL $label" >> Dockerfile
	fi
done

# Build and run commands for the dockerfile
BUILDCMD="docker build -t $DOCKERNAME:$BUILD_VERSION ."
RUNCMD="docker run -it --rm --cap-add=SYS_PTRACE --cap-add=SYS_NICE --shm-size=1G $DOCKERNAME:$BUILD_VERSION"

# Save the build command and run command in the docker image
echo $BUILDCMD > docker_build.sh
echo $RUNCMD > docker_run.sh

# Start building
sh docker_build.sh || exit 1

echo "##########################################################################"
echo Run the following command to run the docker
echo $RUNCMD
echo "##########################################################################"
