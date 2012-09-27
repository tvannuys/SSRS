   DECLARE @YourTable TABLE (StartTime int,  EndTime int)

    INSERT  INTO @YourTable SELECT  70500, 71000
    INSERT  INTO @YourTable SELECT  120500, 121100
    INSERT  INTO @YourTable SELECT  134500, 135800


    Select CONVERT(CHAR(8), DATEADD(SECOND, AVG(DATEDIFF(SECOND,
          CONVERT(DATETIME,CONVERT(VarCHAR(02),StartTime/10000)+':'
         +CONVERT(VARCHAR(02),(StartTime/100)%100)+':'
         +CONVERT(VARCHAR(02),StartTime%100),8),
          CONVERT(DATETIME,CONVERT(VarCHAR(02),Endtime/10000)+':'
         +CONVERT(VARCHAR(02),(EndTime/100)%100)+':'
          +CONVERT(VARCHAR(02),EndTime%100),8))),
       CONVERT(DATETIME, '00:00:00', 113)),8)                   
     AS ElapsedTime
    FROM    @YourTable 
