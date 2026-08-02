#!/bin/bash
# FormBridge Submission Packager (Bash)
# Purpose: Create idempotent submission package for professor/demo delivery
# Usage: bash scripts/package_submission.sh
# Output: dist/formbridge_submission_YYYYMMDD.zip

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Output functions
log_success() { echo -e "${GREEN}✓ $*${NC}"; }
log_warning() { echo -e "${YELLOW}⚠ $*${NC}"; }
log_error() { echo -e "${RED}✗ $*${NC}"; }
log_info() { echo -e "${CYAN}ℹ $*${NC}"; }

# Configuration
OUTPUT_DIR="${1:-dist}"
TIMESTAMP=$(date +%s)
DATE_ONLY=$(date +%Y%m%d)
ZIP_NAME="formbridge_submission_${DATE_ONLY}.zip"
ZIP_PATH="${OUTPUT_DIR}/${ZIP_NAME}"
TEMP_DIR="/tmp/formbridge_package_${TIMESTAMP}"
PROJECT_ROOT="$(pwd)"

log_info "FormBridge Submission Packager"
log_info "==============================="
log_info "Output: ${OUTPUT_DIR}"
log_info "Timestamp: ${TIMESTAMP}"
log_info ""

# Pre-flight checks
log_info "Running pre-flight checks..."

REQUIRED_FILES=(
    "api/openapi.yaml"
    "api/postman/FormBridge.postman_collection.json"
    "api/postman/FormBridge.Dev.postman_environment.json"
    "api/postman/FormBridge.Prod.postman_environment.json"
    "backend/contact_form_lambda.py"
    "docs/demo/VIVA_SCRIPT.md"
    "docs/demo/DEMO_RUNBOOK.md"
    "docs/demo/SUBMISSION_CHECKLIST.md"
    "docs/demo/FAQ.md"
    "docs/demo/ONE_PAGER.md"
    "docs/demo/SCREENSHOT_SHOTLIST.md"
    "README.md"
    "template.yaml"
)

MISSING_COUNT=0
for file in "${REQUIRED_FILES[@]}"; do
    if [[ ! -f "$PROJECT_ROOT/$file" ]]; then
        log_warning "Missing: $file"
        ((MISSING_COUNT++))
    else
        log_success "Found: $file"
    fi
done

if [[ $MISSING_COUNT -gt 0 ]]; then
    log_error "Missing $MISSING_COUNT required files. Aborting."
    exit 1
fi

log_info ""
log_info "Creating temporary staging directory..."
rm -rf "$TEMP_DIR" 2>/dev/null || true
mkdir -p "$TEMP_DIR"
log_success "Staging dir: $TEMP_DIR"

log_info ""
log_info "Copying project files..."

# Items to copy
ITEMS_TO_COPY=(
    "backend"
    "dashboard"
    "docs"
    "api"
    "scripts"
    "template.yaml"
    "README.md"
    "README_PRODUCTION.md"
    "IMPLEMENTATION_SUMMARY_HMAC_EXPORT.md"
    "HMAC_EXPORT_QUICK_REFERENCE.md"
    "SESSION_COMPLETION_SUMMARY.md"
)

for item in "${ITEMS_TO_COPY[@]}"; do
    SOURCE_PATH="$PROJECT_ROOT/$item"
    DEST_PATH="$TEMP_DIR/$item"
    
    if [[ -e "$SOURCE_PATH" ]]; then
        if [[ -d "$SOURCE_PATH" ]]; then
            # Copy directory, excluding patterns
            find "$SOURCE_PATH" -type d \( -name ".venv" -o -name ".aws-sam" -o -name "__pycache__" -o -name ".git" -o -name ".vscode" -o -name "node_modules" \) -prune -o -type f -print | while read -r file; do
                rel_path="${file#$SOURCE_PATH/}"
                mkdir -p "$(dirname "$DEST_PATH/$rel_path")"
                cp "$file" "$DEST_PATH/$rel_path"
            done
            log_success "Copied directory: $item"
        else
            # Copy file
            cp "$SOURCE_PATH" "$DEST_PATH"
            log_success "Copied file: $item"
        fi
    fi
done

