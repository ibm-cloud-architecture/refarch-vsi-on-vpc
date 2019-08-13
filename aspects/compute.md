## Compute

The [virtual server instance (VSI)](https://cloud.ibm.com/docs/vpc-on-classic-vsi?topic=vpc-on-classic-vsi-getting-started) is used for the compute resource in this solution. The VSI is deployed into one of three zones and attached to a single subnet. The virtual server is a part of the load balancer pool and enabled to communicate to public internet via the public gateway.
---

![Architecture](../imgs/compute.png)

---

### Components

- [Subnet](https://cloud.ibm.com/docs/vpc-on-classic?topic=solution-tutorials-vpc-public-app-private-backend) This solution uses a single subnet for each zone that all VSIs in that zone are attached. The subnet is allocated a specific CIDR block for the anticipated resources.

- [Access cloud services](https://cloud.ibm.com/docs/vpc-on-classic?topic=vpc-on-classic-setting-up-access-to-your-classic-infrastructure-from-vpc): The solution deploys a VPC and sets it with classic access to enable VSI access to the security, data and storage service resources.

- [Management Services](https://cloud.ibm.com/docs/vpc-on-classic?topic=vpc-on-classic-at-events) This solution demonstrates the management service integrations you can then use to monitor the activities and data with each resource.
