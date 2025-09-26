# 🚀 AI File Management Workflow
*Complete guide for intelligent file organization using Ollama models*

Last Updated: September 25, 2025 (v2.0 - Added Compliance Features)

---

## ⚠️ CURRENT STATUS
- **325 duplicate files detected** in ORGANIZE_INBOX
- All scripts restored to `~/Documents/`
- Ready for processing

---

## 📋 QUICK START

### Complete Workflow (3 Steps)
```bash
# 1. Backup files to SSD1
~/Documents/quick_backup.sh ~/Desktop/ORGANIZE_INBOX

# 2. Organize with AI (moves files to categories)
~/Documents/ai_organize_cleanup.sh ~/Desktop/ORGANIZE_INBOX

# 3. Deep analysis (optional but recommended)
~/Documents/deep_ai_analysis.sh ~/Desktop/Google_Drive_Mirror/Sornell_Group_Shared_Drive full
```

---

## 🛠️ AVAILABLE SCRIPTS

### Core Scripts (Main Workflow)
| Script | Purpose | Usage |
|--------|---------|--------|
| `quick_backup.sh` | Fast backup to SSD1, no compression | `~/Documents/quick_backup.sh [source_dir]` |
| `ai_organize_cleanup.sh` | AI categorization & move files | `~/Documents/ai_organize_cleanup.sh [source] [dest] [cleanup_mode]` |
| `deep_ai_analysis.sh` | Comprehensive file analysis | `~/Documents/deep_ai_analysis.sh [target] [full/quick/focused]` |
| `deep_ai_analysis_v2.sh` | **Enhanced analysis with naming & SOP compliance** | `~/Documents/deep_ai_analysis_v2.sh [target] [full/quick/naming/sop]` |

### Utility Scripts
| Script | Purpose | Usage |
|--------|---------|--------|
| `fast_backup_dedupe.sh` | Backup with deduplication | `~/Documents/fast_backup_dedupe.sh [source] [skip_compression]` |
| `backup_and_organize.sh` | Original backup & organize | `~/Documents/backup_and_organize.sh [source]` |
| `simple_fast_backup.sh` | Simple rsync backup | `~/Documents/simple_fast_backup.sh` |

---

## 📂 FILE CATEGORIES

Files are organized into these categories by AI:

- **SCRIPTS** - Code files (.sh, .py, .js)
- **PROPERTY** - Real estate documents
- **FINANCIAL** - Invoices, statements, financial docs
- **OPERATIONS** - Maintenance, daily operations
- **LEGAL** - Contracts, agreements
- **REPORTS** - Analytics, summaries
- **TEMPLATES** - Forms, boilerplates
- **PERSONAL_PROJECTS** - Personal code, projects
- **BUSINESS_GENERAL** - General business files
- **TECHNOLOGY** - Tech docs, configs
- **ARCHIVE** - Old/outdated files
- **GENERAL** - Everything else

---

## 🤖 AI MODELS USED

Your system uses 32+ Ollama models, including:

### Custom Business Models
- `domenic-business:latest` - Property management specialist
- `sornell-ops:8b-q5` - Operations & vacancy expert
- `domenic-music:latest` - Creative content

### Code Analysis
- `qwen2.5-coder:32b` - Advanced code analysis
- `starcoder2:15b` - Large code understanding
- `sqlcoder:15b` - Database/SQL analysis

### Reasoning & Analysis
- `deepseek-r1:7b` - Complex reasoning & recommendations
- `phi4:latest` - Pattern recognition
- `llama3.1:70b` - Large context understanding

---

## 💾 DEALING WITH DUPLICATES

### Check for duplicates:
```bash
# Count duplicate files
find ~/Desktop/ORGANIZE_INBOX -type f -exec md5 -q {} \; | sort | uniq -d | wc -l

# Find and list duplicates
find ~/Desktop/ORGANIZE_INBOX -type f -exec md5 -r {} + | \
  awk '{print $1}' | sort | uniq -d > ~/Desktop/duplicate_hashes.txt

# Use deduplication backup script
~/Documents/fast_backup_dedupe.sh ~/Desktop/ORGANIZE_INBOX skip
```