# Copy screenshots if exists
SCREENSHOT_SRC="$PROJECT_ROOT/docs/screenshots"
if [[ -d "$SCREENSHOT_SRC" ]]; then
    cp -r "$SCREENSHOT_SRC" "$TEMP_DIR/docs/screenshots"
    log_success "Copied screenshots"
else
    log_warning "No screenshots folder found (optional)"
fi

# Create READ_ME_FIRST.txt
log_info ""
log_info "Creating READ_ME_FIRST.txt..."

cat > "$TEMP_DIR/READ_ME_FIRST.txt" << 'READMEEOF'
╔════════════════════════════════════════════════════════════════════════════╗
║                     FormBridge - Submission Package                        ║
║                      Serverless Contact Form API                           ║
║                                                                            ║
║  Date: $(date '+%A, %B %d, %Y')                                               ║
╚════════════════════════════════════════════════════════════════════════════╝

👋 WELCOME

This package contains the complete FormBridge project—a production-ready,
serverless contact form API built on AWS Lambda, DynamoDB, and SES.

📚 GETTING STARTED (Pick One)

  Option 1: QUICK DEMO (5 minutes)
  ─────────────────────────────────
  1. Read: docs/demo/ONE_PAGER.md
  2. Watch: docs/demo/DEMO_RUNBOOK.md (visual walkthrough)
  3. Try locally: make local-up && make sam-api

  Option 2: VIVA PRESENTATION (8 minutes)
  ──────────────────────────────────────
  1. Read: docs/demo/VIVA_SCRIPT.md (complete script with Q&A)
  2. Practice with: docs/demo/DEMO_RUNBOOK.md
  3. Check: docs/demo/SUBMISSION_CHECKLIST.md before presenting

  Option 3: TECHNICAL DEEP-DIVE (30 minutes)
  ──────────────────────────────────────────
  1. Architecture: docs/demo/ONE_PAGER.md → Architecture section
  2. API Spec: api/openapi.yaml (or open in Swagger UI)
  3. FAQ: docs/demo/FAQ.md (design decisions explained)
  4. Code: backend/contact_form_lambda.py (main handler)

📁 PROJECT STRUCTURE

  formbridge_submission_YYYYMMDD/
  ├── backend/                              # Lambda Python code
  │   └── contact_form_lambda.py
  ├── dashboard/                            # React analytics dashboard
  │   ├── index.html
  │   ├── app.js
  │   └── config.example.js
  ├── docs/                                 # Documentation
  │   ├── demo/                             # Demo & viva docs
  │   │   ├── VIVA_SCRIPT.md               # 6-8 min presentation script
  │   │   ├── DEMO_RUNBOOK.md              # Step-by-step demo guide
  │   │   ├── ONE_PAGER.md                 # 1-page recruiter/prof summary
  │   │   ├── FAQ.md                       # 50 Q&As on design/architecture
  │   │   ├── SUBMISSION_CHECKLIST.md      # Pre-submission verification
  │   │   └── SCREENSHOT_SHOTLIST.md       # What to screenshot
  │   ├── screenshots/                      # Screenshots (if provided)
  │   ├── HMAC_SIGNING.md                  # HMAC implementation guide
  │   └── EXPORT_README.md                 # CSV export guide
  ├── api/                                  # API artifacts
  │   ├── openapi.yaml                     # OpenAPI 3.0 specification
  │   └── postman/                          # Postman collection & envs
  │       ├── FormBridge.postman_collection.json
  │       ├── FormBridge.Dev.postman_environment.json
  │       └── FormBridge.Prod.postman_environment.json
  ├── scripts/                              # Utility scripts
  ├── template.yaml                         # SAM infrastructure template
  ├── README.md                             # Main project README
  ├── README_PRODUCTION.md                  # Production deployment guide
  ├── IMPLEMENTATION_SUMMARY_HMAC_EXPORT.md # HMAC/CSV implementation details
  ├── SESSION_COMPLETION_SUMMARY.md         # Session overview
  └── READ_ME_FIRST.txt                     # This file

