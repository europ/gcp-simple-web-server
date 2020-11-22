# Google Cloud Platform - Simple Web Server

Deploy simple web server provided by [nginx](https://www.nginx.com/) in [debian 10](https://www.debian.org/index.html) to [google cloud platform](https://cloud.google.com/) using [terraform](https://www.terraform.io/).

1. prerequisites installation

    1. [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
        * authenticate yourself
        * create a project
    1. [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

1. environment configuration

    ```bash
    cat <<EOS > ~/.gcp
    export GCP_PROJECT_ID=<your GCP project name>
    export GCP_ACCOUNT_FILE=~/.config/gcloud/legacy_credentials/<your@email.com>/adc.json
    export GCP_ZONE=europe-west3-b
    export GCP_REGION=europe-west3
    
    export TF_VAR_gcp_zone="\$GCP_ZONE"
    export TF_VAR_gcp_credentials="\$GCP_ACCOUNT_FILE"
    export TF_VAR_gcp_project_id="\$GCP_PROJECT_ID"
    export TF_VAR_gcp_region="\$GCP_REGION"
    EOS
    
    # secure the file
    chmod 0600 ~/.gcp
    
    # load the file
    source ~/.gcp
    ```

1. clone this repository and `cd` into it

1. create SSH key pair

    ```bash
    ssh-keygen -t rsa -b 4096 -C "terraform" -f ./ssh/key
    ```

1. configure terraform variables (set your custom values)

    ```bash
    # create variable file
    cp .terraform.tfvars.example terraform.tfvars

    # set custom variable values
    vi terraform.tfvars
    ```

1. deployment

    ```bash
    # download module(s)
    terraform init

    # deploy
    terraform apply
    ```
