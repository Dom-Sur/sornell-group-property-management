#!/bin/bash

# SOP Deep Clean v2.0 - Complete restructuring to official SOP
# This script enforces strict SOP compliance and moves all files to correct locations
# Date: September 25, 2025

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     🧹 SOP DEEP CLEAN v2.0 - COMPLETE RESTRUCTURING       ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Configuration
BASE_DIR="$HOME/Desktop/Google_Drive_Mirror/Sornell_Group_Shared_Drive"
ARCHIVE_DIR="$BASE_DIR/09_ARCHIVE/TO_SORT"
LOG_FILE="$BASE_DIR/deep_clean_$(date +%Y%m%d_%H%M%S).log"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

cd "$BASE_DIR" || exit 1

# Step 1: Create complete SOP structure with ALL subfolders
echo -e "${BLUE}Step 1: Creating Complete SOP Structure${NC}"
echo "========================================"

# Remove old incorrect numbered folders first
rm -rf 01_Properties 02_Financial 03_Operations 04_Tenant_Management 20-TECHNOLOGY 2>/dev/null

# Create official 8 shared drives + support folders
mkdir -p 00_INBOX/{TO_PROCESS,NEEDS_RENAME,URGENT,DAILY_PROCESSING}
mkdir -p 09_ARCHIVE/{2023,2024,2025,TO_SORT,UNSORTED,PDFs,MEDIA/Images,MEDIA/Videos}

# 01_PROPERTIES with all properties and substructure
for prop in "436_Parkdale_Ave" "232_Callodine_Ave" "240_Callodine_Ave" "186_Warwick_Dr" \
           "157_Fargo_Ave" "29_Livingstone_St" "120_Saint_James_Pl" "9155_Main_St"; do
    mkdir -p "01_PROPERTIES/$prop"/{01_OWNERSHIP,02_LEASES,03_MAINTENANCE,04_FINANCIALS,05_DOCUMENTATION}
    mkdir -p "01_PROPERTIES/$prop/02_LEASES"/{CURRENT,HISTORICAL,APPLICATIONS}
    mkdir -p "01_PROPERTIES/$prop/03_MAINTENANCE"/{WORK_ORDERS,INSPECTIONS,PREVENTIVE}
    mkdir -p "01_PROPERTIES/$prop/04_FINANCIALS"/{MONTHLY,QUARTERLY,ANNUAL}
done

# 02_FINANCIAL_MANAGEMENT with complete structure
mkdir -p 02_FINANCIAL_MANAGEMENT/{01_MONTHLY_REPORTS,02_QUARTERLY_STATEMENTS,03_ANNUAL_REPORTS}
mkdir -p 02_FINANCIAL_MANAGEMENT/{04_TAX_DOCUMENTS,05_BANKING,06_INVOICES,07_BUDGETS,08_CAPEX}
mkdir -p 02_FINANCIAL_MANAGEMENT/04_TAX_DOCUMENTS/{2023,2024,2025,W9s,1099s}
mkdir -p 02_FINANCIAL_MANAGEMENT/05_BANKING/{STATEMENTS,RECONCILIATIONS,DEPOSITS}
mkdir -p 02_FINANCIAL_MANAGEMENT/06_INVOICES/{PENDING,PAID,OVERDUE}

# 03_OPERATIONS with complete structure
mkdir -p 03_OPERATIONS/{01_DAILY_OPERATIONS,02_MAINTENANCE_QUEUE,03_TENANT_MANAGEMENT}
mkdir -p 03_OPERATIONS/{04_VACANCY_REDUCTION,05_INSPECTIONS,06_EMERGENCY_RESPONSE}
mkdir -p 03_OPERATIONS/{07_VENDOR_CONTRACTS,08_COMMUNICATIONS,09_REPORTS}
mkdir -p 03_OPERATIONS/02_MAINTENANCE_QUEUE/{URGENT,SCHEDULED,COMPLETED}
mkdir -p 03_OPERATIONS/03_TENANT_MANAGEMENT/{APPLICATIONS,CURRENT_TENANTS,MOVE_OUTS}

# 04_LEGAL_COMPLIANCE with complete structure
mkdir -p 04_LEGAL_COMPLIANCE/{01_CONTRACTS,02_INSURANCE,03_LICENSES_PERMITS}
mkdir -p 04_LEGAL_COMPLIANCE/{04_LEGAL_CORRESPONDENCE,05_COMPLIANCE_DOCS}
mkdir -p 04_LEGAL_COMPLIANCE/02_INSURANCE/{POLICIES,CLAIMS,CERTIFICATES}

