<cfif not len(attributes.barcode)>
	<script>
		alert('Barkod Giriniz!');
		history.back();
	</script>
    <cfabort>
</cfif>
<cfquery name="get_barcodes" datasource="#dsn1#">
    SELECT 
        SB.BARCODE,
        S.STOCK_ID,
        S.STOCK_CODE PROPERTY,
        S.PRODUCT_ID
    FROM 
        STOCKS_BARCODES SB,
        STOCKS S,
        PRODUCT P
    WHERE
        S.STOCK_ID = SB.STOCK_ID AND
        S.PRODUCT_ID = P.PRODUCT_ID AND
        SB.BARCODE = '#attributes.barcode#'
</cfquery>

<cfquery name="get_file_amount" datasource="#DSN_dev#">
    UPDATE
        STOCK_COUNT_ORDERS_ROWS
    SET
        AMOUNT = #filternum(attributes.amount)#,
        BARCODE = '#attributes.barcode#',
        STOCK_ID = <cfif get_barcodes.recordcount>#get_barcodes.STOCK_ID#<cfelse>NULL</cfif>,
        STOCK_NAME = <cfif get_barcodes.recordcount>'#get_barcodes.PROPERTY#'<cfelse>NULL</cfif>,
        UPDATE_DATE = #now()#,
        UPDATE_EMP = #session.ep.userid#,
        UPDATE_IP = '#cgi.REMOTE_ADDR#',
        IS_UPDATE = 1
    WHERE
        ROW_ID = #attributes.row_id#
</cfquery>
<script type="text/javascript">
	window.opener.location.reload();
	window.close();
</script>