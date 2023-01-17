<cfif form.active_company neq session.ep.company_id>
	<script type="text/javascript">
		alert("<cf_get_lang no ='862.İşlemin Muhasebe Dönemi İle Aktif Muhasebe Döneminiz Farklı'>...<cf_get_lang no ='863.Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=product.collacted_product_prices</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfif not isdefined("form.is_record_active")>
	<script type="text/javascript">
		alert(" <cf_get_lang no ='804.En az 1 ürün seçmelisiniz'> !");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfif attributes.is_active neq -1 and attributes.is_active neq -2 and (isdefined("attributes.price_cat_list") and not len(attributes.price_cat_list))>
	<script type="text/javascript">
		alert("<cf_get_lang no ='868.En az 1 fiyat listesi seçmelisiniz'> !");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfif (attributes.is_active neq -2) and not isdate(attributes.start_date)>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='326.Başlangıç Tarihi Girmelisiniz'> !");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfif isdate(attributes.start_date)><!--- (attributes.is_active neq -2) and AK20041018 --->
	<cf_date tarih="attributes.start_date">
	<cfset attributes.start_date = date_add("h", attributes.start_clock, attributes.start_date)>
	<cfset attributes.start_date = date_add("n", attributes.start_min, attributes.start_date)>
</cfif>
<cfloop list="#attributes.is_record_active#" index="record_product_id_kontrol">
	<cfscript>
		purchase_price_kontrol = evaluate('attributes.purchase_price#record_product_id_kontrol#');
		sales_price_kontrol = evaluate('attributes.sales_price#record_product_id_kontrol#');
		sales_price_with_tax_kontrol = evaluate('attributes.sales_price_with_tax#record_product_id_kontrol#');
	</cfscript>
	<cfif ( len(purchase_price_kontrol) and  (not isNumeric(purchase_price_kontrol)) ) or ( len(sales_price_kontrol) and  (not isNumeric(sales_price_kontrol)) ) or ( len(sales_price_with_tax_kontrol) and  (not isNumeric(sales_price_with_tax_kontrol)) )>
		<script type="text/javascript">
			alert("<cf_get_lang no ='869.Hatalı input'> ! (<cf_get_lang no ='870.Browser hatası'>)");
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfloop>
<cflock name="#createuuid()#" timeout="180">
	<cftransaction>  
        <cfloop list="#attributes.is_record_active#" index="record_product_id"><!--- GET_PRODUCT --->
            <cfscript>
                //yer = ListFind(attributes.product_id, record_PRODUCT_ID);
                tax_purchase = evaluate('attributes.tax_purchase_val#record_product_id#');
                purchase_price = evaluate('attributes.purchase_price#record_product_id#');
                purchase_price_with_tax = purchase_price*((tax_purchase+100)/100);
                purchase_price_old = evaluate('attributes.purchase_price_old#record_product_id#');
                purchase_money = evaluate('attributes.sales_money#record_product_id#');//purchase_money
        
                sales_price = evaluate('attributes.sales_price#record_product_id#');
                sales_price_with_tax = evaluate('attributes.sales_price_with_tax#record_product_id#');
                sales_price_old = evaluate('attributes.sales_price_old#record_product_id#');
                sales_price_with_tax_old = evaluate('attributes.sales_price_with_tax_old#record_product_id#');
                sales_money = evaluate('attributes.sales_money#record_product_id#');
                unit_id = evaluate('attributes.unit_id#record_product_id#');
                stock_id = evaluate('attributes.stock_id#record_product_id#');
                product_id = evaluate('attributes.product_id#record_product_id#');
            </cfscript>
			<cfif attributes.is_active eq -1><!--- Düzenleme Fiyatı Standart Alış ise... --->
                <cfquery name="DEL_PRODUCT_PRICE_PURCHASE" datasource="#DSN3#">
                    DELETE FROM
                        #dsn1_alias#.PRICE_STANDART
                    WHERE
                        PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"> AND
                        PURCHASESALES = 0 AND
                        UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#unit_id#"> AND
                        START_DATE = #attributes.start_date#						
                </cfquery>
                    
                <cfquery name="ADD_PRODUCT_PRICE_PURCHASE" datasource="#DSN3#">
                    INSERT INTO
                        #dsn1_alias#.PRICE_STANDART
                    (
                        PRICESTANDART_STATUS,
                        PRODUCT_ID,
                        PURCHASESALES,
                        PRICE,
                        PRICE_KDV,
                        IS_KDV,
                        ROUNDING,
                        MONEY,
                        UNIT_ID,
                        START_DATE,
                        RECORD_DATE,
                        RECORD_EMP,
                        RECORD_IP
                    )
                    VALUES
                    (
                        0,
                        #product_id#,
                        0,
                        <cfif len(sales_price)>#sales_price#<cfelse>0</cfif>,
                        <cfif len(sales_price_with_tax)>#sales_price_with_tax#<cfelse>0</cfif>,
                        <cfif isdefined("is_tax_included#record_product_id#")>1<cfelse>0</cfif>,<!--- 1 --->
                        0,
                        '#sales_money#',
                        #unit_id#,
                        #attributes.start_date#,
                        #now()#,
                        #session.ep.userid#,
                        '#CGI.REMOTE_ADDR#'
                    )
                </cfquery>
                
                <cfquery name="UPD_PRICE_STANDART_PURCHASE_STAT_0" datasource="#DSN3#">
                    UPDATE
                        #dsn1_alias#.PRICE_STANDART
                    SET
                        PRICESTANDART_STATUS = 0
                    WHERE
                        PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"> AND
                        PURCHASESALES = 0 AND
                        UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#unit_id#"> AND
                        PRICESTANDART_STATUS = 1
                </cfquery>
                <cfquery name="GET_MAX_ST_PURCHASE_DATE_ID" datasource="#DSN3#" maxrows="1">
                    SELECT 
                        MAX(PRICESTANDART_ID) AS PRICESTANDART_ID
                    FROM 
                        #dsn1_alias#.PRICE_STANDART 
                    WHERE 
                        PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"> AND
                        PURCHASESALES = 0 AND
                        UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#unit_id#"> AND 
                        START_DATE = (	SELECT MAX(START_DATE) AS START_DATE 
                                        FROM #dsn1_alias#.PRICE_STANDART 
                                        WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"> AND PURCHASESALES = 0 AND UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#unit_id#">)
                </cfquery>
                <cfquery name="UPD_PRICE_STANDART_PURCHASE_STAT_1" datasource="#DSN3#">
                    UPDATE
                        #dsn1_alias#.PRICE_STANDART
                    SET
                        PRICESTANDART_STATUS = 1
                    WHERE
                        PRICESTANDART_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_st_purchase_date_id.pricestandart_id#">
                </cfquery>
			<cfelseif attributes.is_active eq -2>
                <cfquery name="DEL_PRODUCT_PRICE_SALES" datasource="#DSN3#">
                    DELETE FROM
                        #dsn1_alias#.PRICE_STANDART
                    WHERE
                        PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"> AND
                        PURCHASESALES = 1 AND
                        UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#unit_id#"> AND
                        START_DATE = #attributes.start_date#						
                </cfquery>
                <cfquery name="ADD_PRODUCT_PRICE_SALES" datasource="#DSN3#">
                    INSERT INTO
                        #dsn1_alias#.PRICE_STANDART
                    (
                        PRICESTANDART_STATUS,
                        PRODUCT_ID,
                        PURCHASESALES,
                        PRICE,
                        PRICE_KDV,
                        IS_KDV,
                        ROUNDING,
                        MONEY,
                        UNIT_ID,
                        START_DATE,
                        RECORD_DATE,
                        RECORD_EMP,
                        RECORD_IP
                    )
                    VALUES
                    (
                        0,
                        #product_id#,
                        1,
                        <cfif len(sales_price)>#sales_price#<cfelse>0</cfif>,
                        <cfif len(sales_price_with_tax)>#sales_price_with_tax#<cfelse>0</cfif>,
                        <cfif isdefined("is_tax_included#record_product_id#")>1<cfelse>0</cfif>,<!--- 1 --->
                        0,
                        '#sales_money#',
                        #unit_id#,
                        #attributes.start_date#,
                        #now()#,
                        #session.ep.userid#,
                        '#CGI.REMOTE_ADDR#'
                    )
                </cfquery>
                <cfquery name="UPD_PRICE_STANDART_SALES_STAT_0" datasource="#DSN3#">
                    UPDATE
                        #dsn1_alias#.PRICE_STANDART
                    SET
                        PRICESTANDART_STATUS = 0
                    WHERE
                        PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"> AND
                        PURCHASESALES = 1 AND
                        UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#unit_id#"> AND
                        PRICESTANDART_STATUS = 1
                </cfquery>
                <cfquery name="GET_MAX_ST_DATE_ID" datasource="#DSN3#" maxrows="1">
                    SELECT 
                        MAX(PRICESTANDART_ID) AS PRICESTANDART_ID
                    FROM 
                        #dsn1_alias#.PRICE_STANDART 
                    WHERE 
                        PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"> AND
                        PURCHASESALES = 1 AND
                        UNIT_ID = #unit_id# AND 
                        START_DATE = (	SELECT MAX(START_DATE) AS START_DATE 
                                        FROM #dsn1_alias#.PRICE_STANDART 
                                        WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"> AND PURCHASESALES = 1 AND UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#unit_id#">)
                </cfquery>
                <cfquery name="UPD_PRICE_STANDART_SALES_STAT_1" datasource="#DSN3#">
                    UPDATE
                        #dsn1_alias#.PRICE_STANDART
                    SET
                        PRICESTANDART_STATUS = 1
                    WHERE
                        PRICESTANDART_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_st_date_id.pricestandart_id#">
                </cfquery>
            <cfelse>
				<cfif sales_price gt 0 and sales_price_with_tax gt 0>
                    <cfquery datasource="#dsn3#" name="new_price_add_method" timeout="300">
                        <cfloop list="#attributes.price_cat_list#" index="pricecat">
                            exec add_price 
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">,
                                    #unit_id#,
                                    #pricecat#,
                                    #attributes.start_date#,
                                    #sales_price#,
                                    '#sales_money#',
                                    <cfif isdefined("is_tax_included#record_product_id#")>1<cfelse>0</cfif>,<!--- 1, --->
                                    #sales_price_with_tax#,
                                    -1,
                                    #session.ep.userid#,
                                    '#cgi.remote_addr#',
                                    0,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#">,
                                    0
                        </cfloop>
                    </cfquery>
                </cfif>
            </cfif>
        </cfloop>
    </cftransaction>
</cflock>
<!--- sürec icin fiyat eklenen urunlerden birazının ismi alındı uyarıd yazsın diye... --->
<cfquery name="GET_PROD_NAME" datasource="#DSN1#" maxrows="10">
	SELECT PRODUCT_ID, PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID IN (#attributes.product_id#)
</cfquery>
<cfset prod_name_list=''>
<cfoutput query="get_prod_name">
	<cfset prod_name_list = prod_name_list & '#product_name#,'>
    <cf_workcube_process 
        is_upd='1' 
        old_process_line='0'
        process_stage='#attributes.process_stage#' 
        record_member='#session.ep.userid#'
        record_date='#now()#' 
        action_id='#product_id#' 
        action_page='#request.self#?fuseaction=product.collacted_product_prices'
        warning_description='Toplu Ürün Fiyat Ekleme : #prod_name_list#'>
</cfoutput>

<script type="text/javascript">
	<cfif attributes.window_status eq 0>
		window.location = '<cfoutput>#request.self#?fuseaction=product.collacted_product_prices</cfoutput>';
	<cfelse>
		history.back();
	</cfif>
</script>
