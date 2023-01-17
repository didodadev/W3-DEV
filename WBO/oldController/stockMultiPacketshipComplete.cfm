<cf_get_lang_set module_name="stock">
<cfif not isdefined("attributes.event") or listfind('list,add',attributes.event)>
    <cf_xml_page_edit fuseact="stock.detail_multi_packetship">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.document_number" default="">
    <cfparam name="attributes.start_date" default="">
    <cfparam name="attributes.finish_date" default="">
    <cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
        <cf_date tarih='attributes.start_date'>
    <cfelse>
        <cfif session.ep.our_company_info.unconditional_list><cfset attributes.start_date=''><cfelse><cfset attributes.start_date=wrk_get_today()></cfif>
    </cfif>	
    <cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
        <cf_date tarih='attributes.finish_date'>
    <cfelse>
        <cfif session.ep.our_company_info.unconditional_list><cfset attributes.finish_date=''><cfelse><cfset attributes.finish_date = date_add('d',1,now())></cfif>
    </cfif>
    <cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.consumer_id" default="">
    <cfparam name="attributes.company" default="">
    <cfparam name="attributes.location_id" default="">
    <cfparam name="attributes.department_id" default="">
    <cfparam name="attributes.department_name" default="">
    <cfparam name="attributes.process_stage_type" default="">
    <cfparam name="attributes.error_case_type" default="">
    <cfparam name="attributes.problem_case_type" default="">
    <cfparam name="attributes.problem_type" default="">
    <cfparam name="attributes.team_code" default="">
    <cfparam name="attributes.planning_date" default="#dateFormat(now(),'dd/mm/yyyy')#">
    <cf_date tarih="attributes.planning_date">
    <cfquery name="get_planning_info" datasource="#dsn3#">
        SELECT PLANNING_ID,PLANNING_DATE,TEAM_CODE FROM DISPATCH_TEAM_PLANNING WHERE PLANNING_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.planning_date#">
    </cfquery>
    <cfquery name="get_packetship_stage" datasource="#dsn#">
        SELECT
            PTR.STAGE,
            PTR.PROCESS_ROW_ID 
        FROM
            PROCESS_TYPE_ROWS PTR,
            PROCESS_TYPE_OUR_COMPANY PTO,
            PROCESS_TYPE PT
        WHERE
            PT.IS_ACTIVE = 1 AND
            PT.PROCESS_ID = PTR.PROCESS_ID AND
            PT.PROCESS_ID = PTO.PROCESS_ID AND
            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listfirst(attributes.fuseaction,'.')#.list_packetship%">
        ORDER BY
            PTR.LINE_NUMBER
    </cfquery>
    <cfquery name="get_error_case" datasource="#dsn#">
        SELECT ERROR_CASE_ID, ERROR_CASE_NAME FROM PACKETSHIP_ERROR_CASE ORDER BY ERROR_CASE_NAME
    </cfquery>
    <cfquery name="get_problem_case" datasource="#dsn#">
        SELECT PROBLEM_CASE_ID, PROBLEM_CASE_NAME FROM PACKETSHIP_PROBLEM_CASE ORDER BY PROBLEM_CASE_NAME
    </cfquery>
    <cfif isdefined("attributes.form_submitted")>
        <cfquery name="get_packetship_result" datasource="#dsn2#">
            SELECT 
                (SELECT FULLNAME FROM #dsn_alias#.COMPANY WHERE COMPANY_ID = O.COMPANY_ID) FULLNAME,
                (SELECT CONSUMER_NAME + ' ' + CONSUMER_SURNAME AS CONSUMER_NAME FROM #dsn_alias#.CONSUMER WHERE CONSUMER.CONSUMER_ID = O.CONSUMER_ID) CONSUMER_NAME,
                ISNULL(ORR.DELIVER_DATE,O.DELIVERDATE) DELIVER_DATE,
                (SELECT DEPARTMENT_HEAD FROM #DSN_ALIAS#.DEPARTMENT WHERE DEPARTMENT_ID = ISNULL(ORR.DELIVER_DEPT,O.DELIVER_DEPT_ID) ) AS DEPARTMENT_HEAD,
                (SELECT COMMENT FROM #DSN_ALIAS#.STOCKS_LOCATION WHERE LOCATION_ID = ISNULL(ORR.DELIVER_LOCATION,O.LOCATION_ID) AND DEPARTMENT_ID = ISNULL(ORR.DELIVER_DEPT,O.DELIVER_DEPT_ID)) AS COMMENT,
                O.ORDER_NUMBER,
                (SELECT BRANCH_NAME FROM #DSN_ALIAS#.BRANCH WHERE BRANCH_ID = O.FRM_BRANCH_ID) BRANCH_NAME,
                ORR.PRODUCT_NAME,
                ORR.SPECT_VAR_NAME,
                SRR.SHIP_RESULT_ID,
                SRR.WRK_ROW_ID
            FROM
                SHIP_RESULT_ROW SRR,
                #dsn3_alias#.ORDERS O,
                #dsn3_alias#.ORDER_ROW ORR
            WHERE 
                O.ORDER_ID = ORR.ORDER_ID AND
                SRR.WRK_ROW_RELATION_ID = ORR.WRK_ROW_ID AND
                ((ISNULL(SRR.INVOICE_ID,SRR.SHIP_ID) IS NOT NULL AND SRR.IS_PROBLEM = 0) OR (ISNULL(SRR.INVOICE_ID,SRR.SHIP_ID) IS NULL AND SRR.IS_PROBLEM = 1)) AND
                (
                    (ORR.WRK_ROW_ID IN (SELECT WRK_ROW_RELATION_ID FROM SHIP_ROW WHERE WRK_ROW_RELATION_ID = ORR.WRK_ROW_ID AND WRK_ROW_RELATION_ID IS NOT NULL)) OR
                    (ORR.WRK_ROW_ID IN (SELECT WRK_ROW_RELATION_ID FROM INVOICE_ROW WHERE WRK_ROW_RELATION_ID = ORR.WRK_ROW_ID AND WRK_ROW_RELATION_ID IS NOT NULL))
                ) AND
                SRR.SHIP_RESULT_ID IN 	(	SELECT
                                                SR.SHIP_RESULT_ID
                                            FROM
    
                                                SHIP_RESULT SR
                                            WHERE
                                                SR.IS_ORDER_TERMS = 1 AND
                                                SR.MAIN_SHIP_FIS_NO IS NOT NULL AND
                                                SR.SHIP_METHOD_TYPE IS NOT NULL
                                                <cfif Len(attributes.planning_date)>
                                                    AND SR.OUT_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.planning_date#">
                                                </cfif>
                                                <cfif Len(attributes.team_code)>
                                                    AND SR.EQUIPMENT_PLANNING_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.team_code#">
                                                </cfif>
                                                <cfif len(attributes.keyword)>
                                                    AND (SR.SHIP_FIS_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR SR.REFERENCE_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)
                                                </cfif>
                                                <cfif len(attributes.process_stage_type)>
                                                    AND SR.SHIP_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage_type#">
                                                </cfif>
                                                
                                                <cfif len(attributes.start_date)>
                                                    AND SR.OUT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
                                                </cfif>
                                                <cfif len(attributes.finish_date)>
                                                    AND SR.OUT_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
                                                </cfif>
                                        )
                <cfif Len(attributes.error_case_type) or Len(attributes.problem_case_type) or Len(attributes.problem_type)>
                    AND SRR.WRK_ROW_ID IN	(	SELECT
                                                    WRK_ROW_RELATION_ID
                                                FROM
                                                    SHIP_RESULT_ROW_COMPLETE
                                                WHERE
                                                    1 = 1
                                                    <cfif Len(attributes.error_case_type)>
                                                        AND ERROR_CASE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.error_case_type#">
                                                    </cfif>
                                                    <cfif Len(attributes.problem_case_type)>
                                                        AND PROBLEM_CASE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.problem_case_type#">
                                                    </cfif>
                                                    <cfif Len(attributes.problem_type) and ListFind("0,1",attributes.problem_type,',')>
                                                        AND PROBLEM_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.problem_type#">
                                                    <cfelseif Len(attributes.problem_type) and not ListFind("0,1",attributes.problem_type,',')>
                                                        AND PROBLEM_RESULT_ID IS NULL
                                                    </cfif>
                                            )
                </cfif>
                <cfif len(attributes.document_number)>
                    AND O.ORDER_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.document_number#%">
                </cfif>
                <cfif len(attributes.company_id) and len(attributes.company)>
                    AND O.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
                <cfelseif len(attributes.consumer_id) and len(attributes.company)>
                    AND O.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
                </cfif>
                <cfif len(attributes.location_id) and len(attributes.department_id) and len(attributes.department_name)>
                    AND ISNULL(ORR.DELIVER_LOCATION,O.LOCATION_ID) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.location_id#">
                    AND ISNULL(ORR.DELIVER_DEPT,O.DELIVER_DEPT_ID) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
                </cfif>
            ORDER BY
                RECORD_DATE
        </cfquery>
    <cfelse>
        <cfset get_packetship_result.recordCount = 0>
    </cfif>
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfparam name="attributes.totalrecords" default='#get_packetship_result.recordcount#'>
</cfif>
<script type="text/javascript">
	<cfif not isdefined("attributes.event") or attributes.event is 'list'>
		 function depot_date_change()
			{
				var get_planning_info_js =  wrk_safe_query('stk_get_planning_info','dsn3',0,js_date(document.form_complete.planning_date.value));
				for(j=get_planning_info.recordcount;j>=0;j--)
					document.form_complete.team_code.options[j] = null;
				
				document.form_complete.team_code.options[0]= new Option('Ekip - Araç','');
				if(get_planning_info_js.recordcount)
					for(var jj=0;jj < get_planning_info_js.recordcount;jj++)
						document.form_complete.team_code.options[jj+1]=new Option(get_planning_info_js.TEAM_CODE[jj],get_planning_info_js.PLANNING_ID[jj]);
			}
	$(document).ready(function(){
		document.getElementById('keyword').focus();
		});
	
	function kontrol()
	{
		if(!date_check (document.getElementById('start_date'),document.getElementById('finish_date'),"<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Önce Olamaz'>!") )	
			return false;
		else
			return true;
	}
	function control_form()
	{
		if(document.form_complete.team_code.value == '')
		{
			alert("<cf_get_lang no='160.Ekip Seçmelisiniz'> !");
			return false;
		}
		return true;
	}
	
	function check_all_complete()
	{
		<cfif get_packetship_result.recordcount>
		<cfoutput query="get_packetship_result" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			if(document.packetship_complete.row_problem_type_#currentrow#.value != 1)
				document.packetship_complete.row_problem_type_#currentrow#.value = 0; //Sorunsuz Degeri = 0
		</cfoutput>
		</cfif>
	}
	function problem_control()
	{
		<cfif get_packetship_result.recordcount>
		<cfoutput query="get_packetship_result" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			if(document.packetship_complete.row_problem_type_#currentrow#.value != 1)
			{
				if(document.packetship_complete.row_error_case_type_#currentrow#.value != '')
				{
					alert("<cf_get_lang no='161.Sorunlu Olmayan Durumlar İçin Hata Giremezsiniz'> !");
					return false;
				}
				if(document.packetship_complete.row_problem_case_type_#currentrow#.value != '')
				{
					alert("<cf_get_lang no='162.Sorunlu Olmayan Durumlar İçin Sorunlu Durum Giremezsiniz'> !");
					return false;
				}
			}
		</cfoutput>
		</cfif>
	}
	function control_result()
	{
		<cfif get_packetship_result.recordcount>
		<cfoutput query="get_packetship_result" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			if(document.packetship_complete.row_problem_type_#currentrow#.value == 1)
			{
				if(document.packetship_complete.row_error_case_type_#currentrow#.value == '')
				{
					alert("Sorunlu Olan Durumlar İçin Hata Girmelisiniz ! Satır:"+#currentrow#);
					return false;
				}
				if(document.packetship_complete.row_problem_detail_#currentrow#.value == '')
				{
					alert("Sorunlu Olan Durumlar İçin Açıklama Girmelisiniz ! Satır:"+#currentrow#);
					return false;
				}
				if(document.packetship_complete.row_problem_case_type_#currentrow#.value == '')
				{
					alert("Sorunlu Olan Durumlar İçin Sorunlu Durum Girmelisiniz ! Satır:"+#currentrow#);
					return false;
				}
			}
		</cfoutput>
		</cfif>
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
		
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'stock.list_multi_packetship_complete';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'stock/display/list_multi_packetship_complete.cfm';
	WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'stock/display/list_multi_packetship_complete.cfm';
	WOStruct['#attributes.fuseaction#']['list']['nextEvent'] = 'stock.list_multi_packetship_complete';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'stock.list_multi_packetship_complete';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'stock/display/list_multi_packetship_complete.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] =  'stock/query/add_multi_packetship_complete.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'stock.list_multi_packetship_complete&event=list';
/*	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'stock.list_multi_packetship&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'stock/form/upd_multi_packetship.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] =  'stock/query/upd_multi_packetship.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'stock.list_multi_packetship&event=upd';	
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'main_ship_fis_no=##main_ship_fis_no##';
	WOStruct['#attributes.fuseaction#']['upd']['identity'] = '##main_ship_fis_no##';	
	
	
	if(isdefined("attributes.event") and (attributes.event is 'upd' or attributes.event is 'del') )      
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'stock.list_multi_packetship';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'stock/query/del_packetship.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'stock/query/del_packetship.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'stock.list_multi_packetship';

	}
	if(isdefined("attributes.event") and attributes.event is 'upd')      
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1966]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['customTag'] = '<cf_get_workcube_related_acts period_id="#session.ep.period_id#" company_id="#session.ep.company_id#" asset_cat_id="-24" module_id="13" action_section="SHIP_RESULT_ID" action_id="#get_ship_results_all.ship_result_id#">';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=stock.list_multi_packetship&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&keyword=#attributes.main_ship_fis_no#&print_type=32','list')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}*/
</cfscript>
