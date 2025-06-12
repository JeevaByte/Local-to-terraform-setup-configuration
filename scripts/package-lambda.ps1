# Script to package Lambda function for deployment

Set-Location lambda
npm install
Compress-Archive -Path * -DestinationPath rotation-function.zip -Force
Move-Item -Path rotation-function.zip -Destination .. -Force
Set-Location ..

Write-Host "Lambda function packaged successfully!"