<cf_get_lang_set module_name="correspondence"><!--- sayfanin en altinda kapanisi var --->
<cfif len(attributes.target_date)>
	<cf_date tarih="attributes.target_date">
</cfif>
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<!--- History --->
        <cfinclude template="add_internaldemand_history.cfm">
        <!--- // History --->
        <cfquery name="UPD_INTERNALDEMAND" datasource="#DSN3#">
            UPDATE
                INTERNALDEMAND
            SET
                TO_POSITION_CODE = #attributes.to_position_code#,
                FROM_POSITION_CODE = <cfif len(attributes.from_position_code)>#attributes.from_position_code#<cfelse>NULL</cfif>,
                TARGET_DATE = <cfif len(attributes.target_date)>#attributes.target_date#<cfelse>NULL</cfif>,			
                TOTAL = <cfif isdefined("form.basket_gross_total")>#form.basket_gross_total#<cfelse>0</cfif>,
                DISCOUNT = <cfif isdefined("form.basket_discount_total")>#form.basket_discount_total#<cfelse>0</cfif>,
                TOTAL_TAX = <cfif isdefined("form.basket_tax_total")>#form.basket_tax_total#<cfelse>0</cfif>,
                NET_TOTAL = <cfif isdefined("form.basket_net_total")>#form.basket_net_total#,<cfelse>0,</cfif>					
                INTERNALDEMAND_STATUS = 0,
                IS_ACTIVE = <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
                <cfif isdefined("priority")>
                    PRIORITY = #priority#, 
                </cfif>
                SUBJECT = '#subject#',
                PROJECT_ID = <cfif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>#attributes.project_id#<cfelse>NULL</cfif>,
                PROJECT_ID_OUT = <cfif isdefined("attributes.project_id_out") and len(attributes.project_id_out) and len(attributes.project_head_out)>#attributes.project_id_out#<cfelse>NULL</cfif>,
                INTERNALDEMAND_STAGE = <cfif isdefined("attributes.process_stage")>#attributes.process_stage#,<cfelse>NULL,</cfif>
                DEPARTMENT_IN = <cfif isdefined('attributes.department_in_id') and len(attributes.department_in_id)>#attributes.department_in_id#<cfelse>NULL</cfif>,
                LOCATION_IN = <cfif isdefined('attributes.location_in_id') and len(attributes.location_in_id)>#attributes.location_in_id#<cfelse>NULL</cfif>,
                DEPARTMENT_OUT = <cfif isdefined('attributes.department_id') and len(attributes.department_id)>#attributes.department_id#<cfelse>NULL</cfif>,
                LOCATION_OUT = <cfif isdefined('attributes.location_id') and len(attributes.location_id)>#attributes.location_id#<cfelse>NULL</cfif>,
                REF_NO = <cfif isdefined("attributes.ref_no") and len(attributes.ref_no)>'#attributes.ref_no#'<cfelse>NULL</cfif>,
                <cfif isDefined('attributes.ship_method') and len(attributes.ship_method)>
                    SHIP_METHOD = #attributes.ship_method#,
                </cfif>
                OTHER_MONEY = <cfif isdefined("form.basket_money")>'#form.basket_money#'<cfelse> NULL</cfif>,
                OTHER_MONEY_VALUE = <cfif isdefined("form.basket_money")>#((form.basket_net_total*form.basket_rate1)/form.basket_rate2)#<cfelse>NULL</cfif>,
                WORK_ID = <cfif isdefined('attributes.work_id') and len(attributes.work_id)>#attributes.work_id#<cfelse>NULL</cfif>,
                NOTES = '#attributes.notes#',
                DPL_ID = <cfif isdefined('attributes.dpl_id') and len(attributes.dpl_id) and isdefined('attributes.dpl_no') and len(attributes.dpl_no)>#attributes.dpl_id#<cfelse>NULL</cfif>,
                DEMAND_TYPE = <cfif isdefined('attributes.is_demand') and len(attributes.is_demand)>#attributes.is_demand#<cfelse>NULL</cfif>,
                UPDATE_EMP = #session.pda.userid#,
                UPDATE_DATE = #now()#,
                FROM_COMPANY_ID = <cfif isdefined("attributes.from_company_id") and len(attributes.from_company_id)>#attributes.from_company_id#<cfelse>NULL</cfif>,
                FROM_PARTNER_ID = <cfif isdefined("attributes.from_partner_id") and len(attributes.from_partner_id)>#attributes.from_partner_id#<cfelse>NULL</cfif>,
                FROM_CONSUMER_ID = <cfif isdefined("attributes.from_consumer_id") and len(attributes.from_consumer_id)>#attributes.from_consumer_id#<cfelse>NULL</cfif>
            WHERE 
                INTERNAL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
        </cfquery>
        
        <cfset internaldemand_row_id_list_ =''>
        <cfif attributes.rows_ neq 0>
            <cfloop from="1" to="#attributes.rows_#" index="i">
                <cf_date tarih="attributes.deliver_date#i#">
                <cf_date tarih="attributes.reserve_date#i#">
                <cfif isDefined('session.pda.our_company_info.spect_type') and session.pda.our_company_info.spect_type and isdefined('attributes.is_production#i#') and evaluate('attributes.is_production#i#') eq 1>
                    <cfset specer_spec_id=''>
                    <cfif not isdefined('attributes.spect_id#i#') or not len(evaluate('attributes.spect_id#i#'))>
                        <cfset dsn_type=dsn3>
                        <cfinclude template="../../objects/query/add_basket_spec.cfm">
                    <cfelseif attributes.basket_spect_type eq 7 ><!--- satırdada guncellenebilmeli bu spec tipinde--->
                        <cfset specer_spec_id=evaluate('attributes.spect_id#i#')>
                        <cfinclude template="../../objects/query/add_basket_spec.cfm">
                    </cfif>
                </cfif>
                <cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))>
                    <cfset deger_aciklama2 = evaluate('attributes.product_name_other#i#')>
                <cfelse>
                    <cfset deger_aciklama2 = ''>
                </cfif>
                <cfif len(evaluate('attributes.action_row_id#i#')) and evaluate('attributes.action_row_id#i#') neq 0><!--- yeni eklenmis bir satır degilse --->
                    <cfquery name="UPD_INTERNALDEMAND_ROW" datasource="#DSN3#">
                        UPDATE 
                            INTERNALDEMAND_ROW 
                        SET
                            PRODUCT_ID = #evaluate("attributes.product_id#i#")#,
                            STOCK_ID = #evaluate("attributes.stock_id#i#")#,
                            QUANTITY = #evaluate("attributes.amount#i#")#,
                            UNIT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit#i#')#">,
                            UNIT_ID = #evaluate("attributes.unit_id#i#")#,
                            PRICE = <cfif isdefined('attributes.price#i#') and len(trim(evaluate('attributes.price#i#')))>#evaluate('attributes.price#i#')#<cfelse>0</cfif>,
                            PRICE_OTHER = <cfif isdefined('attributes.price_other#i#') and len(evaluate("attributes.price_other#i#"))>#evaluate('attributes.price_other#i#')#<cfelse>NULL</cfif>,
                            OTHER_MONEY = <cfif isdefined('attributes.other_money_#i#') and len(evaluate("attributes.other_money_#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.other_money_#i#')#"><cfelse>NULL</cfif>,
                            OTHER_MONEY_VALUE = <cfif isdefined('attributes.other_money_value_#i#') and len(evaluate("attributes.other_money_value_#i#"))>#evaluate('attributes.other_money_value_#i#')#<cfelse>NULL</cfif>,
                            TAX = <cfif isdefined("attributes.tax#i#")>#evaluate("attributes.tax#i#")#<cfelse>0</cfif>,
                            DUEDATE = <cfif isdefined("attributes.duedate#i#") and len(evaluate("attributes.duedate#i#"))>#evaluate("attributes.duedate#i#")#<cfelse>0</cfif>,
                            PRODUCT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.product_name#i#")#">,
                            PAY_METHOD_ID = <cfif isdefined("attributes.paymethod_id#i#") and len(evaluate("attributes.paymethod_id#i#"))>#evaluate("attributes.paymethod_id#i#")#<cfelse>0</cfif>,
                            DELIVER_DATE = <cfif isdefined("attributes.deliver_date#i#") and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined("attributes.deliver_dept#i#") and len(trim(evaluate("attributes.deliver_dept#i#"))) and len(listfirst(evaluate("attributes.deliver_dept#i#"),"-"))>
                                DELIVER_DEPT = #listfirst(evaluate("attributes.deliver_dept#i#"),"-")#,
                            <cfelseif isdefined('attributes.department_in_id') and len(attributes.department_in_id)>
                                DELIVER_DEPT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.department_in_id#">,
                            <cfelse>
                                DELIVER_DEPT = NULL,
                            </cfif>
                            <cfif isdefined("attributes.deliver_dept#i#") and listlen(trim(evaluate("attributes.deliver_dept#i#")),"-") eq 2 and len(listlast(evaluate("attributes.deliver_dept#i#"),"-"))>
                                DELIVER_LOCATION = #listlast(evaluate("attributes.deliver_dept#i#"),"-")#,
                            <cfelseif isdefined('attributes.location_in_id') and len(attributes.location_in_id)>
                                DELIVER_LOCATION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.location_in_id#">,
                            <cfelse>
                                DELIVER_LOCATION = NULL,
                            </cfif>
                            DISCOUNT_1 = <cfif isdefined('attributes.indirim1#i#')>#evaluate('attributes.indirim1#i#')#<cfelse>0</cfif>,
                            DISCOUNT_2 = <cfif isdefined('attributes.indirim2#i#')>#evaluate('attributes.indirim2#i#')#<cfelse>0</cfif>,
                            DISCOUNT_3 = <cfif isdefined('attributes.indirim3#i#')>#evaluate('attributes.indirim3#i#')#<cfelse>0</cfif>,
                            DISCOUNT_4 = <cfif isdefined('attributes.indirim4#i#')>#evaluate('attributes.indirim4#i#')#<cfelse>0</cfif>,
                            DISCOUNT_5 = <cfif isdefined('attributes.indirim5#i#')>#evaluate('attributes.indirim5#i#')#<cfelse>0</cfif>,				
                            DISCOUNT_6 = <cfif isdefined('attributes.indirim6#i#')>#evaluate('attributes.indirim6#i#')#<cfelse>0</cfif>,
                            DISCOUNT_7 = <cfif isdefined('attributes.indirim7#i#')>#evaluate('attributes.indirim7#i#')#<cfelse>0</cfif>,
                            DISCOUNT_8 = <cfif isdefined('attributes.indirim8#i#')>#evaluate('attributes.indirim8#i#')#<cfelse>0</cfif>,
                            DISCOUNT_9 = <cfif isdefined('attributes.indirim9#i#')>#evaluate('attributes.indirim9#i#')#<cfelse>0</cfif>,
                            DISCOUNT_10 = <cfif isdefined('attributes.indirim10#i#')>#evaluate('attributes.indirim10#i#')#<cfelse>0</cfif>,
                            TAXTOTAL = <cfif isdefined('attributes.row_taxtotal#i#') and len(evaluate("attributes.row_taxtotal#i#"))>#evaluate("attributes.row_taxtotal#i#")#<cfelse>NULL</cfif>,
                            NETTOTAL = <cfif isdefined('attributes.row_nettotal#i#') and len(evaluate("attributes.row_nettotal#i#"))>#evaluate("attributes.row_nettotal#i#")#<cfelse>NULL</cfif>,				
                            OTV_ORAN = <cfif isdefined('attributes.otv_oran#i#') and len(evaluate('attributes.otv_oran#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.otv_oran#i#')#"><cfelse>NULL</cfif>,
                            OTVTOTAL = <cfif isdefined('attributes.row_otvtotal#i#') and len(evaluate('attributes.row_otvtotal#i#'))>#evaluate('attributes.row_otvtotal#i#')#<cfelse>NULL</cfif>,
                            COST_PRICE = <cfif isdefined('attributes.net_maliyet#i#') and len(evaluate('attributes.net_maliyet#i#'))>#evaluate('attributes.net_maliyet#i#')#<cfelse>0</cfif>,
                            EXTRA_COST = <cfif isdefined('attributes.extra_cost#i#') and len(evaluate('attributes.extra_cost#i#'))>#evaluate('attributes.extra_cost#i#')#<cfelse>0</cfif>,
                            MARJ = <cfif isdefined('attributes.marj#i#') and len(evaluate('attributes.marj#i#'))>#evaluate('attributes.marj#i#')#<cfelse>0</cfif>,
                            PROM_COMISSION = <cfif isdefined('attributes.promosyon_yuzde#i#') and len(evaluate('attributes.promosyon_yuzde#i#'))>#evaluate('attributes.promosyon_yuzde#i#')#<cfelse>NULL</cfif>,
                            PROM_COST = <cfif isdefined('attributes.promosyon_maliyet#i#') and len(evaluate('attributes.promosyon_maliyet#i#'))>#evaluate('attributes.promosyon_maliyet#i#')#<cfelse>0</cfif>,
                            DISCOUNT_COST = <cfif isdefined('attributes.iskonto_tutar#i#') and len(evaluate('attributes.iskonto_tutar#i#'))>#evaluate('attributes.iskonto_tutar#i#')#<cfelse>NULL</cfif>,
                            PROM_ID = <cfif isdefined('attributes.row_promotion_id#i#') and len(evaluate('attributes.row_promotion_id#i#'))>#evaluate('attributes.row_promotion_id#i#')#<cfelse>NULL</cfif>,
                            IS_PROMOTION = <cfif isdefined('attributes.is_promotion#i#') and len(evaluate('attributes.is_promotion#i#'))>#evaluate('attributes.is_promotion#i#')#<cfelse>0</cfif>,
                            PROM_STOCK_ID = <cfif isdefined('attributes.prom_stock_id#i#') and len(evaluate('attributes.prom_stock_id#i#'))>#evaluate('attributes.prom_stock_id#i#')#<cfelse>NULL</cfif>,
                            IS_COMMISSION = <cfif isdefined('attributes.is_commission#i#') and len(evaluate('attributes.is_commission#i#'))>#evaluate('attributes.is_commission#i#')#<cfelse>0</cfif>,
                            UNIQUE_RELATION_ID = <cfif isdefined('attributes.row_unique_relation_id#i#') and len(evaluate('attributes.row_unique_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.row_unique_relation_id#i#')#"><cfelse>NULL</cfif>,
                            PROM_RELATION_ID = <cfif isdefined('attributes.prom_relation_id#i#') and len(evaluate('attributes.prom_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.prom_relation_id#i#')#"><cfelse>NULL</cfif>,
                            AMOUNT2 = <cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
                            UNIT2 = <cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit_other#i#')#"><cfelse>NULL</cfif>,
                            EXTRA_PRICE = <cfif isdefined('attributes.ek_tutar#i#') and len(evaluate('attributes.ek_tutar#i#'))>#evaluate('attributes.ek_tutar#i#')#<cfelse>NULL</cfif>,
                            EK_TUTAR_PRICE = <cfif isdefined('attributes.ek_tutar_price#i#') and len(evaluate('attributes.ek_tutar_price#i#'))>#evaluate('attributes.ek_tutar_price#i#')#<cfelse>NULL</cfif>,
                            EXTRA_PRICE_TOTAL = <cfif isdefined('attributes.ek_tutar_total#i#') and len(evaluate('attributes.ek_tutar_total#i#'))>#evaluate('attributes.ek_tutar_total#i#')#<cfelse>NULL</cfif>,
                            EXTRA_PRICE_OTHER_TOTAL = <cfif isdefined('attributes.ek_tutar_other_total#i#') and len(evaluate('attributes.ek_tutar_other_total#i#'))>#evaluate('attributes.ek_tutar_other_total#i#')#<cfelse>NULL</cfif>,
                            SHELF_NUMBER = <cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
                            BASKET_EXTRA_INFO_ID=<cfif isdefined('attributes.basket_extra_info#i#') and len(evaluate('attributes.basket_extra_info#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.basket_extra_info#i#')#"><cfelse>NULL</cfif>,
                            SELECT_INFO_EXTRA=<cfif isdefined('attributes.select_info_extra#i#') and len(evaluate('attributes.select_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.select_info_extra#i#')#"><cfelse>NULL</cfif>,
                            DETAIL_INFO_EXTRA=<cfif isdefined('attributes.detail_info_extra#i#') and len(evaluate('attributes.detail_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.detail_info_extra#i#')#"><cfelse>NULL</cfif>,
                            PRICE_CAT = <cfif isdefined('attributes.price_cat#i#') and len(evaluate('attributes.price_cat#i#'))>#evaluate('attributes.price_cat#i#')#<cfelse>NULL</cfif>,
                            CATALOG_ID = <cfif isdefined('attributes.row_catalog_id#i#') and len(evaluate('attributes.row_catalog_id#i#'))>#evaluate('attributes.row_catalog_id#i#')#<cfelse>NULL</cfif>,
                            LIST_PRICE = <cfif isdefined('attributes.list_price#i#') and len(evaluate('attributes.list_price#i#'))>#evaluate('attributes.list_price#i#')#<cfelse>NULL</cfif>,
                            NUMBER_OF_INSTALLMENT = <cfif isdefined('attributes.number_of_installment#i#') and len(evaluate('attributes.number_of_installment#i#'))>#evaluate('attributes.number_of_installment#i#')#<cfelse>NULL</cfif>,
                            BASKET_EMPLOYEE_ID = <cfif isdefined('attributes.basket_employee_id#i#') and len(evaluate('attributes.basket_employee_id#i#')) and isdefined('attributes.basket_employee#i#') and len(evaluate('attributes.basket_employee#i#'))>#evaluate('attributes.basket_employee_id#i#')#<cfelse>NULL</cfif>,
                            KARMA_PRODUCT_ID = <cfif isdefined('attributes.karma_product_id#i#') and len(evaluate('attributes.karma_product_id#i#'))>#evaluate('attributes.karma_product_id#i#')#<cfelse>NULL</cfif>,
                            RESERVE_DATE = <cfif isdefined("attributes.reserve_date#i#") and isdate(evaluate('attributes.reserve_date#i#'))>#evaluate('attributes.reserve_date#i#')#<cfelse>NULL</cfif>,
                            PRODUCT_NAME2 = <cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.product_name_other#i#')#"><cfelse>NULL</cfif>,
                            PRODUCT_MANUFACT_CODE = <cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.manufact_code#i#')#"><cfelse>NULL</cfif>,
                            PRO_MATERIAL_ID = <cfif isdefined("attributes.row_ship_id#i#") and len(evaluate('attributes.row_ship_id#i#')) and evaluate('attributes.row_ship_id#i#') neq 0>#evaluate('attributes.row_ship_id#i#')#<cfelse>NULL</cfif>,
                            PBS_ID = <cfif isdefined('attributes.pbs_code#i#') and len(evaluate('attributes.pbs_code#i#')) and isdefined('attributes.pbs_id#i#') and len(evaluate('attributes.pbs_id#i#'))>#evaluate('attributes.pbs_id#i#')#<cfelse>NULL</cfif>,
                            SPECT_VAR_ID = <cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>#evaluate('attributes.spect_id#i#')#<cfelse>NULL</cfif>,
                            SPECT_VAR_NAME = <cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#')) and len(evaluate('attributes.spect_name#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.spect_name#i#')#"><cfelse>NULL</cfif>,
                            ROW_PROJECT_ID = <cfif isdefined('attributes.row_project_id#i#') and len(evaluate('attributes.row_project_id#i#')) and isdefined('attributes.row_project_name#i#') and len(evaluate('attributes.row_project_name#i#'))>#evaluate('attributes.row_project_id#i#')#<cfelse>NULL</cfif>,
                            ROW_WORK_ID = <cfif isdefined('attributes.row_work_id#i#') and len(evaluate('attributes.row_work_id#i#')) and isdefined('attributes.row_work_name#i#') and len(evaluate('attributes.row_work_name#i#'))>#evaluate('attributes.row_work_id#i#')#<cfelse>NULL</cfif>,
                            WRK_ROW_ID = <cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.wrk_row_id#i#')#"><cfelse>NULL</cfif>,
                            WRK_ROW_RELATION_ID = <cfif isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.wrk_row_relation_id#i#')#"><cfelse>NULL</cfif>
                        WHERE
                            I_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#"> AND 
                            I_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.action_row_id#i#')#">
                    </cfquery>
                    <cfset attributes.row_main_id = evaluate('attributes.action_row_id#i#')>
                <cfelse>
                    <cfquery name="ADD_INTERNALDEMAND_ROW" datasource="#DSN3#">
                        INSERT INTO 
                            INTERNALDEMAND_ROW 
                            (
                                I_ID, 
                                PRODUCT_ID,
                                STOCK_ID,
                                QUANTITY,
                                UNIT,
                                UNIT_ID,
                                PRICE,
                                PRICE_OTHER,
                                OTHER_MONEY,
                                OTHER_MONEY_VALUE,
                                TAX,
                                DUEDATE,
                                PRODUCT_NAME,
                                PAY_METHOD_ID,
                                DELIVER_DATE,
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
                                TAXTOTAL,
                                NETTOTAL,				
                                OTV_ORAN,
                                OTVTOTAL,
                                COST_PRICE,
                                EXTRA_COST,
                                MARJ,
                                PROM_COMISSION,
                                PROM_COST,
                                DISCOUNT_COST,
                                PROM_ID,
                                IS_PROMOTION,
                                PROM_STOCK_ID,
                                IS_COMMISSION,
                                UNIQUE_RELATION_ID,
                                PROM_RELATION_ID,
                                AMOUNT2,
                                UNIT2,
                                EXTRA_PRICE,
                                EK_TUTAR_PRICE,
                                EXTRA_PRICE_TOTAL,
                                EXTRA_PRICE_OTHER_TOTAL,
                                SHELF_NUMBER,
                                BASKET_EXTRA_INFO_ID,
                                SELECT_INFO_EXTRA,
                                DETAIL_INFO_EXTRA,
                                PRICE_CAT,
                                CATALOG_ID,
                                LIST_PRICE,
                                NUMBER_OF_INSTALLMENT,
                                BASKET_EMPLOYEE_ID,
                                KARMA_PRODUCT_ID,
                                RESERVE_DATE,
                                PRODUCT_NAME2,
                                PRODUCT_MANUFACT_CODE,
                                WRK_ROW_ID,
                                WRK_ROW_RELATION_ID,
                                PRO_MATERIAL_ID,
                                WIDTH_VALUE,
                                DEPTH_VALUE,
                                HEIGHT_VALUE,
                                ROW_PROJECT_ID,
                                ROW_WORK_ID,
                                PBS_ID,
                                DELIVER_DEPT,
                                DELIVER_LOCATION
                                <cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
                                    ,SPECT_VAR_ID
                                    ,SPECT_VAR_NAME
                                </cfif>
                            )
                        VALUES 
                            (
                                #attributes.id#,
                                #evaluate("attributes.product_id#i#")#,
                                #evaluate("attributes.stock_id#i#")#,
                                #evaluate("attributes.amount#i#")#,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit#i#')#">,
                                #evaluate("attributes.unit_id#i#")#,
                                <cfif isdefined('attributes.price#i#') and len(trim(evaluate('attributes.price#i#')))>#evaluate('attributes.price#i#')#,<cfelse>0,</cfif>
                                <cfif isdefined('attributes.price_other#i#') and len(evaluate("attributes.price_other#i#"))>#evaluate('attributes.price_other#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.other_money_#i#') and len(evaluate("attributes.other_money_#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.other_money_#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.other_money_value_#i#') and len(evaluate("attributes.other_money_value_#i#"))>#evaluate('attributes.other_money_value_#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined("attributes.tax#i#")>#evaluate("attributes.tax#i#")#<cfelse>0</cfif>,
                                <cfif isdefined("attributes.duedate#i#") and len(evaluate("attributes.duedate#i#"))>#evaluate("attributes.duedate#i#")#<cfelse>0</cfif>,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.product_name#i#')#">,
                                <cfif isdefined("attributes.paymethod_id#i#") and len(evaluate("attributes.paymethod_id#i#"))>#evaluate("attributes.paymethod_id#i#")#,<cfelse>0,</cfif>
                                <cfif isdefined("attributes.deliver_date#i#") and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.indirim1#i#')>#evaluate('attributes.indirim1#i#')#<cfelse>0</cfif>,
                                <cfif isdefined('attributes.indirim2#i#')>#evaluate('attributes.indirim2#i#')#<cfelse>0</cfif>,
                                <cfif isdefined('attributes.indirim3#i#')>#evaluate('attributes.indirim3#i#')#<cfelse>0</cfif>,
                                <cfif isdefined('attributes.indirim4#i#')>#evaluate('attributes.indirim4#i#')#<cfelse>0</cfif>,
                                <cfif isdefined('attributes.indirim5#i#')>#evaluate('attributes.indirim5#i#')#<cfelse>0</cfif>,
                                <cfif isdefined('attributes.indirim6#i#')>#evaluate('attributes.indirim6#i#')#<cfelse>0</cfif>,
                                <cfif isdefined('attributes.indirim7#i#')>#evaluate('attributes.indirim7#i#')#<cfelse>0</cfif>,
                                <cfif isdefined('attributes.indirim8#i#')>#evaluate('attributes.indirim8#i#')#<cfelse>0</cfif>,
                                <cfif isdefined('attributes.indirim9#i#')>#evaluate('attributes.indirim9#i#')#<cfelse>0</cfif>,
                                <cfif isdefined('attributes.indirim10#i#')>#evaluate('attributes.indirim10#i#')#<cfelse>0</cfif>,
                                <cfif isdefined('attributes.row_taxtotal#i#') and len(evaluate("attributes.row_taxtotal#i#"))>#evaluate("attributes.row_taxtotal#i#")#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.row_nettotal#i#') and len(evaluate("attributes.row_nettotal#i#"))>#evaluate("attributes.row_nettotal#i#")#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.otv_oran#i#') and len(evaluate('attributes.otv_oran#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.otv_oran#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.row_otvtotal#i#') and len(evaluate('attributes.row_otvtotal#i#'))>#evaluate('attributes.row_otvtotal#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.net_maliyet#i#') and len(evaluate('attributes.net_maliyet#i#'))>#evaluate('attributes.net_maliyet#i#')#<cfelse>0</cfif>,
                                <cfif isdefined('attributes.extra_cost#i#') and len(evaluate('attributes.extra_cost#i#'))>#evaluate('attributes.extra_cost#i#')#<cfelse>0</cfif>,
                                <cfif isdefined('attributes.marj#i#') and len(evaluate('attributes.marj#i#'))>#evaluate('attributes.marj#i#')#<cfelse>0</cfif>,
                                <cfif isdefined('attributes.promosyon_yuzde#i#') and len(evaluate('attributes.promosyon_yuzde#i#'))>#evaluate('attributes.promosyon_yuzde#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.promosyon_maliyet#i#') and len(evaluate('attributes.promosyon_maliyet#i#'))>#evaluate('attributes.promosyon_maliyet#i#')#<cfelse>0</cfif>,
                                <cfif isdefined('attributes.iskonto_tutar#i#') and len(evaluate('attributes.iskonto_tutar#i#'))>#evaluate('attributes.iskonto_tutar#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.row_promotion_id#i#') and len(evaluate('attributes.row_promotion_id#i#'))>#evaluate('attributes.row_promotion_id#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.is_promotion#i#') and len(evaluate('attributes.is_promotion#i#'))>#evaluate('attributes.is_promotion#i#')#<cfelse>0</cfif>,
                                <cfif isdefined('attributes.prom_stock_id#i#') and len(evaluate('attributes.prom_stock_id#i#'))>#evaluate('attributes.prom_stock_id#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.is_commission#i#') and len(evaluate('attributes.is_commission#i#'))>#evaluate('attributes.is_commission#i#')#<cfelse>0</cfif>,
                                <cfif isdefined('attributes.row_unique_relation_id#i#') and len(evaluate('attributes.row_unique_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.row_unique_relation_id#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.prom_relation_id#i#') and len(evaluate('attributes.prom_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.prom_relation_id#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit_other#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.ek_tutar#i#') and len(evaluate('attributes.ek_tutar#i#'))>#evaluate('attributes.ek_tutar#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.ek_tutar_price#i#') and len(evaluate('attributes.ek_tutar_price#i#'))>#evaluate('attributes.ek_tutar_price#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.ek_tutar_total#i#') and len(evaluate('attributes.ek_tutar_total#i#'))>#evaluate('attributes.ek_tutar_total#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.ek_tutar_other_total#i#') and len(evaluate('attributes.ek_tutar_other_total#i#'))>#evaluate('attributes.ek_tutar_other_total#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
								<cfif isdefined('attributes.basket_extra_info#i#') and len(evaluate('attributes.basket_extra_info#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.basket_extra_info#i#')#"><cfelse>NULL</cfif>,
								<cfif isdefined('attributes.select_info_extra#i#') and len(evaluate('attributes.select_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.select_info_extra#i#')#"><cfelse>NULL</cfif>,
								<cfif isdefined('attributes.detail_info_extra#i#') and len(evaluate('attributes.detail_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.detail_info_extra#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.price_cat#i#') and len(evaluate('attributes.price_cat#i#'))>#evaluate('attributes.price_cat#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.row_catalog_id#i#') and len(evaluate('attributes.row_catalog_id#i#'))>#evaluate('attributes.row_catalog_id#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.list_price#i#') and len(evaluate('attributes.list_price#i#'))>#evaluate('attributes.list_price#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.number_of_installment#i#') and len(evaluate('attributes.number_of_installment#i#'))>#evaluate('attributes.number_of_installment#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.basket_employee_id#i#') and len(evaluate('attributes.basket_employee_id#i#')) and isdefined('attributes.basket_employee#i#') and len(evaluate('attributes.basket_employee#i#'))>#evaluate('attributes.basket_employee_id#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.karma_product_id#i#') and len(evaluate('attributes.karma_product_id#i#'))>#evaluate('attributes.karma_product_id#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined("attributes.reserve_date#i#") and isdate(evaluate('attributes.reserve_date#i#'))>#evaluate('attributes.reserve_date#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.product_name_other#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.manufact_code#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.wrk_row_id#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.wrk_row_relation_id#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined("attributes.row_ship_id#i#") and len(evaluate('attributes.row_ship_id#i#')) and evaluate('attributes.row_ship_id#i#') neq 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.row_ship_id#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.row_project_id#i#') and len(evaluate('attributes.row_project_id#i#')) and isdefined('attributes.row_project_name#i#') and len(evaluate('attributes.row_project_name#i#'))>#evaluate('attributes.row_project_id#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.row_work_id#i#') and len(evaluate('attributes.row_work_id#i#')) and isdefined('attributes.row_work_name#i#') and len(evaluate('attributes.row_work_name#i#'))>#evaluate('attributes.row_work_id#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.pbs_code#i#') and len(evaluate('attributes.pbs_code#i#')) and isdefined('attributes.pbs_id#i#') and len(evaluate('attributes.pbs_id#i#'))>#evaluate('attributes.pbs_id#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined("attributes.deliver_dept#i#") and len(trim(evaluate("attributes.deliver_dept#i#"))) and len(listfirst(evaluate("attributes.deliver_dept#i#"),"-"))>
                                    #listfirst(evaluate("attributes.deliver_dept#i#"),"-")#,
                                <cfelseif isdefined('attributes.department_in_id') and len(attributes.department_in_id)>
                                    #attributes.department_in_id#,
                                <cfelse>
                                    NULL,
                                </cfif>
                                <cfif isdefined("attributes.deliver_dept#i#") and listlen(trim(evaluate("attributes.deliver_dept#i#")),"-") eq 2 and len(listlast(evaluate("attributes.deliver_dept#i#"),"-"))>
                                    #listlast(evaluate("attributes.deliver_dept#i#"),"-")#
                                <cfelseif isdefined('attributes.location_in_id') and len(attributes.location_in_id)>
                                    #attributes.location_in_id#
                                <cfelse>
                                    NULL
                                </cfif>
                                <cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
                                    ,#evaluate('attributes.spect_id#i#')#
                                    ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.spect_name#i#')#">
                                </cfif>       
                            )
                    </cfquery>
                    <cfquery name="GET_MAX_INTERNALDEMAND_ROW" datasource="#DSN3#">
                        SELECT
                            MAX(I_ROW_ID) AS I_ROW_ID
                        FROM
                            INTERNALDEMAND_ROW
                        WHERE
                            I_ID= #attributes.ID#
                    </cfquery>
                    <cfset attributes.row_main_id = get_max_internaldemand_row.i_row_id>
                </cfif>
                <cfset internaldemand_row_id_list_ =listappend(internaldemand_row_id_list_,attributes.row_main_id)> <!--- internaldemand_row_id_list_ olusturuluyor, bu liste haricindeki iç talep satırları silinir --->
            </cfloop>	
            <cfif len(internaldemand_row_id_list_)>
                <cfquery name="DEL_ORDER_ROW_" datasource="#DSN3#"> <!--- basketten cıkarılan satırlar INTERNALDEMAND_ROW dan siliniyor --->
                    DELETE FROM 
                        INTERNALDEMAND_ROW 
                    WHERE 
                    	I_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#"> AND 
                        I_ROW_ID NOT IN (#internaldemand_row_id_list_#)
                </cfquery>
            </cfif>
        </cfif>
        <cfscript>
            if(isdefined('attributes.pro_material_id_list') and len(attributes.pro_material_id_list)) //proje malzeme planı ile baglantısı olusturuluyor
            {
                include('add_paper_relation.cfm','\objects\functions'); 
                add_paper_relation(
                    to_paper_id :attributes.ID,
                    to_paper_table : 'INTERNALDEMAND',
                    to_paper_type :3,
                    from_paper_table : 'PRO_MATERIAL',
                    from_paper_type :2,
                    relation_type : 1,
                    action_status:1
                    );
            }
            basket_kur_ekle(action_id:attributes.ID,table_type_id:7,process_type:1);
        </cfscript>
        <cfquery name="GET_INTERNALDEMAND_PAPER" datasource="#DSN3#">
            SELECT INTERNAL_NUMBER FROM INTERNALDEMAND WHERE INTERNAL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
        </cfquery>
        <cfif isdefined('attributes.is_demand') and attributes.is_demand eq 1>
            <cfset page_type = 'upd_purchasedemand'>
            <cfset page_name = 'Satınalma Talebi'>
        <cfelse>
            <cfset page_type = 'upd_internaldemand'>
            <cfset page_name = 'İç Talep'>
        </cfif>
        <!---<cf_workcube_process 
            is_upd='1' 
            data_source='#dsn3#'
            old_process_line='#attributes.old_process_line#'
            process_stage='#attributes.process_stage#' 
            record_member='#session.pda.userid#' 
            record_date='#now()#' 
            action_table='INTERNALDEMAND'
            action_column='INTERNAL_ID'
            action_id='#attributes.id#'
            action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.#page_type#&id=#attributes.id#' 
            warning_description='#page_name#: #get_internaldemand_paper.internal_number#'>--->
	</cftransaction>
</cflock>
<cfif fusebox.circuit eq 'myhome'>
	<cfset id_ = contentEncryptingandDecodingAES(isEncode:1,content:id,accountKey:session.pda.userid)>
<cfelse>
	<cfset id_ = id>
</cfif>
<cfif isdefined('attributes.is_demand') and attributes.is_demand eq 1>
	<script type="text/javascript">
		window.location.href = '<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.upd_purchasedemand&id=#id_#&is_hidden=1</cfoutput>';
	</script>
<cfelse>
	<script type="text/javascript">
		window.location.href = '<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_upd_internaldemand&internal_id=#id_#</cfoutput>';
	</script>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
