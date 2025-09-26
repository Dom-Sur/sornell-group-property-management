# 📚 MASTER GUIDE: AI File Organization System
*Complete documentation for your file organization and AI training scripts*

## Table of Contents
1. [Quick Start](#quick-start)
2. [Main Scripts Overview](#main-scripts-overview)
3. [How to Customize Scripts](#how-to-customize-scripts)
4. [Outdated File Detection](#outdated-file-detection)
5. [Script Locations](#script-locations)
6. [Troubleshooting](#troubleshooting)

---

## 🚀 Quick Start

### Your Main Script:
```bash
~/Documents/backup_and_organize.sh
```

### Basic Usage:
```bash
# Process Sornell_System_Guide folder
~/Documents/backup_and_organize.sh ~/Desktop/Sornell_System_Guide

# Process any folder
~/Documents/backup_and_organize.sh /path/to/any/folder

# Process Downloads
~/Documents/backup_and_organize.sh ~/Downloads
```

---

## 📂 Main Scripts Overview

### 1. **backup_and_organize.sh** (PRIMARY SCRIPT)
**Location:** `~/Documents/backup_and_organize.sh`
**Purpose:** Backs up to SSD1, organizes files, cleans originals
```bash
# Usage
./backup_and_organize.sh [source_folder] [destination_folder]

# Default source: ~/Desktop/Sornell_System_Guide
# Default destination: ~/Documents/Google_Drive_Mirror/Sornell_Group_Shared_Drive
```

### 2. **ai_migrate_fixed.sh**
**Location:** `~/Documents/Google_Drive_Mirror/Sornell_Group_Shared_Drive/ARCHIVED_ORIGINALS/ai_migrate_fixed.sh`
**Purpose:** Uses AI to categorize files
```bash
# Usage
./ai_migrate_fixed.sh [source] [destination]

# Example: Organize Downloads
./ai_migrate_fixed.sh ~/Downloads ~/Desktop/Organized
```

### 3. **organize_and_rename_files.sh**
**Location:** `~/Documents/Google_Drive_Mirror/Sornell_Group_Shared_Drive/ARCHIVED_ORIGINALS/organize_and_rename_files.sh`
**Purpose:** Renames files with proper naming convention
```bash
# Naming format: YYYY_MM_DD_CATEGORY_PROPERTY_DESCRIPTION_VERSION.ext
# Example: 2024_09_25_VAC_PARK_442Lower_Ready_v1.pdf
```

### 4. **train_property_models.sh**
**Location:** `~/Documents/Google_Drive_Mirror/Sornell_Group_Shared_Drive/ARCHIVED_ORIGINALS/train_property_models.sh`
**Purpose:** Creates and trains AI models
```bash
# Creates models:
# - parkdale-specialist
# - vacancy-crisis
# - delinquency-collector
# - domenic-business-v2
```

### 5. **daily_ai_training.sh**
**Location:** `~/Documents/Google_Drive_Mirror/Sornell_Group_Shared_Drive/ARCHIVED_ORIGINALS/daily_ai_training.sh`
**Purpose:** Daily model improvement routine
```bash
# Run every morning
./daily_ai_training.sh
```

---

## 🛠️ How to Customize Scripts

### Change Default Folders

#### Method 1: Edit Script Directly
```bash
# Open script
nano ~/Documents/backup_and_organize.sh

# Find these lines (around line 20-22):
SOURCE_DIR="${1:-$HOME/Desktop/Sornell_System_Guide}"
ORGANIZED_DIR="$HOME/Documents/Google_Drive_Mirror/Sornell_Group_Shared_Drive"

# Change to your preferred locations:
SOURCE_DIR="${1:-$HOME/Desktop/YourFolder}"
ORGANIZED_DIR="$HOME/Desktop/Google_Drive_Mirror/Sornell_Group_Shared_Drive"
```

#### Method 2: Pass Arguments
```bash
# Custom source and destination
~/Documents/backup_and_organize.sh /source/path /destination/path
```

### Update Google Drive Mirror Location

If you moved Google_Drive_Mirror to Desktop:
```bash
# Old path
$HOME/Documents/Google_Drive_Mirror

# New path
$HOME/Desktop/Google_Drive_Mirror

# Update in scripts - Find and replace:
sed -i '' 's|Documents/Google_Drive_Mirror|Desktop/Google_Drive_Mirror|g' ~/Documents/backup_and_organize.sh
```

### Add New Categories

Edit the categorization section:
```bash
# Current categories
SCRIPTS|PROPERTY|FINANCIAL|OPERATIONS|GENERAL

# Add new categories
SCRIPTS|PROPERTY|FINANCIAL|OPERATIONS|MARKETING|LEASES|MAINTENANCE|GENERAL
```

---

## 🔍 Outdated File Detection

### Files to Review (Potentially Outdated):

#### Meeting Notes (Review if >30 days old)
- `09_24_25_meeting/*` - Meeting from September 24
- `DELEGATIONDOCS/*` - May have old delegation info
- `delegations updated/*` - Check if still current

#### Old Versions (Definitely Review)
- `ARCHIVE_OLD_VERSIONS/*` - Previous system versions
- `COMPLETE_SORNELL_PACKAGE/*` - May be superseded

#### Implementation Docs (Check Relevance)
- `Implementation_Docs/*` - May have completed items
- `30_DAY_IMPLEMENTATION_ROADMAP.md` - Check progress

#### Property Estimates (Time-Sensitive)
- `parkdaleestimates/*` - Estimates expire after 30-60 days
- Check dates on all PDFs

### Recommended Actions:

1. **Meeting Notes → Archive after 60 days**
   - Keep in: `13_ARCHIVES/Meeting_History/`
   - Extract action items to current docs

2. **Old Estimates → Update or Archive**
   - If <30 days: Keep in property folder
   - If >30 days: Move to `13_ARCHIVES/Old_Estimates/`
   - If >90 days: Consider deletion

3. **Implementation Docs → Convert to SOPs**
   - Completed items → Create SOP document
   - Ongoing items → Update timeline
   - Failed items → Document lessons learned

---

## 📍 Script Locations

### Currently Active Scripts:
```bash
# Main backup script
~/Documents/backup_and_organize.sh

# All other scripts (after move)
~/Documents/Google_Drive_Mirror/Sornell_Group_Shared_Drive/ARCHIVED_ORIGINALS/
├── ai_migrate_fixed.sh
├── ai_migrate.sh
├── organize_and_rename_files.sh
├── train_property_models.sh
├── daily_ai_training.sh
├── collect_training_data.sh
└── [other scripts]
```

### Documentation Files:
```bash
~/Documents/Google_Drive_Mirror/Sornell_Group_Shared_Drive/ARCHIVED_ORIGINALS/
├── AI_MODEL_TRAINING_PLAN.md
├── AI_ORGANIZER_CUSTOMIZATION_GUIDE.md
├── LLM_MODELS_COMPLETE_GUIDE.md
├── LOCAL_MODEL_TRAINING_GUIDE.md
└── GOOGLE_DRIVE_IMPLEMENTATION_GUIDE.md
```

---

## 💪 Making Scripts Stronger

### 1. Add More Intelligence
```bash
# Add to select_model() function
if [[ "$filename" == *"2023"* ]] || [[ "$filename" == *"2022"* ]]; then
    echo "# OUTDATED: File from previous year"
fi
```

### 2. Add Progress Bar
```bash
# Add visual progress
show_progress() {
    local current=$1
    local total=$2
    local percent=$((current * 100 / total))
    printf "\rProgress: [%-50s] %d%%" $(printf '#%.0s' $(seq 1 $((percent/2)))) $percent
}
```

### 3. Add Email Notifications
```bash
# Send completion email
echo "Backup complete" | mail -s "File Organization Done" your.email@gmail.com
```

### 4. Add Duplicate Detection
```bash
# Check for duplicates before copying
if [ -f "$destination/$filename" ]; then
    if diff "$source/$filename" "$destination/$filename" >/dev/null; then
        echo "DUPLICATE: Skipping $filename"
        continue
    fi
fi
```

---

## 🔧 Troubleshooting

### Issue: "Script not found"
```bash
# Make executable
chmod +x ~/Documents/backup_and_organize.sh

# Check location
ls -la ~/Documents/*.sh
```

### Issue: "SSD1 not found"
```bash
# Check if mounted
ls /Volumes/

# Wait for drive to mount
sleep 5
```

### Issue: "Permission denied"
```bash
# Fix permissions
sudo chmod +x scriptname.sh

# Or run with bash
bash ~/Documents/backup_and_organize.sh
```

### Issue: "Google Drive Mirror not found"
```bash
# Update path in script if moved
# From: ~/Documents/Google_Drive_Mirror
# To: ~/Desktop/Google_Drive_Mirror
```

---

## 📊 File Age Analysis

### Check File Ages:
```bash
# Find files older than 30 days
find ~/Desktop/Sornell_System_Guide -type f -mtime +30 -exec ls -la {} \;

# Find files modified in last 7 days
find ~/Desktop/Sornell_System_Guide -type f -mtime -7 -exec ls -la {} \;
```

### Suggested Review Schedule:
- **Daily:** New files in 00_INBOX
- **Weekly:** Active project folders
- **Monthly:** All property folders
- **Quarterly:** Archives and reference materials
- **Yearly:** Complete system review

---

## 🎯 Priority Actions

1. **Update script paths** if Google_Drive_Mirror moved:
   ```bash
   sed -i '' 's|Documents/Google_Drive_Mirror|Desktop/Google_Drive_Mirror|g' ~/Documents/backup_and_organize.sh
   ```

2. **Review outdated files:**
   - September 24 meeting notes (1+ month old)
   - Parkdale estimates (check dates)
   - Old delegation docs

3. **Test the script:**
   ```bash
   ~/Documents/backup_and_organize.sh ~/Desktop/test_folder
   ```

---

## 💡 Quick Commands

```bash
# View this README
open ~/Desktop/SCRIPT_MASTER_README.md

# Edit main script
nano ~/Documents/backup_and_organize.sh

# Find all scripts
find ~ -name "*.sh" -type f 2>/dev/null | grep -E "migrate|organize|train"

# Check script permissions
ls -la ~/Documents/*.sh

# Run main backup script
~/Documents/backup_and_organize.sh ~/Desktop/Sornell_System_Guide
```

---

*Last Updated: September 25, 2024*
*Main Script: ~/Documents/backup_and_organize.sh*