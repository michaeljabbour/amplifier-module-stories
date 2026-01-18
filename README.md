# Amplifier Stories

Create polished presentations and documents showcasing Amplifier features and projects in multiple formats.

## What This Bundle Does

The **storyteller** agent creates professional content in five formats:
- **HTML** - "Useful Apple Keynote" style presentations
- **PowerPoint** - Professional .pptx presentations
- **Excel** - Data-driven dashboards and analysis
- **Word** - Detailed documentation and reports
- **PDF** - Final deliverables and forms

## Quick Start

### 1. Install Anthropic Skills (Required)

The storyteller uses Anthropic's skills library for document creation:

```bash
# Clone skills repository
git clone https://github.com/anthropics/skills ~/dev/anthropic-skills

# Add to Amplifier settings (if not already configured)
cat >> ~/.amplifier/settings.yaml << 'EOF'
skills:
  dirs:
    - ~/dev/anthropic-skills/skills
    - ~/.amplifier/skills
EOF
```

**Note:** Restart your Amplifier session after configuring skills.

### 2. Verify Skills Are Loaded

After restarting Amplifier:
```
"list available skills"
```

You should see: pptx, xlsx, docx, pdf (and others)

## Usage Examples

### HTML Presentations (Default)
```
"Tell a story about shadow environments"
"Create a deck about the new recipe feature"
```

### PowerPoint
```
"Create a PowerPoint about shadow environments"
"Make a .pptx presentation for the session forking feature"
```

### Excel Dashboards
```
"Make an Excel dashboard showing Amplifier adoption metrics"
"Create an xlsx workbook analyzing recipe execution performance"
```

### Word Documents
```
"Write a Word document detailing the recipe system architecture"
"Create a docx technical guide for the shadow environment feature"
```

### PDF Reports
```
"Create a PDF report summarizing Q1 Amplifier achievements"
"Make a PDF one-pager about the cost optimization feature"
```

## Dependencies

### Core (Always Required)
- **Amplifier CLI** - `uv tool install git+https://github.com/microsoft/amplifier`
- **Anthropic Skills** - Cloned to `~/dev/anthropic-skills`

### Format-Specific Dependencies

#### PowerPoint (.pptx)
```bash
# Node.js packages (global)
npm install -g pptxgenjs playwright sharp react-icons react react-dom

# Python packages
pip install markitdown defusedxml Pillow
```

#### Excel (.xlsx)
```bash
# Python packages
pip install openpyxl pandas defusedxml

# LibreOffice (for formula recalculation)
# macOS:
brew install libreoffice
# Linux:
sudo apt-get install libreoffice
```

#### Word (.docx)
```bash
# Node.js packages (for new documents)
npm install -g docx

# Python packages (for editing)
pip install defusedxml

# Optional: pandoc for text extraction
# macOS:
brew install pandoc
# Linux:
sudo apt-get install pandoc

# Optional: LibreOffice for PDF conversion
brew install libreoffice  # or apt-get install libreoffice
```

#### PDF
```bash
# Python packages
pip install pypdf pdfplumber reportlab pytesseract pdf2image

# Command-line tools
# macOS:
brew install poppler qpdf
# Linux:
sudo apt-get install poppler-utils qpdf

# Optional: OCR support
# macOS:
brew install tesseract
# Linux:
sudo apt-get install tesseract-ocr
```

## Templates

Professional templates for each format, all styled with the "Useful Apple Keynote" aesthetic (black backgrounds, blue accents, clean typography).

### PowerPoint (7 slide templates)
`workspace/pptx/templates/`:
- **slide-title.html** - Centered opening slides
- **slide-content.html** - Standard content with bullets
- **slide-code.html** - Code examples with green syntax highlighting
- **slide-comparison.html** - Before/After two-column layouts
- **slide-metrics.html** - Big gradient numbers (3-column grid)
- **slide-cards.html** - Feature cards in grid layout
- **slide-section.html** - Section dividers with large numbers

### Excel (3 Python templates)
`workspace/xlsx/templates/`:
- **dashboard-template.py** - Complete dashboard with metrics and charts
- **metrics-template.py** - Metrics tracking with trend analysis
- **comparison-template.py** - Before/after comparison tables

### Word (3 JavaScript templates)
`workspace/docx/templates/`:
- **technical-doc-template.js** - Technical docs with table of contents
- **proposal-template.js** - Feature proposals with executive summary
- **case-study-template.js** - Narrative case studies

### PDF (1 Python template)
`workspace/pdf/templates/`:
- **one-pager-template.py** - Executive one-page summaries

**Each format includes a `templates/README.md` with usage examples and style specifications.**

## File Organization

