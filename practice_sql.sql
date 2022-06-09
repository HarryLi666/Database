CREATE DATABASE `sql_turtorial`;
SHOW DATABASES;
USE `sql_turtorial`;

-- INT    		   整數
-- DECIMAL(3,2)    有小數點的數2.55
-- VARCHAR(10)     字串
-- BLOB           (Binary Large Object) 圖片、影片、檔案...
-- DATE.          'YYYY-MM-DD' 日期 2022-01-01
-- TIMESTAMP.     'YYYY-MM-DD HH:MM:SS' 紀錄時間


-- constraints 限制 約束  ex : NOT NULL、UNIQUE、DEFAULT(預設值)
SET SQL_SAFE_UPDATES = 0;
CREATE TABLE `student`(
	`student_id` INT AUTO_INCREMENT,
    `name` VARCHAR(20) NOT NULL,
    `major` VARCHAR(20) DEFAULT '歷史',
    `score` INT,
    PRIMARY KEY(`student_id`)
);

DESCRIBE `student`;

-- 刪除表格
DROP TABLE `student`;

-- 新增屬性
ALTER TABLE `student` ADD gpa DECIMAL(3,2);

-- 刪除屬性 
ALTER TABLE `student` DROP COLUMN gpa;       

-- 插入資料
INSERT INTO `student` VALUES(1, '小白', '歷史', 50);
INSERT INTO `student`(`name`, `major`) VALUES('小黑', '英文');

-- 修改資料
UPDATE `student` SET `major`='英文文學' WHERE `major`='英文';

-- 刪除資料
DELETE FROM `student` WHERE `student_id` = 4;   

-- 取得資料
SELECT * FROM `student` WHERE `major`='歷史' AND `score` > 20;
SELECT * FROM `student` ORDER BY `score` DESC;
SELECT * FROM `student` LIMIT 3;




-- 創建公司資料表格(employee 員工、branch 部門、client 客戶、works_with 銷售金額)

 CREATE TABLE `employee`(
	`emp_id` INT PRIMARY KEY,
    `name`  VARCHAR(20),
	`birth_date` DATE,
    `sex` VARCHAR(1),
    `salary` INT,
    `branch_id` INT,
    `sup_id` INT
 );
 
CREATE TABLE `branch`(
	`branch_id` INT PRIMARY KEY,
    `branch_name` VARCHAR(20),
    `manager_id` INT,
    -- ON DELETE SET NULL   意思是 假設 emp_id 若被刪除 將會把 manager_id 設成 NULL(對應不到即設定成 NULL)
    FOREIGN KEY (`manager_id`) REFERENCES `employee`(`emp_id`) ON DELETE SET NULL -- F.K.(manager_id) 對應到 employee 表的 emp_id
);

-- 加入foreign key
ALTER TABLE `employee` ADD FOREIGN KEY(`branch_id`) REFERENCES `branch`(`branch_id`) ON DELETE SET NULL;
ALTER TABLE `employee` ADD FOREIGN KEY(`sup_id`) REFERENCES `employee`(`emp_id`) ON DELETE SET NULL;

CREATE TABLE `client`(
	`client_id` INT PRIMARY KEY,
    `client_name` VARCHAR(20),
    `phone` VARCHAR(20)
);

CREATE TABLE `work_with`(
	`emp_id` INT,
    `client_id` INT,
    `total_sales` INT,
    PRIMARY KEY(`emp_id`, `client_id`),
    -- ON DELETE CASCADE  意思是 假設把 emp_id 刪除 F.K.的 emp_id 自動刪除(對應不到即刪除)
    FOREIGN KEY(`emp_id`) REFERENCES `employee`(`emp_id`) ON DELETE CASCADE,
    FOREIGN KEY(`client_id`) REFERENCES `client`(`client_id`) ON DELETE CASCADE
);

