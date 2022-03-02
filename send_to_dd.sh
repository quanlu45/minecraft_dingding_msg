#!/bin/bash
# author: quan
# description: this script is used to send minecraft player action to dingding

WEB_HOOK='https://oapi.dingtalk.com/robot/send?access_token=xxxxxx'
MINECRAFT_PATH=/root/minecraft
LOG_NAME=nohup.out

endline=$(wc -l $MINECRAFT_PATH/$LOG_NAME | awk '{print $1}')

function send() {
    curl $WEB_HOOK -H 'Content-Type: application/json' -d "
    {
        'msgtype': 'text',
        'text': {
            'content': '玩家: $p\n动作: $a\n时间: $t'
        }
    }"
}

if [ ! -f ''$MINECRAFT_PATH'/line.txt' ]; then 
   n=$endline
else 
   n=$(cat $MINECRAFT_PATH/line.txt)
fi

while [ $n -le $endline ]; do
	t=$(awk 'NR=='$n' {print $2}' $MINECRAFT_PATH/$LOG_NAME)
	p=$(awk 'NR=='$n' {print substr($6, 1,length($6)-1)}' $MINECRAFT_PATH/$LOG_NAME)
	a=$(awk 'NR=='$n' {print substr($5, 1,length($5)-1)}' $MINECRAFT_PATH/$LOG_NAME)	
	if [[ "$a" == *connect* ]]; then
	   if [[ "$a" == dis* ]]; then
	   		a='下线'
	   else a='上线'
	   fi
	   send
	fi
	let n+=1
done

let endline+=1
echo $endline > $MINECRAFT_PATH/line.txt