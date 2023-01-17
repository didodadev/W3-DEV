<cf_xml_page_edit fuseact="report.product_account_code">
<cfparam name="attributes.module_id_control" default="22">
<cfinclude template="report_authority_control.cfm">
<cfprocessingdirective pageencoding="utf-8"> 
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.product" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.product_cat_code" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.has_account_code" default="">
<cfparam name="attributes.is_active" default="">
<cfparam name="attributes.select_option" default="">
<cfparam name="attributes.is_excel" default="">
<cfset liste="account_code,account_code_pur,account_iade,account_pur_iade,account_exportregistered,outgoing_stock,incoming_stock,inventory_cat,inventory_code,amortization_exp_center_id,amortization_exp_item_id,amortization_method_id,amortization_type_id,amortization_code,otv,tax_code_name,exe_vat_sale_invoice,reason_code,discount_expense_center_id,discount_expense_item_id,discount_activity_type_id,purchase_paymethod_id,sales_paymethod_id,
accrual_income_item_id,accrual_expense_item_id,next_month_incomes_acc_code,next_year_incomes_acc_code,next_month_expenses_acc_code,next_year_expenses_acc_code,account_discount,account_discount_pur,account_pur_iade,account_price,account_price_pur,production_cost,half_production_cost,konsinye_sale_naz_code,dimm_yans_code,dimm_code,promotion_code,prod_general_code,prod_labor_cost_code,account_yurtdisi,account_yurtdisi_pur,material_code,konsinye_sale_code,konsinye_pur_code,account_loss,account_expenditure,sale_product_cost,over_count,under_count,received_progress_code,provided_progress_code,sale_manufactured_cost,scrap_code,material_code_sale,production_cost_sale,scrap_code_sale">
<cfset select_list = "product_status,is_inventory,is_production,is_sales,is_purchase,is_prototype,is_internet,is_extranet,is_terazi,is_karma,is_zero_stock,is_limited_stock,is_serial_no,is_cost,is_quality,is_commission,is_gift_card">

<cfset columnList = "#getLang('main',75)#,#getLang('main',1604)#,#getLang('report',970)#,#getLang('main',809)#,#getLang('main',1388)#,#getLang('main',221)#,#getLang('report',599)# #getLang('main',227)#,#getLang('report',602)# #getLang('main',227)#,#getLang('main',36)#,#getLang('main',764)#,#getLang('report',607)#,#getLang('report',608)#,#getLang('report',605)#,#getLang('report',606)#,#getLang('main',36)# #getLang('report',610)#,#getLang('main',764)# #getLang('report',610)#,#getLang('report',611)#,#getLang('report',612)#,Hammadde Satış,#getLang('report',614)#,#getLang('main',2212)#,#getLang('main',341)#,#getLang('main',342)#,Mamül Satış,#getLang('main',44)# #getLang('main',850)#,#getLang('main',849)#,Satılan Mamülün Maliyeti,#getLang('report',1845)#,#getLang('report',1846)#,#getLang('report',971)#,Hurda Satış,Hurda,D.I.M. Malz.,D.I.M. Malz. Yans.,#getLang('report',956)#,#getLang('report',969)#,#getLang('report',969)#,#getLang('report',613)#,#getLang('main',846)#,Alınan Hakediş,Verilen Hakediş,#getLang('main',1048)#,#getLang('main',1139)#,#getLang('report',452)#,#getLang('main',1410)#,#getLang('main',760)#,#getLang('main',761)#,#getLang('report',452)#,#getLang('main',1411)#">

<cfset columnlistfromxml = "#getLang('main',344)#,#getLang('report',1477)#,#getLang('main',44)#,#getLang('main',36)#,#getLang('main',1948)#,#getLang('report',1491)#,#getLang('report',1492)#,#getLang('main',607)#,#getLang('report',1518)#,#getLang('report',1522)#,#getLang('report',1438)#,#getLang('report',1448)#,#getLang('main',225)#,#getLang('main',846)#,#getLang('report',1288)#,#getLang('report',1520)#,#getLang('report',1528)#">
<cfif isdefined("attributes.get_date") and len(attributes.get_date)>
	<cf_date tarih='attributes.get_date'> 
	<cfparam name="attributes.get_date" default="#attributes.get_date#">
<cfelse>
	<cfparam name="attributes.get_date" default="">
