<cfif attributes.row_count>
	<cfloop from="1" to="#attributes.row_count#" index="i">
		<cfquery name="upd_attender" datasource="#dsn#">
			UPDATE
				ORGANIZATION_ATTENDER
			SET
				COMMENT = <cfif len(evaluate('attributes.comment_#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.comment_#i#')#"><cfelse>NULL</cfif>
				<cfif isdefined('attributes.participation_rate_#i#')>,PARTICIPATION_RATE = <cfif len(evaluate('attributes.participation_rate_#i#'))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.participation_rate_#i#')#"><cfelse>NULL</cfif></cfif> 
			WHERE
				ORGANIZATION_ATTENDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.attender_id_#i#')#">
		</cfquery>
	</cfloop>
</cfif>
<script>
	location.href= document.referrer;
</script>
