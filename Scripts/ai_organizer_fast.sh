#!/bin/bash

# Fast AI Organizer - Pattern-first with optional AI enhancement
# Uses smart patterns first, then AI only for unknowns
# Date: September 25, 2025

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     ⚡ FAST AI ORGANIZER - PATTERN FIRST                  ║"
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

# Configuration
SOURCE_DIR="${1:-$HOME/Desktop/ORGANIZE_INBOX}"
DEST_BASE="${2:-$HOME/Desktop/Google_Drive_Mirror/Sornell_Group_Shared_Drive}"
MODE="${3:-smart}"  # smart, aggressive, preserve
USE_AI="${4:-minimal}"  # always, minimal, never
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
PROCESS_LOG="$DEST_BASE/fast_organizer_${TIMESTAMP}.log"
DUPLICATE_DB="/tmp/duplicate_hashes_${TIMESTAMP}.db"

echo -e "${PURPLE}⚡ Fast Organization Mode${NC}"
echo -e "${CYAN}📍 Source: $SOURCE_DIR${NC}"
echo -e "${CYAN}📂 Destination: $DEST_BASE${NC}"
echo -e "${CYAN}🔧 Mode: $MODE | AI: $USE_AI${NC}"
echo ""

# Create duplicate tracking database
touch "$DUPLICATE_DB"

# Pattern-based categorization (FAST)
categorize_by_pattern() {
    local filepath="$1"
    local filename=$(basename "$filepath")
    local filename_lower=$(echo "$filename" | tr '[:upper:]' '[:lower:]')
    local extension="${filename##*.}"
    local filesize=$(stat -f%z "$filepath" 2>/dev/null || echo "0")

    # Skip hidden and system files
    if [[ "$filename" == .* ]]; then
        echo "SKIP_HIDDEN"
        return 0
    fi

    # Property-specific patterns (highest priority)
    if [[ "$filename_lower" == *"parkdale"* ]]; then
        echo "PROPERTY_PARKDALE"
        return 0
    elif [[ "$filename_lower" == *"callodine"* ]]; then
        echo "PROPERTY_CALLODINE"
        return 0
    elif [[ "$filename_lower" == *"warwick"* ]]; then
        echo "PROPERTY_WARWICK"
        return 0
    elif [[ "$filename_lower" == *"fargo"* ]]; then
        echo "PROPERTY_FARGO"
        return 0
    elif [[ "$filename_lower" == *"livingstone"* ]]; then
        echo "PROPERTY_LIVINGSTONE"
        return 0
    elif [[ "$filename_lower" == *"saint"*james* ]] || [[ "$filename_lower" == *"st"*james* ]]; then
        echo "PROPERTY_STJAMES"
        return 0
    elif [[ "$filename_lower" == *"main"*street* ]] || [[ "$filename_lower" == *"9155"* ]]; then
        echo "PROPERTY_MAINSTREET"
        return 0
    fi

    # Document type patterns
    if [[ "$filename_lower" == *"lease"* ]] || [[ "$filename_lower" == *"rental"*agreement* ]]; then
        echo "LEGAL_LEASES"
        return 0
    elif [[ "$filename_lower" == *"tax"* ]] || [[ "$filename_lower" == *"w9"* ]] || [[ "$filename_lower" == *"1099"* ]]; then
        if [[ "$filename_lower" == *"2024"* ]]; then
            echo "TAX_2024"
        elif [[ "$filename_lower" == *"2023"* ]]; then
            echo "TAX_2023"
        else
            echo "TAX_DOCUMENTS"
        fi
        return 0
    elif [[ "$filename_lower" == *"invoice"* ]] || [[ "$filename_lower" == *"receipt"* ]] || [[ "$filename_lower" == *"payment"* ]]; then
        echo "FINANCIAL_INVOICES"
        return 0
    elif [[ "$filename_lower" == *"bank"* ]] || [[ "$filename_lower" == *"statement"* ]]; then
        echo "FINANCIAL_BANKING"
        return 0
    elif [[ "$filename_lower" == *"maintenance"* ]] || [[ "$filename_lower" == *"repair"* ]] || [[ "$filename_lower" == *"work"*order* ]]; then
        echo "MAINTENANCE"
        return 0
    elif [[ "$filename_lower" == *"tenant"* ]] || [[ "$filename_lower" == *"application"* ]] || [[ "$filename_lower" == *"resident"* ]]; then
        echo "TENANT_RECORDS"
        return 0
    elif [[ "$filename_lower" == *"insurance"* ]] || [[ "$filename_lower" == *"policy"* ]]; then
        echo "INSURANCE"
        return 0
    fi

    # Technical files by extension
    if [[ "$extension" == "sh" ]] || [[ "$extension" == "bash" ]]; then
        echo "SCRIPTS_BASH"
        return 0
    elif [[ "$extension" == "py" ]] || [[ "$extension" == "ipynb" ]]; then
        echo "SCRIPTS_PYTHON"
        return 0
    elif [[ "$extension" == "js" ]] || [[ "$extension" == "ts" ]] || [[ "$extension" == "jsx" ]] || [[ "$extension" == "tsx" ]]; then
        echo "SCRIPTS_JAVASCRIPT"
        return 0
    elif [[ "$extension" == "sql" ]] || [[ "$extension" == "db" ]]; then
        echo "DATABASE"
        return 0
    elif [[ "$extension" == "json" ]] || [[ "$extension" == "yaml" ]] || [[ "$extension" == "yml" ]] || [[ "$extension" == "toml" ]]; then
        echo "CONFIGS"
        return 0
    elif [[ "$extension" == "md" ]] || [[ "$extension" == "txt" ]] || [[ "$extension" == "doc" ]] || [[ "$extension" == "docx" ]]; then
        echo "DOCUMENTS"
        return 0
    elif [[ "$extension" == "xls" ]] || [[ "$extension" == "xlsx" ]] || [[ "$extension" == "csv" ]]; then
        echo "SPREADSHEETS"
        return 0
    elif [[ "$extension" == "pdf" ]]; then
        echo "PDF_FILES"
        return 0
    elif [[ "$extension" == "jpg" ]] || [[ "$extension" == "jpeg" ]] || [[ "$extension" == "png" ]] || [[ "$extension" == "gif" ]]; then
        echo "IMAGES"
        return 0
    elif [[ "$extension" == "mp4" ]] || [[ "$extension" == "mov" ]] || [[ "$extension" == "avi" ]]; then
        echo "VIDEOS"
        return 0
    fi

    # Date-based patterns
    if [[ "$filename_lower" == *"2025"* ]]; then
        echo "ACTIVE_2025"
        return 0
    elif [[ "$filename_lower" == *"2024"* ]]; then
        echo "ARCHIVED_2024"
        return 0
    elif [[ "$filename_lower" == *"2023"* ]]; then
        echo "ARCHIVED_2023"
        return 0
    fi

    # Business patterns
    if [[ "$filename_lower" == *"contract"* ]] || [[ "$filename_lower" == *"agreement"* ]]; then
        echo "LEGAL_CONTRACTS"
        return 0
    elif [[ "$filename_lower" == *"report"* ]] || [[ "$filename_lower" == *"analysis"* ]]; then
        echo "REPORTS"
        return 0
    fi

    # If no pattern matches, return UNKNOWN for potential AI processing
    echo "UNKNOWN"
    return 1
}

