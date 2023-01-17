<cf_get_lang_set module="product">
<cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
	SELECT
		PRODUCT_CAT.PRODUCT_CATID, 
		PRODUCT_CAT.HIERARCHY, 
		PRODUCT_CAT.PRODUCT_CAT
	FROM 
		PRODUCT_CAT,
		PRODUCT_CAT_OUR_COMPANY PCO
	WHERE 
		PRODUCT_CAT.PRODUCT_CATID = PCO.PRODUCT_CATID AND
		PCO.OUR_COMPANY_ID = #session.ep.company_id# 
	ORDER BY 
		HIERARCHY
</cfquery>
<script type="text/javascript">
    function kontrolProductManager()
    {
   	 if(document.ProductManager.product_manager.value == '')
        {
            alert('Sorumlu Seçmelisiniz!');
            return false;
        } 
        if(($('#comp').val() != '' || $('#brand_name').val() != '' || $('#short_code_name').val() != '') && document.getElementById('cat').selectedIndex > -1)
            return true;
        else
        {
            alert('Lüften filtre seçiniz!');
            return false;
        }
		return true;
    }
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();		
	WOStruct['#attributes.fuseaction#']['default'] = 'upd';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'product.set_product_manager';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'product/display/set_product_manager.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'product/query/set_product_manager.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'product.set_product_manager';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'cat=##attributes.cat##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '';

</cfscript>