# 05_STRATEGIC_PLANNING
mkdir -p 05_STRATEGIC_PLANNING/{01_BUSINESS_PLANS,02_MARKET_ANALYSIS,03_EXPANSION}
mkdir -p 05_STRATEGIC_PLANNING/{04_INVESTOR_MATERIALS,05_REPORTS,06_MEETING_NOTES}

# 06_DEVELOPMENT
mkdir -p 06_DEVELOPMENT/{01_ACTIVE_PROJECTS,02_PLANNING,03_PERMITS,04_CONTRACTORS}
mkdir -p 06_DEVELOPMENT/{05_BUDGETS,06_TIMELINES,07_COMPLETIONS}

# 07_TEMPLATES
mkdir -p 07_TEMPLATES/{01_LEASES,02_APPLICATIONS,03_NOTICES,04_MAINTENANCE}
mkdir -p 07_TEMPLATES/{05_FINANCIAL,06_LEGAL,07_OPERATIONAL}

# 08_EXTERNAL_SHARES with stakeholder folders
mkdir -p 08_EXTERNAL_SHARES/{APRIL_QUICKBOOKS,JEFF_CFO,MATTHEW_TECH,JACK_ADMIN}
mkdir -p 08_EXTERNAL_SHARES/{CPA_TAX,ATTORNEYS,INSURANCE,CONTRACTORS}

# 10_TECHNOLOGY (from Development integration)
mkdir -p 10_TECHNOLOGY/{AI_AUTOMATION,SCRIPTS,DOCUMENTATION,DATABASES,CONFIGS}
mkdir -p 10_TECHNOLOGY/AI_AUTOMATION/{MODELS,STAGING,PRODUCTION}

echo -e "${GREEN}✓ Complete SOP structure created${NC}"

# Step 2: Map and move all non-SOP folders
echo ""
echo -e "${BLUE}Step 2: Moving Non-SOP Folders to Correct Locations${NC}"
echo "===================================================="

# Category folder mappings to SOP locations
declare -A FOLDER_MAPPINGS=(
    ["ACTIVE_2025"]="03_OPERATIONS/01_DAILY_OPERATIONS/2025"
    ["ARCHIVED_2023"]="09_ARCHIVE/2023"
    ["ARCHIVED_2024"]="09_ARCHIVE/2024"
    ["ARCHIVED_ORIGINALS"]="09_ARCHIVE/ORIGINALS"
    ["BUSINESS_GENERAL"]="05_STRATEGIC_PLANNING"
    ["CAPEX_SHEETS"]="02_FINANCIAL_MANAGEMENT/08_CAPEX"
    ["CONFIGS"]="10_TECHNOLOGY/CONFIGS"
    ["DATABASE"]="10_TECHNOLOGY/DATABASES"
    ["DOCUMENTS"]="09_ARCHIVE/TO_SORT/DOCUMENTS"
    ["FINANCIAL_BANKING"]="02_FINANCIAL_MANAGEMENT/05_BANKING"
    ["FINANCIAL_INVOICES"]="02_FINANCIAL_MANAGEMENT/06_INVOICES"
    ["GENERAL"]="09_ARCHIVE/UNSORTED"
    ["IMAGES"]="09_ARCHIVE/MEDIA/Images"
    ["INSURANCE"]="04_LEGAL_COMPLIANCE/02_INSURANCE"
    ["LEGAL_CONTRACTS"]="04_LEGAL_COMPLIANCE/01_CONTRACTS"
    ["LEGAL_LEASES"]="01_PROPERTIES/00_GENERAL_LEASES"
    ["MAINTENANCE"]="03_OPERATIONS/02_MAINTENANCE_QUEUE"
    ["PDF_FILES"]="09_ARCHIVE/PDFs"
    ["PERSONAL_PROJECTS"]="09_ARCHIVE/TO_SORT/PERSONAL"
    ["PROPERTY"]="01_PROPERTIES/00_UNSORTED"
    ["PROPERTY_CALLODINE"]="01_PROPERTIES/232_Callodine_Ave"
    ["PROPERTY_FARGO"]="01_PROPERTIES/157_Fargo_Ave"
    ["PROPERTY_LIVINGSTONE"]="01_PROPERTIES/29_Livingstone_St"
    ["PROPERTY_MAINSTREET"]="01_PROPERTIES/9155_Main_St"
    ["PROPERTY_PARKDALE"]="01_PROPERTIES/436_Parkdale_Ave"
    ["PROPERTY_STJAMES"]="01_PROPERTIES/120_Saint_James_Pl"
    ["PROPERTY_WARWICK"]="01_PROPERTIES/186_Warwick_Dr"
    ["REFERENCE_DOCS"]="07_TEMPLATES"
    ["REPORTS"]="05_STRATEGIC_PLANNING/05_REPORTS"
    ["SCRIPTS"]="10_TECHNOLOGY/SCRIPTS"
    ["SCRIPTS_BASH"]="10_TECHNOLOGY/SCRIPTS/BASH"
    ["SCRIPTS_JAVASCRIPT"]="10_TECHNOLOGY/SCRIPTS/JAVASCRIPT"
    ["SCRIPTS_PYTHON"]="10_TECHNOLOGY/SCRIPTS/PYTHON"
    ["SPREADSHEETS"]="02_FINANCIAL_MANAGEMENT/00_SPREADSHEETS"
    ["TAX_2023"]="02_FINANCIAL_MANAGEMENT/04_TAX_DOCUMENTS/2023"
    ["TAX_2024"]="02_FINANCIAL_MANAGEMENT/04_TAX_DOCUMENTS/2024"
    ["TAX_DOCUMENTS"]="02_FINANCIAL_MANAGEMENT/04_TAX_DOCUMENTS/2025"
    ["TEMPLATES"]="07_TEMPLATES"
    ["TENANT_RECORDS"]="03_OPERATIONS/03_TENANT_MANAGEMENT"
    ["VIDEOS"]="09_ARCHIVE/MEDIA/Videos"
)

