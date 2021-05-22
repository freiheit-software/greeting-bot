docker build -t my-function . && docker run --rm -it -p 8080:8080 --env-file=.env my-function --source=app.rb --target=$1
