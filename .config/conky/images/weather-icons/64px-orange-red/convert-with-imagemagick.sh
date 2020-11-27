for filename in *.png; do file=`echo "$filename"`;convert $filename -fuzz 100% -fill '#FE4515' -opaque white $file;done
