<cfquery name="GET_POSITIONCAT_CONTENT" datasource="#DSN#">
	SELECT
		EMPLOYEE_POSITIONS_AUTHORITY.AUTHORITY_ID ,
		AUTHORITY_HEAD,
		AUTHORITY_DETAIL,
		RECORD_MEMBER,
		RECORD_DATE
	FROM
		EMPLOYEE_AUTHORITY,
		EMPLOYEE_POSITIONS_AUTHORITY
	WHERE
		EMPLOYEE_POSITIONS_AUTHORITY.AUTHORITY_ID = EMPLOYEE_AUTHORITY.AUTHORITY_ID
		AND	POSITION_CAT_ID = #attributes.POSITION_CAT_ID#
</cfquery>