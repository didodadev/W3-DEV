<cfsetting showdebugoutput="no"><!--- ajax sayfa oldg. için --->
<cfquery name="get_relation_physical_asset" datasource="#dsn#">
	SELECT
		ASSET_P.ASSETP_ID,
		ASSET_P.ASSETP,
		ASSET_P.SERIAL_NO,
		ASSET_P.BRAND_TYPE_CAT_ID,
		ASSET_P.ASSETP_STATUS,
		ASSET_P.STATUS,
		ASSET_P_CAT.ASSETP_CAT
	FROM
		ASSET_P,
		ASSET_P_CAT
	WHERE
		ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID AND
		ASSET_P.RELATION_PHYSICAL_ASSET_ID = #attributes.asset_id#
</cfquery>
<cfif get_relation_physical_asset.recordcount>
	<cfset brand_type_cat_id_list=''>
    <cfset state_list=''>
    <cfoutput query="get_relation_physical_asset">
    <cfif len(brand_type_cat_id) and not listfind(brand_type_cat_id_list,brand_type_cat_id)>
        <cfset brand_type_cat_id_list = Listappend(brand_type_cat_id_list,brand_type_cat_id)>
    </cfif>	
    <cfif len(assetp_status) and not listfind(state_list,assetp_status)>
        <cfset state_list = Listappend(state_list,assetp_status)>
    </cfif>
    </cfoutput>
    <cfif len(state_list)>
        <cfset state_list=listsort(state_list,"numeric","ASC",",")>			
        <cfquery name="GET_STATE" datasource="#DSN#">
            SELECT ASSET_STATE_ID,ASSET_STATE FROM ASSET_STATE WHERE ASSET_STATE_ID IN (#state_list#) ORDER BY ASSET_STATE_ID
        </cfquery>
        <cfset main_state_list = listsort(listdeleteduplicates(valuelist(GET_STATE.ASSET_STATE_ID,',')),'numeric','ASC',',')>
    </cfif>
    <cfif len(brand_type_cat_id_list)>
        <cfset brand_type_cat_id_list=listsort(brand_type_cat_id_list,"numeric","ASC",",")>
        <cfquery name="GET_BRAND" datasource="#DSN#">
            SELECT
                SETUP_BRAND.BRAND_NAME,
                SETUP_BRAND_TYPE.BRAND_TYPE_NAME,
                SETUP_BRAND_TYPE_CAT.BRAND_TYPE_CAT_NAME
            FROM
                SETUP_BRAND,
                SETUP_BRAND_TYPE,
                SETUP_BRAND_TYPE_CAT
            WHERE
                SETUP_BRAND_TYPE_CAT.BRAND_TYPE_CAT_ID IN (#brand_type_cat_id_list#) AND
                SETUP_BRAND_TYPE_CAT.BRAND_TYPE_ID = SETUP_BRAND_TYPE.BRAND_TYPE_ID AND
                SETUP_BRAND.BRAND_ID = SETUP_BRAND_TYPE.BRAND_ID
            ORDER BY
                SETUP_BRAND_TYPE_CAT.BRAND_TYPE_CAT_ID
        </cfquery>
    </cfif>
    <cfoutput query="get_relation_physical_asset">
    	<table width="100%" style="text-align:right;" cellpadding="0" cellspacing="0">
            <tr>
                <td width="10"></td>
                <td id="asset_row2#currentrow#"  style="text-align:left;" width="20" onClick="gizle_goster(asset_detail2#assetp_id#_#currentrow#);connectAjax2('#assetp_id#_#currentrow#','#assetp_id#');gizle_goster(asset_goster2#assetp_id#_#currentrow#);gizle_goster(asset_gizle2#assetp_id#_#currentrow#);">
                   <img id="asset_goster2#assetp_id#_#currentrow#" style="cursor:pointer;" src="/images/kapa.gif" border="0" title="<cf_get_lang_main no ='1184.Göster'>" />
                   <img id="asset_gizle2#assetp_id#_#currentrow#" style="cursor:pointer;display:none" src="/images/asagi.gif" border="0" alt="<cf_get_lang_main no ='1216.Gizle'>" />
                </td>
                <td>#currentrow#</td>
                <td style="text-align:left;" width="155"><a href="#request.self#?fuseaction=assetcare.list_assetp&event=upd&assetp_id=#get_relation_physical_asset.assetp_id#" class="tableyazi" target="_blank">#assetp#</a></td>
                <td style="text-align:left;" width="155">#serial_no#</td>
                <td style="text-align:left;" width="155">#assetp_cat#</td>
                <td style="text-align:left;" width="155">
                    <cfif len(brand_type_cat_id_list)>
                        #get_brand.brand_name[listfind(brand_type_cat_id_list,get_relation_physical_asset.brand_type_cat_id,',')]# - #get_brand.brand_type_name[listfind(brand_type_cat_id_list,get_relation_physical_asset.brand_type_cat_id,',')]# - #get_brand.brand_type_cat_name[listfind(brand_type_cat_id_list,get_relation_physical_asset.brand_type_cat_id,',')]#
                    </cfif>
                </td>
                <td style="text-align:left;" width="155"><cfif len(assetp_status)>#get_state.asset_state[listfind(main_state_list,get_relation_physical_asset.assetp_status,',')]#</cfif>&nbsp;</td>
                <td style="text-align:left;" width="153"><cfif status><cf_get_lang_main no='81.Aktif'><cfelse><cf_get_lang_main no='82.Pasif'></cfif></td>	
                <td  width="21">
                    <cfsavecontent variable="asset_del"><cf_get_lang no='588.Fiziki Varlığın İlişkisini Siliyorsunuz! Emin misiniz'>!</cfsavecontent>
                    <a href="##" onClick="javascript:if(confirm('#asset_del#')) openBoxDraggable('#request.self#?fuseaction=assetcare.emptypopup_del_assetp_relation&assetp_id=#get_relation_physical_asset.assetp_id#'); return false;" title="<cf_get_lang dictionary_id='48509.İlişkiyi Sil'>"><i class="fa fa-minus"></i></a>
                </td>
                <td  width="21">
                    <a href="javascript://" title="<cf_get_lang dictionary_id='48467.Varolan Fiziki Varlıkla İlişkilendir'>" onClick="openBoxDraggable('#request.self#?fuseaction=assetcare.popup_list_relation_assetp&row_assetp_id=#get_relation_physical_asset.assetp_id#','list');">
                    	<i class="fa fa-table"></i>
                    </a>
                </td>
                <td  width="21"><a href="#request.self#?fuseaction=assetcare.list_assetp&event=upd&assetp_id=#get_relation_physical_asset.assetp_id#" class="tableyazi" target="_blank" title="<cf_get_lang dictionary_id='57464.Güncelle'>"><i class="fa fa-pencil"></i></a></td>
                <td width="21"><a href="#request.self#?fuseaction=assetcare.list_assetp&event=add&relation_assetp_id=#get_relation_physical_asset.assetp_id#&relation_assetp=#get_relation_physical_asset.assetp#" title='<cf_get_lang dictionary_id="48515.Bileşen Ekle">'><i class="fa fa-plus"></i></a></td>
            </tr>
            <tr id="asset_detail2#assetp_id#_#currentrow#" style="display:none">
                <td colspan="12">
                    <div id="DISPLAY_ORDER_STOCK_INFO2#assetp_id#_#currentrow#" class="nohover_div"></div>
                </td>
            </tr>
        </table>
    </cfoutput>
<script type="text/javascript">
function connectAjax2(crtrow,asset_id){
	if(asset_id==0) var asset_id = document.getElementById('asset_id_'+asset_id_crtrow).value;
	var bb = '<cfoutput>#request.self#?fuseaction=assetcare.emptypopup_relation_phsical_ajax</cfoutput>&asset_id='+asset_id;
	AjaxPageLoad(bb,'DISPLAY_ORDER_STOCK_INFO2'+crtrow,1);
}
</script>
</cfif>
