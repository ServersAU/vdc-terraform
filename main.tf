terraform {
  required_providers {
    vcd = {
      source = "vmware/vcd"
      version = "3.3.1"
    }
  }
}

# Configure the VMware Cloud Director Provider
provider "vcd" {
  user                 = var.vcd_user
  password             = var.vcd_pass
  auth_type            = "integrated"
  org                  = var.vcd_org
  vdc                  = var.vcd_vdc
  url                  = "https://vcd.servercontrol.com.au/api"
  max_retry_timeout    = "600"
  allow_unverified_ssl = false
}

# Set a Data Value for the current NSX-T Gateway
data "vcd_nsxt_edgegateway" "nsx_edge" {
  org  = var.vcd_org
  vdc  = var.vcd_vdc
  name = var.nsx_edge
}

# Create the initial "vApp"
resource "vcd_vapp" "terraform_vapp" {
  name = var.vapp_name
  power_on = true
}

resource "vcd_network_routed_v2" "routed_network" {
  org         = var.vcd_org
  vdc         = var.vcd_vdc
  name        = var.routed_network
  description = ""

  edge_gateway_id = data.vcd_nsxt_edgegateway.nsx_edge.id

  gateway       = "192.168.99.1"
  prefix_length = 24

  static_ip_pool {
    start_address = "192.168.99.2"
    end_address   = "192.168.99.254"
  }
}

# Create a vApp Org Network, connect to the Org Network
resource "vcd_vapp_org_network" "vapp_network" {
  depends_on = [vcd_vapp.terraform_vapp, vcd_network_routed_v2.routed_network]
  vapp_name        = var.vapp_name
  org_network_name = vcd_network_routed_v2.routed_network.name
}

# Create app1 in the vApp, wait until the vApp and Networking exists
resource "vcd_vapp_vm" "app1" {

  # Wait until the vApp exists and the network is deployed. 
  depends_on = [vcd_vapp.terraform_vapp, vcd_vapp_org_network.vapp_network]
  vapp_name     = var.vapp_name
  name          = var.app1_name

  # This will be set in Guest Customization
  computer_name = var.app1_name
  
  # Define catalog data
  catalog_name        = "Linux Distros"
  template_name       = "AlmaLinux 8"
  vm_name_in_template = "Alma8"

  # Define VM/vApp resources
  memory        = var.app1_memory
  cpus          = var.app1_cpu

  # Set OS Type and Version for VCD's reference
  os_type = "rhel8_64Guest"
  hardware_version = "vmx-19"

  # Set app1 IP, using app1_ip variable
  network {
    type               = "org"
    name               = var.routed_network
    ip_allocation_mode = "MANUAL"
    ip                 = var.app1_ip
    is_primary         = true
  }
  # app1s Disk
  override_template_disk {
    bus_type         = "paravirtual"
    size_in_mb       = "20000"
    bus_number       = 0
    unit_number      = 0
    iops             = 0
    storage_profile  = "Tier 1 - Hot (SSD)"
  }
  # Set customization options
  customization {
    auto_generate_password = false
    admin_password = var.app1_os_password
  }
}

resource "vcd_vapp_vm" "db1" {

  # Wait until the vApp exists and the network is deployed. 
  depends_on = [vcd_vapp.terraform_vapp, vcd_vapp_org_network.vapp_network]
  vapp_name     = var.vapp_name
  name          = var.db1_name

  # This will be set in Guest Customization
  computer_name = var.db1_name
  
  # Define catalog data
  catalog_name        = "Linux Distros"
  template_name       = "AlmaLinux 8"
  vm_name_in_template = "Alma8"

  # Define VM/vApp resources
  memory        = var.db1_memory
  cpus          = var.db1_cpu

  # Set OS Type and Version for VCD's reference
  os_type = "rhel8_64Guest"
  hardware_version = "vmx-19"

  # Set Network Values. Go Manual and use the db1_ip variable
  network {
    type               = "org"
    name               = var.routed_network
    ip_allocation_mode = "MANUAL"
    ip                 = var.db1_ip
    is_primary         = true
  }
  # Associated db1's disk
  override_template_disk {
    bus_type         = "paravirtual"
    size_in_mb       = "40000"
    bus_number       = 0
    unit_number      = 0
    iops             = 0
    storage_profile  = "Tier 1 - Hot (SSD)"
  }
  # Set customization options
  customization {
    auto_generate_password = false
    admin_password = var.app1_os_password
  }
}
