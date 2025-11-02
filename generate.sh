#!/bin/bash

PROTO_DIR="./proto"

FILES=$(find "$PROTO_DIR" -name "*.proto")

for file in $FILES
do
    IFS='/'
    read -ra path_array <<< "$file"
    folder=${path_array[2]}
    file_name=${path_array[3]}

    rm -rf ./pkg/api/$folder
    mkdir -p ./pkg/api/$folder

    protoc --go_out=./pkg/api/$folder --go_opt=paths=source_relative --go-grpc_out=./pkg/api/$folder --go-grpc_opt=paths=source_relative ./proto/$folder/$file_name
    mv ./pkg/api/$folder/proto/$folder/${folder}_grpc.pb.go ./pkg/api/$folder/${folder}_grpc.pb.go
    mv ./pkg/api/$folder/proto/$folder/$folder.pb.go ./pkg/api/$folder/$folder.pb.go
    rm -rf ./pkg/api/$folder/proto

    echo "generate for $file_name"
done