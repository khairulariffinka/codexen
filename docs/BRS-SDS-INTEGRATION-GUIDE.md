# BRS/SDS Integration Guide

Complete workflow guide for using BRS-Manager and SDS-Manager dengan Planner dan Decision-Log.

---

## 🎯 Overview

This guide demonstrates how BRS, SDS, Planner, dan Decision-Log work together untuk complete project specification dan execution workflow.

**Agents Involved:**
- @brs-manager - Business requirements
- @sds-manager - Technical design
- @planner - Task planning (dengan BRS/SDS integration)
- @decision-log - Decision tracking (dengan BRS/SDS integration)

---

## 📋 Complete Workflow Example

### **Scenario: E-Commerce Platform untuk Pak Ali**

---

## Phase 1: Requirements Gathering (Week 0)

### Step 1: Initial Meeting
```
You meet dengan Pak Ali di kedai runcitnya.

Pak Ali explains:
- "Saya nak sistem online untuk kedai saya"
- "Customer boleh order, saya hantar"
- "Budget dalam RM 50K"
- "3 bulan boleh siap?"
- "Feature: Produk, cart, payment, delivery"

You take notes (BM/English mix):
- Business: Kedai Runcit Pak Ali, Taman Melati
- Budget: RM 50,000
- Timeline: 3 months
- Must-have: Product catalog, shopping cart, payment, delivery
- Nice-to-have: Mobile app (tapi mahal kan?)
```

### Step 2: Generate BRS
```bash
You: "@brs-manager create BRS bilingual"

Paste meeting notes...

@brs-manager:
├─ Analyzing input...
├─ Detected project type: Web Application (85% confidence)
├─ Keywords: "online", "order", "produk", "cart", "payment"
├─ Selected template: brs-web-template.md
├─ Generating 16 sections...
└─ Output: docs/BRS-v1.0.md

BRS Generated:
✓ Executive Summary (EN + BM)
✓ 4 User Personas
✓ 30 Requirements:
  ├─ 10 MUST HAVE
  ├─ 8 SHOULD HAVE
  └─ 6 NICE TO HAVE
✓ Section 8: Scope Exclusions (10 items)
✓ Budget: RM 48,400
✓ Timeline: 12 weeks
✓ Approval Matrix
```

### Step 3: Review sebagai Owner
```
You review BRS-v1.0.md:

✅ Section 5 (Requirements):
   - Semua feature yang Pak Ali cakap ada
   - Prioritization makes sense (MUST/SHOULD/NICE)

✅ Section 8 (Scope Exclusions):
   - "❌ Mobile native app"
   - "❌ Real-time chat"
   - "❌ AI recommendations"
   - Perfect untuk protect scope

✅ Section 11 (Budget):
   - RM 48,400 (within RM 50K)
   - Contingency included

✅ Section 13 (Assumptions):
   - Pak Ali provide content dalam 1 minggu
   - Payment gateway approved dalam 2 minggu

Ready untuk client review!
```

### Step 4: Client Review & Approval
```bash
You: Send BRS-v1.0.md kepada Pak Ali

Pak Ali reviews:
├─ "Eh, mobile app takde?"
│  └─ You: "Check Section 8, boss. Mobile app dalam Future Phase 2."
│  └─ Pak Ali: "Oh okay, Phase 2 lah."
│
├─ "Budget RM 48K, boleh adjust ke RM 45K?"
│  └─ You: "Boleh, kita kurangkan SHOULD HAVE features."
│  └─ Adjust BRS: Move 3 features dari SHOULD ke NICE
│  └─ New budget: RM 44,200
│
└─ Pak Ali approves BRS-v1.0.md
   └─ Digital signature dalam SIGNATURES.md

Status: BRS APPROVED ✓
```

**Auto-trigger @decision-log:**
```bash
@decision-log auto-logs:
├─ DEC-010: MVP Scope Definition
├─ DEC-011: Mobile App Deferred to Phase 2
├─ DEC-012: Budget Adjusted to RM 44.2K
└─ All stored in DECISIONS.md
```

---

## Phase 2: Technical Design (Week 1)

