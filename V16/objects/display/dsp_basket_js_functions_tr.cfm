<script language="javascript1.3">
function filterNumBasket(str,no_of_decimal) 
{
	if (str == undefined || str.length == 0) return '';
	if(!no_of_decimal && no_of_decimal!=0)
		no_of_decimal=2;
	while(str.indexOf('.') > 0) str = str.replace('.','');
	str = str.replace(',', '.');
	decimal_carpan = Math.pow(10,no_of_decimal);
	if(str!=0) return (Math.round(str*decimal_carpan)/decimal_carpan);
	else return  0;
}
function wrk_round(ValToRnd, no_of_decimal){
	/*Aldigi degerler matematik deger olmalidir.
	Bunun sonucunu ekranda gormek icin cogu zaman commaSplit e vermek yeterlidir*/
	if(!no_of_decimal && no_of_decimal!=0)
		no_of_decimal=2;
	decimal_carpan = Math.pow(10,no_of_decimal);
	if(ValToRnd!=0) return (Math.round(ValToRnd*decimal_carpan)/decimal_carpan);
	else return 0;
}
function filterNum(str,no_of_decimal) 
{
	/*form submit edilmeden önce float veya integer alanların temizliği için*/
	if (str == undefined || str.length == 0) return '';
	if(!no_of_decimal && no_of_decimal!=0)
		no_of_decimal=2;
	strCheck = '-0123456789,';
	newStr = '';
	var temp_strlen =str.length;
	for(var i=0; i < temp_strlen; i++) if (strCheck.indexOf(str.charAt(i)) != -1) newStr += str.charAt(i);
	newStr = newStr.replace(',', '.');
	while(newStr.indexOf(',') > 0) newStr = newStr.replace(',','');
	return wrk_round(newStr,no_of_decimal);
}

function commaSplit(str,no_of_decimal,is_round)
{
	/* float degerler icin zaten uygun calisir, no_of_decimal kadar hane default yuvarlar,	yuvarlamamak icin mutlaka no_of_decimal girmeli ve is_round argument da false olmalidir*/
	if (str == undefined || str.length == 0) return '';
	if(!is_round && is_round != false) is_round=true;/*yuvarlama girilmemis veya girilmis ama false degilse ellemeyin*/
	if(!no_of_decimal && no_of_decimal!=0) /* if dogru ellemeyin */
		no_of_decimal=2;
	if(is_round) str = wrk_round(str,no_of_decimal);
	negatif_flag = 0;
	str = str.toString();
	if(parseFloat(str) < 0) {negatif_flag = 1;str = str.replace('-','');}
	textFormat_1='';
	textFormat_2='';
	temp_virgul = str.indexOf('.');
	virgul = '';
	if(temp_virgul >= 0 && no_of_decimal > 0)
		{
		virgul = ',';
		textFormat_2 = str.substr(temp_virgul+1,str.length);
		if(textFormat_2.length > no_of_decimal)
			textFormat_2 = textFormat_2.substr(0,no_of_decimal);
		else
			for (var txtf1 = textFormat_2.length+1;txtf1<=no_of_decimal;txtf1++)
				textFormat_2 = textFormat_2+'0';
		}
	else if(temp_virgul < 0 && no_of_decimal > 0)/* if dogru ellemeyin */
		{
		virgul = ',';
		for (var txtf1=1;txtf1<=no_of_decimal;txtf1++)
			textFormat_2 = textFormat_2+'0';
		}
	nokta_koy = 0;
	if(temp_virgul==0)
		textFormat_1 = 0;
	else if(temp_virgul>3)
		for (var k = temp_virgul-1; k>=0 ; k--){
		textFormat_1 = str.substr(k,1) + textFormat_1;
		nokta_koy++;
		if (nokta_koy%3==0 && k!=0) textFormat_1 = '.'+textFormat_1;
		}
	else if(temp_virgul>0)
		textFormat_1 = str.substr(0,temp_virgul);
	else if(temp_virgul<0)
		for (var k=str.length-1; k>=0 ; k--){
		textFormat_1 = str.substr(k,1) + textFormat_1;
		nokta_koy++;
		if (nokta_koy%3==0 && k!=0) textFormat_1 = '.'+textFormat_1;
		}
	textFormat = textFormat_1+virgul+textFormat_2;
	if(negatif_flag) return '-'+textFormat;
	return textFormat;
}

function formatcurrency(fld,e,d) 
{
	return FormatCurrency(fld,e,d);
}

