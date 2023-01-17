<cfquery name="GET_ASSET_CONTRACT" datasource="#DSN#">
	SELECT
		CONTRACT_HEAD,
		ASSET_CARE_CONTRACT_ID,
		SUPPORT_CAT_ID
	FROM
		ASSET_CARE_CONTRACT
	WHERE
		ASSET_ID = #URL.ASSETP_ID# 
</cfquery>
<cf_ajax_list>
    <tbody>
		<cfif get_asset_contract.recordcount>
            <cfoutput query="get_asset_contract">
            <tr>
                <td width="100%" colspan="2"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=assetcare.popup_upd_asset_contract&asset_id=#url.assetp_id#&asset_care_contract_id=#get_asset_contract.asset_care_contract_id#','medium');" class="tableyazi">#contract_head#  
                    <cfif len(support_cat_id)>
                    <cfquery name="get_support_name" datasource="#DSN#">
                    SELECT TAKE_SUP_CAT  FROM ASSET_TAKE_SUPPORT_CAT WHERE TAKE_SUP_CATID = #support_cat_id#
                    </cfquery> - #get_support_name.take_sup_cat#</cfif></a>
                </td>
            </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td colspan="2" height="22"><cf_get_lang_main no='72.Kayıt Yok'> !</td>
            </tr>		
        </cfif>
    </tbody>
</cf_ajax_list>

