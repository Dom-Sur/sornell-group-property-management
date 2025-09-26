#!/bin/bash

# Ultimate AI Organizer with Premium Models, Deduplication, and Deep Cleaning
# Processes ALL subdirectories recursively with intelligent cleanup
# Date: September 25, 2025

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     🧠 ULTIMATE AI ORGANIZER WITH DEEP CLEANING           ║"
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
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
PROCESS_LOG="$DEST_BASE/ultimate_organizer_${TIMESTAMP}.log"
DUPLICATE_DB="/tmp/duplicate_hashes_${TIMESTAMP}.db"

# Ensure Ollama is running
if ! pgrep -x "ollama" > /dev/null; then
    echo -e "${CYAN}🚀 Starting Ollama service...${NC}"
    ollama serve &>/dev/null &
    sleep 3
fi

echo -e "${PURPLE}🧠 Ultimate AI Organization Mode${NC}"
echo -e "${CYAN}📍 Source: $SOURCE_DIR${NC}"
echo -e "${CYAN}📂 Destination: $DEST_BASE${NC}"
echo -e "${CYAN}🔧 Mode: $MODE${NC}"
echo ""

# Create duplicate tracking database
touch "$DUPLICATE_DB"

# Files to auto-delete (junk)
JUNK_PATTERNS=(
    ".DS_Store"
    "*.tmp"
    "*.temp"
    "*.cache"
    "Thumbs.db"
    "desktop.ini"
    "*.log.1"
    "*.log.2"
    "*.old.log"
    "npm-debug.log*"
    "yarn-error.log*"
    ".npm/_logs/*"
    "*.swp"
    "*.swo"
    "*~"
    ".#*"
    "*.bak"
    "*.backup"
    "._*"
)

# Premium model selection with enhanced logic
select_premium_model() {
    local filename="$1"
    local filesize="$2"
    local content_preview="$3"
    local extension="${filename##*.}"
    local filename_lower=$(echo "$filename" | tr '[:upper:]' '[:lower:]')

    # Legal and contracts - DeepSeek for reasoning
    if [[ "$content_preview" == *"whereas"* ]] || [[ "$content_preview" == *"agreement"* ]] ||
       [[ "$filename_lower" == *"contract"* ]] || [[ "$filename_lower" == *"lease"* ]] ||
       [[ "$filename_lower" == *"agreement"* ]] || [[ "$filename_lower" == *"legal"* ]]; then
        echo "deepseek-r1:7b"

    # Property management - custom models
    elif [[ "$filename_lower" == *"parkdale"* ]]; then
        echo "parkdale-specialist:latest"
    elif [[ "$filename_lower" == *"vacancy"* ]] || [[ "$content_preview" == *"vacant unit"* ]]; then
        echo "vacancy-crisis:latest"
    elif [[ "$filename_lower" == *"maintenance"* ]] || [[ "$content_preview" == *"repair"* ]]; then
        echo "maintenance-predictor:latest"
    elif [[ "$filename_lower" == *"delinquent"* ]] || [[ "$filename_lower" == *"past due"* ]]; then
        echo "delinquency-collector:latest"
    elif [[ "$filename_lower" == *"tenant"* ]] || [[ "$filename_lower" == *"resident"* ]]; then
        echo "domenic-business-v2:latest"

    # Code files - Qwen for complex code
    elif [[ "$extension" == "py" ]] || [[ "$extension" == "js" ]] || [[ "$extension" == "ts" ]] ||
         [[ "$extension" == "jsx" ]] || [[ "$extension" == "tsx" ]] || [[ "$extension" == "java" ]]; then
        if [ "$filesize" -gt 100000 ]; then
            echo "qwen2.5-coder:32b"
        elif [ "$filesize" -gt 50000 ]; then
            echo "qwen2.5-coder:14b"
        else
            echo "qwen2.5-coder:7b"
        fi

    # Data and SQL
    elif [[ "$extension" == "sql" ]] || [[ "$extension" == "csv" ]] || [[ "$extension" == "json" ]]; then
        echo "sqlcoder:7b"

    # Financial - Mixtral for multi-domain reasoning
    elif [[ "$content_preview" == *"invoice"* ]] || [[ "$content_preview" == *"payment"* ]] ||
         [[ "$filename_lower" == *"financial"* ]] || [[ "$filename_lower" == *"tax"* ]]; then
        echo "mixtral:8x7b"

    # Medical/Healthcare (for future use)
    elif [[ "$filename_lower" == *"medical"* ]] || [[ "$filename_lower" == *"health"* ]] ||
         [[ "$content_preview" == *"patient"* ]] || [[ "$content_preview" == *"diagnosis"* ]]; then
        echo "meditron:7b"

    # Research and academic
    elif [[ "$filename_lower" == *"research"* ]] || [[ "$filename_lower" == *"paper"* ]] ||
         [[ "$extension" == "tex" ]] || [[ "$extension" == "bib" ]]; then
        echo "mixtral:8x7b"

    # Large files need powerful models
    elif [ "$filesize" -gt 500000 ]; then
        echo "qwen2.5:72b"
    elif [ "$filesize" -gt 100000 ]; then
        echo "qwen2.5:32b"

    # Small files can use faster models
    elif [ "$filesize" -lt 5000 ]; then
        echo "llama3.2:3b"

    # Default to Phi4 for general purpose
    else
        echo "phi4:latest"
    fi
}

