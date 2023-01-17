<cfinclude template="../../config.cfm">
<cfsetting showdebugoutput="no">

<cfset cmp = objectResolver.resolveByRequest("#addonNS#.components.products.product")>
<cfset getProduct = cmp.getProduct(product_id=attributes.pid)>

<iframe style="display:none;" src="" name="add_edit_product_image" id="add_edit_product_image" width="0" height="0"></iframe>

<cfform  name="addEditProductImage" action="#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['save-product-image']['fuseaction']#" enctype="multipart/form-data">
    <input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.pid#</cfoutput>">
	<input type="hidden" name="product_name" id="product_name" value="<cfoutput>#getProduct.product_name#</cfoutput>">

    <cfif isDefined("attributes.pimageid") and len(attributes.pimageid)>
        <cfset getProductImage = cmp.getProductImage(product_image_id=attributes.pimageid)>

        <input type="hidden" name="product_image_id" id="product_image_id" value="<cfoutput>#getProductImage.product_image_id#</cfoutput>">
        <input type="hidden" name="is_del" id="is_del" value="0">
        <div style="display: none;"><cf_workcube_process is_upd='0' select_value='#getProduct.product_stage#' is_detail='1'></div>
        
        <div class="row">
            <div class="col col-12">
                <div class="row">
                    <div class="col col-12">
                        <cf_get_server_file output_file="product/#getProductImage.path#" output_server="#getProductImage.path_server_id#" output_type="0" image_width="75">
                        <a href="javascript://" class="pull-right" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_image_editor&product_id=#attributes.pid#&product_image_path=#getProductImage.path#</cfoutput>','adminTv','wrk_image_editor')"><img src="/images/canta.gif" alt="Edit" border="0"></a>
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='163.Ana İmaj'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="checkbox" name="main_image" id="main_image" value="1" <cfif getProductImage.image_type eq 1>checked</cfif> />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no ='1965.İmaj'> *</label>
                        <div class="col col-8 col-xs-12">
                            <input type="hidden" value="<cfoutput>#getProductImage.path#</cfoutput>" name="old_file_name" id="old_file_name">
					        <input type="hidden" value="<cfoutput>#getProductImage.path_server_id#</cfoutput>" name="old_file_server_id" id="old_file_server_id">
                            <input type="file" name="product_image" id="product_image" style="width:150px;">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no ='217.Açıklama'> *</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="detail" id="detail" value="<cfoutput>#getProductImage.detail#</cfoutput>" style="width:180px;">
                        </div>
                    </div>
                    <div class="form-group text-right">
                        <input type="button" value="<cf_get_lang_main no ='51.Sil'>" onClick="productImageControl(3);" />
                        <input type="button" value="<cf_get_lang_main no ='52.Güncelle'>" onClick="productImageControl(2);" />
                        <input type="button" value="<cf_get_lang_main no ='20.Geri'>" onClick="reload_this_page();" />
                    </div>
                </div>
            </div>
        </div>

    <cfelse>

        <div class="row">
            <div class="col col-12">
                <div class="form-group">
                    <label class="col col-4 col-xs-12"><cf_get_lang no='163.Ana İmaj'></label>
                    <div class="col col-8 col-xs-12">
                        <input type="checkbox" name="main_image" id="main_image" value="1" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-xs-12"><cf_get_lang_main no ='1965.İmaj'> *</label>
                    <div class="col col-8 col-xs-12">
                        <input type="file" name="product_image" id="product_image" style="width:150px;">
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-xs-12"><cf_get_lang_main no ='217.Açıklama'> *</label>
                    <div class="col col-8 col-xs-12">
                        <input type="text" name="detail" id="detail" value="<cfoutput>#attributes.product_name#</cfoutput>" style="width:180px;">
                    </div>
                </div>
                <div class="form-group text-right">
                    <input type="button" value="<cf_get_lang_main no ='49.Kaydet'>" onClick="productImageControl(1);" />
                    <input type="button" value="<cf_get_lang_main no ='20.Geri'>" onClick="reload_this_page();" />
                </div>
            </div>
        </div>

    </cfif>

</cfform>
<script language="javascript">
	function reload_this_page()
	{
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['list-product-images']['fuseaction']##attributes.pid#</cfoutput>','body_product_images',0,'Loading..')
	}
	function productImageControl(type)
	{
		if(type == 1)
		{
			var obj =  document.getElementById('product_image').value;		
			if ((obj == "") || !((obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'jpeg') || (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'jpg')   || (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'gif') || (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'png') || (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'bmp')))
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no ='1965.İmaj'>");        
				return false;
			}
		}
		if(type == 1 || type == 2)
		{
			if(document.getElementById('detail').value == "")
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no ='217.Açıklama'>");
				return false;
			}
		}
		if(type == 3)
		{
			var delAnswer = confirm("<cf_get_lang_main no='1057.Kayıtlı belgeyi siliyorsunuz emin misiniz'>");
			if (delAnswer == true)
				document.getElementById('is_del').value = 1;
			else return false;
		}
		
		if(type != 3)
			if (confirm("<cf_get_lang_main no='123.Kaydetmek istediğinizden eminmisiniz!'>")); else return false;
			
		document.addEditProductImage.target = 'add_edit_product_image';
		document.addEditProductImage.submit();
	}
</script>
