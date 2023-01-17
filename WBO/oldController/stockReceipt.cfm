<cfif not isdefined("attributes.event") or attributes.event is 'add'>
    <cf_get_lang_set module_name="stock">
    <cf_xml_page_edit fuseact="stock.form_add_fis">
    <cf_papers paper_type="stock_fis">
    <cfinclude template="../stock/query/get_shipment_method.cfm">
    <cfparam name="attributes.fis_date" default="#dateformat(now(),'dd/mm/yyyy')#">
    <cfparam name="attributes.member_type" default="employee">
    <cfparam name="attributes.company_id" default="#session.ep.company_id#">
    <cfif isdefined("paper_full") and isdefined("paper_number")>
        <cfset system_paper_no = paper_full>
        <cfset system_paper_no_add = paper_number>
    <cfelse>
        <cfset system_paper_no = "">
        <cfset system_paper_no_add = "">
    </cfif>
    <cfif isdefined("attributes.upd_id") and len(attributes.upd_id)><!--- Fiş Kopyalama --->
        <cfinclude template="../stock/query/get_fis_det.cfm">
        <cfscript>session_basket_kur_ekle(action_id=attributes.upd_id,table_type_id:6,process_type:1);</cfscript>
        <cfset attributes.fis_date = dateformat(get_fis_det.fis_date,'dd/mm/yyyy')>
        <cfset attributes.deliver_get_id = get_fis_det.employee_id>
        <cfset attributes.deliver_get = get_emp_info(get_fis_det.employee_id,0,0)>
        <cfset attributes.detail = get_fis_det.fis_detail>
        <cfset attributes.location_out = get_fis_det.location_out>
        <cfset attributes.department_out = get_fis_det.department_out>
        <cfset attributes.txt_departman_out = get_location_info(get_fis_det.department_out,get_fis_det.location_out)>
        <cfif len(get_fis_det.prod_order_number)>
            <cfquery name="GET_PRODUCTION_ORDER" datasource="#DSN3#">
                SELECT P_ORDER_NO FROM PRODUCTION_ORDERS WHERE P_ORDER_ID = #get_fis_det.prod_order_number#
            </cfquery>				  
            <cfset attributes.prod_order_number = get_fis_det.prod_order_number>
            <cfset attributes.prod_order = get_production_order.p_order_no>
        <cfelse>
            <cfset attributes.prod_order_number = "">
            <cfset attributes.prod_order = "">
        </cfif>
        <cfset attributes.ref_no = get_fis_det.ref_no>
        <cfset attributes.location_in = get_fis_det.location_in>
        <cfset attributes.department_in = get_fis_det.department_in>
        <cfset attributes.txt_department_in = get_location_info(get_fis_det.department_in,get_fis_det.location_in)>
        <cfset attributes.pj_id = get_fis_det.project_id><!--- attributes.pj_id başka yerden de gönderiliyor --->
        <cfset attributes.is_production = get_fis_det.is_production>
        <cfset attributes.work_id = get_fis_det.WORK_ID>
        <cfset attributes.subscription_id = get_fis_det.subscription_id>
        <cfif len(attributes.subscription_id)>
            <cfquery name="get_sub_no" datasource="#dsn3#">
                SELECT SUBSCRIPTION_NO FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = #attributes.subscription_id#
            </cfquery> 
            <cfif get_sub_no.recordcount><cfset attributes.subscription_no = get_sub_no.subscription_no></cfif>
        </cfif>
    <cfelseif isdefined("attributes.internal_demand_id")>
        <cfquery name="get_internal_demand" datasource="#dsn3#">
            SELECT 
                DEPARTMENT_IN,
                DEPARTMENT_OUT,
                SERVICE_ID,
                PROJECT_ID,
                PROJECT_ID_OUT,
                WORK_ID,
                REF_NO,
                NOTES,
                TARGET_DATE,
                LOCATION_IN,
                LOCATION_OUT,
                NOTES,
                INTERNAL_NUMBER
            FROM 
                INTERNALDEMAND
            WHERE
                INTERNAL_ID=#attributes.internal_demand_id#
        </cfquery>
        <cfquery name="get_int_row" datasource="#dsn3#">
            SELECT I_ROW_ID FROM INTERNALDEMAND_ROW WHERE I_ID=#attributes.internal_demand_id#
        </cfquery>
         <cfif get_int_row.recordcount>
            <cfset internald_row_id_list=listdeleteduplicates(valuelist(get_int_row.i_row_id,','))>
        </cfif>
        <cfscript>session_basket_kur_ekle(action_id=attributes.internal_demand_id,table_type_id:7,process_type:1);</cfscript>
        <cfset attributes.fis_date = dateformat(get_internal_demand.target_date,'dd/mm/yyyy')>
        <cfset attributes.deliver_get_id = ''>
        <cfset attributes.deliver_get = ''>
        <cfif isdefined('from_position_code') and len(from_position_code)>
            <cfset attributes.deliver_get_id = from_position_code>
            <cfset attributes.deliver_get = get_emp_info(from_position_code,0,0)>
            <cfset attributes.member_type = 'employee'>
        <cfelseif isDefined('from_partner_id') and len(from_partner_id)>
            <cfset attributes.deliver_get = get_par_info(from_partner_id,0,0,0)>
            <cfset attributes.member_type = 'partner'>
        <cfelseif isDefined('from_consumer_id') and len(from_consumer_id)>
            <cfset attributes.deliver_get = get_cons_info(from_consumer_id,0,0)>
            <cfset attributes.member_type = 'consumer'>
        </cfif>
        <cfset attributes.detail = get_internal_demand.notes>
        <cfset attributes.location_in = get_internal_demand.location_in>
        <cfset attributes.location_out = get_internal_demand.location_out>
        <cfset attributes.department_out = get_internal_demand.department_out>
        <cfset attributes.txt_departman_out = get_location_info(get_internal_demand.department_out,get_internal_demand.location_out)>
        <cfset attributes.prod_order_number = "">
        <cfset attributes.prod_order = "">
        <cfset attributes.ref_no = get_internal_demand.internal_number>
        <cfset attributes.location_in = get_internal_demand.location_in>
        <cfset attributes.department_in = get_internal_demand.department_in>
        <cfset attributes.txt_department_in = get_location_info(get_internal_demand.department_in,get_internal_demand.location_in)>
        <cfset attributes.pj_id = get_internal_demand.project_id_out>
        <cfset attributes.is_production = ''>
        <cfset attributes.work_id=get_internal_demand.work_id>
        <cfset attributes.service_id=get_internal_demand.service_id>
        <cfset attributes.project_id=get_internal_demand.project_id>
    <cfelse>
        <cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
        <cfset attributes.deliver_get_id = session.ep.userid>
        <cfset attributes.deliver_get = get_emp_info(session.ep.userid,0,0)>
        <cfset attributes.detail = "">
        <cfif not isdefined("attributes.location_out")>
            <cfset attributes.location_out = "">
        </cfif>
        <cfif not isdefined("attributes.department_out")>
            <cfset attributes.department_out = "">
        </cfif>
        <cfif not isdefined("attributes.txt_departman_out")>
            <cfset attributes.txt_departman_out = "">
        </cfif>
        <cfif not isdefined("attributes.location_in")>
            <cfset attributes.location_in = "">
        </cfif>
        <cfif not isdefined("attributes.department_in")>
            <cfset attributes.department_in = "">
        </cfif>
        <cfif not isdefined("attributes.txt_department_in")>
            <cfset attributes.txt_department_in = "">
        </cfif>
        <cfset attributes.prod_order_number = "">
        <cfset attributes.prod_order = "">
        <cfset attributes.ref_no = "">
        <cfset attributes.is_production = "">
    </cfif>
    <cfif isdefined('attributes.internal_row_info')>
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
                SELECT PROJECT_ID,PROJECT_ID_OUT,WORK_ID,LOCATION_OUT,DEPARTMENT_OUT,LOCATION_IN,DEPARTMENT_IN FROM INTERNALDEMAND WHERE INTERNAL_ID IN (#internaldemand_id_list#)
            </cfquery>
        
            <cfscript>
                if(ListLen(ListDeleteDuplicates(ValueList(get_internaldemand_info.project_id,',')),',') eq 1)
                    attributes.project_id = ListDeleteDuplicates(ValueList(get_internaldemand_info.project_id,','));
                else
                    attributes.project_id = "";
    
                if(ListLen(ListDeleteDuplicates(ValueList(get_internaldemand_info.project_id_out,',')),',') eq 1)
                    attributes.pj_id = ListDeleteDuplicates(ValueList(get_internaldemand_info.project_id_out,','));
                else
                    attributes.pj_id = "";	
    
                if(ListLen(ListDeleteDuplicates(ValueList(get_internaldemand_info.work_id,',')),',') eq 1)
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
            </cfscript>
            
             <cfif len(attributes.location_out) and len(attributes.department_out)>
                <cfset attributes.txt_departman_out = get_location_info(attributes.department_out,attributes.location_out)>
            </cfif>
             <cfif len(attributes.location_in) and len(attributes.department_in)>
                <cfset attributes.txt_department_in = get_location_info(attributes.department_in,attributes.location_in)>
             </cfif>
        </cfif>
    </cfif>
    <cfif isdefined('attributes.is_from_prod_report')><!--- isbak için yapılan özel rapordan gelen değerler için kullanılıyor. silmeyiniz. hgul 20121011 --->
        <cfset attributes.prod_order_number = form.prod_order_number>
        <cfset attributes.prod_order = form.prod_order>
        <cfset attributes.department_out = form.department_out>
        <cfset attributes.location_out = form.location_out>
        <cfset attributes.department_in = form.department_in>
        <cfset attributes.location_in = form.location_in>
        <cfset attributes.txt_departman_out = get_location_info(attributes.department_out,attributes.location_out)>
        <cfset attributes.txt_department_in = get_location_info(attributes.department_in,attributes.location_in)>
    </cfif>
    <cfif isdefined('x_departman_out') and x_departman_out eq 1><!--- iş detayından sarf fişi ekleneceğinde projenin departmanı varsa, çıkış depoyu projeden getiriyor. --->
        <cfif isdefined("attributes.pj_id") and len(attributes.pj_id)>
            <cfquery name="get_project_department" datasource="#dsn#">
                SELECT DEPARTMENT_ID,LOCATION_ID FROM PRO_PROJECTS WHERE PROJECT_ID = #attributes.pj_id#
            </cfquery>
            <cfset attributes.department_out = get_project_department.department_id>
            <cfset attributes.location_out = get_project_department.location_id>
            <cfset attributes.txt_departman_out = get_location_info(attributes.department_out,attributes.location_out)>
        </cfif>
    </cfif>
    <cfif (isdefined('attributes.type') and type eq 'convert') and not isdefined("process_cat_id") and not isdefined("attributes.service") and not isdefined("attributes.material_id")><!--- Üretim Malzeme İhtiyaçları veya İç Talepler Listesinden Dönüşüm Yapılıyorsa --->
        <cfquery name="get_process_type" datasource="#dsn3#" maxrows="1"><!--- Ambar fişi oluşturmak istendiği için seçili işlem tipinden ambar fişini seçili hale getiriyoruz. --->
            SELECT 
                PROCESS_TYPE,
                IS_CARI,
                IS_ACCOUNT,
                IS_STOCK_ACTION,
                PROCESS_CAT_ID
            FROM 
                SETUP_PROCESS_CAT 
            WHERE 
                PROCESS_TYPE = 113
        </cfquery>
	<cfelseif (isdefined('attributes.type') and attributes.type eq 'convert')  and isdefined("attributes.process_type") and isdefined("attributes.material_id")>
         <cfquery name="get_process_cat" datasource="#dsn3#" maxrows="1">
            SELECT 
                PROCESS_CAT_ID
            FROM 
                SETUP_PROCESS_CAT 
            WHERE 
                PROCESS_TYPE = #attributes.process_type#
        </cfquery>
     </cfif>
	<cfif isdefined("attributes.service_id") and len(attributes.service_id)>
        <cfquery name="GET_SERVICE_NO" datasource="#DSN3#">
            SELECT SERVICE_NO FROM SERVICE WHERE SERVICE_ID = #attributes.service_id#
        </cfquery>
    </cfif>
	<cfif isdefined('attributes.internal_row_info')><!--- ic talepler listesinden olusturulacaksa --->
        <cfset attributes.basket_related_action = 1> 
    </cfif>
    <cfif session.ep.isBranchAuthorization eq 1><!--- subeden cagırılıyorsa sube basket sablonunu kullansın--->
        <cfset attributes.basket_id = 19>
        <cfquery name="GET_IS_SELECTED" datasource="#DSN3#">
            SELECT IS_SELECTED FROM SETUP_BASKET_ROWS WHERE BASKET_ID = 19 AND B_TYPE=1 AND TITLE = 'is_project_selected'
        </cfquery>
    <cfelse>
        <cfset attributes.basket_id = 12>
        <cfquery name="GET_IS_SELECTED" datasource="#DSN3#">
            SELECT IS_SELECTED FROM SETUP_BASKET_ROWS WHERE BASKET_ID = 12 AND B_TYPE=1 AND TITLE = 'is_project_selected'
        </cfquery>
    </cfif>
    <cfif not isdefined('attributes.type') and not (isdefined("attributes.upd_id") and len(attributes.upd_id))><!--- Malzeme İhtiyaçları Sayfasından Gelmiyor ise burayı yoksa direkt 12 nolu basket açsın +  kopyalama da değilse --->
        <cfif not isdefined("attributes.file_format")>
           <cfset attributes.form_add = 1>
        <cfelse>
           <cfset attributes.basket_sub_id = 12>
        </cfif>	
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
   <cf_get_lang_set module_name="stock">
    <cf_xml_page_edit fuseact="stock.form_add_fis">
    <cfif isnumeric(attributes.upd_id)>
        <cfscript>session_basket_kur_ekle(action_id=attributes.upd_id,table_type_id:6,process_type:1);</cfscript>
        <cfinclude template="../stock/query/get_fis_det.cfm">
        <cfif len(get_fis_det.prod_order_result_number) and len(get_fis_det.prod_order_number)>
            <cfquery name="GET_PROD_ORDER_NO" datasource="#DSN3#">
                SELECT 
                    RESULT_NO,
                    PR_ORDER_ID,
                    PRODUCTION_ORDERS.P_ORDER_ID
                FROM
                    PRODUCTION_ORDERS,
                    PRODUCTION_ORDER_RESULTS
                WHERE 
                    PRODUCTION_ORDERS.P_ORDER_ID = PRODUCTION_ORDER_RESULTS.P_ORDER_ID AND
                    PRODUCTION_ORDER_RESULTS.PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_fis_det.prod_order_result_number#"> AND
                    PRODUCTION_ORDERS.P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_fis_det.prod_order_number#">
            </cfquery>
        </cfif>
    <cfelse>
        <cfset get_fis_det.recordcount = 0>
    </cfif>
    <cfif not get_fis_det.recordcount>
        <cfset hata  = 11>
        <cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'> <cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</cfsavecontent>
        <cfset hata_mesaj  = message>
        <cfinclude template="../dsp_hata.cfm">
        <cfabort>
    <cfelse> 
        <cfquery name="CONTROL_DISPOSAL" datasource="#DSN#">
            SELECT * FROM WASTE_DISPOSAL_RESULT WHERE DISPOSAL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.upd_id#">
        </cfquery>
        <cfinclude template="../stock/query/get_shipment_method.cfm">
        <cfset attributes.cat="">
        <cfquery name="GET_INTERNALDEMAND_RELATION" datasource="#DSN3#">
            SELECT 
                DISTINCT 
                IR.INTERNALDEMAND_ID
            FROM 
                INTERNALDEMAND_RELATION IR,
                INTERNALDEMAND I
            WHERE 
                I.INTERNAL_ID = IR.INTERNALDEMAND_ID AND
                IR.TO_STOCK_FIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_fis_det.fis_id#"> AND 
                IR.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
        </cfquery>
        <cfif len(get_fis_det.service_id)>
            <cfquery name="GET_SERVICE_NO" datasource="#DSN3#">
                SELECT SERVICE_NO FROM SERVICE WHERE SERVICE_ID = #get_fis_det.service_id#
            </cfquery>
        </cfif>
        <cfif len(get_fis_det.prod_order_number)>
            <cfquery name="GET_PRODUCTION_ORDER" datasource="#DSN3#">
                SELECT P_ORDER_NO FROM PRODUCTION_ORDERS WHERE P_ORDER_ID = #get_fis_det.prod_order_number#
            </cfquery>				  
        </cfif>
        <cfif session.ep.our_company_info.project_followup eq 1 and len(get_fis_det.project_id)>
            <cfquery name="GET_PROJECT" datasource="#DSN#">
                SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #get_fis_det.project_id#
            </cfquery>
        </cfif>
        <cfif session.ep.our_company_info.project_followup eq 1 and len(get_fis_det.project_id_in)>
            <cfquery name="GET_PROJECT" datasource="#DSN#">
                SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_fis_det.project_id_in#">
            </cfquery>
        </cfif>
        <cfif session.ep.isBranchAuthorization eq 1><!--- subeden cagırılıyorsa sube basket sablonunu kullansın--->
            <cfset attributes.basket_id = 19> 
             <cfquery name="GET_IS_SELECTED" datasource="#DSN3#">
                SELECT IS_SELECTED FROM SETUP_BASKET_ROWS WHERE BASKET_ID = 19 AND B_TYPE=1 AND TITLE = 'is_project_selected'
            </cfquery>
        <cfelse>
             <cfquery name="GET_IS_SELECTED" datasource="#DSN3#">
                SELECT IS_SELECTED FROM SETUP_BASKET_ROWS WHERE BASKET_ID = 12 AND B_TYPE=1 AND TITLE = 'is_project_selected'
            </cfquery>
            <cfset attributes.basket_id = 12>
        </cfif>
    </cfif>
</cfif>
<script type="text/javascript">
	function kontrol2()
    {
        deger=parseInt(window.document.form_basket.process_cat.value);
        var fis_no = document.getElementById('ct_process_type_'+deger);
        if(!chk_process_cat('form_basket')) return false;
        if(!check_display_files('form_basket')) return false;
        if(!chk_period(form_basket.fis_date,"İşlem")) return false;
        form_basket.del_fis.value =1;
		if(check_stock_action('form_basket') && list_find('110,113', fis_no.value))
		{
			var basket_zero_stock_status = wrk_safe_query('inv_basket_zero_stock_status','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
			if(basket_zero_stock_status.IS_SELECTED != 1)
			{
				if(fis_no.value == 113) is_purchase_info = 1; else is_purchase_info = 0;
				var temp_process_cat = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
				var temp_process_type = document.getElementById('ct_process_type_'+temp_process_cat);
				if(!zero_stock_control(form_basket.department_in.value,form_basket.location_in.value,form_basket.upd_id.value,temp_process_type.value,0,1,1)) return false;
			}
		}
        return true;
    }
<cfif not isdefined("attributes.event") or attributes.event is 'add'>
	function kontrol_kayit()
	{
		if(!paper_control(form_basket.fis_no_,'STOCK_FIS',true,0,'','','')) return false;
		if(!chk_process_cat('form_basket')) return false;
		if(!check_display_files('form_basket')) return false;
		if(!chk_period(form_basket.fis_date,"İşlem")) return false;
		deger = window.document.form_basket.process_cat.options[window.document.form_basket.process_cat.selectedIndex].value;
		if(deger != "")
		{
			var fis_no = document.getElementById('ct_process_type_'+deger);		
			if(list_find('110,115,119',fis_no.value))
			{
			
				if(form_basket.department_in.value == ""  )
				{
					alert("<cf_get_lang no ='424.Giriş Deposunu Seçmelisiniz'>!");
					return false;
				}
	
				<cfif get_is_selected.is_selected eq 1 and session.ep.our_company_info.project_followup eq 1>
					if(document.getElementById('project_id_in').value == "" || document.getElementById('project_head_in').value == "")
					{
						alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='1960.Giris Proje'>");
						return false;
					}
				</cfif>
			
				if( list_find('119',fis_no.value) )
				{
					if (form_basket.prod_order_number.value == '' || form_basket.prod_order.value == '')
					{	
						alert("<cf_get_lang no ='427.Üretimden Gelen Ürünler için Emir No Bilgisini Belirtin'>!");
						return false;
					}	
				}
			}
			if(list_find('111,112',fis_no.value))
			{
				if(form_basket.department_out.value == ""  )
				{
					alert("<cf_get_lang no ='425.Çıkış Deposunu Seçmelisiniz'>!");					
					return false;
				}
				<cfif get_is_selected.is_selected eq 1 and session.ep.our_company_info.project_followup eq 1>
					if(document.getElementById('project_id').value == "" || document.getElementById('project_head').value == "")
					{
						alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='1726.Cikis Proje'>");
						return false;
					}
				</cfif>
			
			}
			if(list_find('113,1131',fis_no.value))
			{
				if(form_basket.department_in.value == "" || form_basket.txt_department_in.value == "" || form_basket.department_out.value == "" )
				{
					alert("<cf_get_lang no ='426.Giriş ve Çıkış Depolarını Seçmelisiniz'>!");
					return false;
				}
				<cfif get_is_selected.is_selected eq 1 and session.ep.our_company_info.project_followup eq 1>
					if(document.getElementById('project_id').value == "" || document.getElementById('project_head').value == "")
					{
						alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='1726.Cikis Proje'>");
						return false;
					}
					if(document.getElementById('project_id_in').value == "" || document.getElementById('project_head_in').value == "")
					{
						alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='1960.Giris Proje'>");
						return false;
					}
				</cfif>
			}
			if(check_stock_action('form_basket') && list_find('110,111,112,113', fis_no.value))
			{
				var basket_zero_stock_status = wrk_safe_query('inv_basket_zero_stock_status','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
				if(basket_zero_stock_status.IS_SELECTED != 1)
				{
					if(!zero_stock_control(form_basket.department_out.value,form_basket.location_out.value,0,fis_no.value)) return false;
				}
			}
			<!---Satır bazında seri girilmesi zorunluluğu kontrolü --->
			<cfif isdefined("xml_serialno_control") and (xml_serialno_control eq 1)>
				prod_name_list = '';
				for(var str=0; str < window.basket.items.length; str++)
				{
					if(window.basket.items[str].PRODUCT_ID != '')
					{
						wrk_row_id_ = window.basket.items[str].WRK_ROW_ID;
						amount_ = window.basket.items[str].AMOUNT;
						product_serial_control = wrk_safe_query("chk_product_serial1",'dsn3',0, window.basket.items[str].PRODUCT_ID);
						get_serial_control = wrk_safe_query('obj_get_seri_row_id','dsn3',0,wrk_row_id_);
						if(product_serial_control.IS_SERIAL_NO=='1'&&get_serial_control.recordcount!=amount_)
						{
							prod_name_list = prod_name_list + eval(str +1) + '.Satır : ' + window.basket.items[str].PRODUCT_NAME + '\n';
						}
					}
				}
				if(prod_name_list!='')
				{
					alert(prod_name_list +" Adlı Ürünler İçin Seri Numarası Girmelisiniz!");
					return false;
				}
			</cfif>
			saveForm();
			return false;
		}
		else
		{
			alert("<cf_get_lang_main no='1358.İşlem Tipi seçiniz'>!");
			return false;
		}
		
	}
	
	function goster_checkbox(yer)
	{
		if(form_basket.process_cat.options[yer].value == 115)
		{
			goster(is_fire_upd);
			goster(sayim_icin);						
		}
		else
		{
			gizle(is_fire_upd);
			gizle(sayim_icin);						
		}
	}
	function goster_checkbox()
	{
		deger = window.document.form_basket.process_cat.options[window.document.form_basket.process_cat.selectedIndex].value;
		if(deger != ""){
			var fis_no = document.getElementById('ct_process_type_'+deger);		
			if(fis_no.value == 115)
			{
				gizle_goster(is_fire_upd);
				gizle_goster(sayim_icin);
			}
		}
	}
	function return_company()
	{	
		if(document.getElementById('member_type').value=='employee')
		{	
			var emp_id=document.getElementById('employee_id').value;
			var GET_COMPANY=wrk_safe_query('sls_get_cmpny','dsn',0,emp_id);
			document.getElementById('company_id').value=GET_COMPANY.COMP_ID;
		}
		else
			return false;
	}
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>  
    function kontrol_kayit()
    {
        if(!chk_process_cat('form_basket')) return false;
        if(!check_display_files('form_basket')) return false;
        if(!chk_period(form_basket.fis_date,"İşlem")) return false;
		if(!paper_control(form_basket.FIS_NO,'STOCK_FIS',true,<cfoutput>'#attributes.upd_id#','#get_fis_det.fis_number#'</cfoutput>)) return false;
        var is_fis_cost = true;
        if(document.form_basket.is_cost.value==0) 
            is_fis_cost = false;
        if (is_fis_cost && !confirm("<cf_get_lang no ='423.Güncellediğiniz Belgenin Masraf Gelir Dağıtımı Yapılmış Devam Ederseniz Bu Dağıtım Silinecektir'>!")) return false;
        deger = window.document.form_basket.process_cat.options[window.document.form_basket.process_cat.selectedIndex].value;
        if(deger != "")
        {

            var fis_no = document.getElementById('ct_process_type_'+deger);
            if(list_find('110,115,119', fis_no.value))
            {
                if(form_basket.department_in.value == "" || form_basket.department_in_txt.value == "")
                {
                    alert("<cf_get_lang no ='424.Giriş Deposunu Seçmelisiniz'> !");
                    return false;
                }
                <cfif get_is_selected.is_selected eq 1 and session.ep.our_company_info.project_followup eq 1>
                    if(document.getElementById('project_id_in').value == "" || document.getElementById('project_head_in').value == "")
                    {
                        alert("Giriş Proje Seçmelisiniz !");
                        return false;
                    }
                </cfif>
            }
            if(list_find('111,112', fis_no.value))
            {
                if(form_basket.department_out.value == "" || form_basket.txt_departman_out_name.value == "")
                {
                    alert("<cf_get_lang no ='425.Çıkış Deposunu Seçmelisiniz'>!");					
                    return false;
                }

                <cfif get_is_selected.is_selected eq 1 and session.ep.our_company_info.project_followup eq 1>
                    if(document.getElementById('project_id').value == "" || document.getElementById('project_head').value == "")
                    {
                        alert("Çıkış Proje Seçmelisiniz !");
                        return false;
                    }
                </cfif>

            }
            if(fis_no.value == 113)
            {
                if(form_basket.department_in.value == "" || form_basket.department_in_txt.value == "" || form_basket.department_out.value == "" || form_basket.txt_departman_out_name.value == "" )
                {
                    alert("<cf_get_lang no ='426.Giriş ve Çıkış Depolarını Seçmelisiniz'>!");
                    return false;
                }
                <cfif get_is_selected.is_selected eq 1 and session.ep.our_company_info.project_followup eq 1>
                
                    if(document.getElementById('project_id_in').value == "" || document.getElementById('project_head_in').value == "")
                    {
                        alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='1960.Giris Proje'>");
                        return false;
                    }
                </cfif>
                <cfif get_is_selected.is_selected eq 1 and session.ep.our_company_info.project_followup eq 1>
                    if(document.getElementById('project_id').value == "" || document.getElementById('project_head').value == "")
                    {
                        alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='1726.Cikis Proje'>");
                        return false;
                    }
                </cfif>										
            }
            if(check_stock_action('form_basket') && list_find('110,113', fis_no.value))
            {
                var basket_zero_stock_status = wrk_safe_query('inv_basket_zero_stock_status','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
                if(basket_zero_stock_status.IS_SELECTED != 1)
                {
                    if(fis_no.value == 113) is_purchase_info = 1; else is_purchase_info = 0;
                    var temp_process_cat = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
                    var temp_process_type = document.getElementById('ct_process_type_'+temp_process_cat);
                    if(!zero_stock_control(form_basket.department_in.value,form_basket.location_in.value,form_basket.upd_id.value,temp_process_type.value,0,0,is_purchase_info)) return false;
                }
            }
            if(check_stock_action('form_basket') && list_find('110,111,112,113', fis_no.value))
            {
                var basket_zero_stock_status = wrk_safe_query('inv_basket_zero_stock_status','dsn3',0, <cfoutput>#attributes.basket_id#</cfoutput>);
                if(basket_zero_stock_status.IS_SELECTED != 1)
                {
                    if(!zero_stock_control(form_basket.department_out.value,form_basket.location_out.value,form_basket.upd_id.value,fis_no.value)) return false;
                }
            }
			saveForm();
            return false;
        }
        else
        {
            alert("<cf_get_lang_main no='1358.İşlem Tipi seçiniz'>!");
            return false;
        }
    }
	
</cfif>
function kontrol_giris()
	{
		deger = form_basket.process_cat.options[form_basket.process_cat.selectedIndex].value;
		if(deger != "")
		{
			var fis_no = document.getElementById('ct_process_type_'+deger);
			if(list_find('111,112', fis_no.value))
			{
				alert("<cf_get_lang no ='234.Sarf ve Fire Fişleri için Giriş Deposu Seçemezsiniz'>!");
				return false;
			}
			return true;
		}
		else
			alert("<cf_get_lang_main no='1358.İşlem Tipi seçiniz'>!");
	}
	 function o_window()
    {
        deger=parseInt(window.document.form_basket.process_cat.value);
        var fis_no = document.getElementById('ct_process_type_'+deger);
        if(list_find('111,112', fis_no.value) && document.getElementById('project_id').value!='')
        {
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_work&field_id=form_basket.work_id&field_name=form_basket.work_head&sarf_project_id='+document.getElementById('project_id').value,'list');
        }
        else
        {
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_work&field_id=form_basket.work_id&field_name=form_basket.work_head','list');
        }
    }
		function kontrol_cikis()
	{
		deger=form_basket.process_cat.options[form_basket.process_cat.selectedIndex].value;
		if(deger != "")
		{
			var fis_no = document.getElementById('ct_process_type_'+deger);		
			if(list_find('110,115,119', fis_no.value))
			{
				alert("<cf_get_lang no ='422.Üretimden Gelen Ürünler ve Sayım Fişleri için Çıkış Deposu Seçemezsiniz'>!");
				return false;
			}
			return true;
		}
		else
			alert("<cf_get_lang_main no='1358.İşlem Tipi seçiniz'>!")
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
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.form_add_fis';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'stock/form/form_add_fis.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'stock/query/add_ship_fis.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'stock.form_add_fis&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_basket(add_fis_process)";

	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.form_add_fis&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'stock/form/form_upd_fis.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'stock/query/upd_fis.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'stock.form_add_fis&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'upd_id=##attributes.upd_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.upd_id##';
	WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_basket(upd_fis)";
	
	if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_fis_process&upd_id=#attributes.upd_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'stock/query/upd_fis.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'stock/query/upd_fis.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_purchase';
		WOStruct['#attributes.fuseaction#']['del']['extraParams'] = 'active_period&process_cat&upd_id&old_process_type&del_fis&type_id&FIS_NO&cat';
	}
	
	if(isdefined("attributes.event") and attributes.event is 'del')       
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'stock.form_add_fis';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'stock/form/form_upd_fis.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'stock/query/upd_fis.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'stock.welcome';

	}
	if(isdefined("attributes.event") and attributes.event is 'upd')       
	{

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1966]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['customTag'] = '<cf_get_workcube_related_acts period_id="#session.ep.period_id#" company_id="#session.ep.company_id#" asset_cat_id="-24" module_id="13" action_section="FIS_ID" action_id="#url.upd_id#">';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[623]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_upd_expensecenter_invoice&id=#GET_FIS_DET.FIS_ID#&is_stock_fis=1','horizantal')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = '#lang_array_main.item[345]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=stock.form_upd_fis&action_name=upd_id&action_id=#attributes.upd_id#&relation_papers_type=FIS_ID','list')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['text'] = '#lang_array_main.item[2402]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#upd_id#&process_cat='+form_basket.old_process_type.value,'page','form_upd_fis')";
		if(get_fis_det.fis_type eq 112){
			if(not control_disposal.recordcount)
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['text'] = '#lang_array_main.item[2586]#';//ek bilgi
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_add_disposal_report&action_id=#upd_id#','page','workcube_print')";
			}
			else if(control_disposal.recordcount)
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['text'] = '#lang_array_main.item[2586]#';//ek bilgi
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_add_disposal_report&action_id=#upd_id#','page','workcube_print')";
			}
			if(session.ep.our_company_info.guaranty_followup)
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['text'] = '#lang_array_main.item[305]#-#lang_array_main.item[306]#';//ek bilgi
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_serial_operations&is_filtre=1&belge_no=#get_fis_det.fis_number#&process_cat_id=#get_fis_det.fis_type#&process_id=#url.upd_id#";
			}

		}
		else
		{
			if(session.ep.our_company_info.guaranty_followup)
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['text'] = '#lang_array_main.item[305]#-#lang_array_main.item[306]#';//ek bilgi
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_serial_operations&is_filtre=1&belge_no=#get_fis_det.fis_number#&process_cat_id=#get_fis_det.fis_type#&process_id=#url.upd_id#";
			}
		}

			
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=stock.form_add_fis&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=stock.form_add_fis&event=add&upd_id=#url.upd_id#";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.upd_id#&print_type=31','page','workcube_print')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);

	}
	else
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['text'] = '#lang_array_main.item[1114]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['href'] = "#request.self#?fuseaction=stock.add_ship_from_file&from_where=4";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'stockReceipt';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'STOCK_FIS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-process_cat','item-fis_no_','item-fis_date','txt_department_in','txt_departman_out','member_name']";
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'stockReceipt';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'STOCK_FIS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-process_cat','item-FIS_NO','item-fis_date','department_in_txt','txt_departman_out_name','member_name']";
</cfscript>