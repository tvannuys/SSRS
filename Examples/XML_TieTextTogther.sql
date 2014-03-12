

-- http://stackoverflow.com/questions/11144125/how-to-return-multiple-results-in-a-subquery

-- Adding lines of text together

SELECT   Name
         , DOB
         , STUFF((SELECT ', ' 
                         + CONVERT(VARCHAR(16), H.Date, 101)
                         + ' ' 
                         + H.Reason 
                  FROM   visits AS H 
                  WHERE  H.VID = visitor.VID 
                  FOR XML PATH('')), 1, 2, '')
FROM     visitor;