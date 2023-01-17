<cfsetting showdebugoutput="no">
<cfif not isdefined("attributes.product_id")>
	<cfquery name="get_stock" datasource="#DSN3#">
		SELECT 
			PRODUCT_ID,
			STOCK_ID,
			PRODUCT_NAME,
			PROPERTY
		FROM 
			STOCKS 
		WHERE 
			STOCK_ID = #attributes.stock_id#
	</cfquery>
</cfif>
<cfif isdefined("attributes.product_id") and not isdefined("attributes.stock_id")>
	<cfquery name="GET_STOCK" datasource="#DSN3#" maxrows="1">
		SELECT 
			PRODUCT_ID,
			STOCK_ID,
			PRODUCT_NAME,
			PROPERTY
		FROM 
			STOCKS 
		WHERE 
			PRODUCT_ID = #attributes.product_id#
	</cfquery>
</cfif>
<cfquery name="add_main_product_" datasource="#dsn#">
	INSERT INTO
		ORDER_PRE_ROWS
	(
		PRODUCT_ID,
		STOCK_ID,
		PRODUCT_NAME,
		QUANTITY,
		EMPLOYEE_ID,
		RECORD_IP,
		RECORD_DATE,
<!---        IS_NONDELETE_PRODUCT,--->
		PERIOD_ID,
		COMPANY_ID
	)
	VALUES
	(
		#get_stock.PRODUCT_ID#,
		#get_stock.stock_id#,
		'#get_stock.product_name# #get_stock.property#',
		#attributes.quantity#,
		#session.ep.userid#,
		'#cgi.remote_addr#',
		#now()#,
<!---        0,--->
		#session.ep.period_id#,
		#session.ep.company_id#
	)
</cfquery>
<script type="text/javascript">
	alert('Ürün Çalışma Sepetinize Eklendi.');
	document.getElementById('speed_to_basket_div').style.display = 'none';
</script>
