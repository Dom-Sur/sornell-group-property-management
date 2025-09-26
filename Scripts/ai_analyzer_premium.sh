#!/bin/bash

# Premium AI Analyzer with Multiple Specializations
# Deep content analysis with specialized models for different domains
# Date: September 25, 2025

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     🔬 PREMIUM AI ANALYZER WITH SPECIALIZATIONS           ║"
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
SOURCE_DIR="${1:-$HOME/Desktop/Google_Drive_Mirror/Sornell_Group_Shared_Drive}"
ANALYSIS_TYPE="${2:-business}"  # business, medical, research, legal, financial, technical
REPORT_DIR="$HOME/Desktop/AI_Analysis_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$REPORT_DIR"

# Ensure Ollama is running
if ! pgrep -x "ollama" > /dev/null; then
    echo -e "${CYAN}🚀 Starting Ollama service...${NC}"
    ollama serve &>/dev/null &
    sleep 3
fi

echo -e "${PURPLE}🔬 Premium Analysis Mode: $ANALYSIS_TYPE${NC}"
echo -e "${CYAN}📍 Analyzing: $SOURCE_DIR${NC}"
echo -e "${CYAN}📊 Reports: $REPORT_DIR${NC}"
echo ""

# Specialized analysis prompts based on type
get_analysis_prompt() {
    local analysis_type="$1"
    local filename="$2"
    local content="$3"

    case "$analysis_type" in
        "business")
            echo "As a business analyst, analyze this document for:
1. Key business metrics and KPIs
2. Financial implications
3. Risk factors
4. Action items and deadlines
5. Stakeholder impacts
6. Compliance requirements
7. Optimization opportunities

File: $filename
Content: ${content:0:2000}

Provide structured analysis with specific recommendations."
            ;;

        "medical")
            echo "As a medical analyst, review this document for:
1. Clinical significance
2. Patient safety concerns
3. Treatment protocols mentioned
4. Diagnostic criteria
5. Medication references
6. Compliance with medical standards
7. Research implications

File: $filename
Content: ${content:0:2000}

Provide clinical analysis with evidence-based insights."
            ;;

        "research")
            echo "As a research analyst, evaluate this document for:
1. Research methodology
2. Data quality and validity
3. Statistical significance
4. Literature references
5. Hypothesis and findings
6. Reproducibility factors
7. Future research directions

File: $filename
Content: ${content:0:2000}

Provide academic analysis with critical evaluation."
            ;;

        "legal")
            echo "As a legal analyst, examine this document for:
1. Legal obligations and liabilities
2. Contractual terms and conditions
3. Compliance requirements
4. Risk exposures
5. Jurisdictional considerations
6. Precedent implications
7. Action deadlines

File: $filename
Content: ${content:0:2000}

Provide legal analysis with risk assessment."
            ;;

        "financial")
            echo "As a financial analyst, analyze this document for:
1. Revenue and expense patterns
2. Cash flow implications
3. Investment opportunities
4. Financial risks
5. Tax considerations
6. Budget variances
7. ROI calculations

File: $filename
Content: ${content:0:2000}

Provide financial analysis with quantitative insights."
            ;;

        "technical")
            echo "As a technical analyst, review this code/document for:
1. Architecture and design patterns
2. Performance implications
3. Security vulnerabilities
4. Code quality metrics
5. Technical debt
6. Scalability considerations
7. Best practices compliance

File: $filename
Content: ${content:0:2000}

Provide technical analysis with specific improvements."
            ;;

        *)
            echo "Analyze this document comprehensively for key insights, risks, and opportunities.
File: $filename
Content: ${content:0:2000}"
            ;;
    esac
}

# Select optimal model for analysis type
select_analysis_model() {
    local analysis_type="$1"
    local filesize="$2"

    case "$analysis_type" in
        "business")
            if [ "$filesize" -gt 100000 ]; then
                echo "mixtral:8x22b"  # Large mixture of experts
            else
                echo "domenic-business-v2:latest"
            fi
            ;;

        "medical")
            echo "meditron:70b"  # Medical-specific model
            ;;

        "research")
            echo "mixtral:8x7b"  # Good for academic analysis
            ;;

        "legal")
            echo "deepseek-r1:7b"  # Best for legal reasoning
            ;;

        "financial")
            echo "mixtral:8x7b"  # Financial analysis
            ;;

        "technical")
            if [ "$filesize" -gt 50000 ]; then
                echo "qwen2.5-coder:32b"
            else
                echo "qwen2.5-coder:14b"
            fi
            ;;

        *)
            echo "phi4:latest"
            ;;
    esac
}

