<cfif isdefined("attributes.product_id") and len(attributes.product_id)>
	<cfquery name="get_product_" datasource="#dsn3#" maxrows="1">
		SELECT
			S.PRODUCT_NAME,
			S.STOCK_ID
		FROM
			STOCKS S
		WHERE
			S.PRODUCT_ID = #attributes.product_id#
	</cfquery>
<cfelse>
	<cfset get_product_.recordcount = 0>
</cfif>
<cfquery name="get_vision_type" datasource="#dsn#">
	SELECT VISION_TYPE_ID,VISION_TYPE_NAME FROM SETUP_VISION_TYPE
</cfquery>
<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('','Vitrine Ürün Ekle',37560)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="add_product_relation" action="#request.self#?fuseaction=product.emptypopup_add_product_vision" method="post">
        <cf_box_elements vertical="0">     
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <div class="form-group" id="is_active">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="checkbox" name="is_active" id="is_active" value="checkbox" checked>
                    </div>
                </div>  
                <div class="form-group" id="is_public">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37561.Public'></label> 
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="checkbox" name="is_public" id="is_public" value="checkbox">
                    </div>
                </div> 
                <div class="form-group" id="is_partner">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58885.Partner'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="Checkbox" name="is_partner" id="is_partner">
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
                            table_name="SETUP_VISION_TYPE">
                    </div>
                </div>            
                <div class="form-group" id="product_id">
                   <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57657.product'>* <cfif session.ep.our_company_info.sales_zone_followup eq 1> *</cfif></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="stock_id" id="stock_id" value="<cfoutput><cfif isdefined("attributes.stock_id")>#attributes.stock_id#<cfelseif get_product_.recordcount>#get_product_.stock_id#</cfif></cfoutput>">
                            <input type="hidden" name="product_id" id="product_id" value="<cfif isdefined("attributes.product_id")><cfoutput>#attributes.product_id#</cfoutput></cfif>">
                            <input type="text" name="product_name" tabindex="62" id="product_name" readonly="yes">
                            <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=add_product_relation.stock_id&product_id=add_product_relation.product_id&field_name=add_product_relation.product_name');return false"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="detail">
                   <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="text" name="detail" id="detail" value="<cfif isdefined("attributes.detail")><cfoutput>#Left(attributes.detail,50)#</cfoutput></cfif>" maxlength="50" tabindex="7"> 
                    </div>
                </div>        
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37564.Yayın Tarihi'>*</label>
                    <div class="col col-4 col-md-8 col-sm-8 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58745.Başlama Tarihi girmelisiniz'>:<cf_get_lang dictionary_id='57742.Tarih'>!</cfsavecontent>
                            <cfinput type="text" name="startdate" value="" message="#message#" validate="#validate_style#">
                            <span class="input-group-addon"> <cf_wrk_date_image date_field="startdate"></span>
                        </div>
                    </div>
                    <div class="col col-4 col-md-8 col-sm-8 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='57739.Bitiş Tarihi Girmelisiniz'>:<cf_get_lang dictionary_id='57742.Tarih'>!</cfsavecontent>
                            <cfinput type="text" name="finishdate" value="" message="#message#" validate="#validate_style#">
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
                                <cfinput validate="#validate_style#" message="#getLang('','Lütfen Tarih Giriniz',58503)#!" type="text" name="startdate" id="startdate">							
                                <span class="input-group-addon"><cf_wrk_date_image date_field="startdate">
                            </div>
                        </div>
                        <div class="col col-4 col-xs-12">
                            <div class="input-group">
                                <cfinput validate="#validate_style#" message="#getLang('','Lütfen Tarih Giriniz',58503)#!" type="text" name="finishdate" id="finishdate">						
                                <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate">
                            </div>
                        </div>
                    </div>
                    </cfif>
                </div>                   
            </div>
        </cf_box_elements>   
        <cf_box_footer>
            <cf_workcube_buttons is_upd='0' add_function="#iif(isdefined("attributes.draggable"),DE("kontrol() && loadPopupBox('add_product_relation' , #attributes.modal_id#)"),DE(""))#">
        </cf_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
	function pencere_ac()
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=add_product_relation.stock_id&product_id=add_product_relation.product_id&field_name=add_product_relation.product_name<cfif isDefined('attributes.product_id') and len(attributes.product_id)><cfoutput>&list_product_id=#attributes.product_id#</cfoutput></cfif>','list');
	}
	function kontrol()
	{  
        if($("select[name=vision_type]").val() == null){
            alert ("<cf_get_lang dictionary_id='58947.Kategori Seçmelisiniz'>");
			return false;
        }       
		if($("#startdate").val()=='')
		{
				alert("<cf_get_lang dictionary_id='58745.Başlama Tarihi girmelisiniz'>");
				return false;
		}
		if($("#finishdate").val()=='')
		{
				alert("<cf_get_lang dictionary_id='57739.bitiş Tarihi girmelisiniz'>");
				return false;
		}
		return true;
	}
</script>
