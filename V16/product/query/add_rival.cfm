<cfquery name="add_rival" datasource="#dsn#" result="MAX_ID">
	INSERT INTO
		SETUP_RIVALS
	(
		RIVAL_NAME,
		RIVAL_DETAIL,
		STATUS,
		RECORD_EMP,
		RECORD_IP,
		RECORD_DATE
	)
	VALUES
	(
		'#attributes.rival_name#',
		'#attributes.rival_detail#',
		<cfif isDefined("attributes.status")>1<cfelse>0</cfif>,
		#session.ep.userid#,
		'#cgi.remote_addr#',
		#now()#
	)
</cfquery>
<cfif len(attributes.record_num) and attributes.record_num neq "">
	<cfloop from="1" to="#attributes.record_num#" index="i">
		<cfif evaluate("attributes.row_kontrol#i#") and len(evaluate("attributes.branch_id#i#"))>
			<cfscript>
				form_branch = evaluate("attributes.branch_id#i#");
			</cfscript>
			<cfquery name="INS_BRANCH" datasource="#DSN#">
				INSERT INTO 
					SETUP_RIVALS_BRANCH 
				(
					R_ID,
					BRANCH_ID
				) 
				VALUES
				(
					#max_id.identitycol#,
					#form_branch#
				)
			</cfquery>
		</cfif>
	</cfloop>
</cfif>
<script type="text/javascript">
	location.href = document.referrer;
</script>
