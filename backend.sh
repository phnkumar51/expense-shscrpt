echo -e "\e[31m disable previous version of nodejs\e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y

echo -e "\e[31m install the latest version of nodejs\e[0m"
dnf install nodejs -y

echo -e "\e[31m configure the backend file\e[0m"
cp backend.service /etc/systemd/system/backend.service

echo -e "\e[31m add user\e[0m"
useradd expense

echo -e "\e[31m remove directory\e[0m"
rm -rf /app

echo -e "\e[31m add directory\e[0m"
mkdir /app

echo -e "\e[31m download the content\e[0m"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip
cd /app

echo -e "\e[31m unzip the content\e[0m"
unzip /tmp/backend.zip
npm install

echo -e "\e[31m restart the webserver\e[0m"
systemctl daemon-reload
systemctl enable backend
systemctl restart backend

dnf install mysql -y
mysql -h mysql-dev.bdevops.online -uroot -pExpenseApp@1 < /app/schema/backend.sql
