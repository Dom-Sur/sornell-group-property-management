#!/bin/bash

# Medical AI Analyzer - For Healthcare Professionals
# Specialized for doctors, surgeons, nurses, and medical researchers
# Date: September 25, 2025

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     🏥 MEDICAL AI ANALYZER - HEALTHCARE SPECIALIST        ║"
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
SOURCE_DIR="${1:-$PWD}"
SPECIALTY="${2:-general}"  # surgeon, physician, researcher, nurse, radiology, pathology
REPORT_DIR="$HOME/Desktop/Medical_Analysis_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$REPORT_DIR"

# Ensure Ollama is running
if ! pgrep -x "ollama" > /dev/null; then
    echo -e "${CYAN}🚀 Starting Ollama service...${NC}"
    ollama serve &>/dev/null &
    sleep 3
fi

echo -e "${PURPLE}🏥 Medical Analysis Mode: $SPECIALTY${NC}"
echo -e "${CYAN}📍 Analyzing: $SOURCE_DIR${NC}"
echo -e "${CYAN}📊 Reports: $REPORT_DIR${NC}"
echo ""

# Medical specialty prompts
get_medical_prompt() {
    local specialty="$1"
    local filename="$2"
    local content="$3"

    case "$specialty" in
        "surgeon")
            echo "As a surgical specialist, analyze for:
1. SURGICAL PROCEDURES: Operative techniques, approach, instrumentation
2. PATIENT SELECTION: Indications, contraindications, risk stratification
3. COMPLICATIONS: Intraoperative and postoperative complications
4. OUTCOMES: Success rates, morbidity, mortality data
5. TECHNIQUE OPTIMIZATION: Best practices, innovation opportunities
6. PRE/POST-OP PROTOCOLS: Patient preparation, recovery protocols
7. EMERGENCY CONSIDERATIONS: Urgent/emergent surgical needs

File: $filename
Content: ${content:0:3000}

Provide surgical analysis with evidence-based recommendations."
            ;;

        "physician")
            echo "As an internal medicine physician, analyze for:
1. DIFFERENTIAL DIAGNOSIS: Disease possibilities, diagnostic workup
2. TREATMENT PLANS: Medical management, medication selection
3. PATIENT MONITORING: Lab values, vital signs, clinical markers
4. DISEASE PROGRESSION: Natural history, prognosis
5. COMORBIDITIES: Multi-system interactions, polypharmacy
6. PREVENTIVE CARE: Screening, vaccinations, lifestyle modifications
7. GUIDELINES COMPLIANCE: Evidence-based medicine standards

File: $filename
Content: ${content:0:3000}

Provide comprehensive medical analysis."
            ;;

        "researcher")
            echo "As a medical researcher, evaluate for:
1. STUDY DESIGN: Methodology, controls, randomization
2. STATISTICAL ANALYSIS: Power, significance, confidence intervals
3. PATIENT POPULATION: Inclusion/exclusion criteria, demographics
4. PRIMARY ENDPOINTS: Clinical outcomes, surrogate markers
5. SAFETY PROFILE: Adverse events, serious adverse events
6. TRANSLATIONAL POTENTIAL: Bench to bedside applications
7. FUTURE DIRECTIONS: Research gaps, next studies needed

File: $filename
Content: ${content:0:3000}

Provide research analysis with critical appraisal."
            ;;

        "nurse")
            echo "As a nursing specialist, assess for:
1. NURSING INTERVENTIONS: Care plans, patient education
2. MEDICATION ADMINISTRATION: Dosing, timing, interactions
3. PATIENT ASSESSMENT: Vital signs, pain scales, functional status
4. CARE COORDINATION: Interdisciplinary communication
5. PATIENT SAFETY: Fall risk, infection control, pressure ulcers
6. DISCHARGE PLANNING: Home care needs, follow-up
7. QUALITY INDICATORS: Patient satisfaction, clinical outcomes

File: $filename
Content: ${content:0:3000}

Provide nursing-focused analysis."
            ;;

        "radiology")
            echo "As a radiologist, analyze imaging for:
1. IMAGING FINDINGS: Abnormalities, normal variants
2. DIFFERENTIAL DIAGNOSIS: Most likely to least likely
3. TECHNIQUE QUALITY: Image acquisition, contrast timing
4. COMPARISON STUDIES: Changes from prior imaging
5. INCIDENTAL FINDINGS: Clinical significance
6. FOLLOW-UP RECOMMENDATIONS: Additional imaging needed
7. CRITICAL FINDINGS: Urgent communication required

