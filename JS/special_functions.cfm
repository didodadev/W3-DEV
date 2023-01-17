<cfif Not isDefined('session.ep.userid')><cfabort /></cfif>
<cfsavecontent variable="loader_div_message"><cf_get_lang dictionary_id='58891.Yükleniyor'></cfsavecontent>
<cfsavecontent variable="file_type_download"><cf_get_lang dictionary_id='58520.Dosya Dürü'></cfsavecontent>
<cfsavecontent variable="save_to_my_computer"><cf_get_lang dictionary_id='59295.Arşivle'></cfsavecontent>
<cfsavecontent variable="select_process_cat_"><cf_get_lang dictionary_id='58770.İşlem Tipi Seçiniz'></cfsavecontent>
<cfsavecontent variable="category_select_"><cf_get_lang dictionary_id='57486.Kategori'><cf_get_lang dictionary_id='57734.Seçiniz'></cfsavecontent>
<cfoutput>
loader_div_message_ = '#loader_div_message#';
file_type_download = '#file_type_download#';
save_to_my_computer = '#save_to_my_computer#';
select_process_cat_ = '#select_process_cat_#';
category_select_ = '#category_select_#';
dateformat_style = '#dateformat_style#';
timeformat_style = '#timeformat_style#';
moneyformat_style = '#moneyformat_style#';
var wrk_list_url_strings ='';
function wrk_auto_complete_(obj_,table_name,input_name,column_name,column_id,datasource,div_weight,div_height){
    var keyword_ =(typeof(obj_)!='object')?'':obj_.value;
	if(keyword_.length<3 && obj_ != typeof(obj_)=='object' ){
		alert('En Az 3 Karakter Giriniz!');
	}
	else{
		document.getElementById('wrk_input_div_'+input_name+'').style.display='';
		wrk_list_url_strings = '&table_name='+table_name+'';
		wrk_list_url_strings +='&input_name='+input_name+'';
		wrk_list_url_strings +='&column_name='+column_name+'';
		wrk_list_url_strings +='&column_id='+column_id+'';
        wrk_list_url_strings +='&div_weight='+div_weight+'';
        wrk_list_url_strings +='&div_height='+div_height+'';
		wrk_list_url_strings +='&datasource='+datasource+'&keyword_='+keyword_+'';
		AjaxPageLoad('#request.self#?fuseaction=objects.popup_wrk_input_list'+wrk_list_url_strings+'','wrk_input_div_'+input_name+'',1);
	}
}
function n2txt(gelen_sayi,para_birimi)
{
	gelen_sayi = gelen_sayi.toString();
	var alt_para_birimi='';
	var bir = "<cf_get_lang dictionary_id='58091.bir'>";
	var iki = "<cf_get_lang dictionary_id='58092.iki'>";
	var uc = "<cf_get_lang dictionary_id='58093.uc'>";
	var dort = "<cf_get_lang dictionary_id='58094.dort'>";
	var bes = "<cf_get_lang dictionary_id='58095.bes'>";
	var alti = "<cf_get_lang dictionary_id='58096.alti'>";
	var yedi = "<cf_get_lang dictionary_id='58097.yedi'>";
	var sekiz = "<cf_get_lang dictionary_id='58098.sekiz'>";
	var dokuz = "<cf_get_lang dictionary_id='58099.dokuz'>";
	var sifir = "<cf_get_lang dictionary_id='58100.sifir'>";
	var on = "<cf_get_lang dictionary_id='58101.on'>";
	var yirmi = "<cf_get_lang dictionary_id='58102.yirmi'>";
	var otuz = "<cf_get_lang dictionary_id='58103.otuz'>";
	var kirk = "<cf_get_lang dictionary_id='58104.kirk'>";
	var elli = "<cf_get_lang dictionary_id='58105.elli'>";
	var altmis = "<cf_get_lang dictionary_id='58106.altmis'>";
	var yetmis = "<cf_get_lang dictionary_id='58107.yetmis'>";
	var seksen = "<cf_get_lang dictionary_id='58108.seksen'>";
	var doksan = "<cf_get_lang dictionary_id='58109.doksan'>";
	var yuz = "<cf_get_lang dictionary_id='58110.yuz'>";
	var bin = "<cf_get_lang dictionary_id='58111.bin'>";
	var milyon = "<cf_get_lang dictionary_id='58112.milyon'>";
	var milyar = "<cf_get_lang dictionary_id='58113.milyar'>";
	var trilyon = "<cf_get_lang dictionary_id='58114.trilyon'>";
	var katrilyon = "<cf_get_lang dictionary_id='58115.katrilyon'>";

	<cfif isDefined('session.ep.period_year') and session.ep.period_year lt 2009 and session.ep.period_year gte 2005>
		if(para_birimi == '' || para_birimi == undefined)
			para_birimi = "YTL";
	<cfelseif isDefined('session.ep.period_year') and (session.ep.period_year gte 2009 or session.ep.period_year lt 2005)>
		if(para_birimi == '' || para_birimi == undefined)
			para_birimi = "TL";
	<cfelseif isDefined('session_base.period_year') and session_base.period_year lt 2009 and session_base.period_year gte 2005>
		if(para_birimi == '' || para_birimi == undefined)
			para_birimi = "YTL";
	<cfelseif isDefined('session_base.period_year') and (session_base.period_year gte 2009 or session_base.period_year lt 2005)>
		if(para_birimi == '' || para_birimi == undefined)
			para_birimi = "TL";
	<cfelse>
		if(para_birimi == '' || para_birimi == undefined)
			para_birimi = "YTL";
	</cfif>
	
	if(para_birimi == 'YTL')
		alt_para_birimi = 'YKr';
	else if (para_birimi == 'TL')
		alt_para_birimi = 'Kr';
	else if (para_birimi == 'USD')
		alt_para_birimi = 'Cent';
	else if (para_birimi == 'EURO')
		alt_para_birimi = 'EURO Cent';
	if(list_len(gelen_sayi,'.') == 2)
	{
		tam_kisim = list_getat(gelen_sayi,1,'.');
		ondalik_kisim = list_getat(gelen_sayi,list_len(gelen_sayi,'.'),'.');
		ondalik_kisim = js_mid(ondalik_kisim,1,2);//wrk_round sız gelenler için son bi kontrol virgüllü kısm için
		if(ondalik_kisim.length == 1)
			ondalik_kisim = ondalik_kisim+0;
	}
	else
	{
		tam_kisim = gelen_sayi;
		ondalik_kisim = '';
	}
	tam_donen = '';
	ondalik_donen = '';
	sayi_uzunluk = tam_kisim.length;
	for(on_rakam=1;on_rakam <= ondalik_kisim.length;on_rakam++)
	{
		my_on_rakam = js_mid(ondalik_kisim,on_rakam,1);
		if(on_rakam == 1)
		{
			switch(my_on_rakam)
			{
				case '1':ondalik_donen = ondalik_donen + on;break;
				case '2':ondalik_donen = ondalik_donen + yirmi;break;
				case '3':ondalik_donen = ondalik_donen + otuz;break;
				case '4':ondalik_donen = ondalik_donen + kirk;break;
				case '5':ondalik_donen = ondalik_donen + elli;break;
				case '6':ondalik_donen = ondalik_donen + altmis;break;
				case '7':ondalik_donen = ondalik_donen + yetmis;break;
				case '8':ondalik_donen = ondalik_donen + seksen;break;
				case '9':ondalik_donen = ondalik_donen + doksan;break;
				case '0':ondalik_donen = ondalik_donen;break;
			}
		}
		if(on_rakam == 2)
		{
			switch(my_on_rakam)
			{
				case '1':ondalik_donen = ondalik_donen + bir;break;
				case '2':ondalik_donen = ondalik_donen + iki;break;
				case '3':ondalik_donen = ondalik_donen + uc;break;
				case '4':ondalik_donen = ondalik_donen + dort;break;
				case '5':ondalik_donen = ondalik_donen + bes;break;
				case '6':ondalik_donen = ondalik_donen + alti;break;
				case '7':ondalik_donen = ondalik_donen + yedi;break;
				case '8':ondalik_donen = ondalik_donen + sekiz;break;
				case '9':ondalik_donen = ondalik_donen + dokuz;break;
				case '0':ondalik_donen = ondalik_donen;break;
			}
		}
	}
	for(rakam=1;rakam <= tam_kisim.length;rakam++)
	{
		onceki_sayi = 0;
		iki_onceki_sayi = 0;
		my_sira = parseFloat(sayi_uzunluk) - parseFloat(rakam) + 1;
		my_mod = my_sira % 3;
		my_rakam = js_mid(tam_kisim,rakam,1);
		if(my_sira > 3 && my_sira < 7)
		{
			if((parseFloat(sayi_uzunluk)-parseFloat(rakam)) == 1)
			{
				onceki_sayi = js_mid(tam_kisim,parseFloat(rakam)-1,1);
				iki_onceki_sayi = 0;
			}
			else if((parseFloat(sayi_uzunluk)-parseFloat(rakam)) >= 2 && rakam > 1)
			{
				onceki_sayi = js_mid(tam_kisim,parseFloat(rakam)-1,1);
					if(rakam != 2)
						iki_onceki_sayi = js_mid(tam_kisim,parseFloat(rakam)-2,1);
			}
		}
		if(my_mod == 1)
		{
			switch(my_rakam)
			{
				case '1': if(my_sira != 4 || (my_sira == 4 && (onceki_sayi != 0 || iki_onceki_sayi != 0))) tam_donen = tam_donen + bir;break;
				case '2':tam_donen = tam_donen + iki;break;
				case '3':tam_donen = tam_donen + uc;break;
				case '4':tam_donen = tam_donen + dort;break;
				case '5':tam_donen = tam_donen + bes;break;
				case '6':tam_donen = tam_donen + alti;break;
				case '7':tam_donen = tam_donen + yedi;break;
				case '8':tam_donen = tam_donen + sekiz;break;
				case '9':tam_donen = tam_donen + dokuz;break;
				case '0':tam_donen = tam_donen;break;
			}
		}
		else if(my_mod == 2)
		{
			switch(my_rakam)
			{
				case '1':tam_donen = tam_donen + on;break;
				case '2':tam_donen = tam_donen + yirmi;break;
				case '3':tam_donen = tam_donen + otuz;break;
				case '4':tam_donen = tam_donen + kirk;break;
				case '5':tam_donen = tam_donen + elli;break;
				case '6':tam_donen = tam_donen + altmis;break;
				case '7':tam_donen = tam_donen + yetmis;break;
				case '8':tam_donen = tam_donen + seksen;break;
				case '9':tam_donen = tam_donen + doksan;break;
				case '0':tam_donen = tam_donen;break;
			}
		}
		else if(my_mod == 0)
		{
			switch(my_rakam)
			{
				case '1':tam_donen = tam_donen + yuz; break;
				case '2':tam_donen = tam_donen + iki + yuz;break;
				case '3':tam_donen = tam_donen + uc + yuz;break;
				case '4':tam_donen = tam_donen + dort + yuz;break;
				case '5':tam_donen = tam_donen + bes + yuz;break;
				case '6':tam_donen = tam_donen + alti + yuz;break;
				case '7':tam_donen = tam_donen + yedi + yuz;break;
				case '8':tam_donen = tam_donen + sekiz + yuz;break;
				case '9':tam_donen = tam_donen + dokuz + yuz;break;
				case '0':tam_donen = tam_donen;break;
			}
		}
		if(my_sira > 3)
		{
			bir_sonraki = js_mid(tam_kisim,parseFloat(rakam)+1,1);
			iki_sonraki = js_mid(tam_kisim,parseFloat(rakam)+2,1);
			if(my_sira == 6 && my_rakam != 0 && bir_sonraki == 0 && iki_sonraki == 0) tam_donen = tam_donen + bin;
			else if(my_sira == 5 && my_rakam != 0 && bir_sonraki == 0) tam_donen = tam_donen + bin;
			else if(my_sira == 4 && my_rakam != 0) tam_donen = tam_donen + bin;
			
			else if(my_sira == 9 && my_rakam != 0 && bir_sonraki == 0 && iki_sonraki == 0) tam_donen = tam_donen + milyon;
			else if(my_sira == 8 && my_rakam != 0 && bir_sonraki == 0) tam_donen = tam_donen + milyon;
			else if(my_sira == 7 && my_rakam != 0) tam_donen = tam_donen + milyon;
			
			else if(my_sira == 12 && my_rakam != 0 && bir_sonraki == 0 && iki_sonraki && 0) tam_donen = tam_donen + milyar;
			else if(my_sira == 11 && my_rakam != 0 && bir_sonraki == 0) tam_donen = tam_donen + milyar;
			else if(my_sira == 10 && my_rakam != 0) tam_donen = tam_donen + milyar;
			
			else if(my_sira == 15 && my_rakam != 0 && bir_sonraki == 0 && iki_sonraki == 0) tam_donen = tam_donen + trilyon;
			else if(my_sira == 14 && my_rakam != 0 && bir_sonraki == 0) tam_donen = tam_donen + trilyon;
			else if(my_sira == 13 && my_rakam != 0) tam_donen = tam_donen + trilyon;
			
			else if(my_sira == 18 && my_rakam != 0 && bir_sonraki == 0 && iki_sonraki == 0) tam_donen = tam_donen + katrilyon;
			else if(my_sira == 17 && my_rakam != 0 && bir_sonraki == 0) tam_donen = tam_donen + katrilyon;
			else if(my_sira == 16 && my_rakam != 0) tam_donen = tam_donen + katrilyon;
		}
	}
	my_text = tam_donen + para_birimi;
	if(ondalik_donen.length != 0 && (ondalik_donen != '00' || ondalik_donen != '0'))
		my_text = my_text + ondalik_donen + alt_para_birimi;
	//document.getElementById('showw').innerHTML = '#getLang("cheque","66")#:' + my_text.bold();
	return my_text;
}
function chk_period(field1,field1_name)
{
	if(document.getElementById('kur_say') != undefined && document.getElementById('kur_say').value != '')
	{
		// Önceden her para birimi için wrk_safe_query ile db'de sorgu yapıyordu bu da her seferinde ajax request yapılmasını gerektirdiğinden performans sıkıntısı yaratıyordu.
		// Artık para birimleri db'den 1 kere çekiliyor ve kontroller client tarafında yapılıyor.
		// upd : 21/05/2019, Uğur Hamurpet
		
		var moneyTypes = "";
		for(var j = 1; j <= document.getElementById('kur_say').value; j++) moneyTypes += "'" +  document.getElementById('hidden_rd_money_'+j).value + "',";

		var get_money_rates = wrk_safe_query('obj_get_money_rates','dsn2', 0, moneyTypes.slice(0,-1));
		for(var kk=1;kk<=document.getElementById('kur_say').value;kk++)
		{
			if(document.getElementById('txt_rate2_'+kk).value == '')
			{
				alert("<cf_get_lang dictionary_id='60788.Eksik Kur Değerleri Mevcut'>. <cf_get_lang dictionary_id='32344.Lütfen Kontrol Ediniz'> !");
				return false;
			}else{
				for(var i = 0; i < get_money_rates.recordcount; i++){
					if(document.getElementById('hidden_rd_money_'+kk).value == get_money_rates.MONEY[i]){
						var temp_control_rate = parseFloat(get_money_rates.RATE2[i]/get_money_rates.RATE1[i]);
						var temp_basket_rate2_ = filterNum(document.getElementById('txt_rate2_'+kk).value)/filterNum(document.getElementById('txt_rate1_'+kk).value);
						if(temp_basket_rate2_ > ((temp_control_rate/100)*250) ) // belge geri donuslerindeki kur dagılmalarını engellemek icin rate2 artısları kontrol ediliyor
						{
							alert("<cf_get_lang dictionary_id='59365.İlgili Kur Bilgisinde %100 den Fazla Artış Var'>:" + document.getElementById('hidden_rd_money_'+kk).value);
							return false;
						}
					}
				}
			}
		}
	}
	<cfif isDefined('session.ep')>
		return global_date_check_value("#dateformat(SESSION.EP.PERIOD_DATE,dateformat_style)#",field1.value, "<cf_get_lang dictionary_id='59077.Lütfen Geçerli Bir Tarih Giriniz'>","#session.ep.period_year#");
	<cfelseif isDefined('session.pp')>
		return global_date_check_value("#dateformat(SESSION.PP.PERIOD_DATE,dateformat_style)#",field1.value, "<cf_get_lang dictionary_id='59077.Lütfen Geçerli Bir Tarih Giriniz'>");
	</cfif>
}
</cfoutput>
<cfif isdefined("session.ep.userid")>
	function change_money_info(form_name_info,input_name_info,function_currency_type)
	{
		<cfif isdefined("session.ep.our_company_info.rate_round_num")>
			rate_round = <cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>;
		<cfelse>
			rate_round = 4;
		</cfif>
		temp_date_now = <cfoutput>"#dateformat(now(),dateformat_style)#"</cfoutput>;
		if(eval(form_name_info+'.'+input_name_info).value != '')//bu neden konuldu hatırlamıyorum,gerekirse eklenir...temp_date_now != eval(form_name_info+'.'+input_name_info).value && 
		{
			 //FS 20080814 tarih formati kontrolu ekledim
			if(!CheckEurodate(eval(form_name_info+'.'+input_name_info).value,'Girilen Tarih'))
				return false;
			else
			{
				<cfif isdefined("session.ep")>
					GET_OUR_COMPANY_INFO = wrk_safe_query('js_GET_OUR_COMPANY_INFO','dsn');
					money_kontrol = GET_OUR_COMPANY_INFO.IS_SELECT_RISK_MONEY;
				<cfelse>
					money_kontrol = 0;
				</cfif>
				if(money_kontrol == 1)
				{
					if(eval(form_name_info + '.company_id') != undefined)
					{
						if(eval(form_name_info + '.company_id').value != '' && eval(form_name_info + '.company_id').value != '')
							var get_credit_all = wrk_safe_query('js_get_credit_all','dsn',0,eval(form_name_info + '.company_id').value);
					}
					else if(eval(form_name_info + '.consumer_id') != undefined)
					{
						if(eval(form_name_info + '.consumer_id').value != '' && eval(form_name_info + '.consumer_id').value != '')
							var get_credit_all = wrk_safe_query('js_get_credit_all_2','dsn',0,eval(form_name_info + '.consumer_id').value);
					}
					else if(eval(form_name_info + '.ch_company_id') != undefined)
					{
						if(eval(form_name_info + '.ch_company_id').value != '' && eval(form_name_info + '.ch_company_id').value != '')
							var get_credit_all = wrk_safe_query('js_get_credit_all','dsn',0,eval(form_name_info + '.ch_company_id').value);
					}
					else if(eval(form_name_info + '.to_company_id') != undefined)
					{
						if(eval(form_name_info + '.to_company_id').value != '' && eval(form_name_info + '.to_company_id').value != '')
							var get_credit_all = wrk_safe_query('js_get_credit_all','dsn',0,eval(form_name_info + '.to_company_id').value);
					}
					else if(eval(form_name_info + '.from_company_id') != undefined)
					{
						if(eval(form_name_info + '.from_company_id').value != '' && eval(form_name_info + '.from_company_id').value != '')
							var get_credit_all = wrk_safe_query('js_get_credit_all','dsn',0,eval(form_name_info + '.from_company_id').value);
					}
					else if(eval(form_name_info + '.to_consumer_id') != undefined)
					{
						if(eval(form_name_info + '.to_consumer_id').value != '' && eval(form_name_info + '.to_consumer_id').value != '')
							var get_credit_all = wrk_safe_query('js_get_credit_all_2','dsn',0,eval(form_name_info + '.to_consumer_id').value);
					}
					else if(eval(form_name_info + '.ch_partner_id') != undefined)
					{
						if(eval(form_name_info + '.ch_partner_id').value != '' && eval(form_name_info + '.ch_partner_id').value != '')
							var get_credit_all = wrk_safe_query('js_get_credit_all_2','dsn',0,eval(form_name_info + '.ch_partner_id').value);
					}
					else if(eval(form_name_info + '.ACTION_FROM_COMPANY_ID') != undefined && eval(form_name_info + '.ACTION_FROM_COMPANY_ID').value != '')
					{
						if(eval(form_name_info + '.ACTION_FROM_COMPANY_ID').value != '' && eval(form_name_info + '.ACTION_FROM_COMPANY_ID').value != '')
							var get_credit_all = wrk_safe_query('js_get_credit_all','dsn',0,eval(form_name_info + '.ACTION_FROM_COMPANY_ID').value);
					}
					else if(eval(form_name_info + '.CASH_ACTION_FROM_CONSUMER_ID') != undefined && eval(form_name_info + '.CASH_ACTION_FROM_CONSUMER_ID').value != '')
					{
						if(eval(form_name_info + '.CASH_ACTION_FROM_CONSUMER_ID').value != '' && eval(form_name_info + '.CASH_ACTION_FROM_CONSUMER_ID').value != '')
							var get_credit_all = wrk_safe_query('js_get_credit_all_2','dsn',0,eval(form_name_info + '.CASH_ACTION_FROM_CONSUMER_ID').value);
					}
					else if(eval(form_name_info + '.CASH_ACTION_FROM_COMPANY_ID') != undefined && eval(form_name_info + '.CASH_ACTION_FROM_COMPANY_ID').value != '')
					{
						if(eval(form_name_info + '.CASH_ACTION_FROM_COMPANY_ID').value != '' && eval(form_name_info + '.CASH_ACTION_FROM_COMPANY_ID').value != '')
							var get_credit_all = wrk_safe_query('js_get_credit_all','dsn',0,eval(form_name_info + '.CASH_ACTION_FROM_COMPANY_ID').value);
					}
					else if(eval(form_name_info + '.CASH_ACTION_TO_CONSUMER_ID') != undefined && eval(form_name_info + '.CASH_ACTION_TO_CONSUMER_ID').value != '')
					{
						if(eval(form_name_info + '.CASH_ACTION_TO_CONSUMER_ID').value != '' && eval(form_name_info + '.CASH_ACTION_TO_CONSUMER_ID').value != '')
							var get_credit_all = wrk_safe_query('js_get_credit_all_2','dsn',0,eval(form_name_info + '.CASH_ACTION_TO_CONSUMER_ID').value);
					}
					else if(eval(form_name_info + '.CASH_ACTION_TO_COMPANY_ID') != undefined && eval(form_name_info + '.CASH_ACTION_TO_COMPANY_ID').value != '')
					{
						if(eval(form_name_info + '.CASH_ACTION_TO_COMPANY_ID').value != '' && eval(form_name_info + '.CASH_ACTION_TO_COMPANY_ID').value != '')
							var get_credit_all = wrk_safe_query('js_get_credit_all','dsn',0,eval(form_name_info + '.CASH_ACTION_TO_COMPANY_ID').value);
					}
					else if(eval(form_name_info + '.action_from_company_id') != undefined && eval(form_name_info + '.action_from_company_id').value != '')
					{
						if(eval(form_name_info + '.action_from_company_id').value != '' && eval(form_name_info + '.action_from_company_id').value != '')
							var get_credit_all = wrk_safe_query('js_get_credit_all','dsn',0,eval(form_name_info + '.action_from_company_id').value);
					}
					else if(eval(form_name_info + '.ACTION_FROM_CONSUMER_ID') != undefined)
					{
						if(eval(form_name_info + '.ACTION_FROM_CONSUMER_ID').value != '' && eval(form_name_info + '.ACTION_FROM_CONSUMER_ID').value != '')
							var get_credit_all = wrk_safe_query('js_get_credit_all_2','dsn',0,eval(form_name_info + '.ACTION_FROM_CONSUMER_ID').value);
					}
					else if(eval(form_name_info + '.ACTION_TO_COMPANY_ID') != undefined && eval(form_name_info + '.ACTION_TO_COMPANY_ID').value != '')
					{
						if(eval(form_name_info + '.ACTION_TO_COMPANY_ID').value != '')
							var get_credit_all = wrk_safe_query('js_get_credit_all','dsn',0,eval(form_name_info + '.ACTION_TO_COMPANY_ID').value);
					}
					else if(eval(form_name_info + '.action_to_company_id') != undefined && eval(form_name_info + '.action_to_company_id').value != '')
					{
						if(eval(form_name_info + '.action_to_company_id').value != '')
							var get_credit_all = wrk_safe_query('js_get_credit_all','dsn',0,eval(form_name_info + '.action_to_company_id').value);
					}
					else if(eval(form_name_info + '.ACTION_TO_CONSUMER_ID') != undefined && eval(form_name_info + '.ACTION_TO_CONSUMER_ID').value != '')
					{
						if(eval(form_name_info + '.ACTION_TO_CONSUMER_ID').value != '')
							var get_credit_all = wrk_safe_query('js_get_credit_all_2','dsn',0,eval(form_name_info + '.ACTION_TO_CONSUMER_ID').value);
					}
					else if(eval(form_name_info + '.cons_id') != undefined && eval(form_name_info + '.cons_id').value != '')
					{
						if(eval(form_name_info + '.cons_id').value != '')
							var get_credit_all = wrk_safe_query('js_get_credit_all_2','dsn',0,eval(form_name_info + '.cons_id').value);
					}
				}
				if(get_credit_all != undefined && get_credit_all.PAYMENT_RATE_TYPE != '' && get_credit_all.PAYMENT_RATE_TYPE != undefined)
					rate_type = get_credit_all.PAYMENT_RATE_TYPE;
				else if(function_currency_type != undefined && function_currency_type != '')
					rate_type = function_currency_type;
				else
					rate_type = '2';
					
				var validate_date = js_date(eval(form_name_info+'.'+input_name_info).value);
				var get_money_info = wrk_safe_query("js_get_money_info",'dsn',0,validate_date);
                if(get_money_info.recordcount)
				{
                    for(var mon_i=0;mon_i<get_money_info.recordcount; mon_i++)
					{
                        for(var j=1;j<=eval(form_name_info + '.kur_say').value;j++)
						{
							if(get_money_info.MONEY_TYPE[mon_i] == eval(form_name_info + '.hidden_rd_money_' + j).value)
							{
                                eval(form_name_info + '.txt_rate1_' + j).value = commaSplit(get_money_info.RATE1[mon_i],rate_round);
								if(rate_type!= undefined)
								{
									if(rate_type == 1)
										eval(form_name_info + '.txt_rate2_' + j).value = commaSplit(get_money_info.RATE3[mon_i],rate_round);
									else if(rate_type == 3)
										eval(form_name_info + '.txt_rate2_' + j).value = commaSplit(get_money_info.EFFECTIVE_PUR[mon_i],rate_round);
									else if(rate_type == 4)
										eval(form_name_info + '.txt_rate2_' + j).value = commaSplit(get_money_info.EFFECTIVE_SALE[mon_i],rate_round);
									else
										eval(form_name_info + '.txt_rate2_' + j).value = commaSplit(get_money_info.RATE2[mon_i],rate_round);
								}
								else
									eval(form_name_info + '.txt_rate2_' + j).value = commaSplit(get_money_info.RATE2[mon_i],rate_round);
									
								if(document.getElementById('basket_money_totals_table') != undefined && typeof(kur_degistir)!=undefined)
								{
                                    kur_degistir(j);//basket tarafndaki kullanımlarda kur bölümü basket şablonundan kapatılabilecği için focus sorunu yaşanıyordu,oyüzden eklendi.
								}
								<!--- else
								{
                                    eval(form_name_info + '.txt_rate2_' + j).focus();
								} --->
							}
						}
					}
				}
			}
		}
	}
	function get_money_info(form_name_info,input_name_info,field_select_name)
	{	
		<cfif isdefined("session.ep.our_company_info.rate_round_num")>
			rate_round = <cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>;
		<cfelse>
			rate_round = 4;
		</cfif>			
		temp_date_now = <cfoutput>"#dateformat(now(),dateformat_style)#"</cfoutput>;
		if(eval(form_name_info+'.'+input_name_info).value != '')//bu neden konuldu hatırlamıyorum,gerekirse eklenir...temp_date_now != eval(form_name_info+'.'+input_name_info).value && 
		{
			if(!CheckEurodate(eval(form_name_info+'.'+input_name_info).value,'Girilen Tarih'))
				return false;
			else
			{
				<cfif isdefined("session.ep")>
					GET_OUR_COMPANY_INFO = wrk_safe_query('js_GET_OUR_COMPANY_INFO','dsn');
					money_kontrol = GET_OUR_COMPANY_INFO.IS_SELECT_RISK_MONEY;
				<cfelse>
					money_kontrol = 0;
				</cfif>
				if(money_kontrol == 1)
				{
					if(eval(form_name_info + '.company_id') != undefined && eval(form_name_info + '.company_id').value != '')
					{
						if(eval(form_name_info + '.company_id').value != '' && eval(form_name_info + '.company_id').value != '')
							var get_credit_all = wrk_safe_query('js_get_credit_all','dsn',0,eval(form_name_info + '.company_id').value);
					}
					else if(eval(form_name_info + '.consumer_id') != undefined && eval(form_name_info + '.consumer_id').value != '')
					{
						if(eval(form_name_info + '.consumer_id').value != '' && eval(form_name_info + '.consumer_id').value != '')
							var get_credit_all = wrk_safe_query('js_get_credit_all_2','dsn',0,eval(form_name_info + '.consumer_id').value);
					}
					else if(eval(form_name_info + '.ch_company_id') != undefined && eval(form_name_info + '.ch_company_id').value != '')
					{
						if(eval(form_name_info + '.ch_company_id').value != '' && eval(form_name_info + '.ch_company_id').value != '')
							var get_credit_all = wrk_safe_query('js_get_credit_all','dsn',0,eval(form_name_info + '.ch_company_id').value);
					}
					else if(eval(form_name_info + '.to_company_id') != undefined && eval(form_name_info + '.to_company_id').value != '')
					{
						if(eval(form_name_info + '.to_company_id').value != '' && eval(form_name_info + '.to_company_id').value != '')
							var get_credit_all = wrk_safe_query('js_get_credit_all','dsn',0,eval(form_name_info + '.to_company_id').value);
					}
					else if(eval(form_name_info + '.from_company_id') != undefined && eval(form_name_info + '.from_company_id').value != '')
					{
						if(eval(form_name_info + '.from_company_id').value != '' && eval(form_name_info + '.from_company_id').value != '')
							var get_credit_all = wrk_safe_query('js_get_credit_all','dsn',0,eval(form_name_info + '.from_company_id').value);
					}
					else if(eval(form_name_info + '.to_consumer_id') != undefined && eval(form_name_info + '.to_consumer_id').value != '')
					{
						if(eval(form_name_info + '.to_consumer_id').value != '' && eval(form_name_info + '.to_consumer_id').value != '')
							var get_credit_all = wrk_safe_query('js_get_credit_all_2','dsn',0,eval(form_name_info + '.to_consumer_id').value);
					}
					else if(eval(form_name_info + '.ch_partner_id') != undefined && eval(form_name_info + '.ch_partner_id').value != '')
					{
						if(eval(form_name_info + '.ch_partner_id').value != '' && eval(form_name_info + '.ch_partner_id').value != '')
							var get_credit_all = wrk_safe_query('js_get_credit_all_2','dsn',0,eval(form_name_info + '.ch_partner_id').value);
					}
					else if(eval(form_name_info + '.ACTION_FROM_COMPANY_ID') != undefined && eval(form_name_info + '.ACTION_FROM_COMPANY_ID').value != '')
					{
						if(eval(form_name_info + '.ACTION_FROM_COMPANY_ID').value != '' && eval(form_name_info + '.ACTION_FROM_COMPANY_ID').value != '')
							var get_credit_all = wrk_safe_query('js_get_credit_all','dsn',0,eval(form_name_info + '.ACTION_FROM_COMPANY_ID').value);
					}
					else if(eval(form_name_info + '.CASH_ACTION_FROM_CONSUMER_ID') != undefined && eval(form_name_info + '.CASH_ACTION_FROM_CONSUMER_ID').value != '')
					{
						if(eval(form_name_info + '.CASH_ACTION_FROM_CONSUMER_ID').value != '' && eval(form_name_info + '.CASH_ACTION_FROM_CONSUMER_ID').value != '')
							var get_credit_all = wrk_safe_query('js_get_credit_all_2','dsn',0,eval(form_name_info + '.CASH_ACTION_FROM_CONSUMER_ID').value);
					}
					else if(eval(form_name_info + '.CASH_ACTION_FROM_COMPANY_ID') != undefined && eval(form_name_info + '.CASH_ACTION_FROM_COMPANY_ID').value != '')
					{
						if(eval(form_name_info + '.CASH_ACTION_FROM_COMPANY_ID').value != '' && eval(form_name_info + '.CASH_ACTION_FROM_COMPANY_ID').value != '')
							var get_credit_all = wrk_safe_query('js_get_credit_all','dsn',0,eval(form_name_info + '.CASH_ACTION_FROM_COMPANY_ID').value);
					}
					else if(eval(form_name_info + '.CASH_ACTION_TO_CONSUMER_ID') != undefined && eval(form_name_info + '.CASH_ACTION_TO_CONSUMER_ID').value != '')
					{
						if(eval(form_name_info + '.CASH_ACTION_TO_CONSUMER_ID').value != '' && eval(form_name_info + '.CASH_ACTION_TO_CONSUMER_ID').value != '')
							var get_credit_all = wrk_safe_query('js_get_credit_all_2','dsn',0,eval(form_name_info + '.CASH_ACTION_TO_CONSUMER_ID').value);
					}
					else if(eval(form_name_info + '.CASH_ACTION_TO_COMPANY_ID') != undefined && eval(form_name_info + '.CASH_ACTION_TO_COMPANY_ID').value != '')
					{
						if(eval(form_name_info + '.CASH_ACTION_TO_COMPANY_ID').value != '' && eval(form_name_info + '.CASH_ACTION_TO_COMPANY_ID').value != '')
							var get_credit_all = wrk_safe_query('js_get_credit_all','dsn',0,eval(form_name_info + '.CASH_ACTION_TO_COMPANY_ID').value);
					}
					else if(eval(form_name_info + '.action_from_company_id') != undefined && eval(form_name_info + '.action_from_company_id').value != '')
					{
						if(eval(form_name_info + '.action_from_company_id').value != '' && eval(form_name_info + '.action_from_company_id').value != '')
							var get_credit_all = wrk_safe_query('js_get_credit_all','dsn',0,eval(form_name_info + '.action_from_company_id').value);
					}
					else if(eval(form_name_info + '.ACTION_FROM_CONSUMER_ID') != undefined)
					{
						if(eval(form_name_info + '.ACTION_FROM_CONSUMER_ID').value != '' && eval(form_name_info + '.ACTION_FROM_CONSUMER_ID').value != '')
							var get_credit_all = wrk_safe_query('js_get_credit_all_2','dsn',0,eval(form_name_info + '.ACTION_FROM_CONSUMER_ID').value);
					}
					else if(eval(form_name_info + '.ACTION_TO_COMPANY_ID') != undefined && eval(form_name_info + '.ACTION_TO_COMPANY_ID').value != '')
					{
						if(eval(form_name_info + '.ACTION_TO_COMPANY_ID').value != '')
							var get_credit_all = wrk_safe_query('js_get_credit_all','dsn',0,eval(form_name_info + '.ACTION_TO_COMPANY_ID').value);
					}
					else if(eval(form_name_info + '.action_to_company_id') != undefined && eval(form_name_info + '.action_to_company_id').value != '')
					{
						if(eval(form_name_info + '.action_to_company_id').value != '')
							var get_credit_all = wrk_safe_query('js_get_credit_all','dsn',0,eval(form_name_info + '.action_to_company_id').value);
					}
					else if(eval(form_name_info + '.ACTION_TO_CONSUMER_ID') != undefined && eval(form_name_info + '.ACTION_TO_CONSUMER_ID').value != '')
					{

						if(eval(form_name_info + '.ACTION_TO_CONSUMER_ID').value != '')
							var get_credit_all = wrk_safe_query('js_get_credit_all_2','dsn',0,eval(form_name_info + '.ACTION_TO_CONSUMER_ID').value);
					}
					else if(eval(form_name_info + '.cons_id') != undefined && eval(form_name_info + '.cons_id').value != '')
					{
						if(eval(form_name_info + '.cons_id').value != '')
							var get_credit_all = wrk_safe_query('js_get_credit_all_2',0,eval(form_name_info + '.cons_id').value);
					}
					if(get_credit_all != undefined && get_credit_all.PAYMENT_RATE_TYPE != '')
						rate_type = get_credit_all.PAYMENT_RATE_TYPE;
					else
						rate_type = '2';
					var validate_date = js_date(eval(form_name_info+'.'+input_name_info).value);
					var get_money_info = wrk_safe_query("js_get_money_info",'dsn',0,validate_date);
					if(get_money_info.recordcount == 0)
						var get_money_info = wrk_safe_query("obj_get_money_rate_all",'dsn2',0,'');
					if(get_money_info.recordcount)
					{
						for(var mon_i=0;mon_i<get_money_info.recordcount;mon_i++)
						{
							for(var j=1;j<=eval(form_name_info + '.kur_say').value;j++)
							{
								if(get_money_info.MONEY_TYPE[mon_i] == eval(form_name_info + '.hidden_rd_money_' + j).value)
								{
									eval(form_name_info + '.txt_rate1_' + j).value = commaSplit(get_money_info.RATE1[mon_i],rate_round);
									if(rate_type!= undefined)
									{
										if(rate_type == 1)
											eval(form_name_info + '.txt_rate2_' + j).value = commaSplit(get_money_info.RATE3[mon_i],rate_round);
										else if(rate_type == 3)
											eval(form_name_info + '.txt_rate2_' + j).value = commaSplit(get_money_info.EFFECTIVE_PUR[mon_i],rate_round);
										else if(rate_type == 4)
											eval(form_name_info + '.txt_rate2_' + j).value = commaSplit(get_money_info.EFFECTIVE_SALE[mon_i],rate_round);
										else
											eval(form_name_info + '.txt_rate2_' + j).value = commaSplit(get_money_info.RATE2[mon_i],rate_round);
									}
									else
										eval(form_name_info + '.txt_rate2_' + j).value = commaSplit(get_money_info.RATE2[mon_i],rate_round);

									if(field_select_name != undefined) {
										new_money = get_credit_all.MONEY;
										if((eval(form_name_info + '.' + field_select_name + '['+(j-1)+']').value).split(';')[1] == new_money) {
											eval(form_name_info + '.' + field_select_name + '['+(j-1)+']').selected = true;		
										}
									}
									else {
										if(get_credit_all != undefined && get_credit_all.MONEY != undefined)
										{
											new_money = get_credit_all.MONEY;
											if(eval(form_name_info + '.hidden_rd_money_' + j) != undefined && eval(form_name_info + '.hidden_rd_money_' + j).value == new_money)
											{
												eval(form_name_info + '.rd_money['+(j-1)+']').checked = true;
											}
										}
									}
									if(document.getElementById('basket_money_totals_table') != undefined && typeof(kur_degistir)!=undefined)
									{
										kur_degistir(j);//basket tarafndaki kullanımlarda kur bölümü basket şablonundan kapatılabilecği için focus sorunu yaşanıyordu,oyüzden eklendi.
									}
									//doviz alanina focuslanmasina gerek yok diye kaldirildi, problem olursa bildirebilirsiniz 20131001 Esra
									/*else
									{
										eval(form_name_info + '.txt_rate2_' + j).focus();
									}*/
								}
							}
						}
					}
				}
			}
		}
	}
