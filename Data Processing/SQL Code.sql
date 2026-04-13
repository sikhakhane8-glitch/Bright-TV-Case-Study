--- Viewing the Data (Viewership) ---
select * from `bright_tv`.`default`.`viewership` limit 100;


---Viewing the Data (User Profiles)---
select * from `bright_tv`.`default`.`user_profiles_1` limit 100;



---Joining Viewership and User Profile tables---
SELECT A.UserID,
       A.Gender,
       A.Race,
       A.Age,
       A.Province,
       B.Recorddate2,
       B.`Duration 2`,
       B.Channel2
FROM `bright_tv`.`default`.`user_profiles_1` AS A
LEFT JOIN `bright_tv`.`default`.`viewership` AS B
ON A.UserID = B.UserID0;


---Converting UTC time to SAST---

SELECT 
    *,
    RecordDate2 + INTERVAL '2 hours' AS datetime_sast
FROM `bright_tv`.`default`.`viewership`;


---Finding NULLS in the dataset---
SELECT
    IFNULL(ROUND(USERID, 0),'0') AS USER_ID,
    IFNULL(GENDER,'No_Gender') AS GENDER,
    IFNULL(RACE,'No_Race') AS RACE,
    IFNULL(ROUND(AGE, 0),'0') AS AGE,
    IFNULL(PROVINCE,'No_Province') AS PROVINCE,
    IFNULL(Channel2, 'No_Channel') AS CHANNEL2,
    IFNULL(RecordDate2,'No_RecordDate') AS RECORDDATE2,
    TO_TIMESTAMP(RECORDDATE2, 'MM/dd/yyyy HH:mm') AS TIMESTAMP_VALUE,
    CAST(TO_TIMESTAMP(RECORDDATE2, 'MM/dd/yyyy HH:mm') AS DATE) AS DATE_PART,
    DATE_FORMAT(TO_TIMESTAMP(RECORDDATE2, 'MM/dd/yyyy HH:mm'),'HH:mm:ss') AS TIME_PART
    FROM `bright_tv`.`default`.`viewership` v
LEFT JOIN `bright_tv`.`default`.`user_profiles_1` u
    ON v.UserID0 = u.UserID;





---Viewership by Province---
SELECT u.Province, COUNT(v.UserID0) AS user_count_by_province
FROM `bright_tv`.`default`.`viewership` v
LEFT JOIN `bright_tv`.`default`.`user_profiles_1` u
    ON v.UserID0 = u.UserID
GROUP BY u.Province
ORDER BY user_count_by_province DESC;




---Viewership split by Age Buckets---
SELECT 
  CASE
      WHEN AGE IS NULL THEN 'UNKNOWN'
      WHEN AGE <13 THEN 'Child'
      WHEN AGE >= 13 AND AGE < 18 THEN 'Teen'
      WHEN AGE >= 18 AND AGE < 30 THEN 'Young Adult'
      WHEN AGE >= 30 AND AGE < 50 THEN 'Adult'
      WHEN AGE >= 50 AND AGE < 65 THEN 'Middle Aged'
      WHEN AGE >= 65 THEN 'Senior'
      ELSE 'Other'
      END AS AGE_GROUP,
COUNT(*) AS NUM_USERS
FROM `bright_tv`.`default`.`user_profiles_1`
GROUP BY AGE_GROUP
ORDER BY NUM_USERS ASC;



---Viewership split by time slots---
SELECT 
 CASE
    WHEN DATE_FORMAT(v.RecordDate2, 'HH:mm:ss') BETWEEN '05:00:00' AND '11:59:59' THEN 'Morning_Viewing'
    WHEN DATE_FORMAT(v.RecordDate2, 'HH:mm:ss') BETWEEN '12:00:00' AND '17:59:59' THEN 'Afternoon_Viewing'
    WHEN DATE_FORMAT(v.RecordDate2, 'HH:mm:ss') BETWEEN '18:00:00' AND '23:59:59' THEN 'Evening_Viewing'
    ELSE 'Midnight_Viewing'
    END AS Viewing_slots,
    COUNT(v.UserID0) AS USER_COUNT
FROM `bright_tv`.`default`.`viewership` v
GROUP BY
CASE
    WHEN DATE_FORMAT(v.RecordDate2, 'HH:mm:ss') BETWEEN '05:00:00' AND '11:59:59' THEN 'Morning_Viewing'
    WHEN DATE_FORMAT(v.RecordDate2, 'HH:mm:ss') BETWEEN '12:00:00' AND '17:59:59' THEN 'Afternoon_Viewing'
    WHEN DATE_FORMAT(v.RecordDate2, 'HH:mm:ss') BETWEEN '18:00:00' AND '23:59:59' THEN 'Evening_Viewing'
    ELSE 'Midnight_Viewing'
END
ORDER BY User_count DESC;

---Viewing split by gender---
SELECT Gender,
COUNT(Userid) AS Male_female_split
from `bright_tv`.`default`.`user_profiles_1` 
GROUP BY GENDER;

---10 : Combining datasets to get a clean and enhanced dataset---
SELECT
    -- User Info
    COALESCE(v.UserID0, 0) AS USER_ID,
    COALESCE(u.Province, 'Unknown') AS PROVINCE,
    COALESCE(u.Gender, 'No_Gender') AS GENDER,
    COALESCE(u.Race, 'No_Race') AS RACE,
    COALESCE(u.Age, 0) AS AGE,

    -- Age Groups
    CASE
        WHEN u.Age IS NULL THEN 'UNKNOWN'
        WHEN u.Age < 13 THEN 'Child'
        WHEN u.Age >= 13 AND u.Age < 18 THEN 'Teen'
        WHEN u.Age >= 18 AND u.Age < 30 THEN 'Young Adult'
        WHEN u.Age >= 30 AND u.Age < 50 THEN 'Adult'
        WHEN u.Age >= 50 AND u.Age < 65 THEN 'Middle Aged'
        WHEN u.Age >= 65 THEN 'Senior'
        ELSE 'Other'
    END AS AGE_GROUP,

    -- Content
    COALESCE(v.Channel2, 'No_Channel') AS CHANNEL,

    -- Duration (seconds)
    COALESCE(
        hour(v.`Duration 2`) * 3600 +
        minute(v.`Duration 2`) * 60 +
        second(v.`Duration 2`),
        0
    ) AS DURATION_SECONDS,

    -- Convert UTC → SAST
    from_utc_timestamp(
        TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm'),
        'Africa/Johannesburg'
    ) AS SAST_TIME,

    -- Date & Time breakdown
    CAST(from_utc_timestamp(
        TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm'),
        'Africa/Johannesburg'
    ) AS DATE) AS VIEW_DATE,

    hour(from_utc_timestamp(
        TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm'),
        'Africa/Johannesburg'
    )) AS HOUR,

    dayofweek(from_utc_timestamp(
        TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm'),
        'Africa/Johannesburg'
    )) AS DAY_OF_WEEK,

    -- Time Slots
    CASE
        WHEN hour(from_utc_timestamp(TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg')) BETWEEN 5 AND 11 THEN 'Morning'
        WHEN hour(from_utc_timestamp(TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg')) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN hour(from_utc_timestamp(TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg')) BETWEEN 18 AND 23 THEN 'Evening'
        ELSE 'Midnight'
    END AS TIME_SLOT

FROM `bright_tv`.`default`.`viewership` v
LEFT JOIN `bright_tv`.`default`.`user_profiles_1` u
    ON v.UserID0 = u.UserID;
