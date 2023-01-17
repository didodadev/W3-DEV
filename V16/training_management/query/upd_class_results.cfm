<CFLOCK name="#CREATEUUID()#" timeout="20">
	<CFTRANSACTION>
	<cfloop from="1" to="#max_record_number#" index="i">
		<cfquery name="get_class_results" datasource="#dsn#">
			SELECT 
				EMP_ID,
				PAR_ID,
				CON_ID
			FROM
				TRAINING_CLASS_RESULTS
			WHERE
				CLASS_ID=#attributes.CLASS_ID# AND
				<cfif isdefined("attributes.EMP_ID_#i#")>
				EMP_ID=#Evaluate("attributes.EMP_ID_#i#")#
				<cfelseif isdefined("attributes.CON_ID_#i#")>
				CON_ID=#Evaluate("attributes.CON_ID_#i#")#
				<cfelseif isdefined("attributes.PAR_ID_#i#")>
				PAR_ID=#Evaluate("attributes.PAR_ID_#i#")#
				</cfif>
		</cfquery>
		<cfif get_class_results.recordcount>
		<cfquery name="ADD_CLASS_RESULTS" datasource="#dsn#">
			UPDATE
				TRAINING_CLASS_RESULTS
			SET
				<cfif isdefined('attributes.PRETEST_POINT_#i#') and IsNumeric(Evaluate("attributes.PRETEST_POINT_#i#"))>
				PRETEST_POINT=#Evaluate("attributes.PRETEST_POINT_#i#")#,
				<cfelse>
				PRETEST_POINT=NULL,
				</cfif>
				<cfif isdefined('attributes.FINALTEST_POINT_#i#') and  IsNumeric(Evaluate("attributes.FINALTEST_POINT_#i#"))>
                    FINALTEST_POINT=#Evaluate("attributes.FINALTEST_POINT_#i#")#,
				<cfelse>
                    FINALTEST_POINT=NULL,
				</cfif>
                <cfif isdefined('attributes.THIRDTEST_POINT_#i#') and IsNumeric(Evaluate("attributes.THIRDTEST_POINT_#i#"))>
					THIRDTEST_POINT=#Evaluate("attributes.THIRDTEST_POINT_#i#")#,
				<cfelse>
					THIRDTEST_POINT=NULL,
				</cfif>
				UPDATE_DATE=#now()#,
				UPDATE_IP='#CGI.REMOTE_ADDR#',
				UPDATE_EMP=#SESSION.EP.USERID#
			WHERE
				CLASS_ID=#attributes.CLASS_ID# AND
				<cfif isdefined("attributes.EMP_ID_#i#")>
				EMP_ID=#Evaluate("attributes.EMP_ID_#i#")#
				<cfelseif isdefined("attributes.CON_ID_#i#")>
				CON_ID=#Evaluate("attributes.CON_ID_#i#")#
				<cfelseif isdefined("attributes.PAR_ID_#i#")>
				PAR_ID=#Evaluate("attributes.PAR_ID_#i#")#
				</cfif>
		</cfquery>
		<cfelse><!--- Katilimcilar listesine yeni eklenen ve testlerde kaydi olmayanlar icin --->
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
				<cfif isdefined('attributes.PRETEST_POINT_#i#') and IsNumeric(Evaluate("attributes.PRETEST_POINT_#i#"))>#Evaluate("attributes.PRETEST_POINT_#i#")#,<cfelse>NULL,</cfif>
				<cfif isdefined('attributes.FINALTEST_POINT_#i#') and IsNumeric(Evaluate("attributes.FINALTEST_POINT_#i#"))>#Evaluate("attributes.FINALTEST_POINT_#i#")#,<cfelse>NULL,</cfif>
                <cfif isdefined('attributes.THIRDTEST_POINT_#i#') and IsNumeric(Evaluate("attributes.THIRDTEST_POINT_#i#"))>#Evaluate("attributes.THIRDTEST_POINT_#i#")#,<cfelse>NULL,</cfif>
				#now()#,
				'#CGI.REMOTE_ADDR#',
				#SESSION.EP.USERID#
				)
		</cfquery>
		</cfif>	
	</cfloop>
	</CFTRANSACTION>
</CFLOCK>

<script type="text/javascript">
window.close();
</script>

