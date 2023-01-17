<cfif isdefined("attributes.member_coloum_number") and len(attributes.member_coloum_number)>
	<cfparam name="attributes.member_coloum_number" default="#attributes.member_coloum_number#">
<cfelse>
	<cfparam name="attributes.member_coloum_number" default="1">
</cfif>

<cfquery name="get_req" datasource="#DSN#">
  SELECT * FROM SETUP_REQ_TYPE
</cfquery>
<cfquery name="get_company_member_req" datasource="#dsn#"> 
	SELECT REQ_ID FROM MEMBER_REQ_TYPE WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
</cfquery>
<cfset liste = valuelist(get_company_member_req.req_id)>
<cfset tihs_row_ = 0>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
	<cfform action="#request.self#?fuseaction=objects2.emptypopup_company_partner_req_type_upd&partner_id=#attributes.pid#" method="post" name="req">
		<cfoutput query="get_req">
		<cfset tihs_row_ = tihs_row_ + 1>
			<cfif this_row_ mod attributes.member_coloum_number eq 1><tr></cfif>
				<td>#get_req.REQ_NAME#</td>
				<td width="20">
					<input type="checkbox" name="REQ" id="REQ" value="#get_req.REQ_ID#"<cfif liste contains REQ_ID>checked</cfif>>
				</td>
			<cfif this_row_ mod attributes.member_coloum_number eq 1><tr></cfif>
		</cfoutput>
	<tr>
		<td height="35" colspan="6" style="text-align:right;" style="text-align:right;"><cf_workcube_buttons is_upd='0'></td>
	</tr>
	</cfform>
</table>

