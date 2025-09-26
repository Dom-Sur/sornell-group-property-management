# Production Pipeline Documentation
## Development to Production Workflow for Sornell Group

---

## 1. PIPELINE OVERVIEW

```mermaid
graph LR
    A[Development] --> B[Staging/Testing]
    B --> C[Review/Approval]
    C --> D[Production]
    D --> E[Google Drive]
    E --> F[Team Access]
```

---

## 2. ENVIRONMENT STRUCTURE

### Development Environment
```
~/Development/
├── Scripts/                  # All automation scripts
├── Documentation/            # SOPs and guides
├── Context_Store/           # Claude AI context
├── RAG_System/              # Future RAG implementation
└── Claude_Projects/         # Active projects
```

### Staging Environment
```
~/Desktop/AI_STAGING/
├── 00_AI_SUGGESTIONS/       # AI recommendations log
├── 01_TESTING/              # 7-day testing period
├── 02_VALIDATION/           # Awaiting approval
├── 03_APPROVED_PENDING/     # Ready for production
└── 04_REJECTED/            # Failed approval
```

### Production Environment
```
~/Desktop/Google_Drive_Mirror/Sornell_Group_Shared_Drive/
├── 00_INBOX/                # Document intake
├── 01_PROPERTIES/           # 8 properties
├── 02_FINANCIAL_MANAGEMENT/ # All financial
├── 03_OPERATIONS/           # Daily operations
├── 04_LEGAL_COMPLIANCE/     # Legal & insurance
├── 05_STRATEGIC_PLANNING/   # Business planning
├── 06_DEVELOPMENT/          # Construction
├── 07_TEMPLATES/            # Forms & templates
├── 08_EXTERNAL_SHARES/      # Stakeholder access
├── 09_ARCHIVE/              # Historical records
└── 10_TECHNOLOGY/           # Scripts & automation
```

---

## 3. FILE PROCESSING PIPELINE

### Stage 1: Intake (00_INBOX)
```bash
# Files arrive in INBOX
~/Desktop/ORGANIZE_INBOX/
    ↓
# Run SOP organizer
~/Development/Scripts/ai_sop_organizer.sh production ~/Desktop/ORGANIZE_INBOX
    ↓
# Files categorized to 00_INBOX/TO_PROCESS
```

### Stage 2: Processing
```bash
# Apply SOP naming convention
[YYYY-MM-DD]_[CATEGORY]_[PROPERTY]_[DESCRIPTION]_[VERSION].[ext]

# Route to correct folder
- Leases → 01_PROPERTIES/[Property]/02_LEASES
- Invoices → 02_FINANCIAL_MANAGEMENT/06_INVOICES
- Maintenance → 03_OPERATIONS/02_MAINTENANCE_QUEUE
- Insurance → 04_LEGAL_COMPLIANCE/02_INSURANCE
```

### Stage 3: Review & Approval
- Daily: Jack processes INBOX (9 AM & 5 PM)
- Weekly: Team reviews staging suggestions
- Monthly: Domenic approves SOP changes

### Stage 4: Production Deployment
```bash
# Move approved items from staging
mv ~/Desktop/AI_STAGING/03_APPROVED_PENDING/* ~/Desktop/Google_Drive_Mirror/

# Sync to Google Drive
# (Google Drive Desktop app handles sync automatically)
```

---

## 4. DEVELOPMENT TO PRODUCTION WORKFLOW

### For Scripts/Automation

1. **Development**
   ```bash
   # Create/edit in Development
   vim ~/Development/Scripts/new_script.sh

   # Test locally
   ./new_script.sh test
   ```

2. **Staging**
   ```bash
   # Test with staging flag
   ./new_script.sh staging

   # Monitor for 7 days
   ~/Development/Scripts/ai_staging_weekly_review.sh
   ```

3. **Production**
   ```bash
   # Deploy to production
   cp ~/Development/Scripts/new_script.sh ~/Desktop/Google_Drive_Mirror/Sornell_Group_Shared_Drive/10_TECHNOLOGY/SCRIPTS/

   # Update team
   echo "New script deployed: new_script.sh" >> ~/Desktop/Google_Drive_Mirror/Sornell_Group_Shared_Drive/00_INBOX/URGENT/deployment_notice.txt
   ```

### For Document Categories

1. **AI Suggests New Category**
   - Logged in AI_STAGING/00_AI_SUGGESTIONS/
   - Test folder created in 01_TESTING/

