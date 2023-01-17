<!--- 	id siz kullanmayiniz. --->
<cfquery name="GET_DEPARTMENT_HEAD" datasource="#dsn#">
	SELECT
		DEPARTMENT_HEAD
	FROM 
		DEPARTMENT
	WHERE
	<cfif isdefined("attributes.DEPARTMENT_ID") and len(attributes.DEPARTMENT_ID)>
		DEPARTMENT_ID = #attributes.DEPARTMENT_ID#
	<cfelseif isdefined("attributes.DEPARTMENT") and len(attributes.DEPARTMENT)>
		DEPARTMENT_ID = #attributes.DEPARTMENT#
	<cfelse> 1 = 0
	</cfif>
</cfquery>
