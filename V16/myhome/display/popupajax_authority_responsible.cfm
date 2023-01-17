<cfquery name="GET_POSITIONCAT_CONTENT_ROW" datasource="#DSN#">
	SELECT
		EMPLOYEE_POSITIONS_AUTHORITY.AUTHORITY_ID,
		AUTHORITY_HEAD,
		AUTHORITY_DETAIL,
		RECORD_MEMBER,
		RECORD_DATE
	FROM
		EMPLOYEE_AUTHORITY,
		EMPLOYEE_POSITIONS_AUTHORITY
	WHERE
		EMPLOYEE_POSITIONS_AUTHORITY.AUTHORITY_ID = EMPLOYEE_AUTHORITY.AUTHORITY_ID
		AND EMPLOYEE_POSITIONS_AUTHORITY.AUTHORITY_ID = #attributes.auth_id#
</cfquery>
<cfoutput>#GET_POSITIONCAT_CONTENT_ROW.AUTHORITY_DETAIL#</cfoutput>

