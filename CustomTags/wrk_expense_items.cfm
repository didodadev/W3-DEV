<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="Yes">
<!---
By : Barbaros KUZ 20080206
Description :
	Gider kalemi secilen yerlerde input alanina girilen ifade ile baslayan gider kalemlerini bulur 
	Ve secilmesi icin o anda inputun altina div acar.
Parameters :
	form_name			-- 	required
	*hierarchy_code		--	required
	*product_cat_name	-- 	required
	
	expense_item_id		-- required
	expense_item_name	-- required
	max_rows 			-- 	not required
	min_char 			-- 	not required
	
	*product_cat_max_length degiskeni fazla gelen text ifadenin belli bir karaktere kadar olan bolumunu almak icin kullanilir.
	expense_name_max_length degiskeni fazla gelen text ifadenin belli bir karaktere kadar olan bolumunu almak icin kullanilir.

	Ayrıca expense_item_name ifadesinin uzunlugu yoksa expense_item_id ifadesi de bosaltilir.
	Div uzunlugu ve karakter uzunlugu otomatik olarak duzenlenir.
Syntax :
	<cf_wrk_expense_items form_name='add_cash_payment' expense_item_id='expense_item_id' expense_item_name='expense_item_name'>
	<input type="hidden" name="expense_item_id" value="">
	<input type="text" name="expense_item_name" value="" onKeyUp="get_expense_item();" style="width:175px;">
	<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=add_cash_payment.expense_item_id&field_name=add_cash_payment.expense_item_name','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
Revisions :
--->
<cfparam name="caller.attributes.max_rows" default="20">
<cfparam name="caller.attributes.min_char" default="3">

<script type="text/javascript">
function get_expense_item()
{
	var max_rows = <cfoutput>#caller.attributes.max_rows#</cfoutput>;
	var min_char = <cfoutput>#caller.attributes.min_char#</cfoutput>;
	var expense_item_genislik = parseInt(<cfoutput>#attributes.form_name#.#attributes.expense_item_name#.style.width</cfoutput>);
	expense_item_div.style.width = expense_item_genislik;
	var expense_name_max_length = wrk_round((expense_item_genislik*0.14),0);

	if(<cfoutput>#attributes.form_name#.#attributes.expense_item_name#</cfoutput>.value.length >= min_char)
	{
		
		var get_expense_item_workdata = workdata('get_expense_item',<cfoutput>#attributes.form_name#.#attributes.expense_item_name#</cfoutput>.value,max_rows);
		var total_expense_item = max_rows;		
		var total_expense_item_name = '';
		if(get_expense_item_workdata.recordcount)
		{
			expense_item_div.style.display = '';
			if(get_expense_item_workdata.recordcount < total_expense_item)
				total_expense_item = get_expense_item_workdata.recordcount;
			for(i=0;i<total_expense_item;i++)
			{
				var baslik = get_expense_item_workdata.EXPENSE_ITEM_NAME[i];
				var baslik = baslik.substr(0,expense_name_max_length);
				var expense_item_name1 = '<a href="javascript://" onClick="add_expense_item('+get_expense_item_workdata.EXPENSE_ITEM_ID[i]+','+'\''+get_expense_item_workdata.EXPENSE_ITEM_NAME[i]+'\');">'+baslik+'</a><br />';
				total_expense_item_name = total_expense_item_name + expense_item_name1;
			}
			expense_item_td.innerHTML = total_expense_item_name;
		}
		else
			div_close_expense_item();
	}
	else
	{
		div_close_expense_item();
		if(<cfoutput>#attributes.form_name#.#attributes.expense_item_name#</cfoutput>.value.length == 0)
			<cfoutput>#attributes.form_name#.#attributes.expense_item_id#</cfoutput>.value = '';
	}
}

function add_expense_item(expense_item_id,expense_item_name)
{
	<cfoutput>#attributes.form_name#.#attributes.expense_item_id#</cfoutput>.value = expense_item_id;
	<cfoutput>#attributes.form_name#.#attributes.expense_item_name#</cfoutput>.value = expense_item_name;
	div_close_expense_item();
}
function div_close_expense_item()
{
	expense_item_div.style.display = 'none';
	expense_item_td.innerHTML = '';
}
</script>

<div id="expense_item_div" style="position:absolute;display:none;z-index:9999;"><br />
	<table class="color-border" cellpadding="2" cellspacing="1" width="100%">
		<tr height="18" class="color-row">
			<td id="expense_item_td">&nbsp;</td>
		</tr>
	</table>
</div>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">