function FormatCurrency(fld,e,no_of_decimal,type) 
{
	
	if(type && type == 'int')
		max_value = 2147483647;
	else
		max_value=Number.MAX_VALUE;
	
	/*modified 20051225*/
	if(!e) return false;/*if(!e) var e = window.event;*/
	if(!no_of_decimal && no_of_decimal!=0) no_of_decimal=2;
	var whichCode = (window.Event) ? e.which : e.keyCode;/*klavyede basilan tusun nosu , e.keyCode:IE, e.which:NN*/
	/*klavyede basilan tusu gormek istersek alert(String.fromCharCode(whichCode));*/
	key_spec_codes = "'13','16','17','35','36','37','39','109','189','9','11'";/*sirasiyla enter,shift,ctrl,end,home,left,right,tab,tab tuslari (belki 189 yani tire veya negatif kontrol edilmeli)*/
	if(key_spec_codes.search("'" + whichCode + "'")>=0) return true; 
	
	if(type)
	{
		if(type == 'int')
		{
			if(whichCode == 110 || whichCode == 188)//virgül kontrolü
			{
				fld.value = fld.value.slice(0,fld.value.length-1);
				alert("<cf_get_lang dictionary_id='60043.Database deki karşılığı olan'>" + type.toUpperCase() + "<cf_get_lang dictionary_id='60044.alana virgül karakteri giremezsiniz'>.");
			}				

			if(filterNum(commaSplit(filterNum(fld.value),0)) > max_value)
			{
				 if(filterNum(commaSplit(filterNum(fld.value),0)).length == 11)
					 fld.value = filterNum(commaSplit(filterNum(fld.value),0)).slice(0,10);
				 else
					 fld.value = filterNum(commaSplit(filterNum(fld.value),0)).slice(0,9);
				 alert("<cf_get_lang dictionary_id='60045.Database de karşılık olan alan tipi'>": +type.toUpperCase()+ "<cf_get_lang dictionary_id='60046.En fazla girilebilecek değer'>:" +max_value);
			}
		}
		else if(type == 'float')
		{
			if(filterNum(commaSplit(filterNum(fld.value),0)) > max_value)
			{
				 if(filterNum(commaSplit(filterNum(fld.value),0)).length == 40)
					 fld.value = filterNum(commaSplit(filterNum(fld.value),0)).slice(0,39);
				 else
					 fld.value = filterNum(commaSplit(filterNum(fld.value),0)).slice(0,38);
				 alert("<cf_get_lang dictionary_id='60045.Database de karşılık olan alan tipi'>": +type.toUpperCase()+ "<cf_get_lang dictionary_id='60046.En fazla girilebilecek değer'>:" +max_value);
			}
		}
	}
	
	if(whichCode==32)
		{/*space (bosluk) basilirsa hepsi temizlensin*/
		while(fld.value.indexOf(' ') > 0)
			fld.value = fld.value.replace(' ','');
		return false;
		}
		
	var result = "";
	var lengthBefore ="";
	var x="";
	var lengthAfter="";
		
	if(fld.value==',' || fld.value=='-') {fld.value = '';return false;}
	if(fld.value.indexOf(',')>0)
		{
		/*diger key kodlar = 188 ve 110:virgul,8:back space,46:del, tus takiminin iki virgulune de izin var*/
		var temp = fld.value.length-fld.value.indexOf(',')-1;
		if(temp == 0)/*son eleman virgulse ve back space veya del tuslanmissa veya decimal yoksa virgulu de silsin*/
			result = (whichCode==8 || whichCode==46 || no_of_decimal==0) ? commaSplit(filterNum(fld.value,temp),temp) : commaSplit(filterNum(fld.value,temp),temp)+',';
		else if(temp < no_of_decimal)
			result = commaSplit(filterNum(fld.value,temp),temp);
		else if(temp > no_of_decimal)
			/* bu durumda girilen degerin istenen decimale kadar olan kismini fonksiyonlardan gecirecegiz*/
			result = commaSplit(filterNum(fld.value.substr(0,fld.value.indexOf(',')+1+no_of_decimal),no_of_decimal),no_of_decimal);
		else
			{
			result = commaSplit(filterNum(fld.value,no_of_decimal),no_of_decimal);
			}
			
			x = doGetCaretPosition(fld);
			lengthBefore = fld.value.length;
			fld.value = result;
			lengthAfter = fld.value.length;
			//alert(lengthBefore + ':'+lengthAfter);
			if(lengthBefore>1 && (lengthBefore<lengthAfter)){
				doSetCaretPosition(fld,x+1);
			}else if(lengthBefore>1 && (lengthBefore>lengthAfter)){
				doSetCaretPosition(fld,x-1);
			}else{
				doSetCaretPosition(fld,x);
			}
			
		}
	else
	{
		result = commaSplit(filterNum(fld.value),0);
		//return false;
		//fld.value = result; //commaSplit(filterNum(fld.value),0);
		//return false;
		x = doGetCaretPosition(fld);
		lengthBefore = fld.value.length;
        fld.value = result;
		lengthAfter = fld.value.length;
		//alert(lengthBefore + ':'+lengthAfter);
			if(lengthBefore>1 && (lengthBefore<lengthAfter)){
				doSetCaretPosition(fld,x+1);
			}else if(lengthBefore>1 && (lengthBefore>lengthAfter)){
				doSetCaretPosition(fld,x-1);
			}else{
				doSetCaretPosition(fld,x);
			}
	}
	return false;
}

