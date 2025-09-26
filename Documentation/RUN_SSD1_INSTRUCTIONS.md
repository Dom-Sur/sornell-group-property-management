# SSD1 Processing Instructions (50,374 Files)

## RECOMMENDED APPROACH

### Option 1: Process Everything with Premium AI (BEST)
```bash
~/Desktop/ssd1_process_all.sh
```
- Choose option 1 to process all 50,374 files
- Uses DeepSeek-R1, Qwen 32B, and other premium models
- Will take several hours but handles everything

### Option 2: Process in Batches (SAFER)
```bash
~/Desktop/ssd1_process_all.sh
```
- Choose option 3 for batch processing (1000 files at a time)
- Better for monitoring progress
- Can stop/restart if needed

### Option 3: Quick Organization (FASTEST)
```bash
~/Desktop/ssd1_quick_organize.sh
```
- Processes directories in parallel (up to 3 at once)
- Uses premium AI models
- Fastest option but less control

## MONITORING PROGRESS

### Watch the logs in real-time:
```bash
# In a new terminal window
tail -f ~/Desktop/SSD1_Processing_*/01_ACTIVE_OPERATIONS_process.log
```

### Check Ollama model usage:
```bash
# In another terminal
ollama ps
```

## DIRECTORY BREAKDOWN
- 01_ACTIVE_OPERATIONS: ~15,000 files (Priority!)
- 02_PROPERTIES: ~12,000 files (Critical leases)
- 03_ENTITIES: ~8,000 files
- 05_PERSONAL: ~7,000 files
- 06_TECHNOLOGY: ~8,374 files

## PREMIUM MODELS BEING USED
- **deepseek-r1:7b** - Legal documents, contracts, leases
- **qwen2.5-coder:32b** - Large code files (>50KB)
- **mixtral:8x7b** - Financial documents
- **domenic-business-v2** - Property management docs
- **parkdale-specialist** - Parkdale specific files
- **phi4:latest** - General purpose

## AFTER COMPLETION
1. Check organized files: `open ~/Desktop/Google_Drive_Mirror/Sornell_Group_Shared_Drive`
2. Review processing logs: `open ~/Desktop/SSD1_Processing_*`
3. Run duplicate check if needed
4. Consider removing SSD1 originals after verification

## TROUBLESHOOTING

If scripts stop or fail:
```bash
# Check if Ollama is running
pgrep -x "ollama" || ollama serve &

# Kill any stuck processes
pkill -f "ai_organize_premium"

# Restart with batch mode (safer)
~/Desktop/ssd1_process_all.sh
# Choose option 3
```

## ESTIMATED TIME
- Full processing: 4-6 hours (all 50,374 files)
- Batch mode: 5-7 hours (with breaks between batches)
- Quick mode: 3-4 hours (parallel processing)

Start with Option 2 (batch mode) for best control and monitoring!