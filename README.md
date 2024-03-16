# Setup an AWS IaC pipeline using AWS CodePipeline

This project uses [AWS CodePipeline](https://docs.aws.amazon.com/codepipeline/latest/userguide/welcome.html) to automatically build and deploy AWS infrastructure-as-code (IaC) changes. Both [Terraform](https://terraform.io) and [AWS CloudFormation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html) are used to deploy resources in an AWS account, allowing you to compare and experiment with the approaches.

Resources deployed include:
- S3 Bucket
- SQS Queue w/ DLQ

![AWS IaC Deployment Pipeline](/docs/aws-cicd-arch.png "AWS IaC Deployment Pipeline")

| | |
|-|-|
|📝 `NOTE` | _**Follow these instructions to setup an IaC pipeline in your own AWS account.**_|
| | |

## Setup your GitHub.com repository

1. Download the [latest release](https://github.com/robsable/aws-iac-pipeline/archive/refs/heads/main.zip) of this project from GitHub.com and extract on your local drive.
1. Edit the `aws-tf-cicd-main/terraform/providers.tf` file to set values for the S3 backend:
   - **bucket** - the name of your S3 bucket
   - **region** - the AWS Region you're working in
1. Edit the `aws-tf-cicd-main/terraform/variables.tf` file to set values for the following:
   - **aws_region** - the AWS Region you're working in
   - **app_name** - a unique name of your choice
   - **app_env** - the environment you're working in (`dev`, `test`, or `prod`)

1. Create a new public or private GitHub repository using the contents of the `aws-iac-pipeline-main` directory.

## Connect AWS to GitHub.com

1. Sign in to the AWS Management Console
1. Open the [Developer Tools Console](https://console.aws.amazon.com/codesuite/settings/connections)
1. Follow [these instructions](https://docs.aws.amazon.com/dtconsole/latest/userguide/connections-create-github.html#connections-create-github-console) to create a connection to GitHub.com
1. Once your connection is setup, note the Connection ID which you will need in a later step. The Connection ID is the 36 character string at the end of the Connection ARN.

## Deploy the CodePipeline

1. In the AWS Management Console we'll [create a CloudFormation Stack](https://console.aws.amazon.com/cloudformation/home#/stacks/create) to deploy our pipeline and associated resources.
1. Specify a template by choosing **Upload a template file** and then the **Choose file** button.
1. Select the `aws-tf-cicd-main/cloudformation/pipeline-setup.yml` file from your local drive and choose **Next**.
1. Specify stack details and choose **Next**.
   - **Stack name** - a unique name of your choice
   - **AppName** - a unique name of your choice
   - **ConnectionID** - the 36 character Connection ID you captured earlier
   - **SourceRepo** - full path to your GitHub.com repo (*Example*: `some-user/my-repo`)
1. Choose **Next** again to accept default options.
1. Scroll to the bottom of the page, acknowledge the checkbox, and choose **Submit**.

## Review CodePipeline Execution History

1. Navigate to the [Pipelines](https://console.aws.amazon.com/codesuite/codepipeline/pipelines) list in the AWS Management Console.
1. Find the pipeline named `AppName`-pipeline to see details and results

![AWS CodePipeline](/docs/testapp-pipeline.png "AWS CodePipeline")

## Code, Build, Deploy, Repeat

At this point you're ready to start adding your own IaC resources using CloudFormation and Terraform. Each time your code is checked in to your GitHub.com repostitory, an AWS CodePipeline will automatically be triggered.

Follow these same setup steps in different AWS accounts to setup IaC pipelines for each of your applications and environments.

## Clean Up

1. Delete build artifacts
   - Go to the [S3 buckets](https://s3.console.aws.amazon.com/s3/buckets) list in the AWS Management Console.
   - Find the S3 bucket named `<AppName>-<AWS_ACCOUNT_ID>-build-artifacts`.
   - Select the bucket and choose and **Empty** to delete its contents.

1. Destroy Terraform resources
   - Go to the [CodeBuild projects](https://us-east-1.console.aws.amazon.com/codesuite/codebuild/projects) list in the AWS Management Console.
   - Select your project from the list and choose **View Details**.
   - Choose the **Edit** button in the top right and scroll down to the **Buildspec** section.
   - Choose the **Use a buildspec file** option and enter `cleanup.yml` in the text field.
   - Scroll to the bottom and choose **Update project**.
   - Return to the [Pipelines](https://console.aws.amazon.com/codesuite/codepipeline/pipelines) list, select your pipeline, and choose **Release Change**.
   - View the build results to confirm removal of Terraform resources. 

1. Delete CloudFormation stacks
   - Go to the [CloudFormation stacks](https://console.aws.amazon.com/cloudformation/home#/stacks/) list in the AWS Management Console.
   - Delete the **IaC pipeline example resources** stack
   - Delete the **Automated IaC build and release pipeline** stack

1. Delete GitHub.com connection
   - Go to the [Connections](https://console.aws.amazon.com/codesuite/settings/connections) list in the AWS Management Console.
   - Select the connection you created and choose **Delete**.