---

## 📏 NAMING CONVENTION & SOP COMPLIANCE (NEW!)

### Standard Naming Format
```
YYYY_MM_DD_CATEGORY_PROPERTY_DESCRIPTION_VERSION.ext
```

### Category Codes
| Code | Category | Example |
|------|----------|---------|
| DOC | Documents | 2025_09_25_DOC_ALL_Meeting_Notes_v1.pdf |
| FIN | Financial | 2025_09_25_FIN_PARK_Invoice_Maintenance_v1.pdf |
| LEA | Lease | 2025_09_25_LEA_442PARK_Tenant_Agreement_v2.docx |
| INS | Insurance | 2025_09_25_INS_ALL_Property_Coverage_v1.pdf |
| MNT | Maintenance | 2025_09_25_MNT_COBBLE_HVAC_Repair_v1.pdf |
| TAX | Tax | 2025_09_25_TAX_ALL_W9_Forms_v1.pdf |
| PROP | Property | 2025_09_25_PROP_FOREST_Deed_v1.pdf |
| OPS | Operations | 2025_09_25_OPS_ALL_Daily_Report_v1.xlsx |
| ADMIN | Administrative | 2025_09_25_ADMIN_ALL_Staff_Schedule_v1.doc |
| LEGAL | Legal | 2025_09_25_LEGAL_LIVING_Contract_v3.pdf |
| TECH | Technology | 2025_09_25_TECH_ALL_System_Config_v1.json |

### Property Codes
| Code | Property |
|------|----------|
| PARK | Parkdale (442/446) |
| COBBLE | Cobblestone |
| FOREST | Forest |
| LIVING | Livingston |
| FARGO | Fargo |
| CALLO | Callodine |
| STJAMES | Saint James |
| MAIN | Main Street |
| ALL | All Properties |

### Deep Analysis v2 - Compliance Features

#### Check Naming Conventions
```bash
# Analyze naming compliance only
~/Documents/deep_ai_analysis_v2.sh ~/Desktop/ORGANIZE_INBOX naming

# This will:
# ✓ Check all files against naming standards
# ✓ Generate compliant name suggestions
# ✓ Create batch rename script
# ✓ Provide compliance statistics
```

#### Check SOP Compliance
```bash
# Check standard operating procedures
~/Documents/deep_ai_analysis_v2.sh ~/Desktop/ORGANIZE_INBOX sop

# This will:
# ✓ Verify lease documents have required elements
# ✓ Check financial files are properly categorized
# ✓ Ensure maintenance files have property codes
# ✓ Validate sensitive file permissions
```

#### Full Compliance Analysis
```bash
# Complete analysis with all compliance checks
~/Documents/deep_ai_analysis_v2.sh ~/Desktop/Google_Drive_Mirror full

# Generates:
# • naming_compliance_[timestamp].md - Full naming report
# • batch_rename.sh - Script to fix all names
# • safe_automation.sh - Safe cleanup commands
# • undo_rename.sh - Reversal script if needed
```

### Safe Automation Commands
The analyzer generates these safe operations:
1. **Create safety backup** - Before any changes
2. **Fix permissions** - chmod 600 for W-9s, tax forms
3. **Remove system files** - .DS_Store, ._*, *.tmp
4. **Create date views** - Organize by year/month using symlinks
5. **Flag old files** - Identify files >1 year old
6. **Find large files** - Locate files >100MB
7. **Detect undated files** - Files missing date prefix

---

## 📊 WORKFLOWS

### 1️⃣ Standard Daily Workflow
```bash
# Morning routine
cd ~/Desktop/ORGANIZE_INBOX

# Step 1: Check what you have
ls -la | head -20
find . -type f | wc -l  # Count files

# Step 2: Backup everything
~/Documents/quick_backup.sh

# Step 3: Organize with AI
~/Documents/ai_organize_cleanup.sh

# Step 4: Verify organization
ls ~/Desktop/Google_Drive_Mirror/Sornell_Group_Shared_Drive/
```

