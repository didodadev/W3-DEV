<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='34247.Sabit Kıymet Kategorileri'></cfsavecontent>
	<cf_box title="#head#" add_href="#request.self#?fuseaction=settings.form_add_inventory_cat" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
			<cfinclude template="../display/list_inventory_cats.cfm">
    	</div>
    	<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
			<cfform name="add_inventory" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_inventory_cat">
        		<cf_box_elements>
          			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
						<div class="form-group" id="upper-cat">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29736.Üst Kategori'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="upper_cat" id="upper_cat" onChange="upper_hier();">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="GET_ALL_INVENTORY_CATS">
										<option value="#HIERARCHY#">#INVENTORY_CAT#</option>
									</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group" id="cat-code">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43389.Kategori Kodu'>*</label>
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<input type="text" name="hierarchy1" id="hierarchy1" value="" readonly="readonly" />
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='44853.Kategori Kodu Girmelisiniz!'></cfsavecontent>
							</div>
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<cfinput type="text" name="hierarchy2" value="" required="yes" message="#message#">
							</div>
						</div>
						<div class="form-group" id="cat-name">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37163.Kategori Adı'>*</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58555.Kategori Adı Girmelisiniz'>!</cfsavecontent>
								<cfinput type="text" name="inventory_cat_name" value="" maxlength="100" required="yes" message="#message#">
							</div>
						</div>
						<div class="form-group" id="inventory_duration">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='44577.Faydalı Ömür'>*</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='44579.Sabit Kıymet İçin Faydalı Ömür Girmelisiniz'>!</cfsavecontent>
								<cfinput type="text" name="inventory_duration" value="" maxlength="5" validate="integer" required="yes" message="#message#">
							</div>
						</div>
						<div class="form-group" id="amortization_rate">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='44578.Amortisman Oranı'>*</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='56988.Amortisman Oranı giriniz'>!</cfsavecontent>
								<cfinput type="text" name="amortization_rate" value="" maxlength="5" validate="integer" required="yes" message="#message#">
							</div>
						</div>
						<div class="form-group" id="special_code">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfinput type="text" name="special_code" value="" maxlength="50">
							</div>
						</div>
						<div class="form-group" id="detail">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<textarea name="detail" id="detail" maxlength="200" style="height:100px" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="Maksimum Karakter :750"></textarea>
							</div>
						</div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<cf_workcube_buttons is_upd='0' add_function='controlInventroyCode()'>
				</cf_box_footer>
			</cfform>
    	</div>
  	</cf_box>
</div>
<script type="text/javascript">
	function upper_hier()
	{
		document.add_inventory.hierarchy1.value=document.add_inventory.upper_cat[document.add_inventory.upper_cat.selectedIndex].value
	}
	function controlInventroyCode()
	{
		if(document.add_inventory.hierarchy1.value != "")
			{code_ = document.add_inventory.hierarchy1.value+'.'+document.add_inventory.hierarchy2.value;}
		else
			{code_ = document.add_inventory.hierarchy2.value;}

		var get_inventory_ =  wrk_safe_query("set_get_inventory_","dsn3",0,code_);
		if (get_inventory_.recordcount)
		{
			alert("<cf_get_lang dictionary_id='44854.Bu Kod Kullanılmakta; Başka Kod Kullanınız'>");
			return false;
		}
	}
</script>