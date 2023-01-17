<cfquery name="GET_UPDATE" datasource="#DSN#">
	SELECT CCH.CONTENTCAT_ID,     
		   C.CONTENT_ID,	   	   	   
		   CC.CONTENTCAT_ID,
		   C.UPD_COUNT,   	   
		   C.UPDATE_DATE,
		   C.UPDATE_MEMBER,  	   
		   C.CHAPTER_ID ,
		   E.EMPLOYEE_NAME,
		   E.EMPLOYEE_SURNAME,
		   E.EMPLOYEE_ID
	  FROM 
		   EMPLOYEES E,
		   CONTENT_CAT CC,
		   CONTENT C ,  	    
		   CONTENT_CHAPTER CCH
		   
	WHERE 
			E.EMPLOYEE_ID = C.UPDATE_MEMBER AND
			C.CHAPTER_ID = CCH.CHAPTER_ID AND
			CCH.CONTENTCAT_ID = CC.CONTENTCAT_ID	 
			<cfif isDefined("attributes.cntid")>
				AND C.CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cntid#">
			<cfelseif isDefined("attributes.cntid")>
				AND C.CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cntid#">
			</cfif>
</cfquery>
