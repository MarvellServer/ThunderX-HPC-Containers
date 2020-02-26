#!/bin/bash

###############################################################################
# Set to terminate script at each error
###############################################################################
set -e
#set -x


###############################################################################
# Check the usage
###############################################################################
if [ -z "$1" ]; then
	echo "---------------------------------------------------"
	echo "Usage: build.sh <APP_NAME>"
	echo -e "<APP_NAME> can be anyone from the below list"
	echo "---------------------------------------------------"
	cat APPLIST
	echo "---------------------------------------------------"
	exit	
fi


###############################################################################
# Read the application config and set the variables
###############################################################################
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BUILD_VERSION="`cat $SCRIPTDIR/../BUILD_VERSION`"
APP=$1
APPDOCKER_DIR=$SCRIPTDIR/apps/$APP
source $APPDOCKER_DIR/config
LIBDOCKER_DIR=$SCRIPTDIR/$TOOLCHAIN
APPBUILD_DIR=$SCRIPTDIR/apps/$APP/build
DOCKERNAME=$APP_TYPE/$APP_NAME
BUILDCMD="docker build -t $DOCKERNAME:$BUILD_VERSION ."
DEFAULTRUNCMD="docker run -it --rm --cap-add=SYS_PTRACE --cap-add=SYS_NICE --shm-size=1G $DOCKERNAME:$BUILD_VERSION"


###############################################################################
# Create the Build Directory tree and copy required data
###############################################################################
rm -rf $APPBUILD_DIR
mkdir -p $APPBUILD_DIR
if [ -d $APPDOCKER_DIR/data/ ]; then
	cp -r $APPDOCKER_DIR/data/ $APPBUILD_DIR/data 
fi
cd $APPBUILD_DIR


