variable "environment_tag" {
    type = string
    default = "NPE"
    description = "The type of environment."
}

variable "region" {
    type = string
    default = "EastUS"
    description = "The Azure region the VNET will be placed in."
}

variable "app_name" {
    type = string
    default = "FancyApp"
    description = "The name for the application using the resources."
}

variable "vnet_cidr" {
    type = string
    default = "10.1.0.0/16"
    description = "The CIDR address for the Azure VNET."
}

variable "public_subnet_name" {
    type = string
    default = "public"
    description = "The name for the public facing subnet in the VNET."
}

variable "enable_public_subnet" {
    type = bool
    default = true
    description = "Enables a public facing subnet."
}

variable "enable_remote_gateways" {
    type = bool
    default = false
    description = "Enables a remote gateway transit on peered connection."
}

variable "public_subnet" {
    type = string
    default = "10.1.0.0/24"
    description = "The CIDR block for the public subnet."
}

variable "app_subnet_name" {
    type = string
    default = "app"
    description = "The name for the application subnet in the VNET."
}

variable "app_subnet" {
    type = string
    default = "10.1.1.0/24"
    description = "The CIDR block for the application subnet."
}

variable "data_subnet_name" {
    type = string
    default = "data"
    description = "The name for the data subnet in the VNET."
}

variable "data_subnet" {
    type = string
    default = "10.1.2.0/24"
    description = "The CIDR block for the data subnet."
}

variable "hub_vnet_name" {
    type = string
    default = "EastUS-MGMT-VNET"
    description = "The name of the Hub VNET to peer with."
}

variable "hub_vnet_rg" {
    type = string
    default = "EastUS-Network-Hub-RG"
    description = "The name of the Hub VNET Resource Group."
}