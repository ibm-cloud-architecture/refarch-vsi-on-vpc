# Deploy workloads on virtual servers in an IBM Cloud VPC


## Solution description

This reference solution describes the services and best practices to provision highly available, secured virtual server instance-based workloads into IBM Cloud using a Virtual Private Cloud. For specific strategies on deploying resilient applications see [this article on IBM Cloud Docs](https://cloud.ibm.com/docs/tutorials?topic=solution-tutorials-strategies-for-resilient-applications). The **workloads on virtual servers in an IBM Cloud VPC** solution describe each of the essential aspects of the architecture including Security, Networking, Access, Data & Storage, Fabric/Compute and Operations. This contains the scripts your team can use to immediately provision and explore the solution to plan and design your IBM Cloud environments. 

---

![reference solution](/imgs/overall.png)

---


## Aspects

To explain the capabilities of this solution we use architecture aspects that provide a diagram, textual explanations and links to documentation for the service components of the architecture. In addition to design and documentation, the aspects include the infrastructure code used to implement the design. You can use these aspects to explain the solution to different stakeholders. The aspects are outlined below and align to the infrastructure code also maintained in this repository. The Architecture aspects for this solution include:

 - [Networking](/aspects/networking.md): Describes the regional (multi-zone) network architecture used for this solution.
 
 - [Fabric/compute](/aspects/compute.md): Describes the IBM Cloud fabric and compute services capabilities, integration and controls used in this solution.
 
 - [Access](/aspects/access.md): Describes the account, access/resource group, organization and user/role model used in this solution to control access to the services and resource instances.
 
 - [Security](/aspects/security.md): Describes the security services and configuration to meet environment isolation, network segregation and application security used in this solution.
 
 - [Data & Storage](/aspects/data_storage.md): Describes the IBM Cloud data and storage services, capabilities, integration and controls used in this solution.
 
 - [Devops/Operations](/aspects/operations.md):  Describes the services used to deliver, change, monitor and manage the solution environment defined in this solution.


### Steps to provision this solution

1. Complete the [tutorial](https://www.ibm.com/cloud/architecture/architectures/public-cloud) for provisioning resources to IBM Cloud with terraform.

2. Build the [IBM Cloud provider for Terraform](https://github.com/IBM-Cloud/terraform-provider-ibm) container and clone this repository into the container.

3. Add your values for the variables in the [variables.tf](infrastructure_code/variables.tf) file.

4. Run terraform plan and apply. 


### Authors and Editors:

- [Vidhi Shah](Vidhi.Shah@ibm.com), IBM GCAT Cloud Solution Developer
- [Jennifer Valle](Jennifer.Valle@ibm.com), IBM GCAT Cloud Solution Developer
- [Steve Cotugno](https://www.ibm.com/cloud/garage/experts/stevecotugno), IBM Solution Architect

Enjoy!
