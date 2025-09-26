#!/bin/bash

# Deep Clean and Reorganize Google Drive Mirror
# Fixes malformed folder names and provides naming options

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     🧹 DEEP CLEAN GOOGLE DRIVE MIRROR                     ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
NC='\033[0m'

BASE_DIR="$HOME/Desktop/Google_Drive_Mirror/Sornell_Group_Shared_Drive"
cd "$BASE_DIR"

echo -e "${CYAN}📊 Current Status:${NC}"
echo ""

# Count problematic folders
MALFORMED=$(find . -maxdepth 1 -type d -name "*\[*" 2>/dev/null | wc -l | tr -d ' ')
UNDERSCORE=$(find . -maxdepth 1 -type d -name "*_*" 2>/dev/null | wc -l | tr -d ' ')
TOTAL=$(find . -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')

echo "  • Total folders: $TOTAL"
echo "  • Malformed (with ANSI codes): $MALFORMED"
echo "  • With underscores: $UNDERSCORE"
echo ""

echo -e "${YELLOW}Naming Convention Options:${NC}"
echo ""
echo "  1) Keep underscores (PROPERTY_PARKDALE)"
echo "  2) Use hyphens (PROPERTY-PARKDALE)"
echo "  3) Use spaces (PROPERTY PARKDALE)"
echo "  4) Use dots (PROPERTY.PARKDALE)"
echo "  5) Numbered prefix (01-PROPERTY-PARKDALE, 02-FINANCIAL)"
echo "  6) Clean names only (PROPERTY, FINANCIAL, etc)"
echo ""
echo -n "Choose naming style [1-6]: "
read -r NAMING_STYLE

echo ""
echo -e "${RED}⚠️  This will:${NC}"
echo "  1. Remove all malformed folder names with ANSI codes"
echo "  2. Clean up duplicate/empty folders"
echo "  3. Reorganize files into proper categories"
echo "  4. Apply your chosen naming convention"
echo ""
echo -n "Continue? (y/n): "
read -r CONFIRM

if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

# Step 1: Fix malformed folders (with ANSI codes)
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}Step 1: Fixing Malformed Folders${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"

for dir in */; do
    if [[ "$dir" == *"["* ]]; then
        # Extract the actual folder name from the mess
        # These folders have format like: [0;34mTEXT[0m filename [0;36m[model][0m → [0;32mCATEGORY[0m ✓
        if [[ "$dir" == *"PROPERTY"* ]]; then
            category="PROPERTY"
        elif [[ "$dir" == *"TECHNOLOGY"* ]]; then
            category="TECHNOLOGY"
        elif [[ "$dir" == *"OPERATIONS"* ]]; then
            category="OPERATIONS"
        elif [[ "$dir" == *"REPORTS"* ]]; then
            category="REPORTS"
        elif [[ "$dir" == *"TEMPLATES"* ]]; then
            category="TEMPLATES"
        elif [[ "$dir" == *"SCRIPTS"* ]]; then
            category="SCRIPTS"
        elif [[ "$dir" == *"GENERAL"* ]]; then
            category="GENERAL"
        else
            category="MISCELLANEOUS"
        fi

        # Move contents to proper folder
        echo -e "${YELLOW}Fixing: $(echo "$dir" | cut -c1-50)...${NC}"
        mkdir -p "$category"

        # Move any files in the malformed folder
        find "$dir" -type f 2>/dev/null -exec mv {} "$category/" \; 2>/dev/null

        # Remove the malformed folder
        rmdir "$dir" 2>/dev/null
        echo -e "${GREEN}  → Moved to $category${NC}"
    fi
done

# Step 2: Apply naming convention
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}Step 2: Applying Naming Convention${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"

# Define folder priority order for numbering
declare -a PRIORITY_ORDER=(
    "ACTIVE_OPERATIONS"
    "PROPERTY_PARKDALE"
    "PROPERTY_CALLODINE"
    "PROPERTY_WARWICK"
    "PROPERTY_FARGO"
    "PROPERTY_LIVINGSTONE"
    "PROPERTY_STJAMES"
    "PROPERTY_MAINSTREET"
    "FINANCIAL_INVOICES"
    "FINANCIAL_BANKING"
    "TAX_2024"
    "TAX_2023"
    "LEGAL_LEASES"
    "LEGAL_CONTRACTS"
    "MAINTENANCE"
    "TENANT_RECORDS"
    "INSURANCE"
    "TECHNOLOGY"
    "SCRIPTS_BASH"
    "SCRIPTS_PYTHON"
    "REPORTS"
    "DOCUMENTS"
    "ARCHIVED_2024"
    "ARCHIVED_2023"
    "GENERAL"
)

# Apply chosen naming style
case $NAMING_STYLE in
    1) # Keep underscores
        echo "Keeping underscore naming..."
        ;;

    2) # Use hyphens
        echo "Converting underscores to hyphens..."
        for dir in */; do
            if [[ "$dir" == *"_"* ]]; then
                newname="${dir//_/-}"
                newname="${newname%/}"
                if [ "$dir" != "$newname/" ] && [ ! -d "$newname" ]; then
                    mv "$dir" "$newname"
                    echo "  Renamed: $dir → $newname"
                fi
            fi
        done
        ;;

    3) # Use spaces
        echo "Converting underscores to spaces..."
        for dir in */; do
            if [[ "$dir" == *"_"* ]]; then
                newname="${dir//_/ }"
                newname="${newname%/}"
                if [ "$dir" != "$newname/" ] && [ ! -d "$newname" ]; then
                    mv "$dir" "$newname"
                    echo "  Renamed: $dir → $newname"
                fi
            fi
        done
        ;;

    4) # Use dots
        echo "Converting underscores to dots..."
        for dir in */; do
            if [[ "$dir" == *"_"* ]]; then
                newname="${dir//_/.}"
                newname="${newname%/}"
                if [ "$dir" != "$newname/" ] && [ ! -d "$newname" ]; then
                    mv "$dir" "$newname"
                    echo "  Renamed: $dir → $newname"
                fi
            fi
        done
        ;;

    5) # Numbered prefix
        echo "Adding numbered prefixes..."
        counter=10
        for folder in "${PRIORITY_ORDER[@]}"; do
            if [ -d "$folder" ]; then
                newname="${counter}-${folder//_/-}"
                mv "$folder" "$newname" 2>/dev/null
                echo "  Renamed: $folder → $newname"
                ((counter+=10))
            fi
        done
        ;;

    6) # Clean names only
        echo "Using clean names..."
        declare -A CLEAN_NAMES=(
            ["PROPERTY_PARKDALE"]="Parkdale Property"
            ["PROPERTY_CALLODINE"]="Callodine Properties"
            ["PROPERTY_WARWICK"]="Warwick Property"
            ["PROPERTY_FARGO"]="Fargo Property"
            ["PROPERTY_LIVINGSTONE"]="Livingstone Property"
            ["PROPERTY_STJAMES"]="St James Property"
            ["PROPERTY_MAINSTREET"]="Main Street Property"
            ["FINANCIAL_INVOICES"]="Invoices"
            ["FINANCIAL_BANKING"]="Banking"
            ["LEGAL_LEASES"]="Leases"
            ["LEGAL_CONTRACTS"]="Contracts"
            ["TAX_2024"]="Tax 2024"
            ["TAX_2023"]="Tax 2023"
            ["MAINTENANCE"]="Maintenance"
            ["TENANT_RECORDS"]="Tenants"
            ["TECHNOLOGY"]="Technology"
            ["REPORTS"]="Reports"
            ["DOCUMENTS"]="Documents"
        )

        for old_name in "${!CLEAN_NAMES[@]}"; do
            new_name="${CLEAN_NAMES[$old_name]}"
            if [ -d "$old_name" ]; then
                mv "$old_name" "$new_name" 2>/dev/null
                echo "  Renamed: $old_name → $new_name"
            fi
        done
        ;;
esac

# Step 3: Clean up empty folders
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}Step 3: Removing Empty Folders${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"

find . -type d -empty -delete 2>/dev/null
echo -e "${GREEN}✓ Empty folders removed${NC}"

# Step 4: Generate report
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}              ✅ DEEP CLEAN COMPLETE                          ${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"

echo ""
echo -e "${CYAN}📊 Final Structure:${NC}"
ls -d */ | head -20

echo ""
echo -e "${YELLOW}💡 Recommendations:${NC}"
echo "  1. Run Fast Organizer to reorganize any misplaced files"
echo "  2. Check for duplicates with duplicate finder"
echo "  3. Update any scripts that reference old folder names"
echo ""

exit 0