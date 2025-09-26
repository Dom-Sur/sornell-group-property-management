#!/bin/bash

# Process Archive TO_SORT - Redistribute files to proper SOP locations
# Date: September 25, 2025

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     📦 PROCESSING ARCHIVE/TO_SORT FOLDERS                 ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

BASE_DIR="$HOME/Desktop/Google_Drive_Mirror/Sornell_Group_Shared_Drive"
ARCHIVE_DIR="$BASE_DIR/09_ARCHIVE/TO_SORT"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

cd "$ARCHIVE_DIR" || exit 1

echo -e "${BLUE}Processing archived folders...${NC}"
echo ""

# Process each folder in TO_SORT
for folder in */; do
    [ ! -d "$folder" ] && continue

    folder_name="${folder%/}"
    echo -e "${YELLOW}Processing: $folder_name${NC}"

    case "$folder_name" in
        PROPERTY_*)
            # Extract property name and move to correct property folder
            prop="${folder_name#PROPERTY_}"
            case "$prop" in
                PARKDALE)
                    target="$BASE_DIR/01_PROPERTIES/436_Parkdale_Ave/05_DOCUMENTATION"
                    ;;
                CALLODINE)
                    target="$BASE_DIR/01_PROPERTIES/232_Callodine_Ave/05_DOCUMENTATION"
                    ;;
                WARWICK)
                    target="$BASE_DIR/01_PROPERTIES/186_Warwick_Dr/05_DOCUMENTATION"
                    ;;
                FARGO)
                    target="$BASE_DIR/01_PROPERTIES/157_Fargo_Ave/05_DOCUMENTATION"
                    ;;
                LIVINGSTONE)
                    target="$BASE_DIR/01_PROPERTIES/29_Livingstone_St/05_DOCUMENTATION"
                    ;;
                STJAMES)
                    target="$BASE_DIR/01_PROPERTIES/120_Saint_James_Pl/05_DOCUMENTATION"
                    ;;
                MAINSTREET)
                    target="$BASE_DIR/01_PROPERTIES/9155_Main_St/05_DOCUMENTATION"
                    ;;
                *)
                    target="$BASE_DIR/01_PROPERTIES/00_GENERAL"
                    ;;
            esac
            ;;

        FINANCIAL_*|TAX_*|SPREADSHEETS)
            target="$BASE_DIR/02_FINANCIAL_MANAGEMENT/00_TO_CATEGORIZE"
            ;;

        LEGAL_*|INSURANCE)
            target="$BASE_DIR/04_LEGAL_COMPLIANCE/00_TO_CATEGORIZE"
            ;;

        MAINTENANCE|TENANT_*)
            target="$BASE_DIR/03_OPERATIONS/00_TO_CATEGORIZE"
            ;;

        SCRIPTS*|DATABASE|CONFIGS)
            target="$BASE_DIR/10_TECHNOLOGY/00_IMPORTED"
            ;;

        DOCUMENTS|GENERAL|PDF_FILES)
            # These stay in archive but organized
            target="$BASE_DIR/09_ARCHIVE/$folder_name"
            ;;

        IMAGES|VIDEOS)
            target="$BASE_DIR/09_ARCHIVE/MEDIA/$folder_name"
            ;;

        ACTIVE_2025)
            target="$BASE_DIR/03_OPERATIONS/01_DAILY_OPERATIONS/2025"
            ;;

        ARCHIVED_*)
            year="${folder_name#ARCHIVED_}"
            target="$BASE_DIR/09_ARCHIVE/$year"
            ;;

        *)
            # Unknown folders stay for manual review
            echo "  ⚠ Unknown folder - keeping in TO_SORT"
            continue
            ;;
    esac

    # Create target and move
    mkdir -p "$target"

    # Count files
    file_count=$(find "$folder" -type f 2>/dev/null | wc -l | tr -d ' ')

    if [ "$file_count" -gt 0 ]; then
        echo "  Moving $file_count files to: ${target#$BASE_DIR/}"

        # Move folder contents
        if [ -d "$folder" ]; then
            # For large folders, show progress
            if [ "$file_count" -gt 100 ]; then
                echo -n "  Progress: "
                find "$folder" -type f 2>/dev/null | while read -r file; do
                    mv "$file" "$target/" 2>/dev/null
                    echo -n "."
                done
                echo ""
            else
                mv "$folder"/* "$target/" 2>/dev/null
            fi

            # Remove empty folder
            rmdir "$folder" 2>/dev/null
            echo -e "${GREEN}  ✓ Complete${NC}"
        fi
    else
        # Remove empty folder
        rmdir "$folder" 2>/dev/null
        echo "  Removed empty folder"
    fi
done

# Process individual files in TO_SORT root
echo ""
echo -e "${BLUE}Processing loose files in TO_SORT...${NC}"

find . -maxdepth 1 -type f 2>/dev/null | while read -r file; do
    filename=$(basename "$file")

    # Move to INBOX for SOP processing
    mv "$file" "$BASE_DIR/00_INBOX/TO_PROCESS/" 2>/dev/null
    echo "  Moved $filename to INBOX"
done

# Summary
echo ""
echo -e "${GREEN}════════════════════════════════════${NC}"
echo -e "${GREEN}Archive Processing Complete!${NC}"
echo ""

# Check what's left
remaining=$(find . -type f 2>/dev/null | wc -l | tr -d ' ')
remaining_folders=$(find . -type d -mindepth 1 2>/dev/null | wc -l | tr -d ' ')

echo "Remaining in TO_SORT:"
echo "  • Files: $remaining"
echo "  • Folders: $remaining_folders"

if [ "$remaining_folders" -gt 0 ]; then
    echo ""
    echo "Folders requiring manual review:"
    find . -type d -mindepth 1 2>/dev/null | while read -r dir; do
        echo "  - $(basename "$dir")"
    done
fi

echo ""
echo "Next steps:"
echo "1. Process INBOX with SOP organizer"
echo "2. Review any remaining TO_SORT items"
echo "3. Run file deduplication"