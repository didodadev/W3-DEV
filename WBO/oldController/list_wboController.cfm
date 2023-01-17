<cfif not isdefined('attributes.formSubmittedController') and isdefined("attributes.event") and (attributes.event is 'det' or attributes.event is 'upd')>
    <cfparam name="attributes.keyword" default="">
    <cfset list_wbo = createObject("component", "development.cfc.list_wbo")>
    <cfset WBO_TYPES = list_wbo.getWboList()>
    <cfif not isdefined("attributes.woid")>
        <cfset attributes.woid = list_wbo.getWrkObjectsId('#DSN#','#attributes.fuseact#')>
    </cfif>
    <cfset GET_WRK_FUSEACTIONS = list_wbo.getWrkFuesactions('#DSN#','#attributes.woid#')>
    <cfset GET_MODULES = list_wbo.getWbo('#dsn#')>
    <cfset wbo_type_list = list_wbo.getWboTypeList('#GET_WRK_FUSEACTIONS.TYPE#','#GET_WRK_FUSEACTIONS.IS_ADD#','#GET_WRK_FUSEACTIONS.IS_UPDATE#','#GET_WRK_FUSEACTIONS.IS_DELETE#')>
    <cfset getSolution = list_wbo.getSolution()>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['systemObject'] = structNew();	
	WOStruct['#attributes.fuseaction#']['systemObject']['dataSourceName'] = dsn; // Transaction icin yapildi.*/
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'dev.list_wbo';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'development/display/list_wbo.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'dev.add_fuseaction';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'development/form/add_fuseaction.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'development/query/add_fuseaction.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'dev.list_wbo&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'dev.upd_fuseaction';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'development/form/upd_fuseaction.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'development/query/upd_fuseaction.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'dev.list_wbo&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'woid=##wrk_objects_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.fuseact##';
	
	
	if(isdefined("attributes.event") and (attributes.event is 'det'))
	{
		WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'dev.list_wbo';
		WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'dev/display/list_wbo.cfm';
		WOStruct['#attributes.fuseaction#']['det']['pageParams'] = structNew();
		WOStruct['#attributes.fuseaction#']['det']['pageParams']['size'] = '8-4;8';
		
		WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][0]['type'] = 0;
		WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][0]['referenceController']  = 'list_wboController.cfm';
		WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][0]['referenceEvent']  = 'upd';
		
		WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][0]['type'] = 2;
		WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][0]['file'] = '#request.self#?fuseaction=dev.form_upd_fuseaction_ajax&field_wrk_ids=wrk_object_id&woid=#GET_WRK_FUSEACTIONS.wrk_objects_id#';
		WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][0]['title'] = 'İlişkili Fuseactionlar';
		WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][0]['id'] = 'get_fuseaction';
		
		WOStruct['#attributes.fuseaction#']['det']['pageObjects'][2][1]['type'] = 2;
		WOStruct['#attributes.fuseaction#']['det']['pageObjects'][2][1]['file'] = '#request.self#?fuseaction=dev.emptypopup_ajax_project_works&woid=#attributes.woid#&fbx=#get_wrk_fuseactions.fuseaction#';
		WOStruct['#attributes.fuseaction#']['det']['pageObjects'][2][1]['title'] = '#lang_array_main.item[608]#';
		WOStruct['#attributes.fuseaction#']['det']['pageObjects'][2][1]['id'] = 'get_work';
	
		WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][1]['type'] = 1;
		WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][1]['file'] = '<cf_get_workcube_note action_section="COMPANY_ID" action_id="1" style="1">';
		
		WOStruct['#attributes.fuseaction#']['det']['pageObjects'][2][0]['type'] = 2;
		WOStruct['#attributes.fuseaction#']['det']['pageObjects'][2][0]['file'] = '#request.self#?fuseaction=dev.form_upd_box_ajax&field_wrk_ids=wrk_object_id&woid=#get_wrk_fuseactions.wrk_objects_id#';
		WOStruct['#attributes.fuseaction#']['det']['pageObjects'][2][0]['title'] = 'Insert Query';
		WOStruct['#attributes.fuseaction#']['det']['pageObjects'][2][0]['id'] = 'get_insert';
	}

	// Tab Menus //
	tabMenuStruct = StructNew();
	tabMenuStruct['#attributes.fuseaction#'] = structNew();
	tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
	// Upd //
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[61]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "alert('burada')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=dev.popup_fuseaction_history&woid=##attributes.woid##','medium','popup_fuseaction_history')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=dev.popup_fuseaction_history&woid=##attributes.woid##','medium','popup_fuseaction_history')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = 'Ekle';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=dev.list_wbo&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}