</cfif>
<cfif isdefined("attributes.form_submitted")>	
        <cfset get_product.recordcount = 0> 
        <cfquery name="GET_PRODUCT" datasource="#DSN3#">
            SELECT   
                PRODUCT_STATUS,
                IS_INVENTORY,
                P.IS_PRODUCTION,
                P.IS_SALES,
                IS_PURCHASE,
                IS_PROTOTYPE,
                IS_INTERNET,
                IS_EXTRANET,
                IS_TERAZI,
                IS_KARMA,
                IS_ZERO_STOCK,
                IS_LIMITED_STOCK,
                IS_SERIAL_NO,
                IS_COST,
                IS_QUALITY,
                IS_COMMISSION,
                IS_GIFT_CARD,
                P.PRODUCT_ID,
                P.PRODUCT_NAME,
                P.PRODUCT_CODE,
                P.TAX,
                P.TAX_PURCHASE,
                P.OTV,
                P.BARCOD,
                PC.PRODUCT_CAT,
                PC.HIERARCHY,
                PP.ACCOUNT_CODE,
                PP.ACCOUNT_CODE_PUR,              
                PP.ACCOUNT_IADE,
                PP.ACCOUNT_PUR_IADE,
                PP.ACCOUNT_DISCOUNT,
                PP.ACCOUNT_DISCOUNT_PUR,
                PP.ACCOUNT_PRICE,
                PP.ACCOUNT_PRICE_PUR,
                PP.PRODUCTION_COST,
                PP.HALF_PRODUCTION_COST,
                PP.KONSINYE_SALE_NAZ_CODE,
                PP.DIMM_CODE,
                PP.DIMM_YANS_CODE,
                PP.PROMOTION_CODE,
                PP.PROD_GENERAL_CODE,
                PP.PROD_LABOR_COST_CODE,
                PP.ACCOUNT_YURTDISI,
                PP.ACCOUNT_YURTDISI_PUR,
                PP.MATERIAL_CODE,
                PP.KONSINYE_SALE_CODE,
                PP.KONSINYE_PUR_CODE,
                PP.ACCOUNT_LOSS,
                PP.ACCOUNT_EXPENDITURE,
                PP.SALE_PRODUCT_COST,
                PP.OVER_COUNT,
                PP.UNDER_COUNT,
                PP.RECEIVED_PROGRESS_CODE,
                PP.PROVIDED_PROGRESS_CODE,
                PP.SALE_MANUFACTURED_COST,
                PP.SCRAP_CODE,
                PP.MATERIAL_CODE_SALE,
                PP.PRODUCTION_COST_SALE,
                PP.SCRAP_CODE_SALE,
                EC.EXPENSE GELIR_MERKEZI,
                EI.EXPENSE_ITEM_NAME GELIR_KALEMI,
                SA.ACTIVITY_NAME GELIR_AKTIVITE_TIPI,
                EPT.TEMPLATE_NAME GELIR_SABLONU,
                EC2.EXPENSE GIDER_MERKEZI,
                EI2.EXPENSE_ITEM_NAME GIDER_KALEMI,
                SA2.ACTIVITY_NAME GIDER_AKTIVITE_TIPI,
                EPT2.TEMPLATE_NAME GIDER_SABLONU,
                PP.ACCOUNT_EXPORTREGISTERED,
                PP.OUTGOING_STOCK,
                PP.INCOMING_STOCK,
                SC.INVENTORY_CAT,
                PP.INVENTORY_CODE,
                PP.AMORTIZATION_METHOD_ID,
                PP.AMORTIZATION_TYPE_ID,
                PP.AMORTIZATION_EXP_CENTER_ID,
                PP.AMORTIZATION_EXP_ITEM_ID,
                EC3.EXPENSE AMORTIZATION_EXP_CENTER,
                EI3.EXPENSE_ITEM_NAME AMORTIZATION_EXP_ITEM,
                PP.AMORTIZATION_CODE,
                PP.EXE_VAT_SALE_INVOICE,
                PP.TAX_CODE,
                PP.TAX_CODE_NAME,
                PP.REASON_CODE,
                EC4.EXPENSE ISKONTO_GIDER_MERKEZI,
                EI4.EXPENSE_ITEM_NAME ISKONTO_GIDER_KALEMI,
                SA3.ACTIVITY_NAME ISKONTO_AKTIVITE_TIPI,
                SP.PAYMETHOD ALIS_ODEME_YONTEMI,
                SP1.PAYMETHOD SATIS_ODEME_YONTEMI,
                EI5.EXPENSE_ITEM_NAME ACCRUAL_INCOME_ITEM,
                EI6.EXPENSE_ITEM_NAME ACCRUAL_EXPENSE_ITEM,
                PP.NEXT_MONTH_INCOMES_ACC_CODE,
                PP.NEXT_YEAR_INCOMES_ACC_CODE,
                PP.NEXT_MONTH_EXPENSES_ACC_CODE,
                PP.NEXT_YEAR_EXPENSES_ACC_CODE,
                PP.ACCRUAL_MONTH,
                PP.ACCRUAL_MONTH_IFRS,
                PP.ACCRUAL_MONTH_BUDGET,
                PP.FIRST_12_TO_MONTH_IFRS,
                PP.FIRST_12_TO_MONTH,
                PP.START_FROM_DELIVERY_DATE,
                PP.START_FROM_DELIVERY_DATE_IFRS,
                PP.DISTRIBUTE_DAY_BASED,
                PP.DISTRIBUTE_DAY_BASED_IFRS,
                PP.DISTRIBUTE_TO_FISCAL_END,
                PP.DISTRIBUTE_TO_FISCAL_END_IFRS,
                PP.PAST_MONTHS_TO_FIRST,
                PP.PAST_MONTHS_TO_FIRST_IFRS
            FROM 
                PRODUCT P
                JOIN PRODUCT_CAT PC ON  P.PRODUCT_CATID = PC.PRODUCT_CATID
                LEFT JOIN PRODUCT_PERIOD PP ON PP.PRODUCT_ID = P.PRODUCT_ID AND PP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
                LEFT JOIN #dsn2_alias#.EXPENSE_CENTER EC ON  EXPENSE_ID = PP.EXPENSE_CENTER_ID
                LEFT JOIN #dsn2_alias#.EXPENSE_ITEMS EI ON INCOME_EXPENSE = 1 AND EI.EXPENSE_ITEM_ID = PP.INCOME_ITEM_ID
                LEFT JOIN #dsn_alias#.SETUP_ACTIVITY SA ON SA.ACTIVITY_ID = PP.INCOME_ACTIVITY_TYPE_ID
                LEFT JOIN #dsn2_alias#.EXPENSE_PLANS_TEMPLATES EPT ON EPT.TEMPLATE_ID = PP.INCOME_TEMPLATE_ID
                LEFT JOIN #dsn2_alias#.EXPENSE_CENTER EC2 ON EC2.EXPENSE_ID = PP.COST_EXPENSE_CENTER_ID
                LEFT JOIN #dsn2_alias#.EXPENSE_ITEMS EI2 ON EI2.IS_EXPENSE = 1 AND EI2.EXPENSE_ITEM_ID = PP.EXPENSE_ITEM_ID
                LEFT JOIN #dsn_alias#.SETUP_ACTIVITY SA2 ON SA2.ACTIVITY_ID = PP.ACTIVITY_TYPE_ID
                LEFT JOIN #dsn2_alias#.EXPENSE_PLANS_TEMPLATES EPT2 ON EPT2.TEMPLATE_ID = PP.EXPENSE_TEMPLATE_ID
                LEFT JOIN  SETUP_INVENTORY_CAT SC ON  SC.INVENTORY_CAT_ID = PP.INVENTORY_CAT_ID
                LEFT JOIN #dsn2_alias#.EXPENSE_CENTER EC3 ON EC3.EXPENSE_ID = PP.AMORTIZATION_EXP_CENTER_ID
                LEFT JOIN #dsn2_alias#.EXPENSE_ITEMS EI3 ON EI3.EXPENSE_ITEM_ID = PP.AMORTIZATION_EXP_ITEM_ID
                LEFT JOIN #dsn2_alias#.EXPENSE_CENTER EC4 ON EC4.EXPENSE_ID = PP.DISCOUNT_EXPENSE_CENTER_ID
                LEFT JOIN #dsn2_alias#.EXPENSE_ITEMS EI4 ON EI4.IS_EXPENSE = 1 AND EI4.EXPENSE_ITEM_ID = PP.DISCOUNT_EXPENSE_ITEM_ID
                LEFT JOIN #dsn_alias#.SETUP_ACTIVITY SA3 ON SA3.ACTIVITY_ID = PP.DISCOUNT_ACTIVITY_TYPE_ID 
                LEFT JOIN #dsn_alias#.SETUP_PAYMETHOD SP ON SP.PAYMETHOD_ID = PP.PURCHASE_PAYMETHOD_ID 
                LEFT JOIN #dsn_alias#.SETUP_PAYMETHOD SP1 ON SP1.PAYMETHOD_ID = PP.SALES_PAYMETHOD_ID 
                LEFT JOIN #dsn2_alias#.EXPENSE_ITEMS EI5 ON EI5.IS_EXPENSE = 0 AND EI5.EXPENSE_ITEM_ID = PP.ACCRUAL_INCOME_ITEM_ID
                LEFT JOIN #dsn2_alias#.EXPENSE_ITEMS EI6 ON EI6.IS_EXPENSE = 1 AND EI6.EXPENSE_ITEM_ID = PP.ACCRUAL_EXPENSE_ITEM_ID
            WHERE
                P.PRODUCT_ID IS NOT NULL
                <cfif len(attributes.product) and len(attributes.product_id)>AND P.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"></cfif>
                <cfif len(attributes.employee) and len(attributes.employee_id)>AND P.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"></cfif>
                <cfif len(attributes.is_active) and (attributes.is_active eq 2)>AND P.PRODUCT_STATUS = 1
                <cfelseif len(attributes.is_active) and (attributes.is_active eq 3)>AND P.PRODUCT_STATUS = 0</cfif>
                <cfif len(attributes.get_date)>AND P.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.get_date#"></cfif>
                <cfif len(attributes.has_account_code)>
                <cfif attributes.has_account_code eq 1>
                    AND P.PRODUCT_ID IN 
                        (SELECT 
                            PRODUCT_ID 
                        FROM 
                            PRODUCT_PERIOD 
                        WHERE 
                            <cfif isdefined("attributes.list_account")>
                                <cfloop list="#liste#" index="liste_">
                                    <cfif (attributes.list_account eq liste_) or (attributes.list_account eq '')>
                                        #uCase(liste_)# IS NOT NULL AND
                                    </cfif>
                                </cfloop>
                            </cfif>
                            PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">)
                <cfelseif attributes.has_account_code eq 0>
                    AND P.PRODUCT_ID NOT IN
                        (SELECT PRODUCT_ID FROM PRODUCT_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">)
                </cfif>
            </cfif>
            <cfif len(attributes.product_cat_code)>AND (PC.HIERARCHY = '#attributes.product_cat_code#' OR PC.HIERARCHY LIKE '#attributes.product_cat_code#%')</cfif>
            ORDER BY 
                P.PRODUCT_ID
         </cfquery>
<cfelse>
	<cfset get_product.recordcount = 0>    
</cfif>
<cfparam name="attributes.totalrecords" default="#get_product.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>          
<cfform name="search_product" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
<cfsavecontent variable="title"><cf_get_lang dictionary_id='39167.Ürün Muhasebe Kodları'></cfsavecontent>
<cf_report_list_search title="#title#">
	<cf_report_list_search_area>
        <div class="row">
            <div class="col col-12 col-xs-12">
                <div class="row formContent">
					<div class="row" type="row">
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                            <div class="col col-12 col-xs-12">
                                <div class="form-group">
                                        <label class="col col-12 col-xs-12 "><cf_get_lang dictionary_id='57657.Ürün'></label>
                                    <div class="col col-12 col-xs-12 ">
                                        <div class="input-group">
                                            <input type="hidden" name="product_id" id="product_id" value="<cfif isdefined("attributes.product_id")><cfoutput>#attributes.product_id#</cfoutput></cfif>">
                                            <input type="hidden" name="stock_id" id="stock_id" value="<cfif isdefined("attributes.stock_id")><cfoutput>#attributes.stock_id#</cfoutput></cfif>">
                                            <input type="text" name="product" id="product" style="width:120px;" value="<cfif isdefined("attributes.product")><cfoutput>#attributes.product#</cfoutput></cfif>" onfocus="AutoComplete_Create('product','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','STOCK_ID,PRODUCT_ID','stock_id,product_id','','3','200');">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_product_names&field_id=search_product.stock_id&product_id=search_product.product_id&field_name=search_product.product</cfoutput>','list');"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57544.Sorumlu'></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                                <cfinput type="text" name="employee" value="#attributes.employee#" onFocus="AutoComplete_Create('employee','FULLNAME','FULLNAME','get_emp_pos','','POSITION_CODE','employee_id','','3','130');" style="width:120px;" maxlength="255">
                                                <input type="hidden" name="employee_id" id="employee_id"  value="<cfoutput>#attributes.employee_id#</cfoutput>">
                                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_id=search_product.employee_id&field_name=search_product.employee&select_list=1','list');"></span>
                                        </div>
                                    </div>
                                    
                                </div>
                            </div> 
                        </div>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                            <div class="col col-12 col-xs-12">
                                <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="product_cat_code" id="product_cat_code" value="<cfif len(attributes.product_cat)><cfoutput>#attributes.product_cat_code#</cfoutput></cfif>">
                                            <input type="text" name="product_cat" id="product_cat" style="width:120px;" onfocus="AutoComplete_Create('product_cat','PRODUCT_CATID,PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','HIERARCHY','product_cat_code','','3','200','','1');" value="<cfif len(attributes.product_cat)><cfoutput>#attributes.product_cat#</cfoutput></cfif>">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_code=search_product.product_cat_code&field_name=search_product.product_cat</cfoutput>');"></span>
                                        </div>
                                    </div> 
                                </div>
                                <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'>*</label>
                                    <div class="col col-6">
                                        <div class="input-group">
                                             <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri">:<cf_get_lang dictionary_id='57782.Tarih Degerini Kontrol Ediniz'></cfsavecontent>
                                            <cfinput type="text" name="get_date" value="#dateformat(attributes.get_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#" required="yes">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="get_date"></span>
                                        </div>
                                    </div>
                                    <div class="col col-6">
                                            <select name="is_active" id="is_active">
                                                <option value="1" <cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                                                <option value="2" <cfif attributes.is_active eq 2>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                                                <option value="3" <cfif attributes.is_active eq 3>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                                            </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                            <div class="col col-12 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></label> 
                                        <div class="col col-12 col-xs-12">
                                            <select name="has_account_code" id="has_account_code" onchange="show_select()">
                                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                <option value="1" <cfif attributes.has_account_code is "1">selected</cfif>><cf_get_lang dictionary_id='39317.Tanimli'></option>
                                                <option value="0" <cfif attributes.has_account_code is "0">selected</cfif>><cf_get_lang dictionary_id='58845.Tanimsiz'></option>
                                            </select>
                                        </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"></label>		
                                    <div class="col col-12 col-xs-12" id="tdlist_account" <cfif attributes.has_account_code eq '' or  attributes.has_account_code eq 0> style="display:none" </cfif>>
                                        <select name="list_account" id="list_account">
                                            <option value=""><cf_get_lang dictionary_id="39664.Muhasebe Kodu Hesabı Seçiniz"></option>
                                            <option value="account_code"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'account_code'>selected</cfif></cfif>><cf_get_lang dictionary_id='57448.Satis'></option>
                                            <option value="account_code_pur" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'account_code_pur'>selected</cfif></cfif>><cf_get_lang dictionary_id='58176.Alis'></option>
                                            <option value="account_iade" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'account_iade'>selected</cfif></cfif>><cf_get_lang dictionary_id='39326.Satis Iade'></option>
                                            <option value="account_pur_iade" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'account_pur_iade'>selected</cfif></cfif>><cf_get_lang dictionary_id='39327.Alis Iade'></option>
                                            <option value="account_discount"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'account_discount'>selected</cfif></cfif>><cf_get_lang dictionary_id='39328.Satis Iskonto'></option>
                                            <option value="account_discount_pur"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'account_discount_pur'>selected</cfif></cfif>><cf_get_lang dictionary_id='39329.Alis Iskonto'></option>
                                            <option value="account_price"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'account_price'>selected</cfif></cfif>><cf_get_lang dictionary_id="57448.Satış"> <cf_get_lang dictionary_id="39331.Fiyat Farkı"></option>
                                            <option value="account_price_pur"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'account_price_pur'>selected</cfif></cfif>><cf_get_lang dictionary_id="58176.Alış"> <cf_get_lang dictionary_id="39331.Fiyat Farkı"></option>
                                            <option value="production_cost"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'production_cost'>selected</cfif></cfif>><cf_get_lang dictionary_id="57456.Üretim">/ <cf_get_lang dictionary_id="58262.Mamüller"></option>
                                            <option value="half_production_cost"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'half_production_cost'>selected</cfif></cfif>><cf_get_lang dictionary_id="58261.Yarı Mamüller / Üretim"></option>
                                            <option value="konsinye_sale_naz_code"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'konsinye_sale_naz_code'>selected</cfif></cfif>><cf_get_lang dictionary_id="39676.Diğer Satış Nazım"></option>
                                            <option value="dimm_yans_code"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'dimm_yans_code'>selected</cfif></cfif>>D.I.M. Malz. Yans.</option>
                                            <option value="dimm_code"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'dimm_code'>selected</cfif></cfif>>D.I.M. Malz.</option>
                                            <option value="promotion_code"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'promotion_code'>selected</cfif></cfif>><cf_get_lang dictionary_id="39677.Promosyon"></option>
                                            <option value="prod_general_code"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'prod_general_code'>selected</cfif></cfif>>G.U. <cf_get_lang dictionary_id="39683.Giderleri Yansıtma"></option>
                                            <option value="prod_labor_cost_code"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'prod_labor_cost_code'>selected</cfif></cfif>><cf_get_lang dictionary_id="39690.Üretim İşcilik Yansıtma"></option>
                                            <option value="account_yurtdisi"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'account_yurtdisi'>selected</cfif></cfif>><cf_get_lang dictionary_id='39332.Yurtdisi Satis'></option>
                                            <option value="account_yurtdisi_pur"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'account_yurtdisi_pur'>selected</cfif></cfif>><cf_get_lang dictionary_id='39333.Yurtdisi Alis'></option>
                                            <option value="material_code"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'material_code'>selected</cfif></cfif>><cf_get_lang dictionary_id='39334.Hammadde'></option>
                                            <option value="konsinye_sale_code"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'konsinye_sale_code'>selected</cfif></cfif>><cf_get_lang dictionary_id='40567.Diger Satis Hesabi'></option>
                                            <option value="konsinye_pur_code" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'konsinye_pur_code'>selected</cfif></cfif>><cf_get_lang dictionary_id='40566.Diger Alis Hesabi'></option>
                                            <option value="account_loss"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'account_loss'>selected</cfif></cfif>><cf_get_lang dictionary_id='39335.Fireler'></option>
                                            <option value="account_expenditure"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'account_loss'>selected</cfif></cfif>><cf_get_lang dictionary_id='30009.Sarflar'></option>
                                            <option value="sale_product_cost"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'sale_product_cost'>selected</cfif></cfif>><cf_get_lang dictionary_id='58258.Maliyet'></option>
                                            <option value="over_count" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'over_count'>selected</cfif></cfif>><cf_get_lang dictionary_id='57753.Sayim Fazlasi'></option>
                                            <option value="under_count" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'under_count'>selected</cfif></cfif>><cf_get_lang dictionary_id='57754.Sayim Eksigi'></option>
                                            <option value="received_progress_code" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'received_progress_code'>selected</cfif></cfif>><cf_get_lang dictionary_id='59117.Alınan Hakediş'></option>
                                            <option value="provided_progress_code" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'provided_progress_code'>selected</cfif></cfif>><cf_get_lang dictionary_id='59118.Verilen Hakediş'></option>
                                            <option value="sale_manufactured_cost" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'sale_manufactured_cost'>selected</cfif></cfif>><cf_get_lang dictionary_id='59119.Satılan Mamülün Maliyeti'></option>
                                            <option value="scrap_code" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'scrap_code'>selected</cfif></cfif>><cf_get_lang dictionary_id='59120.Hurda'></option>
                                            <option value="material_code_sale" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'material_code_sale'>selected</cfif></cfif>><cf_get_lang dictionary_id='59121.Hammadde Satış'></option>
                                            <option value="production_cost_sale" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'production_cost_sale'>selected</cfif></cfif>><cf_get_lang dictionary_id='59122.Mamül Satış'></option>
                                            <option value="scrap_code_sale" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'scrap_code_sale'>selected</cfif></cfif>><cf_get_lang dictionary_id='59123.Hurda Satış'></option>
                                            <option value="account_exportregistered" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'account_exportregistered'>selected</cfif></cfif>><cf_get_lang dictionary_id='60998.İhraç Kayıtlı Satış'></option>
                                            <option value="outgoing_stock" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'outgoing_stock'>selected</cfif></cfif>><cf_get_lang dictionary_id='60300.Stok Satış'></option>
                                            <option value="incoming_stock" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'incoming_stock'>selected</cfif></cfif>><cf_get_lang dictionary_id='60299.Stok Alış'></option>
                                            <option value="inventory_cat" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'inventory_cat'>selected</cfif></cfif>><cf_get_lang dictionary_id='58478.Sabit Kıymet'><cf_get_lang dictionary_id='57486.Kategori'></option>
                                            <option value="inventory_code" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'inventory_code'>selected</cfif></cfif>><cf_get_lang dictionary_id='58478.Sabit Kıymet'><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></option>
                                            <option value="amortization_exp_center_id" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'amortization_exp_center_id'>selected</cfif></cfif>><cf_get_lang dictionary_id='58478.Sabit Kıymet'><cf_get_lang dictionary_id='58460.Masraf Merkezi'></option> 
                                            <option value="amortization_exp_item_id" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'amortization_exp_item_id'>selected</cfif></cfif>><cf_get_lang dictionary_id='58478.Sabit Kıymet'><cf_get_lang dictionary_id='58551.Gider Kalemi'></option>                                                <option value="amortization_method_id" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'amortization_method_id'>selected</cfif></cfif>><cf_get_lang dictionary_id='29420.Amortisman Yöntemi'></option>
                                            <option value="amortization_type_id" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'amortization_type_id'>selected</cfif></cfif>><cf_get_lang dictionary_id='29425.Amortisman Türü'></option>
                                            <option value="amortization_code" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'amortization_code'>selected</cfif></cfif>><cf_get_lang dictionary_id='58298.Birikmiş Amortisman'></option>
                                            <option value="otv" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'otv'>selected</cfif></cfif>><cf_get_lang dictionary_id='58021.ÖTV'></option>
                                            <option value="tax_code_name" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'tax_code_name'>selected</cfif></cfif>><cf_get_lang dictionary_id='30006.Vergi Kodu'></option>  
                                            <option value="exe_vat_sale_invoice" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'exe_vat_sale_invoice'>selected</cfif></cfif>><cf_get_lang dictionary_id="36834.KDV'den Muaf Satış Faturası"></option> 
                                            <option value="reason_code" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'reason_code'>selected</cfif></cfif>><cf_get_lang dictionary_id='43458.İstisna Kodu'></option> 
                                            <option value="discount_expense_center_id" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'discount_expense_center_id'>selected</cfif></cfif>><cf_get_lang dictionary_id='57641.İskonto'><cf_get_lang dictionary_id ='38991.Gider Merkezi'></option> 
                                            <option value="discount_expense_item_id" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'discount_expense_item_id'>selected</cfif></cfif>><cf_get_lang dictionary_id='57641.İskonto'><cf_get_lang dictionary_id ='58551.Gider Kalemi'></option>                                                     <option value="discount_activity_type_id" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'discount_activity_type_id'>selected</cfif></cfif>><cf_get_lang dictionary_id='57641.İskonto'><cf_get_lang dictionary_id='37218.Aktivite Tipi'></option> 
                                            <option value="purchase_paymethod_id" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'purchase_paymethod_id'>selected</cfif></cfif>><cf_get_lang dictionary_id='54531.Alış Ödeme Yöntemi'></option> 
                                            <option value="sales_paymethod_id" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'sales_paymethod_id'>selected</cfif></cfif>><cf_get_lang dictionary_id='54532.Satış Ödeme Yöntemi'></option>
                                            <option value="accrual_income_item_id" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'accrual_income_item_id'>selected</cfif></cfif>><cf_get_lang dictionary_id='60404.Tahakkuk Gelir Kalemi'></option>   
                                            <option value="accrual_expense_item_id" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'accrual_expense_item_id'>selected</cfif></cfif>><cf_get_lang dictionary_id='41055.Tahakkuk Gider Kalemi'></option>                                                        
                                            <option value="next_month_incomes_acc_code" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'next_month_incomes_acc_code'>selected</cfif></cfif>><cf_get_lang dictionary_id="41024.Gelecek Aylara Ait Gelirler Muhasebe Kodu"></option>  
                                            <option value="next_year_incomes_acc_code" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'next_year_incomes_acc_code'>selected</cfif></cfif>><cf_get_lang dictionary_id="41021.Gelecek Yıllara Ait Gelirler Muhasebe Kodu"></option>  
                                            <option value="next_month_expenses_acc_code" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'next_month_expenses_acc_code'>selected</cfif></cfif>><cf_get_lang dictionary_id="41020.Gelecek Aylara Ait Giderler Muhasebe Kodu"></option>  
                                            <option value="next_year_expenses_acc_code" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'next_year_expenses_acc_code'>selected</cfif></cfif>><cf_get_lang dictionary_id="41022.Gelecek Yıllara Ait Giderler Muhasebe Kodu"></option>                                       
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="col col-12 col-xs-12">
                                    <cfif x_select_option eq 1>
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58715.Listele'></label>
                                        <select name="select_option" id="select_option" multiple="multiple" style="width:170px;height:60px">
                                            <option value="1" <cfif listfind(attributes.select_option,1)>selected</cfif>><cf_get_lang dictionary_id ='57756.Durum'></option>
                                            <option value="2" <cfif listfind(attributes.select_option,2)>selected</cfif>><cf_get_lang dictionary_id ='40198.Envanter'></option>
                                            <option value="3" <cfif listfind(attributes.select_option,3)>selected</cfif>><cf_get_lang dictionary_id ='57456.Üretim'></option>
                                            <option value="4" <cfif listfind(attributes.select_option,4)>selected</cfif>><cf_get_lang dictionary_id ='57448.Satış'></option>
                                            <option value="5" <cfif listfind(attributes.select_option,5)>selected</cfif>><cf_get_lang dictionary_id ='29745.Tedarik'></option>
                                            <option value="6" <cfif listfind(attributes.select_option,6)>selected</cfif>><cf_get_lang dictionary_id ='40212.Prototip'></option>
                                            <option value="7" <cfif listfind(attributes.select_option,7)>selected</cfif>><cf_get_lang dictionary_id ='40213.Internet'></option>
                                            <option value="8" <cfif listfind(attributes.select_option,8)>selected</cfif>><cf_get_lang dictionary_id ='58019.Extranet'></option>
                                            <option value="9" <cfif listfind(attributes.select_option,9)>selected</cfif>><cf_get_lang dictionary_id ='40239.Terazi'></option>
                                            <option value="10" <cfif listfind(attributes.select_option,10)>selected</cfif>><cf_get_lang dictionary_id ='40243.Karma Koli'></option>
                                            <option value="11" <cfif listfind(attributes.select_option,11)>selected</cfif>><cf_get_lang dictionary_id ='40159.Sıfır Stok'></option>
                                            <option value="12" <cfif listfind(attributes.select_option,12)>selected</cfif>><cf_get_lang dictionary_id ='40169.Stoklarla Sınırlı'></option>
                                            <option value="13" <cfif listfind(attributes.select_option,13)>selected</cfif>><cf_get_lang dictionary_id ='57637.Seri No'></option>
                                            <option value="14" <cfif listfind(attributes.select_option,14)>selected</cfif>><cf_get_lang dictionary_id ='58258.Maliyet'></option>
                                            <option value="15" <cfif listfind(attributes.select_option,15)>selected</cfif>><cf_get_lang dictionary_id ='40009.Kalite'></option>
                                            <option value="16" <cfif listfind(attributes.select_option,16)>selected</cfif>><cf_get_lang dictionary_id ='40241.Pos Komisyonu'></option>
                                            <option value="17" <cfif listfind(attributes.select_option,17)>selected</cfif>><cf_get_lang dictionary_id ='40249.Hediye Çeki'></option>
                                        </select>
                                    </cfif>
                                    </div>
                                </div>
                            </div>                          
                        </div> 
                    </div>
                </div>
                <div class="row ReportContentBorder">
                    <div class="ReportContentFooter">
                        <label><input type="checkbox" value="1" name="is_excel" id="is_excel"<cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id ='57858.Excel Getir'></label>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
                            <cfinput type="text" name="maxrows" style="width:25px;" value="#attributes.maxrows#" validate="integer" onKeyUp="isNumber(this)" required="yes" message="#message#">
                        <cfelse>    
                            <cfinput type="text" name="maxrows" style="width:25px;" value="#attributes.maxrows#" validate="integer" range="1,999" onKeyUp="isNumber(this)" required="yes" message="#message#">
                        </cfif>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='57911.Çalıştır'></cfsavecontent>
                        <input type="hidden" name="form_submitted" id="form_submitted" value="1">                     
                        <cf_wrk_report_search_button is_excel="1" button_type="1" search_function='control()' insert_info='#message#'>
                    </div>
                </div>
            </div>
        </div>
    </cf_report_list_search_area>
</cf_report_list_search>
</cfform>
<cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1>
    <cfset filename = "#createuuid()#">
    <cfheader name="Expires" value="#Now()#">
    <cfcontent type="application/vnd.msexcel;charset=utf-8">
    <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <cfset type_ = 1>
    <cfset attributes.startrow=1>
    <cfset attributes.maxrows=get_product.recordcount>
<cfelse>
    <cfset type_ = 0>
</cfif>
<cfif isdefined("attributes.form_submitted")>
<cf_report_list>
			<thead>
				<tr> 
					<th ><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='29401.Ürün Kategorisi'></th>
					<th><cf_get_lang dictionary_id="39691.Kategori Kodu"></th>
					<th><cf_get_lang dictionary_id='58221.Ürün Adi'></th>
					<th><cf_get_lang dictionary_id='58800.Ürün Kodu'></th>
					<th><cf_get_lang dictionary_id='57633.Barkod'></th>
					<th><cf_get_lang dictionary_id='39320.Per'><cf_get_lang dictionary_id='57639.Kdv'></th>
					<th><cf_get_lang dictionary_id='39323.Top'><cf_get_lang dictionary_id='57639.Kdv'></th>
					<th ><cf_get_lang dictionary_id='57448.Satis'></th>
                    <th ><cf_get_lang dictionary_id='58176.Alis'></th>                   
					<th ><cf_get_lang dictionary_id='39328.Satis Iskonto'></th>
					<th ><cf_get_lang dictionary_id='39329.Alis Iskonto'></th>
					<th ><cf_get_lang dictionary_id='39326.Satis Iade'></th>
					<th ><cf_get_lang dictionary_id='39327.Alis Iade'></th> 
					<th ><cf_get_lang dictionary_id="57448.Satış"> <cf_get_lang dictionary_id="39331.Fiyat Farkı"></th>
					<th ><cf_get_lang dictionary_id="58176.Alış"> <cf_get_lang dictionary_id="39331.Fiyat Farkı"></th>
					<th ><cf_get_lang dictionary_id='39332.Yurtdisi Satis'></th>
					<th ><cf_get_lang dictionary_id='39333.Yurtdisi Alis'></th>
					<th ><cf_get_lang dictionary_id='59121.Hammadde Satış'></th>
					<th ><cf_get_lang dictionary_id='39335.Fireler'></th>
					<th ><cf_get_lang dictionary_id='30009.Sarflar'></th>
					<th ><cf_get_lang dictionary_id='57753.Sayim Fazlasi'></th>
					<th ><cf_get_lang dictionary_id='57754.Sayim Eksigi'></th>
					<th ><cf_get_lang dictionary_id='59122.Mamül Satış'></th>
					<th><cf_get_lang dictionary_id="57456.Üretim">/ <cf_get_lang dictionary_id="58262.Mamüller"></th>
					<th><cf_get_lang dictionary_id="58261.Yarı Mamüller / Üretim"></th>
					<th ><cf_get_lang dictionary_id="59119.Satılan Mamülün Maliyeti"></th>
					<th ><cf_get_lang dictionary_id='40566.Diger Alis Hesabi'></th>
					<th ><cf_get_lang dictionary_id='40567.Diger Satis Hesabi'></th>
					<th><cf_get_lang dictionary_id="39692.Satış Nazım"></th>
					<th ><cf_get_lang dictionary_id='59123.Hurda Satış'></th>
					<th ><cf_get_lang dictionary_id='59120.Hurda'></th>
					<th><cf_get_lang dictionary_id='65068.D.I.M. Malz.'></th>
					<th><cf_get_lang dictionary_id='65069.D.I.M. Malz. Yans.'></th>
					<th><cf_get_lang dictionary_id="39677.Promosyon"></th>
					<th>G.U. <cf_get_lang dictionary_id="39683.Giderleri Yansıtma"></th>
					<th><cf_get_lang dictionary_id="39690.Üretim İşcilik Yansıtma"></th>
					<th ><cf_get_lang dictionary_id='39334.Hammadde'></th>
					<th ><cf_get_lang dictionary_id='58258.Maliyet'></th>
					<th ><cf_get_lang dictionary_id='59117.Alınan Hakediş'></th>
					<th ><cf_get_lang dictionary_id='39543.Verilen Hakediş'></th>
					<th><cf_get_lang dictionary_id ='58460.Masraf Merkezi'></th>
					<th><cf_get_lang dictionary_id ='58551.Gider Kalemi'></th>
					<th><cf_get_lang dictionary_id ='39173.Aktivite Tipi'></th>
					<th><cf_get_lang dictionary_id ='58822.Masraf Şablonu'></th>
					<th><cf_get_lang dictionary_id ='58172.Gelir Merkezi'></th>
					<th><cf_get_lang dictionary_id ='58173.Gelir Kalemi'></th>
					<th><cf_get_lang dictionary_id ='39173.Aktivite Tipi'></th>
                    <th><cf_get_lang dictionary_id ='58823.Gelir Şablonu'></th>
                    <th><cf_get_lang dictionary_id ='60998.İhraç Kayıtlı Satış'></th>
                    <th ><cf_get_lang dictionary_id='60300.Giden Yoldaki Stok(Satış)'></th>
                    <th ><cf_get_lang dictionary_id='60299.Gelen Yoldaki Stok(Alış)'></th>
                    <th><cf_get_lang dictionary_id='58478.Sabit Kıymet'><cf_get_lang dictionary_id='57486.Kategori'></th>
                    <th><cf_get_lang dictionary_id='58478.Sabit Kıymet'><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></th>
                    <th><cf_get_lang dictionary_id='29420.Amortisman Yöntemi'></th>
                    <th><cf_get_lang dictionary_id='29425.Amortisman Türü'></th>
                    <th><cf_get_lang dictionary_id='58478.Sabit Kıymet'><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th>
                    <th><cf_get_lang dictionary_id='58478.Sabit Kıymet'><cf_get_lang dictionary_id='58551.Gider Kalemi'></th>
                    <th><cf_get_lang dictionary_id='58298.Birikmiş Amortisman'></th>
                    <th><cf_get_lang dictionary_id='58021.ÖTV'></th>
                    <th><cf_get_lang dictionary_id='30006.Vergi Kodu'></th>
                    <th><cf_get_lang dictionary_id="36834.KDV'den Muaf Satış Faturası"></th>
                    <th><cf_get_lang dictionary_id='43458.İstisna Kodu'></th>
                    <th><cf_get_lang dictionary_id='57641.İskonto'><cf_get_lang dictionary_id ='38991.Gider Merkezi'></th>
                    <th><cf_get_lang dictionary_id='57641.İskonto'><cf_get_lang dictionary_id ='58551.Gider Kalemi'></th>
                    <th><cf_get_lang dictionary_id='57641.İskonto'><cf_get_lang dictionary_id='37218.Aktivite Tipi'></th>
                    <th><cf_get_lang dictionary_id='54531.Alış Ödeme Yöntemi'></th>
                    <th><cf_get_lang dictionary_id='54532.Satış Ödeme Yöntemi'></th>
                    <th><cf_get_lang dictionary_id='60404.Tahakkuk Gelir Kalemi'></th>
                    <th><cf_get_lang dictionary_id='41055.Tahakkuk Gider Kalemi'></th>
                    <th><cf_get_lang dictionary_id="41024.Gelecek Aylara Ait Gelirler Muhasebe Kodu"></th>
                    <th><cf_get_lang dictionary_id="41021.Gelecek Yıllara Ait Gelirler Muhasebe Kodu"></th>
                    <th><cf_get_lang dictionary_id="41020.Gelecek Aylara Ait Giderler Muhasebe Kodu"></th>
                    <th><cf_get_lang dictionary_id="41022.Gelecek Yıllara Ait Giderler Muhasebe Kodu"></th>
                    <th colspan="3"><cf_get_lang dictionary_id="41025.Tahakkuk Ay Sayısı"></th>                  
                    <th><cf_get_lang dictionary_id="41023.İlk 12 Ayı Gelecek Aylara Dağıt"></th>
                    <th><cf_get_lang dictionary_id='60405.Tahakkuk İşleminde Başlangıç Tarihini Ürün Teslim Tarihinden Al'></th>
                    <th><cf_get_lang dictionary_id='60406.Tahakkuk İşlemini Mali Yıl Sonuna Kadar Yap'></th>
                    <th><cf_get_lang dictionary_id='60407.Tahakkuk İşlemini Gün Bazında Yap'></th>
                    <th><cf_get_lang dictionary_id='61003.Geçmiş Ayların Dağıtım Tutarını İlk Aya Ekle'></th>
                    <cfif x_select_option eq 1>
						<cfif ListFind(attributes.select_option,1)><th><cf_get_lang dictionary_id ='57756.Durum'></th></cfif>
                        <cfif ListFind(attributes.select_option,2)><th><cf_get_lang dictionary_id ='40198.Envanter'></th></cfif>
                        <cfif ListFind(attributes.select_option,3)><th><cf_get_lang dictionary_id ='57456.Üretim'></th></cfif>
                        <cfif ListFind(attributes.select_option,4)> <th><cf_get_lang dictionary_id ='57448.Satış'></th></cfif>
                        <cfif ListFind(attributes.select_option,5)><th><cf_get_lang dictionary_id ='29745.Tedarik'></th></cfif>
                        <cfif ListFind(attributes.select_option,6)><th><cf_get_lang dictionary_id ='40212.Prototip'></th></cfif>
                        <cfif ListFind(attributes.select_option,7)><th><cf_get_lang dictionary_id ='40213.Internet'></th></cfif>
                        <cfif ListFind(attributes.select_option,8)><th><cf_get_lang dictionary_id ='58019.Extranet'></th></cfif>
                        <cfif ListFind(attributes.select_option,9)><th><cf_get_lang dictionary_id ='40239.Terazi'></th></cfif>
                        <cfif ListFind(attributes.select_option,10)><th><cf_get_lang dictionary_id ='40243.Karma Koli'></th></cfif>
                        <cfif ListFind(attributes.select_option,11)><th><cf_get_lang dictionary_id ='40159.Sıfır Stok'></th></cfif>
                        <cfif ListFind(attributes.select_option,12)><th><cf_get_lang dictionary_id ='40169.Stoklarla Sınırlı'></th></cfif>
                        <cfif ListFind(attributes.select_option,13)><th><cf_get_lang dictionary_id ='57637.Seri No'></th></cfif>
                        <cfif ListFind(attributes.select_option,14)><th><cf_get_lang dictionary_id ='58258.Maliyet'></th></cfif>
                        <cfif ListFind(attributes.select_option,15)><th><cf_get_lang dictionary_id ='40009.Kalite'></th></cfif>
                        <cfif ListFind(attributes.select_option,16)><th><cf_get_lang dictionary_id ='40241.Pos Komisyonu'></th></cfif>
                        <cfif ListFind(attributes.select_option,17)><th><cf_get_lang dictionary_id ='40249.Hediye Çeki'></th></cfif>
                   </cfif>
                </tr>
                <tr>
                    <th  colspan="73"></th>
                    <th><cf_get_lang dictionary_id="58793.Tek Düzen"></th>
                    <th><cf_get_lang dictionary_id="58308.IFRS"></th>
                    <th><cf_get_lang dictionary_id='57559.Bütçe'></th>
                </tr>
		 </thead>        
		<cfif get_product.recordcount>
			<cfset row_count_ = 0>
			<cfoutput query="get_product" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfset row_count_ = row_count_+1>
				<tbody>
					<tr>
						<td align="center">#currentrow#</td><!---No--->
						<td align="center">#product_cat#</td><!---Ürün Kategorisi--->
						<td align="center">#hierarchy#</td><!---Kategori Kodu--->
						<td align="center">#product_name#</td><!---Ürün Adı--->
						<td align="center">#product_code#</td><!---Ürün Kodu--->
						<td align="center">#barcod#</td><!---Barkod--->
						<td align="center">#tax#</td><!---Perakende Kdv--->
						<td align="center">#tax_purchase#</td><!---Toptan kdv--->
						<td align="center">#account_code#</td><!---Satış--->
                        <td align="center">#account_code_pur#</td><!---Alış--->                      
						<td align="center">#account_discount#</td><!---Satış İskonto--->
						<td align="center">#account_discount_pur#</td><!---alış İskonto--->
						<td align="center">#account_iade#</td><!---Satış İade--->
						<td align="center">#account_pur_iade#</td> <!---Alış İade--->
						<td align="center">#account_price#</td><!---Satış Fiyat Farkı--->
						<td align="center">#account_price_pur#</td><!---Alış Fiyat Farkı--->
						<td align="center">#account_yurtdisi#</td><!---Yurtdışı satış--->
						<td align="center">#account_yurtdisi_pur#</td><!---Yurtdışı Alış--->
						<td align="center">#material_code_sale#</td><!---Hammdde Satış--->
						<td align="center">#account_loss#</td><!---Fireler--->
						<td align="center">#account_expenditure#</td><!---Sarflar--->
						<td align="center">#over_count#</td><!---Sayım Fazlası--->
						<td align="center">#under_count#</td><!---Sayımeksiği--->
						<td align="center">#production_cost_sale#</td><!---MAmül Satış--->
						<td align="center">#production_cost#</td><!---Üretim Mamüller--->
						<td align="center">#half_production_cost#</td><!---Yarı Mamüller Üretim--->
						<td align="center">#sale_manufactured_cost#</td><!---Satılan Mamülün Maliyeti--->
						<td align="center">#konsinye_pur_code#</td><!---Diğer Alış Hesabı--->
						<td align="center">#konsinye_sale_code#</td><!---Diğer Satış Hesabı--->
						<td align="center">#konsinye_sale_naz_code#</td><!---Satış Nazım--->
						<td align="center">#scrap_code_sale#</td><!---Hurda Satış--->
						<td align="center">#scrap_code#</td><!---Hurda--->
						<td align="center">#dimm_code#</td><!---DIM Malzeme--->
						<td align="center">#dimm_yans_code#</td><!---DIM Malzreme Yansıtma--->
						<td align="center">#promotion_code#</td><!---Promosyon--->
						<td align="center">#prod_general_code#</td><!---G.U Giderleri Yansıtma--->
						<td align="center">#prod_labor_cost_code#</td><!---Üretim İşçilik yansıtma--->
						<td align="center">#material_code#</td><!---Hammadde--->
						<td align="center">#sale_product_cost#</td><!---MAliyet--->
						<td align="center">#received_progress_code#</td><!---Alınan Hakediş--->
						<td align="center"> #provided_progress_code#</td><!---Verilen Hakediş--->
						<td align="center">#gider_merkezi#</td><!---Masraf Merkezi--->
						<td align="center">#gider_kalemi#</td><!---Gider KAlemi--->
						<td align="center">#gider_aktivite_tipi#</td><!---Aktivite Tipi--->
						<td align="center">#gider_sablonu#</td><!---Masraf Şablonu--->
						<td align="center">#gelir_merkezi#</td><!---Gelir Merkezi--->
						<td align="center">#gelir_kalemi#</td><!---Gelir Kalemi--->
						<td align="center">#gelir_aktivite_tipi#</td><!---Aktivite Tipi--->
                        <td align="center">#gelir_sablonu#</td><!---Gelir Şablonu--->
                        <td align="center">#account_exportregistered#</td><!---İhraç Kayıtlı Satış--->
                        <td align="center">#outgoing_stock#</td><!---Satış Stok--->
						<td align="center">#incoming_stock#</td><!---alış Stok--->
                        <td align="center">#inventory_cat#</td><!---Sabit Kıymet Kategori--->
                        <td align="center">#inventory_code#</td><!---Sabit Kıymet Muhasebe Kodu--->
                        <td><cfif ListFind(amortization_method_id,0)>
                            <cf_get_lang dictionary_id='29421.Azalan Bakiye Üzerinden'>
                        <cfelseif ListFind(amortization_method_id,1)>
                            <cf_get_lang dictionary_id='29422.Sabit Miktar Üzeriden'>
                        <cfelseif ListFind(amortization_method_id,2)>
                            <cf_get_lang dictionary_id='29423.Hızlandırılmış Azalan Bakiye'>
                        <cfelseif ListFind(amortization_method_id,3)>
                            <cf_get_lang dictionary_id='29424.Hızlandırılmış Sabit Değer'>
                        </cfif></td><!---Amortisman Yöntemi--->
                       <td><cfif ListFind(amortization_type_id,1)>
                            <cf_get_lang dictionary_id='29426.Kıst Amortismana Tabi'>
                        <cfelseif ListFind(amortization_type_id,2)>
                            <cf_get_lang dictionary_id='29427.Kıst Amortismana Tabi Değil'>
                        </cfif></td><!---Amortisman Türü--->
                        <td align="center">#amortization_exp_center#</td><!---Sabit Kıymet Masraf Merkezi--->
                        <td align="center">#amortization_exp_item#</td><!---Sabit Kıymet Gider Kalemi--->
                        <td align="center">#amortization_code#</td><!---Sabit Kıymet Birikmiş Amortisman--->
                        <td align="center">#otv#</td><!---OTV--->
                        <td align="center">#tax_code_name#</td><!---Vergi Kodu--->
                        <td align="center">#exe_vat_sale_invoice#</td><!---Kdv'den muaf--->
                        <td align="center">#reason_code#</td><!---İstisna Kodu--->
                        <td align="center">#iskonto_gider_merkezi#</td><!---iskonto gider merkezi--->
                        <td align="center">#iskonto_gider_kalemi#</td><!---iskonto gider kalemi--->
                        <td align="center">#iskonto_aktivite_tipi#</td><!---iskonto aktivite tipi--->
                        <td align="center">#alis_odeme_yontemi#</td><!---Alış Ödeme Yöntemi--->
                        <td align="center">#satis_odeme_yontemi#</td><!---Satış Ödeme Yöntemi--->
                        <td align="center">#ACCRUAL_INCOME_ITEM#</td><!---Tahakkuk Gelir--->
                        <td align="center">#ACCRUAL_EXPENSE_ITEM#</td><!---Tahahkuk_Gider--->
                        <td align="center">#next_month_incomes_acc_code#</td><!---Gelecek aylara ait gelir --->
                        <td align="center">#next_year_incomes_acc_code#</td><!---Gelecek yıllara ait gelir--->
                        <td align="center">#next_month_expenses_acc_code#</td><!---Gelecek aylara ait gider--->
                        <td align="center">#next_year_expenses_acc_code#</td><!---Gelecek yıllara ait gider--->
                        <td align="center">#accrual_month#</td><!---Gelecek yıllara ait gelir--->
                        <td align="center">#accrual_month_ifrs#</td><!---Gelecek aylara ait gider--->
                        <td align="center">#accrual_month_budget#</td><!---Gelecek yıllara ait gider--->
                        <td><cfif first_12_to_month eq 1>
                                <cf_get_lang dictionary_id='58793.Tek Düzen'>/
                            </cfif> 
                            <cfif first_12_to_month_ifrs eq 1>
                                <cf_get_lang dictionary_id='58308.UFRS'>
                            </cfif>
                        </td><!---12 ay--->
                        <td>
                            <cfif start_from_delivery_date eq 1>
                                <cf_get_lang dictionary_id='58793.Tek Düzen'>/
                            </cfif> 
                            <cfif start_from_delivery_date_ifrs eq 1>
                                <cf_get_lang dictionary_id='58308.UFRS'>
                            </cfif>
                        </td><!---teslim tarihinden al--->
                        <td>
                            <cfif distribute_to_fiscal_end eq 1>
                                <cf_get_lang dictionary_id='58793.Tek Düzen'>/
                            </cfif> 
                            <cfif distribute_to_fiscal_end_ifrs eq 1>
                                <cf_get_lang dictionary_id='58308.UFRS'>
                            </cfif>
                        </td><!---Tahakkuk İşlemini Mali Yıl Sonuna Kadar Yap--->
                        <td>
                            <cfif distribute_day_based eq 1>
                                <cf_get_lang dictionary_id='58793.Tek Düzen'>/
                            </cfif> 
                            <cfif distribute_day_based_ifrs eq 1>
                                <cf_get_lang dictionary_id='58308.UFRS'>
                            </cfif>
                        </td><!---Tahakkuk İşlemini Gün bazında Yap--->
                        <td>
                            <cfif past_months_to_first eq 1>
                                <cf_get_lang dictionary_id='58793.Tek Düzen'>/
                            </cfif> 
                            <cfif past_months_to_first_ifrs eq 1>
                                <cf_get_lang dictionary_id='58308.UFRS'>
                            </cfif>
                        </td><!---Geçmiş Ayların Dağıtım Tutarını İlk Aya Ekle--->
                        <cfif x_select_option eq 1>
							<cfif ListFind(attributes.select_option,1)><td><cfif product_status eq 1><cf_get_lang dictionary_id="57493.Aktif"><cfelse><cf_get_lang dictionary_id="57494.Pasif"></cfif></td></cfif><!---Durum--->
                            <cfif ListFind(attributes.select_option,2)><td><cfif is_inventory eq 1><cf_get_lang dictionary_id="57495.Evet"><cfelse><cf_get_lang dictionary_id="57496.Hayır"></cfif></td></cfif><!---Envanter--->
                            <cfif ListFind(attributes.select_option,3)><td><cfif is_production eq 1><cf_get_lang dictionary_id="57495.Evet"><cfelse><cf_get_lang dictionary_id="57496.Hayır"></cfif></td></cfif><!---Üretim--->
                            <cfif ListFind(attributes.select_option,4)><td><cfif is_sales eq 1><cf_get_lang dictionary_id="57495.Evet"><cfelse><cf_get_lang dictionary_id="57496.Hayır"></cfif></td></cfif><!---Satış--->
                            <cfif ListFind(attributes.select_option,5)><td><cfif is_purchase eq 1><cf_get_lang dictionary_id="57495.Evet"><cfelse><cf_get_lang dictionary_id="57496.Hayır"></cfif></td></cfif><!---Tedarik--->
                            <cfif ListFind(attributes.select_option,6)><td><cfif is_prototype eq 1><cf_get_lang dictionary_id="57495.Evet"><cfelse><cf_get_lang dictionary_id="57496.Hayır"></cfif></td></cfif><!---Prototip--->
                            <cfif ListFind(attributes.select_option,7)><td><cfif is_internet eq 1><cf_get_lang dictionary_id="57495.Evet"><cfelse><cf_get_lang dictionary_id="57496.Hayır"></cfif></td></cfif><!---Internet--->
                            <cfif ListFind(attributes.select_option,8)><td><cfif is_extranet eq 1><cf_get_lang dictionary_id="57495.Evet"><cfelse><cf_get_lang dictionary_id="57496.Hayır"></cfif></td></cfif><!---Extranet--->
                            <cfif ListFind(attributes.select_option,9)><td><cfif is_terazi eq 1><cf_get_lang dictionary_id="57495.Evet"><cfelse><cf_get_lang dictionary_id="57496.Hayır"></cfif></td></cfif><!---Terazi--->
                            <cfif ListFind(attributes.select_option,10)><td><cfif is_karma eq 1><cf_get_lang dictionary_id="57495.Evet"><cfelse><cf_get_lang dictionary_id="57496.Hayır"></cfif></td></cfif><!---Karma Koli--->
                            <cfif ListFind(attributes.select_option,11)><td><cfif is_zero_stock eq 1><cf_get_lang dictionary_id="57495.Evet"><cfelse><cf_get_lang dictionary_id="57496.Hayır"></cfif></td></cfif><!---Sıfır Stok--->
                            <cfif ListFind(attributes.select_option,12)><td><cfif is_limited_stock eq 1><cf_get_lang dictionary_id="57495.Evet"><cfelse><cf_get_lang dictionary_id="57496.Hayır"></cfif></td></cfif><!---Stoklarla Sınırlı--->
                            <cfif ListFind(attributes.select_option,13)><td><cfif is_serial_no eq 1><cf_get_lang dictionary_id="57495.Evet"><cfelse><cf_get_lang dictionary_id="57496.Hayır"></cfif></td></cfif><!---Seri No--->
                            <cfif ListFind(attributes.select_option,14)> <td><cfif is_cost eq 1><cf_get_lang dictionary_id="57495.Evet"><cfelse><cf_get_lang dictionary_id="57496.Hayır"></cfif></td></cfif><!---MAliyet--->
                            <cfif ListFind(attributes.select_option,15)><td><cfif is_quality eq 1><cf_get_lang dictionary_id="57495.Evet"><cfelse><cf_get_lang dictionary_id="57496.Hayır"></cfif></td></cfif><!---Kalite--->
                            <cfif ListFind(attributes.select_option,16)><td><cfif is_commission eq 1><cf_get_lang dictionary_id="57495.Evet"><cfelse><cf_get_lang dictionary_id="57496.Hayır"></cfif></td></cfif><!---Pos Komisyonu--->
                            <cfif ListFind(attributes.select_option,17)><td><cfif is_gift_card eq 1><cf_get_lang dictionary_id="57495.Evet"><cfelse><cf_get_lang dictionary_id="57496.Hayır"></cfif></td></cfif><!---Hediye Çeki--->
                        </cfif>

					</tr> 
				</tbody>
			</cfoutput>
			<input type="hidden" name="row_count_" id="row_count_" value="<cfoutput>#row_count_#</cfoutput>">
		<cfelse>
			<tbody>
				<tr>
                	<cfset colspan_ = 49>
                    <cfif x_select_option eq 1>
                    	<cfset colspan_ = colspan_ + listlen(attributes.select_option)>
                    </cfif>
					<td colspan="90"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayit Yok'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></td>
				</tr>
			</tbody>
		</cfif>        
</cf_report_list>
</cfif>
    <cfif attributes.totalrecords gt attributes.maxrows>
                    <cfset adres = "#attributes.fuseaction#&form_submitted=#attributes.form_submitted#">
                    <cfif len(attributes.employee_id) and len(attributes.employee)>
                        <cfset adres = '#adres#&employee=#attributes.employee#'>
                        <cfset adres = '#adres#&employee_id=#attributes.employee_id#'>
                    </cfif>
                    <cfif len(attributes.product_id) and len(attributes.stock_id) and len(attributes.product)>
                        <cfset adres = '#adres#&product=#attributes.product#'>
                        <cfset adres = '#adres#&product_id=#attributes.product_id#'>
                        <cfset adres = '#adres#&stock_id=#attributes.stock_id#'>
                    </cfif>
                    <cfif len(attributes.product_cat) and (isDefined('attributes.product_cat_code') and len(attributes.product_cat_code))>
                        <cfset adres = "#adres#&product_cat_code=#attributes.product_cat_code#">
                    </cfif>
                    <cfif len(attributes.product_cat)>
                        <cfset adres = "#adres#&product_cat=#attributes.product_cat#">
                    </cfif>        
                    <cfif len(attributes.has_account_code)>
                        <cfset adres = '#adres#&has_account_code=#attributes.has_account_code#'>
                    </cfif>
                    <cfif isdefined('attributes.list_account')>
                        <cfset adres='#adres#&list_account=#attributes.list_account#'>
                    </cfif>
                    <cfif isdefined('attributes.select_option')>
                        <cfset adres='#adres#&select_option=#attributes.select_option#'>
                    </cfif>
                    <cfset adres = '#adres#&is_active=#attributes.is_active#'>
                    <cf_paging
                            page="#attributes.page#" 
                            maxrows="#attributes.maxrows#"
                            totalrecords="#attributes.totalrecords#"
                            startrow="#attributes.startrow#"
                            adres="#adres#"> 
    </cfif>
<script type="text/javascript">
	function show_select()
	{
		if(document.getElementById('has_account_code').value==1)
			document.getElementById('tdlist_account',).style.display='';
		else if(document.getElementById('has_account_code').value==0)
			document.getElementById('tdlist_account').style.display='none';
	}
    function control()
    {
		if(document.search_product.is_excel.checked==false)
			{
				document.search_product.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.product_account_code"
				return true;
			}
			else
				document.search_product.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_product_account_code</cfoutput>"
	}
</script>
