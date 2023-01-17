<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
   <cfparam name="attributes.brand_id" default="">
    <cfparam name="attributes.short_code_id" default="">
    <cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.member_name" default="">
    <cfparam name="attributes.pos_code" default="">
    <cfparam name="attributes.pos_manager" default="">
    <cfparam name="attributes.start_date" default="">
    <cfparam name="attributes.finish_date" default="">
    <cfquery name="GET_PRODUCT_CAT" datasource="#dsn1#">
        SELECT 
            PRODUCT_CAT.PRODUCT_CATID, 
            PRODUCT_CAT.HIERARCHY, 
            PRODUCT_CAT.PRODUCT_CAT
        FROM 
            PRODUCT_CAT,
            PRODUCT_CAT_OUR_COMPANY PCO
        WHERE 
            PRODUCT_CAT.PRODUCT_CATID = PCO.PRODUCT_CATID AND
            PCO.OUR_COMPANY_ID = #session.ep.company_id# 
        ORDER BY 
            HIERARCHY
    </cfquery>
    <cfquery name="get_all_period" datasource="#dsn#">
        SELECT PERIOD_YEAR FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #session.ep.company_id#
    </cfquery>
    <cfset method_name_list = 'Hareketli Ortalama (3 AY),Hareketli Ortalama (4 AY),Hareketli Ortalama (5 AY),Hareketli Ortalama (6 AY),Ağırlıklı Hareketli Ortalama (3 AY),Ağırlıklı Hareketli Ortalama (4 AY),Ağırlıklı Hareketli Ortalama (5 AY),Ağırlıklı Hareketli Ortalama (6 AY),Üstel Düzeltme,Trend Analizi,Mevsimsel Tahmin'> 
	<cfif isdefined("attributes.form_submitted")>
        <cfquery name="get_product" datasource="#dsn3#">
            SELECT
                STOCK_ID,
                PRODUCT_ID,
                PRODUCT_NAME,
                SUM(SALE_AMOUNT) AMOUNT
            FROM
            (
                SELECT
                    S.STOCK_ID,
                    S.PRODUCT_ID,
                    S.PRODUCT_NAME,
                    MS.SALE_AMOUNT
                FROM
                    STOCKS S,
                    MONTHLY_SALES_AMOUNT MS
                WHERE
                    S.STOCK_ID = MS.STOCK_ID
                    <cfif isdefined("attributes.stock_id") and len(attributes.stock_id) and len(attributes.product_name)>
                        AND S.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#"> 
                    </cfif>
                    <cfif isdefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_manager)>
                        AND S.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#"> 
                    </cfif>
                    <cfif isdefined("attributes.brand_id") and len(attributes.brand_id) and len(attributes.brand_name)>
                        AND S.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#"> 
                    </cfif>
                    <cfif isdefined("attributes.short_code_id") and len(attributes.short_code_id) and len(attributes.short_code_name)>
                        AND S.SHORT_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.short_code_id#"> 
                    </cfif>				
                    <cfif isdefined("attributes.product_cat") and len(attributes.product_cat)>
                         AND
                            (
                                <cfloop from="1" to="#listlen(attributes.product_cat)#" index="c"> 
                                (S.PRODUCT_CODE LIKE '#ListGetAt(attributes.product_cat,c,',')#.%')
                                <cfif C neq listlen(attributes.product_cat)>OR</cfif>
                                </cfloop>
                            )
                    </cfif>
                    <cfif isdefined("attributes.company_id") and len(attributes.company_id) and len(attributes.member_name)>
                        AND S.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> 
                    </cfif>
                    <cfif isdefined("attributes.start_date") and len(attributes.start_date)>
                        AND MS.MONTH >= <cfqueryparam cfsqltype="cf_sql_integer" value="#month(attributes.start_date)#"> 
                        AND MS.YEAR >= <cfqueryparam cfsqltype="cf_sql_integer" value="#year(attributes.start_date)#"> 
                    </cfif>
                    <cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
                        AND MS.MONTH <= <cfqueryparam cfsqltype="cf_sql_integer" value="#month(attributes.finish_date)#"> 
                        AND MS.YEAR <= <cfqueryparam cfsqltype="cf_sql_integer" value="#year(attributes.finish_date)#"> 
                    </cfif>
                UNION ALL
                SELECT
                    S.STOCK_ID,
                    S.PRODUCT_ID,
                    S.PRODUCT_NAME,
                    SR.STOCK_OUT SALE_AMOUNT
                FROM
                    STOCKS S,
                    #dsn2_alias#.STOCKS_ROW SR
                WHERE
                    S.STOCK_ID = SR.STOCK_ID
                    AND SR.PROCESS_TYPE = 71
                    <cfif isdefined("attributes.stock_id") and len(attributes.stock_id) and len(attributes.product_name)>
                        AND S.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#"> 
                    </cfif>
                    <cfif isdefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_manager)>
                        AND S.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#"> 
                    </cfif>
                    <cfif isdefined("attributes.brand_id") and len(attributes.brand_id) and len(attributes.brand_name)>
                        AND S.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#"> 
                    </cfif>
                    <cfif isdefined("attributes.short_code_id") and len(attributes.short_code_id) and len(attributes.short_code_name)>
                        AND S.SHORT_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.short_code_id#"> 
                    </cfif>				
                    <cfif isdefined("attributes.product_cat") and len(attributes.product_cat)>
                         AND
                            (
                                <cfloop from="1" to="#listlen(attributes.product_cat)#" index="c"> 
                                (S.PRODUCT_CODE LIKE '#ListGetAt(attributes.product_cat,c,',')#.%')
                                <cfif C neq listlen(attributes.product_cat)>OR</cfif>
                                </cfloop>
                            )
                    </cfif>
                    <cfif isdefined("attributes.company_id") and len(attributes.company_id) and len(attributes.member_name)>
                        AND S.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> 
                    </cfif>
                    <cfif isdefined("attributes.start_date") and len(attributes.start_date)>
                        AND SR.PROCESS_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.start_date#"> 
                    </cfif>
                    <cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
                        AND SR.PROCESS_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finish_date#"> 
                    </cfif>
                UNION ALL
                SELECT
                    S.STOCK_ID,
                    S.PRODUCT_ID,
                    S.PRODUCT_NAME,
                    -1*SR.STOCK_IN SALE_AMOUNT
                FROM
                    STOCKS S,
                    #dsn2_alias#.STOCKS_ROW SR
                WHERE
                    S.STOCK_ID = SR.STOCK_ID
                    AND SR.PROCESS_TYPE = 74
                    <cfif isdefined("attributes.stock_id") and len(attributes.stock_id) and len(attributes.product_name)>
                        AND S.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#"> 
                    </cfif>
                    <cfif isdefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_manager)>
                        AND S.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#"> 
                    </cfif>
                    <cfif isdefined("attributes.brand_id") and len(attributes.brand_id) and len(attributes.brand_name)>
                        AND S.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#"> 
                    </cfif>
                    <cfif isdefined("attributes.short_code_id") and len(attributes.short_code_id) and len(attributes.short_code_name)>
                        AND S.SHORT_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.short_code_id#"> 
                    </cfif>				
                    <cfif isdefined("attributes.product_cat") and len(attributes.product_cat)>
                         AND
                            (
                                <cfloop from="1" to="#listlen(attributes.product_cat)#" index="c"> 
                                (S.PRODUCT_CODE LIKE '#ListGetAt(attributes.product_cat,c,',')#.%')
                                <cfif C neq listlen(attributes.product_cat)>OR</cfif>
                                </cfloop>
                            )
                    </cfif>
                    <cfif isdefined("attributes.company_id") and len(attributes.company_id) and len(attributes.member_name)>
                        AND S.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> 
                    </cfif>
                    <cfif isdefined("attributes.start_date") and len(attributes.start_date)>
                        AND SR.PROCESS_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.start_date#"> 
                    </cfif>
                    <cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
                        AND SR.PROCESS_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finish_date#"> 
                    </cfif>
            )T1
            GROUP BY
                STOCK_ID,
                PRODUCT_ID,
                PRODUCT_NAME	
        </cfquery>
    </cfif>
