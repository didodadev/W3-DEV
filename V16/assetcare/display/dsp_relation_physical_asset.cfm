<cfsetting showdebugoutput="no"><!--- ajax sayfa oldg. için --->
<cfparam name="attributes.hide_img" default="">
<cfquery name="get_relation_physical_asset" datasource="#dsn#">
	SELECT
		ASSET_P.ASSETP_ID,
		ASSET_P.ASSETP,
		ASSET_P.SERIAL_NO,
		ASSET_P.BRAND_TYPE_CAT_ID,
		ASSET_P.ASSETP_STATUS,
		ASSET_P.STATUS,
		ASSET_P.ASSETP_CATID,
		ASSET_P_CAT.ASSETP_CAT
	FROM
		ASSET_P,
		ASSET_P_CAT
	WHERE
		ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID AND
		ASSET_P.RELATION_PHYSICAL_ASSET_ID = #attributes.asset_id#
</cfquery>
<cf_ajax_list>
	<thead>
        <tr>
			<cfif not isdefined("attributes.assetp")>
				<th width="25"></th>
			</cfif>
			<th></th>
            <th><cf_get_lang dictionary_id='57487.No'></th>
            <th><cf_get_lang dictionary_id='36342.Varlık Adı'></th>
            <th><cf_get_lang dictionary_id='57637.Seri No'></th>
            <th><cf_get_lang dictionary_id='38919.Varlık Tipi'></th>
            <th><cf_get_lang dictionary_id='38841.Marka/Marka Tipi'></th>
            <th><cf_get_lang dictionary_id='57756.Durum'></th>
            <th><cf_get_lang dictionary_id='57482.Asama'></th>
            <th colspan="4">&nbsp;</th>
        </tr>
    </thead>
    <tbody>
		<cfset brand_type_cat_id_list=''>
		<cfset state_list=''>
		<cfif get_relation_physical_asset.recordcount>
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
			<tr>
				<td style="text-align:left;" width="15" id="asset_row#currentrow#" onClick="gizle_goster(asset_detail#currentrow#);connectAjax('#currentrow#','#assetp_id#');gizle_goster(asset_goster#currentrow#);gizle_goster(asset_gizle#currentrow#);">
					<img id="asset_goster#currentrow#" style="cursor:pointer;" src="/images/kapa.gif" border="0" alt="<cf_get_lang dictionary_id='58596.Göster'>" title="<cf_get_lang dictionary_id='58596.Göster'>">
					<img id="asset_gizle#currentrow#" style="cursor:pointer;display:none" src="/images/asagi.gif" border="0" title="<cf_get_lang dictionary_id='58628.Gizle'>">
				</td>
				<td style="text-align:left;" width="50">#currentrow#</td>
				<td style="text-align:left;" width="120">
				<cfif get_relation_physical_asset.assetp_catid eq 23>
					<a href="#request.self#?fuseaction=assetcare.list_assetp&event=upd&assetp_id=#get_relation_physical_asset.assetp_id#" class="tableyazi" target="_blank">#assetp#</a>
				<cfelseif get_relation_physical_asset.assetp_catid eq 21>
					<a href="#request.self#?fuseaction=assetcare.list_vehicles&event=upd&assetp_id=#get_relation_physical_asset.assetp_id#" class="tableyazi" target="_blank">#assetp#</a>
				</cfif></td>
				<td style="text-align:left;" width="120">#serial_no#</td>
				<td style="text-align:left;" width="120">#assetp_cat#</td>
				<td style="text-align:left;" width="120">
					<cfif len(brand_type_cat_id_list)>
						#get_brand.brand_name[listfind(brand_type_cat_id_list,get_relation_physical_asset.brand_type_cat_id,',')]# - #get_brand.brand_type_name[listfind(brand_type_cat_id_list,get_relation_physical_asset.brand_type_cat_id,',')]# - #get_brand.brand_type_cat_name[listfind(brand_type_cat_id_list,get_relation_physical_asset.brand_type_cat_id,',')]#
					</cfif>
				</td>
				<td style="text-align:left;" width="120"><cfif len(assetp_status)>#get_state.asset_state[listfind(main_state_list,get_relation_physical_asset.assetp_status,',')]#</cfif></td>
				<td style="text-align:left;" width="120"><cfif status><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>	
				<cfif attributes.hide_img neq 1>
				<td style="text-align:right;" width="15">
					<cfsavecontent variable="asset_del"><cf_get_lang dictionary_id='48459.Fiziki Varlığın İlişkisini Siliyorsunuz! Emin misiniz!'></cfsavecontent>
					<a href="##" onClick="javascript:if(confirm('#asset_del#')) openBoxDraggable('#request.self#?fuseaction=assetcare.emptypopup_del_assetp_relation&assetp_id=#get_relation_physical_asset.assetp_id#'); return false;">
						<i class="fa fa-minus" border="0" alt="İlişkiyi Sil" title="İlişkiyi Sil"></i>
                    </a>
				</td>
				<td style="text-align:right;" width="15">					
						<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=assetcare.popup_list_relation_assetp&row_assetp_id=#get_relation_physical_asset.assetp_id#');"  title="<cf_get_lang dictionary_id='48467.Varolan Fiziki Varlıkla İlişkilendir'>">					
                	<i class="fa fa-table"></i>
                    </a>
				</td>
				<td style="text-align:right;" width="15">					
					<cfif get_relation_physical_asset.assetp_catid eq 23>
						<a title="<cf_get_lang dictionary_id='57464.Güncelle'>" href="#request.self#?fuseaction=assetcare.list_assetp&event=upd&assetp_id=#get_relation_physical_asset.assetp_id#" class="tableyazi" target="_blank"><i class="fa fa-pencil"></i></a>
					<cfelseif get_relation_physical_asset.assetp_catid eq 21>
						<a title="<cf_get_lang dictionary_id='57464.Güncelle'>" href="#request.self#?fuseaction=assetcare.list_vehicles&event=upd&assetp_id=#get_relation_physical_asset.assetp_id#" class="tableyazi" target="_blank"><i class="fa fa-pencil"></i></a>
					</cfif>
				</td>
				<td style="text-align:right;" width="15">
					<cfif get_relation_physical_asset.assetp_catid eq 23>
						<a onclick="openBoxDraggable('#request.self#?fuseaction=assetcare.list_assetp&event=add&relation_assetp_id=#get_relation_physical_asset.assetp_id#');"><i class="fa fa-plus" border="0" alt=<cf_get_lang dictionary_id="48515.Bileşen Ekle"> title='<cf_get_lang dictionary_id="48515.Bileşen Ekle">'></i></a>
					<cfelseif get_relation_physical_asset.assetp_catid eq 21>
						<a href="#request.self#?fuseaction=assetcare.list_vehicles&event=add&relation_assetp_id=#get_relation_physical_asset.assetp_id#"><i class="fa fa-plus" border="0" alt='<cf_get_lang dictionary_id="48515.Bileşen Ekle">' title='<cf_get_lang dictionary_id="48515.Bileşen Ekle">'></i></a>
					</cfif>
				</td>
			</cfif>
			</tr>
			<tr id="asset_detail#currentrow#" style="display:none;" class="nohover">
				<td colspan="12">
					<div id="DISPLAY_ORDER_STOCK_INFO#currentrow#" class="nohover_div"></div>
				</td>
			</tr>
		</cfoutput>
		<cfelse>
		  <tr>
			<td colspan="11"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
		  </tr>
		</cfif>
	</tbody>
</cf_ajax_list>   
<script type="text/javascript">
	function connectAjax(crtrow,asset_id){
		if(asset_id==0) var asset_id = document.getElementById('asset_id_'+crtrow).value;
		var bb = '<cfoutput>#request.self#?fuseaction=assetcare.emptypopup_relation_phsical_ajax</cfoutput>&asset_id='+asset_id;
		AjaxPageLoad(bb,'DISPLAY_ORDER_STOCK_INFO'+crtrow,1);
	}
</script>