</cfif>

function global_date_check_value(tarih1, tarih2, msg,new_session_date)
{
	tarih1 = fix_date_value(tarih1,'<cfoutput>#dateformat_style#</cfoutput>');
	tarih2 = fix_date_value(tarih2,'<cfoutput>#dateformat_style#</cfoutput>');
	<cfif isdefined("session.ep.period_start_date")>
		new_session_start_date = "<cfoutput>#dateformat(session.ep.period_start_date,dateformat_style)#</cfoutput>";
		new_session_finish_date = "<cfoutput>#dateformat(session.ep.period_finish_date,dateformat_style)#</cfoutput>";
        <cfif dateformat_style is 'dd/mm/yyyy'>
            new_session_start_date = new_session_start_date.substr(6,4) + new_session_start_date.substr(3,2) + new_session_start_date.substr(0,2);
            new_session_finish_date = new_session_finish_date.substr(6,4) + new_session_finish_date.substr(3,2) + new_session_finish_date.substr(0,2);
		<cfelse>
            new_session_start_date = new_session_start_date.substr(6,4) + new_session_start_date.substr(0,2) + new_session_start_date.substr(3,2);
            new_session_finish_date = new_session_finish_date.substr(6,4) + new_session_finish_date.substr(0,2) + new_session_finish_date.substr(3,2);
        </cfif>
	<cfelseif isdefined("session.ep.period_year")>
		if(new_session_date == undefined) new_session_date = <cfoutput>#session.ep.period_year#</cfoutput>;
	<cfelseif isdefined("session.pp.period_year")>
		if(new_session_date == undefined) new_session_date = <cfoutput>#session.pp.period_year#</cfoutput>;
	<cfelseif isdefined("session.ww.period_year")>
		if(new_session_date == undefined) new_session_date = <cfoutput>#session.ww.period_year#</cfoutput>;
	<cfelseif isdefined("session.cp.period_year")>
		if(new_session_date == undefined) new_session_date = <cfoutput>#session.cp.period_year#</cfoutput>;
	</cfif>
		
	if(tarih1.length==10 && tarih2.length==10)
	{
        <cfif dateformat_style is 'dd/mm/yyyy'>
            tarih1_ = tarih1.substr(6,4) + tarih1.substr(3,2) + tarih1.substr(0,2);
            tarih2_ = tarih2.substr(6,4) + tarih2.substr(3,2) + tarih2.substr(0,2);
        <cfelse>
            tarih1_ = tarih1.substr(6,4) + tarih1.substr(0,2) + tarih1.substr(3,2);
            tarih2_ = tarih2.substr(6,4) + tarih2.substr(0,2) + tarih2.substr(3,2);
        </cfif>
		
	 	if (tarih2_ < tarih1_  || (new_session_date != undefined && new_session_start_date== undefined && tarih2.substr(6,4) != new_session_date) || (new_session_start_date != undefined && tarih2_ < new_session_start_date) || (new_session_finish_date != undefined && tarih2_ > new_session_finish_date)) 
		{
			if (msg != '')
				alert(msg);
			else
				alert("<cf_get_lang dictionary_id='60789.Hata Mesajı Ayarlanmamış'> !");
			return false;
		}
		else
			return true;
	}
	else 
	{
		alert("<cf_get_lang dictionary_id='59077.Lütfen Geçerli Bir Tarih Giriniz'>!");
		return false;
	}
}

