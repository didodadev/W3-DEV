<cfif not listlen(attributes.STOCK_ID_LIST)>
	<script>
		alert('Stok Girmediniz!');
		history.back();
	</script>
    <cfabort>
</cfif>
<cfloop list="#attributes.STOCK_ID_LIST#" index="stock_id_">
    <cfset s_name_= wrk_eval('attributes.stock_name_#stock_id_#')>
    <cfset s_barcode_ = evaluate('attributes.stock_barcode_#stock_id_#')>
    <cfset s_amount_ = evaluate('attributes.amount_#stock_id_#')>
    <cfif len(s_amount_)>
        <cfquery name="add_" datasource="#dsn_dev#">
            INSERT INTO
                STOCK_COUNT_ORDERS_ROWS
                (
                STOCK_ID,
                STOCK_NAME,
                BARCODE,
                ORDER_ID,
                AMOUNT,
                RECORD_EMP,
                RECORD_DATE,
                RECORD_IP
                )
                VALUES
                (
                #stock_id_#,
                '#s_name_#',
                '#s_barcode_#',
                #attributes.order_id#,
                #filternum(s_amount_)#,
                #session.ep.userid#,
                #now()#,
                '#cgi.REMOTE_ADDR#'
                )
        </cfquery>
    </cfif>
</cfloop>
<script>
    window.location.href = "<cfoutput>#request.self#?fuseaction=retail.list_stock_count_orders_rows&event=add&order_id=#attributes.order_id#</cfoutput>";
</script>