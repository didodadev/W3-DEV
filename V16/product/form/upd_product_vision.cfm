<cfquery name="get_vision" datasource="#dsn3#">
	SELECT 
		PV.*,
		S.PRODUCT_NAME,
		S.PROPERTY
	FROM 
		PRODUCT_VISION PV,
		STOCKS S
	WHERE 
		S.PRODUCT_ID = PV.PRODUCT_ID AND
		S.STOCK_ID = PV.STOCK_ID AND
		PV.VISION_ID = #attributes.vision_id#
</cfquery>
<cfquery name="get_vision_type" datasource="#dsn#">
	SELECT VISION_TYPE_ID,VISION_TYPE_NAME FROM SETUP_VISION_TYPE
</cfquery>
<!--- <cfsavecontent variable="txt">
    <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=product.popup_add_product_vision"><img src="/images/plus1.gif" title="<cf_get_lang dictionary_id ='57582.Ekle'>"></a>
</cfsavecontent> --->

<cf_box title="#getLang('','Vitrindeki Ürünü Güncelle',37468)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="upd_product_relation" action="#request.self#?fuseaction=product.emptypopup_upd_product_vision" method="post">
        <cf_box_elements vertical="0">     
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <input type="hidden" name="vision_id" id="vision_id" value="<cfoutput>#attributes.vision_id#</cfoutput>">
                <div class="form-group" id="is_active">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="checkbox" name="is_active" id="is_active" value="checkbox" <cfif GET_VISION.is_active>checked</cfif>>
                    </div>
                </div>  
                <div class="form-group" id="is_public">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37561.Public'></label> 
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="checkbox" name="is_public" id="is_public" value="checkbox" <cfif GET_VISION.is_public>checked</cfif>>
                    </div>
                </div> 
                <div class="form-group" id="is_partner">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58885.Partner'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="Checkbox" name="is_partner" id="is_partner" <cfif GET_VISION.is_partner>checked</cfif>>
                    </div>
                </div> 
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'>*</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <cf_multiselect_check
                            name="vision_type"
                            option_name="vision_type_name"
                            option_value="vision_type_id"
                            width="200"
                            value="#GET_VISION.vision_type#"
                            table_name="SETUP_VISION_TYPE">        
                    </div>                
                </div>  
                <div class="form-group" id="product_id">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57657.product'>* <cfif session.ep.our_company_info.sales_zone_followup eq 1> *</cfif></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="stock_id" id="stock_id" value="<cfoutput>#GET_VISION.stock_id#</cfoutput>">
                            <input type="hidden" name="product_id" id="product_id"  value="<cfoutput>#GET_VISION.product_id#</cfoutput>">
                            <input type="text" name="product_name" tabindex="62" id="product_name" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID,STOCK_ID','product_id,stock_id','','2','200');" autocomplete="off" value="<cfoutput>#GET_VISION.product_name# #GET_VISION.property#</cfoutput>" required="yes">
                            <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=upd_product_relation.stock_id&product_id=upd_product_relation.product_id&field_name=upd_product_relation.product_name');return false"></span>
                        </div>
                    </div>
                </div> 
                <div class="form-group" id="detail">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="text" name="detail" id="detail" value="<cfoutput>#get_vision.DETAIL#</cfoutput>" maxlength="50" tabindex="7"> 
                    </div>
                </div>   
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37564.Yayın Tarihi'>*</label>
                    <div class="col col-4 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58745.Başlama Tarihi girmelisiniz'>:<cf_get_lang dictionary_id='57742.Tarih'>!</cfsavecontent>
                            <cfinput type="text" name="startdate" value="#dateformat(get_vision.startdate,dateformat_style)#" message="#message#" validate="#validate_style#">
                            <span class="input-group-addon"> <cf_wrk_date_image date_field="startdate"></span>
                        </div>
                    </div>
                    <div class="col col-4 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='57739.Bitiş Tarihi Girmelisiniz'>:<cf_get_lang dictionary_id='57742.Tarih'>!</cfsavecontent>
                            <cfinput type="text" name="finishdate" value="#dateformat(get_vision.finishdate,dateformat_style)#" message="#message#" validate="#validate_style#">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <cfif isdefined("is_special_period_date") and is_special_period_date eq 1>
                        <div class="form-group">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58690.Tarih Aralığı'></label>
                            <div class="col col-4 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'>!</cfsavecontent>
                                    <cfinput validate="#validate_style#" message="#message#" type="text" name="startdate" id="startdate">							
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="startdate">
                                </div>
                            </div>
                            <div class="col col-4 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'>!</cfsavecontent>
                                    <cfinput validate="#validate_style#" message="#message#" type="text" name="finishdate" id="finishdate">						
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate">
                                </div>
                            </div>
                        </div>
                    </cfif>
                </div>                  
            </div> 
        </cf_box_elements>   
        <cf_box_footer>
            <cf_record_info query_name="get_vision">
            <cf_workcube_buttons type_format="1" is_upd='1' add_function="kontrol()" is_delete='1' del_function="#isDefined('attributes.draggable') ? 'deleteFunc()' : ''#">
        </cf_box_footer>
    </cfform>
</cf_box>

<script type="text/javascript">
	function pencere_ac()
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=upd_product_relation.stock_id&product_id=upd_product_relation.product_id&field_name=upd_product_relation.product_name<cfif isDefined('attributes.product_id') and len(attributes.product_id)><cfoutput>&list_product_id=#attributes.product_id#</cfoutput></cfif>','list');
	}
	
	function kontrol()
	{
		if (document.upd_product_relation.vision_type.value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='58947.Kategori Seçmelisiniz'>");
			return false;
		}
        <cfif isdefined("attributes.draggable")> 
            loadPopupBox('upd_product_relation' , <cfoutput>#attributes.modal_id#</cfoutput>)
        </cfif>
        return false;
	}
    <cfif isDefined('attributes.draggable')>
        function deleteFunc() {
            openBoxDraggable('<cfoutput>#request.self#?fuseaction=product.emptypopup_del_product_vision&vision_id=#attributes.vision_id#</cfoutput>',<cfoutput>#attributes.modal_id#</cfoutput>);
        }
    </cfif>
</script>