</cfif>  
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")> 
    <script language="javascript">
		function show_products()
		{
			add_assemption.show_products.value = 1;
			add_assemption.submit();
		}
		function calc_products_func(type)
		{
			method_name = list_getat("<cfoutput>#method_name_list#</cfoutput>",type);
			if(confirm("Seçilen Ürünler İçin "+method_name+" Yöntemi İle Hesaplama Yapılacak Emin misiniz?"))
			{
				add_assemption.method_type.value = type;
				add_assemption.submit();
			}
			else
				return false;
		}
		function kontrol_form()
		{
			if(add_assemption.product_cat.value.length == 0 && (add_assemption.short_code_id.value.length == 0 || add_assemption.short_code_name.value.length == 0) && (add_assemption.stock_id.value.length == 0 || add_assemption.product_name.value.length == 0) && (add_assemption.brand_id.value.length == 0 || add_assemption.brand_name.value.length == 0) && (add_assemption.pos_code.value.length == 0 || add_assemption.pos_manager.value.length == 0) && (add_assemption.company_id.value.length == 0 || add_assemption.member_name.value.length == 0))
			{
				alert("<cf_get_lang_main no='1538.En az bir alanda filtre etmelisiniz '>!");
				return false;
			}		
			else
				return true;
		}
	</script>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();	
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'prod.add_demand_assemption';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'production_plan/form/add_demand_assemption.cfm';
	WOStruct['#attributes.fuseaction#']['list']['default'] = 1;	
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'productDemandAssemptionController';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'list';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'CARI_ACTIONS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item1','item2','item3','item11','item12','item13']";
</cfscript>
