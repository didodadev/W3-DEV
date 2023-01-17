<cfif len(attributes.quality_startdate)><cf_date tarih="attributes.quality_startdate"></cfif>
<cfquery name="GET_CONTROL" datasource="#dsn1#">
	SELECT PRODUCT_ID FROM PRODUCT_GENERAL_PARAMETERS WHERE PRODUCT_ID = #attributes.pid# AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfquery name="get_our_company_info" datasource="#dsn#">
	SELECT IS_PRODUCT_COMPANY FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfif GET_CONTROL.RECORDCOUNT>
    <cfquery name="upd_general_parameters" datasource="#dsn1#">
        UPDATE
            PRODUCT_GENERAL_PARAMETERS
        SET
            PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">, 
            COMPANY_ID = <cfif attributes.COMPANY_ID is ""><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.COMPANY_ID#"></cfif>,
            OUR_COMPANY_ID = <cfif attributes.OUR_COMPANY_ID is ""><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.OUR_COMPANY_ID#"></cfif>,
            PRODUCT_MANAGER = <cfif attributes.PRODUCT_MANAGER is ""><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PRODUCT_MANAGER#"></cfif>,
            PRODUCT_STATUS = <cfif isDefined("attributes.product_status") and attributes.product_status eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
            IS_INVENTORY = <cfif isDefined("attributes.is_inventory") and attributes.is_inventory eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            IS_PRODUCTION = <cfif isDefined("attributes.is_production") and attributes.is_production eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
            IS_SALES = <cfif isDefined("attributes.is_sales") and attributes.is_sales eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
            IS_PURCHASE = <cfif isDefined("attributes.is_purchase") and attributes.is_purchase eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
            IS_PROTOTYPE = <cfif isDefined("attributes.is_prototype") and attributes.is_prototype eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            IS_INTERNET = <cfif isDefined("attributes.is_internet") and attributes.is_internet eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            IS_EXTRANET = <cfif isDefined("attributes.is_extranet") and attributes.is_extranet eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
            IS_TERAZI = <cfif isDefined("attributes.is_terazi") and attributes.is_terazi eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            IS_KARMA = <cfif isDefined("attributes.is_karma") and attributes.is_karma eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            IS_ZERO_STOCK = <cfif isDefined("attributes.is_zero_stock") and attributes.is_zero_stock eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            IS_LIMITED_STOCK = <cfif isDefined("attributes.is_limited_stock") and attributes.is_limited_stock eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            IS_SERIAL_NO = <cfif isDefined("attributes.is_serial_no") and attributes.is_serial_no eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            IS_COST = <cfif isDefined("attributes.is_cost") and attributes.is_cost eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            IS_QUALITY = <cfif isDefined("attributes.is_quality") and attributes.is_quality eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            IS_COMMISSION = <cfif isDefined("attributes.is_commission") and attributes.is_commission eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            IS_ADD_XML = <cfif isDefined("attributes.is_add_xml") and attributes.is_add_xml eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            IS_GIFT_CARD = <cfif isDefined("attributes.is_gift_card") and attributes.is_gift_card eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            GIFT_VALID_DAY = <cfif isDefined("attributes.gift_valid_day") and len(attributes.gift_valid_day)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.GIFT_VALID_DAY#"><cfelse>NULL</cfif>,
            QUALITY_START_DATE = <cfif isdefined("attributes.quality_startdate") and len(attributes.quality_startdate)>#attributes.quality_startdate#<cfelse>NULL</cfif>
        WHERE
            PRODUCT_ID = #attributes.pid#
            AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
    </cfquery>
    <cfif get_our_company_info.is_product_company eq 1>
        <cfquery name="UPD_PRODUCT" datasource="#DSN1#">
            UPDATE 
                PRODUCT 
            SET 
                PRODUCT_STATUS = <cfif isDefined("attributes.PRODUCT_STATUS")><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_QUALITY = <cfif isDefined("attributes.is_quality")><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_COST = <cfif isDefined("attributes.IS_COST")><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_INVENTORY = <cfif isDefined("attributes.IS_INVENTORY")><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_PRODUCTION = <cfif isDefined("attributes.IS_PRODUCTION")><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_SALES = <cfif isDefined("attributes.IS_SALES")><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_PURCHASE = <cfif isDefined("attributes.IS_PURCHASE")><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_PROTOTYPE = <cfif isDefined("attributes.IS_PROTOTYPE")><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_TERAZI = <cfif isDefined("attributes.IS_TERAZI")><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_SERIAL_NO = <cfif isDefined("attributes.IS_SERIAL_NO")><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_ZERO_STOCK = <cfif isDefined("attributes.IS_ZERO_STOCK")><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_KARMA = <cfif isDefined("attributes.IS_KARMA")><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_LIMITED_STOCK = <cfif isDefined("attributes.is_limited_stock")><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_COMMISSION = <cfif isDefined("attributes.is_commission")><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_ADD_XML = <cfif isDefined("attributes.is_add_xml") and attributes.is_add_xml eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_LOT_NO = <cfif isDefined("attributes.is_lot_no") and attributes.is_lot_no eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                COMPANY_ID = <cfif isDefined("attributes.COMPANY_ID") and len(attributes.COMPANY_ID) and len(attributes.COMP)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.COMPANY_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                PRODUCT_MANAGER = <cfif isDefined('attributes.PRODUCT_MANAGER') and len(attributes.PRODUCT_MANAGER) and isDefined('attributes.PRODUCT_MANAGER_NAME') and len(attributes.PRODUCT_MANAGER_NAME)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PRODUCT_MANAGER#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" null="yes" value=""></cfif>,
                IS_INTERNET = <cfif isDefined('attributes.is_internet')><cfqueryparam cfsqltype="cf_sql_integer" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="0"></cfif>,
                IS_EXTRANET = <cfif isDefined('attributes.is_extranet')><cfqueryparam cfsqltype="cf_sql_integer" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="0"></cfif>,
                IS_GIFT_CARD = <cfif isDefined('attributes.is_gift_card')><cfqueryparam cfsqltype="cf_sql_integer" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="0"></cfif>,
                GIFT_VALID_DAY = <cfif isDefined('attributes.gift_valid_day') and len(attributes.gift_valid_day)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.gift_valid_day#"><cfelse>NULL</cfif>
            WHERE 
                PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
    </cfquery>
    </cfif>
