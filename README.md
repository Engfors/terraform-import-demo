# Terraform version 1.5.0 import demo

This step-by-step guide will introduce the new and improved import functionality introduce in Terraform 1.5.0

## Prerequisites

* HashiCorp Cloud Platform (HCP) Account
* Terraform Cloud (TCP) Account
* TFC organisation - free tier
* Fork this repository
* Clone the repository

### Setup

1. Follow [the following guide](https://support.hashicorp.com/hc/en-us/articles/4404391219091-Managing-Service-Principal-Credentials-in-HCP) to create HCP credentials needed for Terraform. Leave the tab open or save these for step 6.
2. In Terraform Cloud (TFC), create a new or use an existing organisation
3. Change all occurances of `organization = "<CHANGE ME>"` throughout the code to match your organisation name for Terraform Cloud.
4. In the organisation, create a new [project](https://developer.hashicorp.com/terraform/tutorials/cloud/projects#create-projects), name it `import demo`.
5. Create 3 new [workspaces](https://developer.hashicorp.com/terraform/tutorials/cloud/projects#create-workspaces-in-projects) in the newly created project, for now, select **CLI-driven workflow** and give them the names `terraform-base`, `terraform-create`, `terraform-import`,  and select `import-demo` as project.
6. Once create add the following tags to the workspaces:

* demo
* import

5. To centralise the credentials and configuration needed I choose to create a **Variable Set** that I will attached to the project. To create a variable set, see [this tutorial](https://developer.hashicorp.com/terraform/tutorials/cloud-get-started/cloud-create-variable-set) for an example.  
When creating the variable set, choose any name for it, in the **Variable set scope**, choose the `import demo` project created in step 3.  
Now add the following **Environment variables** from step 1:

* HCP_CLIENT_ID
* HCP_CLIENT_SECRET  
  Click **Create variable set** to save it.

## Create base environment

To create a base for us to explore how we can import resource, we will create a HCP Vault cluster.  

1. Go to your `terraform-base` workspace and the **Variables** tab, verify that your HCP credentials have been successfully loaded as a variable set.
2. Go to **Settings** for the workspace and click on **Version Control**, here you will click on **Connect to version control** --> **Version control workflow** and choose your GitHub repository, see [this example](https://developer.hashicorp.com/terraform/cloud-docs/vcs/github) for help.
3. Select your repository and at the **Workspace Settings** page in the **Terraform Working Directory** section, fill in `terraform-base`, click **Update VCS settings** in the bottom of the page to save. This will start a Terraform run.
4. Apply the run and once completed, continue to the next section

## Sign in to HCP Vault

Go to HCP and click on you HCP vault cluster, in the **Quick actions** section, and the **New admin token**, click on **Generate token** to copy an admin token to your clipboard.  
Click the button on the right that says **Access Vault** followed by **Launch web UI** and sign in with the token you just copied, continue to the next section to create a secret.

## Create Vault secret

1. Go to your `terraform-create` workspace.
2. Go to **Settings** for the workspace and click on **Version Control**, here you will click on **Connect to version control** --> **Version control workflow** and choose your GitHub repository, see [this example](https://developer.hashicorp.com/terraform/cloud-docs/vcs/github) for help.
3. Select your repository and at the **Workspace Settings** page in the **Terraform Working Directory** section, fill in `terraform-create`, click **Update VCS settings** in the bottom of the page to save. This will start a Terraform run.
4. Apply the run and once completed, have a look at your newly created secret in the HCP Vault UI.
5. Continue to the next section.

## Import Vault secret

For this section, we are going to interact with Terraform Cloud from the CLI, follow [these steps](https://developer.hashicorp.com/terraform/tutorials/cloud-get-started/cloud-login) to log in.

Go to the import directory.

```sh
cd learn-terraform-aws-instance
```

Initialise Terraform and select the workspace `terraform-import`

```terraform
terraform init
```

Have a look at the import block in the file `import.tf`

```sh
cat import.tf
```

Now, let's use Terraform to generate configuration for us to be able to import the resources.

```terraform
terraform plan -generate-config-out=generated.tf
```

In this example we will receive the following error that we'll have to attend prior to import the resource into our state:

> Error: Missing required argument
>
> &nbsp;&nbsp;&nbsp;&nbsp;with vault_kv_secret_v2.example,  
> &nbsp;&nbsp;&nbsp;&nbsp;on generated-run-FEGsALeQm3YmqtVW.tf line 2:  
> &nbsp;&nbsp;&nbsp;&nbsp;(source code not available)  
>
> The argument "data_json" is required, but no definition was found.

To fix it, either try this yourself or use my fixed version of the `generated.tf` file.  
Look at the file `generated.tf.fixed` as reference.  

To instead use the prepared one, do the following command:

```sh
cp generated.tf.fixed generated.tf
```

Now you can run Terraform to verify what changes Terraform intends to do:

```terraform
terraform apply
```

Once verified you can go ahead and write `yes` in the prompt, I have added an update to the secret that we after the apply can verify in HCP Vault.  
The plan should read:

```terraform
Plan: 3 to import, 0 to add, 1 to change, 0 to destroy.
```

Now go to HCP vault and refresh the page to see the new version of the secret!

Feel free to play around with this and update the code in the `terraform-create` and `terraform-import` folder, if you are running the plus plan in your organisation you can also trigger a health check to discover [terraform drift](https://www.hashicorp.com/campaign/drift-detection-for-terraform-cloud).

## Cleanup

When you are done with this demo, all you have to do is to [trigger a destroy plan](https://developer.hashicorp.com/terraform/tutorials/cloud-get-started/cloud-destroy) in the `terraform-base` workspace and the Vault cluster and the HVN will be removed from HCP.

## Authors

**Emil Engfors** - *Initial work*
