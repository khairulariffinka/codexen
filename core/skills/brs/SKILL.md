---
name: brs
description: Business Requirement Specification standards, templates, and guidelines for comprehensive project documentation with multilingual support
---

# BRS Skill

Standards and templates for creating comprehensive Business Requirement Specification (BRS) documents.

## When to Use

- Starting new project and need formal requirements document
- Client asks for "formal proposal" or "requirement specs"
- Managing scope creep and need protection clause
- Stakeholder alignment required
- Budget approval needed from management

## BRS Structure (16 Sections)

### 1. Executive Summary
**Purpose:** One-page overview for busy stakeholders

**Content:**
- Project name and brief description
- Business problem being solved
- Proposed solution (high-level)
- Expected benefits/outcomes
- Timeline and budget (summary)

**Bilingual Format:**
```markdown
**English:**
[Detailed English description]

**[BM] Executive Summary:**
[Summary in Malay]
```

---

### 2. Stakeholders
**Purpose:** Identify who is involved and their roles

**Template:**
```markdown
| Stakeholder | Role | Interest | Influence |
|-------------|------|----------|-----------|
| [Name] | Business Owner | High | High |
| [Name] | End User | High | Low |
| [Name] | IT Department | Medium | Medium |
```

**[BM] Categories:**
- **Pemilik Perniagaan** - Business Owner
- **Pengguna Akhir** - End Users
- **Jabatan IT** - IT Department
- **Pemegang Saham** - Investors

---

### 3. Business Objectives
**Purpose:** SMART objectives that are measurable

**Template:**
```markdown
**English:**
1. Increase online sales by 40% within 12 months
2. Reduce order processing time from 2 hours to 30 minutes
3. Achieve 500 monthly active users by Month 6

**[BM] Objectives:**
1. Increase online sales by 40% within 12 months
2. Reduce order processing time from 2 hours to 30 minutes
3. Achieve 500 monthly active users by Month 6
```

**Quality Check:**
- ✅ Specific (not vague)
- ✅ Measurable (has numbers)
- ✅ Achievable (realistic)
- ✅ Relevant (to business)
- ✅ Time-bound (has deadline)

---

### 4. User Personas
**Purpose:** Understand target users

**Template (3-4 personas):**
```markdown
## Persona 1: [Name]
- **Age:** 25-35
- **Occupation:** Working professional
- **Tech-savviness:** High
- **Goals:** [What they want to achieve]
- **Pain Points:** [Current frustrations]
- **Quote:** "[Typical statement]"

**[BM] Profile:**
- **Age:** 25-35
- **Occupation:** Professional
- **Tech Skills:** High
```

---

### 5. Functional Requirements
**Purpose:** What system must do (MoSCoW method)

#### 5.1 MUST HAVE
Critical - System cannot function without these

**Format:**
```markdown
| Req ID | Requirement | Priority | Acceptance Criteria |
|--------|-------------|----------|---------------------|
| REQ-001 | User registration | High | Email validation, password strength |
| REQ-002 | Product catalog | High | Categories, search, filter |
| REQ-003 | Shopping cart | High | Add/remove, quantities, total |
```

**Numbering:** REQ-001, REQ-002, REQ-003... (for traceability)

**[BM] Must Have Requirements:**
Critical requirements that the system cannot function without.

#### 5.2 SHOULD HAVE
Important but not critical

```markdown
| Req ID | Requirement | Priority | Acceptance Criteria |
|--------|-------------|----------|---------------------|
| REQ-011 | WhatsApp notifications | Medium | Order confirmations via WhatsApp |
| REQ-012 | Customer reviews | Medium | Rate 1-5 stars, write reviews |
```

**[BM] Should Have Requirements:**
Important requirements but not critical.

#### 5.3 NICE TO HAVE
Desirable if time permits

```markdown
| Req ID | Requirement | Priority | Acceptance Criteria |
|--------|-------------|----------|---------------------|
| REQ-021 | Mobile app | Low | Native iOS/Android app |
| REQ-022 | AI recommendations | Low | Product suggestions |
```

**[BM] Nice To Have Requirements:**
Requirements desired if time permits.

---

### 6. Non-Functional Requirements
**Purpose:** Quality attributes (performance, security, usability)

**Categories:**

| Category | Requirement | Criteria |
|----------|-------------|----------|
| **Performance** | Page Load Time | < 3 seconds |
| **Performance** | Concurrent Users | Support 100 simultaneous |
| **Security** | Data Encryption | SSL/TLS, encrypted DB |
| **Security** | PCI DSS | Payment compliance |
| **Availability** | Uptime | 99.5% availability |
| **Usability** | Browser Support | Chrome, Firefox, Safari |
| **Usability** | Mobile Responsive | Works on all devices |
| **Compliance** | PDPA | Malaysian data protection |

