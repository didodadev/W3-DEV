<cfif isdefined("attributes.record_num") and attributes.record_num eq 0>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1731.Kişi Seçiniz'>!");
		history.go(-1);
	</script>
	<cfabort>
</cfif>

<cfset list_employee_id="">
<cfset list_shift_id="">
<cfloop from="1" to="#attributes.record_num#" index="m">
	<cfset list_employee_id = listappend(list_employee_id,#evaluate("attributes.employee_id#m#")#,',')>
	<cfset list_shift_id = listappend(list_shift_id,#evaluate("attributes.shift_id#m#")#,',')>
</cfloop>

<cfif len(attributes.record_num) and attributes.record_num neq "">
	<cfloop from="1" to="#attributes.record_num#" index="i">
		<cfscript>
			form_employee_id = evaluate("attributes.employee_id#i#");
			form_shift_id = evaluate("attributes.shift_id#i#");
		</cfscript>

		<cfquery name="upd_emp_shift" datasource="#dsn#">
			UPDATE
				EMPLOYEES_IN_OUT
			SET
				<cfif len(form_shift_id)>
					SHIFT_ID = #form_shift_id#,
				<cfelse>
					SHIFT_ID = NULL,
				</cfif>
				UPDATE_EMP = #SESSION.EP.USERID#,	
				UPDATE_IP = '#CGI.REMOTE_ADDR#',
				UPDATE_DATE = #NOW()#
			WHERE
				EMPLOYEE_ID = #form_employee_id#
				
	<cfquery name="get_last_id" datasource="#dsn#">
		SELECT MAX(IN_OUT_ID) AS LAST_ID FROM EMPLOYEES_IN_OUT
	</cfquery>
	<cfset attributes.IN_OUT_ID=get_last_id.LAST_ID>
			<cfinclude template="../ehesap/query/add_in_out_history.cfm"> 			<!--- history tutar--->
		</cfquery>
	</cfloop>
</cfif>
<script type="text/javascript">
	window.close();
</script>
