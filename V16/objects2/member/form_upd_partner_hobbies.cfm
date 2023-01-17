<cfif not isDefined("attributes.pid") and isDefined("session.pp")>
	<cfset attributes.pid = session.pp.userid>
</cfif>

<cfif isdefined("attributes.member_coloum_number") and len(attributes.member_coloum_number)>
	<cfparam name="attributes.member_coloum_number" default="#attributes.member_coloum_number#">
<cfelse>
	<cfparam name="attributes.member_coloum_number" default="1">
</cfif>

<cfquery name="get_hobby" datasource="#DSN#">
  SELECT * FROM SETUP_HOBBY
</cfquery>
<cfquery name="get_partner_hobbies" datasource="#dsn#"> 
	SELECT HOBBY_ID FROM COMPANY_PARTNER_HOBBY WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
</cfquery>

<cfset liste = valuelist(get_partner_hobbies.hobby_id)>

<cfform action="#request.self#?fuseaction=objects2.emptypopup_partner_hobbies_upd&partner_id=#attributes.pid#" method="post" name="hobby">
	<cfoutput query="get_hobby">
		<div class="row mb-3">
			<div class="col-md-4">
				<label class="checkbox-container font-weight-bold">#get_hobby.HOBBY_NAME#
					<input type="checkbox" id="HOBBY" name="HOBBY" value="#HOBBY_ID#" <cfif liste contains HOBBY_ID>checked</cfif>>
					<span class="checkmark"></span>
				</label>
			</div>
		</div> 
	</cfoutput>
	<div class="row mb-3">
		<td height="35" colspan="6" style="text-align:right;"><cf_workcube_buttons is_upd='0'></td>
	</div>
</cfform>