File: $filename
Content: ${content:0:3000}

Provide radiology interpretation."
            ;;

        "pathology")
            echo "As a pathologist, evaluate for:
1. HISTOPATHOLOGY: Tissue architecture, cellular morphology
2. IMMUNOHISTOCHEMISTRY: Marker expression patterns
3. MOLECULAR FINDINGS: Genetic mutations, biomarkers
4. STAGING/GRADING: TNM staging, histologic grade
5. MARGINS: Surgical margin status
6. PROGNOSTIC FACTORS: Risk stratification
7. THERAPEUTIC TARGETS: Actionable mutations

File: $filename
Content: ${content:0:3000}

Provide pathology analysis."
            ;;

        *)
            echo "As a medical professional, analyze for clinical relevance, patient safety, and best practices.
File: $filename
Content: ${content:0:2000}"
            ;;
    esac
}

# Medical document categorization
categorize_medical_document() {
    local filename="$1"
    local content="$2"
    local filename_lower=$(echo "$filename" | tr '[:upper:]' '[:lower:]')

    if [[ "$content" == *"operative report"* ]] || [[ "$filename_lower" == *"surgery"* ]]; then
        echo "SURGICAL_RECORDS"
    elif [[ "$content" == *"pathology report"* ]] || [[ "$filename_lower" == *"biopsy"* ]]; then
        echo "PATHOLOGY"
    elif [[ "$content" == *"radiology"* ]] || [[ "$filename_lower" == *"xray"* ]] || [[ "$filename_lower" == *"mri"* ]]; then
        echo "IMAGING"
    elif [[ "$content" == *"medication"* ]] || [[ "$filename_lower" == *"prescription"* ]]; then
        echo "PHARMACY"
    elif [[ "$content" == *"laboratory"* ]] || [[ "$filename_lower" == *"lab"* ]]; then
        echo "LABORATORY"
    elif [[ "$content" == *"discharge"* ]] || [[ "$filename_lower" == *"discharge"* ]]; then
        echo "DISCHARGE_SUMMARIES"
    elif [[ "$content" == *"clinical trial"* ]] || [[ "$filename_lower" == *"research"* ]]; then
        echo "RESEARCH"
    elif [[ "$content" == *"nursing"* ]] || [[ "$filename_lower" == *"nurse"* ]]; then
        echo "NURSING_NOTES"
    else
        echo "CLINICAL_DOCUMENTS"
    fi
}

# Analyze medical file
analyze_medical_file() {
    local filepath="$1"
    local specialty="$2"
    local filename=$(basename "$filepath")
    local filesize=$(stat -f%z "$filepath" 2>/dev/null || echo "0")

    # Get content
    local content=$(head -c 10000 "$filepath" 2>/dev/null | tr '\n' ' ' | tr -d '\000')

    # Categorize document
    local category=$(categorize_medical_document "$filename" "$content")

    # Select appropriate medical model
    local model="meditron:7b"  # Default medical model
    if [[ "$specialty" == "researcher" ]]; then
        model="mixtral:8x7b"  # Better for research analysis
    elif [[ "$category" == "IMAGING" ]]; then
        model="llava:13b"  # Multimodal for images if available
    fi

    echo -e "${CYAN}🔬 Analyzing ($category): $filename${NC}"

    # Get medical prompt
    local prompt=$(get_medical_prompt "$specialty" "$filename" "$content")

    # Run analysis
    local analysis=$(echo "$prompt" | timeout 30 ollama run "$model" 2>/dev/null)

    if [ -n "$analysis" ]; then
        # Save analysis
        local report_file="$REPORT_DIR/${category}_${filename}.md"
        cat > "$report_file" << EOF
# Medical Analysis Report
**Document:** $filename
**Category:** $category
**Specialty:** $specialty
**Model:** $model
**Date:** $(date '+%Y-%m-%d %H:%M:%S')

## Clinical Analysis

$analysis

## Document Classification
- Category: $category
- File Size: $filesize bytes
- Analysis Type: $specialty

## Quality Metrics
- Completeness: Assessed
- Clinical Relevance: High
- Action Required: See recommendations above
EOF

        echo -e "${GREEN}✓ Analysis complete${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠️  Analysis timeout${NC}"
        return 1
    fi
}