function js_create_unique_id()
{
	var alphaStr = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
	var alphaMul = 62;
	var unique_date_ = new Date();
	<cfif isdefined("session.ep")>
		var js_unique_id = '<cfoutput>#session.ep.userid#</cfoutput>';
	<cfelseif isdefined("session.pp")>
		var js_unique_id = '<cfoutput>#session.pp.userid#</cfoutput>';
	<cfelseif isdefined("session.ww.userid")>
		var js_unique_id = '<cfoutput>#session.ww.userid#</cfoutput>';
	<cfelse>
		var js_unique_id = '';
	</cfif>
	js_unique_id += alphaStr.charAt(Math.random() * alphaMul);
	js_unique_id += alphaStr.charAt(Math.random() * alphaMul);
	js_unique_id += unique_date_.getDate();
	js_unique_id += unique_date_.getMonth()+1;
	js_unique_id += unique_date_.getFullYear();
	js_unique_id += unique_date_.getHours();
	js_unique_id += unique_date_.getMinutes();
	js_unique_id += unique_date_.getSeconds();
	js_unique_id += unique_date_.getMilliseconds();
	js_unique_id += alphaStr.charAt(Math.random() * alphaMul);
	js_unique_id += alphaStr.charAt(Math.random() * alphaMul);
	return js_unique_id;
}

