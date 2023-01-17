
<cfquery name="GET_LIB_ASSET" datasource="#DSN#">
	SELECT
		*
	FROM
		LIBRARY_ASSET
	WHERE 
		LIB_ASSET_ID = #url.lib_asset_id#
</cfquery>
<cfif len(get_lib_asset.lib_asset_cat)>	
	<cfquery name="GET_LIB_CAT" datasource="#DSN#">
		SELECT
			LIBRARY_CAT
		FROM
			LIBRARY_CAT
		WHERE 
			LIBRARY_CAT_ID = #get_lib_asset.lib_asset_cat# 	
	</cfquery>
</cfif>
<cfif get_lib_asset.department_id is not 0>
	<cfquery name="DEPARTMENT" datasource="#DSN#">
		SELECT
			BRANCH_ID
		FROM
			DEPARTMENT
		WHERE 
			DEPARTMENT_ID = #get_lib_asset.department_id#		
	</cfquery>
</cfif>
<cfif get_lib_asset.department_id is not 0>
	<cfquery name="GET_ASSETP_DEP" datasource="#DSN#">
		SELECT
			ZONE.ZONE_NAME,
			BRANCH.BRANCH_NAME,
			DEPARTMENT.DEPARTMENT_HEAD
		FROM
			ZONE,
			BRANCH,
			DEPARTMENT
		WHERE 
			DEPARTMENT.DEPARTMENT_ID = #get_lib_asset.department_id# AND
			 BRANCH.BRANCH_ID = #department.branch_id# AND
			ZONE.ZONE_ID = BRANCH.ZONE_ID
	</cfquery>
</cfif>
<!--- <cfsavecontent variable="right_images_">
	<cfoutput>
        <cfif not listfindnocase(denied_pages,'asset.popup_list_lib_asset_reservations')><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=asset.popup_list_lib_asset_reservations&lib_asset_id=#get_lib_asset.lib_asset_id#</cfoutput>','medium');"><img src="/images/history.gif" border="0" alt="<cf_get_lang no='18.Rezervasyon Tarihçe'>" title="<cf_get_lang no='18.Rezervasyon Tarihçe'>"></a></cfif>
    </cfoutput>
</cfsavecontent> --->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('main',285)#: #get_lib_asset.lib_asset_name#" popup_box="1" history_href="javascript:openBoxDraggable('#request.self#?fuseaction=asset.popup_list_lib_asset_reservations&lib_asset_id=#get_lib_asset.lib_asset_id#')" history_title="#getLang('','Rezervasyon Tarihçesi','47689')#">
        <cfoutput>
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="form-group" id="item-lib_asset_name">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47684.Kitap'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfif len(get_lib_asset.lib_asset_name)>#get_lib_asset.lib_asset_name#</cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-library_cat">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfif len(get_lib_cat.library_cat)>#get_lib_cat.library_cat#</cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-lib_asset_content">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57653.İçerik'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfif len(get_lib_asset.lib_asset_content)>#get_lib_asset.lib_asset_content#</cfif>
                        </div>								
                    </div>
                    <div class="form-group" id="item-lib_asset_pub">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47686.Yayın Evi'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfif len(get_lib_asset.lib_asset_pub)>#get_lib_asset.lib_asset_pub#</cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-pub_date">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47691.Yayın Yılı'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfif len(get_lib_asset.pub_date)>#get_lib_asset.pub_date#</cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-pub_place">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47738.Yayın Yeri'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfif len(get_lib_asset.pub_place)>#get_lib_asset.pub_place#</cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-department_id">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='30031.Lokasyon'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfif get_lib_asset.department_id is not 0>#get_assetp_dep.zone_name# / #get_assetp_dep.branch_name# / #get_assetp_dep.department_head#</cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-writer">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47687.Yazar'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfif len(get_lib_asset.writer)>#get_lib_asset.writer#</cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-asset_turn">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47772.Çeviren'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfif len(get_lib_asset.asset_turn)>#get_lib_asset.asset_turn#</cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-press">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47692.Baskı'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfif len(get_lib_asset.press)>#get_lib_asset.press#</cfif>
                        </div>
                    </div>	
                    <div class="form-group" id="item-detail">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfif len(get_lib_asset.detail)>#get_lib_asset.detail#</cfif>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
        </cfoutput>
    </cf_box>
</div>