# Analyze single file with specialized model
analyze_file() {
    local filepath="$1"
    local analysis_type="$2"
    local filename=$(basename "$filepath")
    local filesize=$(stat -f%z "$filepath" 2>/dev/null || echo "0")

    # Skip if not readable or too large
    if [ ! -r "$filepath" ] || [ "$filesize" -gt 10000000 ]; then
        return 1
    fi

    # Get content preview
    local content=""
    if [ "$filesize" -lt 1000000 ]; then
        content=$(head -c 50000 "$filepath" 2>/dev/null | tr '\n' ' ' | tr -d '\000')
    fi

    # Select model
    local model=$(select_analysis_model "$analysis_type" "$filesize")

    # Get analysis prompt
    local prompt=$(get_analysis_prompt "$analysis_type" "$filename" "$content")

    echo -e "${CYAN}Analyzing with $model: $filename${NC}"

    # Run analysis
    local analysis=$(echo "$prompt" | timeout 30 ollama run "$model" 2>/dev/null)

    if [ -n "$analysis" ]; then
        # Save individual analysis
        local safe_filename=$(echo "$filename" | tr '/' '_')
        echo "# Analysis: $filename" > "$REPORT_DIR/analysis_${safe_filename}.md"
        echo "**Model:** $model" >> "$REPORT_DIR/analysis_${safe_filename}.md"
        echo "**Type:** $analysis_type" >> "$REPORT_DIR/analysis_${safe_filename}.md"
        echo "" >> "$REPORT_DIR/analysis_${safe_filename}.md"
        echo "$analysis" >> "$REPORT_DIR/analysis_${safe_filename}.md"

        echo -e "${GREEN}✓ Analysis complete${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠️  Analysis timeout${NC}"
        return 1
    fi
}

# Analyze directory recursively
analyze_directory() {
    local dir="$1"
    local max_files="${2:-100}"  # Limit files per directory
    local current_count=0

    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}Analyzing Directory: $(basename "$dir")${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"

    # Priority file patterns based on analysis type
    local priority_patterns=()

    case "$ANALYSIS_TYPE" in
        "business")
            priority_patterns=("*contract*" "*lease*" "*financial*" "*report*")
            ;;
        "medical")
            priority_patterns=("*patient*" "*medical*" "*health*" "*clinical*")
            ;;
        "legal")
            priority_patterns=("*agreement*" "*contract*" "*legal*" "*court*")
            ;;
        "financial")
            priority_patterns=("*invoice*" "*statement*" "*budget*" "*tax*")
            ;;
        "technical")
            priority_patterns=("*.py" "*.js" "*.sh" "*.sql")
            ;;
        *)
            priority_patterns=("*.pdf" "*.docx" "*.xlsx")
            ;;
    esac

    # Analyze priority files first
    for pattern in "${priority_patterns[@]}"; do
        find "$dir" -maxdepth 2 -type f -iname "$pattern" 2>/dev/null | head -20 | while read -r filepath; do
            if [ "$current_count" -lt "$max_files" ]; then
                analyze_file "$filepath" "$ANALYSIS_TYPE"
                ((current_count++))
            fi
        done
    done

    # Analyze remaining files up to limit
    find "$dir" -maxdepth 2 -type f ! -name ".DS_Store" 2>/dev/null | head -$((max_files - current_count)) | while read -r filepath; do
        analyze_file "$filepath" "$ANALYSIS_TYPE"
    done
}

