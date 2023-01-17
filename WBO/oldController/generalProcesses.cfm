<cf_get_lang_set module_name="process">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cfsetting showdebugoutput="no">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.project_id" default="">
    <cfparam name="attributes.project_head" default="">
    <cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
    <cfif isdefined('attributes.is_submitted')>
        <cfquery name="get_general_processes" datasource="#dsn#">
            SELECT
                PM.PROCESS_MAIN_ID,
                PM.PROCESS_MAIN_HEADER,
                PM.PROJECT_ID,
                PM.RECORD_EMP,
                PM.RECORD_DATE
            FROM
                PROCESS_MAIN PM
            WHERE
                PM.PROCESS_MAIN_ID IS NOT NULL
                <cfif len(attributes.keyword)>
                    AND PM.PROCESS_MAIN_HEADER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                </cfif>
                <cfif len(attributes.project_id) and len(attributes.project_head)>
                    AND PM.PROJECT_ID = #attributes.project_id#
                </cfif>
        </cfquery>
    <cfelse>
        <cfset get_general_processes.recordcount = 0>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default='#get_general_processes.recordcount#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfelseif (isdefined("attributes.event") and attributes.event is 'upd')> 
    <cfquery name="get_main_process" datasource="#DSN#">
        SELECT * FROM PROCESS_MAIN WHERE PROCESS_MAIN_ID = #attributes.process_id#
    </cfquery>
    <cfquery name="get_process_type" datasource="#dsn#">
        SELECT
            PMR.PROCESS_MAIN_ROW_ID,
            PMR.PROCESS_ID,
            PMR.PROCESS_CAT_ID,
            PMR.DESIGN_TITLE,
            PMR.DESIGN_OBJECT_TYPE,
            CASE WHEN (PMR.PROCESS_ID IS NOT NULL) 
                THEN
                    (SELECT PROCESS_NAME FROM PROCESS_TYPE WHERE PROCESS_ID = PMR.PROCESS_ID)
                ELSE
                    (SELECT PROCESS_CAT FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = PMR.PROCESS_CAT_ID)
                END AS title,
            CASE WHEN (PMR.PROCESS_ID IS NOT NULL) 
                THEN
                    (SELECT IS_ACTIVE FROM PROCESS_TYPE WHERE PROCESS_ID = PMR.PROCESS_ID)
                ELSE
                    1
                END AS is_active
        FROM
            PROCESS_MAIN_ROWS PMR
        WHERE
            PMR.PROCESS_MAIN_ID = #attributes.process_id#
        ORDER BY
            RECORD_DATE
    </cfquery> 
</cfif>

<script type="text/javascript">
//Event : list
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	document.getElementById('keyword').focus();
<cfelseif (isdefined("attributes.event") and attributes.event is 'upd')>
	function check()
	{
		if (document.upd_process.process_name.value == '')
		{
			alert("<cf_get_lang no='45.Süreç Adı Girmelisiniz'> !");
			return false;
		} 
		else
		return true;
	}
<cfelseif (isdefined("attributes.event") and attributes.event is 'det')>
	function getCSSColors()
	{
		try
		{
			var bg_color = $("#color_list").length != null ? rgbToHex($("#color_list").css("background-color")): "";
			var border_color = $("#color_border").length != null ? rgbToHex($("#color_border").css("background-color")): "";
			var flashObj = document.gp_visual_designer ? document.gp_visual_designer: document.getElementById("gp_visual_designer");
			if (flashObj) flashObj.applyCSS(bg_color, border_color);
		} catch (e) { }
	}
	
	function rgbToHex(value)
	{
		if (value.search("rgb") == -1)
			return value;
		else {
			value = value.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/);
			function hex(x) {
				return ("0" + parseInt(x).toString(16)).slice(-2);
			}
			return "#" + hex(value[1]) + hex(value[2]) + hex(value[3]);
		}
	}
</cfif>

</script>


<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined("attributes.event")) attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'process.general_processes';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'process/display/general_processes.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'process.general_processes';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'process/form/add_main_process.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'process/query/add_main_process.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'process.general_processes&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'process.general_processes';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'process/form/upd_main_process.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'process/query/upd_main_process.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'process.general_processes&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'process_id=##attributes.process_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.process_id##';
	
	WOStruct['#attributes.fuseaction#']['det'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'process.general_processes';
	WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'process/display/gp_visual_designer.cfm';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = '';
	WOStruct['#attributes.fuseaction#']['det']['parameters'] = '';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.main_process_id##';
	
	// Tab Menus //
	tabMenuStruct = StructNew();
	tabMenuStruct['#attributes.fuseaction#'] = structNew();
	tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
	
	// Upd //	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
   
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array.item[7]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['href'] = "#request.self#?fuseaction=process.gp_visual_designer&main_process_id=#attributes.process_id#";
		if (len(get_main_process.project_id) and get_main_process.recordcount)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array.item[149]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['href'] = "#request.self#?fuseaction=project.prodetail&id=#get_main_process.project_id#";
		}
		else
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array.item[150]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['href'] = "#request.self#?fuseaction=project.addpro&main_process_id=#get_main_process.PROCESS_MAIN_ID#";
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=process.form_add_main_process";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";

		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
