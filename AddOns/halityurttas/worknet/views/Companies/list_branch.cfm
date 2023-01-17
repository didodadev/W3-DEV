<cfinclude template="../../config.cfm">
<cfsetting showdebugoutput="no">
<cfset cmp = objectResolver.resolveByRequest("#addonNs#.components.companies.member") />
<cfset get_company_branch = cmp.getCompanyBranch(company_id:attributes.cpid) />
<table class="ajax_list">
	<thead>
        <tr>
            <th><cf_get_lang_main no='1735.Sube Adi'></th>
            <th width="80"><cf_get_lang_main no='1226.il�e'></th>
            <th width="80"><cf_get_lang_main no='559.Sehir'></th>
            <th width="80"><cf_get_lang_main no='807.�lke'></th>
            <th height="22" width="100"><cf_get_lang_main no='731.Iletisim'></th>
        </tr>
    </thead>
    <tbody>
		<cfif get_company_branch.recordcount>
           <cfoutput query="get_company_branch">
            <tr>
                <td><a href="#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['upd-branch']['fuseaction']##get_company_branch.compbranch_id#&cpid=#url.cpid#" class="tableyazi">#compbranch__name#</a></td>
                <td>#county_name#</td>
                <td>#city_name#</td>
                <td>#country_name#</td>
                <td>
                    <img src="/images/tel.gif"  title="<cf_get_lang_main no='87.Tel'>:#compbranch_telcode#-#compbranch_tel1#">&nbsp;
                    <cfif len(get_company_branch.coordinate_1) and len(get_company_branch.coordinate_2)>
                    <a href="javascript://" ><img src="/images/gmaps.gif" border="0" title="Haritada G�ster" onclick="windowopen('#request.self#?fuseaction=objects.popup_view_map&coordinate_1=#get_company_branch.coordinate_1#&coordinate_2=#get_company_branch.coordinate_2#&title=#get_company_branch.compbranch__name#','list','popup_view_map')" align="absmiddle"></a>
                    </cfif>
                    <cfif len(compbranch_email)>
                       <a href="mailto:#compbranch_email#"><img src="/images/mail.gif"  title="E-mail:#compbranch_email#" border="0"></a>
                    </cfif>
                    <cfif len(compbranch_fax)>&nbsp;<img src="/images/fax.gif" title="<cf_get_lang_main no ='76.Fax'>:#compbranch_fax#" border="0"></cfif>
                </td>
            </tr>
          </cfoutput>
        <cfelse>
            <tr>
                <td colspan="5"><cf_get_lang_main no='72.Kayit Bulunamadi'> !</td>
            </tr>
        </cfif>
    </tbody>
</table>