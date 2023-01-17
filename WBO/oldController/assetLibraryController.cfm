<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.lib_cat_id" default="">
<cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfinclude template="../asset/query/get_lib_cat.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_lib_asset.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfset url_string = ''>
<cfif isdefined("attributes.department_id") and len(attributes.department_id)>
	<cfset url_string = "#url_string#&department_id=#attributes.department_id#">
</cfif>
<cfif isdefined("attributes.lib_cat_id") and len(attributes.lib_cat_id)>
	<cfset url_string = "#url_string#&lib_cat_id=#attributes.lib_cat_id#" >
</cfif>
<cfif isdefined("attributes.is_form_submitted") and len(attributes.is_form_submitted)>
	<cfset url_string = "#url_string#&is_form_submitted=#attributes.is_form_submitted#" >
</cfif>
<cfif len(attributes.keyword)>
	<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
</cfif>
<cf_paging page="#attributes.page#" 
	maxrows="#attributes.maxrows#" 
	totalrecords="#attributes.totalrecords#" 
	startrow="#attributes.startrow#" 
	adres="asset.library#url_string#">
<cfquery name="DEP" datasource="#DSN#">
	SELECT 
		DEPARTMENT.DEPARTMENT_ID, 
		DEPARTMENT.DEPARTMENT_HEAD, 
		DEPARTMENT.ADMIN1_POSITION_CODE,
		DEPARTMENT.ADMIN2_POSITION_CODE,
		BRANCH.BRANCH_NAME,
		BRANCH.BRANCH_ID
	FROM 
		DEPARTMENT,
		BRANCH
	WHERE 
		BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID
	ORDER BY
		BRANCH.BRANCH_NAME,
		DEPARTMENT.DEPARTMENT_HEAD
</cfquery>
<cfif isdefined("attributes.event") and attributes.event is 'upd'>
    <cfquery name="GET_LIB_ASSET" datasource="#DSN#">
        SELECT * FROM LIBRARY_ASSET WHERE LIB_ASSET_ID =#attributes.lib_asset_id#
    </cfquery>
</cfif>
<script type="text/javascript">
	document.getElementById('keyword').focus();

	function kontrol()
	{
	
	x = document.form.lib_asset_cat.selectedIndex;
	if (document.form.lib_asset_cat[x].value == "")
		{ 
		alert ("<cf_get_lang_main no='59.eksik veri'>:<cf_get_lang_main no='74.Kategori'> !");
		return false;
		}
		
	x = document.form.department_id.selectedIndex;
	if (document.form.department_id[x].value == "")
		{ 
		alert ("<cf_get_lang_main no='59.eksik veri'>:<cf_get_lang_main no='2234.Lokasyon'>!");
		return false;
		}
	return true;
	}
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'asset.add_library_asset';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'asset/display/add_library_asset.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'asset/query/add_library_asset.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'asset.library&event=upd';

	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'asset.library';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'asset/display/list_it.cfm';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'asset.upd_library_asset';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'asset/display/upd_library_asset.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'asset/query/upd_lib_asset.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'asset.library&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.lib_asset_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.lib_asset_id##';

	if(isdefined("attributes.event") and attributes.event is 'upd')
	{		
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'asset.library&event=upd&lib_asset_id=#get_lib_asset.lib_asset_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'asset/query/del_lib_asset.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'asset/query/del_lib_asset.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'asset.library';
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=asset.library&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);	
	}
</cfscript>
