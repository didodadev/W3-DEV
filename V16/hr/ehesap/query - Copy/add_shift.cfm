<cftransaction>
	<cfquery name="add_shift" datasource="#dsn#" result="MAX_ID">
		INSERT INTO
			SETUP_SHIFTS
			(
			SHIFT_NAME,
			IS_PRODUCTION,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP
			)
		VALUES
			(
			'#SHIFT_NAME#',
			<cfif isdefined('attributes.is_production')>1<cfelse>0</cfif>,
			#NOW()#,
			#SESSION.EP.USERID#,
			'#CGI.REMOTE_ADDR#'
			)
	</cfquery>
</cftransaction>
<script type="text/javascript">	
	window.location.href='<cfoutput>#request.self#?fuseaction=ehesap.shift&event=upd&shift_id=#MAX_ID.IDENTITYCOL#</cfoutput>';
</script>
