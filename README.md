# Terraform on Azure: Automated Infrastructure

## 📌 Overview
This project provisions a basic Azure infrastructure using **Terraform** on **Azure**.  
It demonstrates **Infrastructure as Code (IaC)** fundamentals by creating:  
- A resource group  
- A virtual network and subnet  
- A network security group with inbound rules  
- A public IP and NIC  
- A Linux VM  

The goal was to show how cloud resources can be automated, repeatable and secure instead of being created manually in the Azure portal.

## 🛠️ Tech Stack
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![Azure](https://img.shields.io/badge/Azure-0089D6?style=for-the-badge&logo=microsoft-azure&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)

## 📂 Project Structure
**terraform-azure-infra/**  
├─ **main.tf**              - All Terraform resources  
├─ **outputs.tf**           - Outputs (VM name, Public IP)  
├─ **README.md**            - Project write-up  
├─ **.gitignore**           - Terraform state ignored  
├─ **screenshots/**         - Deployment proof images  

## 🌍 Real-World Relevance
This project reflects common tasks for cloud and DevOps engineers:
- **Infrastructure as Code (IaC):** allows teams to standardise and automate deployments  
- **Networking:** VNets and subnets provide secure isolation  
- **Security:** NSGs enforce firewall rules for safe access  
- **Compute:** Virtual Machines are a core resource for applications and services  
- **Outputs:** provide quick access to important details without using the portal  

## ⚡ Features
- Full IaC deployment with Terraform  
- Resource group, VNet, subnet and NSG created automatically  
- Public IP and NIC assigned to a VM  
- Ubuntu Linux VM provisioned with tags  
- Outputs for VM name and public IP  

## 🚀 Deployment Steps
1. **Initialise project**
   ```bash
   terraform init
2. **Preview Changes**
   ```bash
   terraform plan
3. **Deploy Infrastructure**
   ```bash
   terraform apply