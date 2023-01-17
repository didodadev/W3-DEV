<!--- standart uretim emri seri no baski --->
<cfquery name="Get_Det_Po" datasource="#dsn3#">
	SELECT
		PO.P_ORDER_ID,
		PO.QUANTITY,
		PO.FINISH_DATE,
		PO.P_ORDER_NO,
		S.PROPERTY,
		P.PRODUCT_NAME,
		P.PRODUCT_ID,
		S.STOCK_ID
	FROM
		PRODUCTION_ORDERS PO,
		STOCKS S,
		PRODUCT P
	WHERE
		PO.P_ORDER_ID = #attributes.action_id# AND
		PO.STOCK_ID = S.STOCK_ID AND
		S.PRODUCT_ID = P.PRODUCT_ID
</cfquery>
<cfquery name="Get_Stock_Info" datasource="#dsn3#">
	SELECT * FROM STOCKS S WHERE S.STOCK_ID = #Get_Det_Po.STOCK_ID#
</cfquery>
<cfquery name="Get_ServiceGuaranty" datasource="#dsn3#">
	SELECT 
	    GUARANTY_ID,
    	PROCESS_CAT,
        PROCESS_ID,
        PROCESS_NO,
        SERIAL_NO,
        STOCK_ID 
	FROM 
    	SERVICE_GUARANTY_NEW SGN 
    WHERE
    	SGN.STOCK_ID = #Get_Stock_Info.STOCK_ID# AND 
        PROCESS_NO = '#Get_Det_Po.P_ORDER_NO#'
</cfquery>
<cfloop from="1" to="#Get_Det_Po.Quantity#" index="i">
	<table border="0" cellpadding="0" cellspacing="0">
        <tr>
        	<td valign="top">
            <table border="0" cellpadding="0" cellspacing="0">
            <cfoutput>
            	<tr>
                	<td style="width:40mm;height:20mm;" align="center" class="print">
						#Get_Det_Po.PRODUCT_NAME# #Get_Det_Po.PROPERTY#
						<CF_BarcodeGenerator BarCode="#Get_ServiceGuaranty.SERIAL_NO#">
                    </td>
                </tr>
			</cfoutput>
            </table>
            </td>
        </tr>
    </table>
</cfloop>