### Step 5: Generate SDS
```bash
You: "@sds-manager create SDS from BRS"

@sds-manager:
├─ Reading BRS-v1.0.md (30 requirements)
├─ Analyzing technical requirements...
├─ Designing architecture:
│  ├─ Stack: Laravel 10 + React 18 + MySQL 8.0
│  ├─ Pattern: Monolithic dengan service layer
│  └─ Hosting: DigitalOcean + Laravel Forge
├─ Designing database:
│  ├─ 8 entities identified
│  ├─ ERD generated (Mermaid diagram)
│  └─ Indexes planned for performance
├─ Designing APIs:
│  ├─ 15 endpoints specified (OpenAPI format)
│  ├─ Authentication: JWT via Sanctum
│  └─ Rate limiting: 100 req/min
├─ Logging decisions:
│  ├─ DEC-001: Why Laravel over Node.js
│  ├─ DEC-002: Why React over Vue
│  ├─ DEC-003: Why MySQL over PostgreSQL
│  └─ DEC-004: Why iPay88 over Stripe
└─ Output: docs/SDS-v1.0.md

SDS Generated:
✓ System Overview
✓ Architecture (diagrams)
✓ Data Model (8 tables)
✓ API Specifications (15 endpoints)
✓ Security Architecture
✓ Scalability Plan
✓ Decision Log (4 decisions)
```

**Auto-trigger @decision-log:**
```bash
@decision-log auto-logs dari SDS Section 8:
├─ DEC-001: Backend Framework (Laravel)
├─ DEC-002: Frontend Framework (React)
├─ DEC-003: Database (MySQL)
├─ DEC-004: Payment Gateway (iPay88)
└─ All dengan full rationale
```

### Step 6: Technical Review
```
You review SDS-v1.0.md:

✅ Architecture:
   - Laravel + React sesuai untuk e-commerce
   - Boleh scale kalau Pak Ali punya bisnes grow

✅ Database:
   - 8 tables cover semua requirements
   - Indexes untuk search dan filtering

✅ APIs:
   - 15 endpoints, semua documented
   - Authentication strategy clear

✅ Decisions:
   - Semua rationale documented
   - Alternatives considered

Ready untuk development!
```

---

## Phase 3: Planning (Week 1)

### Step 7: Auto-Generate Plan from BRS + SDS
```bash
You: "@planner create plan from BRS and SDS"

@planner:
├─ Reading BRS-v1.0.md (30 requirements)
├─ Reading SDS-v1.0.md (tech stack, APIs, DB)
├─ Analyzing requirements...
│
├─ Detected Patterns:
│  ├─ REQ-001 to REQ-003: User Auth (Auth pattern)
│  ├─ REQ-004 to REQ-008: Product Catalog (CRUD pattern)
│  ├─ REQ-009 to REQ-012: Cart & Checkout (Commerce pattern)
│  ├─ REQ-013 to REQ-015: Payment (Payment pattern)
│  └─ REQ-016 to REQ-020: Orders & Admin (Management pattern)
│
├─ Breaking down into tasks...
│  ├─ REQ-001 (Auth): 11 tasks, 24 hours
│  ├─ REQ-004 (Catalog): 14 tasks, 49 hours
│  ├─ REQ-009 (Cart): 12 tasks, 42 hours
│  ├─ REQ-013 (Payment): 11 tasks, 49 hours
│  └─ REQ-016 (Orders): 16 tasks, 58 hours
│
├─ Total: 64 tasks, 222 hours (~6 weeks @ 40h/week)
│
├─ Estimating effort dengan complexity multipliers...
│  ├─ Standard tasks: 1.0x
│  ├─ Payment integration: 1.5x (external API)
│  ├─ Search functionality: 1.3x (complex queries)
│  └─ Adjusted total: 342 hours (~8.5 weeks)
│
├─ Assigning agents based on task type...
│  ├─ Backend tasks → @backend-coder
│  ├─ Frontend tasks → @frontend-coder
│  ├─ Database tasks → @database-expert
│  └─ Testing tasks → @test-coder
│
├─ Mapping dependencies...
│  ├─ Auth must complete before Cart
│  ├─ Cart must complete before Payment
│  ├─ Database must complete before Backend
│  └─ Parallel groups identified: 5 groups
│
├─ Creating traceability matrix...
│  └─ Each task linked to REQ-xxx
│
└─ Output: planner.md

Plan Generated:
✓ 64 tasks
✓ 342 hours total
✓ 5 parallel groups
✓ 12-week timeline (3 months)
✓ Traceability: All tasks → Requirements
```

