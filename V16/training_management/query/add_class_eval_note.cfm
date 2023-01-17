<cfloop from="1" to="#max_record_number#" index="i">
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
			'#CGI.REMOTE_ADDR#',
			#NOW()#			
		)	
	</cfquery>
</cfloop>
<script type="text/javascript">
	window.close();
</script>
