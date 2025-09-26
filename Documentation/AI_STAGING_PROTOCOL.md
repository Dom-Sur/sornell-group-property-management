# AI Staging & Innovation Protocol
## For Testing AI-Suggested Improvements Before SOP Integration

---

## 1. STAGING STRUCTURE

### Primary Staging Area (Private to Domenic)
```
📁 MyDrive/
   └── 📁 AI_STAGING/
       ├── 📁 00_AI_SUGGESTIONS/           ← Raw AI suggestions
       ├── 📁 01_TESTING/                  ← Active testing
       ├── 📁 02_VALIDATION/               ← Under review
       ├── 📁 03_APPROVED_PENDING/         ← Ready for SOP update
       ├── 📁 04_REJECTED/                 ← Not implemented
       └── 📁 05_ANALYTICS/                ← Performance metrics
```

### Shared Drive (Official Structure Only)
```
📁 Shared_Drive/
   └── [Official 8 SOP Folders Only]
       - No experimental folders
       - No AI-created categories
       - Strict SOP compliance
```

---

## 2. INNOVATION WORKFLOW

### Stage 1: AI Suggestion Capture
```mermaid
AI Identifies Pattern → Create in AI_STAGING → Test for 7 days
```

**Process:**
1. AI script detects new pattern/category need
2. Logs suggestion to `AI_STAGING/00_AI_SUGGESTIONS/suggestions_log.csv`
3. Creates test folder in `AI_STAGING/01_TESTING/`
4. Routes sample files for testing

**Log Format:**
```csv
Date,AI_Model,Suggested_Folder,Pattern_Detected,File_Count,Confidence_Score
2025-09-25,qwen2.5:32b,PROPERTY_METRICS,monthly_metrics_*,47,0.92
```

### Stage 2: Testing Phase (7 Days)
- Monitor file categorization accuracy
- Track user interaction
- Measure efficiency improvements
- Document edge cases

### Stage 3: Validation (Team Review)
**Weekly Review Meeting Agenda:**
1. Review AI suggestions from past week
2. Analyze testing metrics
3. Vote on implementation
4. Document decision rationale

**Approval Criteria:**
- [ ] 90%+ categorization accuracy
- [ ] Reduces manual filing by 20%+
- [ ] No conflicts with existing SOP
- [ ] Clear business value
- [ ] Team consensus (3/3 votes)

### Stage 4: SOP Integration
If approved:
1. Update Master Organization SOP
2. Create folder in Shared Drive
3. Update all AI scripts
4. Train team on new structure
5. Monitor for 30 days

---

## 3. AI STAGING SCRIPT

```bash
#!/bin/bash
# ai_staging_organizer.sh

STAGING_DIR="$HOME/Drive/MyDrive/AI_STAGING"
SHARED_DIR="$HOME/Desktop/Google_Drive_Mirror/Sornell_Group_Shared_Drive"
SUGGESTION_LOG="$STAGING_DIR/00_AI_SUGGESTIONS/suggestions_$(date +%Y%m).csv"

# Function to suggest new category
suggest_new_category() {
    local pattern="$1"
    local category="$2"
    local confidence="$3"
    local model="$4"

    # Log suggestion
    echo "$(date +%Y-%m-%d),$model,$category,$pattern,1,$confidence" >> "$SUGGESTION_LOG"

    # Create test folder in staging
    mkdir -p "$STAGING_DIR/01_TESTING/$category"

    # Don't create in shared drive!
    echo "📝 New category suggested: $category (Confidence: $confidence)"
    echo "   Testing in: AI_STAGING/01_TESTING/$category"
}

# Enhanced categorization with staging
categorize_with_staging() {
    local file="$1"
    local category=$(analyze_file "$file")

    # Check if category exists in official SOP
    if folder_exists_in_sop "$category"; then
        # Use official folder
        echo "$SHARED_DIR/$category"
    else
        # Route to staging for testing
        echo "$STAGING_DIR/01_TESTING/$category"
        suggest_new_category "$file" "$category" "0.85" "ollama:latest"
    fi
}
```

