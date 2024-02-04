echo disable previous version of nodejs
dnf module disable nodejs -y
dnf module enable nodejs:18 -y

echo install the latest version of nodejs
dnf install nodejs -y

echo configure the backend file
cp backend.service /etc/systemd/system/backend.service

echo add user
useradd expense

echo remove directory
rm -rf /app

echo add directory
mkdir /app

echo download the content
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip
cd /app

echo unzip the content
unzip /tmp/backend.zip
npm install

echo restart the webserver
systemctl daemon-reload
systemctl enable backend
systemctl restart backend

dnf install mysql -y
mysql -h mysql-dev.bdevops.online -uroot -pExpenseApp@1 < /app/schema/backend.sql
