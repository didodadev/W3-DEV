var js_money_ayrac_binlik = ',';
var js_money_ayrac_ondalik = '.';

function wrk_round(ValToRnd, no_of_decimal){
	/*Aldigi degerler matematik deger olmalidir.
	Bunun sonucunu ekranda gormek icin cogu zaman commaSplit e vermek yeterlidir*/
	ondalik_kisim_uzunluk_ = 0;
	if(!no_of_decimal && no_of_decimal!=0) no_of_decimal=2;
	
	try
	{
		if(ValToRnd.indexOf('.'))
			{
			is_decimal_ok_ = list_len(ValToRnd,'.');
			if(is_decimal_ok_ == 2)
				{
					ondalik_kisim_ = list_getat(ValToRnd,2,'.');
					ondalik_kisim_uzunluk_ = ondalik_kisim_.length;
				}
			}
		if(ondalik_kisim_uzunluk_ > no_of_decimal)
		{
		/* ValToRnd= filterNum(ValToRnd); */
		decimal_carpan = Math.pow(10,no_of_decimal);
		if(ValToRnd!=0) return (Math.round(ValToRnd*decimal_carpan)/decimal_carpan);
		else return 0;
		}
		else
		{
			return ValToRnd;
		}
	}
	catch(err)
	{
		decimal_carpan = Math.pow(10,no_of_decimal);
		if(ValToRnd!=0) return (Math.round(ValToRnd*decimal_carpan)/decimal_carpan);
		else return 0;
	}
	/*return f2(ValToRnd);*/
}

function f1(temp_str)
{
	return filterNum(temp_str);
}

function f2(temp_str)
{
	if (temp_str.length == 0) return '';
	temp_str = temp_str.toString();
	if (temp_str.indexOf(js_money_ayrac_binlik) >= 0)
		{
		yer = temp_str.indexOf(js_money_ayrac_binlik);
		temp_str = temp_str.substr(0,yer) + js_money_ayrac_ondalik + temp_str.substr(yer+1, temp_str.length-yer-1);
		}
	return temp_str;
}

function filterNum(str,no_of_decimal) 
{
	/*form submit edilmeden önce float veya integer alanların temizliği için*/
	if (str.length == 0) return '';
	if(!no_of_decimal && no_of_decimal!=0) no_of_decimal=2;
	strCheck = '-0123456789' + js_money_ayrac_ondalik;
	newStr = '';
	for(var i=0; i < str.length; i++) if (strCheck.indexOf(str.charAt(i)) != -1) newStr += str.charAt(i);/*i=0 ifadesi var i=0 oldu.*/
	if(js_money_ayrac_ondalik == ',')
		{
		newStr = newStr.replace(js_money_ayrac_ondalik,js_money_ayrac_binlik);
		while(newStr.indexOf(js_money_ayrac_ondalik) > 0) newStr = newStr.replace(js_money_ayrac_ondalik,'');
		}
	else
		{
			if(newStr.indexOf(js_money_ayrac_ondalik)>0)
				{
					var temp = newStr.length-newStr.indexOf(js_money_ayrac_ondalik)-1;
					if(temp == 0)
						{
							newStr = newStr.replace(js_money_ayrac_ondalik,'');	
						}
				}
		}
	return wrk_round(newStr,no_of_decimal);
}

function formatcurrency(fld,e) 
{
	return FormatCurrency(fld,e);
}

