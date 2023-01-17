<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cf_get_lang_set module_name="myhome">
	<cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.paper_no" default="">
    <cfparam name="attributes.type" default="0">
    <cfparam name="attributes.by" default="0">
    <cfparam name="attributes.is_active" default="">
    <cfif listgetat(attributes.fuseaction,2,'.') eq 'list_purchasedemand'><cfset is_demand = 1><cfelse><cfset is_demand = 0></cfif>
    <cfif isdefined('attributes.form_submitted')>
        <cfquery name="GET_MY_INTERNALDEMANDS" datasource="#DSN3#">
            SELECT 
               *,
               PTR.STAGE
            FROM 
                INTERNALDEMAND
                LEFT JOIN #dsn_alias#.PROCESS_TYPE_ROWS PTR ON INTERNALDEMAND_STAGE=PTR.PROCESS_ROW_ID
            WHERE
                (
                    INTERNALDEMAND.RECORD_EMP = #session.ep.userid#
                    OR
                    INTERNALDEMAND.UPDATE_EMP = #session.ep.userid#
                    OR
                    (
                    <cfif attributes.type eq 0>(TO_POSITION_CODE=#session.ep.position_code# OR FROM_POSITION_CODE = #session.ep.userid#)</cfif>
                    <cfif attributes.type eq 1>TO_POSITION_CODE = #session.ep.position_code#</cfif>
                    <cfif attributes.type eq 2>FROM_POSITION_CODE = #session.ep.userid#</cfif>
                    )
                )
                <cfif len(attributes.keyword)>
                AND
                (
                    SUBJECT LIKE <cfqueryparam cfsqltype="cf_sql_longvarchar" value="%#attributes.keyword#%"> OR
                    NOTES LIKE <cfqueryparam cfsqltype="cf_sql_longvarchar" value="%#attributes.keyword#%">
                )
                </cfif>
                <cfif len(attributes.paper_no)>
                AND INTERNAL_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_longvarchar" value="%#attributes.paper_no#%">
                </cfif>
                AND <cfif is_demand eq 1>DEMAND_TYPE=1<cfelse>DEMAND_TYPE=0</cfif>
                <cfif len(attributes.is_active)>AND IS_ACTIVE = #attributes.is_active#</cfif>
            ORDER BY
                <cfif attributes.by eq 0 >
                    INTERNALDEMAND.RECORD_DATE DESC
                <cfelse>
                    INTERNALDEMAND.RECORD_DATE ASC
                </cfif>
                ,TARGET_DATE DESC
        </cfquery>
    <cfelse>
        <cfset get_my_internaldemands.recordcount = 0>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default='#get_my_internaldemands.recordcount#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfif is_demand eq 1>
        <cfsavecontent variable="head"><cf_get_lang no='254.Satın Alma Taleplerim'></cfsavecontent>
    <cfelse>
        <cfsavecontent variable="head"><cf_get_lang no='11.İç Taleplerim'></cfsavecontent>
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	<cf_get_lang_set module_name="correspondence">
	<cfif listgetat(attributes.fuseaction,2,'.') contains '_purchasedemand'>
		<cfset is_demand = 1>
    <cfelse>
        <cfset is_demand = 0>
    </cfif>
    <cfif listlast(fuseaction,'.') contains "_internaldemand">
        <cf_xml_page_edit fuseact ="correspondence.add_internaldemand">
    <cfelseif listlast(fuseaction,'.') contains "_purchasedemand">
        <cf_xml_page_edit fuseact ="correspondence.add_purchasedemand">
    </cfif>
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
    <cfif isdefined("internal_number_list") and len(internal_number_list)>
        <cfparam name="attributes.ref_no" default="#internal_number_list#">
    <cfelse>
        <cfparam name="attributes.ref_no" default="">
    </cfif>
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
            <cfset attributes.subject=lang_array_main.item[2271]>
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
        <cfif isdefined("pro_material_work_list")  and len(pro_material_work_list)>
            <cfset attributes.work_id=pro_material_work_list>
            <cfset attributes.work_head=get_work_name(attributes.work_id)>
        </cfif>
        <cfif not isdefined("attributes.target_date")><cfset attributes.target_date=""></cfif>
        <cfif isdefined("attributes.from_position_code") and len(attributes.from_position_code)>
            <cfset attributes.from_position_name=get_emp_info(attributes.from_position_code,0,0)>
        <cfelseif x_is_from_employee_id eq 1>
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
        <cfelse>
            <cfset attributes.project_id="">
            <cfset attributes.project_head="">
        </cfif>
        <cfif isdefined("attributes.project_id_out") and len(attributes.project_id_out)>
            <cfset attributes.project_id_out=attributes.project_id_out>
            <cfset attributes.project_head_out=get_project_name(attributes.project_id_out)>
        <cfelse>
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
    <cfif isdefined('attributes.internal_row_info')><!--- proje malzeme planı satırlarından iç talep eklenecekse --->
		<cfset attributes.basket_related_action = 1> 
    </cfif>
    <cfif listgetat(attributes.fuseaction,1,'.') is 'store'>
        <cfset attributes.basket_id = 39>
    <cfelseif listgetat(attributes.fuseaction,1,'.') is 'correspondence'>
        <cfset attributes.basket_id = 8>
    <cfelse>
        <cfset attributes.basket_id = 7>
    </cfif>
    <cfif not isdefined('attributes.type')><!--- Üretim Malzeme İhtiyaçları listesinden dönüşüm yapılmıyorsa --->
        <cfif isdefined("attributes.file_format")>
            <cfset attributes.basket_sub_id = 4>
        <cfelse>
            <cfset attributes.form_add = 1>
        </cfif>
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cf_get_lang_set module_name="correspondence">
	<cfif fusebox.circuit eq 'myhome' and isdefined("attributes.id") and len(attributes.id) and  not isnumeric(attributes.id)><!---gündem den çağrılan sayfalarda id encrypt li gönderildiği için eklendi SG 20131021 --->
		<!---bu alan yendien duzenlenecek MA 20131011--->
        <cfset attributes.id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.id,accountKey:'wrk')>
        <!---bu alan yendien duzenlenecek MA 20131011--->
    </cfif>
    <cfif listgetat(attributes.fuseaction,2,'.') contains '_purchasedemand'>
        <cfset is_demand = 1>
    <cfelse>
        <cfset is_demand = 0>
    </cfif>
    <cfif listlast(fuseaction,'.') contains "_internaldemand">
        <cf_xml_page_edit fuseact ="correspondence.add_internaldemand">
    <cfelseif listlast(fuseaction,'.') contains "_purchasedemand">
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
        <cfset hata  = 11>
        <cfsavecontent variable="message"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'>!</cfsavecontent>
        <cfset hata_mesaj  = message>
        <cfinclude template="../../dsp_hata.cfm">
    <cfelse>
		<cfscript>session_basket_kur_ekle(table_type_id:7,action_id:attributes.id,process_type:1);</cfscript>
        <cfquery name="get_offer" datasource="#DSN3#">
            SELECT OFFER_ID FROM OFFER WHERE INTERNALDEMAND_ID = #attributes.id# AND PURCHASE_SALES = 0
        </cfquery>
		<cfset mesaj = "Siparişe Dönüştür">	
        <cfif get_offer.recordcount>
            <cfset link = "#request.self#?fuseaction=purchase.detail_offer_ta&offer_id=#get_offer.offer_id#">
            <cfset mesaj="Teklif Detay">
        <cfelse>
            <cfset link = "#request.self#?fuseaction=purchase.form_add_offer&internaldemand_id=#attributes.id#">			  
            <cfset mesaj="Teklife Dönüştür">
        </cfif>
    </cfif>
    <cfif listfirst(attributes.fuseaction,'.') is 'purchase'><cfset module_name_ = 'purchase'><cfelse><cfset module_name_ = 'correspondence'></cfif>
    <cfset head_ = Replace(get_internaldemand.subject,'"','','all')>
    <cfset head_ = Replace(head_,"'","","all")>
