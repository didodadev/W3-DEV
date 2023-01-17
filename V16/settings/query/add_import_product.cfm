<!---kayıt işlemleri---->
<cfset bugun_00 = DateFormat(now(),dateformat_style)>
<cf_date tarih='bugun_00'>

<cfquery name="GET_PRODUCT_NO" datasource="#DSN1#">
	SELECT MAX(PRODUCT_NO) AS URUN_NO FROM PRODUCT_NO
</cfquery>

<cfif get_product_no.recordcount and len(get_product_no.urun_no)>
	<cfset attributes.urun_no=get_product_no.urun_no>
<cfelse>
	<cfset attributes.urun_no="10000">
</cfif>

<cfquery name="GET_PRODUCT_NO" datasource="#DSN1#">
	UPDATE PRODUCT_NO SET PRODUCT_NO = #attributes.urun_no+1#
</cfquery>

<cfif len(attributes.hierarchy)>
    <cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
		SELECT HIERARCHY,STOCK_CODE_COUNTER FROM PRODUCT_CAT WHERE HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.hierarchy#">
    </cfquery>
    <cfif not (len(get_product_cat.stock_code_counter) And get_product_cat.stock_code_counter neq 0) >
        <cfset attributes.product_code = attributes.hierarchy&"."&attributes.urun_no>
    <cfelse>
		<cfset attributes.product_code = attributes.hierarchy&"."&get_product_cat.stock_code_counter>
		<cfquery name="upd_stock_code_counter" datasource="#DSN1#">
			UPDATE PRODUCT_CAT 
			SET 
			STOCK_CODE_COUNTER = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_cat.stock_code_counter+1#">
			WHERE HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.hierarchy#">
		</cfquery>
	</cfif>
<cfelse>
	<cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
		SELECT HIERARCHY,STOCK_CODE_COUNTER FROM PRODUCT_CAT WHERE PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#kategori_id#">
    </cfquery>
    <cfif not (len(get_product_cat.stock_code_counter) And get_product_cat.stock_code_counter neq 0) >
        <cfset attributes.product_code=get_product_cat.hierarchy&"."&attributes.urun_no>
    <cfelse>
		<cfset attributes.product_code = get_product_cat.hierarchy&"."&get_product_cat.stock_code_counter>
		<cfquery name="upd_stock_code_counter" datasource="#DSN1#">
			UPDATE PRODUCT_CAT 
			SET 
			STOCK_CODE_COUNTER = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_cat.stock_code_counter+1#">
			WHERE PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#kategori_id#">
		</cfquery>
	</cfif>
</cfif>
<cfif IsDefined('uye_kodu') and len(uye_kodu)>
	<!--- company_id --->
	<cfquery name="GET_COMPANY" datasource="#DSN1#">
		SELECT COMPANY_ID FROM #dsn#.COMPANY WHERE MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uye_kodu#">
	</cfquery>
	<cfset attributes.company_id=get_company.company_id>
<cfelse>
	<!---default company_id--->
	<cfset attributes.company_id="">
</cfif>

<cfif len(short_code_id)>
	<cfquery name="GET_SHORT_CODE" datasource="#DSN1#">
		SELECT MODEL_CODE FROM PRODUCT_BRANDS_MODEL WHERE MODEL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#short_code_id#">
	</cfquery>
	<cfif get_short_code.recordcount>
		<cfset short_code = get_short_code.model_code>
	<cfelse>
		<cfset short_code = "">
	</cfif>
</cfif>