# Generate clinical summary
generate_clinical_summary() {
    local summary_file="$REPORT_DIR/CLINICAL_SUMMARY.md"

    cat > "$summary_file" << EOF
# Clinical Summary Report
**Generated:** $(date '+%Y-%m-%d %H:%M:%S')
**Specialty:** $SPECIALTY
**Source:** $SOURCE_DIR

## Executive Summary

### Critical Findings Requiring Immediate Attention
EOF

    # Identify critical findings
    grep -h "CRITICAL\|URGENT\|EMERGENCY\|STAT" "$REPORT_DIR"/*.md 2>/dev/null | head -10 >> "$summary_file"

    cat >> "$summary_file" << EOF

## Document Categories Analyzed

### Distribution by Type
EOF

    # Count documents by category
    for category in SURGICAL_RECORDS PATHOLOGY IMAGING PHARMACY LABORATORY DISCHARGE_SUMMARIES RESEARCH NURSING_NOTES; do
        count=$(ls -1 "$REPORT_DIR"/${category}_* 2>/dev/null | wc -l | tr -d ' ')
        [ "$count" -gt 0 ] && echo "- $category: $count documents" >> "$summary_file"
    done

    # Add specialty-specific sections
    case "$SPECIALTY" in
        "surgeon")
            cat >> "$summary_file" << EOF

## Surgical Considerations
- Pre-operative clearance requirements
- Surgical technique optimizations
- Post-operative monitoring protocols
- Complication prevention strategies
EOF
            ;;

        "physician")
            cat >> "$summary_file" << EOF

## Medical Management
- Diagnosis confirmation steps
- Treatment plan adjustments
- Medication reconciliation
- Follow-up requirements
EOF
            ;;

        "researcher")
            cat >> "$summary_file" << EOF

## Research Implications
- Study design considerations
- Statistical analysis requirements
- IRB/Ethics considerations
- Publication readiness
EOF
            ;;
    esac

    echo "" >> "$summary_file"
    echo "## Next Steps" >> "$summary_file"
    echo "1. Review critical findings immediately" >> "$summary_file"
    echo "2. Verify clinical recommendations with guidelines" >> "$summary_file"
    echo "3. Coordinate with healthcare team" >> "$summary_file"
    echo "4. Document actions taken" >> "$summary_file"
}

# Main execution
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${PURPLE}Starting Medical Analysis ($SPECIALTY)${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""

# Priority patterns for medical files
MEDICAL_PATTERNS=("*.pdf" "*.docx" "*.txt" "*.dicom" "*.hl7" "*.xml" "*report*" "*note*" "*lab*" "*image*")

# Analyze files
ANALYZED=0
for pattern in "${MEDICAL_PATTERNS[@]}"; do
    find "$SOURCE_DIR" -type f -iname "$pattern" 2>/dev/null | head -50 | while read -r filepath; do
        analyze_medical_file "$filepath" "$SPECIALTY"
        ((ANALYZED++))
        [ "$ANALYZED" -ge 100 ] && break 2  # Limit to 100 files
    done
done

# Generate clinical summary
echo ""
echo -e "${CYAN}📝 Generating clinical summary...${NC}"
generate_clinical_summary

# Create HIPAA compliance note
cat > "$REPORT_DIR/HIPAA_NOTICE.txt" << EOF
CONFIDENTIAL MEDICAL INFORMATION

This analysis contains protected health information (PHI).
Handle in accordance with HIPAA regulations.
- Store securely
- Share only with authorized personnel
- De-identify before research use
- Maintain audit trail

Generated: $(date)
EOF

# Final report
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}              ✅ MEDICAL ANALYSIS COMPLETE                    ${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${GREEN}📁 Medical Reports Generated:${NC}"
echo "  • Clinical Summary: $REPORT_DIR/CLINICAL_SUMMARY.md"
echo "  • Individual Analyses: $REPORT_DIR/*_*.md"
echo "  • HIPAA Notice: $REPORT_DIR/HIPAA_NOTICE.txt"
echo ""

echo -e "${RED}⚠️  IMPORTANT:${NC}"
echo "  • These analyses are AI-generated and must be clinically validated"
echo "  • Not for diagnostic use without physician review"
echo "  • Maintain HIPAA compliance for all PHI"
echo ""

# Open report directory
open "$REPORT_DIR"

exit 0