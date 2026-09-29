#!/usr/bin/env bash
# Fast preview: compile only one problem/solution entry into test-newest.pdf.
#
# Usage:
#   bash-scripts/test-newest.sh [--open] [ENTRY]
#
#   ENTRY: the entry to preview, as a leading number ("42") or part of a
#          filename ("Serbia"). Matching is case-insensitive. A substring
#          matching several entries fails with a listing; an unknown number
#          or a substring matching nothing fails with a clear error.
#          With no ENTRY, previews the entry with the highest leading number
#          across Problems/ and Solutions/, so a newly added entry is picked
#          up with no edits to this script.
#   --open: open test-newest.pdf after building (Skim when available, else
#           the system default viewer).
#
# Examples:
#   bash-scripts/test-newest.sh
#   bash-scripts/test-newest.sh 35
#   bash-scripts/test-newest.sh Serbia
#   bash-scripts/test-newest.sh --open 42
#
# How it works: ENTRY resolves to one number N, and a wrapper test-newest.tex
# is generated at the repo root and compiled with compile-one.sh (the full
# pdflatex / asy / pdflatex / pdflatex round trip, but for one entry only,
# so it takes seconds). The wrapper \inputs the solution file only: every
# solution file starts with \input{Problems/...}, so the problem statement
# is printed exactly once. When no solution file exists yet for N, the
# problem file alone is previewed.
#
# test-newest.tex and test-newest.pdf are gitignored build output: preview,
# check the PDF, then keep working on the real entry. Never commit them.

set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMPILE_ONE="$ROOT/bash-scripts/compile-one.sh"
WRAPPER="$ROOT/test-newest.tex"
PDF="$ROOT/test-newest.pdf"
PROBLEMS_DIR="$ROOT/Problems"
SOLUTIONS_DIR="$ROOT/Solutions"

OPEN=0
args=()
while [ "$#" -gt 0 ]; do
  case "$1" in
    --open)    OPEN=1; shift ;;
    -h|--help) sed -n '2,32p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
    -*)        echo "Unknown option '$1' (see bash-scripts/test-newest.sh --help)"; exit 1 ;;
    *)         args+=("$1"); shift ;;
  esac
done

if [ "${#args[@]}" -gt 1 ]; then
  echo "Usage: bash-scripts/test-newest.sh [--open] [ENTRY]"
  exit 1
fi

# Leading number of a "N Description.tex" basename: the digits before the
# first space. Prints nothing when the name does not follow the convention.
leading_number() {
  case "$1" in
    [0-9]*' '*) echo "${1%% *}" ;;
    *)          echo "" ;;
  esac
}

# Every entry number across Problems/ and Solutions/, deduplicated.
all_numbers() {
  local f n seen=""
  for f in "$PROBLEMS_DIR"/*.tex "$SOLUTIONS_DIR"/*.tex; do
    [ -e "$f" ] || continue
    n="$(leading_number "$(basename "$f")")"
    [ -z "$n" ] && continue
    case " $seen " in
      *" $n "*) ;;
      *) seen="$seen $n" ;;
    esac
  done
  # shellcheck disable=SC2086
  printf '%s\n' $seen | sort -n -u
}

# Basename (without directory) of the problem or solution file for number N,
# or nothing when there is none.
file_for_number() {
  local dir="$1" n="$2" f
  for f in "$dir/$n "*.tex; do
    [ -e "$f" ] || continue
    basename "$f"
    return 0
  done
  return 1
}

# One-line summary of an entry for the ambiguous-match listing.
describe_entry() {
  local n="$1" prob sol line="$1:"
  prob="$(file_for_number "$PROBLEMS_DIR" "$n")" || prob=""
  sol="$(file_for_number "$SOLUTIONS_DIR" "$n")" || sol=""
  [ -n "$prob" ] && line="$line Problems/$prob"
  [ -n "$sol" ] && line="$line Solutions/$sol"
  echo "$line"
}

N=""
if [ "${#args[@]}" -eq 0 ]; then
  N="$(all_numbers | tail -n 1)"
  if [ -z "$N" ]; then
    echo "No numbered entries found in Problems/ or Solutions/" >&2
    exit 1
  fi
elif [[ "${args[0]}" =~ ^[0-9]+$ ]]; then
  want="$((10#${args[0]}))"
  if all_numbers | grep -qx "$want"; then
    N="$want"
  else
    echo "No entry numbered '${args[0]}' in Problems/ or Solutions/" >&2
    exit 1
  fi
else
  matches="$(all_numbers | while read -r n; do
    prob="$(file_for_number "$PROBLEMS_DIR" "$n")" || prob=""
    sol="$(file_for_number "$SOLUTIONS_DIR" "$n")" || sol=""
    if printf '%s %s' "$prob" "$sol" | grep -qiF "${args[0]}"; then
      echo "$n"
    fi
  done)"
  if [ -z "$matches" ]; then
    echo "No entry matching '${args[0]}' in Problems/ or Solutions/" >&2
    exit 1
  elif [ "$(printf '%s\n' "$matches" | wc -l)" -gt 1 ]; then
    {
      echo "Multiple entries match '${args[0]}':"
      printf '%s\n' "$matches" | while read -r n; do
        echo "  $(describe_entry "$n")"
      done
      echo "Pass a leading number or more of the name to disambiguate."
    } >&2
    exit 1
  fi
  N="$matches"
fi

prob_file="$(file_for_number "$PROBLEMS_DIR" "$N")" || prob_file=""
sol_file="$(file_for_number "$SOLUTIONS_DIR" "$N")" || sol_file=""

if [ -z "$prob_file" ] && [ -z "$sol_file" ]; then
  echo "No entry numbered '$N' in Problems/ or Solutions/" >&2
  exit 1
fi

# The solution file already \inputs its problem statement, so inputting it
# alone prints the problem exactly once. Fall back to the problem file when
# no solution exists yet.
if [ -n "$sol_file" ]; then
  body="\\input{Solutions/$sol_file}"
  desc="${sol_file#$N }"
  echo "Previewing entry $N (solution): Solutions/$sol_file"
else
  body="\\input{Problems/$prob_file}"
  desc="${prob_file#$N }"
  echo "Previewing entry $N (no solution yet, problem only): Problems/$prob_file"
fi
desc="${desc%.tex}"

cat > "$WRAPPER" <<EOF
\\input{settings}

\\title{[Preview] $desc}
\\date{\\today}

\\begin{document}

\\maketitle

\\subsection{$desc}
$body

\\end{document}
EOF
echo "Wrapper: test-newest.tex"

bash "$COMPILE_ONE" test-newest || exit 1

if [ "$OPEN" -eq 1 ]; then
  if [ -d /Applications/Skim.app ]; then
    open -a Skim "$PDF"
  else
    open "$PDF"
  fi
fi