---

## 4. METRICS & REPORTING

### Weekly Innovation Report
```
AI STAGING REPORT - Week of [DATE]
=====================================

NEW SUGGESTIONS:
- Emergency_Repairs/ (15 files, 93% accuracy)
- Tenant_Complaints/ (8 files, 87% accuracy)
- Insurance_Claims/ (12 files, 95% accuracy)

TESTING RESULTS:
- Categories tested: 3
- Files processed: 35
- Accuracy rate: 91.7%
- Time saved: 2.5 hours

READY FOR APPROVAL:
- Property_Metrics/ (tested 14 days, 94% accuracy)

REJECTED THIS WEEK:
- Misc_Documents/ (too vague, 62% accuracy)
```

---

## 5. AI SCRIPT MODIFICATIONS

### Update ai_organizer_ultimate.sh:
```bash
# Add staging awareness
USE_STAGING="${USE_STAGING:-true}"

if [ "$USE_STAGING" = "true" ]; then
    DEST_BASE="$HOME/Drive/MyDrive/AI_STAGING/01_TESTING"
    echo "🧪 STAGING MODE: Testing new categories in MyDrive"
else
    DEST_BASE="$HOME/Desktop/Google_Drive_Mirror/Sornell_Group_Shared_Drive"
    echo "📁 PRODUCTION MODE: Using official SOP structure only"
fi
```

---

## 6. GOVERNANCE RULES

### What AI CAN Suggest:
✅ New property-specific subfolders
✅ Additional document categories
✅ Improved naming patterns
✅ Archive reorganization
✅ Temporal groupings (by year/month)

### What AI CANNOT Change:
❌ The 8 primary shared drives
❌ Core SOP naming convention
❌ Permission matrix
❌ Retention policies
❌ Security protocols

---

## 7. IMPLEMENTATION TIMELINE

### Phase 1: Immediate (Today)
1. Create AI_STAGING structure in MyDrive
2. Update scripts with staging logic
3. Start logging suggestions

### Phase 2: Week 1
1. Collect initial AI suggestions
2. Route test files to staging
3. Monitor accuracy metrics

### Phase 3: Week 2
1. First team review meeting
2. Approve/reject suggestions
3. Update SOP if needed

### Phase 4: Ongoing
1. Weekly innovation reviews
2. Monthly SOP updates
3. Quarterly AI model upgrades

---

## 8. SAMPLE SUGGESTION LOG

```csv
Date,Model,Category,Pattern,Files,Confidence,Status,Decision,Notes
2025-09-25,deepseek-r1:7b,EMERGENCY_REPAIRS,*urgent*repair*,15,0.92,Testing,,High value pattern
2025-09-25,qwen2.5:32b,PROPERTY_METRICS,*metrics*report*,23,0.88,Testing,,Monthly reports
2025-09-24,llama3.2:3b,RANDOM_STUFF,misc*,45,0.45,Rejected,Too vague,Low confidence
2025-09-23,phi4:latest,INSURANCE_CLAIMS,*claim*insurance*,12,0.95,Approved,Add to 04_LEGAL,High accuracy
```

---

## 9. SUCCESS METRICS

### KPIs for AI Staging System:
- **Innovation Rate**: 5+ useful suggestions/month
- **Accuracy Target**: 90%+ for approved categories
- **Adoption Rate**: 80%+ of suggestions tested
- **Time Savings**: 20%+ reduction in manual filing
- **SOP Updates**: 1-2 improvements/quarter

---

## 10. ROLLBACK PROCEDURE

If an approved category causes issues:
1. Move files back to previous location
2. Update scripts to remove category
3. Document lessons learned
4. Adjust approval criteria
5. Retrain AI models if needed

---

**Document Owner:** Domenic Surianello
**Review Frequency:** Weekly (Staging), Monthly (SOP)
**Next Review:** October 1, 2025

---