<cfelse>
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
            GIFT_VALID_DAY,
            QUALITY_START_DATE
        )
        VALUES
        (
            <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">,
            <cfif attributes.COMPANY_ID is ""><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.COMPANY_ID#"></cfif>,
            <cfif attributes.OUR_COMPANY_ID is ""><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.OUR_COMPANY_ID#"></cfif>,
            <cfif attributes.PRODUCT_MANAGER is ""><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PRODUCT_MANAGER#"></cfif>,
            <cfif isDefined("attributes.product_status") and attributes.product_status eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            <cfif isDefined("attributes.is_inventory") and attributes.is_inventory eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            <cfif isDefined("attributes.is_production") and attributes.is_production eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            <cfif isDefined("attributes.is_sales") and attributes.is_sales eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            <cfif isDefined("attributes.is_purchase") and attributes.is_purchase eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            <cfif isDefined("attributes.is_prototype") and attributes.is_prototype eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            <cfif isDefined("attributes.is_internet") and attributes.is_internet eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            <cfif isDefined("attributes.is_extranet") and attributes.is_extranet eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            <cfif isDefined("attributes.is_terazi") and attributes.is_terazi eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            <cfif isDefined("attributes.is_karma") and attributes.is_karma eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            <cfif isDefined("attributes.is_zero_stock") and attributes.is_zero_stock eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            <cfif isDefined("attributes.is_limited_stock") and attributes.is_limited_stock eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            <cfif isDefined("attributes.is_serial_no") and attributes.is_serial_no eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            <cfif isDefined("attributes.is_cost") and attributes.is_cost eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            <cfif isDefined("attributes.is_quality") and attributes.is_quality eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            <cfif isDefined("attributes.is_commission") and attributes.is_commission eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            <cfif isDefined("attributes.is_add_xml") and attributes.is_add_xml eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            <cfif isDefined("attributes.is_gift_card") and attributes.is_gift_card eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
            <cfif isDefined("attributes.gift_valid_day") and len(attributes.gift_valid_day)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.GIFT_VALID_DAY#"><cfelse>NULL</cfif>,
            <cfif isdefined("attributes.quality_startdate") and len(quality_startdate)>#attributes.quality_startdate#<cfelse>NULL</cfif>
        )
    </cfquery>
</cfif>
<script type="text/javascript">
    <cfif not isdefined("attributes.draggable")>
        wrk_opener_reload();
	    window.close();
    <cfelse>
        closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
    </cfif>
</script>
