# /bin/zsh
# 适用于mac

# 在线host地址
hostsFile="http://googlehosts-hostsfiles.stor.sinaapp.com/hosts"

# 为zsh设置hosts命令更新,并更新一次
echo "alias hosts='wget $hostsFile && sudo mv hosts /etc/hosts'" >> ~/.zshrc
source ~/.zshrc > /dev/null
hosts > /dev/null


# 添加定时更新
countOri=$(sudo crontab -l > /dev/null | wc -l)
# 新增任务
crontabCMD="* * */1 * * wget $hostsFile && mv hosts /etc/hosts"
# 使用双引号表达原字符串
#echo "$crontabCMD"
if [ $countOri -eq 0 ];then
    echo "$crontabCMD" | sudo crontab
else
    (sudo crontab -l;echo "$crontabCMD") | sudo crontab
fi

countNow=$(sudo crontab -l | wc -l)
if [ $countNow -le $countOri ];then
    echo "Fail to add hostsAutoUpdate crontab"
    exit 1
else
    echo "hostsAutoUpdate set success!"
    sudo crontab -l
fi
