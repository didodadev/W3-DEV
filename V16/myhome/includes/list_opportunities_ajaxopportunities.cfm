<cfsetting showdebugoutput="no">
<cfinclude template="get_opportunities.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default=20>
<cfparam name="attributes.totalrecords" default="#get_opportunities.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_flat_list>
	<cfif get_opportunities.recordcount>
		<cfset opp_partner_list = "">
		<cfset opp_consumer_list = "">
		<cfoutput query="get_opportunities" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<cfif len(partner_id) and not listfind(opp_partner_list,partner_id)>
				<cfset opp_partner_list=listappend(opp_partner_list,partner_id)>
			</cfif>
			<cfif len(consumer_id) and not listfind(opp_consumer_list,consumer_id)>
				<cfset opp_consumer_list=listappend(opp_consumer_list,consumer_id)>
			</cfif>
		</cfoutput>
		<cfif len(opp_partner_list)>
			<cfquery name="get_par_com_info" datasource="#dsn#">
				SELECT
					COMPANY_PARTNER.PARTNER_ID,
					COMPANY_PARTNER.COMPANY_PARTNER_NAME,
					COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
					COMPANY.FULLNAME,
					COMPANY.COMPANY_ID
				FROM
					COMPANY,
					COMPANY_PARTNER
				WHERE
                    COMPANY_PARTNER.PARTNER_ID  IN (#opp_partner_list#) AND
                    COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID
				ORDER BY
					COMPANY_PARTNER.PARTNER_ID
			</cfquery>
			<cfset opp_partner_list = listsort(listdeleteduplicates(valuelist(get_par_com_info.partner_id,',')),'numeric','ASC',',')>
		</cfif>
		<cfif len(opp_consumer_list)>
			<cfquery name="get_con_info" datasource="#dsn#">
				SELECT
					CONSUMER_ID,
					CONSUMER_NAME,
					CONSUMER_SURNAME,
					CONSUMER_EMAIL,
					COMPANY
				FROM
					CONSUMER
				WHERE
					CONSUMER_ID IN (#opp_consumer_list#)
				ORDER BY
					CONSUMER_ID
			</cfquery>
			<cfset opp_consumer_list = listsort(listdeleteduplicates(valuelist(get_con_info.consumer_id,',')),'numeric','ASC',',')>
		</cfif>
	<thead>
		<tr>
			<th><cf_get_lang_main no="68.konu"></th>
			<th><cf_get_lang_main no="780.müşteri"></th>
		</tr>
	</thead>
	<tbody>
		<cfoutput query="get_opportunities" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr>
				<td width="300"><a href="#request.self#?fuseaction=sales.list_opportunity&event=det&opp_id=#opp_id#" class="tableyazi">#opp_head#</a></td>
				<td>
					<cfif len(get_opportunities.partner_id)>
						<a class="tableyazi" href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_par_com_info.company_id[listfind(opp_partner_list,partner_id,',')]#','medium');">#get_par_com_info.fullname[listfind(opp_partner_list,partner_id,',')]#</a> - 
						<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#get_par_com_info.partner_id[listfind(opp_partner_list,partner_id,',')]#','medium');" class="tableyazi">#get_par_com_info.company_partner_name[listfind(opp_partner_list,partner_id,',')]# #get_par_com_info.company_partner_surname[listfind(opp_partner_list,partner_id,',')]#</a>
					<cfelseif len(get_opportunities.consumer_id)>
						#get_con_info.company[listfind(opp_consumer_list,consumer_id,',')]# - <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_con_info.consumer_id[listfind(opp_consumer_list,consumer_id,',')]#','medium');" class="tableyazi">#get_con_info.consumer_name[listfind(opp_consumer_list,consumer_id,',')]# #get_con_info.consumer_surname[listfind(opp_consumer_list,consumer_id,',')]#</a>
					</cfif>
				</td>
			</tr>
		</cfoutput>
		<cfelse>
			<tr>
				<td><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
			</tr>
		</tbody></cfif>
</cf_flat_list>
