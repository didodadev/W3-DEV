<cfinclude template="../query/get_opportunity_offers.cfm">
<cf_flat_list>
    <tbody>
		<cfif get_opportunity_offers.recordcount>
			<cfoutput query="get_opportunity_offers">
                <tr>
                    <td><a href="#request.self#?fuseaction=<cfif offer_zone eq 1>sales.detail_offer_pta<cfelseif offer_zone eq 0>sales.list_offer&event=upd</cfif>&offer_id=#offer_id#" class="tableyazi"><cfif get_opportunity_offers.OFFER_STATUS eq 0><font color="FF0000">#OFFER_NUMBER#-#offer_head#</font><cfelse>#OFFER_NUMBER#-#offer_head#</cfif></a></td>
                    <td width="20"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=sales.emptypopup_del_offer_opp&offer_id=#OFFER_ID#','date')"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
            	<td colspan="2"><cf_get_lang dictionary_id="57484.Kayıt yok">!</td>
            </tr>
        </cfif>
    </tbody>
</cf_flat_list>
