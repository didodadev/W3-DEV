<cf_xml_page_edit fuseact="settings.form_add_service_defect_code">
<div class="col col-12 col-xs-12">
	<cf_box title="#getLang('','settings',42848)#" add_href="#request.self#?fuseaction=settings.form_add_service_defect_code"><!--- Arıza Kodları --->
        <cfform name="service_app_cat" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_service_defect_code">
			<cf_box_elements>	
				<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="1" sort="true">
					<cfinclude template="../display/list_service_defect_code.cfm">
				</div>
				<div class="col col-9 col-md-9 col-sm-9 col-xs-12" type="column" index="2" sort="true">
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
						<div class="form-group" id="item-service_code">
							<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main dictionary_id='58934.Arıza Kodu'>*</label>
							<div class="col col-8 col-md-6 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='43151.Arıza Kodu girmelisiniz'></cfsavecontent>
                                <cfinput type="Text" id="service_code" name="service_code" size="60" maxlength="50" required="Yes" message="#message#">
							</div>
						</div>
                        <cfif xml_product_cat>
                        <div class="form-group" id="item-category_name">
							<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main dictionary_id='29401.Ürün kategorisi'></label>
							<div class="col col-8 col-md-6 col-xs-12">
                                <div class="input-group">
                            <input type="hidden" name="cat_id" id="cat_id" value="">
                            <input type="hidden" name="cat" id="cat" value="">
                            <input name="category_name" type="text" id="category_name"  onFocus="AutoComplete_Create('category_name','PRODUCT_CATID,PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID,HIERARCHY','cat_id,cat','','3','200','','1');" autocomplete="off">
                            <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=0&field_id=service_app_cat.cat_id&field_code=service_app_cat.cat&field_name=service_app_cat.category_name</cfoutput>');"><img align="absmiddle" src="/images/plus_thin.gif"></span>
							</div>
                        </div>
						</div>
                    </cfif>
                    <div class="form-group" id="item-detail">
                        <label class="col col-4 col-md-6 col-xs-12" ><cf_get_lang_main dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8 col-md-6 col-xs-12">
                            <textarea name="detail" id="detail" style="width:150px;height:75px"></textarea>
                          </div>
                    </div>
					</div>
			    </div>
			</cf_box_elements>
			<cf_box_footer>
			<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
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