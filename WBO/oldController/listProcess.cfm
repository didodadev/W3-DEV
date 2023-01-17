<cf_get_lang_set module_name="process">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cfparam name="attributes.author_id" default="">
    <cfparam name="attributes.author_name" default="">
    <cfparam name="attributes.authority_type" default="0">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.module" default="">
    <cfparam name="attributes.company_id" default="#session.ep.company_id#">
    <cfparam name="attributes.is_active" default="">
    <cfparam name="attributes.is_submitted" default="">
    <cfparam name="attributes.record_name" default="">
    <cfparam name="attributes.process" default="">
    <cfparam name="list_comp" default="">
    <cfquery name="get_modules" datasource="#DSN#">
        SELECT MODULE_ID, MODULE_SHORT_NAME FROM MODULES WHERE MODULE_SHORT_NAME<>'' ORDER BY MODULE_SHORT_NAME
    </cfquery>
    <cfquery name="get_company" datasource="#dsn#">
        SELECT COMP_ID,NICK_NAME FROM OUR_COMPANY ORDER BY NICK_NAME
    </cfquery>
    <cfquery name="get_process" datasource="#DSN#">
        SELECT
            PM.PROCESS_MAIN_ID,
            PM.PROCESS_MAIN_HEADER
        FROM
            PROCESS_MAIN PM
        WHERE
            PM.PROCESS_MAIN_ID IS NOT NULL
    </cfquery>
    <cfif isdefined("attributes.process") and len(attributes.process)>
        <cfquery name="get_process_id" datasource="#dsn#">
            SELECT PROCESS_ID FROM PROCESS_MAIN_ROWS WHERE PROCESS_MAIN_ID=#attributes.process# AND PROCESS_ID IS NOT NULL 
        </cfquery>
         <cfif len(get_process_id.process_id)>
            <cfset s_process_id=valuelist(get_process_id.process_id,',')>
        <cfelse>
            <cfset s_process_id='Null'>
        </cfif>  
    </cfif>
    <cfif len(attributes.is_submitted)>
        <cfif len(attributes.author_id) and len(attributes.author_name)>
            <cfquery name="GET_ROWS" datasource="#DSN#">
                <cfif attributes.authority_type eq 1 or attributes.authority_type eq 0>
                    SELECT
                        PROCESS_ROW_ID
                    FROM
                        PROCESS_TYPE_ROWS_POSID
                    WHERE
                        PRO_POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.author_id#"> AND
                        PROCESS_ROW_ID IS NOT NULL
                </cfif>
                <cfif attributes.authority_type eq 0>
                    UNION
                </cfif>
                <cfif attributes.authority_type eq 2 or attributes.authority_type eq 0>
                    SELECT
                        PROCESS_ROW_ID
                    FROM
                        PROCESS_TYPE_ROWS_CAUID
                    WHERE
                        CAU_POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.author_id#"> AND
                        PROCESS_ROW_ID IS NOT NULL
                </cfif>
                <cfif attributes.authority_type eq 0>
                    UNION
                </cfif>
                <cfif attributes.authority_type eq 3 or attributes.authority_type eq 0>
                    SELECT
                        PROCESS_ROW_ID
                    FROM
                        PROCESS_TYPE_ROWS_INFID
                    WHERE
                        INF_POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.author_id#"> AND
                        PROCESS_ROW_ID IS NOT NULL
                </cfif>
            </cfquery>
            <cfif get_rows.recordcount>
                <cfquery name="GET_PRO_ID" datasource="#DSN#">
                    SELECT DISTINCT
                        PROCESS_ID
                    FROM 
                        PROCESS_TYPE_ROWS
                    WHERE
                        PROCESS_ROW_ID IN (#valuelist(get_rows.process_row_id,',')#)
                </cfquery>
             <cfelse>
                <cfset get_pro_id.recordcount = 0>
            </cfif>
        <cfelse>
            <cfset get_pro_id.recordcount = 0>
        </cfif>
        <cfif len(attributes.author_id) and len(attributes.author_name) and get_pro_id.recordcount eq 0 and attributes.authority_type neq 0>
            <cfset GET_PROCESS_TYPE.recordcount = 0>
        <cfelse>
            <cfquery name="GET_PROCESS_TYPE" datasource="#DSN#">
             SELECT
                    PROCESS_TYPE.PROCESS_ID,
                    PROCESS_TYPE.PROCESS_NAME,
                    PROCESS_TYPE.FACTION,
                    PROCESS_TYPE.IS_ACTIVE
                FROM
                    PROCESS_TYPE
                WHERE
                    PROCESS_TYPE.PROCESS_ID IS NOT NULL
                    <cfif len(attributes.module)>
                        AND PROCESS_TYPE.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.module#%">
                    </cfif>
                        AND PROCESS_ID IN
                            (
                            SELECT 
                                PTOC.PROCESS_ID
                            FROM 
                                PROCESS_TYPE_OUR_COMPANY PTOC
                            WHERE 
                                PTOC.PROCESS_ID = PROCESS_TYPE.PROCESS_ID 
                                <cfif len(attributes.company_id)>
                                    AND PTOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> 
                                <cfelseif len(attributes.c_id)>
                                    AND PTOC.OUR_COMPANY_ID IN(#attributes.c_id#)
                                </cfif>
                            )
                    <cfif len(attributes.keyword)>
                        AND 
                        (
                            (PROCESS_TYPE.PROCESS_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)
                            OR
                            (PROCESS_TYPE.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)
                        )
                    </cfif>
                    <cfif isdefined("attributes.record_id") and len(attributes.record_id) and IsDefined("attributes.record_name") and len(attributes.record_name)>
                        AND
                            PROCESS_TYPE.RECORD_EMP=#attributes.record_id#
                    </cfif>
                    <cfif isdefined("attributes.process") and len(attributes.process)>
                        AND
                            PROCESS_TYPE.PROCESS_ID IN (#s_process_id#)
                    </cfif>
                    <cfif len(attributes.is_active)>AND PROCESS_TYPE.IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.is_active#"></cfif>
                    <cfif GET_PRO_ID.recordcount>AND PROCESS_TYPE.PROCESS_ID IN (#Valuelist(GET_PRO_ID.PROCESS_ID,',')#)</cfif>
                ORDER BY
                    PROCESS_NAME	
            </cfquery>
        </cfif>
        <cfif get_process_type.recordcount>
            <cfquery name="get_our_company" datasource="#dsn#">
                SELECT 
                    PTOC.OUR_COMPANY_ID,
                    PTOC.PROCESS_ID,
                    OC.COMP_ID,
                    OC.NICK_NAME  
                FROM 
                    PROCESS_TYPE_OUR_COMPANY PTOC,
                    OUR_COMPANY OC 
                WHERE 
                    PTOC.OUR_COMPANY_ID = OC.COMP_ID AND
                    PROCESS_ID IN (#ListSort(listDeleteDuplicates(Valuelist(GET_PROCESS_TYPE.PROCESS_ID,',')),"numeric","asc",",")#) 
                ORDER BY 
                    OC.NICK_NAME
            </cfquery>
        </cfif>
    <cfelse>
        <cfset get_process_type.recordcount = 0>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default='#get_process_type.recordcount#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfelseif (isdefined("attributes.event") and attributes.event is 'add')>
    <cfquery name="Get_Our_Company" datasource="#dsn#">
        SELECT COMP_ID, NICK_NAME FROM OUR_COMPANY ORDER BY NICK_NAME
    </cfquery>
<cfelseif (isdefined("attributes.event") and attributes.event is 'upd')>  
    <cf_xml_page_edit fuseact="process.upd_process">
    <cfquery name="GET_PROCESS" datasource="#DSN#">
        SELECT * FROM PROCESS_TYPE WHERE PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_id#">
    </cfquery>
    <cfquery name="Get_Our_Company" datasource="#dsn#">
        SELECT COMP_ID, NICK_NAME FROM OUR_COMPANY ORDER BY NICK_NAME
    </cfquery>
    <cfquery name="Get_Process_Type_Our_Company" datasource="#dsn#"><!--- Ilıskili Sirketler --->
        SELECT OUR_COMPANY_ID FROM PROCESS_TYPE_OUR_COMPANY WHERE PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_id#">
    </cfquery>
    <cfset Process_Our_Comp_List = ValueList(Get_Process_Type_Our_Company.Our_Company_Id,',')>
</cfif>

<script type="text/javascript">
//Event : list
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	document.getElementById('keyword').focus();
<cfelseif (isdefined("attributes.event") and attributes.event is 'add')>
	function gonder()
	{
		if(add_process.module_field_name.value=="")
			windowopen('<cfoutput>#request.self#?fuseaction=process.popup_dsp_faction_list&field_name=add_process.module_field_name&is_upd=0</cfoutput>','list');
		else
			windowopen('<cfoutput>#request.self#?fuseaction=process.popup_dsp_faction_list&field_name=add_process.module_field_name&is_upd=1</cfoutput>','list');
	}
	function kontrol()
	{
		if(document.add_process.process_our_company_id.value == '')
		{
			alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang_main no='605.İlişkili Şirketler'> !");
			return false;
		}
		return true;
	}
<cfelseif (isdefined("attributes.event") and attributes.event is 'upd')>
	process_stage_div = 'process_stage';
		var send_address_head = '<cfoutput>#request.self#?fuseaction=process.emptypopupajax_dsp_process_stage&process_id=#process_id#</cfoutput>';
		AjaxPageLoad(send_address_head,process_stage_div,1);
		
		function kontrol()
		{
			var obj =  document.getElementById("main_file").value;
			extention = list_getat(obj,list_len(obj,'.'),'.');
			if(obj != '' && extention != 'cfm') 
			{
				alert("<cf_get_lang no ='79.Lütfen Action File İçin cfm Dosyası Seçiniz '>!");
				return false;
			}
			var obj2 =  document.getElementById("main_action_file").value;
			var extention2 = list_getat(obj2,list_len(obj2,'.'),'.');
			if(obj2 != '' && extention2 != 'cfm') 
			{
				alert("<cf_get_lang no ='80.Lütfen Display File İçin cfm Dosyası Seçiniz'> !");
				return false;
			}
		
			if("<cfoutput>#get_process.is_stage_back#</cfoutput>" == 0)
				if(document.getElementById("is_stage_back").checked == true)
				{
					var GET_KONTROL = wrk_safe_query('prc_get_kontrol','dsn',0,<cfoutput>#attributes.process_id#</cfoutput>);
					if(GET_KONTROL.recordcount != 0 && GET_KONTROL.recordcount != undefined)
					{
						alert("<cf_get_lang no ='88.Bu Süreçteki Aşamaların Zorunluluk Kontrollerine Bakınız'>!");
						return false;
					}
				}
			
			if(document.getElementById("process_our_company_id").value == '')
			{
				alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang_main no='605.İlişkili Şirketler'> !");
				return false;
			}
	
			return true;
		}
		
		function gonder()
		{
			if(document.getElementById("module_field_name").value=="")
				windowopen('<cfoutput>#request.self#?fuseaction=process.popup_dsp_faction_list&field_name=upd_process.module_field_name&is_upd=0</cfoutput>','list');
			else
				windowopen('<cfoutput>#request.self#?fuseaction=process.popup_dsp_faction_list&field_name=upd_process.module_field_name&is_upd=1</cfoutput>','list');
		}
		
		function temizle_action()
		{
			document.getElementById("is_main_action_file").value="";
			document.getElementById("main_action_file").style.display="";
			document.getElementById("main_action_file_rex").style.display='none';
			document.getElementById("value11").style.display='';
			document.getElementById("value12").style.display='none';
			document.getElementById("main_action_file_rex").value='';
		}
		
		function temizle()
		{
			document.getElementById("is_main_file").value="";
			document.getElementById("main_file").style.display='';
			document.getElementById("main_file_rex").style.display='none';
			document.getElementById("value21").style.display='';
			document.getElementById("value22").style.display='none';
			document.getElementById("main_file_rex").value='';
		}
<cfelseif (isdefined("attributes.event") and attributes.event is 'det')>
	  function getCSSColors()
		{
			try
			{
				var bg_color = $("#color_list").length != null ? rgbToHex($("#color_list").css("background-color")): "";
				var border_color = $("#color_border").length != null ? rgbToHex($("#color_border").css("background-color")): "";
				var flashObj = document.bpm_visual_designer ? document.bpm_visual_designer: document.getElementById("bpm_visual_designer");
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
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'process.list_process';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'process/display/list_process.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'process.list_process';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'process/form/add_process.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'process/query/add_process.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'process.list_process&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'process.list_process';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'process/form/upd_process.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'process/query/upd_process.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'process.list_process&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'process_id=##attributes.process_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.process_id##';
	
	WOStruct['#attributes.fuseaction#']['det'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'process.list_process';
	WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'process/display/visual_designer.cfm';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = '';
	WOStruct['#attributes.fuseaction#']['det']['parameters'] = '';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.process_id##';
	
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
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "#request.self#?fuseaction=process.visual_designer&process_id=#attributes.process_id#";

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[61]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=process.emtypopup_dsp_process_type_history&process_id=#attributes.process_id#','list','emtypopup_dsp_process_type_history');";
	  
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = '#lang_array_main.item[279]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['onClick'] = "windowopen('#request.self#?fuseaction=process.emtypopup_dsp_process_file_history&process_id=#attributes.process_id#','list','emtypopup_dsp_process_file_history');";
	  
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=process.list_process&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";

		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
