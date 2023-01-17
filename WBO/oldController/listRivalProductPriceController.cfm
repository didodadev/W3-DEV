<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
   	<cfinclude template="../product/query/get_prod_unit_with_func.cfm">
    <cfinclude template="../product/query/get_rivals.cfm">
    <cfparam name="attributes.keyword" default="">
    <cfif isdefined("attributes.is_submit")>
        <cfinclude template="../product/query/get_rival_price_list.cfm">
    <cfelse>
        <cfset get_rival_prices.recordcount = 0>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.pid" default="">
    <cfparam name="attributes.txt_product" default="">
    <cfparam name="attributes.r_id" default="">
    <cfif not len(attributes.maxrows)><cfset attributes.maxrows = 20></cfif>
    <cfparam name="attributes.totalrecords" default=#get_rival_prices.recordcount#>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfelseif isdefined("attributes.event") and listfindnocase('add,upd',attributes.event)>
	<cfinclude template="../product/query/get_rivals.cfm">
    <cfinclude template="../product/query/get_money.cfm">
    <cfinclude template="../product/query/get_unit.cfm">    
	<cfif attributes.event is 'upd'>
        <cfinclude template="../product/query/get_rival_price.cfm">       
        <cfset attributes.product_unit_id=get_rival_price.unit_id >
        <cfinclude template="../product/query/get_product_unit.cfm">
    </cfif>
</cfif>  

<cfif isdefined("attributes.event") and listfindnocase('add,upd',attributes.event)>
	<script type="text/javascript">
		function unformat_fields()
		{
			if(document.price.money.value == 0)
			{
				alert("Para Birimi Girmelisiniz!");
				return false;
			}
			<cfif isdefined("attributes.event") and attributes.event is 'add'>
				if(document.price.r_id.value == '')
				{
					alert("Rakip Girmelisiz!");
					return false;
				}
				if(document.price.txt_product.value == 0)
				{
					alert("Ürün Seçmelisiniz!");
					return false;
				}
			</cfif>
			document.price.price.value = filterNum(document.price.price.value);
			return true;
		}
	</script>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();	
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'product.list_rival_product_prices';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'product/display/list_rival_product_price.cfm';
	WOStruct['#attributes.fuseaction#']['list']['default'] = 1;	
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.popup_form_add_rival_product_price';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'product/form/add_rival_product_price.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'product/query/add_rival_product_price.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'product.list_rival_product_prices';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'product.popup_form_upd_rival_product_price';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'product/form/upd_rival_product_price.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'product/query/upd_rival_product_price.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'product.list_rival_product_prices';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'PR_ID=##attributes.PR_ID##&pid=##PRODUCT_ID##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.PR_ID##';
	
	WOStruct['#attributes.fuseaction#']['del'] = structNew();
	WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
	WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'product.emptypopup_del_rival_product_price';
	WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'product/query/del_rival_product_price.cfm';
	WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'product/query/del_rival_product_price.cfm';
	WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'product.list_rival_product_prices';
	WOStruct['#attributes.fuseaction#']['del']['parameters'] = 'PR_ID=##attributes.PR_ID##';
	WOStruct['#attributes.fuseaction#']['del']['Identity'] = '##attributes.PR_ID##';
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'listRivalProductPriceController';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'PRICE_RIVAL';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-txt_product','item-r_id','item-price','item-startdate']";
</cfscript>