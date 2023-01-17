<cfsavecontent variable="message"><cf_get_lang dictionary_id='58028.Formül'></cfsavecontent>
<cf_popup_box title="#message#">
	<cfform name="add_product_formula" action="#request.self#?fuseaction=product.emptypopup_add_product_formula" method="post" enctype="multipart/form-data">
		<table>
			<tr>
				<td></td>
				<td><input type="checkbox" name="is_active" id="is_active" checked value="1"><cf_get_lang dictionary_id='57493.Aktif'></td>
			</tr>
			<tr>
				<td width="80"><cf_get_lang dictionary_id ='58028.Formül'>*</td>
				<td width="180"><cfinput type="text" name="formula_name" required="yes" style="width:150px;" value=""></td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id ='57657.Product'>*</td>
				<td>
					<input type="hidden" name="stock_id" id="stock_id" value="">
					<input type="text" name="product_name" id="product_name" value="" style="width:150px;" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','STOCK_ID','stock_id','','3','150');">
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&ajax_form=1&field_name=add_product_formula.product_name&field_id=stock_id', 'list');"> <img border="0" src="/images/plus_thin.gif" align="absmiddle" title="<cf_get_lang dictionary_id='37786.Ürün Seç'>"></a>
				</td>
			</tr>
		</table>
		<cf_popup_box_footer>
			<cf_workcube_buttons type_format='1' is_update = '0' add_function='formula_save()'>
		</cf_popup_box_footer>
	</cfform>
</cf_popup_box>
<script type="text/javascript">
	function formula_save()
	{
		if(document.add_product_formula.formula_name.value == '')
		{
			alert("<cf_get_lang dictionary_id= '37226.Lütfen Formül Tanımı Giriniz'>!");
			return false;
		}
		if(document.add_product_formula.stock_id.value == '' || document.add_product_formula.product_name.value == '')
		{
			alert("<cf_get_lang dictionary_id= '40069.Lütfen Ürün Seçiniz'>!");
			return false;
		}	
		return true;
	}
</script>
