#!/bin/bash

# Premium AI Organization Script with Advanced Models
# Uses your most powerful LLMs including DeepSeek-R1 and large models
# Date: September 25, 2025

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     🧠 PREMIUM AI ORGANIZE WITH DEEP MODELS               ║"
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
CLEANUP_MODE="${3:-no}"  # Default to safe mode
AI_LOG="$DEST_BASE/premium_ai_analysis_$(date +%Y%m%d_%H%M%S).log"

# Ensure Ollama is running
if ! pgrep -x "ollama" > /dev/null; then
    echo -e "${CYAN}🚀 Starting Ollama service...${NC}"
    ollama serve &>/dev/null &
    sleep 3
fi

echo -e "${CYAN}🧠 Premium AI Mode Activated${NC}"
echo -e "${CYAN}📍 Source: $SOURCE_DIR${NC}"
echo -e "${CYAN}📂 Destination: $DEST_BASE${NC}"
echo -e "${CYAN}🔧 Using advanced models including DeepSeek-R1${NC}"
echo ""

# Premium model selection with your most powerful models
select_premium_model() {
    local filename="$1"
    local filesize="$2"
    local extension="${filename##*.}"
    local filename_lower=$(echo "$filename" | tr '[:upper:]' '[:lower:]')

    # Use DeepSeek-R1 for complex reasoning tasks
    if [[ "$filename_lower" == *"contract"* ]] || [[ "$filename_lower" == *"lease"* ]] || [[ "$filename_lower" == *"agreement"* ]]; then
        echo "deepseek-r1:7b"  # Best for legal reasoning

    # Property management - use your custom trained models
    elif [[ "$filename_lower" == *"parkdale"* ]]; then
        echo "parkdale-specialist:latest"
    elif [[ "$filename_lower" == *"vacancy"* ]]; then
        echo "vacancy-crisis:latest"
    elif [[ "$filename_lower" == *"maintenance"* ]]; then
        echo "maintenance-predictor:latest"
    elif [[ "$filename_lower" == *"delinquent"* ]] || [[ "$filename_lower" == *"rent"* ]]; then
        echo "delinquency-collector:latest"
    elif [[ "$filename_lower" == *"property"* ]] || [[ "$filename_lower" == *"tenant"* ]]; then
        echo "domenic-business-v2:latest"

    # Code files - use Qwen 32B for complex code
    elif [[ "$extension" == "py" ]] || [[ "$extension" == "js" ]] || [[ "$extension" == "ts" ]]; then
        if [ "$filesize" -gt 50000 ]; then
            echo "qwen2.5-coder:32b"  # Large model for complex code
        else
            echo "starcoder2:15b"  # Medium model for regular code
        fi
    elif [[ "$extension" == "sh" ]] || [[ "$extension" == "bash" ]]; then
        echo "qwen2.5-coder:7b"

    # SQL and data files
    elif [[ "$extension" == "sql" ]] || [[ "$extension" == "csv" ]]; then
        echo "sqlcoder:7b"

    # Financial and business documents - use Mixtral for multi-reasoning
    elif [[ "$filename_lower" == *"financial"* ]] || [[ "$filename_lower" == *"invoice"* ]] || [[ "$filename_lower" == *"tax"* ]]; then
        echo "mixtral:8x7b"  # Mixture of experts for financial analysis

    # Large documents need powerful models
    elif [ "$filesize" -gt 100000 ]; then
        echo "qwen2.5:32b"  # Large model for big files

    # Small files can use faster models
    elif [ "$filesize" -lt 5000 ]; then
        echo "llama3.2:3b"

    # Default to Phi4 for general purpose
    else
        echo "phi4:latest"
    fi
}

