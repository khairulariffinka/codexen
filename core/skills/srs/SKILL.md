---
name: srs
description: Software Requirements Specification (SRS) standards, functional requirements, non-functional requirements, use cases, and documentation templates.
---

## Language Detection

- **CRITICAL**: Detect user's language and respond in the same language
- If user uses **Bahasa Melayu (Malay)**, respond entirely in **Bahasa Melayu Malaysia**
- If user uses **English**, respond entirely in **English**
- **NEVER mix both languages in the same response** - use ONE language consistently

# SRS Skill

Standards and templates for creating comprehensive Software Requirements Specification (SRS) documents. The SRS bridges the gap between Business Requirements (BRS) and System Design (SDS) by detailing exactly what the software system should do.

## When to Use

- BRS is finalized and detailed software requirements are needed.
- Defining functional and non-functional requirements.
- Creating use cases and user stories for development.
- Specifying external interface requirements (APIs, UI, hardware).
- Before starting the System Design Specification (SDS).

## SRS Structure (6 Main Sections)

### 1. Introduction
**Purpose:** Provide an overview of the entire SRS document.

**Content:**
- Purpose of the document
- Document conventions
- Intended audience and reading suggestions
- Product scope
- References

**Format:**
```markdown
## 1. Introduction

### 1.1 Purpose
This document specifies the software requirements for the [System Name]. It is intended for developers, quality assurance engineers, and project stakeholders.

### 1.2 Scope
The [System Name] is a [brief description of what the software is/does]. This system will enable users to [key capability 1] and [key capability 2].

### 1.3 Definitions and Acronyms
| Term | Definition |
|------|------------|
| API  | Application Programming Interface |
| SRS  | Software Requirements Specification |
```

---

### 2. Overall Description
**Purpose:** Describe the general factors that affect the product and its requirements.

**Content:**
- Product perspective
- Product functions (high-level)
- User classes and characteristics
- Operating environment
- Design and implementation constraints
- Assumptions and dependencies

**Format:**
```markdown
## 2. Overall Description

### 2.1 Product Perspective
The system is an independent application that replaces the legacy [Old System Name]. It integrates with [External System 1] and [External System 2].

### 2.2 User Classes
| User Class | Description | Privilege Level |
|------------|-------------|-----------------|
| Admin | System administrator who manages users and settings. | High |
| End User | Regular user who interacts with core features. | Low |
```

---

### 3. Functional Requirements
**Purpose:** Detailed description of all software functions.

**Format Pattern:**
```markdown
## 3. Functional Requirements

### 3.1 User Authentication (FR-01)
**Description:** The system shall allow users to securely log in.
**Priority:** High

**Sub-requirements:**
- **FR-01.1:** The system shall require an email and password for login.
- **FR-01.2:** The system shall lock the account after 5 failed login attempts.
- **FR-01.3:** The system shall support password reset via email link.

### 3.2 Report Generation (FR-02)
**Description:** The system shall allow admins to generate usage reports.
**Priority:** Medium
...
```

---

### 4. External Interface Requirements
**Purpose:** Specify how the software interacts with people, hardware, and other software.

**Content:**
- User Interfaces (UI expectations, wireframe references)
- Hardware Interfaces (devices, sensors)
- Software Interfaces (databases, APIs, third-party libraries)
- Communication Interfaces (protocols, network standards)

**Format:**
```markdown
## 4. External Interface Requirements

### 4.1 User Interfaces
- The web interface shall be responsive and support minimum resolution of 320x480.
- The UI shall follow the [Company Name] Design System guidelines.

### 4.2 Software Interfaces
- **Database:** PostgreSQL 15+ for data persistence.
- **Payment Gateway:** Stripe API v3 for processing transactions.
```

---

### 5. Non-Functional Requirements
**Purpose:** Specify the quality attributes, performance, and security constraints.

**Content:**
- Performance requirements
- Security requirements
- Reliability and availability
- Maintainability
- Scalability

**Format:**
```markdown
## 5. Non-Functional Requirements

### 5.1 Performance Requirements (NFR-01)
- The system shall respond to 95% of web requests within 500ms.
- The system shall support up to 10,000 concurrent users without degradation.

### 5.2 Security Requirements (NFR-02)
- All user passwords must be hashed using bcrypt (cost factor 12).
- Data at rest shall be encrypted using AES-256.
- The API must use OAuth 2.0 for authorization.
```

---

### 6. Use Cases & User Stories
**Purpose:** Provide actionable scenarios for development and testing.

**Format:**
```markdown
## 6. Use Cases & User Stories

### 6.1 Use Case: User Registration
**Actor:** Guest User
**Precondition:** User is not logged in.
**Main Flow:**
1. User navigates to the registration page.
2. User enters valid email, password, and confirmation password.
3. System validates input and creates a new account.
4. System sends a verification email.
**Alternative Flow:** If email is already registered, system displays an error message.

### 6.2 User Stories
- **US-01:** As a [User Role], I want to [Action], so that [Benefit/Value].
- **US-02:** As an Admin, I want to view the audit log, so that I can monitor system activity.
```

---

## Best Practices
1. **Be unambiguous:** Use specific language ("shall", "must"). Avoid vague terms like "fast", "user-friendly", or "robust".
2. **Be testable:** Every requirement must be verifiable through automated or manual testing.
3. **Traceability:** Assign unique IDs to requirements (e.g., FR-01, NFR-02) to link them to test cases and design specs.
4. **Consistency:** Ensure requirements do not contradict each other.
