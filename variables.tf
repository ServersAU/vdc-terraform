variable "vcd_user" {
    description = "Your login username for the vCloud Director platform"
    type = string
    default = "cid-1234"
}

variable "vcd_pass" {
    description = "Your password for the vCloud Director platform. Refer to the secret.tfvars file to provide this."
    type = string
    sensitive = true
}

variable "vcd_org" {
    description = "The unique organisation name. Can be seen in the MySAU portal. "
    type = string
    default = "cid-1234"
}

variable "vcd_vdc" {
    description = "The unique VDC name. Can be seen in the MySAU portal"
    type = string
    default = "SAU-11111-VD"
}

variable "nsx_edge" {
    description = "The NSX edge for the VDC platform."
    type = string
    default = "SAU-11111-VD-nsx-edge"
}

variable "routed_network" {
    description = "The name for network which connects to the NSX edge gateway."
    type = string
    default = "vDC Network"
}

variable "vapp_network" {
    description = "The name for the vApp network we'll be creating."
    type = string
    default = "vApp Network"
}

# The encompassing "vApp" name, which will hold both app1 and db1 VMs. 
variable "vapp_name" {
    description = "A name for your encompassing vApp"
    type = string
    default = "My vApp"
}

# APP1 Variables, including VM Name, CPU, Memory, and Static IP. 

variable "app1_name" {
    description = "The name of the VM as noted in vCloud Director"
    type = string
    default = "app1"
}

variable "app1_cpu" {
    description = "CPU count of virtual CPUs. Recommended for a minimum of 1"
    type = string
    default = 1
}

variable "app1_memory" {
    description = "The value in MB of how much memory this VM will have"
    type = number
    default = 1024
}

variable "app1_ip" {
    description = ""
    type = string
    default = "192.168.99.10"
}

variable "app1_os_password" {
    description = "A password to set for the O.S. during customization setup. Set this in the secrets.tfvars file."
    type = string
    sensitive = true
}

# DB1 Variables, including VM Name, CPU, Memory, and Static IP. 

variable "db1_name" {
    description = "The name of the VM as noted in vCloud Director"
    type = string
    default = "db1"
}

variable "db1_cpu" {
    description = "CPU count of virtual CPUs. Recommended for a minimum of 1"
    type = string
    default = 1
}

variable "db1_memory" {
    description = "The value in MB of how much memory this VM will have"
    type = number
    default = 1024
}

variable "db1_ip" {
    description = ""
    type = string
    default = "192.168.99.20"
}

variable "db1_os_password" {
    description = "A password to set for the O.S. during customization setup. Set this in the secrets.tfvars file."
    type = string
    sensitive = true
}