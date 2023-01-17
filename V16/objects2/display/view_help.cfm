<cfif isDefined("attributes.help_id")>
	<cfquery name="GET_HELP" datasource="#dsn#">
		SELECT
			HELP_ID,
			HELP_HEAD,
			HELP_TOPIC,
			RECORD_DATE,
			RECORD_MEMBER,
			HELP_FUSEACTION,
			HELP_CIRCUIT,
			IS_STANDARD
		FROM 
			HELP_DESK
		WHERE 
			HELP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.help_id#"> AND
			IS_INTERNET = 1
	</cfquery>
  	<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
    	<tr>
      		<td style="text-align:right;"> 
				<CF_NP tablename="HELP_DESK" 
				  primary_key="HELP_ID" 
				  pointer="HELP_ID=#HELP_ID#"> 
			</td>
    	</tr>
	</table>
	<table width="100%" cellpadding="2" cellspacing="1" border="0" class="color-border">
		<tr bgcolor="#FFFFFF">
			<td valign="top">
			<cfoutput>
			<table width="95%" align="center">
			  	<tr>
					<td><strong>#get_help.help_head#</strong><br/><br/></td>
			  	<tr>
					<td>#get_help.help_topic#</td>
			  	</tr>
			</table>
		  	</cfoutput>
			</td>
		</tr>
	</table>
</cfif>
