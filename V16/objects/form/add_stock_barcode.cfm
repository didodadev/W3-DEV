<cf_xml_page_edit fuseact="objects.popup_form_add_stock_barcode">
<cfquery name="get_product_id" datasource="#dsn3#">
	SELECT PRODUCT_ID FROM STOCKS WHERE STOCK_ID = #attributes.STOCK_ID#
</cfquery>
<cfset attributes.pid = get_product_id.product_id>
<cfinclude template="../query/get_product_unit.cfm">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='33660.Barkod Ekle'></cfsavecontent>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#message#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="add_stock_barcode" method="post" action="#request.self#?fuseaction=objects.emptypopup_form_add_stock_barcode">
			<cf_box_elements>
				<input type="hidden" name="is_barcode_control" id="is_barcode_control" value="<cfoutput>#is_barcode_control#</cfoutput>">
				<input type="hidden" name="is_terazi" id="is_terazi" value="<cfoutput>#attributes.is_terazi#</cfoutput>">
				<input type="hidden" name="stock_id" id="stock_id" value="<cfoutput>#attributes.stock_id#</cfoutput>">
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
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='37333.Barkod Girmelisiniz'> !</cfsavecontent>
							<cfinput type="Text" name="barcode" id="barcode" style="width:150px;" value="" maxlength="50" required="Yes" message="#message#" onKeyUp="barcod_control();">
						</div>
					</div>
					<div class="form-group" id="item-barcode">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57636.Birim'>*</label>  
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select name="unit_id" id="unit_id" style="width:150px;"><cfoutput query="get_product_unit"><option value="#product_unit_id#">#add_unit#</option></cfoutput>
						</select>
					</div>
				</div>
			</div>
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="2" sort="true">
					<cfinclude template="../display/list_stock_barcodes.cfm">
				</div>
			</cf_box_elements>
		<cf_box_footer>
			<cf_workcube_buttons is_upd='0' add_function='form_kontrol()'></td>
		</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
function form_kontrol()
{
	<cfif isDefined('attributes.is_terazi') and attributes.is_terazi is 1>
		add_stock_barcode.barcode.value = trim(add_stock_barcode.barcode.value);
		if(add_stock_barcode.barcode.value.length!=7)
		{
			alert("<cf_get_lang dictionary_id ='33893.Teraziye Giden Ürünler İçin Barkod 7 Karakter Olmalıdır'>!");
			return false;
		}
	<cfelse>
		add_stock_barcode.barcode.value = trim(add_stock_barcode.barcode.value);
		if(add_stock_barcode.barcode.value.length<7)
		{
			alert("<cf_get_lang dictionary_id ='33894.Ürünler İçin Barkod En Az 7 Karakter Olmalıdır'>!");
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
