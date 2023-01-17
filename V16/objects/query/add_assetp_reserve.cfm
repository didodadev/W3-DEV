<cf_date tarih="form.startdate">
<cf_date tarih="form.finishdate"> 
<cfif isdefined("session.ep.time_zone")>
	<cfset form.startdate = date_add("h", form.event_start_clock-session.ep.time_zone, form.startdate)>
<cfelseif isdefined("session.pp.time_zone")>
	<cfset form.startdate = date_add("h", form.event_start_clock-session.pp.time_zone, form.startdate)>
</cfif>
<cfset form.startdate = date_add("n", form.event_start_minute, form.startdate)>
<cfif isdefined("session.ep.time_zone") and isdefined("form.event_finish_clock")>
	<cfset form.finishdate = date_add("h", form.event_finish_clock-session.ep.time_zone, form.finishdate)>
<cfelseif isdefined("session.pp.time_zone") and isdefined("form.event_finish_clock")>
	<cfset form.finishdate = date_add("h", form.event_finish_clock-session.pp.time_zone, form.finishdate)>
</cfif>
<cfif isdefined("form.event_finish_minute")>
	<cfset form.finishdate = date_add("n", form.event_finish_minute, form.finishdate)>
</cfif>
<cfquery name="CHECK_1" datasource="#DSN#">
	SELECT
		ASSETP_ID
	FROM
		ASSET_P_RESERVE
	WHERE
		ASSETP_ID = #attributes.assetp_id# AND
		<cfif isdefined("form.finishdate")>
			RETURN_DATE BETWEEN #form.startdate# AND #form.finishdate#
		<cfelse>
			RETURN_DATE >= #form.startdate#
		</cfif>
</cfquery>
<cfquery name="CHECK" datasource="#DSN#">
	SELECT
		ASSETP_ID
	FROM
		ASSET_P_RESERVE
	WHERE
		ASSETP_ID = #attributes.assetp_id# AND
		(
			(
				STARTDATE < #form.startdate# AND
				FINISHDATE >= #form.startdate#
			)
			OR
			(
				STARTDATE = #form.startdate#
			)
			OR
			(
				STARTDATE > #form.startdate#
				<cfif isdefined("form.finishdate")>
					AND STARTDATE <= #form.finishdate#
				</cfif>
			)
		)
		<cfif isDefined("assetp_resid") and len(assetp_resid)>
		AND ASSETP_RESID <> #assetp_resid#
		</cfif>
</cfquery>

<cfif check_1.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1821.Lütfen Varlık Teslim Tarihinden Sonra Rezervasyon Yapınız'> !");
		history.back();
	</script>
	<cfabort>
<cfelseif check.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1822.Bu Aralıkta Kaynak Rezervasyon Çakışması Var'> !");
		history.back();
	</script>