**Auto-trigger @decision-log:**
```bash
@decision-log logs planning decisions:
├─ DEC-020: Task Estimation Rationale
├─ DEC-021: Parallel Grouping Strategy
└─ DEC-022: Agent Assignment Logic
```

### Step 8: Review Plan
```bash
You: Review planner.md

Milestone 1 (Week 1-2): Foundation
├─ Tasks: 12 tasks, 45 hours
├─ Deliverables: Auth system, Database
└─ Dependencies: None (start immediately)

Milestone 2 (Week 3-6): Core Commerce
├─ Tasks: 28 tasks, 142 hours
├─ Deliverables: Products, Cart, Payment
└─ Dependencies: Milestone 1

Milestone 3 (Week 7-10): Operations
├─ Tasks: 18 tasks, 98 hours
├─ Deliverables: Admin, Orders, Reports
└─ Dependencies: Milestone 2

Milestone 4 (Week 11-12): Polish
├─ Tasks: 6 tasks, 57 hours
├─ Deliverables: Testing, Deploy
└─ Dependencies: Milestone 3

Traceability Example:
REQ-001 (User Auth):
├─ BE-001: Create User model ✅
├─ BE-002: Create register API ✅
├─ FE-001: Create register form ⏳
└─ Status: 2/11 complete (18%)

Timeline: Realistic
Budget: On track
Ready to start development!
```

---

## Phase 4: Development (Week 2-11)

### Step 9: Daily Development Workflow
```
Developer (You):

Morning:
├─ Open planner.md
├─ Check today's tasks
└─ Pick task dengan highest priority

During coding:
├─ Open SDS → Check API spec
├─ Open SDS → Check database schema
├─ Open BRS → Verify acceptance criteria
└─ Code dengan confident

Update progress:
├─ Mark task complete dalam planner.md
├─ planner auto-updates traceability
└─ "REQ-001 now 3/11 complete (27%)"
```

### Step 10: Weekly Progress Report
```bash
You: "@planner generate weekly report"

@planner generates:
├─ Progress: 45/64 tasks complete (70%)
├─ Requirements: 21/30 complete (70%)
├─ Milestone 2: 80% complete
├─ Budget: On track
├─ Risks: None identified
└─ Next week: Start Milestone 3

You send to Pak Ali:
"Boss, projek dah 70% siap. 
Milestone 2 (Core Commerce) 80% complete.
Payment integration dalam testing.
On track untuk April launch."

Pak Ali: "Bagus! 💪"
```

---

## Phase 5: Scope Change (Week 6 - Mid Project)

### Step 11: Client Requests Change
```
Pak Ali: "Saya fikir, kita tambah TikTok integration?
Boleh auto-post produk ke TikTok."

You (switch to PM mode):
├─ Open BRS Section 8
├─ Show: "❌ TikTok integration (Future Phase)"
└─ Explain: "Boss, ini tak dalam Phase 1 scope."

Pak Ali: "Tambah je sikit, tak boleh ke?"

You: "Boleh, tapi kena ada Change Request."
```

### Step 12: Create Change Request
```bash
You: "@brs-manager create change request"

Feature: TikTok Auto-Posting Integration
Requested by: Pak Ali

@brs-manager:
├─ Analyzing impact...
├─ Technical complexity: HIGH
│  ├─ TikTok Shop API (new integration)
│  ├─ Video generation service (FFmpeg)
│  ├─ Background job processing
│  └─ Additional storage (video files)
│
├─ Effort estimate: 80 hours (+3 weeks)
├─ Cost impact: +RM 16,000
├─ Timeline impact: Delay 3 weeks
├─ Risk level: HIGH (API dependency)
│
├─ Generating CR-001-tiktok-integration.md
├─ Compare dengan BRS Section 8
└─ Recommendation: "Defer to Phase 2"

You present to Pak Ali:
├─ Show CR-001 impact analysis
├─ Show: +3 weeks, +RM 16K
├─ Offer options:
│  1. Accept: Delay + cost
│  2. Defer: Phase 2 (recommended)
│  3. Simplified: Manual posting (cheaper)
└─ Pak Ali decides

Pak Ali: "Mahalnya! Takpe, Phase 2 lah."

Result: ✅ Scope protected
```

