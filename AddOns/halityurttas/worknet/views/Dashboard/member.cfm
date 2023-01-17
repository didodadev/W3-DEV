<cfinclude template="../../config.cfm">
<cfset cmp = objectResolver.resolveByRequest("#addonNS#.components.companies.member") />
<cfset get_company = cmp.getCompany(recordcount:10,sortfield:"RECORD_DATE",sortdir:'DESC',company_status:1,is_potential:1)/>
<table class="ajax_list">
	<cfif get_company.recordcount>
    	<thead>
            <tr>
                <th><cf_get_lang_main no="162.Sirket"></th>
                <th><cf_get_lang_main no="1714.yönetici"></th>
                <th colspan="2"><cf_get_lang_main no="330.Tarih"></th>
            </tr>
        </thead>
        <tbody>
			<cfoutput query="get_company">
                <tr>
                    <td>
                        <a href="#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['companies-relation']['fuseaction']##company_id#" class="tableyazi">#fullname#</a>
                    </td>
                    <td>#manager_partner#</td>
                    <td><cfif len(RECORD_DATE)>#dateformat(date_add('h',session.ep.time_zone,RECORD_DATE),'dd/mm/yyyy')#</cfif></td>
                    <td width="15"><a href="#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['companies-relation']['fuseaction']##company_id#"><img src="/images/update_list.gif" border="0"></a></td>
                </tr>
            </cfoutput>
            <tr>
                <td colspan="4" style="text-align:right;">
                    <a href="<cfoutput>#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['companies-list']['fuseaction']#</cfoutput>"><cf_get_lang_main no="296.Tümü"></a>
                </td>
            </tr>	
        </tbody>
	<cfelse>
    	<tbody>
            <tr>
                <td><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
            </tr>
        </tbody>
	</cfif>
</table>
