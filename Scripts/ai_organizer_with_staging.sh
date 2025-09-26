#!/bin/bash

# AI Organizer with Staging - Tests improvements in MyDrive before SOP updates
# Version: 3.0 - Staging Protocol Compliant
# Date: September 25, 2025

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     🧪 AI ORGANIZER WITH STAGING PROTOCOL                 ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Configuration
MODE="${1:-staging}"  # staging or production
SOURCE_DIR="${2:-$HOME/Desktop/ORGANIZE_INBOX}"

# Staging vs Production paths
if [ "$MODE" = "staging" ]; then
    DEST_BASE="$HOME/Desktop/AI_STAGING/01_TESTING"
    SUGGESTION_LOG="$HOME/Desktop/AI_STAGING/00_AI_SUGGESTIONS/suggestions_$(date +%Y%m).csv"
    echo "🧪 STAGING MODE - Testing in MyDrive/AI_STAGING"
else
    DEST_BASE="$HOME/Desktop/Google_Drive_Mirror/Sornell_Group_Shared_Drive"
    echo "📁 PRODUCTION MODE - Using official SOP structure only"
fi

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Official SOP folders (these always exist)
declare -a SOP_FOLDERS=(
    "01_PROPERTIES"
    "02_FINANCIAL_MANAGEMENT"
    "03_OPERATIONS"
    "04_LEGAL_COMPLIANCE"
    "05_STRATEGIC_PLANNING"
    "06_DEVELOPMENT"
    "07_TEMPLATES"
    "08_EXTERNAL_SHARES"
)

# Initialize suggestion log
init_suggestion_log() {
    if [ "$MODE" = "staging" ]; then
        mkdir -p "$(dirname "$SUGGESTION_LOG")"
        if [ ! -f "$SUGGESTION_LOG" ]; then
            echo "Date,Time,Model,Suggested_Category,Pattern,File_Count,Confidence,Status" > "$SUGGESTION_LOG"
        fi
    fi
}

# Log AI suggestion
log_suggestion() {
    local category="$1"
    local pattern="$2"
    local confidence="$3"
    local model="${4:-ollama:latest}"

    if [ "$MODE" = "staging" ]; then
        echo "$(date +%Y-%m-%d),$(date +%H:%M:%S),$model,$category,$pattern,1,$confidence,Testing" >> "$SUGGESTION_LOG"
        echo -e "${YELLOW}💡 AI Suggestion logged: $category (Confidence: $confidence)${NC}"
    fi
}

# Check if folder exists in official SOP
is_sop_folder() {
    local folder="$1"
    for sop in "${SOP_FOLDERS[@]}"; do
        if [[ "$folder" == "$sop"* ]]; then
            return 0
        fi
    done
    return 1
}

# Smart categorization with staging fallback
categorize_file() {
    local file="$1"
    local filename=$(basename "$file")
    local category=""

    # Try pattern matching first (fast)
    if [[ "$filename" =~ [Ll]ease ]]; then
        category="01_PROPERTIES/[Property]/02_LEASES"
    elif [[ "$filename" =~ [Tt]ax|1099|W-?9 ]]; then
        category="02_FINANCIAL_MANAGEMENT/TAX_DOCUMENTS"
    elif [[ "$filename" =~ [Ii]nvoice|[Bb]ill ]]; then
        category="02_FINANCIAL_MANAGEMENT/INVOICES"
    elif [[ "$filename" =~ [Mm]aintenance|[Rr]epair ]]; then
        category="03_OPERATIONS/MAINTENANCE"
    elif [[ "$filename" =~ [Ii]nsurance|[Pp]olicy ]]; then
        category="04_LEGAL_COMPLIANCE/INSURANCE"
    elif [[ "$filename" =~ [Cc]ontract|[Aa]greement ]]; then
        category="04_LEGAL_COMPLIANCE/CONTRACTS"
    else
        # AI suggestion for unknown pattern
        if [ "$MODE" = "staging" ]; then
            # Use AI to suggest new category
            category=$(analyze_with_ai "$file")
            if [ -n "$category" ]; then
                log_suggestion "$category" "$filename" "0.75" "phi4:latest"
                # Create in staging
                mkdir -p "$DEST_BASE/$category"
            else
                category="00_UNCATEGORIZED"
            fi
        else
            category="00_INBOX/NEEDS_REVIEW"
        fi
    fi

    echo "$category"
}

