#!/bin/bash
clear
echo 欢迎使用王江奎软件系统
status=0
times=0     #错误次数
while [ 1 ]
do
    case $status in
        0)
            if (( $times < 3 ))
            then
                read -p "请输入密码：" -s line
                echo ""
                if [ -f password ]
                then
                    pwd=$(cat password)
                else
                    pwd=123456
                    echo $pwd > password
                fi
                if [ $line = $pwd ] 
                then
                    echo 密码输入正确
                    clear
                    echo 您已经成功登录
                    echo 输入help可获取更多信息
                    status=1
                else
                    echo 密码输入错误
                    times=$[$times + 1]
                    echo 您还有"$[3 - $times]"次机会
                    continue
                fi
            else
                echo 您的密码错误次数超过限制，请您稍后再尝试
                status=7
            fi;;
        1)
            read -p "请输入命令：" cmd software
            case $cmd in
                help)
                    status=2;;
                list)
                    status=3;;
                run)
                    status=4;;
                password)
                    status=5;;
                clear)
                    status=6;;
                quit)
                    status=7;;
                *)
                    ;;
            esac;;
        2)
            echo "命令列表       功能说明"
            echo "help           系统说明手册"
            echo "list           用户软件列表"
            echo "run software   运行软件software"
            echo "password       修改密码"
            echo "clear          清理屏幕"
            echo "quit           退出程序"
            status=1;;
        3)
            echo 您的软件列表为：
            if [ -f softwareList ]
            then
                while read line address
                do
                    echo ${line}
                    test=1
                done < softwareList
                if [ -z $test ]
                then
                    echo 空
                fi
            else
                echo 软件列表不存在，将自动创建
                touch softwareList
            fi
            status=1;;
        4)
            if [ -z software ]
            then
                echo 命令格式错误
            else
                flag=0
                while read title address
                do
                    if [ $title = $software ]
                    then
                        echo 开始运行"${software}"
                        echo $address
                        bash $address
                        flag=1
                        break
                    fi
                done < softwareList
                if (($flag == 0))
                then
                    echo 软件不存在
                fi
            fi
            status=1;;
        5)
            echo -n 请输入新密码：
            read -s newpwd
            echo ""
            echo -n 请输入确认密码：
            read -s repwd
            if [ $newpwd = $repwd ]
            then
                echo ""
                echo $newpwd > password
                status=0
            else
                echo ""
                echo "两次密码输入不一致，修改密码失败"
                status=1
            fi;;
        6)
            clear
            status=1;;
        7)
            echo 感谢您的使用，期待与您下次再见
            break;;
        esac
done
