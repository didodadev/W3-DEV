
<script type="text/javascript">
	function process_cat_function_62()
	{	
		if(document.getElementsByName('product_id').length != undefined && document.getElementsByName('product_id').length > 0 )
		{
			var bsk_rowCount = document.getElementsByName('product_id').length;
			for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++)
			{
				var related_ship_info = wrk_query("SELECT SUM(AMOUNT) AMOUNT FROM SHIP_ROW WHERE WRK_ROW_RELATION_ID = '" + document.getElementsByName('wrk_row_relation_id')[str_i_row].value+"'" ,"dsn3");
				
				if (related_ship_info.AMOUNT-old_ship_info.OLD_TOTAL_AMOUNT < filterNum(document.getElementsByName('amount')[str_i_row].value))
				{
					alert(parseInt(str_i_row)+1+ ".Satırdaki Miktar, Kalan Sipariş Miktarından Fazla Olamaz!");
					return false;
				}				
			}
		}

		return true;
	}
</script>

