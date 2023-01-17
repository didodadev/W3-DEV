<cfquery name="GET_POSITION_QUIZ" datasource="#dsn#">
SELECT 
	QUIZ_ID,
	QUIZ_HEAD,
	RECORD_EMP,
	RECORD_DATE
FROM 
	EMPLOYEE_QUIZ
WHERE 
    POSITION_ID LIKE '%,#POSITION_ID#,%'
	AND
	IS_ACTIVE = 1
	<!---AND
	STAGE_ID = -2--->
	AND
	IS_EDUCATION <> 1
	AND
	IS_TRAINER <> 1
	<!--- <cfif isdefined('attributes.POSITION_ID')>
	POSITION_ID= #attributes.POSITION_ID#
	<cfelse>
	POSITION_CAT_ID = #attributes.ID#
	</cfif>	
	<cfif isdefined('attributes.CONTENT_ID')>
	AND
	CONTENT_ID = #attributes.CONTENT_ID#
	</cfif>	 --->
</cfquery>

<!--- 
<cfquery name="GET_POSITION_QUIZ" datasource="#dsn#">
SELECT 
	CONTENT_ID,
	CONT_HEAD,
	CONT_BODY,
	RECORD_MEMBER,
	RECORD_DATE
FROM 
	CONTENT
WHERE 
	<cfif isdefined('attributes.POSITION_ID')>
	POSITION_ID= #attributes.POSITION_ID#
	<cfelse>
	POSITION_CAT_ID = #attributes.ID#
	</cfif>	
	<cfif isdefined('attributes.CONTENT_ID')>
	AND
	CONTENT_ID = #attributes.CONTENT_ID#
	</cfif>	 
</cfquery>
 --->
