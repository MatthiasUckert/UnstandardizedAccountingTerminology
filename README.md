# Unstandardized Accounting Terminology - Supplementary Materials

This repository contains the supplementary website for the paper "Unstandardized Accounting Terminology" submitted to the Journal of Accounting and Economics (JAE).

## Repository Structure
```
.
├── _quarto.yml              # Main Quarto configuration
├── index.qmd                # Home page with abstract
├── additional-tables.qmd    # Additional analyses
├── robustness.qmd           # Robustness checks
├── data.qmd                 # Data and code downloads
├── styles.css               # Custom CSS styling
├── data/                    # Data files (create this folder)
│   └── *.csv               # Your CSV files
├── scripts/                 # R scripts (create this folder)
│   └── *.R                 # Your R scripts
└── docs/                    # Rendered website (auto-generated)
```

## Setup Instructions

### 1. Clone the Repository
```bash
git clone https://github.com/YourUsername/UnstandardizedAccountingTerminology.git
cd UnstandardizedAccountingTerminology
```

### 2. Install Quarto

If you haven't already, install Quarto from [quarto.org](https://quarto.org/docs/get-started/)

### 3. Create Necessary Folders
```bash
mkdir data
mkdir scripts
```

### 4. Add Your Content

- Add your data files to the `/data` folder
- Add your R scripts to the `/scripts` folder
- Edit the `.qmd` files to add your analyses

### 5. Preview Locally
```bash
quarto preview
```

This will open a browser with a live preview that updates as you edit files.

### 6. Render the Website
```bash
quarto render
```

This creates the static site in the `/docs` folder.

### 7. Publish to GitHub Pages

First time setup:
1. Go to your GitHub repository settings
2. Navigate to Pages
3. Set Source to "Deploy from a branch"
4. Choose `main` branch and `/docs` folder
5. Save

Then, to publish:
```bash
git add .
git commit -m "Update website"
git push
```

Your site will be live at: `https://yourusername.github.io/UnstandardizedAccountingTerminology/`

## Editing Content

- **Home page:** Edit `index.qmd`
- **Add tables:** Edit `additional-tables.qmd` and add your R code chunks
- **Add robustness:** Edit `robustness.qmd`
- **Update downloads:** Edit `data.qmd` and add files to `/data` folder
- **Change theme:** Edit the `theme:` line in `_quarto.yml`

## Available Themes

You can easily change the theme in `_quarto.yml`. Options include:
- `cosmo` (current - modern, clean)
- `flatly` (minimal, professional)  
- `sandstone` (warm, friendly)
- `yeti` (clean, spacious)
- `lumen` (bright, modern)

See all themes: [Quarto Themes](https://quarto.org/docs/output-formats/html-themes.html)

## Tips

- Code is hidden by default but users can expand it (using `code-fold: true`)
- The table of contents appears on the right side of each page
- All pages are responsive and work on mobile
- External links open in new tabs automatically

## Questions?

For questions about Quarto, see the [Quarto documentation](https://quarto.org/docs/guide/).
```

---

## **8. .gitignore (Updated)**

Replace your existing `.gitignore` with this updated version:
```
# History files
.Rhistory
.Rapp.history

# Session Data files
.RData
.RDataTmp

# User-specific files
.Ruserdata

# Example code in package build process
*-Ex.R

# Output files from R CMD build
/*.tar.gz

# Output files from R CMD check
/*.Rcheck/

# RStudio files
.Rproj.user/

# produced vignettes
vignettes/*.html
vignettes/*.pdf

# OAuth2 token, see https://github.com/hadley/httr/releases/tag/v0.3
.httr-oauth

# knitr and R markdown default cache directories
*_cache/
/cache/

# Temporary files created by R markdown
*.utf8.md
*.knit.md

# R Environment Variables
.Renviron

# pkgdown site
docs/

# translation temp files
po/*~

# RStudio Connect folder
rsconnect/

# Quarto specific
/.quarto/
/_site/
_freeze/