🚀 QUICK START (5 MINUTES)

  1. Install dependencies:
     - AWS CLI: https://aws.amazon.com/cli/
     - SAM CLI: https://aws.amazon.com/serverless/sam/
     - Docker: https://docker.com
     - Postman: https://www.postman.com

  2. Deploy locally:
     $ cd formbridge_submission_YYYYMMDD
     $ make local-up          # Start Docker services
     $ make sam-api           # Run Lambda locally
     $ make local-test        # Test form submission

  3. Deploy to AWS:
     $ sam build
     $ sam deploy --guided

  4. View results:
     - Dashboard: http://localhost:8080 (local) or GitHub Pages URL (prod)
     - DynamoDB: http://localhost:8001 (local admin UI)
     - Emails: http://localhost:8025 (MailHog for local testing)

📊 DEMO HIGHLIGHTS

  What you'll see:
  ✓ Form submission → DynamoDB storage → Email notification
  ✓ Real-time analytics dashboard (7-day trends)
  ✓ CSV export for reporting
  ✓ Security in action: API key validation, rate limiting, CORS
  ✓ CloudWatch logs and alarms

  Time required: 5–8 minutes live demo + Q&A

🔗 KEY DOCUMENTATION

  For professors/examiners:
  - ONE_PAGER.md                → Start here (project overview)
  - SUBMISSION_CHECKLIST.md     → Verification checklist
  - FAQ.md                      → Common questions & answers

  For developers:
  - template.yaml               → Infrastructure as Code (SAM)
  - backend/contact_form_lambda.py → Main Lambda handler
  - api/openapi.yaml            → API specification

  For operations:
  - README_PRODUCTION.md        → Deployment & monitoring guide
  - docs/demo/DEMO_RUNBOOK.md   → Live demo instructions

💰 COST & DEPLOYMENT

  - AWS free tier eligible: $0/month for typical usage
  - Region: ap-south-1 (Mumbai)
  - Uptime: 99.95%+ (AWS SLA)
  - Status: ✅ Live in production

🎯 NEXT STEPS

  1. Read ONE_PAGER.md (5 min)
  2. Review FAQ.md for common questions (10 min)
  3. Practice VIVA_SCRIPT.md using DEMO_RUNBOOK.md (20 min)
  4. Check SUBMISSION_CHECKLIST.md before viva (5 min)
  5. Deliver! 🚀

📧 CONTACT & LINKS

  GitHub: https://github.com/YOUR_USERNAME/formbridge
  Dashboard: https://YOUR_USERNAME.github.io/dashboard/
  OpenAPI UI: https://YOUR_USERNAME.github.io/swagger/
  Portfolio: https://YOUR_USERNAME.github.io

═══════════════════════════════════════════════════════════════════════════════

Questions? See docs/demo/FAQ.md or reach out.

Happy presenting! 🎉

READMEEOF

log_success "Created READ_ME_FIRST.txt"

# Create output directory if not exists
mkdir -p "$OUTPUT_DIR"
log_success "Output directory ready: $OUTPUT_DIR"

# Remove old zip if exists
if [[ -f "$ZIP_PATH" ]]; then
    rm -f "$ZIP_PATH"
    log_info "Removed old zip package"
fi

# Create zip file
log_info ""
log_info "Creating zip package..."

cd "$TEMP_DIR"
zip -r -q "$ZIP_PATH" .
cd "$PROJECT_ROOT"

log_success "Created zip: $ZIP_PATH"

# Get file size
FILE_SIZE=$(du -h "$ZIP_PATH" | cut -f1)
log_success "File size: $FILE_SIZE"

# Cleanup temp directory
log_info "Cleaning up temporary files..."
rm -rf "$TEMP_DIR"
log_success "Temp directory cleaned"

# Final summary
log_info ""
log_info "═════════════════════════════════════════════════════════"
log_success "✓ Submission package ready!"
log_info "═════════════════════════════════════════════════════════"
log_info ""
log_info "Package: $ZIP_PATH"
log_info "Size: $FILE_SIZE"
log_info "Date: $(date '+%Y-%m-%d %H:%M:%S')"
log_info ""
log_info "Next steps:"
log_info "1. Extract zip: unzip $ZIP_PATH -d <folder>"
log_info "2. Read: READ_ME_FIRST.txt"
log_info "3. Start with: docs/demo/ONE_PAGER.md"
log_info ""
log_success "Ready for submission! 🎉"
