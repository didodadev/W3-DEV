<cfquery name="del_olds" datasource="#dsn#">
	DELETE FROM
		SALARYPARAM_EXCEPT_TAX
	WHERE
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#">
		AND TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.related_year#">
		AND IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
</cfquery>

<cfloop from="1" to="#attributes.rowCount#" index="i">
	<cfif evaluate("ATTRIBUTES.row_kontrol_#i#") eq 1>
		<cfquery name="add_row" datasource="#dsn#">
			INSERT INTO SALARYPARAM_EXCEPT_TAX
				(
				TAX_EXCEPTION,
				AMOUNT,
				START_MONTH,
				FINISH_MONTH,
				EMPLOYEE_ID,
				TERM,
				CALC_DAYS,
				YUZDE_SINIR,
				IS_ALL_PAY,
				IS_ISVEREN,
				IS_SSK,
				EXCEPTION_TYPE,
				IN_OUT_ID,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
				)
			VALUES
				(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('ATTRIBUTES.TAX_EXCEPTION#i#')#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('ATTRIBUTES.AMOUNT#i#')#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('ATTRIBUTES.START_SAL_MON#i#')#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('ATTRIBUTES.END_SAL_MON#i#')#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#ATTRIBUTES.EMPLOYEE_ID#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('ATTRIBUTES.TERM#i#')#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('ATTRIBUTES.CALC_DAYS#i#')#">,
				<cfif len(evaluate("ATTRIBUTES.YUZDE_SINIR#i#"))>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('ATTRIBUTES.YUZDE_SINIR#i#')#">
				<cfelse>
					NULL
				</cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('ATTRIBUTES.IS_ALL_PAY#i#')#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('ATTRIBUTES.IS_ISVEREN#i#')#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('ATTRIBUTES.IS_SSK#i#')#">,
				<cfif len(evaluate("ATTRIBUTES.EXCEPTION_TYPE#i#"))>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('ATTRIBUTES.EXCEPTION_TYPE#i#')#">,
				<cfelse>
					NULL,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
				)
		</cfquery><cfoutput>#i#</cfoutput>
	</cfif>
</cfloop>
<cfif isdefined("attributes.from_upd_salary") and len(attributes.from_upd_salary)>
	<cflocation url="#request.self#?fuseaction=ehesap.list_salary&event=upd&in_out_id=#attributes.in_out_id#&employee_id=#attributes.employee_id#&type=7" addtoken="No">
<cfelseif not isdefined("attributes.draggable")>
	<script type="text/javascript">
		window.close();
	</script>
<cfelse>
	<script type="text/javascript">
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
	</script>
</cfif>