function doGetCaretPosition (oField) {
		var iCaretPos = 0;
		if (document.selection) // IE Support
			{
			oField.focus ();
			var oSel = document.selection.createRange ();
			// Move selection start to 0 position
			oSel.moveStart ('character', -oField.value.length);
			// The caret position is selection length
			iCaretPos = oSel.text.length;
			}
		else
			if (oField.selectionStart || oField.selectionStart == '0') // Firefox support
				iCaretPos = oField.selectionStart;
		return (iCaretPos);
		}
function doSetCaretPosition (oField, iCaretPos)
	{
	if (document.selection) // IE Support
		{
		//var fldLength = oField.value.toString().split(",").length - 1;
		//alert(oField.value.length);
		oField.focus ();
		var oSel = document.selection.createRange ();
		oSel.moveStart ('character', -oField.value.length);
		oSel.moveStart ('character', (iCaretPos));
		oSel.moveEnd ('character',(iCaretPos-oField.value.length));
		oSel.select ();
		}
	else
		if (oField.selectionStart || oField.selectionStart == '0') // Firefox support
			{
			oField.selectionStart = iCaretPos;
			oField.selectionEnd = iCaretPos;
			oField.focus ();
			}
	}

function checkDecimal(oField){
	var decimalNumber = oField.value.toString().split(".").length - 1;
	if(decimalNumber <= 0){
		return false
	}else{
		var x = doGetCaretPosition (oField);
		setCaretDecimal(oField, x);
		return true;
	}
}
function setCaretDecimal(oField, iCaretPos){
		if (document.selection) // IE Support
		{
		oField.focus ();
		var oSel = document.selection.createRange ();
		oSel.moveStart ('character', -oField.value.length);
		oSel.moveStart ('character', (iCaretPos));
		oSel.moveEnd ('character',0);
		oSel.select ();
		}else{
		if (oField.selectionStart || oField.selectionStart == '0') // Firefox support
			{
			oField.selectionStart = iCaretPos;
			oField.selectionEnd = iCaretPos;
			oField.focus ();
			}
	}

}

<!---function FormatCurrency(fld,e,no_of_decimal) 
{
	if(!e) return false;/*if(!e) var e = window.event;*/
	if(!no_of_decimal && no_of_decimal!=0)
	<cfif session_base.period_year lt 2005>
		no_of_decimal=0;
	<cfelse>
		no_of_decimal=2;
	</cfif>

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
	if(fld.value==',' || fld.value=='-') {fld.value = '';return false;}
	if(fld.value.indexOf(',')>0)
		{
		/*diger key kodlar = 188 ve 110:virgul,8:back space,46:del, tus takiminin iki virgulune de izin var*/
		var temp = fld.value.length-fld.value.indexOf(',')-1;
		if(temp == 0)/*son eleman virgulse ve back space veya del tuslanmissa veya decimal yoksa virgulu de silsin*/
			fld.value = (whichCode==8 || whichCode==46 || no_of_decimal==0) ? commaSplit(filterNum(fld.value,temp),temp) : commaSplit(filterNum(fld.value,temp),temp)+',';
		else if(temp < no_of_decimal)
			fld.value = commaSplit(filterNum(fld.value,temp),temp);
		else if(temp > no_of_decimal)
			/* bu durumda girilen degerin istenen decimale kadar olan kismini fonksiyonlardan gecirecegiz*/
			fld.value = commaSplit(filterNum(fld.value.substr(0,fld.value.indexOf(',')+1+no_of_decimal),no_of_decimal),no_of_decimal);
		else
			fld.value = commaSplit(filterNum(fld.value,no_of_decimal),no_of_decimal);
		}
	else
		fld.value = commaSplit(filterNum(fld.value),0);
	return false;
}--->
function list_find(listem,degerim,delim)
{ 
	var listem = listem.toString();
	var kontrol=0;
	if(!delim) delim = ',';
	var listem_1=listem.split(delim);
	for (var m=0; m<listem_1.length; m++)
		if(listem_1[m]==degerim)
		{
			kontrol=1;
			break;
		}
	if(kontrol) return m+1; else return 0;
}
</script>