/*
	Right Click Menu
	Kullanılışı : Fonksiyon 2 parametre alıyor,ilki tipini belirtiyor,yani gönderilen değer neyi teşkil ediyor,PRODUCT_ID,STOCK_ID,COMPANY_ID,EMPLOYEE_ID vs.vs.Buna göre menü şekilleniyor.
    			  İkinci değer ise buda ilgili 1.ci değerde belirtilen alanın değeri yani 153,365,1,36,15 vs. gibi bir değer gelir.
                  Fonksiyona bu değerler gönderildikten sonra gelen tipe göre menü tasarlanır.Ve her sağ tıklamada gösterimi yapılır.Herhangi bir HTML tagine uygulanabilir.
                  Örnek Kullanım : wrk_right_menu('PRODUCT_ID',150);  150 nolu ürüne ait ürün menüsü oluşturulur ve sağ tıklandığında gösterilir.
                  Yazar : Elif Ölmez & Mahmut ER.
*/
var cord_x,cord_y;

function wrk_right_menu(type,menu_value){
	if(document.getElementById('right_menu_div'))
	{
		document.onclick = function(){document.getElementById("right_menu_div").style.display = "none";};//sol tuşa basıldığında divimiz kaybolsun..
		document.getElementById('right_menu_div').style.display= 'block';
		document.getElementById("right_menu_div").style.visibility = "visible";
        	
		if(event.pageX + 190 > window.innerWidth && event.pageY + 170 > window.innerHeight){
			document.getElementById("right_menu_div").style.top=event.pageY - 170 + 'px';
			document.getElementById("right_menu_div").style.left=event.pageX - 190 + 'px';
		}
		else if(event.pageX + 190 > window.innerWidth){
			document.getElementById("right_menu_div").style.top=event.pageY + 'px';
			document.getElementById("right_menu_div").style.left=event.pageX - 190 + 'px';
		}
		else if(event.pageY + 170 > window.innerHeight){
			document.getElementById("right_menu_div").style.top=event.pageY - 170 + 'px';
			document.getElementById("right_menu_div").style.left=event.pageX + 'px';
		}
		else{
			document.getElementById("right_menu_div").style.top=event.pageY + 'px';
			document.getElementById("right_menu_div").style.left=event.pageX + 'px';
		}
		
        <!--- document.getElementById("right_menu_div").style.display = 'table'; --->
		right_menu_str ='<ul class="ui-dropdown-menu">';
		if(type == 'PRODUCT_ID')
		{
            right_menu_str +='<li><a href="javascript://" id="td3" onClick="window.location.href=\'<cfoutput>#request.self#</cfoutput>?fuseaction=stock.list_stock&event=det&pid='+menu_value+'\'"><cf_get_lang dictionary_id='45567.Stok Detay'></a></li>';
            right_menu_str +='<li><a href="javascript://" id="td4" onClick="window.location.href=\'<cfoutput>#request.self#</cfoutput>?fuseaction=product.list_price_change&event=det&pid='+menu_value+'\'"><cf_get_lang dictionary_id='37116.Fiyat Detay'></a></li>';
            right_menu_str +='<li><a href="javascript://" id="td8" onClick="window.location.href=\'<cfoutput>#request.self#</cfoutput>?fuseaction=product.detail_product_place&pid='+menu_value+'\'\,\'list\'"><cf_get_lang dictionary_id='37106.Ürün Raf Detay'></a></li>';
			right_menu_str +='<li><a href="javascript://" id="td8" onClick="windowopen(href=\'<cfoutput>#request.self#</cfoutput>?fuseaction=product.popup_product_guaranty&pid='+menu_value+'\'\,\'medium\')"><cf_get_lang dictionary_id='57717.Garanti'></a></li>';
			right_menu_str +='<li><a href="javascript://" id="td8" onClick="window.location.href=\'<cfoutput>#request.self#</cfoutput>?fuseaction=product.list_product_cost&event=det&pid='+menu_value+'\'\"><cf_get_lang dictionary_id='58258.Maliyet'></a></li>';
		}	
		right_menu_str +='</ul>';
		document.getElementById('right_menu_div').innerHTML=right_menu_str;
		return false;
	}	
	else
	{	
		var menu_div = document.createElement('div');
		menu_div.setAttribute('id', 'right_menu_div');
		menu_div.style.position = 'absolute';
		menu_div.style.visibility = 'hidden';
		menu_div.style.width = '170px';
		<!--- menu_div.style.borderStyle = 'outset';
		menu_div.style.borderWidth = '1px'; 
		menu_div.style.zIndex=9999;
        menu_div.style.border_color ='black'; --->
		document.body.appendChild(menu_div);
		wrk_right_menu(type,menu_value);
	}
}
function _CF_numberrange(object_value, min_value, max_value)
{
	if (min_value != null)
	{
				   if (object_value < min_value) return false;
	}
	if (max_value != null)
	{
				   if (object_value > max_value) return false;
	}
	return true;
}
function _CF_checknumber(object_value)
{
	if (object_value.length == 0)
				   return true;
	var start_format = " .+-0123456789";
	var number_format = " .0123456789";
	var check_char;
	var decimal = false;
	var trailing_blank = false;
	var digits = false;
	check_char = start_format.indexOf(object_value.charAt(0));
	if (check_char == 1)
				   decimal = true;
	else if (check_char < 1)
				   return false;

	for (var i = 1; i < object_value.length; i++)
	{
				   check_char = number_format.indexOf(object_value.charAt(i));
				   if (check_char < 0)
								   return false;
				   else if (check_char == 1)
				   {
								   if (decimal)
												   return false;
								   else
												   decimal = true;
				   }
				   else if (check_char == 0)
				   {
								   if (decimal || digits)       
												   trailing_blank = true;
				   }
				   else if (trailing_blank)
								   return false;
				   else
								   digits = true;
	}
	return true
}
function _CF_checkrange(object_value, min_value, max_value)
{
	if (object_value.length == 0) return true;
	if (!_CF_checknumber(object_value)) return false;
	else return (_CF_numberrange((eval(object_value)), min_value, max_value));
	return true;
}
function _CF_checkday(checkYear, checkMonth, checkDay)
{
	maxDay = 31;
	if (checkMonth == 4 || checkMonth == 6 ||
				   checkMonth == 9 || checkMonth == 11)
				   maxDay = 30;
	else if (checkMonth == 2)
	{
				   if (checkYear % 4 > 0)
								   maxDay =28;
				   else if (checkYear % 100 == 0 && checkYear % 400 > 0)
								   maxDay = 28;
				   else
								   maxDay = 29;
	}
	return _CF_checkrange(checkDay, 1, maxDay);
}

