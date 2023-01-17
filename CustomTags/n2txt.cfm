<!--- 
	verilen sayisal degisken icerigini okunusuna cevirir, verilen deger float olmalidir...
	ornek kullanim :
		<cfset myNumber = 100>
		<cf_n2txt number="myNumber" para_birimi="YTL" alt_para_birimi="Ykr">
		<cfoutput>#myNumber#</cfoutput>
	not :
		en yüksek katrilyon degeri verilebilir
	modified :
		FBS - YO 20090227 2 rakamli sayilar icin ing duzenlemesi yapildi
		FBS 20080402 yaziyi ingilizce yazdirmak icin   
			<cf_get_lang_set_main lang_name="ENG"> custom tagini bu tagin ust kismina eklemek gerekiyor
 --->

 <cfif isdefined("session.pp")>
	<cfset session_base = evaluate('session.pp')>
<cfelseif isdefined("session.ep")>
	<cfset session_base = evaluate('session.ep')>
<cfelseif isdefined("session.ww")>
	<cfset session_base = evaluate('session.ww')>
<cfelseif isdefined("session.wp")>
	<cfset session_base = evaluate('session.wp')>
</cfif>

<cfparam name="attributes.para_birimi" default="#session_base.money#">
<cfparam name="attributes.alt_para_birimi" default="">
<cfparam name="attributes.ing" default="0">
<cfoutput>
	<cfsavecontent variable="bir">#caller.getLang('main',679)#</cfsavecontent>
	<cfsavecontent variable="iki">#caller.getLang('main',680)#</cfsavecontent>
	<cfsavecontent variable="uc">#caller.getLang('main',681)#</cfsavecontent>
	<cfsavecontent variable="dort">#caller.getLang('main',682)#</cfsavecontent>
	<cfsavecontent variable="bes">#caller.getLang('main',683)#</cfsavecontent>
	<cfsavecontent variable="alti">#caller.getLang('main',684)#</cfsavecontent>
	<cfsavecontent variable="yedi">#caller.getLang('main',685)#</cfsavecontent>
	<cfsavecontent variable="sekiz">#caller.getLang('main',686)#</cfsavecontent>
	<cfsavecontent variable="dokuz">#caller.getLang('main',687)#</cfsavecontent>
	<cfsavecontent variable="sifir">#caller.getLang('main',688)#</cfsavecontent>
	<cfsavecontent variable="on">#caller.getLang('main',689)#</cfsavecontent>
	<cfsavecontent variable="onbir">#caller.getLang('main',1389)#</cfsavecontent>
	<cfsavecontent variable="oniki">#caller.getLang('main',1390)#</cfsavecontent>
	<cfsavecontent variable="onuc">#caller.getLang('main',1391)#</cfsavecontent>
	<cfsavecontent variable="ondort">#caller.getLang('main',1392)#</cfsavecontent>
	<cfsavecontent variable="onbes">#caller.getLang('main',1393)#</cfsavecontent>
	<cfsavecontent variable="onalti">#caller.getLang('main',1394)#</cfsavecontent>
	<cfsavecontent variable="onyedi">#caller.getLang('main',1395)#</cfsavecontent>
	<cfsavecontent variable="onsekiz">#caller.getLang('main',1396)#</cfsavecontent>
	<cfsavecontent variable="ondokuz">#caller.getLang('main',1397)#</cfsavecontent>
	<cfsavecontent variable="yirmi">#caller.getLang('main',690)#</cfsavecontent>
	<cfsavecontent variable="otuz">#caller.getLang('main',691)#</cfsavecontent>
	<cfsavecontent variable="kirk">#caller.getLang('main',692)#</cfsavecontent>
	<cfsavecontent variable="elli">#caller.getLang('main',693)#</cfsavecontent>
	<cfsavecontent variable="altmis">#caller.getLang('main',694)#</cfsavecontent>
	<cfsavecontent variable="yetmis">#caller.getLang('main',695)#</cfsavecontent>
	<cfsavecontent variable="seksen">#caller.getLang('main',696)#</cfsavecontent>
	<cfsavecontent variable="doksan">#caller.getLang('main',697)#</cfsavecontent>
	<cfsavecontent variable="yuz">#caller.getLang('main',698)#</cfsavecontent>
	<cfsavecontent variable="bin">#caller.getLang('main',699)#</cfsavecontent>
	<cfsavecontent variable="milyon">#caller.getLang('main',700)#</cfsavecontent>
	<cfsavecontent variable="milyar">#caller.getLang('main',701)#</cfsavecontent>
	<cfsavecontent variable="trilyon">#caller.getLang('main',702)#</cfsavecontent>
	<cfsavecontent variable="katrilyon">#caller.getLang('main',703)#</cfsavecontent>
