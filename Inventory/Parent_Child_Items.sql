

SELECT imitem AS Parent
	, imiitm AS Child 
FROM OPENQUERY(GSFL2K,
	'Select * 
	 FROM itemmast 
	 WHERE imiitm != imitem') 