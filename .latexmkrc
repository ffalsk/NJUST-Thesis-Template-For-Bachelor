# Keep all LaTeX build products in build/.
# LaTeX Workshop opens build/myThesis.pdf, so SyncTeX reverse search can find
# build/myThesis.synctex.gz beside it.
$out_dir = 'build';
$aux_dir = 'build';

# XeLaTeX is required by ctex/fontspec/xeCJK.
$pdf_mode = 5;
$xelatex = 'xelatex -synctex=1 -interaction=nonstopmode -file-line-error %O %S';

# Also copy the final PDF to the project root for convenient sharing.
# The root PDF is only a copy; use build/myThesis.pdf for reverse search.
$success_cmd = 'perl -MFile::Copy=copy -e "copy(q{build/myThesis.pdf}, q{myThesis.pdf}) or die qq{copy failed: $!}"';