# Enhanced categorization with better prompts
categorize_with_premium_ai() {
    local filepath="$1"
    local filename=$(basename "$filepath")
    local filesize=$(stat -f%z "$filepath" 2>/dev/null || echo "0")

    # Skip system files
    if [[ "$filename" == .* ]] || [[ "$filename" == *.tmp ]]; then
        return
    fi

    # Select the best model for this file
    local model=$(select_premium_model "$filename" "$filesize")

    echo -e "${PURPLE}🧠 Using model: $model${NC}"

    # Get content preview for better categorization
    local content_preview=""
    if [ -f "$filepath" ] && [ "$filesize" -lt 100000 ]; then
        content_preview=$(head -c 1000 "$filepath" 2>/dev/null | tr '\n' ' ' | tr -d '\000')
    fi

    # Enhanced AI prompt with context
    local prompt="You are an expert file organizer for a property management company.
Analyze this file and categorize it accurately.

File: '$filename'
Size: $filesize bytes
Content preview: '${content_preview:0:200}'

Categories available:
- PROPERTY (leases, tenant docs, property specific)
- FINANCIAL (invoices, statements, tax docs)
- OPERATIONS (maintenance, repairs, daily ops)
- LEGAL (contracts, agreements, legal docs)
- SCRIPTS (code, automation, technical)
- REPORTS (analytics, summaries, reports)
- TEMPLATES (forms, templates, blanks)
- PERSONAL_PROJECTS (personal code/projects)
- BUSINESS_GENERAL (general business docs)
- TECHNOLOGY (IT, software, configs)
- ARCHIVE (old, outdated, historical)
- GENERAL (everything else)

Consider the content, not just the filename.
Reply with ONLY the single best category name."

    # Get AI categorization with timeout
    local category=$(echo "$prompt" | timeout 15 ollama run "$model" 2>/dev/null | \
                     head -1 | tr '[:lower:]' '[:upper:]' | \
                     grep -oE 'PROPERTY|FINANCIAL|OPERATIONS|LEGAL|SCRIPTS|REPORTS|TEMPLATES|PERSONAL_PROJECTS|BUSINESS_GENERAL|TECHNOLOGY|ARCHIVE|GENERAL' | \
                     head -1)

    # Fallback logic if AI fails
    if [ -z "$category" ]; then
        echo -e "${YELLOW}  ⚠️  AI timeout, using fallback logic${NC}"
        if [[ "$filename" == *.sh ]] || [[ "$filename" == *.py ]]; then
            category="SCRIPTS"
        elif [[ "$filename" == *property* ]] || [[ "$filename" == *parkdale* ]]; then
            category="PROPERTY"
        elif [[ "$filename" == *financial* ]] || [[ "$filename" == *invoice* ]]; then
            category="FINANCIAL"
        else
            category="GENERAL"
        fi
    fi

    # Create destination directory
    mkdir -p "$DEST_BASE/$category"

    # Move or copy based on mode
    printf "%-40s " "${filename:0:40}"
    if [ "$CLEANUP_MODE" == "yes" ]; then
        # Move mode
        if mv "$filepath" "$DEST_BASE/$category/$filename" 2>/dev/null; then
            echo -e "${GREEN}→ $category ✓${NC} [$model]"
            echo "$(date '+%Y-%m-%d %H:%M:%S')|MOVED|$filename|$category|$model" >> "$AI_LOG"
            return 0
        else
            echo -e "${RED}→ Failed${NC}"
            echo "$(date '+%Y-%m-%d %H:%M:%S')|FAILED|$filename|$category|$model" >> "$AI_LOG"
            return 1
        fi
    else
        # Copy mode (safer)
        if cp "$filepath" "$DEST_BASE/$category/$filename" 2>/dev/null; then
            echo -e "${GREEN}→ $category ✓${NC} [$model]"
            echo "$(date '+%Y-%m-%d %H:%M:%S')|COPIED|$filename|$category|$model" >> "$AI_LOG"
            return 0
        else
            echo -e "${RED}→ Failed${NC}"
            echo "$(date '+%Y-%m-%d %H:%M:%S')|FAILED|$filename|$category|$model" >> "$AI_LOG"
            return 1
        fi
    fi
}

# Main processing
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${PURPLE}Starting Premium AI Processing${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"

# Count files
TOTAL_FILES=$(find "$SOURCE_DIR" -type f ! -name ".DS_Store" 2>/dev/null | wc -l | tr -d ' ')
echo -e "${CYAN}📊 Processing $TOTAL_FILES files with advanced AI...${NC}"
echo ""

# Process each file recursively
PROCESSED=0
FAILED=0
SUCCESS_LOG="/tmp/ai_organize_success_$$"
FAILED_LOG="/tmp/ai_organize_failed_$$"

# Clear temp logs
> "$SUCCESS_LOG"
> "$FAILED_LOG"

# Process files with progress tracking
while IFS= read -r filepath; do
    if categorize_with_premium_ai "$filepath"; then
        echo "1" >> "$SUCCESS_LOG"
    else
        echo "1" >> "$FAILED_LOG"
    fi

    # Update progress every 10 files
    CURRENT_PROCESSED=$(wc -l < "$SUCCESS_LOG" 2>/dev/null || echo "0")
    CURRENT_FAILED=$(wc -l < "$FAILED_LOG" 2>/dev/null || echo "0")
    TOTAL_DONE=$((CURRENT_PROCESSED + CURRENT_FAILED))

    if [ $((TOTAL_DONE % 10)) -eq 0 ] && [ $TOTAL_DONE -gt 0 ]; then
        echo -e "${CYAN}Progress: $TOTAL_DONE / $TOTAL_FILES processed${NC}"
    fi
done < <(find "$SOURCE_DIR" -type f ! -name ".DS_Store" 2>/dev/null)

PROCESSED=$(wc -l < "$SUCCESS_LOG" 2>/dev/null || echo "0")
FAILED=$(wc -l < "$FAILED_LOG" 2>/dev/null || echo "0")

# Clean up temp files
rm -f "$SUCCESS_LOG" "$FAILED_LOG"

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}              ✅ PREMIUM AI PROCESSING COMPLETE               ${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""

# Show model usage statistics
echo -e "${CYAN}📊 Model Usage Statistics:${NC}"
grep -o '[a-z0-9-]*:[a-z0-9]*' "$AI_LOG" | sort | uniq -c | sort -rn | head -10

echo ""
echo -e "${GREEN}📁 Files organized to: $DEST_BASE${NC}"
echo -e "${GREEN}📋 Analysis log: $AI_LOG${NC}"
echo ""

echo -e "${YELLOW}💡 Premium Features Used:${NC}"
echo "  • DeepSeek-R1 for legal documents"
echo "  • Qwen 32B for complex code"
echo "  • Mixtral 8x7B for financial analysis"
echo "  • Custom property management models"
echo "  • Enhanced content analysis"
echo ""

exit 0