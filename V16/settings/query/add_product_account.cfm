 <cfquery name="GET_CODES" datasource="#dsn3#">
	SELECT 
    	PRO_CODE_CATID, 
        IS_ACTIVE,  
        PRO_CODE_CAT_NAME,
        ACCOUNT_CODE,
        ACCOUNT_CODE_PUR,
        ACCOUNT_DISCOUNT,
        ACCOUNT_PRICE,
        ACCOUNT_PRICE_PUR,
        ACCOUNT_PUR_IADE,
        ACCOUNT_IADE,
        ACCOUNT_YURTDISI,
        ACCOUNT_YURTDISI_PUR,
        ACCOUNT_DISCOUNT_PUR,
        ACCOUNT_LOSS,
        ACCOUNT_EXPENDITURE,
        OVER_COUNT,
        UNDER_COUNT,
        PRODUCTION_COST,
        HALF_PRODUCTION_COST,
        SALE_PRODUCT_COST,
        SALE_MANUFACTURED_COST,
        DETAIL,
        MATERIAL_CODE,
        KONSINYE_PUR_CODE,
        KONSINYE_SALE_CODE,
        KONSINYE_SALE_NAZ_CODE,
        DIMM_CODE,
        DIMM_YANS_CODE,
        PROMOTION_CODE,
        EXP_CENTER_ID,
        EXP_ITEM_ID,
        EXP_TEMPLATE_ID,
        EXP_ACTIVITY_TYPE_ID,
        INC_CENTER_ID,
        INC_ITEM_ID,
        INC_TEMPLATE_ID,
        INC_ACTIVITY_TYPE_ID,
        INVENTORY_CODE,
        INVENTORY_CAT_ID,
        AMORTIZATION_METHOD_ID,
        AMORTIZATION_TYPE_ID,
        AMORTIZATION_EXP_CENTER_ID,
        AMORTIZATION_EXP_ITEM_ID,
        AMORTIZATION_CODE,
        PROD_GENERAL_CODE,
        PROD_LABOR_COST_CODE,
        RECEIVED_PROGRESS_CODE,
        PROVIDED_PROGRESS_CODE,
        SCRAP_CODE,
        MATERIAL_CODE_SALE,
        PRODUCTION_COST_SALE,
        SCRAP_CODE_SALE,
        EXPENSE_PROGRESS_CODE,
        INCOME_PROGRESS_CODE,
        EXE_VAT_SALE_INVOICE,
        DISCOUNT_EXPENSE_CENTER_ID,
        DISCOUNT_EXPENSE_ITEM_ID,
        DISCOUNT_ACTIVITY_TYPE_ID,
        REASON_CODE,
        INCOMING_STOCK,
        OUTGOING_STOCK,
        ACCOUNT_EXPORTREGISTERED,
        RECORD_EMP,
        RECORD_IP,
        RECORD_DATE 
    FROM 
    	SETUP_PRODUCT_PERIOD_CAT 
    WHERE 
	    PRO_CODE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_acc_cat#">
</cfquery>
<cfquery name="GET_OTHER_PERIOD" datasource="#dsn#">
	SELECT PERIOD_ID FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
</cfquery>
<cfif GET_CODES.recordcount and GET_OTHER_PERIOD.recordcount and ListFind("2,3,4",attributes.cat_type)>
	<cfset p_cat_id_list = "">
	<cfset p_code_list = "">
    <cfloop from="0" to="#attributes.row_count#" index="ind_">
        <cfif isdefined('attributes.product_catid#ind_#') and len(Evaluate('attributes.product_catid#ind_#'))>
            <cfset p_cat_id_list = ListAppend(p_cat_id_list,Evaluate("attributes.product_catid#ind_#"),',')>
        </cfif>
		<cfif attributes.cat_type eq 4>
			<cfif isdefined('attributes.product_code#ind_#') and len(Evaluate('attributes.product_code#ind_#'))>
				<cfset p_code_list = ListAppend(p_code_list,Evaluate("attributes.product_code#ind_#"),',')>
			</cfif>
		</cfif>
    </cfloop>
    <cfif not len(p_cat_id_list)>
        <script type="text/javascript">
            alert("<cf_get_lang no ='1006.Ürün Kategorisi Seçiniz'>!");
            history.back();
        </script>
        <cfabort>
    </cfif>	
