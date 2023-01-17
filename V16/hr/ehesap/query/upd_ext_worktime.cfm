<cf_date tarih="startdate">
<cf_date tarih="attributes.work_startdate">
<cfscript>
	startdate_ = startdate;
	startdate = date_add('h',start_hour, startdate);
	startdate = date_add('n',start_min, startdate);
	finishdate = date_add('h',end_hour, startdate_);
	finishdate = date_add('n',end_min, finishdate);
	
	work_startdate_ = attributes.work_startdate;
	attributes.work_startdate = date_add('h',start_hour,attributes.work_startdate);
	attributes.work_startdate = date_add('n',start_min,attributes.work_startdate);
	
	attributes.work_finishdate = date_add('h',end_hour, work_startdate_);
	attributes.work_finishdate = date_add('n',end_min, attributes.work_finishdate);
	work_finishdate = attributes.work_finishdate;
	work_startdate = attributes.work_startdate;

	start_hour_format = timeformat('#start_hour#:#start_min#',timeformat_style);
	end_hour_format =  timeformat('#end_hour#:#end_min#',timeformat_style);
</cfscript>
<!---  --->
<cfquery name="IS_EXTRA_WORK_TIME_EQUAL" datasource="#DSN#">	<!--- CH --->
	SELECT 
		* 
	FROM
		 EMPLOYEES_EXT_WORKTIMES
	WHERE
		EMPLOYEE_ID = #attributes.employee_id# AND
		EWT_ID != #EWT_ID# AND
		IN_OUT_ID = #attributes.in_out_id# AND
		(ISNULL(VALID,2) > 0)
		AND
		(
			(WORK_START_TIME <= #work_startdate# AND 
			WORK_END_TIME >= #work_startdate#)
			OR
			(WORK_START_TIME <= #work_finishdate# AND 
			WORK_END_TIME >= #work_finishdate#)
			OR
			(WORK_START_TIME <= #work_startdate# AND WORK_END_TIME >= #work_finishdate#)
			OR
			(WORK_START_TIME >= #work_startdate# AND WORK_START_TIME <= #work_finishdate#)
		)
</cfquery>
<cfif IS_EXTRA_WORK_TIME_EQUAL.recordcount>
	<script type="text/javascript">
		alert('Aynı Zaman Dilimleri İçersinde Birden çok Fazla Mesai Tanımlanamaz!');
		history.back();
	</script>
	<cfabort>
</cfif>
<!---  --->

<!--- ic 20050924
add'inde ve update'inde artik tarihler uzerinden degil formdan gelen in_out_id uzerinden
company sorgulaniyor, sonuc gelmiyorsa uyariyor. uyari da degisti, giris-cikis eksik diye uyariyordu ancak artik giris cikis
eksikse zaten adam secilemeyecek --->
<cfquery name="get_employee_company" datasource="#dsn#">
	SELECT
		BRANCH.COMPANY_ID,
		PUANTAJ_GROUP_IDS,
		BRANCH.BRANCH_ID
	FROM
		BRANCH,
		EMPLOYEES_IN_OUT
	WHERE
		EMPLOYEES_IN_OUT.IN_OUT_ID = #attributes.in_out_id# AND
		EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID
</cfquery>
<cfset attributes.our_company_id = get_employee_company.COMPANY_ID>
<cfinclude template="get_hours.cfm">
<cfif not(get_hours.recordcount)>
	<script type="text/javascript">
		alert("Şirket SSK Çalışma Saatlerini Girmelisiniz !");
		window.close();
	</script>
	<cfabort>
</cfif>
<!--- Fazla Mesai Kontrol Esma R. Uysal ---->
<cfif attributes.fuseaction is 'myhome.list_my_extra_times'>
	<cfset EWT_ID_ = contentEncryptingandDecodingAES(isEncode:1,content:attributes.EWT_ID,accountKey:'wrk')>
	<cfset hr= "myhome.list_my_extra_times&event=upd&EWT_ID=#EWT_ID_#">
<cfelse>
	<cfset hr= "ehesap.list_ext_worktimes&event=upd&EWT_ID=#attributes.EWT_ID#">
</cfif> 
<cfinclude template="extra_worktimes_control.cfm">

<cfset attributes.sal_mon = month(startdate)>
<cfset attributes.sal_year = year(startdate)>
<cfset attributes.group_id = "">
<cfif len(get_employee_company.puantaj_group_ids)>
	<cfset attributes.group_id = "#get_employee_company.PUANTAJ_GROUP_IDS#,">
</cfif>
<cfset attributes.branch_id = get_employee_company.branch_id>
<cfset not_kontrol_parameter = 1>
<cfinclude template="../query/get_program_parameter.cfm">

<cfquery name="GET_DAILY_EXT_TIME" datasource="#dsn#">
	SELECT
	<cfif database_type is "MSSQL">
		SUM(DATEDIFF(minute, WORK_START_TIME, WORK_END_TIME)) AS TOTAL_MIN
	<cfelseif database_type is "DB2">
		SUM(SECONDSDIFF(WORK_END_TIME,WORK_START_TIME))/60 AS TOTAL_MIN
	</cfif>
	FROM
		EMPLOYEES_EXT_WORKTIMES
	WHERE
		WORK_START_TIME >= #work_startdate_#
		AND
		WORK_END_TIME < #DATEADD("d", 1, work_startdate_)#
		AND
		EWT_ID <> #EWT_ID#
		AND
		EMPLOYEE_ID = #attributes.employee_id#
		AND ISNULL(VALID,2) > 0
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
			alert("Günlük Kanuni Mesai Limitini (<cfoutput>#get_program_parameters.overtime_hours#</cfoutput> saat) Aşamazsınız !");
		</script>
	</cfif>
</cfif>

<cfquery name="GET_YEARLY_EXT_TIME" datasource="#dsn#">
	SELECT
	<cfif database_type is "MSSQL">
		SUM(DATEDIFF(minute, WORK_START_TIME, WORK_END_TIME)) AS TOTAL_MIN2
	<cfelseif database_type is "DB2">
		SUM(SECONDSDIFF(WORK_END_TIME,WORK_START_TIME))/60 AS TOTAL_MIN2
	</cfif>
	FROM
		EMPLOYEES_EXT_WORKTIMES
	WHERE
		EWT_ID <> #EWT_ID#
		AND
		WORK_START_TIME > #createodbcdatetime(createdate(session.ep.period_year,1,1))#
		AND
		WORK_END_TIME < #createodbcdatetime(createdate(session.ep.period_year+1,1,1))#
		AND
		EMPLOYEE_ID = #attributes.employee_id#
		AND
		ISNULL(VALID,2) > 0
</cfquery>
<cfset get_fuseaction_property = createObject("component","V16.objects.cfc.fuseaction_properties")>
<cfset get_prop = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'ehesap.list_ext_worktimes',
    property_name : 'is_overtime_yearly_hours'
    )>
<cfset is_overtime_yearly_hours = get_prop.PROPERTY_VALUE>
<cfset ext_time_limit = get_program_parameters.OVERTIME_YEARLY_HOURS*60>
<cfset total_mesai = (end_hour - start_hour) * 60 + (end_min - start_min)>

<cfif attributes.day_type eq 1><!--- hafta sonu --->
	<cfset ext_time_limit = ext_time_limit + (get_hours.daily_work_hours*60)>
<cfelseif attributes.day_type eq 3><!--- Gece Çalışması --->
	<cfset ext_time_limit = ext_time_limit + (get_hours.daily_work_hours*60)>
</cfif>

<cfif len(GET_YEARLY_EXT_TIME.TOTAL_MIN2)>
	<cfset total_mesai = total_mesai + GET_YEARLY_EXT_TIME.total_min2>
</cfif>

<cfif total_mesai gt ext_time_limit>
	<script type="text/javascript">
		alert("Yıllık Kanuni Mesai Limitini (<cfoutput>#get_program_parameters.OVERTIME_YEARLY_HOURS#</cfoutput> saat) Aşamazsınız !");
		<cfif is_overtime_yearly_hours eq 1>
			history.back();
		</cfif>
	</script>
	<cfif is_overtime_yearly_hours eq 1>
		<cfabort>
	</cfif>
</cfif>

<cfquery name="upd_worktime" datasource="#dsn#">
	UPDATE
		EMPLOYEES_EXT_WORKTIMES
	SET
        IS_PUANTAJ_OFF = <cfif isdefined("attributes.IS_PUANTAJ_OFF") and attributes.Shift_Status eq 1>1,<cfelse>0,</cfif>
		VALID_DETAIL = '#attributes.valid_detail#',
		EMPLOYEE_ID = #EMPLOYEE_ID#,
		START_TIME = #startdate#,
		END_TIME = #finishdate#,
		WORK_START_TIME = #attributes.work_startdate#,
		WORK_END_TIME = #attributes.work_finishdate#,
		DAY_TYPE = #attributes.DAY_TYPE#,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.REMOTE_ADDR#',
		IN_OUT_ID = #attributes.in_out_id#,
		PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">,
		WORKTIME_WAGE_STATU = <cfif isdefined("attributes.Shift_Status") and len(attributes.Shift_Status)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Shift_Status#"><cfelse>NULL</cfif>,
		WORKING_SPACE = <cfif isdefined("attributes.Working_Location") and len(attributes.Working_Location)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Working_Location#"><cfelse>NULL</cfif>
	WHERE
		EWT_ID = #EWT_ID#
</cfquery>
<cf_wrk_get_history datasource="#dsn#" source_table="EMPLOYEES_EXT_WORKTIMES" target_table="EMPLOYEES_EXT_WORKTIMES_HISTORY" record_id="#EWT_ID#" record_name="EWT_ID">
<cf_workcube_process 
	is_upd='1' 
	data_source='#dsn#' 
	old_process_line='#attributes.old_process_line#'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#' 
	record_date='#now()#'
	action_table='EMPLOYEES_EXT_WORKTIMES'
	action_column='EWT_ID'
	action_id='#attributes.EWT_ID#'
	action_page='#request.self#?fuseaction=#hr#'
	warning_description='Fazla Mesai Talebi'>
	
<!---  pdks kayıt  --->
<cfset pdks_working_inout_cmp = createObject("component","V16.hr.ehesap.cfc.pdks_working_inout")>
<cfif attributes.day_type eq 0><!--- Çalışma Günü --->
	<cfset working_type_ = '-1'>
<cfelseif attributes.day_type eq 1><!--- Hafta Tatili --->
	<cfset working_type_ = '-2'>
<cfelseif attributes.day_type eq 2><!--- Resmi Tatil --->
	<cfset working_type_ = '-3'>
<cfelseif attributes.day_type eq 3><!--- Gece Çalışması --->
	<cfset working_type_ = '-4'>
<cfelseif attributes.day_type eq -8><!--- Fazla Mesai  / Hafta Tatili - Gün --->
	<cfset working_type_ = '-8'>
<cfelseif attributes.day_type eq -9><!--- Fazla Mesai / Akdi Tatil - Gün	 --->
	<cfset working_type_ = '-9'>
<cfelseif attributes.day_type eq -10><!--- Fazla Mesai /Resmi Tatil Gün  --->
	<cfset working_type_ = '-10'>
<cfelseif attributes.day_type eq -11><!---Fazla Mesai /Arefe Tatil Gün   --->
	<cfset working_type_ = '-11'>
<cfelseif attributes.day_type eq -12><!---Fazla Mesai /Dini Bayram Gün   --->	
	<cfset working_type_ = '-12'>
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
window.location.href="<cfoutput>#request.self#?fuseaction=#hr#</cfoutput>";
</script> 
