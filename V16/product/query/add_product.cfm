<!--- Subeye Ait Fiyat Listesinin kontrolu --->
<cfif session.ep.isBranchAuthorization>
	<cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
		SELECT PRICE_CATID FROM PRICE_CAT WHERE BRANCH LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#listgetat(session.ep.user_location,2,'-')#,%">
	</cfquery>
	<cfif not get_price_cat.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id ='37891.Şube Fiyat Kategorisi eksik '>!");
			window.close();
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfset list="',""">
<cfset list2=" , ">
<cfset max_product_id="">
<cfset attributes.PRODUCT_NAME = replacelist(attributes.PRODUCT_NAME,list,list2)><!--- ürün adına tek ve cift tirnak yazilmamali --->
<cfset attributes.PRODUCT_NAME = trim(attributes.PRODUCT_NAME)>
<cfquery name="CHECK_SAME" datasource="#DSN1#">
	SELECT PRODUCT_ID FROM PRODUCT WHERE PRODUCT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_name#">
</cfquery>
<cfif check_same.recordcount>
	<cfif isdefined('attributes.use_same_product_name') and attributes.use_same_product_name eq 1>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id ='46886.Aynı İsimli Bir Ürün Daha Var'>!");
		</script>
	<cfelse>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id ='37892.Aynı İsimli Bir Ürün Daha Var Lütfen Başka Bir Ürün İsmi Giriniz'> !");
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfset FORM.BARCOD=trim(FORM.BARCOD)>
<cfif len(FORM.BARCOD) and attributes.is_barcode_control eq 0>
	<cfquery name="CHECK_BARCODE" datasource="#DSN1#">
		SELECT STOCK_ID FROM GET_STOCK_BARCODES_ALL WHERE BARCODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.BARCOD#">
	</cfquery>
	<cfif check_barcode.recordcount>
    	<cfif attributes.is_barcode_control eq 0>
        	<script type="text/javascript">
				alert("<cf_get_lang dictionary_id ='46887.Girdiğiniz Barkod Başka Bir Ürün Tarafından Kullanılmakta  Lütfen Başka Bir Barkod Giriniz'> !");
				history.back();
			</script>
			<cfabort>
       	<cfelse>
			<cfif attributes.barcode_require><!--- barcode zorunluluğu varsa kayıt işlemini yapılmaz değilse işlem uyarı verir ancak kayıt yapılır--->
                <script type="text/javascript">
                    alert("<cf_get_lang dictionary_id ='46887.Girdiğiniz Barkod Başka Bir Ürün Tarafından Kullanılmakta  Lütfen Başka Bir Barkod Giriniz'> !");
                    history.back();
                </script>
                <cfabort>
            <cfelse>
                <script type="text/javascript">
                    alert("<cf_get_lang dictionary_id ='37894.Girdiğiniz Barkod Başka Bir Ürün Tarafından Kullanılmakta'> !");
                </script>
            </cfif>
       </cfif>
	</cfif>
</cfif>
<!--- ürün kodunu hierarchye göre oluşturalım --->
<cfquery name="GET_OUR_COMPANY_INFO" datasource="#DSN#">
	SELECT IS_BRAND_TO_CODE,IS_PRODUCT_COMPANY FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
	SELECT HIERARCHY,STOCK_CODE_COUNTER FROM PRODUCT_CAT WHERE PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#">
</cfquery>
<cfif not (len(get_product_cat.stock_code_counter) And get_product_cat.stock_code_counter neq 0) >
	<cfset form.product_code="#trim(form.product_code)#">
<cfelse>
	<cfset form.product_code=get_product_cat.stock_code_counter>
	<cfquery name="upd_stock_code_counter" datasource="#DSN1#">
		UPDATE PRODUCT_CAT 
		SET 
		STOCK_CODE_COUNTER = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.product_code+1#">
		WHERE PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#">
	</cfquery>
</cfif>
	<cfset form.product_code="#get_product_cat.hierarchy#.#form.product_code#">
	<cfset product_code_2_format="#attributes.brand_code#.#listlast(get_product_cat.hierarchy,'.')#.#form.short_code#">
	<!--- ürün kodu oluştu --->
	<cfquery name="CHECK_SAME" datasource="#DSN1#">
		SELECT PRODUCT_CODE FROM PRODUCT WHERE PRODUCT.PRODUCT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.product_code#">
	</cfquery>
	<cfif check_same.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id ='37895.Girdiğiniz Ürün Kodu Başka Bir Ürün Tarafından Kullanılmakta Lütfen Başka Bir Ürün Kodu Giriniz'> !");
			history.back();
		</script>
		<cfabort>
	</cfif>

