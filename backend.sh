echo -e "\e[31m disable previous version of nodejs\e[0m"
dnf module disable nodejs -y &>/tmp/expense.log
dnf module enable nodejs:18 -y &>/tmp/expense.log

echo -e "\e[31m install the latest version of nodejs\e[0m"
dnf install nodejs -y &>/tmp/expense.log

echo -e "\e[31m configure the backend file\e[0m"
cp backend.service /etc/systemd/system/backend.service &>/tmp/expense.log

echo -e "\e[31m add user\e[0m"
useradd expense &>/tmp/expense.log

echo -e "\e[31m remove directory\e[0m"
rm -rf /app &>/tmp/expense.log

echo -e "\e[31m add directory\e[0m"
mkdir /app &>/tmp/expense.log

echo -e "\e[31m download the content\e[0m"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip &>/tmp/expense.log
cd /app &>/tmp/expense.log

echo -e "\e[31m unzip the content\e[0m"
unzip /tmp/backend.zip &>/tmp/expense.log
npm install &>/tmp/expense.log

echo -e "\e[31m restart the webserver\e[0m"
systemctl daemon-reload &>/tmp/expense.log
systemctl enable backend &>/tmp/expense.log
systemctl restart backend &>/tmp/expense.log

dnf install mysql -y &>/tmp/expense.log
mysql -h mysql-dev.bdevops.online -uroot -pExpenseApp@1 < /app/schema/backend.sql &>/tmp/expense.log
