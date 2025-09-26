# Claude AI Context Store
## Sornell Group Property Management System

### System Overview
- **Portfolio:** 43 properties (scaling to 100+)
- **Team:** Domenic (Owner), Matthew (Tech), Jack (Admin), April (QB), Jeff (CFO)
- **Primary Drive:** Google Drive Mirror at ~/Desktop/Google_Drive_Mirror/Sornell_Group_Shared_Drive

### Official Folder Structure (SOP Compliant)
```
01_PROPERTIES/          # All 8 properties with subfolders
02_FINANCIAL_MANAGEMENT/ # Accounting, banking, tax
03_OPERATIONS/          # Daily ops, maintenance, vendors
04_LEGAL_COMPLIANCE/    # Legal, insurance, permits
05_STRATEGIC_PLANNING/  # Business plans, analysis
06_DEVELOPMENT/         # Construction, renovations
07_TEMPLATES/           # Standard forms
08_EXTERNAL_SHARES/     # Controlled external access
```

### File Naming Convention
```
[YYYY-MM-DD]_[CATEGORY]_[PROPERTY]_[DESCRIPTION]_[VERSION].[ext]
```

Category Codes: PROP, LEASE, MAINT, FIN, LEGAL, INS, TAX, VENDOR, REPORT, COMM

### Properties List
1. 436_Parkdale_Ave
2. 232_Callodine_Ave
3. 240_Callodine_Ave
4. 186_Warwick_Dr
5. 157_Fargo_Ave
6. 29_Livingstone_St
7. 120_Saint_James_Pl
8. 9155_Main_St

### AI Models Available (Ollama)
- **Legal:** deepseek-r1:7b, deepseek-r1:70b
- **Code:** qwen2.5-coder:32b, qwen2.5-coder:14b
- **Business:** domenic-business-v2:latest, vacant-specialist:latest
- **General:** phi4:latest, llama3.2:1b, llama3.2:3b
- **Medical:** meditron:7b, biomistral:latest
- **Math:** mathstral:7b, wizard-math:latest

### Development Environment
```
~/Development/
├── Claude_Projects/    # Active sessions
├── RAG_System/        # Embeddings & indexes
├── Context_Store/     # This file location
├── Scripts/           # All automation scripts
├── Documentation/     # SOPs and guides
└── Configs/          # Configuration files
```

### Staging Protocol
- **Staging Area:** ~/Desktop/AI_STAGING/
- **Testing Period:** 7 days minimum
- **Approval Required:** 3/3 team votes
- **Success Metrics:** 90%+ accuracy

### Key Scripts
1. **ai_organizer_with_staging.sh** - SOP-compliant with staging
2. **ai_organizer_fast.sh** - Pattern-based (1000+ files/min)
3. **ai_organizer_ultimate.sh** - AI-heavy processing
4. **ai_staging_weekly_review.sh** - Weekly analysis
5. **create_permanent_folders.sh** - Build SOP structure

### Daily Routine (per SOP Section 5)
- **9:00 AM:** Process INBOX, check urgent items
- **Throughout:** Monitor operations
- **5:00 PM:** Final processing, send EOD report

### Permission Matrix
| Drive | Domenic | Matthew | Jack | April | Jeff |
|-------|---------|---------|------|-------|------|
| Properties | Owner | Editor | Editor | Viewer | - |
| Financial | Owner | Editor | Viewer | Editor | Editor |
| Operations | Owner | Editor | Editor | Viewer | Viewer |
| Legal | Owner | Viewer | Viewer | - | Viewer |

### Current Tasks
- Organizing 270k+ files in Google Drive Mirror
- Testing AI suggestions in staging
- Maintaining SOP compliance
- Weekly innovation reviews

### Git Repository
- Location: ~/Development/
- Branches: main (production), staging (testing)
- Commit convention: "type: description"

### Important Notes
- NEVER create folders outside official 8 drives in production
- Test ALL new categories in AI_STAGING first
- Follow SOP naming convention strictly
- Run permission audit weekly
- Backup to 7TB drive monthly

---
Last Updated: September 25, 2025
Version: 1.0