#!/usr/bin/env perl
# file          .latexmkrc
# author        Ryotaro Onuki
# created_at    2019.01.25
# modified_at   2019.02.05

## latex commands
$latex            = 'platex -synctex=1 -halt-on-error';
$latex_silent     = 'platex -synctex=1 -halt-on-error -interaction=batchmode';
$bibtex           = 'pbibtex -kanji=utf8';
$dvipdf           = 'dvipdfmx %O -o %D %S';
$makeindex        = 'mendex %O -o %D %S';
$max_repeat       = 5;

## pdf mode
$pdf_mode         = 3; # 0: none, 1: pdflatex, 2: ps2pdf, 3: dvipdfmx

## viewer settings
$pvc_view_file_via_temporary = 0;
if ($^O eq 'darwin') {
    # OSX
    $pdf_previewer = 'open -a Preview';
} elsif ($^O eq 'linux') {
    # linux
    $pdf_previewer = 'evince';
} else {
    # Windows
    $pdf_previewer    = '"C:\Program Files\SumatraPDF\SumatraPDF.exe" -reuse-instance %O %S';
}

## output directory
$aux_dir          = "build/";
$out_dir          = "build/";