### 2️⃣ Duplicate Cleanup Workflow
```bash
# Use dedup backup (recommended with 325 duplicates!)
~/Documents/fast_backup_dedupe.sh ~/Desktop/ORGANIZE_INBOX skip

# Then organize unique files only
~/Documents/ai_organize_cleanup.sh
```

### 3️⃣ Deep Analysis Workflow
```bash
# After organizing, analyze everything
~/Documents/deep_ai_analysis.sh ~/Desktop/Google_Drive_Mirror/Sornell_Group_Shared_Drive full

# View the report
cat deep_analysis_*.md
```

### 4️⃣ Complete Workflow with Compliance (RECOMMENDED)
```bash
# Step 1: Handle duplicates
~/Documents/fast_backup_dedupe.sh ~/Desktop/ORGANIZE_INBOX skip

# Step 2: Organize with AI
~/Documents/ai_organize_cleanup.sh ~/Desktop/ORGANIZE_INBOX

# Step 3: Check naming and SOP compliance
~/Documents/deep_ai_analysis_v2.sh ~/Desktop/Google_Drive_Mirror/Sornell_Group_Shared_Drive full

# Step 4: Review and fix naming issues
cat naming_compliance_*.md
# If needed, run the generated rename script:
~/.ai_context/batch_rename.sh

# Step 5: Run safe automation
~/.ai_context/safe_automation.sh ~/Desktop/Google_Drive_Mirror
```

### 5️⃣ Quick Triage (No Analysis)
```bash
# Just backup and organize, skip analysis
~/Documents/quick_backup.sh && \
~/Documents/ai_organize_cleanup.sh && \
echo "Done - analysis can wait"
```

---

## 🎯 MASTER WORKFLOW SCRIPT

Create a single command to run everything:

```bash
# Create master script
cat > ~/Documents/master_workflow.sh << 'EOF'
#!/bin/bash
echo "🚀 MASTER AI WORKFLOW"
echo "===================="

# Config
INBOX="${1:-$HOME/Desktop/ORGANIZE_INBOX}"
DEST="$HOME/Desktop/Google_Drive_Mirror/Sornell_Group_Shared_Drive"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check for duplicates first
echo -e "${YELLOW}Checking for duplicates...${NC}"
DUPES=$(find "$INBOX" -type f -exec md5 -q {} \; | sort | uniq -d | wc -l | tr -d ' ')
echo "Found $DUPES duplicate sets"

if [ "$DUPES" -gt 100 ]; then
    echo -e "${YELLOW}Many duplicates detected! Using dedup backup...${NC}"
    ~/Documents/fast_backup_dedupe.sh "$INBOX" skip
else
    echo -e "${BLUE}Standard backup...${NC}"
    ~/Documents/quick_backup.sh "$INBOX"
fi

echo -e "\n${BLUE}Organizing with AI...${NC}"
~/Documents/ai_organize_cleanup.sh "$INBOX" "$DEST"

echo -e "\n${BLUE}Quick analysis...${NC}"
~/Documents/deep_ai_analysis.sh "$DEST" quick

echo -e "\n${GREEN}✅ WORKFLOW COMPLETE!${NC}"
echo "Files organized to: $DEST"
EOF

chmod +x ~/Documents/master_workflow.sh
```

Then run: `~/Documents/master_workflow.sh`

---

## 📁 FILE LOCATIONS

### Input
- **Inbox:** `~/Desktop/ORGANIZE_INBOX/`
- **Drop new files here for processing**

### Output
- **Organized files:** `~/Desktop/Google_Drive_Mirror/Sornell_Group_Shared_Drive/`
- **Backups:** `/Volumes/SSD1/Backups/`
- **Analysis reports:** Project directories
- **AI context:** `~/.ai_context/`
- **Logs:** In destination folder

---

## 🔍 MONITORING & LOGS

