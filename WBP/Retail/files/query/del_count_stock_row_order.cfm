<!---oluşan tablo satırını sil
tabloya bağlı stocks_row daki satırları sil--->
<cfquery name="del_table_row" datasource="#DSN_dev#">
	DELETE FROM
		STOCK_MANAGE_TABLES
	WHERE
		TABLE_CODE = '#attributes.table_code#'
</cfquery>

<cfquery name="del_stock_row" datasource="#DSN2#">
	DELETE FROM
		STOCKS_ROW
	WHERE
		WRK_ROW_ID = '#attributes.table_code#'
</cfquery>
<script>
	alert('İlgili Kayıtlar Silindi!!!');
	window.opener.location.reload();
	window.close();
</script>
