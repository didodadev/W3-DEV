<cf_get_lang_set module_name="stock">
<cfif (isdefined("attributes.event") and attributes.event is 'add') or not isdefined("attributes.event")>
    <cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
    <cfif session.ep.isBranchAuthorization>
		<cfset attributes.basket_id = 45>
    <cfelse>
        <cfset attributes.basket_id = 44>
    </cfif>
    <cfif not isdefined('attributes.type')>
        <cfset attributes.form_add = 1>
    </cfif>
    <cfset search_dep_id = listgetat(session.ep.user_location, 1, '-')>
    <cfinclude template="../stock/query/get_dep_names_for_inv.cfm">
    <cfinclude template="../stock/query/get_default_location.cfm">
    <cfif get_loc.recordcount and get_name_of_dep.recordcount>
        <cfset txt_department_name = get_name_of_dep.department_head & '-' & get_loc.comment>
    <cfelse>
       <cfset txt_department_name = "" >
    </cfif>							
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
   	<cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
	<cfscript>session_basket_kur_ekle(action_id=attributes.ship_id,table_type_id:10,process_type:1);</cfscript>
    <cfquery name="GET_UPD_PURCHASE" datasource="#dsn2#">
        SELECT 
            DISPATCH_SHIP_ID, 
            SHIP_METHOD, 
            PROCESS_STAGE, 
            SHIP_DATE, 
            DELIVER_DATE, 
            LOCATION_OUT, 
            DEPARTMENT_OUT, 
            DELIVER_EMP, 
            DEPARTMENT_IN, 
            LOCATION_IN, 
            MONEY, 
            RATE1, 
            RATE2, 
            DISCOUNTTOTAL, 
            GROSSTOTAL, 
            NETTOTAL, 
            TAXTOTAL, 
            DETAIL, 
            RECORD_EMP, 
            RECORD_DATE, 
            UPDATE_EMP, 
            UPDATE_DATE 
        FROM 
            SHIP_INTERNAL 
        WHERE 
            DISPATCH_SHIP_ID = #url.ship_id#
    </cfquery>
	<cfif len(get_upd_purchase.department_out) and len(get_upd_purchase.location_out)>
        <cfset location_info_ = get_location_info(get_upd_purchase.department_out,get_upd_purchase.location_out)>
    <cfelse>
        <cfset location_info_ = "">
    </cfif>
	<cfif len(get_upd_purchase.ship_method)>
        <cfset attributes.ship_method_id = get_upd_purchase.ship_method>
        <cfinclude template="../stock/query/get_ship_method.cfm">
    </cfif>
    <cfquery name="GET_SHIP" datasource="#DSN2#">
        SELECT SHIP_ID,SHIP_NUMBER FROM SHIP WHERE DISPATCH_SHIP_ID = #attributes.ship_id#
    </cfquery>
	<cfif session.ep.isBranchAuthorization>
        <cfset attributes.basket_id = 45>
    <cfelse>
        <cfset attributes.basket_id = 44>
    </cfif>
</cfif>
<script type="text/javascript">
	function control_depo()
	{
			
	   if(form_basket.txt_departman_.value=="" || form_basket.department_id.value=="")
		{
		   alert("<cf_get_lang no ='425.Çıkış Deposu Seçiniz'>!");
		   return false;
		}
		if(form_basket.department_in_txt.value=="" || form_basket.department_in_id.value=="")
		{
			alert("<cf_get_lang no ='424.Giriş Deposu Seçiniz'>!");
			return false;
		}
		if(form_basket.department_in_id.value == form_basket.department_id.value && form_basket.location_in_id.value == form_basket.location_id.value)
		{
			alert("<cf_get_lang no='174.Giriş ve Çıkış Depoları Aynı Olamaz'>!");
			return false;
		}
		else
		return (process_cat_control() && saveForm());
			
	}
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.add_dispatch_internaldemand';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'stock/form/add_dispatch_internaldemand.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'stock/query/add_dispatch_internaldemand.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.add_dispatch_internaldemand&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['default'] = 1;
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_basket(add_dispatch_internaldemand)";
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.upd_dispatch_internaldemand';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'stock/form/upd_dispatch_internaldemand.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'stock/query/upd_dispatch_internaldemand.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.add_dispatch_internaldemand&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'ship_id=##attributes.ship_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.ship_id##';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_basket(dispatch_internaldemand)";
	
	if(attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array.item[214]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_ship_dispatch&dispatch_ship_id=#attributes.ship_id#";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['target'] = "blank_";
				
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_dispatch_internaldemand&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.ship_id#&print_type=530','page','workcube_print')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);

	}
	
	if(attributes.event is 'upd' or attributes.event is 'del')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_dispatch_internaldemand&del=1&upd_id=#url.ship_id#&head=#location_info_#&event=del';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'stock/query/upd_dispatch_internaldemand.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'stock/query/upd_dispatch_internaldemand.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_purchase';
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'stockDispatchInternaldemand';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'SHIP_INTERNAL';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-txt_departman_','item-process_stage','item-department_in_txt','item-ship_date']"; 
</cfscript>
