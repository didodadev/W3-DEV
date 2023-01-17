<!---
view'de replace ediliyor FA 

<cfset list="',""">
<cfset list2=" , ">
<cfset attributes.PRODUCT_NAME = replacelist(attributes.PRODUCT_NAME,list,list2)>--->

<cfset attributes.PRODUCT_NAME = trim(attributes.PRODUCT_NAME)>
<cfquery name="UPD_PRODUCT_STATUS" datasource="#DSN1#">
    UPDATE 
        PRODUCT 
    SET 
        PRODUCT_STATUS = #iif(isDefined('attributes.product_status'),1,0)#
    WHERE 
        PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PRODUCT_ID#">
</cfquery>
<cfquery name="UPD_STOCK_" datasource="#DSN1#">
	UPDATE 
		STOCKS 
	SET 
		STOCK_STATUS = <cfif isDefined("attributes.PRODUCT_STATUS")>1<cfelse>0</cfif>
	WHERE 
		STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#attributes.old_product_code#%">
</cfquery>
<cfquery name="CHECK_SAME" datasource="#DSN1#">
	SELECT P.PRODUCT_ID FROM PRODUCT P WHERE P.PRODUCT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PRODUCT_NAME#"> AND P.PRODUCT_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.PRODUCT_ID#">
</cfquery>
<cfif check_same.recordcount>
	<cfif isdefined('use_same_product_name') and use_same_product_name eq 1>
		<script type="text/javascript">
			alert("<cf_get_lang no ='912.Aynı İsimli Bir Ürün Daha Var'>!");
		</script>
	<cfelse>
		<script type="text/javascript">
			alert("<cf_get_lang no ='880.Aynı İsimli Bir Ürün Daha Var Lütfen Başka Bir Ürün İsmi Giriniz'> !");
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfquery name="get_stock_barcode_query" datasource="#dsn1#">
	SELECT MIN(STOCK_ID) STOCK_ID FROM STOCKS WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.PRODUCT_ID#">
