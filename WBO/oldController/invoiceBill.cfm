<cf_get_lang_set module_name="invoice"><!--- sayfanin en altinda kapanisi var --->
<cfset process_cat = "">
<cfinclude template="../invoice/query/get_session_cash_all.cfm">
<cfif isdefined("attributes.event") and attributes.event is 'upd'>
    	<cf_xml_page_edit fuseact="invoice.detail_invoice_sale">		
		<cfif isnumeric(attributes.iid)>
            <cfinclude template="../invoice/query/get_sale_det.cfm">
			<cfset process_cat = get_sale_det.process_cat>
            <cfquery name="CHK_SEND_INV" datasource="#dsn2#">
            	SELECT COUNT(*) COUNT FROM EINVOICE_SENDING_DETAIL WHERE  ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#"> AND ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1
            </cfquery>
            <cfquery name="CHK_SEND_ARC" datasource="#dsn2#">
            	SELECT COUNT(*) COUNT FROM EARCHIVE_SENDING_DETAIL WHERE  ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#"> AND ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1
            </cfquery> 
            <cfquery name="control_archive_cancel" datasource="#dsn2#">
            	SELECT ISNULL(IS_CANCEL,0) IS_CANCEL FROM EARCHIVE_RELATION WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#"> AND ACTION_TYPE = 'INVOICE'
            </cfquery> 
		<cfelse>
            <cfset get_sale_det.recordcount = 0>
        </cfif>
		<cfif not get_sale_det.recordcount>
            <cfset hata  = 11>
            <cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'>  <cf_get_lang_main no='587.Çalıştığınız Muhasebe Dönemine Ait Böyle Bir Fatura Bulunamadı'> !</cfsavecontent>
            <cfset hata_mesaj  = message>
            <cfinclude template="../dsp_hata.cfm">
            <cfabort>
        <cfelse>
        <!--- Faturaya ait herhangi bir odeme plani satiri bankaya gonderilmisse fatura silinemez --->
            <cfquery name="get_invoice_payment_plan" datasource="#dsn3#">
                SELECT IS_BANK FROM INVOICE_PAYMENT_PLAN WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.iid#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
            </cfquery>
        <cfif get_invoice_payment_plan.recordcount>
            <cfoutput query="get_invoice_payment_plan">
                <cfif is_bank eq 1><cfset is_not_delete = 1></cfif>
            </cfoutput>
        </cfif>
		<cfif len(get_sale_det.contract_id)>
            <cfquery name="getContract" datasource="#dsn3#">
                SELECT CONTRACT_HEAD FROM RELATED_CONTRACT WHERE CONTRACT_ID = #get_sale_det.contract_id#
            </cfquery>
        </cfif>
        <cfif (GET_SALE_DET.INVOICE_TYPE_CODE eq 'SATIS' or GET_SALE_DET.INVOICE_TYPE_CODE eq 'IADE') and (len(get_sale_det.company_id) and get_sale_det_comp.use_efatura eq 1 and datediff('d',get_sale_det_comp.efatura_date,get_sale_det.invoice_date) gte 0) or (len(get_sale_det.consumer_id) and get_cons_name.use_efatura eq 1 and datediff('d',get_cons_name.efatura_date,get_sale_det.invoice_date) gte 0) and datediff('d',createodbcdatetime('#year(session.ep.our_company_info.efatura_date)#-#month(session.ep.our_company_info.efatura_date)#-#day(session.ep.our_company_info.efatura_date)#'),get_sale_det.invoice_date) gt 0>
            <cfif isdefined("xml_warning_type")>
                <cfquery name="kontrol_warning" datasource="#dsn2#">
                    SELECT COUNT(*) COUNT FROM EINVOICE_SENDING_DETAIL WHERE  ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#"> AND ACTION_TYPE = 'INVOICE'
                </cfquery> 
                <cfif xml_warning_type eq 1 and chk_send_inv.count eq 0><!--- Gönderilmemiş olan tüm faturalar için uyarı verilecek --->
                    <cfset is_einvoice_warning = 1>
                <cfelseif xml_warning_type eq 2 and chk_send_inv.count eq 0><!--- Hiç gönderilmemiş faturalar için uyarı verilecek --->	
                    <cfset is_einvoice_warning = 1>
                <cfelseif xml_warning_type eq 3 and kontrol_warning.count neq 0 and chk_send_inv.count eq 0><!--- Daha önce gönderilip hata alınan faturalar için uyarı verilecek --->	
                    <cfset is_einvoice_warning = 1>
                </cfif>
            </cfif>
        <cfelseif (GET_SALE_DET.INVOICE_TYPE_CODE eq 'SATIS' or GET_SALE_DET.INVOICE_TYPE_CODE eq 'IADE') and session.ep.our_company_info.is_earchive eq 1 and datediff('d',createodbcdatetime('#year(session.ep.our_company_info.earchive_date)#-#month(session.ep.our_company_info.earchive_date)#-#day(session.ep.our_company_info.earchive_date)#'),get_sale_det.invoice_date) gte 0>
            <cfif isdefined("xml_warning_type_archive")>
                <cfquery name="kontrol_warning" datasource="#dsn2#">
                    SELECT COUNT(*) COUNT FROM EARCHIVE_SENDING_DETAIL WHERE  ACTION_ID = #attributes.iid# AND ACTION_TYPE = 'INVOICE'
                </cfquery> 
                <cfif xml_warning_type_archive eq 1 and (chk_send_arc.count eq 0 or (get_sale_det.is_iptal eq 1 and control_archive_cancel.recordcount and control_archive_cancel.is_cancel eq 0))><!--- Gönderilmemiş olan tüm faturalar için uyarı verilecek --->
                    <cfset is_einvoice_warning_arc = 1>
                </cfif>
            </cfif>
        </cfif>
        <cfinclude template="../objects/query/paper_closed_control.cfm">
        <cfinclude template="../invoice/query/get_moneys.cfm">
        <cfinclude template="../invoice/query/get_inv_cancel_types.cfm">
        <cfparam name="attributes.company_id" default="#get_sale_det.company_id#">
        <cfparam name="attributes.invoice_number" default="#get_sale_det.invoice_number#">
        <cfscript>session_basket_kur_ekle(action_id=attributes.iid,table_type_id:1,process_type:1);</cfscript>
        </cfif>
        <cfquery name="get_contract_comp" datasource="#dsn2#">
            SELECT RELATED_ACTION_ID FROM INVOICE_ROW WHERE INVOICE_ID = #attributes.iid# AND RELATED_ACTION_TABLE = 'INVOICE_CONTRACT_COMPARISON'
        </cfquery>
		<cfif not (len(get_sale_det.sales_partner_id) or len(get_sale_det.sales_consumer_id)) and len(ship_id_with_period)>
            <cfquery name="get_sales_emp_id" datasource="#dsn2#">
                SELECT 
                    SHIP_ROW.ROW_ORDER_ID,
                    ORDERS.SALES_PARTNER_ID,
                    ORDERS.SALES_CONSUMER_ID
                FROM 
                    SHIP_ROW,
                    #dsn3_alias#.ORDERS ORDERS
                WHERE 
                    SHIP_ROW.SHIP_ID = #listgetat(ship_id_with_period,1,';')#
                    AND SHIP_ROW.ROW_ORDER_ID = ORDERS.ORDER_ID
            </cfquery>       
            <cfset get_sale_det.sales_partner_id = get_sales_emp_id.sales_partner_id>
            <cfset get_sale_det.sales_consumer_id = get_sales_emp_id.sales_consumer_id>
        </cfif>
		<cfif get_sale_det.upd_status neq 0>
			<cfset kontrol_prov = 0>
            <cfset kontrol_hobim = 0>
            <cfif xml_control_payment_rows eq 1><!--- xml den ödeme planı satırları kontrol edilsin mi seçeneği seçilmişse --->
                <cfquery name="control_prov_rows" datasource="#dsn3#">
                    SELECT 
                        SPR.SUBSCRIPTION_ID,
                        SC.SUBSCRIPTION_NO
                    FROM 
                        SUBSCRIPTION_PAYMENT_PLAN_ROW SPR,
                        SUBSCRIPTION_CONTRACT SC
                    WHERE 
                        SPR.INVOICE_ID = #get_sale_det.invoice_id#
                        AND SPR.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID
                        AND SPR.PERIOD_ID = #session.ep.period_id#
                        AND ISNULL(SPR.IS_COLLECTED_PROVISION,0) = 1
                        AND ISNULL(SPR.IS_PAID,0) = 0
                </cfquery>
                <cfset kontrol_prov = control_prov_rows.recordcount>
        	</cfif>
		   <cfif get_sale_det.upd_status neq 0>                       
                <cfif not len(paper_closed_control.action_id)>
                    <cfif get_sale_det.is_iptal eq 1 and session.ep.our_company_info.is_earchive eq 1>
                    	<cfif control_archive_cancel.recordcount and control_archive_cancel.is_cancel eq 0>
                    		<cfset workcubeButtonInfo = 'Fatura İptal Edildi'>
                        <cfelse>
                        	<cfset workcubeButtonInfo = 'Fatura İptal Edildi(İptal Bilgisi E-Arşiv Sistemine Gönderilmedi)'>
                        </cfif>
					<cfelseif kontrol_prov eq 0>
                        <cfif kontrol_hobim eq 0>
                            <cfif isdefined("is_not_delete") and is_not_delete eq 1>
								<cfset workcubeButtonIsUpd = 1>
                                <cfset workcubeButtonIsDelete = 0>
                            <cfelse>
                                <cfif chk_send_arc.recordcount and chk_send_arc.count gt 0>
									<cfset workcubeButtonIsUpd = 1>
                                    <cfset workcubeButtonIsDelete = 0>
                                <cfelse>
									<cfset workcubeButtonIsUpd = 1>
                                    <cfset workcubeButtonIsDelete = 1>
                                </cfif>
                            </cfif>
                        <cfelse>
                            <cfif control_hobim.is_iptal eq 1>
                                <cfif chk_send_arc.recordcount and chk_send_arc.count gt 0>
									<cfset workcubeButtonIsUpd = 1>
                                    <cfset workcubeButtonIsDelete = 0>
                                <cfelse>
									<cfset workcubeButtonIsUpd = 1>
                                    <cfset workcubeButtonIsDelete = 1>
                                </cfif>
                            <cfelseif control_hobim.is_printed eq 1>
                            	<cfset workcubeButtonInfo = 'Hobim ID : #control_hobim.hobim_id# / Basıldı'>
                            <cfelse>
                            	<cfif control_hobim.is_printed eq 1>
                                	<cfset workcubeButtonInfo = 'Hobim ID : #control_hobim.hobim_id# / Basıldı'>
                                <cfelseif control_hobim.is_sent eq 1>
                                	<cfset workcubeButtonInfo = 'Hobim ID : #control_hobim.hobim_id# / Gönderildi'>
                                </cfif>
                            </cfif>
                        </cfif>
                    <cfelse>
                    	<cfset workcubeButtonInfo = '#lang_array.item[38]#. #lang_array_main.item[1705]# : #control_prov_rows.SUBSCRIPTION_NO#'><!--- <cf_get_lang no="38.Ödenmemiş Provizyon">. <cf_get_lang_main no="1705.Sistem No"> : <cfoutput>#control_prov_rows.SUBSCRIPTION_NO#</cfoutput> --->
                    </cfif>
                <cfelse>
					<cfset workcubeButtonInfo = '#lang_array_main.item[2355]#'><!--- Fatura kapama işlemi yapılan belgede değişiklik yapılamaz --->
                </cfif>     
            </cfif>
			<cfif len(get_sale_det.print_count)>
                <cfset workcubeButtonExtraInfo = '#lang_array.item[221]# : #get_sale_det.print_count#<br>#lang_array.item[37]# : #dateformat(get_sale_det.print_date,'dd/mm/yyyy')#'>
            </cfif>
        </cfif>
         <cfif session.ep.isBranchAuthorization><!--- subeden cagırılıyorsa sube basket sablonunu kullansın--->
            <cfset attributes.basket_id = 18> 
        <cfelse>
            <cfset attributes.basket_id = 2>
        </cfif>                                           
    </cfif>
