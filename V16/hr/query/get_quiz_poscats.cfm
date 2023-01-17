<cfquery name="POS_CATS" datasource="#dsn#">
SELECT 
	POSITION_CAT_ID 
FROM 
	EMPLOYEE_QUIZ 
WHERE 
	QUIZ_ID=#attributes.QUIZ_ID#
</cfquery>
<cfset position_cat_list = ValueList(POSCATS.POSITION_CAT_ID)>
<cfif POS_CATS.recordcount>
<cfquery name="GET_QUIZ_POSCATS" datasource="#dsn#">
	SELECT 
		POSITION_CAT
	FROM 
		SETUP_POSITION_CAT
	WHERE
		POSITION_CAT_ID IN (#position_cat_list#)
	ORDER BY
		POSITION_CAT
</cfquery>
</cfif>
