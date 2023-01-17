<cfif not isdefined("attributes.product_id")>
	<script>
		alert('Ürün Seçmelisiniz!');
		history.back();
	</script>
    <cfabort>
</cfif>

<cfquery name="upd_" datasource="#dsn1#">
    UPDATE
        PRODUCT 
    SET 
		<cfif len(attributes.product_status)>PRODUCT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.product_status#">,</cfif>
        <cfif len(attributes.sales_status)>IS_SALES = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.sales_status#">,</cfif>
        <cfif len(attributes.internet_status)>IS_INTERNET = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.internet_status#">,</cfif>
        <cfif len(attributes.extranet_status)>IS_EXTRANET = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.extranet_status#">,</cfif>
        <cfif len(attributes.zero_stock_status)>IS_ZERO_STOCK = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.zero_stock_status#">,</cfif>
        <cfif len(attributes.serial_no_status)>IS_SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.serial_no_status#">,</cfif>
        <cfif len(attributes.production_status)>IS_PRODUCTION = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.production_status#">,</cfif>
        <cfif len(attributes.purchase_status)>IS_PURCHASE = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.purchase_status#">,</cfif>
        <cfif len(attributes.limited_stock)>IS_LIMITED_STOCK = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.limited_stock#">,</cfif>
        <cfif len(attributes.inventory_status)>IS_INVENTORY = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.inventory_status#">,</cfif>
        <cfif len(attributes.cost_status)>IS_COST = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.cost_status#">,</cfif>
        <cfif len(attributes.is_quality)>IS_QUALITY = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.is_quality#">,</cfif>
        <cfif len(attributes.mixed_parcel)>IS_KARMA = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.mixed_parcel#">,</cfif>
        <cfif len(attributes.scale_status)>IS_TERAZI = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.scale_status#">,</cfif>
        <cfif len(attributes.prototype)>IS_PROTOTYPE = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.prototype#">,</cfif>
        <cfif len(attributes.pos_commission_status)>IS_COMMISSION = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.pos_commission_status#">,</cfif>
        <cfif len(attributes.package_control_type)>PACKAGE_CONTROL_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.package_control_type#">,</cfif>
        <cfif len(attributes.price_authority)>PROD_COMPETITIVE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_authority#">,</cfif>
        <cfif len(attributes.tax_purchase)>TAX_PURCHASE = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.tax_purchase#">,</cfif>
        <cfif len(attributes.tax)>TAX = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.tax#">,</cfif>
        <cfif len(attributes.new_company_id) and len(attributes.new_comp)>COMPANY_ID = #attributes.new_company_id#,</cfif>
		<cfif isdefined("attributes.new_brand_id") and len(attributes.new_brand_id) and len(attributes.new_brand_name)>BRAND_ID = #attributes.new_brand_id#,</cfif>
        <cfif len(attributes.cat_id) and len(attributes.category_name)>
       	 PRODUCT_CATID = #attributes.cat_id#,
        </cfif>
        UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
        UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">,
        UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
    WHERE
    	PRODUCT_ID IN (#attributes.product_id#)
</cfquery>

<cfquery name="get_p" datasource="#dsn1#">
    SELECT * FROM PRODUCT WHERE PRODUCT_ID IN (#attributes.product_id#)
</cfquery>
<cfoutput query="get_p">
    <cfset pid_ = product_id>
    <cfset product_status = product_status>
    <cfquery name="get_stocks" datasource="#dsn1#">
        SELECT * FROM STOCKS WHERE PRODUCT_ID = #pid_#
    </cfquery>
      <cfloop query="get_stocks">
        <cfset sid_ = get_stocks.stock_id>
        <cfquery name="upd_stocks_status" datasource="#dsn1#">
            UPDATE
               STOCKS
           SET
               STOCK_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#product_status#">
           WHERE
               STOCK_ID = #sid_#
        </cfquery>
    </cfloop>
</cfoutput>
<cfif len(attributes.cat_id) and len(attributes.category_name)>
	<cfquery name="GET_CAT_CODE" datasource="#DSN1#">
        SELECT 
            PC.PRODUCT_CATID, 
            PC.HIERARCHY,
            P.PRODUCT_ID 
        FROM 
            PRODUCT_CAT PC,
            PRODUCT P
        WHERE
            P.PRODUCT_CATID = PC.PRODUCT_CATID AND
            P.PRODUCT_CATID = #attributes.cat_id#
    </cfquery>
    <cfset new_hie = GET_CAT_CODE.HIERARCHY>
    
    <cfoutput query="get_p">
    	<cfset product_code_simple_ = listlast(product_code,'.')>
        <cfset new_code_ = new_hie & '.' & product_code_simple_>
        <cfset pid_ = product_id>
        
        <cfquery name="get_stocks" datasource="#dsn1#">
        	SELECT * FROM STOCKS WHERE PRODUCT_ID = #pid_#
        </cfquery>
        
        <cfquery name="upd_p_" datasource="#dsn1#">
        	UPDATE
            	PRODUCT
            SET
            	PRODUCT_CODE = '#new_code_#'
            WHERE
            	PRODUCT_ID = #pid_#
        </cfquery>
        <cfloop query="get_stocks">
        	 <cfset sid_ = get_stocks.stock_id>
             <!---<cfset code_simple_ = listlast(get_stocks.stock_code,'.')>---> <!--- stok kodunu yakalama işlemi 65. satırda da yapılıyor. 66. satırda yeni stok kodu bulunuyor. Burada tekrar bulunup aşağıda eklendiği için stok kodları çokluyor. --->
             <cfquery name="upd_2" datasource="#dsn1#">
             	UPDATE
                	STOCKS
                SET
                	STOCK_CODE = '#new_code_#'<!--- .#code_simple_# --->
                WHERE
                	STOCK_ID = #sid_#
             </cfquery>
        </cfloop>
    </cfoutput>
</cfif>

<cfif len(attributes.new_comp1) and len(attributes.new_company_id1)>
	<cfloop list="#attributes.product_id#" index="pid">
    	<cfquery name="add_" datasource="#dsn3#">
        	INSERT INTO
            	CONTRACT_PURCHASE_PROD_DISCOUNT
                (
                PRODUCT_ID,
                COMPANY_ID,
                PAYMETHOD_ID,
                START_DATE,
                FINISH_DATE,
                PROCESS_STAGE,
                RECORD_DATE,
                RECORD_EMP,
                RECORD_IP
                )
                VALUES
                (
                #pid#,
                #attributes.new_company_id1#,
                1,
                #now()#,
                #dateadd("yyyy",50,now())#,
                67,
                #now()#,
                #session.ep.userid#,
                '#cgi.REMOTE_ADDR#'
                )
        </cfquery>
    </cfloop>
</cfif>

<cfif len(attributes.new_comp2) and len(attributes.new_company_id2)>
	<cfloop list="#attributes.product_id#" index="pid">
    	<cfquery name="add_" datasource="#dsn3#">
        	INSERT INTO
            	CONTRACT_PURCHASE_PROD_DISCOUNT
                (
                PRODUCT_ID,
                COMPANY_ID,
                PAYMETHOD_ID,
                START_DATE,
                FINISH_DATE,
                PROCESS_STAGE,
                RECORD_DATE,
                RECORD_EMP,
                RECORD_IP
                )
                VALUES
                (
                #pid#,
                #attributes.new_company_id2#,
                1,
                #now()#,
                #dateadd("yyyy",50,now())#,
                67,
                #now()#,
                #session.ep.userid#,
                '#cgi.REMOTE_ADDR#'
                )
        </cfquery>
    </cfloop>
</cfif>

<cf_add_log  log_type="1" action_id="1" action_name="Ürün Bilgileri Güncelleme">
<script type="text/javascript">
	alert("<cf_get_lang no='990.İşleminiz Başarı İle Tamamlandı'>!");
	window.location.href='<cfoutput>#request.self#?fuseaction=product.change_product_info</cfoutput>';
</script>