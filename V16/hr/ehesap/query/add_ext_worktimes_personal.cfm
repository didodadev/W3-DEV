<cfif not isdefined("attributes.record_sayisi") or not len(attributes.in_out_id)>
	<script type="text/javascript">
		alert('Kişi Seçme İşleminde Bir Problem Oluştu! Lütfen Tekrar Deneyiniz.');
		window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.list_ext_worktimes&event=addMultiSingle';
	</script>
</cfif>

<cfloop from="1" to="#attributes.record_sayisi#" index="i">
	<cfif evaluate("attributes.row_kontrol_#i#") neq 0>	
		<cfif not isdefined("attributes.startdate#i#") or not len(evaluate("attributes.startdate#i#")) or not isdate(evaluate("attributes.startdate#i#"))>
			<script type="text/javascript">
				alert("Mesai Tarihlerinde Hata Var!");
				window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.list_ext_worktimes&event=addMultiSingle';
			</script>
			<cfabort>
		<cfelse>
			<cfset tarihim = evaluate("attributes.startdate#i#")>
			<CF_DATE tarih="tarihim">						
			<cfscript>
				attributes.day_type = evaluate("attributes.day_type#i#");
				attributes.shift_status = evaluate("attributes.shift_status#i#");
				attributes.process_stage = evaluate("attributes.process_stage#i#");
				start_hour = evaluate("attributes.start_hour#i#");
				start_min = evaluate("attributes.start_min#i#");
				end_hour = evaluate("attributes.end_hour#i#");
				end_min = evaluate("attributes.end_min#i#");
				startdate_ = tarihim;
				startdate = date_add('h', start_hour, startdate_);
				startdate = date_add('n', start_min, startdate);
				finishdate = date_add('h', end_hour, startdate_);
				finishdate = date_add('n', end_min, finishdate);
			</cfscript>
			<cfif datecompare(finishdate,startdate) neq 1>
				<script type="text/javascript">
					alert("Mesai Tarihlerinde Hata Var!");
					window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.list_ext_worktimes&event=addMultiSingle';
				</script>
				<cfabort>
			</cfif>										
		</cfif>
	</cfif>
</cfloop>