**[BM] Non-Functional Requirements:**
System quality attributes (performance, security, usability).

---

### 7. Constraints & Dependencies

#### 7.1 Constraints
```markdown
**English:**
1. **Budget:** Fixed at RM 50,000 (cannot exceed without approval)
2. **Timeline:** Must launch by April 2024 (3 months)
3. **Technical:** Must use cloud hosting (no on-premise)
4. **Resources:** Maximum 3 developers

**[BM] Constraints:**
1. **Budget:** Fixed at RM 50,000 (cannot exceed)
2. **Schedule:** Must launch by April 2024
3. **Technical:** Must use cloud hosting
4. **Resources:** Max 3 developers
```

#### 7.2 Dependencies
```markdown
| Dependency | Type | Risk Level | Mitigation |
|------------|------|------------|------------|
| Payment gateway API | External | High | Start integration early |
| Client content | Internal | Medium | Set deadline with reminders |
| Third-party SMS service | External | Low | Have backup provider |
```

---

### 8. Scope Exclusions ⭐ CRITICAL
**Purpose:** EXPLICITLY state what is NOT included (scope protection)

**Format:**
```markdown
## Scope Exclusions

**⚠️ IMPORTANT:**
The following items are NOT included in Phase 1:

**English:**
### Excluded Features:
- ❌ **Mobile native app** (Web responsive only)
  - *Reason:* Budget constraint, Phase 2 item
- ❌ **Offline functionality**
  - *Reason:* Requires complex sync logic
- ❌ **Real-time chat**
  - *Reason:* Not critical for MVP
- ❌ **Multi-vendor marketplace**
  - *Reason:* Single store scope only
- ❌ **Advanced analytics**
  - *Reason:* Basic reporting only for Phase 1
- ❌ **International shipping**
  - *Reason:* Domestic only
- ❌ **Social media auto-posting**
  - *Reason:* Manual sharing only
- ❌ **Email marketing campaigns**
  - *Reason:* Basic notifications only

**[BM] Excluded Features:**
The following items are NOT included in Phase 1:

- ❌ **Native mobile app** (Web responsive only)
  - *Reason:* Budget constraint, Phase 2 item
- ❌ **Offline functionality**
- ❌ **Real-time chat**
- ❌ **Multi-vendor marketplace**
  - *Reason:* Single store scope only
- ❌ **Advanced analytics**
- ❌ **International shipping**
- ❌ **Social media auto-posting**
- ❌ **Email marketing campaigns**

---

**Note:**
*These exclusions protect both parties from scope creep. 
Any item above can be added in Future Phases with additional cost and timeline extension.*
```

**Why This Matters:**
If client asks "Why no TikTok auto-post?"
→ Open Section 8: "This is in Scope Exclusions. To add, need Change Request and additional budget."

---

### 9. Future Phases
**Purpose:** Roadmap for upsell

```markdown
## Phase 2: Mobile App (Month 4-6)
- Native iOS/Android app
- Push notifications
- Budget: +RM 20,000

## Phase 3: Advanced Features (Month 7-12)
- AI recommendations
- Multi-vendor support
- Advanced analytics
- Budget: +RM 30,000

**[BM] Future Phases:**
Phase 2: Mobile App (Months 4-6)
Phase 3: Advanced Features (Months 7-12)
```

---

### 10. Timeline & Milestones

**Gantt-style Overview:**
```markdown
| Phase | Duration | Deliverables |
|-------|----------|--------------|
| **Phase 1: Foundation** | Week 1-2 | Setup, Auth, Database |
| **Phase 2: Core Features** | Week 3-6 | Products, Cart, Payment |
| **Phase 3: Operations** | Week 7-10 | Admin, Orders, Inventory |
| **Phase 4: Polish** | Week 11-12 | Testing, Deploy, Docs |
```

**Key Milestones:**
- Week 2: Foundation complete
- Week 6: Core features ready
- Week 10: Operations complete
- Week 12: **LAUNCH** 🚀

---

### 11. Budget Estimate

**Detailed Breakdown:**
```markdown
| Category | Amount (RM) | Notes |
|----------|-------------|-------|
| **Development** | 40,000 | 400 hours × RM 100/hr |
| **UI/UX Design** | 3,000 | Mockups, revisions |
| **Infrastructure** | 2,000 | Hosting, domain, SSL |
| **Third-party APIs** | 1,200 | SMS, payment gateway |
| **Testing & QA** | 1,500 | Manual + automated |
| **Documentation** | 700 | User guides, API docs |
| **Contingency (10%)** | 4,840 | Buffer for unexpected |
| **TOTAL** | **RM 53,240** | Rounded: **RM 50,000** |

**[BM] Budget Breakdown:**
Development: RM 40,000
UI/UX Design: RM 3,000
Infrastructure: RM 2,000
Third-party APIs: RM 1,200
Testing & QA: RM 1,500
Documentation: RM 700
Contingency: RM 4,840
**TOTAL: RM 50,000**
```

