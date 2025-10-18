# Unstandardized Accounting Terminology

**Supplementary Materials Website**

[![Website](https://img.shields.io/badge/Website-Live-blue)](https://matthiasuckert.github.io/UnstandardizedAccountingTerminology/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This repository contains the supplementary website for the paper "Unstandardized Accounting Terminology" (under revision at the *Journal of Accounting and Economics*).

## Authors

- **Holger Daske** - University of Mannheim
- **Carol Seregni** - The Wharton School, University of Pennsylvania
- **Matthias Uckert** - University of Amsterdam

## Abstract

The communication of accounting information requires a domain-specific vocabulary, and in specialized languages, standardization is considered a key to clear communication, i.e., one term should only be assigned to one concept and vice versa. In practice, accounting terminology is unstandardized and produces undue complexity. We provide the first large-sample evidence on the level and the implications of unstandardized accounting terminology for a global corpus of annual reports. Our study shows that unstandardized accounting terminology is widespread and increases human and computerized information processing costs, i.e., has economic consequences.

## Website Contents

Visit the live website at: **[matthiasuckert.github.io/UnstandardizedAccountingTerminology](https://matthiasuckert.github.io/UnstandardizedAccountingTerminology/)**

The website provides:

### 📚 **Dictionaries**
- **Term Lists**: Complete sets of unique accounting terms found in financial reports
  - Top-Down (from standards: IFRS, US GAAP, UK GAAP)
  - Bottom-Up from 10-K filings (~50,000 U.S. filings)
  - Bottom-Up from 20-F filings (IFRS taxonomy)
  
- **Concept Lists**: Granular mappings showing which terms are used as synonyms for the same accounting concepts
  
- **Interactive t-SNE Visualizations**: Explore semantic structure of accounting concepts through interactive embeddings

### 🔍 **Robustness Checks**
Comprehensive robustness analyses and validation tests

### 📥 **Data & Code**
- Downloadable dictionaries (Excel format)
- Replication materials
- Documentation

## Features

✨ **Interactive Widgets**: Filter and explore t-SNE visualizations by dictionary type, embedding model, and concept ID

📊 **Searchable Tables**: All term and concept lists are presented in interactive, searchable tables

📱 **Responsive Design**: Fully functional on desktop, tablet, and mobile devices

## Repository Structure

```
.
├── _quarto.yml              # Quarto configuration
├── index.qmd                # Home page with abstract
├── Dictionaries.qmd         # Dictionary tables and visualizations
├── robustness.qmd           # Robustness checks
├── data.qmd                 # Data and code downloads
├── styles.css               # Custom styling
├── R/                       # R functions
│   ├── 02-TableFunctions.R
│   └── 04-CreateTsneWidget.R
├── data/                    # Data files
│   ├── Termlists/
│   ├── Conceptlists/
│   └── tsne_plots_metadata.parquet
├── images/                  # t-SNE plots
│   └── tsne/
├── downloads/               # Downloadable files
└── docs/                    # Rendered website (auto-generated)
```

## For Developers

### Prerequisites

- [Quarto](https://quarto.org/docs/get-started/) (v1.3+)
- R (v4.0+) with packages:
  - `arrow`
  - `dplyr`
  - `DT`
  - `htmltools`
  - `jsonlite`

### Local Development

1. **Clone the repository**
   ```bash
   git clone https://github.com/MatthiasUckert/UnstandardizedAccountingTerminology.git
   cd UnstandardizedAccountingTerminology
   ```

2. **Preview locally**
   ```bash
   quarto preview
   ```
   This opens a live preview at `http://localhost:4200` that updates as you edit.

3. **Render the website**
   ```bash
   quarto render
   ```
   This generates the static site in the `docs/` folder.

4. **Publish to GitHub Pages**
   ```bash
   git add .
   git commit -m "Update website"
   git push
   ```
   
   The site will automatically deploy to GitHub Pages (configured to serve from `main` branch, `/docs` folder).

### Key Configuration

- **Theme**: Cosmo (can be changed in `_quarto.yml`)
- **Output**: `docs/` folder (for GitHub Pages compatibility)
- **Resources**: The `images/` folder is included as a resource to ensure plots are accessible

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Status

**Current Status**: Under revision (Second Round) at the *Journal of Accounting and Economics*

---

*This website was built with [Quarto](https://quarto.org/)*