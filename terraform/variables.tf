variable "region" {
    description = "AWS Region"
    type = string
    default = "us-east-1"  
}

variable "cluster_name" {
    description = "Name of EKS cluster"
    type = string
      default = "gitops-eks-cluster"
}


variable "vpc_cidr_block" {
    description = "CIDR range block"
    type = string
    default = "10.0.0.0/16"
}