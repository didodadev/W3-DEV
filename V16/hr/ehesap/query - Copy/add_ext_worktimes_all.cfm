
<!--- mesai eklenecek herkes için şirketler alınıp şirket saat kontrolleri yapılıyor--->
<cfset list_in_out_id="">
<cfloop from="1" to="#attributes.record_num#" index="i">
	<cfset list_in_out_id=listappend(list_in_out_id,#evaluate("attributes.employee_in_out_id#i#")#,',')>
</cfloop>
<cfif listlen(list_in_out_id) eq 0>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='54227.Mesai Eklenecek Kişi Girmelisiniz'>!");
		history.go(-1);
	</script>
	<cfabort>
</cfif>
<!--- BURAYA BAKILSIN.. YUNUS.. BURADA LISTSORT A İHTİYAÇ OLMAMALI GİBİ..  --->
<cfset list_in_out_id=listsort(list_in_out_id,'numeric')>
<cfquery name="get_employee_company" datasource="#dsn#">
	SELECT
		BRANCH.COMPANY_ID
	FROM
		BRANCH,
		EMPLOYEES_IN_OUT
	WHERE
		EMPLOYEES_IN_OUT.IN_OUT_ID IN (#list_in_out_id#) AND
		EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID
</cfquery>
<cfset comp_list="">
<cfset comp_list=listdeleteduplicates(valuelist(get_employee_company.company_id,','))>
<cfquery name="get_hours" datasource="#dsn#">
	SELECT
		OUR_COMPANY_HOURS.OCH_ID,
		OUR_COMPANY_HOURS.OUR_COMPANY_ID,
		OUR_COMPANY_HOURS.DAILY_WORK_HOURS,
		OUR_COMPANY_HOURS.SATURDAY_WORK_HOURS,
		OUR_COMPANY_HOURS.SSK_MONTHLY_WORK_HOURS,
		OUR_COMPANY_HOURS.SSK_WORK_HOURS,
		OUR_COMPANY_HOURS.UPDATE_DATE,
		OUR_COMPANY.NICK_NAME
	FROM
		OUR_COMPANY_HOURS,OUR_COMPANY
	WHERE
		OUR_COMPANY.COMP_ID = OUR_COMPANY_HOURS.OUR_COMPANY_ID
		AND OUR_COMPANY_HOURS.OUR_COMPANY_ID IN( #comp_list#)
</cfquery>
	<cfif get_hours.recordcount neq listlen(comp_list,',')>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='64571.Şirket SGK Çalışma Saatlerini Girmelisiniz'> !");
			window.close();
		</script>
		<cfabort>
	</cfif>
<!---saat kontroleri bitti--->

<cfset liste="">
<cftransaction>
<cfloop from="1" to="#attributes.record_num#" index="i">
	<cfif isdefined("attributes.row_kontrol_#i#") and evaluate("attributes.row_kontrol_#i#") neq 0 and len(evaluate("attributes.employee_id#i#"))>
		<cfif not isdefined("attributes.startdate#i#") or not len(evaluate("attributes.startdate#i#")) or not isdate(evaluate("attributes.startdate#i#"))>
			<cfset liste=listappend(liste,'#evaluate("attributes.employee#i#")# Mesai Tarihlerinde Hata Var!',',')>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='64620.Mesai Tarihlerinde Hata Var'>");
				window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.list_ext_worktimes&event=addMulti';
			</script>
		<cfelse>
			<cfset tarihim = evaluate("attributes.startdate#i#")>
			<cf_date tarih="tarihim">						
			<cfscript>
				attributes.employee_id = evaluate("attributes.employee_id#i#");
				attributes.employee_in_out_id = evaluate("attributes.employee_in_out_id#i#");
				attributes.day_type = evaluate("attributes.day_type#i#");
				attributes.shift_status = evaluate("attributes.shift_status#i#");
				attributes.process_stage = evaluate("attributes.process_stage#i#");
				attributes.Working_Location = evaluate("attributes.Working_Location#i#");
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
			<cfset attributes.sal_mon = month(startdate_)>
			<cfset attributes.sal_year = year(startdate_)>
			<cfif datecompare(finishdate,startdate) neq 1>
				<cfset liste=listappend(liste,'#evaluate("attributes.employee#i#")#<cf_get_lang dictionary_id="64620.Mesai Tarihlerinde Hata Var">!',',')>
				<script type="text/javascript">
					alert("<cf_get_lang dictionary_id='64620.Mesai Tarihlerinde Hata Var'>!");
					window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.list_ext_worktimes&event=addMulti';
				</script>
				<cfabort>
			<cfelse>
				<cfquery name="get_employee_company" datasource="#dsn#">
					SELECT
						BRANCH.COMPANY_ID,
						PUANTAJ_GROUP_IDS,
						BRANCH.BRANCH_ID
					FROM
						BRANCH,
						EMPLOYEES_IN_OUT
					WHERE
						EMPLOYEES_IN_OUT.IN_OUT_ID = #attributes.employee_in_out_id# AND
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
					<cfquery name="get_hours1" dbtype="query">
						SELECT
							OCH_ID,
							OUR_COMPANY_ID,
							DAILY_WORK_HOURS,
							SATURDAY_WORK_HOURS,
							SSK_MONTHLY_WORK_HOURS,
							SSK_WORK_HOURS,
							UPDATE_DATE,
							NICK_NAME
						FROM
							get_hours
						WHERE
							OUR_COMPANY_ID=#get_employee_company.COMPANY_ID#
					</cfquery>
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
							START_TIME >= #startdate_# AND
							END_TIME < #DATEADD("d", 1, startdate_)# AND
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
						<cfset ext_time_limit = ext_time_limit + (get_hours1.daily_work_hours*60)>
					</cfif>
				
					<cfif len(GET_DAILY_EXT_TIME.TOTAL_MIN)>
						<cfset total_mesai = total_mesai + GET_DAILY_EXT_TIME.TOTAL_MIN>
					</cfif>
					<cfif total_mesai gt ext_time_limit>
						<cfset liste=listappend(liste,'#evaluate("attributes.employee#i#")# Günlük Kanuni Mesai Limitini (#get_program_parameters.overtime_hours# saat) Aştınız !',',')>
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
							START_TIME >= #createdate(session.ep.period_year,1,1)# AND
							END_TIME < #DATEADD("y",1,createdate(session.ep.period_year,1,1))# AND
							EMPLOYEE_ID=#attributes.employee_id#
					</cfquery>
					<cfset ext_time_limit = overTime*60>
					<cfset total_mesai = (end_hour - start_hour)*60 + (end_min - start_min)>
					<cfif attributes.day_type eq 1><!--- hafta sonu --->
						<cfset ext_time_limit = ext_time_limit + (get_hours1.daily_work_hours*60)>
					</cfif>
					<cfif len(GET_YEARLY_EXT_TIME.total_min)>
						<cfset total_mesai = total_mesai + GET_YEARLY_EXT_TIME.total_min>
					</cfif>
					<cfif total_mesai gt ext_time_limit>
						<cfset liste=listappend(liste,'#evaluate("attributes.employee#i#")# <cf_get_lang dictionary_id="64622.Yıllık Kanuni Mesai Limitini"> (#get_program_parameters.OVERTIME_YEARLY_HOURS# <cf_get_lang dictionary_id="57491.Saat">) <cf_get_lang dictionary_id="64623.Aştınız">!',',')>
					</cfif>
					<cfquery name="add_worktime" datasource="#dsn#">
						INSERT INTO
							EMPLOYEES_EXT_WORKTIMES
							(
							EMPLOYEE_ID,
							WORK_START_TIME,
							WORK_END_TIME,
							START_TIME,
							END_TIME,
							DAY_TYPE,
							IN_OUT_ID,
							RECORD_DATE,
							RECORD_EMP,
							RECORD_IP,
							IS_PUANTAJ_OFF,
							WORKTIME_WAGE_STATU,
							PROCESS_STAGE,
							WORKING_SPACE
							)
						VALUES
							(
							#ATTRIBUTES.EMPLOYEE_ID#,
							#startdate#,
							#finishdate#,
							#startdate#,
							#finishdate#,
							#attributes.day_type#,
							#attributes.employee_in_out_id#,
							#now()#,
							#session.ep.userid#,
							'#cgi.REMOTE_ADDR#',
							<cfif isdefined('attributes.is_puantaj_off') and len(attributes.is_puantaj_off)>1<cfelse>0</cfif>,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Shift_Status#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">,
							<cfif isdefined("attributes.Working_Location") and len(attributes.Working_Location)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Working_Location#"><cfelse>NULL</cfif>
							)
					</cfquery>
				<cfelse>
					<cfset liste=listappend(liste,'#evaluate("attributes.employee#i#")#  <cf_get_lang dictionary_id="64621.Çalışanın Giriş Çıkış Kaydı Yok! Kayıt Yapılamadı">!',',')>
				</cfif>	
			</cfif>
		</cfif>
	</cfif>
</cfloop>
</cftransaction>

<!--- <cfif listlen(liste,',')> --->
<cfoutput>
	<cfloop list="#liste#" index="i" delimiters=",">
		#i#<br/>
	</cfloop>
</cfoutput>
<form name="form_kapat" method="post">
	<input type="button" value="Kapat" onClick="kapat();">
</form>
<!--- <cfelse> --->
 	<script type="text/javascript">
		window.location.href="<cfoutput>#request.self#?fuseaction=ehesap.list_ext_worktimes</cfoutput>";
	</script>
<!--- </cfif>
 --->
<script type="text/javascript">
 function kapat()
	{
		window.location.href="<cfoutput>#request.self#?fuseaction=ehesap.list_ext_worktimes</cfoutput>";
	}
</script>
