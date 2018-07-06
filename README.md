
#### Description

- Terraform script will spin a new Linux machine on AWS and install lates Ansible version.


#### prerequisites

- Terraform Installed > 0.8.5.
- Copy the .pem key file to your terraform server.
- Create file name "terraform.tfvars" and define the following:
    -  AWS_ACCESS_KEY = "<aws access key>"
    -  AWS_SECRET_KEY = "<aws secret key>"
    -  AMI = "<amazon machine image>"
    -  INSTANCE_NAME = "<you ansible instance name>"
    -  PRIVATE_KEY_PATH = "<full path to your .pem key>"
    -  KEY_NAME = "<key name defined in aws>"
- create a folder name "create_ansible" and copy bot the terraform.tfvars and the ansible.tf file.

#### Installation

- terraform plan - checking for mistakes in the file structure. make sure there are no errors in output.
- terraform apply - build the Ansible server (process will take ~3min).



