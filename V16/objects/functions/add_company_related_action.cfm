<cfsetting enablecfoutputonly="no">
<cfprocessingdirective suppresswhitespace="yes">
<cffunction name="add_company_related_action" returntype="boolean" output="false">
	<cfargument name="action_id" required="yes" type="numeric">
	<cfargument name="comp_id" required="no" type="string">
	<cfargument name="action_type" required="yes" type="string"><!--- 1:satış siparişi,2:alış siparişi,3:satış faturası,4:alış faturası,5:satış irsaliyesi,6:alış irsaliyesi --->
	<cfif not isdefined("butceci")>
		<cfinclude template="get_butceci.cfm">
	</cfif>
	<cfif not isdefined("carici")>
		<cfinclude template="get_carici.cfm">
	</cfif>
	<cfif not isdefined("muhasebeci")>
		<cfinclude template="get_muhasebeci.cfm">
	</cfif>
	<cfif not isdefined("get_consumer_period")>
		<cfinclude template="get_user_accounts.cfm">
	</cfif>
	<cfif not isdefined("basket_kur_ekle")>
		<cfinclude template="get_basket_money_js.cfm">
	</cfif>
	<cfif not isdefined("add_reserve_row")>
		<cfinclude template="add_order_row_reserved_stock.cfm">
	</cfif>
	<cfif not isdefined("add_stock_rows")>
		<cfinclude template="add_stock_rows.cfm">
	</cfif>
	<cfif not (isdefined("arguments.comp_id") and len(arguments.comp_id))>
		<cfset arguments.comp_id = session.ep.company_id>
	</cfif>
	<cfset new_dsn2 = "#dsn#_#session.ep.period_year#_#arguments.comp_id#">
	<cftry>
		<cfif action_type eq 5><!--- Satış irslaiyesi İse --->
			<cfquery name="get_act_detail" datasource="#new_dsn2#">
				SELECT * FROM SHIP WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
			</cfquery>
			<cfif get_act_detail.recordcount and len(get_act_detail.company_id)>
                <cfquery name="get_related_act" datasource="#new_dsn2#">
                    SELECT * FROM #dsn_alias#.COMPANY_GROUP_ACTIONS WHERE FROM_ACT_TYPE = 5 AND TO_ACT_TYPE IN(5,6,1) AND FROM_OUR_COMP_ID = #arguments.comp_id# AND (FROM_COMPANY_ID IS NULL OR FROM_COMPANY_ID = #get_act_detail.company_id#) AND (FROM_PROCESS_TYPE IS NULL OR FROM_PROCESS_TYPE = #get_act_detail.process_cat#)
                </cfquery>
                <cfif get_related_act.recordcount>
                    <cfset new_comp_id = get_related_act.to_our_comp_id> 
                    <cfset new_dsn3_group = "#dsn#_#get_related_act.to_our_comp_id#"> 
                    <cfset new_dsn2_group = "#dsn#_#session.ep.period_year#_#get_related_act.to_our_comp_id#"> 
                    
                    <!--- grup ici islem ile kaydedilen belgenin doneminde tarih kısıtı var ise kaydetmemesi gerekiyor --->
                    <cfset userPeriodDate = getUserPeriodDate(comp_id:new_comp_id)>
                    <cfif userPeriodDate lt get_act_detail.ship_date>
                        <cfquery name="get_to_period_id" datasource="#dsn#">
                            SELECT PERIOD_ID FROM SETUP_PERIOD WHERE PERIOD_YEAR=#session.ep.period_year# AND OUR_COMPANY_ID = #get_related_act.to_our_comp_id#
                        </cfquery>
                        <cfquery name="get_act_rows" datasource="#new_dsn2#">
                            SELECT * FROM SHIP_ROW WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> ORDER BY SHIP_ROW_ID
                        </cfquery>
                        <cfquery name="get_act_stock_rows" datasource="#new_dsn2#">
                            SELECT 
                                S.STOCK_ID
                            FROM 
                                SHIP_ROW SR,
                                #new_dsn3_group#.STOCKS AS S
                                <cfif len(get_related_act.to_price_cat)>
                                    ,#new_dsn3_group#.PRICE AS PP
                                </cfif>
                            WHERE 
                                SR.SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
                                AND S.STOCK_ID = SR.STOCK_ID
                                <cfif len(get_related_act.to_price_cat)>
                                    AND PP.PRODUCT_ID = S.PRODUCT_ID
                                    AND PP.PRICE_CATID = #get_related_act.to_price_cat#
                                    AND PP.STARTDATE <= #createodbcdatetime(get_act_detail.ship_date)#
                                    AND (PP.FINISHDATE IS NULL OR PP.FINISHDATE >=#createodbcdatetime(get_act_detail.ship_date)#)
                                </cfif>
                        </cfquery>
                        <cfif get_act_rows.recordcount eq get_act_stock_rows.recordcount>
                            <cfquery name="get_money" datasource="#new_dsn2#">
                                SELECT RATE2,RATE1,MONEY_TYPE FROM SHIP_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
                            </cfquery>
                            <cfquery name="get_money_selected" datasource="#new_dsn2#">
                                SELECT RATE2,RATE1,MONEY_TYPE FROM SHIP_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> AND IS_SELECTED=1
                            </cfquery>
                            <cfquery name="get_member_id" datasource="#new_dsn2#">
                                SELECT
                                    COMPANY.COMPANY_ID,
                                    ISNULL(COMPANY.MANAGER_PARTNER_ID,(SELECT TOP 1 PARTNER_ID FROM #dsn_alias#.COMPANY_PARTNER WHERE COMPANY_ID=COMPANY.COMPANY_ID)) PARTNER_ID,
                                    COMPANY_PERIOD.ACCOUNT_CODE
                                FROM 
                                    #dsn_alias#.COMPANY,
                                    #dsn_alias#.COMPANY_PERIOD
                                WHERE
                                    COMPANY.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_act.TO_COMPANY_ID#"> AND
                                    COMPANY_PERIOD.COMPANY_ID = COMPANY.COMPANY_ID AND
                                    <cfif isdefined("session.ep")>
                                        COMPANY_PERIOD.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
                                    <cfelse>
                                        COMPANY_PERIOD.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.period_id#">
                                    </cfif>
                            </cfquery>
                            <cfquery name="get_partner" datasource="#dsn#">
                                SELECT MANAGER_PARTNER_ID,NICKNAME FROM COMPANY WHERE COMPANY_ID = #get_related_act.TO_COMPANY_ID#
                            </cfquery>
                            <cfquery name="get_partner_2" datasource="#dsn#">
                                SELECT MANAGER_PARTNER_ID,NICKNAME FROM COMPANY WHERE COMPANY_ID = #get_act_detail.COMPANY_ID#
                            </cfquery>
                            <cfscript>		
                                form.sale_product=1;
                                form.process_cat=get_related_act.to_process_type;
                                form.active_company="#arguments.comp_id#";
                                attributes.rows_ = get_act_rows.recordcount;
                                attributes.department_id=get_related_act.to_dept_id;
                                attributes.location_id=get_related_act.to_loc_id;
                                attributes.process_stage=get_related_act.to_process_stage;
                                form.process_cat = get_related_act.to_process_type;
                                attributes.company_id=get_related_act.TO_COMPANY_ID;
                                attributes.partner_id=get_partner.MANAGER_PARTNER_ID;
                                attributes.comp_name='a';
                                attributes.partner_name='b';
                                attributes.consumer_id='';
                                
                                attributes.reserved = 1;
                                attributes.order_employee_id =get_related_act.to_sale_emp;
                                attributes.order_employee = get_related_act.to_sale_emp;
                                attributes.sale_emp_name =get_related_act.to_sale_emp;
                                attributes.sale_emp = get_related_act.to_sale_emp;
                                attributes.order_head ="#get_partner_2.NICKNAME# - #get_act_detail.SHIP_NUMBER#";
                                SHIP_NUMBER = "#get_act_detail.SHIP_NUMBER#";
                                attributes.invoice_number='';
                                form.invoice_number='';
                                attributes.ref_no='';
                                attributes.order_date=dateformat(get_act_detail.SHIP_DATE,dateformat_style);
                                attributes.ship_date=dateformat(get_act_detail.SHIP_DATE,dateformat_style);
                                attributes.order_id = '';
                                attributes.kasa='';
                                kasa='';
                                attributes.member_account_code=GET_MEMBER_ID.ACCOUNT_CODE;
                                attributes.detail=get_act_detail.ship_detail;
                                attributes.city_id='';
                                attributes.county_id='';
                                attributes.adres=get_act_detail.ADDRESS;
                                for(stp_mny=1;stp_mny lte GET_MONEY.RECORDCOUNT;stp_mny=stp_mny+1)
                                {
                                    'attributes.hidden_rd_money_#stp_mny#'=GET_MONEY.MONEY_TYPE[stp_mny];
                                    'attributes.txt_rate1_#stp_mny#'=GET_MONEY.RATE1[stp_mny];	
                                    'attributes.txt_rate2_#stp_mny#'=GET_MONEY.RATE2[stp_mny];
                                }
                                form.basket_money=GET_MONEY_SELECTED.MONEY_TYPE;
                                attributes.basket_money=GET_MONEY_SELECTED.MONEY_TYPE;
                                form.basket_rate1=GET_MONEY_SELECTED.RATE1;
                                form.basket_rate2=GET_MONEY_SELECTED.RATE2;
                                attributes.kur_say=GET_MONEY.RECORDCOUNT;
                                attributes.basket_id=2;
                                attributes.list_payment_row_id='';
                                attributes.subscription_id='';
                                attributes.invoice_counter_number='';
                                attributes.commethod_id='';
                                attributes.bool_from_control_bill='';
                                attributes.invoice_control_id='';
                                attributes.contract_row_ids='';
                                attributes.ship_method=get_act_detail.SHIP_METHOD;
                                attributes.card_paymethod_id=get_act_detail.CARD_PAYMETHOD_ID;
                                attributes.commission_rate=get_act_detail.CARD_PAYMETHOD_RATE;
                                attributes.paymethod_id=get_related_act.TO_PAYMETHOD_ID;
                                attributes.deliver_dept_id=get_related_act.TO_DEPT_ID;
                                attributes.deliver_loc_id=get_related_act.TO_LOC_ID;
                                attributes.deliver_dept_name=get_related_act.TO_DEPT_ID;
                                attributes.project_id=get_act_detail.PROJECT_ID;
                                PARTO_ID='';
                                attributes.deliverdate = dateformat(get_act_detail.SHIP_DATE,dateformat_style); 
                                attributes.action_date=get_act_detail.action_date;
                                if(len(get_act_detail.PROCESS_TIME)){
                                attributes.deliver_date_h =  hour(dateadd('h',session.ep.time_zone,get_act_detail.PROCESS_TIME)); 
                                attributes.deliver_date_m = minute(get_act_detail.PROCESS_TIME);
                                }
                                attributes.ship_date = dateformat(get_act_detail.SHIP_DATE,dateformat_style); 
                                form.DELIVER_GET_ID =get_related_act.to_sale_emp;
                                form.DELIVER_GET =get_emp_info(get_related_act.to_sale_emp,0,0);	
                                attributes.DELIVER_GET_ID =get_related_act.to_sale_emp;
                                attributes.DELIVER_GET =get_emp_info(get_related_act.to_sale_emp,0,0);	
                                attributes.deliver_member_type = "employee";
                                attributes.ref_company_id = "";
                                attributes.ref_member_type = "";
                                attributes.ref_member_id = "";
                                attributes.ref_company = "";
                                inventory_product_exists = 0;
                                attributes.tevkifat_oran='';
                                attributes.is_general_prom=0;
                                attributes.indirim_total='100000000000000000000,100000000000000000000';
                                attributes.general_prom_limit='';
                                attributes.general_prom_discount='';
                                attributes.general_prom_amount=0;
                                attributes.free_prom_limit='';
                                attributes.flt_net_total_all=0;
                                attributes.currency_multiplier = '';
                                attributes.basket_member_pricecat='';
                                attributes.basket_due_value_date_='';
                                attributes.BASKET_PRICE_ROUND_NUMBER = 4;
                                form.genel_indirim=get_act_detail.SA_DISCOUNT;
                                if(len(get_related_act.to_price_cat))
                                {
                                    form.basket_gross_total=0;
                                    form.basket_net_total=0;
                                    attributes.basket_net_total=0;
                                    form.basket_otv_total=0;
                                    form.basket_tax_total=0;
                                    form.basket_discount_total = 0;
                                }
                                else
                                {
                                    form.basket_gross_total=get_act_detail.GROSSTOTAL;
                                    form.basket_net_total=get_act_detail.NETTOTAL;
                                    attributes.basket_net_total=get_act_detail.NETTOTAL;
                                    form.basket_otv_total=get_act_detail.OTV_TOTAL;
                                    form.basket_tax_total=get_act_detail.TAXTOTAL;
                                    form.basket_discount_total = form.genel_indirim;
                                }
                                xml_tax_count=1;//kdv sayısı
                                xml_otv_count=1;//otv sayısı
                                function_off = 1;
                            </cfscript>
                            <cfloop query="get_act_rows">
                                <cfset row_ind = get_act_rows.currentrow>
                                <cfif isdefined("is_action_file_") and is_action_file_ eq 1 and Len(new_product_id_)>
                                    <cfset 'attributes.product_id#row_ind#' = new_product_id_>
                                <cfelse>
                                    <cfset 'attributes.product_id#row_ind#' = get_act_rows.PRODUCT_ID[row_ind]>
                                </cfif>
                                <cfquery name="get_product_id" datasource="#new_dsn2#">
                                    SELECT
                                        S.BARCOD BARCODE,
                                        S.STOCK_ID,
                                        S.PRODUCT_ID,
                                        S.STOCK_CODE,
                                        S.PRODUCT_NAME,
                                        S.PROPERTY,
                                        S.IS_INVENTORY,
                                        S.MANUFACT_CODE,
                                        S.TAX,
                                        ISNULL(S.OTV,0) OTV,
                                        S.IS_PRODUCTION
                                        <cfif len(get_related_act.to_price_cat)>
                                            ,PP.PRICE PRICE_KDV
                                        <cfelse>
                                            ,#get_act_rows.price# PRICE_KDV
                                        </cfif>
                                    FROM
                                        #new_dsn3_group#.STOCKS AS S
                                        <cfif len(get_related_act.to_price_cat)>
                                            ,#new_dsn3_group#.PRICE AS PP
                                        </cfif>
                                    WHERE
                                        S.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.product_id#row_ind#')#">
                                        <cfif len(get_related_act.to_price_cat)>
                                            AND PP.PRODUCT_ID = S.PRODUCT_ID
                                            AND PP.PRICE_CATID = #get_related_act.to_price_cat#
                                            AND PP.STARTDATE <= #createodbcdatetime(get_act_detail.ship_date)#
                                            AND (PP.FINISHDATE IS NULL OR PP.FINISHDATE >=#createodbcdatetime(get_act_detail.ship_date)#)
                                        </cfif>
                                </cfquery>
                                <cfif len(get_related_act.to_price_cat) and get_product_id.recordcount>
                                    <!--- Sözleşme İndirimleri --->
                                    <cfquery name="get_contract_discounts" datasource="#new_dsn3_group#" maxrows="1">
                                        SELECT
                                            ISNULL(PC.DISCOUNT_RATE,0) DISCOUNT_RATE,
                                            ISNULL(PC.DISCOUNT_RATE_2,0) DISCOUNT_RATE_2,
                                            ISNULL(PC.DISCOUNT_RATE_3,0) DISCOUNT_RATE_3,
                                            ISNULL(PC.DISCOUNT_RATE_4,0) DISCOUNT_RATE_4,
                                            ISNULL(PC.DISCOUNT_RATE_5,0) DISCOUNT_RATE_5,
                                            PC.PAYMENT_TYPE_ID
                                        FROM 
                                            PRICE_CAT_EXCEPTIONS PC,
                                            RELATED_CONTRACT RC
                                        WHERE
                                            PC.CONTRACT_ID = RC.CONTRACT_ID
                                            AND (PC.SUPPLIER_ID IS NULL OR PC.SUPPLIER_ID = (SELECT COMPANY_ID FROM STOCKS WHERE STOCK_ID=#get_product_id.stock_id#))
                                            AND (PC.PRODUCT_ID IS NULL OR PC.PRODUCT_ID=#get_product_id.product_id#)
                                            AND (PC.BRAND_ID IS NULL OR PC.BRAND_ID=(SELECT BRAND_ID FROM STOCKS WHERE STOCK_ID=#get_product_id.stock_id#))
                                            AND (PC.PRODUCT_CATID IS NULL OR PC.PRODUCT_CATID=(SELECT PRODUCT_CATID FROM STOCKS WHERE STOCK_ID=#get_product_id.stock_id#) OR (SELECT STOCK_CODE FROM STOCKS WHERE STOCK_ID=#get_product_id.stock_id#) LIKE (SELECT PCC.HIERARCHY FROM PRODUCT_CAT PCC WHERE PCC.PRODUCT_CATID = PC.PRODUCT_CATID)+'.%')
                                            AND (PC.SHORT_CODE_ID IS NULL OR PC.SHORT_CODE_ID=(SELECT SHORT_CODE_ID FROM STOCKS WHERE STOCK_ID=#get_product_id.stock_id#))
                                            AND RC.STARTDATE <= #createodbcdatetime(get_act_detail.ship_date)#
                                            AND RC.FINISHDATE >= #createodbcdatetime(get_act_detail.ship_date)#
                                            AND	RC.COMPANY LIKE '%,#get_related_act.TO_COMPANY_ID#,%'
                                            AND PC.PRICE_CATID=#get_related_act.to_price_cat#
                                        ORDER BY 
                                            PC.PRODUCT_ID DESC,PC.BRAND_ID DESC,(SELECT PCC.HIERARCHY FROM PRODUCT_CAT PCC WHERE PCC.PRODUCT_CATID = PC.PRODUCT_CATID) DESC,PC.PRODUCT_CATID DESC,PC.SUPPLIER_ID DESC,PC.COMPANYCAT_ID DESC,PC.SHORT_CODE_ID DESC
                                    </cfquery>
                                </cfif>
                                <cfquery name="get_row_rate" dbtype="query">
                                    SELECT RATE2/RATE1 NEW_RATE FROM get_money WHERE MONEY_TYPE = '#get_act_rows.other_money#'
                                </cfquery>
                                <cfscript>
                                    'attributes.product_name#row_ind#'=get_act_rows.NAME_PRODUCT[row_ind];
                                    'attributes.product_name_other#row_ind#'=get_act_rows.PRODUCT_NAME2[row_ind];
                                    'attributes.tax#row_ind#'= get_act_rows.TAX[row_ind];
                                    'attributes.is_inventory#row_ind#'=get_product_id.IS_INVENTORY;
                                    if(get_product_id.IS_INVENTORY) inventory_product_exists = 1;
                                    'attributes.is_production#row_ind#'=get_product_id.IS_PRODUCTION;
                                    'attributes.amount#row_ind#'=get_act_rows.AMOUNT[row_ind];
                                    'attributes.deliver_date#row_ind#'=get_act_rows.DELIVER_DATE[row_ind];
                                    'attributes.deliver_dept#row_ind#'="#get_related_act.TO_DEPT_ID#-#get_related_act.TO_LOC_ID#";
                                    'attributes.duedate#row_ind#'=get_act_rows.DUE_DATE[row_ind];
                                    'attributes.ek_tutar#row_ind#'=get_act_rows.EK_TUTAR_PRICE[row_ind];
                                    'attributes.ek_tutar_other_total#row_ind#'=get_act_rows.EXTRA_PRICE_TOTAL[row_ind];
                                    'attributes.ek_tutar_total#row_ind#'=get_act_rows.EXTRA_PRICE_OTHER_TOTAL[row_ind];
                                    'attributes.extra_cost#row_ind#'=get_act_rows.EXTRA_COST[row_ind];
                                    'attributes.iskonto_tutar#row_ind#'=get_act_rows.DISCOUNT_COST[row_ind];
                                    'attributes.is_commission#row_ind#'=get_act_rows.IS_COMMISSION[row_ind];
                        
                                    'attributes.is_promotion#row_ind#'=get_act_rows.IS_PROMOTION[row_ind];
                                    'attributes.karma_product_id#row_ind#'=get_act_rows.KARMA_PRODUCT_ID[row_ind];
                                    if(len(get_related_act.to_price_cat))
                                        'attributes.list_price#row_ind#'=get_product_id.PRICE_KDV[row_ind];
                                    else
                                        'attributes.list_price#row_ind#'=get_act_rows.LIST_PRICE[row_ind];
                                        
                                    'attributes.lot_no#row_ind#'=get_act_rows.LOT_NO[row_ind];
                                    'attributes.manufact_code#row_ind#'=get_act_rows.PRODUCT_MANUFACT_CODE[row_ind];
                                    'attributes.marj#row_ind#'=get_act_rows.MARGIN[row_ind];
                                    'attributes.net_maliyet#row_ind#'=get_act_rows.COST_PRICE[row_ind];
                                    'attributes.number_of_installment#row_ind#'=get_act_rows.NUMBER_OF_INSTALLMENT[row_ind];
                                    'attributes.order_currency#row_ind#'='-1';
                                    
                                    'attributes.otv_oran#row_ind#'=get_product_id.OTV;
                                    
                                    if(len(get_related_act.to_price_cat))
                                    {
                                        if(get_contract_discounts.recordcount)
                                        {
                                            'attributes.indirim1#row_ind#'=get_contract_discounts.DISCOUNT_RATE;
                                            'attributes.indirim2#row_ind#'=get_contract_discounts.DISCOUNT_RATE_2;
                                            'attributes.indirim3#row_ind#'=get_contract_discounts.DISCOUNT_RATE_3;
                                            'attributes.indirim4#row_ind#'=get_contract_discounts.DISCOUNT_RATE_4;
                                            'attributes.indirim5#row_ind#'=get_contract_discounts.DISCOUNT_RATE_5;
                                            'attributes.indirim6#row_ind#'=0;
                                            'attributes.indirim7#row_ind#'=0;
                                            'attributes.indirim8#row_ind#'=0;
                                            'attributes.indirim9#row_ind#'=0;
                                            'attributes.indirim10#row_ind#'=0;
                                        }
                                        else
                                        {
                                            'attributes.indirim1#row_ind#'=0;
                                            'attributes.indirim2#row_ind#'=0;
                                            'attributes.indirim3#row_ind#'=0;
                                            'attributes.indirim4#row_ind#'=0;
                                            'attributes.indirim5#row_ind#'=0;
                                            'attributes.indirim6#row_ind#'=0;
                                            'attributes.indirim7#row_ind#'=0;
                                            'attributes.indirim8#row_ind#'=0;
                                            'attributes.indirim9#row_ind#'=0;
                                            'attributes.indirim10#row_ind#'=0;
                                        }
                                    }
                                    else
                                    {
                                        'attributes.indirim1#row_ind#'=get_act_rows.DISCOUNT[row_ind];
                                        'attributes.indirim2#row_ind#'=get_act_rows.DISCOUNT2[row_ind];
                                        'attributes.indirim3#row_ind#'=get_act_rows.DISCOUNT3[row_ind];
                                        'attributes.indirim4#row_ind#'=get_act_rows.DISCOUNT4[row_ind];
                                        'attributes.indirim5#row_ind#'=get_act_rows.DISCOUNT5[row_ind];
                                        'attributes.indirim6#row_ind#'=get_act_rows.DISCOUNT6[row_ind];
                                        'attributes.indirim7#row_ind#'=get_act_rows.DISCOUNT7[row_ind];
                                        'attributes.indirim8#row_ind#'=get_act_rows.DISCOUNT8[row_ind];
                                        'attributes.indirim9#row_ind#'=get_act_rows.DISCOUNT9[row_ind];
                                        'attributes.indirim10#row_ind#'=get_act_rows.DISCOUNT10[row_ind];
                                    }
                                    'attributes.indirim_carpan#row_ind#' = (100-Evaluate('attributes.indirim1#row_ind#')) * (100-Evaluate('attributes.indirim2#row_ind#')) * (100-Evaluate('attributes.indirim3#row_ind#')) * (100-Evaluate('attributes.indirim4#row_ind#')) * (100-Evaluate('attributes.indirim5#row_ind#')) * (100-Evaluate('attributes.indirim6#row_ind#')) * (100-Evaluate('attributes.indirim7#row_ind#')) * (100-Evaluate('attributes.indirim8#row_ind#')) * (100-Evaluate('attributes.indirim9#row_ind#')) * (100-Evaluate('attributes.indirim10#row_ind#'));
                                    if(len(get_related_act.to_price_cat))
                                    {
                                        'attributes.price#row_ind#' = get_act_rows.PRICE[row_ind]*get_product_id.price_kdv/get_act_rows.PRICE[row_ind];
                                        'attributes.price_other#row_ind#' = get_act_rows.PRICE_OTHER[row_ind]*get_product_id.price_kdv/get_act_rows.PRICE[row_ind];
                                        'attributes.row_total#row_ind#' = get_product_id.price_kdv*get_act_rows.AMOUNT[row_ind];
                                        'attributes.row_nettotal#row_ind#' = wrk_round((Evaluate('attributes.row_total#row_ind#')/100000000000000000000)*Evaluate('attributes.indirim_carpan#row_ind#'),4);
                                        'attributes.row_otvtotal#row_ind#'= Evaluate('attributes.row_nettotal#row_ind#')*get_product_id.OTV/100;
                                        'attributes.row_taxtotal#row_ind#' = (Evaluate('attributes.row_nettotal#row_ind#')+(Evaluate('attributes.row_nettotal#row_ind#')*get_product_id.OTV/100))*get_act_rows.TAX[row_ind]/100;
                                        'attributes.row_lasttotal#row_ind#' = Evaluate('attributes.row_nettotal#row_ind#')+Evaluate('attributes.row_taxtotal#row_ind#')+Evaluate('attributes.row_otvtotal#row_ind#');
                                        'attributes.other_money_#row_ind#' = get_act_rows.OTHER_MONEY[row_ind];
                                        'attributes.other_money_value_#row_ind#' = Evaluate('attributes.row_nettotal#row_ind#')/get_row_rate.new_rate;
                                        
                                        form.basket_gross_total=form.basket_gross_total+Evaluate('attributes.row_total#row_ind#');
                                        form.basket_net_total=form.basket_net_total+Evaluate('attributes.row_lasttotal#row_ind#');
                                        attributes.basket_net_total=form.basket_net_total+Evaluate('attributes.row_lasttotal#row_ind#');
                                        form.basket_tax_total=form.basket_tax_total+Evaluate('attributes.row_taxtotal#row_ind#');
                                        form.basket_otv_total=form.basket_otv_total+Evaluate('attributes.row_otvtotal#row_ind#');
                                        form.basket_discount_total=form.basket_discount_total+Evaluate('attributes.row_total#row_ind#')-Evaluate('attributes.row_nettotal#row_ind#'); 
                                    }
                                    else
                                    {
                                        'attributes.price#row_ind#' = get_act_rows.PRICE[row_ind];
                                        'attributes.price_other#row_ind#' = get_act_rows.PRICE_OTHER[row_ind];
                                        'attributes.row_total#row_ind#' = get_act_rows.NETTOTAL[row_ind];
                                        'attributes.row_nettotal#row_ind#' = get_act_rows.NETTOTAL[row_ind];
                                        'attributes.row_otvtotal#row_ind#'= get_act_rows.NETTOTAL[row_ind]*get_product_id.OTV/100;
                                        'attributes.row_taxtotal#row_ind#' = get_act_rows.NETTOTAL[row_ind]*get_act_rows.TAX[row_ind]/100;
                                        'attributes.row_lasttotal#row_ind#' = get_act_rows.NETTOTAL[row_ind] + (get_act_rows.NETTOTAL[row_ind]*get_act_rows.TAX[row_ind]/100);
                                        'attributes.other_money_#row_ind#' = get_act_rows.OTHER_MONEY[row_ind];
                                        'attributes.other_money_value_#row_ind#' = get_act_rows.OTHER_MONEY_VALUE[row_ind];
                                        'attributes.other_money_gross_total#row_ind#' = get_act_rows.OTHER_MONEY_VALUE[row_ind] + (get_act_rows.OTHER_MONEY_VALUE[row_ind]*get_act_rows.TAX[row_ind]/100);
                                    }
                                    'attributes.price_cat#row_ind#'=get_act_rows.PRICE_CAT[row_ind];
                                    'attributes.product_account_code#row_ind#'='';
                                    'attributes.promosyon_maliyet#row_ind#'=get_act_rows.PROM_COST[row_ind];
                                    'attributes.promosyon_yuzde#row_ind#'=get_act_rows.PROM_COMISSION[row_ind];
                                    'attributes.prom_relation_id#row_ind#'=get_act_rows.PROM_RELATION_ID[row_ind];
                                    'attributes.prom_stock_id#row_ind#'=get_act_rows.PROM_STOCK_ID[row_ind];
                                    'attributes.reserve_date#row_ind#'='';
                                    'attributes.reserve_type#row_ind#'='-1';
                                    'attributes.row_promotion_id#row_ind#'=get_act_rows.PROM_ID[row_ind];
                                    'attributes.row_service_id#row_ind#'='';
                                    'attributes.row_ship_id#row_ind#'=0;
                                    'attributes.row_unique_relation_id#row_ind#'=get_act_rows.UNIQUE_RELATION_ID[row_ind];
                                    'attributes.shelf_number#row_ind#'=get_act_rows.SHELF_NUMBER[row_ind];
									/*	PY 0715
										spect var id den main id yi buluyoruz yeni şirkette bu spect main id varsa onun herhangi bir spect_var_id sini atıyoruz
										eğer bulduğumuz spect main id şirketimizde yoksa o stoğa ait herhangi bir spect main id ye bağlı spect var id çekip atıyoruz
										hiç spect main id yoksa atmıyoruz
									*/
									// grup içi işlemde spec kaydı atmayla ilgili düzenleme yapıldı, main spec varsa spec üretiyoruz yoksa boş atıyoruz 1115 PY
									if (get_product_id.IS_PRODUCTION eq 1)
									{
										SQLStr = 'SELECT TOP 1 SPECT_MAIN_ID FROM #new_dsn3_group#.SPECT_MAIN  AS SM WHERE SM.STOCK_ID = #evaluate("attributes.stock_id#row_ind#")# AND SM.IS_TREE = 1 ORDER BY SM.RECORD_DATE DESC,SM.UPDATE_DATE DESC';
										'GET_TREE#row_ind#' = cfquery(SQLString : SQLStr, Datasource : new_dsn2);
										if(not isdefined('attributes.company_id')) attributes.company_id = 0;
										if(not isdefined('attributes.consumer_id')) attributes.consumer_id = 0;
										if(evaluate('GET_TREE#row_ind#.RECORDCOUNT'))
										{
											'spec_info#row_ind#' = specer(
													dsn_type:new_dsn2,
													spec_type:1,
													main_spec_id:evaluate('GET_TREE#row_ind#.SPECT_MAIN_ID'),
													add_to_main_spec:1,
													company_id: attributes.company_id,
													is_company_related_action: 1,
													company_related_dsn: new_dsn3_group,
													consumer_id: attributes.consumer_id
												);
											if(isdefined('attributes.is_spect_name_to_property') and attributes.is_spect_name_to_property eq 1){//Spec ismi confg.ürünlerden oluşturuluyor ise!
												configure_spec_name = evaluate("attributes.product_name#row_ind#");
												GetProductConf(listgetat(Evaluate('spec_info#row_ind#'),1,','));//fonksiyon burda çağırlıyor ilk olarak
											}	
											if(isdefined('attributes.is_spect_name_to_property') and attributes.is_spect_name_to_property eq 1 and isdefined('spec_info#row_ind#')){
												SQLStr1 = 'UPDATE #new_dsn3_group#.SPECT_MAIN SET SPECT_MAIN_NAME = "#left(configure_spec_name,499)#" WHERE SPECT_MAIN_ID = #listgetat(Evaluate('spec_info#row_ind#'),1,',')# ';
												UpdateSpecNameQuery = cfquery(SQLString : SQLStr1, Datasource : new_dsn2);
												if(len(listgetat(Evaluate('spec_info#row_ind#'),1,',')) and listgetat(Evaluate('spec_info#row_ind#'),1,',') gt 0){
													SQLStr2 = 'UPDATE #new_dsn3_group#.SPECT_MAIN SET SPECT_MAIN_NAME = "#left(configure_spec_name,499)#" WHERE SPECT_MAIN_ID = #listgetat(Evaluate('spec_info#row_ind#'),1,',')# ';
													UpdateS_V_SpecNameQuery = cfquery(SQLString : SQLStr2, Datasource : new_dsn2);
												}
											}
											if(isdefined('spec_info#row_ind#') and listlen(evaluate('spec_info#row_ind#'),',')){
												'attributes.spect_id#row_ind#'=listgetat(evaluate('spec_info#row_ind#'),2,',');
												if(len(listgetat(evaluate('spec_info#row_ind#'),3,',')))
													'attributes.spect_name#row_ind#'=listgetat(evaluate('spec_info#row_ind#'),3,',');
												else
													'attributes.spect_name#row_ind#'=evaluate("attributes.product_name#row_ind#");
											}
											else
											{
												'attributes.spect_id#row_ind#'= '';
												'attributes.spect_name#row_ind#'='';	
											}
										}
										else
										{
											'attributes.spect_id#row_ind#'= '';
											'attributes.spect_name#row_ind#'='';	
										}
									}
									else
									{
										'attributes.spect_id#row_ind#'='';
										'attributes.spect_name#row_ind#'='';
									}
                                    'attributes.stock_id#row_ind#'=get_act_rows.STOCK_ID[row_ind];
                                    'attributes.unit#row_ind#'=get_act_rows.UNIT[row_ind];
                                    'attributes.unit_id#row_ind#'=get_act_rows.UNIT_ID[row_ind];
                                    'attributes.unit_other#row_ind#'=get_act_rows.UNIT2[row_ind];
                                    'attributes.basket_employee_id#row_ind#'=get_act_rows.BASKET_EMPLOYEE_ID[row_ind];
                                    'attributes.basket_extra_info#row_ind#'=get_act_rows.BASKET_EXTRA_INFO_ID[row_ind];
                                    'attributes.select_info_extra#row_ind#'=get_act_rows.SELECT_INFO_EXTRA[row_ind];
                                    'attributes.detail_info_extra#row_ind#'=get_act_rows.DETAIL_INFO_EXTRA[row_ind];
                                    if(isdefined('session.pp.userid'))
                                        'attributes.wrk_row_id#row_ind#'="WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.pp.userid##round(rand()*100)#";
                                    else if(isdefined('session.ww.userid'))
                                        'attributes.wrk_row_id#row_ind#'="WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ww.userid##round(rand()*100)#";
                                    else
                                        'attributes.wrk_row_id#row_ind#'="WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)#";
                                    'attributes.wrk_row_relation_id#row_ind#'=get_act_rows.WRK_ROW_ID[row_ind];
                                    attributes.rows_ = row_ind;
                                </cfscript>
                            </cfloop>
                            <cfscript>
                                for(ind_inv_row=1;ind_inv_row lte attributes.rows_;ind_inv_row=ind_inv_row+1)
                                {
                                    //fatura altı indirim varsa ona hesaplanarak satırlara yansıtılıyor
                                    if(get_act_rows.PRICE[row_ind] neq 0)
                                        row_price_=get_act_rows.PRICE[ind_inv_row]*get_product_id.price_kdv/get_act_rows.PRICE[row_ind]*get_act_rows.AMOUNT[ind_inv_row];
                                    else
                                        row_price_ = 0;
                                    tmp_tax=0;
                                    for(ind_tax_count=1;ind_tax_count lte xml_tax_count;ind_tax_count=ind_tax_count+1)
                                    {
                                        if(isdefined('form.basket_tax_#ind_tax_count#') and evaluate('form.basket_tax_#ind_tax_count#') eq evaluate('attributes.tax#ind_inv_row#'))
                                        {
                                            'form.basket_tax_value_#ind_tax_count#' =evaluate('form.basket_tax_value_#ind_tax_count#') + wrk_round((row_price_/100)*get_act_rows.TAX[ind_inv_row],2);
                                            tmp_tax=1;
                                            break;
                                        }
                                    }
                                    if(tmp_tax eq 0)
                                    {
                                        'form.basket_tax_#xml_tax_count#' = evaluate('attributes.tax#ind_inv_row#');
                                        'form.basket_tax_value_#xml_tax_count#' =  wrk_round((row_price_/100)*get_act_rows.TAX[ind_inv_row],2);
                                        xml_tax_count=xml_tax_count+1;
                                    }
                                    tmp_otv=0;
                                    for(ind_otv_count=1;ind_otv_count lte xml_otv_count;ind_otv_count=ind_otv_count+1)
                                    {
                                        if(isdefined('form.basket_otv_#ind_otv_count#') and evaluate('form.basket_otv_#ind_otv_count#') eq get_product_id.OTV)
                                        {
                                            'form.basket_otv_value_#ind_otv_count#'= evaluate('form.basket_otv_value_#ind_otv_count#') + wrk_round((row_price_/100)*get_product_id.OTV,2);
                                            tmp_otv=1;
                                            break;
                                        }
                                    }
                                    if(tmp_otv eq 0)	
                                    {
                                        'form.basket_otv_#xml_otv_count#'= get_product_id.OTV;
                                        'form.basket_otv_value_#xml_otv_count#'= wrk_round((row_price_/100)*get_product_id.OTV,2);
                                        xml_otv_count=xml_otv_count+1;
                                    }
                                }
                            </cfscript>
                            <cfscript>
                                form.basket_otv_count = xml_otv_count-1;//otv oran sayısı
                                form.basket_tax_count = xml_tax_count-1;//kdv sayısı
                                xml_import=1;
                                is_from_import=1;
                            </cfscript>
                            <cfif get_related_act.to_act_type eq 1>
                                <cfinclude template="../../sales/query/add_order.cfm">
                            <cfelseif get_related_act.to_act_type eq 5>
                                <cfset xml_import=1>
                                <cfinclude template="../../stock/query/add_sale.cfm">
                            <cfelseif get_related_act.to_act_type eq 6>
                                <cfset xml_import=1>
                                <cfinclude template="../../stock/query/add_purchase.cfm">
                            </cfif>
                        <cfelse>
                            
                        	<cfif not isdefined("attributes.is_web_service")>
								<script type="text/javascript">
                                    alert("Belgeniz Kaydedildi Fakat Grup İçi İlişkili İşlem Kaydı Yapılamadı ! Ürün ve Fiyat Tanımlarınızı Kontrol Ediniz !");
                                </script>
                                <cfabort>
                            <cfelse>
                            	<cfset attributes.group_error = 1>
                            </cfif>
                        </cfif>
                    <cfelse>
                    	<cfif not isdefined("attributes.is_web_service")>
							<script type="text/javascript">
                                alert("Belgeniz Kaydedildi Fakat Grup İçi İlişkili İşlem Kaydı Yapılamadı ! Aktarılacak Şirketteki Muhasebe Dönem Kısıtını Kontrol Ediniz !");
                            </script>
                            <cfabort>
                        <cfelse>
                        	<cfset attributes.group_error = 1>
                        </cfif>
                    </cfif> 
                </cfif>
            </cfif>
		<cfelseif action_type eq 3><!--- Satış faturası İse --->
			<cfquery name="get_act_detail" datasource="#new_dsn2#">
				SELECT * FROM INVOICE WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
			</cfquery>
            <cfif get_act_detail.recordcount and len(get_act_detail.company_id)>
				<cfquery name="get_related_act" datasource="#new_dsn2#">
					SELECT ISNULL(TO_COMPANY_ID,#get_act_detail.company_id#) TO_COMPANY_ID_,* FROM #dsn_alias#.COMPANY_GROUP_ACTIONS WHERE FROM_ACT_TYPE = 3 AND TO_ACT_TYPE IN(3,4) AND FROM_OUR_COMP_ID =#arguments.comp_id# AND (FROM_COMPANY_ID IS NULL OR FROM_COMPANY_ID = #get_act_detail.company_id#) AND (FROM_PROCESS_TYPE IS NULL OR FROM_PROCESS_TYPE = #get_act_detail.process_cat#)
				</cfquery>
				<cfif get_related_act.recordcount>
					<cfset new_comp_id = get_related_act.to_our_comp_id> 
					<cfset new_dsn3_group = "#dsn#_#get_related_act.to_our_comp_id#"> 
					<cfset new_dsn2_group = "#dsn#_#session.ep.period_year#_#get_related_act.to_our_comp_id#"> 
					<cfquery name="getCompanyPeriodId" datasource="#dsn#">
						SELECT PERIOD_ID FROM SETUP_PERIOD WHERE PERIOD_YEAR = #session.ep.period_year# AND OUR_COMPANY_ID = #new_comp_id#
					</cfquery>
                    <cfset new_period_id = getCompanyPeriodId.PERIOD_ID>
					<!--- grup ici islem ile kaydedilen belgenin doneminde tarih kısıtı var ise kaydetmemesi gerekiyor --->
                    <cfset userPeriodDate = getUserPeriodDate(comp_id:new_comp_id)>
                    <cfif userPeriodDate lt get_act_detail.invoice_date>
                        <cfquery name="get_act_rows" datasource="#new_dsn2#">
                            SELECT * FROM INVOICE_ROW WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> ORDER BY INVOICE_ROW_ID
                        </cfquery>
                        
                        <!--- 
                            FA 08122014 
                            iki şirketin sistem para birimleri farklı ise karşı şirkette kur ve fiyatların düzeltilmesi için oran bulunur ve fiyatlar bu oran ile düzenlenir 
                            sistem para birimi aynı olan şirketlerde bu oran zaten 1 olacaktır
                            sistem para birimi farklı olan şirketlerde oran kaydedilen belgeden yeniden hesaplanır 
                        --->
                        <cfquery name="getMoneyNewRateToCompany" datasource="#new_dsn2#">
                            SELECT
                                IM.RATE2/IM2.RATE2 NEW_RATE
                            FROM 
                                INVOICE_MONEY IM
                                LEFT JOIN INVOICE_MONEY IM2 ON IM2.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> AND IM2.MONEY_TYPE = (SELECT MONEY FROM #new_dsn2_group#.SETUP_MONEY WHERE RATE2/RATE1 = 1)
                            WHERE 
                                IM.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> AND
                                IM.RATE1/IM.RATE2 = 1
                        </cfquery>
                        <cfset newRateToCompany = getMoneyNewRateToCompany.NEW_RATE>
                        <cfquery name="get_money" datasource="#new_dsn2#">
                            SELECT (RATE2*#newRateToCompany#) AS RATE2,RATE1,MONEY_TYPE,IS_SELECTED FROM INVOICE_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
                        </cfquery>
                        <cfquery name="get_money_selected" dbtype="query">
                            SELECT RATE2,RATE1,MONEY_TYPE FROM get_money WHERE IS_SELECTED=1
                        </cfquery>
                        
                        <cfquery name="get_to_period_id" datasource="#dsn#">
                            SELECT PERIOD_ID FROM SETUP_PERIOD WHERE PERIOD_YEAR=#session.ep.period_year# AND OUR_COMPANY_ID = #get_related_act.to_our_comp_id#
                        </cfquery>
                        <cfset new_period_id = get_to_period_id.period_id>
                        <cfquery name="get_member_id" datasource="#new_dsn2#">
                            SELECT
                                COMPANY.COMPANY_ID,
                                ISNULL(COMPANY.MANAGER_PARTNER_ID,(SELECT TOP 1 PARTNER_ID FROM #dsn_alias#.COMPANY_PARTNER WHERE COMPANY_ID=COMPANY.COMPANY_ID)) PARTNER_ID,
                                COMPANY_PERIOD.ACCOUNT_CODE
                            FROM 
                                #dsn_alias#.COMPANY,
                                #dsn_alias#.COMPANY_PERIOD
                            WHERE
                                COMPANY.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_act.TO_COMPANY_ID_#"> AND
                                COMPANY_PERIOD.COMPANY_ID = COMPANY.COMPANY_ID AND
                                COMPANY_PERIOD.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#new_period_id#">
                        </cfquery>
                        <cfquery name="get_partner" datasource="#dsn#">
                            SELECT MANAGER_PARTNER_ID,NICKNAME FROM COMPANY WHERE COMPANY_ID = #get_related_act.TO_COMPANY_ID_#
                        </cfquery>
                        <cfscript>
                            if(get_related_act.to_act_type eq 4)
                                form.sale_product=0;
                            else
                                form.sale_product=1;
                            form.process_cat=get_related_act.to_process_type;
                            invoice_cat=get_related_act.to_process_type;
                            form.active_company="#arguments.comp_id#";
                            attributes.rows_ = get_act_rows.recordcount;
                            attributes.department_id=get_related_act.to_dept_id;
                            attributes.location_id=get_related_act.to_loc_id;
                            attributes.process_stage=get_related_act.to_process_stage;
                            EMPO_ID =get_related_act.to_sale_emp;
                            attributes.DELIVER_GET =get_emp_info(get_related_act.to_sale_emp,0,0);
                            attributes.DELIVER_GET_ID =get_related_act.to_sale_emp;
                            form.DELIVER_GET =get_emp_info(get_related_act.to_sale_emp,0,0);
                            form.DELIVER_GET_ID =get_related_act.to_sale_emp;
                            attributes.EMPO_ID =get_related_act.to_sale_emp;
                            attributes.PARTNER_NAMEO =get_related_act.to_sale_emp;
                            attributes.company_id=get_related_act.TO_COMPANY_ID_;
                            attributes.partner_id=get_partner.MANAGER_PARTNER_ID;
                            attributes.comp_name='a';
                            attributes.partner_name='b';
                            attributes.consumer_id='';
                            
                            attributes.reserved = 1;
                            attributes.invoice_number='';
                            form.invoice_number='';
                            attributes.ref_no='';
                            attributes.invoice_date=dateformat(get_act_detail.invoice_date,dateformat_style);
                            attributes.invoice_date_h = hour(dateadd('h',session.ep.time_zone,get_act_detail.PROCESS_TIME));
                            attributes.invoice_date_m = minute(get_act_detail.PROCESS_TIME);
                            attributes.order_id = '';
                            attributes.kasa='';
                            kasa='';
                            attributes.member_account_code=GET_MEMBER_ID.ACCOUNT_CODE;
                            note=get_act_detail.note;
                            attributes.city_id='';
                            attributes.county_id='';
                            attributes.adres=get_act_detail.SHIP_ADDRESS;
                            for(stp_mny=1;stp_mny lte GET_MONEY.RECORDCOUNT;stp_mny=stp_mny+1)
                            {
                                'attributes.hidden_rd_money_#stp_mny#'=GET_MONEY.MONEY_TYPE[stp_mny];
                                'attributes.txt_rate1_#stp_mny#'=GET_MONEY.RATE1[stp_mny];	
                                'attributes.txt_rate2_#stp_mny#'=GET_MONEY.RATE2[stp_mny];
                            }
                            form.basket_money=GET_MONEY_SELECTED.MONEY_TYPE;
                            attributes.basket_money=GET_MONEY_SELECTED.MONEY_TYPE;
                            form.basket_rate1=GET_MONEY_SELECTED.RATE1;
                            form.basket_rate2=GET_MONEY_SELECTED.RATE2;
                            attributes.basket_rate1=GET_MONEY_SELECTED.RATE1;
                            attributes.basket_rate2=GET_MONEY_SELECTED.RATE2;
                            attributes.kur_say=GET_MONEY.RECORDCOUNT;
                            attributes.basket_id=2;
                            attributes.list_payment_row_id='';
                            attributes.subscription_id='';
                            attributes.invoice_counter_number='';
                            attributes.commethod_id='';
                            attributes.bool_from_control_bill='';
                            attributes.invoice_control_id='';
                            attributes.contract_row_ids='';
                            attributes.ship_method=get_act_detail.SHIP_METHOD;
                            attributes.card_paymethod_id=get_act_detail.CARD_PAYMETHOD_ID;
                            attributes.commission_rate=get_act_detail.CARD_PAYMETHOD_RATE;
                            attributes.paymethod_id=get_related_act.TO_PAYMETHOD_ID;
                            attributes.deliver_dept_id=get_related_act.TO_DEPT_ID;
                            attributes.deliver_loc_id=get_related_act.TO_LOC_ID;
                            attributes.deliver_dept_name=get_related_act.TO_DEPT_ID;
                            attributes.project_id=get_act_detail.PROJECT_ID;
                            PARTO_ID='';
                            attributes.deliverdate = dateformat(get_act_detail.invoice_date,dateformat_style); 
                            attributes.ship_date = dateformat(get_act_detail.invoice_date,dateformat_style); 	
                            attributes.yuvarlama=0;
                            form.serial_number = get_act_detail.serial_number;
                            form.serial_no = get_act_detail.serial_no;
                            form.invoice_number = get_act_detail.invoice_number;
                            attributes.ref_company_id = "";
                            attributes.ref_member_type = "";
                            attributes.ref_member_id = "";
                            attributes.ref_company = "";
                            inventory_product_exists = 0;
                            attributes.tevkifat_oran='';
                            attributes.is_general_prom=0;
                            attributes.indirim_total='100000000000000000000,100000000000000000000';
                            attributes.general_prom_limit='';
                            attributes.general_prom_discount='';
                            attributes.general_prom_amount=0;
                            attributes.free_prom_limit='';
                            attributes.flt_net_total_all=0;
                            attributes.currency_multiplier = '';
                            attributes.basket_member_pricecat='';
                            attributes.basket_due_value_date_='';
                            attributes.BASKET_PRICE_ROUND_NUMBER = 4;
                            form.genel_indirim=get_act_detail.SA_DISCOUNT*newRateToCompany;
                            form.basket_gross_total=0;
                            form.basket_net_total=0;
                            attributes.basket_net_total=0;
                            form.basket_tax_total=0;
                            form.basket_otv_total=0;
                            form.basket_discount_total = 0;
                            xml_tax_count=1;//kdv sayısı
                            xml_otv_count=1;//otv sayısı
                        </cfscript>
                        <cfloop query="get_act_rows">
                            <cfset row_ind = get_act_rows.currentrow>
                            <cfif isdefined("is_action_file_") and is_action_file_ eq 1 and Len(new_product_id_)>
                                <cfset 'attributes.product_id#row_ind#' = new_product_id_>
                            <cfelse>
                                <cfset 'attributes.product_id#row_ind#' = get_act_rows.PRODUCT_ID[row_ind]>
                            </cfif>
                            <cfquery name="get_product_id" datasource="#new_dsn2#">
                                SELECT
                                    S.BARCOD BARCODE,
                                    S.STOCK_ID,
                                    S.PRODUCT_ID,
                                    S.STOCK_CODE,
                                    S.PRODUCT_NAME,
                                    S.PROPERTY,
                                    S.IS_INVENTORY,
                                    S.MANUFACT_CODE,
                                    S.TAX,
                                    ISNULL(S.OTV,0) OTV,
                                    S.IS_PRODUCTION
                                    <cfif len(get_related_act.to_price_cat)>
                                        ,PP.PRICE PRICE_KDV
                                    <cfelse>
                                        ,#get_act_rows.price# PRICE_KDV
                                    </cfif>
                                FROM
                                    #new_dsn3_group#.STOCKS AS S
                                    <cfif len(get_related_act.to_price_cat)>
                                        ,#new_dsn3_group#.PRICE AS PP
                                    </cfif>
                                WHERE
                                    S.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.product_id#row_ind#')#">
                                    <cfif len(get_related_act.to_price_cat)>
                                        AND PP.PRODUCT_ID = S.PRODUCT_ID
                                        AND PP.PRICE_CATID = #get_related_act.to_price_cat#
                                        AND PP.STARTDATE <= #createodbcdatetime(get_act_detail.invoice_date)#
                                        AND (PP.FINISHDATE IS NULL OR PP.FINISHDATE >= #createodbcdatetime(get_act_detail.invoice_date)#)
                                    </cfif>
                            </cfquery>
                            <cfquery name="get_row_rate" dbtype="query">
                                SELECT RATE2/RATE1 NEW_RATE FROM get_money WHERE MONEY_TYPE = '#get_act_rows.other_money#'
                            </cfquery>
                            <cfif len(get_act_rows.OTV_ORAN[row_ind]) and get_act_rows.OTV_ORAN[row_ind] neq 0>
                                <cfquery name="get_otv" datasource="#new_dsn3_group#">
                                    SELECT * FROM SETUP_OTV WHERE TAX = #get_act_rows.OTV_ORAN[row_ind]# AND PERIOD_ID = #get_to_period_id.PERIOD_ID#
                                </cfquery>
                            <cfelse>
                                <cfset get_otv.recordcount = 0>
                            </cfif>
                            <cfif len(get_related_act.to_price_cat) and get_product_id.recordcount>
                                <!--- Sözleşme İndirimleri --->
                                <cfquery name="get_contract_discounts" datasource="#new_dsn3_group#" maxrows="1">
                                    SELECT
                                        ISNULL(PC.DISCOUNT_RATE,0) DISCOUNT_RATE,
                                        ISNULL(PC.DISCOUNT_RATE_2,0) DISCOUNT_RATE_2,
                                        ISNULL(PC.DISCOUNT_RATE_3,0) DISCOUNT_RATE_3,
                                        ISNULL(PC.DISCOUNT_RATE_4,0) DISCOUNT_RATE_4,
                                        ISNULL(PC.DISCOUNT_RATE_5,0) DISCOUNT_RATE_5,
                                        PC.PAYMENT_TYPE_ID
                                    FROM 
                                        PRICE_CAT_EXCEPTIONS PC,
                                        RELATED_CONTRACT RC
                                    WHERE
                                        PC.CONTRACT_ID = RC.CONTRACT_ID
                                        AND (PC.SUPPLIER_ID IS NULL OR PC.SUPPLIER_ID = (SELECT COMPANY_ID FROM STOCKS WHERE STOCK_ID=#get_product_id.stock_id#))
                                        AND (PC.PRODUCT_ID IS NULL OR PC.PRODUCT_ID=#get_product_id.product_id#)
                                        AND (PC.BRAND_ID IS NULL OR PC.BRAND_ID=(SELECT BRAND_ID FROM STOCKS WHERE STOCK_ID=#get_product_id.stock_id#))
                                        AND (PC.PRODUCT_CATID IS NULL OR PC.PRODUCT_CATID=(SELECT PRODUCT_CATID FROM STOCKS WHERE STOCK_ID=#get_product_id.stock_id#) OR (SELECT STOCK_CODE FROM STOCKS WHERE STOCK_ID=#get_product_id.stock_id#) LIKE (SELECT PCC.HIERARCHY FROM PRODUCT_CAT PCC WHERE PCC.PRODUCT_CATID = PC.PRODUCT_CATID)+'.%')
                                        AND (PC.SHORT_CODE_ID IS NULL OR PC.SHORT_CODE_ID=(SELECT SHORT_CODE_ID FROM STOCKS WHERE STOCK_ID=#get_product_id.stock_id#))
                                        AND RC.STARTDATE <= #createodbcdatetime(get_act_detail.invoice_date)#
                                        AND RC.FINISHDATE >= #createodbcdatetime(get_act_detail.invoice_date)#
                                        AND	RC.COMPANY LIKE '%,#get_related_act.TO_COMPANY_ID#,%'
                                        AND PC.PRICE_CATID=#get_related_act.to_price_cat#
                                    ORDER BY 
                                        PC.PRODUCT_ID DESC,PC.BRAND_ID DESC,(SELECT PCC.HIERARCHY FROM PRODUCT_CAT PCC WHERE PCC.PRODUCT_CATID = PC.PRODUCT_CATID) DESC,PC.PRODUCT_CATID DESC,PC.SUPPLIER_ID DESC,PC.COMPANYCAT_ID DESC,PC.SHORT_CODE_ID DESC
                                </cfquery>
                            </cfif>
                            <cfscript>
                                'attributes.product_name#row_ind#'=get_act_rows.NAME_PRODUCT[row_ind];
                                'attributes.product_name_other#row_ind#'=get_act_rows.PRODUCT_NAME2[row_ind];
                                'attributes.tax#row_ind#'= get_act_rows.TAX[row_ind];
                                'attributes.is_inventory#row_ind#'=get_product_id.IS_INVENTORY;
                                if(get_product_id.IS_INVENTORY) inventory_product_exists = 1;
                                'attributes.is_production#row_ind#'=get_product_id.IS_PRODUCTION;
                                'attributes.amount#row_ind#'=get_act_rows.AMOUNT[row_ind];
                                'attributes.deliver_date#row_ind#'=get_act_rows.DELIVER_DATE[row_ind];
                                'attributes.deliver_dept#row_ind#'="#get_related_act.TO_DEPT_ID#-#get_related_act.TO_LOC_ID#";
                                'attributes.duedate#row_ind#'=get_act_rows.DUE_DATE[row_ind];
                                'attributes.ek_tutar#row_ind#'=get_act_rows.EXTRA_PRICE[row_ind]*newRateToCompany;
                                'attributes.ek_tutar_price#row_ind#'=get_act_rows.EK_TUTAR_PRICE[row_ind]*newRateToCompany;
                                'attributes.ek_tutar_other_total#row_ind#'=get_act_rows.EXTRA_PRICE_TOTAL[row_ind]*newRateToCompany;
                                'attributes.ek_tutar_total#row_ind#'=get_act_rows.EXTRA_PRICE_OTHER_TOTAL[row_ind]*newRateToCompany;
                                'attributes.extra_cost#row_ind#'=get_act_rows.EXTRA_COST[row_ind]*newRateToCompany;
                                'attributes.iskonto_tutar#row_ind#'=get_act_rows.DISCOUNT_COST[row_ind]*newRateToCompany;
                                'attributes.is_commission#row_ind#'=get_act_rows.IS_COMMISSION[row_ind];
                    
                                'attributes.is_promotion#row_ind#'=get_act_rows.IS_PROMOTION[row_ind];
                                'attributes.karma_product_id#row_ind#'=get_act_rows.KARMA_PRODUCT_ID[row_ind];
                                'attributes.list_price#row_ind#'=get_act_rows.LIST_PRICE[row_ind]*newRateToCompany;
                                    
                                'attributes.lot_no#row_ind#'=get_act_rows.LOT_NO[row_ind];
                                'attributes.manufact_code#row_ind#'=get_act_rows.PRODUCT_MANUFACT_CODE[row_ind];
                                'attributes.marj#row_ind#'=get_act_rows.MARGIN[row_ind];
                                'attributes.net_maliyet#row_ind#'=get_act_rows.COST_PRICE[row_ind]*newRateToCompany;
                                'attributes.number_of_installment#row_ind#'=get_act_rows.NUMBER_OF_INSTALLMENT[row_ind];
                                'attributes.order_currency#row_ind#'='-1';
                                
                                if(len(get_act_rows.OTV_ORAN[row_ind]) and get_act_rows.OTV_ORAN[row_ind] neq 0 and get_otv.recordcount)
                                {
                                    'attributes.otv_oran#row_ind#'=get_act_rows.OTV_ORAN[row_ind];
                                    'attributes.row_otvtotal#row_ind#'=get_act_rows.OTVTOTAL[row_ind]*newRateToCompany;															
                                }
                                else
                                {
                                    'attributes.otv_oran#row_ind#'=0;
                                    'attributes.row_otvtotal#row_ind#'=0;															
                                }
                                
                                if(len(get_related_act.to_price_cat))
                                {
                                    if(get_contract_discounts.recordcount)
                                    {
                                        'attributes.indirim1#row_ind#'=get_contract_discounts.DISCOUNT_RATE;
                                        'attributes.indirim2#row_ind#'=get_contract_discounts.DISCOUNT_RATE_2;
                                        'attributes.indirim3#row_ind#'=get_contract_discounts.DISCOUNT_RATE_3;
                                        'attributes.indirim4#row_ind#'=get_contract_discounts.DISCOUNT_RATE_4;
                                        'attributes.indirim5#row_ind#'=get_contract_discounts.DISCOUNT_RATE_5;
                                        'attributes.indirim6#row_ind#'=0;
                                        'attributes.indirim7#row_ind#'=0;
                                        'attributes.indirim8#row_ind#'=0;
                                        'attributes.indirim9#row_ind#'=0;
                                        'attributes.indirim10#row_ind#'=0;
                                    }
                                    else
                                    {
                                        'attributes.indirim1#row_ind#'=0;
                                        'attributes.indirim2#row_ind#'=0;
                                        'attributes.indirim3#row_ind#'=0;
                                        'attributes.indirim4#row_ind#'=0;
                                        'attributes.indirim5#row_ind#'=0;
                                        'attributes.indirim6#row_ind#'=0;
                                        'attributes.indirim7#row_ind#'=0;
                                        'attributes.indirim8#row_ind#'=0;
                                        'attributes.indirim9#row_ind#'=0;
                                        'attributes.indirim10#row_ind#'=0;
                                    }
                                }
                                else
                                {
                                    'attributes.indirim1#row_ind#'=get_act_rows.DISCOUNT1[row_ind];
                                    'attributes.indirim2#row_ind#'=get_act_rows.DISCOUNT2[row_ind];
                                    'attributes.indirim3#row_ind#'=get_act_rows.DISCOUNT3[row_ind];
                                    'attributes.indirim4#row_ind#'=get_act_rows.DISCOUNT4[row_ind];
                                    'attributes.indirim5#row_ind#'=get_act_rows.DISCOUNT5[row_ind];
                                    'attributes.indirim6#row_ind#'=get_act_rows.DISCOUNT6[row_ind];
                                    'attributes.indirim7#row_ind#'=get_act_rows.DISCOUNT7[row_ind];
                                    'attributes.indirim8#row_ind#'=get_act_rows.DISCOUNT8[row_ind];
                                    'attributes.indirim9#row_ind#'=get_act_rows.DISCOUNT9[row_ind];
                                    'attributes.indirim10#row_ind#'=get_act_rows.DISCOUNT10[row_ind];
                                }
                                'attributes.indirim_carpan#row_ind#' = (100-Evaluate('attributes.indirim1#row_ind#')) * (100-Evaluate('attributes.indirim2#row_ind#')) * (100-Evaluate('attributes.indirim3#row_ind#')) * (100-Evaluate('attributes.indirim4#row_ind#')) * (100-Evaluate('attributes.indirim5#row_ind#')) * (100-Evaluate('attributes.indirim6#row_ind#')) * (100-Evaluate('attributes.indirim7#row_ind#')) * (100-Evaluate('attributes.indirim8#row_ind#')) * (100-Evaluate('attributes.indirim9#row_ind#')) * (100-Evaluate('attributes.indirim10#row_ind#'));
                                if(len(get_act_rows.OTV_ORAN[row_ind]) and get_otv.recordcount eq 0)
                                    row_price = get_product_id.price_kdv+(get_product_id.price_kdv*get_act_rows.OTV_ORAN[row_ind]/100);
                                else
                                    row_price = get_product_id.price_kdv;
                                if(get_act_rows.PRICE[row_ind] neq 0)
                                {
                                    'attributes.price#row_ind#' = get_act_rows.PRICE[row_ind]*row_price/get_act_rows.PRICE[row_ind]*newRateToCompany;
                                    'attributes.price_other#row_ind#' = get_act_rows.PRICE_OTHER[row_ind]*row_price/get_act_rows.PRICE[row_ind];
                                }
                                else
                                {
                                    'attributes.price#row_ind#' = 0;
                                    'attributes.price_other#row_ind#' = 0;
                                }
                                'attributes.row_total#row_ind#' = row_price*get_act_rows.AMOUNT[row_ind]*newRateToCompany;
                                'form.row_total#row_ind#' = row_price*get_act_rows.AMOUNT[row_ind]*newRateToCompany;
                                'attributes.row_nettotal#row_ind#' = wrk_round((Evaluate('attributes.row_total#row_ind#')/100000000000000000000)*Evaluate('attributes.indirim_carpan#row_ind#'),4);
                                'form.row_nettotal#row_ind#' = wrk_round((Evaluate('attributes.row_total#row_ind#')/100000000000000000000)*Evaluate('attributes.indirim_carpan#row_ind#'),4);
                                'attributes.row_otvtotal#row_ind#'= Evaluate('attributes.row_nettotal#row_ind#')*evaluate('attributes.otv_oran#row_ind#')/100;
                                'form.row_otvtotal#row_ind#'= Evaluate('attributes.row_nettotal#row_ind#')*evaluate('attributes.otv_oran#row_ind#')/100;
                                'attributes.row_taxtotal#row_ind#' = (Evaluate('attributes.row_nettotal#row_ind#')+Evaluate('attributes.row_otvtotal#row_ind#'))*get_act_rows.TAX[row_ind]/100;
                                'form.row_taxtotal#row_ind#' = (Evaluate('attributes.row_nettotal#row_ind#')+Evaluate('attributes.row_otvtotal#row_ind#'))*get_act_rows.TAX[row_ind]/100;
                                'attributes.row_lasttotal#row_ind#' = Evaluate('attributes.row_nettotal#row_ind#')+Evaluate('attributes.row_taxtotal#row_ind#')+Evaluate('attributes.row_otvtotal#row_ind#');
                                'form.row_lasttotal#row_ind#' = Evaluate('attributes.row_nettotal#row_ind#')+Evaluate('attributes.row_taxtotal#row_ind#')+Evaluate('attributes.row_otvtotal#row_ind#');
                                'attributes.row_lasttotal_#row_ind#' = Evaluate('attributes.row_nettotal#row_ind#')+Evaluate('attributes.row_otvtotal#row_ind#');
                                'form.row_lasttotal_#row_ind#' = Evaluate('attributes.row_nettotal#row_ind#')+Evaluate('attributes.row_otvtotal#row_ind#');
                                'attributes.other_money_#row_ind#' = get_act_rows.OTHER_MONEY[row_ind];
                                'form.other_money_#row_ind#' = get_act_rows.OTHER_MONEY[row_ind];
                                'attributes.other_money_value_#row_ind#' = Evaluate('attributes.row_nettotal#row_ind#')/get_row_rate.new_rate;
                                'form.other_money_value_#row_ind#' = Evaluate('attributes.row_nettotal#row_ind#')/get_row_rate.new_rate;
                                
                                form.basket_gross_total=form.basket_gross_total+Evaluate('attributes.row_total#row_ind#');
                                form.basket_net_total=form.basket_net_total+Evaluate('attributes.row_lasttotal#row_ind#');
                                attributes.basket_net_total=form.basket_net_total+Evaluate('attributes.row_lasttotal#row_ind#');
                                form.basket_otv_total=form.basket_otv_total+Evaluate('attributes.row_otvtotal#row_ind#');
                                form.basket_tax_total=form.basket_tax_total+Evaluate('attributes.row_taxtotal#row_ind#');
                                form.basket_discount_total=form.basket_discount_total+Evaluate('attributes.row_total#row_ind#')-Evaluate('attributes.row_nettotal#row_ind#'); 
                                'attributes.price_cat#row_ind#'=get_act_rows.PRICE_CAT[row_ind];
                                'attributes.product_account_code#row_ind#'='';
                                'attributes.promosyon_maliyet#row_ind#'=get_act_rows.PROM_COST[row_ind];
                                'attributes.promosyon_yuzde#row_ind#'=get_act_rows.PROM_COMISSION[row_ind];
                                'attributes.prom_relation_id#row_ind#'=get_act_rows.PROM_RELATION_ID[row_ind];
                                'attributes.prom_stock_id#row_ind#'=get_act_rows.PROM_STOCK_ID[row_ind];
                                'attributes.reserve_date#row_ind#'='';
                                'attributes.reserve_type#row_ind#'='-1';
                                'attributes.row_promotion_id#row_ind#'=get_act_rows.PROM_ID[row_ind];
                                'attributes.row_service_id#row_ind#'='';
                                'attributes.row_ship_id#row_ind#'=0;
                                'attributes.row_unique_relation_id#row_ind#'=get_act_rows.UNIQUE_RELATION_ID[row_ind];
                                'attributes.shelf_number#row_ind#'=get_act_rows.SHELF_NUMBER[row_ind];
								/*	PY 0715
									spect var id den main id yi buluyoruz yeni şirkette bu spect main id varsa onun herhangi bir spect_var_id sini atıyoruz
									eğer bulduğumuz spect main id şirketimizde yoksa o stoğa ait herhangi bir spect main id ye bağlı spect var id çekip atıyoruz
									hiç spect main id yoksa atmıyoruz
								*/
								// grup içi işlemde spec kaydı atmayla ilgili düzenleme yapıldı, main spec varsa spec üretiyoruz yoksa boş atıyoruz 1115 PY
								if (get_product_id.IS_PRODUCTION eq 1)
								{
									SQLStr = 'SELECT TOP 1 SPECT_MAIN_ID FROM #new_dsn3_group#.SPECT_MAIN  AS SM WHERE SM.STOCK_ID = #evaluate("attributes.stock_id#row_ind#")# AND SM.IS_TREE = 1 ORDER BY SM.RECORD_DATE DESC,SM.UPDATE_DATE DESC';
									'GET_TREE#row_ind#' = cfquery(SQLString : SQLStr, Datasource : new_dsn2);
									if(not isdefined('attributes.company_id')) attributes.company_id = 0;
									if(not isdefined('attributes.consumer_id')) attributes.consumer_id = 0;
									if(evaluate('GET_TREE#row_ind#.RECORDCOUNT'))
									{
										'spec_info#row_ind#' = specer(
												dsn_type:new_dsn2,
												spec_type:1,
												main_spec_id:evaluate('GET_TREE#row_ind#.SPECT_MAIN_ID'),
												add_to_main_spec:1,
												company_id: attributes.company_id,
												is_company_related_action: 1,
												company_related_dsn: new_dsn3_group,
												consumer_id: attributes.consumer_id
											);
										if(isdefined('attributes.is_spect_name_to_property') and attributes.is_spect_name_to_property eq 1){//Spec ismi confg.ürünlerden oluşturuluyor ise!
											configure_spec_name = evaluate("attributes.product_name#row_ind#");
											GetProductConf(listgetat(Evaluate('spec_info#row_ind#'),1,','));//fonksiyon burda çağırlıyor ilk olarak
										}	
										if(isdefined('attributes.is_spect_name_to_property') and attributes.is_spect_name_to_property eq 1 and isdefined('spec_info#row_ind#')){
											SQLStr1 = 'UPDATE #new_dsn3_group#.SPECT_MAIN SET SPECT_MAIN_NAME = "#left(configure_spec_name,499)#" WHERE SPECT_MAIN_ID = #listgetat(Evaluate('spec_info#row_ind#'),1,',')# ';
											UpdateSpecNameQuery = cfquery(SQLString : SQLStr1, Datasource : new_dsn2);
											if(len(listgetat(Evaluate('spec_info#row_ind#'),1,',')) and listgetat(Evaluate('spec_info#row_ind#'),1,',') gt 0){
												SQLStr2 = 'UPDATE #new_dsn3_group#.SPECT_MAIN SET SPECT_MAIN_NAME = "#left(configure_spec_name,499)#" WHERE SPECT_MAIN_ID = #listgetat(Evaluate('spec_info#row_ind#'),1,',')# ';
												UpdateS_V_SpecNameQuery = cfquery(SQLString : SQLStr2, Datasource : new_dsn2);
											}
										}
										if(isdefined('spec_info#row_ind#') and listlen(evaluate('spec_info#row_ind#'),',')){
											'attributes.spect_id#row_ind#'=listgetat(evaluate('spec_info#row_ind#'),2,',');
											if(len(listgetat(evaluate('spec_info#row_ind#'),3,',')))
												'attributes.spect_name#row_ind#'=listgetat(evaluate('spec_info#row_ind#'),3,',');
											else
												'attributes.spect_name#row_ind#'=evaluate("attributes.product_name#row_ind#");
										}
										else
										{
											'attributes.spect_id#row_ind#'= '';
											'attributes.spect_name#row_ind#'='';	
										}
									}
									else
									{
										'attributes.spect_id#row_ind#'= '';
										'attributes.spect_name#row_ind#'='';	
									}
								}
								else
								{
									'attributes.spect_id#row_ind#'='';
									'attributes.spect_name#row_ind#'='';
								}                      
								'attributes.stock_id#row_ind#'=get_act_rows.STOCK_ID[row_ind];
                                'attributes.unit#row_ind#'=get_act_rows.UNIT[row_ind];
                                'attributes.unit_id#row_ind#'=get_act_rows.UNIT_ID[row_ind];
                                'attributes.unit_other#row_ind#'=get_act_rows.UNIT2[row_ind];
                                'attributes.basket_employee_id#row_ind#'=get_act_rows.BASKET_EMPLOYEE_ID[row_ind];
                                'attributes.basket_extra_info#row_ind#'=get_act_rows.BASKET_EXTRA_INFO_ID[row_ind];
                                'attributes.select_info_extra#row_ind#'=get_act_rows.SELECT_INFO_EXTRA[row_ind];
                                'attributes.detail_info_extra#row_ind#'=get_act_rows.DETAIL_INFO_EXTRA[row_ind];
                                if(isdefined('session.pp.userid'))
                                    'attributes.wrk_row_id#row_ind#'="WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.pp.userid##round(rand()*100)#";
                                else if(isdefined('session.ww.userid'))
                                    'attributes.wrk_row_id#row_ind#'="WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ww.userid##round(rand()*100)#";
                                else
                                    'attributes.wrk_row_id#row_ind#'="WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)#";
                                'attributes.wrk_row_relation_id#row_ind#'=get_act_rows.WRK_ROW_ID[row_ind];
                                attributes.rows_ = row_ind;
                            </cfscript>
                        </cfloop>
                        <cfscript>
                            for(ind_tax_count=1;ind_tax_count lte 100;ind_tax_count=ind_tax_count+1)
                            {
                                'attributes.basket_tax_value_#ind_tax_count#' = 0 ;
                                'attributes.basket_tax_#ind_tax_count#' = 0 ;
                                'attributes.basket_otv_value_#ind_tax_count#' = 0 ;
                                'attributes.basket_otv_#ind_tax_count#' = 0 ;
                            }
                            temp_otv_list_ = '';
                            for(ind_inv_row=1;ind_inv_row lte attributes.rows_;ind_inv_row=ind_inv_row+1)
                            {
                                //fatura altı indirim varsa ona hesaplanarak satırlara yansıtılıyor
                                row_price_= wrk_round(Evaluate('attributes.row_lasttotal_#ind_inv_row#'),4);
                                row_price_2= wrk_round((Evaluate('attributes.row_total#ind_inv_row#')/100000000000000000000)*Evaluate('attributes.indirim_carpan#ind_inv_row#'),4);
                                tmp_tax=0;
                                for(ind_tax_count=1;ind_tax_count lte xml_tax_count;ind_tax_count=ind_tax_count+1)
                                {
                                    if(isdefined('attributes.basket_tax_#ind_tax_count#') and evaluate('attributes.basket_tax_#ind_tax_count#') eq evaluate('attributes.tax#ind_inv_row#'))
                                    {
                                        'attributes.basket_tax_value_#ind_tax_count#' =evaluate('attributes.basket_tax_value_#ind_tax_count#') + wrk_round((row_price_/100)*get_act_rows.TAX[ind_inv_row],6);
                                        tmp_tax=1;
                                        break;
                                    }
                                }
                                if(tmp_tax eq 0)
                                {
                                    'attributes.basket_tax_#xml_tax_count#' = evaluate('attributes.tax#ind_inv_row#');
                                    'attributes.basket_tax_value_#xml_tax_count#' =  wrk_round((row_price_/100)*get_act_rows.TAX[ind_inv_row],6);
                                    xml_tax_count=xml_tax_count+1;
                                }
                                tmp_otv=0;
                                for(ind_otv_count=1;ind_otv_count lte xml_otv_count;ind_otv_count=ind_otv_count+1)
                                {
                                    if(isdefined('attributes.basket_otv_#ind_otv_count#') and evaluate('attributes.basket_otv_#ind_otv_count#') eq evaluate('attributes.otv_oran#ind_inv_row#'))
                                    {
                                        'attributes.basket_otv_value_#ind_otv_count#'= evaluate('attributes.basket_otv_value_#ind_otv_count#') + wrk_round((row_price_2/100)*evaluate('attributes.otv_oran#ind_inv_row#'),2);
                                        tmp_otv=1;
                                        break;
                                    }
                                }
                                if(tmp_otv eq 0)	
                                {
                                    'attributes.basket_otv_#xml_otv_count#'= evaluate('attributes.otv_oran#ind_inv_row#');
                                    'attributes.basket_otv_value_#xml_otv_count#'= wrk_round((row_price_2/100)*evaluate('attributes.otv_oran#ind_inv_row#'),2);
                                    xml_otv_count=xml_otv_count+1;
                                }
                                temp_otv_list_ = listappend(temp_otv_list_,evaluate('attributes.otv_oran#ind_inv_row#'));
                            }
                        </cfscript>
                        <cfscript>
                            form.basket_otv_count = xml_otv_count-1;//otv oran sayısı
                            form.basket_tax_count = xml_tax_count-1;//kdv sayısı
                            is_from_import=1;
                            attributes.basket_gross_total=form.basket_gross_total;
                            attributes.basket_net_total=form.basket_net_total;
                            attributes.basket_otv_total=form.basket_otv_total;
                            attributes.basket_tax_total=form.basket_tax_total;
                            attributes.basket_discount_total = form.basket_discount_total;
                        </cfscript>
                        <cfif len(temp_otv_list_)>
                            <cfquery name="get_otv" datasource="#new_dsn3_group#">
                                SELECT * FROM SETUP_OTV WHERE TAX IN (#temp_otv_list_#) AND PERIOD_ID =#get_to_period_id.PERIOD_ID#
                            </cfquery>
                        </cfif>
                        <cfif get_related_act.to_act_type eq 4>
                            <cfset xml_import=2>
                            <cfset is_from_function = 1>
                            <cfinclude template="../../invoice/query/add_invoice_purchase.cfm">
                        <cfelse>
                            <cfset xml_import=1>
                            <cfset is_from_function = 1>
                            <cfinclude template="../../invoice/query/add_invoice_sale.cfm">
                        </cfif>
                        <cfset xml_import=0>
                    <cfelse>
						<script type="text/javascript">
                            alert("Belgeniz Kaydedildi Fakat Grup İçi İlişkili İşlem Kaydı Yapılamadı ! Aktarılacak Şirketteki Muhasebe Dönem Kısıtını Kontrol Ediniz !");
                        </script>
                        <cfabort>
                    </cfif> 
				<cfelse>
					<cfquery name="get_related_act" datasource="#new_dsn2#">
						SELECT * FROM #dsn_alias#.COMPANY_GROUP_ACTIONS WHERE FROM_ACT_TYPE = 3 AND TO_ACT_TYPE = 1 AND FROM_OUR_COMP_ID =#arguments.comp_id# AND (FROM_COMPANY_ID IS NULL OR FROM_COMPANY_ID = #get_act_detail.company_id#) AND (FROM_PROCESS_TYPE IS NULL OR FROM_PROCESS_TYPE = #get_act_detail.process_cat#)
					</cfquery>
					<cfif get_related_act.recordcount>
						<cfset new_comp_id = get_related_act.to_our_comp_id> 
						<cfset new_dsn3_group = "#dsn#_#get_related_act.to_our_comp_id#"> 
						<!--- grup ici islem ile kaydedilen belgenin doneminde tarih kısıtı var ise kaydetmemesi gerekiyor --->
						<cfset userPeriodDate = getUserPeriodDate(comp_id:new_comp_id)>
                        <cfif userPeriodDate lt get_act_detail.invoice_date>
                            <cfquery name="get_to_period_id" datasource="#dsn#">
                                SELECT PERIOD_ID FROM SETUP_PERIOD WHERE PERIOD_YEAR=#session.ep.period_year# AND OUR_COMPANY_ID = #get_related_act.to_our_comp_id#
                            </cfquery>
                            <cfquery name="get_act_rows" datasource="#new_dsn2#">
                                SELECT * FROM INVOICE_ROW WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> ORDER BY INVOICE_ROW_ID
                            </cfquery>
                            <cfquery name="get_act_stock_rows" datasource="#new_dsn2#">
                                SELECT 
                                    S.STOCK_ID
                                FROM 
                                    INVOICE_ROW SR,
                                    #new_dsn3_group#.STOCKS AS S
                                    <cfif len(get_related_act.to_price_cat)>
                                        ,#new_dsn3_group#.PRICE AS PP
                                    </cfif>
                                WHERE 
                                    SR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
                                    AND S.STOCK_ID = SR.STOCK_ID
                                    <cfif len(get_related_act.to_price_cat)>
                                        AND PP.PRODUCT_ID = S.PRODUCT_ID
                                        AND PP.PRICE_CATID = #get_related_act.to_price_cat#
                                        AND PP.STARTDATE <= #createodbcdatetime(get_act_detail.invoice_date)#
                                        AND (PP.FINISHDATE IS NULL OR PP.FINISHDATE >=#createodbcdatetime(get_act_detail.invoice_date)#)
                                    </cfif>
                            </cfquery>
                            <cfquery name="get_money" datasource="#new_dsn2#">
                                SELECT RATE2,RATE1,MONEY_TYPE FROM INVOICE_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
                            </cfquery>
                            <cfquery name="get_money_selected" datasource="#new_dsn2#">
                                SELECT RATE2,RATE1,MONEY_TYPE FROM INVOICE_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> AND IS_SELECTED=1
                            </cfquery>
                            <cfset new_period_id = get_to_period_id.period_id>
                            <cfif get_act_rows.recordcount eq get_act_stock_rows.recordcount>
                                <cfquery name="get_member_id" datasource="#new_dsn2#">
                                    SELECT
                                        COMPANY.COMPANY_ID,
                                        ISNULL(COMPANY.MANAGER_PARTNER_ID,(SELECT TOP 1 PARTNER_ID FROM #dsn_alias#.COMPANY_PARTNER WHERE COMPANY_ID=COMPANY.COMPANY_ID)) PARTNER_ID,
                                        COMPANY_PERIOD.ACCOUNT_CODE,
                                        COMPANY.NICKNAME
                                    FROM 
                                        #dsn_alias#.COMPANY,
                                        #dsn_alias#.COMPANY_PERIOD
                                    WHERE
                                        COMPANY.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_act.TO_COMPANY_ID#"> AND
                                        COMPANY_PERIOD.COMPANY_ID = COMPANY.COMPANY_ID AND
                                        <cfif isdefined("session.ep")>
                                            COMPANY_PERIOD.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
                                        <cfelse>
                                            COMPANY_PERIOD.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.period_id#">
                                        </cfif>
                                </cfquery>
                                <cfquery name="get_partner" datasource="#dsn#">
                                    SELECT MANAGER_PARTNER_ID,NICKNAME FROM COMPANY WHERE COMPANY_ID = #get_related_act.TO_COMPANY_ID#
                                </cfquery>
                                <cfquery name="get_partner_2" datasource="#dsn#">
                                    SELECT MANAGER_PARTNER_ID,NICKNAME FROM COMPANY WHERE COMPANY_ID = #get_act_detail.COMPANY_ID#
                                </cfquery>
                                <cfscript>		
                                    form.sale_product=1;
                                    form.active_company="#arguments.comp_id#";
                                    attributes.rows_ = get_act_rows.recordcount;
                                    attributes.department_id=get_related_act.to_dept_id;
                                    attributes.location_id=get_related_act.to_loc_id;
                                    attributes.process_stage=get_related_act.to_process_stage;
            
                                    attributes.company_id=get_related_act.TO_COMPANY_ID;
                                    attributes.partner_id=get_partner.MANAGER_PARTNER_ID;
                                    attributes.comp_name='a';
                                    attributes.partner_name='b';
                                    attributes.consumer_id='';
                                    
                                    attributes.reserved = 1;
                                    attributes.order_employee_id =get_related_act.to_sale_emp;
                                    attributes.order_employee = get_related_act.to_sale_emp;
                                    attributes.order_head ="#get_partner_2.NICKNAME# - #get_act_detail.INVOICE_NUMBER#";
                                    attributes.invoice_number='';
                                    form.invoice_number='';
                                    attributes.ref_no='';
                                    attributes.order_date=dateformat(get_act_detail.INVOICE_DATE,dateformat_style);
                                    attributes.order_id = '';
                                    attributes.kasa='';
                                    kasa='';
                                    attributes.member_account_code=GET_MEMBER_ID.ACCOUNT_CODE;
                                    attributes.detail=get_act_detail.note;
                                    attributes.city_id='';
                                    attributes.county_id='';
                                    attributes.adres=get_act_detail.SHIP_ADDRESS;
                                    for(stp_mny=1;stp_mny lte GET_MONEY.RECORDCOUNT;stp_mny=stp_mny+1)
                                    {
                                        'attributes.hidden_rd_money_#stp_mny#'=GET_MONEY.MONEY_TYPE[stp_mny];
                                        'attributes.txt_rate1_#stp_mny#'=GET_MONEY.RATE1[stp_mny];	
                                        'attributes.txt_rate2_#stp_mny#'=GET_MONEY.RATE2[stp_mny];
                                    }
                                    form.basket_money=GET_MONEY_SELECTED.MONEY_TYPE;
                                    attributes.basket_money=GET_MONEY_SELECTED.MONEY_TYPE;
                                    form.basket_rate1=GET_MONEY_SELECTED.RATE1;
                                    form.basket_rate2=GET_MONEY_SELECTED.RATE2;
                                    attributes.basket_rate1=GET_MONEY_SELECTED.RATE1;
                                    attributes.basket_rate2=GET_MONEY_SELECTED.RATE2;
                                    attributes.kur_say=GET_MONEY.RECORDCOUNT;
                                    attributes.basket_id=2;
                                    attributes.list_payment_row_id='';
                                    attributes.subscription_id='';
                                    attributes.invoice_counter_number='';
                                    attributes.commethod_id='';
                                    attributes.bool_from_control_bill='';
                                    attributes.invoice_control_id='';
                                    attributes.contract_row_ids='';
                                    attributes.ship_method=get_act_detail.SHIP_METHOD;
                                    attributes.card_paymethod_id=get_act_detail.CARD_PAYMETHOD_ID;
                                    attributes.commission_rate=get_act_detail.CARD_PAYMETHOD_RATE;
                                    attributes.paymethod_id=get_related_act.TO_PAYMETHOD_ID;
                                    attributes.deliver_dept_id=get_related_act.TO_DEPT_ID;
                                    attributes.deliver_loc_id=get_related_act.TO_LOC_ID;
                                    attributes.deliver_dept_name=get_related_act.TO_DEPT_ID;
                                    attributes.project_id=get_act_detail.PROJECT_ID;
                                    PARTO_ID='';
                                    attributes.deliverdate = dateformat(get_act_detail.INVOICE_DATE,dateformat_style); 
                                    attributes.ship_date = dateformat(get_act_detail.INVOICE_DATE,dateformat_style); 
                                    form.DELIVER_GET_ID =get_related_act.to_sale_emp;
                                    form.DELIVER_GET =get_emp_info(get_related_act.to_sale_emp,0,0);
                                    attributes.DELIVER_GET_ID =get_related_act.to_sale_emp;
                                    attributes.DELIVER_GET =get_emp_info(get_related_act.to_sale_emp,0,0);			
                                    attributes.ref_company_id = "";
                                    attributes.ref_member_type = "";
                                    attributes.ref_member_id = "";
                                    attributes.ref_company = "";
                                    inventory_product_exists = 0;
                                    attributes.tevkifat_oran='';
                                    attributes.is_general_prom=0;
                                    attributes.indirim_total='100000000000000000000,100000000000000000000';
                                    attributes.general_prom_limit='';
                                    attributes.general_prom_discount='';
                                    attributes.general_prom_amount=0;
                                    attributes.free_prom_limit='';
                                    attributes.flt_net_total_all=0;
                                    attributes.currency_multiplier = '';
                                    attributes.basket_member_pricecat='';
                                    attributes.basket_due_value_date_='';
                                    attributes.BASKET_PRICE_ROUND_NUMBER = 4;
                                    form.genel_indirim=get_act_detail.SA_DISCOUNT;
                                    if(len(get_related_act.to_price_cat))
                                    {
                                        form.basket_gross_total=0;
                                        form.basket_net_total=0;
                                        attributes.basket_net_total=0;
                                        form.basket_otv_total=0;
                                        form.basket_tax_total=0;
                                        form.basket_discount_total = 0;
                                    }
                                    else
                                    {
                                        form.basket_gross_total=get_act_detail.GROSSTOTAL;
                                        form.basket_net_total=get_act_detail.NETTOTAL;
                                        attributes.basket_net_total=get_act_detail.NETTOTAL;
                                        form.basket_otv_total=get_act_detail.OTV_TOTAL;
                                        form.basket_tax_total=get_act_detail.TAXTOTAL;
                                        form.basket_discount_total = form.genel_indirim;
                                    }
                                    xml_tax_count=1;//kdv sayısı
                                    xml_otv_count=1;//otv sayısı
                                </cfscript>
                                <cfloop query="get_act_rows">
                                    <cfset row_ind = get_act_rows.currentrow>
                                    <cfif isdefined("is_action_file_") and is_action_file_ eq 1 and Len(new_product_id_)>
                                        <cfset 'attributes.product_id#row_ind#' = new_product_id_>
                                    <cfelse>
                                        <cfset 'attributes.product_id#row_ind#' = get_act_rows.PRODUCT_ID[row_ind]>
                                    </cfif>
                                    <cfquery name="get_product_id" datasource="#new_dsn2#">
                                        SELECT
                                            S.BARCOD BARCODE,
                                            S.STOCK_ID,
                                            S.PRODUCT_ID,
                                            S.STOCK_CODE,
                                            S.PRODUCT_NAME,
                                            S.PROPERTY,
                                            S.IS_INVENTORY,
                                            S.MANUFACT_CODE,
                                            S.TAX,
                                            ISNULL(S.OTV,0) OTV,
                                            S.IS_PRODUCTION
                                            <cfif len(get_related_act.to_price_cat)>
                                                ,PP.PRICE PRICE_KDV
                                            <cfelse>
                                                ,#get_act_rows.price# PRICE_KDV
                                            </cfif>
                                        FROM
                                            #new_dsn3_group#.STOCKS AS S
                                            <cfif len(get_related_act.to_price_cat)>
                                                ,#new_dsn3_group#.PRICE AS PP
                                            </cfif>
                                        WHERE
                                            S.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.product_id#row_ind#')#">
                                            <cfif len(get_related_act.to_price_cat)>
                                                AND PP.PRODUCT_ID = S.PRODUCT_ID
                                                AND PP.PRICE_CATID = #get_related_act.to_price_cat#
                                                AND PP.STARTDATE <= #createodbcdatetime(get_act_detail.INVOICE_DATE)#
                                                AND (PP.FINISHDATE IS NULL OR PP.FINISHDATE >=#createodbcdatetime(get_act_detail.INVOICE_DATE)#)
                                            </cfif>
                                    </cfquery>
                                    <cfif len(get_related_act.to_price_cat) and get_product_id.recordcount>
                                        <!--- Sözleşme İndirimleri --->
                                        <cfquery name="get_contract_discounts" datasource="#new_dsn3_group#" maxrows="1">
                                            SELECT
                                                ISNULL(PC.DISCOUNT_RATE,0) DISCOUNT_RATE,
                                                ISNULL(PC.DISCOUNT_RATE_2,0) DISCOUNT_RATE_2,
                                                ISNULL(PC.DISCOUNT_RATE_3,0) DISCOUNT_RATE_3,
                                                ISNULL(PC.DISCOUNT_RATE_4,0) DISCOUNT_RATE_4,
                                                ISNULL(PC.DISCOUNT_RATE_5,0) DISCOUNT_RATE_5,
                                                PC.PAYMENT_TYPE_ID
                                            FROM 
                                                PRICE_CAT_EXCEPTIONS PC,
                                                RELATED_CONTRACT RC
                                            WHERE
                                                PC.CONTRACT_ID = RC.CONTRACT_ID
                                                AND (PC.SUPPLIER_ID IS NULL OR PC.SUPPLIER_ID = (SELECT COMPANY_ID FROM STOCKS WHERE STOCK_ID=#get_product_id.stock_id#))
                                                AND (PC.PRODUCT_ID IS NULL OR PC.PRODUCT_ID=#get_product_id.product_id#)
                                                AND (PC.BRAND_ID IS NULL OR PC.BRAND_ID=(SELECT BRAND_ID FROM STOCKS WHERE STOCK_ID=#get_product_id.stock_id#))
                                                AND (PC.PRODUCT_CATID IS NULL OR PC.PRODUCT_CATID=(SELECT PRODUCT_CATID FROM STOCKS WHERE STOCK_ID=#get_product_id.stock_id#) OR (SELECT STOCK_CODE FROM STOCKS WHERE STOCK_ID=#get_product_id.stock_id#) LIKE (SELECT PCC.HIERARCHY FROM PRODUCT_CAT PCC WHERE PCC.PRODUCT_CATID = PC.PRODUCT_CATID)+'.%')
                                                AND (PC.SHORT_CODE_ID IS NULL OR PC.SHORT_CODE_ID=(SELECT SHORT_CODE_ID FROM STOCKS WHERE STOCK_ID=#get_product_id.stock_id#))
                                                AND RC.STARTDATE <= #createodbcdatetime(get_act_detail.INVOICE_DATE)#
                                                AND RC.FINISHDATE >= #createodbcdatetime(get_act_detail.INVOICE_DATE)#
                                                AND	RC.COMPANY LIKE '%,#get_related_act.TO_COMPANY_ID#,%'
                                                AND PC.PRICE_CATID=#get_related_act.to_price_cat#
                                            ORDER BY 
                                                PC.PRODUCT_ID DESC,PC.BRAND_ID DESC,(SELECT PCC.HIERARCHY FROM PRODUCT_CAT PCC WHERE PCC.PRODUCT_CATID = PC.PRODUCT_CATID) DESC,PC.PRODUCT_CATID DESC,PC.SUPPLIER_ID DESC,PC.COMPANYCAT_ID DESC,PC.SHORT_CODE_ID DESC
                                        </cfquery>
                                    </cfif>
                                    <cfquery name="get_row_rate" dbtype="query">
                                        SELECT RATE2/RATE1 NEW_RATE FROM get_money WHERE MONEY_TYPE = '#get_act_rows.other_money#'
                                    </cfquery>
                                    <cfscript>
                                        'attributes.product_name#row_ind#'=get_act_rows.NAME_PRODUCT[row_ind];
                                        'attributes.product_name_other#row_ind#'=get_act_rows.PRODUCT_NAME2[row_ind];
                                        'attributes.tax#row_ind#'= get_act_rows.TAX[row_ind];
                                        'attributes.is_inventory#row_ind#'=get_product_id.IS_INVENTORY;
                                        if(get_product_id.IS_INVENTORY) inventory_product_exists = 1;
                                        'attributes.is_production#row_ind#'=get_product_id.IS_PRODUCTION;
                                        'attributes.amount#row_ind#'=get_act_rows.AMOUNT[row_ind];
                                        'attributes.deliver_date#row_ind#'=get_act_rows.DELIVER_DATE[row_ind];
                                        'attributes.deliver_dept#row_ind#'="#get_related_act.TO_DEPT_ID#-#get_related_act.TO_LOC_ID#";
                                        'attributes.duedate#row_ind#'=get_act_rows.DUE_DATE[row_ind];
                                        'attributes.ek_tutar#row_ind#'=get_act_rows.EK_TUTAR_PRICE[row_ind];
                                        'attributes.ek_tutar_other_total#row_ind#'=get_act_rows.EXTRA_PRICE_TOTAL[row_ind];
                                        'attributes.ek_tutar_total#row_ind#'=get_act_rows.EXTRA_PRICE_OTHER_TOTAL[row_ind];
                                        'attributes.extra_cost#row_ind#'=get_act_rows.EXTRA_COST[row_ind];
                                        'attributes.iskonto_tutar#row_ind#'=get_act_rows.DISCOUNT_COST[row_ind];
                                        'attributes.is_commission#row_ind#'=get_act_rows.IS_COMMISSION[row_ind];
                            
                                        'attributes.is_promotion#row_ind#'=get_act_rows.IS_PROMOTION[row_ind];
                                        'attributes.karma_product_id#row_ind#'=get_act_rows.KARMA_PRODUCT_ID[row_ind];
                                        if(len(get_related_act.to_price_cat))
                                            'attributes.list_price#row_ind#'=get_product_id.PRICE_KDV[row_ind];
                                        else
                                            'attributes.list_price#row_ind#'=get_act_rows.LIST_PRICE[row_ind];
                                            
                                        'attributes.lot_no#row_ind#'=get_act_rows.LOT_NO[row_ind];
                                        'attributes.manufact_code#row_ind#'=get_act_rows.PRODUCT_MANUFACT_CODE[row_ind];
                                        'attributes.marj#row_ind#'=get_act_rows.MARGIN[row_ind];
                                        'attributes.net_maliyet#row_ind#'=get_act_rows.COST_PRICE[row_ind];
                                        'attributes.number_of_installment#row_ind#'=get_act_rows.NUMBER_OF_INSTALLMENT[row_ind];
                                        'attributes.order_currency#row_ind#'='-1';
                                        
                                        'attributes.otv_oran#row_ind#'=get_product_id.OTV;
                                        
                                        if(len(get_related_act.to_price_cat))
                                        {
                                            if(get_contract_discounts.recordcount)
                                            {
                                                'attributes.indirim1#row_ind#'=get_contract_discounts.DISCOUNT_RATE;
                                                'attributes.indirim2#row_ind#'=get_contract_discounts.DISCOUNT_RATE_2;
                                                'attributes.indirim3#row_ind#'=get_contract_discounts.DISCOUNT_RATE_3;
                                                'attributes.indirim4#row_ind#'=get_contract_discounts.DISCOUNT_RATE_4;
                                                'attributes.indirim5#row_ind#'=get_contract_discounts.DISCOUNT_RATE_5;
                                                'attributes.indirim6#row_ind#'=0;
                                                'attributes.indirim7#row_ind#'=0;
                                                'attributes.indirim8#row_ind#'=0;
                                                'attributes.indirim9#row_ind#'=0;
                                                'attributes.indirim10#row_ind#'=0;
                                            }
                                            else
                                            {
                                                'attributes.indirim1#row_ind#'=0;
                                                'attributes.indirim2#row_ind#'=0;
                                                'attributes.indirim3#row_ind#'=0;
                                                'attributes.indirim4#row_ind#'=0;
                                                'attributes.indirim5#row_ind#'=0;
                                                'attributes.indirim6#row_ind#'=0;
                                                'attributes.indirim7#row_ind#'=0;
                                                'attributes.indirim8#row_ind#'=0;
                                                'attributes.indirim9#row_ind#'=0;
                                                'attributes.indirim10#row_ind#'=0;
                                            }
                                        }
                                        else
                                        {
                                            'attributes.indirim1#row_ind#'=get_act_rows.DISCOUNT[row_ind];
                                            'attributes.indirim2#row_ind#'=get_act_rows.DISCOUNT2[row_ind];
                                            'attributes.indirim3#row_ind#'=get_act_rows.DISCOUNT3[row_ind];
                                            'attributes.indirim4#row_ind#'=get_act_rows.DISCOUNT4[row_ind];
                                            'attributes.indirim5#row_ind#'=get_act_rows.DISCOUNT5[row_ind];
                                            'attributes.indirim6#row_ind#'=get_act_rows.DISCOUNT6[row_ind];
                                            'attributes.indirim7#row_ind#'=get_act_rows.DISCOUNT7[row_ind];
                                            'attributes.indirim8#row_ind#'=get_act_rows.DISCOUNT8[row_ind];
                                            'attributes.indirim9#row_ind#'=get_act_rows.DISCOUNT9[row_ind];
                                            'attributes.indirim10#row_ind#'=get_act_rows.DISCOUNT10[row_ind];
                                        }
                                        'attributes.indirim_carpan#row_ind#' = (100-Evaluate('attributes.indirim1#row_ind#')) * (100-Evaluate('attributes.indirim2#row_ind#')) * (100-Evaluate('attributes.indirim3#row_ind#')) * (100-Evaluate('attributes.indirim4#row_ind#')) * (100-Evaluate('attributes.indirim5#row_ind#')) * (100-Evaluate('attributes.indirim6#row_ind#')) * (100-Evaluate('attributes.indirim7#row_ind#')) * (100-Evaluate('attributes.indirim8#row_ind#')) * (100-Evaluate('attributes.indirim9#row_ind#')) * (100-Evaluate('attributes.indirim10#row_ind#'));
                                        if(len(get_related_act.to_price_cat))
                                        {
                                            'attributes.price#row_ind#' = get_act_rows.PRICE[row_ind]*get_product_id.price_kdv/get_act_rows.PRICE[row_ind];
                                            'attributes.price_other#row_ind#' = get_act_rows.PRICE_OTHER[row_ind]*get_product_id.price_kdv/get_act_rows.PRICE[row_ind];
                                            'attributes.row_total#row_ind#' = get_product_id.price_kdv*get_act_rows.AMOUNT[row_ind];
                                            'attributes.row_nettotal#row_ind#' = wrk_round((Evaluate('attributes.row_total#row_ind#')/100000000000000000000)*Evaluate('attributes.indirim_carpan#row_ind#'),4);
                                            'attributes.row_otvtotal#row_ind#'= Evaluate('attributes.row_nettotal#row_ind#')*get_product_id.OTV/100;
                                            'attributes.row_taxtotal#row_ind#' = (Evaluate('attributes.row_nettotal#row_ind#')+(Evaluate('attributes.row_nettotal#row_ind#')*get_product_id.OTV/100))*get_act_rows.TAX[row_ind]/100;
                                            'attributes.row_lasttotal#row_ind#' = Evaluate('attributes.row_nettotal#row_ind#')+Evaluate('attributes.row_taxtotal#row_ind#')+Evaluate('attributes.row_otvtotal#row_ind#');
                                            'attributes.other_money_#row_ind#' = get_act_rows.OTHER_MONEY[row_ind];
                                            'attributes.other_money_value_#row_ind#' = Evaluate('attributes.row_nettotal#row_ind#')/get_row_rate.new_rate;
                                            
                                            form.basket_gross_total=form.basket_gross_total+Evaluate('attributes.row_total#row_ind#');
                                            form.basket_net_total=form.basket_net_total+Evaluate('attributes.row_lasttotal#row_ind#');
                                            attributes.basket_net_total=form.basket_net_total+Evaluate('attributes.row_lasttotal#row_ind#');
                                            form.basket_tax_total=form.basket_tax_total+Evaluate('attributes.row_taxtotal#row_ind#');
                                            form.basket_otv_total=form.basket_otv_total+Evaluate('attributes.row_otvtotal#row_ind#');
                                            form.basket_discount_total=form.basket_discount_total+Evaluate('attributes.row_total#row_ind#')-Evaluate('attributes.row_nettotal#row_ind#'); 
                                        }
                                        else
                                        {
                                            'attributes.price#row_ind#' = get_act_rows.PRICE[row_ind];
                                            'attributes.price_other#row_ind#' = get_act_rows.PRICE_OTHER[row_ind];
                                            'attributes.row_total#row_ind#' = get_act_rows.NETTOTAL[row_ind];
                                            'attributes.row_nettotal#row_ind#' = get_act_rows.NETTOTAL[row_ind];
                                            'attributes.row_otvtotal#row_ind#'= get_act_rows.NETTOTAL[row_ind]*get_product_id.OTV/100;
                                            'attributes.row_taxtotal#row_ind#' = get_act_rows.NETTOTAL[row_ind]*get_act_rows.TAX[row_ind]/100;
                                            'attributes.row_lasttotal#row_ind#' = get_act_rows.NETTOTAL[row_ind] + (get_act_rows.NETTOTAL[row_ind]*get_act_rows.TAX[row_ind]/100);
                                            'attributes.other_money_#row_ind#' = get_act_rows.OTHER_MONEY[row_ind];
                                            'attributes.other_money_value_#row_ind#' = get_act_rows.OTHER_MONEY_VALUE[row_ind];
                                            'attributes.other_money_gross_total#row_ind#' = get_act_rows.OTHER_MONEY_VALUE[row_ind] + (get_act_rows.OTHER_MONEY_VALUE[row_ind]*get_act_rows.TAX[row_ind]/100);
                                        }
                                        'attributes.price_cat#row_ind#'=get_act_rows.PRICE_CAT[row_ind];
                                        'attributes.product_account_code#row_ind#'='';
                                        'attributes.promosyon_maliyet#row_ind#'=get_act_rows.PROM_COST[row_ind];
                                        'attributes.promosyon_yuzde#row_ind#'=get_act_rows.PROM_COMISSION[row_ind];
                                        'attributes.prom_relation_id#row_ind#'=get_act_rows.PROM_RELATION_ID[row_ind];
                                        'attributes.prom_stock_id#row_ind#'=get_act_rows.PROM_STOCK_ID[row_ind];
                                        'attributes.reserve_date#row_ind#'='';
                                        'attributes.reserve_type#row_ind#'='-1';
                                        'attributes.row_promotion_id#row_ind#'=get_act_rows.PROM_ID[row_ind];
                                        'attributes.row_service_id#row_ind#'='';
                                        'attributes.row_ship_id#row_ind#'=0;
                                        'attributes.row_unique_relation_id#row_ind#'=get_act_rows.UNIQUE_RELATION_ID[row_ind];
                                        'attributes.shelf_number#row_ind#'=get_act_rows.SHELF_NUMBER[row_ind];
										/*	PY 0715
											spect var id den main id yi buluyoruz yeni şirkette bu spect main id varsa onun herhangi bir spect_var_id sini atıyoruz
											eğer bulduğumuz spect main id şirketimizde yoksa o stoğa ait herhangi bir spect main id ye bağlı spect var id çekip atıyoruz
											hiç spect main id yoksa atmıyoruz
										*/
										// grup içi işlemde spec kaydı atmayla ilgili düzenleme yapıldı, main spec varsa spec üretiyoruz yoksa boş atıyoruz 1115 PY
										if (get_product_id.IS_PRODUCTION eq 1)
										{
											SQLStr = 'SELECT TOP 1 SPECT_MAIN_ID FROM #new_dsn3_group#.SPECT_MAIN  AS SM WHERE SM.STOCK_ID = #evaluate("attributes.stock_id#row_ind#")# AND SM.IS_TREE = 1 ORDER BY SM.RECORD_DATE DESC,SM.UPDATE_DATE DESC';
											'GET_TREE#row_ind#' = cfquery(SQLString : SQLStr, Datasource : new_dsn2);
											if(not isdefined('attributes.company_id')) attributes.company_id = 0;
											if(not isdefined('attributes.consumer_id')) attributes.consumer_id = 0;
											if(evaluate('GET_TREE#row_ind#.RECORDCOUNT'))
											{
												'spec_info#row_ind#' = specer(
														dsn_type:new_dsn2,
														spec_type:1,
														main_spec_id:evaluate('GET_TREE#row_ind#.SPECT_MAIN_ID'),
														add_to_main_spec:1,
														company_id: attributes.company_id,
														is_company_related_action: 1,
														company_related_dsn: new_dsn3_group,
														consumer_id: attributes.consumer_id
													);
												if(isdefined('attributes.is_spect_name_to_property') and attributes.is_spect_name_to_property eq 1){//Spec ismi confg.ürünlerden oluşturuluyor ise!
													configure_spec_name = evaluate("attributes.product_name#row_ind#");
													GetProductConf(listgetat(Evaluate('spec_info#row_ind#'),1,','));//fonksiyon burda çağırlıyor ilk olarak
												}	
												if(isdefined('attributes.is_spect_name_to_property') and attributes.is_spect_name_to_property eq 1 and isdefined('spec_info#row_ind#')){
													SQLStr1 = 'UPDATE #new_dsn3_group#.SPECT_MAIN SET SPECT_MAIN_NAME = "#left(configure_spec_name,499)#" WHERE SPECT_MAIN_ID = #listgetat(Evaluate('spec_info#row_ind#'),1,',')# ';
													UpdateSpecNameQuery = cfquery(SQLString : SQLStr1, Datasource : new_dsn2);
													if(len(listgetat(Evaluate('spec_info#row_ind#'),1,',')) and listgetat(Evaluate('spec_info#row_ind#'),1,',') gt 0){
														SQLStr2 = 'UPDATE #new_dsn3_group#.SPECT_MAIN SET SPECT_MAIN_NAME = "#left(configure_spec_name,499)#" WHERE SPECT_MAIN_ID = #listgetat(Evaluate('spec_info#row_ind#'),1,',')# ';
														UpdateS_V_SpecNameQuery = cfquery(SQLString : SQLStr2, Datasource : new_dsn2);
													}
												}
												if(isdefined('spec_info#row_ind#') and listlen(evaluate('spec_info#row_ind#'),',')){
													'attributes.spect_id#row_ind#'=listgetat(evaluate('spec_info#row_ind#'),2,',');
													if(len(listgetat(evaluate('spec_info#row_ind#'),3,',')))
														'attributes.spect_name#row_ind#'=listgetat(evaluate('spec_info#row_ind#'),3,',');
													else
														'attributes.spect_name#row_ind#'=evaluate("attributes.product_name#row_ind#");
												}
												else
												{
													'attributes.spect_id#row_ind#'= '';
													'attributes.spect_name#row_ind#'='';	
												}
											}
											else
											{
												'attributes.spect_id#row_ind#'= '';
												'attributes.spect_name#row_ind#'='';	
											}
										}
										else
										{
											'attributes.spect_id#row_ind#'='';
											'attributes.spect_name#row_ind#'='';
										}
                                        'attributes.stock_id#row_ind#'=get_act_rows.STOCK_ID[row_ind];
                                        'attributes.unit#row_ind#'=get_act_rows.UNIT[row_ind];
                                        'attributes.unit_id#row_ind#'=get_act_rows.UNIT_ID[row_ind];
                                        'attributes.unit_other#row_ind#'=get_act_rows.UNIT2[row_ind];
                                        'attributes.basket_employee_id#row_ind#'=get_act_rows.BASKET_EMPLOYEE_ID[row_ind];
                                        'attributes.basket_extra_info#row_ind#'=get_act_rows.BASKET_EXTRA_INFO_ID[row_ind];
                                        'attributes.select_info_extra#row_ind#'=get_act_rows.SELECT_INFO_EXTRA[row_ind];
                                        'attributes.detail_info_extra#row_ind#'=get_act_rows.DETAIL_INFO_EXTRA[row_ind];
                                        if(isdefined('session.pp.userid'))
                                            'attributes.wrk_row_id#row_ind#'="WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.pp.userid##round(rand()*100)#";
                                        else if(isdefined('session.ww.userid'))
                                            'attributes.wrk_row_id#row_ind#'="WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ww.userid##round(rand()*100)#";
                                        else
                                            'attributes.wrk_row_id#row_ind#'="WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)#";
                                        'attributes.wrk_row_relation_id#row_ind#'=get_act_rows.WRK_ROW_ID[row_ind];
                                        attributes.rows_ = row_ind;
                                    </cfscript>
                                </cfloop>
                                <cfscript>
                                    for(ind_inv_row=1;ind_inv_row lte attributes.rows_;ind_inv_row=ind_inv_row+1)
                                    {
                                        //fatura altı indirim varsa ona hesaplanarak satırlara yansıtılıyor
                                        row_price_=get_act_rows.PRICE[ind_inv_row]*get_product_id.price_kdv/get_act_rows.PRICE[row_ind]*get_act_rows.AMOUNT[ind_inv_row];
                                        tmp_tax=0;
                                        for(ind_tax_count=1;ind_tax_count lte xml_tax_count;ind_tax_count=ind_tax_count+1)
                                        {
                                            if(isdefined('form.basket_tax_#ind_tax_count#') and evaluate('form.basket_tax_#ind_tax_count#') eq evaluate('attributes.tax#ind_inv_row#'))
                                            {
                                                'form.basket_tax_value_#ind_tax_count#' =evaluate('form.basket_tax_value_#ind_tax_count#') + wrk_round((row_price_/100)*get_act_rows.TAX[ind_inv_row],2);
                                                tmp_tax=1;
                                                break;
                                            }
                                        }
                                        if(tmp_tax eq 0)
                                        {
                                            'form.basket_tax_#xml_tax_count#' = evaluate('attributes.tax#ind_inv_row#');
                                            'form.basket_tax_value_#xml_tax_count#' =  wrk_round((row_price_/100)*get_act_rows.TAX[ind_inv_row],2);
                                            xml_tax_count=xml_tax_count+1;
                                        }
                                        tmp_otv=0;
                                        for(ind_otv_count=1;ind_otv_count lte xml_otv_count;ind_otv_count=ind_otv_count+1)
                                        {
                                            if(isdefined('form.basket_otv_#ind_otv_count#') and evaluate('form.basket_otv_#ind_otv_count#') eq get_product_id.OTV)
                                            {
                                                'form.basket_otv_value_#ind_otv_count#'= evaluate('form.basket_otv_value_#ind_otv_count#') + wrk_round((row_price_/100)*get_product_id.OTV,2);
                                                tmp_otv=1;
                                                break;
                                            }
                                        }
                                        if(tmp_otv eq 0)	
                                        {
                                            'form.basket_otv_#xml_otv_count#'= get_product_id.OTV;
                                            'form.basket_otv_value_#xml_otv_count#'= wrk_round((row_price_/100)*get_product_id.OTV,2);
                                            xml_otv_count=xml_otv_count+1;
                                        }
                                    }
                                </cfscript>
                                <cfscript>
                                    form.basket_otv_count = xml_otv_count-1;//otv oran sayısı
                                    form.basket_tax_count = xml_tax_count-1;//kdv sayısı
                                    xml_import=1;
                                    is_from_import=1;
                                </cfscript>
                                <cfinclude template="../../sales/query/add_order.cfm">
                            <cfelse>
								<script type="text/javascript">
                                    alert("Belgeniz Kaydedildi Fakat Grup İçi İlişkili İşlem Kaydı Yapılamadı ! Ürün ve Fiyat Tanımlarınızı Kontrol Ediniz !");
                                </script>
                                <cfabort>
                            </cfif>
                        <cfelse>
							<script type="text/javascript">
                                alert("Belgeniz Kaydedildi Fakat Grup İçi İlişkili İşlem Kaydı Yapılamadı ! Aktarılacak Şirketteki Muhasebe Dönem Kısıtını Kontrol Ediniz !");
                            </script>
                            <cfabort>
                        </cfif> 
					</cfif>
				</cfif>
			</cfif>
		<cfelseif action_type eq 4><!--- alış faturası İse --->
			<cfquery name="get_act_detail" datasource="#new_dsn2#">
				SELECT * FROM INVOICE WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
			</cfquery>

			<cfif get_act_detail.recordcount and len(get_act_detail.company_id)>
                <cfquery name="get_related_act" datasource="#new_dsn2#">
                    SELECT ISNULL(TO_COMPANY_ID,#get_act_detail.company_id#) TO_COMPANY_ID_,* FROM #dsn_alias#.COMPANY_GROUP_ACTIONS WHERE FROM_ACT_TYPE = 4 AND TO_ACT_TYPE IN(3,4) AND FROM_OUR_COMP_ID =#arguments.comp_id# AND (FROM_COMPANY_ID IS NULL OR FROM_COMPANY_ID = #get_act_detail.company_id#) AND (FROM_PROCESS_TYPE IS NULL OR FROM_PROCESS_TYPE = #get_act_detail.process_cat#)
                </cfquery>
				
                <cfif get_related_act.recordcount>
                    <cfset new_comp_id = get_related_act.to_our_comp_id> 
                    <cfset new_dsn3_group = "#dsn#_#get_related_act.to_our_comp_id#"> 
                    <cfset new_dsn2_group = "#dsn#_#session.ep.period_year#_#get_related_act.to_our_comp_id#">					
					<cfquery name="getCompanyPeriodId" datasource="#dsn#">
						SELECT PERIOD_ID FROM SETUP_PERIOD WHERE PERIOD_YEAR = #session.ep.period_year# AND OUR_COMPANY_ID = #new_comp_id#
					</cfquery>
                    <cfset new_period_id = getCompanyPeriodId.PERIOD_ID>
                    <!--- grup ici islem ile kaydedilen belgenin doneminde tarih kısıtı var ise kaydetmemesi gerekiyor --->
					<cfset userPeriodDate = getUserPeriodDate(comp_id:new_comp_id)>
                    <cfif userPeriodDate lt get_act_detail.invoice_date>
						<!--- FA iki şirketin sistem para birimleri farklı ise karşı şirketin para birimleri gönderilmelidir cari ve muhasebe işlemlerinde gönderilmeyince session daki para birimlerini almaktadır. --->
                        <cfquery name="getCompanyPeriodMoney" datasource="#dsn#">
                            SELECT STANDART_PROCESS_MONEY AS TO_MONEY,OTHER_MONEY AS TO_MONEY_2 FROM SETUP_PERIOD WHERE PERIOD_YEAR = #session.ep.period_year# AND OUR_COMPANY_ID = #new_comp_id#
                        </cfquery>
                        
                        <cfquery name="get_act_rows" datasource="#new_dsn2#">
                            SELECT * FROM INVOICE_ROW WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> ORDER BY INVOICE_ROW_ID
                        </cfquery>
                        <!--- 
                            FA 08122014 
                            iki şirketin sistem para birimleri farklı ise karşı şirkette kur ve fiyatların düzeltilmesi için oran bulunur ve fiyatlar bu oran ile düzenlenir 
                            sistem para birimi aynı olan şirketlerde bu oran zaten 1 olacaktır
                            sistem para birimi farklı olan şirketlerde oran kaydedilen belgeden yeniden hesaplanır 
                        --->
                        <cfquery name="getMoneyNewRateToCompany" datasource="#new_dsn2#">
                            SELECT
                                IM.RATE2/IM2.RATE2 NEW_RATE
                            FROM 
                                INVOICE_MONEY IM
                                LEFT JOIN INVOICE_MONEY IM2 ON IM2.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> AND IM2.MONEY_TYPE = (SELECT MONEY FROM #new_dsn2_group#.SETUP_MONEY WHERE RATE2/RATE1 = 1)
                            WHERE 
                                IM.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> AND
                                IM.RATE1/IM.RATE2 = 1
                        </cfquery>
                        <cfset newRateToCompany = getMoneyNewRateToCompany.NEW_RATE>
                        
                        <cfquery name="get_money" datasource="#new_dsn2#">
                            SELECT (RATE2*#newRateToCompany#) AS RATE2,RATE1,MONEY_TYPE,IS_SELECTED FROM INVOICE_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
                        </cfquery>
                        <cfquery name="get_money_selected" dbtype="query">
                            SELECT RATE2,RATE1,MONEY_TYPE FROM get_money WHERE IS_SELECTED=1
                        </cfquery>
                        
                        <cfquery name="get_to_period_id" datasource="#dsn#">
                            SELECT PERIOD_ID FROM SETUP_PERIOD WHERE PERIOD_YEAR=#session.ep.period_year# AND OUR_COMPANY_ID = #get_related_act.to_our_comp_id#
                        </cfquery>
                        <cfset new_period_id = get_to_period_id.period_id>
                        <cfquery name="get_member_id" datasource="#new_dsn2#">
                            SELECT
                                COMPANY.COMPANY_ID,
                                ISNULL(COMPANY.MANAGER_PARTNER_ID,(SELECT TOP 1 PARTNER_ID FROM #dsn_alias#.COMPANY_PARTNER WHERE COMPANY_ID=COMPANY.COMPANY_ID)) PARTNER_ID,
                                COMPANY_PERIOD.ACCOUNT_CODE
                            FROM 
                                #dsn_alias#.COMPANY,
                                #dsn_alias#.COMPANY_PERIOD
                            WHERE
                                COMPANY.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_act.TO_COMPANY_ID_#"> AND
                                COMPANY_PERIOD.COMPANY_ID = COMPANY.COMPANY_ID AND
                                COMPANY_PERIOD.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#new_period_id#">
                        </cfquery>
                        <cfquery name="get_partner" datasource="#dsn#">
                            SELECT MANAGER_PARTNER_ID FROM COMPANY WHERE COMPANY_ID = #get_related_act.TO_COMPANY_ID_#
                        </cfquery>
                        
                        <cfscript>		
                            // FA iki sirketin para birimleri farklı ise gonderilmek zorunda
                            if(not session.ep.money is getCompanyPeriodMoney.to_money)
                            {
                                to_action_currency = getCompanyPeriodMoney.to_money;
                                to_action_currency_2 = getCompanyPeriodMoney.to_money_2;
                            }
                            
                            if(get_related_act.to_act_type eq 4)
                                form.sale_product=0;
                            else
                                form.sale_product=1;
                            form.process_cat=get_related_act.to_process_type;
                            invoice_cat=get_related_act.to_process_type;
                            form.active_company="#arguments.comp_id#";
                            attributes.rows_ = get_act_rows.recordcount;
                            attributes.department_id=get_related_act.to_dept_id;
                            attributes.location_id=get_related_act.to_loc_id;
                            attributes.process_stage=get_related_act.to_process_stage;
                            form.DELIVER_GET_ID =get_related_act.to_sale_emp;
                            form.DELIVER_GET =get_emp_info(get_related_act.to_sale_emp,0,0);
                            attributes.DELIVER_GET_ID =get_related_act.to_sale_emp;
                            attributes.DELIVER_GET =get_emp_info(get_related_act.to_sale_emp,0,0);
                            EMPO_ID =get_related_act.to_sale_emp;
                            attributes.EMPO_ID =get_related_act.to_sale_emp;
                            attributes.PARTNER_NAMEO =get_related_act.to_sale_emp;
                            attributes.company_id=get_related_act.TO_COMPANY_ID_;
                            attributes.partner_id=get_partner.MANAGER_PARTNER_ID;
                            attributes.comp_name='a';
                            attributes.partner_name='b';
                            attributes.consumer_id='';
                            attributes.yuvarlama=0;
                            attributes.reserved = 1;
                            attributes.invoice_number='';
                            form.invoice_number='';
                            attributes.ref_no='';
                            attributes.invoice_date=dateformat(get_act_detail.invoice_date,dateformat_style);
                            attributes.invoice_date_h = hour(now());
                            attributes.invoice_date_m = minute(now());
                            attributes.order_id = '';
                            attributes.kasa='';
                            kasa='';
                            attributes.member_account_code=GET_MEMBER_ID.ACCOUNT_CODE;
                            note=get_act_detail.note;
                            attributes.city_id='';
                            attributes.county_id='';
                            attributes.adres=get_act_detail.SHIP_ADDRESS;
                            for(stp_mny=1;stp_mny lte GET_MONEY.RECORDCOUNT;stp_mny=stp_mny+1)
                            {
                                'attributes.hidden_rd_money_#stp_mny#'=GET_MONEY.MONEY_TYPE[stp_mny];
                                'attributes.txt_rate1_#stp_mny#'=GET_MONEY.RATE1[stp_mny];	
                                'attributes.txt_rate2_#stp_mny#'=GET_MONEY.RATE2[stp_mny];
                            }
                            form.basket_money=GET_MONEY_SELECTED.MONEY_TYPE;
                            attributes.basket_money=GET_MONEY_SELECTED.MONEY_TYPE;
                            form.basket_rate1=GET_MONEY_SELECTED.RATE1;
                            form.basket_rate2=GET_MONEY_SELECTED.RATE2;
                            attributes.basket_rate1=GET_MONEY_SELECTED.RATE1;
                            attributes.basket_rate2=GET_MONEY_SELECTED.RATE2;
                            attributes.kur_say=GET_MONEY.RECORDCOUNT;
                            attributes.basket_id=2;
                            attributes.list_payment_row_id='';
                            attributes.subscription_id='';
                            attributes.invoice_counter_number='';
                            attributes.commethod_id='';
                            attributes.bool_from_control_bill='';
                            attributes.invoice_control_id='';
                            attributes.contract_row_ids='';
                            attributes.ship_method=get_act_detail.SHIP_METHOD;
                            attributes.card_paymethod_id=get_act_detail.CARD_PAYMETHOD_ID;
                            attributes.commission_rate=get_act_detail.CARD_PAYMETHOD_RATE;
                            attributes.paymethod_id=get_related_act.TO_PAYMETHOD_ID;
                            attributes.deliver_dept_id=get_related_act.TO_DEPT_ID;
                            attributes.deliver_loc_id=get_related_act.TO_LOC_ID;
                            attributes.deliver_dept_name=get_related_act.TO_DEPT_ID;
                            attributes.project_id=get_act_detail.PROJECT_ID;
                            PARTO_ID='';
                            attributes.deliverdate = dateformat(get_act_detail.invoice_date,dateformat_style); 
                            attributes.ship_date = dateformat(get_act_detail.invoice_date,dateformat_style); 		
                            form.serial_number = get_act_detail.serial_number;
                            form.serial_no = get_act_detail.serial_no;
                            form.invoice_number = get_act_detail.invoice_number;
                            attributes.ref_company_id = "";
                            attributes.ref_member_type = "";
                            attributes.ref_member_id = "";
                            attributes.ref_company = "";
                            inventory_product_exists = 0;
                            attributes.tevkifat_oran='';
                            form.stopaj=get_act_detail.stopaj;
                            form.stopaj_rate_id=get_act_detail.stopaj_rate_id;
                            form.stopaj_yuzde=get_act_detail.stopaj_oran;
                            attributes.is_general_prom=0;
                            attributes.indirim_total='100000000000000000000,100000000000000000000';
                            attributes.general_prom_limit='';
                            attributes.general_prom_discount='';
                            attributes.general_prom_amount=0;
                            attributes.free_prom_limit='';
                            attributes.flt_net_total_all=0;
                            attributes.currency_multiplier = '';
                            attributes.basket_member_pricecat='';
                            attributes.basket_due_value_date_='';
                            attributes.BASKET_PRICE_ROUND_NUMBER = 4;
                            form.genel_indirim=get_act_detail.SA_DISCOUNT*newRateToCompany;
                            if(len(get_act_detail.round_money))
                                form.yuvarlama=get_act_detail.round_money*newRateToCompany;	
                            if(len(get_related_act.to_price_cat))
                            {
                                form.basket_gross_total=0;
                                form.basket_net_total=0;
                                attributes.basket_net_total=0;
                                form.basket_otv_total=0;
                                form.basket_tax_total=0;
                                form.basket_discount_total = 0;
                            }
                            else
                            {
                                form.basket_gross_total=get_act_detail.GROSSTOTAL*newRateToCompany;
                                form.basket_net_total=get_act_detail.NETTOTAL*newRateToCompany;
                                attributes.basket_net_total=get_act_detail.NETTOTAL*newRateToCompany;
                                form.basket_otv_total=get_act_detail.OTV_TOTAL*newRateToCompany;
                                form.basket_tax_total=get_act_detail.TAXTOTAL*newRateToCompany;
                                form.basket_discount_total = form.genel_indirim*newRateToCompany;
                            }
                            xml_tax_count=1;//kdv sayısı
                            xml_otv_count=1;//otv sayısı
                        </cfscript>
                        <cfloop query="get_act_rows">
                            <cfset row_ind = get_act_rows.currentrow>
                            <cfif isdefined("is_action_file_") and is_action_file_ eq 1 and Len(new_product_id_)>
                                <cfset 'attributes.product_id#row_ind#' = new_product_id_>
                            <cfelse>
                                <cfset 'attributes.product_id#row_ind#' = get_act_rows.PRODUCT_ID[row_ind]>
                            </cfif>
                            <cfquery name="get_product_id" datasource="#new_dsn2#">
                                SELECT
                                    S.BARCOD BARCODE,
                                    S.STOCK_ID,
                                    S.PRODUCT_ID,
                                    S.STOCK_CODE,
                                    S.PRODUCT_NAME,
                                    S.PROPERTY,
                                    S.IS_INVENTORY,
                                    S.MANUFACT_CODE,
                                    S.TAX,
                                    S.IS_PRODUCTION
                                    <cfif len(get_related_act.to_price_cat)>
                                        ,PP.PRICE PRICE_KDV
                                    <cfelse>
                                        ,#get_act_rows.price# PRICE_KDV
                                    </cfif>
                                FROM
                                    #new_dsn3_group#.STOCKS AS S
                                    <cfif len(get_related_act.to_price_cat)>
                                        ,#new_dsn3_group#.PRICE AS PP
                                    </cfif>
                                WHERE
                                    S.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.product_id#row_ind#')#">
                                    <cfif len(get_related_act.to_price_cat)>
                                        AND PP.PRODUCT_ID = S.PRODUCT_ID
                                        AND PP.PRICE_CATID = #get_related_act.to_price_cat#
                                        AND PP.STARTDATE <= #createodbcdatetime(get_act_detail.invoice_date)#
                                        AND (PP.FINISHDATE IS NULL OR PP.FINISHDATE >=#createodbcdatetime(get_act_detail.invoice_date)#)
                                    </cfif>
                            </cfquery>
                            <cfif not get_product_id.recordcount>
                                <cfquery name="get_product_id" datasource="#new_dsn2#">
                                    SELECT
                                        S.BARCOD BARCODE,
                                        S.STOCK_ID,
                                        S.PRODUCT_ID,
                                        S.STOCK_CODE,
                                        S.PRODUCT_NAME,
                                        S.PROPERTY,
                                        S.IS_INVENTORY,
                                        S.MANUFACT_CODE,
                                        S.TAX,
                                        S.IS_PRODUCTION
                                        ,#get_act_rows.price# PRICE_KDV
                                    FROM
                                        #new_dsn3_group#.STOCKS AS S
                                    WHERE
                                        S.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.product_id#row_ind#')#">
                                </cfquery>
                            </cfif>
                            <cfquery name="get_row_rate" dbtype="query">
                                SELECT RATE2/RATE1 NEW_RATE FROM get_money WHERE MONEY_TYPE = '#get_act_rows.other_money#'
                            </cfquery>
                            <cfif len(get_related_act.to_price_cat) and get_product_id.recordcount>
                                <!--- Sözleşme İndirimleri --->
                                <cfquery name="get_contract_discounts" datasource="#new_dsn3_group#" maxrows="1">
                                    SELECT
                                        ISNULL(PC.DISCOUNT_RATE,0) DISCOUNT_RATE,
                                        ISNULL(PC.DISCOUNT_RATE_2,0) DISCOUNT_RATE_2,
                                        ISNULL(PC.DISCOUNT_RATE_3,0) DISCOUNT_RATE_3,
                                        ISNULL(PC.DISCOUNT_RATE_4,0) DISCOUNT_RATE_4,
                                        ISNULL(PC.DISCOUNT_RATE_5,0) DISCOUNT_RATE_5,
                                        PC.PAYMENT_TYPE_ID
                                    FROM 
                                        PRICE_CAT_EXCEPTIONS PC,
                                        RELATED_CONTRACT RC
                                    WHERE
                                        PC.CONTRACT_ID = RC.CONTRACT_ID
                                        AND (PC.SUPPLIER_ID IS NULL OR PC.SUPPLIER_ID = (SELECT COMPANY_ID FROM STOCKS WHERE STOCK_ID=#get_product_id.stock_id#))
                                        AND (PC.PRODUCT_ID IS NULL OR PC.PRODUCT_ID=#get_product_id.product_id#)
                                        AND (PC.BRAND_ID IS NULL OR PC.BRAND_ID=(SELECT BRAND_ID FROM STOCKS WHERE STOCK_ID=#get_product_id.stock_id#))
                                        AND (PC.PRODUCT_CATID IS NULL OR PC.PRODUCT_CATID=(SELECT PRODUCT_CATID FROM STOCKS WHERE STOCK_ID=#get_product_id.stock_id#) OR (SELECT STOCK_CODE FROM STOCKS WHERE STOCK_ID=#get_product_id.stock_id#) LIKE (SELECT PCC.HIERARCHY FROM PRODUCT_CAT PCC WHERE PCC.PRODUCT_CATID = PC.PRODUCT_CATID)+'.%')
                                        AND (PC.SHORT_CODE_ID IS NULL OR PC.SHORT_CODE_ID=(SELECT SHORT_CODE_ID FROM STOCKS WHERE STOCK_ID=#get_product_id.stock_id#))
                                        AND RC.STARTDATE <= #createodbcdatetime(get_act_detail.invoice_date)#
                                        AND RC.FINISHDATE >= #createodbcdatetime(get_act_detail.invoice_date)#
                                        AND	RC.COMPANY LIKE '%,#get_related_act.TO_COMPANY_ID#,%'
                                        AND PC.PRICE_CATID=#get_related_act.to_price_cat#
                                    ORDER BY 
                                        PC.PRODUCT_ID DESC,PC.BRAND_ID DESC,(SELECT PCC.HIERARCHY FROM PRODUCT_CAT PCC WHERE PCC.PRODUCT_CATID = PC.PRODUCT_CATID) DESC,PC.PRODUCT_CATID DESC,PC.SUPPLIER_ID DESC,PC.COMPANYCAT_ID DESC,PC.SHORT_CODE_ID DESC
                                </cfquery>
                            </cfif>
                            <cfscript>
                                'attributes.product_name#row_ind#'=get_act_rows.NAME_PRODUCT[row_ind];
                                'attributes.product_name_other#row_ind#'=get_act_rows.PRODUCT_NAME2[row_ind];
                                'attributes.tax#row_ind#'= get_act_rows.TAX[row_ind];
                                'attributes.is_inventory#row_ind#'=get_product_id.IS_INVENTORY;
                                if(get_product_id.IS_INVENTORY) inventory_product_exists = 1;
                                'attributes.is_production#row_ind#'=get_product_id.IS_PRODUCTION;
                                'attributes.amount#row_ind#'=get_act_rows.AMOUNT[row_ind];
                                'attributes.deliver_date#row_ind#'=get_act_rows.DELIVER_DATE[row_ind];
                                'attributes.deliver_dept#row_ind#'="#get_related_act.TO_DEPT_ID#-#get_related_act.TO_LOC_ID#";
                                'attributes.duedate#row_ind#'=get_act_rows.DUE_DATE[row_ind];
                                'attributes.ek_tutar#row_ind#'=iif((len(get_act_rows.EXTRA_PRICE[row_ind])),'get_act_rows.EXTRA_PRICE[row_ind]*newRateToCompany','0');
                                'attributes.ek_tutar_price#row_ind#'=iif((len(get_act_rows.EK_TUTAR_PRICE[row_ind])),'get_act_rows.EK_TUTAR_PRICE[row_ind]*newRateToCompany','0');
                                'attributes.ek_tutar_other_total#row_ind#'=iif((len(get_act_rows.EXTRA_PRICE_TOTAL[row_ind])),'get_act_rows.EXTRA_PRICE_TOTAL[row_ind]*newRateToCompany','0');
                                'attributes.ek_tutar_total#row_ind#'=iif((len(get_act_rows.EXTRA_PRICE_OTHER_TOTAL[row_ind])),'get_act_rows.EXTRA_PRICE_OTHER_TOTAL[row_ind]*newRateToCompany','0');
                                'attributes.extra_cost#row_ind#'=iif((len(get_act_rows.EXTRA_COST[row_ind])),'get_act_rows.EXTRA_COST[row_ind]*newRateToCompany','0');
                                'attributes.iskonto_tutar#row_ind#'=iif((len(get_act_rows.DISCOUNT_COST[row_ind])),'get_act_rows.DISCOUNT_COST[row_ind]*newRateToCompany','0');
                                'attributes.is_commission#row_ind#'=get_act_rows.IS_COMMISSION[row_ind];
                    
                                'attributes.is_promotion#row_ind#'=get_act_rows.IS_PROMOTION[row_ind];
                                'attributes.karma_product_id#row_ind#'=get_act_rows.KARMA_PRODUCT_ID[row_ind];
                                if(len(get_related_act.to_price_cat))
                                    'attributes.list_price#row_ind#'=get_product_id.PRICE_KDV[row_ind];
                                else
                                    'attributes.list_price#row_ind#'=get_act_rows.LIST_PRICE[row_ind]*newRateToCompany;
                                    
                                'attributes.lot_no#row_ind#'=get_act_rows.LOT_NO[row_ind];
                                'attributes.manufact_code#row_ind#'=get_act_rows.PRODUCT_MANUFACT_CODE[row_ind];
                                'attributes.marj#row_ind#'=get_act_rows.MARGIN[row_ind];
                                'attributes.net_maliyet#row_ind#'=get_act_rows.COST_PRICE[row_ind]*newRateToCompany;
                                'attributes.number_of_installment#row_ind#'=get_act_rows.NUMBER_OF_INSTALLMENT[row_ind];
                                'attributes.order_currency#row_ind#'='-1';
                                
                                'attributes.otv_oran#row_ind#'=get_act_rows.OTV_ORAN[row_ind];
                                'attributes.row_otvtotal#row_ind#'=get_act_rows.OTVTOTAL[row_ind]*newRateToCompany;
                                
                                if(len(get_related_act.to_price_cat))
                                {
                                    if(get_contract_discounts.recordcount)
                                    {
                                        'attributes.indirim1#row_ind#'=get_contract_discounts.DISCOUNT_RATE;
                                        'attributes.indirim2#row_ind#'=get_contract_discounts.DISCOUNT_RATE_2;
                                        'attributes.indirim3#row_ind#'=get_contract_discounts.DISCOUNT_RATE_3;
                                        'attributes.indirim4#row_ind#'=get_contract_discounts.DISCOUNT_RATE_4;
                                        'attributes.indirim5#row_ind#'=get_contract_discounts.DISCOUNT_RATE_5;
                                        'attributes.indirim6#row_ind#'=0;
                                        'attributes.indirim7#row_ind#'=0;
                                        'attributes.indirim8#row_ind#'=0;
                                        'attributes.indirim9#row_ind#'=0;
                                        'attributes.indirim10#row_ind#'=0;
                                    }
                                    else
                                    {
                                        'attributes.indirim1#row_ind#'=0;
                                        'attributes.indirim2#row_ind#'=0;
                                        'attributes.indirim3#row_ind#'=0;
                                        'attributes.indirim4#row_ind#'=0;
                                        'attributes.indirim5#row_ind#'=0;
                                        'attributes.indirim6#row_ind#'=0;
                                        'attributes.indirim7#row_ind#'=0;
                                        'attributes.indirim8#row_ind#'=0;
                                        'attributes.indirim9#row_ind#'=0;
                                        'attributes.indirim10#row_ind#'=0;
                                    }
                                }
                                else
                                {
                                    'attributes.indirim1#row_ind#'=get_act_rows.DISCOUNT1[row_ind];
                                    'attributes.indirim2#row_ind#'=get_act_rows.DISCOUNT2[row_ind];
                                    'attributes.indirim3#row_ind#'=get_act_rows.DISCOUNT3[row_ind];
                                    'attributes.indirim4#row_ind#'=get_act_rows.DISCOUNT4[row_ind];
                                    'attributes.indirim5#row_ind#'=get_act_rows.DISCOUNT5[row_ind];
                                    'attributes.indirim6#row_ind#'=get_act_rows.DISCOUNT6[row_ind];
                                    'attributes.indirim7#row_ind#'=get_act_rows.DISCOUNT7[row_ind];
                                    'attributes.indirim8#row_ind#'=get_act_rows.DISCOUNT8[row_ind];
                                    'attributes.indirim9#row_ind#'=get_act_rows.DISCOUNT9[row_ind];
                                    'attributes.indirim10#row_ind#'=get_act_rows.DISCOUNT10[row_ind];
                                }
                                'attributes.indirim_carpan#row_ind#' = (100-Evaluate('attributes.indirim1#row_ind#')) * (100-Evaluate('attributes.indirim2#row_ind#')) * (100-Evaluate('attributes.indirim3#row_ind#')) * (100-Evaluate('attributes.indirim4#row_ind#')) * (100-Evaluate('attributes.indirim5#row_ind#')) * (100-Evaluate('attributes.indirim6#row_ind#')) * (100-Evaluate('attributes.indirim7#row_ind#')) * (100-Evaluate('attributes.indirim8#row_ind#')) * (100-Evaluate('attributes.indirim9#row_ind#')) * (100-Evaluate('attributes.indirim10#row_ind#'));
                                if(len(get_related_act.to_price_cat) and get_product_id.price_kdv neq 0)
                                {
                                    'attributes.price#row_ind#' = get_act_rows.PRICE[row_ind]*get_product_id.price_kdv/get_act_rows.PRICE[row_ind];
                                    'attributes.price_other#row_ind#' = get_act_rows.PRICE_OTHER[row_ind]*get_product_id.price_kdv/get_act_rows.PRICE[row_ind];
                                    'attributes.row_total#row_ind#' = get_product_id.price_kdv*get_act_rows.AMOUNT[row_ind];
                                    'attributes.row_nettotal#row_ind#' = wrk_round((Evaluate('attributes.row_total#row_ind#')/100000000000000000000)*Evaluate('attributes.indirim_carpan#row_ind#'),4);
                                    'attributes.row_taxtotal#row_ind#' = Evaluate('attributes.row_nettotal#row_ind#')*get_act_rows.TAX[row_ind]/100;
                                    'form.row_taxtotal#row_ind#' = Evaluate('attributes.row_nettotal#row_ind#')*get_act_rows.TAX[row_ind]/100;
                                    'attributes.row_lasttotal#row_ind#' = Evaluate('attributes.row_nettotal#row_ind#') + (Evaluate('attributes.row_nettotal#row_ind#')*get_act_rows.TAX[row_ind]/100);
                                    'attributes.other_money_#row_ind#' = get_act_rows.OTHER_MONEY[row_ind];
                                    'attributes.other_money_value_#row_ind#' = Evaluate('attributes.row_nettotal#row_ind#')/get_row_rate.new_rate;
                                    
                                    form.basket_gross_total=form.basket_gross_total+Evaluate('attributes.row_total#row_ind#');
                                    form.basket_net_total=form.basket_net_total+Evaluate('attributes.row_lasttotal#row_ind#');
                                    attributes.basket_net_total=form.basket_net_total+Evaluate('attributes.row_lasttotal#row_ind#');
                                    form.basket_tax_total=form.basket_tax_total+Evaluate('attributes.row_taxtotal#row_ind#');
                                    form.basket_discount_total=form.basket_discount_total+Evaluate('attributes.row_total#row_ind#')-Evaluate('attributes.row_nettotal#row_ind#'); 
                                }
                                else
                                {
                                    'attributes.price#row_ind#' = get_act_rows.PRICE[row_ind]*newRateToCompany;
                                    'attributes.price_other#row_ind#' = get_act_rows.PRICE_OTHER[row_ind];
                                    'attributes.row_total#row_ind#' = get_act_rows.NETTOTAL[row_ind]*newRateToCompany;
                                    'attributes.row_nettotal#row_ind#' = get_act_rows.NETTOTAL[row_ind]*newRateToCompany;
                                    'attributes.row_taxtotal#row_ind#' = get_act_rows.NETTOTAL[row_ind]*get_act_rows.TAX[row_ind]/100*newRateToCompany;
                                    'form.row_taxtotal#row_ind#' = get_act_rows.NETTOTAL[row_ind]*get_act_rows.TAX[row_ind]/100*newRateToCompany;
                                    'attributes.row_lasttotal#row_ind#' = get_act_rows.NETTOTAL[row_ind] + (get_act_rows.NETTOTAL[row_ind]*get_act_rows.TAX[row_ind]/100)*newRateToCompany;
                                    'attributes.other_money_#row_ind#' = get_act_rows.OTHER_MONEY[row_ind];
                                    'attributes.other_money_value_#row_ind#' = get_act_rows.OTHER_MONEY_VALUE[row_ind];
                                    'attributes.other_money_gross_total#row_ind#' = get_act_rows.OTHER_MONEY_VALUE[row_ind] + (get_act_rows.OTHER_MONEY_VALUE[row_ind]*get_act_rows.TAX[row_ind]/100);
                                }
                                'attributes.price_cat#row_ind#'=get_act_rows.PRICE_CAT[row_ind];
                                'attributes.product_account_code#row_ind#'='';
                                'attributes.promosyon_maliyet#row_ind#'=get_act_rows.PROM_COST[row_ind];
                                'attributes.promosyon_yuzde#row_ind#'=get_act_rows.PROM_COMISSION[row_ind];
                                'attributes.prom_relation_id#row_ind#'=get_act_rows.PROM_RELATION_ID[row_ind];
                                'attributes.prom_stock_id#row_ind#'=get_act_rows.PROM_STOCK_ID[row_ind];
                                'attributes.reserve_date#row_ind#'='';
                                'attributes.reserve_type#row_ind#'='-1';
                                'attributes.row_promotion_id#row_ind#'=get_act_rows.PROM_ID[row_ind];
                                'attributes.row_service_id#row_ind#'='';
                                'attributes.row_ship_id#row_ind#'=0;
                                'attributes.row_unique_relation_id#row_ind#'=get_act_rows.UNIQUE_RELATION_ID[row_ind];
                                'attributes.shelf_number#row_ind#'=get_act_rows.SHELF_NUMBER[row_ind];
								/*	PY 0715
									spect var id den main id yi buluyoruz yeni şirkette bu spect main id varsa onun herhangi bir spect_var_id sini atıyoruz
									eğer bulduğumuz spect main id şirketimizde yoksa o stoğa ait herhangi bir spect main id ye bağlı spect var id çekip atıyoruz
									hiç spect main id yoksa atmıyoruz
								*/
								// grup içi işlemde spec kaydı atmayla ilgili düzenleme yapıldı, main spec varsa spec üretiyoruz yoksa boş atıyoruz 1115 PY
								if (get_product_id.IS_PRODUCTION eq 1)
								{
									SQLStr = 'SELECT TOP 1 SPECT_MAIN_ID FROM #new_dsn3_group#.SPECT_MAIN  AS SM WHERE SM.STOCK_ID = #evaluate("attributes.stock_id#row_ind#")# AND SM.IS_TREE = 1 ORDER BY SM.RECORD_DATE DESC,SM.UPDATE_DATE DESC';
									'GET_TREE#row_ind#' = cfquery(SQLString : SQLStr, Datasource : new_dsn2);
									if(not isdefined('attributes.company_id')) attributes.company_id = 0;
									if(not isdefined('attributes.consumer_id')) attributes.consumer_id = 0;
									if(evaluate('GET_TREE#row_ind#.RECORDCOUNT'))
									{
										'spec_info#row_ind#' = specer(
												dsn_type:new_dsn2,
												spec_type:1,
												main_spec_id:evaluate('GET_TREE#row_ind#.SPECT_MAIN_ID'),
												add_to_main_spec:1,
												company_id: attributes.company_id,
												is_company_related_action: 1,
												company_related_dsn: new_dsn3_group,
												consumer_id: attributes.consumer_id
											);
										if(isdefined('attributes.is_spect_name_to_property') and attributes.is_spect_name_to_property eq 1){//Spec ismi confg.ürünlerden oluşturuluyor ise!
											configure_spec_name = evaluate("attributes.product_name#row_ind#");
											GetProductConf(listgetat(Evaluate('spec_info#row_ind#'),1,','));//fonksiyon burda çağırlıyor ilk olarak
										}	
										if(isdefined('attributes.is_spect_name_to_property') and attributes.is_spect_name_to_property eq 1 and isdefined('spec_info#row_ind#')){
											SQLStr1 = 'UPDATE #new_dsn3_group#.SPECT_MAIN SET SPECT_MAIN_NAME = "#left(configure_spec_name,499)#" WHERE SPECT_MAIN_ID = #listgetat(Evaluate('spec_info#row_ind#'),1,',')# ';
											UpdateSpecNameQuery = cfquery(SQLString : SQLStr1, Datasource : new_dsn2);
											if(len(listgetat(Evaluate('spec_info#row_ind#'),1,',')) and listgetat(Evaluate('spec_info#row_ind#'),1,',') gt 0){
												SQLStr2 = 'UPDATE #new_dsn3_group#.SPECT_MAIN SET SPECT_MAIN_NAME = "#left(configure_spec_name,499)#" WHERE SPECT_MAIN_ID = #listgetat(Evaluate('spec_info#row_ind#'),1,',')# ';
												UpdateS_V_SpecNameQuery = cfquery(SQLString : SQLStr2, Datasource : new_dsn2);
											}
										}
										if(isdefined('spec_info#row_ind#') and listlen(evaluate('spec_info#row_ind#'),',')){
											'attributes.spect_id#row_ind#'=listgetat(evaluate('spec_info#row_ind#'),2,',');
											if(len(listgetat(evaluate('spec_info#row_ind#'),3,',')))
												'attributes.spect_name#row_ind#'=listgetat(evaluate('spec_info#row_ind#'),3,',');
											else
												'attributes.spect_name#row_ind#'=evaluate("attributes.product_name#row_ind#");
										}
										else
										{
											'attributes.spect_id#row_ind#'= '';
											'attributes.spect_name#row_ind#'='';	
										}
									}
									else
									{
										'attributes.spect_id#row_ind#'= '';
										'attributes.spect_name#row_ind#'='';	
									}
								}
								else
								{
									'attributes.spect_id#row_ind#'='';
									'attributes.spect_name#row_ind#'='';
								}
                                'attributes.stock_id#row_ind#'=get_act_rows.STOCK_ID[row_ind];
                                'attributes.unit#row_ind#'=get_act_rows.UNIT[row_ind];
                                'attributes.unit_id#row_ind#'=get_act_rows.UNIT_ID[row_ind];
                                'attributes.unit_other#row_ind#'=get_act_rows.UNIT2[row_ind];
                                'attributes.basket_employee_id#row_ind#'=get_act_rows.BASKET_EMPLOYEE_ID[row_ind];
                                'attributes.basket_extra_info#row_ind#'=get_act_rows.BASKET_EXTRA_INFO_ID[row_ind];
                                'attributes.select_info_extra#row_ind#'=get_act_rows.SELECT_INFO_EXTRA[row_ind];
                                'attributes.detail_info_extra#row_ind#'=get_act_rows.DETAIL_INFO_EXTRA[row_ind];
                                if(isdefined('session.pp.userid'))
                                    'attributes.wrk_row_id#row_ind#'="WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.pp.userid##round(rand()*100)#";
                                else if(isdefined('session.ww.userid'))
                                    'attributes.wrk_row_id#row_ind#'="WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ww.userid##round(rand()*100)#";
                                else
                                    'attributes.wrk_row_id#row_ind#'="WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)#";
                                'attributes.wrk_row_relation_id#row_ind#'=get_act_rows.WRK_ROW_ID[row_ind];
                                attributes.rows_ = row_ind;
                            </cfscript>
                        </cfloop>
                        <cfscript>
                            for(ind_inv_row=1;ind_inv_row lte attributes.rows_;ind_inv_row=ind_inv_row+1)
                            {
                                //fatura altı indirim varsa ona hesaplanarak satırlara yansıtılıyor
                                row_price_=get_act_rows.PRICE[ind_inv_row]*get_act_rows.AMOUNT[ind_inv_row]*newRateToCompany;
                                tmp_tax=0;
                                for(ind_tax_count=1;ind_tax_count lte xml_tax_count;ind_tax_count=ind_tax_count+1)
                                {
                                    if(isdefined('form.basket_tax_#ind_tax_count#') and evaluate('form.basket_tax_#ind_tax_count#') eq evaluate('attributes.tax#ind_inv_row#'))
                                    {
                                        'form.basket_tax_value_#ind_tax_count#' =evaluate('form.basket_tax_value_#ind_tax_count#') + wrk_round((row_price_/100)*get_act_rows.TAX[ind_inv_row],2);
                                        tmp_tax=1;
                                        break;
                                    }
                                }
                                if(tmp_tax eq 0)
                                {
                                    'form.basket_tax_#xml_tax_count#' = evaluate('attributes.tax#ind_inv_row#');
                                    'form.basket_tax_value_#xml_tax_count#' =  wrk_round((row_price_/100)*get_act_rows.TAX[ind_inv_row],2);
                                    xml_tax_count=xml_tax_count+1;
                                }
                                tmp_otv=0;
                                for(ind_otv_count=1;ind_otv_count lte xml_otv_count;ind_otv_count=ind_otv_count+1)
                                {
                                    if(isdefined('form.basket_otv_#ind_otv_count#') and evaluate('form.basket_otv_#ind_otv_count#') eq evaluate('attributes.otv_oran#ind_inv_row#'))
                                    {
                                        'form.basket_otv_value_#ind_otv_count#'= evaluate('form.basket_otv_value_#ind_otv_count#') + wrk_round((row_price_/100)*get_act_rows.OTV_ORAN[ind_inv_row],2);
                                        tmp_otv=1;
                                        break;
                                    }
                                }
                                if(tmp_otv eq 0)	
                                {
                                    'form.basket_otv_#xml_otv_count#'= evaluate('attributes.otv_oran#ind_inv_row#');
                                    'form.basket_otv_value_#xml_otv_count#'= wrk_round((row_price_/100)*get_act_rows.OTV_ORAN[ind_inv_row],2);
                                    xml_otv_count=xml_otv_count+1;
                                }
                            }
                        </cfscript>
                        <cfscript>
                            form.basket_otv_count = xml_otv_count-1;//otv oran sayısı
                            form.basket_tax_count = xml_tax_count-1;//kdv sayısı
                            xml_import=2;
                            is_from_import=1;
                        </cfscript>
                        <cfif get_related_act.to_act_type eq 3>
                            <cfset xml_import=1>
                            <cfset is_from_function = 1>
                            <cfinclude template="../../invoice/query/add_invoice_sale.cfm">
                        <cfelse>
                            <cfset xml_import=2>
                            <cfset is_from_function = 1>
                            <cfinclude template="../../invoice/query/add_invoice_purchase.cfm">
                        </cfif>
                        
						<cfif isdefined('error_flag') and error_flag eq 1>
							<script type="text/javascript">
                                alert("Belgeniz Kaydedildi Fakat Grup İçi İlişkili İşlem Kaydı Yapılamadı.");
                            </script>
                            <cfabort>
                        </cfif>
                    <cfelse>
						<script type="text/javascript">
                            alert("Belgeniz Kaydedildi Fakat Grup İçi İlişkili İşlem Kaydı Yapılamadı ! Aktarılacak Şirketteki Muhasebe Dönem Kısıtını Kontrol Ediniz !");
                        </script>
                        <cfabort>
                    </cfif> 
                </cfif>
            </cfif>
            
		<cfelseif action_type eq 1 or action_type eq 2><!--- satış ve alış siparişi İse --->
            <cfquery name="get_act_detail" datasource="#new_dsn2#">
				SELECT * FROM #dsn3_alias#.ORDERS WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
			</cfquery>
			<cfif get_act_detail.recordcount and len(get_act_detail.company_id)>
				<cfquery name="get_related_act" datasource="#new_dsn2#">
					SELECT ISNULL(TO_COMPANY_ID,#get_act_detail.company_id#) TO_COMPANY_ID_,* FROM #dsn_alias#.COMPANY_GROUP_ACTIONS WHERE FROM_ACT_TYPE =#action_type# AND TO_ACT_TYPE IN(1,2) AND FROM_OUR_COMP_ID =#arguments.comp_id# AND (FROM_COMPANY_ID IS NULL OR FROM_COMPANY_ID = #get_act_detail.company_id#) AND (FROM_PROCESS_STAGE IS NULL OR FROM_PROCESS_STAGE = #get_act_detail.order_stage#)
				</cfquery>
				<cfif get_related_act.recordcount>
					<cfset new_comp_id = get_related_act.to_our_comp_id> 
					<cfif get_related_act.to_act_type eq 1>
						<cfset new_dsn3_group = "#dsn#_#get_related_act.to_our_comp_id#"> 
					<cfelse>
						<cfset new_dsn3_group = "#dsn#_#get_related_act.to_our_comp_id#"> 
						<cfset new_dsn3_group_pur = "#dsn#_#get_related_act.to_our_comp_id#"> 
					</cfif>	
					<cfset new_dsn2_group = "#dsn#_#session.ep.period_year#_#get_related_act.to_our_comp_id#"> 
					<cfquery name="get_act_rows" datasource="#new_dsn2#">
						SELECT * FROM #dsn3_alias#.ORDER_ROW WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> ORDER BY ORDER_ROW_ID
					</cfquery>
                    
                    <!--- FA iki şirketin sistem para birimleri farklı ise karşı şirketin para birimleri gönderilmelidir cari ve muhasebe işlemlerinde gönderilmeyince session daki para birimlerini almaktadır. --->
                    <cfquery name="getCompanyPeriodMoney" datasource="#dsn#">
                        SELECT STANDART_PROCESS_MONEY AS TO_MONEY,OTHER_MONEY AS TO_MONEY_2 FROM SETUP_PERIOD WHERE PERIOD_YEAR = #session.ep.period_year# AND OUR_COMPANY_ID = #new_comp_id#
                    </cfquery>
                    
                    <!--- 
						FA 08122014 
						iki şirketin sistem para birimleri farklı ise karşı şirkette kur ve fiyatların düzeltilmesi için oran bulunur ve fiyatlar bu oran ile düzenlenir 
						sistem para birimi aynı olan şirketlerde bu oran zaten 1 olacaktır
						sistem para birimi farklı olan şirketlerde oran kaydedilen belgeden yeniden hesaplanır 
					--->
					<cfquery name="getMoneyNewRateToCompany" datasource="#new_dsn2#">
						SELECT
							OM.RATE2/OM2.RATE2 NEW_RATE
						FROM 
							#dsn3_alias#.ORDER_MONEY OM
							LEFT JOIN #dsn3_alias#.ORDER_MONEY OM2 ON OM2.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> AND 
                            OM2.MONEY_TYPE = (SELECT MONEY FROM #new_dsn2_group#.SETUP_MONEY WHERE RATE2/RATE1 = 1)
						WHERE 
							OM.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> AND
							OM.RATE1/OM.RATE2 = 1
					</cfquery>
					<cfset newRateToCompany = getMoneyNewRateToCompany.NEW_RATE>
					
					<cfquery name="get_money" datasource="#new_dsn2#">
						SELECT (RATE2*#newRateToCompany#) AS RATE2,RATE1,MONEY_TYPE,IS_SELECTED FROM #dsn3_alias#.ORDER_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
					</cfquery>
					<cfquery name="get_money_selected" dbtype="query">
						SELECT RATE2,RATE1,MONEY_TYPE FROM get_money WHERE IS_SELECTED=1
					</cfquery>
                    
					<cfquery name="get_to_period_id" datasource="#dsn#">
						SELECT PERIOD_ID FROM SETUP_PERIOD WHERE PERIOD_YEAR=#session.ep.period_year# AND OUR_COMPANY_ID = #get_related_act.to_our_comp_id#
					</cfquery>
					<cfset new_period_id = get_to_period_id.period_id>
					<cfquery name="get_member_id" datasource="#new_dsn2#">
						SELECT
							COMPANY.COMPANY_ID,
							ISNULL(COMPANY.MANAGER_PARTNER_ID,(SELECT TOP 1 PARTNER_ID FROM #dsn_alias#.COMPANY_PARTNER WHERE COMPANY_ID=COMPANY.COMPANY_ID)) PARTNER_ID,
							COMPANY_PERIOD.ACCOUNT_CODE
						FROM 
							#dsn_alias#.COMPANY,
							#dsn_alias#.COMPANY_PERIOD
						WHERE
							COMPANY.COMPANY_ID = #get_related_act.TO_COMPANY_ID_# AND
							COMPANY_PERIOD.COMPANY_ID = COMPANY.COMPANY_ID AND
							COMPANY_PERIOD.PERIOD_ID = #new_period_id#
					</cfquery>
					<cfquery name="get_partner" datasource="#dsn#">
						SELECT MANAGER_PARTNER_ID FROM COMPANY WHERE COMPANY_ID = #get_related_act.TO_COMPANY_ID_#
					</cfquery>
					<cfscript>
						// FA iki sirketin para birimleri farklı ise gonderilmek zorunda
						if(not session.ep.money is getCompanyPeriodMoney.to_money)
						{
							to_action_currency = getCompanyPeriodMoney.to_money;
							to_action_currency_2 = getCompanyPeriodMoney.to_money_2;
						}
						
						form.sale_product=1;
						form.process_cat=get_related_act.to_process_type;
						invoice_cat=get_related_act.to_process_type;
						form.active_company="#arguments.comp_id#";
						attributes.rows_ = get_act_rows.recordcount;
						attributes.deliver_dept_id=get_related_act.to_dept_id;
						attributes.deliver_loc_id=get_related_act.to_loc_id;
						attributes.deliver_dept_name=get_related_act.to_loc_id;
						attributes.process_stage=get_related_act.to_process_stage;
						attributes.order_employee_id =get_related_act.to_sale_emp;
						attributes.company_id=get_related_act.TO_COMPANY_ID_;
						attributes.partner_id=get_partner.MANAGER_PARTNER_ID;
						attributes.comp_name='a';
						attributes.partner_name='b';
						attributes.consumer_id='';
						
						attributes.reserved = 1;
						attributes.invoice_number='';
						form.invoice_number='';
						attributes.ref_no='';
						attributes.order_date=dateformat(get_act_detail.order_date,dateformat_style);
						attributes.order_id = '';
						attributes.kasa='';
						kasa='';
						attributes.member_account_code=GET_MEMBER_ID.ACCOUNT_CODE;
						attributes.order_detail=get_act_detail.order_detail;
						order_detail=get_act_detail.order_detail;
						attributes.city_id='';
						attributes.county_id='';
						attributes.adres=get_act_detail.SHIP_ADDRESS;
						for(stp_mny=1;stp_mny lte GET_MONEY.RECORDCOUNT;stp_mny=stp_mny+1)
						{
							'attributes.hidden_rd_money_#stp_mny#'=GET_MONEY.MONEY_TYPE[stp_mny];
							'attributes.txt_rate1_#stp_mny#'=GET_MONEY.RATE1[stp_mny];	
							'attributes.txt_rate2_#stp_mny#'=GET_MONEY.RATE2[stp_mny];
						}
						form.basket_money=GET_MONEY_SELECTED.MONEY_TYPE;
						attributes.basket_money=GET_MONEY_SELECTED.MONEY_TYPE;
						form.basket_rate1=GET_MONEY_SELECTED.RATE1;
						form.basket_rate2=GET_MONEY_SELECTED.RATE2;
						attributes.kur_say=GET_MONEY.RECORDCOUNT;
						attributes.basket_id=2;
						attributes.list_payment_row_id='';
						attributes.subscription_id='';
						attributes.invoice_counter_number='';
						attributes.commethod_id='';
						attributes.bool_from_control_bill='';
						attributes.invoice_control_id='';
						attributes.contract_row_ids='';
						attributes.ship_method=get_act_detail.SHIP_METHOD;
						attributes.card_paymethod_id=get_act_detail.CARD_PAYMETHOD_ID;
						attributes.commission_rate=get_act_detail.CARD_PAYMETHOD_RATE;
						attributes.paymethod_id=get_related_act.TO_PAYMETHOD_ID;
						attributes.pay_method=get_related_act.TO_PAYMETHOD_ID;
						attributes.paymethod=get_related_act.TO_PAYMETHOD_ID;
						attributes.deliver_dept_id=get_related_act.TO_DEPT_ID;
						attributes.deliver_loc_id=get_related_act.TO_LOC_ID;
						attributes.deliver_dept_name=get_related_act.TO_DEPT_ID;
						attributes.project_id=get_act_detail.PROJECT_ID;
						PARTO_ID='';
						attributes.deliverdate = dateformat(get_act_detail.order_date,dateformat_style); 
						attributes.publishdate = dateformat(get_act_detail.publishdate,dateformat_style); 
						attributes.ship_date = dateformat(get_act_detail.order_date,dateformat_style); 
						form.DELIVER_GET_ID =get_related_act.to_sale_emp;
						form.DELIVER_GET =get_emp_info(get_related_act.to_sale_emp,0,0);	
						attributes.DELIVER_GET_ID =get_related_act.to_sale_emp;
						attributes.DELIVER_GET =get_emp_info(get_related_act.to_sale_emp,0,0);		
						attributes.ref_company_id = "";
						attributes.ref_member_type = "";
						attributes.ref_member_id = "";
						attributes.ref_company = "";
						inventory_product_exists = 0;
						attributes.tevkifat_oran='';
						attributes.is_general_prom=0;
						attributes.indirim_total='100000000000000000000,100000000000000000000';
						attributes.general_prom_limit='';
						attributes.general_prom_discount='';
						attributes.general_prom_amount=0;
						attributes.free_prom_limit='';
						attributes.flt_net_total_all=0;
						attributes.currency_multiplier = '';
						attributes.basket_member_pricecat='';
						attributes.basket_due_value_date_='';
						attributes.BASKET_PRICE_ROUND_NUMBER = 4;
						form.genel_indirim=get_act_detail.SA_DISCOUNT*newRateToCompany;
						if(len(get_related_act.to_price_cat))
						{
							form.basket_gross_total=0;
							form.basket_net_total=0;
							form.basket_otv_total=0;
							form.basket_tax_total=0;
							form.basket_discount_total = 0;
						}
						else
						{
							form.basket_gross_total=get_act_detail.GROSSTOTAL*newRateToCompany;
							form.basket_net_total=get_act_detail.NETTOTAL*newRateToCompany;
							iif((len(get_act_detail.OTV_TOTAL)),'get_act_detail.OTV_TOTAL*newRateToCompany','0');
							form.basket_tax_total=get_act_detail.TAXTOTAL*newRateToCompany;
							form.basket_discount_total = form.genel_indirim*newRateToCompany;
						}
						xml_tax_count=1;//kdv sayısı
						xml_otv_count=1;//otv sayısı
					</cfscript>
					<cfloop query="get_act_rows">
						<cfset row_ind = get_act_rows.currentrow>
						<cfif isdefined("is_action_file_") and is_action_file_ eq 1 and Len(new_product_id_)>
							<cfset 'attributes.product_id#row_ind#' = new_product_id_>
						<cfelse>
							<cfset 'attributes.product_id#row_ind#' = get_act_rows.PRODUCT_ID[row_ind]>
						</cfif>
						<cfquery name="get_product_id" datasource="#new_dsn2#">
							SELECT
								S.BARCOD BARCODE,
								S.STOCK_ID,
								S.PRODUCT_ID,
								S.STOCK_CODE,
								S.PRODUCT_NAME,
								S.PROPERTY,
								S.IS_INVENTORY,
								S.MANUFACT_CODE,
								S.TAX,
								S.IS_PRODUCTION
								<cfif len(get_related_act.to_price_cat)>
									,PP.PRICE PRICE_KDV
								<cfelse>
									,#get_act_rows.price# PRICE_KDV
								</cfif>
							FROM
								#new_dsn3_group#.STOCKS AS S
								<cfif len(get_related_act.to_price_cat)>
									,#new_dsn3_group#.PRICE AS PP
								</cfif>
							WHERE
								S.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.product_id#row_ind#')#">
								<cfif len(get_related_act.to_price_cat)>
									AND PP.PRODUCT_ID = S.PRODUCT_ID
									AND PP.PRICE_CATID = #get_related_act.to_price_cat#
									AND PP.STARTDATE <= #createodbcdatetime(get_act_detail.order_date)#
									AND (PP.FINISHDATE IS NULL OR PP.FINISHDATE >=#createodbcdatetime(get_act_detail.order_date)#)
								</cfif>
						</cfquery>
						<cfquery name="get_row_rate" dbtype="query">
							SELECT RATE2/RATE1 NEW_RATE FROM get_money WHERE MONEY_TYPE = '#get_act_rows.other_money#'
						</cfquery>
						<cfif len(get_related_act.to_price_cat) and get_product_id.recordcount>
							<!--- Sözleşme İndirimleri --->
							<cfquery name="get_contract_discounts" datasource="#new_dsn3_group#" maxrows="1">
								SELECT
									ISNULL(PC.DISCOUNT_RATE,0) DISCOUNT_RATE,
									ISNULL(PC.DISCOUNT_RATE_2,0) DISCOUNT_RATE_2,
									ISNULL(PC.DISCOUNT_RATE_3,0) DISCOUNT_RATE_3,
									ISNULL(PC.DISCOUNT_RATE_4,0) DISCOUNT_RATE_4,
									ISNULL(PC.DISCOUNT_RATE_5,0) DISCOUNT_RATE_5,
									PC.PAYMENT_TYPE_ID
								FROM 
									PRICE_CAT_EXCEPTIONS PC,
									RELATED_CONTRACT RC
								WHERE
									PC.CONTRACT_ID = RC.CONTRACT_ID
									AND (PC.SUPPLIER_ID IS NULL OR PC.SUPPLIER_ID = (SELECT COMPANY_ID FROM STOCKS WHERE STOCK_ID=#get_product_id.stock_id#))
									AND (PC.PRODUCT_ID IS NULL OR PC.PRODUCT_ID=#get_product_id.product_id#)
									AND (PC.BRAND_ID IS NULL OR PC.BRAND_ID=(SELECT BRAND_ID FROM STOCKS WHERE STOCK_ID=#get_product_id.stock_id#))
									AND (PC.PRODUCT_CATID IS NULL OR PC.PRODUCT_CATID=(SELECT PRODUCT_CATID FROM STOCKS WHERE STOCK_ID=#get_product_id.stock_id#) OR (SELECT STOCK_CODE FROM STOCKS WHERE STOCK_ID=#get_product_id.stock_id#) LIKE (SELECT PCC.HIERARCHY FROM PRODUCT_CAT PCC WHERE PCC.PRODUCT_CATID = PC.PRODUCT_CATID)+'.%')
									AND (PC.SHORT_CODE_ID IS NULL OR PC.SHORT_CODE_ID=(SELECT SHORT_CODE_ID FROM STOCKS WHERE STOCK_ID=#get_product_id.stock_id#))
									AND RC.STARTDATE <= #createodbcdatetime(get_act_detail.order_date)#
									AND RC.FINISHDATE >= #createodbcdatetime(get_act_detail.order_date)#
									AND	RC.COMPANY LIKE '%,#get_related_act.TO_COMPANY_ID_#,%'
									AND PC.PRICE_CATID=#get_related_act.to_price_cat#
								ORDER BY 
									PC.PRODUCT_ID DESC,PC.BRAND_ID DESC,(SELECT PCC.HIERARCHY FROM PRODUCT_CAT PCC WHERE PCC.PRODUCT_CATID = PC.PRODUCT_CATID) DESC,PC.PRODUCT_CATID DESC,PC.SUPPLIER_ID DESC,PC.COMPANYCAT_ID DESC,PC.SHORT_CODE_ID DESC
							</cfquery>
						</cfif>
						<cfscript>
							'attributes.product_name#row_ind#'=get_act_rows.PRODUCT_NAME[row_ind];
							'attributes.product_name_other#row_ind#'=get_act_rows.PRODUCT_NAME2[row_ind];
							'attributes.tax#row_ind#'= get_act_rows.TAX[row_ind];
							'attributes.is_inventory#row_ind#'=get_product_id.IS_INVENTORY;
							if(get_product_id.IS_INVENTORY) inventory_product_exists = 1;
							'attributes.is_production#row_ind#'=get_product_id.IS_PRODUCTION;
							'attributes.amount#row_ind#'=get_act_rows.QUANTITY[row_ind];
							'attributes.deliver_date#row_ind#'=get_act_rows.DELIVER_DATE[row_ind];
							'attributes.deliver_dept#row_ind#'="#get_related_act.TO_DEPT_ID#-#get_related_act.TO_LOC_ID#";
							'attributes.duedate#row_ind#'=get_act_rows.DUEDATE[row_ind];
							'attributes.ek_tutar#row_ind#'=iif((len(get_act_rows.EK_TUTAR_PRICE[row_ind])),'get_act_rows.EK_TUTAR_PRICE[row_ind]*newRateToCompany','0');
							'attributes.ek_tutar_other_total#row_ind#'=iif((len(get_act_rows.EXTRA_PRICE_TOTAL[row_ind])),'get_act_rows.EXTRA_PRICE_TOTAL[row_ind]*newRateToCompany','0');
							'attributes.ek_tutar_total#row_ind#'=iif((len(get_act_rows.EXTRA_PRICE_OTHER_TOTAL[row_ind])),'get_act_rows.EXTRA_PRICE_OTHER_TOTAL[row_ind]*newRateToCompany','0');
							'attributes.extra_cost#row_ind#'=iif((len(get_act_rows.EXTRA_COST[row_ind])),'get_act_rows.EXTRA_COST[row_ind]*newRateToCompany','0');
							'attributes.iskonto_tutar#row_ind#'=iif((len(get_act_rows.DISCOUNT_COST[row_ind])),'get_act_rows.DISCOUNT_COST[row_ind]*newRateToCompany','0');
							'attributes.is_commission#row_ind#'=get_act_rows.IS_COMMISSION[row_ind];
				
							'attributes.is_promotion#row_ind#'=get_act_rows.IS_PROMOTION[row_ind];
							'attributes.karma_product_id#row_ind#'=get_act_rows.KARMA_PRODUCT_ID[row_ind];
							if(len(get_related_act.to_price_cat))
								'attributes.list_price#row_ind#'=get_product_id.PRICE_KDV[row_ind];
							else
								'attributes.list_price#row_ind#'=iif((len(get_act_rows.LIST_PRICE[row_ind])),'get_act_rows.LIST_PRICE[row_ind]*newRateToCompany','0');
								
							'attributes.lot_no#row_ind#'=get_act_rows.LOT_NO[row_ind];
							'attributes.manufact_code#row_ind#'=get_act_rows.PRODUCT_MANUFACT_CODE[row_ind];
							'attributes.marj#row_ind#'=get_act_rows.MARJ[row_ind];
							'attributes.net_maliyet#row_ind#'=iif((len(get_act_rows.COST_PRICE[row_ind])),'get_act_rows.COST_PRICE[row_ind]*newRateToCompany','0');
							'attributes.number_of_installment#row_ind#'=get_act_rows.NUMBER_OF_INSTALLMENT[row_ind];
							'attributes.order_currency#row_ind#'='-1';
							
							'attributes.otv_oran#row_ind#'=get_act_rows.OTV_ORAN[row_ind];
							'attributes.row_otvtotal#row_ind#'=iif((len(get_act_rows.OTVTOTAL[row_ind])),'get_act_rows.OTVTOTAL[row_ind]*newRateToCompany','0');
							
							if(len(get_related_act.to_price_cat))
							{
								if(get_contract_discounts.recordcount)
								{
									'attributes.indirim1#row_ind#'=get_contract_discounts.DISCOUNT_RATE;
									'attributes.indirim2#row_ind#'=get_contract_discounts.DISCOUNT_RATE_2;
									'attributes.indirim3#row_ind#'=get_contract_discounts.DISCOUNT_RATE_3;
									'attributes.indirim4#row_ind#'=get_contract_discounts.DISCOUNT_RATE_4;
									'attributes.indirim5#row_ind#'=get_contract_discounts.DISCOUNT_RATE_5;
									'attributes.indirim6#row_ind#'=0;
									'attributes.indirim7#row_ind#'=0;
									'attributes.indirim8#row_ind#'=0;
									'attributes.indirim9#row_ind#'=0;
									'attributes.indirim10#row_ind#'=0;
								}
								else
								{
									'attributes.indirim1#row_ind#'=0;
									'attributes.indirim2#row_ind#'=0;
									'attributes.indirim3#row_ind#'=0;
									'attributes.indirim4#row_ind#'=0;
									'attributes.indirim5#row_ind#'=0;
									'attributes.indirim6#row_ind#'=0;
									'attributes.indirim7#row_ind#'=0;
									'attributes.indirim8#row_ind#'=0;
									'attributes.indirim9#row_ind#'=0;
									'attributes.indirim10#row_ind#'=0;
								}
							}
							else
							{
								'attributes.indirim1#row_ind#'=get_act_rows.DISCOUNT_1[row_ind];
								'attributes.indirim2#row_ind#'=get_act_rows.DISCOUNT_2[row_ind];
								'attributes.indirim3#row_ind#'=get_act_rows.DISCOUNT_3[row_ind];
								'attributes.indirim4#row_ind#'=get_act_rows.DISCOUNT_4[row_ind];
								'attributes.indirim5#row_ind#'=get_act_rows.DISCOUNT_5[row_ind];
								'attributes.indirim6#row_ind#'=get_act_rows.DISCOUNT_6[row_ind];
								'attributes.indirim7#row_ind#'=get_act_rows.DISCOUNT_7[row_ind];
								'attributes.indirim8#row_ind#'=get_act_rows.DISCOUNT_8[row_ind];
								'attributes.indirim9#row_ind#'=get_act_rows.DISCOUNT_9[row_ind];
								'attributes.indirim10#row_ind#'=get_act_rows.DISCOUNT_10[row_ind];
							}
							'attributes.indirim_carpan#row_ind#' = (100-Evaluate('attributes.indirim1#row_ind#')) * (100-Evaluate('attributes.indirim2#row_ind#')) * (100-Evaluate('attributes.indirim3#row_ind#')) * (100-Evaluate('attributes.indirim4#row_ind#')) * (100-Evaluate('attributes.indirim5#row_ind#')) * (100-Evaluate('attributes.indirim6#row_ind#')) * (100-Evaluate('attributes.indirim7#row_ind#')) * (100-Evaluate('attributes.indirim8#row_ind#')) * (100-Evaluate('attributes.indirim9#row_ind#')) * (100-Evaluate('attributes.indirim10#row_ind#'));
							if(len(get_related_act.to_price_cat))
							{
								'attributes.price#row_ind#' = get_act_rows.PRICE[row_ind]*get_product_id.price_kdv/get_act_rows.PRICE[row_ind];
								'attributes.price_other#row_ind#' = get_act_rows.PRICE_OTHER[row_ind]*get_product_id.price_kdv/get_act_rows.PRICE[row_ind];
								'attributes.row_total#row_ind#' = get_product_id.price_kdv*get_act_rows.QUANTITY[row_ind];
								'attributes.row_nettotal#row_ind#' = wrk_round((Evaluate('attributes.row_total#row_ind#')/100000000000000000000)*Evaluate('attributes.indirim_carpan#row_ind#'),4);
								'attributes.row_taxtotal#row_ind#' = Evaluate('attributes.row_nettotal#row_ind#')*get_act_rows.TAX[row_ind]/100;
								'attributes.row_lasttotal#row_ind#' = Evaluate('attributes.row_nettotal#row_ind#') + (Evaluate('attributes.row_nettotal#row_ind#')*get_act_rows.TAX[row_ind]/100);
								'attributes.other_money_#row_ind#' = get_act_rows.OTHER_MONEY[row_ind];
								'attributes.other_money_value_#row_ind#' = Evaluate('attributes.row_nettotal#row_ind#')/get_row_rate.new_rate;
								
								form.basket_gross_total=form.basket_gross_total+Evaluate('attributes.row_total#row_ind#');
								form.basket_net_total=form.basket_net_total+Evaluate('attributes.row_lasttotal#row_ind#');
								form.basket_tax_total=form.basket_tax_total+Evaluate('attributes.row_taxtotal#row_ind#');
								form.basket_discount_total=form.basket_discount_total+Evaluate('attributes.row_total#row_ind#')-Evaluate('attributes.row_nettotal#row_ind#'); 
							}
							else
							{
								'attributes.price#row_ind#' = iif((len(get_act_rows.PRICE[row_ind])),'get_act_rows.PRICE[row_ind]*newRateToCompany','0');
								'attributes.price_other#row_ind#' = get_act_rows.PRICE_OTHER[row_ind]*newRateToCompany;
								'attributes.row_total#row_ind#' = get_act_rows.NETTOTAL[row_ind]*newRateToCompany;
								'attributes.row_nettotal#row_ind#' = get_act_rows.NETTOTAL[row_ind]*newRateToCompany;
								'attributes.row_taxtotal#row_ind#' = get_act_rows.NETTOTAL[row_ind]*get_act_rows.TAX[row_ind]/100*newRateToCompany;
								'attributes.row_lasttotal#row_ind#' = get_act_rows.NETTOTAL[row_ind] + (get_act_rows.NETTOTAL[row_ind]*get_act_rows.TAX[row_ind]/100)*newRateToCompany;
								'attributes.other_money_#row_ind#' = get_act_rows.OTHER_MONEY[row_ind];
								'attributes.other_money_value_#row_ind#' = get_act_rows.OTHER_MONEY_VALUE[row_ind];
								'attributes.other_money_gross_total#row_ind#' = get_act_rows.OTHER_MONEY_VALUE[row_ind] + (get_act_rows.OTHER_MONEY_VALUE[row_ind]*get_act_rows.TAX[row_ind]/100);
							}
							'attributes.price_cat#row_ind#'=get_act_rows.PRICE_CAT[row_ind];
							'attributes.product_account_code#row_ind#'='';
							'attributes.promosyon_maliyet#row_ind#'=get_act_rows.PROM_COST[row_ind];
							'attributes.promosyon_yuzde#row_ind#'=get_act_rows.PROM_COMISSION[row_ind];
							'attributes.prom_relation_id#row_ind#'=get_act_rows.PROM_RELATION_ID[row_ind];
							'attributes.prom_stock_id#row_ind#'=get_act_rows.PROM_STOCK_ID[row_ind];
							'attributes.reserve_date#row_ind#'='';
							'attributes.reserve_type#row_ind#'='-1';
							'attributes.row_promotion_id#row_ind#'=get_act_rows.PROM_ID[row_ind];
							'attributes.row_service_id#row_ind#'='';
							'attributes.row_ship_id#row_ind#'=0;
							'attributes.row_unique_relation_id#row_ind#'=get_act_rows.UNIQUE_RELATION_ID[row_ind];
							'attributes.shelf_number#row_ind#'=get_act_rows.SHELF_NUMBER[row_ind];
							/*	PY 0715
								spect var id den main id yi buluyoruz yeni şirkette bu spect main id varsa onun herhangi bir spect_var_id sini atıyoruz
								eğer bulduğumuz spect main id şirketimizde yoksa o stoğa ait herhangi bir spect main id ye bağlı spect var id çekip atıyoruz
								hiç spect main id yoksa atmıyoruz
							*/
							// grup içi işlemde spec kaydı atmayla ilgili düzenleme yapıldı, main spec varsa spec üretiyoruz yoksa boş atıyoruz 1115 PY
								if (get_product_id.IS_PRODUCTION eq 1)
								{
									SQLStr = 'SELECT TOP 1 SPECT_MAIN_ID FROM #new_dsn3_group#.SPECT_MAIN  AS SM WHERE SM.STOCK_ID = #evaluate("attributes.stock_id#row_ind#")# AND SM.IS_TREE = 1 ORDER BY SM.RECORD_DATE DESC,SM.UPDATE_DATE DESC';
									'GET_TREE#row_ind#' = cfquery(SQLString : SQLStr, Datasource : new_dsn2);
									if(not isdefined('attributes.company_id')) attributes.company_id = 0;
									if(not isdefined('attributes.consumer_id')) attributes.consumer_id = 0;
									if(evaluate('GET_TREE#row_ind#.RECORDCOUNT'))
									{
										'spec_info#row_ind#' = specer(
												dsn_type:new_dsn2,
												spec_type:1,
												main_spec_id:evaluate('GET_TREE#row_ind#.SPECT_MAIN_ID'),
												add_to_main_spec:1,
												company_id: attributes.company_id,
												is_company_related_action: 1,
												company_related_dsn: new_dsn3_group,
												consumer_id: attributes.consumer_id
											);
										if(isdefined('attributes.is_spect_name_to_property') and attributes.is_spect_name_to_property eq 1){//Spec ismi confg.ürünlerden oluşturuluyor ise!
											configure_spec_name = evaluate("attributes.product_name#row_ind#");
											GetProductConf(listgetat(Evaluate('spec_info#row_ind#'),1,','));//fonksiyon burda çağırlıyor ilk olarak
										}	
										if(isdefined('attributes.is_spect_name_to_property') and attributes.is_spect_name_to_property eq 1 and isdefined('spec_info#row_ind#')){
											SQLStr1 = 'UPDATE #new_dsn3_group#.SPECT_MAIN SET SPECT_MAIN_NAME = "#left(configure_spec_name,499)#" WHERE SPECT_MAIN_ID = #listgetat(Evaluate('spec_info#row_ind#'),1,',')# ';
											UpdateSpecNameQuery = cfquery(SQLString : SQLStr1, Datasource : new_dsn2);
											if(len(listgetat(Evaluate('spec_info#row_ind#'),1,',')) and listgetat(Evaluate('spec_info#row_ind#'),1,',') gt 0){
												SQLStr2 = 'UPDATE #new_dsn3_group#.SPECT_MAIN SET SPECT_MAIN_NAME = "#left(configure_spec_name,499)#" WHERE SPECT_MAIN_ID = #listgetat(Evaluate('spec_info#row_ind#'),1,',')# ';
												UpdateS_V_SpecNameQuery = cfquery(SQLString : SQLStr2, Datasource : new_dsn2);
											}
										}
										if(isdefined('spec_info#row_ind#') and listlen(evaluate('spec_info#row_ind#'),',')){
											'attributes.spect_id#row_ind#'=listgetat(evaluate('spec_info#row_ind#'),2,',');
											if(len(listgetat(evaluate('spec_info#row_ind#'),3,',')))
												'attributes.spect_name#row_ind#'=listgetat(evaluate('spec_info#row_ind#'),3,',');
											else
												'attributes.spect_name#row_ind#'=evaluate("attributes.product_name#row_ind#");
										}
										else
										{
											'attributes.spect_id#row_ind#'= '';
											'attributes.spect_name#row_ind#'='';	
										}
									}
									else
									{
										'attributes.spect_id#row_ind#'= '';
										'attributes.spect_name#row_ind#'='';	
									}
								}
								else
								{
									'attributes.spect_id#row_ind#'='';
									'attributes.spect_name#row_ind#'='';
								}
							'attributes.stock_id#row_ind#'=get_act_rows.STOCK_ID[row_ind];
							'attributes.unit#row_ind#'=get_act_rows.UNIT[row_ind];
							'attributes.unit_id#row_ind#'=get_act_rows.UNIT_ID[row_ind];
							'attributes.unit_other#row_ind#'=get_act_rows.UNIT2[row_ind];
							'attributes.basket_employee_id#row_ind#'=get_act_rows.BASKET_EMPLOYEE_ID[row_ind];
							'attributes.basket_extra_info#row_ind#'=get_act_rows.BASKET_EXTRA_INFO_ID[row_ind];
                            'attributes.select_info_extra#row_ind#'=get_act_rows.SELECT_INFO_EXTRA[row_ind];
                            'attributes.detail_info_extra#row_ind#'=get_act_rows.DETAIL_INFO_EXTRA[row_ind];
							if(isdefined('session.pp.userid'))
								'attributes.wrk_row_id#row_ind#'="WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.pp.userid##round(rand()*100)#";
							else if(isdefined('session.ww.userid'))
								'attributes.wrk_row_id#row_ind#'="WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ww.userid##round(rand()*100)#";
							else
								'attributes.wrk_row_id#row_ind#'="WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)#";
							'attributes.wrk_row_relation_id#row_ind#'=get_act_rows.WRK_ROW_ID[row_ind];
							attributes.rows_ = row_ind;
						</cfscript>
					</cfloop>
					<cfscript>
						for(ind_inv_row=1;ind_inv_row lte attributes.rows_;ind_inv_row=ind_inv_row+1)
						{
							//fatura altı indirim varsa ona hesaplanarak satırlara yansıtılıyor
							row_price_=get_act_rows.PRICE[ind_inv_row]*get_act_rows.QUANTITY[ind_inv_row]*newRateToCompany;
							tmp_tax=0;
							for(ind_tax_count=1;ind_tax_count lte xml_tax_count;ind_tax_count=ind_tax_count+1)
							{
								if(isdefined('form.basket_tax_#ind_tax_count#') and evaluate('form.basket_tax_#ind_tax_count#') eq evaluate('attributes.tax#ind_inv_row#'))
								{
									'form.basket_tax_value_#ind_tax_count#' =evaluate('form.basket_tax_value_#ind_tax_count#') + wrk_round((row_price_/100)*get_act_rows.TAX[ind_inv_row],2);
									tmp_tax=1;
									break;
								}
							}
							if(tmp_tax eq 0)
							{
								'form.basket_tax_#xml_tax_count#' = evaluate('attributes.tax#ind_inv_row#');
								'form.basket_tax_value_#xml_tax_count#' =  wrk_round((row_price_/100)*get_act_rows.TAX[ind_inv_row],2);
								xml_tax_count=xml_tax_count+1;
							}
							tmp_otv=0;
							for(ind_otv_count=1;ind_otv_count lte xml_otv_count;ind_otv_count=ind_otv_count+1)
							{
								if(isdefined('form.basket_otv_#ind_otv_count#') and evaluate('form.basket_otv_#ind_otv_count#') eq evaluate('attributes.otv_oran#ind_inv_row#'))
								{
									'form.basket_otv_value_#ind_otv_count#'= evaluate('form.basket_otv_value_#ind_otv_count#') + wrk_round((row_price_/100)*get_act_rows.OTV_ORAN[ind_inv_row],2);
									tmp_otv=1;
									break;
								}
							}
							if(tmp_otv eq 0)	
							{
								'form.basket_otv_#xml_otv_count#'= evaluate('attributes.otv_oran#ind_inv_row#');
								'form.basket_otv_value_#xml_otv_count#'= wrk_round((row_price_/100)*get_act_rows.OTV_ORAN[ind_inv_row],2);
								xml_otv_count=xml_otv_count+1;
							}
						}
					</cfscript>
					<cfscript>
						form.basket_otv_count = xml_otv_count-1;//otv oran sayısı
						form.basket_tax_count = xml_tax_count-1;//kdv sayısı
						xml_import=1;
					</cfscript>
					<cfif get_related_act.to_act_type eq 1>
						<cfinclude template="../../sales/query/add_order.cfm">
					<cfelse>
						<!---<cfset xml_import_pur=1>--->
						<cfinclude template="../../purchase/query/add_order.cfm">
					</cfif>
				</cfif>
			</cfif>
		</cfif>
        <cfcatch type="any">
			<cfoutput>
                <cfdump var="#cfcatch#">
				<script type="text/javascript">
                    alert("Belgeniz Kaydedildi Fakat Grup İçi İlişkili İşlem Kaydı Yapılamadı ! Ürün ve Fiyat Tanımlarınızı Kontrol Ediniz !");
                </script>
				<cfabort>
			</cfoutput>
		</cfcatch>
	</cftry>
	<cfreturn 1>
</cffunction>


<cffunction name="getUserPeriodDate" returntype="any" output="false">
	<cfargument name="comp_id" required="yes" type="numeric">
    
    <cfquery name="get_user_period_date" datasource="#dsn#">
    	SELECT TOP 1
            SP.PERIOD_DATE AS PERIOD_DATE
        FROM 
            SETUP_PERIOD SP
        WHERE 
            SP.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year#"> AND
            SP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.comp_id#">
    </cfquery>
    
    <cfreturn get_user_period_date.PERIOD_DATE>
</cffunction>

</cfprocessingdirective>
<cfsetting enablecfoutputonly="no">
