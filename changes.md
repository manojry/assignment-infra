# DocuFlow Infrastructure - Change Log

## Quick Start
```bash
terraform plan -var-file="inputs/prod.tfvars"
terraform apply -var-file="inputs/prod.tfvars"
```

## Project Structure

Organized infrastructure code into separate files for easier maintenance:

```
assignment-infra/
├── main.tf           # VPC, subnets, route tables, NAT gateway
├── ecs.tf            # ECS cluster, services, ALB, auto-scaling
├── rds.tf            # PostgreSQL database, security groups
├── rbac.tf           # IAM roles and policies
├── data.tf           # Data sources (Secrets Manager, etc.)
├── providers.tf      # AWS provider configuration
├── variables.tf      # Variable definitions
├── outputs.tf        # Output values
├── terraform.tfvars.example
└── inputs/
    ├── dev.tfvars
    └── prod.tfvars
```

---

## Changes Made

### Database (rds.tf)
- **Private subnets**: RDS now runs in private subnets only, no internet access
- **Security**: Database security group only allows connections from ECS tasks
- **Multi-AZ**: Enabled for high availability
- **Storage**: Changed to GP3 for better performance
- **Secrets**: Password stored in AWS Secrets Manager with KMS encryption
- **Subnet group**: Uses only private subnets across multiple availability zones

### Container Service (ecs.tf)
- **Load balancer**: Added ALB to distribute traffic across ECS tasks
- **ALB security**: Separate security group for ALB (currently allows internet traffic)
- **Target group**: Health checks configured for container endpoints
- **Service integration**: ECS service connected to ALB target group
- **Auto-scaling**: CPU-based scaling (1-20 tasks) with 5-minute cooldown periods
- **Multi-AZ deployment**: Tasks spread across multiple availability zones

### Networking (main.tf)
- **NAT Gateway**: Private subnets can access internet for updates
- **Private routing**: Separate route table for private subnets
- **CloudWatch logs**: VPC and ECS logs with 7-day retention

---

## Future Improvements

### Security
- Add WAF to protect ALB from common web attacks
- Restrict ALB security group to known IP ranges
- Configure cloudwatch alarms for ecs service and rds instance
- Create IAM role for terraform so that role is used for terraform operations instead of access keys.