</cfquery>
<cfset FORM.BARCOD=TRIM(FORM.BARCOD)>
<cfif len(FORM.BARCOD)>
	<cfquery name="CHECK_BARCODE" datasource="#dsn1#"><!--- baska ürüne veya varsa aynı ürünün baska stogunda aynı barkod kullanılmış mı  --->
		SELECT 	
			PRODUCT_ID 
		FROM 
			GET_STOCK_BARCODES_ALL
		WHERE 
			BARCODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.BARCOD#"> AND
			(
                PRODUCT_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.PRODUCT_ID#">
                <cfif len(get_stock_barcode_query.stock_id)>
                OR (PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.PRODUCT_ID#"> AND STOCK_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#get_stock_barcode_query.stock_id#">)
                </cfif>
			)
	</cfquery>
	<cfif check_barcode.recordcount>
    	<cfif attributes.is_barcode_control eq 0>
        	<script type="text/javascript">
				alert("<cf_get_lang no ='881.Girdiğiniz Barkod Başka Bir Ürün Tarafından Kullanılmakta  Lütfen Başka Bir Barkod Giriniz'> !");
				history.back();
			</script>
			<cfabort>
       	<cfelse>
			<cfif attributes.barcode_require><!--- barcode zorunluluğu varsa kayıt işlemini yapılmaz değilse işlem uyarı verir ancak kayıt yapılır--->
                <script type="text/javascript">
                    alert("<cf_get_lang no ='881.Girdiğiniz Barkod Başka Bir Ürün Tarafından Kullanılmakta  Lütfen Başka Bir Barkod Giriniz'>!");
                    history.back();
                </script>
                <cfabort>
            <cfelse>
                <script type="text/javascript">
                    alert("<cf_get_lang no ='882.Girdiğiniz Barkod Başka Bir Ürün Tarafından Kullanılmakta'>!");
                </script>
			</cfif>
        </cfif>
	</cfif>
</cfif>
<!---  
Burada ürün kodu veya kategorisi değişmiş mi diye kontrol ediyoruz...
Eger deðiþmiþse deðiþmiþ halini db de kontrol ediyoruz hata varsa yazacaðýz.
Yoksa ilgili degisiklikleri yapip devam edecegiz...
Soyle ki;
Bu ürün kodunu (kategori ile birlikte olusan veya kullanicinin elle girdigi) iceren stoklar taranacak ve bu degisiklik aynen
buralara da yapilacak...
 18062002
 --->
<!---<cfobject component="workdata/back_history" name="backHistory">--->
<cfset bugun_00 = DateFormat(now(),dateformat_style)>
<cf_date tarih='bugun_00'>
<cfif not (form.old_product_catid is form.product_catid)>
	<!--- Kategori degismisse ürün kodu da degisir ürün kodu ile bu ürüne bagli stoklar da degiseceginden hepsini yenileyelim. --->
	<cfquery name="GET_PRODUCT_CAT" datasource="#DSN3#">
		SELECT HIERARCHY,STOCK_CODE_COUNTER FROM PRODUCT_CAT WHERE PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.PRODUCT_CATID#">
	</cfquery>
	<cfif not (len(get_product_cat.stock_code_counter) And get_product_cat.stock_code_counter neq 0) >
		<cfset form.PRODUCT_CODE = '#get_product_cat.HIERARCHY#.#trim(ListLast(form.PRODUCT_CODE,'.'))#'>
	<cfelse>
		<cfset form.PRODUCT_CODE = '#get_product_cat.HIERARCHY#.#get_product_cat.stock_code_counter#'>
		<cfquery name="upd_stock_code_counter" datasource="#DSN1#">
			UPDATE PRODUCT_CAT 
			SET 
			STOCK_CODE_COUNTER = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_cat.stock_code_counter+1#">
			WHERE PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#">
		</cfquery>
	</cfif>
	<cfquery name="CHECK_CODE" datasource="#DSN1#">
		SELECT PRODUCT_CODE FROM PRODUCT WHERE PRODUCT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PRODUCT_CODE#"> AND PRODUCT_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.PRODUCT_ID#">
	</cfquery>
	<cfif check_code.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='883.Girdiğiniz Ürün Kodu Başka Bir Ürün Tarafından Kullanılmakta Lütfen Başka Bir Ürün Kodu Giriniz'> !");
			history.back();
		</script>
		<cfabort>
	</cfif>
	<cfquery name="SEL_STOCK_ESKILER" datasource="#DSN1#">
		SELECT STOCK_CODE AS PRODUCT_CODE, STOCK_ID FROM STOCKS WHERE STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.OLD_PRODUCT_CODE#%">
	</cfquery>

	<cflock name="#CREATEUUID()#" timeout="60">
		<cftransaction>
			<cfloop query="sel_stock_eskiler">
				<cfset temp = "">
				<cfset fark = Len(sel_stock_eskiler.product_code) - Len(form.old_product_code)>
				<cfif (fark neq 0)>
					<cfset temp = form.product_code & Right(sel_stock_eskiler.product_code,fark)>
				<cfelse>
					<cfset temp = form.product_code>
				</cfif>
				<cfquery name="UPD_STOCK" datasource="#DSN1#">
					UPDATE 
						STOCKS 
					SET 
						STOCK_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#temp#">,
						STOCK_STATUS = <cfif isDefined("attributes.PRODUCT_STATUS")>1<cfelse>0</cfif>,
						UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
						UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#REMOTE_ADDR#">,
						UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					WHERE 
						STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SEL_STOCK_ESKILER.STOCK_ID#">
				</cfquery>
			</cfloop>
		</cftransaction>
	</cflock>
	<!--- cat değiştiği için info plus siliniyor--->
	<cfquery name="DEL_INFOPLUS" datasource="#DSN3#">
		DELETE FROM PRODUCT_INFO_PLUS WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PRODUCT_ID#">
	</cfquery>
<cfelse>
	<!--- Kategori degismemis ama ürün kodu degismis ise ürün kodu ile bu ürüne bagli stoklar da degiseceginden hepsini yenileyelim.--->
	<cfif not (form.old_product_code is form.product_code)>
		<cfquery name="CHECK_CODE" datasource="#DSN1#">
			SELECT PRODUCT_CODE FROM PRODUCT WHERE PRODUCT_CODE=<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PRODUCT_CODE#"> AND PRODUCT_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.PRODUCT_ID#">
		</cfquery>
		<cfif check_code.recordcount>
			<script type="text/javascript">
				alert("<cf_get_lang no ='883.Girdiğiniz Ürün Kodu Başka Bir Ürün Tarafından Kullanılmakta Lütfen Başka Bir Ürün Kodu Giriniz'>!");
				history.back();
			</script>
			<cfabort>
		</cfif>
	</cfif>
	<cfif not (form.old_product_code is form.product_code)>
		<cfquery name="SEL_STOCK_ESKILER" datasource="#DSN1#">
			SELECT STOCK_CODE AS PRODUCT_CODE, STOCK_ID FROM STOCKS WHERE STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.OLD_PRODUCT_CODE#%">
		</cfquery>
		<cflock name="#CREATEUUID()#" timeout="60">
			<cftransaction>
				<cfloop query="sel_stock_eskiler">
					<cfset temp="">
					<cfset fark = Len(sel_stock_eskiler.product_code) - Len(form.old_product_code)>
					<cfif fark neq 0>
						<cfset temp = form.product_code & Right(sel_stock_eskiler.product_code,fark)>
					<cfelse>
						<cfset temp = form.product_code>
					</cfif>
					<cfquery name="UPD_STOCK" datasource="#DSN1#">
						UPDATE 
							STOCKS 
						SET 
							STOCK_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TEMP#">,
							STOCK_STATUS = <cfif isDefined("attributes.PRODUCT_STATUS")>1<cfelse>0</cfif>,
							UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
							UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#REMOTE_ADDR#">,
							UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						WHERE 
							STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SEL_STOCK_ESKILER.STOCK_ID#">
					</cfquery>
				</cfloop>
			</cftransaction>
		</cflock>
	</cfif>
</cfif>
<cfif isdefined("attributes.USER_FRIENDLY_URL") and len(attributes.USER_FRIENDLY_URL)> 
	<cf_workcube_user_friendly user_friendly_url='#attributes.user_friendly_url#' action_type='PRODUCT_ID' action_id='#FORM.PRODUCT_ID#' action_page='objects2.detail_product&product_id=#FORM.PRODUCT_ID#'>
</cfif>
<cf_wrk_get_history datasource="#dsn1#" source_table="PRODUCT" target_table="PRODUCT_HISTORY" insert_column_name="DENEME" record_name="PRODUCT_ID" RECORD_ID="#attributes.product_id#">
<cfif isdefined("attributes.quality_startdate") and len(attributes.quality_startdate)>
	<cf_date tarih="attributes.quality_startdate">
</cfif>
<cfquery name="get_our_company_info" datasource="#dsn#">
	SELECT IS_PRODUCT_COMPANY FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfquery name="UPD_PRODUCT" datasource="#DSN1#" result="xxxx">
    UPDATE 
        PRODUCT 
    SET 
        USER_FRIENDLY_URL = <cfif isdefined("attributes.USER_FRIENDLY_URL") and len(attributes.USER_FRIENDLY_URL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#user_friendly_#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" null="yes" value=""></cfif>,
        <cfif get_our_company_info.is_product_company neq 1>
        	PRODUCT_STATUS = <cfif isDefined("attributes.PRODUCT_STATUS")><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
       		IS_QUALITY = <cfif isDefined("FORM.is_quality")><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
        	IS_COST = <cfif isDefined("FORM.IS_COST")><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
        	IS_INVENTORY = <cfif isDefined("FORM.IS_INVENTORY")><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
        	IS_PRODUCTION = <cfif isDefined("FORM.IS_PRODUCTION")><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            IS_SALES = <cfif isDefined("FORM.IS_SALES")><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            IS_PURCHASE = <cfif isDefined("FORM.IS_PURCHASE")><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            IS_PROTOTYPE = <cfif isDefined("FORM.IS_PROTOTYPE")><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            IS_TERAZI = <cfif isDefined("FORM.IS_TERAZI")><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            IS_SERIAL_NO = <cfif isDefined("FORM.IS_SERIAL_NO")><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            IS_ZERO_STOCK = <cfif isDefined("FORM.IS_ZERO_STOCK")><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            IS_KARMA = <cfif isDefined("FORM.IS_KARMA")><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            IS_LIMITED_STOCK = <cfif isDefined("attributes.is_limited_stock")><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            IS_COMMISSION = <cfif isDefined("attributes.is_commission")><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            IS_ADD_XML = <cfif isDefined("attributes.is_add_xml") and attributes.is_add_xml eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            IS_LOT_NO = <cfif isDefined("attributes.is_lot_no") and attributes.is_lot_no eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
        	COMPANY_ID = <cfif isDefined("FORM.COMPANY_ID") and len(FORM.COMPANY_ID) and len(FORM.COMP)><cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.COMPANY_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
            PRODUCT_MANAGER = <cfif isDefined('attributes.PRODUCT_MANAGER') and len(attributes.PRODUCT_MANAGER) and isDefined('attributes.PRODUCT_MANAGER_NAME') and len(attributes.PRODUCT_MANAGER_NAME)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PRODUCT_MANAGER#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" null="yes" value=""></cfif>,
            IS_INTERNET = <cfif isDefined('attributes.is_internet')><cfqueryparam cfsqltype="cf_sql_integer" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="0"></cfif>,
            IS_EXTRANET = <cfif isDefined('attributes.is_extranet')><cfqueryparam cfsqltype="cf_sql_integer" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="0"></cfif>,
            IS_GIFT_CARD = <cfif isDefined('attributes.is_gift_card')><cfqueryparam cfsqltype="cf_sql_integer" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="0"></cfif>,
            GIFT_VALID_DAY = <cfif isDefined('attributes.gift_valid_day') and len(attributes.gift_valid_day)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.gift_valid_day#"><cfelse>NULL</cfif>,
        </cfif>
        PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.PRODUCT_CATID#">,
        PRODUCT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PRODUCT_NAME#">,
        TAX = <cfqueryparam cfsqltype="cf_sql_float" value="#FORM.TAX#">,
        TAX_PURCHASE = <cfqueryparam cfsqltype="cf_sql_float" value="#FORM.TAX_PURCHASE#">,
		OTV_TYPE = <cfif isDefined('attributes.OTV_TYPE') and len(attributes.OTV_TYPE)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.OTV_TYPE#"><cfelse>NULL</cfif>,
        OTV = <cfif isDefined('attributes.OTV') and len(attributes.OTV)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(attributes.OTV,4)#"><cfelse>NULL</cfif>,
		OIV = <cfif isDefined('attributes.OIV') and len(attributes.OIV)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.OIV#"><cfelse>NULL</cfif>,
		BSMV = <cfif isDefined('attributes.BSMV') and len(attributes.BSMV)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.BSMV#"><cfelse>NULL</cfif>,
        BARCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.BARCOD#">,
        PRODUCT_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PRODUCT_DETAIL#">,
        PRODUCT_DETAIL2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PRODUCT_DETAIL2#">,
        BRAND_ID = <cfif len(attributes.brand_name) and len(attributes.brand_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
        PRODUCT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PRODUCT_CODE#">,
        MANUFACT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.MANUFACT_CODE#">,
        SHELF_LIFE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.SHELF_LIFE#">,
        SEGMENT_ID = <cfif isDefined('attributes.SEGMENT_ID') and len(attributes.SEGMENT_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.SEGMENT_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
        
        PROD_COMPETITIVE = <cfif isDefined('attributes.prod_comp') and len(attributes.prod_comp)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prod_comp#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
        PRODUCT_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">,
        MIN_MARGIN = <cfif isDefined('attributes.MIN_MARGIN') and len(attributes.MIN_MARGIN)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(attributes.MIN_MARGIN,4)#"><cfelse>null</cfif>,		
        MAX_MARGIN = <cfif isDefined('attributes.MAX_MARGIN') and len(attributes.MAX_MARGIN)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(attributes.MAX_MARGIN,4)#"><cfelse>null</cfif>,		
        PRODUCT_CODE_2 = <cfif len(attributes.product_code_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_code_2#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
        SHORT_CODE = <cfif len(attributes.SHORT_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.SHORT_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
        SHORT_CODE_ID = <cfif len(attributes.SHORT_CODE_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.SHORT_CODE_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
        WORK_STOCK_ID = <cfif isdefined('attributes.work_product_name') and len(attributes.work_product_name) and len(attributes.work_stock_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_stock_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
        WORK_STOCK_AMOUNT = <cfif isdefined('attributes.work_product_name') and len(attributes.work_product_name) and len(attributes.work_stock_id) and len(attributes.work_stock_amount)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.work_stock_amount#"><cfelse><cfqueryparam cfsqltype="cf_sql_float" value="" null="yes"></cfif>,
        PACKAGE_CONTROL_TYPE = <cfif isdefined('attributes.PACKAGE_CONTROL_TYPE') and len(attributes.PACKAGE_CONTROL_TYPE)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PACKAGE_CONTROL_TYPE#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
        <cfif IsDefined("session.ep.userid")>
            UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
        <cfelseif IsDefined("session.pp.userid")>
            UPDATE_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">,
        </cfif>		
        UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
        UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
        CUSTOMS_RECIPE_CODE = <cfif isdefined("attributes.customs_recipe_code") and len(attributes.customs_recipe_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.customs_recipe_code#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
		IS_WATALOGY_INTEGRATED = <cfif isdefined('attributes.is_watalogy_integrated') and attributes.is_watalogy_integrated eq 1><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
		WATALOGY_CAT_ID = <cfif isdefined('attributes.watalogy_cat_id') and isdefined('attributes.watalogy_cat_name') and len(attributes.watalogy_cat_id) and len(attributes.watalogy_cat_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.watalogy_cat_id#"><cfelse>NULL</cfif>,
		PRODUCT_KEYWORD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_keyword#" null="#not len(attributes.product_keyword)#">,
		PRODUCT_DESCRIPTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_description#" null="#not len(attributes.product_description)#">,
		PRODUCT_DETAIL_WATALOGY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_detail_watalogy#" null="#not len(attributes.product_detail_watalogy)#">
        <cfif get_our_company_info.is_product_company eq 0>,QUALITY_START_DATE = <cfif isdefined("attributes.quality_startdate") and len(attributes.quality_startdate)><cfqueryparam cfsqltype="cf_sql_date" value="#attributes.quality_startdate#"><cfelse><cfqueryparam cfsqltype="cf_sql_date" value="" null="yes"></cfif></cfif>,
		ORIGIN_ID = <cfif isdefined("attributes.origin") and len(attributes.origin)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.origin#"><cfelse>NULL</cfif>
		,PURCHASE_CARBON_VALUE = <cfif isDefined('attributes.PURCHASE_CARBON_VALUE') and len(attributes.PURCHASE_CARBON_VALUE)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(attributes.PURCHASE_CARBON_VALUE,8)#"><cfelse>NULL</cfif>
		,SALES_CARBON_VALUE = <cfif isDefined('attributes.SALES_CARBON_VALUE') and len(attributes.SALES_CARBON_VALUE)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(attributes.SALES_CARBON_VALUE,8)#"><cfelse>NULL</cfif>
		,RECYCLE_RATE = <cfif isDefined('attributes.RECYCLE_RATE') and len(attributes.RECYCLE_RATE)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(attributes.RECYCLE_RATE)#"><cfelse>NULL</cfif>
		,RECYCLE_METHOD = <cfif isDefined('attributes.RECYCLE_METHOD') and len(attributes.RECYCLE_METHOD)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.RECYCLE_METHOD#"><cfelse>NULL</cfif>
		,RECYCLE_CALCULATION_TYPE = <cfif isDefined('attributes.RECYCLE_CALCULATION_TYPE') and len(attributes.RECYCLE_CALCULATION_TYPE)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.RECYCLE_CALCULATION_TYPE#"><CFELSE>NULL</cfif>
		,RECOVERY_AMOUNT= <cfif isDefined('attributes.RECOVERY_AMOUNT') and len(attributes.RECOVERY_AMOUNT)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(attributes.RECOVERY_AMOUNT)#"><cfelse>NULL</cfif>
		,PROJECT_ID = <cfif isDefined('attributes.PROJECT_ID') and len(attributes.PROJECT_ID) AND LEN(attributes.PROJECT_HEAD)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PROJECT_ID#"><cfelse>NULL</cfif>
		,P_PROFIT = <cfif isDefined('attributes.P_PROFIT') and len(attributes.P_PROFIT)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(attributes.P_PROFIT)#"><cfelse>NULL</cfif>
		,S_PROFIT = <cfif isDefined('attributes.S_PROFIT') and len(attributes.S_PROFIT)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(attributes.S_PROFIT)#"><cfelse>NULL</cfif>
		,DUEDAY = <cfif isDefined('attributes.DUEDAY') and len(attributes.DUEDAY)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.DUEDAY#"><cfelse>NULL</cfif>
		,MAXIMUM_STOCK = <cfif isDefined('attributes.MAXIMUM_STOCK') and len(attributes.MAXIMUM_STOCK)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.MAXIMUM_STOCK#"><cfelse>NULL</cfif>
		,G_PRODUCT_TYPE = <cfif isDefined('attributes.G_PRODUCT_TYPE') and len(attributes.G_PRODUCT_TYPE)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.G_PRODUCT_TYPE#"><cfelse>NULL</cfif>
		,ADD_STOCK_DAY = <cfif isDefined('attributes.ADD_STOCK_DAY') and len(attributes.ADD_STOCK_DAY)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ADD_STOCK_DAY#"><cfelse>NULL</cfif>
		,MINIMUM_STOCK = <cfif isDefined('attributes.MINIMUM_STOCK') and len(attributes.MINIMUM_STOCK)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.MINIMUM_STOCK#"><cfelse>NULL</cfif>
		,ORDER_LIMIT = <cfif isDefined('attributes.ORDER_LIMIT') and len(attributes.ORDER_LIMIT)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ORDER_LIMIT#"><cfelse>NULL</cfif>
		,INSTRUCTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.INSTRUCTION#">
	WHERE  
        PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.product_id#">
</cfquery>
<cfif get_our_company_info.recordcount and get_our_company_info.IS_PRODUCT_COMPANY neq 1>
    <cfquery name="GET_PRODUCT_COMPANY" datasource="#DSN1#">
        SELECT OUR_COMPANY_ID,PRODUCT_ID FROM PRODUCT_GENERAL_PARAMETERS WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.product_id#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
    </cfquery>
	<cfif not GET_PRODUCT_COMPANY.recordcount>
        <cfquery name="add_general_parameters" datasource="#dsn1#">
            INSERT INTO PRODUCT_GENERAL_PARAMETERS
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
                QUALITY_START_DATE
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#form.product_id#">, 
             	<cfif isDefined("FORM.COMPANY_ID") and len(FORM.COMPANY_ID) and len(FORM.COMP)><cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.COMPANY_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                #session.ep.company_id#,
                <cfif isDefined('attributes.PRODUCT_MANAGER') and len(attributes.PRODUCT_MANAGER) and isDefined('attributes.PRODUCT_MANAGER_NAME') and len(attributes.PRODUCT_MANAGER_NAME)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PRODUCT_MANAGER#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" null="yes" value=""></cfif>,
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
                <cfif isdefined("attributes.quality_startdate") and len(attributes.quality_startdate)><cfqueryparam cfsqltype="cf_sql_date" value="#attributes.quality_startdate#"><cfelse><cfqueryparam cfsqltype="cf_sql_date" value="" null="yes"></cfif>
            )
        </cfquery>
    <cfelse>
        <cfquery name="upd_general_parameters" datasource="#dsn1#">
            UPDATE
                PRODUCT_GENERAL_PARAMETERS
            SET
                PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.product_id#">, 
                COMPANY_ID = <cfif isDefined("FORM.COMPANY_ID") and len(FORM.COMPANY_ID) and len(FORM.COMP)><cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.COMPANY_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                OUR_COMPANY_ID = #session.ep.company_id#,
                PRODUCT_MANAGER = <cfif isDefined('attributes.PRODUCT_MANAGER') and len(attributes.PRODUCT_MANAGER) and isDefined('attributes.PRODUCT_MANAGER_NAME') and len(attributes.PRODUCT_MANAGER_NAME)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PRODUCT_MANAGER#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" null="yes" value=""></cfif>,
                PRODUCT_STATUS = <cfif isDefined("attributes.PRODUCT_STATUS")><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_INVENTORY = <cfif isDefined("form.is_inventory") and form.is_inventory eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_PRODUCTION = <cfif isDefined("form.is_production") and form.is_production eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
                IS_SALES = <cfif isDefined("form.is_sales") and form.is_sales eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
                IS_PURCHASE = <cfif isDefined("form.is_purchase") and form.is_purchase eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
                IS_PROTOTYPE = <cfif isDefined("form.is_prototype") and form.is_prototype eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_INTERNET = <cfif isDefined("form.is_internet") and form.is_internet eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_EXTRANET = <cfif isDefined("form.is_extranet") and form.is_extranet eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
                IS_TERAZI = <cfif isDefined("form.is_terazi") and form.is_terazi eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_KARMA = <cfif isDefined("form.is_karma") and form.is_karma eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_ZERO_STOCK = <cfif isDefined("form.is_zero_stock") and form.is_zero_stock eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_LIMITED_STOCK = <cfif isDefined("form.is_limited_stock") and form.is_limited_stock eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_SERIAL_NO = <cfif isDefined("form.is_serial_no") and form.is_serial_no eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_COST = <cfif isDefined("form.is_cost") and form.is_cost eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_QUALITY = <cfif isDefined("form.is_quality") and form.is_quality eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_COMMISSION = <cfif isDefined("form.is_commission") and form.is_commission eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_ADD_XML = <cfif isDefined("form.is_add_xml") and form.is_add_xml eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_GIFT_CARD = <cfif isDefined('attributes.is_gift_card')><cfqueryparam cfsqltype="cf_sql_integer" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="0"></cfif>,
                IS_LOT_NO = <cfif isDefined("form.is_lot_no") and form.is_lot_no eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                GIFT_VALID_DAY = <cfif isDefined('attributes.gift_valid_day') and len(attributes.gift_valid_day)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.gift_valid_day#"><cfelse>NULL</cfif>,
                QUALITY_START_DATE = <cfif isdefined("attributes.quality_startdate") and len(attributes.quality_startdate)><cfqueryparam cfsqltype="cf_sql_date" value="#attributes.quality_startdate#"><cfelse><cfqueryparam cfsqltype="cf_sql_date" value="" null="yes"></cfif>
            WHERE
                PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.product_id#">
        </cfquery>
		
    </cfif>
</cfif>
<cfquery name="get_lang" datasource="#dsn#">
	SELECT
		ITEM,
		LANGUAGE
	FROM 
		SETUP_LANGUAGE_INFO
	WHERE
		UNIQUE_COLUMN_ID = #attributes.product_id# AND
		COLUMN_NAME = 'PRODUCT_NAME' AND
		TABLE_NAME = 'PRODUCT' AND
        LANGUAGE = '#session.ep.language#'
</cfquery>
<cfif get_lang.recordcount>
	<cfquery name="upd_" datasource="#dsn#">
    	UPDATE SETUP_LANGUAGE_INFO SET ITEM = '#attributes.product_name#' WHERE UNIQUE_COLUMN_ID = #attributes.product_id# AND COLUMN_NAME = 'PRODUCT_NAME' AND TABLE_NAME = 'PRODUCT' AND LANGUAGE = '#session.ep.language#'
    </cfquery>
</cfif>
<cfquery name="get_lang_det" datasource="#dsn#">
	SELECT
		ITEM,
		LANGUAGE
	FROM 
		SETUP_LANGUAGE_INFO
	WHERE
		UNIQUE_COLUMN_ID = #attributes.product_id# AND
		COLUMN_NAME = 'PRODUCT_DETAIL' AND
		TABLE_NAME = 'PRODUCT' AND
        LANGUAGE = '#session.ep.language#'
</cfquery>
<cfif get_lang_det.recordcount>
	<cfquery name="upd_lang_det" datasource="#dsn#">
    	UPDATE SETUP_LANGUAGE_INFO SET ITEM = '#attributes.PRODUCT_DETAIL#' WHERE UNIQUE_COLUMN_ID = #attributes.product_id# AND COLUMN_NAME = 'PRODUCT_DETAIL' AND TABLE_NAME = 'PRODUCT' AND LANGUAGE = '#session.ep.language#'
    </cfquery>
</cfif>
<cfif attributes.is_spect_name_upd eq 1>
	<cfquery name="get_prod_prototype" datasource="#DSN1#">
		SELECT IS_PROTOTYPE FROM PRODUCT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.product_id#">
	</cfquery>
	<cfif get_prod_prototype.IS_PROTOTYPE eq 0>
		<cfquery name="upd_prod_spect" datasource="#dsn3#" maxrows="1">
			UPDATE
				SPECT_MAIN
			SET
				SPECT_MAIN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PRODUCT_NAME#">
			WHERE
				STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_stock_barcode_query.STOCK_ID#"> AND
				SPECT_STATUS = 1
		</cfquery>
	</cfif>
</cfif>
<!--- Custom Tag' a Gidecek Parametreler --->
<cfset pid = attributes.product_id>
<cf_workcube_process 
	is_upd='1' 
	old_process_line='#attributes.old_process_line#'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#'
	record_date='#now()#'
	action_table='PRODUCT'
	action_column='PRODUCT_ID'
	action_id='#attributes.product_id#' 
	action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_product&event=det&pid=#attributes.product_id#' 
	warning_description='Ürün : #attributes.product_name#'>
<!--- //Custom Tag' a Gidecek Parametreler --->
<cfif FORM.BARCOD neq FORM.OLD_BARCOD or attributes.MANUFACT_CODE neq attributes.old_MANUFACT_CODE or attributes.PRODUCT_CODE_2 neq attributes.old_PRODUCT_CODE_2>
	<cfquery name="upd_stock_barcode" datasource="#DSN1#">
		UPDATE
			STOCKS
		SET
			<cfif attributes.PRODUCT_CODE_2 neq attributes.old_PRODUCT_CODE_2>STOCK_CODE_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PRODUCT_CODE_2#">,</cfif>
			<cfif attributes.MANUFACT_CODE neq attributes.old_MANUFACT_CODE>MANUFACT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.MANUFACT_CODE#">,</cfif>
			<cfif FORM.BARCOD neq FORM.OLD_BARCOD>BARCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.BARCOD#">,</cfif>
			STOCK_STATUS = <cfif isDefined("attributes.PRODUCT_STATUS")><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
			UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
			UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#REMOTE_ADDR#">,
			UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
		WHERE
			STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_stock_barcode_query.STOCK_ID#">
	</cfquery>
    <cfif FORM.BARCOD neq FORM.OLD_BARCOD and get_stock_barcode_query.recordcount>
		<cfquery name="upd_stock_barcode" datasource="#dsn1#">
      		UPDATE
				STOCKS_BARCODES
			SET
				BARCODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.BARCOD#">
			WHERE
				BARCODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.OLD_BARCOD#"> AND 
				STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_stock_barcode_query.STOCK_ID#">
        </cfquery>
	</cfif>
</cfif>
<cfquery name="GET_UNIT" datasource="#dsn1#">
	SELECT 
		PRODUCT_UNIT_ID 
	FROM 
		PRODUCT_UNIT 
	WHERE 
		PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.PRODUCT_ID#"> AND 
		IS_MAIN = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND 
		PRODUCT_UNIT_STATUS = 1
</cfquery>
<!--- Standart Alış ve Standart Satış Burada Kayıt Ediliyor --->

<cfif (STANDART_ALIS neq OLD_STANDART_ALIS) or (form.MONEY_ID_SA neq form.MONEY_ID_SA_OLD) or (form.is_tax_included_purchase neq form.old_is_tax_included_purchase) or (form.old_tax_purchase neq form.tax_purchase) or (form.old_tax_sell neq form.tax)>
	<cflock name="#CREATEUUID()#" timeout="60">
		<cftransaction>
			 <cfquery name="DEL_PRODUCT_PRICE_PURCHASE" datasource="#dsn1#">
				DELETE FROM
					PRICE_STANDART
				WHERE
					PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.PRODUCT_ID#"> AND
					PURCHASESALES = <cfqueryparam cfsqltype="cf_sql_smallint" value="0"> AND
					UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_UNIT.PRODUCT_UNIT_ID#"> AND
					START_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bugun_00#">						
			</cfquery> 
			<cfscript>
				if (isnumeric(FORM.STANDART_ALIS))
					if (attributes.is_tax_included_purchase eq 1)
						{
							purchase_kdvsiz = wrk_round(FORM.STANDART_ALIS*100/(attributes.tax_purchase+100),session.ep.our_company_info.purchase_price_round_num);
							purchase_kdvli = FORM.STANDART_ALIS;
							purchase_is_tax_included = 1;
						}
					else
						{
							purchase_kdvsiz = FORM.STANDART_ALIS;
							purchase_kdvli = wrk_round(FORM.STANDART_ALIS*(1+(attributes.tax_purchase/100)),session.ep.our_company_info.purchase_price_round_num);
							purchase_is_tax_included = 0;
						}
				else
					{
						purchase_kdvsiz = 0;
						purchase_kdvli = 0;
						purchase_is_tax_included = 0;
					}					
			</cfscript>
			<cfquery name="CORRECT_PRICE_0" datasource="#dsn1#">
				UPDATE 
					PRICE_STANDART
				SET 
					PRICESTANDART_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="0">,
					RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">
				WHERE 
					PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.PRODUCT_ID#"> AND 
					PURCHASESALES = <cfqueryparam cfsqltype="cf_sql_smallint" value="0"> AND
					UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_UNIT.PRODUCT_UNIT_ID#"> AND
					PRICESTANDART_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
			</cfquery>
			<cfquery name="ADD_STANDART_PRICE" datasource="#dsn1#">
				INSERT INTO 
					PRICE_STANDART
				(
					PRODUCT_ID,
					PURCHASESALES,
					PRICE,
					PRICE_KDV,
					IS_KDV,
					ROUNDING,
					START_DATE,
					RECORD_DATE,
					RECORD_IP,
					PRICESTANDART_STATUS,
					MONEY,
					UNIT_ID,
					RECORD_EMP
				)
				VALUES 
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.PRODUCT_ID#">,
					<cfqueryparam cfsqltype="cf_sql_smallint" value="0">,							
					<cfqueryparam cfsqltype="cf_sql_float" value="#purchase_kdvsiz#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#purchase_kdvli#">,
					<cfqueryparam cfsqltype="cf_sql_smallint" value="#purchase_is_tax_included#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="0">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#bugun_00#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTEADDR#">,
					<cfqueryparam cfsqltype="cf_sql_smallint" value="1">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.MONEY_ID_SA#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#GET_UNIT.PRODUCT_UNIT_ID#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">
				)
			</cfquery>
		</cftransaction>
	</cflock>
</cfif>
<cfif (form.OLD_STANDART_SATIS neq form.STANDART_SATIS) or (form.MONEY_ID_SS neq form.MONEY_ID_SS_OLD) or (form.is_tax_included_sales neq form.old_is_tax_included_sales) or (form.old_tax_purchase neq form.tax_purchase) or (form.old_tax_sell neq form.tax)>
	<cflock name="#CREATEUUID()#" timeout="60">
		<cftransaction>
			<cfquery name="DEL_PRODUCT_PRICE_SALES" datasource="#dsn1#">
				DELETE FROM
					PRICE_STANDART
				WHERE
					PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.PRODUCT_ID#"> AND
					PURCHASESALES = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
					UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_UNIT.PRODUCT_UNIT_ID#"> AND
					START_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bugun_00#">						
			</cfquery>
			<cfscript>
				if (isnumeric(FORM.STANDART_SATIS))
					if (attributes.is_tax_included_sales eq 1)
						{
							price_kdvsiz = wrk_round(FORM.STANDART_SATIS*100/(attributes.tax+100),session.ep.our_company_info.sales_price_round_num);
							price_kdvli = FORM.STANDART_SATIS;
							price_is_tax_included = 1;
						}
					else
						{
							price_kdvsiz = FORM.STANDART_SATIS;
							price_kdvli = wrk_round(FORM.STANDART_SATIS*(1+(attributes.tax/100)),session.ep.our_company_info.sales_price_round_num);
							price_is_tax_included = 0;
						}
				else
					{
						price_kdvsiz = 0;
						price_kdvli = 0;
						price_is_tax_included = 0;
					}					
			</cfscript>
			<cfquery name="CORRECT_PRICE_0" datasource="#dsn1#">
				UPDATE 
					PRICE_STANDART
				SET 
					PRICESTANDART_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="0">,
					RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">
				WHERE 
					PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.PRODUCT_ID#"> AND 
					PURCHASESALES = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
					UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_UNIT.PRODUCT_UNIT_ID#"> AND
					PRICESTANDART_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
			</cfquery>
			<cfquery name="ADD_STANDART_PRICE" datasource="#dsn1#">
				INSERT INTO PRICE_STANDART 
					(
						PRODUCT_ID,
						PURCHASESALES,							
						PRICE,
						PRICE_KDV,
						IS_KDV,
						ROUNDING,
						START_DATE,
						RECORD_DATE,
						RECORD_IP,
						PRICESTANDART_STATUS,
						MONEY,
						UNIT_ID,
						RECORD_EMP
					)
				VALUES 
					(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.PRODUCT_ID#">,
						<cfqueryparam cfsqltype="cf_sql_smallint" value="1">,							
						<cfqueryparam cfsqltype="cf_sql_float" value="#price_kdvsiz#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#price_kdvli#">,
						<cfqueryparam cfsqltype="cf_sql_smallint" value="#price_is_tax_included#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="0">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#bugun_00#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTEADDR#">,
						<cfqueryparam cfsqltype="cf_sql_smallint" value="1">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.MONEY_ID_SS#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#GET_UNIT.PRODUCT_UNIT_ID#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">
					)						
			</cfquery>
           
		</cftransaction>
	</cflock>
</cfif>
<cfquery name="GET_MAX_STCK" datasource="#DSN3#">
	SELECT MAX(STOCK_ID) AS MAX_STCK FROM #dsn1_alias#.STOCKS
</cfquery>
<cfif isdefined('attributes.acc_code_cat') and len(attributes.acc_code_cat)>
	<cfquery name="GET_CODES" datasource="#DSN3#">
		SELECT * FROM SETUP_PRODUCT_PERIOD_CAT WHERE PRO_CODE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.acc_code_cat#">
	</cfquery>
<cfelse>
	<cfset get_codes.recordcount = 0>
</cfif>
<cfif GET_CODES.recordcount>
	<cfquery name = "PRODUCT_PERIOD_CONTROL" datasource="#DSN3#">
		SELECT * FROM PRODUCT_PERIOD WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.PRODUCT_ID#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.PERIOD_ID#"> 
	</cfquery>
  
	<cfif attributes.old_acc_code_cat eq attributes.acc_code_cat> <!--- muhasebe kodu varsa ve degisim olmicaksa --->
	<cfelseif len(attributes.old_acc_code_cat)><!---  daha onceden muhasebe kodu varsa guncelle --->
		<cfquery name="UPD_MAIN_UNIT" datasource="#DSN3#">
			UPDATE 
				PRODUCT_PERIOD 
			SET
				PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.PRODUCT_ID#">,  
				PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.PERIOD_ID#"> ,
				ACCOUNT_CODE = <cfif len(GET_CODES.ACCOUNT_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				ACCOUNT_CODE_PUR = <cfif len(GET_CODES.ACCOUNT_CODE_PUR)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_CODE_PUR#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				ACCOUNT_DISCOUNT = <cfif len(GET_CODES.ACCOUNT_DISCOUNT)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_DISCOUNT#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				ACCOUNT_PRICE = <cfif len(GET_CODES.ACCOUNT_PRICE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_PRICE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				ACCOUNT_PUR_IADE = <cfif len(GET_CODES.ACCOUNT_PUR_IADE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_PUR_IADE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				ACCOUNT_IADE = <cfif len(GET_CODES.ACCOUNT_IADE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_IADE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				ACCOUNT_DISCOUNT_PUR =<cfif len(GET_CODES.ACCOUNT_DISCOUNT_PUR)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_DISCOUNT_PUR#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				ACCOUNT_YURTDISI = <cfif len(GET_CODES.ACCOUNT_YURTDISI)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_YURTDISI#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				ACCOUNT_YURTDISI_PUR = <cfif len(GET_CODES.ACCOUNT_YURTDISI_PUR)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_YURTDISI_PUR#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				EXPENSE_CENTER_ID = <cfif len(GET_CODES.INC_CENTER_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.INC_CENTER_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,			
				EXPENSE_ITEM_ID = <cfif len(GET_CODES.EXP_ITEM_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.EXP_ITEM_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
				INCOME_ITEM_ID = <cfif len(GET_CODES.INC_ITEM_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.INC_ITEM_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
				EXPENSE_TEMPLATE_ID =<cfif len(GET_CODES.EXP_TEMPLATE_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.EXP_TEMPLATE_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,  
				ACTIVITY_TYPE_ID = <cfif len(GET_CODES.EXP_ACTIVITY_TYPE_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.EXP_ACTIVITY_TYPE_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,		 
				COST_EXPENSE_CENTER_ID = <cfif len(GET_CODES.EXP_CENTER_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.EXP_CENTER_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>, 
				INCOME_ACTIVITY_TYPE_ID = <cfif len(GET_CODES.INC_ACTIVITY_TYPE_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.INC_ACTIVITY_TYPE_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,	
				INCOME_TEMPLATE_ID = <cfif len(GET_CODES.INC_TEMPLATE_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.INC_TEMPLATE_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
				ACCOUNT_LOSS = <cfif len(GET_CODES.ACCOUNT_LOSS)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_LOSS#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				ACCOUNT_EXPENDITURE = <cfif len(GET_CODES.ACCOUNT_EXPENDITURE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_EXPENDITURE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				OVER_COUNT = <cfif len(GET_CODES.OVER_COUNT)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.OVER_COUNT#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				UNDER_COUNT = <cfif len(GET_CODES.UNDER_COUNT)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.UNDER_COUNT#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				PRODUCTION_COST = <cfif len(GET_CODES.PRODUCTION_COST)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PRODUCTION_COST#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,	
				HALF_PRODUCTION_COST =<cfif len(GET_CODES.HALF_PRODUCTION_COST)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.HALF_PRODUCTION_COST#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				SALE_PRODUCT_COST = <cfif len(GET_CODES.SALE_PRODUCT_COST)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.SALE_PRODUCT_COST#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,					 
				MATERIAL_CODE = <cfif len(GET_CODES.MATERIAL_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.MATERIAL_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				KONSINYE_PUR_CODE = <cfif len(GET_CODES.KONSINYE_PUR_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.KONSINYE_PUR_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				KONSINYE_SALE_CODE = <cfif len(GET_CODES.KONSINYE_SALE_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.KONSINYE_SALE_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				KONSINYE_SALE_NAZ_CODE = <cfif len(GET_CODES.KONSINYE_SALE_NAZ_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.KONSINYE_SALE_NAZ_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				DIMM_CODE = <cfif len(GET_CODES.DIMM_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.DIMM_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				DIMM_YANS_CODE = <cfif len(GET_CODES.DIMM_YANS_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.DIMM_YANS_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				PROMOTION_CODE = <cfif len(GET_CODES.PROMOTION_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PROMOTION_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				PRODUCT_PERIOD_CAT_ID = <cfif isdefined('attributes.acc_code_cat') and len(attributes.acc_code_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.acc_code_cat#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
				ACCOUNT_PRICE_PUR = <cfif len(GET_CODES.ACCOUNT_PRICE_PUR)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_PRICE_PUR#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				MATERIAL_CODE_SALE = <cfif len(GET_CODES.MATERIAL_CODE_SALE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.MATERIAL_CODE_SALE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				PRODUCTION_COST_SALE = <cfif len(GET_CODES.PRODUCTION_COST_SALE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PRODUCTION_COST_SALE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				SALE_MANUFACTURED_COST = <cfif len(GET_CODES.SALE_MANUFACTURED_COST)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.SALE_MANUFACTURED_COST#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				PROVIDED_PROGRESS_CODE = <cfif len(GET_CODES.PROVIDED_PROGRESS_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PROVIDED_PROGRESS_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				SCRAP_CODE_SALE = <cfif len(GET_CODES.SCRAP_CODE_SALE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.SCRAP_CODE_SALE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				SCRAP_CODE = <cfif len(GET_CODES.SCRAP_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.SCRAP_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				PROD_GENERAL_CODE = <cfif len(GET_CODES.PROD_GENERAL_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PROD_GENERAL_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				PROD_LABOR_COST_CODE = <cfif len(GET_CODES.PROD_LABOR_COST_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PROD_LABOR_COST_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				RECEIVED_PROGRESS_CODE = <cfif len(GET_CODES.RECEIVED_PROGRESS_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.RECEIVED_PROGRESS_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				INVENTORY_CAT_ID = <cfif len(GET_CODES.INVENTORY_CAT_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.INVENTORY_CAT_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				INVENTORY_CODE = <cfif len(GET_CODES.INVENTORY_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.INVENTORY_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				AMORTIZATION_METHOD_ID = <cfif len(GET_CODES.AMORTIZATION_METHOD_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_METHOD_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				AMORTIZATION_TYPE_ID = <cfif len(GET_CODES.AMORTIZATION_TYPE_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_TYPE_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				AMORTIZATION_EXP_CENTER_ID = <cfif len(GET_CODES.AMORTIZATION_EXP_CENTER_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_EXP_CENTER_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				AMORTIZATION_EXP_ITEM_ID = <cfif len(GET_CODES.AMORTIZATION_EXP_ITEM_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_EXP_ITEM_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				AMORTIZATION_CODE = <cfif len(GET_CODES.AMORTIZATION_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				RECORD_EMP =  <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">,
				RECORD_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
				RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTEADDR#">
			WHERE 
				PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.PRODUCT_ID#"> 
			AND 
				PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.PERIOD_ID#"> 	
		</cfquery>	
	<cfelse> <!--- ürünün muhasebe kodu girilmemisse --->
		<!--- Muhasebe kodu popupından yapılan tanımlamaları kontrol etmediği için ürün muhasebe kodu tanımları birden fazla oluyordu --->
		<cfquery name="delOldPeriods" datasource="#dsn3#">
			DELETE FROM PRODUCT_PERIOD WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.PRODUCT_ID#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.PERIOD_ID#">
		</cfquery>
		<cfquery name="UPD_MAIN_UNIT" datasource="#DSN3#">
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
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.PRODUCT_ID#">,
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
				<cfif len(GET_CODES.AMORTIZATION_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTEADDR#">
			)
		</cfquery>		
	</cfif>
</cfif>
<!---Ek Bilgiler--->
<cfset attributes.info_id =  attributes.product_id>
<cfset attributes.is_upd = 1>
<cfset attributes.info_type_id=-5>
<cfinclude template="../../objects/query/add_info_plus2.cfm">
<cfset attributes.actionId = attributes.product_id>
<!---Ek Bilgiler--->
<!--- Standart Alış ve Standart Satış Kaydı Bitti --->
<script>
	window.location.href = '<cfoutput>/index.cfm?fuseaction=product.list_product&event=det&pid=#FORM.PRODUCT_ID#</cfoutput>';
</script>

