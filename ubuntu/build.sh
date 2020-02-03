SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [ -z "$1" ]; then
	echo "Usage: build.sh <APP_NAME>"
	echo "APP_NAME can be anyone from the below list"
	APPS=`ls apps`
	echo $APPS
	exit	
fi
# Get the build version number
BUILD_VERSION=`cat $SCRIPTDIR/../BUILD_VERSION`

APP=$1
APPDOCKER_DIR=$SCRIPTDIR/apps/$APP

# If the application directory does not exist, exit
cd $APPDOCKER_DIR || exit

# If application has prerequisites that are not satisifed, exit
if [ -f $APPDOCKER_DIR/prerequisites.sh ]; then
	sh $APPDOCKER_DIR/prerequisites.sh $APPDOCKER_DIR || exit
fi

# Read the application config
source $APPDOCKER_DIR/config

LIBDOCKER_DIR=$SCRIPTDIR/$TOOLCHAIN

# Create the Build Directory and Copy the data files
rm -rf $APPDOCKER_DIR/build
mkdir -p $APPDOCKER_DIR/build
cp -r $APPDOCKER_DIR/data $APPDOCKER_DIR/build
cd $APPDOCKER_DIR/build

# Combine the Dockerfiles of the components required
for comp in $COMPONENTS; do
	cat $LIBDOCKER_DIR/Dockerfile.$comp >> Dockerfile || exit 1
done
cat $APPDOCKER_DIR/Dockerfile.${APP_NAME} >> Dockerfile

DOCKERNAME=$APP_TYPE/$APP_NAME

# Add build_version and docker name labels into the Dockerfile
echo "LABEL BUILD_VERSION=$BUILD_VERSION" >> Dockerfile
echo "LABEL DOCKERNAME=$DOCKERNAME" >> Dockerfile

# Add the library versions into the Dockerfile
for comp in $COMPONENTS; do
	lib_version=`cat $LIBDOCKER_DIR/LIB_VERSIONS | grep $comp`
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
