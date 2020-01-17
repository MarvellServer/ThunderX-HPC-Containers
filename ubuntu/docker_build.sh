if [ -z "$1" ]; then
	echo "Usage: docker_build.sh <APP_NAME>"
	echo "APP_NAME can be anyone from the below list"
	APPS=`ls apps`
	echo $APPS
	exit	
fi
APP=$1

function build_component () {
	local COMPONENT=$1
	CMD="docker build \
		-f Dockerfile.$TOOLCHAIN \
		-t ubuntu/$TOOLCHAIN/$COMPONENT:latest \
		--target $COMPONENT . "
	echo $CMD >> build.sh
	$CMD || exit
}

function build_benchmark () {
	local COMPONENT=$1
	local TAG=$2
	local MINIMIZE=$3
	if [ "$MINIMIZE" == "YES" ]; then
		BUILDARGS="--build-arg finalimage=minimalimage"
	else
		BUILDARGS="--build-arg finalimage=fullimage"
	fi
	CMD="docker build \
		-f Dockerfile.$APP_NAME.$TOOLCHAIN \
		-t ubuntu/$TOOLCHAIN/$COMPONENT:$TAG \
		$BUILDARGS ."
	echo $CMD >> build.sh
	$CMD || exit 
}

cd apps/$APP || exit
source ./config

rm -rf build
mkdir -p build
cp ../../base/Dockerfile.$TOOLCHAIN build
cp Dockerfile.${APP_NAME}.$TOOLCHAIN build
cp -r data build
cd build

build_component utils
for comp in base $COMPONENTS; do
	build_component $comp
	if [ "$MINIMIZE" == "YES" ]; then
		build_component ${comp}_minimal
	fi
done
build_benchmark $APP_NAME $APP_TAG $MINIMIZE

echo "##########################################################################"
echo Run the following command to run the docker
echo docker run -it --rm --cap-add=SYS_PTRACE --cap-add=SYS_NICE --shm-size=1G ubuntu/$TOOLCHAIN/$APP_NAME:$APP_TAG
echo "##########################################################################"
