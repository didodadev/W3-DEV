<!---
    File: AfmSearch.cfc
    Author: Kaan Salı - Alloversoft
    Date: 23.10.2020
    Description: Aftermarket Eklentisi için Arama, Solr Indexleme, Veritabanı işlemleri gibi işlemleri barındırır.
--->
<cfcomponent hint="Aftermarket Eklentisi için Arama, Solr Indexleme, Veritabanı işlemleri gibi işlemleri barındırır.">
    <cfset dsn = application.systemParam.systemParam().dsn>

    <!--- Arama işlemleri --->
    <cffunction name="SearchSolr" type="any" hint="Solr üstünde gönderilen dataya uygun arama yapar. Data yapısı bu şekilde olmalıdır: searchData = q:'Query String', category:'isteğe bağlı', categoryTree:'isteğe bağlı', collection : 'collectionAdı', maxRows : 20 }">
        <cfargument name="data" type="struct">
        <cftry>
            <cfsearch collection=#data.collection# name="qresult" criteria="#data.q#" suggestions="always" maxrows="#data.maxRows#">
            <cfreturn qresult>
            <cfcatch>
                <cfdump var="#cfcatch#">
            </cfcatch>
        </cftry>
    </cffunction> 

    <cffunction name="SearchByKeywordSolr" type="any" hint="Solr üstünde gönderilen queryi arar.">
        <cfargument name="query" type="string">
        <cfargument name="collection" type="string">
        <cfargument name="maxRows" type="integer" required="false">
        <cftry>
            <cfif isDefined("maxRows")>
                <cfsearch collection=#collection# name="qresult" criteria="contentsExact:#query#" maxrows="#maxRows#">
            <cfelse>
                <cfsearch collection=#collection# name="qresult" criteria="contentsExact:#query#" >
            </cfif>
            <cfreturn qresult>
            <cfcatch>
                <cfdump var="#cfcatch#">
            </cfcatch>
        </cftry>
    </cffunction> 

    <cffunction name="GetAfmProducts" type="any" hint="Index aramasında bulunan verileri workcube veritabanından getirir.">
        <cfargument name="searchKey" type="string">
        <cfargument name="maxRows" type="integer">
        <cfscript>
            searchData = {
                q:"#replace(replace(searchKey,'-',''),'.','')#",
                category:"Parts",
                categoryTree:"Bases",
                collection : "GlobalB2BProductSearchV1",
                maxRows : maxRows
            }
        </cfscript>
        <cfset SearchResult = SearchSolr(searchData)>
        <cfset SearchIdList = ""> 
        <cfoutput query="SearchResult">
            <cfset SearchIdList =  listAppend(SearchIdList, key)>
        </cfoutput>
        <cfquery name="Get_Products" datasource="#dsn#_product">
            SELECT 
                PRODUCT.PRODUCT_ID,
                PRODUCT_CODE,
                PRODUCT_NAME
            FROM
                PRODUCT,
                STOCKS
            WHERE
                PRODUCT.PRODUCT_ID IN (#SearchIdList#) AND
                STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID

        </cfquery>
        <cfreturn Get_Products>
    </cffunction>
    <!--- Solr Collection İşlemleri --->
    <cffunction name="RecreateSolrDatas" type="any" hint="Solr'da aktarılan datadaki key varsa o key'e ait verileri günceller, key bulunmayan veriyi indekse ekler.">
        <cfargument name="startIndex" type="integer" default=0>
        <cftry>
            <cfscript>
            coll = GlobalB2BProductSearchV1.find();
            result = coll.asArray();
            arrayEach(result,function(element,index){
                structDelete(element,'_id');
                structDelete(element,'Warehouse');
                structDelete(element,'DescriptionList');
                structDelete(element,'ManufacturerList');
                structDelete(element,'EngineCodeList');
                structDelete(element,'ManufacturerModel');
                structDelete(element,'ModelDescriptionList');
                structDelete(element,'IsStock');
                structInsert(element,'Id',index+startIndex);
                structUpdate(element,'AlternativeList',arrayToList(element.AlternativeList));
            });
            baseDatas = {
                result: "#replace(serializeJSON(result),"/","","all")#", // Mongodan gelecek datalar eklenecek. Örnek {Bez: item["Bez"],KTypeNr: item["KTypeNr"]} 
                columns: "Id,PartNumber,PartDescription,Image,BrandName,BrandId,TecDocId,SearchKey,OemNo,StockCode,AlternativeList", //Warehouse,DescriptionList,ManufacturerList,EngineCodeList,AlternativeList,ManufacturerModel (Tamamı Liste şeklinde, aktarım araştırılacak) 
                columnTypes: "Integer,Varchar,Varchar,Varchar,Varchar,Varchar,Integer,Varchar,Varchar,Varchar,Varchar", //Array,Array,Array,Array,Array,Array,Array
                collectionName: "GlobalB2BProductSearchV1", //Hangi koleksiyon ismi kullanılacaksa o yazılacak.
                categoryTree: "Bases", //Verilerin bulunacağı ana kategori ismi
                category: "Parts", //Verilerin bulunacağı alt kategori ismi - Araç markası kullanılabilir
                key: "Id" //Primary Key
            }
            </cfscript>

            <cfset response = deserializeJSON(baseDatas.result)>   
            <cfset queryVar=queryNew(baseDatas.columns,baseDatas.columnTypes,response)> <!--- [{},{}] ---><!--- "Id,Adı,Soyadı" ---><!--- "Integer,Varchar" --->
            <cfindex collection=#baseDatas.collectionName# action="update" query="queryVar" body="#baseDatas.columns#" key=#baseDatas.key# status="status" type="custom" categoryTree="#baseDatas.categoryTree#" category="#baseDatas.category#" custom1="SearchKey" title="PartNumber">
            <cfcatch type="any">
                <cfdump var="#cfcatch.message#">
            </cfcatch>
        </cftry>
    </cffunction>
    <cffunction name="RecreateCollection" type="any" hint="Solr'daki koleksiyonu siler, boş olarak tekrar oluşturur.">
        <cfargument name="collectionName" type="string">
        <cfcollection action="list" collection="#collectionName#" name="collectionExists" />
        <cfif collectionExists.recordCount>
            <cfcollection action="delete" collection="#collectionName#">
        </cfif>
        <cfcollection action="create" categories="true" collection="#collectionName#">
    </cffunction>
    <!--- Db İşlemleri --->
    <cffunction name="InsertAfmProducts" type="any" hint="Afm projesine ait olan verileri gerekli tablolara ekler.">
        <cfargument name="partList" type="query">
        <cfargument name="product_cat_id" type="integer" default="">
        <cfargument name="acc_code_cat" type="integer" default="">
        
        <cfquery name="GET_PRODUCTS" datasource="#dsn1#">
            SELECT TOP(1) PRODUCT_ID FROM PRODUCT ORDER BY PRODUCT_ID DESC;
        </cfquery>
        <cfset product_count = GET_PRODUCTS.PRODUCT_ID+1>
        <cfloop query="partList">
        <cfquery name="ADD_PRODUCT" datasource="#dsn1#">
            INSERT INTO 
            PRODUCT
                (
                    PRODUCT_STATUS,
                    PRODUCT_CODE,
                    PRODUCT_CATID,
                    BARCOD,
                    PRODUCT_NAME,
                    PRODUCT_DETAIL,
                    PRODUCT_DETAIL2,
                    TAX,
                    TAX_PURCHASE,
                    IS_INVENTORY,
                    IS_PRODUCTION,
                    SHELF_LIFE,
                    IS_SALES,
                    IS_PURCHASE,
                    MANUFACT_CODE,
                    IS_PROTOTYPE,
                    IS_INTERNET,
                    PRODUCT_STAGE,
                    IS_TERAZI,
                    IS_SERIAL_NO,
                    IS_ZERO_STOCK,
                    MIN_MARGIN,
                    MAX_MARGIN,
                    IS_KARMA,
                    IS_COST,
                    IS_EXTRANET,
                    RECORD_MEMBER,
                    RECORD_DATE,
                    MEMBER_TYPE,
                    PACKAGE_CONTROL_TYPE,
                    IS_LIMITED_STOCK,
                    IS_COMMISSION,
                    IS_ADD_XML,
                    IS_GIFT_CARD,
                    GIFT_VALID_DAY,
                    IS_QUALITY,
                    IS_LOT_NO,
                    BRAND_ID
                )
            VALUES 
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#PartNumber#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#product_cat_id#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#PartDescription#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#TecDocId#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value=18>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value=18>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value=1>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value=0>,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value=1>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value=1>,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#OemNo#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value=0>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value=0>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value=65>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value=0>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value=0>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value=0>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value=0>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value=0>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value=0>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value=1>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value=0>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="e-#session.ep.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value=1>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value=0>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value=0>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value=0>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value=0>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value=0>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value=0>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value=0>,
                    (SELECT TOP(1) BRAND_ID FROM PRODUCT_BRANDS WHERE BRAND_CODE = #BrandId#)
                )
        </cfquery>
        <cfquery name="ADD_STOCKS" datasource="#dsn1#">
            INSERT INTO
            STOCKS
                (
                    STOCK_CODE,
                    PRODUCT_ID,
                    PROPERTY,
                    BARCOD,
                    PRODUCT_UNIT_ID,
                    MANUFACT_CODE,
                    STOCK_STATUS,
                    RECORD_EMP,
                    RECORD_IP,
                    RECORD_DATE,
                    UPDATE_EMP,
                    UPDATE_IP,
                    UPDATE_DATE,
                    SERIAL_BARCOD
                )
            VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#PartNumber#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#product_count#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#product_count#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#OemNo#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value=1>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value='#cgi.remote_addr#'>,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                    NULL,
                    NULL,
                    NULL,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="">
                )
        </cfquery>
        <cfquery name="ADD_PRODUCT_OUR_COMPANY" datasource = "#dsn1#">
            INSERT INTO 
            PRODUCT_OUR_COMPANY
                (
                    PRODUCT_ID,
                    OUR_COMPANY_ID
                ) 
            VALUES 
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#product_count#">,
                    1
                )
        </cfquery>
        <cfquery name="ADD_PRODUCT_UNIT" datasource="#dsn1#">
            INSERT INTO 
            PRODUCT_UNIT 
            (
                PRODUCT_UNIT_STATUS,
                PRODUCT_ID,
                MAIN_UNIT_ID,
                MAIN_UNIT,
                UNIT_ID,
                ADD_UNIT,
                MULTIPLIER,
                DIMENTION,
                IS_MAIN,
                IS_SHIP_UNIT,
                QUANTITY
            )
            VALUES 
            (
                1,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#product_count#">,
                1,
                'Adet',
                1,
                'Adet',
                1,
                '',
                1,
                0,
                1
            )
        </cfquery>
        <cfquery name="ADD_PRICE_STANDART" datasource="#dsn1#">
            INSERT INTO 
                PRICE_STANDART
                (
                    PRICESTANDART_STATUS,
                    PRODUCT_ID,
                    PURCHASESALES,
                    PRICE,
                    PRICE_KDV,
                    IS_KDV,
                    ROUNDING,
                    [MONEY],
                    UNIT_ID,
                    [START_DATE],
                    [RECORD_DATE],
                    [RECORD_IP],
                    [RECORD_EMP]
                ) 
                VALUES
                (
                    1,
                    #product_count#,
                    0,
                    0,
                    0,
                    0,
                    0,
                    'TL',
                    #product_count#,
                    getdate(),
                    getdate(),
                    NULL,
                    2
                ),
                (
                    1,
                    #product_count#,
                    1,
                    0,
                    0,
                    0,
                    0,
                    'TL',
                    #product_count#,
                    getdate(),
                    getdate(),
                    NULL,
                    2
                )
        </cfquery>
        <!--- Ürüne Ait Stok Sayısını Getirtmek gerekli. Wizard sırasında departman adı ve lokasyonu değiştirilecek unutulmasın --->
        <cfif stockCount neq 0>
        <cfquery name="ADD_STOCKS_ROWS" datasource="#dsn1#">
            INSERT INTO STOCKS_ROW
            (
                STOCK_ID,
                PRODUCT_ID,
                PROCESS_TYPE,
                STOCK_IN,
                STOCK_OUT,
                STORE,
                STORE_LOCATION
            ) 
            VALUES
            (
                #product_count#,
                #product_count#,
                76,
                #stockCount#,
                0,
                #stockDepartment#,
                #stockDepartmentLocation#
            )
        </cfquery>
        <cfquery name="GET_CODES" datasource="#DSN3#">
            SELECT * FROM SETUP_PRODUCT_PERIOD_CAT WHERE IS_ACTIVE = 1 AND PRO_CODE_CATID = #acc_code_cat#
        </cfquery>
        <cfquery name="ADD_PRODUCT_PERIOD" datasource="#dsn3#">
            INSERT INTO PRODUCT_PERIOD
			(
				PRODUCT_ID,  
				PERIOD_ID,
				ACCOUNT_CODE,
				ACCOUNT_CODE_PUR,
				ACCOUNT_DISCOUNT, 
				ACCOUNT_PRICE ,
				ACCOUNT_PUR_IADE, 
				ACCOUNT_IADE,
				ACCOUNT_DISCOUNT_PUR,
				ACCOUNT_YURTDISI,
				ACCOUNT_YURTDISI_PUR,
				EXPENSE_CENTER_ID,
				EXPENSE_ITEM_ID ,
				INCOME_ITEM_ID,
				EXPENSE_TEMPLATE_ID,
				ACTIVITY_TYPE_ID ,
				COST_EXPENSE_CENTER_ID ,
				INCOME_ACTIVITY_TYPE_ID ,
				INCOME_TEMPLATE_ID,
				ACCOUNT_LOSS ,
				ACCOUNT_EXPENDITURE,
				OVER_COUNT ,
				UNDER_COUNT,
				PRODUCTION_COST ,
				HALF_PRODUCTION_COST,
				SALE_PRODUCT_COST ,
				MATERIAL_CODE,
				KONSINYE_PUR_CODE ,
				KONSINYE_SALE_CODE,
				KONSINYE_SALE_NAZ_CODE,
				DIMM_CODE,
				DIMM_YANS_CODE,
				PROMOTION_CODE,
				PRODUCT_PERIOD_CAT_ID,
				ACCOUNT_PRICE_PUR,
				MATERIAL_CODE_SALE,
				PRODUCTION_COST_SALE,
				SALE_MANUFACTURED_COST,
				PROVIDED_PROGRESS_CODE,
				SCRAP_CODE_SALE,
				SCRAP_CODE,
				PROD_GENERAL_CODE,
				PROD_LABOR_COST_CODE,
				RECEIVED_PROGRESS_CODE,
				INVENTORY_CAT_ID,
				INVENTORY_CODE,
				AMORTIZATION_METHOD_ID,
				AMORTIZATION_TYPE_ID,
				AMORTIZATION_EXP_CENTER_ID,
				AMORTIZATION_EXP_ITEM_ID,
				AMORTIZATION_CODE,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#product_count#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.PERIOD_ID#"> ,
				<cfif len(GET_CODES.ACCOUNT_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfif len(GET_CODES.ACCOUNT_CODE_PUR)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_CODE_PUR#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfif len(GET_CODES.ACCOUNT_DISCOUNT)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_DISCOUNT#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfif len(GET_CODES.ACCOUNT_PRICE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_PRICE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfif len(GET_CODES.ACCOUNT_PUR_IADE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_PUR_IADE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfif len(GET_CODES.ACCOUNT_IADE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_IADE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfif len(GET_CODES.ACCOUNT_DISCOUNT_PUR)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_DISCOUNT_PUR#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfif len(GET_CODES.ACCOUNT_YURTDISI)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_YURTDISI#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfif len(GET_CODES.ACCOUNT_YURTDISI_PUR)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_YURTDISI_PUR#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfif len(GET_CODES.INC_CENTER_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.INC_CENTER_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,			
				<cfif len(GET_CODES.EXP_ITEM_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.EXP_ITEM_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
				<cfif len(GET_CODES.INC_ITEM_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.INC_ITEM_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
				<cfif len(GET_CODES.EXP_TEMPLATE_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.EXP_TEMPLATE_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,  
				<cfif len(GET_CODES.EXP_ACTIVITY_TYPE_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.EXP_ACTIVITY_TYPE_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,		 
				<cfif len(GET_CODES.EXP_CENTER_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.EXP_CENTER_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>, 
				<cfif len(GET_CODES.INC_ACTIVITY_TYPE_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.INC_ACTIVITY_TYPE_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,	
				<cfif len(GET_CODES.INC_TEMPLATE_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.INC_TEMPLATE_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
				<cfif len(GET_CODES.ACCOUNT_LOSS)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_LOSS#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfif len(GET_CODES.ACCOUNT_EXPENDITURE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_EXPENDITURE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfif len(GET_CODES.OVER_COUNT)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.OVER_COUNT#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfif len(GET_CODES.UNDER_COUNT)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.UNDER_COUNT#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfif len(GET_CODES.PRODUCTION_COST)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PRODUCTION_COST#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,	
				<cfif len(GET_CODES.HALF_PRODUCTION_COST)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.HALF_PRODUCTION_COST#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfif len(GET_CODES.SALE_PRODUCT_COST)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.SALE_PRODUCT_COST#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,					 
				<cfif len(GET_CODES.MATERIAL_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.MATERIAL_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfif len(GET_CODES.KONSINYE_PUR_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.KONSINYE_PUR_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfif len(GET_CODES.KONSINYE_SALE_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.KONSINYE_SALE_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfif len(GET_CODES.KONSINYE_SALE_NAZ_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.KONSINYE_SALE_NAZ_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfif len(GET_CODES.DIMM_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.DIMM_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfif len(GET_CODES.DIMM_YANS_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.DIMM_YANS_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfif len(GET_CODES.PROMOTION_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PROMOTION_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfif isdefined('acc_code_cat') and len(acc_code_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#acc_code_cat#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
				<cfif len(GET_CODES.ACCOUNT_PRICE_PUR)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_PRICE_PUR#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfif len(GET_CODES.MATERIAL_CODE_SALE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.MATERIAL_CODE_SALE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfif len(GET_CODES.PRODUCTION_COST_SALE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PRODUCTION_COST_SALE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfif len(GET_CODES.SALE_MANUFACTURED_COST)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.SALE_MANUFACTURED_COST#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfif len(GET_CODES.PROVIDED_PROGRESS_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PROVIDED_PROGRESS_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfif len(GET_CODES.SCRAP_CODE_SALE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.SCRAP_CODE_SALE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfif len(GET_CODES.SCRAP_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.SCRAP_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfif len(GET_CODES.PROD_GENERAL_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PROD_GENERAL_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfif len(GET_CODES.PROD_LABOR_COST_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PROD_LABOR_COST_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfif len(GET_CODES.RECEIVED_PROGRESS_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.RECEIVED_PROGRESS_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfif len(GET_CODES.INVENTORY_CAT_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.INVENTORY_CAT_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfif len(GET_CODES.INVENTORY_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.INVENTORY_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfif len(GET_CODES.AMORTIZATION_METHOD_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_METHOD_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfif len(GET_CODES.AMORTIZATION_TYPE_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_TYPE_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfif len(GET_CODES.AMORTIZATION_EXP_CENTER_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_EXP_CENTER_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfif len(GET_CODES.AMORTIZATION_EXP_ITEM_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_EXP_ITEM_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfif len(GET_CODES.AMORTIZATION_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTEADDR#">
        </cfquery>
        </cfif>
        <cfset product_count = product_count +1>
        </cfloop>
    </cffunction>
    <cffunction name="InsertAlternatives" type="any" hint="Afm projesine ait olan parçaların alternatiflerini yükler. Bu işlem uzun zaman alabilir! (1-2 saat)">
        <!---     <cfquery name="Delete_alternatives" datasource="#dsn#_1">
            DELETE FROM
            ALTERNATIVE_PRODUCTS
        </cfquery> --->
        <cfquery name="Get_Products" datasource="#dsn#_product">
            SELECT
                PRODUCT_ID,
                PRODUCT_CODE
            FROM 
                PRODUCT
            ORDER BY PRODUCT_ID
        </cfquery>
        <cfoutput query="Get_Products">
            <cfset Alternatives = SearchByKeywordSolr('"#PRODUCT_CODE#"',"GlobalB2BProductSearchV1")>
            <cfset Alternatives = queryFilter(Alternatives,function(alternative){return alternative.title != Get_Products.PRODUCT_CODE})>
                <cfloop query="Alternatives">
                    <cfquery name="add_alternative" datasource="#dsn#_1">
                        INSERT INTO ALTERNATIVE_PRODUCTS
                            (
                                PRODUCT_ID,
                                STOCK_ID,
                                ALTERNATIVE_PRODUCT_ID,
                                RECORD_DATE,
                                RECORD_EMP
                            )
                        VALUES
                            (
                                #Get_Products.PRODUCT_ID#,
                                #Key#,
                                #Key#,
                                #NOW()#,
                                #session.ep.userid#
                            )
                    </cfquery>
                </cfloop>
        </cfoutput>
        <cfreturn "İşlem başarıyla gerçekleştirildi">
    </cffunction>
    <cffunction name="InsertBrands" type="any" hint="Afm projesine ait olan markaları sisteme ekler.">
        <cfset GlobalB2BProductSearchV1 = application.mongo.getDBCollection( "GlobalB2BProductSearchV1" )>
        <cfset BrandList = GlobalB2BProductSearchV1.aggregate({"$group": {"_id":{"BrandName": '$BrandName',"BrandId": '$BrandId'}}},{"$sort" : {"_id.BrandId": 1}}).asArray()>
        <cfloop array="#BrandList#" index="i" item="BrandData">
            <cfquery name="Insert_Brands" datasource="#dsn#_product">
                INSERT INTO
                    PRODUCT_BRANDS
                    (
                        BRAND_NAME,
                        BRAND_CODE,
                        IS_ACTIVE,
                        IS_INTERNET,
                        RECORD_EMP,
                        RECORD_DATE,
                        RECORD_IP
                    )
                VALUES
                    (
                        '#BrandData._id["BrandName"]#',
                        '#BrandData._id["BrandId"]#',
                        1,
                        1,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value='#cgi.remote_addr#'>
                    )
            </cfquery>   
            <cfquery name="Insert_Brand_Our_Company" datasource="#dsn#_product">
                INSERT INTO
                    PRODUCT_BRANDS_OUR_COMPANY
                    (
                        BRAND_ID,
                        OUR_COMPANY_ID
                    )
                VALUES
                    (
                        #i#,
                        1
                    )
            </cfquery>
        </cfloop>
    </cffunction>
    <cffunction name="CreateAfmProject" type="any" hint="Tüm projeyi oluşturur.Sırasıyla : Solr Index oluşturma, Veritabanına markaları yazdırma, parçaları yazdırma, alternatifleri yazdırma, stokları ekleme işlemini gerçekleştirir.">
        <cfargument name="collectionName" type="string">
        <cfargument name="product_cat_id" type="integer" default="">
        <cfargument name="acc_code_cat" type="integer" default="">
        <cfscript>
            RecreateCollection(collectionName);
            RecreateSolrDatas(); // Verileri Solr'a indexler, kaydedilmiş verilerden Key ile parça idsi eşleşecek. O yüzden önce atılması önemlidir.
            InsertBrands(); // Markalar parçalardan önce aktarılmalı, yoksa parçaların markaları tek tek verilmelidir.
            GlobalB2BProductSearchV1 = application.mongo.getDBCollection( "GlobalB2BProductSearchV1" ); 
            coll = GlobalB2BProductSearchV1.find();
            result = coll.asArray();
            arrayEach(result,function(element,index){
                structDelete(element,'_id');
                structDelete(element,'Warehouse');
                structDelete(element,'DescriptionList');
                structDelete(element,'ManufacturerList');
                structDelete(element,'EngineCodeList');
                structDelete(element,'ManufacturerModel');
                structDelete(element,'ModelDescriptionList');
                structDelete(element,'IsStock');
                structDelete(element,'BrandId');
                structDelete(element,'Image');
                structDelete(element,'SearchKey');
                structDelete(element,'StockCode');
                structUpdate(element,'AlternativeList',arrayToList(element.AlternativeList));
            });
            partDatas = queryNew("PartNumber,PartDescription,AlternativeList,OemNumber,BrandName,TecDocId","Varchar,Varchar,Varchar,Varchar,Varchar,Integer",result);     
            InsertAfmProducts(partDatas,product_cat_id,acc_code_cat);
            InsertAlternatives();
        </cfscript>
    </cffunction>
</cfcomponent>