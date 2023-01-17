<cf_xml_page_edit fuseact="settings.form_add_service_defect_code">
<cfquery name="SERVICECODE" datasource="#dsn3#">
	SELECT
        #dsn#.Get_Dynamic_Language(SERVICE_CODE_ID,'#session.ep.language#','SETUP_SERVICE_CODE','SERVICE_CODE',NULL,NULL,SERVICE_CODE) AS SERVICE_CODE,
        SERVICE_CODE_DETAIL, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE,
        UPDATE_EMP, 
        UPDATE_IP,
        PRODUCT_CAT
    FROM 
    	SETUP_SERVICE_CODE 
    WHERE 
	    SERVICE_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.SERVICE_CODE_ID#">
</cfquery>	
    <div class="col col-12 col-xs-12">
        <cf_box title="#getLang('','settings',42848)#" add_href="#request.self#?fuseaction=settings.form_add_service_defect_code" is_blank="0"><!--- Arıza Kodları --->
            <cfform name="service_app_cat" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_service_defect_code">
                <input type="hidden" name="SERVICE_CODE_ID" id="SERVICE_CODE_ID" value="<cfoutput>#URL.SERVICE_CODE_ID#</cfoutput>">
                <cf_box_elements>	
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="1" sort="true">
                        <cfinclude template="../display/list_service_defect_code.cfm">
                    </div>
                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12" type="column" index="2" sort="true">
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                            <div class="form-group" id="item-service_code">
                                <label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main dictionary_id='58934.Arıza Kodu'>*</label>
                                <div class="col col-8 col-md-6 col-xs-12">
                                    <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang no='1168.Arıza Kodu girmelisiniz'></cfsavecontent>
                                        <cfinput type="Text" id="service_code" name="service_code" size="60" value="#SERVICECODE.SERVICE_CODE#" maxlength="50" required="Yes" message="#message#">
                                        <span class="input-group-addon">
                                        <cf_language_info
                                        table_name="SETUP_SERVICE_CODE"
                                        column_name="SERVICE_CODE"
                                        column_id_value="#URL.SERVICE_CODE_ID#"
                                        maxlength="500"
                                        datasource="#dsn3#" 
                                        column_id="SERVICE_CODE_ID" 
                                        control_type="2">
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <cfif xml_product_cat>
                            <div class="form-group" id="item-category_name">
                                <label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main dictionary_id='29401.Ürün kategorisi'></label>
                                <div class="col col-8 col-md-6 col-xs-12">
                                    <div class="input-group">
                                        <cfif len(SERVICECODE.PRODUCT_CAT)>
                                            <cfquery name="get_product_Cat" datasource="#dsn3#">
                                                SELECT PRODUCT_CAT,HIERARCHY FROM PRODUCT_CAT WHERE PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SERVICECODE.PRODUCT_CAT#">
                                            </cfquery>
                                        </cfif>
                                        <input type="hidden" name="cat_id" id="cat_id" value="<cfif len(SERVICECODE.PRODUCT_CAT)><cfoutput>#SERVICECODE.PRODUCT_CAT#</cfoutput></cfif>">
                                        <input type="hidden" name="cat" id="cat" value="<cfif isdefined("get_product_Cat.HIERARCHY") and len(get_product_Cat.HIERARCHY)><cfoutput>#get_product_Cat.HIERARCHY#</cfoutput></cfif>">
                                        <input name="category_name" type="text" id="category_name"  value="<cfif isdefined("get_product_Cat.product_Cat") and len(get_product_Cat.product_Cat)><cfoutput>#get_product_Cat.HIERARCHY# #get_product_Cat.PRODUCT_CAT#</cfoutput></cfif>" onFocus="AutoComplete_Create('category_name','PRODUCT_CATID,PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID,HIERARCHY','cat_id,cat','','3','200','','1');" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=0&field_id=service_app_cat.cat_id&field_code=service_app_cat.cat&field_name=service_app_cat.category_name</cfoutput>');"><img align="absmiddle" src="/images/plus_thin.gif"></span>
                                </div>
                            </div>
                            </div>
                        </cfif>
                        <div class="form-group" id="item-detail">
                            <label class="col col-4 col-md-6 col-xs-12" ><cf_get_lang_main dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-md-6 col-xs-12">
                                <textarea name="detail" id="detail" style="width:150px;height:75px"><cfoutput>#SERVICECODE.SERVICE_CODE_DETAIL#</cfoutput></textarea>
                              </div>
                        </div>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                <cf_record_info query_name="SERVICECODE">
                 <cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_service_defect_code&SERVICE_CODE_ID=#url.SERVICE_CODE_ID#'>
            </cf_box_footer>
            </cfform>
        </cf_box>
    </div>
    <script type="text/javascript">
        function kontrol()
        {
            if(document.getElementById("service_code").value == '')
            {
                alert('<cf_get_lang dictionary_id='43151.Arıza Kodu girmelisiniz'>!')
                return false;
            }
        }
    
    </script>