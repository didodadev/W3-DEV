<cfquery name="GET_POSCAT_EMPQUIZS" datasource="#dsn#">
	SELECT 
		RELATION_FIELD_ID,
		RELATION_ACTION_ID
	FROM 
		RELATION_SEGMENT_QUIZ 
	WHERE 
		RELATION_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer"  value="#attributes.position_id#">
		<!--- Pozisyon Tipinin Iliskili Olcme Degerlendirme Formlari Yeni Bir Tabloyla Ilıskilendirildigi Icin Query Degistirildi --->
		<!--- SELECT 
			QUIZ_ID,
			QUIZ_HEAD
		FROM 
			EMPLOYEE_QUIZ
		WHERE 
			POSITION_CAT_ID LIKE '%,#attributes.position_id#,%' --->
</cfquery>






