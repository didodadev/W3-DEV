<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="Yes">
<!---
By : Özden Öztürk 20070912
Description :
	muhasbe hesap kodu secilen yerlerde input alanina girilen ifade ile baslayan hesap kodlarını bulur 
	Ve secilmesi icin o anda inputun altina div acar.
Parameters :
	form_name		-- 	required
	account_code	-- 	required
	account_name	-- 	not required
	max_rows 		-- 	not required
	min_char 		-- 	not required	
	is_multi_no		-- 	not required
	is_sub_acc		-- 	not required
	search_from_name --not required
	acc_name_with_code --not required

	account_name parametresi gönderilirse secilen hesabın adını belirtilen alana düşürür, gonderilmediginde sadece hesap kodu gonderilir.
	acc_name_with_code parametresi account_name ile beraber gonderilebilir. gonderildiginde account name alanına hem hesap adı hesap kodu ile beraber dusurulur
	is_sub_acc parametresi rapor ve liste sayfaları haricinde ust hesapların secilebilmesini engellemek icin eklendi. Orn. uye muhasebe kodu
	secilen kaydedilen sayfada custom tag cagırılırken is_sub_acc '0' gonderilmelidir ki ust hesaplar listelenmesin.
	
	search_from_name parametesi filtrelemenin account_name alanından mı yoksa account_code alanından mı yapılacagını belirler. account_name alanına yazılan ifadeye gore
	arama yapılacaksa search_from_name parametresi '1' gonderilmelidir. account_name gonderilmeden sadece search_from_name gonderilemez.
		<cf_wrk_account_codes form_name='add_acc' account_code='code2' account_name='code2_name' search_from_name='1'>
	
	Bir formda ikinci kez kullanilirsa is_multi_no parametresi tanimlanmali. custom tag in sayfada kaç kez kullanıldıgı is_multi_no parametresine deger olarak atanmalıdır.
		<cf_wrk_account_codes form_name='add_acc' account_code='code2' account_name='code2_name' is_multi_no='2'>
		<cfinput type="text" name="code2" value="" onKeyUp="get_wrk_acc_code_1();"();">
		<cfinput type="text" name="code2_name" value="">	
--->
<cfparam name="attributes.is_multi_no" default='1'>
<cfparam name="attributes.max_rows" default="20">
<cfparam name="attributes.min_char" default="3">
<cfparam name="attributes.is_sub_acc" default="0">

<script type="text/javascript">
function get_wrk_acc_code_<cfoutput>#attributes.is_multi_no#</cfoutput>()
{ 
	var max_rows = <cfoutput>#attributes.max_rows#</cfoutput>;
	var min_char = <cfoutput>#attributes.min_char#</cfoutput>;
	var show_sub_acc = <cfoutput>#attributes.is_sub_acc#</cfoutput>;
	if(<cfoutput>#attributes.form_name#.#attributes.account_code#.style.width</cfoutput> != undefined && <cfoutput>#attributes.form_name#.#attributes.account_code#.style.width</cfoutput> != '')
		var acccode_div_genislik = parseInt(<cfoutput>#attributes.form_name#.#attributes.account_code#.style.width</cfoutput>);
	else
		var acccode_div_genislik =100;
	acccode_div_<cfoutput>#attributes.is_multi_no#</cfoutput>.style.width = acccode_div_genislik;
	var acccode_max_length = wrk_round((acccode_div_genislik*0.14),0);
	<cfif isdefined('attributes.account_name') and isdefined('attributes.search_from_name') and attributes.search_from_name eq 1>
		var search_code_text = <cfoutput>#attributes.form_name#.#attributes.account_name#</cfoutput>.value;
	<cfelse>
		var search_code_text = <cfoutput>#attributes.form_name#.#attributes.account_code#</cfoutput>.value;
	</cfif>
	if(search_code_text.length >= min_char)
	{
		var account_code_result = workdata('get_account_code',search_code_text,max_rows,show_sub_acc,0);
		var acc_code_count = max_rows;		
		var total_acc_code = '';
		if(account_code_result.recordcount)
		{
			eval("acccode_div_<cfoutput>#attributes.is_multi_no#</cfoutput>").style.display = '';
			if(account_code_result.recordcount < acc_code_count)
				acc_code_count = account_code_result.recordcount;
			for(i=0;i<acc_code_count;i++)
			{
				var baslik = account_code_result.ACCOUNT_CODE[i];
				var baslik = baslik.substr(0,acccode_max_length);
				var temp_acc_code = '<a href="javascript://" onClick="add_acc_<cfoutput>#attributes.is_multi_no#</cfoutput>(\''+account_code_result.ACCOUNT_CODE[i]+'\',\''+account_code_result.ACCOUNT_NAME[i]+'\');">'+baslik+'</a><br />';
				total_acc_code = total_acc_code + temp_acc_code;
			}
			acccode_td_<cfoutput>#attributes.is_multi_no#</cfoutput>.innerHTML = total_acc_code;
		}
		else
			div_close_acc_<cfoutput>#attributes.is_multi_no#</cfoutput>();
	}
	else
	{
		div_close_acc_<cfoutput>#attributes.is_multi_no#</cfoutput>();
		if(<cfoutput>#attributes.form_name#.#attributes.account_code#</cfoutput>.value.length == 0)
			<cfoutput>#attributes.form_name#.#attributes.account_code#</cfoutput>.value = '';
	}
}

function add_acc_<cfoutput>#attributes.is_multi_no#</cfoutput>(acc_code,acc_name)
{
	<cfoutput>#attributes.form_name#.#attributes.account_code#</cfoutput>.value = acc_code;
	<cfif isdefined('attributes.account_name') and isdefined('attributes.acc_name_with_code')> 
		<cfoutput>#attributes.form_name#.#attributes.account_name#</cfoutput>.value = acc_code + '-' + acc_name;
	<cfelseif  isdefined('attributes.account_name')>
		<cfoutput>#attributes.form_name#.#attributes.account_name#</cfoutput>.value = acc_name;
	</cfif>
	div_close_acc_<cfoutput>#attributes.is_multi_no#</cfoutput>();
}
function div_close_acc_<cfoutput>#attributes.is_multi_no#</cfoutput>()
{
	acccode_div_<cfoutput>#attributes.is_multi_no#</cfoutput>.style.display = 'none';
	acccode_td_<cfoutput>#attributes.is_multi_no#</cfoutput>.innerHTML = '';
}
</script>

<div id="acccode_div_<cfoutput>#attributes.is_multi_no#</cfoutput>" style="position:absolute;display:none;z-index:1;"><br />
	<table class="color-border" cellpadding="2" cellspacing="1" width="100%">
		<tr height="18" class="color-row">
			<td id="acccode_td_<cfoutput>#attributes.is_multi_no#</cfoutput>">&nbsp;</td>
		</tr>
	</table>
</div>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">
