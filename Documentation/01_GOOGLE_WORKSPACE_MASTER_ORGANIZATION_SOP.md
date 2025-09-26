# GOOGLE WORKSPACE MASTER ORGANIZATION SOP
## Standard Operating Procedure for Sornell Group Real Estate Portfolio
### Effective Date: September 2025

---

## 1. PURPOSE & SCOPE

This SOP establishes the standard procedures for organizing, managing, and maintaining Sornell Group's Google Workspace environment for a 43-unit real estate portfolio with scalability to 100+ units.

### Applicable To:
- All team members with Google Workspace access
- External collaborators with limited access
- Property management operations
- Financial documentation
- Legal and compliance records

---

## 2. FOLDER STRUCTURE STANDARDS

### 2.1 Primary Shared Drives (8 Total)

```
📁 01_PROPERTIES
   Purpose: All property-specific documentation
   Access: Domenic (Owner), Matthew (Editor), Jack (Editor)
   
📁 02_FINANCIAL_MANAGEMENT  
   Purpose: Accounting, banking, tax documents
   Access: Domenic (Owner), April (Editor), Jeff (Editor)
   
📁 03_OPERATIONS
   Purpose: Daily operations, SOPs, vendor management
   Access: Domenic (Owner), Team (Editor)
   
📁 04_LEGAL_COMPLIANCE
   Purpose: Legal documents, insurance, permits
   Access: Domenic (Owner), Limited (Viewer)
   
📁 05_STRATEGIC_PLANNING
   Purpose: Business plans, market analysis, investor materials
   Access: Domenic (Owner), Advisors (Editor)
   
📁 06_DEVELOPMENT
   Purpose: Construction projects, renovations
   Access: Domenic (Owner), Contractors (Limited)
   
📁 07_TEMPLATES
   Purpose: Standardized forms and documents
   Access: All (Viewer), Admins (Editor)
   
📁 08_EXTERNAL_SHARES
   Purpose: Controlled external collaboration
   Access: Custom per stakeholder
```

### 2.2 Property Folder Substructure

Each property in 01_PROPERTIES must have:
```
📁 [Property Address]
   ├── 📁 01_OWNERSHIP (Deeds, titles, purchase docs)
   ├── 📁 02_LEASES (Current and historical)
   ├── 📁 03_MAINTENANCE (Work orders, inspections)
   ├── 📁 04_FINANCIALS (Property-specific P&L)
   └── 📁 05_DOCUMENTATION (Photos, compliance)
```

---

## 3. FILE NAMING CONVENTIONS

### 3.1 Standard Format
```
[YYYY-MM-DD]_[CATEGORY]_[PROPERTY/PROJECT]_[DESCRIPTION]_[VERSION].[ext]
```

### 3.2 Category Codes
- **PROP** - Property Documents
- **LEASE** - Lease Agreements  
- **MAINT** - Maintenance Records
- **FIN** - Financial Documents
- **LEGAL** - Legal Documents
- **INS** - Insurance
- **TAX** - Tax Related
- **VENDOR** - Vendor Contracts
- **REPORT** - Reports
- **COMM** - Communications

### 3.3 Examples
- `2025-09-23_LEASE_123MainSt_Unit2B_Renewal_v1.pdf`
- `2025-09-23_FIN_Portfolio_MonthlyReport_FINAL.xlsx`
- `2025-09-23_MAINT_456ElmAve_HVACRepair_COMPLETE.pdf`

---

## 4. ACCESS CONTROL PROCEDURES

### 4.1 Permission Matrix

| Shared Drive | Domenic | Matthew | Jack | Bookkeeper | CFO | Advisors |
|-------------|---------|---------|------|------------|-----|----------|
| 01_PROPERTIES | Owner | Editor | Editor | Viewer* | Viewer | None |
| 02_FINANCIAL | Owner | Editor | Viewer | Editor | Editor | Viewer* |
| 03_OPERATIONS | Owner | Editor | Editor | Viewer | Viewer | Viewer |
| 04_LEGAL | Owner | Viewer | Viewer | None | Viewer | Viewer* |
| 05_STRATEGIC | Owner | Viewer | Viewer | None | Editor | Editor |

*Limited to specific folders

### 4.2 External Access Protocol

1. **Request Received**
   - Document requester identity
   - Verify business need
   - Check NDA status

2. **Access Grant**
   - Create folder in 08_EXTERNAL_SHARES
   - Set viewer-only permissions
   - Apply expiration date (max 90 days)
   - Send access instructions