```
amplifier-stories/
├── docs/                     # Final deliverables (all formats)
│   ├── *.html                # HTML presentations
│   ├── *.pptx                # PowerPoint files (approved)
│   ├── *.xlsx                # Excel workbooks (approved)
│   ├── *.docx                # Word documents (approved)
│   └── *.pdf                 # PDF files (approved)
├── workspace/                # Working directory for all formats
│   ├── pptx/
│   │   ├── templates/        # 7 HTML slide templates (kept in git)
│   │   ├── html-slides/      # Working HTML (gitignored)
│   │   ├── assets/           # Generated images (gitignored)
│   │   ├── output/           # Final .pptx (kept in git)
│   │   └── thumbnails/       # Validation previews (gitignored)
│   ├── xlsx/
│   │   ├── templates/        # 3 Python templates (kept in git)
│   │   └── output/           # Final .xlsx (kept in git)
│   ├── docx/
│   │   ├── templates/        # 3 JavaScript templates (kept in git)
│   │   └── output/           # Final .docx (kept in git)
│   └── pdf/
│       ├── templates/        # 1 Python template (kept in git)
│       └── output/           # Final .pdf (kept in git)
├── context/                  # Style guides and instructions
├── agents/                   # Agent definitions
├── tools/                    # Development utilities
├── deploy.sh                 # Deployment script
└── .env.local                # Local config (gitignored)
```

## Deployment

### SharePoint Deployment (Optional)

Configure SharePoint path for automatic deployment:

```bash
# Copy example config
cp .env.local.example .env.local

# Edit .env.local and set your SharePoint folder path
# SHAREPOINT_DECKS_PATH=/Users/yourname/OneDrive - Company/Shared/Decks
```

Deploy files:
```bash
# Deploy all HTML files to SharePoint
./deploy.sh

# Deploy specific file
./deploy.sh my-presentation.html

# Export to local Downloads instead
./deploy.sh --local
```

## Development

### Creating New Content

Ask the storyteller agent naturally:
```
"Create a [format] about [topic]"
"Make a [format] showing [data/story]"
```

The agent will:
1. Research the topic (GitHub activity, commits, PRs)
2. Design the narrative arc
3. Create content in the requested format
4. Organize files in appropriate workspace
5. Present for approval before deployment

### Workflow by Format

**HTML:**
- Creates self-contained file with inline CSS/JS
- Saves directly to `docs/`
- Updates `docs/index.html`

**PowerPoint:**
- Reads html2pptx guide
- Creates HTML slides in `pptx-workspace/html-slides/`
- Generates assets in `pptx-workspace/assets/`
- Converts to .pptx in `pptx-workspace/output/`
- Validates with thumbnails

**Excel:**
- Creates workbook with openpyxl/pandas
- Uses formulas (not hardcoded values)
- Recalculates to verify zero errors
- Saves to `workspace/xlsx/output/`

**Word:**
- Uses docx-js for new documents
- Uses OOXML library for editing
- Supports tracked changes and comments
- Saves to `workspace/docx/output/`

**PDF:**
- Creates with reportlab or converts from other formats
- Extracts data with pdfplumber
- Merges/splits with pypdf
- Saves to `workspace/pdf/output/`

## Style Guidelines

### HTML Presentations
- Black backgrounds, clean typography
- One concept per slide
- Big impact numbers
- Code examples with syntax highlighting
- "Useful Apple Keynote" aesthetic

### PowerPoint
- Professional corporate style
- Can match existing templates (e.g., Surface-Presentation.pptx)
- Web-safe fonts only
- Accurate positioning via html2pptx

### Excel
- Financial modeling standards
- Color coding: Blue=inputs, Black=formulas, Green=cross-sheet, Red=external
- Zero formula errors (mandatory)
- Formatted zeros as "-"

### Word
- Clear hierarchy with headings
- Table of contents for long documents
- Tracked changes for reviews
- Professional formatting

### PDF
- Print-ready quality
- Consistent fonts and spacing
- Proper page breaks

## Troubleshooting

### Skills Not Loading
```bash
# Verify skills directory exists
ls ~/dev/anthropic-skills/skills

# Check settings.yaml configuration
grep -A3 "skills:" ~/.amplifier/settings.yaml

# Restart Amplifier session
exit
# Start new session
```

### Missing Dependencies

**Check Python packages:**
```bash
pip list | grep -E "openpyxl|pypdf|pdfplumber|reportlab|markitdown"
```

**Check Node.js packages:**
```bash
npm list -g | grep -E "pptxgenjs|playwright|sharp|docx"
```

**Install missing packages** using commands from Dependencies section above.

### Formula Errors in Excel
```bash
# Recalculate formulas
python ~/dev/anthropic-skills/skills/xlsx/recalc.py your-file.xlsx

# Check for errors
# Script will return JSON with error details
```

## Contributing

See `AGENTS.md` for agent configuration and `bundle.md` for bundle details.

## License

MIT - See repository for details.