# Generate executive summary
generate_summary() {
    local summary_file="$REPORT_DIR/EXECUTIVE_SUMMARY.md"

    cat > "$summary_file" << EOF
# Executive Summary - $ANALYSIS_TYPE Analysis
**Generated:** $(date '+%Y-%m-%d %H:%M:%S')
**Source:** $SOURCE_DIR
**Analysis Type:** $ANALYSIS_TYPE

## Key Findings

### Priority Items Requiring Action
EOF

    # Use AI to summarize all individual analyses
    local all_analyses=$(cat "$REPORT_DIR"/analysis_*.md 2>/dev/null | head -c 10000)

    if [ -n "$all_analyses" ]; then
        local summary_prompt="Synthesize these analyses into an executive summary with:
1. Top 5 critical findings
2. Immediate action items
3. Risk factors identified
4. Opportunities discovered
5. Recommendations

Analyses:
$all_analyses

Provide a concise, actionable executive summary."

        echo "$summary_prompt" | timeout 45 ollama run "mixtral:8x7b" >> "$summary_file" 2>/dev/null
    fi

    echo "" >> "$summary_file"
    echo "## Analysis Statistics" >> "$summary_file"
    echo "- Total files analyzed: $(ls -1 "$REPORT_DIR"/analysis_*.md 2>/dev/null | wc -l | tr -d ' ')" >> "$summary_file"
    echo "- Analysis type: $ANALYSIS_TYPE" >> "$summary_file"
    echo "- Report location: $REPORT_DIR" >> "$summary_file"
}

# Main execution
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${PURPLE}Starting Premium Analysis ($ANALYSIS_TYPE mode)${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""

# Count total files
TOTAL_FILES=$(find "$SOURCE_DIR" -type f ! -name ".DS_Store" 2>/dev/null | wc -l | tr -d ' ')
echo -e "${CYAN}📊 Total files available: $TOTAL_FILES${NC}"
echo -e "${YELLOW}⚡ Analyzing top priority files...${NC}"
echo ""

# Analyze main directories
for dir in "$SOURCE_DIR"/*; do
    if [ -d "$dir" ]; then
        analyze_directory "$dir" 50  # Analyze up to 50 files per directory
    fi
done

# Generate executive summary
echo ""
echo -e "${CYAN}📝 Generating executive summary...${NC}"
generate_summary

# Create specialized reports based on type
case "$ANALYSIS_TYPE" in
    "business")
        echo -e "${CYAN}📊 Creating business metrics dashboard...${NC}"
        cat > "$REPORT_DIR/BUSINESS_METRICS.md" << EOF
# Business Metrics Dashboard
## Property Performance
- Vacancy rates by property
- Delinquency patterns
- Maintenance costs

## Financial Health
- Revenue trends
- Operating expenses
- Cash flow analysis

## Risk Assessment
- High-risk tenants
- Upcoming lease expirations
- Maintenance backlogs
EOF
        ;;

    "medical")
        echo -e "${CYAN}🏥 Creating clinical summary...${NC}"
        cat > "$REPORT_DIR/CLINICAL_SUMMARY.md" << EOF
# Clinical Summary Report
## Patient Safety Issues
## Treatment Protocols
## Medication Management
## Compliance Status
EOF
        ;;

    "legal")
        echo -e "${CYAN}⚖️ Creating legal compliance report...${NC}"
        cat > "$REPORT_DIR/LEGAL_COMPLIANCE.md" << EOF
# Legal Compliance Report
## Contract Status
## Compliance Deadlines
## Risk Exposures
## Litigation Matters
EOF
        ;;
esac

# Final summary
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}              ✅ PREMIUM ANALYSIS COMPLETE                    ${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${GREEN}📁 Reports Generated:${NC}"
echo "  • Executive Summary: $REPORT_DIR/EXECUTIVE_SUMMARY.md"
echo "  • Individual Analyses: $REPORT_DIR/analysis_*.md"

if [ "$ANALYSIS_TYPE" == "business" ]; then
    echo "  • Business Metrics: $REPORT_DIR/BUSINESS_METRICS.md"
elif [ "$ANALYSIS_TYPE" == "legal" ]; then
    echo "  • Legal Compliance: $REPORT_DIR/LEGAL_COMPLIANCE.md"
fi

echo ""
echo -e "${YELLOW}💡 Next Steps:${NC}"
echo "  1. Review executive summary for priority items"
echo "  2. Check individual analyses for details"
echo "  3. Share reports with relevant stakeholders"
echo ""

# Open report directory
open "$REPORT_DIR"

exit 0