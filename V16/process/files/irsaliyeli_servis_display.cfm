<script type="text/javascript">
function process_cat_dsp_function()
{
	product_name_ = document.add_service.service_product.value;
	product_id_ = document.add_service.service_product_id.value;
	stock_id_ = document.add_service.stock_id.value;
	department_id_ = document.add_service.department_id.value;
	location_id_ = document.add_service.location_id.value;
	department_ = document.add_service.department.value;
	seri_ = document.add_service.service_product_serial.value;
	garanti_ = document.add_service.GUARANTY_START_DATE.value;

	if(product_name_=='' || product_id_=='' || stock_id_=='')
	{
		alert("<cf_get_lang_main no='815.Ürün Seçmelisiniz'>!");
		return false;
	}
	
	if(seri_=='')
	{
		alert("<cf_get_lang no ='91.Seri No Girmelisiniz'>!");
		return false;
	}
	
	if(garanti_=='')
	{
		alert("<cf_get_lang no ='92.Garanti Tarihi Girmelisiniz'>!");
		return false;
	}
	
	if(department_id_=='' || location_id_=='' || department_=='')
	{
		alert("<cf_get_lang no ='93.Depo Seçmelisiniz'>!");
		return false;
	}
	
	return true;
}
</script>

