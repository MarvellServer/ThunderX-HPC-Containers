source ./config

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
	local BUILDARGS="--build-arg name_tag=$TAG"
	CMD="docker build \
		-f Dockerfile.$APP_NAME.$TOOLCHAIN \
		-t ubuntu/$TOOLCHAIN/$COMPONENT:$TAG \
		$BUILDARGS . "
	echo $CMD >> build.sh
	$CMD || exit 
}

rm -rf build
mkdir -p build
cp ../../base/Dockerfile.$TOOLCHAIN build
cp Dockerfile.hpl.$TOOLCHAIN build
cp -r data build
cd build

build_component base
build_component utils
build_component openmpi
build_component openblas
build_benchmark $APP_NAME $APP_TAG

echo "##########################################################################"
echo Run the following command to run the docker
echo docker run -it --rm --cap-add=SYS_PTRACE --cap-add=SYS_NICE --shm-size=1G ubuntu/$TOOLCHAIN/$APP_NAME:$APP_TAG
echo "##########################################################################"
