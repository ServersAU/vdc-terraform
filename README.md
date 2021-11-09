# Servers Australia - VDC Terraform Demo

This is a demo terraform repo to illustrate the usage of Terraform with the Servers Australia "Virtual Datacentre" Platform. This code, and any examples included, should not be used for production environments. 

Written by Ben King for Servers Australia, 2021. 


# Contents

This repo consists of: 
 - ```/main.tf```: The main terraform file. In here, you establish the intended configuration, including VMs, Networks, and Firewall Rules. 
 - ```/variables.tf```: A supplementary file. In here, you set applicable variables for your environment, including CPU, RAM and IP information. 
 - ```/secret.tfvars```: This file holds your password for the vdc environment, along with the VM passwords. This is provided to assist with a "quick start" tutorial, never store your passwords in plaintext in a production environment. Variables have been left blank for you to fill in the passwords yourself. 

# Getting Started

Firstly, install terraform on your system. If you are on MacOS, homebrew can be used with: 

```
# brew install hashicorp/tap/terraform
```

Once installed, prepare your folder with: 

```
# terraform init
```

This will prepare your environment and create a .hcl lock file and .terraform folder. 


## Update your variables

Navigate to the variables.tf file. At a minimum, update the following variable types in the "default" section: 

 - ```vcd_user```: replace "cid-1234" with your **Username** (as shown in the MySAU Services portal)
 - ```vcd_org```: replace "cid-1234" with your **Organisation** name (as shown in the MySAU Services portal)
 - ```vcd_vdc```: replace "SAU-XXXXX-VD" with your **Virtual Data Centre** name (as shown in the MySAU Services portal)
 - ```nsx_edge```: Similar to above, replace "SAU-XXXXX-VD-nsx-edge" with your **Virtual Data Centre** name, appending -nsx-edge. 

![MySAU Details](/images/org_and_vdc_details.png)


## Set your Passwords

For production environments, it is recommended to use a secure form of password management. For now, we'll use a seperate variables file and input our passwords. Define the following: 

- ```vcd_pass```: The password you setup for your login. This can be reset in the MySAU portal under "Reset Password". 
- ```app1_os_password```: A random string or set password you'll use for the app1 VM. 
- ```db1_os_password```: Another random string or set password you'll use for the db1 VM. 

# Planning the Configuration

```
# terraform plan -var-file="secret.tfvars"
```

Terraform will read your main.tf file, fill in the variables from your variable file and secret file, and present any planned additions, changes or deletions. We want to add five things: 
- A new Routed Network (vcd_network_routed_v2.routed_network)
- A new vApp (vcd_vapp.terraform_vapp)
- An  organisational network for the vApp (vcd_vapp_org_network.vapp_network)
- The app1 VM (vcd_vapp_vm.app1)
- The db1 VM (vcd_vapp_vm.db1)

You should see a line confirming these file items will be created: 
```
Plan: 5 to add, 0 to change, 0 to destroy.
```

# Applying the Configuration

If we are happy to proceed, run the below to begin: 

```
# terraform apply -var-file="secret.tfvars"

<omitted for brevity>
Plan: 5 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.
```
It will prompt for a final "yes" from you, then it will proceed to create the infrastructure. 
