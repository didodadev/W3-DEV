<cfsetting showdebugoutput="no">
<cfinclude template="get_company_cat.cfm">
<cfinclude template="get_company.cfm">
<cf_flat_list>
	<cfif get_company.recordcount>
		<cfparam name="attributes.page" default=1>
		<cfparam name="attributes.maxrows" default=20>
		<cfparam name="attributes.totalrecords" default="#get_company.recordcount#">
		<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
		<cfset manager_list = "">
		<cfoutput query="get_company" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
			<cfif len(manager_partner_id) and not listfind(manager_list,manager_partner_id)>
				<cfset manager_list=listappend(manager_list,manager_partner_id)>
			</cfif>
		</cfoutput>
		<cfif len(manager_list)>
			<cfquery name="get_manager_name" datasource="#dsn#">
				SELECT PARTNER_ID, COMPANY_PARTNER_NAME, COMPANY_PARTNER_SURNAME, COMPANY_PARTNER_EMAIL FROM COMPANY_PARTNER WHERE PARTNER_ID IN (#manager_list#) ORDER BY PARTNER_ID
			</cfquery>
			<cfset manager_list = listsort(listdeleteduplicates(valuelist(get_manager_name.partner_id,',')),'numeric','ASC',',')>
		</cfif>
		<thead>
			<tr>
				<th><cf_get_lang_main no="162.şirket"></th>
				<th><cf_get_lang_main no="1714.yönetici"></th>
				<th><cf_get_lang_main no="330.tarih"></th>
			</tr>
		</thead>
        <tbody>
			<cfoutput query="get_company" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
				<tr>
					<td width="250">
                    	<cfif get_module_user(4)>
                        	<a href="#request.self#?fuseaction=member.form_list_company&event=det&cpid=#company_id#" target="_blank" class="tableyazi">#fullname#</a>
						<cfelseif get_module_user(52)>
							<a href="#request.self#?fuseaction=crm.detail_company&is_search=1&cpid=#company_id#" target="_blank" class="tableyazi">#fullname#</a>
						<cfelse>
							<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','medium');" class="tableyazi">#fullname#</a>
						</cfif>
					</td>
					<td width="210">
						<cfif len(MANAGER_PARTNER_ID) and MANAGER_PARTNER_ID NEQ "0">
							 <a href="mailto:#get_manager_name.company_partner_email[listfind(manager_list,manager_partner_id,',')]#" class="tableyazi">#get_manager_name.company_partner_name[listfind(manager_list,manager_partner_id,',')]# #get_manager_name.company_partner_surname[listfind(manager_list,manager_partner_id,',')]#</a> &nbsp;
						<cfelse>
							<font face="Verdana" color="##ff0000"><cf_get_lang no='118.Yönetici Seçilmedi'></font>
						</cfif>
					</td>
					<td width="65"><cfif len(RECORD_DATE)>#dateformat(date_add('h',session.ep.time_zone,RECORD_DATE),dateformat_style)#</cfif></td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
			</tr>
		</tbody></cfif>
	
</cf_flat_list>
