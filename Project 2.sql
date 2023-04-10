-- 1
USE alumni;
-- 3
DESC college_a_hs;
DESC college_a_se;
DESC college_a_sj;
DESC college_b_hs;
DESC college_b_se;
DESC college_b_sj;

-- 6
CREATE VIEW college_a_hs_v AS SELECT * FROM college_a_hs WHERE RollNo IS NOT NULL
AND LastUpdate IS NOT NULL AND Name IS NOT NULL
AND FatherName IS NOT NULL AND MotherName IS NOT NULL
AND Batch IS NOT NULL AND Degree IS NOT NULL
AND PresentStatus IS NOT NULL AND EntranceExam IS NOT NULL
AND HSDegree IS NOT NULL AND Institute IS NOT NULL
AND Location IS NOT NULL;
SELECT * FROM college_a_hs_v;
-- 7
CREATE VIEW college_a_se_v AS SELECT * FROM college_a_se
WHERE RollNo IS NOT NULL AND LastUpdate IS NOT NULL
AND Name IS NOT NULL AND FatherName IS NOT NULL
AND MotherName IS NOT NULL AND Batch IS NOT NULL
AND Degree IS NOT NULL AND PresentStatus IS NOT NULL
AND Organization IS NOT NULL AND Location IS NOT NULL;
SELECT * FROM college_a_se_v;

-- 8
CREATE VIEW college_a_sj_v AS SELECT * FROM college_a_sj
WHERE RollNo IS NOT NULL AND LastUpdate IS NOT NULL
AND Name IS NOT NULL AND FatherName IS NOT NULL
AND MotherName IS NOT NULL AND Batch IS NOT NULL
AND Degree IS NOT NULL AND PresentStatus IS NOT NULL
AND Organization IS NOT NULL AND Designation IS NOT NULL
AND Location IS NOT NULL;
SELECT * FROM college_a_sj_v;

-- 9
CREATE VIEW college_b_hs_v AS SELECT * FROM college_b_hs
WHERE RollNo IS NOT NULL AND LastUpdate IS NOT NULL
AND Name IS NOT NULL AND FatherName IS NOT NULL
AND MotherName IS NOT NULL AND Branch IS NOT NULL
AND Batch IS NOT NULL AND Degree IS NOT NULL
AND PresentStatus IS NOT NULL AND HSDegree IS NOT NULL
AND EntranceExam IS NOT NULL AND Institute IS NOT NULL
AND Location IS NOT NULL;
SELECT * FROM college_b_hs_v;

-- 10
CREATE VIEW college_b_se_v AS SELECT * FROM college_b_se
WHERE RollNo IS NOT NULL AND LastUpdate IS NOT NULL
AND Name IS NOT NULL AND FatherName IS NOT NULL
AND MotherName IS NOT NULL AND Branch IS NOT NULL
AND Batch IS NOT NULL AND Degree IS NOT NULL
AND PresentStatus IS NOT NULL AND Organization IS NOT NULL
AND Location IS NOT NULL;
SELECT * FROM college_b_se_v;

-- 11
CREATE VIEW college_b_sj_v AS SELECT * FROM college_b_sj
WHERE RollNo IS NOT NULL AND LastUpdate IS NOT NULL
AND Name IS NOT NULL AND FatherName IS NOT NULL
AND MotherName IS NOT NULL AND Branch IS NOT NULL
AND Batch IS NOT NULL AND Degree IS NOT NULL
AND PresentStatus IS NOT NULL AND Organization IS NOT NULL
AND Designation IS NOT NULL AND Location IS NOT NULL;
SELECT * FROM college_b_sj;

-- 12
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `lower_collegedata`(  INOUT name1 TEXT(40000) )
BEGIN    
DECLARE namelist VARCHAR(16000) DEFAULT ""; 
SELECT lower(Name),lower(FatherName),lower(MotherName) FROM
college_a_hs_v UNION
SELECT lower(Name),lower(FatherName),lower(MotherName) FROM
college_a_se_v UNION
SELECT lower(Name),lower(FatherName),lower(MotherName) FROM
college_a_sj_v UNION
SELECT lower(Name),lower(FatherName),lower(MotherName) FROM
college_b_hs_v UNION
SELECT lower(Name),lower(FatherName),lower(MotherName) FROM
college_b_se_v UNION
SELECT lower(Name),lower(FatherName),lower(MotherName) FROM
college_b_sj_v;
END $$
DELIMITER ;

