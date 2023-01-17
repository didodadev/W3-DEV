<cf_date tarih="attributes.start_date">
<cf_date tarih="attributes.finish_date">
<cfset attributes.start_date = date_add('h', form.event_start_clock - session.ep.time_zone, attributes.start_date)>
<cfset attributes.start_date = date_add('n', form.event_start_minute, attributes.start_date)>
<cfset attributes.finish_date = date_add('h', form.event_finish_clock - session.ep.time_zone, attributes.finish_date)>
<cfset attributes.finish_date = date_add('n', form.event_finish_minute, attributes.finish_date)>
<cfquery name="get_class_attendance" datasource="#dsn#">
	SELECT
		TRAINING_CLASS_ATTENDANCE.CLASS_ATTENDANCE_ID
	FROM
		TRAINING_CLASS_ATTENDANCE,
		TRAINING_CLASS
	WHERE
		TRAINING_CLASS_ATTENDANCE.CLASS_ATTENDANCE_ID IS NOT NULL AND 
		TRAINING_CLASS_ATTENDANCE.CLASS_ID = TRAINING_CLASS.CLASS_ID AND 
		TRAINING_CLASS.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#"> AND 
		(
			(<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> BETWEEN TRAINING_CLASS_ATTENDANCE.START_DATE AND TRAINING_CLASS_ATTENDANCE.FINISH_DATE OR <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"> BETWEEN TRAINING_CLASS_ATTENDANCE.START_DATE AND TRAINING_CLASS_ATTENDANCE.FINISH_DATE) OR
			(TRAINING_CLASS_ATTENDANCE.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND TRAINING_CLASS_ATTENDANCE.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">)
		)
</cfquery>
<cfif get_class_attendance.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='13.uyarı'> : <cf_get_lang no ='516.Bu Tarihler arasında yoklama kaydı var'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfif attributes.attendance_row_count>
	<cflock name="#CREATEUUID()#" timeout="20">
		<cftransaction>
			<cfquery name="ADD_CLASS_ATTENDANCE" datasource="#dsn#" result="max_id">
				INSERT INTO
					TRAINING_CLASS_ATTENDANCE
				(
					CLASS_ID,
					START_DATE,
					FINISH_DATE,
					RECORD_DATE,
					RECORD_IP,
					RECORD_EMP
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
				)
			</cfquery>	
			<cfset get_class_attendance_id.class_attendance_id = max_id.identitycol>
			<cfoutput>
			<cfloop from="1" to="#attributes.attendance_row_count#" index="attendance_index">
				<cfquery name="ADD_CLASS_ATTENDANCE_DT" datasource="#DSN#">
					INSERT INTO
						TRAINING_CLASS_ATTENDANCE_DT
					(
						CLASS_ATTENDANCE_ID,
						<cfif isDefined('attributes.emp_id_#attendance_index#')>
							EMP_ID,
						<cfelseif isDefined('attributes.par_id_#attendance_index#')>
							PAR_ID,
						<cfelseif isDefined('attributes.con_id_#attendance_index#')>
							CON_ID,
						</cfif>
						ATTENDANCE_MAIN,
						IS_EXCUSE_MAIN,
						EXCUSE_MAIN,
						REASON_TO_START_ID,
						IS_TRAINER
					)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#get_class_attendance_id.class_attendance_id#">,
						<cfif isDefined('attributes.emp_id_#attendance_index#')>
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.emp_id_#attendance_index#')#">,
						<cfelseif isDefined('attributes.par_id_#attendance_index#')>
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.par_id_#attendance_index#')#">,
						<cfelseif isDefined('attributes.con_id_#attendance_index#')>
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.con_id_#attendance_index#')#">,
						</cfif>
						<cfif Len(Evaluate("attributes.attendance_#attendance_index#"))><cfqueryparam cfsqltype="cf_sql_float" value="#Evaluate('attributes.attendance_#attendance_index#')#">,<cfelse>NULL,</cfif>
						<cfif isDefined("attributes.is_excuse_#attendance_index#")>1,<cfelse>0,</cfif>
						<cfif Len(Evaluate("attributes.excuse_#attendance_index#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('attributes.excuse_#attendance_index#')#"><cfelse>NULL</cfif>,
						<cfif isdefined("attributes.reason_to_start_#attendance_index#") and len(evaluate("attributes.reason_to_start_#attendance_index#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.reason_to_start_#attendance_index#')#"><cfelse>NULL</cfif>,
						<cfif isdefined("attributes.is_tra_#attendance_index#") and len(evaluate("attributes.is_tra_#attendance_index#"))><cfqueryparam cfsqltype="cf_sql_bit" value="#evaluate('attributes.is_tra_#attendance_index#')#"><cfelse>NULL</cfif>
					) 
				</cfquery>
			</cfloop>
			</cfoutput>
		</cftransaction>
	</cflock>
<cfelseif kontroldegiskeni IS 0>
	<script type="text/javascript">
		alert("<cf_get_lang no ='517.Önce katılımcı eklemelisiniz'> !");
		window.close();
	</script>
	<cfabort>
</cfif>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
