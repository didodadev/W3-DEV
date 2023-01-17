<cfquery name="add_in_out_real" datasource="#dsn#">
	UPDATE 
		EMPLOYEES_OFFTIME_CONTRACT
	SET
		SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.SAL_YEAR#">,
		IS_APPROVE = <cfif isDefined('attributes.IS_APPROVE') and len(attributes.IS_APPROVE)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.IS_APPROVE#"><cfelse>NULL</cfif>,
		IS_MAIL = <cfif isDefined('attributes.IS_MAIL') and len(attributes.IS_MAIL)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.IS_MAIL#"><cfelse>NULL</cfif>,
		EX_SAL_YEAR_REMAINDER_DAY = <cfqueryparam cfsqltype="cf_sql_float" value="#replace(attributes.EX_SAL_YEAR_REMAINDER_DAY,",",".")#">, --Önceki Dönemden Devredilen İzin Gün Sayısı
		EX_SAL_YEAR_OFTIME_DAY = <cfqueryparam cfsqltype="cf_sql_float" value="#replace(attributes.EX_SAL_YEAR_OFTIME_DAY,",",".")#">, --Önceki Dönemde kullanılan İzin Gün Sayısı
		SAL_YEAR_REMAINDER_DAY = <cfqueryparam cfsqltype="cf_sql_float" value="#replace(attributes.SAL_YEAR_REMAINDER_DAY,",",".")#">, --İlgili Dönem Hak edilen İzin Gün Sayısı,
		SAL_YEAR_OFTIME_DAY = <cfqueryparam cfsqltype="cf_sql_float" value="#replace(attributes.SAL_YEAR_OFTIME_DAY,",",".")#">, --İlgili Dönemda Kullanılan İzin Gün Sayısı
		SYSTEM_PAPER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.SYSTEM_PAPER_NO#">, --Mutabakat No - Sistem belge numarası
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.REMOTE_ADDR#',
		UPDATE_DATE = #now()#,
		CONTRACT_STAGE = <cfif isDefined('attributes.process_stage') and len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>
	WHERE
		EMPLOYEES_OFFTIME_CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employees_offtime_contract_id#">
</cfquery>
<cf_workcube_process 
        is_upd='1' 
        old_process_line='#attributes.old_process_line#'
        process_stage='#attributes.process_stage#' 
        record_member='#session.ep.userid#' 
        record_date='#now()#'
        action_table='EMPLOYEES_OFFTIME_CONTRACT'
        action_column='employees_offtime_contract_id'
        action_id='#attributes.employees_offtime_contract_id#'
        action_page='#request.self#?fuseaction=ehesap.hr_offtime_approve&event=upd&employees_offtime_contract_id=#attributes.employees_offtime_contract_id#' 
        warning_description='#getLang('hr',1562)#'>
<script type="text/javascript">
	location.href="<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.hr_offtime_approve&event=upd&employees_offtime_contract_id=<cfoutput>#attributes.employees_offtime_contract_id#</cfoutput>"
</script>