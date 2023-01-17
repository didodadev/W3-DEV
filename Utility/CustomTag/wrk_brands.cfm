<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="Yes">
<!---
By : 
Abdüsselam KARATAŞ 20061125

Description :
	Marka secilen yerlerde input alanina girilen ifade ile baslayan markalari adlarini bulur.
	Ve secilmesi icin o anda inputun altina div acar.
Parameters :
	form_name		-- 	required
	brand_id 		-- 	required
	brand_name 		-- 	required
	max_rows 		-- 	not required
	min_char 		--  not required
	
	brand_max_length degiskeni fazla gelen text ifadenin belli bir karaktere kadar olan bolumunu almak icin kullanilir.
	Ayrıca brand_name ifadesinin uzunlugu yoksa brand_id ifadesi de bosaltilir.	
	Div uzunlugu ve karakter uzunlugu otomatik olarak duzenlenir.
Syntax :
	text alana onKeyUp="get_brand();" şeklinde ifade eklenmeli
	<cf_wrk_brands form_name='search_product' brand_id='brand_id' brand_name='brand_name'>
	<input type="hidden" name="brand_id" value="<cfoutput>#attributes.brand_id#</cfoutput>">
	<input type="text" name="brand_name" value="<cfoutput>#attributes.brand_name#</cfoutput>" onKeyUp="get_brand();" style="width:140px;">
Revisions :
	Barbaros KUZ 20070718
--->
<cfparam name="attributes.max_rows" default="20">
<cfparam name="attributes.min_char" default="3">

<script type="text/javascript">
function get_brand()
{
	var max_rows = <cfoutput>#attributes.max_rows#</cfoutput>;
	var min_char = <cfoutput>#attributes.min_char#</cfoutput>;
	var brand_div_genislik = parseInt(<cfoutput>#attributes.form_name#.#attributes.brand_name#.style.width</cfoutput>);
	brand_div.style.width = brand_div_genislik;
	var brand_max_length = wrk_round((brand_div_genislik*0.14),0);
	
	if(<cfoutput>#attributes.form_name#.#attributes.brand_name#</cfoutput>.value.length >= min_char)
	{
		var get_product_brand = workdata('get_brand',<cfoutput>#attributes.form_name#.#attributes.brand_name#</cfoutput>.value,max_rows);
		var total_brand_no = max_rows;
		var total_brandname = '';
		if(get_product_brand.recordcount)
		{
			brand_div.style.display = '';
			if(get_product_brand.recordcount < total_brand_no)
				total_brand_no = get_product_brand.recordcount;
			for(i=0;i<total_brand_no;i++)
			{
				var baslik = get_product_brand.BRAND_NAME[i];
				var baslik = baslik.substr(0,brand_max_length);
				var brandname = '<a href="javascript://" onClick="add_brand('+get_product_brand.BRAND_ID[i]+','+'\''+get_product_brand.BRAND_NAME[i]+'\''+');">'+baslik+'</a>' + '<br />';
				total_brandname = total_brandname + brandname;
			}
			brand_td.innerHTML = total_brandname;
		}
		else
			div_close_brand();
	}
	else
	{
		div_close_brand();
		if(<cfoutput>#attributes.form_name#.#attributes.brand_name#</cfoutput>.value.length == 0)
			<cfoutput>#attributes.form_name#.#attributes.brand_id#</cfoutput>.value = '';		
	}
}
function add_brand(brand_id,brand_name)
{
	<cfoutput>#attributes.form_name#.#attributes.brand_id#</cfoutput>.value = brand_id;
	<cfoutput>#attributes.form_name#.#attributes.brand_name#</cfoutput>.value = brand_name;
	div_close_brand();
}
function div_close_brand()
{
	brand_div.style.display = 'none';
	brand_td.innerHTML = '';
}
</script>
<div id="brand_div" style="position:absolute;display:none;z-index:9999;"><br />
	<table class="color-border" cellpadding="2" cellspacing="1" width="100%">
		<tr height="22" class="color-row">
			<td id="brand_td">&nbsp;</td>
		</tr>
	</table>
</div>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">