<cfquery name="ADD_PRODUCT" datasource="#DSN1#">
	INSERT INTO
		PRODUCT
	(
		PRODUCT_STATUS,
		<cfif len(attributes.company_id)>COMPANY_ID,</cfif>
		PRODUCT_CATID,
		PRODUCT_CODE,
		BARCOD,
		PRODUCT_NAME,
		PRODUCT_DETAIL,
		PRODUCT_DETAIL2,
		TAX,
		TAX_PURCHASE,
		IS_INVENTORY,
		IS_PRODUCTION,
		IS_SALES,
		IS_PURCHASE,
		IS_PROTOTYPE,
		IS_INTERNET,
        IS_EXTRANET,
		IS_COST,			
		PRODUCT_STAGE,
		IS_TERAZI,
		IS_SERIAL_NO,
		IS_ZERO_STOCK,
		IS_KARMA,
		RECORD_DATE,
		RECORD_MEMBER,
		MEMBER_TYPE,
		PROD_COMPETITIVE,
		MANUFACT_CODE,
		BRAND_ID,
		SHORT_CODE,
		SHORT_CODE_ID,
		PRODUCT_CODE_2,
        IS_LIMITED_STOCK,
        IS_QUALITY,
        MIN_MARGIN,
        MAX_MARGIN,
        SHELF_LIFE,
        SEGMENT_ID,
		BSMV,
		OIV
	)
	VALUES
	(  
		<cfqueryparam cfsqltype="cf_sql_bit" value="1">,
		<cfif len(attributes.company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">,</cfif>    
		<cfqueryparam cfsqltype="cf_sql_integer" value="#kategori_id#">,
		<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.PRODUCT_CODE#">,
		<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#barcode_no#">,
		<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#urun_adi#">,
		<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#detail#">,
		<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#detail_2#">,
		<cfqueryparam cfsqltype="cf_sql_float" value="#satis_kdv#">,
		<cfqueryparam cfsqltype="cf_sql_float" value="#alis_kdv#">,
		<cfif len(is_inventory) and is_inventory eq 1><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelseif len(is_inventory) and is_inventory eq 0><cfqueryparam cfsqltype="cf_sql_bit" value="0"><cfelseif len(barcode_no)><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
		<cfif len(is_production)><cfqueryparam cfsqltype="cf_sql_bit" value="#is_production#"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
		<cfif len(is_sales)><cfqueryparam cfsqltype="cf_sql_bit" value="#is_sales#"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
		<cfif len(is_purchase)><cfqueryparam cfsqltype="cf_sql_bit" value="#is_purchase#"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
		<cfqueryparam cfsqltype="cf_sql_bit" value="0">,
		<cfif len(is_internet)><cfqueryparam cfsqltype="cf_sql_bit" value="#is_internet#"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
        <cfif len(is_extranet)><cfqueryparam cfsqltype="cf_sql_bit" value="#is_extranet#"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
		<cfqueryparam cfsqltype="cf_sql_bit" value="1">,			
		<cfif len(surec_id)><cfqueryparam cfsqltype="cf_sql_bit" value="#surec_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="1"></cfif>,
		<cfif birim is "KG"><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
		<cfqueryparam cfsqltype="cf_sql_bit" value="0">,
		<cfif len(is_zero_stock)><cfqueryparam cfsqltype="cf_sql_bit" value="#is_zero_stock#"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
		<cfqueryparam cfsqltype="cf_sql_bit" value="0">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">,
		<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#SESSION.EP.USERKEY#">,
		<cfif len(fiyat_yetkisi)><cfqueryparam cfsqltype="cf_sql_bit" value="#fiyat_yetkisi#"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="1"></cfif>,
		<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#uretici_urun_kodu#">,
		<cfif len(brand_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#brand_id#"><cfelse>NULL</cfif>,
		<cfif len(short_code_id)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#short_code#"><cfelse>NULL</cfif>,
		<cfif len(short_code_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#short_code_id#"><cfelse>NULL</cfif>,
		<cfif len(product_code_2)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#product_code_2#"><cfelse>NULL</cfif>,
        <cfif len(is_limited_stock)><cfqueryparam cfsqltype="cf_sql_bit" value="#is_limited_stock#"><cfelse>0</cfif>,
        <cfif len(is_quality)><cfqueryparam cfsqltype="cf_sql_bit" value="#is_quality#"><cfelse>0</cfif>,
        <cfif len(min_margin)><cfqueryparam cfsqltype="cf_sql_float" value="#min_margin#"><cfelse>NULL</cfif>,
        <cfif len(max_margin)><cfqueryparam cfsqltype="cf_sql_float" value="#max_margin#"><cfelse>NULL</cfif>,
        <cfif len(shelf_life)><cfqueryparam cfsqltype="cf_sql_integer" value="#shelf_life#"><cfelse>NULL</cfif>,
        <cfif len(segment_id)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#segment_id#"><cfelse>NULL</cfif>,
		<cfif len(bsmv)><cfqueryparam cfsqltype="cf_sql_float" value="#bsmv#"><cfelse>NULL</cfif>,
		<cfif len(oiv)><cfqueryparam cfsqltype="cf_sql_float" value="#oiv#"><cfelse>NULL</cfif>    
	)
</cfquery>
<!--- ürünün unit kaydı--->
<cfquery name="GET_PID" datasource="#dsn1#">
	SELECT MAX(PRODUCT_ID) AS PRODUCT_ID FROM PRODUCT
</cfquery>
<cfquery name="GET_UNITS_" datasource="#DSN1#">
	SELECT UNIT_ID,UNIT FROM #dsn#.SETUP_UNIT WHERE UNIT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(birim)#"> 
</cfquery>
<cfquery name="GET_UNITS_DEFAULT" datasource="#DSN1#">
	SELECT UNIT_ID,UNIT FROM #dsn#.SETUP_UNIT WHERE UNIT_ID=1
</cfquery>
<cfloop query="get_units_">
	<cfif trim(UCase(birim)) eq trim(UCase(unit))>
		<cfset unit_ids = "#unit_id#,#unit#">
	<cfelse>
		<cfset unit_ids = "#get_units_default.unit_id#,#get_units_default.unit#">
	</cfif>
</cfloop>
<cfquery name="ADD_MAIN_UNIT" datasource="#DSN1#">
	INSERT INTO
		PRODUCT_UNIT 
        (
            PRODUCT_ID, 
            PRODUCT_UNIT_STATUS, 
            MAIN_UNIT_ID, 
            MAIN_UNIT, 
            UNIT_ID, 
            ADD_UNIT,
            DIMENTION,
            VOLUME,
            WEIGHT,
            IS_MAIN,
            RECORD_EMP,
            RECORD_DATE
    
        )
        VALUES 
        (
            <cfqueryparam cfsqltype="cf_sql_integer" value="#get_pid.product_id#">,
            <cfqueryparam cfsqltype="cf_sql_bit" value="1">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(UNIT_IDS,1)#">,
            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#ListGetAt(UNIT_IDS,2)#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(UNIT_IDS,1)#">,
            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#ListGetAt(UNIT_IDS,2)#">,
            <cfif len(dimention)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#dimention#"><cfelse>NULL</cfif>,
            <cfif len(volume)><cfqueryparam cfsqltype="cf_sql_float" value="#volume#"><cfelse>NULL</cfif>,
            <cfif len(weight)><cfqueryparam cfsqltype="cf_sql_decimal" value="#weight#"><cfelse>NULL</cfif>,
            <cfqueryparam cfsqltype="cf_sql_bit" value="1">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
        )					
</cfquery>
<cfquery name="GET_MAX_UNIT" datasource="#dsn1#">
	SELECT MAX(PRODUCT_UNIT_ID) AS MAX_UNIT FROM PRODUCT_UNIT
</cfquery>

<!---alış fiyatı--->
<cfif IsNumeric(alis_fiyat_kdvsiz)>
	<cfset alis_fiyat_kdvli=(alis_fiyat_kdvsiz*(100+alis_kdv))/(100)>
	<cfset is_kdv=0>
<cfelseif IsNumeric(alis_fiyat_kdvli)>
	<cfset alis_fiyat_kdvsiz = (alis_fiyat_kdvli*100)/(100+alis_kdv)>
	<cfset is_kdv=1>
<cfelse>
	<cfset alis_fiyat_kdvsiz = 0>
	<cfset alis_fiyat_kdvli = 0>
	<cfset is_kdv=0>
</cfif>
<cfquery name="ADD_STD_PRICE" datasource="#DSN1#">
	INSERT INTO
		PRICE_STANDART
        (
            PRODUCT_ID, 
            PURCHASESALES, 
            PRICE, 
            PRICE_KDV,
            IS_KDV,
            ROUNDING,
            MONEY,
            START_DATE,
            RECORD_DATE,
            PRICESTANDART_STATUS,
            UNIT_ID,
            RECORD_EMP
        )
        VALUES
        (
            <cfqueryparam cfsqltype="cf_sql_integer" value="#get_pid.product_id#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="0">,
            <cfif not IsNumeric(alis_fiyat_kdvsiz)> <cfqueryparam cfsqltype="cf_sql_integer" value="0"><cfelse> <cfqueryparam cfsqltype="cf_sql_float" value="#alis_fiyat_kdvsiz#"></cfif>,
            <cfif not isnumeric(alis_fiyat_kdvli)> <cfqueryparam cfsqltype="cf_sql_integer" value="0"><cfelse> <cfqueryparam cfsqltype="cf_sql_float" value="#alis_fiyat_kdvli#"></cfif>,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#is_kdv#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="0">,
            <cfif len(purchase_money)> <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#purchase_money#"><cfelse> <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#session.ep.money#"></cfif>,
            <cfqueryparam cfsqltype="cf_sql_float" value="#bugun_00#">,
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_unit.max_unit#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
        )
</cfquery>

<!---satış fiyatı--->
<cfif IsNumeric(satis_fiyat_kdvli)>
	<cfset satis_fiyat_kdvsiz = (satis_fiyat_kdvli*100)/(100+satis_kdv)>
	<cfset is_kdv_satis=1>
<cfelseif IsNumeric(satis_fiyat_kdvsiz)>
	<cfset satis_fiyat_kdvli=(satis_fiyat_kdvsiz*(100+satis_kdv))/(100)>
	<cfset is_kdv_satis=0>
<cfelse>
	<cfset satis_fiyat_kdvsiz = 0>
	<cfset satis_fiyat_kdvli = 0>
	<cfset is_kdv_satis=1>
</cfif>

<cfquery name="ADD_STD_PRICE" datasource="#DSN1#">
	INSERT INTO
		PRICE_STANDART
		(
			PRODUCT_ID, 
			PURCHASESALES, 
			PRICE, 
			PRICE_KDV,
			IS_KDV,
			ROUNDING,
			MONEY,
			START_DATE,
			RECORD_DATE,
			PRICESTANDART_STATUS,
			UNIT_ID,
			RECORD_EMP
		)
		VALUES
		(
			#get_pid.product_id#,
			1,
			<cfif not IsNumeric(satis_fiyat_kdvsiz)>0<cfelse>#satis_fiyat_kdvsiz#</cfif>,
			<cfif not isnumeric(satis_fiyat_kdvli)>0<cfelse>#satis_fiyat_kdvli#</cfif>,
			#is_kdv_satis#,
			0,
			<cfif len(sales_money)>'#sales_money#'<cfelse>'#session.ep.money#'</cfif>,
			#bugun_00#,
			#NOW()#,
			1,
			#get_max_unit.max_unit#,
			#session.ep.userid#
		)
</cfquery>

<!--- stok --->
<cfquery name="ADD_STOCKS" datasource="#dsn1#">
	INSERT INTO STOCKS
	(
		STOCK_CODE,
		PRODUCT_ID,
		PROPERTY,
		BARCOD,					
		PRODUCT_UNIT_ID,
		STOCK_STATUS,
		MANUFACT_CODE,
		STOCK_CODE_2,
		RECORD_EMP, RECORD_IP, RECORD_DATE
	)
	VALUES
	(
		'#attributes.PRODUCT_CODE#',
		#GET_PID.PRODUCT_ID#,
		'#cesit_adi#',
		'#barcode_no#',
		#GET_MAX_UNIT.MAX_UNIT#,
		1,
		<cfif isdefined('uretici_urun_kodu') and len(uretici_urun_kodu)>'#uretici_urun_kodu#'<cfelse>''</cfif>,
		<cfif len(product_code_2)>'#product_code_2#'<cfelse>NULL</cfif>,
		#session.ep.userid#, '#REMOTE_ADDR#', #now()#
	)
</cfquery>

<!---stok kaydı id si--->
<cfquery name="GET_MAX_STCK" datasource="#DSN1#">
	SELECT MAX(STOCK_ID) AS MAX_STCK FROM STOCKS
</cfquery>

<!--- Ürün - Şirket İlişkisi --->
<cfif isDefined('attributes.comp_id') and len(attributes.comp_id)>
	<cfloop from="1" to="#listlen(attributes.comp_id,',')#" index="i">
        <cfquery name="ADD_PRODUCT_OUR_COMPANY_ID" datasource="#DSN1#">
            INSERT INTO 
            	PRODUCT_OUR_COMPANY
                (
                    PRODUCT_ID,
                    OUR_COMPANY_ID
                )
                VALUES
                (
                    #get_pid.product_id#,
                    #ListGetAt(attributes.comp_id,i,',')#
                )
        </cfquery>
    </cfloop>
<cfelse>
    <cfquery name="ADD_PRODUCT_OUR_COMPANY_ID" datasource="#DSN1#">
        INSERT INTO 
            PRODUCT_OUR_COMPANY
            (
                PRODUCT_ID,
                OUR_COMPANY_ID
            )
            VALUES
            (
                #get_pid.product_id#,
                #session.ep.company_id#
            )
    </cfquery>
</cfif>
<!--- Ürün - Şirket İlişkisi --->

<!--- Ürün - Şube İlişkisi --->
<cfif isDefined('attributes.branch') and len(attributes.branch)>
	<cfloop from="1" to="#listlen(attributes.branch,',')#" index="j">
        <cfquery name="ADD_PRODUCT_BRANCH" datasource="#DSN1#">
            INSERT INTO 
                PRODUCT_BRANCH
            (
                PRODUCT_ID,
                BRANCH_ID,
                RECORD_EMP, 
                RECORD_IP,
                RECORD_DATE	
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#get_pid.product_id#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(attributes.branch,j,',')#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#remote_addr#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">			
            )
        </cfquery>
    </cfloop>
</cfif>
<!--- Ürün - Şube İlişkisi --->

<!---stok row--->
<cfquery name="GET_MY_PERIODS" datasource="#DSN1#">
	SELECT 
        PERIOD,
        PERIOD_ID, 
        PERIOD_YEAR, 
        OUR_COMPANY_ID, 
        RECORD_DATE, 
        RECORD_IP, 
        RECORD_EMP, 
        UPDATE_DATE, 
        UPDATE_IP, 
        UPDATE_EMP 
    FROM 
    	#dsn#.SETUP_PERIOD 
    WHERE 
	    OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>

<cfloop query="get_my_periods">
	<cfif database_type is "MSSQL">
		<cfset temp_dsn = "#dsn#_#period_year#_#session.ep.company_id#">
	<cfelseif database_type is "DB2">
		<cfset temp_dsn = "#dsn#_#session.ep.company_id#_#right(period_year,2)#">
	</cfif>

	<cfquery name="INSRT_STK_ROW" datasource="#dsn1#">
		INSERT INTO 
			#temp_dsn#.STOCKS_ROW 
            (
                STOCK_ID,
                PRODUCT_ID
            )
            VALUES 
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_stck.max_stck#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#get_pid.product_id#">
            )
	</cfquery>
</cfloop>

<!--- muhasebe kodu --->

<cfif isdefined('account_code') and len(account_code)>
	<cfquery name="GET_CODES" datasource="#DSN1#">
		SELECT * FROM #DSN3#.SETUP_PRODUCT_PERIOD_CAT WHERE PRO_CODE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#account_code#">
	</cfquery>
<cfelse>
	<cfset get_codes.recordcount = 0>
</cfif>

<cfif get_codes.recordcount and get_my_periods.recordcount>
    <cfloop list="#ValueList(get_my_periods.PERIOD_ID)#" index="i">
        <cfquery name="ADD_PERIOD" datasource="#dsn1#">
            INSERT INTO
                #dsn3#.PRODUCT_PERIOD
            (
                PRODUCT_ID,  
                PERIOD_ID,
                ACCOUNT_CODE,
                ACCOUNT_CODE_PUR,
                ACCOUNT_DISCOUNT,
                ACCOUNT_PRICE,
                ACCOUNT_PUR_IADE,
                ACCOUNT_IADE,
                ACCOUNT_DISCOUNT_PUR,
                ACCOUNT_YURTDISI,					
                ACCOUNT_YURTDISI_PUR,
                EXPENSE_CENTER_ID,
                EXPENSE_ITEM_ID,
                INCOME_ITEM_ID,
                EXPENSE_TEMPLATE_ID,
                ACTIVITY_TYPE_ID,
                COST_EXPENSE_CENTER_ID,
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
                AMORTIZATION_CODE
            )
            VALUES 
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PID.PRODUCT_ID#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">,
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
                <cfif isdefined('account_code') and len(account_code)><cfqueryparam cfsqltype="cf_sql_integer" value="#account_code#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
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
                <cfif len(GET_CODES.AMORTIZATION_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>
            )
        </cfquery>
    </cfloop>
</cfif>