# AI Organization Patterns Documentation

## Overview
Complete documentation of all file patterns used by the AI organization scripts to categorize and organize files.

## 🎯 Pattern Categories & Priority

### 1. PROPERTY-SPECIFIC (Highest Priority)
These patterns identify files related to specific properties in your portfolio.

| Pattern | Category | Example Files |
|---------|----------|---------------|
| `*parkdale*` | PROPERTY_PARKDALE | 436_parkdale_lease.pdf, parkdale_maintenance.xlsx |
| `*callodine*` | PROPERTY_CALLODINE | 232_callodine_tenant.doc, callodine_rent_roll.csv |
| `*warwick*` | PROPERTY_WARWICK | 186_warwick_inspection.pdf |
| `*fargo*` | PROPERTY_FARGO | 157_fargo_invoice.pdf |
| `*livingstone*` | PROPERTY_LIVINGSTONE | 29_livingstone_agreement.docx |
| `*saint*james*` or `*st*james*` | PROPERTY_STJAMES | 120_saint_james_lease.pdf |
| `*main*street*` or `*9155*` | PROPERTY_MAINSTREET | 9155_main_street_tax.pdf |

### 2. LEGAL DOCUMENTS
Contracts, leases, and legal agreements.

| Pattern | Category | Example Files |
|---------|----------|---------------|
| `*lease*` or `*rental*agreement*` | LEGAL_LEASES | apartment_lease_2025.pdf |
| `*contract*` or `*agreement*` | LEGAL_CONTRACTS | service_contract.docx |

### 3. FINANCIAL DOCUMENTS
Financial records, invoices, and banking documents.

| Pattern | Category | Example Files |
|---------|----------|---------------|
| `*invoice*` or `*receipt*` or `*payment*` | FINANCIAL_INVOICES | plumber_invoice_oct.pdf |
| `*bank*` or `*statement*` | FINANCIAL_BANKING | chase_statement_sept.pdf |

### 4. TAX DOCUMENTS
Tax-related files with year detection.

| Pattern | Category | Example Files |
|---------|----------|---------------|
| `*tax*` or `*w9*` or `*1099*` | TAX_[YEAR] | 2024_tax_return.pdf, w9_tenant.pdf |
| Contains "2024" | TAX_2024 | property_tax_2024.xlsx |
| Contains "2023" | TAX_2023 | 1099_2023.pdf |

### 5. OPERATIONS & MAINTENANCE
Daily operations and maintenance records.

| Pattern | Category | Example Files |
|---------|----------|---------------|
| `*maintenance*` or `*repair*` or `*work*order*` | MAINTENANCE | hvac_repair_order.pdf |
| `*tenant*` or `*application*` or `*resident*` | TENANT_RECORDS | tenant_application_smith.pdf |
| `*insurance*` or `*policy*` | INSURANCE | property_insurance_policy.pdf |

### 6. TECHNICAL FILES (By Extension)
Programming and technical files categorized by extension.

| Extension | Category | Example Files |
|-----------|----------|---------------|
| `.sh`, `.bash` | SCRIPTS_BASH | backup_script.sh |
| `.py`, `.ipynb` | SCRIPTS_PYTHON | data_analysis.py, notebook.ipynb |
| `.js`, `.ts`, `.jsx`, `.tsx` | SCRIPTS_JAVASCRIPT | app.js, component.tsx |
| `.sql`, `.db` | DATABASE | property_database.sql |
| `.json`, `.yaml`, `.yml`, `.toml` | CONFIGS | settings.json, config.yaml |

### 7. DOCUMENT TYPES (By Extension)
General document categorization.

| Extension | Category | Example Files |
|-----------|----------|---------------|
| `.md`, `.txt`, `.doc`, `.docx` | DOCUMENTS | README.md, notes.txt |
| `.xls`, `.xlsx`, `.csv` | SPREADSHEETS | budget.xlsx, data.csv |
| `.pdf` | PDF_FILES | report.pdf |

### 8. MEDIA FILES
Images and videos.

| Extension | Category | Example Files |
|-----------|----------|---------------|
| `.jpg`, `.jpeg`, `.png`, `.gif` | IMAGES | property_photo.jpg |
| `.mp4`, `.mov`, `.avi` | VIDEOS | walkthrough.mp4 |

### 9. TIME-BASED ORGANIZATION
Files organized by year.

| Pattern | Category | Purpose |
|---------|----------|---------|
| `*2025*` | ACTIVE_2025 | Current year active files |
| `*2024*` | ARCHIVED_2024 | Previous year archives |
| `*2023*` | ARCHIVED_2023 | Older archives |