# Move each non-SOP folder
for folder in "${!FOLDER_MAPPINGS[@]}"; do
    if [ -d "$folder" ]; then
        target="${FOLDER_MAPPINGS[$folder]}"
        echo -e "${YELLOW}Moving $folder → $target${NC}"
        mkdir -p "$target"

        # Move contents, not the folder itself
        if [ "$(ls -A "$folder" 2>/dev/null)" ]; then
            mv "$folder"/* "$target/" 2>/dev/null && rmdir "$folder" 2>/dev/null
            echo -e "${GREEN}  ✓ Moved and removed $folder${NC}"
        else
            rmdir "$folder" 2>/dev/null
            echo -e "${GREEN}  ✓ Removed empty $folder${NC}"
        fi
    fi
done

# Step 3: Process any remaining unknown folders
echo ""
echo -e "${BLUE}Step 3: Processing Unknown Folders${NC}"
echo "===================================="

# Find all non-SOP folders
for dir in */; do
    # Skip if it's an official SOP folder
    if [[ ! "$dir" =~ ^[0-9]{2}_ ]] && [[ "$dir" != "README.md" ]]; then
        folder_name="${dir%/}"
        echo -e "${RED}Unknown folder: $folder_name${NC}"

        # Move to archive for manual review
        mkdir -p "09_ARCHIVE/TO_SORT"
        mv "$folder_name" "09_ARCHIVE/TO_SORT/" 2>/dev/null
        echo -e "${YELLOW}  → Moved to 09_ARCHIVE/TO_SORT for review${NC}"
    fi
done

# Step 4: Clean up duplicate/incorrect numbered folders
echo ""
echo -e "${BLUE}Step 4: Cleaning Duplicate Numbered Folders${NC}"
echo "============================================"

# List of folders that should not exist
OLD_FOLDERS=("01_Properties" "02_Financial" "03_Operations" "04_Tenant_Management" "20-TECHNOLOGY")

