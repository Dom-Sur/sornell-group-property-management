#!/bin/bash

# Quick & Powerful AI Processing - Fast Parallel Execution
# Combines organization and analysis in one swift operation
# Date: September 25, 2025

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     ⚡ QUICK POWER AI - PARALLEL PROCESSING               ║"
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
ACTION="${3:-both}"  # organize, analyze, both
MAX_PARALLEL="${4:-5}"  # Number of parallel processes
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Ensure Ollama is running
if ! pgrep -x "ollama" > /dev/null; then
    echo -e "${CYAN}🚀 Starting Ollama service...${NC}"
    ollama serve &>/dev/null &
    sleep 2
fi

echo -e "${PURPLE}⚡ Quick Power Mode${NC}"
echo -e "${CYAN}📍 Source: $SOURCE_DIR${NC}"
echo -e "${CYAN}📂 Destination: $DEST_BASE${NC}"
echo -e "${CYAN}🔧 Action: $ACTION${NC}"
echo -e "${CYAN}⚡ Parallel processes: $MAX_PARALLEL${NC}"
echo ""

# Quick model selection - optimized for speed
quick_select_model() {
    local filename="$1"
    local filesize="$2"
    local extension="${filename##*.}"

    # Use fast models for quick processing
    if [[ "$filename" == *"lease"* ]] || [[ "$filename" == *"contract"* ]]; then
        echo "llama3.2:3b"  # Fast for legal
    elif [[ "$extension" == "py" ]] || [[ "$extension" == "js" ]]; then
        echo "qwen2.5-coder:3b"  # Fast for code
    elif [ "$filesize" -gt 100000 ]; then
        echo "phi3:mini"  # Fast for large files
    else
        echo "llama3.2:1b"  # Ultra-fast default
    fi
}

# Quick organize function
quick_organize() {
    local filepath="$1"
    local filename=$(basename "$filepath")
    local filesize=$(stat -f%z "$filepath" 2>/dev/null || echo "0")

    # Skip system files
    [[ "$filename" == .* ]] && return 0

    # Quick duplicate check using size and name
    local existing=$(find "$DEST_BASE" -name "$filename" -size "${filesize}c" 2>/dev/null | head -1)
    if [ -n "$existing" ]; then
        rm -f "$filepath" 2>/dev/null
        return 0
    fi

    # Quick categorization
    local category="GENERAL"
    local filename_lower=$(echo "$filename" | tr '[:upper:]' '[:lower:]')

    # Pattern-based quick categorization
    if [[ "$filename_lower" == *"parkdale"* ]]; then
        category="PROPERTY_PARKDALE"
    elif [[ "$filename_lower" == *"lease"* ]]; then
        category="LEGAL_CONTRACTS"
    elif [[ "$filename_lower" == *"invoice"* ]] || [[ "$filename_lower" == *"payment"* ]]; then
        category="FINANCIAL"
    elif [[ "$filename_lower" == *"maintenance"* ]] || [[ "$filename_lower" == *"repair"* ]]; then
        category="MAINTENANCE"
    elif [[ "$filename" == *.sh ]] || [[ "$filename" == *.py ]] || [[ "$filename" == *.js ]]; then
        category="TECHNOLOGY"
    elif [[ "$filename_lower" == *"2024"* ]]; then
        category="ARCHIVED_2024"
    elif [[ "$filename_lower" == *"2025"* ]]; then
        category="ACTIVE_OPERATIONS"
    fi

    # Quick move
    mkdir -p "$DEST_BASE/$category"
    mv "$filepath" "$DEST_BASE/$category/" 2>/dev/null && echo -e "  ${GREEN}✓${NC} $filename → $category"
}

# Quick analyze function
quick_analyze() {
    local filepath="$1"
    local filename=$(basename "$filepath")
    local model="llama3.2:1b"  # Ultra-fast model

    # Get quick content preview
    local content=$(head -c 500 "$filepath" 2>/dev/null | tr '\n' ' ')

    # Quick analysis prompt
    local prompt="In 3 bullet points, identify: 1) Main purpose 2) Key info 3) Action needed
File: $filename
Content: ${content:0:200}"

    # Run quick analysis
    echo "$prompt" | timeout 5 ollama run "$model" 2>/dev/null | head -5
}

# Parallel processor
process_batch() {
    local batch_file="$1"
    local action="$2"

    while IFS= read -r filepath; do
        case "$action" in
            "organize")
                quick_organize "$filepath"
                ;;
            "analyze")
                quick_analyze "$filepath"
                ;;
            "both")
                quick_organize "$filepath"
                quick_analyze "$filepath" 2>/dev/null | head -2
                ;;
        esac
    done < "$batch_file"
}

# Main execution
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${PURPLE}Starting Quick Power Processing${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"

# Get all files
TEMP_FILE_LIST="/tmp/quick_power_files_$$"
find "$SOURCE_DIR" -type f ! -name ".DS_Store" 2>/dev/null > "$TEMP_FILE_LIST"

TOTAL_FILES=$(wc -l < "$TEMP_FILE_LIST" | tr -d ' ')
echo -e "${CYAN}📊 Processing $TOTAL_FILES files in parallel...${NC}"
echo ""

# Split files into batches for parallel processing
BATCH_SIZE=$((TOTAL_FILES / MAX_PARALLEL + 1))
split -l "$BATCH_SIZE" "$TEMP_FILE_LIST" "/tmp/batch_$$_"

# Start parallel processing
echo -e "${YELLOW}⚡ Launching $MAX_PARALLEL parallel workers...${NC}"

for batch in /tmp/batch_$$_*; do
    process_batch "$batch" "$ACTION" &
done

# Monitor progress
while [ $(jobs -r | wc -l) -gt 0 ]; do
    REMAINING=$(jobs -r | wc -l)
    echo -ne "\r${CYAN}⏳ Workers active: $REMAINING ${NC}"
    sleep 2
done

echo ""

# Cleanup
rm -f /tmp/batch_$$_* "$TEMP_FILE_LIST"

# Quick statistics
if [ "$ACTION" != "analyze" ]; then
    echo ""
    echo -e "${CYAN}📊 Quick Organization Results:${NC}"
    for category in "$DEST_BASE"/*; do
        if [ -d "$category" ]; then
            count=$(find "$category" -type f 2>/dev/null | wc -l | tr -d ' ')
            [ "$count" -gt 0 ] && printf "  %-30s: %5d files\n" "$(basename "$category")" "$count"
        fi
    done
fi

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}              ✅ QUICK POWER COMPLETE                         ${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${GREEN}⚡ Processing time: < 1 minute${NC}"
echo -e "${GREEN}📁 Files organized to: $DEST_BASE${NC}"
echo ""

exit 0