<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="Yes">
<!---
By : Sevda Mersin 20071101
Description :
	Ürün secilen yerlerde input alanina girilen ifade ile baslayan ürün adlarini bulur 
	Ve secilmesi icin o anda inputun altina div acar.
Parameters :
	form_name		-- 	required
	product_id 		--	not required
	stock_id 		--	not required
	product_name	-- 	required
	max_rows 		-- 	not required
	min_char 		-- 	not required
	
	product_max_length degiskeni fazla gelen text ifadenin belli bir karaktere kadar olan bolumunu almak icin kullanilir.
	Ayrıca product_name ifadesinin uzunlugu yoksa product_id ve stock_id ifadesi de bosaltilir. Stock_id veya product_id ile 
	veya herikisi ile de çalışır.
	Div uzunlugu ve karakter uzunlugu otomatik olarak duzenlenir.
Syntax :
	<cf_wrk_products form_name = 'search_product' product_name='product_name' product_id='product_id' stock_id='stock_id'>
	<input type="hidden" name="product_id" value="<cfoutput>#attributes.product_id#</cfoutput>">
	<input type="hidden" name="stock_id" value="<cfoutput>#attributes.stock_id#</cfoutput>">
	<input type="text" name="product_name" value="<cfoutput>#attributes.product_name#</cfoutput>" onKeyUp="get_product();" style="width:140px;">
--->
<cfparam name="caller.attributes.max_rows" default="20">
<cfparam name="caller.attributes.min_char" default="3">

<cfif caller.fusebox.circuit is 'store'>
	<script type="text/javascript">
		var is_store_module = 1;
	</script>
<cfelse>
	<script type="text/javascript">
		var is_store_module = 0;
	</script>
</cfif>
<script type="text/javascript">
function get_product()
{
	var max_rows = <cfoutput>#caller.attributes.max_rows#</cfoutput>;
	var min_char = <cfoutput>#caller.attributes.min_char#</cfoutput>;
	var product_div_genislik = parseInt(<cfoutput>#attributes.form_name#.#attributes.product_name#.style.width</cfoutput>);
	product_div.style.width = product_div_genislik;
	var product_max_length = wrk_round((product_div_genislik*0.14),0);
	if(<cfoutput>#attributes.form_name#.#attributes.product_name#</cfoutput>.value.length >= min_char)
	{
		var get_product = workdata('get_product',<cfoutput>#attributes.form_name#.#attributes.product_name#</cfoutput>.value,max_rows,is_store_module);
		var total_product = max_rows;		
		var total_product_name = '';
		if(get_product.recordcount)
		{
			product_div.style.display = '';
			if(get_product.recordcount < total_product)
				total_product = get_product.recordcount;
			for(i=0;i<total_product;i++)
			{
				var baslik = get_product.PRODUCT_NAME[i];
				var baslik = baslik.substr(0,product_max_length);
				var product_name1 = '<a href="javascript://" onClick="add_product('+get_product.STOCK_ID[i]+','+'\''+get_product.PRODUCT_ID[i]+'\','+'\''+get_product.PRODUCT_NAME[i]+'\');">'+baslik+'</a><br />';
				total_product_name = total_product_name + product_name1;
			}
			product_td.innerHTML = total_product_name;
		}
		else
			div_close_product();
	}
	else
	{
		div_close_product();
		if(<cfoutput>#attributes.form_name#.#attributes.product_name#</cfoutput>.value.length == 0)
			<cfif isdefined("attributes.product_id")>
				<cfoutput>#attributes.form_name#.#attributes.product_id#</cfoutput>.value = '';
			</cfif>
			<cfif isdefined("attributes.stock_id")>
				<cfoutput>#attributes.form_name#.#attributes.stock_id#</cfoutput>.value = '';
			</cfif>
	}
}

function add_product(stock_id,product_id,product_name)
{
	<cfif isdefined("attributes.stock_id")>
		<cfoutput>#attributes.form_name#.#attributes.stock_id#</cfoutput>.value = stock_id;
	</cfif>
	<cfif isdefined("attributes.product_id")>
		<cfoutput>#attributes.form_name#.#attributes.product_id#</cfoutput>.value = product_id;
	</cfif>
	<cfoutput>#attributes.form_name#.#attributes.product_name#</cfoutput>.value = product_name;
	div_close_product();
}
function div_close_product()
{
	product_div.style.display = 'none';
	product_td.innerHTML = '';
}
</script>

<div id="product_div" style="position:absolute;display:none;z-index:1;width:auto; border:1px solid #E6E6E6;"><br />
	<table class="color-border" cellpadding="2" cellspacing="1">
		<tr height="18" class="color-row">
			<td id="product_td" style="line-height:20px;">&nbsp;</td>
		</tr>
	</table>
</div>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">