2. **7-Day Testing Period**
   - Files routed to test folder
   - Accuracy metrics collected

3. **Weekly Review Meeting**
   - Review metrics
   - Team votes (3/3 required)
   - Document decision

4. **SOP Update & Deployment**
   - Update Master Organization SOP
   - Create folder in production
   - Update all scripts
   - Train team

---

## 5. AUTOMATION SCRIPTS

### Daily Processing
```bash
# Morning routine (9:00 AM)
~/Development/Scripts/ai_sop_organizer.sh production ~/Desktop/ORGANIZE_INBOX

# Evening routine (5:00 PM)
~/Development/Scripts/ai_sop_organizer.sh production ~/Desktop/ORGANIZE_INBOX
```

### Weekly Reviews
```bash
# Generate staging report
~/Development/Scripts/ai_staging_weekly_review.sh

# Process archive
~/Development/Scripts/process_archive_to_sort.sh
```

### Monthly Maintenance
```bash
# Deep clean
~/Development/Scripts/sop_deep_clean_v2.sh

# Deduplication
~/Development/Scripts/dedup_check.sh

# Backup
rsync -av ~/Desktop/Google_Drive_Mirror/ /Volumes/7TB_Backup/
```

---

## 6. GIT WORKFLOW

### Branches
- `main` - Production-ready code
- `staging` - Testing new features
- `feature/*` - Development branches

### Commit Convention
```bash
git commit -m "type: description"

Types:
- feat: New feature
- fix: Bug fix
- docs: Documentation
- refactor: Code restructuring
- test: Testing
- chore: Maintenance
```

### Deployment
```bash
# Development
git checkout -b feature/new-organizer
# ... make changes ...
git commit -m "feat: Add new categorization rules"
git push origin feature/new-organizer

# Staging
git checkout staging
git merge feature/new-organizer
git push origin staging
# Test for 7 days

# Production
git checkout main
git merge staging
git tag -a v1.2.0 -m "Release version 1.2.0"
git push origin main --tags
```

---

## 7. MONITORING & METRICS

### Daily Metrics
- Files processed: Target 100%
- Naming compliance: Target >95%
- Processing time: Target <4 hours

### Weekly Metrics
- AI accuracy: Target >90%
- Manual interventions: Target <10%
- User satisfaction: Target >95%

### Monthly Metrics
- Storage optimization: Target <1TB
- Duplicate rate: Target <5%
- SOP compliance: Target 100%

---

## 8. EMERGENCY PROCEDURES

### Script Failure
```bash
# Check logs
tail -f ~/Desktop/Google_Drive_Mirror/Sornell_Group_Shared_Drive/*.log

# Rollback
git checkout main -- ~/Development/Scripts/
```

### Mass Misfilings
```bash
# Run deep clean
~/Development/Scripts/sop_deep_clean_v2.sh

# Restore from backup
rsync -av /Volumes/7TB_Backup/ ~/Desktop/Google_Drive_Mirror/
```

### Google Drive Sync Issues
1. Pause sync in Google Drive app
2. Run local organization
3. Verify structure
4. Resume sync

---

## 9. ACCESS CONTROLS

### Script Permissions
```bash
# Production scripts (executable by team)
chmod 755 ~/Desktop/Google_Drive_Mirror/*/10_TECHNOLOGY/SCRIPTS/*.sh

# Development scripts (owner only)
chmod 700 ~/Development/Scripts/*.sh

# Sensitive documents
chmod 600 ~/Desktop/Google_Drive_Mirror/*/02_FINANCIAL_MANAGEMENT/04_TAX_DOCUMENTS/*
```

### Folder Permissions (Google Drive)
- Owner: Domenic (all folders)
- Editor: Matthew (Tech), Jack (Admin)
- Viewer: April (Financial), Jeff (CFO)
- Limited: External stakeholders

---

## 10. CONTINUOUS IMPROVEMENT

### Weekly Innovation Review
1. Review AI suggestions
2. Analyze efficiency metrics
3. Identify bottlenecks
4. Propose improvements

### Monthly SOP Updates
1. Document changes needed
2. Test in staging
3. Get team approval
4. Update production

### Quarterly Training
1. Review new procedures
2. Hands-on practice
3. Q&A session
4. Certification

---

**Document Owner:** Domenic Surianello
**Technical Lead:** Matthew
**Operations Lead:** Jack
**Last Updated:** September 25, 2025
**Next Review:** October 1, 2025