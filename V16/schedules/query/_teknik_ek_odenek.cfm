<!--- <cfquery name="get_pos" datasource="#dsn#">
	SELECT
		*
	FROM
		EMPLOYEES E,
		EMPLOYEE_POSITIONS EP,
		EMPLOYEES_IN_OUT EIO,
		EMPLOYEES_RELATIVES ER
	WHERE
		E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND
		E.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND
		E.EMPLOYEE_ID = ER.EMPLOYEE_ID AND
		EP.COLLAR_TYPE = 1 AND
		EIO.FINISH_DATE IS NULL AND
		EIO.START_DATE < #Now()#
</cfquery>

<cfquery name="get_cocuk_say" dbtype="query">
	SELECT
		Count(*) AS CSay
	FROM
		get_pos
	WHERE
		RELATIVE_LEVEL = 4 OR
		RELATIVE_LEVEL = 5
</cfquery> --->

<cfquery name="get_pos" datasource="#dsn#">
	SELECT
		*
	FROM
		EMPLOYEE_POSITIONS EP
	WHERE
		EP.COLLAR_TYPE = 1
</cfquery>

<cfoutput query="#get_pos#">
	<cfquery name="get_in_out" datasource="#dsn#">
		SELECT
			*
		FROM
			EMPLOYEE_POSITIONS EP,
			EMPLOYEES_IN_OUT EIO
		WHERE
			EP.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND
			EIO.FINISH_DATE IS NULL AND
			EIO.START_DATE < #Now()#
	</cfquery>
</cfoutput>

<cfdump var="#get_pos#">
