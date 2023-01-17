<cfquery name="get_formula" datasource="#dsn3#">
	SELECT 
		*
	FROM 
		SETUP_PRODUCT_FORMULA
	WHERE
		SETUP_PRODUCT_FORMULA.PRODUCT_FORMULA_ID = #attributes.id#
</cfquery>
<cfsavecontent variable="txt">
    <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=product.popup_add_product_formula"><img src="/images/plus1.gif" title="<cf_get_lang dictionary_id ='57582.Ekle'>"></a>
</cfsavecontent>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='58028.Formül'></cfsavecontent>
<cf_popup_box title="#message#" right_images="#txt#">
    <cfform name="add_product_formula" action="#request.self#?fuseaction=product.emptypopup_upd_product_formula" method="post" enctype="multipart/form-data">
    <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
            <table>
                <tr>
                    <td></td>
                    <td colspan="3"><input type="checkbox" name="is_active" id="is_active"<cfif get_formula.is_active eq 1>checked</cfif> value="1"><cf_get_lang dictionary_id='57493.Aktif'> </td>
                </tr>
                <tr>
                    <td><cf_get_lang dictionary_id="58028.Formül"></td>
                    <td><cfinput type="text" name="formula_name" style="width:150px;" value="#get_formula.formula_name#"></td>
                </tr>
                <cfset product_name = ''>
                <cfif len(get_formula.formula_stock_id)>
                    <cfquery name="get_product_name" datasource="#dsn3#">
                        SELECT PRODUCT_NAME FROM STOCKS WHERE STOCK_ID = #get_formula.formula_stock_id#
                    </cfquery>
                    <cfif get_product_name.recordcount>
                        <cfset product_name = ValueList(get_product_name.product_name,',')>
                    </cfif>
                </cfif>
                <tr>
                    <td><cf_get_lang dictionary_id ='57657.Product'></td>
                    <td>
                        <cfoutput>
                            <input type="hidden" name="stock_id" id="stock_id" value="#get_formula.formula_stock_id#">
                            <input type="text" name="product_name" id="product_name" value="#product_name#" style="width:150px;" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','STOCK_ID','stock_id','','3','150');">
                        </cfoutput>
                        <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&ajax_form=1&field_name=add_product_formula.product_name&field_id=stock_id', 'list');"><img border="0" src="/images/plus_thin.gif" align="absmiddle" title="<cf_get_lang dictionary_id='37786.Ürün Seç'>"></a>
                    </td>
                </tr>
			</table>
			<div id="configurator_save_divid"></div>
			<div id="configurator_save_divid2"></div>
			<cf_popup_box_footer>
				<cf_record_info query_name="get_formula">
				<cf_workcube_buttons type_format='1' is_upd = '1' is_delete='0' add_function='configurator_save()'>
			</cf_popup_box_footer>
    </cfform>
</cf_popup_box>
<script type="text/javascript">
    var adres = '<cfoutput>#request.self#?fuseaction=product.emptypopup_detail_formula&product_formula_id=#attributes.id#'</cfoutput>;
    AjaxPageLoad(adres,'configurator_save_divid','1',"Bekleyiniz!");			
    var adres = '<cfoutput>#request.self#?fuseaction=product.emptypopup_detail_formula_row&product_formula_id=#attributes.id#'</cfoutput>;
    AjaxPageLoad(adres,'configurator_save_divid2','1',"Bekleyiniz!");			
	function configurator_save()
	{
		if(document.add_product_formula.formula_name.value == '')
		{
			alert("<cf_get_lang dictionary_id='37226.Lütfen Formül Tanımı Giriniz'>!");
			return false;
		}
		if(document.add_product_formula.stock_id.value == '' || document.add_product_formula.product_name.value == '')
		{
			alert("<cf_get_lang dictionary_id='37237.Lütfen Ürün Seçiniz'>!");
			return false;
		}	
		return true;
	}
</script>
