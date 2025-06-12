#!/bin/bash

# Script to package Lambda function for deployment

cd lambda
npm install
zip -r rotation-function.zip .
mv rotation-function.zip ..
cd ..

echo "Lambda function packaged successfully!"