<cflock name="#CreateUUID()#" timeout="30">
<cftransaction>
	<cfloop from="1" to="#attributes.record_sayisi#" index="i">
		<cfif evaluate("attributes.row_kontrol_#i#") neq 0>						
			<cfset tarihim = evaluate("attributes.startdate#i#")>
			<cf_date tarih="tarihim">			
			<cfset attributes.sal_mon = month(tarihim)>
			<cfset attributes.sal_year = year(tarihim)>
			<cfscript>
				attributes.day_type = evaluate("attributes.day_type#i#");
				attributes.shift_status = evaluate("attributes.shift_status#i#");
				attributes.process_stage = evaluate("attributes.process_stage#i#");
				start_hour = evaluate("attributes.start_hour#i#");
				start_min = evaluate("attributes.start_min#i#");
				end_hour = evaluate("attributes.end_hour#i#");
				end_min = evaluate("attributes.end_min#i#");
				startdate_ = tarihim;
				startdate = date_add('h', start_hour, startdate_);
				startdate = date_add('n', start_min, startdate);
				finishdate = date_add('h', end_hour, startdate_);
				finishdate = date_add('n', end_min, finishdate);
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
					EMPLOYEES_IN_OUT.IN_OUT_ID = #attributes.in_out_id# AND
					EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID
			</cfquery>
			<cfif get_employee_company.recordcount>
				<cfset attributes.group_id = "">
				<cfif len(get_employee_company.puantaj_group_ids)>
					<cfset attributes.group_id = "#get_employee_company.PUANTAJ_GROUP_IDS#,">
				</cfif>
				<cfset attributes.branch_id = get_employee_company.branch_id>
				<cfset not_kontrol_parameter = 1>
				<cfinclude template="get_program_parameter.cfm">
				<cfset ATTRIBUTES.OUR_COMPANY_ID = get_employee_company.COMPANY_ID>
				<cfinclude template="get_hours.cfm">
			<cfelse>
				<script type="text/javascript">
					alert("Şirket SGK Çalışma Saatleri Eksik  ve/veya Çalışanın Giriş Çıkış Kaydı Yok !");
					window.close();
				</script>
				<cfabort>
			</cfif>
			
			<cfquery name="GET_DAILY_EXT_TIME" datasource="#dsn#">
				SELECT
				<cfif database_type is "MSSQL">
					SUM(DATEDIFF(MINUTE, START_TIME, END_TIME)) AS TOTAL_MIN
				<cfelseif database_type is "DB2">
					SUM(SECONDSDIFF(END_TIME,START_TIME))/60 AS TOTAL_MIN
				</cfif>
				FROM
					EMPLOYEES_EXT_WORKTIMES
				WHERE
					START_TIME >= #STARTDATE_# AND
					END_TIME <  #DATEADD("d",1, STARTDATE_)# AND
					EMPLOYEE_ID=#attributes.employee_id#
			</cfquery>
			
			<cfset total_mesai = (end_hour - start_hour)*60 + (end_min - start_min)>
			<cfif get_program_parameters.recordcount>
				<cfset overTime = get_program_parameters.overtime_hours>
			<cfelse>
				<cfset overTime = 0>
			</cfif>
			<cfset ext_time_limit = overTime*60>
			<cfif attributes.day_type eq 1><!--- hafta sonu --->
				<cfset ext_time_limit = ext_time_limit + (get_hours.daily_work_hours*60)>
			</cfif>
			
			<cfif len(GET_DAILY_EXT_TIME.TOTAL_MIN)>
				<cfset total_mesai = total_mesai + GET_DAILY_EXT_TIME.TOTAL_MIN>
			</cfif>
			
			<cfif total_mesai gt ext_time_limit>
				<script type="text/javascript">
					alert("Günlük Kanuni Mesai Limitini (<cfoutput>#get_program_parameters.overtime_hours#</cfoutput> saat) Aştınız !");
				</script>
			</cfif>
			
			<cfquery name="GET_YEARLY_EXT_TIME" datasource="#dsn#">
				SELECT
				<cfif database_type is "MSSQL">
					SUM(DATEDIFF(MINUTE, START_TIME, END_TIME)) AS TOTAL_MIN
				<cfelseif database_type is "DB2">
					SUM(SECONDSDIFF(END_TIME,START_TIME))/60 AS TOTAL_MIN
				</cfif>
				FROM
					EMPLOYEES_EXT_WORKTIMES
				WHERE
					START_TIME >= #createdate(session.ep.period_year,1,1)#
					AND END_TIME < #DATEADD("y",1,createdate(session.ep.period_year,1,1))#
					AND EMPLOYEE_ID=#attributes.employee_id#
			</cfquery>
			
			<cfset ext_time_limit = overTime*60>
			
			<cfset total_mesai = (end_hour - start_hour)*60 + (end_min - start_min)>
			
			<cfif attributes.day_type eq 1><!--- hafta sonu --->
				<cfset ext_time_limit = ext_time_limit + (get_hours.daily_work_hours*60)>
			</cfif>
			
			<cfif len(GET_YEARLY_EXT_TIME.total_min)>
				<cfset total_mesai = total_mesai + GET_YEARLY_EXT_TIME.total_min>
			</cfif>
			
			<cfif total_mesai gt ext_time_limit>
				<script type="text/javascript">
					alert("Yıllık Kanuni Mesai Limitini (<cfoutput>#get_program_parameters.OVERTIME_YEARLY_HOURS#</cfoutput> saat) Aştınız !");
				</script>
			</cfif>
			
			<cfquery name="add_worktime" datasource="#dsn#" result="MAX_ID">
				INSERT INTO
					EMPLOYEES_EXT_WORKTIMES
					(
					EMPLOYEE_ID,
					WORK_START_TIME,
					WORK_END_TIME,
					START_TIME,
					END_TIME,
					DAY_TYPE,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP,
					IN_OUT_ID,
					IS_PUANTAJ_OFF,
					WORKTIME_WAGE_STATU,
					PROCESS_STAGE
					)
				VALUES
					(
					#EMPLOYEE_ID#,
					#startdate#,
					#finishdate#,
					#startdate#,
					#finishdate#,
					#attributes.day_type#,
					#now()#,
					#session.ep.userid#,
					'#cgi.REMOTE_ADDR#',
					#attributes.in_out_id#,
					<cfif isdefined('attributes.is_puantaj_off') and len(attributes.is_puantaj_off)>1<cfelse>0</cfif>,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Shift_Status#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
					)
			</cfquery>
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
				action_page='#request.self#?fuseaction=ehesap.list_ext_worktimes&event=upd&EWT_ID=#MAX_ID.IDENTITYCOL#'
				warning_description='Fazla Mesai Talebi'>
		</cfif>
	</cfloop>
</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=ehesap.list_ext_worktimes</cfoutput>";
</script>
