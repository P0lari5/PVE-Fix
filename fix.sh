#!/bin/sh

echo 
echo 
echo 1.去除登录时订阅提示
echo 2.修复Updare无法更新问题
echo 3.添加cpu温度显示
echo
echo
read -p "请选择:" M
echo 

echo
#选择
if [ "$M" = "1" ]
then
cd /usr/share/javascript/proxmox-widget-toolkit
echo 备份proxmoxlib.js
cp  proxmoxlib.js proxmoxlib.js.backup
echo 修改proxmoxlib.js
sed -i.bak "s/data.status !== 'Active'/false/g"  /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
echo 重启服务
systemctl restart pveproxy.service
echo 修改完毕

elif [ "$M" = "2" ]
then
#脚本提示
echo 正在修复Proxmox VE更新问题
#移动到脚本目录
cd /etc/apt
#备份文件
echo 正在备份文件
cp sources.list sources.backup.list
#删除文件
echo 正在备份文件
rm -rf sources.list

#下载修复文件
echo 正在下载新文件
wget -q --no-check-certificate https://raw.githubusercontent.com/pkpkgtr1/PVE-Fix/master/update/sources.list
#设置权限
chmod -R 0755 sources.list

#延迟运行
ping 127.0.0.1 -c 2 > /dev/null
#空行
echo

#移动到脚本目录
cd /etc/apt/sources.list.d
#备份文件
rm -rf pve-enterprise.list
#下载修复文件
wget -q --no-check-certificate https://raw.githubusercontent.com/pkpkgtr1/PVE-Fix/master/update/pve-enterprise.list
#设置权限
chmod -R 0755 pve-enterprise.list
#延迟运行
ping 127.0.0.1 -c 2 > /dev/null
#空行
echo 已修复完成升级一下试试吧

elif [ "$M" = "3" ]
then

#pve添加cpu温度显示
#----------------------------------------------------------------------------------
apt-get install lm-sensors
#判断Api接口是否存在
grep -q "thermalstate" /usr/share/perl5/PVE/API2/Nodes.pm
if [ $? -eq 0 ]; then

    echo Api已存在无需更新 

else
    sed -i.bak '/res->{ksm} = /i\        $res->{thermalstate} = `sensors`;' /usr/share/perl5/PVE/API2/Nodes.pm
    echo 文件已更新
fi
#判断JS文件是否存在
#!/bin/sh
cpucores=`cat /proc/cpuinfo | grep "cpu cores" | uniq | awk -F: '{print $2}'|awk '{print int($0)}'`
if [ "$cpucores" = 1 ]
then 
grep -q "CPU Thermal State" /usr/share/pve-manager/js/pvemanagerlib.js
if [ $? -eq 0 ]; then
    echo CPU为单核
    echo CPU温度代码已存在无需更新 
else
    rm -rf CPU_Thermal_State
    ping 127.0.0.1 -c 1 > /dev/null
    wget -q --no-check-certificate https://raw.githubusercontent.com/pkpkgtr1/PVE-Fix/master/update/CPU_Thermal_State
    chmod -R 0755 CPU_Thermal_State
    sed -i -e '/pveversion/{n;d}' /usr/share/pve-manager/js/pvemanagerlib.js
    ping 127.0.0.1 -c 1 > /dev/null
    sed -i -e '/pveversion/{n;d}' /usr/share/pve-manager/js/pvemanagerlib.js
    ping 127.0.0.1 -c 1 > /dev/null
    sed -i.bak '/pveversion/r CPU_Thermal_State' /usr/share/pve-manager/js/pvemanagerlib.js
    echo cpu单核文件已更新   
    echo 正在重启完毕
    systemctl restart pveproxy
fi
elif [ "$cpucores" = 2 ]
then 
#双核cpu写入代码判断
grep -q "CPU Thermal State" /usr/share/pve-manager/js/pvemanagerlib.js
if [ $? -eq 0 ]; then
    echo CPU为双核
    echo CPU温度代码已存在无需更新 
else
    rm -rf CPU_Thermal_State
    ping 127.0.0.1 -c 1 > /dev/null
    wget -q --no-check-certificate https://raw.githubusercontent.com/pkpkgtr1/PVE-Fix/master/update/CPU_Thermal_State2
    chmod -R 0755 CPU_Thermal_State
    sed -i -e '/pveversion/{n;d}' /usr/share/pve-manager/js/pvemanagerlib.js
    ping 127.0.0.1 -c 1 > /dev/null
    sed -i -e '/pveversion/{n;d}' /usr/share/pve-manager/js/pvemanagerlib.js
    ping 127.0.0.1 -c 1 > /dev/null
    sed -i.bak '/pveversion/r CPU_Thermal_State2' /usr/share/pve-manager/js/pvemanagerlib.js
    echo cpu双核文件已更新   
    echo 正在重启完毕
    systemctl restart pveproxy
fi
elif [ "$cpucores" = 4 ]
then 
grep -q "CPU Thermal State" /usr/share/pve-manager/js/pvemanagerlib.js
if [ $? -eq 0 ]; then
    echo CPU为四核
    echo CPU温度代码已存在无需更新 
else
    rm -rf CPU_Thermal_State
    ping 127.0.0.1 -c 1 > /dev/null
    wget -q --no-check-certificate https://raw.githubusercontent.com/pkpkgtr1/PVE-Fix/master/update/CPU_Thermal_State4
    chmod -R 0755 CPU_Thermal_State
    sed -i -e '/pveversion/{n;d}' /usr/share/pve-manager/js/pvemanagerlib.js
    ping 127.0.0.1 -c 1 > /dev/null
    sed -i -e '/pveversion/{n;d}' /usr/share/pve-manager/js/pvemanagerlib.js
    ping 127.0.0.1 -c 1 > /dev/null
    sed -i.bak '/pveversion/r CPU_Thermal_State4' /usr/share/pve-manager/js/pvemanagerlib.js
    echo cpu四核文件已更新   
    echo 正在重启完毕
    systemctl restart pveproxy
fi
else
echo 您的cpu不在支持范围请联系作者
fi








#-----------------------------------------------------------------------------------

else
echo 请输入正确的序号
fi