
<!---
    İlker Altındal
    Create : 300621
    Desc : Datagate.cfc üzerinden sipariş işlemleri için adreslenen fonksiyonlar yer alır
--->

<cfcomponent extends="cfc.sdFunctions">
    <cfset dsn = dsn_alias = application.systemParam.systemParam().dsn />
    <cfset dsn1 = dsn_product = dsn1_alias = '#dsn#_product' />
    <cfset dsn2 = dsn2_alias = '#dsn#_#session.ep.period_year#_#session.ep.company_id#' />
	<cfset dsn3 = dsn3_alias = '#dsn#_#session.ep.company_id#' />
    <cfset index_folder = application.systemParam.systemParam().index_folder >
    <cfset dir_seperator = application.systemParam.systemParam().dir_seperator>
    <cfset request.self = application.systemParam.systemParam().request.self />
    <cfset file_web_path = application.systemParam.systemParam().file_web_path />
    <cfset fusebox.process_tree_control = application.systemParam.systemParam().fusebox.process_tree_control>
    <cfset WFunctions = createObject("component","WMO.functions") />
    <cfset FaFunctions = createObject("component","cfc.FaFunctions") />
    <cfif (isdefined("session.ep") and isDefined("session.ep.userid"))>
		<cfset session_base.money = session.ep.money>
		<cfset session_base.money2 = session.ep.money2>
		<cfset session_base.userid = session.ep.userid>
		<cfset session_base.company_id = session.ep.company_id>
		<cfset session_base.period_id = session.ep.period_id>
	</cfif>
    <cfset MMFunctions = createObject("component","cfc.mmFunctions") />
    <cfset wrk_eval = WFunctions.wrk_eval>
    <cfset cfquery = WFunctions.cfquery>
    <cfset get_emp_info = WFunctions.get_emp_info>
    <cfset specer = MMFunctions.specer>
    <cfset wrk_round = WFunctions.wrk_round>
    <cfset butceci = FaFunctions.butceci>
    <cfset butce_sil = FaFunctions.butce_sil>
    <cfset getLang = WFunctions.getLang>
    <cfset sql_unicode = WFunctions.sql_unicode>
    <cfif not isdefined('basket_kur_ekle')>
        <cfinclude template="../../objects/functions/get_basket_money_js.cfm">
    </cfif>
    <cfif not isdefined('add_company_related_action')>
        <cfinclude template="../../objects/functions/add_company_related_action.cfm">
    </cfif>

    <cffunction name="upd_order" access="public" returntype="any" hint="Sipariş Güncelleme İşlemleri">
        <cfset attributes = arguments>
        <cfset form = arguments>
        <cfset responseStruct = structNew()>

        <cfif form.active_company neq session.ep.company_id>
            <cfset responseStruct.message = getLang('main','İşlemin Şirketi İle Aktif Şirketiniz Farklı Çalıştığınız Şirketi Kontrol Ediniz',38700)>
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = {}>
            <cfreturn responseStruct>
            <cfabort>
        </cfif>
        <cfif not isdefined("attributes.rows_") or attributes.rows_ lte 0>
            <cfset responseStruct.message = getLang('main','Ürün Seçmediniz! Lütfen Ürün Seçiniz',45894)>
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = {}>
            <cfreturn responseStruct>
            <cfabort>
        </cfif>
        
        <cfif isdefined("attributes.process_cat") and len(attributes.process_cat)>
            <cfquery name="get_type" datasource="#dsn3#">
                SELECT PROCESS_TYPE,PROCESS_CAT_ID,ACTION_FILE_NAME,ACTION_FILE_FROM_TEMPLATE,IS_BUDGET_RESERVED_CONTROL FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat#">
            </cfquery>
            <cfquery name="GET_PAPER" datasource="#DSN3#">
                SELECT ORDER_NUMBER FROM ORDERS WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.order_id#">
            </cfquery>
            <cfscript>
                attributes.currency_multiplier = '';
                paper_currency_multiplier ='';
                if(isDefined('attributes.kur_say') and len(attributes.kur_say))
                    for(mon=1;mon lte attributes.kur_say;mon=mon+1)
                    {
                        if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
                            attributes.currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
                        if(evaluate("attributes.hidden_rd_money_#mon#") is form.basket_money)
                            paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
                    }
                    butce_sil(action_id:FORM.order_id,process_type:get_type.PROCESS_TYPE,reserv_type:1);
            </cfscript>
        </cfif>
        
        <!--- History --->
        <cfset attributes.order_id = FORM.ORDER_ID>
        <cfset order_history = this.add_order_history(order_id : attributes.order_id )>
        <!--- History --->

        <cf_xml_page_edit fuseact="purchase.detail_order">
        <cf_date tarih = "attributes.basket_due_value_date_">
        <cf_date tarih = "attributes.order_date">
        <!--- irsaliye tarihine gore ortalama vade tarihi --->
        <cfset order_due_date = attributes.basket_due_value_date_> 
        <cfif isdefined("attributes.deliverdate") and isdate(attributes.deliverdate)><cf_date tarih = "attributes.deliverdate"></cfif>
        <cfif isdefined("attributes.publishdate") and isdate(attributes.publishdate)><cf_date tarih = "attributes.publishdate"></cfif>
        <cflock name="#CreateUUID()#" timeout="40">
          <cftransaction>
            <cftry>
                <cfscript>
                    add_relation_rows(
                        action_type:'del',
                        action_dsn : '#dsn3#',
                        to_table:'ORDERS',
                        to_action_id : attributes.order_id
                        );
                </cfscript>
                <!--- Sözleşme eski ID için kullanıldı mcifci --->
                <cfquery name="get_old_contract" datasource="#dsn3#">
                    SELECT CONTRACT_ID FROM ORDERS WHERE ORDER_ID = #attributes.order_id#
                </cfquery>
            
                <cfquery name="UPD_OFFER" datasource="#DSN3#">
                    UPDATE 
                        ORDERS 
                    SET
                        ORDER_STATUS = <cfif isDefined("ORDER_STATUS")>1<cfelse>0</cfif>,
                        ORDER_DATE = #attributes.order_date#,
                        ORDER_STAGE = <cfif isdefined("attributes.process_stage")>#attributes.process_stage#,<cfelse>NULL,</cfif>
                        DELIVER_DEPT_ID = <cfif isdefined("attributes.deliver_dept_id") and len(attributes.deliver_dept_id) and len(attributes.deliver_dept_name)>#attributes.deliver_dept_id#<cfelse>NULL</cfif>,
                        LOCATION_ID = <cfif isdefined("attributes.deliver_loc_id") and len(attributes.deliver_loc_id) and len(attributes.deliver_dept_name)>#attributes.deliver_loc_id#<cfelse>NULL</cfif>,
                        SHIP_ADDRESS = <cfif isdefined("attributes.ship_address") and len(attributes.ship_address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ship_address#"><cfelse>NULL</cfif>,
                        SHIP_ADDRESS_ID = <cfif isdefined("attributes.ship_address_id") and len(attributes.ship_address_id)>#attributes.ship_address_id#<cfelse>NULL</cfif>,
                        CITY_ID = <cfif isdefined("attributes.ship_address_city_id") and len(attributes.ship_address_city_id)>#attributes.ship_address_city_id#<cfelse>NULL</cfif>,
                        COUNTY_ID = <cfif isdefined("attributes.ship_address_county_id") and len(attributes.ship_address_county_id)>#attributes.ship_address_county_id#<cfelse>NULL</cfif>,
                        DELIVERDATE = <cfif len(attributes.deliverdate)>#attributes.deliverdate#<cfelse>NULL</cfif>,
                        PUBLISHDATE = <cfif len(attributes.publishdate)>#attributes.publishdate#<cfelse>NULL</cfif>,
                        INCLUDED_KDV = <cfif isdefined("attributes.INCLUDED_KDV")>1<cfelse>0</cfif>,
                        PAYMETHOD = <cfif isdefined("attributes.paymethod_id") and len(attributes.paymethod_id) and len(attributes.pay_method)>#attributes.paymethod_id#<cfelse>NULL</cfif>,
                        INVISIBLE = <cfif isDefined("attributes.INVISIBLE")>1<cfelse>0</cfif>,
                        PARTNER_ID = <cfif len(attributes.PARTNER_ID)>#attributes.PARTNER_ID#<cfelse>NULL</cfif>,
                        COMPANY_ID = <cfif len(attributes.COMPANY_ID)>#attributes.COMPANY_ID#<cfelse>NULL</cfif>,
                        CONSUMER_ID = <cfif len(attributes.CONSUMER_ID)>#attributes.CONSUMER_ID#<cfelse>NULL</cfif>,
                        OTHER_MONEY = <cfif isDefined("attributes.basket_money")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.basket_money#">,<cfelse> NULL,</cfif>
                        OTHER_MONEY_VALUE = #((attributes.basket_net_total*attributes.basket_rate1)/attributes.basket_rate2)#,
                        TAX = <cfif isDefined("attributes.tax")>#listGetAt(attributes.tax,1)#<cfelse>NULL</cfif>,
                        PRIORITY_ID = #attributes.PRIORITY_ID#,
                        ORDER_HEAD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ORDER_HEAD#">,
                        ORDER_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ORDER_DETAIL#">,
                        DUE_DATE = <cfif isdefined("order_due_date") and len(order_due_date)>#order_due_date#<cfelse>NULL</cfif>,
                        RESERVED = <cfif isDefined('attributes.RESERVED')>1<cfelse>0</cfif>,
                        SHIP_METHOD = <cfif isdefined("attributes.ship_method_id") and len(attributes.ship_method_id) and len(trim(attributes.ship_method_name))>#attributes.ship_method_id#<cfelse>NULL</cfif>,
                        NETTOTAL = <cfif isdefined("attributes.basket_net_total") and len(attributes.basket_net_total)>#attributes.basket_net_total#<cfelse>NULL</cfif>,
                        TAXTOTAL = <cfif isdefined("attributes.basket_tax_total") and len(attributes.basket_tax_total)>#attributes.basket_tax_total#<cfelse>NULL</cfif>,
                        DISCOUNTTOTAL = <cfif isdefined("attributes.basket_discount_total") and len(attributes.basket_discount_total)> #attributes.basket_discount_total#<cfelse>NULL</cfif>,
                        GROSSTOTAL = <cfif isdefined("attributes.basket_gross_total") and len(attributes.basket_gross_total)>#attributes.basket_gross_total#<cfelse>NULL</cfif>,
                        PROJECT_ID = <cfif isdefined("attributes.project_id") and len(attributes.project_id) and LEN(attributes.project_head)>#attributes.project_id#<cfelse>NULL</cfif>,
                        CATALOG_ID = <cfif isdefined("attributes.catalog_id") and len(attributes.catalog_id) and len(attributes.catalog_name)>#attributes.catalog_id#<cfelse>NULL</cfif>,
                        ORDER_EMPLOYEE_ID = <cfif isdefined("attributes.order_employee_id") and len(attributes.order_employee_id)>#attributes.order_employee_id#<cfelse>NULL</cfif>,
                        REF_NO  = <cfif isdefined("attributes.ref_no") and len(attributes.ref_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ref_no#"><cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id)>
                            CARD_PAYMETHOD_ID= #attributes.card_paymethod_id#,
                            CARD_PAYMETHOD_RATE = <cfif isdefined("attributes.commission_rate") and len(attributes.commission_rate)>#attributes.commission_rate#,<cfelse>NULL,</cfif>
                        <cfelse>
                            CARD_PAYMETHOD_ID= NULL,
                            CARD_PAYMETHOD_RATE = NULL,
                        </cfif>
                        WORK_ID = <cfif isdefined("attributes.work_id") and len(attributes.work_id)>#attributes.work_id#<cfelse>NULL</cfif>,
                        IS_FOREIGN = <cfif isdefined("attributes.is_foreign")>1<cfelse>0</cfif>,
                        UPDATE_DATE = #NOW()#,
                        UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
                        UPDATE_EMP = #SESSION.EP.USERID#,
                        CONTRACT_ID	= <cfif (isdefined('attributes.contract_no') and len(attributes.contract_no)) and isdefined('attributes.contract_id') and len(attributes.contract_id)>#attributes.contract_id#<cfelse>NULL</cfif>,
                        PROCESS_CAT =<cfif isdefined("attributes.process_cat") and len(attributes.process_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat#"><cfelse>NULL</cfif>,
                        SA_DISCOUNT = <cfif isdefined("attributes.genel_indirim") and len(attributes.genel_indirim)>#attributes.genel_indirim#<cfelse>NULL</cfif>
                    WHERE 
                        ORDER_ID = #FORM.ORDER_ID#
                </cfquery>
            
                <cfif (isdefined('attributes.contract_no') and len(attributes.contract_no)) and isdefined('attributes.contract_id') and len(attributes.contract_id)>
                    <!--- Eski sözleşmeden sipariş bağlantısı çıkartılıyor --->
                    <cfif Len(get_old_contract.CONTRACT_ID) And get_old_contract.CONTRACT_ID Neq attributes.contract_id>
                        <cfquery name="get_contract" datasource="#dsn3#">
                            SELECT ORDER_ID FROM RELATED_CONTRACT WHERE CONTRACT_ID = #get_old_contract.CONTRACT_ID#
                        </cfquery>
                        <cfset old_list = '' />
                        <cfloop from="1" to="#listlen(get_contract.ORDER_ID)#" index="sayac">
                            <cfif len(ListGetAt(get_contract.ORDER_ID,sayac,',')) and not listfind(old_list,ListGetAt(get_contract.ORDER_ID,sayac,','),',')>
                                <cfset old_list = Listappend(old_list,ListGetAt(get_contract.ORDER_ID,sayac,','),',') />
                            </cfif>
                        </cfloop>
                        <cfif listFind(old_list,attributes.order_id)>
                            <cfset old_list = listDeleteAt(old_list,listFind(old_list,attributes.order_id)) />
                            <cfquery datasource="#dsn3#">
                                UPDATE RELATED_CONTRACT SET ORDER_ID = ',#old_list#,' WHERE CONTRACT_ID = #get_old_contract.CONTRACT_ID#
                            </cfquery>
                        </cfif>
                    </cfif>
                    <!---// Eski sözleşmeden sipariş bağlantısı çıkartılıyor --->
                    <!--- Yeni sözleşmeye sipariş bağlantısı ekleniyor --->
                    <cfquery name="get_contracts" datasource="#dsn3#">
                        SELECT ORDER_ID FROM RELATED_CONTRACT WHERE CONTRACT_ID = #attributes.contract_id#
                    </cfquery>
                    <cfset related_list = '' />
                    <cfloop from="1" to="#listlen(get_contracts.ORDER_ID)#" index="sayac">
                        <cfif len(ListGetAt(get_contracts.ORDER_ID,sayac,',')) and not listfind(related_list,ListGetAt(get_contracts.ORDER_ID,sayac,','),',')>
                            <cfset related_list = Listappend(related_list,ListGetAt(get_contracts.ORDER_ID,sayac,','),',') />
                        </cfif>
                    </cfloop>
                    <cfscript>
                        related_list = Listappend(related_list,attributes.order_id);
                        related_list = ListSort(ListDeleteDuplicates(related_list),"numeric","asc",",");
                        new_related_id  = '';
                        if (ListLen(get_contracts.ORDER_ID) Eq 0) {
                            new_related_id = ',';
                        }
                        new_related_id	= '#new_related_id##get_contracts.ORDER_ID##attributes.order_id#,';
                    </cfscript>
                    <cfquery datasource="#dsn3#">
                        UPDATE RELATED_CONTRACT SET ORDER_ID = '#related_list#' WHERE CONTRACT_ID = #attributes.contract_id#
                    </cfquery>
                    <!---// Yeni sözleşmeye sipariş bağlantısı ekleniyor --->
                <cfelseif Len(get_old_contract.CONTRACT_ID)>
                    <cfquery name="get_contract" datasource="#dsn3#">
                        SELECT ORDER_ID FROM RELATED_CONTRACT WHERE CONTRACT_ID = #get_old_contract.CONTRACT_ID#
                    </cfquery>
                    <cfset old_list = '' />
                    <cfloop from="1" to="#listlen(get_contract.ORDER_ID)#" index="sayac">
                        <cfif len(ListGetAt(get_contract.ORDER_ID,sayac,',')) and not listfind(old_list,ListGetAt(get_contract.ORDER_ID,sayac,','),',')>
                            <cfset old_list = Listappend(old_list,ListGetAt(get_contract.ORDER_ID,sayac,','),',') />
                        </cfif>
                    </cfloop>
                    <cfif listFind(old_list,attributes.order_id)>
                        <cfset old_list = listDeleteAt(old_list,listFind(old_list,attributes.order_id)) />
                        <cfquery datasource="#dsn3#">
                            UPDATE RELATED_CONTRACT SET ORDER_ID = ',#old_list#,' WHERE CONTRACT_ID = #get_old_contract.CONTRACT_ID#
                        </cfquery>
                    </cfif>
                </cfif>
                
                <!--- urun asortileri siliniyor --->
                <cfset del_assort = this.DEL_OFFER_ASSORT_ROWS(order_id : attributes.order_id )>

                <!---  uruna sortileri  --->
                <cfset order_row_id_list_ = ''>
                <cfloop from="1" to="#attributes.rows_#" index="i">
                    <cf_date tarih="attributes.deliver_date#i#">
                    <cf_date tarih="attributes.reserve_date#i#">
                    <cfif session.ep.our_company_info.spect_type and isdefined('attributes.is_production#i#') and evaluate('attributes.is_production#i#') eq 1>
                        <cfset specer_spec_id=''>
                        <cfset dsn_type=dsn3>
                        <cfif not isdefined('attributes.spect_id#i#') or not len(evaluate('attributes.spect_id#i#'))>
                            <cfinclude template="../../objects/query/add_basket_spec.cfm">
                        <cfelseif attributes.basket_spect_type eq 7 ><!--- satırdada guncellenebilmeli bu spec tipinde--->
                            <cfset specer_spec_id=evaluate('attributes.spect_id#i#')>
                            <cfinclude template="../../objects/query/add_basket_spec.cfm">
                        </cfif>
                    </cfif>
                    <cfif len(evaluate('attributes.action_row_id#i#')) and evaluate('attributes.action_row_id#i#') neq 0><!--- yeni eklenmis bir satır degilse --->
                        <cfquery name="UPD_ORDER_ROW" datasource="#DSN3#"><!--- eski satır update --->
                            UPDATE
                                ORDER_ROW
                            SET
                                ORDER_ID = #FORM.ORDER_ID#,
                                ROW_INTERNALDEMAND_ID = <cfif isdefined('attributes.internaldemand_id_list') and len(attributes.internaldemand_id_list) and isdefined("attributes.row_ship_id#i#") and len(evaluate('attributes.row_ship_id#i#')) and listfirst(evaluate('attributes.row_ship_id#i#'),';') neq 0>#listfirst(evaluate('attributes.row_ship_id#i#'),';')#<cfelse>NULL</cfif>,
                                RELATED_INTERNALDEMAND_ROW_ID = <cfif isdefined('attributes.internaldemand_id_list') and len(attributes.internaldemand_id_list) and isdefined("attributes.row_ship_id#i#") and listlen(evaluate('attributes.row_ship_id#i#'),";") eq 2 and len(listgetat(evaluate('attributes.row_ship_id#i#'),2,';'))>#listgetat(evaluate('attributes.row_ship_id#i#'),2,';')#<cfelse>NULL</cfif>,
                                ROW_PRO_MATERIAL_ID = <cfif isdefined('attributes.pro_material_id_list') and len(attributes.pro_material_id_list) and isdefined("attributes.row_ship_id#i#") and len(evaluate('attributes.row_ship_id#i#')) and listfirst(evaluate('attributes.row_ship_id#i#'),';') neq 0>#listfirst(evaluate('attributes.row_ship_id#i#'),';')#<cfelse>NULL</cfif>,
                                PRODUCT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.product_name#i#')#">,
                                PRODUCT_ID = #evaluate('attributes.product_id#i#')#,
                                STOCK_ID = #evaluate('attributes.stock_id#i#')#,
                                QUANTITY = #evaluate('attributes.amount#i#')#,
                                UNIT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit#i#')#">,
                                UNIT_ID = #evaluate("attributes.unit_id#i#")#,
                                PRICE = #evaluate("attributes.price#i#")#,
                                TAX = #evaluate("attributes.tax#i#")#,
                                <cfif isdefined("x_apply_deliverdate_to_rows") and x_apply_deliverdate_to_rows eq 1 and not (isdefined("attributes.deliver_date#i#") and len(evaluate('attributes.deliver_date#i#')))>
                                    DELIVER_DATE = <cfif len(attributes.deliverdate)>#attributes.deliverdate#<cfelse>NULL</cfif>,
                                <cfelse>    
                                    DELIVER_DATE = <cfif isdefined("attributes.deliver_date#i#") and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
                                </cfif>                        
                                <cfif isdefined("attributes.deliver_dept#i#") and len(trim(evaluate("attributes.deliver_dept#i#"))) and len(listfirst(evaluate("attributes.deliver_dept#i#"),"-"))>
                                    DELIVER_DEPT=#listfirst(evaluate("attributes.deliver_dept#i#"),"-")#,
                                <cfelseif isdefined('attributes.deliver_dept_id') and len(attributes.deliver_dept_id)>
                                    DELIVER_DEPT=#attributes.deliver_dept_id#,
                                <cfelse>
                                    DELIVER_DEPT=NULL,
                                </cfif>
                                <cfif isdefined("attributes.deliver_dept#i#") and listlen(trim(evaluate("attributes.deliver_dept#i#")),"-") eq 2 and len(listlast(evaluate("attributes.deliver_dept#i#"),"-"))>
                                    DELIVER_LOCATION=#listlast(evaluate("attributes.deliver_dept#i#"),"-")#,
                                <cfelseif isdefined('attributes.deliver_loc_id') and len(attributes.deliver_loc_id)>
                                    DELIVER_LOCATION=#attributes.deliver_loc_id#,
                                <cfelse>
                                    DELIVER_LOCATION=NULL,
                                </cfif>
                                DISCOUNT_1=<cfif isdefined('attributes.indirim1#i#')>#evaluate('attributes.indirim1#i#')#<cfelse>NULL</cfif>,
                                DISCOUNT_2=<cfif isdefined('attributes.indirim2#i#')>#evaluate('attributes.indirim2#i#')#<cfelse>NULL</cfif>,
                                DISCOUNT_3=<cfif isdefined('attributes.indirim3#i#')>#evaluate('attributes.indirim3#i#')#<cfelse>NULL</cfif>,
                                DISCOUNT_4=<cfif isdefined('attributes.indirim4#i#')>#evaluate('attributes.indirim4#i#')#<cfelse>NULL</cfif>,
                                DISCOUNT_5=<cfif isdefined('attributes.indirim5#i#')>#evaluate('attributes.indirim5#i#')#<cfelse>NULL</cfif>,
                                DISCOUNT_6=<cfif isdefined('attributes.indirim6#i#')>#evaluate('attributes.indirim6#i#')#<cfelse>NULL</cfif>,
                                DISCOUNT_7=<cfif isdefined('attributes.indirim7#i#')>#evaluate('attributes.indirim7#i#')#<cfelse>NULL</cfif>,
                                DISCOUNT_8=<cfif isdefined('attributes.indirim8#i#')>#evaluate('attributes.indirim8#i#')#<cfelse>NULL</cfif>,
                                DISCOUNT_9=<cfif isdefined('attributes.indirim9#i#')>#evaluate('attributes.indirim9#i#')#<cfelse>NULL</cfif>,
                                DISCOUNT_10=<cfif isdefined('attributes.indirim10#i#')>#evaluate('attributes.indirim10#i#')#<cfelse>NULL</cfif>,
                                OTHER_MONEY=<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.other_money_#i#')#">,
                                OTHER_MONEY_VALUE=<cfif isdefined('attributes.other_money_value_#i#') and len(evaluate("attributes.other_money_value_#i#"))>#evaluate('attributes.other_money_value_#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
                                    SPECT_VAR_ID=#evaluate('attributes.spect_id#i#')#,
                                    SPECT_VAR_NAME=<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(evaluate('attributes.spect_name#i#'),500)#">,
                                <cfelse>
                                    SPECT_VAR_ID=NULL,
                                    SPECT_VAR_NAME=NULL,
                                </cfif>
                                LOT_NO=<cfif isdefined('attributes.lot_no#i#')><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
                                PRICE_OTHER=<cfif isdefined('attributes.price_other#i#')>#evaluate('attributes.price_other#i#')#<cfelse>NULL</cfif>,
                                IS_PROMOTION=<cfif isdefined('attributes.is_promotion#i#') and len(evaluate('attributes.is_promotion#i#'))>#evaluate('attributes.is_promotion#i#')#<cfelse>0</cfif>,
                                NETTOTAL=<cfif isdefined("attributes.row_nettotal#i#") and len(evaluate("attributes.row_nettotal#i#"))>#evaluate("attributes.row_nettotal#i#")#<cfelse>NULL</cfif>,
                                ORDER_ROW_CURRENCY=<cfif isdefined("attributes.order_currency#i#") and len(evaluate("attributes.order_currency#i#"))>#evaluate("attributes.order_currency#i#")#<cfelse>-1</cfif>,
                                RESERVE_TYPE=<cfif isdefined("attributes.reserve_type#i#") and len(evaluate("attributes.reserve_type#i#")) and isdefined("attributes.order_currency#i#") and len(evaluate("attributes.order_currency#i#")) and evaluate("attributes.order_currency#i#") eq -9>-3<cfelseif isdefined("attributes.reserve_type#i#") and len(evaluate("attributes.reserve_type#i#"))>#evaluate("attributes.reserve_type#i#")#<cfelse>-1</cfif>,
                                RESERVE_DATE=<cfif isdefined("attributes.reserve_date#i#") and isdate(evaluate('attributes.reserve_date#i#'))>#evaluate('attributes.reserve_date#i#')#<cfelse>NULL</cfif>,
                                COST_PRICE=<cfif isdefined('attributes.net_maliyet#i#') and len(evaluate('attributes.net_maliyet#i#'))>#evaluate('attributes.net_maliyet#i#')#<cfelse>0</cfif>,
                                EXTRA_COST=<cfif isdefined('attributes.extra_cost#i#') and len(evaluate('attributes.extra_cost#i#'))>#evaluate('attributes.extra_cost#i#')#<cfelse>0</cfif>,
                                DISCOUNT_COST=<cfif isdefined('attributes.iskonto_tutar#i#') and len(evaluate('attributes.iskonto_tutar#i#'))>#evaluate('attributes.iskonto_tutar#i#')#<cfelse>NULL</cfif>,
                                UNIQUE_RELATION_ID=<cfif isdefined('attributes.row_unique_relation_id#i#') and len(evaluate('attributes.row_unique_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.row_unique_relation_id#i#')#"><cfelse>NULL</cfif>,
                                PROM_RELATION_ID=<cfif isdefined('attributes.prom_relation_id#i#') and len(evaluate('attributes.prom_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.prom_relation_id#i#')#"><cfelse>NULL</cfif>,
                                PRODUCT_NAME2=<cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.product_name_other#i#')#"><cfelse>NULL</cfif>,
                                AMOUNT2=<cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
                                UNIT2=<cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit_other#i#')#"><cfelse>NULL</cfif>,
                                MARJ=<cfif isdefined('attributes.marj#i#') and len(evaluate('attributes.marj#i#'))>#evaluate('attributes.marj#i#')#,<cfelse>0,</cfif>
                                EXTRA_PRICE=<cfif isdefined('attributes.ek_tutar#i#') and len(evaluate('attributes.ek_tutar#i#'))>#evaluate('attributes.ek_tutar#i#')#<cfelse>NULL</cfif>,
                                EK_TUTAR_PRICE=<cfif isdefined('attributes.ek_tutar_price#i#') and len(evaluate('attributes.ek_tutar_price#i#'))>#evaluate('attributes.ek_tutar_price#i#')#<cfelse>NULL</cfif>,
                                EXTRA_PRICE_TOTAL=<cfif isdefined('attributes.ek_tutar_total#i#') and len(evaluate('attributes.ek_tutar_total#i#'))>#evaluate('attributes.ek_tutar_total#i#')#<cfelse>NULL</cfif>,
                                EXTRA_PRICE_OTHER_TOTAL=<cfif isdefined('attributes.ek_tutar_other_total#i#') and len(evaluate('attributes.ek_tutar_other_total#i#'))>#evaluate('attributes.ek_tutar_other_total#i#')#<cfelse>NULL</cfif>,
                                SHELF_NUMBER=<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
                                PRODUCT_MANUFACT_CODE=<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.manufact_code#i#')#"><cfelse>NULL</cfif>,
                                BASKET_EXTRA_INFO_ID=<cfif isdefined('attributes.basket_extra_info#i#') and len(evaluate('attributes.basket_extra_info#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.basket_extra_info#i#')#"><cfelse>NULL</cfif>,
                                SELECT_INFO_EXTRA=<cfif isdefined('attributes.select_info_extra#i#') and len(evaluate('attributes.select_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.select_info_extra#i#')#"><cfelse>NULL</cfif>,
                                DETAIL_INFO_EXTRA=<cfif isdefined('attributes.detail_info_extra#i#') and len(evaluate('attributes.detail_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.detail_info_extra#i#')#"><cfelse>NULL</cfif>,
                                BASKET_EMPLOYEE_ID=<cfif isdefined('attributes.basket_employee_id#i#') and len(evaluate('attributes.basket_employee_id#i#')) and isdefined('attributes.basket_employee#i#') and len(evaluate('attributes.basket_employee#i#'))>#evaluate('attributes.basket_employee_id#i#')#<cfelse>NULL</cfif>,
                                PRICE_CAT=<cfif isdefined('attributes.price_cat#i#') and len(evaluate('attributes.price_cat#i#'))>#evaluate('attributes.price_cat#i#')#<cfelse>NULL</cfif>,
                                CATALOG_ID = <cfif isdefined('attributes.row_catalog_id#i#') and len(evaluate('attributes.row_catalog_id#i#'))>#evaluate('attributes.row_catalog_id#i#')#<cfelse>NULL</cfif>,
                                LIST_PRICE=<cfif isdefined('attributes.list_price#i#') and len(evaluate('attributes.list_price#i#'))>#evaluate('attributes.list_price#i#')#<cfelse>NULL</cfif>,
                                NUMBER_OF_INSTALLMENT=<cfif isdefined('attributes.number_of_installment#i#') and len(evaluate('attributes.number_of_installment#i#'))>#evaluate('attributes.number_of_installment#i#')#<cfelse>NULL</cfif>,
                                DUEDATE=<cfif isdefined("attributes.duedate#i#") and len(evaluate("attributes.duedate#i#"))>#evaluate('attributes.duedate#i#')#<cfelse>0</cfif>,
                                KARMA_PRODUCT_ID=<cfif isdefined('attributes.karma_product_id#i#') and len(evaluate('attributes.karma_product_id#i#'))>#evaluate('attributes.karma_product_id#i#')#<cfelse>NULL</cfif>,
                                OTV_ORAN=<cfif isdefined('attributes.otv_oran#i#') and len(evaluate('attributes.otv_oran#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.otv_oran#i#')#"><cfelse>NULL</cfif>,
                                OTVTOTAL=<cfif isdefined('attributes.row_otvtotal#i#') and len(evaluate('attributes.row_otvtotal#i#'))>#evaluate('attributes.row_otvtotal#i#')#<cfelse>NULL</cfif>,
                                WRK_ROW_ID=<cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.wrk_row_id#i#')#"><cfelse>NULL</cfif>,
                                WRK_ROW_RELATION_ID=<cfif isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.wrk_row_relation_id#i#')#"><cfelse>NULL</cfif>,
                                RELATED_ACTION_ID=<cfif isdefined('attributes.related_action_id#i#') and len(evaluate('attributes.related_action_id#i#'))>#evaluate('attributes.related_action_id#i#')#<cfelse>NULL</cfif>,
                                RELATED_ACTION_TABLE=<cfif isdefined('attributes.related_action_table#i#') and len(evaluate('attributes.related_action_table#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.related_action_table#i#')#"><cfelse>NULL</cfif>,
                                WIDTH_VALUE=<cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
                                DEPTH_VALUE=<cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
                                HEIGHT_VALUE=<cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>,
                                ROW_PROJECT_ID = <cfif isdefined('attributes.row_project_id#i#') and len(evaluate('attributes.row_project_id#i#')) and isdefined('attributes.row_project_name#i#') and len(evaluate('attributes.row_project_name#i#'))>#evaluate('attributes.row_project_id#i#')#<cfelse>NULL</cfif>,
                                ROW_WORK_ID = <cfif isdefined('attributes.row_work_id#i#') and len(evaluate('attributes.row_work_id#i#')) and isdefined('attributes.row_work_name#i#') and len(evaluate('attributes.row_work_name#i#'))>#evaluate('attributes.row_work_id#i#')#<cfelse>NULL</cfif>
                                <cfif isdefined('attributes.row_exp_center_id#i#') and len(evaluate("attributes.row_exp_center_id#i#")) and isdefined('attributes.row_exp_center_name#i#') and len(evaluate("attributes.row_exp_center_name#i#"))>
                                ,EXPENSE_CENTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_exp_center_id#i#')#">
                                </cfif>
                                <cfif isdefined('attributes.row_exp_item_id#i#') and len(evaluate("attributes.row_exp_item_id#i#")) and isdefined('attributes.row_exp_item_name#i#') and len(evaluate("attributes.row_exp_item_name#i#"))>
                                ,EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_exp_item_id#i#')#">
                                </cfif>
                                <cfif isdefined('attributes.row_activity_id#i#') and len(evaluate("attributes.row_activity_id#i#"))>
                                ,ACTIVITY_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_activity_id#i#')#">
                                </cfif>
                                <cfif isdefined('attributes.row_acc_code#i#') and len(evaluate("attributes.row_acc_code#i#"))>
                                ,ACC_CODE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate('attributes.row_acc_code#i#')#">
                                </cfif>
                                <cfif isdefined('attributes.row_subscription_name#i#') and len(evaluate("attributes.row_subscription_name#i#")) and isdefined('attributes.row_subscription_id#i#') and len(evaluate("attributes.row_subscription_id#i#"))>
                                ,SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_subscription_id#i#')#">
                                </cfif>
                                <cfif isdefined('attributes.row_assetp_name#i#') and len(evaluate("attributes.row_assetp_name#i#")) and isdefined('attributes.row_assetp_id#i#') and len(evaluate("attributes.row_assetp_id#i#"))>
                                ,ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_assetp_id#i#')#">
                                </cfif>
                                <cfif isdefined('attributes.row_bsmv_rate#i#') and len(evaluate("attributes.row_bsmv_rate#i#"))>
                                ,BSMV_RATE = <cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_rate#i#')#">
                                </cfif>
                                <cfif isdefined('attributes.row_bsmv_amount#i#') and len(evaluate("attributes.row_bsmv_amount#i#"))>
                                ,BSMV_AMOUNT = <cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_amount#i#')#">
                                </cfif>
                                <cfif isdefined('attributes.row_bsmv_currency#i#') and len(evaluate("attributes.row_bsmv_currency#i#"))>
                                ,BSMV_CURRENCY = <cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_currency#i#')#">
                                </cfif>
                                <cfif isdefined('attributes.row_oiv_rate#i#') and len(evaluate("attributes.row_oiv_rate#i#"))>
                                ,OIV_RATE = <cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_oiv_rate#i#')#">
                                </cfif>
                                <cfif isdefined('attributes.row_oiv_amount#i#') and len(evaluate("attributes.row_oiv_amount#i#"))>
                                ,OIV_AMOUNT = <cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_oiv_amount#i#')#">
                                </cfif>
                                <cfif isdefined('attributes.row_tevkifat_rate#i#') and len(evaluate("attributes.row_tevkifat_rate#i#"))>
                                ,TEVKIFAT_RATE = <cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_tevkifat_rate#i#')#">
                                </cfif>
                                <cfif isdefined('attributes.row_tevkifat_amount#i#') and len(evaluate("attributes.row_tevkifat_amount#i#"))>
                                ,TEVKIFAT_AMOUNT = <cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_tevkifat_amount#i#')#">
                                </cfif>
                            WHERE
                                ORDER_ID=#attributes.order_id#
                                AND ORDER_ROW_ID=#evaluate('attributes.action_row_id#i#')#
                        </cfquery>
                        <cfset attributes.ROW_MAIN_ID = evaluate('attributes.action_row_id#i#')>
                    <cfelse>
                        <cfquery name="ADD_PRODUCT_TO_OFFER" datasource="#DSN3#">
                            INSERT INTO 
                                ORDER_ROW 
                                (
                                ORDER_ID, 
                                ROW_INTERNALDEMAND_ID,
                                RELATED_INTERNALDEMAND_ROW_ID,
                                ROW_PRO_MATERIAL_ID,
                                PRODUCT_NAME,
                                PRODUCT_ID,
                                STOCK_ID,
                                QUANTITY,
                                UNIT,
                                UNIT_ID,
                                PRICE,
                                TAX,
                                DELIVER_DATE,
                                DELIVER_DEPT,
                                DELIVER_LOCATION,
                                DISCOUNT_1,
                                DISCOUNT_2,
                                DISCOUNT_3,
                                DISCOUNT_4,
                                DISCOUNT_5,					
                                DISCOUNT_6,
                                DISCOUNT_7,
                                DISCOUNT_8,
                                DISCOUNT_9,
                                DISCOUNT_10,						
                                OTHER_MONEY,
                                OTHER_MONEY_VALUE,
                                SPECT_VAR_ID,
                                SPECT_VAR_NAME,
                                LOT_NO,
                                PRICE_OTHER,
                                IS_PROMOTION,
                                NETTOTAL,
                                ORDER_ROW_CURRENCY,
                                RESERVE_TYPE,
                                RESERVE_DATE,
                                COST_PRICE,
                                EXTRA_COST,
                                DISCOUNT_COST,
                                UNIQUE_RELATION_ID,
                                PROM_RELATION_ID,
                                PRODUCT_NAME2,
                                AMOUNT2,
                                UNIT2,
                                MARJ,
                                EXTRA_PRICE,
                                EK_TUTAR_PRICE,<!--- iscilik birim maliyet --->
                                EXTRA_PRICE_TOTAL,
                                EXTRA_PRICE_OTHER_TOTAL,
                                SHELF_NUMBER,
                                PRODUCT_MANUFACT_CODE,
                                BASKET_EXTRA_INFO_ID,
                                BASKET_EMPLOYEE_ID,
                                PRICE_CAT,
                                CATALOG_ID,
                                LIST_PRICE,
                                NUMBER_OF_INSTALLMENT,
                                DUEDATE,
                                KARMA_PRODUCT_ID,
                                OTV_ORAN,
                                OTVTOTAL,
                                WRK_ROW_ID,
                                WRK_ROW_RELATION_ID,
                                RELATED_ACTION_ID,
                                RELATED_ACTION_TABLE,
                                WIDTH_VALUE,
                                DEPTH_VALUE,
                                HEIGHT_VALUE,
                                ROW_PROJECT_ID,
                                ROW_WORK_ID
                                <cfif isdefined('attributes.row_exp_center_id#i#') and len(evaluate("attributes.row_exp_center_id#i#")) and isdefined('attributes.row_exp_center_name#i#') and len(evaluate("attributes.row_exp_center_name#i#"))>,EXPENSE_CENTER_ID</cfif>
                                <cfif isdefined('attributes.row_exp_item_id#i#') and len(evaluate("attributes.row_exp_item_id#i#")) and isdefined('attributes.row_exp_item_name#i#') and len(evaluate("attributes.row_exp_item_name#i#"))>,EXPENSE_ITEM_ID</cfif>
                                <cfif isdefined('attributes.row_activity_id#i#') and len(evaluate("attributes.row_activity_id#i#"))>,ACTIVITY_TYPE_ID</cfif>
                                <cfif isdefined('attributes.row_acc_code#i#') and len(evaluate("attributes.row_acc_code#i#"))>,ACC_CODE</cfif>
                                <cfif isdefined('attributes.row_subscription_name#i#') and len(evaluate("attributes.row_subscription_name#i#")) and isdefined('attributes.row_subscription_id#i#') and len(evaluate("attributes.row_subscription_id#i#"))>,SUBSCRIPTION_ID</cfif>
                                <cfif isdefined('attributes.row_assetp_name#i#') and len(evaluate("attributes.row_assetp_name#i#")) and isdefined('attributes.row_assetp_id#i#') and len(evaluate("attributes.row_assetp_id#i#"))>,ASSETP_ID</cfif>
                                <cfif isdefined('attributes.row_bsmv_rate#i#') and len(evaluate("attributes.row_bsmv_rate#i#"))>,BSMV_RATE</cfif>
                                <cfif isdefined('attributes.row_bsmv_amount#i#') and len(evaluate("attributes.row_bsmv_amount#i#"))>,BSMV_AMOUNT</cfif>
                                <cfif isdefined('attributes.row_bsmv_currency#i#') and len(evaluate("attributes.row_bsmv_currency#i#"))>,BSMV_CURRENCY</cfif>
                                <cfif isdefined('attributes.row_oiv_rate#i#') and len(evaluate("attributes.row_oiv_rate#i#"))>,OIV_RATE</cfif>
                                <cfif isdefined('attributes.row_oiv_amount#i#') and len(evaluate("attributes.row_oiv_amount#i#"))>,OIV_AMOUNT</cfif>
                                <cfif isdefined('attributes.row_tevkifat_rate#i#') and len(evaluate("attributes.row_tevkifat_rate#i#"))>,TEVKIFAT_RATE</cfif>
                                <cfif isdefined('attributes.row_tevkifat_amount#i#') and len(evaluate("attributes.row_tevkifat_amount#i#"))>,TEVKIFAT_AMOUNT</cfif>
                                )
                            VALUES 
                                (
                                #FORM.ORDER_ID#,
                                <cfif isdefined('attributes.internaldemand_id_list') and len(attributes.internaldemand_id_list) and isdefined("attributes.row_ship_id#i#") and len(evaluate('attributes.row_ship_id#i#')) and listfirst(evaluate('attributes.row_ship_id#i#'),';') neq 0>#listfirst(evaluate('attributes.row_ship_id#i#'),';')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.internaldemand_id_list') and len(attributes.internaldemand_id_list) and isdefined("attributes.row_ship_id#i#") and listlen(evaluate('attributes.row_ship_id#i#'),";") eq 2 and len(listgetat(evaluate('attributes.row_ship_id#i#'),2,';'))>#listgetat(evaluate('attributes.row_ship_id#i#'),2,';')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.pro_material_id_list') and len(attributes.pro_material_id_list) and isdefined("attributes.row_ship_id#i#") and len(evaluate('attributes.row_ship_id#i#')) and listfirst(evaluate('attributes.row_ship_id#i#'),';') neq 0>#listfirst(evaluate('attributes.row_ship_id#i#'),';')#<cfelse>NULL</cfif>,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.product_name#i#')#">,
                                    #evaluate('attributes.product_id#i#')#,
                                    #evaluate('attributes.stock_id#i#')#,
                                    #evaluate('attributes.amount#i#')#,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit#i#')#">,
                                    #evaluate("attributes.unit_id#i#")#,
                                    #evaluate("attributes.price#i#")#,
                                    #evaluate("attributes.tax#i#")#,
                                <cfif isdefined("x_apply_deliverdate_to_rows") and x_apply_deliverdate_to_rows eq 1 and not (isdefined("attributes.deliver_date#i#") and len(evaluate('attributes.deliver_date#i#')))>
                                    <cfif len(attributes.deliverdate)>#attributes.deliverdate#<cfelse>NULL</cfif>,
                                <cfelse>                    
                                    <cfif isdefined("attributes.deliver_date#i#") and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
                                </cfif>
                                <cfif isdefined("attributes.deliver_dept#i#") and len(trim(evaluate("attributes.deliver_dept#i#"))) and len(listfirst(evaluate("attributes.deliver_dept#i#"),"-"))>
                                    #listfirst(evaluate("attributes.deliver_dept#i#"),"-")#,
                                <cfelseif isdefined("attributes.deliver_dept_id") and len(attributes.deliver_dept_id)>
                                    #attributes.deliver_dept_id#,
                                <cfelse>
                                    NULL,
                                </cfif>
                                <cfif isdefined("attributes.deliver_dept#i#") and listlen(trim(evaluate("attributes.deliver_dept#i#")),"-") eq 2 and len(listlast(evaluate("attributes.deliver_dept#i#"),"-"))>
                                    #listlast(evaluate("attributes.deliver_dept#i#"),"-")#,
                                <cfelseif isdefined("attributes.deliver_loc_id") and len(attributes.deliver_loc_id)>
                                    #attributes.deliver_loc_id#,
                                <cfelse>
                                    NULL,
                                </cfif>
                                <cfif isdefined('attributes.indirim1#i#') and len(evaluate("attributes.indirim1#i#"))>#evaluate('attributes.indirim1#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.indirim2#i#') and len(evaluate("attributes.indirim2#i#"))>#evaluate('attributes.indirim2#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.indirim3#i#') and len(evaluate("attributes.indirim3#i#"))>#evaluate('attributes.indirim3#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.indirim4#i#') and len(evaluate("attributes.indirim4#i#"))>#evaluate('attributes.indirim4#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.indirim5#i#') and len(evaluate("attributes.indirim5#i#"))>#evaluate('attributes.indirim5#i#')#<cfelse>NULL</cfif>,					
                                <cfif isdefined('attributes.indirim6#i#')>#evaluate('attributes.indirim6#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.indirim7#i#')>#evaluate('attributes.indirim7#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.indirim8#i#')>#evaluate('attributes.indirim8#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.indirim9#i#')>#evaluate('attributes.indirim9#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.indirim10#i#')>#evaluate('attributes.indirim10#i#')#<cfelse>NULL</cfif>,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.other_money_#i#')#">,
                                <cfif isdefined('attributes.other_money_value_#i#') and len(evaluate("attributes.other_money_value_#i#"))>#evaluate('attributes.other_money_value_#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>#evaluate('attributes.spect_id#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.spect_name#i#')><cfqueryparam cfsqltype="cf_sql_varchar" value="#left(evaluate('attributes.spect_name#i#'),500)#"><cfelse>NULL</cfif>,			
                                <cfif isdefined('attributes.lot_no#i#')><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.price_other#i#') and len(evaluate("attributes.price_other#i#"))>#evaluate('attributes.price_other#i#')#<cfelse>NULL</cfif>,
                                    0,
                                <cfif isdefined("attributes.row_nettotal#i#") and len(evaluate("attributes.row_nettotal#i#"))>#evaluate("attributes.row_nettotal#i#")#<cfelse>NULL</cfif>,
                                <cfif isdefined("attributes.order_currency#i#") and len(evaluate("attributes.order_currency#i#"))>#evaluate("attributes.order_currency#i#")#<cfelse>NULL</cfif>,
                                <cfif isdefined("attributes.reserve_type#i#") and len(evaluate("attributes.reserve_type#i#"))>#evaluate("attributes.reserve_type#i#")#<cfelse>NULL</cfif>,
                                <cfif isdefined("attributes.reserve_date#i#") and isdate(evaluate('attributes.reserve_date#i#'))>#evaluate('attributes.reserve_date#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.net_maliyet#i#') and len(evaluate('attributes.net_maliyet#i#'))>#evaluate('attributes.net_maliyet#i#')#<cfelse>0</cfif>,
                                <cfif isdefined('attributes.extra_cost#i#') and len(evaluate('attributes.extra_cost#i#'))>#evaluate('attributes.extra_cost#i#')#<cfelse>0</cfif>,
                                <cfif isdefined('attributes.iskonto_tutar#i#') and len(evaluate('attributes.iskonto_tutar#i#'))>#evaluate('attributes.iskonto_tutar#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.row_unique_relation_id#i#') and len(evaluate('attributes.row_unique_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.row_unique_relation_id#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.prom_relation_id#i#') and len(evaluate('attributes.prom_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.prom_relation_id#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.product_name_other#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit_other#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.marj#i#') and len(evaluate('attributes.marj#i#'))>#evaluate('attributes.marj#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.ek_tutar#i#') and len(evaluate('attributes.ek_tutar#i#'))>#evaluate('attributes.ek_tutar#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.ek_tutar_price#i#') and len(evaluate('attributes.ek_tutar_price#i#'))>#evaluate('attributes.ek_tutar_price#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.ek_tutar_total#i#') and len(evaluate('attributes.ek_tutar_total#i#'))>#evaluate('attributes.ek_tutar_total#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.ek_tutar_other_total#i#') and len(evaluate('attributes.ek_tutar_other_total#i#'))>#evaluate('attributes.ek_tutar_other_total#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.manufact_code#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.basket_extra_info#i#') and len(evaluate('attributes.basket_extra_info#i#'))>#evaluate('attributes.basket_extra_info#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.basket_employee_id#i#') and len(evaluate('attributes.basket_employee_id#i#')) and isdefined('attributes.basket_employee#i#') and len(evaluate('attributes.basket_employee#i#'))>#evaluate('attributes.basket_employee_id#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.price_cat#i#') and len(evaluate('attributes.price_cat#i#'))>#evaluate('attributes.price_cat#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.row_catalog_id#i#') and len(evaluate('attributes.row_catalog_id#i#'))>#evaluate('attributes.row_catalog_id#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.list_price#i#') and len(evaluate('attributes.list_price#i#'))>#evaluate('attributes.list_price#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.number_of_installment#i#') and len(evaluate('attributes.number_of_installment#i#'))>#evaluate('attributes.number_of_installment#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined("attributes.duedate#i#") and len(evaluate("attributes.duedate#i#"))>#evaluate("attributes.duedate#i#")#<cfelse>0</cfif>,
                                <cfif isdefined('attributes.karma_product_id#i#') and len(evaluate('attributes.karma_product_id#i#'))>#evaluate('attributes.karma_product_id#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.otv_oran#i#') and len(evaluate('attributes.otv_oran#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.otv_oran#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.row_otvtotal#i#') and len(evaluate('attributes.row_otvtotal#i#'))>#evaluate('attributes.row_otvtotal#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.wrk_row_id#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.wrk_row_relation_id#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.related_action_id#i#') and len(evaluate('attributes.related_action_id#i#'))>#evaluate('attributes.related_action_id#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.related_action_table#i#') and len(evaluate('attributes.related_action_table#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.related_action_table#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.row_project_id#i#') and len(evaluate('attributes.row_project_id#i#')) and isdefined('attributes.row_project_name#i#') and len(evaluate('attributes.row_project_name#i#'))>#evaluate('attributes.row_project_id#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.row_work_id#i#') and len(evaluate('attributes.row_work_id#i#')) and isdefined('attributes.row_work_name#i#') and len(evaluate('attributes.row_work_name#i#'))>#evaluate('attributes.row_work_id#i#')#<cfelse>NULL</cfif>
                                <cfif isdefined('attributes.row_exp_center_id#i#') and len(evaluate("attributes.row_exp_center_id#i#")) and isdefined('attributes.row_exp_center_name#i#') and len(evaluate("attributes.row_exp_center_name#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_exp_center_id#i#')#"></cfif>
                                <cfif isdefined('attributes.row_exp_item_id#i#') and len(evaluate("attributes.row_exp_item_id#i#")) and isdefined('attributes.row_exp_item_name#i#') and len(evaluate("attributes.row_exp_item_name#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_exp_item_id#i#')#"></cfif>
                                <cfif isdefined('attributes.row_activity_id#i#') and len(evaluate("attributes.row_activity_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_activity_id#i#')#"></cfif>
                                <cfif isdefined('attributes.row_acc_code#i#') and len(evaluate("attributes.row_acc_code#i#"))>,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate('attributes.row_acc_code#i#')#"></cfif>
                                <cfif isdefined('attributes.row_subscription_name#i#') and len(evaluate("attributes.row_subscription_name#i#")) and isdefined('attributes.row_subscription_id#i#') and len(evaluate("attributes.row_subscription_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_subscription_id#i#')#"></cfif>
                                <cfif isdefined('attributes.row_assetp_name#i#') and len(evaluate("attributes.row_assetp_name#i#")) and isdefined('attributes.row_assetp_id#i#') and len(evaluate("attributes.row_assetp_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_assetp_id#i#')#"></cfif>
                                <cfif isdefined('attributes.row_bsmv_rate#i#') and len(evaluate("attributes.row_bsmv_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_rate#i#')#"></cfif>
                                <cfif isdefined('attributes.row_bsmv_amount#i#') and len(evaluate("attributes.row_bsmv_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_amount#i#')#"></cfif>
                                <cfif isdefined('attributes.row_bsmv_currency#i#') and len(evaluate("attributes.row_bsmv_currency#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_currency#i#')#"></cfif>
                                <cfif isdefined('attributes.row_oiv_rate#i#') and len(evaluate("attributes.row_oiv_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_oiv_rate#i#')#"></cfif>
                                <cfif isdefined('attributes.row_oiv_amount#i#') and len(evaluate("attributes.row_oiv_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_oiv_amount#i#')#"></cfif>
                                <cfif isdefined('attributes.row_tevkifat_rate#i#') and len(evaluate("attributes.row_tevkifat_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_tevkifat_rate#i#')#"></cfif>
                                <cfif isdefined('attributes.row_tevkifat_amount#i#') and len(evaluate("attributes.row_tevkifat_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_tevkifat_amount#i#')#"></cfif>
                                )
                        </cfquery>
                        <cfquery name="get_max_order_row" datasource="#DSN3#">
                            SELECT MAX(ORDER_ROW_ID) AS ORDER_ROW_ID FROM ORDER_ROW
                        </cfquery>
                        <cfset attributes.ROW_MAIN_ID = get_max_order_row.ORDER_ROW_ID>
                    </cfif>
                    <!---Ek Bilgiler--->
                    <cfset attributes.is_upd = 1>
                    <cfset attributes.info_id = attributes.order_id>
                    <cfset attributes.info_type_id = -12>
                    <cfinclude template="../../objects/query/add_info_plus2.cfm">
                    <!---Ek Bilgiler--->
                    <cfif isdefined('attributes.related_action_id#i#') and Evaluate('attributes.related_action_id#i#') gt 0 and isdefined('attributes.wrk_row_relation_id#i#') and Evaluate('attributes.wrk_row_relation_id#i#') gt 0>
                        <cfscript>
                            add_relation_rows(
                                action_type:'add',
                                action_dsn : '#dsn3#',
                                to_table:'ORDERS',
                                from_table:'#evaluate("attributes.RELATED_ACTION_TABLE#i#")#',
                                to_wrk_row_id : Evaluate("attributes.wrk_row_id#i#"),
                                from_wrk_row_id :Evaluate("attributes.wrk_row_relation_id#i#"),
                                amount : Evaluate("attributes.amount#i#"),
                                to_action_id : attributes.order_id,
                                from_action_id :Evaluate("attributes.related_action_id#i#")
                                );
                        </cfscript>
                    </cfif>
                    <!---  urun asortileri --->			
                    <cfset order_row_id_list_ =listappend(order_row_id_list_,attributes.ROW_MAIN_ID)> <!--- order_row_id_list olusturuluyor, bu liste haricindeki order_row satırları silinir --->
                    <cfset row_id = i>
                    <cfset ACTION_TYPE_ID = 2>
                    <cfset assortment_textilte = add_assortment_textile(row_id : row_id, action_type_id : ACTION_TYPE_ID)>
                    <cfinclude template="../query/add_department_information.cfm">		
            
                    <cfif isdefined('attributes.process_cat') and len(attributes.process_cat) and isdefined("get_type.IS_BUDGET_RESERVED_CONTROL") and get_type.IS_BUDGET_RESERVED_CONTROL eq 1>
                        <cfif isdefined('attributes.other_money_value_#i#') and len(evaluate("attributes.other_money_value_#i#"))>
                            <cfset other_money_val = evaluate('attributes.other_money_value_#i#')>
                        <cfelse>
                            <cfset other_money_val =''>
                        </cfif>
                        <cfif isdefined('attributes.other_money_#i#') and len(evaluate("attributes.other_money_#i#"))>
                            <cfset other_money = evaluate('attributes.other_money_#i#')>
                        <cfelse>
                            <cfset other_money = ''>
                        </cfif>
                        
                        <cfscript>
                            butceci(
                            action_id : attributes.ORDER_ID,
                            muhasebe_db : dsn3,
                            is_income_expense : true,
                            period_id:session.ep.period_id,
                            process_type : get_type.process_type,
                            product_tax: evaluate("attributes.tax#i#"),//kdv
                            stock_id: evaluate("attributes.stock_id#i#"),
                            product_id: evaluate("attributes.product_id#i#"),
                            product_otv: iif((isdefined("attributes.otv_oran#i#") and len(evaluate('attributes.otv_oran#i#'))),evaluate("attributes.otv_oran#i#"),0),
                            product_oiv: iif((isdefined("attributes.row_oiv_rate#i#") and len(evaluate('attributes.row_oiv_rate#i#'))),evaluate("attributes.row_oiv_rate#i#"),0),
                            tevkifat_rate: iif((isdefined("attributes.row_tevkifat_rate#i#") and len(evaluate('attributes.row_tevkifat_rate#i#'))),evaluate("attributes.row_tevkifat_rate#i#"),0),
                            nettotal : wrk_round(evaluate("attributes.row_nettotal#i#")),
                            other_money_value : other_money_val,
                            action_currency : other_money,
                            currency_multiplier : attributes.currency_multiplier,
                            expense_date : attributes.order_date,
                            expense_center_id : iif((isdefined("attributes.row_exp_center_id#i#") and len(evaluate('attributes.row_exp_center_id#i#'))),evaluate("attributes.row_exp_center_id#i#"),0),
                            expense_item_id : iif((isdefined("attributes.row_exp_item_id#i#") and len(evaluate('attributes.row_exp_item_id#i#'))),evaluate("attributes.row_exp_item_id#i#"),0),
                            detail : '#GET_PAPER.ORDER_NUMBER# Nolu Sipariş',
                            paper_no : GET_PAPER.ORDER_NUMBER,
                            branch_id : ListGetAt(session.ep.user_location,2,"-"),
                            reserv_type :1, //expense_reserved_rows tablosuna gelir olarak yazılsın.
                            project_id: iif(isdefined("attributes.project_id") and len(attributes.project_id), "attributes.project_id", DE('')),
                            activity_type : evaluate("attributes.row_activity_id#i#"),
                            invoice_row_id:attributes.ROW_MAIN_ID
                            );
                        </cfscript>
                    </cfif>
            
                </cfloop>
                <cfif len(order_row_id_list_)>
                    <cfquery name="DEL_ORDER_ROW_" datasource="#DSN3#"> <!--- basketten cıkarılan satırlar ORDER_ROW dan siliniyor --->
                        DELETE FROM ORDER_ROW WHERE ORDER_ID =#attributes.order_id# AND ORDER_ROW_ID NOT IN (#order_row_id_list_#)
                    </cfquery>
                </cfif>
                <cfscript>
                    basket_kur_ekle(action_id:FORM.ORDER_ID,table_type_id:3,process_type:1);
                    add_reserve_row(
                        reserve_order_id:FORM.ORDER_ID,
                        reserve_action_type:1,
                        is_related_action_iptal :iif((isdefined("attributes.irsaliye_iptal") and (attributes.irsaliye_iptal eq 1)),1,0),
                        is_order_process:0,
                        is_purchase_sales:0
                        );
                    
                    if(isdefined('attributes.internaldemand_id_list') and len(attributes.internaldemand_id_list)) //siparis ic talepten olusturulmussa
                    {
                        add_internaldemand_row_relation(
                            to_related_action_id:FORM.ORDER_ID,
                            to_related_action_type:0,
                            action_status:1,
                            is_related_action_iptal :iif((isdefined("ORDER_STATUS") and (ORDER_STATUS eq 1)),0,1)
                            );
                    }
                    if(isdefined('attributes.pro_material_id_list') and len(attributes.pro_material_id_list)) //proje malzeme planı ile baglantısı olusturuluyor
                    {
                        add_paper_relation(
                            to_paper_id :FORM.ORDER_ID,
                            to_paper_table : 'ORDERS',
                            to_paper_type :1,
                            from_paper_table : 'PRO_MATERIAL',
                            from_paper_type :2,
                            relation_type : 1,
                            action_status:1
                            );
                    }
                </cfscript>
                <!---sipariş güncellendiğinde parçalı cari ödeme planı sablonu silinir --->
                <cfquery name="DEL_PAYMENT_PLANS" datasource="#dsn3#">
                    DELETE FROM ORDER_PAYMENT_PLAN_ROWS WHERE PAYMENT_PLAN_ID IN (ISNULL((SELECT PAYMENT_PLAN_ID FROM ORDER_PAYMENT_PLAN WHERE ACTION_ID=#attributes.order_id#),0))
                </cfquery>
                <cfquery name="DEL_PAYMENT_PLANS" datasource="#dsn3#">
                    DELETE FROM ORDER_PAYMENT_PLAN WHERE ACTION_ID=#attributes.order_id#
                </cfquery>
                    <cf_workcube_process 
                        is_upd='1' 
                        data_source='#dsn3#' 
                        process_stage='#attributes.process_stage#' 
                        old_process_line='#attributes.old_process_line#'
                        record_member='#session.ep.userid#'
                        record_date='#now()#' 
                        action_table='ORDERS'
                        action_column='ORDER_ID'
                        action_id='#form.order_id#' 
                        action_page='#request.self#?fuseaction=purchase.list_order&event=upd&order_id=#form.order_id#' 
                        warning_description="#getLang('','Sipariş',57611)# : #get_order.order_number#">
            
                    <cfif isdefined("attributes.process_cat") and len(attributes.process_cat)>
                        <cf_workcube_process_cat 
                            process_cat="#attributes.process_cat#"
                            action_id = "#attributes.ORDER_ID#"
                            action_table="ORDER"
                            action_column="ORDER_ID"
                            is_action_file = 1
                            action_page='#request.self#?fuseaction=purchase.list_order&event=upd&order_id=#attributes.ORDER_ID#'
                            action_file_name='#get_type.action_file_name#'
                            action_db_type = '#dsn3#'
                            is_template_action_file = '#get_type.action_file_from_template#'>
                    </cfif>	
                    <cfset responseStruct.message = "İşlem Başarılı">
                    <cfset responseStruct.status = true>
                    <cfset responseStruct.error = {}>
                    <cfset responseStruct.identity = ''>
                <cfcatch type="database">
                    <cftransaction action="rollback">
                    <cfset responseStruct.message = "İşlem Hatalı">
                    <cfset responseStruct.status = false>
                    <cfset responseStruct.error = cfcatch>
                </cfcatch>
                </cftry>
            </cftransaction>
        </cflock>
        <cfreturn responseStruct>
    </cffunction>

    <cffunction name="add_order" access="public" returntype="struct" output="false" hint="Sipariş Ekleme İşlemleri">
        <cfset attributes = arguments>
        <cfset form = arguments>
        <cfset responseStruct = structNew()>
        <cfif attributes.active_company neq session.ep.company_id>
            <cfset responseStruct.message = getLang('main','İşlemin Şirketi İle Aktif Şirketiniz Farklı Çalıştığınız Şirketi Kontrol Ediniz',38700)>
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = {}>
            <cfreturn responseStruct>
            <cfabort>
        </cfif>
        <cfif not isdefined("attributes.rows_") or attributes.rows_ lte 0>
            <cfset responseStruct.message = getLang('main','Ürün Seçmediniz! Lütfen Ürün Seçiniz',45894)>
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = {}>
            <cfreturn responseStruct>
            <cfabort>
        </cfif>
        <cf_xml_page_edit fuseact="purchase.detail_order">
        <cf_date tarih = "attributes.basket_due_value_date_">
        <cf_date tarih = "attributes.order_date">
        <!--- irsaliye tarihine gore ortalama vade tarihi --->
        <cfif isdefined('attributes.basket_due_value_date_')>
            <cfset order_due_date = attributes.basket_due_value_date_>
        <cfelse>
            <cfset order_due_date = ''>
        </cfif>
        <cfif not isdefined("new_dsn3_group_pur")><cfset new_dsn3_group_pur = dsn3></cfif>

        <cfif isdefined("attributes.deliverdate") and isdate(attributes.deliverdate)>
            <cf_date tarih = "attributes.deliverdate">
        </cfif>
        <cfif isdefined("attributes.publishdate") and isdate(attributes.publishdate)>
            <cf_date tarih = "attributes.publishdate">
        </cfif>
        <cfif isdefined('attributes.process_cat') and len(attributes.process_cat)>
            <cfscript>
                attributes.currency_multiplier = '';
                paper_currency_multiplier ='';
                if(isDefined('attributes.kur_say') and len(attributes.kur_say))
                    for(mon=1;mon lte attributes.kur_say;mon=mon+1)
                    {
                        if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
                            attributes.currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
                        if(evaluate("attributes.hidden_rd_money_#mon#") is form.basket_money)
                            paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
                    }
            </cfscript>
            <cfquery name="get_type" datasource="#dsn3#">
                SELECT PROCESS_TYPE,PROCESS_CAT_ID,ACTION_FILE_NAME,ACTION_FILE_FROM_TEMPLATE,IS_BUDGET_RESERVED_CONTROL FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #attributes.process_cat#
            </cfquery>
        </cfif>
        <cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
        <cflock name="#CreateUUID()#" timeout="20">
        <cftransaction>
            <cftry>
                <cfif not (isdefined("attributes.order_number") and len(attributes.order_number))>
                    <cfquery name="get_order_code" datasource="#new_dsn3_group_pur#">
                        SELECT ORDER_NO, ORDER_NUMBER FROM GENERAL_PAPERS WHERE PAPER_TYPE = 1 AND ZONE_TYPE = 0
                    </cfquery>
                    <cfset paper_code = evaluate('get_order_code.ORDER_NO')>
                    <cfset paper_number = evaluate('get_order_code.ORDER_NUMBER') +1>
                    <cfset paper_full = '#paper_code#-#paper_number#'>
                    <cfquery name="UPD_OFFER_CODE" datasource="#new_dsn3_group_pur#">
                        UPDATE 
                            GENERAL_PAPERS 
                        SET 
                            ORDER_NUMBER = ORDER_NUMBER+1
                        WHERE 
                            PAPER_TYPE = 1 
                            AND ZONE_TYPE = 0
                    </cfquery>
                <cfelse>
                    <cfset paper_full = attributes.order_number>
                </cfif>
                <!--- ORDER_CURRENCY 1 DURUMUNDA BASLIYOR --->
                <cfquery name="INS_ORDER" datasource="#new_dsn3_group_pur#" result="my_result">
                    INSERT INTO 
                        ORDERS(
                        WRK_ID,
                        ORDER_STATUS,
                        ORDER_STAGE,
                        ORDER_DATE,
                        ORDER_NUMBER,
                        PURCHASE_SALES,
                        COMPANY_ID,
                        PARTNER_ID,
                        CONSUMER_ID,
                        STARTDATE,
                        DELIVERDATE,
                        PRIORITY_ID,								   
                        OFFER_ID,
                        PAYMETHOD,
                        ORDER_HEAD,
                        ORDER_DETAIL,
                        NETTOTAL,
                        DELIVER_DEPT_ID,
                        LOCATION_ID,
                        SHIP_ADDRESS,
                        SHIP_ADDRESS_ID,
                        CITY_ID,
                        COUNTY_ID,
                        INVISIBLE,
                        PUBLISHDATE,
                        <cfif isdefined('attributes.basket_money')>
                        OTHER_MONEY,
                        OTHER_MONEY_VALUE,
                        </cfif>
                        <cfif isdefined('attributes.tax')>			
                        TAX,
                        </cfif>
                        INCLUDED_KDV,
                        RESERVED,
                        SHIP_METHOD,
                        PROJECT_ID,
                        CATALOG_ID,
                        TAXTOTAL,
                        DISCOUNTTOTAL,
                        GROSSTOTAL,
                        ORDER_EMPLOYEE_ID,
                        DUE_DATE,
                        REF_NO,
                        CARD_PAYMETHOD_ID,
                        CARD_PAYMETHOD_RATE,
                        WORK_ID,
                        IS_FOREIGN,
                        RECORD_DATE,
                        RECORD_EMP,
                        RECORD_IP,
                        CONTRACT_ID,
                        PROCESS_CAT,
                        SA_DISCOUNT)
                    VALUES(
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_id#">,
                        <cfif isDefined("attributes.order_status")>1<cfelse>0</cfif>,
                        #attributes.process_stage#,
                        #attributes.order_date#,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#paper_full#">,
                        0,
                        <cfif Len(attributes.COMPANY_ID)>#attributes.COMPANY_ID#<cfelse>NULL</cfif>,
                        <cfif len(attributes.PARTNER_ID)>#attributes.PARTNER_ID#<cfelse>NULL</cfif>,
                        <cfif len(attributes.CONSUMER_ID)>#attributes.CONSUMER_ID#<cfelse>NULL</cfif>,
                            #now()#,
                        <cfif len(attributes.deliverdate)>
                            #attributes.deliverdate#,
                        <cfelse>
                            NULL,
                        </cfif>
                            <cfif isdefined("attributes.PRIORITY_ID") and len(attributes.PRIORITY_ID)>#attributes.PRIORITY_ID#,<cfelse>1,</cfif>
                            <cfif isdefined("attributes.offer_id") and len(attributes.offer_id)>#attributes.offer_id#<cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.paymethod_id") and len(attributes.paymethod_id) and len(attributes.pay_method)>
                            #attributes.paymethod_id#,
                        <cfelse>
                            NULL,
                        </cfif>
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ORDER_HEAD#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ORDER_DETAIL#">,
                        <cfif isdefined("attributes.basket_net_total")>
                            #attributes.basket_net_total#,
                        <cfelse>
                            0,
                        </cfif>
                        <cfif isdefined("attributes.deliver_dept_id") and len(attributes.deliver_dept_id) and len(attributes.deliver_dept_name)>
                            #attributes.deliver_dept_id#,
                        <cfelse>
                            NULL,
                        </cfif>
                        <cfif isdefined("attributes.deliver_loc_id") and len(attributes.deliver_loc_id) and len(attributes.deliver_dept_name)>
                            #attributes.deliver_loc_id#,
                        <cfelse>
                            NULL,
                        </cfif>
                        <cfif isdefined("attributes.ship_address") and len(attributes.ship_address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ship_address#"><cfelse>NULL</cfif>,
                        <cfif isDefined("attributes.ship_address_id") and len(attributes.ship_address_id)>#attributes.ship_address_id#<cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.ship_address_city_id") and len(attributes.ship_address_city_id)>#attributes.ship_address_city_id#<cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.ship_address_county_id") and len(attributes.ship_address_county_id)>#attributes.ship_address_county_id#<cfelse>NULL</cfif>,
                        <cfif isDefined("attributes.INVISIBLE")>
                            1,
                        <cfelse>
                            0,
                        </cfif>
                        <cfif len(attributes.publishdate)>
                            #attributes.publishdate#,
                        <cfelse>
                            NULL,
                        </cfif>
                        <cfif isdefined('attributes.basket_money')>
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.basket_money#">,
                            #((attributes.basket_net_total*attributes.basket_rate1)/attributes.basket_rate2)#,
                        </cfif>
                        <cfif isdefined('attributes.tax')>
                            #attributes.tax#,
                        </cfif>
                        <cfif isDefined("INCLUDED_KDV")>
                            1,
                        <cfelse>
                            0,
                        </cfif>
                        <cfif isDefined('attributes.RESERVED')>1<cfelse>0</cfif>,
                        <cfif len(attributes.ship_method_id)>#attributes.ship_method_id#<cfelse>NULL</cfif>,			
                        <cfif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>
                            #attributes.project_id#,
                        <cfelse>
                            NULL,
                        </cfif>
                        <cfif isdefined("attributes.catalog_id") and len(attributes.catalog_id) and len(attributes.catalog_name)>
                            #attributes.catalog_id#,
                        <cfelse>
                            NULL,
                        </cfif>
                            #attributes.basket_tax_total#,
                            #attributes.basket_discount_total#,
                            #attributes.basket_gross_total#,
                        <cfif isdefined("attributes.order_employee_id") and len(attributes.order_employee_id)>#attributes.order_employee_id#<cfelse>NULL</cfif>, 
                        <cfif isdefined("order_due_date") and len(order_due_date)>#order_due_date#<cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.ref_no") and len(attributes.ref_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ref_no#"><cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id)>
                            #attributes.card_paymethod_id#,
                            <cfif isdefined("attributes.commission_rate") and len(attributes.commission_rate)>
                                #attributes.commission_rate#,
                            <cfelse>
                                NULL,
                            </cfif>
                        <cfelse>
                            NULL,
                            NULL,
                        </cfif>
                        <cfif isdefined("attributes.work_id") and len(trim(attributes.work_id))>#attributes.work_id#<cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.is_foreign")>1<cfelse>0</cfif>,
                            #now()#,
                            #session.ep.userid#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
                            <cfif (isdefined('attributes.contract_no') and len(attributes.contract_no)) and isdefined('attributes.contract_id') and len(attributes.contract_id)>#attributes.contract_id#<cfelse>NULL</cfif>,
                            <cfif isdefined("attributes.PROCESS_CAT") and len(attributes.PROCESS_CAT)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PROCESS_CAT#"><cfelse>NULL</cfif>,	
                            <cfif isdefined("attributes.genel_indirim") and len(attributes.genel_indirim)>#attributes.genel_indirim#<cfelse>NULL</cfif>
                    )
                    </cfquery>

                    <cfquery name="GET_ORDER" datasource="#new_dsn3_group_pur#">
                        SELECT MAX(ORDER_ID) AS ORDER_ID FROM ORDERS WHERE WRK_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_id#">
                    </cfquery>

                    <cfif (isdefined('attributes.contract_no') and len(attributes.contract_no)) and isdefined('attributes.contract_id') and len(attributes.contract_id)>
                        <cfquery name="get_contracts" datasource="#new_dsn3_group_pur#">
                            SELECT ORDER_ID FROM RELATED_CONTRACT WHERE CONTRACT_ID = #attributes.contract_id#
                        </cfquery>
                        <cfset new_related_id	= '#get_contracts.ORDER_ID##GET_ORDER.ORDER_ID#,' />
                        <cfquery datasource="#new_dsn3_group_pur#">
                            UPDATE RELATED_CONTRACT SET ORDER_ID = '#new_related_id#' WHERE CONTRACT_ID = #attributes.contract_id#
                        </cfquery>
                    </cfif>

                    <cfif attributes.rows_ neq 0>
                        <cfloop from="1" to="#attributes.rows_#" index="i">
                            <cf_date tarih="attributes.deliver_date#i#">
                            <cf_date tarih="attributes.reserve_date#i#">
                            <cfif session.ep.our_company_info.spect_type and isdefined('attributes.is_production#i#') and evaluate('attributes.is_production#i#') eq 1 and not (isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#')))>
                                <cfset dsn_type=new_dsn3_group_pur>
                                <cfinclude template="../../objects/query/add_basket_spec.cfm">
                            </cfif>
                            <cfquery name="ADD_ORDER_ROW_" datasource="#new_dsn3_group_pur#">
                                INSERT INTO 
                                    ORDER_ROW 	 
                                    (
                                    ORDER_ID,
                                    ROW_INTERNALDEMAND_ID,
                                    RELATED_INTERNALDEMAND_ROW_ID,
                                    ROW_PRO_MATERIAL_ID,
                                    STOCK_ID,
                                    PRODUCT_ID,
                                    PRODUCT_NAME,
                                    QUANTITY,
                                <cfif isdefined('attributes.price#i#') and  len(evaluate('attributes.price#i#'))>
                                    PRICE,
                                </cfif>
                                    TAX,
                                    UNIT,
                                    UNIT_ID,
                                    DELIVER_DATE,
                                    DELIVER_DEPT,
                                    DELIVER_LOCATION,
                                    DISCOUNT_1,
                                    DISCOUNT_2,
                                    DISCOUNT_3,
                                    DISCOUNT_4,
                                    DISCOUNT_5,						
                                    DISCOUNT_6,
                                    DISCOUNT_7,
                                    DISCOUNT_8,
                                    DISCOUNT_9,
                                    DISCOUNT_10,						
                                    OTHER_MONEY,
                                    OTHER_MONEY_VALUE,
                                <cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
                                    SPECT_VAR_ID,
                                    SPECT_VAR_NAME,
                                </cfif>
                                    LOT_NO,
                                    PRICE_OTHER,
                                    NETTOTAL,
                                    IS_PROMOTION,
                                    DISCOUNT_COST,
                                    ORDER_ROW_CURRENCY,
                                    RESERVE_TYPE,
                                    RESERVE_DATE,
                                    EXTRA_COST,
                                    UNIQUE_RELATION_ID,
                                    PROM_RELATION_ID,
                                    PRODUCT_NAME2,
                                    AMOUNT2,
                                    UNIT2,
                                    EXTRA_PRICE,
                                    EK_TUTAR_PRICE,<!--- iscilik birim ücreti --->
                                    EXTRA_PRICE_TOTAL,
                                    EXTRA_PRICE_OTHER_TOTAL,
                                    SHELF_NUMBER,
                                    PRODUCT_MANUFACT_CODE,
                                    BASKET_EXTRA_INFO_ID,
                                    SELECT_INFO_EXTRA,
                                    DETAIL_INFO_EXTRA,
                                    BASKET_EMPLOYEE_ID,
                                    LIST_PRICE,
                                    PRICE_CAT,
                                    CATALOG_ID,
                                    NUMBER_OF_INSTALLMENT,
                                    DUEDATE,
                                    KARMA_PRODUCT_ID,
                                    OTV_ORAN,
                                    OTVTOTAL,
                                    WRK_ROW_ID,
                                    WRK_ROW_RELATION_ID,
                                    RELATED_ACTION_ID,
                                    RELATED_ACTION_TABLE,
                                    WIDTH_VALUE,
                                    DEPTH_VALUE,
                                    HEIGHT_VALUE,
                                    ROW_PROJECT_ID,
                                    ROW_WORK_ID,
                                    DESCRIPTION
                                    <cfif isdefined('attributes.row_exp_center_id#i#') and len(evaluate("attributes.row_exp_center_id#i#")) and isdefined('attributes.row_exp_center_name#i#') and len(evaluate("attributes.row_exp_center_name#i#"))>,EXPENSE_CENTER_ID</cfif>
                                    <cfif isdefined('attributes.row_exp_item_id#i#') and len(evaluate("attributes.row_exp_item_id#i#")) and isdefined('attributes.row_exp_item_name#i#') and len(evaluate("attributes.row_exp_item_name#i#"))>,EXPENSE_ITEM_ID</cfif>
                                    <cfif isdefined('attributes.row_activity_id#i#') and len(evaluate("attributes.row_activity_id#i#"))>,ACTIVITY_TYPE_ID</cfif>
                                    <cfif isdefined('attributes.row_acc_code#i#') and len(evaluate("attributes.row_acc_code#i#"))>,ACC_CODE</cfif>
                                    <cfif isdefined('attributes.row_bsmv_rate#i#') and len(evaluate("attributes.row_bsmv_rate#i#"))>,BSMV_RATE</cfif>
                                    <cfif isdefined('attributes.row_bsmv_amount#i#') and len(evaluate("attributes.row_bsmv_amount#i#"))>,BSMV_AMOUNT</cfif>
                                    <cfif isdefined('attributes.row_bsmv_currency#i#') and len(evaluate("attributes.row_bsmv_currency#i#"))>,BSMV_CURRENCY</cfif>
                                    <cfif isdefined('attributes.row_oiv_rate#i#') and len(evaluate("attributes.row_oiv_rate#i#"))>,OIV_RATE</cfif>
                                    <cfif isdefined('attributes.row_oiv_amount#i#') and len(evaluate("attributes.row_oiv_amount#i#"))>,OIV_AMOUNT</cfif>
                                    <cfif isdefined('attributes.row_tevkifat_rate#i#') and len(evaluate("attributes.row_tevkifat_rate#i#"))>,TEVKIFAT_RATE</cfif>
                                    <cfif isdefined('attributes.row_tevkifat_amount#i#') and len(evaluate("attributes.row_tevkifat_amount#i#"))>,TEVKIFAT_AMOUNT</cfif>
                                    )
                                VALUES 
                                    (
                                    #GET_ORDER.ORDER_ID#,
                                    <cfif isdefined('attributes.internaldemand_id_list') and len(attributes.internaldemand_id_list) and isdefined("attributes.row_ship_id#i#") and len(evaluate('attributes.row_ship_id#i#')) and listfirst(evaluate('attributes.row_ship_id#i#'),';') neq 0>#listfirst(evaluate('attributes.row_ship_id#i#'),';')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.internaldemand_id_list') and len(attributes.internaldemand_id_list) and isdefined("attributes.row_ship_id#i#") and listlen(evaluate('attributes.row_ship_id#i#'),";") eq 2 and len(listgetat(evaluate('attributes.row_ship_id#i#'),2,';'))>#listgetat(evaluate('attributes.row_ship_id#i#'),2,';')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.pro_material_id_list') and len(attributes.pro_material_id_list) and isdefined("attributes.row_ship_id#i#") and len(evaluate('attributes.row_ship_id#i#')) and listfirst(evaluate('attributes.row_ship_id#i#'),';') neq 0>#listfirst(evaluate('attributes.row_ship_id#i#'),';')#<cfelse>NULL</cfif>,
                                        #evaluate("attributes.stock_id#i#")#,
                                        #evaluate("attributes.product_id#i#")#,
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.product_name#i#')#">,
                                        #evaluate("attributes.amount#i#")#,
                                    <cfif isdefined('attributes.price#i#') and len(evaluate('attributes.price#i#'))>
                                        #evaluate('attributes.price#i#')#,
                                    </cfif>
                                        #evaluate("attributes.tax#i#")#,
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit#i#')#">,
                                        #evaluate("attributes.unit_id#i#")#,
                                    <cfif isdefined("x_apply_deliverdate_to_rows") and x_apply_deliverdate_to_rows eq 1 and not (isdefined("attributes.deliver_date#i#") and len(evaluate('attributes.deliver_date#i#')))>
                                        <cfif len(attributes.deliverdate)>#attributes.deliverdate#<cfelse>NULL</cfif>,
                                    <cfelse>                    
                                        <cfif isdefined("attributes.deliver_date#i#") and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
                                    </cfif>                            
                                    <cfif isdefined("attributes.deliver_dept#i#") and len(trim(evaluate("attributes.deliver_dept#i#"))) and len(listfirst(evaluate("attributes.deliver_dept#i#"),"-"))>
                                        #listfirst(evaluate("attributes.deliver_dept#i#"),"-")#,
                                    <cfelseif len(attributes.deliver_dept_id)>
                                        #attributes.deliver_dept_id#,						
                                    <cfelse>
                                        NULL,
                                    </cfif>
                                    <cfif isdefined("attributes.deliver_dept#i#") and listlen(trim(evaluate("attributes.deliver_dept#i#")),"-") eq 2 and len(listlast(evaluate("attributes.deliver_dept#i#"),"-"))>
                                        #listlast(evaluate("attributes.deliver_dept#i#"),"-")#,
                                    <cfelseif len(attributes.deliver_loc_id)>
                                        #attributes.deliver_loc_id#,
                                    <cfelse>
                                        NULL,
                                    </cfif>
                                    <cfif isdefined('attributes.indirim1#i#')>#evaluate('attributes.indirim1#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.indirim2#i#')>#evaluate('attributes.indirim2#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.indirim3#i#')>#evaluate('attributes.indirim3#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.indirim4#i#')>#evaluate('attributes.indirim4#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.indirim5#i#')>#evaluate('attributes.indirim5#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.indirim6#i#')>#evaluate('attributes.indirim6#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.indirim7#i#')>#evaluate('attributes.indirim7#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.indirim8#i#')>#evaluate('attributes.indirim8#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.indirim9#i#')>#evaluate('attributes.indirim9#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.indirim10#i#')>#evaluate('attributes.indirim10#i#')#<cfelse>NULL</cfif>,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.other_money_#i#')#">,
                                    <cfif isdefined("attributes.other_money_value_#i#") and  len(evaluate("attributes.other_money_value_#i#"))>#evaluate("attributes.other_money_value_#i#")#<cfelse>1</cfif>,
                                    <cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
                                        #evaluate('attributes.spect_id#i#')#,
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#left(evaluate('attributes.spect_name#i#'),500)#">,
                                    </cfif>
                                    <cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.price_other#i#') and len(evaluate('attributes.price_other#i#'))>#evaluate("attributes.price_other#i#")#<cfelse>NULL</cfif>,
                                    <cfif isdefined("attributes.row_nettotal#i#") and len(evaluate("attributes.row_nettotal#i#"))>#evaluate("attributes.row_nettotal#i#")#<cfelse>NULL</cfif>,
                                        0,
                                    <cfif isdefined('attributes.iskonto_tutar#i#') and len(evaluate('attributes.iskonto_tutar#i#'))>#evaluate('attributes.iskonto_tutar#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined("attributes.order_currency#i#") and len(evaluate("attributes.order_currency#i#"))>#evaluate("attributes.order_currency#i#")#<cfelse>-1</cfif>,
                                    <cfif isdefined("attributes.reserve_type#i#") and len(evaluate("attributes.reserve_type#i#")) and isdefined("attributes.order_currency#i#") and len(evaluate("attributes.order_currency#i#")) and evaluate("attributes.order_currency#i#") eq -9>-3<cfelseif isdefined("attributes.reserve_type#i#") and len(evaluate("attributes.reserve_type#i#"))>#evaluate("attributes.reserve_type#i#")#<cfelse>-1</cfif>,
                                    <cfif isdefined("attributes.reserve_date#i#") and len(evaluate("attributes.reserve_date#i#"))>#evaluate("attributes.reserve_date#i#")#<cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.extra_cost#i#') and len(evaluate('attributes.extra_cost#i#'))>#evaluate('attributes.extra_cost#i#')#<cfelse>0</cfif>,
                                    <cfif isdefined('attributes.row_unique_relation_id#i#') and len(evaluate('attributes.row_unique_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.row_unique_relation_id#i#')#"><cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.prom_relation_id#i#') and len(evaluate('attributes.prom_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.prom_relation_id#i#')#"><cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.product_name_other#i#')#"><cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit_other#i#')#"><cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.ek_tutar#i#') and len(evaluate('attributes.ek_tutar#i#'))>#evaluate('attributes.ek_tutar#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.ek_tutar_price#i#') and len(evaluate('attributes.ek_tutar_price#i#'))>#evaluate('attributes.ek_tutar_price#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.ek_tutar_total#i#') and len(evaluate('attributes.ek_tutar_total#i#'))>#evaluate('attributes.ek_tutar_total#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.ek_tutar_other_total#i#') and len(evaluate('attributes.ek_tutar_other_total#i#'))>#evaluate('attributes.ek_tutar_other_total#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.manufact_code#i#')#"><cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.basket_extra_info#i#') and len(evaluate('attributes.basket_extra_info#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.basket_extra_info#i#')#"><cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.select_info_extra#i#') and len(evaluate('attributes.select_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.select_info_extra#i#')#"><cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.detail_info_extra#i#') and len(evaluate('attributes.detail_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.detail_info_extra#i#')#"><cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.basket_employee_id#i#') and len(evaluate('attributes.basket_employee_id#i#')) and isdefined('attributes.basket_employee#i#') and len(evaluate('attributes.basket_employee#i#'))>#evaluate('attributes.basket_employee_id#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.list_price#i#') and len(evaluate('attributes.list_price#i#'))>#evaluate('attributes.list_price#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.price_cat#i#') and len(evaluate('attributes.price_cat#i#'))>#evaluate('attributes.price_cat#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.row_catalog_id#i#') and len(evaluate('attributes.row_catalog_id#i#'))>#evaluate('attributes.row_catalog_id#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.number_of_installment#i#') and len(evaluate('attributes.number_of_installment#i#'))>#evaluate('attributes.number_of_installment#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined("attributes.duedate#i#") and len(evaluate("attributes.duedate#i#"))>#evaluate("attributes.duedate#i#")#<cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.karma_product_id#i#') and len(evaluate('attributes.karma_product_id#i#'))>#evaluate('attributes.karma_product_id#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.otv_oran#i#') and len(evaluate('attributes.otv_oran#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.otv_oran#i#')#"><cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.row_otvtotal#i#') and len(evaluate('attributes.row_otvtotal#i#'))>#evaluate('attributes.row_otvtotal#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.wrk_row_id#i#')#"><cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.wrk_row_relation_id#i#')#"><cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.related_action_id#i#') and len(evaluate('attributes.related_action_id#i#'))>#evaluate('attributes.related_action_id#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.related_action_table#i#') and len(evaluate('attributes.related_action_table#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.related_action_table#i#')#"><cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.row_project_id#i#') and len(evaluate('attributes.row_project_id#i#')) and isdefined('attributes.row_project_name#i#') and len(evaluate('attributes.row_project_name#i#'))>#evaluate('attributes.row_project_id#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.row_work_id#i#') and len(evaluate('attributes.row_work_id#i#')) and isdefined('attributes.row_work_name#i#') and len(evaluate('attributes.row_work_name#i#'))>#evaluate('attributes.row_work_id#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.description#i#') and len(evaluate('attributes.description#i#'))>'#evaluate('attributes.description#i#')#'<cfelse>NULL</cfif> 
                                    <cfif isdefined('attributes.row_exp_center_id#i#') and len(evaluate("attributes.row_exp_center_id#i#")) and isdefined('attributes.row_exp_center_name#i#') and len(evaluate("attributes.row_exp_center_name#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_exp_center_id#i#')#"></cfif>
                                    <cfif isdefined('attributes.row_exp_item_id#i#') and len(evaluate("attributes.row_exp_item_id#i#")) and isdefined('attributes.row_exp_item_name#i#') and len(evaluate("attributes.row_exp_item_name#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_exp_item_id#i#')#"></cfif>
                                    <cfif isdefined('attributes.row_activity_id#i#') and len(evaluate("attributes.row_activity_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_activity_id#i#')#"></cfif>
                                    <cfif isdefined('attributes.row_acc_code#i#') and len(evaluate("attributes.row_acc_code#i#"))>,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate('attributes.row_acc_code#i#')#"></cfif>
                                    <cfif isdefined('attributes.row_bsmv_rate#i#') and len(evaluate("attributes.row_bsmv_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_rate#i#')#"></cfif>
                                    <cfif isdefined('attributes.row_bsmv_amount#i#') and len(evaluate("attributes.row_bsmv_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_amount#i#')#"></cfif>
                                    <cfif isdefined('attributes.row_bsmv_currency#i#') and len(evaluate("attributes.row_bsmv_currency#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_currency#i#')#"></cfif>
                                    <cfif isdefined('attributes.row_oiv_rate#i#') and len(evaluate("attributes.row_oiv_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_oiv_rate#i#')#"></cfif>
                                    <cfif isdefined('attributes.row_oiv_amount#i#') and len(evaluate("attributes.row_oiv_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_oiv_amount#i#')#"></cfif>
                                    <cfif isdefined('attributes.row_tevkifat_rate#i#') and len(evaluate("attributes.row_tevkifat_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_tevkifat_rate#i#')#"></cfif>
                                    <cfif isdefined('attributes.row_tevkifat_amount#i#') and len(evaluate("attributes.row_tevkifat_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_tevkifat_amount#i#')#"></cfif>
                                    )
                            </cfquery>

                        <cfquery name="get_max_order_row" datasource="#new_dsn3_group_pur#">
                            SELECT MAX(ORDER_ROW_ID) AS ORDER_ROW_ID FROM ORDER_ROW
                        </cfquery>
                        <cfif isdefined('attributes.related_action_id#i#') and Evaluate('attributes.related_action_id#i#') gt 0 and isdefined('attributes.wrk_row_relation_id#i#') and Evaluate('attributes.wrk_row_relation_id#i#') gt 0>
                            <cfscript>
                                add_relation_rows(
                                    action_type:'add',
                                    action_dsn : '#new_dsn3_group_pur#',
                                    to_table:'ORDERS',
                                    from_table:'#evaluate("attributes.RELATED_ACTION_TABLE#i#")#',
                                    to_wrk_row_id : Evaluate("attributes.wrk_row_id#i#"),
                                    from_wrk_row_id :Evaluate("attributes.wrk_row_relation_id#i#"),
                                    amount : Evaluate("attributes.amount#i#"),
                                    to_action_id : GET_ORDER.ORDER_ID,
                                    from_action_id :Evaluate("attributes.related_action_id#i#")
                                    );
                            </cfscript>
                        </cfif>
                        <cfset attributes.ROW_MAIN_ID = get_max_order_row.ORDER_ROW_ID>
                        <cfset row_id = i>
                        <cfset ACTION_TYPE_ID = 2>
                        <cfset attributes.product_id = evaluate("attributes.product_id#i#")>
                        <cfset assortment_textilte = add_assortment_textile(row_id : row_id, action_type_id : ACTION_TYPE_ID)>

                        <cfinclude template="../query/add_department_information.cfm">
                            <!--- bütçe rezerve kontrolü --->
                            <cfif isdefined('attributes.process_cat') and len(attributes.process_cat) and isdefined("get_type.IS_BUDGET_RESERVED_CONTROL") and get_type.IS_BUDGET_RESERVED_CONTROL eq 1>
                                <cfif isdefined('attributes.other_money_value_#i#') and len(evaluate("attributes.other_money_value_#i#"))>
                                    <cfset other_money_val = evaluate('attributes.other_money_value_#i#')>
                                <cfelse>
                                    <cfset other_money_val = ''>
                                </cfif>
                                <cfif isdefined('attributes.other_money_#i#') and len(evaluate("attributes.other_money_#i#"))>
                                    <cfset other_money = evaluate('attributes.other_money_#i#')>
                                <cfelse>
                                    <cfset other_money = ''>
                                </cfif>
                                <cfscript>
                                    butceci(
                                    action_id : GET_ORDER.ORDER_ID,
                                    muhasebe_db : dsn3,
                                    is_income_expense : true,
                                    process_type : get_type.process_type,
                                    product_tax: evaluate("attributes.tax#i#"),//kdv
                                    stock_id: evaluate("attributes.stock_id#i#"),
                                    product_id: evaluate("attributes.product_id#i#"),
                                    nettotal : wrk_round(evaluate("attributes.row_nettotal#i#")),
                                    other_money_value : other_money_val,
                                    action_currency : other_money,
                                    currency_multiplier : attributes.currency_multiplier,
                                    expense_date : attributes.order_date,
                                    expense_center_id : iif((isdefined("attributes.row_exp_center_id#i#") and len(evaluate('attributes.row_exp_center_id#i#'))),evaluate("attributes.row_exp_center_id#i#"),0),
                                    expense_item_id : iif((isdefined("attributes.row_exp_item_id#i#") and len(evaluate('attributes.row_exp_item_id#i#'))),evaluate("attributes.row_exp_item_id#i#"),0),
                                    detail : '#paper_full# Nolu Sipariş',
                                    paper_no : '#paper_full#',
                                    branch_id : ListGetAt(session.ep.user_location,2,"-"),
                                    discounttotal: iif((isdefined("attributes.genel_indirim") and len('attributes.genel_indirim')),"#attributes.genel_indirim#",0),
                                    reserv_type :1, //expense_reserved_rows tablosuna gelir olarak yazılsın.
                                    project_id: iif(isdefined("attributes.project_id") and len(attributes.project_id), "attributes.project_id", DE('')),
                                    activity_type : evaluate("attributes.row_activity_id#i#"),
                                    invoice_row_id:attributes.ROW_MAIN_ID
                                    );
                                </cfscript>
                            </cfif>
                        
                        </cfloop>	
                    </cfif>
                    <!--- referans satıs siparisiyle kaydedilen siparis arasındaki baglantı  PAPER_RELATION'da tutuluyor--->
                    <cfif isdefined('attributes.ref_paper_id') and len(attributes.ref_paper_id)>
                        <cfquery name="ADD_PAPER_RELATION" datasource="#new_dsn3_group_pur#">
                            INSERT INTO
                            #dsn_alias#.PAPER_RELATION
                                (
                                PAPER_ID,
                                PAPER_TABLE,
                                PAPER_TYPE_ID,
                                RELATED_PAPER_ID,
                                RELATED_PAPER_TABLE,
                                RELATED_PAPER_TYPE_ID,
                                COMP_ID,
                                PERIOD_ID
                                )
                            VALUES
                                (
                                #GET_ORDER.ORDER_ID#,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="ORDERS">,
                                1,
                                <cfif isdefined('attributes.pro_material_id') and len(attributes.pro_material_id)>
                                #attributes.pro_material_id#,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="PRO_MATERIAL">,
                                2,
                                <cfelse>
                                #attributes.ref_paper_id#,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="ORDERS">,
                                1,
                                </cfif>
                                #session.ep.company_id#,
                                #session.ep.period_id#
                                )
                        </cfquery>
                    </cfif>
                <cfscript>
                    basket_kur_ekle(action_id:GET_ORDER.ORDER_ID,table_type_id:3,process_type:0,basket_money_db:new_dsn3_group_pur);
                    add_reserve_row(
                        reserve_order_id:GET_ORDER.ORDER_ID,
                        reserve_action_type:0,
                        is_order_process:0,
                        is_purchase_sales:0,
                        process_db : new_dsn3_group_pur,
                        process_db_alias : "#new_dsn3_group_pur#."
                        );
                    if(isdefined('attributes.internaldemand_id_list') and len(attributes.internaldemand_id_list)) //siparis ic talepten olusturulacaksa
                    {
                        add_internaldemand_row_relation(
                            to_related_action_id:GET_ORDER.ORDER_ID,
                            to_related_action_type:0,
                            action_status:0
                            );
                    }
                    if(isdefined('attributes.pro_material_id_list') and len(attributes.pro_material_id_list)) //proje malzeme planı ile baglantısı olusturuluyor
                    {
                        add_paper_relation(
                            to_paper_id :GET_ORDER.ORDER_ID,
                            to_paper_table : 'ORDERS',
                            to_paper_type :1,
                            from_paper_table : 'PRO_MATERIAL',
                            from_paper_type :2,
                            relation_type : 1,
                            action_status:0
                            );
                    }
                </cfscript>
                <cfset last_order_id_pur = GET_ORDER.ORDER_ID>
                <cfif not isdefined("first_order_id_pur")>
                    <cfset first_order_id_pur = GET_ORDER.ORDER_ID>
                </cfif>
                <!---Ek Bilgiler--->
                <cfset attributes.info_id = my_result.IDENTITYCOL>
                <cfset attributes.is_upd = 0>
                <cfset attributes.info_type_id = -12>
                <cfinclude template="../../objects/query/add_info_plus2.cfm">
                <!---Ek Bilgiler--->
                <cf_workcube_process 
                    is_upd='1' 
                    data_source='#new_dsn3_group_pur#' 
                    old_process_line='0'
                    process_stage='#attributes.process_stage#' 
                    record_member='#session.ep.userid#' 
                    record_date='#now()#' 
                    action_table='ORDERS'
                    action_column='ORDER_ID'
                    action_id='#GET_ORDER.ORDER_ID#'
                    action_page='#request.self#?fuseaction=purchase.list_order&event=upd&order_id=#GET_ORDER.ORDER_ID#' 
                    warning_description="#getLang('','Sipariş',57611)# : #paper_full#">

                <cfif isdefined("attributes.process_cat") and len(attributes.process_cat)>
                    <cf_workcube_process_cat 
                        process_cat="#attributes.process_cat#"
                        action_id = "#GET_ORDER.ORDER_ID#"
                        action_table="ORDER"
                        action_column="ORDER_ID"
                        is_action_file = 1
                        action_page='#request.self#?fuseaction=purchase.list_order&event=upd&order_id=#GET_ORDER.ORDER_ID#'
                        action_file_name='#get_type.action_file_name#'
                        action_db_type = '#dsn3#'
                        is_template_action_file = '#get_type.action_file_from_template#'>
                </cfif>
                <cfset responseStruct.message = "İşlem Başarılı">
                    <cfset responseStruct.status = true>
                    <cfset responseStruct.error = {}>
                    <cfset responseStruct.identity = GET_ORDER.ORDER_ID>
                <cfcatch type="database">
                    <cftransaction action="rollback">
                    <cfset responseStruct.message = "İşlem Hatalı">
                    <cfset responseStruct.status = false>
                    <cfset responseStruct.error = cfcatch>
                </cfcatch>	
            </cftry>
            </cftransaction>
        </cflock>
        <cfif isdefined('xml_import_pur')><cfset last_xml_import_pur = xml_import_pur></cfif>
        <cfif isdefined("last_order_id_pur") and not isdefined("last_xml_import_pur")>
            <cfscript>
                add_company_related_action(action_id:last_order_id_pur,action_type:2);
            </cfscript>
        </cfif>
        <cfreturn responseStruct>
    </cffunction>

    <cffunction name="add_order_history" access="public" returntype="any" hint="Sipariş Tarihçe Kaydı">
        <cfargument name="order_id" required="true">
        <cfquery name="GET_ORDER" datasource="#DSN3#">
            SELECT * FROM ORDERS WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#">
        </cfquery>
        <cfquery name="GET_ORDER_ROW" datasource="#DSN3#">
            SELECT * FROM ORDER_ROW WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#">
        </cfquery>
        <cflock name="#CREATEUUID()#" timeout="20">
            <cftransaction>
                <cf_wrk_get_history datasource="#dsn3#" source_table="ORDERS" target_table="ORDERS_HISTORY" record_id= "#arguments.order_id#" record_name="ORDER_ID">
                <cfquery name="get_max_hist_id" datasource="#dsn3#">
                    SELECT MAX(ORDER_HISTORY_ID) MAX_ID FROM ORDERS_HISTORY
                </cfquery>
                <cf_wrk_get_history datasource="#dsn3#" source_table="ORDER_ROW" target_table="ORDER_ROW_HISTORY" insert_column_name="ORDER_HISTORY_ID" insert_column_value="#get_max_hist_id.MAX_ID#" record_id= "#valuelist(GET_ORDER_ROW.order_ROW_id)#" record_name="ORDER_ROW_ID">
            </cftransaction>
        </cflock>
        <cfreturn 1>
    </cffunction>

    <cffunction name="DEL_OFFER_ASSORT_ROWS" access="public" hint="Ürün Asortileri silinmesi">
        <cfargument name="order_id" required="true">
        <cfquery name="DEL_OFFER_ASSORT_ROWS" datasource="#DSN3#">
            DELETE FROM
                PRODUCTION_ASSORTMENT
            WHERE
                ACTION_TYPE = 2 AND 
                ASSORTMENT_ID IN ( SELECT ORDER_ROW_ID FROM ORDER_ROW WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#">)
        </cfquery>
    </cffunction>

    <cffunction name="add_assortment_textile" access="public" returntype="any" hint="Ürün Asortileri">
        <cfargument name="row_id" required="true">
        <cfargument name="action_type_id" required="true">
        <cfif isdefined("form.ASSORTMENT_#arguments.row_id#_COUNT")>
            <cfloop from="1" to="#evaluate("form.ASSORTMENT_#arguments.row_id#_COUNT")-1#" index="row_counter">
                <cfquery name="add_assortment" datasource="#dsn3#">
                    INSERT INTO 
                        PRODUCTION_ASSORTMENT	
                            (
                                ASSORTMENT_ID,
                                PARSE1,
                                PARSE2,
                                PROPERTY_ID1,
                                PROPERTY_ID2,									
                                AMOUNT,
                                ACTION_TYPE
                            )
                        VALUES
                            (
                                #attributes.ROW_MAIN_ID#,
                                #evaluate("form.ASSORTMENT_#arguments.row_id#_#row_counter#_1")#,
                                #evaluate("form.ASSORTMENT_#arguments.row_id#_#row_counter#_2")#,
                                1,
                                1,
                                #evaluate("form.ASSORTMENT_#arguments.row_id#_#row_counter#_3")#,
                                #arguments.action_type_id#
                            )
                </cfquery>
            </cfloop>
        </cfif>
    </cffunction>

    <cffunction name="del_order" access="public">
        <cfargument name="order_id" required="true">
        <cfset responseStruct = StructNew()>
        <cfset fusebox.circuit = listFirst(arguments.fuseaction,'.')>
        <cfset fusebox.fuseaction = listLast(arguments.fuseaction,'.')>

        <cfset del_asset = this.del_asset(action_id : arguments.order_id, action_section : 'ORDER_ID')>

        <cflock name="#CreateUUID()#" timeout="20">
            <cftransaction>
                <cftry>
                    <!---sipariş silindiğinde parçalı cari ödeme planı sablonu silinir --->
                    <cfquery name="DEL_PAYMENT_PLANS" datasource="#dsn3#">
                        DELETE FROM ORDER_PAYMENT_PLAN_ROWS WHERE PAYMENT_PLAN_ID IN (ISNULL((SELECT PAYMENT_PLAN_ID FROM ORDER_PAYMENT_PLAN WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#">),0))
                    </cfquery>
                    <cfquery name="DEL_PAYMENT_PLANS" datasource="#dsn3#">
                        DELETE FROM ORDER_PAYMENT_PLAN WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#">
                    </cfquery>
                    <!---//sipariş silindiğinde parçalı cari ödeme planı sablonu silinir --->
                    <cfscript>
                        add_relation_rows(
                            action_type:'del',
                            action_dsn : '#dsn3#',
                            to_table:'ORDERS',
                            to_action_id : arguments.order_id
                            );
                    </cfscript>
                    <cfquery name="GET_ORD_DET" datasource="#dsn3#">
                        SELECT ORDER_ID,OFFER_ID,ORDER_HEAD,ORDER_NUMBER,ORDER_STAGE,PROCESS_CAT FROM ORDERS WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#">
                    </cfquery>
                    <cfif len(get_ord_det.offer_id) and get_ord_det.offer_id neq 0>
                        <cfquery name="UPD_OFFER_ST" datasource="#dsn3#">
                            UPDATE OFFER SET OFFER_CURRENCY = 1	WHERE OFFER_ID = #GET_ORD_DET.OFFER_ID#
                        </cfquery>
                    </cfif>
                    <cfif len(GET_ORD_DET.PROCESS_CAT)> <!--- bütçe rezerv işlemi siliniyor --->
                        <cfquery name="get_type" datasource="#dsn3#">
                            SELECT PROCESS_TYPE FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #GET_ORD_DET.PROCESS_CAT#
                        </cfquery>
                        <cfscript>
                            butce_sil(action_id:arguments.order_id,process_type:get_type.PROCESS_TYPE,muhasebe_db:dsn3,reserv_type:1);
                        </cfscript>
                    </cfif>
                    <!--- urun asortileri siliniyor	--->
                    <cfquery name="DEL_OFFER_ASSORT_ROWS" datasource="#DSN3#">
                        DELETE FROM
                            PRODUCTION_ASSORTMENT
                        WHERE
                            ACTION_TYPE = 2 AND 
                            ASSORTMENT_ID IN (
                                                SELECT
                                                    ORDER_ROW_ID 
                                                FROM
                                                    ORDER_ROW
                                                WHERE
                                                    ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#">
                                                )
                    </cfquery>
                    <cfquery name="DEL_ORDER_ROW_DEPARTMENTS" datasource="#dsn3#">
                        DELETE FROM ORDER_ROW_DEPARTMENTS WHERE 
                                    ORDER_ROW_ID IN (
                                            SELECT 
                                                ORDER_ROW.ORDER_ROW_ID
                                            FROM 
                                                ORDER_ROW,
                                                ORDERS
                                            WHERE 	
                                                ORDERS.ORDER_ID = ORDER_ROW.ORDER_ID AND 
                                                ORDERS.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#">)
                    </cfquery>
                    <cfquery name="DEL_PAPER_RELATION" datasource="#dsn3#">
                        DELETE FROM
                            #dsn_alias#.PAPER_RELATION
                        WHERE 
                            PAPER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#"> AND
                            PAPER_TABLE = 'ORDERS' AND
                            PAPER_TYPE_ID = 1
                    </cfquery>
                    <!--- siparis satır rezerveleri siliniyor --->
                    <cfquery name="DEL_ORDER_RESERVE" datasource="#dsn3#">
                        DELETE FROM ORDER_ROW_RESERVED WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#"> AND SHIP_ID IS NULL
                    </cfquery>
                    <!--- siparis iç talep baglantısı sililiniyor --->
                    <cfquery name="DEL_ORDER_RESERVE" datasource="#dsn3#">
                        DELETE FROM INTERNALDEMAND_RELATION_ROW WHERE TO_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#">
                    </cfquery>
                    <cfquery name="DEL_ORDER_ROW" datasource="#dsn3#">
                        DELETE FROM ORDER_ROW WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#">
                    </cfquery>
                    <cfquery name="DEL_ORDER" datasource="#dsn3#">
                        DELETE FROM ORDERS WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#">
                    </cfquery>

                    <!--- History Kayitlari Silinir --->
                    <cfquery name="Del_History_Row" datasource="#dsn3#">
                        DELETE FROM ORDER_ROW_HISTORY WHERE ORDER_HISTORY_ID IN (SELECT ORDER_HISTORY_ID FROM ORDERS_HISTORY WHERE ORDERS_HISTORY.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#">)
                    </cfquery>
                    <cfquery name="Del_History" datasource="#dsn3#">
                        DELETE FROM ORDERS_HISTORY WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#">
                    </cfquery>
                    <!--- Belge Silindiginde Bagli Uyari/Onaylar Da Silinir --->
                    <cfquery name="Del_Relation_Warnings" datasource="#dsn3#">
                        DELETE FROM #dsn_alias#.PAGE_WARNINGS WHERE ACTION_TABLE = 'ORDERS' AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                    </cfquery>
                    <cf_add_log  log_type="-1" action_id="#arguments.order_id#" action_name="#get_ord_det.order_head#-#get_ord_det.order_number#" paper_no="#get_ord_det.order_number#" process_stage="#get_ord_det.order_stage#" data_source="#dsn3#">
                <cfset responseStruct.message = "İşlem Başarılı">
                <cfset responseStruct.status = true>
                <cfset responseStruct.error = {}>
                <cfset responseStruct.identity = ''>
                <cfcatch type="database">
                    <cftransaction action="rollback">
                    <cfset responseStruct.message = "İşlem Hatalı">
                    <cfset responseStruct.status = false>
                    <cfset responseStruct.error = cfcatch>
                </cfcatch>    
            </cftry>    
            </cftransaction>
        </cflock>
        <cfreturn responseStruct>
    </cffunction>

    <cffunction name="del_asset" returntype="any" access="public">
        <cfargument name="action_id" required="true">
        <cfargument name="action_section" required="true">
        <cfset path=''>
        <cfquery name="GET_ASSETS" datasource="#DSN#">
            SELECT
                ASSET.ASSET_FILE_NAME,
                ASSET.ASSET_FILE_SERVER_ID,
                ASSET.MODULE_NAME,
                ASSET.ASSET_ID,
                ASSET.ASSETCAT_ID,
                ASSET_CAT.ASSETCAT_PATH		
            FROM
                ASSET,
                ASSET_CAT
            WHERE
                ASSET.ACTION_SECTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#UCASE(arguments.action_section)#"> AND
                ASSET.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> AND
                ASSET.ASSETCAT_ID = ASSET_CAT.ASSETCAT_ID
        </cfquery>
        <cfoutput query="get_assets">
            <cfif ASSETCAT_ID gte 0>
                <cfset path = assetcat_path>
            </cfif>
            <cfif len(path)>
                <cfset folder="asset/#path#">
            <cfelse>
                <cfset folder="#assetcat_path#">
            </cfif>
                
            <cfquery name="CONTROL_" datasource="#DSN#">
                SELECT
                    ASSET_ID
                FROM
                    ASSET
                WHERE
                    ASSET_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#get_assets.asset_id#"> AND
                    ASSET_FILE_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#get_assets.asset_file_name#">
            </cfquery>
                
            <cfif control_.recordcount>
                <!--- dosya birden fazla varlik tarafindan kullanildigi icin silinmiyor --->
            <cfelse>
                <cf_del_server_file output_file="#folder#/#asset_file_name#" output_server="#asset_file_server_id#">
            </cfif>
        </cfoutput>

        <cfquery name="DEL_ASSETS" datasource="#DSN#">
            DELETE FROM
                ASSET
            WHERE
                ACTION_SECTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCASE(arguments.action_section)#"> AND
                ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
        </cfquery>
    </cffunction>

</cfcomponent>