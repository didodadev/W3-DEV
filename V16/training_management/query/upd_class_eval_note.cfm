<cfloop from="1" to="#max_record_number#" index="i">
	<cfquery  name="get_kontrol" datasource="#DSN#">
		SELECT
			EVAL_NOTE_ID
		FROM
			TRAINING_CLASS_EVAL_NOTE
		WHERE
			CLASS_ID=#attributes.CLASS_ID# AND
			<cfif isdefined("attributes.EMP_ID_#i#")>
				EMPLOYEE_ID = #evaluate("attributes.EMP_ID_#i#")#
			<cfelseif isdefined("attributes.CON_ID_#i#")>
				CON_ID = #evaluate("attributes.CON_ID_#i#")#
			<cfelseif isdefined("attributes.PAR_ID_#i#")>
				PAR_ID = #evaluate("attributes.PAR_ID_#i#")#
			</cfif>
	</cfquery>
	<cfif not get_kontrol.recordcount>
		<cfquery name="ins_db" datasource="#DSN#">
			INSERT INTO 
				TRAINING_CLASS_EVAL_NOTE
				(
					<cfif isdefined("attributes.EMP_ID_#i#")>
					EMPLOYEE_ID 
					<cfelseif isdefined("attributes.CON_ID_#i#")>
					CON_ID
					<cfelseif isdefined("attributes.PAR_ID_#i#")>
					PAR_ID
					</cfif>
					,CLASS_ID
					,DETAIL
					,RECORD_EMP
					,RECORD_IP 
					,RECORD_DATE
				)
			VALUES
				(
					<cfif isdefined("attributes.EMP_ID_#i#")>
					#evaluate("attributes.EMP_ID_#i#")#,
					<cfelseif isdefined("attributes.CON_ID_#i#")>
					#evaluate("attributes.CON_ID_#i#")#,
					<cfelseif isdefined("attributes.PAR_ID_#i#")>
					#evaluate("attributes.PAR_ID_#i#")#,
					</cfif>
					#attributes.CLASS_ID#,
					'#wrk_eval("attributes.NOTE_#i#")#',
					#SESSION.EP.USERID#,
					'#CGI.REMOTE_USER#',
					#NOW()#			
				)	
		</cfquery>
	<cfelse>
		<cfquery name="ins_db" datasource="#DSN#">
			UPDATE
				TRAINING_CLASS_EVAL_NOTE
			SET
				DETAIL='#wrk_eval("attributes.NOTE_#i#")#',
				UPDATE_EMP=#SESSION.EP.USERID#,
				UPDATE_IP='#CGI.REMOTE_USER#',
				UPDATE_DATE=#NOW()#
			WHERE
				EVAL_NOTE_ID=#get_kontrol.EVAL_NOTE_ID#
		</cfquery>
	</cfif>
</cfloop>
<script type="text/javascript">
	window.close();
</script>
