﻿<cfquery name="GET_SPOTS" datasource="#DSN#" maxrows="10">
	SELECT 
		C.CONT_HEAD, 
		C.CONTENT_ID,
		C.CONT_SUMMARY,
        X.CONTIMAGE_SMALL
	FROM  
		CONTENT C
        OUTER APPLY (
		SELECT TOP 1 CONTIMAGE_SMALL FROM CONTENT_IMAGE WHERE CONTENT_ID = C.CONTENT_ID
		) AS X,
		CONTENT_CHAPTER CH,
		CONTENT_CAT CT 
	WHERE 
		C.SPOT = 1 AND
		C.STAGE_ID = -2 AND 
		C.EMPLOYEE_VIEW = 1 AND
		C.CHAPTER_ID = CH.CHAPTER_ID AND
		CH.CONTENTCAT_ID = CT.CONTENTCAT_ID AND
		CT.LANGUAGE_ID = '#session.ep.language#' 
	ORDER BY 
		C.CONTENT_ID DESC
</cfquery>