---

### 12. Risk Assessment

```markdown
| Risk | Probability | Impact | Score | Mitigation |
|------|------------|--------|-------|------------|
| Payment gateway delay | Medium | High | 6 | Start integration Week 2 |
| Scope creep | High | High | 9 | Strict BRS adherence |
| Resource unavailable | Low | High | 3 | Backup developers |
| Technical complexity | Medium | Medium | 4 | Proof of concepts |
| Client approval delays | Medium | Medium | 4 | Weekly check-ins |

**[BM] Risk Assessment:**
Probability: Low | Medium | High
Impact: Low | Medium | High
Score = Probability × Impact (1-9)
```

---

### 13. Assumptions

```markdown
**English:**
1. Client will provide product content within 1 week of request
2. Payment gateway account will be approved within 2 weeks
3. Third-party APIs (SMS, email) will remain available
4. Client has stable internet connection for demos
5. No major changes to business requirements during development

**[BM] Assumptions:**
1. Client will provide product content within 1 week
2. Payment gateway account will be approved within 2 weeks
3. Third-party APIs (SMS, email) will remain available
4. Client has stable internet connection
5. No major changes to business requirements during development
```

---

### 14. Approval Matrix

```markdown
| Role | Name | Signature | Date | Status |
|------|------|-----------|------|--------|
| **Business Owner** | [Client Name] | _____________ | ______ | [ ] Approved [ ] Rejected |
| **Project Manager** | [PM Name] | _____________ | ______ | [ ] Approved [ ] Rejected |
| **Technical Lead** | [Lead Name] | _____________ | ______ | [ ] Approved [ ] Rejected |

**Instructions:**
Please type your full name in the "Signature" column as digital acknowledgment.

**Date Format / Format Tarikh:** DD/MM/YYYY
```

---

### 15. Change Log

```markdown
| Version | Date | Changes | Approved By | Date Approved |
|---------|------|---------|-------------|---------------|
| 1.0 | [Date] | Initial BRS | [Name] | [Date] |
| 1.1 | [Date] | Added CR-001: TikTok integration | [Name] | [Date] |
| 1.2 | [Date] | Modified REQ-005: Added GrabPay | [Name] | [Date] |

**[BM] Change Log:**
Version 1.0: Initial BRS
Version 1.1: Added CR-001: TikTok integration
Version 1.2: Modified REQ-005: Added GrabPay
```

---

## Change Request Template

When client wants to change scope, use this format:

```markdown
# Change Request: CR-[Number]

## Request Details
- **CR Number:** CR-001
- **Requested By:** [Name]
- **Date:** [Date]
- **Priority:** High/Medium/Low

## Change Description
**English:** [What they want]
**[BM]:** [In Malaysian Malay]

## Impact Analysis
- **Technical Impact:** [What needs to change technically]
- **Timeline Impact:** +X weeks
- **Cost Impact:** +RM X,XXX
- **Risk Level:** High/Medium/Low

## Options
1. **Accept:** Implement with additional cost/time
2. **Defer:** Move to Future Phase
3. **Reject:** Not feasible

## Recommendation
[What you recommend and why]

## Approval
| Role | Name | Decision | Date |
|------|------|----------|------|
| Business Owner | | [ ] Accept [ ] Reject | |
| Project Manager | | [ ] Accept [ ] Reject | |
```

## Quality Standards

Before finalizing BRS, verify:
- ✅ All 16 sections present
- ✅ Requirements numbered (REQ-xxx)
- ✅ MoSCoW prioritization applied
- ✅ Section 8 (exclusions) comprehensive
- ✅ Budget realistic
- ✅ Timeline achievable
- ✅ Risks identified with mitigation
- ✅ Bilingual sections complete (if requested)
- ✅ Approval matrix ready
- ✅ Change log started

## Language Options

### Option 1: English Only
```
@brs-manager create BRS english
```
All sections in English only.

### Option 2: Bilingual (Default)
```
@brs-manager create BRS bilingual
```
English primary, BM summary boxes.

### Option 3: Malay Primary (Future)
```
@brs-manager create BRS malay
```
BM primary, English summary boxes.

## Common Pitfalls to Avoid

❌ **Vague requirements:** "Fast system" → ✅ "Page load < 2 seconds"
❌ **Missing exclusions:** Client assumes everything included
❌ **Unrealistic timeline:** "1 week to complete e-commerce"
❌ **No version control:** Changes not tracked
❌ **Skipping approvals:** No formal sign-off

## Success Metrics

Good BRS should:
- 📋 Prevent 80% of scope creep
- ✅ Get client approval within 48 hours
- 🎯 Be clear enough for developer to start
- 💰 Provide accurate budget estimate (±10%)
- 📅 Give realistic timeline (±1 week)
