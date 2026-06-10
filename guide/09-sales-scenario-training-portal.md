# 09 — Sales Scenario Training Portal: Scenario-Based Learning Design, Frictionless Onboarding Architecture, and Data Model Discipline

**Source repo:** [andredavisme/sales-scenario-training-portal](https://github.com/andredavisme/sales-scenario-training-portal)  
**Completed:** 2026-06-10  
**Theme:** A browser-based scenario training portal for industrial electrical distribution sales reps, built on Supabase (Postgres + RLS) with a static HTML/CSS/JS frontend. Designed for reps with no prior technical background. The repo contains the schema design, content architecture, UX voice guidelines, security rules, and a post-mortem log. Taken together, these documents encode a philosophy about how to build training systems that actually produce behavioral change — and how to build any customer-facing data product without accumulating technical debt through poor decisions about access, naming, version control, and feedback design.

---

## 1. The Dual-Deliverable Model: Public Template and Internal Zip

The portal is designed as two simultaneous deliverables from the same codebase:

- **Deliverable A — Public Educational Template:** Supabase backend + GitHub Pages frontend, fully documented for developer reuse. The scenario data lives in the database. The frontend reads from it via the Supabase API.
- **Deliverable B — Internal Handoff Zip:** Self-contained single `index.html` with all scenario data embedded in JavaScript, no server or CDN calls required, launchable from any browser, distributed as a `.zip`.

The key design constraint on Deliverable B: it must work completely offline. No network dependency at runtime. The scenario data travels with the file.

### Business Takeaway
**Every deliverable that will be used by people who don't control the infrastructure should be self-contained.** A customer-facing price sheet that requires a live database connection will fail the moment the customer is in a meeting with no signal. A vendor-submitted RFQ that depends on a portal being online will stall the moment the portal has downtime. A training resource that requires a login will be abandoned the moment the login doesn't work. The internal zip principle applies broadly: design your external deliverables to be self-contained and not dependent on your infrastructure's availability.

**Applied to RFQ/service workflows:**
- Any document, guide, or reference that is distributed to customers or vendors should be renderable and usable without network access: PDF over web link, embedded data over live database query, download over portal login.
- For critical operational documents (spec sheets, price lists, delivery confirmations), maintain both a live version (always current) and a snapshot version (PDF or export) that was accurate at the time of commitment. Disputes are resolved from the snapshot, not from the live record.
- When building any customer-facing tool, ask: if the internet connection drops, if the portal is down, if the login fails — can the customer still do what they need to do? If not, redesign the dependency.
- Apply the same principle internally: reports that are only accessible through a live dashboard are unavailable during an outage. Export key operational reports to a shareable format on a schedule so that the data is always accessible independent of system availability.

---

## 2. The Scenario Data Model: Schema Design for Instructional Content

The scenarios table schema is defined explicitly:

```sql
CREATE TABLE public.scenarios (
  id          uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  module      text NOT NULL,  -- 'drives' | 'breakers' | 'power_supplies' | 'starters' | 'controls'
  prompt      text NOT NULL,
  choices     jsonb NOT NULL, -- [{"label": "A", "text": "..."}]
  answer      text NOT NULL,  -- single letter: 'A' | 'B' | 'C' | 'D'
  explanation text NOT NULL,
  difficulty  text NOT NULL,  -- 'easy' | 'medium' | 'hard'
  created_at  timestamptz DEFAULT now()
);
```

Four design decisions are embedded in this schema:
1. `choices` is `jsonb` rather than four separate columns — the number of choices can vary without a schema change
2. `answer` is a single letter, not a foreign key to the choices array — the schema is not over-normalized
3. `explanation` is a required field — the answer without the reasoning is not a complete record
4. `difficulty` is a controlled vocabulary — not free text, not a number, but a named tier

### Business Takeaway
**The schema of any content record encodes the assumption about what constitutes a complete record.** A question without an explanation is an incomplete record — the schema enforces this by making `explanation NOT NULL`. An order without a delivery commitment is an incomplete record. A quote without a validity date is an incomplete record. A customer complaint without a category is an incomplete record. The fields you mark as required define your minimum viable data standard.

**Applied to RFQ/service workflows:**
- For every record type in your system, define the minimum complete record: what fields are required for the record to be actionable? An order without a confirmed ship-to address is not a complete order. A vendor quote without a unit price and lead time is not a complete quote. A service ticket without a problem description is not a complete ticket.
- Use controlled vocabulary for categorical fields — not free text. A "status" field that accepts any text will eventually contain 47 variants of "pending." An `enum` or a dropdown with defined values is a data quality constraint that pays dividends every time the field is filtered, counted, or reported on.
- The `jsonb` pattern for variable-length structured data applies to business records too: rather than adding columns to a table every time a product has a new attribute, a structured `attributes` field holds the variable content while the required fields remain stable. This is especially relevant for RFQ line items where different product categories have different spec fields.
- `NOT NULL` on `explanation` is the schema equivalent of "no action without a reason." Apply the same principle to your change log fields: a status change without a reason field is an unexplained mutation.

---

## 3. Open Access Without Security Theater: RLS by Design, Not by Default

The access model decision is documented explicitly and dated: *"Open access (confirmed 2026-05-15). No login, no accounts, no session tracking required. The `anon` role has SELECT permission on `scenarios` only. No writes from the frontend — ever."*

The reasoning is clear: *"A login wall kills momentum before a rep has even seen a question. Progress tracking can be added later if needed; it should never be a prerequisite to launch."*

The security note is equally explicit: *"Even with open access, RLS is still enabled on every table. The anon policy is explicit and intentional — not a default or an oversight."*

This distinguishes between security theater (adding a login that provides no actual protection) and genuine security (RLS enabled, no writes from frontend, no service role key in frontend code, all secrets in Supabase Vault).

### Business Takeaway
**Friction that serves no security purpose is not security — it is abandonment bait.** A login wall in front of a resource that contains no sensitive information does not protect the business; it reduces engagement with the resource. A required field in an intake form that the business never uses does not improve data quality; it increases form abandonment. Every friction point in a customer or employee workflow should be justified by the value it protects, not by the assumption that more steps means more control.

**Applied to RFQ/service workflows:**
- Audit your customer-facing intake processes: how many fields, login steps, portal registrations, and verification steps are required before a customer can submit an RFQ, request a quote, or report a problem? For each step, identify what it protects. If the answer is "nothing," remove it.
- Distinguish between access control (who can see and change what) and friction (steps that slow everyone down equally). Access control is a security mechanism. Friction is a design failure.
- Apply the RLS principle to your data: for every data type, define who can read it and who can write it. These should be explicit decisions, not defaults. Default-open is a security failure. Default-closed is an operational failure. Explicit-and-documented is the correct state.
- The "no writes from frontend" rule applies to customer-facing tools: customers should be able to read confirmations, track status, and download documents — but not directly modify orders, pricing, or inventory records. All writes go through a controlled interface with authorization and audit logging.

---

## 4. UX Voice and Personality: Training Content That Has Energy

The voice guidelines are one of the most distinctive sections of the documentation:

**Tone principles:**
- **Direct.** Short sentences. No filler words.
- **Encouraging without being sappy.** "Nice — that's the one" beats "Correct! Great job!"
- **A little edge.** It's okay to be slightly irreverent. These are sales reps, not kindergarteners.
- **Fresh every session.** Vary feedback text. Never feel like reading from a script.

**Examples of voice done right:**
- ✅ "Yep. The VFD limits inrush — that's the play."
- ✅ "Nope. Think about what's upstream of the motor."
- ✅ "2 for 2. Let's keep it moving."

**Examples of voice done wrong:**
- ❌ "Congratulations! You answered correctly! Keep up the great work!"
- ❌ "I'm sorry, that answer is incorrect. The correct answer is B."
- ❌ "Welcome to the Sales Scenario Training Portal. Please select a module to begin."

The distinction: the right voice treats the learner as a capable adult in a challenging situation. The wrong voice performs positivity at them.

### Business Takeaway
**Every piece of communication your business sends — confirmation emails, error messages, onboarding flows, status updates — has a voice, and that voice either builds or erodes trust.** A confirmation email that says "Your request has been received and will be processed in the order in which it was received" communicates nothing and wastes the reader's attention. A confirmation that says "Got it. Your quote for 3x VFD-22kW is in queue — you'll hear back by Thursday" communicates a specific, human commitment.

**Applied to RFQ/service workflows:**
- Audit your outbound communications for the three wrong-voice patterns: excessive formality that performs professionalism rather than delivering it; generic positivity that says nothing; passive constructions that avoid commitment.
- Apply the "direct, no filler" principle to: order confirmations, quote cover notes, delivery notifications, problem resolution summaries, and customer-facing status messages. Every one of these is a trust-building or trust-eroding touchpoint.
- Apply the "specific over generic" principle to every timeline commitment: not "shortly" or "as soon as possible" but a day, a window, or a condition ("by end of day Thursday" or "as soon as we confirm stock, which we're checking now").
- Error messages and rejection notices deserve the same voice discipline. "Your submission was not processed due to an error" is not a communication; it is an abdication. "The ZIP code you entered doesn't match the state — fix that and resubmit" is a communication.

---

## 5. Fresh Every Session: Stateless Design as a Feature

The "Fresh Each Session" principle is documented as a deliberate design choice, not a technical limitation:

*"The portal loads fresh every time — no cookies, no stored progress, no 'welcome back' state. This is a feature, not a limitation."*

- The opening screen should feel like kicking off something, not resuming something
- Module selection is always the first step — never auto-resume
- Score resets on reload — reps retake modules to sharpen, not to "complete"

The design philosophy: training is not a checkbox. A rep who has "completed" the drives module by scoring 6/10 once has not learned drives. A rep who runs the module three times in a week, improving each time, has. Stateless design removes the false sense of completion that a progress bar creates.

### Business Takeaway
**"Completed" is not a learning outcome — it is an administrative milestone.** A sales rep who checked the box on product training has not necessarily learned to apply the product knowledge in a real customer conversation. A customer service rep who "completed" the escalation protocol training has not necessarily internalized when and how to escalate. Systems that track completion incentivize completing, not learning. Systems designed for repeated engagement incentivize sharpening.

**Applied to RFQ/service workflows:**
- For recurring processes where consistency matters (quoting, order entry, customer communication, issue escalation), design the workflow to be run fresh each time — not auto-populated from the previous instance in ways that carry forward stale assumptions.
- Distinguish between completion tracking (administrative) and competency tracking (operational). Completion tracking answers "did they do it." Competency tracking answers "can they do it reliably." Both have value, but confusing them leads to training programs that generate completion percentages without improving performance.
- Apply the stateless design principle to recurring reports: a monthly report that auto-populates from the previous month's template will inherit the previous month's assumptions, filters, and exclusions. Require an explicit confirmation at the start of each cycle that the current parameters are correct.
- The "score resets on reload" principle applies to customer satisfaction metrics: a customer who was happy six months ago and has not been asked since has not been confirmed as happy. Satisfaction is a current state, not a historical record.

---

## 6. Migration Naming Convention and Version Control Discipline

The migration convention is defined once and enforced absolutely:

`YYYYMMDD_NNN_description.sql` — **never edit a migration once applied to production.**

The open decision (OD-001) documents the discovery that seeds from Session 1 were applied to Supabase directly via MCP tool and were not version-controlled in the repo. The recommendation is explicit: Option A — apply via MCP AND push SQL files to `supabase/migrations/` for version control. The reasoning: *"Faster but seeds are not reproducible without the Supabase project."*

Reproducibility is the principle. A database state that exists only in the live system and cannot be reconstructed from source control is a fragile system.

### Business Takeaway
**Any operational state that cannot be reconstructed from a written record is a fragile dependency.** A pricing structure that exists only in one person's head is a single point of failure. A customer configuration that was applied directly to a live system without being documented is an undocumented change. A discount agreement that was set verbally and never written into the order system will generate a dispute the first time the rep who made the agreement is unavailable.

**Applied to RFQ/service workflows:**
- Every configuration, exception, agreement, and setting that governs how a customer or vendor relationship operates must be version-controlled: documented, dated, and accessible without the person who set it.
- Apply the migration naming convention principle to your own change records: `YYYYMMDD_description_owner` for every significant configuration change to a customer account, pricing agreement, or system setting. Never overwrite the record; create a new one with a date and reason.
- OD-001 applies directly: whenever you discover that a critical system state exists only in a live tool without a corresponding documented record, treat it as a high-priority risk item. The work to document and version-control it is always worth doing before the live tool becomes unavailable.
- Reproducibility is the test: if the system were reset to zero tomorrow, could you reconstruct the current state from your records? If not, identify what is missing and document it.

---

## 7. Post-Mortems as Institutional Memory: The PM Log

The training build guide includes a dedicated Chapter 15 for post-mortems, with two entries logged from the first day of work:

**PM-001 — Sandbox Path Resolution Failure**
- What happened: file generation failed because `~` resolved to a non-existent path
- Root cause: sandbox filesystem doesn't follow standard Linux home directory layout
- Fix: start every file-writing session with `echo $HOME && pwd`
- Rule added: Section 8 of this manual + Chapter 9 of warrior-x-docs training manual

**PM-002 — Repo Named After Client**
- What happened: repo was initially created as `eia-schneider-training-portal`, naming the client in the public URL
- Root cause: no naming rule existed at time of repo creation
- Fix: renamed to `sales-scenario-training-portal`
- Rule added: propagated to warrior-x-docs Ch. 7, 9, 10, and 15

Both post-mortems follow the same structure: what happened, root cause, fix, rule added. The rule-added field is the critical one — a post-mortem that produces a finding without producing a rule change is an incomplete post-mortem.

### Business Takeaway
**A post-mortem that does not produce a rule change is a root cause analysis without a preventive action — which means the same failure will recur.** The PM-002 example is particularly instructive: the failure was naming a public repo after a client, which embedded client data in a public URL. The fix was to rename the repo. But the rule that was added — *never put client names in the repo name, filenames, or commit messages — use generic names only* — is what prevents PM-002 from recurring on the next project.

**Applied to RFQ/service workflows:**
- Implement a post-mortem protocol for every significant operational failure: wrong shipment, missed delivery commitment, billing error, lost order, customer escalation. The protocol should require: what happened, root cause, fix applied, rule or process change added.
- The rule-added field is not optional. A post-mortem with no rule change is an incident report, not a corrective action. Incident reports describe history. Corrective actions prevent recurrence.
- Build a living post-mortem log, accessible to the team, that accumulates rules over time. This is your institutional memory for operational failures. New team members reading this log understand what has gone wrong before and why the current procedures are written the way they are.
- Apply the PM-002 principle broadly: what is the equivalent of "client name in public URL" in your business? Where does sensitive information appear in places that are less controlled than intended? Audit your external-facing naming conventions, filenames, email subjects, and shared documents for unintentional disclosure.

---

## 8. Security Rules: Non-Negotiable Constraints

The security rules are listed as absolute, not as guidelines:

- 🔴 Never put client or customer names in the repo name, filenames, or commit messages — use generic names only
- 🔴 RLS must be enabled on every table — even tables with open anon access
- 🔴 Never use the service role key in frontend code
- 🔴 No API keys, passwords, or secrets in GitHub — Supabase Vault only

The red flag designation signals that these are not preferences — they are constraints that, if violated, require immediate remediation.

### Business Takeaway
**Every business that handles customer data, vendor pricing, or internal financials has non-negotiable data handling rules — but most have not written them down as constraints rather than guidelines.** A guideline can be overridden by convenience or urgency. A constraint cannot. The difference between a guideline and a constraint is whether violation triggers immediate corrective action or a note in the next retrospective.

**Applied to RFQ/service workflows:**
- Define your non-negotiable data handling constraints: what customer data may never be in an unencrypted email attachment? What pricing information may never be in a public-facing document? What vendor terms may never be disclosed to competing vendors? Write these as red-flag constraints, not as best practices.
- Apply the naming rule to your own file and system naming conventions: customer names, contract values, and sensitive terms should not appear in file names that travel outside your controlled environment (email attachments, shared drives, public links).
- The "secrets in Vault only" rule applies to any credential or access key that governs access to systems: API keys, system passwords, EDI access credentials, and portal login details should be in a secrets manager, not in a spreadsheet, email, or shared document.
- Audit your current environment for constraint violations: where are credentials stored? Where do client names appear in places they shouldn't? Where is sensitive pricing accessible to parties who shouldn't have it? These are your PM-002 equivalents waiting to be discovered.

---

## Key Principles Summary

| Principle | Portal Pattern | Business Application |
|-----------|---------------|----------------------|
| Dual-deliverable | Public template + offline zip | External deliverables must be self-contained; snapshots for dispute resolution |
| Schema = minimum viable record | `explanation NOT NULL`; controlled vocabulary | Define required fields; `NOT NULL` is the schema equivalent of "no action without a reason" |
| Explicit access control | RLS enabled even with open anon access | Access control is explicit; distinguish security from friction |
| Voice discipline | Direct, specific, no filler; right vs. wrong examples | Every outbound communication is a trust touchpoint; remove corporate filler |
| Stateless design as feature | Fresh session; score resets; no false completion | Completion is administrative; competency is operational; don't confuse them |
| Migration convention | `YYYYMMDD_NNN_description.sql`; never edit applied | Every operational state must be reconstructable from written records |
| Post-mortem + rule change | PM log with required "rule added" field | Post-mortems without rule changes are incident reports, not corrective actions |
| Non-negotiable constraints | Red-flag rules, not guidelines | Write data handling rules as constraints; violations require immediate remediation |
