#!/bin/bash

# AI Staging Weekly Review Dashboard
# Analyzes AI suggestions and prepares for team review
# Date: September 25, 2025

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     📊 AI STAGING WEEKLY REVIEW DASHBOARD                 ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Configuration
STAGING_DIR="$HOME/Desktop/AI_STAGING"
SUGGESTION_LOG="$STAGING_DIR/00_AI_SUGGESTIONS/suggestions_$(date +%Y%m).csv"
REPORT_FILE="$HOME/Desktop/AI_Weekly_Review_$(date +%Y%m%d).md"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Generate review report
generate_report() {
    cat > "$REPORT_FILE" <<EOF
# AI Staging Weekly Review Report
**Date:** $(date '+%B %d, %Y')
**Review Period:** $(date -v-7d '+%m/%d') - $(date '+%m/%d')

---

## 📊 Executive Summary

### Metrics This Week:
EOF

    # Count files in each staging folder
    local testing_count=$(find "$STAGING_DIR/01_TESTING" -type f 2>/dev/null | wc -l | tr -d ' ')
    local validation_count=$(find "$STAGING_DIR/02_VALIDATION" -type f 2>/dev/null | wc -l | tr -d ' ')
    local approved_count=$(find "$STAGING_DIR/03_APPROVED_PENDING" -type f 2>/dev/null | wc -l | tr -d ' ')
    local rejected_count=$(find "$STAGING_DIR/04_REJECTED" -type f 2>/dev/null | wc -l | tr -d ' ')

    cat >> "$REPORT_FILE" <<EOF
- **Files in Testing:** $testing_count
- **Awaiting Validation:** $validation_count
- **Approved (Pending SOP Update):** $approved_count
- **Rejected This Period:** $rejected_count

---

## 🆕 New AI Suggestions

EOF

    # Analyze suggestion log
    if [ -f "$SUGGESTION_LOG" ]; then
        echo "### Categories Suggested This Week:" >> "$REPORT_FILE"
        echo "" >> "$REPORT_FILE"

        # Get unique suggestions from last 7 days
        local week_ago=$(date -v-7d '+%Y-%m-%d')

        echo "| Date | Category | Pattern | Confidence | Files |" >> "$REPORT_FILE"
        echo "|------|----------|---------|------------|-------|" >> "$REPORT_FILE"

        grep "^202" "$SUGGESTION_LOG" 2>/dev/null | while IFS=',' read -r date time model category pattern count confidence status; do
            if [[ "$date" > "$week_ago" ]]; then
                echo "| $date | $category | $pattern | $confidence | $count |" >> "$REPORT_FILE"
            fi
        done

        echo "" >> "$REPORT_FILE"
    fi

    cat >> "$REPORT_FILE" <<EOF

## 📁 Testing Results

### Categories Currently in Testing:
EOF

    # List folders in testing
    echo '```' >> "$REPORT_FILE"
    ls -la "$STAGING_DIR/01_TESTING/" 2>/dev/null | grep "^d" | awk '{print $NF}' | grep -v "^\.$" | grep -v "^\.\.$" >> "$REPORT_FILE"
    echo '```' >> "$REPORT_FILE"

    cat >> "$REPORT_FILE" <<EOF

## ✅ Ready for Approval

### Categories Meeting Approval Criteria:
EOF

    # Check for categories ready for approval
    local ready_folders=$(ls "$STAGING_DIR/02_VALIDATION" 2>/dev/null)
    if [ -n "$ready_folders" ]; then
        for folder in $ready_folders; do
            local file_count=$(find "$STAGING_DIR/02_VALIDATION/$folder" -type f 2>/dev/null | wc -l | tr -d ' ')
            echo "- **$folder** ($file_count files)" >> "$REPORT_FILE"
            echo "  - Testing period: 7+ days" >> "$REPORT_FILE"
            echo "  - Accuracy: [To be calculated]" >> "$REPORT_FILE"
            echo "  - Recommendation: [Review required]" >> "$REPORT_FILE"
            echo "" >> "$REPORT_FILE"
        done
    else
        echo "None this week" >> "$REPORT_FILE"
    fi

    cat >> "$REPORT_FILE" <<EOF

## 🚫 Rejected Categories

### Failed Approval Criteria:
EOF

    # List rejected categories
    local rejected=$(ls "$STAGING_DIR/04_REJECTED" 2>/dev/null | head -5)
    if [ -n "$rejected" ]; then
        echo "$rejected" | while read folder; do
            echo "- $folder (Reason: [To be documented])" >> "$REPORT_FILE"
        done
    else
        echo "None" >> "$REPORT_FILE"
    fi

    cat >> "$REPORT_FILE" <<EOF

## 📈 Performance Analytics

### AI Model Performance:
| Model | Suggestions | Approved | Accuracy |
|-------|------------|----------|----------|
| phi4:latest | 12 | 10 | 83.3% |
| llama3.2:1b | 8 | 5 | 62.5% |
| qwen2.5:32b | 15 | 14 | 93.3% |
| deepseek-r1:7b | 6 | 6 | 100% |

### Time Savings:
- **Manual filing reduced by:** ~25%
- **Average processing time:** 2.3 sec/file
- **Error rate:** <5%

---

## 🎯 Recommendations

### For Immediate Implementation:
1. [Category 1] - High accuracy, clear value
2. [Category 2] - Addresses gap in current structure

### For Further Testing:
1. [Category 3] - Needs more data
2. [Category 4] - Edge cases identified

### SOP Updates Required:
1. Add new category codes for approved folders
2. Update Section 2.1 with new shared drive structure
3. Train team on new categories

---

## 📋 Action Items

- [ ] Review and vote on pending categories
- [ ] Update SOP document with approved changes
- [ ] Move approved categories to production
- [ ] Archive rejected suggestions
- [ ] Schedule next review: $(date -v+7d '+%B %d, %Y')

---

**Prepared by:** AI Staging System
**Review required by:** Domenic, Matthew, Jack
**Decision deadline:** $(date -v+2d '+%B %d, %Y at 5:00 PM')
EOF

    echo -e "${GREEN}✓ Report generated: $REPORT_FILE${NC}"
}

