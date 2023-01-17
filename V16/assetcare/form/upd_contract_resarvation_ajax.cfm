<!---
    File: upd_contract_resarvation_ajax.cfm
    Folder: contract\form
    Author: Gramoni-Mahmut Çifçi mahmut.cifci@gramoni.com
    Date: 2019-11-19 21:30:13 
    Description:
        Anlaşmalar modülü sözleşme ile bağlantılı fiziki varlıkların listelendiği ajax ekrandır
    History:
        
    To Do:

--->
<cfsetting showdebugoutput="no">
<cfquery name="get_assets" datasource="#dsn#">
	SELECT 
		RPAC.RELATION_ID,
		AP.ASSETP_ID,
		AP.ASSETP
	FROM 
		ASSET_P AP,
		RELATION_PHYSICAL_ASSET_CONTRACT RPAC
	WHERE
		RPAC.CONTRACT_ID = #attributes.contract_id# AND
		RPAC.OUR_COMPANY_ID = #session.ep.company_id# AND
		RPAC.ASSETP_ID = AP.ASSETP_ID
</cfquery>

<cf_ajax_list>
<cfif get_assets.recordcount>
	<cfoutput query="get_assets">
	<tr>
		<td><a href="#request.self#?fuseaction=assetcare.list_assetp&event=upd&assetp_id=#ASSETP_ID#" target="_blank">#ASSETP#</a></td>
		<td align="center" width="30"><a href="#request.self#?fuseaction=assetcare.del_contract_assetp&relation_id=#RELATION_ID#"><img src="/images/delete_list.gif" title="<cf_get_lang dictionary_id='34244.Bağlantı sil'>" border="0" ></a></td>
	</tr>
	</cfoutput>
<cfelse>
	<tr>
		<td colspan="3">&nbsp;<cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
	</tr>					
</cfif>
</cf_ajax_list>