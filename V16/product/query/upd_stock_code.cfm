<cfset form.barcod = trim(form.barcod)>
<cfif attributes.NEW_STOCK_CODE eq attributes.PCODE>
    <cfquery name="UPD_PRODUCT_STATUS" datasource="#DSN1#">
        UPDATE 
            PRODUCT 
        SET 
            PRODUCT_STATUS = #iif(isDefined('form.stock_status'),1,0)#
        WHERE 
            PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PRODUCT_ID#">
    </cfquery>
</cfif>

<cfquery name="CHECK_CODE" datasource="#DSN1#">
	SELECT 
		STOCK_ID
	FROM 
		STOCKS 
	WHERE 
		STOCK_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.new_stock_code)#"> AND 
		STOCK_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#form.stock_id#">
</cfquery>
<cfquery name="chk_stock_barcode" datasource="#dsn1#">
	SELECT STOCK_ID FROM STOCKS_BARCODES WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.stock_id#">
</cfquery>
<cfif check_code.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='891.Girdiğiniz Stok Kodu Başka Bir Stok Tarafından Kullanılmakta Lütfen Başka Bir Stok Kodu Giriniz'> !");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfif len(form.barcod)>
	<cfquery name="CHECK_BARCODE" datasource="#DSN1#">
		SELECT
			STOCK_ID
		FROM
			GET_STOCK_BARCODES_ALL
		WHERE
			BARCODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.barcod#"> AND 
			STOCK_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#form.stock_id#">
	</cfquery>
	<cfif check_barcode.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='892.Girdiğiniz Barkod Başka Bir Stok Tarafından Kullanılmakta Lütfen Başka Bir Barkod Giriniz!'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>