# Use AI only for unknowns (if enabled)
categorize_with_ai() {
    local filepath="$1"
    local filename=$(basename "$filepath")
    local filesize=$(stat -f%z "$filepath" 2>/dev/null || echo "0")

    # Only use fast models
    local model="llama3.2:1b"
    if [ "$filesize" -gt 50000 ]; then
        model="llama3.2:3b"
    fi

    # Simple prompt for speed
    local prompt="Categorize this file into ONE category:
File: $filename
Categories: PROPERTY_[NAME], FINANCIAL, LEGAL, MAINTENANCE, TENANT_RECORDS, TECHNOLOGY, ARCHIVED_[YEAR], GENERAL
Reply with ONLY the category."

    # Quick AI call with short timeout
    local category=$(echo "$prompt" | timeout 5 ollama run "$model" 2>/dev/null | head -1 | tr -d '\r\n' | grep -oE '^[A-Z][A-Z_0-9]*$')

    if [ -n "$category" ] && [ "${#category}" -ge 4 ]; then
        echo "$category"
        return 0
    fi

    # Final fallback
    echo "GENERAL"
    return 0
}

# Check if file is duplicate
is_duplicate() {
    local filepath="$1"
    local file_hash=$(md5 -q "$filepath" 2>/dev/null)

    if [ -z "$file_hash" ]; then
        return 1
    fi

    if grep -q "^$file_hash " "$DUPLICATE_DB"; then
        return 0  # Is duplicate
    else
        echo "$file_hash $filepath" >> "$DUPLICATE_DB"
        return 1  # Not duplicate
    fi
}

