<cf_wrk_grid search_header = "#getLang(dictionary_id:63502)#" table_name="PRODUCT_TREE_TYPE" sort_column="TYPE" u_id="TYPE_ID" datasource="#dsn#" search_areas = "TYPE" >
    <cf_wrk_grid_column name="TYPE_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="TYPE" header="#getLang('','bileşenler ',48653)#" select="yes" width="150" display="yes"/>
    <cf_wrk_grid_column  name="WASTE_RATE" header="#getLang('','Fire Oranı ',36357)#" select="yes"  display="yes" type="numeric" onclick="fire_control()"/>
</cf_wrk_grid>
<script type="text/javascript">
    function fire_control()
	{ 
		if($('#WASTE_RATE').val() != '' && $('#WASTE_RATE').val() > 100)
		{
			alert("<cf_get_lang dictionary_id='60525.Fire Oranı 100den büyük olamaz'>!");
			$('#WASTE_RATE').val('');
		}			
	}
</script>