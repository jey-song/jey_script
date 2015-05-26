#!/bin/bash 
#Jey
#2014.04.17

# 项目根目录
base_path=`dirname ${PWD}`
# 要执行搜索的根目录
work_path="${base_path}/Starling"
# 存放图片未使用的文件夹转移到位置
moveto_path="${base_path}/resources_unuse"
# 要检索的图片文件夹
source_path="${base_path}/Starling/Images"
path=${source_path}


# 未使用图片写入文件
writeto_unuse_file="./unuse-file.txt"
# 使用图片写入文件
writeto_use_file="./use-file.txt"

if [[ -f "$writeto_unuse_file" ]]; then
	echo "删除旧的文件: ${writeto_unuse_file}"
	rm $writeto_unuse_file
fi

if [[ -f "$writeto_use_file" ]]; then
	echo "删除旧的文件: ${writeto_use_file}"
	rm $writeto_use_file
fi

if [[ ! -x "$moveto_path" ]]; then
	mkdir -p $moveto_pat
	# svn add $moveto_path --parents --depth=infinity
else
	echo "移动前文件个数:"
	echo `ls -lR ${moveto_path}| grep "^-" | wc -l`
fi


oldname=''
for name in `ls -R ${source_path}`
do
  if [[ $name == *: ]]; then
  	path="${name//:/}"
  elif [[ $name == *.png ]]; then
  	f="${name//.png/}"
  	f="${f//@[2,3][x,X]/}"
  	f="${f/[0-9]*/}"
  	if [[ $f == $oldname ]]; then
  		#echo "ignore and continue"
  		continue
  	fi
	oldname=$f
	#echo "find ${work_path} -regex '.*.[{plist}|{xib}|{m}]$' -type f|xargs grep -ri ${f} -l"
	#continue

	array=($(find ${work_path} -regex '.*.[{h}{plist}|{xib}|{m}]$' -type f|xargs grep -ri ${f} -l))
	# printf "%s\n\t%s\x00\n" "$name" "${array[@]}"
	if [[ ${#array[@]} == 0 ]]; then
		# echo $name
		file=$path/$name
		echo $file>>${writeto_unuse_file}
		echo "删除的文件名字$file"
		
		mv $file $moveto_path
		#if [[ $name == *@* ]]; then
		#	svn rm $file/@
		#else
		#	svn rm $file
		#fi
	else
		# echo $name>>./use-file.txt
		printf "%s 存在文件:\n\t%s\x00\n" "$name" "${array[@]}">>${writeto_use_file}
	fi
  fi
done

echo "移动后文件个数:"
echo `ls -lR ${moveto_path}| grep "^-" | wc -l`