### View recent processing:
```bash
# Check latest AI decisions
tail -50 ~/Desktop/Google_Drive_Mirror/Sornell_Group_Shared_Drive/ai_analysis_*.log

# See what got organized where
grep "MOVED" ~/Desktop/Google_Drive_Mirror/Sornell_Group_Shared_Drive/ai_analysis_*.log | tail -20

# Check for failures
grep "FAILED" ~/Desktop/Google_Drive_Mirror/Sornell_Group_Shared_Drive/ai_analysis_*.log
```

### Check AI model status:
```bash
# List available models
ollama list

# Ensure Ollama is running
pgrep -x "ollama" || ollama serve &
```

---

## 🚨 TROUBLESHOOTING

### Issue: "SSD1 not found"
```bash
# Check if mounted
ls /Volumes/
# Mount your external drive first
```

### Issue: "Ollama not running"
```bash
# Start Ollama
ollama serve &
# Wait a few seconds
sleep 5
```

### Issue: "Too many duplicates"
```bash
# Use the deduplication script instead
~/Documents/fast_backup_dedupe.sh ~/Desktop/ORGANIZE_INBOX skip
```

### Issue: "Scripts not found"
```bash
# Verify scripts are in Documents
ls ~/Documents/*.sh
# Make executable if needed
chmod +x ~/Documents/*.sh
```

---

## 💡 PRO TIPS

1. **Process duplicates first** - With 325 duplicates, use `fast_backup_dedupe.sh`

2. **Run analysis overnight** - Deep analysis can take time with many files

3. **Check model performance**:
   ```bash
   # See which models are used most
   grep -o '[a-z0-9-]*:latest\|[a-z0-9-]*:[0-9]*b' ~/Desktop/Google_Drive_Mirror/Sornell_Group_Shared_Drive/ai_analysis_*.log | sort | uniq -c | sort -rn
   ```

4. **Create aliases** for common operations:
   ```bash
   echo "alias ai-organize='~/Documents/master_workflow.sh'" >> ~/.zshrc
   echo "alias ai-backup='~/Documents/quick_backup.sh'" >> ~/.zshrc
   echo "alias ai-analyze='~/Documents/deep_ai_analysis.sh'" >> ~/.zshrc
   source ~/.zshrc
   ```

5. **Schedule daily processing**:
   ```bash
   # Add to crontab for 3 AM daily
   echo "0 3 * * * ~/Documents/master_workflow.sh" | crontab -
   ```

---

## 📈 NEXT STEPS

1. **Deal with 325 duplicates** - Run dedup backup first
2. **Process ORGANIZE_INBOX** - Use master workflow
3. **Review organized files** - Check categories are correct
4. **Run deep analysis** - Get insights and recommendations
5. **Set up automation** - Create aliases and schedules

---

## 🆘 QUICK HELP

```bash
# What do I have?
ls ~/Documents/*.sh

# How many files to process?
find ~/Desktop/ORGANIZE_INBOX -type f | wc -l

# How many duplicates?
find ~/Desktop/ORGANIZE_INBOX -type f -exec md5 -q {} \; | sort | uniq -d | wc -l

# Just run everything
~/Documents/master_workflow.sh
```

## 🎯 QUICK REFERENCE - ENHANCED FEATURES

### Naming Convention Check
```bash
~/Documents/deep_ai_analysis_v2.sh . naming
```

### SOP Compliance Check
```bash
~/Documents/deep_ai_analysis_v2.sh . sop
```

### Full Analysis with Compliance
```bash
~/Documents/deep_ai_analysis_v2.sh . full
```

### Fix All Names (After Analysis)
```bash
~/.ai_context/batch_rename.sh
```

### Run Safe Cleanup
```bash
~/.ai_context/safe_automation.sh .
```

### Complete Workflow with Compliance
```bash
# One command to rule them all
~/Documents/master_workflow.sh && \
~/Documents/deep_ai_analysis_v2.sh ~/Desktop/Google_Drive_Mirror/Sornell_Group_Shared_Drive full
```

---

*Generated by AI Workflow System - September 25, 2025*
*Version 2.0 - Enhanced with Naming Convention and SOP Compliance*