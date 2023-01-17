<cfset session_base = session_base?:session.ep />
<cfset jc = createObject("component","workcube.cfc.queryJSONConverter")>
<cfquery name="GET_CASH_REG" datasource="#DSN2#">
	SELECT
            USE_FOREIGN_CURRENCY,
            USE_CATEGORY_ICON,
            USE_PRODUCT_IMAGE,
            USE_CUSTOMER_RECORD,
            USE_LOYALTY_CARD,
            AMOUNT_ROUND,
            PRICE_ROUND,
            CUSTOMER_ID,
            USE_LOT_NO,
            USE_SERIAL_NO,
            POS_ID,
            POS_PROCESS_CAT,
            PRICE_CAT_ID
        FROM
            #dsn3#.POS_EQUIPMENT
	WHERE
        EQUIPMENT_CODE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#session_base.whops.equipment_code#">
</cfquery>
<cfset CashRegObject =  replace(serializeJSON( jc.returnData( replace(serializeJSON( GET_CASH_REG),"//","") ) ), "//", "")>