</cfif>
<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function(e) {
			document.getElementById('keyword').focus();
		})
	<cfelseif isdefined("attributes.event") and attributes.event is 'add' or attributes.event is 'upd'>
		function form_kontrol()
		{
			<cfif attributes.event is 'add'>
				if(document.form_basket.process_stage.value == "")
				{
					alert("<cf_get_lang no ='173.Lütfen Süreçlerinizi Tanimlayiniz veya Tanimlanan Süreçler Üzerinde Yetkiniz Yok'>!");
					return false;
				}
			</cfif>
			if(document.form_basket.to_position_code.value == "" || document.form_basket.position_code.value == "")
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='512.Kime '>!");
				return false;
			}
			<cfif isdefined('x_apply_deliverdate_to_rows') and x_apply_deliverdate_to_rows eq 1>
				apply_deliver_date('target_date');
			</cfif> 
			<cfif isdefined("xml_upd_row_project") and xml_upd_row_project eq 1>
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
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'correspondence.add_internaldemand';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'correspondence/form/add_internaldemand.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'correspondence/query/add_internaldemand.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'myhome.list_internaldemand&event=upd';		

	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'correspondence.add_internaldemand';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'correspondence/form/upd_internaldemand.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'correspondence/query/upd_internaldemand.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'myhome.list_internaldemand&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';

	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.list_internaldemand';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'myhome/display/list_my_internaldemands.cfm';
	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_del_internaldemand&id=#id#&head=#head_#- #get_internaldemand.internal_number#&type_=#get_internaldemand.demand_type#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'correspondence/query/del_internaldemand.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'correspondence/query/del_internaldemand.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'myhome.list_internaldemand';
	}
	
	// Tab Menus //
	tabMenuStruct = StructNew();
	tabMenuStruct['#attributes.fuseaction#'] = structNew();
	tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
	
	// Add //
	if(isdefined("attributes.event") and attributes.event is 'add')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = 'PHL';//PHL
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['href'] = "#request.self#?fuseaction=objects.add_order_from_file&from_where=3&is_demand=#is_demand#&frm_str_=#listgetat(attributes.fuseaction,1,'.')#";
	}
	// Upd //	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		if(is_demand eq 0)
		{
			if(fusebox.circuit eq 'store')
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array.item[259]# #lang_array_main.item[656]#';//Satın Alma Talebinen Dönüştür
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['href'] = "#request.self#?fuseaction=store.add_purchasedemand&internaldemand_id=#attributes.id#&is_from_internaldemand=1&internal_row_info=1";
			}
			else
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = 'Satın Alma Talebine #lang_array_main.item[656]#';//Satın Alma Talebinen Dönüştür
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['href'] = "#request.self#?fuseaction=purchase.add_purchasedemand&internaldemand_id=#attributes.id#&is_from_internaldemand=1&internal_row_info=1";
			}	
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[1879]#';//İç Talep Karşılaştırma Raporu
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_internaldemand_relation&internaldemand_id=#attributes.id#','list')";
		if(fusebox.circuit neq 'myhome')
		{
			if(fusebox.circuit eq 'store')
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = '#lang_array_main.item[1831]# #lang_array_main.item[656]#';//Sarfişi Dönüştür
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['href'] = "#request.self#?fuseaction=store.form_add_fis&internal_demand_id=#attributes.id#&from_position_code=#get_internaldemand.from_position_code#&from_company_id=#get_internaldemand.from_company_id#&from_partner_id=#get_internaldemand.from_partner_id#&from_consumer_id=#get_internaldemand.from_consumer_id#";
			}
			else
			{
				if(isDefined('xml_sarf_fis_button') and xml_sarf_fis_button eq 1)
				{
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = '#lang_array_main.item[1831]# #lang_array_main.item[656]#';//Sarfişi Dönüştür
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['href'] = "#request.self#?fuseaction=stock.form_add_fis&internal_demand_id=#attributes.id#&from_position_code=#get_internaldemand.from_position_code#&from_company_id=#get_internaldemand.from_company_id#&from_partner_id=#get_internaldemand.from_partner_id#&from_consumer_id=#get_internaldemand.from_consumer_id#";
				}
			}
		}
		else
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = '#lang_array_main.item[1831]# #lang_array_main.item[656]#';//Sarfişi Dönüştür
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['href'] = "#request.self#?fuseaction=store.form_add_fis&internal_demand_id=#attributes.id#&from_position_code=#get_internaldemand.from_position_code#&from_company_id=#get_internaldemand.from_company_id#&from_partner_id=#get_internaldemand.from_partner_id#&from_consumer_id=#get_internaldemand.from_consumer_id#";
		}
		if(fusebox.circuit neq 'store')
			link = "#request.self#?fuseaction=store.form_add_internaldemand_order&id=#attributes.id#&project_id=#get_internaldemand.project_id#&is_demand=#is_demand#";
		else
			link = "#request.self#?fuseaction=purchase.form_add_internaldemand_order&id=#attributes.id#&project_id=#get_internaldemand.project_id#&is_demand=#is_demand#";
		if(isDefined('xml_purch_order_button') and xml_purch_order_button eq 1)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['text'] = '#lang_array_main.item[1034]#';//Siparişe Dönüştür
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['href'] = "#link#";
		}  
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['text'] = '#lang_array_main.item[345]#';//Uyarılar
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=#attributes.fuseaction#&action_id=#attributes.id#&action_name=id&relation_papers_type=<cfif is_demand eq 1>purchasedemand<cfelse>internaldemand</cfif>','list')";
		if(fusebox.circuit eq 'store')
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['text'] = '#lang_array_main.item[61]#';//Tarihçe
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['onClick'] = "windowopen('#request.self#?fuseaction=store.popup_list_internaldemand_history&offer_id=#get_offer.offer_id#&id=#attributes.id#&project_id=#get_internaldemand.project_id#<cfif isdefined('is_demand')>&is_demand=#is_demand#</cfif>','page')";
		}
		else
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['text'] = '#lang_array_main.item[61]#';//Tarihçe
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['onClick'] = "windowopen('#request.self#?fuseaction=correspondence.popup_list_internaldemand_history&offer_id=#get_offer.offer_id#&id=#attributes.id#&project_id=#get_internaldemand.project_id#<cfif isdefined('is_demand')>&is_demand=#is_demand#</cfif>','page')";
		}
		if(isDefined('xml_purch_offer_button') and xml_purch_offer_button eq 1)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][6]['text'] = '#mesaj#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][6]['href'] = "#link#";
		}
		else
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][7]['text'] = '#mesaj#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][7]['href'] = "windowopen('#request.self#?fuseaction=#module_name_#.popup_dsp_internaldemand_asset&id=#id#','medium')";
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=myhome.list_internaldemand&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=myhome.list_internaldemand&event=add&id=#attributes.id#";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.id#&print_type=92','page')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
