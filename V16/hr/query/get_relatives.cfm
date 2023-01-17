<cfif fusebox.circuit eq 'myhome'>
	<cfset attributes.employee_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.employee_id,accountKey:'wrk')>
<cfelse>
	<cfset attributes.employee_id = attributes.employee_id>
</cfif>
<cfquery name="GET_RELATIVES" datasource="#DSN#">
	SELECT
		*,
		NAME + ' ' + SURNAME RELATIVE_NAME
	FROM
		EMPLOYEES_RELATIVES
	WHERE
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
	ORDER BY
		BIRTH_DATE,
		NAME,
		SURNAME,
		RELATIVE_LEVEL
</cfquery>
