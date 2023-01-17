<cfif len(attributes.chief1_code) or len(attributes.chief2_code) or len(attributes.chief3_code)>
		<cfloop from="1" to="#form.loop_count#" index="i">
			<cfscript>
				MY_POSITION_CODE = evaluate("attributes.POSITION_CODE_#i#");
			</cfscript>	
			
				<cfquery name="add_standby" datasource="#dsn#">
					INSERT INTO
						EMPLOYEE_POSITIONS_STANDBY
						(
						<cfif len(attributes.chief1_code)>CHIEF1_CODE,</cfif>
						<cfif len(attributes.chief2_code)>CHIEF2_CODE,</cfif>
						<cfif len(attributes.chief3_code)>CHIEF3_CODE,</cfif>
						POSITION_CODE,	
						RECORD_DATE,
						RECORD_KEY,
						RECORD_IP
						)
						VALUES
						(
						<cfif len(attributes.chief1_code)>#attributes.chief1_code#,</cfif>
						<cfif len(attributes.chief2_code)>#attributes.chief2_code#,</cfif>
						<cfif len(attributes.chief3_code)>#attributes.chief3_code#,</cfif>
						#MY_POSITION_CODE#,
						#NOW()#,
						'#SESSION.EP.USERKEY#',
						'#CGI.REMOTE_ADDR#'
						)
				</cfquery>
				<cfquery name="add1" datasource="#dsn#">
					UPDATE 
						EMPLOYEE_POSITIONS 
					SET 
						<cfif len(attributes.chief1_code)>UPPER_POSITION_CODE = #attributes.CHIEF1_CODE#<cfelse>UPPER_POSITION_CODE = NULL</cfif>,
						<cfif len(attributes.CHIEF2_CODE)>UPPER_POSITION_CODE2 = #attributes.CHIEF2_CODE#<cfelse>UPPER_POSITION_CODE2 = NULL</cfif> 
					WHERE 
						POSITION_CODE = #MY_POSITION_CODE#
				</cfquery>
		</cfloop>	
<cfelse>

<cfloop from="1" to="#form.loop_count#" index="i">
	<cfscript>
		MY_CHIEF1_CODE = evaluate("attributes.CHIEF1_CODE_#i#");
		MY_CHIEF2_CODE = evaluate("attributes.CHIEF2_CODE_#i#");
		MY_CHIEF3_CODE = evaluate("attributes.CHIEF3_CODE_#i#");
		MY_POSITION_CODE = evaluate("attributes.POSITION_CODE_#i#");
	</cfscript>	
	
	<cfif len(MY_CHIEF1_CODE) or len(MY_CHIEF2_CODE) or len(MY_CHIEF3_CODE)>
		<cfquery name="add_standby" datasource="#dsn#">
			INSERT INTO
				EMPLOYEE_POSITIONS_STANDBY
				(
				<cfif len(MY_CHIEF1_CODE)>CHIEF1_CODE,</cfif>
				<cfif len(MY_CHIEF2_CODE)>CHIEF2_CODE,</cfif>
				<cfif len(MY_CHIEF3_CODE)>CHIEF3_CODE,</cfif>
				POSITION_CODE,	
				RECORD_DATE,
				RECORD_KEY,
				RECORD_IP
				)
				VALUES
				(
				<cfif len(MY_CHIEF1_CODE)>#MY_CHIEF1_CODE#,</cfif>
				<cfif len(MY_CHIEF2_CODE)>#MY_CHIEF2_CODE#,</cfif>
				<cfif len(MY_CHIEF3_CODE)>#MY_CHIEF3_CODE#,</cfif>
				#MY_POSITION_CODE#,
				#NOW()#,
				'#SESSION.EP.USERKEY#',
				'#CGI.REMOTE_ADDR#'
				)
		</cfquery>
		<cfquery name="add1" datasource="#dsn#">
			UPDATE 
				EMPLOYEE_POSITIONS 
			SET 
				<cfif len(MY_CHIEF1_CODE)>UPPER_POSITION_CODE = #MY_CHIEF1_CODE#</cfif>,
				UPPER_POSITION_CODE2 = <cfif len(MY_CHIEF2_CODE)>#MY_CHIEF2_CODE#<cfelse>NULL</cfif> 
			WHERE 
				POSITION_CODE = #MY_POSITION_CODE#
		</cfquery>
	</cfif>
</cfloop>
</cfif>
<script type="text/javascript">
	window.close();
</script> 
