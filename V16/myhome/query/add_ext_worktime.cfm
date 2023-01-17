<cf_date tarih="startdate">
<cfscript>
	startdate_ = startdate;
	startdate = date_add('h', start_hour, startdate);
	startdate = date_add('n', start_min, startdate);
	finishdate = date_add('h', end_hour, startdate_);
	finishdate = date_add('n', end_min, finishdate);
	start_hour_format = timeformat('#start_hour#:#start_min#',timeformat_style);
	end_hour_format =  timeformat('#end_hour#:#end_min#',timeformat_style);
</cfscript>
<cfquery name="get_employee_company" datasource="#dsn#">
	SELECT
		BRANCH.COMPANY_ID,
		PUANTAJ_GROUP_IDS,
		BRANCH.BRANCH_ID
	FROM
		BRANCH,
		EMPLOYEES_IN_OUT
	WHERE
		EMPLOYEES_IN_OUT.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> AND
		EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID
</cfquery>
<cfquery name="IS_EXTRA_WORK_TIME_EQUAL" datasource="#dsn#">	<!--- CH --->
	SELECT 
		*
	FROM
		EMPLOYEES_EXT_WORKTIMES
	WHERE
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
		IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> AND
		(ISNULL(VALID,2) > 0)
		AND
		(
			(
			WORK_START_TIME >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#startdate#"> AND
			WORK_START_TIME <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#finishdate#">
			)
		OR
			(
			WORK_START_TIME <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#startdate#"> AND
			WORK_END_TIME >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#startdate#">
			)
		)
</cfquery>
<cfif IS_EXTRA_WORK_TIME_EQUAL.recordcount>
	<script type="text/javascript">
		alert('Aynı Zaman Dilimleri İçersinde Birden çok Fazla Mesai Tanımlanamaz!');
		window.location.href="<cfoutput>#request.self#?fuseaction=myhome.list_my_extra_times&event=add</cfoutput>";
	</script>
	<cfabort>