**Auto-trigger @decision-log:**
```bash
@decision-log logs:
├─ DEC-025: TikTok Integration Deferred
├─ Decision: Defer to Phase 2
├─ Rationale: High cost, high risk, not critical
├─ Approved by: Pak Ali
└─ Revisit: Month 4 (Phase 2 planning)
```

### Step 13: No BRS Update Needed
```
Since change rejected:
├─ BRS stays at v1.0 (no change)
├─ SDS stays at v1.0 (no change)
├─ planner stays on track (no delay)
└─ Timeline maintained: April launch

You: On track, budget preserved! 💰
```

---

## Phase 6: Completion (Week 12)

### Step 14: Final Verification
```bash
You: "@planner verify completion"

@planner checks:
├─ All 64 tasks: ✅ Complete
├─ All 30 requirements: ✅ Verified
│  ├─ REQ-001 to REQ-030: Acceptance criteria met
│  └─ Traceability: Code matches specs
├─ BRS: All MUST HAVE implemented
├─ SDS: All specs implemented
└─ Testing: All tests pass

Status: READY FOR DELIVERY ✓
```

### Step 15: Project Handover
```
You deliver to Pak Ali:

📦 Package includes:
├─ 🌐 Working e-commerce system
├─ 📄 BRS-v1.0.md (Requirements document)
├─ 📄 SDS-v1.0.md (Technical specs)
├─ 📄 planner.md (Implementation record)
├─ 📄 DECISIONS.md (Decision log)
├─ 📄 User Manual (BM + English)
└─ 🔑 Admin credentials

Pak Ali receives:
✅ Complete system
✅ Full documentation
✅ Can extend Phase 2 later
✅ Can hire dev (docs complete)
✅ Professional handover

Pak Ali: "Terbaik! Professional betul."
```

---

## 📊 Integration Benefits Summary

### **Without Integration:**
```
❌ Manual task creation: 2-3 hours
❌ Manual decision logging: Forgotten
❌ Find information: 10-15 min/search
❌ Scope change: Chaos, arguments
❌ Handover: "Erm... tanya developer lama"
```

### **With Integration:**
```
✅ Auto task generation: 5 minutes
✅ Auto decision logging: Complete history
✅ Find information: 2 seconds
✅ Scope change: Impact analysis, clear process
✅ Handover: Complete documentation
```

### **Time Saved per Project:**
| Activity | Without | With | Saved |
|----------|---------|------|-------|
| Task planning | 3h | 5min | 2h 55m |
| Decision docs | 2h | 0min | 2h |
| Finding info | 5h | 30min | 4h 30m |
| Scope changes | 4h | 1h | 3h |
| **Total** | **14h** | **2h** | **12h** |

**For 10 projects/year: 120 hours saved = 3 weeks!**

---

## 🎯 Key Integration Points

### **BRS → @planner:**
- Requirements → Tasks
- MoSCoW → Priority
- Section 8 → Exclusions protect timeline

### **SDS → @planner:**
- Tech stack → Agent assignment
- API specs → Backend tasks
- DB schema → Database tasks
- Architecture → Dependencies

### **BRS → @decision-log:**
- Scope decisions
- Change approvals
- Budget decisions

### **SDS → @decision-log:**
- Architecture decisions
- Tech stack rationale
- Rejected alternatives

### **@planner → @decision-log:**
- Estimation rationale
- Prioritization logic
- Planning strategy

---

## ✅ Next Steps

**Ready to use integration:**
1. Create BRS dengan @brs-manager
2. Generate SDS dengan @sds-manager
3. Create plan dengan @planner (auto-integration)
4. Review DECISIONS.md (auto-logged)
5. Start development!

**For troubleshooting:**
- See agent-specific documentation
- Check TUTORIALS.md examples
- Review SKILL.md standards

---

*Integration complete!* 🚀
