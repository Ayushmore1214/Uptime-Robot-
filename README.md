This is a complete, end-to-end project for deploying a full-stack application (React + Node.js) to Amazon EKS. The entire infrastructure is managed by Terraform, and deployments are automated with GitHub Actions.

## How to Run

### 1. Prerequisites
- AWS CLI
- Terraform
- `kubectl`
- Docker
- A GitHub repository with this code.

### 2. Terraform Setup
1.  Navigate to the `/terraform` directory.
2.  Create a file named `terraform.tfvars`.vv
3.  Add your variables to this file:
    ```tfvars
    db_password = "YourSuperStrongPassword123"
    github_repo = "YOUR_GITHUB_USERNAME/YOUR_REPO_NAME"
    ```
4.  Run `terraform init`.
5.  Run `terraform apply -var-file="terraform.tfvars"`. This will take 10-15 minutes.
6.  Note the outputs, especially `rds_endpoint` and `frontend_bucket_name`.

### 3. Kubernetes Secret
1.  In the `/kubernetes` directory, create `secret.yaml` from the template.
2.  Base64 encode your RDS credentials and endpoint from the Terraform output and paste them into the file.
3.  Connect to your EKS cluster: `aws eks update-kubeconfig --name k-stax-cluster --region us-east-1`
4.  Apply the secret: `kubectl apply -f kubernetes/secret.yaml`

### 4. GitHub Actions Setup
1.  In your GitHub repository settings, go to "Secrets and variables" -> "Actions".
2.  Create a new repository secret named `S3_BUCKET_NAME` and paste the `frontend_bucket_name` from your Terraform output as the value.
3.  In `.github/workflows/deploy.yml`, replace `YOUR_AWS_ACCOUNT_ID` with your actual AWS Account ID.

### 5. Deploy
1.  Commit and push all your code to the `main` branch.
2.  The GitHub Actions pipeline will automatically trigger, build your containers, and deploy to EKS and S3.
3.  After the pipeline succeeds, find the DNS name of the Application Load Balancer in the AWS EC2 Console.
4.  Update the `API_URL` in `frontend/src/App.js` with this DNS name.
5.  Commit and push this final change. The pipeline will redeploy the frontend.
6.  Visit your `frontend_url` from the Terraform output to see your live application!

### 6. CLEANUP
**THIS IS THE MOST IMPORTANT STEP.** To avoid AWS charges, run this command when you are done:
```bash
cd terraform
terraform destroy -var-file="terraform.tfvars"