</cfif>
<!---
<cfquery name="IS_OFFTIME_EQUAL" datasource="#dsn#">
	SELECT
		*
	FROM
		OFFTIME
	WHERE
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
		(
			(STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#startdate#"> AND 
			FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#startdate#">)
			OR
			(STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#finishdate#"> AND 
			FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#finishdate#">)
			OR
			(STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#startdate#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#finishdate#">)
			OR
			(STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#startdate#"> AND STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#finishdate#">)
		)
</cfquery>
<cfif IS_OFFTIME_EQUAL.recordcount>
	<script type="text/javascript">
		alert('Zaman Dilimi İçersinde Kişi İzinli Olduğu İçin Fazla Mesai Girilemez!');
		window.location.reload();
	</script>
	<cfabort>
</cfif>
--->

<cfset attributes.our_company_id = get_employee_company.COMPANY_ID>
<cfinclude template="../../hr/ehesap/query/get_hours.cfm">

<!--- Fazla Mesai Kontrol Esma R. Uysal ---->
<cfset hr= "myhome.list_my_extra_times&event=add">
<cfinclude template="../../hr/ehesap/query/extra_worktimes_control.cfm">

<cfif not(get_hours.recordcount)>
	<script type="text/javascript">
		alert("Şirket SGK Çalışma Saatlerini Girmelisiniz !");
		window.location.href="<cfoutput>#request.self#?fuseaction=myhome.list_my_extra_times&event=add</cfoutput>";
	</script>
	<cfabort>
</cfif>
<cfset attributes.sal_mon = month(startdate)>
<cfset attributes.sal_year = year(startdate)>
<cfset attributes.group_id = "">
<cfif len(get_employee_company.puantaj_group_ids)>
	<cfset attributes.group_id = "#get_employee_company.PUANTAJ_GROUP_IDS#,">
</cfif>
<cfset attributes.branch_id = get_employee_company.branch_id>
<cfset not_kontrol_parameter = 1>
<cfinclude template="../../hr/ehesap/query/get_program_parameter.cfm">
<cfif not get_program_parameters.recordcount>
	<script type="text/javascript">
		alert('<cf_get_lang_main no="1336.Seçtiğiniz Tarihi Kapsayan Program Akış Parametresi Bulunamamıştır! Lütfen Program Akış Parametrelerini Giriniz">');
		window.close();
	</script>
	<cfabort>
</cfif>
<cfquery name="GET_DAILY_EXT_TIME" datasource="#dsn#">
	SELECT
	<cfif database_type is "MSSQL">
		SUM(DATEDIFF(MINUTE,WORK_START_TIME,WORK_END_TIME)) AS TOTAL_MIN
	<cfelseif database_type is "DB2">
		SUM(SECONDSDIFF(WORK_END_TIME,WORK_START_TIME))/60 AS TOTAL_MIN
	</cfif>
	FROM
		EMPLOYEES_EXT_WORKTIMES
	WHERE
		WORK_START_TIME >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#startdate_#"> AND
		WORK_END_TIME < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d', 1, startdate_)#"> AND
		EMPLOYEE_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
		ISNULL(VALID,2) > 0
</cfquery>
<cfset total_mesai = (end_hour - start_hour)*60 + (end_min - start_min)>
<cfset ext_time_limit = get_program_parameters.overtime_hours*60>
<cfif attributes.day_type eq 1><!--- hafta sonu --->
	<cfset ext_time_limit = ext_time_limit + (get_hours.daily_work_hours*60)>
<cfelseif attributes.day_type eq 3><!--- Gece Çalışması --->
	<cfset ext_time_limit = ext_time_limit + (get_hours.daily_work_hours*60)>
</cfif>
<cfif len(GET_DAILY_EXT_TIME.TOTAL_MIN)>
	<cfset total_mesai = total_mesai + GET_DAILY_EXT_TIME.TOTAL_MIN>
</cfif>
<cfif attributes.day_type eq 0> <!--- resmi tatil, hafta sonunda fazla mesai sınırı yoktur.CH_26012009 --->
	<cfif total_mesai gt ext_time_limit>
		<script type="text/javascript">
			alert("Günlük Kanuni Mesai Limitini (<cfoutput>#get_program_parameters.overtime_hours#</cfoutput> saat) Aştınız !");
		</script>
	</cfif>
</cfif>
<cfquery name="GET_YEARLY_EXT_TIME" datasource="#dsn#">
	SELECT
	<cfif database_type is "MSSQL">
		SUM(DATEDIFF(MINUTE,WORK_START_TIME,WORK_END_TIME)) AS TOTAL_MIN
	<cfelseif database_type is "DB2">
		SUM(SECONDSDIFF(WORK_END_TIME,WORK_START_TIME))/60 AS TOTAL_MIN
	</cfif>
	FROM
		EMPLOYEES_EXT_WORKTIMES
	WHERE
		WORK_START_TIME >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdate(session.ep.period_year,1,1)#"> AND
		WORK_END_TIME < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(createdate(session.ep.period_year+1,1,1))#">
		AND EMPLOYEE_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
		AND ISNULL(VALID,2) > 0
</cfquery>
<cfset ext_time_limit = get_program_parameters.OVERTIME_YEARLY_HOURS*60>
<cfset total_mesai = (end_hour - start_hour)*60 + (end_min - start_min)>
<cfif attributes.day_type eq 1><!--- hafta sonu --->
	<cfset ext_time_limit = ext_time_limit + (get_hours.daily_work_hours*60)>
<cfelseif attributes.day_type eq 3><!--- Gece Çalışması --->
	<cfset ext_time_limit = ext_time_limit + (get_hours.daily_work_hours*60)>
</cfif>
<cfif len(GET_YEARLY_EXT_TIME.total_min)>
	<cfset total_mesai = total_mesai + GET_YEARLY_EXT_TIME.total_min>
</cfif>
<cfset get_fuseaction_property = createObject("component","V16.objects.cfc.fuseaction_properties")>
<cfset get_prop = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'ehesap.list_ext_worktimes',
    property_name : 'is_overtime_yearly_hours'
    )>
<cfset is_overtime_yearly_hours = get_prop.PROPERTY_VALUE>
<cfif total_mesai gt ext_time_limit>
	<script type="text/javascript">
		alert("Yıllık Kanuni Mesai Limitini (<cfoutput>#get_program_parameters.OVERTIME_YEARLY_HOURS#</cfoutput> saat) Aştınız !");
		<cfif is_overtime_yearly_hours eq 1>
			history.back();
		</cfif>
	</script>
	<cfif is_overtime_yearly_hours eq 1>
		<cfabort>
	</cfif>
</cfif>
<cfquery name="get_" datasource="#dsn#" maxrows="1">
	SELECT
		EP.UPPER_POSITION_CODE,
		EP.UPPER_POSITION_CODE2
	FROM
		EMPLOYEE_POSITIONS EP
	WHERE
		EP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#EMPLOYEE_ID#"> AND
		EP.IS_MASTER = 1
</cfquery>

<cfquery name="add_worktime" datasource="#dsn#" result="MAX_ID">
	INSERT INTO
		EMPLOYEES_EXT_WORKTIMES
		(
		IS_PUANTAJ_OFF,
		EMPLOYEE_ID,
		WORK_START_TIME,
		WORK_END_TIME,
		START_TIME,
		END_TIME,
		DAY_TYPE,
		VALID_DETAIL,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP,
		IN_OUT_ID,
		PROCESS_STAGE,
		WORKTIME_WAGE_STATU,
		WORKING_SPACE
		)
	VALUES
		(
		<cfif isdefined("attributes.is_puantaj_off") and len(attributes.is_puantaj_off) and attributes.is_puantaj_off eq 1>1<cfelse>0</cfif>,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#employee_id#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#startdate#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#finishdate#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#startdate#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#finishdate#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.day_type#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.valid_detail#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">,
		<cfif isdefined("attributes.Shift_Status") and len(attributes.Shift_Status)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Shift_Status#"><cfelse>NULL</cfif>,
		<cfif isdefined("attributes.Working_Location") and len(attributes.Working_Location)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Working_Location#"><cfelse>NULL</cfif>

		)
</cfquery> 
<cfif listfirst(attributes.fuseaction,'.') is 'myhome'>
    <cfset EWT_ID_ = contentEncryptingandDecodingAES(isEncode:1,content:MAX_ID.IDENTITYCOL,accountKey:'wrk')>
<cfelse>
    <cfset EWT_ID_ = MAX_ID.IDENTITYCOL>
</cfif>
<cf_workcube_process 
			is_upd='1' 
			data_source='#dsn#' 
			old_process_line='0'
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#'
			action_table='EMPLOYEES_EXT_WORKTIMES'
			action_column='EWT_ID'
			action_id='#MAX_ID.IDENTITYCOL#'
			action_page='#request.self#?fuseaction=myhome.list_my_extra_times&event=upd&EWT_ID=#EWT_ID_#'
			warning_description='Fazla Mesai Talebi'>
<cf_wrk_get_history datasource="#dsn#" source_table="EMPLOYEES_EXT_WORKTIMES" target_table="EMPLOYEES_EXT_WORKTIMES_HISTORY" record_id= "#MAX_ID.IDENTITYCOL#" record_name="EWT_ID">
	
<!---  pdks kayıt  --->
<cfset pdks_working_inout_cmp = createObject("component","V16.hr.ehesap.cfc.pdks_working_inout")>
<cfif attributes.day_type eq 0><!--- Çalışma Günü --->
	<cfset working_type_ = '-1'>
<cfelseif attributes.day_type eq 1><!--- Hafta Tatili --->
	<cfset working_type_ = '-2'>
<cfelseif attributes.day_type eq 2><!--- Resmi Tatil --->
	<cfset working_type_ = '-3'>
<cfelse><!--- Gece Çalışması --->
	<cfset working_type_ = '-4'>
</cfif>
<cfset add_pdks_day = pdks_working_inout_cmp.add_pdks_day(
	employee_id : attributes.employee_id,
	in_out_id : attributes.in_out_id,
	branch_id : attributes.branch_id ,
	sal_year : year(startdate),
	sal_mon : month(startdate),
	day_ : day(startdate),
	offtimecat_id : working_type_,
	start_hour : start_hour,
	finish_hour : end_hour,
	start_min : start_min,
	finish_min : end_min
)>

<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=myhome.list_my_extra_times&event=upd&EWT_ID=#EWT_ID_#</cfoutput>";
</script>