</cfscript>
<cfif not isdefined('attributes.formSubmittedController')><!---formSubmittedController : sayfa query sayfasi ise buraya girmesin --->
	<script type="text/javascript">
        $( "#clickme" ).click(function() {
          $( "#editor_id" ).toggle( "slow", function() {
          });
        });
        function check_type()
        {
            if(document.getElementById('wbo_type').value == "")
            {
                alert("Detayları Görmek İçin Dosya Tipi     Seçmelisiniz !");
            }
        }
        
        function loadFamilies(solutionId,target,related,selected)
        {
            $('#'+related+" option[value!='']").remove();
            $.ajax({
                  url: '/V16/WMO/GeneralFunctions.cfc?method=getFamily&dsn=<cfoutput>#dsn#</Cfoutput>&solutionId=' + solutionId,
                  success: function(data) {
                    if(data)
                    {
                        $('#'+target+" option[value!='']").remove();
                        data = $.parseJSON( data );
                        for(i=0;i<data.DATA.length;i++)
                        {
                            var option = $('<option/>');
                            if(selected && selected == data.DATA[i][0])
                                option.attr({ 'value': data.DATA[i][0], 'selected':'selected' }).text(data.DATA[i][1]);
                            else
                                option.attr({ 'value': data.DATA[i][0] }).text(data.DATA[i][1]);
                            $('#'+target).append(option);
                        }
                    }
                  }
               });
        }
        function loadModules(familyId,target,selected)
        {
            $.ajax({
                  url: '/V16/WMO/GeneralFunctions.cfc?method=getModule&dsn=<cfoutput>#dsn#</Cfoutput>&familyId=' + familyId,
                  success: function(data) {
                    if(data)
                    {
                        $('#'+target+" option[value!='']").remove();
                        data = $.parseJSON( data );
                        for(i=0;i<data.DATA.length;i++)
                        {
                            var option = $('<option/>');
                            if(selected && selected == data.DATA[i][0])
                                option.attr({ 'value': data.DATA[i][0], 'selected':'selected' }).text(data.DATA[i][1]);
                            else
                                option.attr({ 'value': data.DATA[i][0] }).text(data.DATA[i][1]);
                            $('#'+target).append(option);
                        }
                    }
                  }
               });
        }
        
        //document.getElementById('txt_fuseaction').focus();

        
        function fuseaction_to_delRow(yer)
        {
            flag_custag = document.getElementById('tbl_to_names_row_count_').value;
            if(flag_custag > 0)
            {
                try{document.upd_faction.wrk_object_id[yer].value = '';}catch(e){}
            }
            else
            {
                try{document.upd_faction.wrk_object_id.value = '';}catch(e){}
            }
            document.getElementById('fuseaction_to_row' + yer).style.display = "none";
            
        }
        
        function check_fuseaction()
        {
            if(document.getElementById('txt_fuseaction').value.length > 2)
            {
                this_fuseaction_name = document.getElementById('txt_fuseaction').value;
                //get_fuseaction_ = wrk_safe_query('obj_get_fuseaction','dsn',0,this_fuseaction_name);
                _show_(this_fuseaction_name);
            }
            return false;
        }
        
        function _show_(this_fuseaction_name)
        {
            if(document.getElementById('check_fuseaction_layer') != undefined)
            {
                goster(check_fuseaction_layer);
                AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=dev.emptypopup_get_fuseaction&fbx_name=' + this_fuseaction_name,'check_fuseaction_layer',1);
            }
            else
                setTimeout('_show_("'+this_fuseaction_name+'")',20);
        } 
        
        function change_window()
        {
            if(document.getElementById('type').value == 'query')
                document.getElementById('window_name').value ='emptypopup';
        }
		$(document).ready(function () {
			show_process_cat();
		});
		function show_process_cat(use_process_cat,process_cat)
        {
            if(document.getElementById('use_process_cat').checked == true)
                 document.getElementById('process_cat').style.display = '';
			else
				document.getElementById('process_cat').style.display = 'none';
        }
    </script>
</cfif>
