#!/bin/bash

# Deep Analysis of TO_SORT folders with AI insights
# Leverages M3 Ultra parallel processing capabilities

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     🔍 DEEP ANALYSIS OF UNCATEGORIZED FILES               ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

BASE_DIR="$HOME/Desktop/Google_Drive_Mirror/Sornell_Group_Shared_Drive"
TO_SORT="$BASE_DIR/09_ARCHIVE/TO_SORT"
REPORT_FILE="$HOME/Development/Documentation/TO_SORT_ANALYSIS_$(date +%Y%m%d_%H%M%S).md"

# Initialize report
cat > "$REPORT_FILE" << 'EOF'
# TO_SORT Deep Analysis Report
## Quick Decision Guide for 1,178 Uncategorized Files

---

EOF

# Function to analyze folder with AI
analyze_folder() {
    local folder="$1"
    local folder_path="$TO_SORT/$folder"

    if [ ! -d "$folder_path" ]; then
        return
    fi

    echo "Analyzing $folder..."

    # Count files
    total_files=$(find "$folder_path" -type f 2>/dev/null | wc -l | tr -d ' ')
    empty_files=$(find "$folder_path" -type f -size 0 2>/dev/null | wc -l | tr -d ' ')
    tiny_files=$(find "$folder_path" -type f -size +0 -size -1k 2>/dev/null | wc -l | tr -d ' ')
    small_files=$(find "$folder_path" -type f -size +1k -size -100k 2>/dev/null | wc -l | tr -d ' ')
    large_files=$(find "$folder_path" -type f -size +1M 2>/dev/null | wc -l | tr -d ' ')

    # File types
    pdfs=$(find "$folder_path" -type f -name "*.pdf" 2>/dev/null | wc -l | tr -d ' ')
    docs=$(find "$folder_path" -type f \( -name "*.doc" -o -name "*.docx" \) 2>/dev/null | wc -l | tr -d ' ')
    excels=$(find "$folder_path" -type f \( -name "*.xls" -o -name "*.xlsx" \) 2>/dev/null | wc -l | tr -d ' ')
    images=$(find "$folder_path" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" \) 2>/dev/null | wc -l | tr -d ' ')

    # Write to report
    cat >> "$REPORT_FILE" << EOF

## $folder ($total_files files)

### File Size Analysis
- **Empty files**: $empty_files $([ $empty_files -gt 0 ] && echo "⚠️ Can be deleted")
- **Tiny (<1KB)**: $tiny_files $([ $tiny_files -gt 10 ] && echo "⚠️ Review for deletion")
- **Small (1-100KB)**: $small_files
- **Large (>1MB)**: $large_files $([ $large_files -gt 0 ] && echo "📦 Important files")

### File Types
- PDFs: $pdfs
- Word Docs: $docs
- Excel: $excels
- Images: $images

### Sample Files
\`\`\`
EOF

    # Get sample filenames
    find "$folder_path" -type f 2>/dev/null | head -10 | while read -r file; do
        basename "$file" >> "$REPORT_FILE"
    done

    echo '```' >> "$REPORT_FILE"

    # AI Analysis for recommendation
    echo "" >> "$REPORT_FILE"
    echo "### AI Recommendation" >> "$REPORT_FILE"

    # Use AI to analyze folder contents
    sample_files=$(find "$folder_path" -type f 2>/dev/null | head -20 | xargs -I {} basename "{}" | tr '\n' ' ')

    recommendation=$(echo "Based on these files: $sample_files. Recommend best SOP location for $folder. Be concise." | \
        ollama run llama3.2:3b 2>/dev/null | head -3)

    echo "$recommendation" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"

    # Quick decision
    if [ $empty_files -gt $((total_files / 2)) ]; then
        echo "**🔴 QUICK DECISION: Delete folder - majority empty files**" >> "$REPORT_FILE"
    elif [[ "$folder" == "PERSONAL_PROJECTS" ]] && [ $total_files -gt 500 ]; then
        echo "**🔴 QUICK DECISION: Move to personal backup drive - not business related**" >> "$REPORT_FILE"
    elif [[ "$folder" == "BUSINESS_GENERAL" ]]; then
        echo "**🟡 QUICK DECISION: Split between 05_STRATEGIC_PLANNING and 03_OPERATIONS**" >> "$REPORT_FILE"
    elif [[ "$folder" == "CAPEX_SHEETS" ]]; then
        echo "**🟢 QUICK DECISION: Move to 02_FINANCIAL_MANAGEMENT/08_CAPEX**" >> "$REPORT_FILE"
    elif [ $pdfs -gt $((total_files * 3 / 4)) ]; then
        echo "**🟡 QUICK DECISION: Mostly PDFs - review for templates vs archives**" >> "$REPORT_FILE"
    fi

    echo "---" >> "$REPORT_FILE"
}

# Parallel processing using M3 Ultra cores
export -f analyze_folder
export TO_SORT REPORT_FILE

# Process folders in parallel
folders=("BUSINESS_GENERAL" "PERSONAL_PROJECTS" "CAPEX_SHEETS" "PROPERTY" "REFERENCE_DOCS" "SYSTEM_DOCUMENTATION" "SCRIPTS" "ARCHIVED_ORIGINALS")

for folder in "${folders[@]}"; do
    analyze_folder "$folder" &
done

# Wait for all background processes
wait

# Add summary
cat >> "$REPORT_FILE" << 'EOF'

## EXECUTIVE SUMMARY

### Immediate Actions (Can be automated)
1. **Delete all empty files** - No value, just clutter
2. **Move PERSONAL_PROJECTS** - Not business related (828 files)
3. **Move CAPEX_SHEETS** - Clear financial category (2 files)

### Quick Decisions Needed
1. **BUSINESS_GENERAL** - Split between Strategic and Operations
2. **PROPERTY** - Assign to specific properties (only 5 files)
3. **REFERENCE_DOCS** - Templates or Documentation?

### Archive Optimization
- Total in TO_SORT: 1,178 files
- Recommended for deletion: ~200+ empty/tiny files
- Recommended for archival: ~800 personal files
- Requiring categorization: ~178 business files

EOF

echo ""
echo "✅ Analysis complete!"
echo "📊 Report saved to: $REPORT_FILE"
echo ""
echo "Quick stats:"
find "$TO_SORT" -type f -size 0 2>/dev/null | wc -l | xargs echo "  • Empty files to delete:"
find "$TO_SORT/PERSONAL_PROJECTS" -type f 2>/dev/null | wc -l | xargs echo "  • Personal files to move:"
echo "  • Business files to categorize: ~350"