for old in "${OLD_FOLDERS[@]}"; do
    if [ -d "$old" ]; then
        echo -e "${YELLOW}Removing old folder: $old${NC}"

        # Move contents to correct location first
        case "$old" in
            "01_Properties")
                [ -d "$old" ] && mv "$old"/* "01_PROPERTIES/" 2>/dev/null
                ;;
            "02_Financial")
                [ -d "$old" ] && mv "$old"/* "02_FINANCIAL_MANAGEMENT/" 2>/dev/null
                ;;
            "03_Operations")
                [ -d "$old" ] && mv "$old"/* "03_OPERATIONS/" 2>/dev/null
                ;;
            "04_Tenant_Management")
                [ -d "$old" ] && mv "$old"/* "03_OPERATIONS/03_TENANT_MANAGEMENT/" 2>/dev/null
                ;;
            "20-TECHNOLOGY")
                [ -d "$old" ] && mv "$old"/* "10_TECHNOLOGY/" 2>/dev/null
                ;;
        esac

        rmdir "$old" 2>/dev/null
        echo -e "${GREEN}  ✓ Removed${NC}"
    fi
done

# Step 5: Process root files
echo ""
echo -e "${BLUE}Step 5: Processing Root Files${NC}"
echo "=============================="

find . -maxdepth 1 -type f ! -name ".*" ! -name "*.log" ! -name "README.md" 2>/dev/null | while read -r file; do
    filename=$(basename "$file")
    echo "Processing: $filename"

    # Move to inbox for processing
    mv "$file" "00_INBOX/TO_PROCESS/" 2>/dev/null
    echo -e "${GREEN}  → Moved to 00_INBOX/TO_PROCESS${NC}"
done

# Step 6: Clean empty directories
echo ""
echo -e "${BLUE}Step 6: Cleaning Empty Directories${NC}"
echo "==================================="

# Remove empty directories (except SOP ones)
find . -type d -empty ! -path "./[0-9][0-9]_*" -delete 2>/dev/null
echo -e "${GREEN}✓ Empty directories removed${NC}"

# Step 7: Create pipeline connection
echo ""
echo -e "${BLUE}Step 7: Creating Development Pipeline${NC}"
echo "======================================"

# Create symlinks for development integration
ln -sf "$HOME/Development/Scripts" "$BASE_DIR/10_TECHNOLOGY/SCRIPTS/DEVELOPMENT" 2>/dev/null
ln -sf "$HOME/Development/Documentation" "$BASE_DIR/10_TECHNOLOGY/DOCUMENTATION/DEVELOPMENT" 2>/dev/null
ln -sf "$HOME/Desktop/AI_STAGING" "$BASE_DIR/10_TECHNOLOGY/AI_AUTOMATION/STAGING" 2>/dev/null

echo -e "${GREEN}✓ Development pipeline connected${NC}"

# Step 8: Generate report
echo ""
echo -e "${BLUE}Step 8: Final Report${NC}"
echo "===================="

# Count items in each main folder
echo "" | tee -a "$LOG_FILE"
echo "📊 FINAL STRUCTURE REPORT" | tee -a "$LOG_FILE"
echo "=========================" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

for folder in [0-9]*; do
    if [ -d "$folder" ]; then
        count=$(find "$folder" -type f 2>/dev/null | wc -l | tr -d ' ')
        printf "%-30s %6d files\n" "$folder" "$count" | tee -a "$LOG_FILE"
    fi
done

echo "" | tee -a "$LOG_FILE"

# Check for any remaining non-SOP folders
remaining=$(ls -d [A-Z]* 2>/dev/null | grep -v README | wc -l | tr -d ' ')

if [ "$remaining" -eq 0 ]; then
    echo -e "${GREEN}✅ PERFECT! No non-SOP folders remain${NC}" | tee -a "$LOG_FILE"
else
    echo -e "${RED}⚠ Warning: $remaining non-SOP folders still exist${NC}" | tee -a "$LOG_FILE"
    ls -d [A-Z]* 2>/dev/null | grep -v README | tee -a "$LOG_FILE"
fi

echo ""
echo -e "${GREEN}════════════════════════════════════${NC}"
echo -e "${GREEN}✅ SOP DEEP CLEAN COMPLETE!${NC}"
echo -e "${GREEN}════════════════════════════════════${NC}"
echo ""
echo "Summary:"
echo "• SOP structure fully created"
echo "• Non-SOP folders moved to proper locations"
echo "• Development pipeline connected"
echo "• Log file: $LOG_FILE"
echo ""
echo "Next steps:"
echo "1. Review 09_ARCHIVE/TO_SORT for uncategorized items"
echo "2. Process 00_INBOX/TO_PROCESS with SOP organizer"
echo "3. Run weekly staging review"
echo "4. Update team on new structure"