</cfif>

<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfif GET_CODES.recordcount and GET_OTHER_PERIOD.recordcount>
            <cfquery name="del_old_codes" datasource="#dsn3#">
                DELETE FROM PRODUCT_PERIOD WHERE PRODUCT_ID IN (
                                                                    SELECT
                                                                        PRODUCT_ID
                                                                    FROM
                                                                        #dsn1_alias#.PRODUCT
                                                                    WHERE
                                                                        <cfif attributes.cat_type eq 1><!--- Kdvlere gore --->
                                                                            1 = 1
                                                                            <cfif isDefined("attributes.tax_sale") and len(attributes.tax_sale)>AND TAX = #attributes.tax_sale#</cfif>
                                                                            <cfif isDefined("attributes.tax_purchase") and len(attributes.tax_purchase)>AND TAX_PURCHASE = #attributes.tax_purchase#</cfif>
                                                                        <cfelseif attributes.cat_type eq 2><!--- Kategorisine Göre ve Satış Kdv --->
                                                                            PRODUCT_CATID IN (#p_cat_id_list#)
                                                                            <cfif isDefined("attributes.tax_sale") and len(attributes.tax_sale)>AND TAX = #attributes.tax_sale#</cfif>
                                                                        <cfelseif attributes.cat_type eq 3><!--- Kategori ve Satış Alış KDV sine Göre --->
                                                                            PRODUCT_CATID IN (#p_cat_id_list#)
                                                                            <cfif isDefined("attributes.tax_sale") and len(attributes.tax_sale)>AND TAX = #attributes.tax_sale#</cfif>
                                                                            <cfif isDefined("attributes.tax_purchase") and len(attributes.tax_purchase)>AND TAX_PURCHASE = #attributes.tax_purchase#</cfif>
                                                                        <cfelseif attributes.cat_type eq 4><!--- Kategorisine Gore --->
                                                                            (<cfloop list="#p_code_list#" index="pc">
                                                                                (PRODUCT_CODE = '#pc#' OR PRODUCT_CODE LIKE '#pc#.%')
                                                                                <cfif ListLast(p_code_list,",") neq pc>OR</cfif>
                                                                            </cfloop>)
                                                                        <cfelse>
                                                                            1 = 0
                                                                        </cfif>
                                                                    )
                     AND PERIOD_ID = #session.ep.period_id#
            </cfquery>
            <cfloop list="#ValueList(GET_OTHER_PERIOD.PERIOD_ID)#" index="i"> <!--- Önceden şirketin tüm dönemlerini döndürüyordu, şimdi sadece session.ep.period_id için çalıştırıyor. Loopu kaldırmadım, lazım olabilir sonradan. Durgan20150115 --->
                <cfquery name="add_prod_period" datasource="#dsn3#">
                    INSERT INTO
                        PRODUCT_PERIOD
                    (
                        PRODUCT_ID, 
                        PERIOD_ID,
                        ACCOUNT_CODE, 
                        ACCOUNT_CODE_PUR,
                        ACCOUNT_DISCOUNT,
                        ACCOUNT_PRICE,
                        ACCOUNT_PRICE_PUR,
                        ACCOUNT_PUR_IADE,
                        ACCOUNT_IADE,
                        ACCOUNT_YURTDISI,
                        ACCOUNT_YURTDISI_PUR,
                        ACCOUNT_DISCOUNT_PUR,
                        COST_EXPENSE_CENTER_ID,
                        EXPENSE_ITEM_ID,
                        EXPENSE_TEMPLATE_ID,
                        ACTIVITY_TYPE_ID,
                        EXPENSE_CENTER_ID,
                        INCOME_ITEM_ID,
                        INCOME_ACTIVITY_TYPE_ID,
                        INCOME_TEMPLATE_ID,
                        ACCOUNT_LOSS,
                        ACCOUNT_EXPENDITURE,
                        OVER_COUNT,
                        UNDER_COUNT,
                        PRODUCTION_COST,
                        HALF_PRODUCTION_COST,
                        SALE_PRODUCT_COST,
                        MATERIAL_CODE,
                        KONSINYE_PUR_CODE,
                        KONSINYE_SALE_CODE,
                        KONSINYE_SALE_NAZ_CODE,
                        DIMM_CODE,
                        DIMM_YANS_CODE,
                        PROMOTION_CODE,
                        PRODUCT_PERIOD_CAT_ID,
                        INVENTORY_CODE,
                        INVENTORY_CAT_ID,
                        AMORTIZATION_METHOD_ID,
                        AMORTIZATION_TYPE_ID,
                        AMORTIZATION_EXP_CENTER_ID,
                        AMORTIZATION_EXP_ITEM_ID,
                        AMORTIZATION_CODE,
                        PROD_GENERAL_CODE,
                        PROD_LABOR_COST_CODE,
                        RECEIVED_PROGRESS_CODE,
                        PROVIDED_PROGRESS_CODE,
                        MATERIAL_CODE_SALE, 
                        PRODUCTION_COST_SALE, 
                        SALE_MANUFACTURED_COST,
                        SCRAP_CODE_SALE,
                        SCRAP_CODE,
                        RECORD_EMP,
                        RECORD_IP,
                        RECORD_DATE,
                        EXE_VAT_SALE_INVOICE,
                        DISCOUNT_EXPENSE_CENTER_ID,
                        DISCOUNT_EXPENSE_ITEM_ID,
                        DISCOUNT_ACTIVITY_TYPE_ID,
                        REASON_CODE,
                        INCOMING_STOCK,
                        OUTGOING_STOCK,
                        ACCOUNT_EXPORTREGISTERED
                    )
                    
                    
                    SELECT 
                        P.PRODUCT_ID, 
                        #i# AS PERIOD_ID,
                        <cfif len (GET_CODES.ACCOUNT_CODE)>'#GET_CODES.ACCOUNT_CODE#'<cfelse>null</cfif> as ACCOUNT_CODE,
                        <cfif len(GET_CODES.ACCOUNT_CODE_PUR)>'#GET_CODES.ACCOUNT_CODE_PUR#'<cfelse>null</cfif> AS  ACCOUNT_CODE_PUR,
                        <cfif len(GET_CODES.ACCOUNT_DISCOUNT)>'#GET_CODES.ACCOUNT_DISCOUNT#'<cfelse>null</cfif> AS  ACCOUNT_DISCOUNT,
                        <cfif len(GET_CODES.ACCOUNT_PRICE)>'#GET_CODES.ACCOUNT_PRICE#'<cfelse>null</cfif> AS ACCOUNT_PRICE,
                        <cfif len(GET_CODES.ACCOUNT_PRICE_PUR)>'#GET_CODES.ACCOUNT_PRICE_PUR#'<cfelse>null</cfif> AS  ACCOUNT_PRICE_PUR,
                        <cfif len(GET_CODES.ACCOUNT_PUR_IADE)>'#GET_CODES.ACCOUNT_PUR_IADE#'<cfelse>null</cfif> AS ACCOUNT_PUR_IADE ,
                        <cfif len(GET_CODES.ACCOUNT_IADE)>'#GET_CODES.ACCOUNT_IADE#' <cfelse>null</cfif> AS ACCOUNT_IADE ,
                        <cfif len(GET_CODES.ACCOUNT_YURTDISI)>'#GET_CODES.ACCOUNT_YURTDISI#'<cfelse>null</cfif> AS ACCOUNT_YURTDISI,
                        <cfif len(GET_CODES.ACCOUNT_YURTDISI_PUR)>'#GET_CODES.ACCOUNT_YURTDISI_PUR#'<cfelse>null</cfif> AS ACCOUNT_YURTDISI_PUR ,
                        <cfif len(GET_CODES.ACCOUNT_DISCOUNT_PUR)>'#GET_CODES.ACCOUNT_DISCOUNT_PUR#'<cfelse>null</cfif> AS ACCOUNT_DISCOUNT_PUR,
                        <cfif len(GET_CODES.EXP_CENTER_ID)>#GET_CODES.EXP_CENTER_ID#<cfelse>null</cfif> AS EXP_CENTER_ID ,
                        <cfif len(GET_CODES.EXP_ITEM_ID)>#GET_CODES.EXP_ITEM_ID#<cfelse>null</cfif> AS EXP_ITEM_ID ,
                        <cfif len(GET_CODES.EXP_TEMPLATE_ID)>  #GET_CODES.EXP_TEMPLATE_ID# <cfelse> null </cfif> AS EXP_TEMPLATE_ID,
                        <cfif len(GET_CODES.EXP_ACTIVITY_TYPE_ID)> #GET_CODES.EXP_ACTIVITY_TYPE_ID# <cfelse> null </cfif>AS EXP_ACTIVITY_TYPE_ID,
                        <cfif len(GET_CODES.INC_CENTER_ID)>#GET_CODES.INC_CENTER_ID# <cfelse> null </cfif> AS INC_CENTER_ID,
                        <cfif len(GET_CODES.INC_ITEM_ID)>#GET_CODES.INC_ITEM_ID# <cfelse> null </cfif> AS INC_ITEM_ID ,
                        <cfif len(GET_CODES.INC_ACTIVITY_TYPE_ID)>#GET_CODES.INC_ACTIVITY_TYPE_ID# <cfelse> null </cfif> AS INC_ACTIVITY_TYPE_ID,
                        <cfif len(GET_CODES.INC_TEMPLATE_ID)>#GET_CODES.INC_TEMPLATE_ID# <cfelse> null </cfif> AS INC_TEMPLATE_ID,
                        <cfif len(GET_CODES.ACCOUNT_LOSS)>'#GET_CODES.ACCOUNT_LOSS#' <cfelse> null </cfif> AS ACCOUNT_LOSS,
                        <cfif len(GET_CODES.ACCOUNT_EXPENDITURE)>'#GET_CODES.ACCOUNT_EXPENDITURE#' <cfelse> null </cfif> AS ACCOUNT_EXPENDITURE,
                        <cfif len(GET_CODES.OVER_COUNT)>'#GET_CODES.OVER_COUNT#' <cfelse> null </cfif> AS OVER_COUNT,
                        <cfif len(GET_CODES.UNDER_COUNT)>'#GET_CODES.UNDER_COUNT#' <cfelse> null </cfif> AS UNDER_COUNT,
                        <cfif len(GET_CODES.PRODUCTION_COST)>'#GET_CODES.PRODUCTION_COST#' <cfelse> null </cfif> AS PRODUCTION_COST,
                        <cfif len(GET_CODES.HALF_PRODUCTION_COST)>'#GET_CODES.HALF_PRODUCTION_COST#' <cfelse> null </cfif> AS HALF_PRODUCTION_COST,
                        <cfif len(GET_CODES.SALE_PRODUCT_COST)>'#GET_CODES.SALE_PRODUCT_COST#' <cfelse> null </cfif> AS SALE_PRODUCT_COST,
                        <cfif len(GET_CODES.MATERIAL_CODE)>'#GET_CODES.MATERIAL_CODE#' <cfelse> null </cfif> AS MATERIAL_CODE,
                        <cfif len(GET_CODES.KONSINYE_PUR_CODE)>'#GET_CODES.KONSINYE_PUR_CODE#' <cfelse> null </cfif> AS KONSINYE_PUR_CODE,
                        <cfif len(GET_CODES.KONSINYE_SALE_CODE)>'#GET_CODES.KONSINYE_SALE_CODE#' <cfelse> null </cfif> AS KONSINYE_SALE_CODE,
                        <cfif len(GET_CODES.KONSINYE_SALE_NAZ_CODE)>'#GET_CODES.KONSINYE_SALE_NAZ_CODE#' <cfelse> null </cfif> AS KONSINYE_SALE_NAZ_CODE,
                        <cfif len(GET_CODES.DIMM_CODE)>'#GET_CODES.DIMM_CODE#' <cfelse> null </cfif> AS DIMM_CODE,
                        <cfif len(GET_CODES.DIMM_YANS_CODE)>'#GET_CODES.DIMM_YANS_CODE#'<cfelse>NULL</cfif> as DIMM_YANS_CODE ,
                        <cfif len(GET_CODES.PROMOTION_CODE)>'#GET_CODES.PROMOTION_CODE#' <cfelse> null </cfif> AS PROMOTION_CODE,
                         #attributes.product_acc_cat# AS product_acc_cat,
                        <cfif len(GET_CODES.INVENTORY_CODE)>'#GET_CODES.INVENTORY_CODE#' <cfelse> null </cfif> AS INVENTORY_CODE,
                        <cfif len(GET_CODES.INVENTORY_CAT_ID)>'#GET_CODES.INVENTORY_CAT_ID#' <cfelse> null </cfif> AS INVENTORY_CAT_ID,
                        <cfif len(GET_CODES.AMORTIZATION_METHOD_ID)>'#GET_CODES.AMORTIZATION_METHOD_ID#' <cfelse> null </cfif> AS AMORTIZATION_METHOD_ID,
                        <cfif len(GET_CODES.AMORTIZATION_TYPE_ID)>'#GET_CODES.AMORTIZATION_TYPE_ID#' <cfelse> null </cfif> AS AMORTIZATION_TYPE_ID,
                        <cfif len(GET_CODES.AMORTIZATION_EXP_CENTER_ID)>'#GET_CODES.AMORTIZATION_EXP_CENTER_ID#' <cfelse> null </cfif> AS AMORTIZATION_EXP_CENTER_ID,
                        <cfif len(GET_CODES.AMORTIZATION_EXP_ITEM_ID)>'#GET_CODES.AMORTIZATION_EXP_ITEM_ID#' <cfelse> null </cfif> AS AMORTIZATION_EXP_ITEM_ID,
                        <cfif len(GET_CODES.AMORTIZATION_CODE)>'#GET_CODES.AMORTIZATION_CODE#' <cfelse> null </cfif> AS AMORTIZATION_CODE,
                        <cfif len(GET_CODES.PROD_GENERAL_CODE)>'#GET_CODES.PROD_GENERAL_CODE#' <cfelse> null </cfif> AS PROD_GENERAL_CODE,
                        <cfif len(GET_CODES.PROD_LABOR_COST_CODE)>'#GET_CODES.PROD_LABOR_COST_CODE#' <cfelse> null </cfif> AS PROD_LABOR_COST_CODE,
                        <cfif len(GET_CODES.RECEIVED_PROGRESS_CODE)>'#GET_CODES.RECEIVED_PROGRESS_CODE#' <cfelse> null </cfif> AS RECEIVED_PROGRESS_CODE,
                        <cfif len(GET_CODES.PROVIDED_PROGRESS_CODE)>'#GET_CODES.PROVIDED_PROGRESS_CODE#' <cfelse> null </cfif> AS PROVIDED_PROGRESS_CODE,
                        <cfif len(GET_CODES.MATERIAL_CODE_SALE)>'#GET_CODES.MATERIAL_CODE_SALE#' <cfelse> null </cfif> AS MATERIAL_CODE_SALE,
                        <cfif len(GET_CODES.PRODUCTION_COST_SALE)>'#GET_CODES.PRODUCTION_COST_SALE#' <cfelse> null </cfif> AS PRODUCTION_COST_SALE,
                        <cfif len(GET_CODES.SALE_MANUFACTURED_COST)>'#GET_CODES.SALE_MANUFACTURED_COST#' <cfelse> null </cfif> AS SALE_MANUFACTURED_COST,
                        <cfif len(GET_CODES.SCRAP_CODE_SALE)>'#GET_CODES.SCRAP_CODE_SALE#' <cfelse> null </cfif> AS SCRAP_CODE_SALE,
                        <cfif len(GET_CODES.SCRAP_CODE)>'#GET_CODES.SCRAP_CODE#' <cfelse> null </cfif> AS SCRAP_CODE,
                        #session.ep.userid# ,
                        '#CGI.REMOTE_ADDR#',
                        #now()#,
                        <cfif len (GET_CODES.EXE_VAT_SALE_INVOICE)>'#GET_CODES.EXE_VAT_SALE_INVOICE#'<cfelse>null</cfif> as EXE_VAT_SALE_INVOICE,
                        <cfif len (GET_CODES.DISCOUNT_EXPENSE_CENTER_ID)>'#GET_CODES.DISCOUNT_EXPENSE_CENTER_ID#'<cfelse>null</cfif> as DISCOUNT_EXPENSE_CENTER_ID, 
                        <cfif len (GET_CODES.DISCOUNT_EXPENSE_ITEM_ID)>'#GET_CODES.DISCOUNT_EXPENSE_ITEM_ID#'<cfelse>null</cfif> as DISCOUNT_EXPENSE_ITEM_ID,
                        <cfif len (GET_CODES.DISCOUNT_ACTIVITY_TYPE_ID)>'#GET_CODES.DISCOUNT_ACTIVITY_TYPE_ID#'<cfelse>null</cfif> as DISCOUNT_ACTIVITY_TYPE_ID,
                        <cfif len (GET_CODES.REASON_CODE)>'#GET_CODES.REASON_CODE#'<cfelse>null</cfif> as REASON_CODE,
                        <cfif len (GET_CODES.INCOMING_STOCK)>'#GET_CODES.INCOMING_STOCK#'<cfelse>null</cfif> as INCOMING_STOCK,
                        <cfif len (GET_CODES.OUTGOING_STOCK)>'#GET_CODES.OUTGOING_STOCK#'<cfelse>null</cfif> as OUTGOING_STOCK,
                        <cfif len (GET_CODES.ACCOUNT_EXPORTREGISTERED)>'#GET_CODES.ACCOUNT_EXPORTREGISTERED#'<cfelse>null</cfif> as ACCOUNT_EXPORTREGISTERED
                  FROM       
                        #dsn1_alias#.PRODUCT AS P
                  WHERE
                       <cfif attributes.cat_type eq 1><!--- Kdvlere gore --->
                            1 = 1
                            <cfif isDefined("attributes.tax_sale") and len(attributes.tax_sale)>AND TAX = #attributes.tax_sale#</cfif>
                            <cfif isDefined("attributes.tax_purchase") and len(attributes.tax_purchase)>AND TAX_PURCHASE = #attributes.tax_purchase#</cfif>
                        <cfelseif attributes.cat_type eq 2><!--- Kategorisine Göre ve Satış Kdv --->
                            PRODUCT_CATID IN (#p_cat_id_list#)
                            <cfif isDefined("attributes.tax_sale") and len(attributes.tax_sale)>AND TAX = #attributes.tax_sale#</cfif>
                        <cfelseif attributes.cat_type eq 3><!--- Kategori ve Satış Alış KDV sine Göre --->
                            PRODUCT_CATID IN (#p_cat_id_list#)
                            <cfif isDefined("attributes.tax_sale") and len(attributes.tax_sale)>AND TAX = #attributes.tax_sale#</cfif>
                            <cfif isDefined("attributes.tax_purchase") and len(attributes.tax_purchase)>AND TAX_PURCHASE = #attributes.tax_purchase#</cfif>
                        <cfelseif attributes.cat_type eq 4><!--- Kategorisine Gore --->
                            (<cfloop list="#p_code_list#" index="pc">
                                (PRODUCT_CODE = '#pc#' OR PRODUCT_CODE LIKE '#pc#.%')
                                <cfif ListLast(p_code_list,",") neq pc>OR</cfif>
                            </cfloop>)
                        <cfelse>
                            1 = 0
                        </cfif>
                    <!---VALUES 
                    (
                        #get_products.PRODUCT_ID#,
                        #i#,
                        <cfif len(GET_CODES.ACCOUNT_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_CODE#"><cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.ACCOUNT_CODE_PUR)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_CODE_PUR#"><cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.ACCOUNT_DISCOUNT)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_DISCOUNT#"><cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.ACCOUNT_PRICE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_PRICE#"><cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.ACCOUNT_PRICE_PUR)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_PRICE_PUR#"><cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.ACCOUNT_PUR_IADE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_PUR_IADE#"><cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.ACCOUNT_IADE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_IADE#"><cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.ACCOUNT_YURTDISI)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_YURTDISI#"><cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.ACCOUNT_YURTDISI_PUR)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_YURTDISI_PUR#"><cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.ACCOUNT_DISCOUNT_PUR)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_DISCOUNT_PUR#"><cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.EXP_CENTER_ID)>#GET_CODES.EXP_CENTER_ID#<cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.EXP_ITEM_ID)>#GET_CODES.EXP_ITEM_ID#<cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.EXP_TEMPLATE_ID)>#GET_CODES.EXP_TEMPLATE_ID#<cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.EXP_ACTIVITY_TYPE_ID)>#GET_CODES.EXP_ACTIVITY_TYPE_ID#<cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.INC_CENTER_ID)>#GET_CODES.INC_CENTER_ID#<cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.INC_ITEM_ID)>#GET_CODES.INC_ITEM_ID#<cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.INC_ACTIVITY_TYPE_ID)>#GET_CODES.INC_ACTIVITY_TYPE_ID#<cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.INC_TEMPLATE_ID)>#GET_CODES.INC_TEMPLATE_ID#<cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.ACCOUNT_LOSS)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_LOSS#"><cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.ACCOUNT_EXPENDITURE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_EXPENDITURE#"><cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.OVER_COUNT)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.OVER_COUNT#"><cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.UNDER_COUNT)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.UNDER_COUNT#"><cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.PRODUCTION_COST)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PRODUCTION_COST#"><cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.HALF_PRODUCTION_COST)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.HALF_PRODUCTION_COST#"><cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.SALE_PRODUCT_COST)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.SALE_PRODUCT_COST#"><cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.MATERIAL_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.MATERIAL_CODE#"><cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.KONSINYE_PUR_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.KONSINYE_PUR_CODE#"><cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.KONSINYE_SALE_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.KONSINYE_SALE_CODE#"><cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.KONSINYE_SALE_NAZ_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.KONSINYE_SALE_NAZ_CODE#"><cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.DIMM_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.DIMM_CODE#"><cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.DIMM_YANS_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.DIMM_YANS_CODE#"><cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.PROMOTION_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PROMOTION_CODE#"><cfelse>NULL</cfif>,
                        <cfif Len(attributes.product_acc_cat)>#attributes.product_acc_cat#<cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.INVENTORY_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.INVENTORY_CODE#"><cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.INVENTORY_CAT_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.INVENTORY_CAT_ID#"><cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.AMORTIZATION_METHOD_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_METHOD_ID#"><cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.AMORTIZATION_TYPE_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_TYPE_ID#"><cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.AMORTIZATION_EXP_CENTER_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_EXP_CENTER_ID#"><cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.AMORTIZATION_EXP_ITEM_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_EXP_ITEM_ID#"><cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.AMORTIZATION_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_CODE#"><cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.PROD_GENERAL_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PROD_GENERAL_CODE#"><cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.PROD_LABOR_COST_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PROD_LABOR_COST_CODE#"><cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.RECEIVED_PROGRESS_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.RECEIVED_PROGRESS_CODE#"><cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.PROVIDED_PROGRESS_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PROVIDED_PROGRESS_CODE#"><cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.MATERIAL_CODE_SALE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.MATERIAL_CODE_SALE#"><cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.PRODUCTION_COST_SALE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PRODUCTION_COST_SALE#"><cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.SALE_MANUFACTURED_COST)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.SALE_MANUFACTURED_COST#"><cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.SCRAP_CODE_SALE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.SCRAP_CODE_SALE#"><cfelse>NULL</cfif>,
                        <cfif len(GET_CODES.SCRAP_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.SCRAP_CODE#"><cfelse>NULL</cfif>,
                        #session.ep.userid#,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
                        #now()#
                    )--->
                </cfquery>
            </cfloop>
		</cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">
	alert("<cf_get_lang no ='2536.Islem Tamamlandı'>!");
	window.location.href='<cfoutput>#request.self#?fuseaction=settings.form_add_pro_account</cfoutput>';
</script>

