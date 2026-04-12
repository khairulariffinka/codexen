---
name: brs
description: Business Requirement Specification standards, templates, and guidelines for comprehensive project documentation with multilingual support
---

# BRS Skill

Standards and templates for creating comprehensive Business Requirement Specification (BRS) documents.

## When to Use

- Starting new project and need formal requirements document
- Client asks for "formal proposal" atau "requirement specs"
- Managing scope creep and need protection clause
- Stakeholder alignment required
- Budget approval needed from management

## BRS Structure (16 Sections)

### 1. Executive Summary / Ringkasan Eksekutif
**Purpose:** One-page overview untuk busy stakeholders

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

**[BM] Ringkasan Eksekutif:**
[Ringkasan dalam Bahasa Melayu Malaysia]
```

---

### 2. Stakeholders / Pemegang Taruh
**Purpose:** Identify siapa involved dan their roles

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

### 3. Business Objectives / Objektif Perniagaan
**Purpose:** SMART objectives yang measurable

**Template:**
```markdown
**English:**
1. Increase online sales by 40% within 12 months
2. Reduce order processing time from 2 hours to 30 minutes
3. Achieve 500 monthly active users by Month 6

**[BM] Objektif:**
1. Tingkatkan jualan dalam talian sebanyak 40% dalam 12 bulan
2. Kurangkan masa pemprosesan pesanan dari 2 jam ke 30 minit
3. Capai 500 pengguna aktif bulanan menjelang Bulan 6
```

**Quality Check:**
- ✅ Specific (not vague)
- ✅ Measurable (ada numbers)
- ✅ Achievable (realistic)
- ✅ Relevant (to business)
- ✅ Time-bound (ada deadline)

---

### 4. User Personas / Profil Pengguna
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

**[BM] Profil:**
- **Umur:** 25-35
- **Pekerjaan:** Profesional
- **Kemahiran Teknologi:** Tinggi
```

---

### 5. Functional Requirements / Keperluan Fungsi
**Purpose:** What system must do (MoSCoW method)

#### 5.1 MUST HAVE / MESTI ADA
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

**[BM] Keperluan Mesti Ada:**
Keperluan kritikal yang sistem tidak boleh berfungsi tanpa.

#### 5.2 SHOULD HAVE / ELOK ADA
Important but not critical

```markdown
| Req ID | Requirement | Priority | Acceptance Criteria |
|--------|-------------|----------|---------------------|
| REQ-011 | WhatsApp notifications | Medium | Order confirmations via WhatsApp |
| REQ-012 | Customer reviews | Medium | Rate 1-5 stars, write reviews |
```

**[BM] Keperluan Elok Ada:**
Keperluan penting tetapi bukan kritikal.

#### 5.3 NICE TO HAVE / KALAU SEMPAT
Desirable if time permits

```markdown
| Req ID | Requirement | Priority | Acceptance Criteria |
|--------|-------------|----------|---------------------|
| REQ-021 | Mobile app | Low | Native iOS/Android app |
| REQ-022 | AI recommendations | Low | Product suggestions |
```

**[BM] Keperluan Kalau Sempat:**
Keperluan yang diinginkan jika masa membenarkan.

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

**[BM] Keperluan Bukan Fungsi:**
Sifat kualiti sistem (prestasi, keselamatan, kebolehgunaan).

---

### 7. Constraints & Dependencies

#### 7.1 Constraints / Batasan
```markdown
**English:**
1. **Budget:** Fixed at RM 50,000 (cannot exceed without approval)
2. **Timeline:** Must launch by April 2024 (3 months)
3. **Technical:** Must use cloud hosting (no on-premise)
4. **Resources:** Maximum 3 developers

**[BM] Batasan:**
1. **Bajet:** Tetap RM 50,000 (tidak boleh melebihi)
2. **Jadual:** Mesti dilancarkan menjelang April 2024
3. **Teknikal:** Mesti guna hosting awan
4. **Sumber:** Maksimum 3 pembangun
```

#### 7.2 Dependencies / Kebergantungan
```markdown
| Dependency | Type | Risk Level | Mitigation |
|------------|------|------------|------------|
| Payment gateway API | External | High | Start integration early |
| Client content | Internal | Medium | Set deadline with reminders |
| Third-party SMS service | External | Low | Have backup provider |
```

---

### 8. Scope Exclusions / Skop Dikecualikan ⭐ CRITICAL
**Purpose:** EXPLICITLY state what is NOT included (scope protection)

**Format:**
```markdown
## Scope Exclusions / Skop Dikecualikan

**⚠️ IMPORTANT / PENTING:**
The following items are NOT included dalam Phase 1:

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

**[BM] Ciri Dikecualikan:**
Item berikut TIDAK termasuk dalam Fasa 1:

- ❌ **Aplikasi mudah alih asli** (Web responsif sahaja)
  - *Sebab:* Batasan bajet, item Fasa 2
- ❌ **Fungsi luar talian**
- ❌ **Sembang masa nyata**
- ❌ **Marketplace pelbagai vendor**
  - *Sebab:* Skop kedai tunggal sahaja
- ❌ **Analitik lanjutan**
- ❌ **Penghantaran antarabangsa**
- ❌ **Siaran automatik media sosial**
- ❌ **Kempen pemasaran emel**

---

**Note / Nota:**
*These exclusions protect both parties from scope creep. 
Any item above can be added in Future Phases dengan additional cost and timeline extension.*

*Pengecualian ini melindungi kedua-dua pihak daripada penambahan skop.
Mana-mana item di atas boleh ditambah dalam Fasa Seterusnya dengan kos dan lanjutan jadual tambahan.*
```

