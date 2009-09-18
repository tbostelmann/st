#!/usr/bin/perl

open(IMAGES, "find ./public/system/photos/ -type f | grep -v '_large.' | grep -v '_medium.' | grep -v '_thumb.' | grep -v '_mini' | grep -v '_small' |");

while (<IMAGES>) {
  chomp;
  $file = $_;
  /^(.*)(\..+)$/;
  $file = $1 . "_medium" . $2;
  $file2 = $1 . "_small" . $2;
  `cp $file $file2`;
  `mogrify -adaptive-resize 210x210 $file2`;
  $file3 = $1 . "_mini" . $2;
  `cp $file $file3`;
  `mogrify -adaptive-resize 155x155 $file3`;
}