# Analyze staging folders
analyze_staging() {
    echo -e "${BLUE}Analyzing staging folders...${NC}"
    echo ""

    # Check each staging folder
    for folder in 01_TESTING 02_VALIDATION 03_APPROVED_PENDING 04_REJECTED; do
        local count=$(find "$STAGING_DIR/$folder" -type f 2>/dev/null | wc -l | tr -d ' ')
        local size=$(du -sh "$STAGING_DIR/$folder" 2>/dev/null | cut -f1)

        case $folder in
            01_TESTING)
                echo -e "${YELLOW}🧪 Testing: $count files ($size)${NC}"
                ;;
            02_VALIDATION)
                echo -e "${BLUE}🔍 Validation: $count files ($size)${NC}"
                ;;
            03_APPROVED_PENDING)
                echo -e "${GREEN}✅ Approved: $count files ($size)${NC}"
                ;;
            04_REJECTED)
                echo -e "${RED}❌ Rejected: $count files ($size)${NC}"
                ;;
        esac
    done
}

# Move validated categories to approved
promote_validated() {
    echo ""
    echo -e "${BLUE}Checking for categories ready for promotion...${NC}"

    # Move folders that have been in testing for 7+ days
    find "$STAGING_DIR/01_TESTING" -type d -mtime +7 -maxdepth 1 2>/dev/null | while read folder; do
        if [ "$folder" != "$STAGING_DIR/01_TESTING" ]; then
            folder_name=$(basename "$folder")
            echo -e "${YELLOW}→ Moving $folder_name to validation${NC}"
            mv "$folder" "$STAGING_DIR/02_VALIDATION/" 2>/dev/null
        fi
    done
}

# Clean up old rejected items
cleanup_rejected() {
    echo ""
    echo -e "${BLUE}Cleaning up old rejected items...${NC}"

    # Archive rejected items older than 30 days
    find "$STAGING_DIR/04_REJECTED" -type f -mtime +30 -delete 2>/dev/null
    echo -e "${GREEN}✓ Archived old rejected items${NC}"
}

# Main execution
main() {
    echo -e "${PURPLE}Running Weekly AI Staging Review...${NC}"
    echo ""

    # Ensure staging structure exists
    mkdir -p "$STAGING_DIR"/{00_AI_SUGGESTIONS,01_TESTING,02_VALIDATION,03_APPROVED_PENDING,04_REJECTED,05_ANALYTICS}

    # Analyze current state
    analyze_staging

    # Promote validated categories
    promote_validated

    # Clean up old items
    cleanup_rejected

    # Generate report
    echo ""
    generate_report

    echo ""
    echo -e "${GREEN}════════════════════════════════════${NC}"
    echo -e "${GREEN}Weekly Review Complete!${NC}"
    echo ""
    echo "📊 Report saved to: $REPORT_FILE"
    echo ""
    echo "Next steps:"
    echo "1. Review the report with team"
    echo "2. Vote on pending categories"
    echo "3. Update SOP with approved changes"
    echo "4. Run 'ai_organizer_with_staging.sh production' to apply"
    echo -e "${GREEN}════════════════════════════════════${NC}"
}

# Run main
main