#!/bin/bash

# Fix Sornell Group Shared Drive Folder Structure
# This script consolidates all overlapping folders and moves category folders to proper locations

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     🔧 FIXING FOLDER STRUCTURE                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

cd "$HOME/Desktop/Google_Drive_Mirror/Sornell_Group_Shared_Drive"

# Step 1: Fix duplicate numbered folders
echo "Step 1: Fixing duplicate numbered folders..."
echo "==========================================="

# Remove old duplicate numbered folders
[ -d "01_Properties" ] && mv 01_Properties/* 01_PROPERTIES/ 2>/dev/null && rmdir 01_Properties 2>/dev/null
[ -d "02_Financial" ] && mv 02_Financial/* 02_FINANCIAL/ 2>/dev/null && rmdir 02_Financial 2>/dev/null
[ -d "03_Operations" ] && mv 03_Operations/* 03_OPERATIONS/ 2>/dev/null && rmdir 03_Operations 2>/dev/null
[ -d "04_Tenant_Management" ] && mv 04_Tenant_Management/* 03_OPERATIONS/03_TENANT_MANAGEMENT/ 2>/dev/null && rmdir 04_Tenant_Management 2>/dev/null
[ -d "20-TECHNOLOGY" ] && mv 20-TECHNOLOGY/* 10_TECHNOLOGY/ 2>/dev/null && rmdir 20-TECHNOLOGY 2>/dev/null
[ -d "50-GENERAL" ] && mv 50-GENERAL/* 10_TECHNOLOGY/ 2>/dev/null && rmdir 50-GENERAL 2>/dev/null

echo "✓ Fixed numbered folders"

# Step 2: Move category folders to proper locations
echo ""
echo "Step 2: Moving category folders to proper subfolders..."
echo "======================================================="

# Documents go to appropriate folders
if [ -d "DOCUMENTS" ]; then
    echo "Moving DOCUMENTS files..."
    mkdir -p 03_OPERATIONS/01_DAILY_OPERATIONS/Documents
    mv DOCUMENTS/* 03_OPERATIONS/01_DAILY_OPERATIONS/Documents/ 2>/dev/null
    rmdir DOCUMENTS 2>/dev/null
fi

# Spreadsheets go to Financial
if [ -d "SPREADSHEETS" ]; then
    echo "Moving SPREADSHEETS to Financial..."
    mkdir -p 02_FINANCIAL/00_SPREADSHEETS
    mv SPREADSHEETS/* 02_FINANCIAL/00_SPREADSHEETS/ 2>/dev/null
    rmdir SPREADSHEETS 2>/dev/null
fi

# Scripts go to Technology
if [ -d "SCRIPTS" ]; then
    echo "Moving SCRIPTS to Technology..."
    mv SCRIPTS/* 10_TECHNOLOGY/SCRIPTS/ 2>/dev/null
    rmdir SCRIPTS 2>/dev/null
fi

# Configs go to Technology
if [ -d "CONFIGS" ]; then
    echo "Moving CONFIGS to Technology..."
    mv CONFIGS/* 10_TECHNOLOGY/CONFIGS/ 2>/dev/null
    rmdir CONFIGS 2>/dev/null
fi

# Database files go to Technology
if [ -d "DATABASE" ]; then
    echo "Moving DATABASE to Technology..."
    mv DATABASE/* 10_TECHNOLOGY/DATABASES/ 2>/dev/null
    rmdir DATABASE 2>/dev/null
fi

# Images go to Archive/Media
if [ -d "IMAGES" ]; then
    echo "Moving IMAGES to Archive/Media..."
    mkdir -p 09_ARCHIVE/MEDIA/Images
    mv IMAGES/* 09_ARCHIVE/MEDIA/Images/ 2>/dev/null
    rmdir IMAGES 2>/dev/null
fi

# Videos go to Archive/Media
if [ -d "VIDEOS" ]; then
    echo "Moving VIDEOS to Archive/Media..."
    mkdir -p 09_ARCHIVE/MEDIA/Videos
    mv VIDEOS/* 09_ARCHIVE/MEDIA/Videos/ 2>/dev/null
    rmdir VIDEOS 2>/dev/null
fi

# Insurance goes to Legal/Compliance
if [ -d "INSURANCE" ]; then
    echo "Moving INSURANCE to Legal/Compliance..."
    mv INSURANCE/* 04_LEGAL_COMPLIANCE/02_INSURANCE/ 2>/dev/null
    rmdir INSURANCE 2>/dev/null
fi

# Maintenance goes to Operations
if [ -d "MAINTENANCE" ]; then
    echo "Moving MAINTENANCE to Operations..."
    mv MAINTENANCE/* 03_OPERATIONS/02_MAINTENANCE_QUEUE/ 2>/dev/null
    rmdir MAINTENANCE 2>/dev/null
fi

# Property files go to Properties
if [ -d "PROPERTY" ]; then
    echo "Moving PROPERTY files to Properties folder..."
    mkdir -p 01_PROPERTIES/00_GENERAL
    mv PROPERTY/* 01_PROPERTIES/00_GENERAL/ 2>/dev/null
    rmdir PROPERTY 2>/dev/null
fi

# Reports go to Archive
if [ -d "REPORTS" ]; then
    echo "Moving REPORTS to Archive..."
    mkdir -p 09_ARCHIVE/REPORTS
    mv REPORTS/* 09_ARCHIVE/REPORTS/ 2>/dev/null
    rmdir REPORTS 2>/dev/null
fi

# General files go to Archive/Unsorted
if [ -d "GENERAL" ]; then
    echo "Moving GENERAL to Archive/Unsorted..."
    mkdir -p 09_ARCHIVE/UNSORTED
    mv GENERAL/* 09_ARCHIVE/UNSORTED/ 2>/dev/null
    rmdir GENERAL 2>/dev/null
fi

# Step 3: Move property-specific category folders
echo ""
echo "Step 3: Moving property-specific folders..."
echo "==========================================="

for prop_folder in PROPERTY_*; do
    if [ -d "$prop_folder" ]; then
        case "$prop_folder" in
            PROPERTY_PARKDALE)
                echo "Moving $prop_folder..."
                mv "$prop_folder"/* 01_PROPERTIES/436_Parkdale_Ave/ 2>/dev/null
                rmdir "$prop_folder" 2>/dev/null
                ;;
            PROPERTY_CALLODINE)
                echo "Moving $prop_folder..."
                mkdir -p 01_PROPERTIES/Callodine_Properties
                mv "$prop_folder"/* 01_PROPERTIES/Callodine_Properties/ 2>/dev/null
                rmdir "$prop_folder" 2>/dev/null
                ;;
            PROPERTY_WARWICK)
                echo "Moving $prop_folder..."
                mv "$prop_folder"/* 01_PROPERTIES/186_Warwick_Dr/ 2>/dev/null
                rmdir "$prop_folder" 2>/dev/null
                ;;
            PROPERTY_FARGO)
                echo "Moving $prop_folder..."
                mv "$prop_folder"/* 01_PROPERTIES/157_Fargo_Ave/ 2>/dev/null
                rmdir "$prop_folder" 2>/dev/null
                ;;
            PROPERTY_LIVINGSTONE)
                echo "Moving $prop_folder..."
                mv "$prop_folder"/* 01_PROPERTIES/29_Livingstone_St/ 2>/dev/null
                rmdir "$prop_folder" 2>/dev/null
                ;;
            PROPERTY_STJAMES)
                echo "Moving $prop_folder..."
                mv "$prop_folder"/* 01_PROPERTIES/120_Saint_James_Pl/ 2>/dev/null
                rmdir "$prop_folder" 2>/dev/null
                ;;
            PROPERTY_MAINSTREET)
                echo "Moving $prop_folder..."
                mv "$prop_folder"/* 01_PROPERTIES/9155_Main_St/ 2>/dev/null
                rmdir "$prop_folder" 2>/dev/null
                ;;
        esac
    fi
done

# Step 4: Move other category folders
echo ""
echo "Step 4: Moving remaining category folders..."
echo "============================================"

# Move any remaining category folders
for cat_folder in ACTIVE_* ARCHIVED_* TAX_* FINANCIAL_* LEGAL_* SCRIPTS_* TENANT_* PDF_FILES; do
    if [ -d "$cat_folder" ]; then
        case "$cat_folder" in
            ACTIVE_*)
                echo "Moving $cat_folder to Operations..."
                mv "$cat_folder"/* 03_OPERATIONS/01_DAILY_OPERATIONS/ 2>/dev/null
                rmdir "$cat_folder" 2>/dev/null
                ;;
            ARCHIVED_*)
                year="${cat_folder#ARCHIVED_}"
                echo "Moving $cat_folder to Archive/$year..."
                mkdir -p "09_ARCHIVE/$year"
                mv "$cat_folder"/* "09_ARCHIVE/$year/" 2>/dev/null
                rmdir "$cat_folder" 2>/dev/null
                ;;
            TAX_*)
                echo "Moving $cat_folder to Financial/Tax..."
                mv "$cat_folder"/* 02_FINANCIAL/04_TAX_DOCUMENTS/ 2>/dev/null
                rmdir "$cat_folder" 2>/dev/null
                ;;
            FINANCIAL_*)
                echo "Moving $cat_folder to Financial..."
                mv "$cat_folder"/* 02_FINANCIAL/ 2>/dev/null
                rmdir "$cat_folder" 2>/dev/null
                ;;
            LEGAL_*)
                echo "Moving $cat_folder to Legal..."
                mv "$cat_folder"/* 04_LEGAL_COMPLIANCE/ 2>/dev/null
                rmdir "$cat_folder" 2>/dev/null
                ;;
            SCRIPTS_*)
                echo "Moving $cat_folder to Technology/Scripts..."
                mv "$cat_folder"/* 10_TECHNOLOGY/SCRIPTS/ 2>/dev/null
                rmdir "$cat_folder" 2>/dev/null
                ;;
            TENANT_*)
                echo "Moving $cat_folder to Operations/Tenant..."
                mv "$cat_folder"/* 03_OPERATIONS/03_TENANT_MANAGEMENT/ 2>/dev/null
                rmdir "$cat_folder" 2>/dev/null
                ;;
            PDF_FILES)
                echo "Moving PDF_FILES to Archive/PDFs..."
                mkdir -p 09_ARCHIVE/PDFs
                mv PDF_FILES/* 09_ARCHIVE/PDFs/ 2>/dev/null
                rmdir PDF_FILES 2>/dev/null
                ;;
        esac
    fi
done

# Step 5: Clean up empty directories
echo ""
echo "Step 5: Cleaning up empty directories..."
echo "========================================"
find . -maxdepth 1 -type d -empty -delete 2>/dev/null
echo "✓ Removed empty directories"

# Step 6: Display final structure
echo ""
echo "📊 FINAL CLEAN STRUCTURE:"
echo "========================="
echo ""
echo "Official folders (00-10):"
ls -d [0-9][0-9]_* 2>/dev/null | sort
echo ""
echo "Any remaining root folders:"
ls -d [A-Z]* 2>/dev/null | grep -v "README" | head -10

echo ""
echo "✅ STRUCTURE FIXED!"
echo ""
echo "Next steps:"
echo "1. Review 09_ARCHIVE/UNSORTED for files that need proper categorization"
echo "2. Check 01_PROPERTIES/00_GENERAL for property files that need specific property folders"
echo "3. Set up daily INBOX processing routine"