# Main processing function
process_file() {
    local filepath="$1"
    local filename=$(basename "$filepath")

    # Get pattern-based category first (FAST)
    local category=$(categorize_by_pattern "$filepath")

    # Handle special cases
    if [ "$category" = "SKIP_HIDDEN" ]; then
        echo -e "${YELLOW}  Skipping hidden: $filename${NC}"
        return 0
    fi

    # Check for duplicates
    if is_duplicate "$filepath"; then
        if [ "$MODE" = "aggressive" ]; then
            rm -f "$filepath" 2>/dev/null
            echo -e "${RED}  Deleted duplicate: $filename${NC}"
        else
            echo -e "${YELLOW}  Skipped duplicate: $filename${NC}"
        fi
        return 0
    fi

    # If unknown and AI is enabled, try AI
    if [ "$category" = "UNKNOWN" ] && [ "$USE_AI" != "never" ]; then
        if [ "$USE_AI" = "always" ] || [ "$USE_AI" = "minimal" ]; then
            echo -ne "${CYAN}  AI analyzing: $filename... ${NC}"
            category=$(categorize_with_ai "$filepath")
            echo -e "${GREEN}→ $category${NC}"
        else
            category="GENERAL"
        fi
    elif [ "$category" = "UNKNOWN" ]; then
        category="GENERAL"
    fi

    # Create destination directory
    local dest_dir="$DEST_BASE/$category"
    mkdir -p "$dest_dir"

    # Apply naming convention if needed
    local new_filename="$filename"
    if [[ ! "$filename" =~ ^[0-9]{4}_[0-9]{2}_[0-9]{2}_ ]]; then
        new_filename="$(date +%Y_%m_%d)_${filename}"
    fi

    # Move or copy file
    local dest_path="$dest_dir/$new_filename"

    if [ "$MODE" = "preserve" ]; then
        cp "$filepath" "$dest_path" 2>/dev/null && echo -e "${GREEN}  ✓ Copied to $category${NC}"
    else
        mv "$filepath" "$dest_path" 2>/dev/null && echo -e "${GREEN}  ✓ Moved to $category${NC}"
    fi

    echo "$(date '+%Y-%m-%d %H:%M:%S')|ORGANIZED|$filename|$category" >> "$PROCESS_LOG"
    return 0
}

# Process directory with progress
process_directory() {
    local dir="$1"
    local depth="${2:-0}"

    # Visual depth indicator
    local indent=""
    for ((i=0; i<depth; i++)); do
        indent="  $indent"
    done

    echo -e "${CYAN}${indent}📁 Processing: $(basename "$dir")${NC}"

    # Process files in this directory
    local file_count=0
    for filepath in "$dir"/*; do
        if [ -f "$filepath" ]; then
            ((file_count++))
            process_file "$filepath"
        fi
    done

    if [ "$file_count" -gt 0 ]; then
        echo -e "${BLUE}${indent}  Processed $file_count files${NC}"
    fi

    # Process subdirectories
    for subdir in "$dir"/*; do
        if [ -d "$subdir" ]; then
            process_directory "$subdir" $((depth + 1))
        fi
    done

    # Only remove TRULY empty directories in aggressive mode
    # Check if directory has any files OR subdirectories
    if [ "$MODE" = "aggressive" ] && [ "$depth" -gt 0 ]; then
        local remaining=$(ls -A "$dir" 2>/dev/null | wc -l | tr -d ' ')
        if [ "$remaining" -eq 0 ]; then
            rmdir "$dir" 2>/dev/null && echo -e "${YELLOW}${indent}  Removed empty directory${NC}"
        fi
    fi
}

# Main execution
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${PURPLE}Starting Fast Processing${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"

# Ensure Ollama is running if AI is enabled
if [ "$USE_AI" != "never" ]; then
    if ! pgrep -x "ollama" > /dev/null; then
        echo -e "${CYAN}Starting Ollama for AI fallback...${NC}"
        ollama serve &>/dev/null &
        sleep 2
    fi
fi

# Count total files
TOTAL_FILES=$(find "$SOURCE_DIR" -type f 2>/dev/null | wc -l | tr -d ' ')
echo -e "${CYAN}📊 Total files: $TOTAL_FILES${NC}"
echo ""

START_TIME=$(date +%s)

# Process everything
process_directory "$SOURCE_DIR"

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

# Cleanup
rm -f "$DUPLICATE_DB"

# Statistics
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}              ✅ FAST PROCESSING COMPLETE                     ${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"

# Show category distribution
echo ""
echo -e "${CYAN}📊 Files by Category:${NC}"
for category_dir in "$DEST_BASE"/*; do
    if [ -d "$category_dir" ]; then
        count=$(find "$category_dir" -type f 2>/dev/null | wc -l | tr -d ' ')
        if [ "$count" -gt 0 ]; then
            printf "  %-30s: %5d files\n" "$(basename "$category_dir")" "$count"
        fi
    fi
done | sort -t: -k2 -rn | head -20

echo ""
echo -e "${GREEN}⏱️  Processing time: $((DURATION / 60)) min $((DURATION % 60)) sec${NC}"
echo -e "${GREEN}📋 Log file: $PROCESS_LOG${NC}"
echo ""

exit 0