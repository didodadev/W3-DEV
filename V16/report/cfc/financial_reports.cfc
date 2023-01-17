<cfcomponent>
	<!--- Ürün Muhasebe Kodları Raporu Excel Fonksiyonu SK20151124 --->
    <!--- 
		select_list : select_option inputundan gelen değerler için çekilecek extra sütun listesi
		columnlistfromxml : select_option inputundan gelen değerler için çekilecek extra sütunların adlarının listesi (dil setinden geliyor)
		querycolumns : Default olarak çekilen sütunlar
		columnList : Default çekilen sütunların adlarının listesi (dil setinden geliyor)
	--->
	<cffunction name="getProductAccountCode" access="public" returntype="any">
        <cfargument name="employee">
        <cfargument name="employee_id">
        <cfargument name="product">
        <cfargument name="product_id">
        <cfargument name="product_cat">
        <cfargument name="product_cat_code">
        <cfargument name="stock_id">
        <cfargument name="has_account_code">
        <cfargument name="is_active">
        <cfargument name="select_option">
        <cfargument name="is_excel">
        <cfargument name="get_date">
        <cfargument name="list_account">
        <cfargument name="list">
        <cfargument name="x_select_option">
        <cfargument name="select_list">
        <cfargument name="columnlistfromxml">
        <cfargument name="columnList">
        <cfset dsn3 = this.dsn3>
        <cfset dsn_alias = this.dsn_alias>
        <cfset dsn2_alias = this.dsn2_alias>
        <cfset querycolumns = "ROWNUM, PRODUCT_CAT, HIERARCHY ,PRODUCT_NAME, PRODUCT_CODE, BARCOD, TAX, TAX_PURCHASE, ACCOUNT_CODE, ACCOUNT_CODE_PUR, ACCOUNT_DISCOUNT, ACCOUNT_DISCOUNT_PUR, ACCOUNT_IADE, ACCOUNT_PUR_IADE, ACCOUNT_PRICE, ACCOUNT_PRICE_PUR, ACCOUNT_YURTDISI, ACCOUNT_YURTDISI_PUR, MATERIAL_CODE_SALE, ACCOUNT_LOSS, ACCOUNT_EXPENDITURE, OVER_COUNT, UNDER_COUNT, PRODUCTION_COST_SALE, PRODUCTION_COST, HALF_PRODUCTION_COST, SALE_MANUFACTURED_COST, KONSINYE_PUR_CODE, KONSINYE_SALE_CODE, KONSINYE_SALE_NAZ_CODE, SCRAP_CODE_SALE, SCRAP_CODE, DIMM_CODE, DIMM_YANS_CODE, PROMOTION_CODE, PROD_GENERAL_CODE, PROD_LABOR_COST_CODE, MATERIAL_CODE, SALE_PRODUCT_COST, RECEIVED_PROGRESS_CODE, PROVIDED_PROGRESS_CODE, GIDER_MERKEZI, GIDER_KALEMI, GIDER_AKTIVITE_TIPI, GIDER_SABLONU, GELIR_MERKEZI, GELIR_KALEMI, GELIR_AKTIVITE_TIPI, GELIR_SABLONU">
        <cftry>
            <cfset sheet = 1>
			<cfset sheetsize = 60000>
            <cfset querycount = 75000>
            <cfset uuid=CreateUUID()>
			<cfscript>
                prepareDirectory(this.upload_folder);
            </cfscript>
			<cfloop condition="sheet lte (Int(querycount/sheetsize)+1)">
                <cfset startrow = (sheet-1)*sheetsize +1>
                <cfset maxrows = sheet * sheetsize>
                <cfif maxrows gt querycount>
                	<cfset maxrows = querycount>
                </cfif>
                <cfset columnCountFromXml = 0>
                <cfquery name="GET_PRODUCT" datasource="#DSN3#">
                    WITH CTE1 AS(   
                        SELECT   
                            PRODUCT_STATUS,
                            IS_INVENTORY,
                            P.IS_PRODUCTION,
                            IS_SALES,
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
                            ROW_NUMBER() OVER (ORDER BY P.PRODUCT_ID) ROWNUM
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
                        WHERE
                            P.PRODUCT_ID IS NOT NULL
                            <cfif len(arguments.product) and len(arguments.product_id)>AND P.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"></cfif>
                            <cfif len(arguments.employee) and len(arguments.employee_id)>AND P.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#"></cfif>
                            <cfif len(arguments.is_active) and (arguments.is_active eq 2)>AND P.PRODUCT_STATUS = 1
                            <cfelseif len(arguments.is_active) and (arguments.is_active eq 3)>AND P.PRODUCT_STATUS = 0</cfif>
                            <cfif len(arguments.get_date)>AND P.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.get_date#"></cfif>
                            <cfif len(arguments.has_account_code)>
                            <cfif arguments.has_account_code eq 1>
                                AND P.PRODUCT_ID IN 
                                    (SELECT 
                                        PRODUCT_ID 
                                    FROM 
                                        PRODUCT_PERIOD 
                                    WHERE 
                                        <cfif isdefined("arguments.list_account")>
                                            <cfloop list="#arguments.list#" index="liste_">
                                                <cfif (arguments.list_account eq liste_) or (arguments.list_account eq '')>
                                                    #uCase(liste_)# IS NOT NULL AND
                                                </cfif>
                                            </cfloop>
                                        </cfif>
                                        PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">)
                            <cfelseif arguments.has_account_code eq 0>
                                AND P.PRODUCT_ID NOT IN
                                    (SELECT PRODUCT_ID FROM PRODUCT_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">)
                            </cfif>
                        </cfif>
                        <cfif len(arguments.product_cat_code)>AND (PC.HIERARCHY = '#arguments.product_cat_code#' OR PC.HIERARCHY LIKE '#arguments.product_cat_code#%')</cfif>
                        )
                        SELECT
                            <cfloop from="1" to="49" index="j">
                                CONVERT(VARCHAR(50),#ListGetAt(querycolumns,j)#) + ' ' '#ListGetAt(columnList,j)#' , <!--- CONVERT(VARCHAR(50),#ListGetAt(querycolumns,j)#) + ' ' bu boşluk Alt + 255 ile oluşturuldu. Yazılmadığında ya da normal boşluk karakteri yazıldığında excele text olarak yazmıyor, kodları sayıya çeviriyor.--->
                            </cfloop>
                            <cfif arguments.x_select_option eq 1>
                                <cfloop from="1" to="17" index="i">
                                    <cfif ListFind(arguments.select_option,i)>
                                        <cfif i eq 1>
                                            CASE WHEN #UCase(ListGetAt(select_list,1))# = 1 THEN 'Aktif' ELSE 'Pasif' END AS '#ListGetAt(arguments.columnlistfromxml,1)#' ,
                                        <cfelse>
                                            CASE WHEN #UCase(ListGetAt(select_list,i))# = 1 THEN 'Evet' ELSE 'Hayır' END AS '#ListGetAt(arguments.columnlistfromxml,i)#' ,
                                        </cfif>
                                        <cfset columnCountFromXml+=1>
                                    </cfif>
                                </cfloop>
                            </cfif>
                            (SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                        FROM
                            CTE1
                        WHERE
                            ROWNUM BETWEEN #startrow# AND #maxrows#
                     </cfquery>
    				<cfset querycount = GET_PRODUCT.QUERY_COUNT>
					<cfset tempPath = GetTempDirectory() & CreateUUID() & ".xls">
                    <cfspreadsheet action="write" filename="#tempPath#" query="GET_PRODUCT" sheetname="Product Account Codes #sheet#" overwrite="true">
					<cfscript>
                        var PACSheet = SpreadsheetRead(tempPath);
						columncount = listlen(columnList,',') + columnCountFromXml;
						SpreadsheetDeleteColumn(PACSheet, columncount+1);
                    </cfscript>
                    <cfspreadsheet action="write" filename="#this.upload_folder#/reserve_files/#session.ep.userid#/product_account_codes_#sheet#.xls" name="PACSheet" sheetname="Product Account Codes #sheet#" overwrite=true>
                 	<cfset sheet = sheet +1>
             	</cfloop>
                <cfzip file="#this.upload_folder#/reserve_files/#session.ep.userid#/product_account_codes_#session.ep.userid#.zip" action="zip" 
                  source="#this.upload_folder#/reserve_files/#session.ep.userid#" 
                  recurse="No" >
                <script type="text/javascript">
                   <cfoutput>
                       get_wrk_message_div("Zip","Zip","/documents/reserve_files/#session.ep.userid#/product_account_codes_#session.ep.userid#.zip") ;
                   </cfoutput>
                </script>
                <cfcatch>
                    
                </cfcatch>
        	</cftry>
		<cfreturn get_product>
	</cffunction>
    <cffunction name="prepareDirectory" access="private" returntype="any">
    	<cfargument name="upload_folder">
        <cftry>
			<cfif DirectoryExists("#this.upload_folder#reserve_files/#session.ep.userid#")>
                <cfdirectory action="delete" directory="#this.upload_folder#reserve_files/#session.ep.userid#" recurse="yes">
            </cfif>
            <cfset Sleep(3000)>
            <cfdirectory action="create" directory="#this.upload_folder#reserve_files/#session.ep.userid#">
        <cfcatch>
            <script type="text/javascript">
                alert('Klasorlerin silinmesi/olusturulmasi sirasinda bir hata olustu. Dosyalar ya da klasorler kullanimda olabilir.');
                window.history.back();
            </script>
        	<cfabort>
        </cfcatch>
        </cftry>
    </cffunction>
</cfcomponent>
