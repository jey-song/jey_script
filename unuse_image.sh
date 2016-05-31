#!/bin/bash 
#Jey
#2014.04.17

# 项目要执行搜索的根目录
base_path="../xllive"
# 存放图片未使用的文件夹转移到位置
moveto_path="${base_path}/resources_unuse"
# 要检索的图片文件夹
source_path="${base_path}/xllive/Assets.xcassets"
path="${base_path}/xllive"


# 未使用图片写入文件
writeto_unuse_file="${moveto_path}/unuse-file.txt"
# 使用图片写入文件
writeto_use_file="${moveto_path}/use-file.txt"

if [[ -f "$writeto_unuse_file" ]]; then
  echo "删除旧的文件: ${writeto_unuse_file}"
  rm $writeto_unuse_file
fi

if [[ -f "$writeto_use_file" ]]; then
  echo "删除旧的文件: ${writeto_use_file}"
  rm $writeto_use_file
fi

if [[ ! -x "$moveto_path" ]]; then
  mkdir -p $moveto_path
  # svn add $moveto_path --parents --depth=infinity
else
  echo "移动前文件个数:"
  echo `ls -lR ${moveto_path}| grep "^-" | wc -l`
fi

function find_image() {
	name=$1
	ext=$2
	fdir=$3

  endnum=${name##*[[:alpha:]]}
  temp=${name:0:$((${#name}-${#endnum}))}

	array=($(find ${path} -regex '.*.[{plist}|{xib}|{m}|{mm}]$' -type f|xargs grep -ri $temp -l))
  # printf "%s\n\t%s\x00\n" "$name" "${array[@]}"
  if [[ ${#array[@]} == 0 ]]; then
    # echo $name
    file=$fdir/$name$ext
    echo $file>>${writeto_unuse_file}
    echo "删除的文件名字$file"
    
    mv $file $moveto_path
    # if [[ $name == *@* ]]; then
    #   svn rm $file/@
    # else
    #   svn rm $file
    # fi
  else
    # echo $name>>./use-file.txt
    printf "%s 存在文件:\n\t%s\x00\n" "$name" "${array[@]}">>${writeto_use_file}
  fi
}

function del_image() {
  for name in `ls -R ${source_path}`
  do
    if [[ $name == *: ]]; then
      path="${name//:/}"
    elif [[ $name == *.png ]]; then
      f="${name//.png/}"
      f="${f//@2x/}"
      f="${f//@2X/}"
    	# echo "find ${base_path} -regex '.*.[{plist}|{xib}|{m}]$' -type f|xargs grep -ri ${f} -l"
    	find_image $f ".png" $path
    fi
  done
}

function del_xcassets() {
	for name in `find ${source_path} -type d`
  do
  	b_path=`dirname ${name}`
  	b_name=`basename ${name}`
  	#echo ${b_name:(-9)}
  	ext=".imageset"
  	if [[ ${b_name:(-9)} == $ext ]]; then
  		find_image "${b_name%$ext}" $ext $b_path
  	fi
  done
}

if [[ ${source_path:(-9)} == ".xcassets" ]]; then
	del_xcassets
else
	del_image
fi

echo "移动后文件个数:"
echo `ls -lR ${moveto_path}| grep "^-" | wc -l`