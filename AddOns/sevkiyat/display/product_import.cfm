<cfif isdefined("attributes.is_submit")>
	<cfinclude template="../query/product_import.cfm">
<cfelse>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Ürün Aktarım','43255')#" nofooter="1">
		<cfform action="index.cfm?fuseaction=sevkiyat.product_import" method="post" enctype="multipart/form-data" name="form_upd_product">
			<cf_box_elements>
			<cfinput type="hidden" name="is_submit" value="1">			
			<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group" id="item-process_cat">
					<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'></label>
					<div class="col col-9 col-xs-12"><cfinput type="file" name="fileToUpload" id="fileToUpload" required="yes" message="Upload File!"></div>
				</div>
				<div class="form-group" id="item-comp">
					<label class="col col-3 col-xs-3"><cf_get_lang dictionary_id='29533.Tedarikçi'></label>
					<div class="col col-9 col-xs-12">
						<div class="input-group">
							<input name="comp" type="text" id="comp"  onfocus="AutoComplete_Create('comp','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','1,1,0','COMPANY_ID','company_id','','3','140');" value="" autocomplete="off">
							<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=form_upd_product.company_id&field_comp_name=form_upd_product.comp<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2&keyword=</cfoutput>'+form_upd_product.comp.value);" title="<cf_get_lang dictionary_id='44630.Ekle'>"></span>
							<cfinput type="hidden" name="company_id" id="company_id" value="" required="yes" message="#getLang('','Tedarikçi','29533')#">
						</div>
					</div>
				</div>
				<div class="form-group" id="item-product_cat">
					<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'>*</label>
					<div class="col col-9 col-xs-12">
						<div class="input-group">
							<cfinput type="hidden" name="product_catid" id="product_catid" value="" required="yes" message="#getLang('','Kategori','57486')#">
							<cfinput type="text" name="product_cat" id="product_cat" value="" onFocus="AutoComplete_Create('product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','1','PRODUCT_CATID','product_catid','','3','455');">
							<span class="input-group-addon icon-ellipsis btnPoniter" title="<cf_get_lang dictionary_id='33118.Ürün Kategorisi Ekle'> !" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&field_id=form_upd_product.product_catid&field_name=form_upd_product.product_cat');"></span>
						</div>
					</div>
				</div>
			</div>	
		</cf_box_elements>		
		<cf_box_footer>
			<cf_workcube_buttons is_upd='0'>
		</cf_box_footer>
		</cfform>
	</cf_box>
</div>
</cfif>