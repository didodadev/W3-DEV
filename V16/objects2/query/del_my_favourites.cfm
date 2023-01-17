<cfsetting showdebugoutput="no">
<cfquery name="DEL_FAVORITIES" datasource="#dsn3#">
	DELETE FROM ORDER_PRE_PRODUCTS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
</cfquery>
<br /><br/>Ürün Favorilerinizden Çıkarıldı
<script type="text/javascript">
	goster(_message_);
	setTimeout("gizle_message_box()",2000);
	function gizle_message_box()
	{
		gizle(_message_);
	}
</script>
<cfabort>