<cflock name="#CREATEUUID()#" timeout="60">
	<cftransaction>
        <cfquery name="UPD_STOCK_CODE" datasource="#DSN1#">
            UPDATE 
                STOCKS 
            SET 
                STOCK_CODE = '#trim(new_stock_code)#',
                STOCK_CODE_2 = '#trim(stock_code_2)#',
                PROPERTY = '#form.property_detail#',
                BARCOD = '#form.barcod#',
                PRODUCT_UNIT_ID = #form.unit#,
                SERIAL_BARCOD = <cfif len(attributes.serial_barcod)>#form.serial_barcod#<cfelse>NULL</cfif>,
                MANUFACT_CODE = '#form.manufact_code#',
                STOCK_STATUS = #iif(isDefined('form.stock_status'),1,0)#,
                FRIENDLY_URL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.friendly_url#">,
                COUNTER_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.counter_type_id#" null="#(isDefined('attributes.counter_type_id') and len(attributes.counter_type_id)) ? 'no' : 'yes'#">,
                COUNTER_MULTIPLIER = <cfif isDefined('attributes.counter_multiplier') and len(attributes.counter_multiplier)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(attributes.counter_multiplier)#"><cfelse>NULL</cfif>,
                UPDATE_EMP = #session.ep.userid#,
                UPDATE_IP = '#REMOTE_ADDR#',
                UPDATE_DATE =  #now()#,
                ASSORTMENT_DEFAULT_AMOUNT = <cfif isDefined('attributes.assortment_default_amount') and len(attributes.assortment_default_amount)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assortment_default_amount#"><cfelse>NULL</cfif>
            WHERE
                STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.stock_id#">
        </cfquery>

        <cfquery name="UPD_STOCK_" datasource="#DSN1#">
			UPDATE 
				STOCKS 
			SET 
				STOCK_STATUS = #iif(isDefined('form.stock_status'),1,0)#
			WHERE 
				STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#trim(new_stock_code)#%">
		</cfquery>

        <cfif chk_stock_barcode.recordcount>
            <cfquery name="UPD_STOCK_BARCODE" datasource="#DSN1#">
                UPDATE
                    STOCKS_BARCODES
                SET
                    BARCODE = '#attributes.barcod#',
                    UNIT_ID = #form.unit#
                WHERE
                	<cfif len(attributes.old_barcod)>
                    	BARCODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.old_barcod#"> AND 
                    </cfif>
                    STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.stock_id#">
            </cfquery>
        <cfelse>
        	<cfquery name="ADD_STOCK_BARCODE" datasource="#DSN1#">
                INSERT INTO
                    STOCKS_BARCODES
                (
                    STOCK_ID,
                    BARCODE,
                    UNIT_ID
                )
                VALUES 
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#form.stock_id#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.barcod#">,
                    #form.unit#
                )
            </cfquery>
        </cfif>	
        <cfif form.old_barcod neq form.barcod or attributes.manufact_code neq attributes.old_manufact_code or attributes.stock_code_2 neq attributes.old_stock_code_2>
            <!--- barcode göre düzenliyordu artık ana çeşitmi diye kontrol koydum yine barcode bakıyor kaldırabiliriz --->
            <cfquery name="GET_PROD" datasource="#DSN1#">
                SELECT
                    MIN(STOCK_ID) MIN_STOCK_ID
                FROM
                    STOCKS
                WHERE
                    PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
            </cfquery>
            <cfif get_prod.min_stock_id eq form.stock_id>
                <cfquery name="UPD_PRODUCT_BARCODE" datasource="#DSN1#">
                    UPDATE
                        PRODUCT
                    SET
						<cfif attributes.stock_code_2 neq attributes.old_stock_code_2>PRODUCT_CODE_2 = '#attributes.stock_code_2#',</cfif>
                        <cfif attributes.manufact_code neq attributes.old_manufact_code>MANUFACT_CODE = '#attributes.old_manufact_code#',</cfif>
                        <cfif attributes.barcod neq attributes.old_barcod>BARCOD = '#attributes.barcod#',</cfif>
                        UPDATE_EMP = #session.ep.userid#,
                        UPDATE_IP = '#REMOTE_ADDR#',
                        UPDATE_DATE =  #now()#
                    WHERE
                        BARCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.old_barcod#"> AND 
                        PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
                </cfquery>
            </cfif>
        </cfif>
        <cfquery name="DEL_PROPERTIES" datasource="#DSN1#">
            DELETE FROM STOCKS_PROPERTY WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
        </cfquery>
        <cfif attributes.property_count gt 0>
            <cfloop from="1" to="#attributes.property_count#" index="i">
                <cfif isdefined('attributes.property_id_#i#')>
                    <cfquery name="ADD_STOCK_PROPERTY" datasource="#DSN1#">
                        INSERT INTO
                            STOCKS_PROPERTY
                        (
                            STOCK_ID,
                            PROPERTY_ID,
                            PROPERTY_DETAIL_ID,
                            PROPERTY_DETAIL,
                            TOTAL_MIN,
                            TOTAL_MAX			
                        )
                        VALUES
                        (
                            #form.stock_id#,
                            #evaluate('attributes.property_id_#i#')#,
                            <cfif len(evaluate('attributes.sub_property_list_#i#'))>#evaluate('attributes.sub_property_list_#i#')#<cfelse>NULL</cfif>,
                            '#wrk_eval('attributes.property_detail2_#i#')#',
                            '#wrk_eval('attributes.total_min_#i#')#',
                            '#wrk_eval('attributes.total_max_#i#')#'
                        )
                    </cfquery>
                </cfif>
            </cfloop>
        </cfif>
        <cfif isdefined("attributes.lot_no") and len(attributes.lot_no) and len(attributes.lot_number)>
            <cfquery name="get_" datasource="#dsn1#">
                SELECT * FROM  LOT_NO_COUNTER  WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
            </cfquery>
            <cfif NOT get_.recordcount>
                <cfquery name="UPD_PRODUCT_BARCODE" datasource="#DSN1#">
                    INSERT INTO 
                        LOT_NO_COUNTER
                    (
                        LOT_NO,
                        LOT_NUMBER,
                        STOCK_ID
                        
                    )
                    VALUES
                    (
                        '#attributes.lot_no#',
                        '#attributes.lot_number#',
                        #attributes.stock_id#
                    )
                </cfquery>
            <cfelse>
                <cfquery name="UPD_PRODUCT_BARCODE" datasource="#DSN1#">
                    UPDATE
                        LOT_NO_COUNTER
                    SET
                        LOT_NO = '#attributes.lot_no#',
                        LOT_NUMBER = '#attributes.lot_number#'
                    WHERE
                    STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
                </cfquery>
            </cfif>
        </cfif>
        <cfif isdefined("attributes.counter_multiplier") and len(attributes.counter_multiplier)>
            <cfquery name="get_stock_price_standart_purchase" datasource="#DSN1#">
                SELECT PRICESTANDART_ID FROM PRICE_STANDART WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#"> AND PURCHASESALES = 0 AND PRICESTANDART_STATUS = 1
            </cfquery>
            <cfquery name="UPD_PRICE_STANDART" datasource="#DSN1#">
                <cfif get_stock_price_standart_purchase.recordcount>
                    UPDATE PRICE_STANDART SET 
                        PRICE = <cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(attributes.purchase_price)#">,
                        PRICE_KDV = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.purchase_price_kdv#">,
					    IS_KDV = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.purchase_is_kdv#">,
                        MONEY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.purchase_money#">
                    WHERE PRICESTANDART_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_stock_price_standart_purchase.PRICESTANDART_ID#">
                <cfelse>
                    INSERT INTO PRICE_STANDART(
                        PRICESTANDART_STATUS,
                        PURCHASESALES,
                        PRICE,
                        PRICE_KDV,
                        IS_KDV,
                        MONEY,
                        UNIT_ID,
                        STOCK_ID,
                        RECORD_EMP,
                        RECORD_IP,
                        RECORD_DATE
                    )VALUES(
                        1,
                        0,
                        <cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(attributes.purchase_price)#">,
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.purchase_price_kdv#">,
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.purchase_is_kdv#">,
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.purchase_money#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.unit#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">,
                        #session.ep.userid#,
                        '#REMOTE_ADDR#',
                        #now()#
                    )
                </cfif>
            </cfquery>

            <cfquery name="get_stock_price_standart_sales" datasource="#DSN1#">
                SELECT PRICESTANDART_ID FROM PRICE_STANDART WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#"> AND PURCHASESALES = 1 AND PRICESTANDART_STATUS = 1
            </cfquery>
            <cfquery name="UPD_PRICE_STANDART" datasource="#DSN1#">
                <cfif get_stock_price_standart_sales.recordcount>
                    UPDATE PRICE_STANDART SET 
                        PRICE = <cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(attributes.sales_price)#">,
                        PRICE_KDV = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.sales_price_kdv#">,
					    IS_KDV = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.sales_is_kdv#">,
                        MONEY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.sales_money#">
                    WHERE PRICESTANDART_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_stock_price_standart_sales.PRICESTANDART_ID#">
                <cfelse>
                    INSERT INTO PRICE_STANDART(
                        PRICESTANDART_STATUS,
                        PURCHASESALES,
                        PRICE,
                        PRICE_KDV,
                        IS_KDV,
                        MONEY,
                        UNIT_ID,
                        STOCK_ID,
                        RECORD_EMP,
                        RECORD_IP,
                        RECORD_DATE
                    )VALUES(
                        1,
                        1,
                        <cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(attributes.sales_price)#">,
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.sales_price_kdv#">,
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.sales_is_kdv#">,
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.sales_money#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.unit#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">,
                        #session.ep.userid#,
                        '#REMOTE_ADDR#',
                        #now()#
                    )
                </cfif>
            </cfquery>
        <cfelse>
            <cfquery name="DELETE_PRICE_STANDART" datasource="#DSN1#">
                DELETE FROM PRICE_STANDART WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
            </cfquery>
        </cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
        location.href = document.referrer;
    <cfelse>
        closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','unique__dsp_product_stocks_' );
    </cfif>
</script>
