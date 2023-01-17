<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="Yes">
<!---
By : Barbaros KUZ 20070713
Description :
	Proje secilen yerlerde input alanina girilen ifade ile baslayan proje adlarini bulur 
	Ve secilmesi icin o anda inputun altina div acar.
Parameters :
	form_name		-- 	required
	property_id 		--	required
	property_name	-- 	required
	max_rows 		-- 	not required
	min_char 		-- 	not required
	is_multi_no		-- 	not required
	
	spect_property_max_length degiskeni fazla gelen text ifadenin belli bir karaktere kadar olan bolumunu almak icin kullanilir.
	Ayrıca property_name ifadesinin uzunlugu yoksa property_id ifadesi de bosaltilir.
	Div uzunlugu ve karakter uzunlugu otomatik olarak duzenlenir.
Syntax :
	<cf_wrk_projects form_name = 'search_project' property_name='property_name' property_id='property_id'>
	<input type="hidden" name="property_id" value="<cfoutput>#attributes.property_id#</cfoutput>">
	<input type="text" name="property_name" value="<cfoutput>#attributes.property_name#</cfoutput>" onKeyUp="get_spect_cat_pro_1();" style="width:140px;">
	Bir formda ikinci kez kullanilirsa (is_multi_no parametresi tanimlanmali)
	<cf_wrk_projects form_name='add_cari_to_cari' property_id='property_id_2' property_name='property_name_2' is_multi_no='2'>
	<input type="hidden" name="property_id_2" value="">						
	<input type="text" name="property_name_2" value="" style="width:175px;" onkeyup="get_spect_cat_pro_2();">
	
Revisions :
	Barbaros KUZ 20070718
	Barbaros KUZ 20080123	
--->
<cfparam name="attributes.is_multi_no" default='1'>
<cfparam name="caller.attributes.max_rows" default="20">
<cfparam name="caller.attributes.min_char" default="3">

<script type="text/javascript">
function get_spect_cat_pro_<cfoutput>#attributes.is_multi_no#</cfoutput>()
{	
	var max_rows = <cfoutput>#caller.attributes.max_rows#</cfoutput>;
	//var min_char = <cfoutput>#caller.attributes.min_char#</cfoutput>;
	var spect_cat_pro_div_genislik = parseInt(<cfoutput>#attributes.form_name#.#attributes.property_name#.style.width</cfoutput>);
	spect_cat_prpty_<cfoutput>#attributes.is_multi_no#</cfoutput>.style.width = spect_cat_pro_div_genislik;
	var spect_property_max_length = wrk_round((spect_cat_pro_div_genislik*0.14),0);
	/*if(<cfoutput>#attributes.form_name#.#attributes.property_name#</cfoutput>.value.length >= min_char)
	{*/
		var get_spect_cat_property_workdata = workdata('get_spect_cat_property',<cfoutput>#attributes.form_name#.#attributes.property_name#</cfoutput>.value,max_rows,list_getat(<cfoutput>#attributes.form_name#.#attributes._property_id_#</cfoutput>.value,1,','));
		var total_property = max_rows;		
		var total_property_name = '';
		//alert(list_getat(<cfoutput>#attributes.form_name#.#attributes._property_id_#</cfoutput>.value,1,','));
		if(get_spect_cat_property_workdata.recordcount)
		{
			eval("spect_cat_prpty_<cfoutput>#attributes.is_multi_no#</cfoutput>").style.display = '';
			if(get_spect_cat_property_workdata.recordcount < total_property)
				total_property = get_spect_cat_property_workdata.recordcount;
			for(i=0;i<total_property;i++)
			{
				var baslik = get_spect_cat_property_workdata.PROPERTY_DETAIL[i];
				var baslik = baslik.substr(0,spect_property_max_length);
				var property_name1 = '<a href="javascript://" onClick="add_property_<cfoutput>#attributes.is_multi_no#</cfoutput>('+get_spect_cat_property_workdata.PROPERTY_DETAIL_ID[i]+','+'\''+get_spect_cat_property_workdata.PROPERTY_DETAIL[i]+'\');">'+baslik+'</a><br />';
				total_property_name = total_property_name + property_name1;
			}
			property_td_<cfoutput>#attributes.is_multi_no#</cfoutput>.innerHTML = total_property_name;
		}
		else
			div_close_property_<cfoutput>#attributes.is_multi_no#</cfoutput>();
		if(<cfoutput>#attributes.form_name#.#attributes.property_name#</cfoutput>.value.length == 0)
			{<cfoutput>
			#attributes.form_name#.#attributes.property_id#.value = '';
			#attributes.form_name#.#attributes.property_name#.value=list_getat(#attributes.form_name#.#attributes._property_id_#.value,2,',');</cfoutput>
			}
}

function add_property_<cfoutput>#attributes.is_multi_no#</cfoutput>(property_id,property_name)
{
	<cfoutput>#attributes.form_name#.#attributes.property_id#.value =list_getat(<cfoutput>#attributes.form_name#.#attributes._property_id_#</cfoutput>.value,1,',')+'-'+property_id;</cfoutput>
	<cfoutput>#attributes.form_name#.#attributes.property_name#.value = property_name;</cfoutput>
	div_close_property_<cfoutput>#attributes.is_multi_no#</cfoutput>();
}
function div_close_property_<cfoutput>#attributes.is_multi_no#</cfoutput>()
{
	spect_cat_prpty_<cfoutput>#attributes.is_multi_no#</cfoutput>.style.display = 'none';
	property_td_<cfoutput>#attributes.is_multi_no#</cfoutput>.innerHTML = '';
}
</script>

<div id="spect_cat_prpty_<cfoutput>#attributes.is_multi_no#</cfoutput>" style="position:absolute;display:none;z-index:9999;"><br />
	<table class="color-border" cellpadding="2" cellspacing="1" width="100%">
		<tr height="18" class="color-row">
			<td id="property_td_<cfoutput>#attributes.is_multi_no#</cfoutput>">&nbsp;</td>
		</tr>
	</table>
</div>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">
