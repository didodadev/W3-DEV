<script language="javascript">
	function process_cat_function_201()
	{
		for(jj=1;jj<=document.all.record_num.value;jj++)
		{
			if(eval("document.all.row_kontrol"+jj).value==1)
			{
				if(eval("document.all.expense_center_id"+jj).value != '')
				{
					var get_code = wrk_query('SELECT EXPENSE_CODE FROM EXPENSE_CENTER WHERE EXPENSE_ID = ' + eval("document.all.expense_center_id"+jj).value,'dsn2','1');
					if(get_code.recordcount > 0)
					{
						var get_code2 = wrk_query("SELECT EXPENSE_CODE FROM EXPENSE_CENTER WHERE EXPENSE_ID <> " + eval("document.all.expense_center_id"+jj).value+" AND EXPENSE_CODE LIKE '"+get_code.EXPENSE_CODE[0]+"%'","dsn2",'1');
						if(get_code2.recordcount > 0)
						{
							alert("Masraf Merkezinin Alt Masraf Merkezi Mevcut! Satır:"+jj);
							return false;
						}
					}
				}
			}
		}
		return true;
	}
</script>
