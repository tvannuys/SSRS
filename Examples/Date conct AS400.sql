
-- Concat. date to mm/dd/yyyy from the AS400
MONTH(ohsdat) || ''/'' || DAY(ohsdat) || ''/'' || YEAR(ohsdat) AS ship_Date