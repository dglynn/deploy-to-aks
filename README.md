- [Deploy App to an AKS cluster](#deploy-app-to-and-aks-cluster)
  - [Prerequisites](#prerequisites)
  - [Build docker images](#build-docker-images)
  - [Deploy AKS cluster to Azure](#deploy-aks-cluster-to-azure)

## Deploy a node-todo app to an AKS cluster

In this repo is my config for how to deploy this [node-todo](https://github.com/scotch-io/node-todo) app to an Azure AKS cluster, with a mongodb backend.

### Prerequisites

- [`az cli`](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- [`terraform v0.14.9`](https://releases.hashicorp.com/terraform/0.14.9/)
- [`docker`](https://docs.docker.com/engine/install/)
- [`kubectl`](https://kubernetes.io/docs/tasks/tools/)
- [`helm`](https://helm.sh/docs/intro/install/)
- [`k9s`](https://k9scli.io/topics/install/) - this is optional but a very good text based ui tool for k8s management

### Build the docker images

There are Dockerfile configs to build the images in each sub-folder [`node-todo`](node-todo/Dockerfile) & [`mongodb`](mongodb/Dockerfile). To make your own images from those files and upload them to your own container registry, you can run the following commands:

1. Clone the repo
1. E.g. to build the node-todo app:
   - `cd node-todo`
   - `docker built -t your_docker_hub_id/node-todo .`
1. Once complete follow that with a docker push command:
   - `docker push your_docker_hub_id/node-todo`
1. Repeat the above steps for the mongodb image
   - The mongo db needs extra config to create the node-todo db and user, you can find that config [here](mongodb/init.js)

The repo config is setup to use the images in my docker hub. https://hub.docker.com/u/dglynn

### Deploy AKS cluster to Azure

To deploy the AKS cluster to your own tenant you first need to `cd aks-cluster` and edit the following files:

1. From the [variables.tf](aks-cluster/variables.tf) add your tenant and subscription id's:

   ```
   variable "tenant_id" {
     type        = string
     default     = "ADD YOUR TENANT ID HERE"
     description = "The tenant id of your Azure account"
   }

   variable "subscription_id" {
     type        = string
     default     = "ADD YOUR SUBSCRIPTION ID HERE"
     description = "A subscription id in your Azure tenant"
   }
   ```

1. The next file to edit is the [modules/aks/main.tf](modules/aks/main.tf) and add your `user_principal_name` to this data resource which is used to setup rbac access for the aks admin group in your azure ad:
   ```
   data "azuread_user" "aks_rbac_user" {
     user_principal_name = "ADD YOUR UPN HERE FROM AZURE AD"
   }
   ```
1. After you have done this, you can now login to the azure portal using the following command:
   - `az login` and complete the login process from the web page that opens up.
1. Once logged in return to the root of the [aks-cluster](aks-cluster) directory and run the following terraform commands:
   - `terraform init` - this initialises the modules, installs providers and remote backend terraform state storage
   - `terraform plan -no-color -out tfplan | tee tfplan.log`
     - This will run the plan and output what wil lbe deployed in your azure subscription
     - You can open the `tfplan.log` file it creates to see the plan too
1. If there are no errors and the plan is deploying the expected resources you can now run:
   - `terraform apply tfplan`
1. There is an example of how to setup a remote backend store for the state file, if you would like to try that. There is some manual steps to carry out in advance first. When you open the [backend.tf](aks-cluster/backend.tf) it has all the necessary information.
1. When the terraform apply has been completed it will output the aks config and public ip of the cluster:
   - Copy the aks config and run it: `az aks get-credentials --subscription your_sub_id_will_be_here --resource-group todo --name todo --overwrite-existing`

### Deploying the helm apps

Now you are ready to deploy your apps, [`cd helm`](helm) from the root of the repo:

1. We install the mongodb backend first:
   - You can do a dry run to see what it will do
     - `helm install --dry-run mongodb mongodb`
   - To install the app run:
     - `helm install mongodb mongodb`
1. Now the node-todo app:
   - You can do a dry run to see what it will do
     - `helm install --dry-run todo todo`
   - To install the app run:
     - `helm install todo todo`
1. Once the apps have been installed, you can now copy the public ip from the earlier terraform apply and open your favourite browser and you should land at the apps homepage

### Kubectl and k9s to check the appos after installation

You can check some information about the cluster after its built

1. `kubectl get nodes` will show the nodepool
1. `kubectl get pods` will show the running pods
1. `kubectl get ingress` will show the todo app ingress
1. `kubectl get --watch pods` can be run to see the pods come up during the helm installations
1. `kubectl logs -f todo-uuid_here_of_pod` will show ifd the app started and connected to the db
1. To trigger a scale up and out of the app you can use tools like these:
   - https://loader.io/
   - https://gatling.io/
1. The cluster is setup with a minimum of 3 nodes in the default nodepool scaling up to a maximum of 5 nodes. The app itself has scale out settings in the helm [values.yaml](helm/todo/values.yaml) file. The cluster is set to scale the nodes back down once the utilisation drops to 30%. This can be seen from the AKS resource config in the [aks module](aks-cluster/aks/main.tf)
