<cf_xml_page_edit fuseact="settings.form_add_service_spare_part">
<cfquery name="GET_SPARE_PART" datasource="#dsn3#">
	SELECT 
        SPARE_PART, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE,
        UPDATE_EMP, 
        UPDATE_IP,
        PRODUCT_CAT
    FROM 
    	SERVICE_SPARE_PART 
    WHERE 
	    SPARE_PART_ID = #attributes.SPARE_PART_ID#
</cfquery>
<cf_catalystHeader>    
<cfsavecontent variable="title"><cf_get_lang dictionary_id='57656.Servis'> <cf_get_lang dictionary_id='57800.İşlem tipi'> <cf_get_lang dictionary_id='57464.Güncelle'></cfsavecontent>
<cf_box title="#title#" resize="1">
    <cfform name="service_support_cat" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_service_spare_part">
        <input type="hidden" name="spare_part_id" id="spare_part_id" value="<cfoutput>#url.spare_part_id#</cfoutput>">
            <cf_box_elements>
                <div class="col col-6 col-sm-6 col-xs-12">
                    <div class="form-group">
                        <label class="col col-4 col-md-3 col-xs-12"><cf_get_lang dictionary_id='43150.Yedek Parça Durumu'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='43150.Yedek Parça Durumu'><cf_get_lang dictionary_id='57464.Güncelle'></cfsavecontent>
                                <cfinput type="Text" name="SPARE_PART" style="width:150px;" value="#get_spare_part.SPARE_PART#" maxlength="50" required="Yes" message="#message#">
                                <span class="input-group-addon">
                                    <cf_language_info 
                                    table_name="SERVICE_SPARE_PART" 
                                    column_name="SPARE_PART" 
                                    column_id_value="#url.spare_part_id#" 
                                    maxlength="500" 
                                    datasource="#dsn3#" 
                                    column_id="SPARE_PART_ID" 
                                    control_type="0">
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <cfif xml_product_cat>
                            <label class="col col-4 col-md-3 col-xs-12"><cf_get_lang dictionary_id='29401.Kategori'></label>
                            <div class="col col-8 col-xs-12">
                                <cfif len(GET_SPARE_PART.PRODUCT_CAT)>
                                <cfquery name="get_product_Cat" datasource="#dsn3#">
                                SELECT PRODUCT_CAT,HIERARCHY FROM PRODUCT_CAT WHERE PRODUCT_CATID = #GET_SPARE_PART.PRODUCT_CAT#
                                </cfquery>
                                </cfif>
                                <input type="hidden" name="cat_id" id="cat_id" value="<cfif len(GET_SPARE_PART.PRODUCT_CAT)><cfoutput>#GET_SPARE_PART.PRODUCT_CAT#</cfoutput></cfif>">
                                <input type="hidden" name="cat" id="cat" value="<cfif isdefined("get_product_Cat.HIERARCHY") and len(get_product_Cat.HIERARCHY)><cfoutput>#get_product_Cat.HIERARCHY#</cfoutput></cfif>">
                                <input name="category_name" type="text" id="category_name" style="width:150px;" value="<cfif isdefined("get_product_Cat.product_Cat") and len(get_product_Cat.product_Cat)><cfoutput>#get_product_Cat.HIERARCHY# #get_product_Cat.PRODUCT_CAT#</cfoutput></cfif>" onFocus="AutoComplete_Create('category_name','PRODUCT_CATID,PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID,HIERARCHY','cat_id,cat','','3','200','','1');" autocomplete="off">
                                <a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=0&field_id=service_support_cat.cat_id&field_code=service_support_cat.cat&field_name=service_support_cat.category_name</cfoutput>');"><img align="absmiddle" src="/images/plus_thin.gif"></a>
                    	
                            </div>
                        </cfif>
                    </div>
                </div>
            </cf_box_elements>
        <cf_box_footer>
            <cf_record_info query_name="get_spare_part">
            <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_upd_service_spare_part&is_del=1&spare_part_id=#url.spare_part_id#'>
        </cf_box_footer>
    </cfform>
</cf_box>
