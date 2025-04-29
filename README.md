# 🎂 Hello Birthday API – Infrastructure Config Repo

[![Terraform Plan and on PR](https://github.com/cerepx/hello-birthday-api-config-repo/actions/workflows/terraform-plan.yml/badge.svg)](https://github.com/cerepx/hello-birthday-api-config-repo/actions/workflows/terraform-dev.yml)
[![Terraform Plan and Apply (Prod)](https://github.com/cerepx/hello-birthday-api-config-repo/actions/workflows/terraform-apply.yml/badge.svg)](https://github.com/cerepx/hello-birthday-api-config-repo/actions/workflows/terraform-prod.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

> Infrastructure as Code (IaC) for deploying the [Hello Birthday API](https://github.com/cerepx/hello-birthday-api) to AWS using Terraform and GitHub Actions.

---

## 🚀 Purpose

This repository automates the provisioning and deployment of the Hello Birthday API on AWS.

- Uses **modular Terraform** to define and manage infrastructure.
- Integrates **GitHub Actions** to handle CI/CD for both `dev` and `prod`.
- Automatically manages **container image versioning**, builds, and deployments.

---

## 🏗️ Architecture

The deployed infrastructure looks like this:

Client → API Gateway → ALB → ECS (Fargate) → RDS (MySQL)


| Component        | Description                                                                 |
|------------------|-----------------------------------------------------------------------------|
| API Gateway      | Public entrypoint for HTTP requests.                                        |
| ALB              | Internal Application Load Balancer for routing traffic to ECS services.     |
| ECS (Fargate)    | Runs containerized Hello Birthday API application.                          |
| RDS              | MySQL database used to store user data (e.g., birth dates).                 |
| GitHub Actions   | CI/CD automation for Terraform plan and apply workflows.                    |

---

## ⚙️ Components Overview

### 📦 Terraform Modules
This repo defines reusable modules for:
- VPC
- Subnets
- Security Groups
- ALB & Listener
- ECS Cluster & Services
- RDS Instance
- API Gateway + VPC Link

### 🔁 GitHub Actions CI/CD

| Branch      | Event         | Pipeline              | Action                      |
|-------------|---------------|-----------------------|-----------------------------|
| `main`      | PR created    | terraform-plan.yml     | Terraform Plan (Dev)        |
| `main`      | PR merged     | terraform-apply.yml    | Terraform Apply (Dev)       |
| `release`   | PR created    | terraform-plan.yml     | Terraform Plan (Prod)       |
| `release`   | PR merged     | terraform-apply.yml    | Terraform Apply (Prod)      |

> 🚧 Each environment (Dev & Prod) runs its own Terraform Plan and Apply — fully automated via GitHub Actions.

---

## 🔄 Image Versioning & Deployment Flow

The `hello-birthday-api-config-repo` is closely integrated with the application repository [hello-birthday-api](https://github.com/cerepx/hello-birthday-api) for continuous delivery.

1. [hello-birthday-api](https://github.com/cerepx/hello-birthday-api) builds and publishes the Docker image to **GitHub Packages** on every release.
2. When a new image tag is published, the `dependencies.yml` file in this repo is automatically updated via a PR — triggered from the app repo.
3. That PR triggers the **Terraform Plan pipeline for Dev**, which:
   - Pulls the new image from GitHub Packages.
   - Pushes it to **AWS ECR**.
   - Prepares the ECS task definition with the new image tag.
4. When the PR is merged to `main`, the **Apply pipeline for Dev** runs and:
   - Deploys the new ECS task using the image from ECR.
   - Rolls out the new version live in the **Dev environment**.

> ✅ This automation ensures the latest app image is tested and deployed continuously with full visibility and approval steps via GitHub Pull Requests.

---

## 📂 Directory Structure

```text
.github/
  workflows/                    # Workflows for terraform plan & apply
    terraform-plan.yml
    terraform-apply.yml

infrastructure/
  backends/                     # Terraform backend config for each env
    backend-dev.hcl
    backend-prod.hcl

terraform/
  modules/
    alb/
    ecs_cluster/
    ecs_service/
    rds/
    vpc/
    apigateway/

dependencies.yml                # Tracks container image tags
README.md
LICENSE
```

---

## 📜 License
This project is licensed under the MIT License.

---

## 🧠 Notes for Contributors

- 🛠 All changes must go through **Pull Requests** — no direct commits to `main` or `release`.
- 🌱 Follow the branch naming convention:
  - `feature/*` – for new features
  - `bugfix/*` – for fixing bugs
  - `hotfix/*` – for production-level urgent changes
- 🔒 The `main` and `release` branches are protected and managed through CI pipelines:
  - `main` → triggers **Dev** plan/apply
  - `release` → triggers **Prod** plan/apply
- 🔁 Each PR triggers the appropriate **Terraform Plan**; merges trigger **Apply**.

---

## 💡 Acknowledgments

🛠 Built Using

- [Terraform](https://www.terraform.io/) — infrastructure as code tool used to provision AWS resources.
- [GitHub Actions](https://github.com/features/actions) — CI/CD automation for planning and applying infrastructure.
- [AWS](https://aws.amazon.com/) — cloud platform hosting the full application stack.
- [GitHub Packages](https://docs.github.com/en/packages) — container registry where Docker images are published and consumed.