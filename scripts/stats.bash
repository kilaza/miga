#!/bin/bash
# Available variables: $PROJECT, $RUNTYPE, $MIGA, $CORES, $DATASET
set -e
SCRIPT="stats"
echo "MiGA: $MIGA"
echo "Project: $PROJECT"
# shellcheck source=scripts/miga.bash
source "$MIGA/scripts/miga.bash" || exit 1
DIR="$PROJECT/data/90.stats"
[[ -d "$DIR" ]] || mkdir -p "$DIR"
cd "$DIR"

# Initialize
miga date > "$DATASET.start"

# Calculate statistics
for i in raw_reads trimmed_fasta assembly cds essential_genes distances ; do
  echo "# $i"
  miga result_stats --compute-and-save -P "$PROJECT" -D "$DATASET" -r $i
done

# Finalize
miga date > "$DATASET.done"
miga add_result -P "$PROJECT" -D "$DATASET" -r "$SCRIPT" -f
