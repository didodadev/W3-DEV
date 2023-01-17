<cf_date tarih="attributes.start_date">
<cf_date tarih="attributes.finish_date">
<cfset attributes.start_date = date_add('h', form.event_start_clock - session.ep.time_zone, attributes.start_date)>
<cfset attributes.start_date = date_add('n', form.event_start_minute, attributes.start_date)>
<cfset attributes.finish_date = date_add('h', form.event_finish_clock - session.ep.time_zone, attributes.finish_date)>
<cfset attributes.finish_date = date_add('n', form.event_finish_minute, attributes.finish_date)>

<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="UPD_CLASS_ATTENDANCE" datasource="#DSN#">
			UPDATE
				TRAINING_CLASS_ATTENDANCE
			SET
				CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">,
				START_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">,
				FINISH_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">,
				UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
			WHERE
				CLASS_ATTENDANCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_attendance_id#">
		</cfquery>	
		
		<cfquery name="DEL_TRAINING_CLASS_ATTENDANCE_DT" datasource="#DSN#">
			DELETE FROM TRAINING_CLASS_ATTENDANCE_DT WHERE CLASS_ATTENDANCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_attendance_id#">
		</cfquery>
		<cfoutput>
		<cfloop from="1" to="#attributes.attendance_row_count#" index="attendance_index">
			<cfif isDefined('attributes.emp_id_#attendance_index#') or isDefined("attributes.con_id_#attendance_index#") or isDefined('attributes.par_id_#attendance_index#')>
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
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_attendance_id#">,
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
			</cfif>
		</cfloop>
		</cfoutput>
	</cftransaction>
</cflock>
 <script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script> 
