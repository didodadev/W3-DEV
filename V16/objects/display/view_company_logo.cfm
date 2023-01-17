<cfif not isdefined("dsn")>
	<cfset dsn = caller.dsn>
	<cfset dsn_alias = caller.dsn_alias>
</cfif>
<cfquery name="CHECK" datasource="#DSN#">
	SELECT 
	    ASSET_FILE_NAME2,
		ASSET_FILE_NAME2_SERVER_ID
	FROM 
	    OUR_COMPANY 
	WHERE 
		<cfif isdefined("attributes.our_company_id")>
			COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
		<cfelse>
			<cfif isDefined("session.ep.company_id") and len(session.ep.company_id)>
				COMP_ID = #session.ep.company_id#
			<cfelseif isDefined("session.pp.company_id") and len(session.pp.company_id)>	
				COMP_ID = #session.pp.company_id#
			<cfelseif isDefined("session.ww.our_company_id")>
				COMP_ID = #session.ww.our_company_id#
			<cfelseif isDefined("session.cp.our_company_id")>
				COMP_ID = #session.cp.our_company_id#
			</cfif> 
		</cfif> 
</cfquery>
<cfinclude template="../../settings/query/get_template_dimension.cfm">
<cfif len(check.asset_file_name2)>
	<cfset attributes.type = 1>
	<table border="0" cellpadding="<cfif isdefined("attributes.padding_off")>0<cfelse>10</cfif>" cellspacing="<cfif isdefined("attributes.padding_off")>0<cfelse>10</cfif>" bgcolor="FFFFFF" style="width : <cfoutput>#get_template_dimension.template_width#</cfoutput>">
		<tr> 
			<td style="width:20mm;height:20mm;" align="<cfoutput>#get_template_dimension.template_align#</cfoutput>">
				<cf_get_server_file output_file="/settings/#check.asset_file_name2#" output_server="#check.asset_file_name2_server_id#" output_type="5">
			</td>
		</tr>
    </table>
</cfif>
<cfif isdefined("attributes.show_datetime") and attributes.show_datetime and (attributes.show_datetime eq 1)>
	<table cellpadding="10" cellspacing="10" bgcolor="FFFFFF" style="width : <cfoutput>#get_template_dimension.template_width##get_template_dimension.TEMPLATE_UNIT#</cfoutput>">
		<tr>
			<td align="<cfoutput>#get_template_dimension.template_align#</cfoutput>">
				<b><cfoutput>#dateformat(now(),dateformat_style)# - #timeformat(date_add('H',session.ep.time_zone,now()),timeformat_style)#</cfoutput></b>
			</td>
		</tr>
	</table>
</cfif>
