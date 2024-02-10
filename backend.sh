log_file=$log_file

echo -e "\e[31m disable previous version of nodejs\e[0m"
dnf module disable nodejs -y &>$log_file
dnf module enable nodejs:18 -y &>$log_file

echo -e "\e[31m install the latest version of nodejs\e[0m"
dnf install nodejs -y &>$log_file

echo -e "\e[31m configure the backend file\e[0m"
cp backend.service /etc/systemd/system/backend.service &>$log_file

echo -e "\e[31m add user\e[0m"
useradd expense &>$log_file

echo -e "\e[31m remove directory\e[0m"
rm -rf /app &>$log_file

echo -e "\e[31m add directory\e[0m"
mkdir /app &>$log_file

echo -e "\e[31m download the content\e[0m"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip &>$log_file
cd /app &>$log_file

echo -e "\e[31m unzip the content\e[0m"
unzip /tmp/backend.zip &>$log_file
npm install &>$log_file

echo -e "\e[31m restart the webserver\e[0m"
systemctl daemon-reload &>$log_file
systemctl enable backend &>$log_file
systemctl restart backend &>$log_file

dnf install mysql -y &>$log_file
mysql -h mysql-dev.bdevops.online -uroot -pExpenseApp@1 < /app/schema/backend.sql &>$log_file
