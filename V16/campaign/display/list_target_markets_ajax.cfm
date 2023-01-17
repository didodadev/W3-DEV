<cfsetting showdebugoutput="no">
<cfinclude template="../query/get_camp_tmarkets.cfm">
<cf_ajax_list>
	<thead>
       
    </thead>
    <tbody>
	<cfif camp_tmarkets.recordcount>
		<cfoutput query="camp_tmarkets">
				<cfset attributes.tmarket_id = tmarket_id>
                <cfinclude template="../query/get_target_markets.cfm">
				<cfset 'cons_#attributes.tmarket_id#' =0>
                <cfset 'par_#attributes.tmarket_id#' =0>
            <cfif tmarket.target_market_type eq 0 or tmarket.target_market_type eq 3>
            	<cfinclude template="../query/get_tmarket_consumers.cfm">
				<cfset 'cons_#attributes.tmarket_id#' = get_tmarket_users.recordcount>
                <cfinclude template="../query/get_tmarket_partner_ids.cfm">
				<cfset 'par_#attributes.tmarket_id#' = get_tmarket_partners.recordcount>
            <cfelseif tmarket.target_market_type eq 1 or tmarket.target_market_type eq 4>
            	<cfinclude template="../query/get_tmarket_partner_ids.cfm">
				<cfset 'par_#attributes.tmarket_id#' = get_tmarket_partners.recordcount>
            <cfelseif tmarket.target_market_type eq 2 or tmarket.target_market_type eq 5>
            	<cfinclude template="../query/get_tmarket_consumers.cfm">
				<cfset 'cons_#attributes.tmarket_id#' = get_tmarket_users.recordcount>
            </cfif>
			<!---<cfif tmarket.target_market_type eq 0 or tmarket.target_market_type eq 2>
				<cfinclude template="../query/get_tmarket_consumers.cfm">
				<cfset 'cons_#attributes.tmarket_id#' = get_tmarket_users.recordcount>
			</cfif>
			<cfif tmarket.target_market_type eq 0 or tmarket.target_market_type eq 1>
				<cfinclude template="../query/get_tmarket_partner_ids.cfm">
				<cfset 'par_#attributes.tmarket_id#' = get_tmarket_partners.recordcount>
			</cfif>--->
			<cfset total_no = evaluate("cons_#attributes.tmarket_id#") + evaluate("par_#attributes.tmarket_id#")>				
			<tr id="__erase__#camp_id#_#currentrow#">
				<td><a href="#request.self#?fuseaction=campaign.list_target_list&tmarket_id=#tmarket_id#&camp_id=#camp_id#" class="tableyazi">#tmarket_name# - #total_no# (#evaluate("par_#attributes.tmarket_id#")# / #evaluate("cons_#attributes.tmarket_id#")#)</a><br></td>
			    <td style="width:15px;"><a href="#request.self#?fuseaction=campaign.list_target_markets&event=upd&tmarket_id=#tmarket_id#&camp_id=#camp_id#" class="tableyazi"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
			    <td style="width:15px;" ><cfsavecontent variable="del_message"><cf_get_lang_main no='121.Silmek Istediginizden Emin Misiniz'></cfsavecontent><a style="cursor:pointer;" onClick="javascript:if (confirm('#del_message#')){AjaxPageLoad('#request.self#?fuseaction=campaign.emptypopup_del_camp_tmarket&tmarket_id=#tmarket_id#&camp_id=#camp_id#&is_ajax_delete');gizle(__erase__#camp_id#_#currentrow#);}"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
					
				</tr>
		</cfoutput>
	<cfelse>
	  <tr>
		<td colspan="3"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
	  </tr>
	</cfif>
    </tbody>
</cf_ajax_list>
