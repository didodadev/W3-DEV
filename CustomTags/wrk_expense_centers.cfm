<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="Yes">
<!---
By : Barbaros KUZ 20080206
Description :
	Masraf/Gelir Kalemi secilen yerlerde input alanina girilen ifade ile baslayan masraf/gelir kalemlerini bulur.
	Ve secilmesi icin o anda inputun altina div acar.
Parameters :
	form_name			-- 	required
	
	expense_center_id	-- required
	expense_center_name	-- required
	max_rows 			-- 	not required
	min_char 			-- 	not required
	
	expense_max_length degiskeni fazla gelen text ifadenin belli bir karaktere kadar olan bolumunu almak icin kullanilir.

	Ayrıca expense_center_name ifadesinin uzunlugu yoksa expense_center_id ifadesi de bosaltilir.
	Div uzunlugu ve karakter uzunlugu otomatik olarak duzenlenir.
Syntax :
	<cf_wrk_expense_centers form_name='add_cash_payment' expense_center_id='expense_center_id' expense_center_name='expense_center_name'>
	<input type="hidden" name="expense_center_id" value="">
	<input type="text" name="expense_center_name" value="" onKeyUp="get_expense_center();" style="width:175px;">
	<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_expense_center&field_name=add_cash_payment.expense_center&field_id=add_cash_payment.expense_center_id&is_invoice=1</cfoutput>','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
Revisions :
--->
<cfparam name="caller.attributes.max_rows" default="20">
<cfparam name="caller.attributes.min_char" default="3">

<script type="text/javascript">
function get_expense_center()
{
	var max_rows = <cfoutput>#caller.attributes.max_rows#</cfoutput>;
	var min_char = <cfoutput>#caller.attributes.min_char#</cfoutput>;
	var expense_center_genislik = parseInt(<cfoutput>#attributes.form_name#.#attributes.expense_center_name#.style.width</cfoutput>);
	expense_center_div.style.width = expense_center_genislik;
	var expense_name_max_length = wrk_round((expense_center_genislik*0.14),0);

	if(<cfoutput>#attributes.form_name#.#attributes.expense_center_name#</cfoutput>.value.length >= min_char)
	{
		
		var get_expense_center_workdata = workdata('get_expense_center',<cfoutput>#attributes.form_name#.#attributes.expense_center_name#</cfoutput>.value,max_rows);
		var total_expense_center = max_rows;		
		var total_expense_center_name = '';
		if(get_expense_center_workdata.recordcount)
		{
			expense_center_div.style.display = '';
			if(get_expense_center_workdata.recordcount < total_expense_center)
				total_expense_center = get_expense_center_workdata.recordcount;
			for(i=0;i<total_expense_center;i++)
			{
				var baslik = get_expense_center_workdata.EXPENSE[i];
				var baslik = baslik.substr(0,expense_name_max_length);
				var expense_center_name1 = '<a href="javascript://" onClick="add_expense_center('+get_expense_center_workdata.EXPENSE_ID[i]+','+'\''+get_expense_center_workdata.EXPENSE[i]+'\');">'+baslik+'</a><br />';
				total_expense_center_name = total_expense_center_name + expense_center_name1;
			}
			expense_center_td.innerHTML = total_expense_center_name;
		}
		else
			div_close_expense_center();
	}
	else
	{
		div_close_expense_center();
		if(<cfoutput>#attributes.form_name#.#attributes.expense_center_name#</cfoutput>.value.length == 0)
			<cfoutput>#attributes.form_name#.#attributes.expense_center_id#</cfoutput>.value = '';
	}
}

function add_expense_center(expense_center_id,expense_center_name)
{
	<cfoutput>#attributes.form_name#.#attributes.expense_center_id#</cfoutput>.value = expense_center_id;
	<cfoutput>#attributes.form_name#.#attributes.expense_center_name#</cfoutput>.value = expense_center_name;
	div_close_expense_center();
}
function div_close_expense_center()
{
	expense_center_div.style.display = 'none';
	expense_center_td.innerHTML = '';
}
</script>

<div id="expense_center_div" style="position:absolute;display:none;z-index:9999;"><br />
	<table class="color-border" cellpadding="2" cellspacing="1" width="100%">
		<tr height="18" class="color-row">
			<td id="expense_center_td">&nbsp;</td>
		</tr>
	</table>
</div>
</cfprocessingdirective>
<cfsetting enablecfoutputonly="no">
