<cf_get_lang_set module_name="purchase">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<!--- Lutfen Sayfaya Filtre vb Eklerken Dikkatli Olalim!!!!!!!! Varolan Yapiyi Bozmayalim FBS 20120501 --->
	<cfif listfirst(fuseaction,'.') is 'correspondence'>
        <cfif listlast(fuseaction,'.') is 'list_purchasedemand'>
            <cf_xml_page_edit fuseact ="correspondence.list_purchasedemand">
        <cfelse>
            <cf_xml_page_edit fuseact ="correspondence.list_internaldemand">
        </cfif>
    <cfelse>
        <cfif listlast(fuseaction,'.') is 'list_purchasedemand'>
            <cf_xml_page_edit fuseact ="purchase.list_purchasedemand">
        <cfelse>
            <cf_xml_page_edit fuseact ="purchase.list_internaldemand">
        </cfif>
    </cfif>
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.location_id" default="">
    <cfparam name="attributes.department_id" default="">
    <cfparam name="attributes.location_in_id" default="">
    <cfparam name="attributes.department_in_id" default="">
    <cfparam name="attributes.txt_departman" default="">
    <cfparam name="attributes.department_in_txt" default="">
    <cfparam name="attributes.internaldemand_stage" default="">
    <cfparam name="attributes.internaldemand_status" default="">
    <cfparam name="attributes.internaldemand_action" default="0">
    <cfparam name="attributes.priority" default="">
    <cfparam name="attributes.add_explain" default="">
    <cfparam name="attributes.group_project" default="">
    <cfparam name="attributes.deliverdate" default= "">
    <cfif not isdefined("attributes.list_type")>
     <cfparam name="attributes.list_type" default="1">
    </cfif>
    <cfif listgetat(attributes.fuseaction,2,'.') contains 'list_purchasedemand'><cfset is_demand = 1><cfelse><cfset is_demand = 0></cfif>
        <cfif isdefined("x_order_by") and x_order_by eq 1>
            <cfparam name="attributes.order_by_date_" default="1">
        <cfelseif isdefined("x_order_by") and x_order_by eq 2>
            <cfparam name="attributes.order_by_date_" default="2">
        <cfelseif isdefined("x_order_by") and x_order_by eq 3>
            <cfparam name="attributes.order_by_date_" default="3">
        <cfelseif isdefined("x_order_by") and x_order_by eq 4>
            <cfparam name="attributes.order_by_date_" default="4">
        <cfelseif isdefined("x_order_by") and x_order_by eq 5>
            <cfparam name="attributes.order_by_date_" default="5">
        <cfelseif isdefined("x_order_by") and x_order_by eq 6>
            <cfparam name="attributes.order_by_date_" default="6">
        <cfelseif isdefined("x_order_by") and x_order_by eq 7>
            <cfparam name="attributes.order_by_date_" default="7">
        <cfelseif isdefined("x_order_by") and x_order_by eq 8>
            <cfparam name="attributes.order_by_date_" default="8">
        <cfelse>
            <cfparam name="attributes.order_by_date_" default="">
        </cfif> 
        <cfif x_list_is_from_employee_id eq 1>
            <cfif not  isdefined('attributes.is_submit') or (isDefined("attributes.from_employee_id") and len(attributes.from_employee_id))>
                <cfparam name="attributes.from_employee_id" default='#session.ep.userid#'><!--- Pozisyon Kod Yerine Userid Tutuluyor --->
                <cfparam name="attributes.from_employee_name" default='#session.ep.name# #session.ep.surname#'>
            <cfelse>
                <cfparam name="attributes.from_employee_id" default=''>
                <cfparam name="attributes.from_employee_name" default=''>
            </cfif>
        <cfelse>
            <cfparam name="attributes.from_employee_id" default=''>
            <cfparam name="attributes.from_employee_name" default=''>
        </cfif>
    <cfif isdefined("xml_to_position_code") and xml_to_position_code eq 1>
        <cfparam name="attributes.to_position_code" default="#session.ep.position_code#">
        <cfparam name="attributes.to_position_name" default= "#session.ep.name# #session.ep.surname#">
    <cfelse>
        <cfparam name="attributes.to_position_code" default="">
        <cfparam name="attributes.to_position_name" default= "">
    </cfif>
    <cfparam name="attributes.from_partner_id" default="">
    <cfparam name="attributes.from_consumer_id" default="">
    <cfparam name="attributes.from_company_id" default="">
    <cfparam name="attributes.product_id" default="">
    <cfparam name="attributes.product_name" default="">
    <cfparam name="attributes.prod_cat" default="">
    <cfparam name="attributes.position_code" default="">
    <cfparam name="attributes.position_name" default="">
    <cfparam name="attributes.project_id" default="">
    <cfparam name="attributes.project_head" default="">
    <cfparam name="attributes.work_id" default="">
    <cfparam name="attributes.work_head" default="">
    <cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.company" default="">
    <cfparam name="attributes.is_active" default="1">
    <cfparam name="attributes.dpl_id" default="">
    <cfparam name="attributes.dpl_no" default="">
    <cfset url_str = "">
    <cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
        <cf_date tarih="attributes.startdate">
    <cfelse>
        <cfif session.ep.our_company_info.unconditional_list>
            <cfset attributes.startdate=''>
        <cfelse> 
            <cfset attributes.startdate = wrk_get_today()>
        </cfif>
    </cfif>
    <cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
        <cf_date tarih="attributes.finishdate">
    <cfelse>
        <cfif session.ep.our_company_info.unconditional_list>
            <cfset attributes.finishdate=''>
        <cfelse>
            <cfset attributes.finishdate = wrk_get_today()>
        </cfif>
    </cfif>
    <cfif isdefined("attributes.deliverdate") and isdate(attributes.deliverdate)>
        <cf_date tarih="attributes.deliverdate">
    </cfif>
    <cfif x_show_authorized_stage eq 1>
        <cf_workcube_process_info>
    </cfif>
    <cfquery name="GET_PROCESS_TYPE" datasource="#DSN#">
        SELECT
            PTR.STAGE,
            PTR.PROCESS_ROW_ID
        FROM
            PROCESS_TYPE_ROWS PTR,
            PROCESS_TYPE_OUR_COMPANY PTO,
            PROCESS_TYPE PT
        WHERE
            PT.IS_ACTIVE = 1 AND
            PTR.PROCESS_ID = PT.PROCESS_ID AND
            PT.PROCESS_ID = PTO.PROCESS_ID AND
            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            <cfif is_demand eq 1>
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listfirst(attributes.fuseaction,'.')#.list_purchasedemand%">
            <cfelse>
                <cfif attributes.list_type eq 2>
                    PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="project.popup_add_project%">
                <cfelse>
                    PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listfirst(attributes.fuseaction,'.')#.list_internaldemand%">
                </cfif>
            </cfif>
            <cfif x_show_authorized_stage eq 1 and isDefined("Process_RowId_List") and ListLen(process_rowid_list)>
                AND PTR.PROCESS_ROW_ID IN (#process_rowid_list#)
            </cfif>
    </cfquery>
    <cfquery name="GET_ADD_EXP" datasource="#DSN3#">
        SELECT BASKET_INFO_TYPE_ID,BASKET_INFO_TYPE FROM SETUP_BASKET_INFO_TYPES
    </cfquery>
    
    <cfif x_is_show_unit eq 1 and attributes.list_type eq 1>
        <cfquery name="GET_PRODUCT_UNITS" datasource="#DSN3#">
            SELECT 
                IS_MAIN,
                ADD_UNIT,
                PRODUCT_ID,
                MULTIPLIER 
            FROM 
                PRODUCT_UNIT 
            WHERE 
                PRODUCT_UNIT_STATUS = 1
        </cfquery>
    </cfif>          
     <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>                           
    <cfif isdefined('attributes.is_submit')>
        <cfif attributes.list_type eq 2>
            <cfinclude template="../../purchase/query/get_project_material_list.cfm">
            <!---<cfinclude template="../query/get_list_internaldemand.cfm"><!---13052015smh--->--->
        <cfelse>
            <cfinclude template="../correspondence/query/get_list_internaldemand.cfm">
        </cfif>
    <cfelse>
        <cfset get_list_internaldemand.recordcount=0>
        <cfset get_list_internaldemand.query_count=0>
    </cfif>
    <cfparam name="attributes.totalrecords" default='#get_list_internaldemand.query_count#'>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	<cfif listgetat(attributes.fuseaction,2,'.') eq 'list_purchasedemand'>
		<cfset is_demand = 1>
    <cfelse>
        <cfset is_demand = 0>
    </cfif>
    <!---<cfif listlast(fuseaction,'.') eq "add_internaldemand">--->
        <cf_xml_page_edit fuseact ="correspondence.add_internaldemand">
    <!---<cfelseif listlast(fuseaction,'.') eq "add_purchasedemand">
        <cf_xml_page_edit fuseact ="correspondence.add_purchasedemand">
    </cfif>--->
    <cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
    <cfinclude template="../correspondence/query/get_priority.cfm">
    <cfif isdefined('attributes.is_from_report')><!--- heg gıda rapor için eklendi 1114 py --->
        <cfset attributes.department_id = form.department_out>
        <cfset attributes.location_id = form.location_out>
        <cfset attributes.department_in_id = form.department_in>
        <cfset attributes.location_in_id = form.location_in>
        <cfset attributes.txt_department_name = get_location_info(attributes.department_id,attributes.location_id)>
        <cfset attributes.department_in_txt = get_location_info(attributes.department_in_id,attributes.location_in_id)>
        <cfset attributes.ref_no = form.convert_p_order_no>
    </cfif>
    <cfif isdefined('attributes.internal_row_info')>
        <!--- Planlama Bazinda --->
        <cfif isDefined("attributes.pro_material_id_list")>
            <cfscript>
                pro_material_id_list ="";
                pro_material_row_id_list = "";
                pro_material_amount_list = "";
                pro_material_work_list = "";
                for(ind_i=1; ind_i lte listlen(attributes.internal_row_info); ind_i=ind_i+1)
                {
                    temp_row_info_ = listgetat(attributes.internal_row_info,ind_i);
                    if(isdefined('add_stock_amount_#replace(temp_row_info_,";","_")#') and len(evaluate('add_stock_amount_#replace(temp_row_info_,";","_")#')) )
                    {
                        pro_material_amount_list = listappend(pro_material_amount_list,filterNum(evaluate('add_stock_amount_#replace(temp_row_info_,";","_")#'),4));
                        pro_material_work_list = listappend(pro_material_work_list,evaluate('work_id#replace(temp_row_info_,";","_")#'));
                        pro_material_row_id_list = listappend(pro_material_row_id_list,listlast(temp_row_info_,';'));
                        if(not listfind(pro_material_id_list,listfirst(temp_row_info_,';')))
                            pro_material_id_list = listappend(pro_material_id_list,listfirst(temp_row_info_,';'));
                    }
                }
            </cfscript>
       <cfelse>
        <cfif isdefined("attributes.internaldemand_id")>
            <cfquery name="getIntRow" datasource="#dsn3#">
                SELECT 
                    IR.I_ROW_ID,
                    IR.QUANTITY - SUM(ISNULL(IRR2.AMOUNT,0)) QUANTITY 
                FROM 
                   INTERNALDEMAND_ROW IR
                        LEFT JOIN INTERNALDEMAND_RELATION_ROW IRR2 ON IRR2.INTERNALDEMAND_ID=IR.I_ID AND IR.I_ROW_ID=IRR2.INTERNALDEMAND_ROW_ID AND IRR2.TO_INTERNALDEMAND_ID IS NOT NULL 
                WHERE
                    IR.I_ID=#attributes.internaldemand_id# AND
                    IR.I_ROW_ID NOT IN 
                        (
                            SELECT 
                                INTERNALDEMAND_ROW_ID
                            FROM
                                INTERNALDEMAND_RELATION_ROW IRR
                            WHERE
                                IRR.INTERNALDEMAND_ID=IR.I_ID AND
                                IR.I_ROW_ID=IRR.INTERNALDEMAND_ROW_ID AND
                                TO_INTERNALDEMAND_ID IS NOT NULL 
                           GROUP BY 
                                INTERNALDEMAND_ROW_ID
                           HAVING
                                IR.QUANTITY - SUM(ISNULL(IRR.AMOUNT,0))<=0
                        )
                         GROUP BY 
                            I_ROW_ID,
                            QUANTITY
            </cfquery>
            <cfscript>
                if (getIntRow.recordcount)
                {
                    internald_row_amount_list =valuelist(getIntRow.QUANTITY,',');
                    internald_row_id_list =valuelist(getIntRow.I_ROW_ID);
                    internaldemand_id_list =attributes.internaldemand_id;
                }
                else
                {
                    internald_row_amount_list ="";
                    internald_row_id_list ="";
                    internaldemand_id_list ="";
                }
            </cfscript>
        <cfelse>
            <cfscript>
                internald_row_amount_list ="";
                internald_row_id_list ="";
                internaldemand_id_list ="";
                for(ind_i=1; ind_i lte listlen(attributes.internal_row_info); ind_i=ind_i+1)
                {
                    temp_row_info_ = listgetat(attributes.internal_row_info,ind_i);
                    if(isdefined('add_stock_amount_#replace(temp_row_info_,";","_")#') and len(evaluate('add_stock_amount_#replace(temp_row_info_,";","_")#')) )
                    {
                        internald_row_amount_list = listappend(internald_row_amount_list,filterNum(evaluate('add_stock_amount_#replace(temp_row_info_,";","_")#'),4));
                        internald_row_id_list = listappend(internald_row_id_list,listlast(temp_row_info_,';'));
                        if(not listfind(internaldemand_id_list,listfirst(temp_row_info_,';')))
                            internaldemand_id_list = listappend(internaldemand_id_list,listfirst(temp_row_info_,';'));
                    }
                }
            </cfscript>
        </cfif>
        <cfif isdefined('internaldemand_id_list') and len(internaldemand_id_list)>
            <cfquery name="GET_INTERNALDEMAND_NUMBER" datasource="#DSN3#">
                SELECT 
                    DISTINCT 
                    INTERNAL_NUMBER
                FROM 
                    INTERNALDEMAND
                WHERE 
                    INTERNAL_ID IN (#internaldemand_id_list#)
            </cfquery>
            <cfset internal_number_list = valuelist(GET_INTERNALDEMAND_NUMBER.INTERNAL_NUMBER,',')>
            <cfquery name="get_internaldemand_info" datasource="#dsn3#">
                SELECT PROJECT_ID,PROJECT_ID_OUT,WORK_ID,LOCATION_OUT,DEPARTMENT_OUT,LOCATION_IN,DEPARTMENT_IN,TARGET_DATE,FROM_POSITION_CODE FROM INTERNALDEMAND WHERE INTERNAL_ID IN (#internaldemand_id_list#)
            </cfquery>
            <cfscript>
                if(ListLen(ListDeleteDuplicates(ValueList(get_internaldemand_info.project_id,',')),',') eq 1)
                    attributes.project_id = ListDeleteDuplicates(ValueList(get_internaldemand_info.project_id,','));
                else
                    attributes.project_id = "";
        
                if(ListLen(ListDeleteDuplicates(ValueList(get_internaldemand_info.project_id_out,',')),',') eq 1)
                    attributes.project_id_out = ListDeleteDuplicates(ValueList(get_internaldemand_info.project_id_out,','));
                else
                    attributes.project_id_out = "";	
        
                if( compare(ValueList(get_internaldemand_info.work_id), ListDeleteDuplicates(ValueList(get_internaldemand_info.work_id))) eq -1)
                    attributes.work_id = "";
                else if(ListLen(ListDeleteDuplicates(ValueList(get_internaldemand_info.work_id,',')),',') eq 1)
                    attributes.work_id = ListDeleteDuplicates(ValueList(get_internaldemand_info.work_id,','));
                else
                    attributes.work_id = "";
                    
                if(ListLen(ListDeleteDuplicates(ValueList(get_internaldemand_info.location_out,',')),',') eq 1)
                    attributes.location_out = ListDeleteDuplicates(ValueList(get_internaldemand_info.location_out,','));
                else
                    attributes.location_out = "";
                    
                if(ListLen(ListDeleteDuplicates(ValueList(get_internaldemand_info.department_out,',')),',') eq 1)
                    attributes.department_out = ListDeleteDuplicates(ValueList(get_internaldemand_info.department_out,','));
                else
                    attributes.department_out = "";
                    
                if(ListLen(ListDeleteDuplicates(ValueList(get_internaldemand_info.location_in,',')),',') eq 1)
                    attributes.location_in = ListDeleteDuplicates(ValueList(get_internaldemand_info.location_in,','));
                else
                    attributes.location_in = "";
                    
                if(ListLen(ListDeleteDuplicates(ValueList(get_internaldemand_info.department_in,',')),',') eq 1)
                    attributes.department_in = ListDeleteDuplicates(ValueList(get_internaldemand_info.department_in,','));
                else
                    attributes.department_in = "";	
                
                if(ListLen(ListDeleteDuplicates(ValueList(get_internaldemand_info.target_date,',')),',') eq 1)
                    attributes.target_date = ListDeleteDuplicates(ValueList(get_internaldemand_info.target_date,','));
                else
                    attributes.target_date = "";	
                 if(ListLen(ListDeleteDuplicates(ValueList(get_internaldemand_info.from_position_code,',')),',') eq 1)
                    attributes.from_position_code = ListDeleteDuplicates(ValueList(get_internaldemand_info.from_position_code,','));
                else
                    attributes.from_position_code = "";
            </cfscript>
            <cfif len(attributes.location_out) and len(attributes.department_out)>
                <cfset attributes.txt_departman_out = get_location_info(attributes.department_out,attributes.location_out)>
            </cfif>
            <cfif len(attributes.location_in) and len(attributes.department_in)>
                <cfset attributes.txt_department_in = get_location_info(attributes.department_in,attributes.location_in)>
            </cfif>
        </cfif>
        </cfif>
    </cfif>
    <cfif not isdefined("is_demand")>
		<cfset is_demand=0>
    </cfif>
    <cfparam name="attributes.ref_no" default="">
    <cfif isdefined("attributes.id") and len(attributes.id)>
        <cfscript>
                get_demand_list_action = CreateObject("component","correspondence.cfc.get_demand");
                get_demand_list_action.dsn = dsn3;
                get_internaldemand = get_demand_list_action.get_demand_list_fnc(
                is_demand:'#iif(isdefined("is_demand"),"is_demand",DE(""))#',
                id:'#iif(isdefined("attributes.id"),"attributes.id",DE(""))#'
                );
        </cfscript>
    <cfelse>
        <cfset get_internaldemand.recordcount=0>
    </cfif>
    <cfif get_internaldemand.recordcount>
        <cfset attributes.subject=get_internaldemand.subject>
        <cfset attributes.from_position_code=get_internaldemand.from_position_code>
        <cfif len(get_internaldemand.from_position_code)>
            <cfset attributes.from_position_name=get_emp_info(get_internaldemand.from_position_code,0,0)>
        <cfelse>
            <cfset attributes.from_position_name="">
        </cfif>
        <cfset attributes.priority=get_internaldemand.priority>
        <cfset attributes.service_id=get_internaldemand.service_id>
        <cfif len(get_internaldemand.service_id)>
            <cfquery name="get_service" datasource="#dsn3#">
                SELECT SERVICE_NO,SERVICE_HEAD FROM SERVICE WHERE SERVICE_ID = #get_internaldemand.service_id#
            </cfquery>
            <cfset attributes.service_no=get_service.service_no&' '&get_service.service_head>
        <cfelse>
            <cfset attributes.service_no="">
        </cfif>
        <cfset attributes.department_out=get_internaldemand.department_out>
        <cfset attributes.location_out=get_internaldemand.location_out>
        <cfset attributes.department_in=get_internaldemand.department_in>
        <cfset attributes.location_in=get_internaldemand.location_in>
        <cfset attributes.to_position_code=get_internaldemand.to_position_code>
        <cfif len(get_internaldemand.to_position_code)>
            <cfset attributes.position_code=get_emp_info(get_internaldemand.to_position_code,1,0)>
        <cfelse>
            <cfset attributes.position_code="">
        </cfif>
        <cfset attributes.notes=get_internaldemand.notes>
        <cfset attributes.project_id=get_internaldemand.project_id>
        <cfif len(get_internaldemand.project_id)>
            <cfset attributes.project_head=get_project_name(get_internaldemand.project_id)>
        <cfelse>
            <cfset attributes.project_head="">   
        </cfif>
        <cfset attributes.ship_method = get_internaldemand.ship_method>
        <cfif len(get_internaldemand.ship_method)>
           <cfinclude template="../query/get_ship_method.cfm">
           <cfset attributes.ship_method_name=get_ship_method.ship_method>
        <cfelse>
            <cfset attributes.ship_method_name="">      
        </cfif>
        <cfset attributes.project_id_out=get_internaldemand.project_id_out>
        <cfif len(get_internaldemand.project_id_out)>
            <cfset attributes.project_head_out=get_project_name(get_internaldemand.project_id_out)>
        <cfelse>
            <cfset attributes.project_head_out="">
        </cfif>
        <cfset attributes.work_id=get_internaldemand.work_id>
        <cfif len(get_internaldemand.work_id)>
            <cfset attributes.work_head=get_work_name(get_internaldemand.work_id)>
        <cfelse>
            <cfset attributes.work_head="">
        </cfif>
        <cfset attributes.target_date=get_internaldemand.target_date>
        <cfset attributes.dpl_id=get_internaldemand.dpl_id>
        <cfif len(get_internaldemand.dpl_id)>
            <cfquery name="get_dpl" datasource="#dsn3#">
               SELECT DPL_NO FROM DRAWING_PART WHERE DPL_ID = #get_internaldemand.dpl_id#
            </cfquery>
            <cfset attributes.dpl_no=get_dpl.dpl_no>
        <cfelse>
            <cfset attributes.dpl_no="">
        </cfif>
        <cfset attributes.is_active=get_internaldemand.is_active>
        <cfset attributes.ref_no=get_internaldemand.ref_no>
    <cfelse>
        <cfif is_demand eq 1>
            <cfset attributes.subject=lang_array.item[259]>
        <cfelse>
            <cfset attributes.subject=lang_array_main.item[1386]>
        </cfif>
        <cfif isdefined("attributes.service_id") and len(attributes.service_id)>
            <cfquery name="get_service" datasource="#dsn3#">
                SELECT SERVICE_NO,SERVICE_HEAD FROM SERVICE WHERE SERVICE_ID = #attributes.service_id#
            </cfquery>
            <cfset attributes.service_no=get_service.service_no>
            <cfset attributes.service_name=get_service.service_no&' '&get_service.service_head>
            <cfset attributes.ref_no=attributes.service_no>
        <cfelse>
            <cfset attributes.service_no="">
            <cfset attributes.service_name="">
        </cfif>
        <cfif len(attributes.ref_no)>
            <cfset attributes.ref_no = attributes.ref_no>
        <cfelse>
            <cfset attributes.ref_no = "">
        </cfif>
       <cfif isdefined('x_to_position_code') and len(x_to_position_code)>
            <cfset attributes.to_position_code=x_to_position_code>
            <cfset attributes.position_code=get_emp_info(x_to_position_code,1,0)>
        <cfelse>
            <cfset attributes.to_position_code="">  
            <cfset attributes.position_code="">                     
        </cfif>
        <cfif isdefined("attributes.work_id") and len(attributes.work_id)>
            <cfset attributes.work_id=attributes.work_id>
            <cfset attributes.work_head=get_work_name(attributes.work_id)>
        </cfif>
        <cfif not isdefined("attributes.target_date")><cfset attributes.target_date=""></cfif>
        <cfif x_is_from_employee_id eq 1>
            <cfset attributes.from_position_code=session.ep.userid>
            <cfset attributes.from_position_name=get_emp_info(session.ep.userid,0,0)>
        <cfelse>
            <cfset attributes.from_position_code="">
            <cfset attributes.from_position_name="">
        </cfif>
        <cfset attributes.search_dep_id="">
        <cfset attributes.search_location_id="">
        <cfif isdefined("attributes.project_id") and len(attributes.project_id)>
            <cfset attributes.project_id=attributes.project_id>
            <cfset attributes.project_head=get_project_name(attributes.project_id)>
            <cfset attributes.project_id_out=''>
            <cfset attributes.project_head_out=''>
        <cfelse>
            <cfset attributes.project_id="">
            <cfset attributes.project_head="">
            <cfset attributes.project_id_out=""> 
            <cfset attributes.project_head_out=""> 
        </cfif>
        <cfset attributes.is_active=1>
    </cfif>
    <cfif isdefined("attributes.offer_id") and len(attributes.offer_id)>
        <cfquery name="get_offer_no" datasource="#dsn3#">
            SELECT OFFER_NUMBER FROM OFFER WHERE OFFER_ID = #attributes.offer_id#
        </cfquery>
        <cfset attributes.ref_no = get_offer_no.OFFER_NUMBER>
    </cfif>
	<cfif session.ep.isBranchAuthorization>
        <cfset attributes.basket_id = 39>
    <cfelseif listgetat(attributes.fuseaction,1,'.') is 'correspondence'>
        <cfset attributes.basket_id = 8>
    <cfelse>
        <cfset attributes.basket_id = 7>
    </cfif>
	<cfif isdefined('attributes.internal_row_info')><!--- proje malzeme planı satırlarından iç talep eklenecekse --->
    	<cfset attributes.basket_related_action = 1> 
    </cfif>
    <cfif not isdefined('attributes.type')><!--- Üretim Malzeme İhtiyaçları listesinden dönüşüm yapılmıyorsa --->
		<cfif isdefined("attributes.file_format")>
            <cfset attributes.basket_sub_id = 4>
        <cfelse>
            <cfset attributes.form_add = 1>
        </cfif>
	</cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cfif fusebox.circuit eq 'myhome' and isdefined("attributes.id") and len(attributes.id) and  not isnumeric(attributes.id)><!---gündem den çağrılan sayfalarda id encrypt li gönderildiği için eklendi SG 20131021 --->
		<!---bu alan yendien duzenlenecek MA 20131011--->
        <cfset attributes.id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.id,accountKey:'wrk')>
        <!---bu alan yendien duzenlenecek MA 20131011--->
    </cfif>
    <cfif listgetat(attributes.fuseaction,2,'.') eq 'list_purchasedemand'>
        <cfset is_demand = 1>
    <cfelse>
        <cfset is_demand = 0>
    </cfif>
    <cfif listlast(fuseaction,'.') eq "list_internaldemand">
        <cf_xml_page_edit fuseact ="correspondence.add_internaldemand">
    <cfelseif listlast(fuseaction,'.') eq "list_purchasedemand"> 
        <cf_xml_page_edit fuseact ="correspondence.add_purchasedemand">
    </cfif>
    <cfif isdefined("attributes.id") and len(attributes.id)>
        <cfif not isnumeric(attributes.id)><cfset attributes.id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.id,accountKey:'wrk')></cfif>
        <cfscript>
            get_demand_list_action = CreateObject("component","correspondence.cfc.get_demand");
            get_demand_list_action.dsn = dsn3;
            get_internaldemand = get_demand_list_action.get_demand_list_fnc(
            is_demand:is_demand,
            id:attributes.id
            );
        </cfscript>
    <cfelse>
        <cfset get_internaldemand.recordcount=0>
    </cfif>
    <cfif not get_internaldemand.recordcount or (isdefined("attributes.active_company") and attributes.active_company neq session.ep.company_id)>
    	<pre><cfdump var="#get_internaldemand#">
        <cfset hata  = 11>
        <cfsavecontent variable="message"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'>!</cfsavecontent>
        <cfset hata_mesaj  = message>
        <cfinclude template="../dsp_hata.cfm">
        <cfabort>
    <cfelse>
		<cfscript>session_basket_kur_ekle(table_type_id:7,action_id:attributes.id,process_type:1);</cfscript>
        <cfquery name="get_offer" datasource="#DSN3#">
            SELECT OFFER_ID FROM OFFER WHERE INTERNALDEMAND_ID = #attributes.id# AND PURCHASE_SALES = 0
        </cfquery>
    </cfif>
    <cfset mesaj = "Siparişe Dönüştür">	
    <cfif get_offer.recordcount>
		<cfset link = "#request.self#?fuseaction=purchase.detail_offer_ta&offer_id=#get_offer.offer_id#">
        <cfset mesaj="Teklif Detay">
    <cfelse>
        <cfset link = "#request.self#?fuseaction=purchase.form_add_offer&internaldemand_id=#attributes.id#">			  
        <cfset mesaj="Teklife Dönüştür">
    </cfif>
    <cfif listfirst(attributes.fuseaction,'.') is 'purchase'><cfset module_name_ = 'purchase'><cfelse><cfset module_name_ = 'correspondence'></cfif>
    <cfset head_ = Replace(get_internaldemand.subject,'"','','all')>
    <cfset head_ = Replace(head_,"'","","all")>
    	<cfif session.ep.isBranchAuthorization>
    	<cfset attributes.basket_id = 39>
    <cfelseif listgetat(attributes.fuseaction,1,'.') is 'correspondence'>
        <cfset attributes.basket_id = 8>
    <cfelse>
        <cfset attributes.basket_id = 7>
    </cfif>
    <cfif isdefined("attributes.file_format")>
         <cfset attributes.basket_sub_id = 4>
    </cfif>
</cfif>
<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function(){
	   		$('#keyword').focus();
	   	});
		function compare(value,value2,id)
		{
			if(filterNum(value,4)=='' || filterNum(value,4)==0)
				value=1;
				
			if(filterNum(value,4)> value2)
			{
				alert('Kalan Miktar '+value2+' \dan Fazla Olmamalıdır!');
				document.getElementById(id).value = commaSplit(value2,4);
				return false;
			}
			return true;
		}
		function change_deliverdate(xx,yy)
		{
			if(xx != '')
			{
				updrowdeliverdate_div = 'update_row_deliver_date_'+yy;
				var send_address = '<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.emptypopup_upd_demand_row_deliver_date&row_order_id=' + yy + '&row_deliver_date=' + xx;
				AjaxPageLoad(send_address,updrowdeliverdate_div ,1);
			}
			else
			{
				alert("<cf_get_lang no='233.Tarih Alanı Boş Olmamalıdır'>");
				return false;
			}
		}
		function kontrol()
		{
			<cfif isdefined("x_is_select_department") and x_is_select_department eq 1>//xmlden zorunlu olsun seçilmişse ve satır bazında listeleme yapılıyorsa
				if(document.form_basket.list_type.value == 1)
				{
					<cfif x_show_project_out eq 1>
					if(document.form_basket.txt_departman.value == "" || document.form_basket.department_id.value == "")
					{
						alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='1631.Çıkış Depo'>");
						return false;
					}
					</cfif>
					<cfif x_show_project_in eq 1>
					if(document.form_basket.department_in_txt.value == "" || document.form_basket.department_in_id.value == "")
					{
						alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang no='148.Giriş Depo'>");
						return false;
					}
					</cfif>
				}
			</cfif>
			return true;
		}
		function control_action(type)
		/*___Type__ 1:Sevk İrsaliyesi 2:Ambar Fişi 3:Satınalma Siparisi 4: İç Talep 5 : Satinalma Teklifi*/
		{
			if(document.list_internaldemand_2.internal_row_info.length != undefined)
			{
				var checked_item_ = document.list_internaldemand_2.internal_row_info;
				for(var xx=0; xx < document.list_internaldemand_2.internal_row_info.length; xx++)
				{
					if(checked_item_[xx].checked)
						var is_selected_row = 1;
				}
			}
			else if(document.list_internaldemand_2.internal_row_info.checked)
				var is_selected_row = 1;
			
			if(is_selected_row == undefined)
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no ='245.Ürün'>");
				return false;
			}
			
			<cfoutput>
			if(type==1)
			{
				list_internaldemand_2.action="#request.self#?fuseaction=stock.add_ship_dispatch<cfif isdefined("attributes.txt_departman") and len(attributes.txt_departman)>&department_id=#attributes.department_id#&location_id=#attributes.location_id#</cfif><cfif len(attributes.department_in_txt)>&department_in_id=#attributes.department_in_id#&location_in_id=#attributes.location_in_id#</cfif>";
				document.list_internaldemand_2.sevk_irsaliyesi.disabled=true;
			}
			if(type==2)
			{
				list_internaldemand_2.action="#request.self#?fuseaction=stock.form_add_fis";
				document.list_internaldemand_2.ambar_fisi.disabled=true;
			}
			
			if(type==3)
			{
				list_internaldemand_2.action="#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.form_add_internaldemand_order";
				document.list_internaldemand_2.satinalma_siparisi.disabled=true;
			}
			if(type==4)
			{
				if(document.list_internaldemand_2.internal_row_info.length != undefined)
				{
					var checked_item_ = document.list_internaldemand_2.internal_row_info;
					for(var xx=0; xx < document.list_internaldemand_2.internal_row_info.length; xx++)
					{
						if(checked_item_[xx].checked)
						{
							var action_id_ = list_getat(document.all.internal_row_info[xx].value,2,';');
							var action_row_id_ = list_getat(document.all.internal_row_info[xx].value,1,';');
						}
					}
				}
				list_internaldemand_2.action="#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.add_internaldemand&pro_material_id_list=1<cfif isdefined("ACTION_ID")>&upd_id=#ACTION_ID#</cfif><cfif len(attributes.project_id) and len(attributes.project_head)>&project_id=<cfoutput>#attributes.project_id#</cfoutput></cfif>";
				document.list_internaldemand_2.add_internaldemand_.disabled=true;
			}
			if(type==5)
			{
				list_internaldemand_2.action="#request.self#?fuseaction=purchase.form_add_offer";
				document.list_internaldemand_2.satinalma_teklifi.disabled=true;
			}
			if(type==6)
			{
				list_internaldemand_2.action="#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.add_purchasedemand&is_from_internaldemand=1<cfif isdefined("ACTION_ID")>&upd_id=#ACTION_ID#</cfif>";
				document.list_internaldemand_2.satinalma_talebi.disabled=true;
			}
			if(type==7)
			{
				if(document.list_internaldemand_2.internal_row_info.length != undefined)
				{
					var checked_item_ = document.list_internaldemand_2.internal_row_info;
					for(var xx=0; xx < document.list_internaldemand_2.internal_row_info.length; xx++)
					{
						if(checked_item_[xx].checked)
						{
							var action_row_id_ = list_getat(document.all.internal_row_info[xx].value,2,';');
							var get_spect_info_ = wrk_safe_query('corr_get_intrnldmnd','dsn3',0,action_row_id_);
							var listParam = get_spect_info_.STOCK_ID;
							QueryTextSpec = 'prdp_get_main_spec_id_3';
							var get_main_spec_id = wrk_safe_query(QueryTextSpec,'dsn3',0,listParam);
							if(get_main_spec_id.recordcount == 0)
							{
								var y = xx + 1;
								alert(y +'. Satırdaki Ürünün Spec Kaydı Bulunmamaktadır!');		
								return false;
							}
						}
					}
				}
				list_internaldemand_2.action='#request.self#?fuseaction=prod.add_prod_order&is_demand=1&is_collacted=1&frm_prod_report=1';
				document.list_internaldemand_2.uretim_talebi.disabled=true;
			}
			</cfoutput>
			list_internaldemand_2.submit();
		}
		 
		function open_div_purchase_info(no,stock_id,product_id) //satır bazında listelemede stok durumlarını getirmek icin
		{
			gizle_goster(eval("document.getElementById('purchase_info_row"+no+"')"));
			gizle_goster(eval("document.getElementById('stock_purchase_info"+no+"')"));
			AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_ajax_product_stock_info&sales=1&production_statistic=1&pid='+product_id+'&sid='+stock_id,'stock_purchase_info'+no+'',1);
		}
		function show_work_list()
		{
			if(document.form_basket.list_type.options[document.form_basket.list_type.selectedIndex].value==2)//planlama bazında
			{
				document.getElementById('show_product_1').style.display="";//ürünleri göster
				document.getElementById('show_product_2').style.display="";
				document.getElementById('show_company_1').style.display="";
				document.getElementById('show_company_2').style.display="";
				//document.getElementById('company_td_2').style.display="";
				document.getElementById('show_position_1').style.display='none';
				document.getElementById('show_position_2').style.display='none';
				document.getElementById('show_prod_cat_1').style.display='none';
				<cfif x_show_project_in eq 1>
					document.getElementById('show_to_department_1').style.display='none';
					document.getElementById('show_to_department_2').style.display='none';
				</cfif>
				<cfif x_show_project_out eq 1>
					document.getElementById('show_from_department_1').style.display='none';
					document.getElementById('show_from_department_2').style.display='none';
				</cfif>
				<cfif x_basket_row_add_definition eq 1 >
					document.getElementById('add_inf').style.display='none';
				</cfif>
				document.getElementById('show_to_position_code_1').style.display='none';
				document.getElementById('show_to_position_code_2').style.display='none';
				document.getElementById('show_from_position_code_1').style.display='none';
				document.getElementById('show_from_position_code_2').style.display='none';
				<cfif isdefined("x_deliverdate") and x_deliverdate eq 1 and is_demand eq 0>
					document.getElementById('show_deliverdate_1').style.display='none';
					document.getElementById('show_deliverdate_2').style.display='none';
				</cfif>
				AjaxPageLoad('<cfoutput>#request.self#?fuseaction=purchase.list_demand_stage&is_demand=#is_demand#&list_type=2<cfif x_show_authorized_stage eq 1><cfif isdefined("Process_RowId_List")>&Process_RowId_List=#Process_RowId_List#</cfif></cfif></cfoutput>' ,'stage1');
			}
			else if(document.form_basket.list_type.options[document.form_basket.list_type.selectedIndex].value==1)//satır bazında.
			{
				document.getElementById('show_product_1').style.display='';
				document.getElementById('show_product_2').style.display='';
				document.getElementById('show_company_1').style.display='';
				//document.getElementById('company_td_2').style.display="";
				document.getElementById('show_company_2').style.display='';
				document.getElementById('show_position_1').style.display='';
				document.getElementById('show_position_2').style.display='';
				document.getElementById('show_prod_cat_1').style.display='';
				<cfif x_show_project_in eq 1>
					document.getElementById('show_to_department_1').style.display='';
					document.getElementById('show_to_department_2').style.display='';
				</cfif>
				<cfif is_demand neq 1>
					<cfif x_show_project_out eq 1>
						document.getElementById('show_from_department_1').style.display='';
						document.getElementById('show_from_department_2').style.display='';
					</cfif>
				</cfif>
				<cfif x_basket_row_add_definition eq 1>
					document.getElementById('add_inf').style.display='';
				</cfif>
				document.getElementById('show_to_position_code_1').style.display='';
				document.getElementById('show_to_position_code_2').style.display='';
				document.getElementById('show_from_position_code_1').style.display='';
				document.getElementById('show_from_position_code_2').style.display='';
				<cfif isdefined("x_deliverdate") and x_deliverdate eq 1 and is_demand eq 0>
					document.getElementById('show_deliverdate_1').style.display='';
					document.getElementById('show_deliverdate_2').style.display='';
				</cfif>
				AjaxPageLoad('<cfoutput>#request.self#?fuseaction=purchase.list_demand_stage&is_demand=#is_demand#&list_type=1<cfif x_show_authorized_stage eq 1><cfif isdefined("Process_RowId_List")>&Process_RowId_List=#Process_RowId_List#</cfif></cfif></cfoutput>' ,'stage1');
		
			}
			else
			{
				document.getElementById('show_product_1').style.display='none';
				document.getElementById('show_product_2').style.display='none';
				document.getElementById('show_company_1').style.display='none';
				document.getElementById('show_company_2').style.display='none';
				//document.getElementById('company_td_2').style.display="none";
				document.getElementById('show_position_1').style.display='none';
				document.getElementById('show_position_2').style.display='none';
				document.getElementById('show_prod_cat_1').style.display='none';
				<cfif x_show_project_in eq 1>
					document.getElementById('show_to_department_1').style.display='';
					document.getElementById('show_to_department_2').style.display='';
				</cfif>
				<cfif is_demand neq 1>
					<cfif x_show_project_out eq 1>
						document.getElementById('show_from_department_1').style.display='';
						document.getElementById('show_from_department_2').style.display='';
					</cfif>
				</cfif>
				<cfif x_basket_row_add_definition eq 1 >
					document.getElementById('add_inf').style.display='none';
				</cfif>
				document.getElementById('show_to_position_code_1').style.display='';
				document.getElementById('show_to_position_code_2').style.display='';
				document.getElementById('show_from_position_code_1').style.display='';
				document.getElementById('show_from_position_code_2').style.display='';
				<cfif isdefined("x_deliverdate") and x_deliverdate eq 1 and is_demand eq 0>
					document.getElementById('show_deliverdate_1').style.display='none';
					document.getElementById('show_deliverdate_2').style.display='none';
				</cfif>
				AjaxPageLoad('<cfoutput>#request.self#?fuseaction=purchase.list_demand_stage&is_demand=#is_demand#&list_type=0<cfif x_show_authorized_stage eq 1><cfif isdefined("Process_RowId_List")>&Process_RowId_List=#Process_RowId_List#</cfif></cfif></cfoutput>' ,'stage1');
			}
	
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
		function kontrol()
		{
			if(document.form_basket.process_stage.value == "")
			{
				alert("<cf_get_lang no ='173.Lütfen Süreçlerinizi Tanimlayiniz veya Tanimlanan Süreçler Üzerinde Yetkiniz Yok'>!");
				return false;
			}
			if(document.form_basket.to_position_code.value == "" || document.form_basket.position_code.value == "")
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='512.Kime '>!");
				return false;
			}
			<cfif is_department_in eq 1 and x_project_department_in eq 1>
				if(document.form_basket.department_in_id.value == "" || document.form_basket.department_in_txt.value == "")
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no ='148.Giriş Depo'>!");
					return false;
				}
			</cfif>
			<cfif isdefined('x_apply_deliverdate_to_rows') and x_apply_deliverdate_to_rows eq 1>
				apply_deliver_date('target_date');
			</cfif> 
			<cfif isdefined("xml_upd_row_project") and xml_upd_row_project eq 1 and x_project_department_in eq 1>
				project_field_name = 'project_head';
				project_field_id = 'project_id';
				apply_deliver_date('',project_field_name,project_field_id);
			</cfif>
			return (process_cat_control() && saveForm());
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
		function form_kontrol()
		{
			if(document.form_basket.to_position_code.value == "" || document.form_basket.position_code.value == "")
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='512.Kime '>!");
				return false;
			}
			<cfif is_department_in eq 1 and x_project_department_in eq 1>
				if(document.form_basket.department_in_id.value == "" || document.form_basket.department_in_txt.value == "" )
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no ='148.Giriş Depo'>!");
					return false;
				}
			</cfif>
			<cfif isdefined('x_apply_deliverdate_to_rows') and x_apply_deliverdate_to_rows eq 1>
				apply_deliver_date('target_date');
			</cfif>
			<cfif isdefined("xml_upd_row_project") and xml_upd_row_project eq 1 and x_project_department_in eq 1>
				project_field_name = 'project_head';
				project_field_id = 'project_id';
				apply_deliver_date('',project_field_name,project_field_id);
			</cfif>
			return (process_cat_control() && saveForm());
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'purchase.list_purchasedemand';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'correspondence/display/list_internaldemand.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'purchase.list_purchasedemand';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'correspondence/form/add_internaldemand.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'correspondence/query/add_internaldemand.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'purchase.list_purchasedemand&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'purchase.list_purchasedemand';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'correspondence/form/upd_internaldemand.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'correspondence/query/upd_internaldemand.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'purchase.list_purchasedemand&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_del_internaldemand&id=#id#&head=#head_#- #get_internaldemand.internal_number#&type_=#get_internaldemand.demand_type#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'correspondence/query/del_internaldemand.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'correspondence/query/del_internaldemand.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'purchase.list_purchasedemand';
	}
	
	// Tab Menus //
	tabMenuStruct = StructNew();
	tabMenuStruct['#attributes.fuseaction#'] = structNew();
	tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
	
	//Add//
	if(isdefined("attributes.event") and attributes.event is 'add')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['text'] = 'PHL';//PHL
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['href'] = "#request.self#?fuseaction=objects.add_order_from_file&from_where=3&is_demand=#is_demand#&frm_str_=#listgetat(attributes.fuseaction,1,'.')#";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}

	// Upd //	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		i = 0;
		if(is_demand eq 0 and isDefined('xml_purchase_demand_button') and xml_purchase_demand_button eq 1)
		{
			if(session.ep.isBranchAuthorization eq 1)
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[259]# #lang_array_main.item[656]#';//Satın Alma Talebinen Dönüştür
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=store.add_purchasedemand&internaldemand_id=#attributes.id#&is_from_internaldemand=1&internal_row_info=1";
				i = i + 1;
			}
			else
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = 'Satın Alma Talebine #lang_array_main.item[656]#';//Satın Alma Talebinen Dönüştür
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=purchase.add_purchasedemand&internaldemand_id=#attributes.id#&is_from_internaldemand=1&internal_row_info=1";
				i = i + 1;
			}	
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array_main.item[1879]#';//İç Talep Karşılaştırma Raporu
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_internaldemand_relation&internaldemand_id=#attributes.id#','list')";
		i = i + 1;
		if(fusebox.circuit neq 'myhome')
		{
			if(session.ep.isBranchAuthorization eq 1)
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array_main.item[1831]# #lang_array_main.item[656]#';//Sarfişi Dönüştür
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=store.form_add_fis&internal_demand_id=#attributes.id#&from_position_code=#get_internaldemand.from_position_code#&from_company_id=#get_internaldemand.from_company_id#&from_partner_id=#get_internaldemand.from_partner_id#&from_consumer_id=#get_internaldemand.from_consumer_id#";
				i = i + 1;
			}
			else
			{
				if(isDefined('xml_sarf_fis_button') and xml_sarf_fis_button eq 1)
				{
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array_main.item[1831]# #lang_array_main.item[656]#';//Sarfişi Dönüştür
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=stock.form_add_fis&internal_demand_id=#attributes.id#&from_position_code=#get_internaldemand.from_position_code#&from_company_id=#get_internaldemand.from_company_id#&from_partner_id=#get_internaldemand.from_partner_id#&from_consumer_id=#get_internaldemand.from_consumer_id#";
					i = i + 1;
				}
			}
		}
		else
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array_main.item[1831]# #lang_array_main.item[656]#';//Sarfişi Dönüştür
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=store.form_add_fis&internal_demand_id=#attributes.id#&from_position_code=#get_internaldemand.from_position_code#&from_company_id=#get_internaldemand.from_company_id#&from_partner_id=#get_internaldemand.from_partner_id#&from_consumer_id=#get_internaldemand.from_consumer_id#";
			i = i + 1;
		}
		if(session.ep.isBranchAuthorization eq 1)
		{
			if(isDefined('xml_purch_order_button') and xml_purch_order_button eq 1)
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array_main.item[1034]#';//Sarfişi Dönüştür
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=store.form_add_internaldemand_order&id=#attributes.id#&project_id=#get_internaldemand.project_id#&is_demand=#is_demand#";
				i = i + 1;
			}  
		}
		else
		{
			if(isDefined('xml_purch_order_button') and xml_purch_order_button eq 1)
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array_main.item[1034]#';//Sarfişi Dönüştür
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=purchase.form_add_internaldemand_order&id=#attributes.id#&project_id=#get_internaldemand.project_id#&is_demand=#is_demand#";
				i = i + 1;
			}
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array_main.item[345]#';//Uyarılar
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=#attributes.fuseaction#&action_id=#attributes.id#&action_name=id&relation_papers_type=<cfif is_demand eq 1>purchasedemand<cfelse>internaldemand</cfif>','list')";
		i = i + 1;
		if(session.ep.isBranchAuthorization eq 1)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array_main.item[61]#';//Tarihçe
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=store.popup_list_internaldemand_history&offer_id=#get_offer.offer_id#&id=#attributes.id#&project_id=#get_internaldemand.project_id#<cfif isdefined('is_demand')>&is_demand=#is_demand#</cfif>','page')";
			i = i + 1;
		}
		else
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array_main.item[61]#';//Tarihçe
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=correspondence.popup_list_internaldemand_history&offer_id=#get_offer.offer_id#&id=#attributes.id#&project_id=#get_internaldemand.project_id#<cfif isdefined('is_demand')>&is_demand=#is_demand#</cfif>','page')";
			i = i + 1;
		}
		if(isDefined('xml_purch_offer_button') and xml_purch_offer_button eq 1)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#mesaj#';//Tarihçe
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#link#";
			i = i + 1;
		}		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = 'Belgeler';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=#module_name_#.popup_dsp_internaldemand_asset&id=#id#','medium')";

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=purchase.list_purchasedemand&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=purchase.list_purchasedemand&event=add&id=#attributes.id#";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.id#&print_type=92','page')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'listPurchasedemandController';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'INTERNALDEMAND';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item1','item3']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
</cfscript>
