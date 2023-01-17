<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_SETUP_APP_BRANCHES_ROWS" datasource="#dsn#">
			INSERT 
			INTO 
				SETUP_APP_BRANCHES_ROWS
				(
					BRANCHES_ID,
					BRANCHES_NAME_ROW,
					BRANCHES_DETAIL_ROW,
					BRANCHES_STATUS_ROW,
					RECORD_DATE,
					RECORD_IP,
					RECORD_EMP
				) 
			VALUES 
				(
					#branches_id#,
					'#branches_name_row#',
					'#branches_detail_row#',
					<cfif isDefined('attributes.branches_status_row')>1<cfelse>0</cfif>,
					#now()#,
					'#cgi.remote_addr#',
					#session.ep.userid#
				)
		</cfquery>
	</cftransaction>
</cflock>
<script>
	location.href = document.referrer;
</script>
