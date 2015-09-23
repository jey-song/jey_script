
#!/bin/sh
message=`git log --pretty=format:"%s" -1`
git_remote_pre="refs/remotes/origin/"
branch=`git for-each-ref --format='%(objectname) %(refname)' $git_remote_pre | awk "/^$(git rev-parse HEAD)/ {print \$2}" | awk '{print $2}'`

pre_release="[DEPLOY]"
pre_len=${#pre_release}
#echo "====git message:====$message=======${branch:${#git_remote_pre}}======="

if [ ${#message} -ge $pre_len ] && [ "${message:0:$pre_len}" == "$pre_release" ];
then
  source /home/deploy/libs/bashrc
  r_m=${message:$pre_len}
  
  to_ser=''
  if [ ${#r_m} -ge 1 ] && [ "${r_m:0:1}" == "[" ];
  then
    r_m=${r_m:1}
    to_ser=${r_m%%]*}
  fi

  all=("admin_services" "all_services" "api_web")
  for ser in ${all[@]}  
  do
    if [ ${#to_ser} -eq 0 ] || [ "${to_ser}" == ${ser} ];
    then
      cap dev1 deploy group=${ser} pro=${ser}_0 branch=${branch:${#git_remote_pre}}
    fi
  done
  exit 0
fi

exit 0