<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="Yes">
<!---
By : Barbaros KUZ 20080116
Description :
	Urun kategorisi secilen yerlerde input alanina girilen ifade ile baslayan kategori adlarini bulur 
	Ve secilmesi icin o anda inputun altina div acar.
Parameters :
	form_name		-- 	required
	hierarchy_code	--	not required
	product_cat_id	--	not required
	product_cat_name-- 	required
	max_rows 		-- 	not required
	min_char 		-- 	not required
	
	Ayrıca product_cat_name ifadesinin uzunlugu yoksa hierarchy_code veya product_cat_id ifadesi de bosaltilir.		
	product_cat_max_length degiskeni fazla gelen text ifadenin belli bir karaktere kadar olan bolumunu almak icin kullanilir.
	Div uzunlugu ve karakter uzunlugu otomatik olarak duzenlenir.

Syntax :
	product_cat_id icin;
	<cf_wrk_product_cat form_name='search_product' product_cat_id='product_cat_id' product_cat_name='category_name'>
	<input type="hidden" name="product_cat_id" value="<cfif len(attributes.product_cat_id) and len(attributes.category_name)><cfoutput>#attributes.product_cat_id#</cfoutput></cfif>">
	<input type="text" name="category_name" value="<cfif len(attributes.category_name)><cfoutput>#attributes.category_name#</cfoutput></cfif>" onKeyUp="get_product_cat();" style="width:135px;">

	hierarchy_code icin;
	<cf_wrk_product_cat form_name='search_product' hierarchy_code='cat' product_cat_name='category_name'>
	<input type="hidden" name="cat" value="<cfif len(attributes.cat) and len(attributes.category_name)><cfoutput>#attributes.cat#</cfoutput></cfif>">
	<input type="text" name="category_name" value="<cfif len(attributes.category_name)><cfoutput>#attributes.category_name#</cfoutput></cfif>" onKeyUp="get_product_cat();" style="width:135px;">
Revisions :
	Barbaros KUZ 20080307
--->
<cfparam name="caller.attributes.max_rows" default="20">
<cfparam name="caller.attributes.min_char" default="3">

<script type="text/javascript">
function get_product_cat()
{
	var max_rows = <cfoutput>#caller.attributes.max_rows#</cfoutput>;
	var min_char = <cfoutput>#caller.attributes.min_char#</cfoutput>;
	var product_cat_genislik = parseInt(<cfoutput>#attributes.form_name#.#attributes.product_cat_name#.style.width</cfoutput>);
	product_cat_div.style.width = product_cat_genislik;
	var product_cat_max_length = wrk_round((product_cat_genislik*0.14),0);

	if(<cfoutput>#attributes.form_name#.#attributes.product_cat_name#</cfoutput>.value.length >= min_char)
	{
		
		var get_product_cat_workdata = workdata('get_product_cat',<cfoutput>#attributes.form_name#.#attributes.product_cat_name#</cfoutput>.value,max_rows);
		var total_product_cat = max_rows;		
		var total_product_cat_name = '';
		if(get_product_cat_workdata.recordcount)
		{
			product_cat_div.style.display = '';
			if(get_product_cat_workdata.recordcount < total_product_cat)
				total_product_cat = get_product_cat_workdata.recordcount;
			for(i=0;i<total_product_cat;i++)
			{
				var baslik = get_product_cat_workdata.PRODUCT_CAT[i];
				var baslik = baslik.substr(0,product_cat_max_length);

				var product_cat_name1 = '<a href="javascript://" onClick="add_product_cat('+'\''+get_product_cat_workdata.PRODUCT_CATID[i]+'\','+'\''+get_product_cat_workdata.HIERARCHY[i]+'\','+'\''+get_product_cat_workdata.HIERARCHY[i] + ' ' + get_product_cat_workdata.PRODUCT_CAT[i]+'\');">'+baslik+'</a><br />';
				total_product_cat_name = total_product_cat_name + product_cat_name1;
			}
			project_td.innerHTML = total_product_cat_name;
		}
		else
			div_close_product_cat();
	}
	else
	{
		div_close_product_cat();
		if(<cfoutput>#attributes.form_name#.#attributes.product_cat_name#</cfoutput>.value.length == 0)
		{
			<cfif isdefined("attributes.hierarchy_code")>
				<cfoutput>#attributes.form_name#.#attributes.hierarchy_code#</cfoutput>.value = '';
			<cfelse>
				<cfoutput>#attributes.form_name#.#attributes.product_cat_id#</cfoutput>.value = '';
			</cfif>		
		}
	}
}

function add_product_cat(product_cat_id,hierarchy,product_cat_name)
{
	<cfoutput>#attributes.form_name#.#attributes.product_cat_name#</cfoutput>.value = product_cat_name;
	<cfif isdefined("attributes.hierarchy_code")>
		<cfoutput>#attributes.form_name#.#attributes.hierarchy_code#</cfoutput>.value = hierarchy;
	</cfif>
	<cfif isdefined("attributes.product_cat_id")>
		<cfoutput>#attributes.form_name#.#attributes.product_cat_id#</cfoutput>.value = product_cat_id;
	</cfif>	
	
	div_close_product_cat();
}
function div_close_product_cat()
{
	product_cat_div.style.display = 'none';
	project_td.innerHTML = '';
}
</script>

<div id="product_cat_div" style="position:absolute;display:none;z-index:9999;"><br />
	<table class="color-border" cellpadding="2" cellspacing="1" width="100%">
		<tr height="18" class="color-row">
			<td id="project_td">&nbsp;</td>
		</tr>
	</table>
</div>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">