</cfoutput>


<cfif attributes.para_birimi is 'YTL'>
	<cfset attributes.alt_para_birimi = 'YKr'>
<cfelseif attributes.para_birimi is 'USD'>
	<cfset attributes.alt_para_birimi = 'Cent'>
<cfelseif attributes.para_birimi is 'TL'>
	<cfset attributes.alt_para_birimi = 'Kr'>
<cfelseif attributes.para_birimi is 'EUR'>
	<cfset attributes.alt_para_birimi = 'EUR Cent'>	
</cfif>
<cfscript>
function cevir(gelen_sayi)
{
	if(listlen(gelen_sayi,'.') eq 2)
		{
		tam_kisim = listfirst(gelen_sayi,'.');
		ondalik_kisim = listlast(gelen_sayi,'.');
		ondalik_kisim = mid(ondalik_kisim,1,2);//wrk_round sız gelenler için son bi kontrol virgüllü kısm için
		
		if(len(ondalik_kisim) eq 1)
			ondalik_kisim = '#ondalik_kisim#0';
		/*else
			ondalik_kisim = '#ondalik_kisim#';//ondalik_kisim = '#ondalik_kisim#0'; SG20131224 ondalik kısımda sonu sıfır gelen sayılarda problem oldugu icin 0 kaldırıldı.*/
		}
	else
		{
		tam_kisim = gelen_sayi;
		ondalik_kisim = '';
		}
	tam_donen = '';
	ondalik_donen = '';

	sayi_uzunluk = len(tam_kisim);
	for(on_rakam=1;on_rakam lte len(ondalik_kisim);on_rakam=on_rakam+1)
		{
			my_on_rakam = mid(ondalik_kisim,on_rakam,1);
			if(on_rakam eq 1)
			{
				switch(my_on_rakam)
				{
					case "1" : 
					{
						my_second_rakam = mid(ondalik_kisim,2,1);
						switch(my_second_rakam)
						{
							case "1" : ondalik_donen = "#ondalik_donen# #onbir#";break;
							case "2" : ondalik_donen = "#ondalik_donen# #oniki#";break;
							case "3" : ondalik_donen = "#ondalik_donen# #onuc#";break;
							case "4" : ondalik_donen = "#ondalik_donen# #ondort#";break;
							case "5" : ondalik_donen = "#ondalik_donen# #onbes#";break;
							case "6" : ondalik_donen = "#ondalik_donen# #onalti#";break;
							case "7" : ondalik_donen = "#ondalik_donen# #onyedi#";break;
							case "8" : ondalik_donen = "#ondalik_donen# #onsekiz#";break;
							case "9" : ondalik_donen = "#ondalik_donen# #ondokuz#";break;
							case "0" : ondalik_donen = "#ondalik_donen# #on#";break;
						}
						break;
					} 
					case "2" : ondalik_donen = "#ondalik_donen# #yirmi#";break;
					case "3" : ondalik_donen = "#ondalik_donen# #otuz#";break;
					case "4" : ondalik_donen = "#ondalik_donen# #kirk#";break;
					case "5" : ondalik_donen = "#ondalik_donen# #elli#";break;
					case "6" : ondalik_donen = "#ondalik_donen# #altmis#";break;
					case "7" : ondalik_donen = "#ondalik_donen# #yetmis#";break;
					case "8" : ondalik_donen = "#ondalik_donen# #seksen#";break;
					case "9" : ondalik_donen = "#ondalik_donen# #doksan#";break;
					case "0" : ondalik_donen = "#ondalik_donen# #sifir#";break;
				}
			}
			
			if(on_rakam eq 2)
			{
				my_first_rakam = mid(ondalik_kisim,1,1);
				if(my_first_rakam neq 1)
				{
					switch(my_on_rakam)
					{
						case "1" : ondalik_donen = "#ondalik_donen# #bir#";break;
						case "2" : ondalik_donen = "#ondalik_donen# #iki#";break;
						case "3" : ondalik_donen = "#ondalik_donen# #uc#";break;
						case "4" : ondalik_donen = "#ondalik_donen# #dort#";break;
						case "5" : ondalik_donen = "#ondalik_donen# #bes#";break;
						case "6" : ondalik_donen = "#ondalik_donen# #alti#";break;
						case "7" : ondalik_donen = "#ondalik_donen# #yedi#";break;
						case "8" : ondalik_donen = "#ondalik_donen# #sekiz#";break;
						case "9" : ondalik_donen = "#ondalik_donen# #dokuz#";break;
						//case "0" : ondalik_donen = "#ondalik_donen# #sifir#";break;
					}
				}
			}
		}
	
		for(rakam=1;rakam lte len(tam_kisim);rakam=rakam+1)
		{
			onceki_sayi = 0;
			iki_onceki_sayi = 0;
			my_sira = sayi_uzunluk - rakam + 1;
			my_mod = my_sira mod 3;
			my_rakam = mid(tam_kisim,rakam,1);
			if(my_sira gt 3)
				{
					if((sayi_uzunluk-rakam) eq 1)
					{
						onceki_sayi = mid(tam_kisim,rakam-1,1);
						iki_onceki_sayi = 0;
					}
					else if((sayi_uzunluk-rakam) gte 2 and rakam gt 1)
					{
						onceki_sayi = mid(tam_kisim,rakam-1,1);
						if(rakam neq 2)
							iki_onceki_sayi = mid(tam_kisim,rakam-2,1);
					}
				}

			if(my_mod eq 1)
			{
				if(my_sira lt sayi_uzunluk)
				{
				sonraki_sayi = mid(tam_kisim,rakam-1,1);
					if(sonraki_sayi neq 1)
					{
						switch(my_rakam)
						{
							case "1" : tam_donen = "#tam_donen# #bir#";break;
							case "2" : tam_donen = "#tam_donen# #iki#";break;
							case "3" : tam_donen = "#tam_donen# #uc#";break;
							case "4" : tam_donen = "#tam_donen# #dort#";break;
							case "5" : tam_donen = "#tam_donen# #bes#";break;
							case "6" : tam_donen = "#tam_donen# #alti#";break;
							case "7" : tam_donen = "#tam_donen# #yedi#";break;
							case "8" : tam_donen = "#tam_donen# #sekiz#";break;
							case "9" : tam_donen = "#tam_donen# #dokuz#";break;
							case "0" : tam_donen = "#tam_donen#";break;
						}
					}
				}
				else if(my_sira eq sayi_uzunluk)
					{
						switch(my_rakam)
						{
							case "1" :if(attributes.ing eq 1 or not listfind('3,4',my_sira)) tam_donen = "#tam_donen# #bir#"; else tam_donen = "#tam_donen#";break;// yuz ve bin disindakiler icin 1 degeri yazilsin fbs20110103
							case "2" : tam_donen = "#tam_donen# #iki#";break;
							case "3" : tam_donen = "#tam_donen# #uc#";break;
							case "4" : tam_donen = "#tam_donen# #dort#";break;
							case "5" : tam_donen = "#tam_donen# #bes#";break;
							case "6" : tam_donen = "#tam_donen# #alti#";break;
							case "7" : tam_donen = "#tam_donen# #yedi#";break;
							case "8" : tam_donen = "#tam_donen# #sekiz#";break;
							case "9" : tam_donen = "#tam_donen# #dokuz#";break;
							case "0" : tam_donen = "#tam_donen#";break;
						}
					}
				else
				{
					switch(my_rakam)
						{
						case "1" : tam_donen = "#tam_donen# #bir#";break;
						case "2" : tam_donen = "#tam_donen# #iki#";break;
						case "3" : tam_donen = "#tam_donen# #uc#";break;
						case "4" : tam_donen = "#tam_donen# #dort#";break;
						case "5" : tam_donen = "#tam_donen# #bes#";break;
						case "6" : tam_donen = "#tam_donen# #alti#";break;
						case "7" : tam_donen = "#tam_donen# #yedi#";break;
						case "8" : tam_donen = "#tam_donen# #sekiz#";break;
						case "9" : tam_donen = "#tam_donen# #dokuz#";break;
						case "0" : tam_donen = "#tam_donen#";break;
						}
				}
			}
			else if(my_mod eq 2)
			{
				switch(my_rakam)
				{
					case "1" : 
					{
						if(my_sira lte sayi_uzunluk)
							{
								sonraki_sayi = mid(tam_kisim,rakam+1,1);
								switch(sonraki_sayi)
								{
									case "1" : tam_donen = "#tam_donen# #onbir#";break;
									case "2" : tam_donen = "#tam_donen# #oniki#";break;
									case "3" : tam_donen = "#tam_donen# #onuc#";break;
									case "4" : tam_donen = "#tam_donen# #ondort#";break;
									case "5" : tam_donen = "#tam_donen# #onbes#";break;
									case "6" : tam_donen = "#tam_donen# #onalti#";break;
									case "7" : tam_donen = "#tam_donen# #onyedi#";break;
									case "8" : tam_donen = "#tam_donen# #onsekiz#";break;
									case "9" : tam_donen = "#tam_donen# #ondokuz#";break;
									case "0" : tam_donen = "#tam_donen# #on#";break;
								}
							}
						else
							tam_donen = "#tam_donen# #on#";
					break;
					} 
					case "2" : tam_donen = "#tam_donen# #yirmi#";break;
					case "3" : tam_donen = "#tam_donen# #otuz#";break;
					case "4" : tam_donen = "#tam_donen# #kirk#";break;
					case "5" : tam_donen = "#tam_donen# #elli#";break;
					case "6" : tam_donen = "#tam_donen# #altmis#";break;
					case "7" : tam_donen = "#tam_donen# #yetmis#";break;
					case "8" : tam_donen = "#tam_donen# #seksen#";break;
					case "9" : tam_donen = "#tam_donen# #doksan#";break;
					case "0" : tam_donen = "#tam_donen# ";break;
				}
			}
			else if(my_mod eq 0)
			{
				switch(my_rakam)
				{
					case "1" : if(attributes.ing eq 1) tam_donen = "#tam_donen# #bir# #yuz#"; else tam_donen = "#tam_donen# #yuz#"; break;
					case "2" : tam_donen = "#tam_donen# #iki# #yuz#";break;
					case "3" : tam_donen = "#tam_donen# #uc# #yuz#";break;
					case "4" : tam_donen = "#tam_donen# #dort# #yuz#";break;
					case "5" : tam_donen = "#tam_donen# #bes# #yuz#";break;
					case "6" : tam_donen = "#tam_donen# #alti# #yuz#";break;
					case "7" : tam_donen = "#tam_donen# #yedi# #yuz#";break;
					case "8" : tam_donen = "#tam_donen# #sekiz# #yuz#";break;
					case "9" : tam_donen = "#tam_donen# #dokuz# #yuz#";break;
					case "0" : tam_donen = "#tam_donen# ";break;
				}
			}

			if(my_sira gt 3)
			{
				bir_sonraki = mid(tam_kisim,rakam+1,1);
				iki_sonraki = mid(tam_kisim,rakam+2,1);
				
				if(my_sira eq 6 and my_rakam neq 0 and bir_sonraki eq 0 and iki_sonraki eq 0) tam_donen = "#tam_donen# #bin#";
				else if(my_sira eq 5 and my_rakam neq 0 and bir_sonraki eq 0) tam_donen = "#tam_donen# #bin#";
				else if(my_sira eq 4 and my_rakam neq 0) tam_donen = "#tam_donen# #bin#";
				
				else if(my_sira eq 9 and my_rakam neq 0 and bir_sonraki eq 0 and iki_sonraki eq 0) tam_donen = "#tam_donen# #milyon#";
				else if(my_sira eq 8 and my_rakam neq 0 and bir_sonraki eq 0) tam_donen = "#tam_donen# #milyon#";
				else if(my_sira eq 7 and my_rakam neq 0) tam_donen = "#tam_donen# #milyon#";
				
				else if(my_sira eq 12 and my_rakam neq 0 and bir_sonraki eq 0 and iki_sonraki eq 0) tam_donen = "#tam_donen# #milyar#";
				else if(my_sira eq 11 and my_rakam neq 0 and bir_sonraki eq 0) tam_donen = "#tam_donen# #milyar#";
				else if(my_sira eq 10 and my_rakam neq 0) tam_donen = "#tam_donen# #milyar#";
				
				else if(my_sira eq 15 and my_rakam neq 0 and bir_sonraki eq 0 and iki_sonraki eq 0) tam_donen = "#tam_donen# #trilyon#";
				else if(my_sira eq 14 and my_rakam neq 0 and bir_sonraki eq 0) tam_donen = "#tam_donen# #trilyon#";
				else if(my_sira eq 13 and my_rakam neq 0) tam_donen = "#tam_donen# #trilyon#";
				
				else if(my_sira eq 18 and my_rakam neq 0 and bir_sonraki eq 0 and iki_sonraki eq 0) tam_donen = "#tam_donen# #katrilyon#";
				else if(my_sira eq 17 and my_rakam neq 0 and bir_sonraki eq 0) tam_donen = "#tam_donen# #katrilyon#";
				else if(my_sira eq 16 and my_rakam neq 0) tam_donen = "#tam_donen# #katrilyon#";
			}
			
		}
		my_text = '#tam_donen# #attributes.para_birimi#';
		if(len(ondalik_donen) and (ondalik_donen is not '00' or ondalik_donen is not '0'))
			my_text = '#my_text# #ondalik_donen# #attributes.alt_para_birimi#';
		return my_text;
	}
	try
	{
		"caller.#attributes.number#" = cevir(evaluate("caller.#attributes.number#"));
	}
	catch(any e)
	{
		writeoutput('!!n2txt!!');
	}
</cfscript>
