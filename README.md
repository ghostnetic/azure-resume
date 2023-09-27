# Cloud Resume - Azure

## Steps Completed

**1. Azure Certification**
- [x] **Complete**
* Acquired the [**Microsoft Certified: Azure Fundamentals**](https://learn.microsoft.com/en-us/users/drathell-8407/credentials/d0708f3ebf976c07) certification, demonstrating a foundational understanding of Azure cloud services and solutions.

**2. HTML & CSS Enhancement** 
- [x] **Complete**
- Utilizing a template, I converted my resume into a web-compatible **HTML format**. To ensure a pleasant and universally accessible user experience, I integrated **CSS styling**, enriching the visual presentation without overcomplicating the design.
- ***Note: Still need to finish the projects section, for the projects displayed are NOT my work.***

**3. Deployment as a Static Website**
- [x] **Complete**
* Hosted the HTML resume online utilizing **Azure Storage** as a static website platform.
* This step is crucial as it utilizes Azure's native capability to host static content, rather than relying on third-party platforms like Netlify or GitHub Pages.

**5. Securing with HTTPS**
- [x] **Complete**
- Prioritized security by ensuring that the Azure Storage website URL uses **HTTPS**.
- Achieved this secure connection with the help of **Azure CDN**, which facilitates SSL termination for custom domains linked to Azure Blob Storage.

**6. Custom DNS Integration**
- [X] **In Progress**
- Configured a custom domain, which can be found [**here**](https://resume.davidrathell.dev/), to point to the Azure CDN endpoint.
- This step offers a personalized web address for accessing the resume, enhancing its professional look. The domain registration typically incurs a small fee.

**7. Infrastructure Automation with Terraform**
- [ ] **In Progress**
- Utilized **Terraform**, an Infrastructure as Code (IaC) tool, to script, plan, and apply the infrastructure setup.
- This approach introduces automation and repeatability, ensuring infrastructure consistency and streamlining any modifications or scaling in the future.

**8. HTTPS Configuration with Nginx Reverse Proxy**
- [ ] **In Progress**
- Set up an **Nginx server** as a reverse proxy to enhance security and performance.
- With Terraform scripts, automated the provisioning of this server, demonstrating an integrated approach to infrastructure and application deployment.