function FormatCurrency(fld,e,no_of_decimal) 
{
	/*modified 20051225*/
	if(!e) return false;/*if(!e) var e = window.event;*/
	if(!no_of_decimal && no_of_decimal!=0) no_of_decimal=2;
	var whichCode = (window.Event) ? e.which : e.keyCode;/*klavyede basilan tusun nosu , e.keyCode:IE, e.which:NN*/
	/*klavyede basilan tusu gormek istersek alert(String.fromCharCode(whichCode));*/
	key_spec_codes = "'13','16','17','35','36','37','39','109','189','9','11'";/*sirasiyla enter,shift,ctrl,end,home,left,right,tab,tab tuslari (belki 189 yani tire veya negatif kontrol edilmeli)*/
	if(key_spec_codes.search("'" + whichCode + "'")>=0) return true; 
	
	if(whichCode==32)
		{/*space (bosluk) basilirsa hepsi temizlensin*/
		while(fld.value.indexOf(' ') > 0)
			fld.value = fld.value.replace(' ','');
		return false;
		}
	if(fld.value=='.' || fld.value==',' || fld.value=='-') {fld.value = '';return false;}
	if(fld.value.indexOf(js_money_ayrac_ondalik)>0)
		{
		/*diger key kodlar = 188 ve 110:virgul,8:back space,46:del, tus takiminin iki virgulune de izin var*/
		var temp = fld.value.length-fld.value.indexOf(js_money_ayrac_ondalik)-1;
		if(temp == 0)/*son eleman virgulse ve back space veya del tuslanmissa veya decimal yoksa virgulu de silsin*/
			{
			fld.value = (whichCode==8 || whichCode==46 || no_of_decimal==0) ? commaSplit(filterNum(fld.value,temp),temp) : commaSplit(filterNum(fld.value,temp),temp) + js_money_ayrac_ondalik;
			//alert('tmp'+fld.value);
			}
		else if(temp < no_of_decimal)
			fld.value = commaSplit(filterNum(fld.value,temp),temp);
		else if(temp > no_of_decimal)
			/* bu durumda girilen degerin istenen decimale kadar olan kismini fonksiyonlardan gecirecegiz*/
			fld.value = commaSplit(filterNum(fld.value.substr(0,fld.value.indexOf(js_money_ayrac_ondalik)+1+no_of_decimal),no_of_decimal),no_of_decimal);
		else
			{
			fld.value = commaSplit(filterNum(fld.value,no_of_decimal),no_of_decimal);
			}
		}
	else
		{
		fld.value = commaSplit(filterNum(fld.value),0);
		}
	return false;
}

function commaSplit(str,no_of_decimal,is_round)
{
	/* float degerler icin zaten uygun calisir, no_of_decimal kadar hane default yuvarlar,
	yuvarlamamak icin mutlaka no_of_decimal girmeli ve is_round argument da false olmalidir*/
	if(str.length==0) return '';
	if(!is_round && is_round != false) is_round=true;/*yuvarlama girilmemis veya girilmis ama false degilse ellemeyin*/
	if(!no_of_decimal && no_of_decimal!=0) no_of_decimal=2; /* if dogru ellemeyin */
	if(is_round) str = wrk_round(str,no_of_decimal);
	negatif_flag = 0;
	str = str.toString();
	if(parseFloat(str) < 0) {negatif_flag = 1;str = str.replace('-','');}
	if (str.indexOf(js_money_ayrac_ondalik)>0)/*sadece YTL gecisi icin gecici olarak calisiyor, silinmeli*/
		{
		//alert('commaSplit e verilen '+str+' degeri'+' float a cevrilerek verilmelidir.\r -filterNum() ve f2() konbinasyonları kullanılabilir-\rYine de değeriniz düzeltildi (HS)');
		//str = filterNum(f2(filterNum(str)));
		}
	
	textFormat_1='';
	textFormat_2='';
	
	temp_virgul = str.indexOf('.');
	virgul = '';
	if(temp_virgul >= 0 && no_of_decimal > 0)
		{
		virgul = js_money_ayrac_ondalik;
		textFormat_2 = str.substr(temp_virgul+1,str.length);
		if(textFormat_2.length > no_of_decimal)
			textFormat_2 = textFormat_2.substr(0,no_of_decimal);
		else
			for (var txtf1 = textFormat_2.length+1;txtf1<=no_of_decimal;txtf1++)
				textFormat_2 = textFormat_2 + '0';
		}
	else if(temp_virgul < 0 && no_of_decimal > 0)/* if dogru ellemeyin */
		{
		virgul = js_money_ayrac_ondalik;
		for (var txtf1=1;txtf1<=no_of_decimal;txtf1++)
			textFormat_2 = textFormat_2 + '0';
		}
	nokta_koy = 0;
	if(temp_virgul==0)
		textFormat_1 = 0;
	else if(temp_virgul>3)
		for (var k = temp_virgul-1; k>=0 ; k--){
		textFormat_1 = str.substr(k,1) + textFormat_1;
		nokta_koy++;
		if (nokta_koy%3==0 && k!=0) textFormat_1 = js_money_ayrac_binlik +textFormat_1;
		}
	else if(temp_virgul>0)
		textFormat_1 = str.substr(0,temp_virgul);
	else if(temp_virgul<0)
		for (var k=str.length-1; k>=0 ; k--){
		textFormat_1 = str.substr(k,1) + textFormat_1;
		nokta_koy++;
		if (nokta_koy%3==0 && k!=0) textFormat_1 = js_money_ayrac_binlik + textFormat_1;
		}

	textFormat = textFormat_1 + virgul + textFormat_2;
	if(negatif_flag) return '-'+textFormat;
	return textFormat;
}

