<!--- Surecin Asamasinda Yetkili Degilse veya Tum Calisanlar Degilse Uyari Verir FBS 20091119 --->
<script type="text/javascript">
function process_cat_dsp_function()
{
	var get_process_sql = wrk_safe_query('prc_get_process','dsn',0,document.all.process_stage.value);
	var process_all_employee = wrk_safe_query('prc_process_all_employee','dsn',0,document.all.process_stage.value);
	if(get_process_sql.recordcount == 0 && process_all_employee.recordcount == 0)
	{
		alert('Belgenin Bu Aşamasında Yetkiniz Yok!');
		return false;
	}
	return true;
}
</script>