**Why This Matters:**
Kalau client tanya "Kenapa tak ada TikTok auto-post?"
→ Buka Section 8: "Ini dalam Scope Exclusions. Kalau nak tambah, kena ada Change Request dan budget tambahan."

---

### 9. Future Phases / Fasa Seterusnya
**Purpose:** Roadmap untuk upsell

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

**[BM] Fasa Seterusnya:**
Fasa 2: Aplikasi Mudah Alih (Bulan 4-6)
Fasa 3: Ciri Lanjutan (Bulan 7-12)
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

### 11. Budget Estimate / Anggaran Bajet

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
| **Contingency (10%)** | 4,840 | Buffer untuk unexpected |
| **TOTAL** | **RM 53,240** | Rounded: **RM 50,000** |

**[BM] Pecahan Bajet:**
Pembangunan: RM 40,000
Reka Bentuk UI/UX: RM 3,000
Infrastruktur: RM 2,000
API Pihak Ketiga: RM 1,200
Ujian & QA: RM 1,500
Dokumentasi: RM 700
Kontingensi: RM 4,840
**JUMLAH: RM 50,000**
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

**[BM] Penilaian Risiko:**
Kebarangkalian: Rendah | Sederhana | Tinggi
Impak: Rendah | Sederhana | Tinggi
Skor = Kebarangkalian × Impak (1-9)
```

---

### 13. Assumptions / Andaian

```markdown
**English:**
1. Client will provide product content within 1 week of request
2. Payment gateway account will be approved within 2 weeks
3. Third-party APIs (SMS, email) will remain available
4. Client has stable internet connection for demos
5. No major changes to business requirements during development

**[BM] Andaian:**
1. Klien akan menyediakan kandungan produk dalam masa 1 minggu
2. Akaun gerbang pembayaran akan diluluskan dalam 2 minggu
3. API pihak ketiga (SMS, emel) akan kekal tersedia
4. Klien mempunyai sambungan internet stabil
5. Tiada perubahan besar ke atas keperluan perniagaan semasa pembangunan
```

---

### 14. Approval Matrix / Matriks Kelulusan

```markdown
| Role | Name | Signature | Date | Status |
|------|------|-----------|------|--------|
| **Business Owner** | [Client Name] | _____________ | ______ | [ ] Approved [ ] Rejected |
| **Project Manager** | [PM Name] | _____________ | ______ | [ ] Approved [ ] Rejected |
| **Technical Lead** | [Lead Name] | _____________ | ______ | [ ] Approved [ ] Rejected |

**Instructions / Arahan:**
Please type your full name in the "Signature" column as digital acknowledgment.
Sila taip nama penuh anda dalam kolum "Tandatangan" sebagai pengiktirafan digital.

**Date Format / Format Tarikh:** DD/MM/YYYY
```

---

### 15. Change Log / Log Perubahan

```markdown
| Version | Date | Changes | Approved By | Date Approved |
|---------|------|---------|-------------|---------------|
| 1.0 | [Date] | Initial BRS | [Name] | [Date] |
| 1.1 | [Date] | Added CR-001: TikTok integration | [Name] | [Date] |
| 1.2 | [Date] | Modified REQ-005: Added GrabPay | [Name] | [Date] |

**[BM] Log Perubahan:**
Versi 1.0: BRS asal
Versi 1.1: Tambah CR-001: Integrasi TikTok
Versi 1.2: Ubah REQ-005: Tambah GrabPay
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

## Change Description / Penerangan Perubahan
**English:** [What they want]
**[BM]:** [Dalam Bahasa Melayu Malaysia]

## Impact Analysis / Analisis Impak
- **Technical Impact:** [What needs to change technically]
- **Timeline Impact:** +X weeks
- **Cost Impact:** +RM X,XXX
- **Risk Level:** High/Medium/Low

## Options / Pilihan
1. **Accept:** Implement dengan additional cost/time
2. **Defer:** Move to Future Phase
3. **Reject:** Not feasible

## Recommendation / Cadangan
[What you recommend and why]

## Approval / Kelulusan
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
❌ **Unrealistic timeline:** "1 week untuk complete e-commerce"
❌ **No version control:** Changes not tracked
❌ **Skipping approvals:** No formal sign-off

## Success Metrics

Good BRS should:
- 📋 Prevent 80% of scope creep
- ✅ Get client approval dalam 48 hours
- 🎯 Be clear enough untuk developer to start
- 💰 Provide accurate budget estimate (±10%)
- 📅 Give realistic timeline (±1 week)