3. **Monitoring**
   - Weekly access review
   - Monthly audit report
   - Quarterly permission cleanup

---

## 5. DAILY OPERATIONS PROCEDURES

### 5.1 Morning Routine (9:00 AM)

**Responsible:** Jack

1. **Check Inbox (5 minutes)**
   - Open `/00_INBOX/` folder
   - Count new documents
   - Identify urgent items

2. **Document Processing (15 minutes)**
   ```
   For each document:
   a. Verify naming convention
   b. Rename if needed
   c. Move to appropriate folder
   d. Set permissions
   e. Log in daily tracker
   ```

3. **Status Report (5 minutes)**
   - Email team with:
     - Files processed
     - Urgent items
     - Issues found

### 5.2 End of Day (5:00 PM)

1. Final inbox check
2. Update tracking sheet
3. Send EOD report to Domenic
4. Verify backup completed

---

## 6. WEEKLY PROCEDURES

### 6.1 Monday - Planning
- Team sync meeting (30 min)
- Review week priorities
- Assign special projects

### 6.2 Wednesday - Audit
- Permission review
- Check external access
- Update access log

### 6.3 Friday - Reporting
- Weekly metrics report
- Backup verification
- Archive old files

---

## 7. MONTHLY REQUIREMENTS

### 7.1 First Monday - Deep Audit

1. **Full Permission Review**
   - Export all permissions
   - Compare to matrix
   - Remove unauthorized access
   - Document changes

2. **Storage Optimization**
   - Identify files >100MB
   - Archive old documents
   - Remove duplicates
   - Report space saved

### 7.2 Month-End Reporting

Create dashboard with:
- Total documents
- Storage used
- Active users
- Security incidents
- Compliance status

---

## 8. SECURITY PROTOCOLS

### 8.1 Mandatory Settings
- ✅ 2-Factor Authentication required
- ✅ Specific people sharing only
- ✅ Download restrictions on sensitive docs
- ✅ 30-day default expiration
- ✅ Watermarking for legal documents

### 8.2 Red Flags - Immediate Action
- Bulk downloads by external user
- Sharing attempts to unauthorized emails
- Access from unusual locations
- Multiple failed login attempts

**Response Protocol:**
1. Suspend access immediately
2. Document incident
3. Notify Domenic within 15 minutes
4. Review audit logs

---

## 9. BACKUP & RECOVERY

### 9.1 Backup Schedule
- **Daily:** Google native backup
- **Weekly:** Critical folders to 7TB drive
- **Monthly:** Full portfolio backup
- **Quarterly:** Compliance archive
- **Annual:** Complete archive

### 9.2 Recovery Procedures

**File Deletion:**
1. Check Google Drive trash (30 days)
2. Use Google Vault if older
3. Restore from external backup
4. Document recovery

**System Failure:**
1. Switch to offline mode
2. Use local backups
3. Queue changes for sync
4. Communicate status

---

## 10. COMPLIANCE & RETENTION

### 10.1 Retention Periods
- Financial Records: 7 years
- Tax Documents: 7 years
- Leases: Term + 3 years
- Maintenance: 5 years
- Legal Documents: Permanent

### 10.2 Compliance Checklist
- [ ] Monthly permission audit
- [ ] Quarterly retention review
- [ ] Annual compliance assessment
- [ ] Document destruction log

---

## 11. QUALITY CONTROL

### 11.1 Daily Metrics
- Processing time: <4 hours
- Naming compliance: >95%
- Filing accuracy: >98%
- Permission accuracy: 100%

### 11.2 Weekly Targets
- Zero security incidents
- 100% backup success
- <24hr support response
- 95% user satisfaction

---

## 12. TRAINING REQUIREMENTS

### 12.1 New Team Member
- Day 1: System overview (2 hours)
- Day 2: Hands-on training (3 hours)
- Day 3: Supervised practice
- Week 1: Daily check-ins

### 12.2 Ongoing Training
- Monthly: New features
- Quarterly: Security refresh
- Annual: Full recertification

---

## 13. EMERGENCY CONTACTS

**Internal:**
- Domenic (Principal): [Phone]
- Matthew (Technical): [Phone]
- Jack (Operations): [Phone]

**External:**
- Google Support: 1-844-491-0215
- IT Backup: [Contact]

---

## 14. REVISION HISTORY

| Version | Date | Changes | Approved By |
|---------|------|---------|-------------|
| 1.0 | 2025-09-23 | Initial Release | Domenic |

---

**Document Owner:** Domenic Surianello
**Review Frequency:** Quarterly
**Next Review:** January 2026

---

END OF SOP