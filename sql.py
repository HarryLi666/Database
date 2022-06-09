import mysql.connector

connection = mysql.connector.connect(host='localhost',
                                    port='3306',
                                    user='root',
                                    password='00000000')

cursor = connection.cursor()

# 創建資料庫
cursor.execute("CREATE DATABASE `qq`;")

# 取得所有資料庫名稱
cursor.execute("SHOW DATABASES;")
record = cursor.fetchall()
for r in record:
    print(r)

# 選擇資料庫
cursor.execute("USE `sql_turtorial`;")

# 創建表格
cursor.execute("CREATE TABLE `qq`(qq INT);")

# 取得部門所有資料
cursor.execute(" SELECT * FROM `branch`; ")
record = cursor.fetchall()
for r in record:
    print(r)

# 新增
cursor.execute(" INSERT INTO `branch` VALUES (5, 'qq', NULL); ")
# 修改
cursor.execute(" UPDATE `branch` SET `manager_id` = NULL WHERE `branch_id` = 4; ")
# 刪除
cursor.execute(" DELETE FROM `branch` WHERE `branch_id`= 5; ")





cursor.close()
connection.commit()
connection.close()