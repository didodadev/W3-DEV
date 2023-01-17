<cf_xml_page_edit fuseact="objects.popup_form_add_stock_barcode">
<cfinclude template="../query/get_stock_barcodes.cfm">
<cfset attributes.stock_id = GET_STOCKS_BARCODES.stock_id>
<cfquery name="get_product_id" datasource="#dsn3#">
	SELECT PRODUCT_ID FROM STOCKS WHERE STOCK_ID = #attributes.STOCK_ID#
</cfquery>
<cfset attributes.pid = get_product_id.product_id>
<cfinclude template="../query/get_product_unit.cfm">
<cfquery name="STOCKS_BARCODES" datasource="#dsn3#">
	SELECT BARCODE,UNIT_ID FROM STOCKS_BARCODES WHERE STOCK_ID = #attributes.STOCK_ID#
</cfquery>
<cfparam name="attributes.is_terazi" default="0">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='33661.Barkod Güncelle'></cfsavecontent>
<cf_box title="#message#" popup_box="1">
    <cfform action="#request.self#?fuseaction=objects.emptypopup_form_upd_stock_barcode" method="post" name="add_stock_barcode">
  		<cf_box_elements>
			<input type="hidden" name="is_barcode_control" id="is_barcode_control" value="<cfoutput>#is_barcode_control#</cfoutput>">
			<input type="hidden" name="stock_id" id="stock_id" value="<cfoutput>#attributes.stock_id#</cfoutput>">
			<input type="hidden" name="old_barcode" id="old_barcode" value="<cfoutput>#attributes.BARCODE#</cfoutput>">
			<input type="hidden" name="is_terazi" id="is_terazi" value="<cfoutput>#attributes.is_terazi#</cfoutput>">
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
			<div class="form-group" id="item-stock_id">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>  
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<cfoutput>#get_product_name(stock_id:attributes.stock_id,with_property:1)#</cfoutput>
				</div>
			</div>
			<div class="form-group" id="item-barcode">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57633.Barkod'>*</label>  
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='37333.Barkod Girmelisiniz'>!</cfsavecontent>
						<cfinput type="Text" name="barcode" id="barcode" style="width:150px;" value="#attributes.barcode#" maxlength="50" required="Yes" message="#message#" onKeyUp="barcod_control();">
					</div>
				</div>
				<div class="form-group" id="item-barcode">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57636.Birim'>*</label>  
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<select name="unit_id" id="unit_id" style="width:150px;"><cfoutput query="GET_PRODUCT_UNIT"><option value="#product_unit_id#" <cfif GET_STOCKS_BARCODES.UNIT_ID EQ product_unit_id>selected</cfif>>#add_unit#</option></cfoutput></select>
					</div>
				</div>
			</div>
			<cfinclude template="../display/list_stock_barcodes.cfm">
      	</cf_box_elements>
		<cf_box_footer>
			<cf_workcube_buttons is_upd='1' add_function='form_kontrol()' delete_page_url='#request.self#?fuseaction=objects.emptypopup_del_stock_barcode&stock_id=#attributes.stock_id#&barcode=#attributes.BARCODE#&is_terazi=#attributes.is_terazi#'>
		</cf_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
function form_kontrol()
{
	//fbs burasi ile ilgili bir duzenleme yapildi ancak mantigi uzerinde konusup daha saglikli hale getirilecek
	var get_main_barcode_control = wrk_query("SELECT S.BARCOD BARCODE FROM STOCKS S WHERE S.STOCK_ID = "+ document.getElementById('stock_id').value+" AND S.BARCOD = '"+document.getElementById('barcode').value+"'","dsn3");// AND PU.UNIT_ID IN ("+ document.getElementById('unit_id').value+")
	var get_barcode_control = wrk_query("SELECT SB.BARCODE BARCODE,PU.ADD_UNIT ADD_UNIT FROM STOCKS S, STOCKS_BARCODES SB,PRODUCT_UNIT PU WHERE S.STOCK_ID = SB.STOCK_ID AND S.PRODUCT_ID = PU.PRODUCT_ID AND PU.PRODUCT_UNIT_ID = SB.UNIT_ID AND PU.MAIN_UNIT_ID <> PU.UNIT_ID AND SB.STOCK_ID = "+ document.getElementById('stock_id').value+" AND SB.BARCODE = '"+document.getElementById('barcode').value+"'","dsn3");// AND PU.UNIT_ID IN ("+ document.getElementById('unit_id').value+")
	//var listParam = document.getElementById('stock_id').value + "*" + document.getElementById('barcode').value;
	//alert(listParam);
	//var get_main_barcode_control = wrk_safe_query('prd_main_barcode_control','dsn3','1',listParam);
	//var get_barcode_control = wrk_safe_query('prd_other_barcode_control','dsn3','1',listParam);
	//alert(get_main_barcode_control.recordcount);
	//alert(get_barcode_control.recordcount);
	if(get_main_barcode_control.recordcount > 0 || get_barcode_control.recordcount > 1)
	{
		alert("<cf_get_lang dictionary_id='60323.Aynı Ürüne Ait Tanımlı Birden Fazla Barkod Var'>! \n <cf_get_lang dictionary_id='42748.Lütfen Kontrol Ediniz'>.");
		return false;
	}
	<cfif attributes.is_terazi is 1>
		add_stock_barcode.barcode.value = trim(add_stock_barcode.barcode.value);
		if(add_stock_barcode.barcode.value.length!=7){
			alert("<cf_get_lang dictionary_id='37681.Teraziye Giden Ürünler İçin Barkod 7 Karakter Olmalıdır'>!");
			return false;
		}
	<cfelse>
		add_stock_barcode.barcode.value = trim(add_stock_barcode.barcode.value);
		if(add_stock_barcode.barcode.value.length<7)
		{
			alert("<cf_get_lang dictionary_id='33894.Ürünler İçin Barkod En Az 7 Karakter Olmalıdır'>!");
			return false;
		}
	</cfif>
	return true;
}
function barcod_control()
{
	var prohibited_asci='32,33,34,35,36,37,38,39,40,41,42,43,44,59,60,61,62,63,64,91,92,93,94,96,123,124,125,156,171,187,163,126';
	barcode = document.getElementById('barcode');
	toplam_ = barcode.value.length;
	deger_ = barcode.value;
	if(toplam_>0)
	{
		for(var this_tus_=0; this_tus_< toplam_; this_tus_++)
		{
			tus_ = deger_.charAt(this_tus_);
			cont_ = list_find(prohibited_asci,tus_.charCodeAt());
			if(cont_>0)
			{
				alert("[space],!,\"\,#,$,%,&,',(,),*,+,,;,<,=,>,?,@,[,\,],],`,{,|,},£,~ Karakterlerinden Oluşan Barcod Girilemez!");
				barcode.value = '';
				break;
			}
		}
	}
}
</script>
