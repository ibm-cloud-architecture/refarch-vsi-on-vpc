## Data & Storage

The Data and Storage aspect describes the block and object storage and data services for this example. It includes a description of the network connectivity, backup & restore, roles and capabilities to provide data and storage in IBM Cloud.

---

### Architecture diagram

![Arhitecture](../imgs/data_storage.png)

---
  
## Data and Storage Capabilities

  
- [Block Volume](https://cloud.ibm.com/docs/vpc-on-classic-block-storage?topic=vpc-on-classic-block-storage-getting-started): This solution creates a single volume for each VSI using encryption. [Backup](https://cloud.ibm.com/docs/vpc-on-classic-block-storage?topic=vpc-on-classic-block-storage-block-storage-vpc-faq) can be performed on the volumes.


- [Cloud Object Storage](https://cloud.ibm.com/docs/cloud-object-storage?topic=cloud-object-storage-about-cloud-object-storage): This solution demonstrates the ability of the application deployed into the virtual services to read/write to the object storage resource using private networks.


- [PostgreSQL database](https://cloud.ibm.com/docs/key-protect?topic=key-protect-getting-started-tutorial): This solution demonstrates the ability of the application deployed into the virtual services to read/write to the PostgreSQL data service resource using private networks.