<cfif  not isdefined("attributes.event") or  (isdefined("attributes.event") and attributes.event is 'add')>
		<cf_xml_page_edit fuseact="invoice.form_add_bill">
        <cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
        <cfset kontrol_status = 1>
        <cfinclude template="../invoice/query/control_bill_no.cfm">
        <cfparam name="attributes.member_account_code" default="">
        <cfparam name="attributes.invoice_counter_number" default="">
        <cfparam name="attributes.subscription_id" default="">
        <cfparam name="attributes.list_payment_row_id" default="">
        <cfparam name="attributes.company_id" default="">	
        <cfparam name="attributes.comp_name" default="">
        <cfparam name="attributes.consumer_id" default="">
        <cfparam name="attributes.partner_id" default="">
        <cfparam name="attributes.partner_name" default="">
        <cfparam name="attributes.employee_id" default="">
        <cfparam name="attributes.consumer_reference_code" default="">
        <cfparam name="attributes.partner_reference_code" default="">
        <cfparam name="attributes.ref_no" default="">
        <cfparam name="attributes.city_id" default="">
        <cfparam name="attributes.county_id" default="">
        <cfparam name="attributes.department_name" default="">
        <cfparam name="attributes.process_cat" default="">
        <cfparam name="attributes.note" default="">
        <!--- üye bilgileri sayfasından gelince kullanılıyor --->
        <cfset paper_type = 'invoice'>
        <cfif isdefined('attributes.company_id') and len(attributes.company_id)>
            <cfset attributes.company_id = attributes.company_id>
            <cfquery name="get_comp_info" datasource="#dsn#">
                SELECT FULLNAME,USE_EFATURA,EFATURA_DATE FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
            </cfquery>
            <cfset attributes.comp_name = get_comp_info.FULLNAME>
            <cfif len(get_comp_info.use_efatura) and get_comp_info.use_efatura eq 1 and datediff('d',dateformat(get_comp_info.efatura_date,'dd/mm/yyyy'),dateformat(now(),'dd/mm/yyyy')) gte 0>
                <cfset paper_type = 'e_invoice'>
            </cfif>
            <cfif len(attributes.partner_id)>
                <cfset attributes.partner_id = attributes.partner_id>
                <cfset attributes.partner_name = get_par_info(attributes.partner_id,0,-1,0)>
            <cfelse>
                <cfquery name="get_manager_partner" datasource="#dsn#">
                    SELECT MANAGER_PARTNER_ID FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
                </cfquery>
                <cfset attributes.partner_id = get_manager_partner.manager_partner_id>
                <cfset attributes.partner_name = get_par_info(get_manager_partner.manager_partner_id,0,-1,0)>
            </cfif>
            <cfset attributes.member_account_code = GET_COMPANY_PERIOD(attributes.company_id)>
            <cfif isdefined("attributes.service_operation_ids") and len(attributes.service_operation_ids)>
                <cfquery name="get_comp_info" datasource="#dsn#">
                    SELECT FULLNAME,COMPANY_ADDRESS,COMPANY_POSTCODE,SEMT,COUNTY,CITY,COUNTRY FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
                </cfquery>
                <cfset attributes.comp_name = get_comp_info.FULLNAME>
                <cfset attributes.partner_name = get_par_info(attributes.partner_id,0,-1,0)>
                
                <cfset attributes.city_id = get_comp_info.CITY>
                <cfset attributes.county_id = get_comp_info.COUNTY>
                <cfset attributes.country_id = get_comp_info.COUNTRY>
                <cfscript>
                if(len(attributes.county_id))
                {
                    get_comp_county_id = cfquery(SQLString:'SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID=#attributes.county_id#',Datasource:dsn);
                    attributes.county=get_comp_county_id.COUNTY_NAME;
                }
                else
                    attributes.county="";
        
                if(len(attributes.city_id))
                {
                    get_comp_city_id = cfquery(SQLString:'SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID=#attributes.city_id#',Datasource:dsn);
                    attributes.city=get_comp_city_id.CITY_NAME;
                }
                else
                    attributes.city="";
        
                if(len(attributes.country_id))
                {
                    get_comp_country_id =cfquery(SQLString:'SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID=#attributes.country_id#',Datasource:dsn);
                    attributes.country=get_comp_country_id.COUNTRY_NAME;
                }
                else
                    attributes.country="";
                </cfscript>
                <cfset attributes.adres = "#get_comp_info.COMPANY_ADDRESS# #get_comp_info.COMPANY_POSTCODE# #get_comp_info.semt# #attributes.county# #attributes.city# #attributes.country#">	
            </cfif>
        <cfelseif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
            <cfquery name="get_cons_info_" datasource="#dsn#">
                SELECT CONSUMER_NAME+' '+CONSUMER_SURNAME FULLNAME,USE_EFATURA,EFATURA_DATE FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
            </cfquery>
            <cfif len(get_cons_info_.use_efatura) and get_cons_info_.use_efatura eq 1 and datediff('d',dateformat(get_cons_info_.efatura_date,'dd/mm/yyyy'),dateformat(now(),'dd/mm/yyyy')) gte 0>
                <cfset paper_type = 'e_invoice'>
            </cfif>
            <cfset attributes.consumer_id = attributes.consumer_id>
            <cfset attributes.partner_name = get_cons_info_.FULLNAME>
            <cfset attributes.member_account_code = GET_CONSUMER_PERIOD(attributes.consumer_id)>
        <cfelseif isdefined("attributes.project_id") and len(attributes.project_id)>
            <cfquery name="get_project_info" datasource="#dsn#">
                SELECT COMPANY_ID,PARTNER_ID,CONSUMER_ID FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
            </cfquery>
            <cfif len(get_project_info.partner_id)>
                <cfset attributes.company_id = get_project_info.company_id>
                <cfset attributes.partner_id = get_project_info.partner_id>
                <cfset attributes.partner_name = get_par_info(get_project_info.partner_id,0,-1,0)>
                <cfset attributes.comp_name =get_par_info(get_project_info.company_id,1,0,0)>
                <cfset attributes.member_account_code = GET_COMPANY_PERIOD(get_project_info.company_id)>
            <cfelseif len(get_project_info.consumer_id)>
                <cfset attributes.consumer_id = get_project_info.consumer_id>
                <cfset attributes.partner_name = get_cons_info(get_project_info.consumer_id,0,0)>
                <cfset attributes.comp_name =get_cons_info(get_project_info.consumer_id,2,0)>
                <cfset attributes.member_account_code = GET_CONSUMER_PERIOD(get_project_info.consumer_id)>
            </cfif>
        <cfelseif isdefined("attributes.assetp_id") and len(attributes.assetp_id)>
            <cfquery name="get_assetp_member" datasource="#dsn#" maxrows="1">
                SELECT * FROM RELATION_ASSETP_MEMBER WHERE ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#">
            </cfquery>
            <cfif get_assetp_member.recordcount>
                <cfset attributes.company_id = get_assetp_member.company_id>
                <cfset attributes.partner_id = get_assetp_member.partner_id>
                <cfquery name="get_comp_info" datasource="#dsn#">
                    SELECT FULLNAME,COMPANY_ADDRESS,COMPANY_POSTCODE,SEMT,COUNTY,CITY,COUNTRY FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
                </cfquery>
                <cfset attributes.comp_name = get_comp_info.FULLNAME>
                <cfset attributes.partner_name = get_par_info(attributes.partner_id,0,-1,0)>
                
                <cfset attributes.city_id = get_comp_info.CITY>
                <cfset attributes.county_id = get_comp_info.COUNTY>
                <cfset attributes.country_id = get_comp_info.COUNTRY>
                <cfscript>
                if(len(attributes.county_id))
                {
                    get_comp_county_id = cfquery(SQLString:'SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID=#attributes.county_id#',Datasource:dsn);
                    attributes.county=get_comp_county_id.COUNTY_NAME;
                }
                else
                    attributes.county="";
        
                if(len(attributes.city_id))
                {
                    get_comp_city_id = cfquery(SQLString:'SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID=#attributes.city_id#',Datasource:dsn);
                    attributes.city=get_comp_city_id.CITY_NAME;
                }
                else
                    attributes.city="";
        
                if(len(attributes.country_id))
                {
                    get_comp_country_id =cfquery(SQLString:'SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID=#attributes.country_id#',Datasource:dsn);
                    attributes.country=get_comp_country_id.COUNTRY_NAME;
                }
                else
                    attributes.country="";
                </cfscript>
                <cfset attributes.adres = "#get_comp_info.COMPANY_ADDRESS# #get_comp_info.COMPANY_POSTCODE# #get_comp_info.semt# #attributes.county# #attributes.city# #attributes.country#">	
                
                <cfif listlen(session.ep.USER_LOCATION,"-") gt 2>
                    <cfset attributes.location_id = '#listgetat(session.ep.USER_LOCATION,3,"-")#'>
                    <cfquery name="get_loc" datasource="#dsn#">
                        SELECT 
                            D.DEPARTMENT_HEAD + ' ' + SL.COMMENT AS LOKASYON,
                            SL.LOCATION_ID,
                            SL.DEPARTMENT_ID,
                            D.BRANCH_ID
                        FROM 
                            STOCKS_LOCATION SL,
                            DEPARTMENT D
                        WHERE 
                            SL.LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.location_id#"> AND
                            SL.DEPARTMENT_ID = D.DEPARTMENT_ID
                    </cfquery>
                    <cfset attributes.branch_id = get_loc.branch_id>
                    <cfset attributes.department_id = get_loc.department_id>
                    <cfset attributes.location_id = get_loc.location_id>
                    <cfset attributes.department_name = get_loc.lokasyon>
                </cfif>
            </cfif>	
        </cfif>
        <cfif isdefined('attributes.department_ID') and len(attributes.department_ID)>
            <cfset attributes.branch_id = get_location_info(attributes.department_ID,attributes.location_id,1,1)>
            <cfset attributes.department_ID = attributes.department_ID>
            <cfset attributes.location_id = attributes.location_id>
        <cfelse>
            <cfset attributes.branch_id = ''>
            <cfset attributes.department_ID = ''>
            <cfset attributes.location_id = ''>
        </cfif>
        <cfif isdefined('attributes.subscription_id') and len(attributes.subscription_id)>
            <cfquery name="GET_SUBSCRIPTION" datasource="#DSN3#">
                SELECT SUBSCRIPTION_INVOICE_DETAIL, PROJECT_ID, SUBSCRIPTION_TYPE_ID, PAYMENT_TYPE_ID FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = #attributes.subscription_id#
            </cfquery>
            <cfset attributes.note = GET_SUBSCRIPTION.SUBSCRIPTION_INVOICE_DETAIL>
        </cfif>
        <cfif len(attributes.list_payment_row_id)>
            <cfset paymethod_row_id = ListFirst(attributes.list_payment_row_id)>
            <cfquery name="get_paymethod_id" datasource="#dsn3#">
                SELECT PAYMETHOD_ID FROM SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #paymethod_row_id#
            </cfquery>
            <cfif len(get_paymethod_id.paymethod_id)>
                <cfquery name="get_payment_type" datasource="#DSN#">
                    SELECT ISNULL(DUE_DAY,0) DUE_DAY,PAYMETHOD FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = #get_paymethod_id.paymethod_id#
                </cfquery>
                    <cfset basket_due_value_date_ = DateAdd('D',get_payment_type.due_day,now())>
            </cfif>
        </cfif>
        <cfif isdefined('get_subscription.project_id') and len(get_subscription.project_id)> 
            <cfquery name="get_project_info" datasource="#dsn#">
                SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_subscription.project_id#">
            </cfquery>
        </cfif>
        <cfif isdefined('attributes.contract_id') and len(attributes.contract_id)>
            <cfquery name="getContract" datasource="#dsn3#">
                SELECT CONTRACT_HEAD FROM RELATED_CONTRACT WHERE CONTRACT_ID = #attributes.contract_id#
            </cfquery>
        </cfif>
        
            <cfif session.ep.isBranchAuthorization>
            <!--- subeden cagırılıyorsa sube basket sablonunu kullansın--->
                <cfset attributes.basket_id = 18> 
            <cfelse>
                <cfset attributes.basket_id = 2>
            </cfif>
            <cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id)>
                <cfset attributes.basket_sub_id = 31>
            <cfelseif isdefined("attributes.assetp_id") and len(attributes.assetp_id) and isdefined("attributes.service_operation_id")>
                 <cfset attributes.basket_sub_id = 32>
            <cfelseif isdefined("attributes.service_operation_ids") and isdefined("attributes.is_from_operations")>
                 <cfset attributes.basket_sub_id = 32>
            </cfif>		
            <cfif not isdefined('attributes.stock_id') and not isdefined('attributes.convert_stocks_id') and not isdefined('attributes.stock_name') and not isdefined("attributes.basket_sub_id")>
                <cfset attributes.form_add = 1>
            </cfif>
		</cfif> 
