# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Project Is

A LaTeX project collecting olympiad geometry problems and their solutions, compiled into PDF documents. Problems are sourced from competitions like IMO, USAMO, USAJMO, Korea MO, Japan MO, and Indonesian competitions (OSN, LMNAS, OSP, KTOM, etc.). Solutions are written in Indonesian (Bahasa Indonesia).

## Building the PDFs

There are three main LaTeX entry points:

```bash
# Full document (problems + solutions)
pdflatex --shell-escape main.tex

# Problems only
pdflatex --shell-escape main-problems.tex

# Solutions only
pdflatex --shell-escape main-solutions.tex
```

The `--shell-escape` flag is required because `settings.tex` loads the `asymptote` package, which calls out to the `asy` binary to render geometric figures. Run `pdflatex` twice if the table of contents is out of date.

Auxiliary files (`.aux`, `.log`, `.out`, `.fls`, `.fdb_latexmk`, `.toc`, `.eps`, `main-*.asy`, `.pre`) are gitignored.

## Project Architecture

The document tree is:

```
main.tex / main-problems.tex / main-solutions.tex
  └── settings.tex          # \documentclass + \usepackage[wota]{azzam}
  └── problems.tex          # \subsection + \input for each Problems/ file
  └── solutions.tex         # \subsection + \input for each Solutions/ file
        └── Problems/N ...  # raw problem statement (plain math, no preamble)
        └── Solutions/N ... # proof environment; \inputs its problem + diagram
        └── Asymptote/N ... # Asymptote-based diagrams (used in older entries)
        └── Tikzlatex/N ... # TikZ/tkz-euclide diagrams (used in newer entries)
```

### Numbering convention

Every problem is assigned a sequential integer N. Files are named `N Description.tex` (e.g. `41 OSS Pradipta Dirgantara 2026.tex`). The same N is used across all four directories (Problems/, Solutions/, Asymptote/ or Tikzlatex/).

### Problem files (`Problems/`)

Contain only the raw problem statement — plain LaTeX math, no `\begin{document}` or preamble. Example:

```latex
Let $ABC$ be an acute triangle...
```

### Solution files (`Solutions/`)

Follow this structure:

```latex
\textbf{\textit{Soal. }}\input{Problems/N ...}

\begin{proof}[\textbf{Solusi.} (Date)]
...solution body using \dangle, \lemmarev, align*, etc...
\input{Tikzlatex/N ...}   % or \input{Asymptote/N ...}
\end{proof}
```

The `\dangle` macro (directed angle) and `lemmarev` environment come from the custom `azzam` package loaded in `settings.tex`.

### Diagram files

- **`Asymptote/`** — older diagrams using `\begin{asy}...\end{asy}` (requires `asymptote` package and the `asy` binary).
- **`Tikzlatex/`** — newer diagrams using `tikzpicture` with `tkz-euclide` macros (`\tkzDefPoint`, `\tkzDrawSegment`, etc.). Preferred for new entries.

Some problems have variant diagrams marked with `(2)` or `(1)` in the filename.

### Aggregator files (`problems.tex`, `solutions.tex`)

Each entry is a `\subsection{Display Name}` followed by `\input{Problems/N ...}` or `\input{Solutions/N ...}`. When adding a new problem, append to **both** aggregator files.

## Adding a New Problem

1. Create `Problems/N Name.tex` with the problem statement.
2. Create a diagram in `Tikzlatex/N Name.tex` (TikZ preferred).
3. Create `Solutions/N Name.tex` referencing both.
4. Append a `\subsection` + `\input` entry to `problems.tex`.
5. Append a matching entry to `solutions.tex`.
