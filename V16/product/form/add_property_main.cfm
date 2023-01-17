<cf_xml_page_edit fuseact="product.upd_property_main">
<cfinclude template="../query/get_our_companies.cfm">
<!---Özellik Ekle--->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='33614.Ürün Özellikleri'>: <cf_get_lang dictionary_id='45697.Yeni Kayıt'></cfsavecontent>
	<cf_box title="#head#" popup_box="1" closable="1" resize="0">
		<cfform name="add_property_main" method="post" action="#request.self#?fuseaction=product.emptypopup_add_property_main" >
			<cf_box_elements vertical="0">
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-status">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
							<label><input type="checkbox" value="1" name="is_active" id="is_active" checked> <cf_get_lang dictionary_id='57493.Aktif'></label>
						</div>
					</div>
					<div class="form-group" id="item-property">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57632.Özellik'> *</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='29741.Özellik Girmelisiniz'></cfsavecontent>
							<cfinput type="text" name="property" value="" message="#message#" required="yes" maxlength="50">
						</div>
					</div>
					<div class="form-group" id="item-property_code">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57789.Özellik Kodu'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
							<cfinput type="text" name="property_code" maxlength="20">
						</div>
					</div>
					<div class="form-group" id="item-detail">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
							<textarea name="detail" id="detail" value=""></textarea>
						</div>
					</div>
					<cfif xml_size_color eq 1>
						<div class="form-group" id="item-size_color">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37324.Beden'>/<cf_get_lang dictionary_id='37325.Renk'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
								<label><cf_get_lang dictionary_id='37324.Beden'> <input type="checkbox" name="size_color" id="size_color" value="1"></label>
								<label><cf_get_lang dictionary_id='37325.Renk'> <input type="checkbox" name="size_color" id="size_color" value="0"></label>
								<label><input type="checkbox" value="1" name="PROPERTY_LEN" id="PROPERTY_LEN" checked><cf_get_lang dictionary_id='48153.Height'></label>
								<label><input type="checkbox" value="1" name="is_variation_control" id="is_variation_control"> <cf_get_lang dictionary_id='37651.Sepet Kontrol Yapılsın'></label> 
								<label><input type="checkbox" value="1" name="is_web_control" id="is_web_control"> <cf_get_lang dictionary_id='37161.Web de Göster'></label>
							</div>
						</div>
					</cfif>
					<div class="form-group" id="item-our_company_ids">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58017.İlişkili Şirketler'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
							<cf_multiselect_check  
								name="our_company_ids"
								option_name="nick_name"
								option_value="comp_id"
								width="200"
								table_name="OUR_COMPANY">
						</div>
					</div>
					<div class="form-group" id="item-status">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"></label>
					</div>
				</div>
			</cf_box_elements>	
			<cf_box_footer>	
				<cf_workcube_buttons is_upd='0' add_function="#iif(isdefined("attributes.draggable"),DE("kontrol_prop() && loadPopupBox('search_par' , #attributes.modal_id#)"),DE(""))#">
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">	
function kontrol_prop(){
	<cfif xml_size_color eq 1> 
		if(add_property_main.size_color[0].checked && add_property_main.size_color[1].checked){
			alert("<cf_get_lang dictionary_id='60448.Hem Renk Hem Beden seçilemez'>!!");
			return false;
		}
	</cfif>
	
		if (document.add_property_main.our_company_ids.value == "")
  { 
   alert ("<cf_get_lang dictionary_id='60449.Özellik kaydedebilmeniz için en az bir şirket seçmeniz gerekmektedir'>!!");
   return false;
  }
}
//function
</script>
