<cfif isdefined("nafaka_type_id") and len(nafaka_type_id) and len(nafaka_id) and nafaka_id neq 0>
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
<cfif StructCount(icra_type_id) gt 0 and StructCount(icra_id) gt 0>
	<cfloop collection="#icra_id#" item="idx">
		<cfquery name="get_" datasource="#dsn#">
			UPDATE
				EMPLOYEES_PUANTAJ_ROWS_EXT
			SET 
				<cfif structKeyExists(icra_rakam,"#idx#")>AMOUNT_2 = <cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("icra_rakam['#idx#']")#">,</cfif>
				RELATED_TABLE = 'COMMANDMENT',
				RELATED_TABLE_ID = #idx#
			WHERE
				PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#puantaj_id#"> AND
				EMPLOYEE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#"> AND
				DETAIL = '#evaluate("icra_type_id['#idx#']")#-#idx#'
		</cfquery>
	</cfloop>
	<cfinclude template = "../display/calc_icra.cfm">
	<cfloop query="#get_new_rows#">
		<cfif structKeyExists(kalan_deger_,"#get_new_rows.COMMANDMENT_ID#")>
			<cfquery name="upd_salaryparam_get" datasource="#dsn#">
				UPDATE
					SALARYPARAM_GET
				SET
					AMOUNT_GET = #kalan_deger_["#get_new_rows.COMMANDMENT_ID#"]#
				WHERE
					RELATED_TABLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_new_rows.COMMANDMENT_ID#">
					AND START_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
					AND END_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
					AND TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#">
			</cfquery>
		</cfif>
	</cfloop>
	<cfquery name="del_salaryparam_get" datasource="#dsn#">
		DELETE FROM
			SALARYPARAM_GET
		WHERE
			START_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
			AND END_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
			AND TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#">
			AND AMOUNT_GET = 0
			AND IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
			AND RELATED_TABLE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="COMMANDMENT">
	</cfquery>
	<cfquery name="get_" datasource="#dsn#">
		DELETE FROM
			EMPLOYEES_PUANTAJ_ROWS_EXT
		WHERE
			PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#puantaj_id#"> AND
			EMPLOYEE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#"> AND
			AMOUNT_2 = 0 AND
			RELATED_TABLE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="COMMANDMENT">
	</cfquery>
</cfif>