<!---kopyalama için sorgu ve scriptler birleştirilecek smh24032016--->
	<cfif isdefined("attributes.event") and attributes.event is 'copy'>
        <cfinclude template="../invoice/query/get_sale_det.cfm">
    <cfif not get_sale_det.recordcount>
        <br/><font class="txtbold">Çalıştığınız Muhasebe Dönemine Ait Böyle Bir Fatura Bulunamadı !</font>
        <cfexit method="exittemplate">
    </cfif>
    <cfinclude template="../invoice/query/get_session_cash_all.cfm">
    <cfinclude template="../invoice/query/get_moneys.cfm">
    <cfparam name="attributes.company_id" default="#get_sale_det.company_id#">
    <cfparam name="attributes.invoice_number" default="">
    <cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
    <cfset paper_type = 'invoice'>
    <cfif len(get_sale_det.company_id)>
        <cfquery name="get_comp_info" datasource="#dsn#">
            SELECT FULLNAME,USE_EFATURA,EFATURA_DATE FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sale_det.company_id#">
        </cfquery>
        <cfif len(get_comp_info.use_efatura) and get_comp_info.use_efatura eq 1 and datediff('d',dateformat(get_comp_info.efatura_date,'dd/mm/yyyy'),dateformat(now(),'dd/mm/yyyy')) gte 0>
            <cfset paper_type = 'e_invoice'>
        </cfif>
        <cfset member_account_code = get_company_period(get_sale_det.company_id)>
    <cfelseif len(get_sale_det.consumer_id)>
        <cfquery name="get_cons_info_" datasource="#dsn#">
            SELECT CONSUMER_NAME+' '+CONSUMER_SURNAME FULLNAME,USE_EFATURA,EFATURA_DATE FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sale_det.consumer_id#">
        </cfquery>
        <cfif len(get_cons_info_.use_efatura) and get_cons_info_.use_efatura eq 1 and datediff('d',dateformat(get_cons_info_.efatura_date,'dd/mm/yyyy'),dateformat(now(),'dd/mm/yyyy')) gte 0>
            <cfset paper_type = 'e_invoice'>
        </cfif>
        <cfset member_account_code = get_consumer_period(get_sale_det.consumer_id)>
    <cfelseif len(get_sale_det.employee_id)>
        <cfset member_account_code = get_employee_period(get_sale_det.employee_id)>
    </cfif>
    <cfset attributes.department_id = get_sale_det.DEPARTMENT_ID>
    <cfinclude template="../invoice/query/get_dept_name.cfm">
    <cfset txt_department_name = get_dept_name.DEPARTMENT_HEAD>
    <cfset branch_id = get_dept_name.BRANCH_ID>
    <cfif len(get_sale_det.DEPARTMENT_LOCATION)>
		<cfset attributes.location_id = get_sale_det.DEPARTMENT_LOCATION>
        <cfinclude template="../invoice/query/get_location_name.cfm">
        <cfset txt_department_name = txt_department_name & "-" & get_location_name.COMMENT>
    </cfif>
     <cfif len(get_sale_det.card_paymethod_id)>
        <cfquery name="get_card_paymethod" datasource="#dsn3#">
            SELECT 
                CARD_NO
                <cfif get_sale_det.commethod_id eq 6> <!--- WW den gelen siparişlerin guncellemesi, (siparisin commethod_id si faturaya tasınıyor) --->
                ,PUBLIC_COMMISSION_MULTIPLIER AS COMMISSION_MULTIPLIER
                <cfelse>  <!--- EP VE PP den gelen siparişlerin guncellemesi --->
                ,COMMISSION_MULTIPLIER 
                </cfif>
            FROM 
            	CREDITCARD_PAYMENT_TYPE 
            WHERE 
            	PAYMENT_TYPE_ID=#get_sale_det.card_paymethod_id#
        </cfquery>
	</cfif>
    <cfif len(get_sale_det.project_id)>
        <cfquery name="GET_PROJECT" datasource="#dsn#">
            SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #get_sale_det.project_id#
        </cfquery>
	</cfif>
    <cfset attributes.basket_id = 2>
	<script type="text/javascript">
        $( document ).ready(function() {
            change_money_info('form_basket','invoice_date');
            kontrol_yurtdisi();
            check_process_is_sale();
            change_paper_duedate('invoice_date');
        });
        function add_irsaliye()
        {
            if (confirm("<cf_get_lang no ='355.İrsaliye Seçerseniz Ürünler Silinecek, Emin misiniz'> ?"))
                del_rows();
            str_irslink = '&ship_id_liste=' + form_basket.irsaliye_id_listesi.value + '&id=sale_upd&sale_product=1&company_id='+form_basket.company_id.value+'&consumer_id='+ form_basket.consumer_id.value<cfif fusebox.circuit eq "store">+'&is_store='+1</cfif>;
             <cfif session.ep.our_company_info.project_followup eq 1>
                if(form_basket.project_id.value!='' && form_basket.project_head.value!='')
                    str_irslink = str_irslink+'&project_id='+form_basket.project_id.value;
             </cfif>
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_choice_ship' + str_irslink , 'page');
            return true;
        }
        function add_order()
        {	
            if((form_basket.company_id.value.length!="" && form_basket.company_id.value!="") || (form_basket.consumer_id.value.length!="" && form_basket.consumer_id.value!="") || (form_basket.employee_id.value.length!="" && form_basket.employee_id.value!=""))
            {	
                str_irslink = '&is_from_invoice=1&order_id_liste=' + form_basket.order_id_listesi.value + '&is_purchase=0&company_id='+form_basket.company_id.value + '&consumer_id='+form_basket.consumer_id.value<cfif fusebox.circuit eq "store">+'&is_sale_store='+1</cfif>; 
                <cfif session.ep.our_company_info.project_followup eq 1>
                    if(form_basket.project_id.value!='' && form_basket.project_head.value!='')
                        str_irslink = str_irslink+'&project_id='+form_basket.project_id.value;
                </cfif>
                windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_orders_for_ship' + str_irslink , 'list_horizantal');
                return true;
            }
            else (form_basket.company_id.value =="")
            {
                alert("<cf_get_lang no='181.Cari Hesap Seçmelisiniz'> !");
                return false;
            }
        }
        function check_invoice_type()
        {
            if(form_basket.company_id!=undefined && form_basket.company_id.value.length)
            {
                var get_member_control = wrk_safe_query('obj_get_company_efatura','dsn' , 0, form_basket.company_id.value);
            }
            else if(form_basket.consumer_id!=undefined && form_basket.consumer_id.value.length)
            {
                var get_member_control = wrk_safe_query('obj_get_consumer_efatura','dsn',0,form_basket.consumer_id.value);
            }
            if(get_member_control != undefined && get_member_control.USE_EFATURA == 1 && datediff(date_format(get_member_control.EFATURA_DATE),document.getElementById('invoice_date').value,0) >= 0)
                paper_type = 'E_INVOICE';
            else
                paper_type = 'INVOICE';
            paper_control(form_basket.serial_no,paper_type,true,0,'','','','','',1,form_basket.serial_number);
        }
        function kontrol()
        {
            if(form_basket.order_id_listesi.value!='' && form_basket.irsaliye_id_listesi.value != '')
            {
                alert("İrsaliye ve Sipariş Aynı Anda Seçilemez. Lütfen Seçimlerinizi Kontrol Ediniz !");
                return false;
            }
            if (!date_check(form_basket.invoice_date,form_basket.ship_date,"Fiili Sevk Tarihi, Fatura Tarihinden Önce Olamaz!"))
                return false;
            if(form_basket.company_id!=undefined && form_basket.company_id.value.length)
            {
                var get_member_control = wrk_safe_query('obj_get_company_efatura','dsn' , 0, form_basket.company_id.value);
            }
            else if(form_basket.consumer_id!=undefined && form_basket.consumer_id.value.length)
            {
                var get_member_control = wrk_safe_query('obj_get_consumer_efatura','dsn',0,form_basket.consumer_id.value);
            }
            if(get_member_control != undefined && get_member_control.USE_EFATURA == 1 && datediff(date_format(get_member_control.EFATURA_DATE),document.getElementById('invoice_date').value,0) >= 0)
                paper_type = 'E_INVOICE';
            else
                paper_type = 'INVOICE';
            if(!paper_control(document.form_basket.serial_no,paper_type,true,0,'','','','','',1,form_basket.serial_number)) return false;
            <cfif isdefined('xml_acc_department_info') and xml_acc_department_info eq 2> //xmlde muhasebe icin departman secimi zorunlu ise
                if( document.form_basket.acc_department_id.options[document.form_basket.acc_department_id.selectedIndex].value=='')
                {
                    alert("<cf_get_lang_main no='1424.Lutfen Departman Seciniz'>");
                    return false;
                } 
            </cfif>
            <cfif isdefined("xml_upd_row_project") and xml_upd_row_project eq 1 and session.ep.our_company_info.project_followup eq 1>
                apply_deliver_date('','project_head','');
            </cfif>
            if (!chk_process_cat('form_basket')) return false;
            if(!check_display_files('form_basket')) return false;
            if (!chk_period(form_basket.invoice_date,"İşlem")) return false;
            if (!check_accounts('form_basket')) return false;
            if (!check_product_accounts()) return false;
            if (!kontrol_ithalat()) return false;
            var temp_process_cat = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
            if(temp_process_cat.length)
            {
                if(check_stock_action('form_basket')) //islem kategorisi stok hareketi yapıyorsa
                {
                    var fis_no = eval("document.form_basket.ct_process_type_" + temp_process_cat);
                    var basket_zero_stock_status = wrk_safe_query('inv_basket_zero_stock_status','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
                    if(basket_zero_stock_status.IS_SELECTED != 1)//<!--- basket sablonlarında sıfır stok ile calıs secilmemisse zero_stock kontrolu yapılıyor --->
                    {
                        if(!zero_stock_control(form_basket.department_id.value,form_basket.location_id.value,0,fis_no.value)) return false;
                    }
                }
            }
            change_paper_duedate('invoice_date');
            saveForm();
            return false;
        }
        function kontrol2()
        {
            if (!chk_process_cat('form_basket')) return false;
            if(!check_display_files('form_basket')) return false;
            form_basket.del_invoice_id.value = <cfoutput>#attributes.iid#</cfoutput>;
            return true;
        }
    
        function kontrol_ithalat()
        {
            deger = form_basket.process_cat.options[form_basket.process_cat.selectedIndex].value;
            sistem_para_birimi = "<cfoutput>#SESSION.EP.MONEY#</cfoutput>";	
            if(deger != ""){
                var fis_no = eval("form_basket.ct_process_type_" + deger);
                //kdvden muaf satis faturasi : 533
                if(list_find('531,533',fis_no.value))
                    $( document ).ready(function() {
                        reset_basket_kdv_rates();
                    });
            }
            return true;
        }
        function kontrol_yurtdisi()
        {
            deger = form_basket.process_cat.options[form_basket.process_cat.selectedIndex].value;
            if(deger != ""){
                var fis_no = eval("form_basket.ct_process_type_" + deger);
                if(list_find('531,533',fis_no.value))
                {
                    $( document ).ready(function() {
                        reset_basket_kdv_rates();
                    }); //kdv oranları sıfırlanıyor dsp_basket_js_scripts te tanımlı
                }
            }
        }	
        function add_adress()
        {
            if(!(form_basket.company_id.value=="") || !(form_basket.consumer_id.value=="") || !(form_basket.employee_id.value==""))
            {
                if(form_basket.company_id.value!="")
                {
                    str_adrlink = '&field_long_adres=form_basket.adres&field_adress_id=form_basket.ship_address_id';
                    if(form_basket.city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.city_id';
                    if(form_basket.county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.county_id'<cfif fusebox.circuit eq "store">+'&is_store_module='+1</cfif>;
                    windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(form_basket.comp_name.value)+''+ str_adrlink , 'list');
                    return true;
                }
                else
                {
                    str_adrlink = '&field_long_adres=form_basket.adres&field_adress_id=form_basket.ship_address_id';
                    if(form_basket.city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.city_id';
                    if(form_basket.county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.county_id'<cfif fusebox.circuit eq "store">+'&is_store_module='+1</cfif>;
                    windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(form_basket.partner_name.value)+''+ str_adrlink , 'list');
                    return true;
                }
            }
            else
            {
                alert("<cf_get_lang no='181.Cari Hesap Seçmelisiniz'>");
                return false;
            }
        }
    </script>
</cfif>
<!---kopyalama için sorgu ve scriptler birleştirilecek smh24032016--->
<script type="text/javascript">
	<cfif not IsDefined("attributes.event") or (isdefined("attributes.event") and listfindnocase('add,upd',attributes.event))>
		function add_adress()
		{
			if(!(form_basket.company_id.value=="") || !(form_basket.consumer_id.value=="") || !(form_basket.employee_id.value==""))
			{
				if(form_basket.company_id.value!="")
				{
					str_adrlink = '&field_long_adres=form_basket.adres&field_adress_id=form_basket.ship_address_id';
					if(form_basket.city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.city_id';
					if(form_basket.county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.county_id'<cfif fusebox.circuit eq "store">+'&is_store_module='+1</cfif>;
					<cfif not isdefined("attributes.event") or (isdefined("attributes.event") and attributes.event is 'add')>
						windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(form_basket.comp_name.value)+''+ str_adrlink , 'list');
					<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
						windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&company_id='+encodeURIComponent(form_basket.company_id.value)+'&member_name='+encodeURIComponent(form_basket.comp_name.value)+'&keyword='+encodeURIComponent(form_basket.partner_name.value)+''+ str_adrlink , 'list');
					</cfif>
					return true;
				}
				else
				{
					str_adrlink = '&field_long_adres=form_basket.adres&field_adress_id=form_basket.ship_address_id';
					if(form_basket.city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.city_id';
					if(form_basket.county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.county_id'<cfif fusebox.circuit eq "store">+'&is_store_module='+1</cfif>;
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(form_basket.partner_name.value)+''+ str_adrlink , 'list');
					return true;
				}
			}
			else
			{
				alert("<cf_get_lang no='181.Cari Hesap Seçmelisiniz'>");
				return false;
			}
		}
		function kontrol_yurtdisi()
		{
			var deger = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
			if(deger.length)
			{
				var fis_no = eval("document.form_basket.ct_process_type_" + deger);
				if(list_find('531,533',fis_no.value))
				{ 
						kasa_sec.style.display = 'none';
						<cfif not isdefined("attributes.event") or (isdefined("attributes.event") and attributes.event is 'add')>						
							cash_.style.display = 'none';
						<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
							not.style.display = 'none';
						</cfif>	
						if(form_basket.cash != undefined)
							form_basket.cash.checked=false;
					$( document ).ready(function() 
					{
						reset_basket_kdv_rates(); //kdv oranları sıfırlanıyor dsp_basket_js_scripts te tanımlı
					});		
				}
				else
				{
						kasa_sec.style.display = '';
				}
			}
		}		
		function kontrol_ithalat()
		{
			sistem_para_birimi = "<cfoutput>#SESSION.EP.MONEY#</cfoutput>";	
			deger = form_basket.process_cat.options[form_basket.process_cat.selectedIndex].value;
			if(deger != "")
			{
				var fis_no = eval("form_basket.ct_process_type_" + deger);
				//kdvden muaf satis faturasi : 533
				if(list_find('531,533',fis_no.value))
					$( document ).ready(function() 
					{
						reset_basket_kdv_rates(); //kdv oranları sıfırlanıyor dsp_basket_js_scripts te tanımlı
					});	
			}
			return true;
		}	
		function check_invoice_type()
		{
			if(form_basket.company_id!=undefined && form_basket.company_id.value.length)
			{
				var get_member_control = wrk_safe_query('obj_get_company_efatura','dsn' , 0, form_basket.company_id.value);
			}
			else if(form_basket.consumer_id!=undefined && form_basket.consumer_id.value.length)
			{
				var get_member_control = wrk_safe_query('obj_get_consumer_efatura','dsn',0,form_basket.consumer_id.value);
			}
			if(get_member_control != undefined && get_member_control.USE_EFATURA == 1 && datediff(date_format(get_member_control.EFATURA_DATE),document.getElementById('invoice_date').value,0) >= 0)
				paper_type = 'E_INVOICE';
			else
				paper_type = 'INVOICE';
			<cfif not isdefined("attributes.event") or (isdefined("attributes.event") and attributes.event is 'add')>	
				paper_control(form_basket.serial_no,paper_type,true,'','','','','','',1,form_basket.serial_number);
			<cfelseif IsDefined("attributes.event") and attributes.event is 'upd'>
				<cfoutput>
					paper_control(form_basket.serial_no,paper_type,true,'#attributes.iid#','#get_sale_det.serial_no#','','','','','',form_basket.serial_number);
				</cfoutput>
			</cfif>
		}
		function add_order()
		{	
			deger = form_basket.process_cat.options[form_basket.process_cat.selectedIndex].value;
			if(deger == '')
			{
				alert("<cf_get_lang_main no='1358.İşlem Tipi Seçmelisiniz'> !");
				return false;
			}
			if((form_basket.company_id.value.length!="" && form_basket.company_id.value!="") || (form_basket.consumer_id.value.length!="" && form_basket.consumer_id.value!="") || (form_basket.employee_id.value.length!="" && form_basket.employee_id.value!=""))
			{	
				if(eval("form_basket.ct_process_type_" + deger).value == 62)
				{
					is_purchase = 1;
					is_return = 1;
				}
				else
				{
					is_purchase = 0;
					is_return = 0;
				}
				str_irslink = '&is_from_invoice=1&order_id_liste=' + form_basket.order_id_listesi.value + '&is_purchase='+is_purchase+'&is_return='+is_return+'&company_id='+form_basket.company_id.value + '&consumer_id='+form_basket.consumer_id.value<cfif fusebox.circuit eq "store">+'&is_sale_store='+1</cfif>; 
				<cfif session.ep.our_company_info.project_followup eq 1>
					if(form_basket.project_id.value!='' && form_basket.project_head.value!='')
						str_irslink = str_irslink+'&project_id='+form_basket.project_id.value;
				</cfif>
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_orders_for_ship' + str_irslink , 'list_horizantal');
				return true;
			}
			else (form_basket.company_id.value =="")
			{
				alert("<cf_get_lang no='181.Cari Hesap Seçmelisiniz'> !");
				return false;
			}
		}
		<cfif not isdefined("attributes.event") or (isdefined("attributes.event") and attributes.event is 'add')>
			$( document ).ready(function() {
				<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
					<!--- Eğer üye seçili geliyorsa otomatik olarak carinin işlem dövizi gelecek --->
					get_money_info('form_basket','invoice_date');
				</cfif>
			});			
			function ayarla_gizle_goster()
			{
				if(form_basket.cash != undefined &&  form_basket.cash.checked)
					cash_.style.display='';
				else
					cash_.style.display='none';
			}	
			function check_process_is_sale(){/*alım iadeleri satis karakterli oldugu halde alış fiyatları ile çalışması için*/
				<cfif attributes.basket_id is 2>
					var selected_ptype = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
					sale_product = 1;
					if(selected_ptype.length)
					{
						var proc_control = eval('document.form_basket.ct_process_type_'+selected_ptype+'.value');
						if(proc_control==62)
						{
							sale_product= 0;
						}
					}
					<cfelse>
						return true;
				</cfif>
			}	
			function add_irsaliye()
			{
				if(form_basket.company_id.value.length || form_basket.consumer_id.value.length)
				{ 
					str_irslink = '&ship_id_liste=' + form_basket.irsaliye_id_listesi.value + '&id=sale&sale_product=1&company_id='+form_basket.company_id.value+'&consumer_id='+ form_basket.consumer_id.value + '&invoice_date=' + form_basket.invoice_date.value<cfif fusebox.circuit eq "store">+'&is_store='+1</cfif>;
			
			
					 <cfif session.ep.our_company_info.project_followup eq 1>
						if(form_basket.project_id.value!='' && form_basket.project_head.value!='')
							str_irslink = str_irslink+'&project_id='+form_basket.project_id.value;
					 </cfif>
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_choice_ship&ship_project_liste=1' + str_irslink,'wide');
					return true;
				}
				else
				{
					alert("<cf_get_lang no='181.Cari Hesap Seçmelisiniz '> !");
					return false;
				}
			}
		<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
			function add_irsaliye()
			{
				var irs_list='';
				if (window.basket.items.length != undefined) 
					for (i=0; i < window.basket.items.length; i++) {
						if(!list_find(irs_list,window.basket.items[i].ROW_SHIP_ID,','))
							{
							if(i!=0)
								irs_list = irs_list + ',' ;
							irs_list = irs_list + window.basket.items[i].ROW_SHIP_ID;
							}
					}
				else
					irs_list = irs_list + window.basket.items[i].ROW_SHIP_ID;
			
				str_irslink = '&ship_id_liste=' + irs_list + '&id=sale_upd&sale_product=1&company_id='+form_basket.company_id.value+'&consumer_id='+ form_basket.consumer_id.value<cfif fusebox.circuit eq "store">+'&is_store='+1</cfif>;
				 <cfif session.ep.our_company_info.project_followup eq 1>
						if(form_basket.project_id.value!='' && form_basket.project_head.value!='')
							str_irslink = str_irslink+'&project_id='+form_basket.project_id.value;
					 </cfif>
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_choice_ship&ship_project_liste=1' + str_irslink , 'page');
				return true;
			}
		</cfif>
		<cfif isdefined("attributes.event") and attributes.event is 'upd'>
			$( document ).ready(function() 
				{
					<cfif isdefined("is_einvoice_warning") and is_einvoice_warning eq 1>
						alert("<cf_get_lang no='114.Detayına Girmek İstediğiniz E-Fatura Gönderilmemiştir Lütfen Kontrol Ediniz!'>");
					<cfelseif isdefined("is_einvoice_warning_arc") and is_einvoice_warning_arc eq 1>
						alert("Detayına Girmek İstediğiniz E-Arşiv Fatura Gönderilmemiştir. Lütfen Kontrol Ediniz!");
					</cfif>
					
					kontrol_yurtdisi();
					check_process_is_sale();
					change_paper_duedate('invoice_date');
				});
			function kontrol2()
				{
					if (!chk_process_cat('form_basket')) return false;
					if (!check_display_files('form_basket')) return false;
					if (!chk_period(form_basket.invoice_date,"İşlem")) return false;
					var listParam = "<cfoutput>#attributes.iid#</cfoutput>" + "*" + form_basket.old_process_type.value ;
					<cfif not get_module_power_user(20)>
						var closed_info = wrk_safe_query("inv_closed_info_2",'dsn2',0,listParam);
						if(closed_info.recordcount)
						{
							alert("Faturayla İlişkili Ödeme Talebi Olduğu İçin Silinemez ! Talep ID :"+closed_info.CLOSED_ID);
							return false;
						}
					</cfif>
					<cfif session.ep.our_company_info.is_efatura>
						var chk_efatura = wrk_safe_query("chk_efatura_count",'dsn2',0,'<cfoutput>#attributes.iid#</cfoutput>');
						if(chk_efatura.recordcount > 0)
						{
							alert("<cf_get_lang no='112.Fatura ile İlişkili e-Fatura Olduğu için Silinemez !'>");
							return false;
						}
					</cfif>
					form_basket.del_invoice_id.value = <cfoutput>#attributes.iid#</cfoutput>;
					return control_account_process(<cfoutput>'#attributes.iid#','#get_sale_det.invoice_cat#'</cfoutput>); 
				}	
			function kontrol()
				{
					if (!date_check(form_basket.invoice_date,form_basket.ship_date,"<cf_get_lang no='117.Fiili Sevk Tarihi, Fatura Tarihinden Önce Olamaz!'>"))
						return false;
					<cfif session.ep.our_company_info.is_efatura>
						var chk_efatura = wrk_safe_query("chk_efatura_count",'dsn2',0,'<cfoutput>#attributes.iid#</cfoutput>');
						if(chk_efatura.recordcount > 0)
						{
							<cfif xml_upd_einvoice eq 0 and isdefined("chk_send_inv") and chk_send_inv.count>
								if(document.getElementById('fatura_iptal') != undefined && document.getElementById('fatura_iptal').checked == false)
								{
									alert("<cf_get_lang no='96.e-Faturası Oluşturulmuş Faturayı Güncelleyemezsiniz!'>");
									return false;
								}
								else
								{
									if(confirm("<cf_get_lang no='98.e-Faturası Oluşturulmuş Faturayı Güncellemek İstiyor musunuz!'>") == true);
									else
									return false;
								}
							<cfelse>	
								if(confirm("<cf_get_lang no='98.e-Faturası Oluşturulmuş Faturayı Güncellemek İstiyor musunuz!'>") == true);
								else
								return false;
							</cfif>
						}
					</cfif>
					<cfif session.ep.our_company_info.is_earchive>
						var chk_efatura = wrk_safe_query("chk_earchive_count",'dsn2',0,'<cfoutput>#attributes.iid#</cfoutput>');
						if(chk_efatura.recordcount > 0)
						{
							<cfif xml_upd_earchive eq 0>
								{
									alert("e-Arşiv Faturası Oluşturulmuş Faturayı Güncelleyemezsiniz !");
									return false;
								}
							<cfelse>	
								if(confirm("e-Arşiv Faturası Oluşturulmuş Faturayı Güncellemek İstiyor musunuz !") == true);
								else
								return false;
							</cfif>
						}
					</cfif>
					<cfif get_with_ship.is_with_ship neq 1> 
						if(form_basket.order_id_listesi.value!='' && form_basket.irsaliye_id_listesi.value != '')
						{
							alert("<cf_get_lang no='99.İrsaliye ve Sipariş Aynı Anda Seçilemez. Lütfen Seçimlerinizi Kontrol Ediniz!'>");
							return false;
						}
					</cfif>
					//Odeme Plani Guncelleme Kontrolleri
					//Eger bankaya gonderilmis herhangi bir odeme plani satiri varsa odeme planinin yeniden olusturulmasi soz konusu olamaz
					var listParams_ = "<cfoutput>#attributes.iid#</cfoutput>";
					var payment_plan_is_bank = wrk_safe_query("get_inv_payment_plan_bank",'dsn3',0,listParams_);
					var temp_process_cat = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
				
					if (payment_plan_is_bank.recordcount > 0)
					{
						document.form_basket.invoice_payment_plan.value = 0;
					}
					else
					{
						if (document.getElementById('invoice_cari_action_type').value == 5 && document.getElementById('old_pay_method').value != "")
						{
							if (confirm("<cf_get_lang_main no='1663.Güncellediğiniz Belgenin Ödeme Planı Yeniden Oluşturulacaktır'>!"))
								document.form_basket.invoice_payment_plan.value = 1;
							else
							{
								document.form_basket.invoice_payment_plan.value = 0;
								<cfif xml_control_payment_plan_status eq 1>
									return false;
								</cfif>
							}
						}
					}
					if (document.getElementById('fatura_iptal') != undefined && document.getElementById('fatura_iptal').checked == false && document.form_basket.invoice_payment_plan.value == 0)
					{
						var listParam = "<cfoutput>#attributes.iid#</cfoutput>" + "*" + "<cfoutput>#session.ep.period_id#</cfoutput>" ;
						var payment_plan_info = wrk_safe_query("inv_payment_plan",'dsn3',0,listParam);
						if(payment_plan_info.recordcount)
						{
							if((document.form_basket.old_pay_method.value != document.form_basket.paymethod_id.value) || document.form_basket.old_net_total.value != wrk_round(document.all.basket_net_total.value,window.basket.hidden_values.basket_total_round_number_) || (payment_plan_info.COMPANY_ID != '' && payment_plan_info.COMPANY_ID != document.form_basket.company_id.value) || (eval("document.form_basket.ct_process_type_" + temp_process_cat) != undefined && form_basket.old_process_type.value != eval("document.form_basket.ct_process_type_" + temp_process_cat).value))
							{
								alert("<cf_get_lang no='101.Ödeme Planı Girilen Belgenin Tutarı,Carisi,Ödeme Yöntemi veya İşlem Tipi Değiştirilemez !'>");
								return false;
							}
						}
					}
					else if(document.getElementById('fatura_iptal') != undefined && document.getElementById('fatura_iptal').checked == true)
					{
						if(payment_plan_is_bank.recordcount > 0)
							alert("<cf_get_lang no='103.Bankaya Gönderilen Ödeme Planı Satırları İptal Edilecektir !'>");
					}
					if(form_basket.company_id!=undefined && form_basket.company_id.value.length)
					{
						var get_member_control = wrk_safe_query('obj_get_company_efatura','dsn' , 0, form_basket.company_id.value);
					}
					else if(form_basket.consumer_id!=undefined && form_basket.consumer_id.value.length)
					{
						var get_member_control = wrk_safe_query('obj_get_consumer_efatura','dsn',0,form_basket.consumer_id.value);
					}
					if(get_member_control != undefined && get_member_control.USE_EFATURA == 1 && datediff(date_format(get_member_control.EFATURA_DATE),document.getElementById('invoice_date').value,0) >= 0)
						paper_type = 'E_INVOICE';
					else
						paper_type = 'INVOICE';
					if(!paper_control(document.form_basket.serial_no,paper_type,true,<cfoutput>'#attributes.iid#','#get_sale_det.serial_no#'</cfoutput>,'','','','','',form_basket.serial_number)) return false;
				
					//sm tutar kısmını kapattı her durumda kontrol edilmeli 20130411
					//Butce Dagilim Kontrolu
					if(document.form_basket.is_cost.value == 1)
						if(confirm("<cf_get_lang no ='269.Güncellediğiniz Faturanın Masraf- Gelir Dağıtımı Yapılmış Devam Ederseniz Bu Dağıtım Silinecektir'>!"))
							document.form_basket.is_cost.value = 0;
						else
						{
							//document.form_basket.is_cost.value = 1;
							return false;
						}
				
			
					if (!chk_process_cat('form_basket')) return false;
					<cfif isdefined('xml_acc_department_info') and xml_acc_department_info eq 2>//xmlde muhasebe icin departman secimi zorunlu ise
						if( document.form_basket.acc_department_id.options[document.form_basket.acc_department_id.selectedIndex].value=='')
						{
							alert("<cf_get_lang_main no='1424.Lutfen Departman Seciniz'>");
							return false;
						} 
					</cfif>
					if (!check_display_files('form_basket')) return false;
					if (!chk_period(form_basket.invoice_date,"İşlem")) return false;
					if (!check_accounts('form_basket')) return false;
					<cfif session.ep.our_company_info.project_followup eq 1 and isdefined("xml_upd_row_project") and xml_upd_row_project eq 1>
						apply_deliver_date('','project_head','');
					</cfif>
					if(form_basket.department_id.value=="")
						{
						alert("<cf_get_lang no='206.Departman Seçiniz'>!");
						return false;
						}
					if(form_basket.location_id.value=="")
						{
							alert("<cf_get_lang_main no='2234.Lokasyon'><cf_get_lang_main no='322.Seçiniz'>!");
							return false;
						}
					if(!check_product_accounts()) return false;
					
					if(document.getElementById('fatura_iptal') != undefined && document.form_basket.fatura_iptal.checked==false && temp_process_cat.length )
					{
						if(check_stock_action('form_basket')) //islem kategorisi stok hareketi yapıyorsa
						{
							var fis_no = eval("document.form_basket.ct_process_type_" + temp_process_cat);
							var basket_zero_stock_status = wrk_safe_query('inv_basket_zero_stock_status','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
							if(basket_zero_stock_status.IS_SELECTED != 1)
							{
								if(!zero_stock_control(form_basket.department_id.value,form_basket.location_id.value,form_basket.irsaliye_id_listesi.value,fis_no.value)) return false;
							}
						}
					}
					if (!kontrol_ithalat()) return false;
					change_paper_duedate('invoice_date');	
					<cfif not get_module_power_user(20)>
						var listParam = "<cfoutput>#attributes.iid#</cfoutput>" + "*" + form_basket.old_process_type.value ;
						var closed_info = wrk_safe_query("inv_closed_info",'dsn2',0,listParam);
						if(closed_info.recordcount)
							//process_info.IS_PAYMETHOD_BASED_CARI == 1 &&  kaldirildi fbs20110420 bu secili olmasa da islem yapilmamasi gerekiyor
							if((document.form_basket.old_pay_method.value != document.form_basket.paymethod_id.value) || document.form_basket.old_net_total.value != wrk_round(document.all.basket_net_total.value,window.basket.hidden_values.basket_total_round_number_) || (closed_info.COMPANY_ID != '' && closed_info.COMPANY_ID != form_basket.company_id.value) || (closed_info.CONSUMER_ID != '' && closed_info.CONSUMER_ID != form_basket.consumer_id.value) || (form_basket.old_process_type.value != eval("document.form_basket.ct_process_type_" + temp_process_cat).value))
							{
								alert("<cf_get_lang no='104.Belge Kapama,Talep veya Emir Girilen Belgenin Tutarı,Carisi,Ödeme Yöntemi veya İşlem Tipi Değiştirilemez !'>");
								return false;
							}
					</cfif>
					<cfif isdefined("xml_control_ship_amount") and xml_control_ship_amount eq 1>
					<cfoutput>
						var ship_product_list = '';
						var wrk_row_id_list_new = '';
						var amount_list_new = '';
						if(form_basket.product_id.length != undefined && form_basket.product_id.length >1)
						{


							var bsk_rowCount = form_basket.product_id.length;
							for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++)
							{
								if(document.form_basket.product_id[str_i_row].value != '' && document.form_basket.wrk_row_relation_id[str_i_row].value != '' && document.form_basket.row_ship_id[str_i_row].value != '')
								{
									if(list_find(wrk_row_id_list_new,document.form_basket.wrk_row_relation_id[str_i_row].value))
									{
										row_info = list_find(wrk_row_id_list_new,document.form_basket.wrk_row_relation_id[str_i_row].value);
										amount_info = list_getat(amount_list_new,row_info);
										amount_info = parseFloat(amount_info) + parseFloat(filterNum(document.form_basket.amount[str_i_row].value,<cfoutput>#GET_BASKET.AMOUNT_ROUND#</cfoutput>));
										amount_list_new = list_setat(amount_list_new,row_info,amount_info);
									}
									else
									{
										wrk_row_id_list_new = wrk_row_id_list_new + ',' + document.form_basket.wrk_row_relation_id[str_i_row].value;
										amount_list_new = amount_list_new + ',' + filterNum(document.form_basket.amount[str_i_row].value,<cfoutput>#GET_BASKET.AMOUNT_ROUND#</cfoutput>);
									}
								}
							}
							for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++)
							{
								if(document.form_basket.product_id[str_i_row].value != '' && document.form_basket.wrk_row_relation_id[str_i_row].value != '' && document.form_basket.row_ship_id[str_i_row].value != '')
								{
									var listParam = document.form_basket.invoice_id.value + "*" + document.form_basket.wrk_row_relation_id[str_i_row].value ;
									var get_inv_control = wrk_safe_query("inv_get_inv_control_2","dsn2",0,listParam);	
									if(list_len(document.form_basket.row_ship_id[str_i_row].value,';') > 1)
									{
										new_period = list_getat(document.form_basket.row_ship_id[str_i_row].value,2,';');
										var get_period = wrk_safe_query("inv_get_period","dsn",0,new_period);
										new_dsn2 = "#dsn#"+"_"+get_period.PERIOD_YEAR+"_"+get_period.OUR_COMPANY_ID;	
									}
									else
										new_dsn2 = "#dsn2#";
									var get_ship_control = wrk_safe_query("inv_get_ship_control",new_dsn2,0,document.form_basket.wrk_row_relation_id[str_i_row].value);
									var get_ship_control2 = wrk_safe_query("inv_get_ship_control2",new_dsn2,0,document.form_basket.wrk_row_relation_id[str_i_row].value );
									ship_amount_ = parseFloat(get_ship_control.AMOUNT)-parseFloat(get_ship_control2.AMOUNT); 
									row_info = list_find(wrk_row_id_list_new,document.form_basket.wrk_row_relation_id[str_i_row].value);
									amount_info = list_getat(amount_list_new,row_info);
									var total_inv_amount = parseFloat(get_inv_control.AMOUNT)+parseFloat(amount_info);
									if(get_ship_control != undefined && get_ship_control.recordcount > 0 && ship_amount_ >0 && get_inv_control != undefined && get_inv_control.recordcount > 0 && total_inv_amount >0)
									{
										if(total_inv_amount > ship_amount_)
											ship_product_list = ship_product_list + eval(str_i_row+1) + '.Satır : ' + document.all.product_name[str_i_row].value + '\n';
									}
								}
							}
						}	
						else if(document.form_basket.product_id[0] != undefined && document.form_basket.product_id[0].value!='')
						{
							if(document.form_basket.product_id[0].value != '' && document.form_basket.wrk_row_relation_id[0].value != '' && document.form_basket.row_ship_id[0].value != '')
							{
								var listParam = document.form_basket.invoice_id.value + "*" + document.form_basket.wrk_row_relation_id[0].value ;
								var get_inv_control = wrk_safe_query("inv_get_inv_control_2","dsn2",0,listParam);	
								if(list_len(document.form_basket.row_ship_id[0].value,';') > 1)
								{
									new_period = list_getat(document.form_basket.row_ship_id[0].value,2,';');
									var get_period = wrk_safe_query("inv_get_period","dsn",0,new_period);
									new_dsn2 = "#dsn#"+"_"+get_period.PERIOD_YEAR+"_"+get_period.OUR_COMPANY_ID;	
								}
								else
									new_dsn2 = "#dsn2#";
								var get_ship_control = wrk_safe_query("inv_get_ship_control",new_dsn2,0,document.form_basket.wrk_row_relation_id[0].value);
								var get_ship_control2 = wrk_safe_query("inv_get_ship_control2",new_dsn2,0,document.form_basket.wrk_row_relation_id[0].value);
								ship_amount_ = parseFloat(get_ship_control.AMOUNT)-parseFloat(get_ship_control2.AMOUNT); 
								var total_inv_amount = parseFloat(get_inv_control.AMOUNT)+parseFloat(filterNum(document.form_basket.amount[0].value,<cfoutput>#GET_BASKET.AMOUNT_ROUND#</cfoutput>));
								if(get_ship_control != undefined && get_ship_control.recordcount > 0 && ship_amount_ >0 && get_inv_control != undefined && get_inv_control.recordcount > 0 && total_inv_amount >0)
								{
									if(total_inv_amount > ship_amount_)
										ship_product_list = ship_product_list + 1 + '.Satır : ' + document.all.product_name[0].value + '\n';
								}
							}
						}
						else if(document.all.product_id != undefined && document.all.product_id.value != '')
						{
							if(document.form_basket.product_id.value != '' && document.form_basket.wrk_row_relation_id.value != '' && document.form_basket.row_ship_id.value != '')
							{
								var listParam = document.form_basket.invoice_id.value + "*" + document.form_basket.wrk_row_relation_id.value ; 
								var get_inv_control = wrk_safe_query("inv_get_inv_control_2","dsn2",0,listParam);	
								if(list_len(document.form_basket.row_ship_id.value,';') > 1)
								{
									new_period = list_getat(document.form_basket.row_ship_id.value,2,';');
									var get_period = wrk_safe_query("inv_get_period","dsn",0,new_period );
									new_dsn2 = "#dsn#"+"_"+get_period.PERIOD_YEAR+"_"+get_period.OUR_COMPANY_ID;	
								}
								else
									new_dsn2 = "#dsn2#";
								var get_ship_control = wrk_safe_query("inv_get_ship_control",new_dsn2,0,document.form_basket.wrk_row_relation_id.value);	
								var get_ship_control2 = wrk_safe_query("inv_get_ship_control2",new_dsn2,0,document.form_basket.wrk_row_relation_id.value);
								ship_amount_ = parseFloat(get_ship_control.AMOUNT)-parseFloat(get_ship_control2.AMOUNT); 
								var total_inv_amount = parseFloat(get_inv_control.AMOUNT)+parseFloat(filterNum(document.form_basket.amount.value,<cfoutput>#GET_BASKET.AMOUNT_ROUND#</cfoutput>));
								if(get_ship_control != undefined && get_ship_control.recordcount > 0 && ship_amount_ >0 && get_inv_control != undefined && get_inv_control.recordcount > 0 && total_inv_amount >0)
								{
									if(total_inv_amount > ship_amount_)
										ship_product_list = ship_product_list + 1 + '.Satır : ' + document.all.product_name.value + '\n';
								}
							}
						}
						if(ship_product_list != '')
						{
							alert("<cf_get_lang no='106.Aşağıda Belirtilen Ürünler İçin Toplam Fatura Miktarı İrsaliye Miktarından Fazla ! Lütfen Ürünleri Kontrol Ediniz !'>\n\n" + ship_product_list);
							return false;
						}
					</cfoutput>
					</cfif>
					//irsaliye satır kontrolü
					<cfif xml_control_ship_row eq 1>
					<cfoutput>
					ship_list_ = document.getElementById('irsaliye_id_listesi').value; 
					if(ship_list_ != '')
					{
						var ship_row_list = '';
						if(form_basket.product_id.length != undefined && form_basket.product_id.length >1)
						{
							var bsk_rowCount = form_basket.product_id.length; 
							for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++)
							{
								if(document.form_basket.product_id[str_i_row].value != '' && document.form_basket.wrk_row_relation_id[str_i_row].value == '')
								{
									ship_row_list = ship_row_list + eval(str_i_row+1) + '.Satır : ' + document.all.product_name[str_i_row].value + '\n';
								}
							}
							
						}	
						else if(document.form_basket.product_id[0] != undefined && document.form_basket.product_id[0].value!='')
						{
							if(document.form_basket.product_id[0].value != '' && document.form_basket.wrk_row_relation_id[0].value == '')
							{
								ship_row_list = ship_row_list + eval(str_i_row+1) + '.Satır : ' + document.all.product_name[0].value + '\n';
							}
						}
						else if(document.all.product_id != undefined && document.all.product_id.value != '')
						{
							if(document.form_basket.product_id.value != '' && document.form_basket.wrk_row_relation_id.value == '' )
							{
								ship_row_list = ship_row_list + eval(str_i_row+1) + '.Satır : ' + document.all.product_name.value + '\n';
							}
						}
						if(ship_row_list != '')
						{
							alert("Aşağıda Belirtilen Ürünler İlişkili İrsaliye Dışında Eklenmiştir.  ! Lütfen Ürünleri Kontrol Ediniz ! \n\n" + ship_row_list);
							return false;
						}
					}
					</cfoutput>
					</cfif>
					<cfif xml_control_ship_date eq 1>
						var irsaliye_deger_list = document.form_basket.irsaliye_date_listesi.value;
						if(irsaliye_deger_list != '')
							{
								var liste_uzunlugu = list_len(irsaliye_deger_list);
								for(var str_i_row=1; str_i_row <= liste_uzunlugu; str_i_row++)
									{
										var tarih_ = list_getat(irsaliye_deger_list,str_i_row,',');
										var sonuc_ = datediff(document.form_basket.invoice_date.value,tarih_,0);
										if(sonuc_ > 0)
											{
												alert("<cf_get_lang no='108.Fatura Tarihi İrsaliye Tarihinden Önce Olamaz!'>");
												return false;
											}
									}
							}
					</cfif>
					// xml de proje kontrolleri yapılsın seçilmişse
					<cfif xml_control_ship_project eq 1>
						var irsaliye_deger_list = document.form_basket.irsaliye_project_id_listesi.value;
						if(irsaliye_deger_list != '')
							{
								var liste_uzunlugu = list_len(irsaliye_deger_list);
								for(var str_i_row=1; str_i_row <= liste_uzunlugu; str_i_row++)
									{
										var project_id_ = list_getat(irsaliye_deger_list,str_i_row,',');
										if(document.form_basket.project_id.value != '' && document.form_basket.project_head.value != '')
											var sonuc_ = document.form_basket.project_id.value;
										else
											var sonuc_ = 0;
										if(project_id_ != sonuc_)
											{
												alert("<cf_get_lang no='111.İlgili Faturaya Bağlı İrsaliyelerin Projeleri İle Faturada Seçilen Proje Aynı Olmalıdır!'>");
												return false;
											}
									}
							}
					</cfif>
					return (control_account_process(<cfoutput>'#attributes.iid#','#get_sale_det.invoice_cat#'</cfoutput>) && saveForm()); 
				}		
				function openVoucher()
				{
					windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_payment_with_voucher&is_purchase_=0&payment_process_id=#attributes.iid#&inv_order_id=#get_order.ORDER_ID#&str_table=INVOICE&rate_round_num='+window.basket.hidden_values.basket_rate_round_number_+'&round_number='+window.basket.hidden_values.basket_total_round_number_.value+'&branch_id='+document.form_basket.branch_id.value</cfoutput>,'page','upd_bill');		
				}			
		</cfif>		
	</cfif>
	
</script>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	
	WOStruct['#attributes.fuseaction#']['systemObject'] = structNew();
	WOStruct['#attributes.fuseaction#']['systemObject']['processCat'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['processCatSelected'] = '#process_cat#';
	WOStruct['#attributes.fuseaction#']['systemObject']['processCatCallFunction'] = 'kontrol_yurtdisi();check_process_is_sale()';
	
	if(not isdefined("attributes.event"))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'invoice.form_add_bill';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'invoice/display/add_bill.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'invoice/query/add_invoice_sale.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'invoice.form_add_bill&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "basketDisplay()";
	WOStruct['#attributes.fuseaction#']['add']['formName'] = 'form_basket';
	
	WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'kontrolBill()';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'invoice.detail_invoice_sale';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'invoice/display/upd_bill.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'invoice/query/upd_invoice.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'invoice.form_add_bill&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'iid=##attributes.iid##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.iid##';
	WOStruct['#attributes.fuseaction#']['upd']['js'] = "basketDisplay()";
	WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'form_basket';
	WOStruct['#attributes.fuseaction#']['upd']['recordQuery'] = 'get_sale_det';
	
	WOStruct['#attributes.fuseaction#']['upd']['buttons'] = structNew();
	if(isdefined("workcubeButtonInfo"))
	{
		WOStruct['#attributes.fuseaction#']['upd']['buttons']['info'] = '#workcubeButtonInfo#';
	}
	else if(isdefined("workcubeButtonIsUpd"))
	{
		WOStruct['#attributes.fuseaction#']['upd']['buttons']['update'] = '#workcubeButtonIsUpd#';
		WOStruct['#attributes.fuseaction#']['upd']['buttons']['updateFunction'] = 'kontrol()';
		WOStruct['#attributes.fuseaction#']['upd']['buttons']['delete'] = '#workcubeButtonIsDelete#';
		WOStruct['#attributes.fuseaction#']['upd']['buttons']['deleteFunction'] = 'kontrol2()';
	}
	if(isdefined("workcubeButtonExtraInfo"))
	{
		WOStruct['#attributes.fuseaction#']['upd']['buttons']['extraInfo'] = '#workcubeButtonExtraInfo#';
	}
	
	WOStruct['#attributes.fuseaction#']['copy'] = structNew();
	WOStruct['#attributes.fuseaction#']['copy']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['copy']['fuseaction'] = 'invoice.form_copy_bill';
	WOStruct['#attributes.fuseaction#']['copy']['filePath'] = 'invoice/form/copy_bill.cfm';
	WOStruct['#attributes.fuseaction#']['copy']['queryPath'] = 'invoice/query/add_invoice_sale.cfm';
	WOStruct['#attributes.fuseaction#']['copy']['nextEvent'] = 'invoice.form_add_bill&event=upd';
	WOStruct['#attributes.fuseaction#']['copy']['parameters'] = 'iid=##attributes.iid##';
	WOStruct['#attributes.fuseaction#']['copy']['Identity'] = '##attributes.iid##';
	WOStruct['#attributes.fuseaction#']['copy']['js'] = "javascript:gizle_goster_basket(copy_bill);";
	
	if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'invoice.emptypopup_upd_bill&invoice_id=#attributes.iid#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'invoice/query/upd_invoice.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'invoice/query/upd_invoice.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = '#fusebox.circuit#.list_bill';
		WOStruct['#attributes.fuseaction#']['del']['extraParams'] = 'active_period&old_process_type&del_invoice_id&invoice_number&employee_id&company_id&consumer_id&process_cat';
	}
	if(isdefined("attributes.event") and attributes.event is 'add')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['search']['text'] = '#lang_array_main.item[153]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['search']['onclick'] = "openSearchForm()";
	}
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		
		WOStruct['#attributes.fuseaction#']['print'] = structNew();
		WOStruct['#attributes.fuseaction#']['print']['cfcName'] = 'invoiceBillPrint';
		WOStruct['#attributes.fuseaction#']['print']['identity'] = 'iid';
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[345]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=#listgetat(attributes.fuseaction,1,'.')#.detail_invoice_sale&action_name=iid&action_id=#attributes.iid#&relation_papers_type=INVOICE_ID','list')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array.item[258]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onclick'] = "windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_invoice_orders&invoice_id=#url.iid#&is_sale=1','list')";
			
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = '#lang_array_main.item[1339]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['onclick'] = "windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_get_contract_comparison&iid=#url.iid#&type=1','wwide1')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['text'] = '#lang_array.item[259]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_upd_income_center_invoice&id=#url.iid#&sale_emp=#get_sale_det.sale_emp#','horizantal')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['text'] = '#lang_array_main.item[2577]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_account_cards&invoice_id=#attributes.iid#','page','upd_bill')";
			
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['text'] = '#lang_array.item[323]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_pursuits_documents_plus&action_id=#attributes.iid#&pursuit_type=is_sale_invoice','page')";
		
		i = 6;	
		if(session.ep.our_company_info.is_earchive eq 1)
		{				
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array_main.item[1338]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=invoice.popup_cancel_invoice&invoice_id=#attributes.iid#','small','popup_cancel_invoice')";
			i = i + 1;
		}
		
	
		if(session.ep.our_company_info.guaranty_followup)
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array_main.item[2594]#';
				if(fusebox.circuit is 'store')
						tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=store.list_serial_operations&is_filtre=1&invoice_number=#get_sale_det.invoice_number#";
				else
						tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=stock.list_serial_operations&is_filtre=1&invoice_number=#get_sale_det.invoice_number#";				
				i = i + 1;
			}
			
			if(len(get_sale_det.consumer_id))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array_main.item[397]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = '#request.self#?fuseaction=ch.list_extre&member_type=consumer&member_id=#get_sale_det.consumer_id#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['target'] = "_blank";
				i = i + 1;
			}
			else if(len(get_sale_det.company_id))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array_main.item[397]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = '#request.self#?fuseaction=ch.list_extre&member_type=partner&member_id=#get_sale_det.company_id#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['target'] = "_blank";
				i = i + 1;
			}
						
			if(listfind('48,49,50,51,58,63',get_sale_det.invoice_cat,','))
				{
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[322]#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_form_add_product_cost_invoice&invoice_id=#url.iid#','horizantal')";
					i = i + 1;
				}
			if(len(get_sale_det.pay_method))
				{
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[324]#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onclick'] = "openVoucher();";
				}
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[261]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_bill";		
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[262]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_bill&event=copy&iid=#attributes.iid#";		
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onclick'] = "myPopup('printPage');";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['search']['text'] = '#lang_array_main.item[153]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['search']['onclick'] = "openSearchForm()";
						
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
		if(isdefined("attributes.event") and attributes.event is 'upd')
		{			
			if((GET_SALE_DET.INVOICE_TYPE_CODE eq 'SATIS' or GET_SALE_DET.INVOICE_TYPE_CODE eq 'IADE') and (len(get_sale_det.company_id) and get_sale_det_comp.use_efatura eq 1 and datediff('d',get_sale_det_comp.efatura_date,get_sale_det.invoice_date) gte 0) or (len(get_sale_det.consumer_id) and get_cons_name.use_efatura eq 1 and datediff('d',get_cons_name.efatura_date,get_sale_det.invoice_date) gte 0))
				{	
					transformations['#attributes.fuseaction#']['upd']['icons']['customTag'] = structNew();
					transformations['#attributes.fuseaction#']['upd']['icons']['customTag'] = '<cf_wrk_efatura_display action_id="#attributes.iid#" action_type="INVOICE" action_date="#get_sale_det.invoice_date#">';
				}
			else if ((GET_SALE_DET.INVOICE_TYPE_CODE eq 'SATIS' or GET_SALE_DET.INVOICE_TYPE_CODE eq 'IADE') and session.ep.our_company_info.is_earchive eq 1 and datediff('d',session.ep.our_company_info.earchive_date,get_sale_det.invoice_date) gte 0)
				{	
					transformations['#attributes.fuseaction#']['upd']['icons']['customTag'] = structNew();
					transformations['#attributes.fuseaction#']['upd']['icons']['customTag'] = '<cf_wrk_earchive_display action_id="#attributes.iid#" action_type="INVOICE" action_date="#get_sale_det.invoice_date#">';
				}
			WOStruct['#attributes.fuseaction#']['print'] = structNew();
			WOStruct['#attributes.fuseaction#']['print']['cfcName'] = 'invoiceBillPrint';
			WOStruct['#attributes.fuseaction#']['print']['identity'] = 'iid';
		}
		WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
		WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'invoiceBill';
		WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'INVOICE';
		WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
		WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-process_stage','item-comp_name','item-partner_name','item-serial_no','item-invoice_date','item-location_id','item-adres']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.		
</cfscript>