### 10. BUSINESS REPORTS
Analysis and reporting documents.

| Pattern | Category | Example Files |
|---------|----------|---------------|
| `*report*` or `*analysis*` | REPORTS | monthly_report.pdf, roi_analysis.xlsx |

## 🚫 Files That Are Skipped

### Hidden/System Files
- Any file starting with `.` (e.g., `.DS_Store`, `.gitignore`)
- Exception: These are processed if AI mode is enabled

### Junk Files (Auto-deleted in aggressive mode)
- `.DS_Store`
- `*.tmp`, `*.temp`
- `*.cache`
- `Thumbs.db`
- `desktop.ini`
- `*.log.1`, `*.log.2`
- `npm-debug.log*`
- `*.swp`, `*.swo`
- `*~`
- `.#*`
- `*.bak`, `*.backup`
- `._*`
- Empty files (0 bytes)

## 📁 Final Category Structure

```
Google_Drive_Mirror/Sornell_Group_Shared_Drive/
├── PROPERTY_PARKDALE/         # 436 Parkdale specific
├── PROPERTY_CALLODINE/        # 232 & 240 Callodine
├── PROPERTY_WARWICK/          # 186 Warwick
├── PROPERTY_FARGO/            # 157 Fargo
├── PROPERTY_LIVINGSTONE/      # 29 Livingstone
├── PROPERTY_STJAMES/          # 120 Saint James
├── PROPERTY_MAINSTREET/       # 9155 Main Street
├── LEGAL_LEASES/              # All lease documents
├── LEGAL_CONTRACTS/           # Other legal contracts
├── FINANCIAL_INVOICES/        # Invoices and receipts
├── FINANCIAL_BANKING/         # Bank statements
├── TAX_2024/                  # 2024 tax documents
├── TAX_2023/                  # 2023 tax documents
├── TAX_DOCUMENTS/             # Other tax files
├── MAINTENANCE/               # Repair and maintenance
├── TENANT_RECORDS/            # Tenant applications/info
├── INSURANCE/                 # Insurance policies
├── SCRIPTS_BASH/              # Shell scripts
├── SCRIPTS_PYTHON/            # Python code
├── SCRIPTS_JAVASCRIPT/        # JavaScript/TypeScript
├── DATABASE/                  # SQL and database files
├── CONFIGS/                   # Configuration files
├── DOCUMENTS/                 # Text documents
├── SPREADSHEETS/              # Excel/CSV files
├── PDF_FILES/                 # PDF documents
├── IMAGES/                    # Photos and images
├── VIDEOS/                    # Video files
├── ACTIVE_2025/               # Current year files
├── ARCHIVED_2024/             # 2024 archives
├── ARCHIVED_2023/             # 2023 archives
├── REPORTS/                   # Business reports
└── GENERAL/                   # Uncategorized files
```

## 🚀 Processing Priority

1. **Pattern Matching First** - 90% of files match patterns
2. **AI Fallback** (Optional) - For unknown patterns only
3. **Default to GENERAL** - If all else fails

## 💡 Tips for File Naming

To ensure proper automatic categorization:

1. **Include property name** in filename (e.g., `parkdale_lease_unit2.pdf`)
2. **Include year** for time-sensitive docs (e.g., `invoice_2025_jan.pdf`)
3. **Use descriptive keywords** (e.g., `maintenance`, `tenant`, `tax`)
4. **Keep original extensions** for proper type detection

## 🎯 Script Selection Guide

- **Fast Organizer** (`ai_organizer_fast.sh`) - RECOMMENDED
  - Pattern-first approach
  - Minimal AI usage
  - Best for daily organization

- **Ultimate Organizer** (`ai_organizer_ultimate.sh`)
  - AI-heavy processing
  - Deep content analysis
  - Use for complex files

- **Quick Power** (`ai_quick_power.sh`)
  - Parallel processing
  - Best for large batches
  - Ultra-fast execution

## 📊 Performance Metrics

| Script | Files/Minute | AI Usage | Best For |
|--------|--------------|----------|----------|
| Fast Organizer | 1000+ | Minimal | Daily organization |
| Ultimate | 5-10 | Heavy | Complex analysis |
| Quick Power | 2000+ | None | Bulk processing |

## 🔄 Duplicate Handling

- MD5 hash-based detection
- **Smart mode**: Skip duplicates
- **Aggressive mode**: Delete duplicates
- **Preserve mode**: Keep all copies

## 📝 Notes

- Patterns are case-insensitive
- Multiple patterns can match one file (first match wins)
- Empty folders are preserved in smart/preserve modes
- AI models used: llama3.2:1b (fast), llama3.2:3b (medium), phi4:latest (general)