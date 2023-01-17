﻿<cfquery name="GET_LAST_CHAPTER_NEWS" DATASOURCE="#DSN#"><!--- maxrows="5" --->
	SELECT CCH.CONTENTCAT_ID, 
		CCH.CHAPTER,
		CC.CONTENTCAT, 
		C.CONTENT_ID,
		C.CONT_HEAD,
		C.PRIORITY,
		C.COMPANY_CAT,
		C.RECORD_MEMBER,
		C.RECORD_DATE,
		C.CONT_POSITION,
		C.CONSUMER_CAT,
		C.COMPANY_CAT,
		C.CONTENT_PROPERTY_ID,
		C.CHAPTER_ID
	  FROM 
		CONTENT C,
		CONTENT_CAT CC, 
		CONTENT_CHAPTER CCH
	  WHERE 	
		EMPLOYEE_VIEW = 1
		AND	C.CHAPTER_ID = CCH.CHAPTER_ID
		AND	CCH.CONTENTCAT_ID = CC.CONTENTCAT_ID
		AND
		CC.LANGUAGE_ID = '#SESSION.EP.LANGUAGE#'
		AND 
		C.STAGE_ID = -2
		AND
		C.CONTENT_STATUS = 1
		AND
		CAST(C.CONT_POSITION AS CHAR(6)) LIKE '%6%'
		AND
		CCH.CHAPTER_ID = #URL.CHAPTER_ID#
	 	ORDER BY C.CONTENT_ID DESC	
</cfquery>