INSERT INTO `branch` VALUES(1, '研發', NULL);
INSERT INTO `branch` VALUES(2, '行政', NULL);
INSERT INTO `branch` VALUES(3, '資訊', NULL);
INSERT INTO `employee` VALUES (206, '小黃', '1999-10-08', 'F', 50000, 1, NULL);
INSERT INTO `employee` VALUES (207, '小綠', '1985-09-16', 'M', 29000, 2, 206);
INSERT INTO `employee` VALUES (208, '小黑', '2000-12-19', 'M', 35000, 3, 206);
INSERT INTO `employee` VALUES (209, '小白', '1997-01-22', 'F', 39000, 3, 207);
INSERT INTO `employee` VALUES (210, '小藍', '1925-11-10', 'F', 84000, 1, 207);
UPDATE `branch` SET `manager_id` = 206 WHERE `branch_id` = 1;
UPDATE `branch` SET `manager_id` = 207 WHERE `branch_id` = 2;
UPDATE `branch` SET `manager_id` = 208 WHERE `branch_id` = 3;
INSERT INTO `client` VALUES (400, '阿狗', '254354335');
INSERT INTO `client` VALUES (401, '阿貓', '25633899');
INSERT INTO `client` VALUES (402, '旺來', '45354345');
INSERT INTO `client` VALUES (403, '露西', '54354365');
INSERT INTO `client` VALUES (404, '艾瑞克', '18783783');
INSERT INTO `work_with` VALUES(206, 400, '70000');
INSERT INTO `work_with` VALUES(207, 401, '24000');
INSERT INTO `work_with` VALUES(208, 402, '9800');
INSERT INTO `work_with` VALUES(209, 403, '24000');
INSERT INTO `work_with` VALUES(210, 404, '87940');

-- 1.取得所有員工資料
SELECT * FROM `employee`;
-- 2.取得所有客戶資料
SELECT * FROM `client`;
-- 3.按薪水低到高取得員工資料
SELECT * FROM `employee` ORDER BY `salary`;
-- 4.取得薪水前3高的員工
SELECT * FROM `employee` ORDER BY `salary` DESC LIMIT 3;
-- 5.取的所有員工的名字 
SELECT `name` FROM `employee`;


-- aggregate functions 聚合函數

-- 1.取得員工人數 
SELECT COUNT(*) FROM `employee`;
-- 2.取得所有出生於 1970-01-01 之後的女性員工人數 
SELECT COUNT(*) FROM `employee` WHERE `birth_date` > '1970-01-01' AND `sex` = 'F';
-- 3.取得所有員工的平均新水 
SELECT AVG(`salary`) FROM `employee`;
-- 4.取得所有員工薪水的總和 
SELECT SUM(`salary`) FROM `employee`;
-- 5.取得薪水最高的員工 
SELECT MAX(`salary`) FROM `employee`;
-- 6.取的薪水最低的員工 
SELECT MIN(`salary`) FROM `employee`;


-- wildcards 萬用字元 ％ 代表多家自元, _ 代表一個字元 

-- 1.取得電話號碼尾數是335的客戶
SELECT * FROM `client` WHERE `phone` LIKE '%335';
-- 2.取得性阿的客戶
SELECT * FROM `client` WHERE `client_name` LIKE '阿%';
-- 3.取得生日在12月的員工 
SELECT * FROM `employee` WHERE `birth_date` LIKE '_____12%';


-- Union 聯集

-- 1.員工名字 聯集 客戶名字 
SELECT `name` FROM `employee` UNION SELECT `client_name` FROM `client`; 
-- 2.員工id + 員工名字 union 客戶名字 ＋ 客戶id
SELECT `emp_id` AS `total_id`, `name` AS `total_name` FROM `employee` UNION SELECT `client_id`, `client_name` FROM `client`;
-- 3.員工薪水 union 銷售金額 
SELECT `salary` FROM `employee` UNION SELECT `total_sales` FROM `work_with`;


-- join 連接 

INSERT INTO `branch` VALUES(4, '偷懶', NULL);
-- 1. 取得所有部門經理的名字 
SELECT `employee`.`emp_id`, `employee`.`name`, `branch`.`branch_name` FROM `employee` JOIN `branch` ON `employee`.`emp_id` = `branch`.`manager_id`;
-- LEFT/RIGHT JOIN
SELECT `employee`.`emp_id`, `employee`.`name`, `branch`.`branch_name` FROM `employee` LEFT JOIN `branch` ON `employee`.`emp_id` = `branch`.`manager_id`;
SELECT `employee`.`emp_id`, `employee`.`name`, `branch`.`branch_name` FROM `employee` RIGHT JOIN `branch` ON `employee`.`emp_id` = `branch`.`manager_id`;


-- subquery 子查詢 

-- 1.找出研發部門經理的名字
SELECT `name` FROM `employee` WHERE `emp_id`= (SELECT `manager_id` FROM `branch` WHERE `branch_name`='研發');
-- 2.找出對單一位客戶銷售金額超過50000的員工名字
SELECT `name` FROM `employee` WHERE `emp_id` IN (SELECT `emp_id` FROM `work_with` WHERE `total_sales` > 50000);





 




