<cfsetting showdebugoutput="no">
<iframe style="display:none;" src="" name="addEditBrand_" id="addEditBrand_" width="0" height="0"></iframe>
<cfform name="addEditBrand" id="addEditBrand" action="#request.self#?fuseaction=worknet.emptypopup_brands" enctype="multipart/form-data" >
	<input type="hidden" name="member_id" id="member_id" value="<cfoutput>#attributes.cpid#</cfoutput>">
	<cfif isdefined('attributes.bid') and len(attributes.bid)>
		<cfset cmp = createObject("component","V16.worknet.query.worknet_member") />
		<cfset getBrand = cmp.getBrand(brand_id:attributes.bid)>
		<input type="hidden" name="brand_id" id="brand_id" value="<cfoutput>#getBrand.brand_id#</cfoutput>">
		<input type="hidden" name="is_del" id="is_del" value="0">
		<cf_box_elements>
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
				<div class="form-group">
					<cf_get_server_file output_file="member/#getBrand.brand_logo_path#" output_server="#getBrand.brand_logo_path_server_id#" output_type="0" image_width="75">
				</div>
				<div class="form-group">
					<label class="col col-12"><cf_get_lang no='170.Kendi Üretimim'><input type="checkbox" name="my_production" id="my_production" value="1"<cfif getBrand.my_production eq 1>checked</cfif>/></label>
				</div>
				<div class="form-group">
					<label class="col col-4"><cf_get_lang no='171.Marka Adı'></label>
					<div class="col col-8"><input type="text" name="brand_name" id="brand_name" value="<cfoutput>#getBrand.brand_name#</cfoutput>"></div>
				</div>
				<div class="form-group">
					<label class="col col-4"><cf_get_lang_main no='1225.Logo'></label>
					<div class="col col-8">
						<input type="hidden" name="old_file_name" id="old_file_name" value="<cfoutput>#getBrand.brand_logo_path#</cfoutput>">
						<input type="hidden" name="old_file_server_id" id="old_file_server_id" value="<cfoutput>#getBrand.brand_logo_path_server_id#</cfoutput>">
						<input type="file" name="brand_logo_path" id="brand_logo_path">
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4"><cf_get_lang_main no ='217.Açıklama'></label>
					<div class="col col-8"><input type="text" name="brand_detail" id="brand_detail" value="<cfoutput>#getBrand.brand_detail#</cfoutput>"></div>
				</div>
				<cf_box_footer>
					<div>
						<input type="button" value="<cf_get_lang_main no ='51.Sil'>" onClick="brandControl(3);" />
						<input type="button" value="<cf_get_lang_main no ='52.Güncelle'>" onClick="brandControl(2);" />
						<input type="button" value="<cf_get_lang_main no ='20.Geri'>" onClick="reload_this_page();" />
					</div>
				</cf_box_footer>
			</div>
		</cf_box_elements>
	<cfelse>
		<cf_box_elements>
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
				<div class="form-group">
					<label><cf_get_lang no='170.Kendi Üretimim'><input type="checkbox" name="my_production" id="my_production" value="1"></label>
				</div>
				<div class="form-group">
					<label class="col col-4"><cf_get_lang no='171.Marka Adı'></label>
					<div class="col col-8"><input type="text" name="brand_name" id="brand_name" value=""></div>
				</div>
				<div class="form-group">
					<label class="col col-4"d><cf_get_lang_main no='1225.Logo'></label>
					<div class="col col-8"><input type="file" name="brand_logo_path" id="brand_logo_path" value=""></div>
				</div>
				<div class="form-group">
					<label class="col col-4"><cf_get_lang_main no ='217.Açıklama'></label>
					<div class="col col-8"><input type="text" name="brand_detail" id="brand_detail" value=""></div>
				</div>
				<cf_box_footer>
					<div>
						<input type="button" value="<cf_get_lang_main no ='49.Kaydet'>" onClick="brandControl(1);" />
						<input type="button" value="<cf_get_lang_main no ='20.Geri'>" onClick="reload_this_page();" />
					</div>
				</cf_box_footer>
			</div>
		</cf_box_elements>
	</cfif>
</cfform>
<script type="text/javascript">
	function reload_this_page()
	{
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=worknet.emptypopup_list_brands&cpid=#attributes.cpid#</cfoutput>','body_brands',0,'Loading..')
	}
	function brandControl(type)
	{
		if(type == 1)
		{
			var obj =  document.getElementById('brand_logo_path').value;
			if ((obj == "") || !((obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'jpeg') || (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'jpg')   || (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'gif') || (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'png') || (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'bmp')))
			{
				alert("<cf_get_lang no='223.Lütfen bir resim dosyası(gif,jpg,jpeg veya png) giriniz!'>!");
				return false;
			}
		}
		if(type == 1 || type == 2)
		{
			if(document.getElementById('brand_name').value == "")
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no='171.Marka Adı'>!");
				return false;
			}
		}
		if(type == 3)
		{
			var delAnswer = confirm("<cf_get_lang_main no='121.Silmek istediğinizden eminmisiniz!'>");
			if (delAnswer == true)
				document.getElementById('is_del').value = 1;
			else return false;
		}
		if (confirm("<cf_get_lang_main no='123.Kaydetmek istediğinizden eminmisiniz!'>")); else return false;
		
			document.addEditBrand.target = 'addEditBrand_';
			document.addEditBrand.submit();
			return true;
	}
</script>

