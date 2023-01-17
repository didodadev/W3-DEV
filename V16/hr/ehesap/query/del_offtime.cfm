<cf_get_lang_set module_name="ehesap">
<cflock timeout="60">
	<cftransaction>
		<cfquery name="GET_OFFTIME" datasource="#DSN#">
			SELECT EMPLOYEE_ID,OFFTIME_STAGE FROM OFFTIME WHERE OFFTIME_ID=#attributes.OFFTIME_ID#
		</cfquery>
        <cfquery name="getEmpName" datasource="#dsn#">
            SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME AS EMPLOYEE FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_offtime.employee_id#">
        </cfquery>
		<cfquery name="DEL_OFFTIME" datasource="#DSN#">
			DELETE FROM OFFTIME WHERE OFFTIME_ID=#attributes.OFFTIME_ID#
		</cfquery>
		<cfquery name="DEL_OFFTIME" datasource="#DSN#">
			DELETE FROM EVENT WHERE OFFTIME_ID=#attributes.OFFTIME_ID#
		</cfquery>		
		<cf_add_log log_type="-1" action_id="#attributes.OFFTIME_ID#" action_table="OFFTIME" action_column="OFFTIME_ID" action_name="#get_emp_info(attributes.head,0,0)#" process_stage="#get_offtime.offtime_stage#" fuseact="#attributes.fuseaction#">
	</cftransaction>
</cflock>

<!---- 
Kayıt silinse dahi onay / red süreci atılıyor. O Yüzden kapatıldı. Esma R. Uysal
<cf_workcube_process 
	is_upd='1' 
	data_source='#dsn#' 
	old_process_line='0'
	process_stage='#get_offtime.offtime_stage#' 
	record_member='#session.ep.userid#'
	record_date='#now()#' 
	action_table='OFFTIME'
	action_column='OFFTIME_ID'
	action_id='#attributes.offtime_id#' 
	action_page='#request.self#?fuseaction=ehesap.offtimes'
	warning_description='İzin  : #attributes.offtime_id# - #getEmpName.EMPLOYEE#'>
---->
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=#nextEvent#</cfoutput>';
</script>
<cf_get_lang_set module_name="#fusebox.circuit#">
