variable "resource_group_name" {
  description = "The name of the resource group in which to create the resources."
  type        = string
}

variable "project_name_prefix" {
  description = "The prefix for the Project name."
  type        = string

}

variable "mysql_server_name" {
  description = "The name of the MySQL server."
  type        = string
  
}

variable "sku_name" {
  description = "The SKU name of the MySQL server."
  type        = string
  
}

variable "db_username" {
  description = "The administrator username of the MySQL server."
  type        = string  
  
}

variable "db_password" {
  description = "The administrator password of the MySQL server."
  type        = string
  
}   

variable "mysql_database_name" {
  description = "The name of the MySQL database."
  type        = string
  
}   

variable "vm_count" {
  description = "The number of virtual machines."
  type        = number
}

variable "vm_size" {
  description = "The size of the virtual machine."
  type        = string
  
}

variable "vm_username" {
  description = "The administrator username of the virtual machine."
  type        = string
  
}

variable "vm_password" {
  description = "The administrator password of the virtual machine."
  type        = string
  
}

variable "private_ips" {
  description = "The private IP addresses of the virtual machines."
  type        = list(string)
  default = [ "10.0.2.5","10.0.2.6" ]
  
}