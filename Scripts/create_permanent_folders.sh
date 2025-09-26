#!/bin/bash

# Create Permanent Folder Structure for Sornell Group Shared Drive
# Based on Official Master Organization SOP
# Date: September 25, 2025

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     📁 CREATING PERMANENT FOLDER STRUCTURE                ║"
echo "║         Sornell Group Shared Drive                        ║"
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

BASE_DIR="$HOME/Desktop/Google_Drive_Mirror/Sornell_Group_Shared_Drive"

echo -e "${CYAN}📍 Base Directory: $BASE_DIR${NC}"
echo ""

# Main Drive Structure (8 Primary Drives as per SOP)
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}Creating Primary Folder Structure${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"

# Create main directories with proper naming
declare -a MAIN_DIRS=(
    "00_INBOX"
    "01_PROPERTIES"
    "02_FINANCIAL"
    "03_OPERATIONS"
    "04_LEGAL_COMPLIANCE"
    "05_STRATEGIC_PLANNING"
    "06_VENDOR_MANAGEMENT"
    "07_TEMPLATES_FORMS"
    "08_EXTERNAL_SHARES"
    "09_ARCHIVE"
    "10_TECHNOLOGY"
)

for dir in "${MAIN_DIRS[@]}"; do
    mkdir -p "$BASE_DIR/$dir"
    echo -e "${GREEN}✓ Created: $dir${NC}"
done

# Property Subfolders - Standard structure for each property
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}Creating Property Subfolders${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"

# List of properties
declare -a PROPERTIES=(
    "436_Parkdale_Ave"
    "232_Callodine_Ave"
    "240_Callodine_Ave"
    "186_Warwick_Dr"
    "157_Fargo_Ave"
    "29_Livingstone_St"
    "120_Saint_James_Pl"
    "9155_Main_St"
)

# Create standard subfolders for each property
for prop in "${PROPERTIES[@]}"; do
    prop_dir="$BASE_DIR/01_PROPERTIES/$prop"
    mkdir -p "$prop_dir/01_OWNERSHIP"
    mkdir -p "$prop_dir/02_LEASES"
    mkdir -p "$prop_dir/03_MAINTENANCE"
    mkdir -p "$prop_dir/04_FINANCIALS"
    mkdir -p "$prop_dir/05_DOCUMENTATION"
    echo -e "${GREEN}✓ Created property structure: $prop${NC}"
done

# Financial Subfolders
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}Creating Financial Subfolders${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"

mkdir -p "$BASE_DIR/02_FINANCIAL/01_MONTHLY_REPORTS"
mkdir -p "$BASE_DIR/02_FINANCIAL/02_QUARTERLY_STATEMENTS"
mkdir -p "$BASE_DIR/02_FINANCIAL/03_ANNUAL_REPORTS"
mkdir -p "$BASE_DIR/02_FINANCIAL/04_TAX_DOCUMENTS"
mkdir -p "$BASE_DIR/02_FINANCIAL/05_BANKING"
mkdir -p "$BASE_DIR/02_FINANCIAL/06_INVOICES"
mkdir -p "$BASE_DIR/02_FINANCIAL/07_BUDGETS"
mkdir -p "$BASE_DIR/02_FINANCIAL/08_CAPEX"

echo -e "${GREEN}✓ Created financial structure${NC}"

# Operations Subfolders
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}Creating Operations Subfolders${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"

mkdir -p "$BASE_DIR/03_OPERATIONS/01_DAILY_OPERATIONS"
mkdir -p "$BASE_DIR/03_OPERATIONS/02_MAINTENANCE_QUEUE"
mkdir -p "$BASE_DIR/03_OPERATIONS/03_TENANT_MANAGEMENT"
mkdir -p "$BASE_DIR/03_OPERATIONS/04_VACANCY_REDUCTION"
mkdir -p "$BASE_DIR/03_OPERATIONS/05_INSPECTIONS"
mkdir -p "$BASE_DIR/03_OPERATIONS/06_EMERGENCY_RESPONSE"

echo -e "${GREEN}✓ Created operations structure${NC}"

# Legal & Compliance Subfolders
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}Creating Legal & Compliance Subfolders${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"

mkdir -p "$BASE_DIR/04_LEGAL_COMPLIANCE/01_CONTRACTS"
mkdir -p "$BASE_DIR/04_LEGAL_COMPLIANCE/02_INSURANCE"
mkdir -p "$BASE_DIR/04_LEGAL_COMPLIANCE/03_LICENSES_PERMITS"
mkdir -p "$BASE_DIR/04_LEGAL_COMPLIANCE/04_LEGAL_CORRESPONDENCE"
mkdir -p "$BASE_DIR/04_LEGAL_COMPLIANCE/05_COMPLIANCE_DOCS"

echo -e "${GREEN}✓ Created legal structure${NC}"

# Strategic Planning Subfolders
mkdir -p "$BASE_DIR/05_STRATEGIC_PLANNING/01_BUSINESS_PLANS"
mkdir -p "$BASE_DIR/05_STRATEGIC_PLANNING/02_MARKET_ANALYSIS"
mkdir -p "$BASE_DIR/05_STRATEGIC_PLANNING/03_EXPANSION_PLANS"
mkdir -p "$BASE_DIR/05_STRATEGIC_PLANNING/04_MEETING_NOTES"

echo -e "${GREEN}✓ Created strategic planning structure${NC}"

# Vendor Management Subfolders
mkdir -p "$BASE_DIR/06_VENDOR_MANAGEMENT/01_ACTIVE_VENDORS"
mkdir -p "$BASE_DIR/06_VENDOR_MANAGEMENT/02_VENDOR_CONTRACTS"
mkdir -p "$BASE_DIR/06_VENDOR_MANAGEMENT/03_VENDOR_INVOICES"
mkdir -p "$BASE_DIR/06_VENDOR_MANAGEMENT/04_VENDOR_EVALUATIONS"

echo -e "${GREEN}✓ Created vendor management structure${NC}"

# Templates & Forms
mkdir -p "$BASE_DIR/07_TEMPLATES_FORMS/01_LEASE_TEMPLATES"
mkdir -p "$BASE_DIR/07_TEMPLATES_FORMS/02_MAINTENANCE_FORMS"
mkdir -p "$BASE_DIR/07_TEMPLATES_FORMS/03_FINANCIAL_TEMPLATES"
mkdir -p "$BASE_DIR/07_TEMPLATES_FORMS/04_OPERATIONAL_FORMS"

echo -e "${GREEN}✓ Created templates structure${NC}"

# External Shares - For stakeholders
mkdir -p "$BASE_DIR/08_EXTERNAL_SHARES/APRIL_PROPERTIES"
mkdir -p "$BASE_DIR/08_EXTERNAL_SHARES/JEFF_FINANCIAL"
mkdir -p "$BASE_DIR/08_EXTERNAL_SHARES/MERIK_STRATEGY"
mkdir -p "$BASE_DIR/08_EXTERNAL_SHARES/CPA_TAX"
mkdir -p "$BASE_DIR/08_EXTERNAL_SHARES/ATTORNEYS"
mkdir -p "$BASE_DIR/08_EXTERNAL_SHARES/CONTRACTORS"
mkdir -p "$BASE_DIR/08_EXTERNAL_SHARES/INSURANCE"

echo -e "${GREEN}✓ Created external shares structure${NC}"

# Archive Structure
mkdir -p "$BASE_DIR/09_ARCHIVE/2023"
mkdir -p "$BASE_DIR/09_ARCHIVE/2024"
mkdir -p "$BASE_DIR/09_ARCHIVE/2025"

echo -e "${GREEN}✓ Created archive structure${NC}"

# Technology Structure (Enhanced)
mkdir -p "$BASE_DIR/10_TECHNOLOGY/AI_AUTOMATION"
mkdir -p "$BASE_DIR/10_TECHNOLOGY/SCRIPTS"
mkdir -p "$BASE_DIR/10_TECHNOLOGY/DOCUMENTATION"
mkdir -p "$BASE_DIR/10_TECHNOLOGY/DATABASES"
mkdir -p "$BASE_DIR/10_TECHNOLOGY/CONFIGS"

echo -e "${GREEN}✓ Created technology structure${NC}"

# Create README files in key directories
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}Creating README Files${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"

# Create main README
cat > "$BASE_DIR/README.md" << EOF
# Sornell Group Shared Drive
## Master Organization Structure

This is the official folder structure for the Sornell Group property management portfolio.

### Primary Folders:
- **00_INBOX** - All new documents start here
- **01_PROPERTIES** - Property-specific documents (43 properties)
- **02_FINANCIAL** - Financial records and reports
- **03_OPERATIONS** - Daily operational documents
- **04_LEGAL_COMPLIANCE** - Legal documents and compliance
- **05_STRATEGIC_PLANNING** - Business planning documents
- **06_VENDOR_MANAGEMENT** - Vendor relationships
- **07_TEMPLATES_FORMS** - Standard forms and templates
- **08_EXTERNAL_SHARES** - Controlled external access
- **09_ARCHIVE** - Historical documents by year
- **10_TECHNOLOGY** - IT and automation resources

### Access Control:
- Owner: Domenic Surianello
- Editors: Matthew (Technical), Jack (Admin)
- Viewers: As specified in permission matrix

### File Naming Convention:
\`[YYYY-MM-DD]_[CATEGORY]_[PROPERTY]_[DESCRIPTION]_[VERSION].[ext]\`

Example: \`2025-09-25_LEASE_436Parkdale_Unit2B_Renewal_v1.pdf\`

Last Updated: $(date '+%Y-%m-%d %H:%M:%S')
EOF

echo -e "${GREEN}✓ Created README.md${NC}"

# Create INBOX instructions
cat > "$BASE_DIR/00_INBOX/INSTRUCTIONS.md" << EOF
# INBOX Processing Instructions

## Daily Processing (9:00 AM & 5:00 PM)
1. Check all new files
2. Rename according to convention
3. Move to appropriate folder
4. Update tracking log

## File Naming Convention:
\`[YYYY-MM-DD]_[CATEGORY]_[PROPERTY]_[DESCRIPTION]_[VERSION].[ext]\`

## Category Codes:
- PROP - Property Documents
- LEASE - Lease Agreements
- MAINT - Maintenance Records
- FIN - Financial Documents
- LEGAL - Legal Documents
- INS - Insurance
- TAX - Tax Related
- VENDOR - Vendor Contracts
EOF

echo -e "${GREEN}✓ Created INBOX instructions${NC}"

# Summary
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}              ✅ PERMANENT STRUCTURE CREATED                  ${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""

# Count folders created
FOLDER_COUNT=$(find "$BASE_DIR" -type d | wc -l | tr -d ' ')

echo -e "${CYAN}📊 Summary:${NC}"
echo "  • Main directories: ${#MAIN_DIRS[@]}"
echo "  • Properties configured: ${#PROPERTIES[@]}"
echo "  • Total folders created: $FOLDER_COUNT"
echo "  • README files created: 2"
echo ""

echo -e "${YELLOW}💡 Next Steps:${NC}"
echo "  1. Files will be automatically organized into these folders"
echo "  2. Set up permissions according to access matrix"
echo "  3. Configure external shares with expiration dates"
echo "  4. Begin daily INBOX processing routine"
echo ""

exit 0