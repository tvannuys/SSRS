

SELECT c.customer_id,
       con.contact_id,
       c.company_name,
       con.first_name,
       con.last_name,
       con_email.items [email]
FROM   customer c WITH(NOLOCK)
       JOIN contact con WITH(NOLOCK)
         ON c.customer_id = con.customer_id
       CROSS APPLY dbo.Split(con.email, ';') con_email
WHERE  con.email LIKE '%;%'
ORDER  BY c.customer_id,
          con.contact_id;

---------------------------------------------------------------------
CREATE FUNCTION dbo.Split(@String    VARCHAR(8000),
                          @Delimiter CHAR(1))
returns @temptable TABLE (
  items VARCHAR(8000))
AS
  BEGIN
      DECLARE @idx INT
      DECLARE @slice VARCHAR(8000)

      SELECT @idx = 1

      IF Len(@String) < 1
          OR @String IS NULL
        RETURN

      WHILE @idx != 0
        BEGIN
            SET @idx = Charindex(@Delimiter, @String)

            IF @idx != 0
              SET @slice = LEFT(@String, @idx - 1)
            ELSE
              SET @slice = @String

            IF( Len(@slice) > 0 )
              INSERT INTO @temptable
                          (Items)
              VALUES     (@slice)

            SET @String = RIGHT(@String, Len(@String) - @idx)

            IF Len(@String) = 0
              BREAK
        END

      RETURN
  END 