# Check if file is duplicate
is_duplicate() {
    local filepath="$1"
    local file_hash=$(md5 -q "$filepath" 2>/dev/null)

    if [ -z "$file_hash" ]; then
        return 1
    fi

    if grep -q "^$file_hash " "$DUPLICATE_DB"; then
        echo -e "${YELLOW}  ⚠️  Duplicate detected: $(basename "$filepath")${NC}" >&2
        return 0
    else
        echo "$file_hash $filepath" >> "$DUPLICATE_DB"
        return 1
    fi
}

# Check if file should be deleted as junk
is_junk() {
    local filename="$1"
    local filepath="$2"

    for pattern in "${JUNK_PATTERNS[@]}"; do
        case "$filename" in
            $pattern)
                echo -e "${RED}  🗑️  Removing junk: $filename${NC}" >&2
                return 0
                ;;
        esac
    done

    # Check for empty files
    if [ ! -s "$filepath" ]; then
        echo -e "${RED}  🗑️  Removing empty file: $filename${NC}" >&2
        return 0
    fi

    return 1
}

# Enhanced categorization with content analysis
categorize_and_organize() {
    local filepath="$1"
    local filename=$(basename "$filepath")
    local filesize=$(stat -f%z "$filepath" 2>/dev/null || echo "0")

    # Skip if junk
    if is_junk "$filename" "$filepath"; then
        rm -f "$filepath" 2>/dev/null
        return 0
    fi

    # Skip if duplicate (in aggressive mode, delete; in smart mode, skip)
    if is_duplicate "$filepath"; then
        if [ "$MODE" == "aggressive" ]; then
            rm -f "$filepath" 2>/dev/null
            echo "$(date '+%Y-%m-%d %H:%M:%S')|DELETED_DUPLICATE|$filename" >> "$PROCESS_LOG"
        fi
        return 0
    fi

    # Get content preview for better AI analysis
    local content_preview=""
    if [ -f "$filepath" ] && [ "$filesize" -lt 500000 ]; then
        content_preview=$(head -c 5000 "$filepath" 2>/dev/null | tr '\n' ' ' | tr -d '\000' | cut -c 1-1000)
    fi

    # Select optimal model
    local model=$(select_premium_model "$filename" "$filesize" "$content_preview")

    # Enhanced AI categorization prompt
    local prompt="You are an expert file organizer. Analyze this file deeply.

File: '$filename'
Size: $filesize bytes
Content preview: '${content_preview:0:500}'

Categories:
- ACTIVE_OPERATIONS (current business operations, active tasks)
- PROPERTY_[NAME] (property-specific, use actual property name if detected)
- FINANCIAL_[YEAR] (financial docs, add year if detected)
- LEGAL_CONTRACTS (legal documents, agreements)
- TAX_[YEAR] (tax documents, add year)
- MAINTENANCE (repairs, work orders)
- TENANT_RECORDS (tenant information, applications)
- TECHNOLOGY (code, scripts, technical docs)
- ARCHIVED_[YEAR] (old/outdated, add year)
- REPORTS_ANALYTICS (reports, data analysis)
- PERSONAL_PROJECTS (personal non-business)
- REFERENCE_DOCS (templates, guides, manuals)

Consider content deeply. If property name found (Parkdale, Callodine, Main Street, etc),
use PROPERTY_[NAME]. If year found, append it. Be specific.

Reply with ONLY the category name."

    # Get AI categorization
    local category=$(echo "$prompt" | timeout 20 ollama run "$model" 2>/dev/null | \
                     head -1 | tr -d '\r\n' | \
                     sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | \
                     grep -oE '^[A-Z][A-Z_]*[A-Z0-9_]*$' | head -1)

    # Validate and fallback categorization if AI fails or gives invalid response
    if [ -z "$category" ] || [ "${#category}" -lt 4 ]; then
        echo -e "${YELLOW}  ⚠️  AI timeout, using smart fallback${NC}"

        # Smart pattern matching fallback
        if [[ "$filename_lower" == *"parkdale"* ]]; then
            category="PROPERTY_PARKDALE"
        elif [[ "$filename_lower" == *"callodine"* ]]; then
            category="PROPERTY_CALLODINE"
        elif [[ "$filename_lower" == *"main"* ]] && [[ "$filename_lower" == *"street"* ]]; then
            category="PROPERTY_MAINSTREET"
        elif [[ "$filename_lower" == *"2024"* ]]; then
            if [[ "$filename_lower" == *"tax"* ]]; then
                category="TAX_2024"
            elif [[ "$filename_lower" == *"financial"* ]]; then
                category="FINANCIAL_2024"
            else
                category="ARCHIVED_2024"
            fi
        elif [[ "$filename_lower" == *"2025"* ]]; then
            category="ACTIVE_OPERATIONS"
        elif [[ "$extension" == "sh" ]] || [[ "$extension" == "py" ]]; then
            category="TECHNOLOGY"
        elif [[ "$filename_lower" == *"lease"* ]]; then
            category="LEGAL_CONTRACTS"
        elif [[ "$filename_lower" == *"tenant"* ]]; then
            category="TENANT_RECORDS"
        else
            category="REFERENCE_DOCS"
        fi
    fi

    # Create destination with subdirectories for better organization
    local dest_dir="$DEST_BASE/$category"

    # Add date-based subdirectory for certain categories
    if [[ "$category" == "ACTIVE_OPERATIONS" ]] || [[ "$category" == "FINANCIAL_"* ]]; then
        local year_month=$(date +%Y_%m)
        dest_dir="$dest_dir/$year_month"
    fi

    mkdir -p "$dest_dir"

    # Apply naming convention
    local new_filename="$filename"
    if [[ ! "$filename" =~ ^[0-9]{4}_[0-9]{2}_[0-9]{2}_ ]]; then
        new_filename="$(date +%Y_%m_%d)_${category}_${filename}"
    fi

    # Move or copy based on mode
    local dest_path="$dest_dir/$new_filename"

    if [ "$MODE" == "preserve" ]; then
        cp "$filepath" "$dest_path" 2>/dev/null && echo -e "${GREEN}→ $category ✓${NC} [$model]"
    else
        mv "$filepath" "$dest_path" 2>/dev/null && echo -e "${GREEN}→ $category ✓${NC} [$model]"
    fi

    echo "$(date '+%Y-%m-%d %H:%M:%S')|ORGANIZED|$filename|$category|$model|$new_filename" >> "$PROCESS_LOG"
    return 0
}

