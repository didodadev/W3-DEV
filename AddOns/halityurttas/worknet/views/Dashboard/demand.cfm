<cfsetting showdebugoutput="no">
<cfinclude template="../../config.cfm">
<cfset cmp = objectResolver.resolveByRequest("#addonNS#.components.demands.demand") />
<cfset get_demand = cmp.getDemand(recordCount:10,is_status:1,is_online:1) />
<table class="ajax_list">
	<cfif get_demand.recordcount>
    	<thead>
            <tr>
                <th><cf_get_lang no="88.Talep"></th>
                <th><cf_get_lang_main no="1195.Firma"></th>
                <th colspan="2"><cf_get_lang no="84.Yayın Tarihi"></th>
            </tr>
        </thead>
        <tbody>
			<cfoutput query="get_demand">
                <tr>
                    <td>
                        <a href="#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['demands-relation']['fuseaction']##demand_id#" class="tableyazi">#demand_head#</a>
                    </td>
                    <td>#member_name#</td>
                    <td>#dateformat(start_date,'dd/mm/yyyy')#-#dateformat(finish_date,'dd/mm/yyyy')#</td>
                    <td width="15"><a href="#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['demands-relation']['fuseaction']##demand_id#"><img src="/images/update_list.gif" border="0"></a></td>
                </tr>
            </cfoutput>
            <tr>
                <td colspan="4" style="text-align:right;">
                    <a href="<cfoutput>#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['demands-list']['fuseaction']#</cfoutput>"><cf_get_lang_main no="296.Tümü"></a>
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
