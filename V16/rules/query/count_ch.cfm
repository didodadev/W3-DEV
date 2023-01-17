<cfquery name="COUNT_CH" datasource="#dsn#">
 	 SELECT 
	 	COUNT(CONTENT_ID) AS COUNT FROM CONTENT
  	 WHERE 
  		EMPLOYEE_VIEW = 1
  		AND 
		STAGE_ID = -2 and
  		CHAPTER_ID = #CHAPTER_ID#
  </cfquery>