<cfset bugun_00 = DateFormat(now(),dateformat_style)>
<cf_date tarih='bugun_00'>

<cfif isdefined('attributes.acc_code_cat') and len(attributes.acc_code_cat)>
	<cfquery name="GET_CODES" datasource="#DSN3#">
		SELECT * FROM SETUP_PRODUCT_PERIOD_CAT WHERE PRO_CODE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.acc_code_cat#">
	</cfquery>
	<cfquery name="GET_OTHER_PERIOD" datasource="#DSN3#">
		SELECT PERIOD_ID FROM #dsn_alias#.SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.COMPANY_ID#">
	</cfquery>
<cfelse>
	<cfset get_codes.recordcount = 0>
</cfif>
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_PRODUCT" datasource="#DSN3#">
			INSERT INTO 
				#dsn1_alias#.PRODUCT
			(
				PRODUCT_STATUS,
				IS_QUALITY,
				IS_COST,
				IS_INVENTORY,
				IS_PRODUCTION,
				IS_SALES,
				IS_PURCHASE,
				IS_PROTOTYPE,
				IS_TERAZI,
				IS_SERIAL_NO,
				IS_ZERO_STOCK,
				IS_KARMA,
				IS_LIMITED_STOCK,
                IS_LOT_NO,
				PRODUCT_CATID,
				PRODUCT_NAME,
				TAX,
				TAX_PURCHASE,
				BARCOD,
				PRODUCT_DETAIL,
                PRODUCT_DETAIL2,
				COMPANY_ID,
				BRAND_ID,
				RECORD_DATE,
				RECORD_MEMBER,
				MEMBER_TYPE,
				PRODUCT_CODE,
				MANUFACT_CODE,
				SHELF_LIFE,
				<cfif isDefined('attributes.SEGMENT_ID') and len(attributes.SEGMENT_ID)>
				SEGMENT_ID,
				</cfif>
				<cfif isDefined('attributes.PRODUCT_MANAGER') and len(attributes.PRODUCT_MANAGER)>
				PRODUCT_MANAGER,
				</cfif>
				IS_INTERNET,
				IS_EXTRANET,
				PROD_COMPETITIVE,
				PRODUCT_STAGE,
				MIN_MARGIN,
				MAX_MARGIN,
				OTV,
				PRODUCT_CODE_2,
				SHORT_CODE,
				SHORT_CODE_ID,
				WORK_STOCK_ID,
				WORK_STOCK_AMOUNT,
				RECORD_BRANCH_ID,
                PACKAGE_CONTROL_TYPE,
				IS_COMMISSION,
				IS_GIFT_CARD,
				GIFT_VALID_DAY,
				CUSTOMS_RECIPE_CODE,
				OIV,
				BSMV,
				IS_WATALOGY_INTEGRATED,
				WATALOGY_CAT_ID,
				ORIGIN_ID,
				OTV_TYPE,
				INSTRUCTION,
				IS_IMPORTED
			)
			VALUES 
			(
                <cfif isDefined("attributes.product_status") and attributes.product_status eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
				<cfif isDefined("form.is_quality") and form.is_quality eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
				<cfif isDefined("FORM.IS_COST") and FORM.IS_COST eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
				<cfif isDefined("FORM.IS_INVENTORY") and FORM.IS_INVENTORY eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
				<cfif isDefined("FORM.IS_PRODUCTION") and FORM.IS_PRODUCTION eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
				<cfif isDefined("FORM.IS_SALES") and FORM.IS_SALES eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
				<cfif isDefined("FORM.IS_PURCHASE") and FORM.IS_PURCHASE eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
				<cfif isDefined("FORM.IS_PROTOTYPE") and FORM.IS_PROTOTYPE eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
				<cfif isDefined("FORM.IS_TERAZI") and FORM.IS_TERAZI eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
				<cfif isDefined("FORM.IS_SERIAL_NO") and FORM.IS_SERIAL_NO eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
				<cfif isDefined("FORM.IS_ZERO_STOCK") and FORM.IS_ZERO_STOCK eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
				<cfif isDefined("FORM.IS_KARMA") and FORM.IS_KARMA eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
				<cfif isDefined("attributes.is_limited_stock") and attributes.is_limited_stock eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
				<cfif isDefined("FORM.IS_LOT_NO") and FORM.IS_LOT_NO eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.PRODUCT_CATID#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PRODUCT_NAME#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#FORM.TAX#">,					
				<cfqueryparam cfsqltype="cf_sql_float" value="#FORM.TAX_PURCHASE#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.BARCOD#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PRODUCT_DETAIL#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PRODUCT_DETAIL2#">,
				<cfif FORM.COMPANY_ID is ""><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.COMPANY_ID#"></cfif>,
				<cfif len(attributes.brand_name) and len(attributes.brand_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.BRAND_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#SESSION.EP.USERKEY#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PRODUCT_CODE#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.MANUFACT_CODE#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.SHELF_LIFE#">,
				<cfif isDefined('attributes.SEGMENT_ID') and len(attributes.SEGMENT_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.SEGMENT_ID#">,</cfif>
				<cfif isDefined('attributes.PRODUCT_MANAGER') and len(attributes.PRODUCT_MANAGER)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PRODUCT_MANAGER#">,</cfif>
				<cfif isDefined('attributes.is_internet') and attributes.is_internet eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1">,<cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0">,</cfif>
				<cfif isDefined('attributes.is_extranet') and attributes.is_extranet eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1">,<cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0">,</cfif>
				<cfif isDefined('attributes.prod_comp') and len(attributes.prod_comp)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prod_comp#">,<cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes">,</cfif>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">,               
				<cfif isDefined('attributes.MIN_MARGIN') and len(attributes.MIN_MARGIN)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(attributes.min_margin,4)#"><cfelse>0</cfif>,
                <cfif isDefined('attributes.MAX_MARGIN') and len(attributes.MAX_MARGIN)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(attributes.max_margin,4)#"><cfelse>0</cfif>,
				<cfif isDefined('attributes.OTV') and len(attributes.OTV)><cfif attributes.OTV_TYPE eq 1><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(attributes.OTV,4)#">,<cfelse><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.OTV#">,</cfif><cfelse><cfqueryparam cfsqltype="cf_sql_float" value="" null="yes">,</cfif>
				<cfif get_our_company_info.is_brand_to_code>
					<cfif len(attributes.product_code_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_code_2#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#product_code_2_format#"></cfif>,
				<cfelse>
					<cfif len(attributes.product_code_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_code_2#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				</cfif>
				<cfif len(attributes.short_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.SHORT_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfif len(attributes.short_code_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.short_code_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
				<cfif isdefined('attributes.work_product_name') and len(attributes.work_product_name) and len(attributes.work_stock_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_stock_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
				<cfif isdefined('attributes.work_product_name') and len(attributes.work_product_name) and len(attributes.work_stock_id) and len(attributes.work_stock_amount)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.work_stock_amount#"><cfelse><cfqueryparam cfsqltype="cf_sql_float" value="" null="yes"></cfif>,
				<cfif session.ep.isBranchAuthorization><cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
				<cfif isdefined('attributes.PACKAGE_CONTROL_TYPE') and len(attributes.PACKAGE_CONTROL_TYPE)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PACKAGE_CONTROL_TYPE#">,<cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes">,</cfif>
				<cfif isDefined("attributes.is_commission") and attributes.is_commission eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
				<cfif isDefined("attributes.is_gift_card") and attributes.is_gift_card eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
				<cfif isDefined('attributes.gift_valid_day') and len(attributes.gift_valid_day)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.gift_valid_day#"><cfelse>NULL</cfif>,				
				<cfif isdefined("attributes.customs_recipe_code") and len(attributes.customs_recipe_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.customs_recipe_code#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfif isDefined('attributes.OIV') and len(attributes.OIV)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.OIV#"><cfelse><cfqueryparam cfsqltype="cf_sql_float" value="" null="yes"></cfif>,
				<cfif isDefined('attributes.BSMV') and len(attributes.BSMV)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.BSMV#"><cfelse><cfqueryparam cfsqltype="cf_sql_float" value="" null="yes"></cfif>,
				<cfif isdefined('attributes.is_watalogy_integrated') and attributes.is_watalogy_integrated eq 1><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
				<cfif isdefined('attributes.watalogy_cat_id') and isdefined('attributes.watalogy_cat_name') and len(attributes.watalogy_cat_id) and len(attributes.watalogy_cat_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.watalogy_cat_id#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.origin') and len(attributes.origin)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.origin#"><cfelse>NULL</cfif>,
				<cfif isDefined('attributes.OTV_TYPE') and len(attributes.OTV_TYPE)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.OTV_TYPE#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.instruction#">,
				<cfif isDefined("FORM.IS_IMPORTED") and FORM.IS_IMPORTED eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>

			)
        	SELECT @@IDENTITY AS MAX_PRODUCT_ID
		</cfquery>
		<cfquery name="GET_PID" datasource="#DSN3#">
			SELECT MAX(PRODUCT_ID) AS PRODUCT_ID FROM #dsn1_alias#.PRODUCT
		</cfquery>
		<cfset pid = GET_PID.PRODUCT_ID>
        <cfif GET_OUR_COMPANY_INFO.IS_PRODUCT_COMPANY EQ 1>
            <cfquery name="add_general_parameters2" datasource="#dsn3#">
                INSERT INTO #dsn1_alias#.PRODUCT_GENERAL_PARAMETERS
                (
                    PRODUCT_ID,
                    COMPANY_ID, 
                    OUR_COMPANY_ID,
                    PRODUCT_MANAGER,
                    PRODUCT_STATUS, 
                    IS_INVENTORY, 
                    IS_PRODUCTION, 
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
                    IS_ADD_XML,
                    IS_GIFT_CARD,
                    IS_LOT_NO,
                    GIFT_VALID_DAY,
					IS_IMPORTED
                )
                VALUES
                (
                    #pid#, 
                    <cfif FORM.COMPANY_ID is ""><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.COMPANY_ID#"></cfif>,
                    #session.ep.company_id#,
                    <cfif isDefined('attributes.PRODUCT_MANAGER') and len(attributes.PRODUCT_MANAGER)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PRODUCT_MANAGER#"><cfelse>NULL</cfif>,
                    <cfif isDefined("attributes.PRODUCT_STATUS")><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("form.is_inventory") and form.is_inventory eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("form.is_production") and form.is_production eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
                    <cfif isDefined("form.is_sales") and form.is_sales eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
                    <cfif isDefined("form.is_purchase") and form.is_purchase eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
                    <cfif isDefined("form.is_prototype") and form.is_prototype eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("form.is_internet") and form.is_internet eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("form.is_extranet") and form.is_extranet eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
                    <cfif isDefined("form.is_terazi") and form.is_terazi eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("form.is_karma") and form.is_karma eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("form.is_zero_stock") and form.is_zero_stock eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("form.is_limited_stock") and form.is_limited_stock eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("form.is_serial_no") and form.is_serial_no eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("form.is_cost") and form.is_cost eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("form.is_quality") and form.is_quality eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("form.is_commission") and form.is_commission eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("form.is_add_xml") and form.is_add_xml eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined('attributes.is_gift_card')><cfqueryparam cfsqltype="cf_sql_integer" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="0"></cfif>,
                    <cfif isDefined("form.is_lot_no") and form.is_lot_no eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined('attributes.gift_valid_day') and len(attributes.gift_valid_day)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.gift_valid_day#"><cfelse>NULL</cfif>,
					<cfif isDefined("form.is_imported") and form.is_imported eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>

                )
            </cfquery>
        </cfif>
		<cfif GET_CODES.recordcount and GET_OTHER_PERIOD.recordcount>
			<cfloop list="#ValueList(GET_OTHER_PERIOD.PERIOD_ID)#" index="i">
				<cfquery name="ADD_MAIN_UNIT" datasource="#DSN3#">
					INSERT INTO
						PRODUCT_PERIOD
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
						<cfif isdefined('attributes.acc_code_cat') and len(attributes.acc_code_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.acc_code_cat#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
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
		<cfquery name="ADD_MAIN_UNIT" datasource="#DSN3#">
			INSERT INTO
				#dsn1_alias#.PRODUCT_UNIT 
			(
				PRODUCT_ID, 
				PRODUCT_UNIT_STATUS, 
				MAIN_UNIT_ID, 
				MAIN_UNIT, 
				UNIT_ID, 
				ADD_UNIT,
				DIMENTION,
				WEIGHT,
                VOLUME,
				IS_MAIN,
				IS_SHIP_UNIT,
                RECORD_EMP,
                RECORD_DATE

			)
			VALUES 
			(
				#GET_PID.PRODUCT_ID#,
				1,
				#LISTGETAT(UNIT_ID,1)#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#LISTGETAT(UNIT_ID,2)#">,
				#LISTGETAT(UNIT_ID,1)#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#LISTGETAT(UNIT_ID,2)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.DIMENTION#">,
				<cfif isDefined('FORM.WEIGHT') and len(FORM.WEIGHT)><cfqueryparam cfsqltype="cf_sql_float" value="#FORM.WEIGHT#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.volume#" null="#not len(attributes.volume)#">,
				1,
				<cfif isdefined('is_ship_unit')>1<cfelse>0</cfif>,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			)					
		</cfquery>
		<cfquery name="GET_MAX_UNIT" datasource="#DSN3#">
			SELECT MAX(PRODUCT_UNIT_ID) AS MAX_UNIT FROM #dsn1_alias#.PRODUCT_UNIT
		</cfquery>
		<cfscript>
			if (isnumeric(attributes.PURCHASE))
				if (attributes.is_tax_included_purchase eq 1)
				{
					purchase_kdvsiz = wrk_round(attributes.PURCHASE*100/(attributes.tax_purchase+100),session.ep.our_company_info.purchase_price_round_num);
					purchase_kdvli = attributes.PURCHASE;
					purchase_is_tax_included = 1;
				}
				else
				{
					purchase_kdvsiz = attributes.PURCHASE;
					purchase_kdvli =  wrk_round(attributes.PURCHASE*(1+(attributes.tax_purchase/100)),session.ep.our_company_info.purchase_price_round_num);
					purchase_is_tax_included = 0;
				}
			else
			{
				purchase_kdvsiz = 0;
				purchase_kdvli = 0;
				purchase_is_tax_included = 0;
			}					
		</cfscript>
		<!--- purchasesales is 0 / alış fiyatı --->
		<cfquery name="ADD_STD_PRICE" datasource="#DSN3#">
			INSERT INTO
				#dsn1_alias#.PRICE_STANDART
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
				#GET_PID.PRODUCT_ID#,
				0,
				#purchase_kdvsiz#,
				#purchase_kdvli#,
				#purchase_is_tax_included#,
				0,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.MONEY_ID_SA#">,
				#bugun_00#,
				#NOW()#,
				1,
				#GET_MAX_UNIT.MAX_UNIT#,
				#SESSION.EP.USERID#
			)
		</cfquery>

		<cfscript>
			if (isnumeric(attributes.PRICE))
				if (attributes.is_tax_included_sales eq 1)
				{
					price_kdvsiz = wrk_round(attributes.PRICE*100/(attributes.tax+100),session.ep.our_company_info.sales_price_round_num);
					price_kdvli = attributes.PRICE;
					price_is_tax_included = 1;
				}
				else
				{
					price_kdvsiz = attributes.PRICE;
					price_kdvli = wrk_round(attributes.PRICE*(1+(attributes.tax/100)),session.ep.our_company_info.sales_price_round_num);
					price_is_tax_included = 0;
				}
			else
			{
				price_kdvsiz = 0;
				price_kdvli = 0;
				price_is_tax_included = 0;
			}					
		</cfscript>
		<!--- purchasesales is 1 / satış fiyatı --->
		<cfquery name="ADD_STD_PRICE" datasource="#DSN3#">
			INSERT INTO 
				#dsn1_alias#.PRICE_STANDART
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
				#GET_PID.PRODUCT_ID#,
				1,
				#price_kdvsiz#,
				#price_kdvli#,
				#price_is_tax_included#,
				0,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.MONEY_ID_SS#">,
				#bugun_00#,
				#NOW()#,
				1,
				#GET_MAX_UNIT.MAX_UNIT#,
				#SESSION.EP.USERID#
			)
		</cfquery>
		
		<!--- Subedeben kayıt atilmis ise ilgili sube listesine fiyat atilmasi  --->
		<cfif session.ep.isBranchAuthorization>
			<cfscript>
				add_price(product_id : get_pid.product_id,
					product_unit_id : get_max_unit.max_unit,
					price_cat : get_price_cat.price_catid,
					start_date : createodbcdatetime(createdatetime(year(now()),month(now()),day(now()),hour(now()),(minute(now()) - minute(now()) mod 5),0)),
					price : price_kdvsiz,
					price_money : attributes.money_id_sa,
					is_kdv : attributes.is_tax_included_sales,
					price_with_kdv : price_kdvli
					);
			</cfscript>
		</cfif>	
		
		<cfquery name="ADD_STOCKS" datasource="#DSN3#">
			INSERT INTO
				#dsn1_alias#.STOCKS
			(
				STOCK_CODE,
				STOCK_CODE_2,
				PRODUCT_ID,
				PROPERTY,
				BARCOD,					
				PRODUCT_UNIT_ID,
				STOCK_STATUS,
				MANUFACT_CODE,
				RECORD_EMP, 
				RECORD_IP,
				RECORD_DATE
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PRODUCT_CODE#">,
				<cfif get_our_company_info.is_brand_to_code eq 1>
					<cfif len(attributes.product_code_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_code_2#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#product_code_2_format#"></cfif>,
				<cfelse>
					<cfif len(attributes.product_code_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_code_2#"><cfelse>NULL</cfif>,
				</cfif>
				#GET_PID.PRODUCT_ID#,
				'', <!--- property degeri null oldugunda raporlar, urun agacı gibi bir cok ekranda property le beraber cekilen urun isminde sorun oluyordu ---><!--- '-',  boş olarak eklenmesi terch edildi--->
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.BARCOD#">,
				#GET_MAX_UNIT.MAX_UNIT#,
				<cfif isDefined("attributes.product_status") and attributes.product_status eq 1>1<cfelse>0</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.MANUFACT_CODE#">,
				#session.ep.userid#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#remote_addr#">,
				#now()#
			)
		</cfquery>
		
		<cfquery name="GET_MAX_STCK" datasource="#DSN3#">
			SELECT MAX(STOCK_ID) AS MAX_STCK FROM #dsn1_alias#.STOCKS
		</cfquery>
		<cfquery name="ADD_STOCK_BARCODE" datasource="#DSN3#">
			INSERT INTO 
				#dsn1_alias#.STOCKS_BARCODES
			(
				STOCK_ID,
				BARCODE,
				UNIT_ID
			)
			VALUES 
			(
				#GET_MAX_STCK.MAX_STCK#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.BARCOD#">,
				#GET_MAX_UNIT.MAX_UNIT#
			)
		</cfquery>

		<cfquery name="ADD_PRODUCT_OUR_COMPANY_ID" datasource="#DSN3#">
			INSERT INTO 
				#dsn1_alias#.PRODUCT_OUR_COMPANY
				(
					PRODUCT_ID,
					OUR_COMPANY_ID
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#get_pid.product_id#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
				)
		</cfquery>
		
		<!--- FB 20070702 urune sessiondaki branch ekleniyor --->
		<cfquery name="add_product_branch_id" datasource="#DSN3#">
			INSERT INTO
				#dsn1_alias#.PRODUCT_BRANCH
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
				<cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">,
				#session.ep.userid#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#remote_addr#">,
				#now()#				
			)
		</cfquery>
		<cfquery name="get_my_periods" datasource="#DSN3#">
			SELECT * FROM #dsn_alias#.SETUP_PERIOD WHERE OUR_COMPANY_ID = #SESSION.EP.COMPANY_ID#
		</cfquery>
		<cfloop query="get_my_periods">
			<cfif database_type is "MSSQL">
				<cfset temp_dsn = "#DSN#_#PERIOD_YEAR#_#SESSION.EP.COMPANY_ID#">
			<cfelseif database_type is "DB2">
				<cfset temp_dsn = "#dsn#_#SESSION.EP.COMPANY_ID#_#right(period_year,2)#">
			</cfif>
			<cfquery name="INSRT_STK_ROW" datasource="#DSN3#">
				INSERT INTO #temp_dsn#.STOCKS_ROW 
					(
						STOCK_ID,
						PRODUCT_ID
					)
				VALUES 
					(
						#GET_MAX_STCK.MAX_STCK#,
						#GET_PID.PRODUCT_ID#
					)
			</cfquery>
		</cfloop>
        <!--- Stok Stratejisi Ekliyor! --->
        <cfquery name="ADD_STK_STRATEGY" datasource="#DSN3#">
			INSERT INTO
				STOCK_STRATEGY 
			(
				PRODUCT_ID,
				STOCK_ID,
				MINIMUM_ORDER_UNIT_ID,
				STRATEGY_TYPE,
                IS_LIVE_ORDER
				
			)
			VALUES
			(
				#pid#,
				#GET_MAX_STCK.MAX_STCK#,
				#GET_MAX_UNIT.MAX_UNIT#,
				1,
                0
			)
		</cfquery>
		<cfif isDefined("attributes.block_stock_value") and len(attributes.block_stock_value)>
			<cfquery name="GET_MAX_STRATEGY" datasource="#DSN3#">
				SELECT MAX(STOCK_STRATEGY_ID) MAX_ID FROM STOCK_STRATEGY WHERE STOCK_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#GET_MAX_STCK.MAX_STCK#">
			</cfquery>
			<cfquery name="ADD_STK_STRATEGY" datasource="#DSN3#">
				INSERT INTO
					ORDER_ROW_RESERVED 
				(
					STOCK_STRATEGY_ID,
					STOCK_ID,
					PRODUCT_ID,
					RESERVE_STOCK_IN,
					RESERVE_STOCK_OUT,
					STOCK_IN,
					STOCK_OUT
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#GET_MAX_STRATEGY.MAX_ID#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#GET_MAX_STCK.MAX_STCK#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#pid#">,
					0,
					#attributes.block_stock_value#,
					0,
					0
				)
			</cfquery>
		</cfif>
        
        <cfif isdefined("attributes.property_row_count") and len(attributes.property_row_count)>
        	<cfloop from="1" to="#attributes.property_row_count#" index="z">
				<cfif isdefined("attributes.chk_product_property_#z#")>
                    <cfquery name="ADD_PROPERTY" datasource="#DSN3#">
                        INSERT INTO
                            #dsn1_alias#.PRODUCT_DT_PROPERTIES
                        (
                            PRODUCT_ID,
                            PROPERTY_ID,
                            VARIATION_ID,
                            RECORD_EMP,
                            RECORD_DATE,
                            RECORD_IP
                        )
                        VALUES
                        (
                            #GET_PID.PRODUCT_ID#,
                            #evaluate("attributes.product_property_id#z#")#,
                            <cfif isdefined("attributes.property_detail_")>#listfirst(evaluate("attributes.property_detail_#z#"),';')#<cfelse>NULL</cfif>,
                            #session.ep.userid#,
                            #now()#,
                            '#cgi.remote_addr#'
                        )
                	</cfquery>
                </cfif>
            </cfloop>
        </cfif>

        <cf_workcube_process
            data_source='#dsn3#'  
            is_upd='1' 
            old_process_line='0'
            process_stage='#attributes.process_stage#' 
            record_member='#session.ep.userid#' 
            record_date='#now()#' 
            action_table='PRODUCT'
            action_column='PRODUCT_ID'
            action_id='#get_pid.product_id#'
            action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_product&event=det&pid=#get_pid.product_id#' 
            warning_description='Ürün : #attributes.product_name#'>
	</cftransaction>
</cflock>

<!--- Kaydedilen ürün wex ile watalogye gider. Yoruma alındı. --->
<!--- <cfquery name="get_product" datasource="#dsn1#">
	SELECT * FROM PRODUCT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PID.PRODUCT_ID#">
</cfquery>
<cfset cmp = createObject("component","cfc.queryJSONConverter")>
<cfset send_data = cmp.returnData(Replace(serializeJSON(get_product),"//","")) />
<cfset return_value = structNew() />
<cftry>
	<cfhttp url="https://dev.workcube.com/wex.cfm/getWatalogyProduct/getProduct" result="response" charset="utf-8">
		<cfif get_product.recordCount>
			<cfhttpparam name="data" type="formfield" value="#Replace(serializeJSON(send_data),"//","")#">
		</cfif>
	</cfhttp>
	<cfset return_value.STATUS = response.Filecontent>
	<cfcatch type="any">
		<cfset return_value.STATUS = false>
	</cfcatch>
</cftry> --->

<cfif isdefined("attributes.USER_FRIENDLY_URL") and len(attributes.USER_FRIENDLY_URL)> 
	<cf_workcube_user_friendly user_friendly_url='#attributes.user_friendly_url#' action_type='PRODUCT_ID' action_id='#pid#' action_page='objects2.detail_product&product_id=#pid#'>
	<cfquery name="upd_product_" datasource="#dsn1#">
		UPDATE PRODUCT SET USER_FRIENDLY_URL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#user_friendly_#"> WHERE PRODUCT_ID = #pid#
	</cfquery>
</cfif>
<cfif not isdefined("is_operation_type")><!--- Uretim Planlamadan kontrol ediliyor silmeyiniz fbs20090929 --->
	<cflocation url="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_product&event=det&pid=#get_pid.product_id#" addtoken="no">
</cfif>