CALL lower_collegedata(@name1); 

-- 14
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_name_collegeA`(  INOUT name1 TEXT(40000) )
BEGIN   
DECLARE na INT DEFAULT 0;  
DECLARE namelist VARCHAR(16000) DEFAULT "";    
DECLARE namedetail   CURSOR FOR  SELECT Name FROM college_a_hs   
UNION   SELECT Name FROM college_a_se   
UNION   SELECT Name FROM college_a_sj;    
DECLARE CONTINUE HANDLER   
FOR NOT FOUND SET na =1;    
OPEN namedetail;    
getame :  
LOOP  
FETCH FROM namedetail INTO namelist;  
IF na = 1 
THEN  LEAVE getame;  
END IF;  
SET name1 = CONCAT(namelist,";",name1);   
 END LOOP getame;  
 CLOSE namedetail; 
END $$
DELIMITER ;
 
SET @name1="";
CALL get_name_collegeA(@name1);
SELECT @name1 Name; 

-- 15
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_name_collegeB`(  INOUT name1 TEXT(40000) )
BEGIN   
DECLARE na INT DEFAULT 0;  
DECLARE namelist VARCHAR(16000) DEFAULT "";    
DECLARE namedetail   
CURSOR FOR  SELECT Name FROM college_b_hs   
UNION   SELECT Name FROM college_b_se  
 UNION   SELECT Name FROM college_b_sj;   
 DECLARE CONTINUE HANDLER   
 FOR NOT FOUND SET na =1;   
 OPEN namedetail;    
 getame :  
 LOOP  
 FETCH FROM namedetail INTO namelist; 
 IF na = 1 THEN  LEAVE getame;  
 END IF;  
 SET name1 = CONCAT(namelist,";",name1);    
 END LOOP getame; 
 CLOSE namedetail; 
 END $$
 DELIMITER ;
 
SET @name2="";
CALL get_name_collegeB(@name2);
SELECT @name2 Name;

-- 16
SELECT "HigherStudies" PresentStatus,(SELECT COUNT(*) FROM college_a_hs)/
((SELECT COUNT(*) FROM college_a_hs) + (SELECT COUNT(*) FROM college_a_se) + (SELECT COUNT(*) FROM college_a_sj))*100
College_A_Percentage,
(SELECT COUNT(*) FROM college_b_hs)/
((SELECT COUNT(*) FROM college_b_hs) + (SELECT COUNT(*) FROM college_b_se) + (SELECT COUNT(*) FROM college_b_sj))*100
College_B_Percentage
UNION
SELECT "Self Employed" PresentStatus,(SELECT COUNT(*) FROM college_a_se)/
((SELECT COUNT(*) FROM college_a_hs) + (SELECT COUNT(*) FROM college_a_se) + (SELECT COUNT(*) FROM college_a_sj))*100
College_A_Percentage,
(SELECT COUNT(*) FROM college_b_se)/
((SELECT COUNT(*) FROM college_b_hs) + (SELECT COUNT(*) FROM college_b_se) + (SELECT COUNT(*) FROM college_b_sj))*100
College_B_Percentage
UNION
SELECT "Service Job" PresentStatus,(SELECT COUNT(*) FROM college_a_sj)/
((SELECT COUNT(*) FROM college_a_hs) + (SELECT COUNT(*) FROM college_a_se) + (SELECT COUNT(*) FROM college_a_sj))*100
College_A_Percentage,
(SELECT COUNT(*) FROM college_b_sj)/
((SELECT COUNT(*) FROM college_b_hs) + (SELECT COUNT(*) FROM college_b_se) + (SELECT COUNT(*) FROM college_b_sj))*100
College_B_Percentage;


