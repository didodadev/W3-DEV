<!---
File: custom_export.cfc
Author: Workcube-Melek Kocabey<melekkocabey@workcube.com>
Date: 24.02.2020
Controller: -
Description: Dış Ticaret > İhracat - Gümrük İşlemleri component dosyasıdır.
--->
<cfcomponent extends="cfc.faFunctions">
    <cfscript>
		functions = CreateObject("component","WMO.functions");
		filterNum = functions.filterNum;
        wrk_round = functions.wrk_round;
        date_add = functions.date_add;
        TLFORMAT = functions.TLFORMAT;
        LISTDELETEDUPLICATES=functions.LISTDELETEDUPLICATES;
        sql_unicode = functions.sql_unicode;
        functions_ = CreateObject("component","cfc.faFunctions");
        muhasebeci = functions_.muhasebeci;
        cfquery = functions.cfquery;
	</cfscript>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn_alias = application.systemParam.systemParam().dsn>
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">
    <cfset user_domain = application.systemParam.systemParam().user_domain>
    <cfset dir_seperator = application.systemParam.systemParam().dir_seperator>
    <cfset dsn2 = '#dsn#_#session.ep.period_year#_#session.ep.company_id#'>
    <cfset request.self = application.systemParam.systemParam().request.self>
    <cffunction name="UPD_INVOICE_EXPORT" access="remote" returnformat="JSON" returntype="string">
        <cfargument name = "export_invoice_id" default="">
        <cfargument name = "detail_invoice" default="">
        <cfargument name = "invoice_stage" default="">
        <cfargument name = "realization_date" default="">
        <cfargument name = "fuseaction" default="">
        <cfargument name = "is_invoice_export_custom" default="">
        <cfif len(arguments.realization_date) and isDate(arguments.realization_date)>
            <cf_date tarih = 'arguments.realization_date'>
        </cfif>
        <cfset status = true>
        <cftry>
            <cflock name="#CreateUUID()#" timeout="20">
                <cftransaction>
                    <cfquery name="UPD_INVOICE_EXPORT" datasource="#dsn2#">
                        UPDATE
                            INVOICE
                        SET 
                            NOTE = <cfif len(arguments.detail_invoice)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detail_invoice#"><cfelse>NULL</cfif>,
                            PROCESS_STAGE = <cfif len(arguments.invoice_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.invoice_stage#"><cfelse>NULL</cfif>,
                            REALIZATION_DATE = <cfif len(arguments.realization_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.realization_date#"><cfelse>NULL</cfif>
                        WHERE
                            INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.export_invoice_id#">
                    </cfquery>
                    <cfquery name="get_invoice" datasource="#dsn2#">
                        SELECT INVOICE_NUMBER,PROCESS_CAT FROM INVOICE WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.export_invoice_id#">
                    </cfquery>
                    <cfset attributes.fuseaction = arguments.fuseaction>
                    <cfset FUSEBOX.PROCESS_TREE_CONTROL = application.systemParam.systemParam().fusebox.process_tree_control>
                    <cf_workcube_process 
                        is_upd='1' 
                        data_source='#dsn2#' 
                        process_stage='#arguments.invoice_stage#' 
                        old_process_line='#arguments.old_process_line#'
                        record_member='#session.ep.userid#'
                        record_date='#now()#' 
                        action_table='INVOICE'
                        action_column='INVOICE_ID'
                        action_id='#arguments.export_invoice_id#' 
                        action_page='index.cfm?fuseaction=invoice.list_bill_FTexport&event=det&export_invoice_id=#arguments.export_invoice_id#' 
                        warning_description='İhracat-Gümrük : #get_invoice.invoice_number#'>                    
                </cftransaction>
            </cflock><!--- Muhasebe Fişi Kes --->
            <cfif len(arguments.is_invoice_export_custom) and arguments.is_invoice_export_custom eq 1>
                <cfquery name="get_invoice_row" datasource="#dsn2#">
                    SELECT PRODUCT_ID,* FROM INVOICE_ROW WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.export_invoice_id#">
                </cfquery>
                <cfset acc_product_list=listsort(valuelist(get_invoice_row.PRODUCT_ID),'numeric','asc')>
                <cfquery name="product_account_codes" datasource="#dsn3#">
                    SELECT 
                        ACCOUNT_YURTDISI_PUR,
                        ACCOUNT_YURTDISI,
                        OUTGOING_STOCK,
                        INCOMING_STOCK
                    FROM 
                        PRODUCT_PERIOD
                    WHERE
                        PRODUCT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#acc_product_list#" list="yes">)
                        <cfif isDefined('session.ep')>
                            AND	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
                        <cfelseif isDefined('session.pp')>
                            AND	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.period_id#">
                        <cfelseif isDefined('session.ww')>
                            AND	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.period_id#">
                        </cfif>
                </cfquery>
                <cfquery name="get_acc_card" datasource="#dsn2#">
        	SELECT * FROM ACCOUNT_CARD WHERE ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="531"> and ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.export_invoice_id#">
        </cfquery>
     	<cfif get_acc_card.recordcount>
            <cfquery name="get_acc_rows" datasource="#dsn2#">
            	SELECT * FROM ACCOUNT_CARD_ROWS WHERE CARD_ID = #get_acc_card.card_id#
            </cfquery>
            <cfquery name="get_process_cat" datasource="#dsn2#">
            	SELECT IS_ACCOUNT_GROUP FROM #dsn3#.SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #get_acc_card.action_cat_id#
            </cfquery>
            <cfquery name="GET_NO_" datasource="#dsn2#">
                SELECT * FROM #dsn3#.SETUP_INVOICE SETUP_INVOICE
            </cfquery>
            <cfscript>
				if(get_acc_rows.amount gt 0 and get_acc_rows.amount_2 gt 0)
					currency_multiplier = get_acc_rows.amount/get_acc_rows.amount_2;
				else
					currency_multiplier = 1;
            	str_borclu_hesaplar="";
            	str_borclu_tutarlar="";
            	str_dovizli_borclar="";
            	str_other_currency_borc="";
				acc_project_list_borc="";
            	str_alacakli_hesaplar="";
            	str_alacakli_tutarlar="";
            	str_dovizli_alacaklar="";
            	str_other_currency_alacak="";
				acc_project_list_alacak="";
				satir_detay_list = ArrayNew(2);
				str_borc_miktar = ArrayNew(1);
				str_borc_tutar = ArrayNew(1);
            </cfscript>
            <cfoutput query="get_acc_rows">
				<cfscript>
                	if(get_acc_rows.ba eq 1)
					{
						str_borclu_hesaplar=listappend(str_borclu_hesaplar,product_account_codes.OUTGOING_STOCK);
						str_borclu_tutarlar=listappend(str_borclu_tutarlar,amount);
						str_dovizli_borclar=listappend(str_dovizli_borclar,other_amount);
						str_other_currency_borc=listappend(str_other_currency_borc,other_currency);
						str_borc_miktar[listlen(str_borclu_tutarlar)]=quantity;
						str_borc_tutar[listlen(str_borclu_tutarlar)]=price;
						acc_project_list_borc=listappend(acc_project_list_borc,acc_project_id);
						satir_detay_list[1][listlen(str_borclu_tutarlar)] = "#detail#";
					}
					else
					{
						str_alacakli_hesaplar=listappend(str_alacakli_hesaplar,product_account_codes.ACCOUNT_YURTDISI);
						str_alacakli_tutarlar=listappend(str_alacakli_tutarlar,amount);
						str_dovizli_alacaklar=listappend(str_dovizli_alacaklar,other_amount);
						str_other_currency_alacak=listappend(str_other_currency_alacak,other_currency);
						acc_project_list_alacak=listappend(acc_project_list_alacak,acc_project_id);
						satir_detay_list[2][listlen(str_alacakli_tutarlar)] = "#detail#";
					}
                </cfscript>
			</cfoutput>
            <cfscript>
				str_fark_gelir =GET_NO_.FARK_GELIR;
				str_fark_gider =GET_NO_.FARK_GIDER;
				str_max_round = 0.5;
				str_round_detail = get_acc_rows.detail;
            	muhasebeci(
					wrk_id : get_acc_card.wrk_id,
					action_id : get_acc_card.action_id,
					workcube_process_type : get_acc_card.action_type,
					workcube_process_cat:get_acc_card.action_cat_id,
					account_card_type : 13,
					company_id : get_acc_card.acc_company_id,
					consumer_id : get_acc_card.acc_consumer_id,
					islem_tarihi : arguments.realization_date,
					borc_hesaplar : str_borclu_hesaplar,
					borc_tutarlar : str_borclu_tutarlar,
					other_amount_borc : str_dovizli_borclar,
					other_currency_borc : str_other_currency_borc,
					alacak_hesaplar : str_alacakli_hesaplar,
					alacak_tutarlar : str_alacakli_tutarlar,
					other_amount_alacak : str_dovizli_alacaklar,
					other_currency_alacak :str_other_currency_alacak,
					borc_miktarlar : str_borc_miktar,
					borc_birim_tutar : str_borc_tutar,
					from_branch_id : get_acc_rows.acc_branch_id,
					acc_department_id : get_acc_rows.acc_department_id,
					fis_detay : "#get_acc_card.CARD_DETAIL#",
					fis_satir_detay : satir_detay_list,
					decleration_no : get_acc_card.paper_no,
					is_account_group : get_process_cat.is_account_group,
					currency_multiplier : currency_multiplier,
					dept_round_account :str_fark_gider,
					claim_round_account : str_fark_gelir,
					max_round_amount :str_max_round,
					round_row_detail:str_round_detail,
					acc_project_list_alacak : acc_project_list_alacak,
					acc_project_list_borc : acc_project_list_borc,
                    DSN3_ALIAS: "#dsn3#"
				);
            </cfscript>
        </cfif>
            <cfelseif len(arguments.is_invoice_export_custom) and arguments.is_invoice_export_custom eq 0>
                <cfquery name="UPD_ACCOUNT_CARD" datasource="#dsn2#">
                    UPDATE
                        ACCOUNT_CARD
                    SET 
                        ACTION_DATE = <cfif len(arguments.realization_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.realization_date#"><cfelse>NULL</cfif>
                    WHERE
                        ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.export_invoice_id#"> AND ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="531">
                </cfquery>                 
            </cfif>
        <cfcatch type="any">
            <cfset status = false>
            <cfdump var ="#cfcatch#">
        </cfcatch>
        </cftry>
        <cfreturn replace(serializeJSON(status),"//","")>
    </cffunction>
    <cffunction name="get_invoice_export_process_cat" returntype="any" output="false">
        <cfargument name="process_cat" default="" >
        <cfquery name="get_invoice_export_process_cat" datasource="#dsn3#">
            SELECT
                PROCESS_CAT
            FROM
               SETUP_PROCESS_CAT
            WHERE
                PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_cat#">
        </cfquery>
        <cfreturn get_invoice_export_process_cat>
    </cffunction>
    <cffunction name="add_custom_export" access="remote">
        <cfargument name="period_id" default="">
        <cfargument name="invoice_export_id" default="" >
        <cfargument name="decleration_no" default="">
        <cfargument name="invoice_paper_no" default="">
        <cfargument name="regim" default="" >
        <cfargument name="financial_reponsible_id" default="" >
        <cfargument name="customs_company_id" default="">
        <cfargument name="customs_partner_id" default="">
        <cfargument name="customs_consumer_id" default="">
        <cfargument name="customs_comp_name" default="" >
        <cfargument name="decleration_country" default="">
        <cfargument name="export_country" default="">
        <cfargument name="export_zone" default="">
        <cfargument name="country_destination" default="">        
        <cfargument name="country_destination_zone" default="">
        <cfargument name="decleration_category" default="">
        <cfargument name="reference_no" default="">
        <cfargument name="transport_vehicle_code_id" default="" >
        <cfargument name="transport_vehicle_info" default="">
        <cfargument name="transport_vehicle_contry" default="">
        <cfargument name="container_type" default="">
         <cfargument name="container_type_id" default="">
        <cfargument name="gross_kg" default="">
        <cfargument name="net_kg" default="">
        <cfargument name="delivery_code" default="">
        <cfargument name="delivery_code_id" default="">
        <cfargument name="delivery_adress" default="">
        <cfargument name="outland_vehicle_code_id" default="">
        <cfargument name="outland_vehicle_contry" default="">
        <cfargument name="outland_vehicle_info" default="">
        <cfargument name="contract_type" default="">
        <cfargument name="outland_transport_type_id" default="">
        <cfargument name="domestic_transport_type_id" default="">
        <cfargument name="loading_place" default="">
        <cfargument name="exit_custom_office_id" default="">
        <cfargument name="goods_place_id" default="">
        <cfargument name="unbonded_warehouse_id" default="">
        <cfargument name="decleration_company_id" default="">
        <cfargument name="transport_cost" default="">
        <cfargument name="transport_cost_money_type" default="">
        <cfargument name="domestic_cost" default="">
        <cfargument name="domestic_cost_money_type" default="">
        <cfargument name="assurance_cost" default="">
        <cfargument name="assurance_cost_money_type" default="">
        <cfargument name="outland_cost" default="">
        <cfargument name="outland_cost_money_type" default="">
        <cfargument name="totatl_cost_system" default="">
        <cfargument name="totatl_cost_system_money_type" default="">
        <cfargument name="totatl_cost_other_money" default="">
        <cfargument name="invoice_cost" default="" >
        <cfargument name="invoice_cost_money_type" default="">
        <cfargument name="loading_list" default="">
        <cfargument name="decleration_date" default="">
        <cfargument name="approve_date" default="">
        <cfargument name="closed_date" default="">
        <cfargument name="decleration_detail" default="">
        <cfargument name="buyer_id" default="">
        <cfargument name="farm_policy" default="">
        <cfargument name="declaration" default="">
        <cfquery name="add_custom_export" datasource="#dsn3#">
            INSERT INTO 
                CUSTOM_DECLERATION
                (
                    PERIOD_ID,
                    INVOICE_ID,
                    DECLERATION_NO,
                    INVOICE_PAPER_NO,
                    REGIME,
                    FINANCIAL_RESPONSIBLE_COMPANY,
                    DECLERATION_COMPANY,
                    FIRST_DESTINATION_COUNTRY,
                    TRADER_COUNTRY,
                    EXPORTER_COUNTRY,
                    EXPORTER_ZONE,
                    FINAL_DESTINATION_COUNTRY,
                    FINAL_DESTINATION_ZONE,
                    DECLERATION_CATEGORY,
                    REFERENCE_NO,
                    TRANSPORT_VEHICLE_CODE,
                    TRANSPORT_VEHICLE_INFO,
                    TRANSPORT_VEHICLE_CONTRY,
                    CONTAINER_TYPE,
                    GROSS_KG,
                    NET_KG,
                    DELIVERY_CODE,
                    DELIVERY_ADRESS	,
                    OUTLAND_VEHICLE_CODE,
                    OUTLAND_VEHICLE_COUNTRY,
                    OUTLAND_VEHICLE_INFO,
                    CONTRATCT_TYPE,
                    OUTLAND_TRANSPORT_TYPE,
                    DOMESTIC_TRANSPORT_TYPE,
                    LOADING_PLACE,
                    EXIT_CUSTOM_OFFICE,
                    GOODS_PLACE,
                    UNBONDED_WAREHOUSE,
                    CUSTOM_BROKER,
                    TRANSPORT_COST,
                    TRANSPORT_COST_MONEY_TYPE,
                    DOMESTIC_COST,
                    DOMESTIC_COST_MONEY_TYPE,
                    ASSURANCE_COST,
                    ASSURANCE_COST_MONEY_TYPE,
                    OUTLAND_COST,
                    OUTLAND_COST_MONEY_TYPE,
                    TOTAL_COST_SYTEM,
                    TOTAL_COST_OTHER_MONEY,
                    TOTAL_COST_MONEY_TYPE,
                    INVOICE_COST,
                    INVOICE_COST_MONEY_TYPE,
                    LOADING_LIST,
                    DECLERATION_DATE,
                    APPROVE_DATE,
                    CLOSED_DATE,
                    DECLERATION_DETAIL,
                    DECLERATION_BUYER,
                    DECLARATION,
                    FARM_POLICY,
                    RECORD_DATE,
                    RECORD_IP,
                    RECORD_EMP
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.invoice_export_id#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.decleration_no#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.invoice_paper_no#">,
                    <cfif len(arguments.regim)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.regim#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.financial_reponsible_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.financial_reponsible_id#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.decleration_company_id)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.decleration_company_id#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.decleration_country)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.decleration_country#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.trader_country)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.trader_country#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.export_country)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.export_country#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.export_zone)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.export_zone#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.country_destination)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.country_destination#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.country_destination_zone)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.country_destination_zone#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.decleration_category)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.decleration_category#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.reference_no)><cfqueryparam cfsqltype="cf_sql_varchar" value = "#arguments.reference_no#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.transport_vehicle_code_id)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.transport_vehicle_code_id#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.transport_vehicle_info)><cfqueryparam cfsqltype="cf_sql_varchar" value = "#arguments.transport_vehicle_info#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.transport_vehicle_contry_id)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.transport_vehicle_contry_id#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.container_type_id)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.container_type_id#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.gross_kg)><cfqueryparam cfsqltype="cf_sql_float" value = "#filterNum(arguments.gross_kg,2)#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.net_kg)><cfqueryparam cfsqltype="cf_sql_float" value = "#filterNum(arguments.net_kg,2)#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.delivery_code_id)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.delivery_code_id#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.delivery_adress)><cfqueryparam cfsqltype="cf_sql_varchar" value = "#arguments.delivery_adress#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.outland_vehicle_code_id)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.outland_vehicle_code_id#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.outland_vehicle_contry)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.outland_vehicle_contry#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.outland_vehicle_info)><cfqueryparam cfsqltype="cf_sql_varchar" value = "#arguments.outland_vehicle_info#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.contract_type)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.contract_type#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.outland_transport_type_id)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.outland_transport_type_id#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.domestic_transport_type_id)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.domestic_transport_type_id#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.loading_place)><cfqueryparam cfsqltype="cf_sql_varchar" value = "#arguments.loading_place#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.exit_custom_office_id)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.exit_custom_office_id#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.goods_place_id)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.goods_place_id#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.unbonded_warehouse_id)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.unbonded_warehouse_id#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.customs_partner_id) and len(arguments.customs_comp_name)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.customs_partner_id#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_float" value = "#filterNum(arguments.transport_cost,2)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value = "#listgetat(arguments.transport_cost_money_type,1)#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value = "#filterNum(arguments.domestic_cost,2)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value = "#listgetat(arguments.domestic_cost_money_type,1)#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value = "#filterNum(arguments.assurance_cost,2)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value = "#listgetat(arguments.assurance_cost_money_type,1)#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value = "#filterNum(arguments.outland_cost,2)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value = "#listgetat(arguments.outland_cost_money_type,1)#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value = "#filterNum(arguments.totatl_cost_system,2)#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value = "#filterNum(arguments.totatl_cost_other_money,2)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value = "#listgetat(arguments.totatl_cost_system_money_type,1)#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value = "#filterNum(arguments.invoice_cost,2)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value = "#listgetat(arguments.invoice_cost_money_type,1)#">,
                    <cfif len(arguments.loading_list)><cfqueryparam cfsqltype="cf_sql_varchar" value = "#arguments.loading_list#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.decleration_date#">,
                    <cfif len(arguments.approve_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.approve_date#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.closed_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.closed_date#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.decleration_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value = "#arguments.decleration_detail#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.buyer_id)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.buyer_id#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.declaration)><cfqueryparam cfsqltype="cf_sql_varchar" value = "#arguments.declaration#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.farm_policy)><cfqueryparam cfsqltype="cf_sql_varchar" value = "#arguments.farm_policy#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                )
        </cfquery>
        <cfquery name="get_max_id" datasource="#dsn3#">
            SELECT MAX(CUSTOM_DECLERATION_ID) AS CUSTOM_DECLERATION_ID,MAX(INVOICE_ID) AS INVOICE_ID  FROM CUSTOM_DECLERATION
        </cfquery>
        <script>
			window.location.href = '<cfoutput>/index.cfm?fuseaction=invoice.list_bill_FTexport&event=det&export_id=#get_max_id.CUSTOM_DECLERATION_ID#&export_invoice_id=#arguments.invoice_export_id#</cfoutput>';
		</script>
    </cffunction>
    <cffunction name="upd_custom_export" access="remote">
        <cfargument name="export_id" default="" >
        <cfargument name="period_id" default="" >
        <cfargument name="invoice_export_id" default="" >
        <cfargument name="decleration_no" default="">
        <cfargument name="invoice_paper_no" default="">
        <cfargument name="regim" default="" >
        <cfargument name="financial_reponsible_id" default="">
        <cfargument name="customs_company_id" default="">
        <cfargument name="customs_partner_id" default="">
        <cfargument name="customs_consumer_id" default="">
        <cfargument name="customs_comp_name" default="" >
        <cfargument name="decleration_country" default="" >
        <cfargument name="export_country" default="" >
        <cfargument name="export_zone" default="" >
        <cfargument name="country_destination" default="" >        
        <cfargument name="country_destination_zone" default="" >
        <cfargument name="decleration_category" default="" >
        <cfargument name="reference_no" default="">
        <cfargument name="transport_vehicle_code_id" default="" >
        <cfargument name="transport_vehicle_info" default="">
        <cfargument name="transport_vehicle_contry" default="">
        <cfargument name="transport_vehicle_contry_id" default="" >
        <cfargument name="container_type" default="">
        <cfargument name="container_type_id" default="">
        <cfargument name="gross_kg" default="" >
        <cfargument name="net_kg" default="" >
        <cfargument name="delivery_code" default="">
        <cfargument name="delivery_code_id" default="" >
        <cfargument name="delivery_adress" default="">
        <cfargument name="outland_vehicle_code_id" default="" >
        <cfargument name="outland_vehicle_contry" default="" >
        <cfargument name="outland_vehicle_info" default="">
        <cfargument name="contract_type" default="" >
        <cfargument name="outland_transport_type_id" default="" >
        <cfargument name="domestic_transport_type_id" default="" >
        <cfargument name="loading_place" default="">
        <cfargument name="exit_custom_office_id" default="" >
        <cfargument name="goods_place_id" default="">
        <cfargument name="unbonded_warehouse_id" default="" >
        <cfargument name="decleration_company_id" default="" >
        <cfargument name="transport_cost" default="" >
        <cfargument name="transport_cost_money_type" default="" >
        <cfargument name="domestic_cost" default="" >
        <cfargument name="domestic_cost_money_type" default="" >
        <cfargument name="assurance_cost" default="" >
        <cfargument name="assurance_cost_money_type" default="" >
        <cfargument name="outland_cost" default="" >
        <cfargument name="outland_cost_money_type" default="" >
        <cfargument name="totatl_cost_system" default="" >
        <cfargument name="totatl_cost_system_money_type" default="" >
        <cfargument name="totatl_cost_other_money" default="" >
        <cfargument name="invoice_cost" default="" >
        <cfargument name="invoice_cost_money_type" default="" >
        <cfargument name="loading_list" default="">
        <cfargument name="decleration_date" default="" >
        <cfargument name="approve_date" default="" >
        <cfargument name="closed_date" default="" >
        <cfargument name="decleration_detail" default="" >
        <cfargument name="buyer_id" default="[ ]">
        <cfargument name="farm_policy" default="">
        <cfargument name="declaration" default="">
        <cfquery name="upd_custom_export" datasource="#dsn3#">
            UPDATE 
                CUSTOM_DECLERATION
            SET
                PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year#">,
                INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.invoice_export_id#">,
                DECLERATION_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.decleration_no#">,
                INVOICE_PAPER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.invoice_paper_no#">,
                REGIME = <cfif len(arguments.regim)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.regim#"><cfelse>NULL</cfif>,
                FINANCIAL_RESPONSIBLE_COMPANY = <cfif len(arguments.financial_reponsible_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.financial_reponsible_id#"><cfelse>NULL</cfif>,
                DECLERATION_COMPANY = <cfif len(arguments.decleration_company_id)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.decleration_company_id#"><cfelse>NULL</cfif>,
                FIRST_DESTINATION_COUNTRY = <cfif len(arguments.decleration_country)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.decleration_country#"><cfelse>NULL</cfif>,
                TRADER_COUNTRY = <cfif len(arguments.trader_country)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.trader_country#"><cfelse>NULL</cfif>,
                EXPORTER_COUNTRY = <cfif len(arguments.export_country)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.export_country#"><cfelse>NULL</cfif>,
                EXPORTER_ZONE = <cfif len(arguments.export_zone)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.export_zone#"><cfelse>NULL</cfif>,
                FINAL_DESTINATION_COUNTRY = <cfif len(arguments.country_destination)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.country_destination#"><cfelse>NULL</cfif>,
                FINAL_DESTINATION_ZONE = <cfif len(arguments.country_destination_zone)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.country_destination_zone#"><cfelse>NULL</cfif>,
                DECLERATION_CATEGORY = <cfif len(arguments.decleration_category)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.decleration_category#"><cfelse>NULL</cfif>,
                REFERENCE_NO = <cfif len(arguments.reference_no)><cfqueryparam cfsqltype="cf_sql_varchar" value = "#arguments.reference_no#"><cfelse>NULL</cfif>,
                TRANSPORT_VEHICLE_CODE = <cfif len(arguments.transport_vehicle_code_id)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.transport_vehicle_code_id#"><cfelse>NULL</cfif>,
                TRANSPORT_VEHICLE_INFO = <cfif len(arguments.transport_vehicle_info)><cfqueryparam cfsqltype="cf_sql_varchar" value = "#arguments.transport_vehicle_info#"><cfelse>NULL</cfif>,
                TRANSPORT_VEHICLE_CONTRY = <cfif len(arguments.transport_vehicle_contry_id)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.transport_vehicle_contry_id#"><cfelse>NULL</cfif>,
                CONTAINER_TYPE = <cfif len(arguments.container_type_id)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.container_type_id#"><cfelse>NULL</cfif>,
                GROSS_KG = <cfif len(arguments.gross_kg)><cfqueryparam cfsqltype="cf_sql_float" value = "#filterNum(arguments.gross_kg,2)#"><cfelse>NULL</cfif>,
                NET_KG = <cfif len(arguments.net_kg)><cfqueryparam cfsqltype="cf_sql_float" value = "#filterNum(arguments.net_kg,2)#"><cfelse>NULL</cfif>,
                DELIVERY_CODE = <cfif len(arguments.delivery_code_id)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.delivery_code_id#"><cfelse>NULL</cfif>,
                DELIVERY_ADRESS	= <cfif len(arguments.delivery_adress)><cfqueryparam cfsqltype="cf_sql_varchar" value = "#arguments.delivery_adress#"><cfelse>NULL</cfif>,
                OUTLAND_VEHICLE_CODE = <cfif len(arguments.outland_vehicle_code_id)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.outland_vehicle_code_id#"><cfelse>NULL</cfif>,
                OUTLAND_VEHICLE_COUNTRY = <cfif len(arguments.outland_vehicle_contry)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.outland_vehicle_contry#"><cfelse>NULL</cfif>,
                OUTLAND_VEHICLE_INFO = <cfif len(arguments.outland_vehicle_info)><cfqueryparam cfsqltype="cf_sql_varchar" value = "#arguments.outland_vehicle_info#"><cfelse>NULL</cfif>,
                CONTRATCT_TYPE = <cfif len(arguments.contract_type)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.contract_type#"><cfelse>NULL</cfif>,
                OUTLAND_TRANSPORT_TYPE = <cfif len(arguments.outland_transport_type_id)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.outland_transport_type_id#"><cfelse>NULL</cfif>,
                DOMESTIC_TRANSPORT_TYPE = <cfif len(arguments.domestic_transport_type_id)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.domestic_transport_type_id#"><cfelse>NULL</cfif>,
                LOADING_PLACE = <cfif len(arguments.loading_place)><cfqueryparam cfsqltype="cf_sql_varchar" value = "#arguments.loading_place#"><cfelse>NULL</cfif>,
                EXIT_CUSTOM_OFFICE = <cfif len(arguments.exit_custom_office_id)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.exit_custom_office_id#"><cfelse>NULL</cfif>,
                GOODS_PLACE = <cfif len(arguments.goods_place_id)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.goods_place_id#"><cfelse>NULL</cfif>,
                UNBONDED_WAREHOUSE = <cfif len(arguments.unbonded_warehouse_id)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.unbonded_warehouse_id#"><cfelse>NULL</cfif>,
                CUSTOM_BROKER = <cfif len(arguments.customs_partner_id) and len(arguments.customs_comp_name)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.customs_partner_id#"><cfelse>NULL</cfif>,
                TRANSPORT_COST = <cfqueryparam cfsqltype="cf_sql_float" value = "#filterNum(arguments.transport_cost,2)#">,
                TRANSPORT_COST_MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value = "#arguments.transport_cost_money_type#">,
                DOMESTIC_COST = <cfqueryparam cfsqltype="cf_sql_float" value = "#filterNum(arguments.domestic_cost,2)#">,
                DOMESTIC_COST_MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value = "#arguments.domestic_cost_money_type#">,
                ASSURANCE_COST = <cfqueryparam cfsqltype="cf_sql_float" value = "#filterNum(arguments.assurance_cost,2)#">,
                ASSURANCE_COST_MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value = "#arguments.assurance_cost_money_type#">,
                OUTLAND_COST = <cfqueryparam cfsqltype="cf_sql_float" value = "#filterNum(arguments.outland_cost,2)#">,
                OUTLAND_COST_MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value = "#arguments.outland_cost_money_type#">,
                TOTAL_COST_SYTEM = <cfqueryparam cfsqltype="cf_sql_float" value = "#filterNum(arguments.totatl_cost_system,2)#">,
                TOTAL_COST_OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_float" value = "#filterNum(arguments.totatl_cost_other_money,2)#">,
                TOTAL_COST_MONEY_TYPE =<cfqueryparam cfsqltype="cf_sql_varchar" value = "#arguments.totatl_cost_system_money_type#">,
                INVOICE_COST = <cfqueryparam cfsqltype="cf_sql_float" value = "#filterNum(arguments.invoice_cost,2)#">,
                INVOICE_COST_MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value = "#arguments.invoice_cost_money_type#">,
                LOADING_LIST = <cfif len(arguments.loading_list)><cfqueryparam cfsqltype="cf_sql_varchar" value = "#arguments.loading_list#"><cfelse>NULL</cfif>,
                DECLERATION_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.decleration_date#">,
                APPROVE_DATE = <cfif len(arguments.approve_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.approve_date#"><cfelse>NULL</cfif>,
                CLOSED_DATE = <cfif len(arguments.closed_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.closed_date#"><cfelse>NULL</cfif>,
                DECLERATION_DETAIL = <cfif len(arguments.decleration_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value = "#arguments.decleration_detail#"><cfelse>NULL</cfif>,
                DECLERATION_BUYER = <cfif len(arguments.buyer_id)><cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.buyer_id#"><cfelse>NULL</cfif>,
                DECLARATION = <cfif len(arguments.declaration)><cfqueryparam cfsqltype="cf_sql_varchar" value = "#arguments.declaration#"><cfelse>NULL</cfif>,
                FARM_POLICY = <cfif len(arguments.farm_policy)><cfqueryparam cfsqltype="cf_sql_varchar" value = "#arguments.farm_policy#"><cfelse>NULL</cfif>,
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
            WHERE
                CUSTOM_DECLERATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.export_id#">
        </cfquery>
        <script>
		  window.document.location.href='<cfoutput>/index.cfm?fuseaction=invoice.list_bill_FTexport&event=det&export_id=#arguments.export_id#&export_invoice_id=#arguments.invoice_export_id#</cfoutput>';
      </script> 
    </cffunction>
    <cffunction name="GET_CUSTOM_DECLERATION" returntype="any" output="false">
        <cfargument name="export_id" default="">
        <cfquery name="GET_CUSTOM_DECLERATION" datasource="#dsn3#">
            SELECT
                *
            FROM
               CUSTOM_DECLERATION
            WHERE
                CUSTOM_DECLERATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.export_id#">
        </cfquery>
        <cfreturn GET_CUSTOM_DECLERATION>
    </cffunction>
    <cffunction name="GET_DECLERATION" returntype="query">
        <cfargument name="startrow" default="">
        <cfargument name="maxrows" default="">
        <cfargument name="keyword" default="">
        <cfquery name="GET_DECLERATION" datasource="#dsn3#">    
            SELECT
                *
            FROM
               CUSTOM_DECLERATION
            WHERE 1=1
                <cfif isdefined("arguments.beyan") and len(arguments.beyan)>
                  AND  DECLERATION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
                </cfif>
                <cfif isdefined("arguments.decleration_no") and len(arguments.decleration_no)>
                    AND (
                            DECLERATION_NO LIKE '<cfif len(arguments.decleration_no) gt 3>%</cfif>#arguments.decleration_no#%'
                        )
                </cfif>
                <cfif isdefined("arguments.decleration_date") and len(arguments.decleration_date)>
                   AND DECLERATION_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.decleration_date#">
                </cfif>
                <cfif isdefined("arguments.keyword") and len(arguments.keyword)>
                    AND  DECLERATION_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
                </cfif>
                <cfif isdefined("arguments.custom_brokers_id") and len(arguments.custom_brokers_id)>
                    AND CUSTOM_BROKER = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.custom_brokers_id#">
                </cfif>
        </cfquery>
        <cfreturn GET_DECLERATION>
    </cffunction>
    <cffunction name="dlt_DECLERATION" access="remote">
      		<cfargument name="export_id" default="">
			<cfquery name="dlt_DECLERATION" datasource="#dsn3#">
                DELETE CUSTOM_DECLERATION WHERE CUSTOM_DECLERATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.export_id#">
            </cfquery>
		  <script>
				window.document.location.href='/index.cfm?fuseaction=invoice.list_bill_FTexport';
          </script> 
      </cffunction>
</cfcomponent>