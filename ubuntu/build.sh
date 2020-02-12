SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [ -z "$1" ]; then
	echo "Usage: build.sh <APP_NAME>"
	echo "APP_NAME can be anyone from the below list"
	APPS=`ls apps`
	echo $APPS
	exit	
fi
BUILD_VERSION=`cat $SCRIPTDIR/../BUILD_VERSION`
APP=$1
APPDOCKER_DIR=$SCRIPTDIR/apps/$APP

# If the application directory does not exist, exit
cd $APPDOCKER_DIR || exit

# Read the application config
source $APPDOCKER_DIR/config

LIBDOCKER_DIR=$SCRIPTDIR/$TOOLCHAIN
DOCKERNAME=$APP_TYPE/$APP_NAME
BUILDCMD="docker build -t $DOCKERNAME:$BUILD_VERSION ."
DEFAULTRUNCMD="docker run -it --rm --cap-add=SYS_PTRACE --cap-add=SYS_NICE --shm-size=1G $DOCKERNAME:$BUILD_VERSION"

# Create the Build Directory and Copy the data files
rm -rf $APPDOCKER_DIR/build
mkdir -p $APPDOCKER_DIR/build
cp -r $APPDOCKER_DIR/data $APPDOCKER_DIR/build
cd $APPDOCKER_DIR/build


# Combine the Dockerfiles, prerequisites and readme of the components required
touch Dockerfile
touch README
touch prerequisites.sh
for comp in $COMPONENTS; do
	cat $LIBDOCKER_DIR/Dockerfile.$comp >> Dockerfile || exit 1
	if [ -f $LIBDOCKER_DIR/prerequisites.${comp}.sh ]; then
		cat $APPDOCKER_DIR/prerequisites.${comp}.sh >> prerequisites.sh
	fi
	if [ -f $LIBDOCKER_DIR/README.${comp} ]; then
		cat $APPDOCKER_DIR/README.${comp} >> README
	fi
done
cat $APPDOCKER_DIR/Dockerfile.${APP_NAME} >> Dockerfile || exit 1
if [ -f $APPDOCKER_DIR/prerequisites.sh ]; then
	cat $APPDOCKER_DIR/prerequisites.sh >> prerequisites.sh
fi
if [ -f $APPDOCKER_DIR/README ]; then
	cat $APPDOCKER_DIR/README >> README
else
	echo "Run the following command to run the docker" >> README
	echo "$DEFAULTRUNCMD" >> README
fi


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


# Save the build command in the docker image
echo $BUILDCMD > docker_build.sh

# Check prerequisites
sh prerequisites.sh || exit 1

# Start building
sh docker_build.sh || exit 1

# Print the README
sed -i "s#BUILD_VERSION#$BUILD_VERSION#g" README
echo "##########################################################################"
cat README
echo "##########################################################################"
