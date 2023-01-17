<cf_date tarih = "attributes.startdate">
<cf_date tarih = "attributes.finishdate">

<cfset startdate_ = date_add('n',attributes.start_minute,attributes.startdate)>
<cfset startdate_ = date_add('h',attributes.start_hour,startdate_)>
<cfset finishdate_ = date_add('n',attributes.finish_min,attributes.finishdate)>
<cfset finishdate_ = date_add('h',attributes.finish_hour,finishdate_)>

<CFTRANSACTION>
<cfif listfirst(attributes.fuseaction,'.') is 'hr'>
	<cfquery name="add_emp_daily_in_out" datasource="#dsn#">
		INSERT INTO
			EMPLOYEE_DAILY_IN_OUT
			(
				EMPLOYEE_ID,
				IN_OUT_ID,
				BRANCH_ID,
				IS_WEEK_REST_DAY,
				DETAIL,
				START_DATE,
				FINISH_DATE,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
		VALUES
			(
				#attributes.employee_id#,
				<cfif len(attributes.in_out_id)>#attributes.in_out_id#,<cfelse>NULL,</cfif>
				<cfif len(attributes.branch_id)>#attributes.branch_id#,<cfelse>NULL,</cfif>
				<cfif Len(attributes.is_week_rest_day)>#attributes.is_week_rest_day#<cfelse>NULL</cfif>,
				'#attributes.detail#',
				<cfif len(startdate_)>#startdate_#,<cfelse>NULL,</cfif>
				<cfif len(finishdate_)>#finishdate_#,<cfelse>NULL,</cfif>
				#now()#,
				#session.ep.userid#,
				'#cgi.remote_addr#'
			)
	</cfquery>
<cfelse>
	<cfquery name="add_emp_daily_in_out" datasource="#dsn#">
		INSERT INTO
			EMPLOYEE_DAILY_IN_OUT
			(
				PARTNER_ID,
				IS_WEEK_REST_DAY,
				DETAIL,
				START_DATE,
				FINISH_DATE,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
		VALUES
			(
				#attributes.partner_id#,
				<cfif Len(attributes.is_week_rest_day)>#attributes.is_week_rest_day#<cfelse>NULL</cfif>,
				<cfif len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
				<cfif len(startdate_)>#startdate_#,<cfelse>NULL,</cfif>
				<cfif len(finishdate_)>#finishdate_#,<cfelse>NULL,</cfif>
				#now()#,
				#session.ep.userid#,
				'#cgi.remote_addr#'
			)
	</cfquery>
</cfif>
	<cfquery name="LAST_ID" datasource="#DSN#">
		SELECT MAX(ROW_ID) AS LATEST_RECORD_ID FROM EMPLOYEE_DAILY_IN_OUT
	</cfquery>
    <cf_wrk_get_history datasource="#dsn#" source_table="EMPLOYEE_DAILY_IN_OUT" target_table="EMPLOYEE_DAILY_IN_OUT_HISTORY" record_id= "#LAST_ID.LATEST_RECORD_ID#" record_name="ROW_ID">
</CFTRANSACTION>
	

<cfquery name="get_imports_all" datasource="#dsn#">
	SELECT
		EIO.IN_OUT_ID,
		SS.START_HOUR,
		SS.START_MIN,
		SS.END_HOUR,
		SS.END_MIN,
		<cfif database_type is "MSSQL">
			SUM(DATEDIFF(MINUTE,EIO.START_DATE,EIO.FINISH_DATE)) AS TOTAL_MIN
		<cfelseif database_type is "DB2">
			SUM(SECONDSDIFF(EIO.FINISH_DATE,EIO.START_DATE))/60 AS TOTAL_MIN
		</cfif>
	FROM 
		EMPLOYEE_DAILY_IN_OUT EIO,
		EMPLOYEES_IN_OUT EI,
		SETUP_SHIFTS SS
	WHERE 
		EIO.ROW_ID = #LAST_ID.LATEST_RECORD_ID# AND
		EIO.FINISH_DATE IS NOT NULL AND
		EIO.FILE_ID IS NULL AND
		EIO.IN_OUT_ID = EI.IN_OUT_ID AND
		EI.SHIFT_ID = SS.SHIFT_ID
	GROUP BY
		EIO.IN_OUT_ID,
		SS.START_HOUR,
		SS.START_MIN,
		SS.END_HOUR,
		SS.END_MIN
</cfquery>

<cfoutput query="get_imports_all">
	<cfquery name="get_" datasource="#dsn#" maxrows="1">
		SELECT 
			EIO.START_DATE,
			EIO.EMPLOYEE_ID,
			EIO.IN_OUT_ID,
			EP.UPPER_POSITION_CODE,
			EP.UPPER_POSITION_CODE2
		FROM 
			EMPLOYEE_DAILY_IN_OUT EIO,
			EMPLOYEE_POSITIONS EP
		WHERE 
			EIO.ROW_ID = #LAST_ID.LATEST_RECORD_ID# AND
			EIO.IN_OUT_ID = #IN_OUT_ID# AND
			EP.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND
			EP.IS_MASTER = 1
	</cfquery>
	<cfset date_1 = createdatetime(2007,1,1,START_HOUR,START_MIN,0)>
	<cfset date_2 = createdatetime(2007,1,1,END_HOUR,END_MIN,0)>
	<cfset fark_ = datediff("n",date_1,date_2)>
	<cfif TOTAL_MIN gt fark_>
		<cfset new_date_ = createdatetime(year(get_.START_DATE),month(get_.START_DATE),day(get_.START_DATE),END_HOUR,END_MIN,0)>
		<cfquery name="add_" datasource="#dsn#">
			INSERT INTO
				EMPLOYEES_EXT_WORKTIMES
					(
					IS_FROM_PDKS,
					EMPLOYEE_ID,
					IN_OUT_ID,
					DAY_TYPE,
					VALIDATOR_POSITION_CODE_1,
					VALIDATOR_POSITION_CODE_2,
					START_TIME,
					END_TIME,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
					)
					VALUES
					(
					1,
					#get_.employee_id#,
					#get_.in_out_id#,
					0,
					<cfif len(get_.UPPER_POSITION_CODE)>#get_.UPPER_POSITION_CODE#,<cfelse>NULL,</cfif>
					<cfif len(get_.UPPER_POSITION_CODE2)>#get_.UPPER_POSITION_CODE2#,<cfelse>NULL,</cfif>
					#createodbcdatetime(new_date_)#,
					#createodbcdatetime(date_add("n",TOTAL_MIN-fark_,new_date_))#,
					#now()#,
					#session.ep.userid#,
					'#cgi.REMOTE_ADDR#'
					)
		</cfquery>	
	</cfif>
</cfoutput>
<cfset attributes.actionId = LAST_ID.LATEST_RECORD_ID>
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=hr.list_emp_daily_in_out_row&event=upd&ROW_ID=#attributes.actionId#</cfoutput>';
</script>
