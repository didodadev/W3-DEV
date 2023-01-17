<cfsetting showdebugoutput="no"><!--- <cfdump var="#attributes#"><cfabort> --->
<script type="text/javascript">
function get_spect_cat_pro_<cfoutput>#attributes.is_multi_no#</cfoutput>()
{
	var maxrows = <cfoutput>#attributes.MAXROWS#</cfoutput>;
	var spect_cat_pro_div_genislik = parseInt(<cfoutput>#attributes.form_name#.#attributes.field_name#.style.width</cfoutput>);
	spect_cat_prpty_<cfoutput>#attributes.is_multi_no#</cfoutput>.style.width = spect_cat_pro_div_genislik;
	var spect_property_max_length = wrk_round((spect_cat_pro_div_genislik*0.14),0);
	var get_spect_cat_property_workdata = workdata('get_spect_cat_property',<cfoutput>#attributes.form_name#.#attributes.field_name#.value,maxrows,#attributes.property_id#</cfoutput>);
	var total_property = maxrows;
	var total_property_name = '';
	if(get_spect_cat_property_workdata.recordcount)
	{
		eval("spect_cat_prpty_<cfoutput>#attributes.is_multi_no#</cfoutput>").style.display = '';
		if(get_spect_cat_property_workdata.recordcount < total_property)
			total_property = get_spect_cat_property_workdata.recordcount;
		for(i=0;i<total_property;i++)
		{
			var baslik = get_spect_cat_property_workdata.PROPERTY_DETAIL[i];
			var baslik = baslik.substr(0,spect_property_max_length);
			var property_name1 = '<a href="javascript://" onClick="add_property_<cfoutput>#attributes.is_multi_no#</cfoutput>('+get_spect_cat_property_workdata.PROPERTY_DETAIL_ID[i]+','+'\''+get_spect_cat_property_workdata.PROPERTY_DETAIL[i]+'\');">'+baslik+'</a><br/>';
			total_property_name = total_property_name + property_name1;
		}
		property_td_<cfoutput>#attributes.is_multi_no#</cfoutput>.innerHTML = total_property_name;
	}
	else	
		div_close_property_<cfoutput>#attributes.is_multi_no#</cfoutput>();
	if(<cfoutput>#attributes.form_name#.#attributes.field_name#</cfoutput>.value.length == 0)
		{
		<cfoutput>
		#attributes.form_name#.#attributes.field_id#.value = '';
		#attributes.form_name#.#attributes.field_name#.value = '#attributes.default_property_name#';
		//div_close_property_#attributes.is_multi_no#();
		</cfoutput>
		}
}
function add_property_<cfoutput>#attributes.is_multi_no#</cfoutput>(property_id,property_name)
{
	<cfoutput>#attributes.form_name#.#attributes.field_id#.value =<cfoutput>#attributes.property_id#</cfoutput>+'-'+property_id;</cfoutput>
	<cfoutput>#attributes.form_name#.#attributes.field_name#.value = property_name;</cfoutput>
	div_close_property_<cfoutput>#attributes.is_multi_no#</cfoutput>();
}
function div_close_property_<cfoutput>#attributes.is_multi_no#</cfoutput>()
{	<cfoutput>
	spect_cat_prpty_#attributes.is_multi_no#.style.display = 'none';
	property_td_#attributes.is_multi_no#.innerHTML = '';
	</cfoutput>
}
</script>
<script type="text/javascript">
get_spect_cat_pro_<cfoutput>#attributes.is_multi_no#</cfoutput>();
</script>
