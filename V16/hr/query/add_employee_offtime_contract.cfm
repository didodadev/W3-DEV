
<cfparam name="attributes.IS_APPROVE" default="0">
<cfparam name="attributes.IS_MAIL" default="0">
<cfparam name="attributes.SYSTEM_PAPER_NO" default="">
<cfquery name="add_in_out_real" datasource="#dsn#" result="result">
	INSERT INTO EMPLOYEES_OFFTIME_CONTRACT (
		EMPLOYEE_ID,
		SAL_YEAR,
		IS_APPROVE,
		IS_MAIL,
		OFFTIME_DATE_1,
		EX_SAL_YEAR_REMAINDER_DAY, --Önceki Dönemden Devredilen İzin Gün Sayısı
		EX_SAL_YEAR_OFTIME_DAY, --Önceki Dönemde kullanılan İzin Gün Sayısı
		SAL_YEAR_REMAINDER_DAY, --İlgili Dönem Hak edilen İzin Gün Sayısı,
		SAL_YEAR_OFTIME_DAY, --İlgili Dönemda Kullanılan İzin Gün Sayısı
		SYSTEM_PAPER_NO, --Mutabakat No - Sistem belge numarası
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP,
		CONTRACT_STAGE
	) VALUES(
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.SAL_YEAR#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.IS_APPROVE#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.IS_MAIL#">,
		#now()#,
		<cfqueryparam cfsqltype="cf_sql_float" value="#replace(attributes.EX_SAL_YEAR_REMAINDER_DAY,",",".")#">, --Önceki Dönemden Devredilen İzin Gün Sayısı
		<cfqueryparam cfsqltype="cf_sql_float" value="#replace(attributes.EX_SAL_YEAR_OFTIME_DAY,",",".")#">, --Önceki Dönemde kullanılan İzin Gün Sayısı
		<cfqueryparam cfsqltype="cf_sql_float" value="#replace(attributes.SAL_YEAR_REMAINDER_DAY,",",".")#">, --İlgili Dönem Hak edilen İzin Gün Sayısı,
		<cfqueryparam cfsqltype="cf_sql_float" value="#replace(attributes.SAL_YEAR_OFTIME_DAY,",",".")#">, --İlgili Dönemda Kullanılan İzin Gün Sayısı
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.SYSTEM_PAPER_NO#">, --Mutabakat No - Sistem belge numarası
		#now()#,
		#SESSION.EP.USERID#,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
	)
</cfquery>
<cf_workcube_process 
        is_upd='1' 
        old_process_line='0'
        process_stage='#attributes.process_stage#' 
        record_member='#session.ep.userid#' 
        record_date='#now()#'
        action_table='EMPLOYEES_OFFTIME_CONTRACT'
        action_column='EMPLOYEES_OFFTIME_CONTRACT_ID'
        action_id='#result.IDENTITYCOL#'
        action_page='#request.self#?fuseaction=ehesap.hr_offtime_approve&event=upd&EMPLOYEES_OFFTIME_CONTRACT_ID=#result.IDENTITYCOL#' 
        warning_description='#getLang('hr',1562)#'>
<script type="text/javascript">
	location.href="<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.hr_offtime_approve&event=upd&EMPLOYEES_OFFTIME_CONTRACT_ID=<cfoutput>#result.IDENTITYCOL#</cfoutput>"
	window.close();
</script>