# Process directory recursively with progress
process_directory_deep() {
    local dir="$1"
    local depth="${2:-0}"

    # Visual depth indicator
    local indent=""
    for ((i=0; i<depth; i++)); do
        indent="  $indent"
    done

    echo -e "${CYAN}${indent}📁 Processing: $(basename "$dir")${NC}"

    # Count files in this directory
    local file_count=$(find "$dir" -maxdepth 1 -type f ! -name ".DS_Store" 2>/dev/null | wc -l | tr -d ' ')

    if [ "$file_count" -gt 0 ]; then
        echo -e "${BLUE}${indent}  → Found $file_count files${NC}"

        # Process each file
        find "$dir" -maxdepth 1 -type f ! -name ".DS_Store" 2>/dev/null | while read -r filepath; do
            printf "${indent}    %-50s " "$(basename "$filepath" | cut -c 1-50)"
            categorize_and_organize "$filepath"
        done
    fi

    # Process subdirectories
    find "$dir" -maxdepth 1 -type d ! -path "$dir" 2>/dev/null | while read -r subdir; do
        if [[ "$(basename "$subdir")" != ".*" ]]; then
            process_directory_deep "$subdir" $((depth + 1))
        fi
    done

    # Remove empty directory if in aggressive mode
    if [ "$MODE" == "aggressive" ] && [ "$depth" -gt 0 ]; then
        rmdir "$dir" 2>/dev/null && echo -e "${RED}${indent}  🗑️  Removed empty directory${NC}"
    fi
}

# Main execution
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${PURPLE}Starting Ultimate AI Processing${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"

# Count total files
TOTAL_FILES=$(find "$SOURCE_DIR" -type f ! -name ".DS_Store" 2>/dev/null | wc -l | tr -d ' ')
echo -e "${CYAN}📊 Total files to process: $TOTAL_FILES${NC}"
echo ""

# Start processing
START_TIME=$(date +%s)

# Process the entire directory tree
process_directory_deep "$SOURCE_DIR"

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

# Cleanup
rm -f "$DUPLICATE_DB"

# Generate statistics
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}              ✅ ULTIMATE PROCESSING COMPLETE                 ${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"

# Show category distribution
echo ""
echo -e "${CYAN}📊 Organization Summary:${NC}"
grep "ORGANIZED" "$PROCESS_LOG" 2>/dev/null | cut -d'|' -f4 | sort | uniq -c | sort -rn | head -20

# Show model usage
echo ""
echo -e "${PURPLE}🧠 AI Models Used:${NC}"
grep "ORGANIZED" "$PROCESS_LOG" 2>/dev/null | cut -d'|' -f5 | sort | uniq -c | sort -rn

# Show statistics
ORGANIZED_COUNT=$(grep -c "ORGANIZED" "$PROCESS_LOG" 2>/dev/null || echo "0")
DUPLICATE_COUNT=$(grep -c "DELETED_DUPLICATE" "$PROCESS_LOG" 2>/dev/null || echo "0")

echo ""
echo -e "${GREEN}📈 Statistics:${NC}"
echo "  • Files organized: $ORGANIZED_COUNT"
echo "  • Duplicates removed: $DUPLICATE_COUNT"
echo "  • Processing time: $((DURATION / 60)) minutes"
echo "  • Log file: $PROCESS_LOG"
echo ""

exit 0