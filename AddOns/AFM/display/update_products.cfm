<cfset isStartInsert = false>
<cfset isMongoFind = false>
<cfif isMongoFind>
    <cfset GlobalB2BProductSearchV1 = application.mongo.getDBCollection( "GlobalB2BProductSearchV1" )>
    <cfscript>
        variables.mongoUtil = GlobalB2BProductSearchV1.getMongoUtil();
        x = mongoUtil.newIDCriteriaObject( "5f1df19dea8e1011084fe1ff");
        coll = GlobalB2BProductSearchV1.find(criteria = {"_id" = {"$gt" = x["_id"] }});        
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
    </cfscript>
    <!--- <cfdump var="#partDatas#" abort> --->
</cfif>
<cfif isStartInsert>
    <!---   <cfset afmSearch = CreateObject("component","cfc.AfmSearch")> 
            afmSearch.InsertAfmProducts(partDatas);
        
    --->
    <cfquery name="GET_PRODUCTS" datasource="#dsn1#">
        SELECT TOP(1) PRODUCT_ID FROM PRODUCT ORDER BY PRODUCT_ID DESC;
    </cfquery>
    <cfset product_count = GET_PRODUCTS.PRODUCT_ID+1>
    <cfloop query="partDatas">
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
                IS_LOT_NO
            )
        VALUES 
            (
                1,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#PartNumber#">,
                4,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#PartDescription#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="">,
                <cfqueryparam cfsqltype="cf_sql_integer" value=18>,
                <cfqueryparam cfsqltype="cf_sql_integer" value=18>,
                <cfqueryparam cfsqltype="cf_sql_integer" value=1>,
                <cfqueryparam cfsqltype="cf_sql_integer" value=0>,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="">,
                <cfqueryparam cfsqltype="cf_sql_integer" value=1>,
                <cfqueryparam cfsqltype="cf_sql_integer" value=1>,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#OemNumber#">,
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
                <cfqueryparam cfsqltype="cf_sql_integer" value=0>
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
                <cfqueryparam cfsqltype="cf_sql_varchar" value="">,
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
    <cfset product_count = product_count +1>
    </cfloop>
</cfif>
