docker build -t `cat VERSION` --build-arg version=`cat VERSION` --build-arg base=`cat BASE` .
