<!---Uretim Sonucu Detayi Fiziki varlıklar --->
<cfsavecontent variable="message"> <cf_get_lang dictionary_id='30004.Fiziki Varlıklar'></cfsavecontent>
<cf_box title="#message#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
<cf_grid_list>
	<thead>
        <tr>
            <th style="width:25px;"><cf_get_lang dictionary_id='57487.No'></th>
            <th><cf_get_lang dictionary_id='36342.Varlık Adı'></th>
            <th><cf_get_lang dictionary_id='36646.Varlık Tipi'></th>
            <th style="width:15px;"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=assetcare.popup_list_relation_assetp&prod_result_id=#url.id#</cfoutput>','list');"><img src="/images/report_square.gif" border="0" title="<cf_get_lang dictionary_id='57909.İlişkilendir'>"></a></th>
        </tr>
    </thead>
    <tbody>
        <cfquery name="get_relation_prod_result_asset" datasource="#dsn#">
            SELECT ASSETP_ID, PROD_RESULT_ID FROM ASSET_P_RESERVE WHERE PROD_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
        </cfquery>
        <cfif get_relation_prod_result_asset.recordcount>
            <cfoutput query="get_relation_prod_result_asset">
                <tr>
                    <td>#currentrow#</td>
                    <cfquery name="get_assetp_name" datasource="#dsn#">
                        SELECT 
                            ASSET_P_CAT.ASSETP_CAT,
                            ASSET_P.ASSETP_ID, 
                            ASSET_P.ASSETP 
                        FROM 
                            ASSET_P,
                            ASSET_P_CAT 
                        WHERE 
                            ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID AND
                            ASSET_P.ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#assetp_id#">
                    </cfquery>
                    <td><a href="#request.self#?fuseaction=assetcare.list_assetp&event=upd&assetp_id=#assetp_id#" class="tableyazi" target="_blank">#get_assetp_name.assetp#</a></td>
                    <td>#get_assetp_name.assetp_cat# </td>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id ='36713.Varlık Rezervasyonunu Siliyorsunuz Emin misiniz'></cfsavecontent>
                    <td><a href="##" onClick="javascript:if (confirm('#message#')) windowopen('#request.self#?fuseaction=prod.emptypopup_del_asset_prod_result&id=#url.id#&assetp_id=#assetp_id#','small'); else return;"><img src="/images/delete_list.gif"  border="0" title="<cf_get_lang dictionary_id='38180.Notu Sil'>"></a></td>
                </tr>
            </cfoutput>
         <cfelse>
            <tr>
                <td colspan="4"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
            </tr>
        </cfif> 
    </tbody>
</<cf_grid_list>
