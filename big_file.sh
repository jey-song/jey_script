#/bin/bash
if [ $# -gt 2 ];then
  path=$1
  ext=$2
  size=$3
  echo "find path:  ($path)  \n"
else
  echo "useage: ./big-image.sh path png 50"
  echo "path:查找的文件夹目录 png:要查找的后缀 50:文件大于50k"
  exit 1
fi

for file in `find $path -regex ".*.${ext}$" -size +${size}k`
do
  echo $file
  dir="`dirname ./big${file:${#path}}`"
  test -d "$dir" || mkdir -p "$dir" && cp $file "$dir"
done