<cfelse>
	<cfif isDefined("attributes.EVENT_ID")>
		<cfquery name="ADD_ASSETP_RESERVE" datasource="#DSN#">
			INSERT INTO 
				ASSET_P_RESERVE
			(
				ASSETP_ID,
				<cfif isDefined("attributes.event_id") and len(attributes.event_id)>EVENT_ID,</cfif>
				<cfif isDefined("attributes.class_id") and len(attributes.class_id)>CLASS_ID,</cfif>
				DETAIL,
				STARTDATE,
				FINISHDATE,
				STATUS,
				STAGE_ID,
				EMPLOYEE_ID,
				MULTIPLE,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP,
				UPDATE_DATE,
				UPDATE_EMP,
				UPDATE_IP
			)
			VALUES
			(
				#attributes.ASSETP_ID#,
				<cfif isDefined("attributes.EVENT_ID") and len(attributes.EVENT_ID)>#attributes.EVENT_ID#,</cfif>
				<cfif isDefined("attributes.CLASS_ID") and len(attributes.CLASS_ID)>#attributes.CLASS_ID#,</cfif>
				<cfif isdefined("attributes.detail") and len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.startdate")>#FORM.STARTDATE#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.finishdate")>#FORM.FINISHDATE#<cfelse>NULL</cfif>,
				1,
				#attributes.process_stage#,
				#attributes.employee_id#,
				<cfif isdefined("attributes.multiple") and attributes.multiple eq 1>1<cfelse>0</cfif>,
				#NOW()#,
				#SESSION.EP.USERID#,
				'#CGI.REMOTE_ADDR#',
				#NOW()#,
				#SESSION.EP.USERID#,
				'#CGI.REMOTE_ADDR#'
			)
			SELECT SCOPE_IDENTITY() AS [SCOPE_IDENTITY]
		</cfquery>
		<cf_workcube_process
			is_upd='1' 
			data_source='#dsn#'
			old_process_line='0'
			process_stage='#attributes.process_stage#'
			record_member='#session.ep.userid#'
			record_date='#now()#'
			action_table='ASSET_P_RESERVE'
			action_column='ASSETP_RESID'
			action_id='#ADD_ASSETP_RESERVE.SCOPE_IDENTITY#'
			action_page=''
			warning_description=''>
	<cfelseif isDefined("attributes.event_plan_id")><!--- Satış Planlamadan geliyorsa --->
		<cfquery name="ADD_ASSETP_RESERVE" datasource="#DSN#">
			INSERT INTO 
				ASSET_P_RESERVE
			(
				ASSETP_ID,
				<cfif isDefined("attributes.event_plan_id") and len(attributes.event_plan_id)>EVENT_PLAN_ID,</cfif>
				<cfif isDefined("attributes.class_id") and len(attributes.class_id)>CLASS_ID,</cfif>
				DETAIL,
				STARTDATE,
				FINISHDATE,
				STATUS,
				STAGE_ID,
				MULTIPLE,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP,
				UPDATE_DATE,
				UPDATE_EMP,
				UPDATE_IP
			)
			VALUES
			(
				#attributes.ASSETP_ID#,
				<cfif isDefined("attributes.event_plan_id") and len(attributes.event_plan_id)>#attributes.EVENT_PLAN_ID#,</cfif>
				<cfif isDefined("attributes.CLASS_ID") and len(attributes.CLASS_ID)>#attributes.CLASS_ID#,</cfif>
				<cfif isdefined("attributes.detail") and len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
				#FORM.STARTDATE#,
				#FORM.FINISHDATE#,
				1,
				#attributes.process_stage#,
				<cfif isdefined("attributes.multiple") and attributes.multiple eq 1>1<cfelse>0</cfif>,
				#NOW()#,
				#SESSION.EP.USERID#,
				'#CGI.REMOTE_ADDR#',
				#NOW()#,
				#SESSION.EP.USERID#,
				'#CGI.REMOTE_ADDR#'
			)
		</cfquery>
		<cfelseif isdefined("attributes.work_id")>
			<cfquery name="ADD_ASSETP_RESERVE" DATASOURCE="#DSN#">
				INSERT INTO 
					ASSET_P_RESERVE
				(
					ASSETP_ID,
					<cfif isDefined("attributes.work_id") and len(attributes.work_id)>WORK_ID,</cfif>
					DETAIL,
					STARTDATE,
					FINISHDATE,
					STATUS,
					STAGE_ID,
					MULTIPLE,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP,
					UPDATE_DATE,
					UPDATE_EMP,
					UPDATE_IP
				)
				VALUES
				(
					#attributes.ASSETP_ID#,
					<cfif isDefined("attributes.work_id") and len(attributes.work_id)>#attributes.work_id#,</cfif>
					<cfif isdefined("attributes.detail") and len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
					#FORM.STARTDATE#,
					#FORM.FINISHDATE#,
					1,
					#attributes.process_stage#,
					<cfif isdefined("attributes.multiple") and attributes.multiple eq 1>1<cfelse>0</cfif>,
					#NOW()#,
					#SESSION.EP.USERID#,
					'#CGI.REMOTE_ADDR#',
					#NOW()#,
					#SESSION.EP.USERID#,
					'#CGI.REMOTE_ADDR#'
					)
			</cfquery>
		<cfelseif isdefined("attributes.organization_id")>
			<cfquery name="ADD_ASSETP_RESERVE" DATASOURCE="#DSN#">
				INSERT INTO 
					ASSET_P_RESERVE
				(
					ASSETP_ID,
					<cfif isDefined("attributes.organization_id") and len(attributes.organization_id)>ORGANIZATION_ID,</cfif>
					DETAIL,
					STARTDATE,
					FINISHDATE,
					STATUS,
					STAGE_ID,
					MULTIPLE,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP,
					UPDATE_DATE,
					UPDATE_EMP,
					UPDATE_IP
				)
				VALUES
				(
					#attributes.ASSETP_ID#,
					<cfif isDefined("attributes.organization_id") and len(attributes.organization_id)>#attributes.organization_id#,</cfif>
					<cfif isdefined("attributes.detail") and len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
					#FORM.STARTDATE#,
					#FORM.FINISHDATE#,
					1,
					#attributes.process_stage#,
					<cfif isdefined("attributes.multiple") and attributes.multiple eq 1>1<cfelse>0</cfif>,
					#NOW()#,
					#SESSION.EP.USERID#,
					'#CGI.REMOTE_ADDR#',
					#NOW()#,
					#SESSION.EP.USERID#,
					'#CGI.REMOTE_ADDR#'
					)
			</cfquery>
		<cfelseif isdefined("attributes.class_id")>
			<cfquery name="ADD_ASSETP_RESERVE" DATASOURCE="#DSN#">
				INSERT INTO 
					ASSET_P_RESERVE
				(
					ASSETP_ID,
					<cfif isDefined("attributes.class_id") and len(attributes.class_id)>CLASS_ID,</cfif>
					DETAIL,
					STARTDATE,
					FINISHDATE,
					STATUS,
					STAGE_ID,
					MULTIPLE,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP,
					UPDATE_DATE,
					UPDATE_EMP,
					UPDATE_IP
				)
				VALUES
				(
					#attributes.ASSETP_ID#,
					<cfif isDefined("attributes.class_id") and len(attributes.class_id)>#attributes.class_id#,</cfif>
					<cfif isdefined("attributes.detail") and len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
					#FORM.STARTDATE#,
					#FORM.FINISHDATE#,
					1,
					#attributes.process_stage#,
					<cfif isdefined("attributes.multiple") and attributes.multiple eq 1>1<cfelse>0</cfif>,
					#NOW()#,
					#SESSION.EP.USERID#,
					'#CGI.REMOTE_ADDR#',
					#NOW()#,
					#SESSION.EP.USERID#,
					'#CGI.REMOTE_ADDR#'
					)
			</cfquery>
		<cfelse>
			<cfquery name="ADD_ASSETP_RESERVE" DATASOURCE="#DSN#">
				INSERT INTO 
					ASSET_P_RESERVE
				(
					ASSETP_ID,
					<cfif isDefined("attributes.PROJECT_ID") and len(attributes.PROJECT_ID)>PROJECT_ID,</cfif>
					<cfif isDefined("attributes.WORK_ID") and len(attributes.WORK_ID)>WORK_ID,</cfif>
					<cfif isDefined("attributes.PROD_ORDER_ID") and len(attributes.PROD_ORDER_ID)>PROD_ORDER_ID,</cfif>
					<cfif isDefined("attributes.CLASS_ID") and len(attributes.CLASS_ID)>CLASS_ID,</cfif>
					DETAIL,
					STARTDATE,
					FINISHDATE,
					STATUS,
					STAGE_ID,
					MULTIPLE,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP,
					UPDATE_DATE,
					UPDATE_EMP,
					UPDATE_IP,
					OUR_COMPANY_ID
				)
				VALUES
				(
					#attributes.ASSETP_ID#,
					<cfif isDefined("attributes.PROJECT_ID") and len(attributes.PROJECT_ID)>#attributes.PROJECT_ID#,</cfif>
					<cfif isDefined("attributes.WORK_ID") and len(attributes.WORK_ID)>#attributes.WORK_ID#,</cfif>
					<cfif isDefined("attributes.PROD_ORDER_ID") and len(attributes.PROD_ORDER_ID)>#attributes.PROD_ORDER_ID#,</cfif>
					<cfif isDefined("attributes.CLASS_ID") and len(attributes.CLASS_ID)>#attributes.CLASS_ID#,</cfif>
					<cfif isdefined("attributes.detail") and len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
					#FORM.STARTDATE#,
					#FORM.FINISHDATE#,
					1,
					#attributes.process_stage#,
					<cfif isdefined("attributes.multiple") and attributes.multiple eq 1>1<cfelse>0</cfif>,
					#NOW()#,
					#SESSION.EP.USERID#,
					'#CGI.REMOTE_ADDR#',
					#NOW()#,
					#SESSION.EP.USERID#,
					'#CGI.REMOTE_ADDR#',
					#SESSION.EP.COMPANY_ID#
				)
			</cfquery>
	</cfif>
</cfif>

<script type="text/javascript">
		<cfif isDefined('attributes.draggable') and attributes.draggable eq 1>
			location.href= document.referrer;
		<cfelse>
			window.close();
		</cfif>
</script>