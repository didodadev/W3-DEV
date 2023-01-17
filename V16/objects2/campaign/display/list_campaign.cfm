<cfinclude template="../query/get_campaigns.cfm">
<cfinclude template="../query/get_campaign_cats.cfm">
<cfparam name="attributes.page" default=1>
<cfif isdefined("session.pp.maxrows")>
	<cfparam name="attributes.maxrows" default='#session.pp.maxrows#'>
<cfelse>
	<cfparam name="attributes.maxrows" default='#session.ww.maxrows#'>
</cfif>
<cfset attributes.totalrecords = '#campaign.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfif campaign.recordcount>	
	<table class="table">
		<tr> 
			<td><cf_get_lang dictionary_id='57487.No'></td>
			<td><cf_get_lang dictionary_id='57446.Kampanya'></td>
			<td><cf_get_lang dictionary_id='57630.Tip'></td>
			<td><cf_get_lang dictionary_id='34595.Yürürlülük Tarihi'></td>
			<cfif isdefined("attributes.is_show_camp_leader") and attributes.is_show_camp_leader eq 1><td><cf_get_lang dictionary_id='34596.Lider'></td></cfif>
		</tr>
		<cfoutput query="campaign" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 	
			<tr> 
				<td>#camp_no#</td>
				<td><a href="#USER_FRIENDLY_URL#" class="camp_link">#camp_head#</a></td>
				<td>#camp_cat_name#</td>
				<td>#dateformat(date_add('h',session_base.time_zone,camp_startdate),'dd/mm/yyyy')# - #dateformat(date_add('h',session_base.time_zone,camp_finishdate),'dd/mm/yyyy')#</td>
				<cfif isdefined("attributes.is_show_camp_leader") and attributes.is_show_camp_leader eq 1>
					<td> 
					  <cfif len(leader_employee_id)>
							<cfquery name="GET_POSITION" datasource="#DSN#">
								SELECT
									EMPLOYEE_NAME,
									EMPLOYEE_SURNAME,
									POSITION_NAME
								FROM
									EMPLOYEE_POSITIONS
								WHERE
									EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#leader_employee_id#"> AND
									POSITION_STATUS = 1
							</cfquery>
						   #get_position.employee_name# #get_position.employee_surname# - #get_position.position_name#
					  </cfif>
					</td>
				</cfif>
			</tr>
		</cfoutput> 
	</table>
</cfif>