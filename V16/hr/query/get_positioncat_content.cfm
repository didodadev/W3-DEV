<cfquery name="GET_POSITIONCAT_CONTENT" datasource="#DSN#">
	SELECT
		EMPLOYEE_POSITIONS_AUTHORITY.AUTHORITY_ID,
		EMPLOYEE_AUTHORITY.AUTHORITY_HEAD,
		EMPLOYEE_AUTHORITY.AUTHORITY_DETAIL,
		EMPLOYEE_AUTHORITY.RECORD_MEMBER,
		EMPLOYEE_AUTHORITY.RECORD_DATE
	FROM
		EMPLOYEE_AUTHORITY,
		EMPLOYEE_POSITIONS_AUTHORITY
	WHERE
		EMPLOYEE_POSITIONS_AUTHORITY.AUTHORITY_ID = EMPLOYEE_AUTHORITY.AUTHORITY_ID AND
		EMPLOYEE_POSITIONS_AUTHORITY.POSITION_CAT_ID = #attributes.position_cat_id#
</cfquery>
