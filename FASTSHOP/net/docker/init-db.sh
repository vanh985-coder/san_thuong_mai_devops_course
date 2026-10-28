#!/bin/bash
set -e

# Nếu database Fastshop đã có thì bỏ qua, không import lại
EXISTS=$(/opt/mssql-tools18/bin/sqlcmd -S db -U sa -P "$MSSQL_SA_PASSWORD" -C -h -1 -W \
  -Q "SET NOCOUNT ON; SELECT COUNT(*) FROM sys.databases WHERE name = 'Fastshop'")

if [ "$EXISTS" = "1" ]; then
  echo "Database Fastshop da ton tai, bo qua import."
  exit 0
fi

# Xoá các dòng chỉ đường dẫn ổ D:\ của Windows
sed -e "/FILENAME = N'/d" -e "/^ *ON  *PRIMARY/d" -e "/^ *LOG ON/d" /scripts/script.sql > /tmp/fastshop.sql

# Import vào SQL Server
echo "Dang import script.sql ..."
/opt/mssql-tools18/bin/sqlcmd -S db -U sa -P "$MSSQL_SA_PASSWORD" -C -f 65001 -i /tmp/fastshop.sql > /dev/null
echo "Import xong."

