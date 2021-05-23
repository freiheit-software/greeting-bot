base_dir="$PWD"
cd "`dirname \"$0\"`"
gcloud functions deploy $1 --runtime=ruby27 --trigger-http --entry-point=$1 --region europe-west3 --env-vars-file=env.yaml --service-account=cloud-functions-invoker@freiheit-software-bots.iam.gserviceaccount.com
cd "$base_dir"