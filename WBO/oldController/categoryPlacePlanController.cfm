<cf_get_lang_set module_name="stock">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.keyword" default="">
    <cfinclude template="../product/query/get_stores.cfm">
    <cfif fuseaction contains "popup">
      <cfset is_popup=1>
     <cfelse>
      <cfset is_popup=0>
    </cfif>
    <cfif fusebox.circuit is 'store'>
        <cfset attributes.branch_id = listgetat(session.ep.user_location,2,'-')>
    </cfif>
    <cfif isdefined("attributes.form_submitted")>
            <cfinclude template="../stock/query/get_pro_cat_place_all.cfm">
    <cfelse>
            <cfset get_pro_cat_place.recordcount=0>
    </cfif>
    <cfinclude template="../stock/query/get_pro_cat_place.cfm">
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cfinclude template="../stock/query/get_pro_cat_place.cfm">
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function(){
			document.getElementById('keyword').focus();
		});	
	<cfelseif isdefined("attributes.event") and listFindNoCase('add,upd',attributes.event)>
		function kontrol()
		{
			x = (50 - document.getElementById('detail').value.length);
			if ( x < 0 )
			{ 
				alert ("<cf_get_lang_main no='359.Detay'><cf_get_lang_main no ='798.Alanindaki Fazla Karakter Sayısı'> "+ ((-1) * x));
				return false;
			}
			if (!date_check(document.categoryPlan.START_DATE, document.categoryPlan.FINISH_DATE, "<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden büyük olamaz'>!"))
				return false;
			return true;	
		}
	</cfif>
</script>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'stock.popup_add_category_place';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'stock/form/add_category_place.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'stock/query/add_category_place.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'stock.list_category_place';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'stock.popup_upd_category_place';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'stock/form/upd_category_place.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'stock/query/upd_category_place.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'stock.list_category_place';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'pc_place_id=##attributes.pc_place_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.pc_place_id##';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'stock.list_category_place';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'stock/display/list_category_place.cfm';	

	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'categoryPlacePlanController';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'PRODUCT_CAT_PLACE';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-product_cat','item-txt_department_in','item-START_DATE']"; 
	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[15]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=stock.list_category_place&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
</cfscript>