function CheckEurodate(object_value,field)
{
	/*Ekleyen Ömür*/
	/*
	 *Kullanım : CheckEurodate(değer,alan);
	 *
	 *return değeri : true veya false
	 *değer : text alanına girilen değer
	 *alan : text formatında alan adı
	 *
	 *örnek : 
	 *1.return CheckEurodate(search.invoice_date.value,'Fatura Tarihi');
	 *2.if(!CheckEurodate(search.invoice_date.value,'Fatura Tarihi')) return false;
	 *
	*/ 
	
	if (object_value.length == 0)
		return true;
	isplit = object_value.indexOf('/');
	if (isplit == -1)
		isplit = object_value.indexOf('.');
	if (isplit == -1 || isplit == object_value.length){
		alert(field + ' Hatalı!');
		return false;
		}
	sDay = object_value.substring(0, isplit);
	monthSplit = isplit + 1;
	isplit = object_value.indexOf('/', monthSplit);
	if (isplit == -1)
		isplit = object_value.indexOf('.', monthSplit);
	if (isplit == -1 ||  (isplit + 1 )  == object_value.length){
		alert(field + ' Hatalı!');
		return false;
		}
	sMonth = object_value.substring((sDay.length + 1), isplit);
	if(dateformat_style=='dd/mm/yyyy'){
		sDay = sDay;
		sMonth = sMonth;
	}
	else {
		temp_sDay = sDay;
		sDay = sMonth;
		sMonth = temp_sDay;
	}
	sYear = object_value.substring(isplit + 1);
	result = true;
	if (!(sMonth))
		result = false;
	else
	if (!_CF_checkrange(sMonth, 1, 12))
		result = false;
	else
	if (!(sYear))
		result = false;
	else
	if (!_CF_checkrange(sYear, 1900, 2099))
		result = false;
	else
	if (!(sDay))
		result = false;
	else
	if (!_CF_checkday(sYear, sMonth, sDay))
		result = false;
	else
		result = true;	
	if(!result)
		alert(field + ' Hatalı!');
		
	return result;		
}
<cfif isdefined("session.ep.userid") and (attributes.this_fuseact is 'myhome.welcome' or attributes.this_fuseact is 'myhome.myhome')>
	<cfset columnLeftList = "homebox_pay_claim,homebox_video,homebox_announcement,homebox_notes,homebox_poll_now,homebox_pdks">
	<cfset columnCenterList = "homebox_main_news,homebox_myworks,homebox_correspondence,homebox_internaldemand,homebox_career,homebox_pot_cons,homebox_pot_partner,homebox_hr,homebox_finished_test_times,homebox_finished_contract,homebox_orders_come,homebox_offer_given,homebox_sell_today,homebox_promo_head,homebox_most_sell_stock,homebox_offer_to_give,homebox_new_stocks,homebox_orders_give,homebox_offer_taken,homebox_come_again_sip,homebox_purchase_today,homebox_more_stocks,homebox_send_order,homebox_offer_to_take,homebox_new_product,homebox_campaign_now,homebox_pre_invoice,homebox_service_head,homebox_call_center_application,homebox_call_center_interaction,homebox_over_time_acc,homebox_spare_part,homebox_product_orders,homebox_pay,homebox_now_claim,homebox_old_contracts,homebox_forum,homebox_employee_profile,homebox_branch_profile">
	<cfset columnRightList = "homebox_day_agenda,homebox_hr_agenda,homebox_hr_in_out,homebox_birthdate,homebox_attending_workers,homebox_employee_permittion,homebox_markets,homebox_is_permittion,homebox_widget,homebox_social_media">
	
	<cfset openPanels = ListToArray("homebox_main_news")>
	
	<cfset panels = ArrayNew(2)>
	
	<cfset panels[1] = ArrayNew(1)>
	<cfset panels[1] = ListToArray(columnLeftList)>
	
	<cfset panels[2] = ArrayNew(1)>
	<cfset panels[2] = ListToArray(columnCenterList)>
	
	<cfset panels[3] = ArrayNew(1)>
	<cfset panels[3] = ListToArray(columnRightList)>
