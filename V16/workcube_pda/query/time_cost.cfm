<cfset Error_ = "">
<cfquery name="get_process_stage" datasource="#dsn#" maxrows="1">
    SELECT
        PTR.PROCESS_ROW_ID 
    FROM
        PROCESS_TYPE_ROWS PTR,
        PROCESS_TYPE_OUR_COMPANY PTO,
        PROCESS_TYPE PT
    WHERE
        PT.IS_ACTIVE = 1 AND
        PT.PROCESS_ID = PTR.PROCESS_ID AND
        PT.PROCESS_ID = PTO.PROCESS_ID AND
        PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
        PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%myhome.time_cost%">
    ORDER BY
        PTR.LINE_NUMBER
</cfquery>
<cfif isDefined("attributes.row_count") and Len(attributes.row_count)>
	<cfloop from="1" to="#attributes.row_count#" index="rc">
		<cfif (Evaluate("attributes.event_hour_#rc#")*60) + Evaluate("attributes.event_minute_#rc#") gt 0>
			<cfquery name="Get_Employee_Maliyet" datasource="#dsn#">
				SELECT EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME NAME_SURNAME,ISNULL(ON_MALIYET,0) ON_MALIYET, ISNULL(ON_HOUR,0) ON_HOUR, ISNULL(ON_HOUR_DAILY,0) ON_HOUR_DAILY FROM EMPLOYEE_POSITIONS WHERE IS_MASTER = 1 AND EMPLOYEE_ID = #Evaluate("attributes.employee_id_#rc#")#
			</cfquery>
			<cfif not Get_Employee_Maliyet.RecordCount or Get_Employee_Maliyet.On_Maliyet lte 0 or Get_Employee_Maliyet.On_Hour lte 0 or Get_Employee_Maliyet.On_Hour_Daily lte 0>
				<cfset Error_ = Error_ & Get_Employee_Maliyet.Name_Surname & "\n">
			</cfif>
		</cfif>
	</cfloop>
	<cfif Len(Error_)>
		<script type="text/javascript">
			alert("İnsan Kaynaklarından Çalışan Maliyeti Tanımlanmamış Çalışanlar Var! \n<cfoutput>#Error_#</cfoutput>");
			history.back();
		</script>
		<cfabort>
	</cfif>
	<cfquery name="get_in_out_id" datasource="#dsn#">
		SELECT 
			EIO.IN_OUT_ID,
			PUANTAJ_GROUP_IDS,
			BRANCH_ID
		FROM
			EMPLOYEES_IN_OUT EIO
		WHERE
			EIO.EMPLOYEE_ID = #session.ep.userid# AND 
			(
				(EIO.FINISH_DATE IS NULL AND EIO.START_DATE < #now()# )
				OR
				(
				EIO.FINISH_DATE >= #now()#
				)
			)
	</cfquery>
	<cfset attributes.sal_mon = MONTH(now())>
	<cfset attributes.sal_year = YEAR(now())>
	<cfset attributes.group_id = "">
	<cfif len(get_in_out_id.puantaj_group_ids)>
		<cfset attributes.group_id = "#get_in_out_id.PUANTAJ_GROUP_IDS#,">
	</cfif>
	<cfset attributes.branch_id = get_in_out_id.branch_id>
	<cfset not_kontrol_parameter = 1>
	<cfinclude template="../../hr/ehesap/query/get_program_parameter.cfm">
	<cfloop from="1" to="#attributes.row_count#" index="rc">
		<cfset event_date = Evaluate("attributes.event_date_#rc#")>
		<cfset expensed_minute = (Evaluate("attributes.event_hour_#rc#")*60) + Evaluate("attributes.event_minute_#rc#")>
		
		<cfif expensed_minute gt 0>
			<cfquery name="Get_Employee_Maliyet" datasource="#dsn#">
				SELECT ISNULL(ON_MALIYET,0) ON_MALIYET, ISNULL(ON_HOUR,0) ON_HOUR, ISNULL(ON_HOUR_DAILY,0) ON_HOUR_DAILY FROM EMPLOYEE_POSITIONS WHERE IS_MASTER = 1 AND EMPLOYEE_ID = #Evaluate("attributes.employee_id_#rc#")#
			</cfquery>
			<cfquery name="get_style" datasource="#dsn#">
				SELECT IS_TIME_STYLE FROM OUR_COMPANY_INFO WHERE COMP_ID = #session.pda.our_company_id#
			</cfquery>
			<cfif not len(get_style.IS_TIME_STYLE) or get_style.IS_TIME_STYLE eq 1><!--- haftalik kontrol --->
				<cfset salary_minute = Get_Employee_Maliyet.ON_MALIYET / Get_Employee_Maliyet.ON_HOUR / 60>
			<cfelseif get_style.IS_TIME_STYLE eq 2><!--- gunluk kontrol --->
				<cfset salary_minute = Get_Employee_Maliyet.ON_MALIYET / Get_Employee_Maliyet.ON_HOUR_DAILY / 60>
			</cfif>
			<cfset degerim = 1> <!--- Mesai Türü için --->
			<cfif Evaluate("attributes.overtime_type_#rc#") eq 1>
				<cfset degerim = 1>
			<cfelseif Evaluate("attributes.overtime_type_#rc#") eq 2>
				<cfset degerim = 1.5>
			<cfelse>
				<cfif Evaluate("attributes.overtime_type_#rc#") eq 3>
					<cfif isdefined("get_program_parameters.WEEKEND_MULTIPLIER") and len(get_program_parameters.WEEKEND_MULTIPLIER)>
						<cfset degerim = get_program_parameters.WEEKEND_MULTIPLIER>
					<cfelse>
						<cfset degerim = 1.5>
					</cfif>
				<cfelseif Evaluate("attributes.overtime_type_#rc#") eq 4>
					<cfif isdefined("get_program_parameters.OFFICIAL_MULTIPLIER") and len(get_program_parameters.OFFICIAL_MULTIPLIER)>
						<cfset degerim = get_program_parameters.OFFICIAL_MULTIPLIER>
					<cfelse>
						<cfset degerim = 2>
					</cfif>
				</cfif>
			</cfif>
			
			<cfset expensed_money = expensed_minute * salary_minute * degerim>
			<cfset total_time = expensed_minute/60>
			<cfif expensed_minute gt 1440><!--- 24 saat kontrolu --->
				<script type="text/javascript">
					alert("Bir Gün İçin Girilebilecek En Fazla Süre 24 Saattir!");
					history.back();
				</script>
				<cfabort>
			</cfif>
			<cf_date tarih="event_date">
			<cfquery name="Upd_Time_Cost" datasource="#dsn#">
				INSERT INTO
					TIME_COST
				(
						OUR_COMPANY_ID,
						TOTAL_TIME,
						EXPENSED_MONEY,
						EXPENSED_MINUTE,
						EMPLOYEE_ID,
						P_ORDER_RESULT_ID,
						COMMENT,
						EVENT_DATE,
						OVERTIME_TYPE,
						STATE,
                        TIME_COST_STAGE,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP
				)
				VALUES
				(
						#session.pda.our_company_id#,
						#wrk_round(total_time)#,
						#expensed_money#,
						#expensed_minute#,
						#Evaluate("attributes.employee_id_#rc#")#,
						<cfif Len(attributes.pr_order_id)>#attributes.pr_order_id#<cfelse>NULL</cfif>,
						<cfif Len(attributes.pr_order_number)>'#attributes.pr_order_number#'<cfelse>NULL</cfif>,
						#event_date#,
						<cfif Len(Evaluate("attributes.overtime_type_#rc#"))>#Evaluate("attributes.overtime_type_#rc#")#<cfelse>NULL</cfif>,
						1,
                        <cfif isdefined('get_process_stage.process_row_id') and len(get_process_stage.process_row_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_process_stage.process_row_id#"><cfelse>NULL</cfif>,
						#now()#,
						#session.pda.userid#,
						'#cgi.remote_addr#'
				)
			</cfquery>
		</cfif>
	</cfloop>
</cfif>
<script language="javascript" type="text/javascript">
	document.location.href = "<cfoutput>#request.self#?fuseaction=pda.time_cost&pr_order_id=#attributes.pr_order_id#</cfoutput>";
</script>
