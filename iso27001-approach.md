# ISO 27001 Compliance Approach

ISO/IEC 27001 is a standard for an **Information Security Management System (ISMS)**

My goal would not be to immediately implement every control. It would be to understand the current state of the infrastructure, identify the highest-risk gaps, and create a practical roadmap a small engineering team can execute, with security work integrated into normal engineering workflows rather than run as a separate compliance project.
 
Because the platform processes **sensitive personal data of young people** (special-category data under  GDPR), I would let the confidentiality and integrity of that data drive the risk weighting.

## Summary
 
My approach would be to:
 
1. Define the ISMS scope and map sensitive data flows
2. Stand up the minimal management layer (policy, roles, objectives)
3. Define a repeatable risk methodology and produce a Statement of Applicability
4. Inventory existing controls, using IaC and git history as ready-made evidence
5. Perform a gap assessment against Annex A (2022)
6. Prioritize improvements by risk, weighting sensitive personal data heavily
7. Integrate security work into existing engineering workflows
8. Manage suppliers and data-protection obligations explicitly
9. Deliver a roadmap with clear ownership, then operate the ISMS toward certification

## 1. Define scope and context

The first step is to define the ISMS scope: which systems, services, data, and teams are in and out of scope, and who the interested parties are (users, regulators, vendors, the board).

Based on the architecture, I would initially include:
 
- **Google Cloud Platform** : landing zone, workload projects, IAM, Cloud Run, networking, logging and monitoring
- **DigitalOcean** : managed databases, backups, access controls
- **Render** : hosted services, deployment pipelines
- **Vercel** : frontend applications, deployment workflows
- **GitHub** : source code, pull requests, CI/CD pipelines, secrets
- **Messaging / counselling channel** : the third-party services that carry user conversations (e.g. WhatsApp/SMS providers), since they process the most sensitive data

The objective is to agree the boundary before assessing controls, and to record the data flows for sensitive personal data across these systems.

## 2. Establish the ISMS foundation (Clause 5)
 
Even for a small team, certification requires a minimal management layer:
 
- A short, top-level **Information Security Policy** with visible management commitment
- Defined **security roles and responsibilities** (who owns the ISMS, who owns risk)
- Measurable **security objectives**
I would keep this lightweight and proportionate to the team size, enough to satisfy the standard without creating process the team won't follow.
 
## 3. Risk assessment and treatment methodology (Clause 6)
 
Before prioritizing anything, I would define a **repeatable risk method** so decisions are defensible to an auditor:
 
- Identify assets and the threats/vulnerabilities against them
- Score each risk by **likelihood × impact**, weighting confidentiality of sensitive personal data heavily
- Record everything in a **risk register** with a named **risk owner** per risk
- Choose a treatment per risk: mitigate, accept, transfer, or avoid
- Produce a **Statement of Applicability (SoA)** : the central ISO 27001 deliverable — mapping each Annex A control to applicable / not applicable, with justification and implementation status
## 4. Understand existing controls (evidence first)
 
Before proposing changes, I would assess what already exists. A major advantage here is that **most infrastructure is managed as code**, which means a significant portion of audit evidence already exists: Terraform defines the controls, and git history plus pull-request approvals are themselves the **change-management and access-control evidence** auditors ask for.
 
| Area | What I would check |
| --- | --- |
| Identity & access | MFA enabled? SSO? Service-account usage? Least privilege implemented? |
| Infrastructure | IaC coverage, environment separation, change-management process |
| Secrets | Secret Manager usage, rotation, no secrets in repositories |
| Logging | Audit logs enabled, centralized logging, retention policies |
| Backups | Database backups, recovery testing, retention |
 
## 5. Gap assessment against Annex A (2022)
 
After understanding the current state, I would assess gaps against the four Annex A themes and the management-system clauses.
 
| Area | Example questions |
| --- | --- |
| Access control | Who has access to what? Is least privilege enforced? |
| Asset management | Is there an asset inventory with owners? |
| Change management | How are changes approved and recorded? |
| Logging & monitoring | Are security events recorded and reviewed? |
| Backup & recovery | Can systems be restored, and is restore tested? |
| Supplier management | How are GCP, DigitalOcean, Render, Vercel and messaging providers managed? Are DPAs in place? |
| People & awareness | Do staff and counsellors receive security-awareness training? |
| Incident response | Is there a documented process, including breach notification? |
 
The goal is not to solve everything immediately, but to identify the highest-risk gaps.
 
## 6. Prioritize by risk
 
In a small team, I would avoid implementing everything at once and instead drive the backlog from the risk register.
 
**High priority**
- MFA everywhere
- Least-privilege IAM
- Secret management and rotation
- Backup validation (tested restores)
- Audit logging on sensitive data
**Medium priority**
- Security monitoring and alerting
- Incident-response documentation
- Vendor / processor assessments
**Lower priority**
- Process improvements
- Additional documentation
This reduces real risk quickly while making steady, demonstrable progress toward compliance.
 
## 7. Integrate security into engineering workflows
 
I would treat compliance as part of normal engineering work, not a parallel process developers ignore:
 
- **Infrastructure** : a Terraform pull request to enable Cloud Audit Logs
- **CI/CD** : a GitHub Action adding dependency and IaC security scanning (e.g. Checkov / tfsec)
- **IAM** : a Terraform change reducing excessive permissions
Each improvement ships as a reviewed pull request, which also produces the evidence trail the audit needs.
 
## 8. Supplier and data-protection management
 
Because the stack depends on several third parties and handles sensitive personal data, I would treat this as a first-class workstream:
 
- Maintain a **vendor register**; collect each provider's ISO 27001 / SOC 2 reports
- Ensure **Data Processing Agreements (DPAs)** are in place with every processor, especially the messaging provider that carries user conversations
- Maintain a **record of processing** and a **data classification** scheme for special-category data
- Provide **security-awareness training** for staff and the volunteer counsellors who handle sensitive conversations
- Keep **incident response** aligned to GDPR's 72-hour breach-notification requirement
ISO 27701 (the privacy extension to 27001) would be a natural follow-on once the ISMS is established.
 
## 9. Roadmap, ownership, and operating the ISMS
 
At the end of the assessment phase I would deliver a practical roadmap:
 
- **Current state** : what already exists
- **Gap list** : what is missing
- **Prioritized action plan** : what to implement first
- **Ownership** : who is responsible
| Item | Owner |
| --- | --- |
| MFA rollout | Platform Team |
| Backup restore testing | Infrastructure Team |
| Vendor / DPA assessment | Engineering + Management |
| Incident-response process | Platform Team |
| Awareness training | People + Security |
 
To keep the ISMS alive (and to stay certified), I would also run the recurring management-system activities: **internal audits**, periodic **management reviews**, and **continual improvement** (Clauses 9–10).
 
**Certification path:** once controls and evidence are in place, an accredited certification body runs **Stage 1** (readiness / documentation review) and **Stage 2** (the main audit). The certificate is valid for three years with **annual surveillance audits**.
 
Collaboration throughout would involve developers, platform/infrastructure engineers, engineering managers, and any security stakeholders, with short regular review sessions to track progress and remove blockers.
 