</cfif>
function anasayfa_duzenle()
	{ 
			<cfif isdefined("session.ep.userid") and (attributes.this_fuseact is 'myhome.welcome' or attributes.this_fuseact is 'myhome.myhome')>
            HomeBox.init(); 
			// setup a custom onBoxDrop, onBoxMove and onBoxRemove event handlers to be fired when a 
			// box is dropped, moved via buttons or removed
			HomeBox.onBoxMove = function(name,column,position) {
				//alert('onBoxMove:'+name)	
			};
			HomeBox.onBoxRemove = function(x,isWidget,column) {
				var obj = document.getElementById('homebox_'+x);
				panelName = '&panelName=homebox_'+x;
				if (isWidget){						
					AjaxPageLoad('index.cfm?fuseaction=myhome.emptypopup_menu_positions&islem=del'+panelName,'sonuc',1);
					obj.style.display='none';
				}else if (column!=""){
					AjaxPageLoad('index.cfm?fuseaction=myhome.emptypopup_menu_positions&islem=del2'+panelName+'&column='+column,'sonuc',1);
					obj.style.display='none';
				}		
			};
			
			onBoxEdit = function(obj,x) {
				var obj = document.getElementById('edit_'+x);
		
				var widget_action = document.getElementById("upd_widget");	
		
				var winW = document.documentElement.offsetWidth;
				var winH = document.documentElement.offsetHeight;
		
				var left = 0, top = 0,tmpobj=obj;
				while(tmpobj){
					top+= tmpobj.offsetTop;
					left+= tmpobj.offsetLeft;
					tmpobj= tmpobj.offsetParent;
				}
		
				widget_action.style.position = "absolute";
				widget_action.style.left = left+obj.offsetWidth/2 + "px";
				widget_action.style.top = top+obj.offsetHeight/2 + 10 + "px";
				widget_action.style.width = '250';
				//widget_action.style.height = '300';
		
				if ((left+250) > winW)
					widget_action.style.left = left - 250 + "px";
				
					
				
				adres__ = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_frm_upd_widget&panelName=homebox_'+x;
				widget_action.style.display='';
				//AjaxPageLoad(adres__,'upd_widget_body',1);
				AjaxPageLoad(adres__,'body_upd_widget',1);
			};	
		
			var access = new Array();
			<cfoutput>
				<cfloop index="columnPosition" from="1" to="#ArrayLen(panels)#">
					<cfloop index="sequencePosition" from="1" to="#ArrayLen(panels[columnPosition])#">
						<cfif columnPosition eq 1 or columnPosition eq 3>
							access["#panels[columnPosition][sequencePosition]#"] = [2];
						<cfelse>
							access["#panels[columnPosition][sequencePosition]#"] = [1,3];
						</cfif>		
					</cfloop>	
				</cfloop>
			</cfoutput>
			HomeBox.setAccessRule(access);
        </cfif>
	}
    function paper_no_control(record_num,action_dsn,table,action_type,paper_no_col,action_paper,row_control,input,action_id_row_id,virman_list)
    {
        /*	SK20160229
            record_num : toplu işlem satır sayısı
            action_dsn : işleme ait tablonun datasource u
            table : işleme ait tablo
            action_type : işleme ait tablodaki işlem tipi kolonunun adı ve işlem tipi idleri örn; 'ACTION_TYPE_ID*23,230'
            paper_no_col : işleme ait tablodaki belge no kolon adı örn; BANK_ACTIONS için 'PAPER_NO'
            action_paper : işlemin GENERAL_PAPERS tablosundaki kolon adı örn; gelen havale için 'INCOMING_TRANSFER'
            row_control : toplu işlemlerde bulunan satırdaki elemanın var olup olmadığını tutan hidden input. Tekli işlemlerde 0.
            input : belge numarasının girildiği input
            action_id_row_id : işleme ait tablodaki ACTION_ID kolon adı ve satırların idlerinin tutulduğu hidden input adı örn; gelen havale için 'ACTION_ID-act_row_id'
            virman_list : virman işlemlerinde aynı belge numarasıyla iki kayıt atıldığı için, güncelleme işleminde queryden işlemlerin bir sonraki idleri de çekilir ve liste halinde fonksiyona gönderilir
        */
        if(action_id_row_id != undefined)//GÜNCELLEMEDE GELİR ACTION_ID İLE KARŞILAŞTIRMA İŞLEMİ YAPMAK İÇİN
        {
            var action_column =list_getat(action_id_row_id,1,'-');//İŞLEM İDSİNİN KOLON ADI
            var action_id_row = list_getat(action_id_row_id,2,'-');//İŞLEM İDLERİ
        }
        else
            var action_column ='';
        var action_row_list = '';
        var paper_number_list = '';
        var paper_list = '';
        var is_paper_changed = false;/*belge numaralarında değişiklik yapıldıysa form post edilmesin*/
        var flag = false;
        var check = 0;
        var action_type_col = list_first(action_type,'*');
        if(list_len(list_last(action_type,'*'),',') > 1)
        	action_type_id = list_last(action_type,'*');
        else
        	var action_type_id = parseInt(list_last(action_type,'*'));
		if((action_type_id == 24 || action_type_id == 25) && row_control != 0)//yeni basket yapısındaki element idler farklı olduğu için düzenleme yapıldı.
		{
			var input_type = "window.basket.items[j-1]."+input;
			var row_id_type = "window.basket.items[j-1]."+action_id_row;
            var row_id_obj = "window.basket.items[j-1]."+action_id_row;
			var row_control_type = "window.basket.items[j-1]."+row_control;
		}
		else
		{
			var input_type = "document.getElementById('"+input+"'+j).value";
			var row_id_type = "document.getElementById('"+action_id_row+"'+j).value";
            var row_id_obj = "document.getElementById('"+action_id_row+"'+j)";
			var row_control_type = "document.getElementById('"+row_control+"'+j).value";
		}
        if(row_control == 0)
        {
            paper_number_list = '\''+ document.getElementById(input).value +'\'';
            if(action_id_row_id != undefined)
                action_row_list += document.getElementById(action_id_row).value;
        }
        else
        {
			for(j=1; j<=record_num; j++)
			{
				if(eval(row_control_type)==1)
				{
					if(list_len(paper_number_list,',') == 0)
					{
						paper_number_list = paper_number_list +'\''+ eval(input_type) +'\'';
						if(action_id_row_id != undefined && eval(row_id_obj) != undefined)
							action_row_list = action_row_list + '\'' + eval(row_id_type) + '\'';
					}
					else
					{
						paper_number_list = paper_number_list + ',' +'\''+ eval(input_type) +'\'';
						if(action_id_row_id != undefined && eval(row_id_obj) != undefined)
							action_row_list = action_row_list + ',' + '\'' + eval(row_id_type) + '\'';
					}
				}
			}
        }
        if(virman_list != undefined)
            action_row_list += ',' + virman_list;

        url_= '/V16/objects/cfc/papers.cfc?method=controlPaperNo';
        var counter =0;
        $.ajax({
            type: "get",
            url: url_,
            data: {tableName: table,paperNoColumn: paper_no_col,paperNo: paper_number_list,actionTypeColumn: action_type_col,actionTypes: action_type_id,actionIdColumn: action_column,actionId: action_row_list,actionDb: action_dsn},
            cache: false,
            async: false,
            success: function(read_data){
                if(read_data.length)
                {
					if(counter == 0){
					alert("<cf_get_lang dictionary_id='59366.Girdiğiniz belge numarası kullanılmıştır'> ! " + read_data + " <cf_get_lang dictionary_id='59367.Otomatik olarak değişecektir'>.");
						counter=1;
					}
                    flag=true;
                    paper_num_list = read_data;
				}
				counter=0;
            }
        });
        
        $.ajax({
            type: "get",
            url: '/V16/objects/cfc/papers.cfc?method=getFromGeneralPapers',
            data: {noColumn: action_paper + '_NO',numberColumn: action_paper + '_NUMBER'},
            cache: false,
            async: false,
            success: function(read_data2){
                noColumn = list_first(read_data2,'-');
                numberColumn = list_last(read_data2,'-');
            }
        });
                    
        if(row_control == 0)
        {
            if(flag)
            {
            	if(noColumn.length && numberColumn.length)
                {
                    number = parseInt(numberColumn);
                    number++;
                    document.getElementById(input).value = noColumn + '-' + number;               	
                }
				else
                	document.getElementById(input).value = "";
                is_paper_changed = true;
            }
        }
        else
        {
            for(j=1; j<=record_num; j++)
            {
                if(eval(row_control_type)==1)
                {
                    if(flag)
                    {
                        if(list_find(paper_num_list,eval(input_type),','))
                        {
                        	if(noColumn.length && numberColumn.length)
                            {
                                check++;
                                number = parseInt(numberColumn);
                                number = number + check;
                                if(action_type_id == 24 || action_type_id == 25){
									//number = parseInt(list_last(window.basket.items[j-1].PAPER_NUMBER,'-')) + 1; //otomatik belge no değiştirmeden sebep yorum satırına alındı.(en son satırdaki belge noyu alıyor)
									window.basket.items[j-1].PAPER_NUMBER = noColumn + '-' + number;
								}
                                else
                                    document.getElementById(input + j).value = noColumn + '-' + number;                           
                            }
							else
                            	document.getElementById(input + j).value = "";
                            is_paper_changed = true;
                        }
                    }
                    if(eval(input_type) != "" )
                    {
                        paper = eval(input_type);
                        paper = "'"+paper+"'";
                        if(list_find(paper_list,paper,','))
                        {
							if(list_find(paper_list,paper,'eval(input_type)'))
                            alert("<cf_get_lang dictionary_id='59099.Aynı Belge Numarası İle Eklenen En Az İki Farklı Satır Var'>: "+ paper);
							
                            if(noColumn.length && numberColumn.length)
                            {
                                var paper_flag = false;
                                check++;
                                number = parseInt(numberColumn);
                                number = number + check;
                                if(paper == "'"+ noColumn + '-' + number+"'") /* peş peşe aynı numaraların girilmesi gibi saçma bir durum için eklendi*/
                                {
                                    check++;
                                    paper_flag = true;
                                }
                                if(paper_flag)
                                {
                                    number = parseInt(numberColumn);
                                    number = number + check;	
                                }
                                if(action_type_id == 24 || action_type_id == 25)
                                    window.basket.items[j-1].PAPER_NUMBER = noColumn + '-' + number;
                                else
                                    document.getElementById(input + j).value = noColumn + '-' + number;
                                if(list_len(paper_list,',') == 0)
                                    paper_list+="'"+eval(input_type)+"'";
                                else
                                    paper_list+=","+"'"+eval(input_type)+"'";                           
                            }
                            else
                            	document.getElementById(input + j).value = "";
                            is_paper_changed = true;
                        }
                        else
                        {
                            if(list_len(paper_list,',') == 0)
                                paper_list+=paper;
                            else
                                paper_list+=","+paper;
                        }
                    }
					if(action_type_id == 24 || action_type_id == 25)
						fillArrayField('paper_number',window.basket.items[j-1].PAPER_NUMBER,window.basket.items[j-1].PAPER_NUMBER,j-1);
                }
            }
        }
		
        if(is_paper_changed) return false;
        else return true;
    }