# AI analysis function
analyze_with_ai() {
    local file="$1"
    local content=$(head -c 1000 "$file" 2>/dev/null | tr '\n' ' ')

    # Quick AI categorization
    local prompt="Categorize this file into a business folder. Reply with only the folder name: $content"

    # Use lightweight model for speed
    local suggestion=$(echo "$prompt" | ollama run llama3.2:1b 2>/dev/null | head -1)

    # Sanitize suggestion
    suggestion=$(echo "$suggestion" | tr ' ' '_' | tr -cd '[:alnum:]_')

    if [ -n "$suggestion" ]; then
        echo "AI_SUGGESTED/$suggestion"
    fi
}

# Process files
process_files() {
    local count=0
    local staged=0
    local processed=0

    echo -e "${BLUE}Processing files...${NC}"
    echo ""

    find "$SOURCE_DIR" -type f ! -name ".*" 2>/dev/null | while read -r file; do
        filename=$(basename "$file")

        # Get category
        category=$(categorize_file "$file")

        # Determine destination
        if is_sop_folder "$category"; then
            dest_dir="$DEST_BASE/$category"
            ((processed++))
        else
            if [ "$MODE" = "staging" ]; then
                dest_dir="$DEST_BASE/$category"
                ((staged++))
                echo -e "${YELLOW}→ Staging: $filename → $category${NC}"
            else
                dest_dir="$DEST_BASE/00_INBOX/NEEDS_REVIEW"
                echo -e "${RED}→ Unknown: $filename → INBOX for review${NC}"
            fi
        fi

        # Create directory and move file
        mkdir -p "$dest_dir"
        mv "$file" "$dest_dir/" 2>/dev/null && {
            ((count++))
            echo -e "${GREEN}✓ Processed: $filename${NC}"
        }
    done

    echo ""
    echo -e "${GREEN}════════════════════════════════════${NC}"
    echo -e "${GREEN}Processing Complete:${NC}"
    echo "  • Total files: $count"
    if [ "$MODE" = "staging" ]; then
        echo "  • Staged for testing: $staged"
        echo "  • Using SOP structure: $processed"
        echo ""
        echo "  📝 Review suggestions at:"
        echo "     $SUGGESTION_LOG"
    fi
    echo -e "${GREEN}════════════════════════════════════${NC}"
}

# Generate staging report
generate_staging_report() {
    if [ "$MODE" = "staging" ] && [ -f "$SUGGESTION_LOG" ]; then
        echo ""
        echo -e "${BLUE}📊 STAGING ANALYTICS${NC}"
        echo "========================"

        # Count suggestions by category
        echo "Top AI Suggestions:"
        tail -n +2 "$SUGGESTION_LOG" | cut -d',' -f3 | sort | uniq -c | sort -rn | head -5

        echo ""
        echo "Recent Activity:"
        tail -5 "$SUGGESTION_LOG"
    fi
}

# Main execution
main() {
    init_suggestion_log

    echo "Mode: $MODE"
    echo "Source: $SOURCE_DIR"
    echo "Destination: $DEST_BASE"
    echo ""

    # Create base directories
    mkdir -p "$DEST_BASE"
    if [ "$MODE" = "production" ]; then
        for folder in "${SOP_FOLDERS[@]}"; do
            mkdir -p "$DEST_BASE/$folder"
        done
    fi

    # Process files
    process_files

    # Generate report if in staging
    generate_staging_report

    echo ""
    echo -e "${GREEN}✅ Complete!${NC}"

    if [ "$MODE" = "staging" ]; then
        echo ""
        echo "Next steps:"
        echo "1. Review staged categories in AI_STAGING/01_TESTING"
        echo "2. Monitor for 7 days"
        echo "3. Present findings at weekly review"
        echo "4. Update SOP if approved"
    fi
}

# Ensure Ollama is running
if [ "$MODE" = "staging" ]; then
    if ! pgrep -x "ollama" > /dev/null; then
        echo "Starting Ollama for AI analysis..."
        ollama serve &>/dev/null &
        sleep 2
    fi
fi

# Run main
main