###############################################################################
# Copy the data for the components into the build directory
# and add the line to copy the same into the image
###############################################################################
for comp in $COMPONENTS; do
	if [ -d $LIBDOCKER_DIR/data/$comp/ ]; then
		mkdir -p $APPBUILD_DIR/data/$comp
		cp -r $LIBDOCKER_DIR/data/$comp/* $APPBUILD_DIR/data/$comp || exit 0
	fi
done


###############################################################################
# Combine the Readmes of the components involved.
# If a README exists for the application, use that. Else print
# the default run command as the README
###############################################################################
echo "" > README
for comp in $COMPONENTS; do
	if [ -f $LIBDOCKER_DIR/README.${comp} ]; then
		cat $LIBDOCKER_DIR/README.${comp} >> README
		echo -e "\n" >> README
	fi
done

if [ -f $APPDOCKER_DIR/README.${APP_NAME} ]; then
	cat $APPDOCKER_DIR/README.${APP_NAME} >> README
else
	echo "-----" >> README
	echo "NOTES" >> README
	echo "-----" >> README
	echo "Run the following command to run the docker" >> README
	echo "$DEFAULTRUNCMD" >> README
fi
sed -i "s#BUILD_VERSION#$BUILD_VERSION#g" README


###############################################################################
# Combine the prerequisites of the components involved.
###############################################################################
echo "" > prerequisites.sh
for comp in $COMPONENTS; do
	if [ -f $LIBDOCKER_DIR/prerequisites.${comp}.sh ]; then
		cat $LIBDOCKER_DIR/prerequisites.${comp}.sh >> prerequisites.sh
	fi
done

if [ -f $APPDOCKER_DIR/prerequisites.${APP_NAME}.sh ]; then
	cat $APPDOCKER_DIR/prerequisites.${APP_NAME}.sh >> prerequisites.sh
fi


###############################################################################
# Combine the Dockerfiles of the components involved
###############################################################################
touch Dockerfile
for comp in $COMPONENTS; do
	cat $LIBDOCKER_DIR/Dockerfile.$comp >> Dockerfile
	echo "" >> Dockerfile
done
cat $APPDOCKER_DIR/Dockerfile.${APP_NAME} >> Dockerfile


###############################################################################
# Add Command to change to user guest in the Dockerfile
###############################################################################
echo -e "\n# Change to user guest" >> Dockerfile
echo "USER    root" >> Dockerfile
echo "RUN     mkdir -p /docker" >> Dockerfile
echo "RUN     chown -R guest:guest /docker/" >> Dockerfile
echo "USER    guest" >> Dockerfile


###############################################################################
# Add the command to copy the Dockerfiles into the image
###############################################################################
# These files should be always copied to the image
echo -e "\n# Copy the final dockerfile and data to the image" >> Dockerfile
echo "COPY    . /docker/src" >> Dockerfile


###############################################################################
# Add build_version and docker name labels into the Dockerfile
###############################################################################
echo -e "\n# Build version and name" >> Dockerfile
echo "LABEL BUILD_VERSION=$BUILD_VERSION" >> Dockerfile
echo "LABEL DOCKERNAME=$DOCKERNAME" >> Dockerfile


###############################################################################
# Add the library versions into the Dockerfile
###############################################################################
echo -e "\n# Versions of the components" >> Dockerfile
for comp in $COMPONENTS; do
	set +e
	lib_version=`cat $LIBDOCKER_DIR/LIB_VERSIONS | grep -w $comp`
	set -e
	if [ ! -z "$lib_version" ]; then
		label=`echo $lib_version | awk '{print toupper($1) "_VERSION=" $2}'`
		echo "LABEL $label" >> Dockerfile
	fi
done


###############################################################################
# Save the build command in the docker image
###############################################################################
echo $BUILDCMD > docker_build.sh


###############################################################################
# Check prerequisites.
# Then rename the BUILDDIR to /docker/src so as to reflect the paths after
# the script is copied to the image 
###############################################################################
sed "s#BUILDDIR#$APPBUILD_DIR#g" prerequisites.sh | sh
sed -i "s#BUILDDIR#/docker/src#g" prerequisites.sh


###############################################################################
# Rename the reference to the previously build image if it exists
###############################################################################
set +e
docker tag $DOCKERNAME:$BUILD_VERSION $APP_TYPE/bkp/$APP_NAME:${BUILD_VERSION}
set -e


###############################################################################
# Start building
###############################################################################
# Build the intermediate stages and tag them
devel=`echo $COMPONENTS | awk '{print $1}'`
for comp in $COMPONENTS; do
	if [[ "$comp" == *"devel"* ]]; then
		tag=$APP_TYPE/$comp:$BUILD_VERSION
	elif [[ "$comp" == *"runtime"* ]]; then
		tag=$APP_TYPE/$comp:$BUILD_VERSION
	else
		tag=$APP_TYPE/$devel/$comp:$BUILD_VERSION
	fi
	# Build the components one by one and name them
	docker build --target $comp -t $tag .
done
docker build --target $APP_NAME -t $APP_TYPE/build/$APP_NAME:$BUILD_VERSION .
# Build the app
sh docker_build.sh


###############################################################################
# Squash the image
###############################################################################
set +e
docker tag $DOCKERNAME:$BUILD_VERSION $APP_TYPE/nosquash/$APP_NAME:${BUILD_VERSION}
docker-squash -t $DOCKERNAME:$BUILD_VERSION $APP_TYPE/nosquash/$APP_NAME:${BUILD_VERSION}

# Remove the previously built image
docker image rm $APP_TYPE/bkp/$APP_NAME:${BUILD_VERSION}


###############################################################################
# Remove the unnecessary tagged images
###############################################################################
# Remove the image used to build the app
#docker image rm $APP_TYPE/build/$APP_NAME:${BUILD_VERSION}

# Remove the non-squashed image
docker image rm $APP_TYPE/nosquash/$APP_NAME:${BUILD_VERSION}
set -e


###############################################################################
# Print the README
###############################################################################
cat README
