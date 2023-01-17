<cfif len(nafaka_type_id) and len(nafaka_id) and nafaka_id neq 0>
	<cfquery name="get_" datasource="#dsn#">
		UPDATE
			EMPLOYEES_PUANTAJ_ROWS_EXT
		SET 
			RELATED_TABLE = 'COMMANDMENT',
			RELATED_TABLE_ID = #nafaka_id#
		WHERE
			PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#puantaj_id#"> AND
			EMPLOYEE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#"> AND
			DETAIL = '#nafaka_type_id#-#nafaka_id#'
	</cfquery>
</cfif>

<cfif len(icra_type_id) and len(icra_id) and icra_id neq 0>
	<cfquery name="get_" datasource="#dsn#">
		UPDATE
			EMPLOYEES_PUANTAJ_ROWS_EXT
		SET 
			RELATED_TABLE = 'COMMANDMENT',
			RELATED_TABLE_ID = #icra_id#
		WHERE
			PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#puantaj_id#"> AND
			EMPLOYEE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#"> AND
			DETAIL = '#icra_type_id#-#icra_id#'
	</cfquery>
</cfif>

