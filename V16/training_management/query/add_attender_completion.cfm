<cfif isdefined('attributes.maxlen') and attributes.maxlen gt 0>
	<cfquery name="get_attender_completion" datasource="#dsn#">
		SELECT TOP 1 COMPLETION_ID,RECORD_EMP,RECORD_IP,RECORD_DATE FROM TRAINING_CLASS_GROUP_COMPLETION WHERE TRAIN_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_group_id#">
	</cfquery>
	<cfif get_attender_completion.recordCount>
		<cfset record_emp = get_attender_completion.record_emp>
		<cfset record_ip = get_attender_completion.record_ip>
		<cfset record_date = get_attender_completion.record_date>
		<cf_date tarih="record_date">
		<cfquery name="del_attender_completion" datasource="#dsn#">
			DELETE TRAINING_CLASS_GROUP_COMPLETION WHERE TRAIN_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_group_id#">
		</cfquery>
	</cfif>
	<cfquery name="add_attender_completion" datasource="#dsn#">
		<cfloop from="1" to="#attributes.maxlen#" index="i">
			INSERT INTO
				TRAINING_CLASS_GROUP_COMPLETION
			(
				EMP_ID,
				PAR_ID,
				CON_ID,
				GRP_ID,
				TRAIN_GROUP_ID,
				IS_COMPLETED,
				REASON_TO_LEAVE_ID,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP,
				UPDATE_DATE,
				UPDATE_EMP,
				UPDATE_IP
			)
			VALUES
			(
				<cfif listfirst(evaluate('attributes.attender_#i#'),";") eq 'employee'>#listlast(evaluate('attributes.attender_#i#'),";")#<cfelse>NULL</cfif>,
				<cfif listfirst(evaluate('attributes.attender_#i#'),";") eq 'partner'>#listlast(evaluate('attributes.attender_#i#'),";")#<cfelse>NULL</cfif>,
				<cfif listfirst(evaluate('attributes.attender_#i#'),";") eq 'consumer'>#listlast(evaluate('attributes.attender_#i#'),";")#<cfelse>NULL</cfif>,
				<cfif listfirst(evaluate('attributes.attender_#i#'),";") eq 'group'>#listlast(evaluate('attributes.attender_#i#'),";")#<cfelse>NULL</cfif>,
				#attributes.train_group_id#,
				<cfif isdefined("attributes.complete_#i#") and len(evaluate("attributes.complete_#i#"))>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.leave_reason_id_#i#") and len(evaluate("attributes.leave_reason_id_#i#"))>#evaluate("attributes.leave_reason_id_#i#")#<cfelse>NULL</cfif>,
				<cfif get_attender_completion.recordCount>#record_date#<cfelse>#now()#</cfif>,
				<cfif get_attender_completion.recordCount>#record_emp#<cfelse>#session.ep.userid#</cfif>,
				<cfif get_attender_completion.recordCount>'#record_ip#'<cfelse>'#cgi.remote_addr#'</cfif>,
				<cfif get_attender_completion.recordCount>#now()#<cfelse>NULL</cfif>,
				<cfif get_attender_completion.recordCount>#session.ep.userid#<cfelse>NULL</cfif>,
				<cfif get_attender_completion.recordCount>'#cgi.remote_addr#'<cfelse>NULL</cfif>
			)
		</cfloop>
	</cfquery>
</cfif>
<script type="text/javascript">
	window.close();
</script>
