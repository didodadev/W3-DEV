<CFLOCK name="#CREATEUUID()#" timeout="20">
	<CFTRANSACTION>
	<cfloop from="1" to="#max_record_number#" index="i">
		<cfquery name="ADD_CLASS_RESULTS" datasource="#dsn#">
			INSERT INTO
				TRAINING_CLASS_RESULTS
				(
				CLASS_ID,
				<cfif isdefined("attributes.EMP_ID_#i#")>
				EMP_ID,
				<cfelseif isdefined("attributes.CON_ID_#i#")>
				CON_ID,
				<cfelseif isdefined("attributes.PAR_ID_#i#")>
				PAR_ID,
				</cfif>
				PRETEST_POINT,
				FINALTEST_POINT,
                THIRDTEST_POINT,
				RECORD_DATE,
				RECORD_IP,
				RECORD_EMP
				)
			VALUES
				(
				#attributes.CLASS_ID#,
				<cfif isdefined("attributes.EMP_ID_#i#")>
				#evaluate("attributes.EMP_ID_#i#")#,
				<cfelseif isdefined("attributes.CON_ID_#i#")>
				#Evaluate("attributes.CON_ID_#i#")#,
				<cfelseif isdefined("attributes.PAR_ID_#i#")>
				#Evaluate("attributes.PAR_ID_#i#")#,
				</cfif>
				<cfif IsNumeric(Evaluate("attributes.PRETEST_POINT_#i#"))>#Evaluate("attributes.PRETEST_POINT_#i#")#,<cfelse>NULL,</cfif>
				<cfif IsNumeric(Evaluate("attributes.FINALTEST_POINT_#i#"))>#Evaluate("attributes.FINALTEST_POINT_#i#")#,<cfelse>NULL,</cfif>
                <cfif isdefined("attributes.THIRDTEST_POINT_#i#") AND IsNumeric(Evaluate("attributes.THIRDTEST_POINT_#i#"))>#Evaluate("attributes.THIRDTEST_POINT_#i#")#,<cfelse>NULL,</cfif>
				#now()#,
				'#CGI.REMOTE_ADDR#',
				#SESSION.EP.USERID#
				)
		</cfquery>	
		</cfloop>
	</CFTRANSACTION>
</CFLOCK>

<script type="text/javascript">
wrk_opener_reload();
window.close();
</script>

