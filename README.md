![Ampere Computing](https://avatars2.githubusercontent.com/u/34519842?s=400&u=1d29afaac44f477cbb0226139ec83f73faefe154&v=4)

# terraform-oci-ampere-ai-demo-yolov5

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

# YOLOv5 Demo

After completing the instructions of **"Launching A1 Shape With Terraform"** below,
examine the IP address of the compute instance using Oracle Cloud Console. Usually, it will take a few minutes, after the
instance is provisioned, for docker container to be initialized and started. 

[![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/AmpereComputing/terraform-oci-ampere-yolov5/releases/download/latest/oci-ampere-yolov5-latest.zip)

## Demo URL on port 7000 ##

* Point browser to http://\<instance-ip>:7000/app
* The video should be displayed on the brower with the detection results.

# Lauching A1 Shape With Terraform

## Description

Terraform code to launch a Ampere A1 Shape on Oracle Cloud Infrastructure (OCI) Free-Tier with a Tensorflow DEMO workload running via Docker.

## Requirements

 * [Terraform](https://www.terraform.io/downloads.html)
 * [Oracle OCI "Always Free" Account](https://www.oracle.com/cloud/free/#always-free)



## What exactly is Terraform doing

The goal of this code is to supply the minimal ammount of information to quickly have working Ampere A1 instances on OCI ["Always Free"](https://www.oracle.com/cloud/free/#always-free).
To keep things simple, The root compartment will be used (compartment id and tenancy id are the same) when launching the instance.  

Addtional tasks performed by this code:

* Dynamically creating sshkeys to use when logging into the instance.
* Dynamically getting region, availability zone and image id..
* Creating necessary core networking configurations for the tenancy
* Rendering metadata to pass into the Ampere A1 instance to install and configure Docker and launch a Tensorflow workload
* Launch 1 Ampere A1 instance with 24GB RAM, 4 Cores, and pass in rendered metadata 
* Output IP information to connect to the instance.


To get started clone this repository from GitHub locally.

## Configuration with terraform.tfvars

The easiest way to configure is to use a terraform.tfvars in the project directory.  
Please note that Compartment OCID are the same as Tenancy OCID for Root Compartment.
The following is an example of what terraform.tfvars should look like:

```
tenancy_ocid = "ocid1.tenancy.oc1..aaaaaaaabcdefghijklmnopqrstuvwxyz1234567890abcdefghijklmnopq"
user_ocid = "ocid1.user.oc1..aaaaaaaabcdefghijklmnopqrstuvwxyz0987654321zyxwvustqrponmlkj"
fingerprint = "a1:01:b2:02:c3:03:e4:04:10:11:12:13:14:15:16:17"
```

### Using as a Module

This can also be used as a terraform module.   The following is example code for module usage:

```
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}

module "oci-ampere-tensorflow" {
  source                   = "github.com/amperecomputing/terraform-oci-ampere-tensorflow"
  tenancy_ocid             = var.tenancy_ocid
  user_ocid                = var.user_ocid
  fingerprint              = var.fingerprint
  private_key_path         = var.private_key_path
# Optional
# oci_vcn_cidr_block       = "10.2.0.0/16"
# oci_vcn_cidr_subnet      = "10.2.1.0/24"
# instance_prefix          = "ampere-yolov5"
# oci_vm_count             = "4"
# ampere_a1_vm_memory      = "8"
# ampere_a1_cpu_core_count = "1"
}

output "oci_ampere_a1_private_ips" {
  value     = module.oci-ampere-a1.AmpereA1_PrivateIPs
}
output "oci_ampere_a1_public_ips" {
  value = module.oci-ampere-a1.AmpereA1_PublicIPs
}
```

### Running Terraform

```
terraform init && terraform plan && terraform apply -auto-approve
```

### Additional Terraform resources for OCI Ampere A1

* Apache Tomcat on Ampere A1: [https://github.com/oracle-devrel/terraform-oci-arch-tomcat-autonomous](https://github.com/oracle-devrel/terraform-oci-arch-tomcat-autonomous)
* WordPress on Ampere A1: [https://github.com/oracle-quickstart/oci-arch-wordpress-mds/tree/master/matomo](https://github.com/oracle-quickstart/oci-arch-wordpress-mds/tree/master/matomo)

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_oci"></a> [oci](#provider\_oci) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [local_file.oci-ssh-privkey](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.oci-ssh-pubkey](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [oci_core_instance.ampere_a1](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_instance) | resource |
| [oci_core_internet_gateway.ampere_internet_gateway](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_internet_gateway) | resource |
| [oci_core_route_table.ampere_route_table](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_route_table) | resource |
| [oci_core_security_list.ampere_security_list](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_security_list) | resource |
| [oci_core_subnet.ampere_subnet](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_subnet) | resource |
| [oci_core_virtual_network.ampere_vcn](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_virtual_network) | resource |
| [random_uuid.random_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [tls_private_key.oci](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [oci_core_images.ubuntu-20_04-aarch64](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/core_images) | data source |
| [oci_identity_availability_domains.ads](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/identity_availability_domains) | data source |
| [oci_identity_regions.regions](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/identity_regions) | data source |
| [oci_identity_tenancy.tenancy](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/identity_tenancy) | data source |
| [template_file.cloud_config](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ampere_a1_cpu_core_count"></a> [ampere\_a1\_cpu\_core\_count](#input\_ampere\_a1\_cpu\_core\_count) | Default core count for Ampere A1 instances in OCI | `string` | `"4"` | no |
| <a name="input_ampere_a1_vm_memory"></a> [ampere\_a1\_vm\_memory](#input\_ampere\_a1\_vm\_memory) | Default RAM in GB for Ampere A1 instances in OCI Free Tier | `string` | `"24"` | no |
| <a name="input_fingerprint"></a> [fingerprint](#input\_fingerprint) | OCI Fingerprint ID for Free-Tier Account | `any` | n/a | yes |
| <a name="input_instance_prefix"></a> [instance\_prefix](#input\_instance\_prefix) | Name prefix for vm instances | `string` | `"ampere-yolov5"` | no |
| <a name="input_oci_vcn_cidr_block"></a> [oci\_vcn\_cidr\_block](#input\_oci\_vcn\_cidr\_block) | CIDR Address range for OCI Networks | `string` | `"10.3.0.0/16"` | no |
| <a name="input_oci_vcn_cidr_subnet"></a> [oci\_vcn\_cidr\_subnet](#input\_oci\_vcn\_cidr\_subnet) | CIDR Address range for OCI Networks | `string` | `"10.3.1.0/24"` | no |
| <a name="input_oci_vm_count"></a> [oci\_vm\_count](#input\_oci\_vm\_count) | OCI Free Tier Ampere A1 is two instances | `number` | `1` | no |
| <a name="input_private_key_path"></a> [private\_key\_path](#input\_private\_key\_path) | Local path to the OCI private key file | `any` | n/a | yes |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | OCI Tenancy ID for Free-Tier Account | `any` | n/a | yes |
| <a name="input_user_ocid"></a> [user\_ocid](#input\_user\_ocid) | OCI User ID for Free-Tier Account | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_AmpereA1_BootVolumeIDs"></a> [AmpereA1\_BootVolumeIDs](#output\_AmpereA1\_BootVolumeIDs) | Output the boot volume IDs of the instance |
| <a name="output_AmpereA1_PrivateIPs"></a> [AmpereA1\_PrivateIPs](#output\_AmpereA1\_PrivateIPs) | Output the private IPs of the instance |
| <a name="output_AmpereA1_PublicIPs"></a> [AmpereA1\_PublicIPs](#output\_AmpereA1\_PublicIPs) | Output the public IPs of the instance |
| <a name="output_OCI_Availability_Domains"></a> [OCI\_Availability\_Domains](#output\_OCI\_Availability\_Domains) | Output Availability Domain Results |
| <a name="output_Ubuntu-20_04-aarch64-latest_name"></a> [Ubuntu-20\_04-aarch64-latest\_name](#output\_Ubuntu-20\_04-aarch64-latest\_name) | Output OCI Ubuntu 20.04 Image Name |
| <a name="output_Ubuntu-20_04-aarch64-latest_ocid"></a> [Ubuntu-20\_04-aarch64-latest\_ocid](#output\_Ubuntu-20\_04-aarch64-latest\_ocid) | Output OCI Ubuntu 20.04 Image ID |
| <a name="output_cloud_init"></a> [cloud\_init](#output\_cloud\_init) | Ouput rendered Cloud-Init Metadata |
| <a name="output_oci_home_region"></a> [oci\_home\_region](#output\_oci\_home\_region) | Output the OCI home region |
| <a name="output_oci_ssh_private_key"></a> [oci\_ssh\_private\_key](#output\_oci\_ssh\_private\_key) | Output the OCI SSH Private Key |
| <a name="output_oci_ssh_pubic_key"></a> [oci\_ssh\_pubic\_key](#output\_oci\_ssh\_pubic\_key) | Output the OCI SSH Public Key |
| <a name="output_random_uuid"></a> [random\_uuid](#output\_random\_uuid) | Output the randomly generated uuid |
<!-- END_TF_DOCS -->

## References

* [https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm)
* [Where to Get the Tenancy's OCID and User's OCID](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#five)
* [API Key Authentication](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm#APIKeyAuth)
* [Instance Principal Authorization](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm#instancePrincipalAuth)
* [Security Token Authentication](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm#securityTokenAuth)
* [How to Generate an API Signing Key](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#two)
* [Bootstrapping a VM image in Oracle Cloud Infrastructure using Cloud-Init](https://martincarstenbach.wordpress.com/2018/11/30/bootstrapping-a-vm-image-in-oracle-cloud-infrastructure-using-cloud-init/)
* [Oracle makes building applications on Ampere A1 Compute instances easy](https://blogs.oracle.com/cloud-infrastructure/post/oracle-makes-building-applications-on-ampere-a1-compute-instances-easy?source=:ow:o:p:nav:062520CloudComputeBC)
* [scross01/oci-linux-instance-cloud-init.tf](https://gist.github.com/scross01/5a66207fdc731dd99869a91461e9e2b8)
* [scross01/autonomous_linux_7.7.tf](https://gist.github.com/scross01/bcd21c12b15787f3ae9d51d0d9b2df06)
* [Oracle Cloud Always Free](https://www.oracle.com/cloud/free/#always-free)
