SELECT TOP (1000) [Student_ID]
      ,[Age]
      ,[Gender]
      ,[Academic_Level]
      ,[Country]
      ,[Avg_Daily_Usage_Hours]
      ,[Most_Used_Platform]
      ,[Affects_Academic_Performance]
      ,[Sleep_Hours_Per_Night]
      ,[Mental_Health_Score]
      ,[Relationship_Status]
      ,[Conflicts_Over_Social_Media]
      ,[Addicted_Score]
  FROM [Portfolio Project].[dbo].[Students Social Media Addiction]


  SELECT *
  FROM [Students Social Media Addiction]
  -- cleaning data
  --create index
  CREATE INDEX Student_ID
ON [Students Social Media Addiction]([Student_ID])

SELECT *
  FROM [Students Social Media Addiction]

 --round coloumn data to 2 decimal place

 UPDATE [Students Social Media Addiction]
SET [Avg_Daily_Usage_Hours] = ROUND([Avg_Daily_Usage_Hours], 2);

 UPDATE [Students Social Media Addiction]
SET [Sleep_Hours_Per_Night] = ROUND([Sleep_Hours_Per_Night], 2);


SELECT *
  FROM [Students Social Media Addiction]

  --changing data type of column
  ALTER TABLE [Students Social Media Addiction]
ALTER COLUMN Affects_Academic_Performance VARCHAR(3);

-- updating to yes and no
UPDATE [Students Social Media Addiction]
SET Affects_Academic_Performance = 'Yes'
WHERE Affects_Academic_Performance = '1';

UPDATE [Students Social Media Addiction]
SET Affects_Academic_Performance = 'No'
WHERE Affects_Academic_Performance = '0';

SELECT*
FROM [Students Social Media Addiction]