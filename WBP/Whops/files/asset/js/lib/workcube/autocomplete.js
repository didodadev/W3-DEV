/*
AutocompleteId			: Arama yapılacak textin id değerini belirtir.

findfield				: Database'den arama yapılacak alanların listesini belirtir. İlgili alanlar virgül ile ayrılarak gönderilmelidir.

visible_field			: Arama işlemi sırasında açılan listede görünecek alanları belirtir.  İlgili alanlar virgül ile ayrılarak gönderilmelidir.Ayırma işlemi ekranda ' || ' ayıracı ile yapılmaktadır.

query					: Aramanın yapılacağı workdata adını belirtir.

extra_params			: query de kullanılacak parametreleri belirtir. '1,3,2' gibi sayısal veriler gönderilirken, '1,\'2\',3' gibi de hem string hem de sayısal veri gönderilebilir.

datafield				: Arama işlemi sonucunda database den hangi alanların getirileceği belirlenir. İlgili alanlar virgül ile ayrılarak gönderilmelidir.

formfield				: Arama işlemi sonucunda sorgudan gelen değerlerin formdaki hangi alanlara yazılacağını belirtir. İlgili alanlar virgül ile ayrılarak gönderilmelidir.
// extend --->			: formfield alanına tek parametreli bir fonksiyon geçirilmesi durumunda callback işlemi yaparak fonksiyonun parametresine değeri döndürür. Tek değer üzerinden çalışacakk şekilde yapılandırılmıştır! Birden fazla değer için kullanılamaz! 

isNotDeleting			: İnputa değer girildiğinde autocomplete bulamıyorsa div kapatıldığında yazılan değerin silinmemesi için eklendi. Hata vermemesi için default 0 atandı. 1 gönderildiğinde silinmez.

Geri kalan tüm parametreler eski sistem içindir ve hata vermemesi için kullanılmıştır.
*/
var js_autocomplete_create_count_ = 1;
var arrAutocomplete = new Array();
var kontrol_i = 0;
/*
document.getElementsByTagName("body,html").onclick = function(){
	document.getElementsByClassName("completeListbox").remove();
};
*/
function AutoComplete_Create(AutocompleteId,findfield_wrk,visible_field_wrk,query_wrk,extra_params,datafield_wrk,formfield_wrk,a1,a2,a3,isCompleteText,isCompleteText2,isNotDeleting=0){

	js_autocomplete_create_count_ = 1; $(".completeListbox").remove(); // Birden fazla arama sonucu kutusu dökmemesi için kullanıldı.
	var obj_text_input = document.getElementById(AutocompleteId);
	
	var objInput = $('#'+AutocompleteId); //jquery selector	
	objInput.attr("autocomplete", "off");

	if(obj_text_input.readOnly == true)	return false;

	js_autocomplete_create_count_ = js_autocomplete_create_count_ + 1;
	
	var style = {
		
		"width"			: objInput.parent().width(),
		"max-height"	: "150px",
		"overflow"		: "auto",
		"position"		: "absolute",
		"left"          : objInput.position().left,
		"top"           :  objInput.position().top + objInput.outerHeight(),
		"z-index"		: "159", 
		"filter"		: "progid:DXImageTransform.Microsoft.Shadow(color='gray', Direction=135, Strength=4)",
		"display"		: "none",
		
		}
	
	
	
	
	var dropdown =	$('<div>').attr({
		
				'id'			: AutocompleteId+'_div_'+js_autocomplete_create_count_ ,
				'name'			: AutocompleteId+'_div_'+js_autocomplete_create_count_,
				'class'			: 'completeListbox',
				"autocomplete"	: "on"
						
				})
				.css(style)
				

	objInput.after(dropdown);
	
	arrAutocomplete[AutocompleteId] = new Array();
	arrAutocomplete[AutocompleteId]["dropdown"] = dropdown;
	arrAutocomplete[AutocompleteId]["obj_text_input"] = obj_text_input;
	arrAutocomplete[AutocompleteId]["obj_value_input"] = formfield_wrk;	
	arrAutocomplete[AutocompleteId]["column_visible"] = visible_field_wrk;	
	arrAutocomplete[AutocompleteId]["column_value"] = datafield_wrk;
	arrAutocomplete[AutocompleteId]["column_text"] = findfield_wrk;
	arrAutocomplete[AutocompleteId]["oldValue"] = $("#"+AutocompleteId).val();
	arrAutocomplete[AutocompleteId]["isNotDeleting"] = isNotDeleting;
	
	// Basket şablonlarında yer alan satır varsa proje değiştirilemesin kontrolü sadece proje popup'ında kontrol ediliyordu. Autocomplete'de kontrol eklendi. EY 20150805
	if(window.basket != undefined && window.basket.items.length && window.basket.hidden_values.basket_id != undefined && formfield_wrk.indexOf('project') == 0 && $("#"+formfield_wrk).val().length)
		arrAutocomplete[AutocompleteId]["projectControl"] = window.basket.hidden_values.basket_id;
	else
		arrAutocomplete[AutocompleteId]["projectControl"] = 0;
	//console.log('projectControl:'+projectControl);
	

	arrAutocomplete[AutocompleteId]["query"] = query_wrk;
	arrAutocomplete[AutocompleteId]["name"] = null;

	arrAutocomplete[AutocompleteId]["str"] = obj_text_input.value;
	if (extra_params!="") //for maxrow, always must be first parameters of queries
		extra_params = '50,'+escape(extra_params);
	else
		extra_params = '50';
	arrAutocomplete[AutocompleteId]["extra_params"] = extra_params;
	arrAutocomplete[AutocompleteId]["address"] = 'AutocompleteId='+AutocompleteId+'&query='+query_wrk+'&column_visible='+visible_field_wrk+'&column_text='+findfield_wrk+'&column_value='+datafield_wrk+'&divName='+AutocompleteId+'_div_'+js_autocomplete_create_count_+'&extra_params='+extra_params;

	arrAutocomplete[AutocompleteId]["divName"] =  AutocompleteId+'_div_'+js_autocomplete_create_count_;
	
	arrAutocomplete[AutocompleteId]["startIndex"] = 0;
	arrAutocomplete[AutocompleteId]["selectedIndex"] = -1;
	
	arrAutocomplete[AutocompleteId]["preSelectedIndex"] = -1;
	arrAutocomplete[AutocompleteId]["preClassName"] = "";
	
	arrAutocomplete[AutocompleteId]["writingStr"] = "";

	if (isCompleteText == true){ // for call_function
		arrAutocomplete[AutocompleteId]["isCompleteText"] = isCompleteText;
		arrAutocomplete[AutocompleteId]["call_function"] = isCompleteText2;
	}
	else
	{
		arrAutocomplete[AutocompleteId]["isCompleteText"] = isCompleteText2;
		arrAutocomplete[AutocompleteId]["call_function"] = isCompleteText;
	}
	
		obj_text_input.onkeydown = function (e)
		{		
			var evtobj = window.event ? event : e //distinguish between IE's explicit event object (window.event) and Firefox's implicit.
			var unicode = evtobj.charCode ? evtobj.charCode : evtobj.keyCode
			if ( unicode == 13 )
			{
				if (arrAutocomplete[AutocompleteId]["obj_text_input"].value.length<3 || arrAutocomplete[AutocompleteId]["dropdown"].css('display')=='none')
					return true;
				//sec(AutocompleteId,arrAutocomplete[AutocompleteId]["selectedIndex"]);
				return false;
			}else{

				if (arrAutocomplete[AutocompleteId]["obj_text_input"].value.length<3){

					$(".completeListbox").hide();
				
				}
			}
		}		

	obj_text_input.onkeyup = function (e){
		secim(AutocompleteId,e,'1',obj_text_input);
	}	

	/*obj_text_input.onblur = function(e)
	{*/
		try{
			if(arrAutocomplete[AutocompleteId]["dropdown"].css('display') !='none')
				var control_auto = 1;
		}catch(err){

		
		}
		//arrAutocomplete[AutocompleteId]["dropdown"].parentNode.removeChild(arrAutocomplete[AutocompleteId]["dropdown"]);
	/*}*/
	/*
	$('.completeListbox').on('mouseleave', hideElm);
	$(document).on('click', hideElm);
	function hideElm() {
		$(".completeListbox").hide(200);
	}
	*/
	

}

function secim(AutocompleteId,e){
	var evtobj=window.event? event : e //distinguish between IE's explicit event object (window.event) and Firefox's implicit.
	var unicode=evtobj.charCode? evtobj.charCode : evtobj.keyCode;
	var tmp = document.getElementById(AutocompleteId+'_div_'+js_autocomplete_create_count_);
	
	//var tmp = $("#"+AutocompleteId+'_div_'+js_autocomplete_create_count_);

	if (unicode==13 || unicode==27) 
	{ // enter ve esc için
		if (unicode==13)
		{
			setAtt(AutocompleteId,arrAutocomplete[AutocompleteId]["selectedIndex"],false);
			$("#"+AutocompleteId).blur();
		}
		else
		{
			reloadOldValue(AutocompleteId,arrAutocomplete[AutocompleteId]["oldValue"]);
			$("#"+AutocompleteId).blur();
		}
		$(tmp).css('display','none');
		//tmp.style.display = 'none';
		event.returnValue = false;
		event.cancelBubble = true;
		return;
	};
	try{
		//if (tmp.getElementsByTagName('div').length>1)
		{
			if (unicode==38){//up		
				sec(AutocompleteId,'dec');
				return;
			}
			else if (unicode==40){//down
				sec(AutocompleteId,'inc');
				return;
			}
		}
	}catch(err){}
				
	// key code range 48-57 is keypad number
	// key code range 65-90,96-105 is upper or lower alphabetical character
	// key code range 8-46 is numpad number
	other_unicode = (unicode == 106 || unicode == 223 || unicode == 107 || unicode == 52 || unicode == 189 || unicode == 188 || unicode == 190 || unicode == 16 || unicode == 54 || unicode == 50 || unicode == 192 ||  unicode == 55 || unicode == 16);
	tr_unicode = (unicode == 186 || unicode == 191 || unicode == 219 || unicode == 220 || unicode == 221 || unicode == 222);
	if ((unicode >= 48 && unicode <= 57) || (unicode >= 65 && unicode <= 90) || (unicode >= 96 && unicode <= 105) || unicode == 8 || unicode == 46 || unicode == 32 || tr_unicode || other_unicode){
						
		if (unicode == 8){	//shift delete button		
			if (arrAutocomplete[AutocompleteId]["obj_text_input"].value.toUpperCase()==arrAutocomplete[AutocompleteId]["writingStr"].toUpperCase())
				return;		
			arrAutocomplete[AutocompleteId]["startIndex"] =arrAutocomplete[AutocompleteId]["obj_text_input"].value.length;
		}else if (unicode == 46){ //classical del button
			arrAutocomplete[AutocompleteId]["startIndex"] =arrAutocomplete[AutocompleteId]["obj_text_input"].value.length;
			return;
		}else //other acceptable keys
			arrAutocomplete[AutocompleteId]["startIndex"]++;		
						
		arrAutocomplete[AutocompleteId]["writingStr"] = arrAutocomplete[AutocompleteId]["obj_text_input"].value;
		kontrol_auto = arrAutocomplete[AutocompleteId]["writingStr"];
		dizi=kontrol_auto.split(';',20);
		if (arrAutocomplete[AutocompleteId]["obj_text_input"].value.length>2){
			if(kontrol_auto.indexOf(';',1) != -1){
				document.getElementById(arrAutocomplete[AutocompleteId]["divName"]).style.display='none';
			}
			else
				document.getElementById(arrAutocomplete[AutocompleteId]["divName"]).style.display='block';
			
			arrAutocomplete[AutocompleteId]["preClassName"] = "";
			arrAutocomplete[AutocompleteId]["preSelectedIndex"] = -1;

			if(dizi[1])
			{
				if(dizi[1].length>2)
				{
					document.getElementById(arrAutocomplete[AutocompleteId]["divName"]).style.display='block';					
					AjaxPageLoad('index.cfm?fuseaction=objects.emptypopup_autocomplete&autoComplete=1&mask='+urlencode(dizi[1])+'&'+arrAutocomplete[AutocompleteId]["address"]+"&oldValue="+arrAutocomplete[AutocompleteId]["oldValue"]+"&projectControl="+arrAutocomplete[AutocompleteId]["projectControl"]+"&isNotDeleting="+arrAutocomplete[AutocompleteId]["isNotDeleting"],arrAutocomplete[AutocompleteId]["divName"],1);
				}
			}
			else
			{				
				AjaxPageLoad('index.cfm?fuseaction=objects.emptypopup_autocomplete&autoComplete=1&mask='+urlencode(dizi[0])+'&'+arrAutocomplete[AutocompleteId]["address"]+"&oldValue="+arrAutocomplete[AutocompleteId]["oldValue"]+"&projectControl="+arrAutocomplete[AutocompleteId]["projectControl"]+"&isNotDeleting="+arrAutocomplete[AutocompleteId]["isNotDeleting"],arrAutocomplete[AutocompleteId]["divName"],1);					
			}
/*			AjaxPageLoad('index.cfm?fuseaction=objects.emptypopup_autocomplete&mask='+urlencode(arrAutocomplete[AutocompleteId]["obj_text_input"].value)+'&'+arrAutocomplete[AutocompleteId]["address"],arrAutocomplete[AutocompleteId]["divName"],1);
*/		}
/*		dizi2=kontrol_auto.split(',',20);
		if (arrAutocomplete[AutocompleteId]["obj_text_input"].value.length>2){
			if(kontrol_auto.indexOf(',',1) != -1){
				document.getElementById(arrAutocomplete[AutocompleteId]["divName"]).style.display='none';
			}
			else
				document.getElementById(arrAutocomplete[AutocompleteId]["divName"]).style.display='block';
			
			arrAutocomplete[AutocompleteId]["preClassName"] = "";
			arrAutocomplete[AutocompleteId]["preSelectedIndex"] = -1;
			if(dizi2[1])
			{
				if(dizi2[1].length>2)
				{
					document.getElementById(arrAutocomplete[AutocompleteId]["divName"]).style.display='block';					
					AjaxPageLoad('index.cfm?fuseaction=objects.emptypopup_autocomplete&mask='+urlencode(dizi2[1])+'&'+arrAutocomplete[AutocompleteId]["address"],arrAutocomplete[AutocompleteId]["divName"],1);
				}
			}
			else
			{				
				AjaxPageLoad('index.cfm?fuseaction=objects.emptypopup_autocomplete&mask='+urlencode(dizi2[0])+'&'+arrAutocomplete[AutocompleteId]["address"],arrAutocomplete[AutocompleteId]["divName"],1);					
			}
		}
*/
	}
}
//Sadece ok tuslarinda caalisiyor.
function sec(AutocompleteId,secim){
	//var tmp = document.getElementById(AutocompleteId+'_div_'+js_autocomplete_create_count_);
	var tmp = $("#"+AutocompleteId+'_div_'+js_autocomplete_create_count_);

	var total_len_ = tmp.find('div[class="odd"]').length;
	arrAutocomplete[AutocompleteId]["preSelectedIndex"] = arrAutocomplete[AutocompleteId]["selectedIndex"];
	
	if (secim=='inc'){ //down
		if (arrAutocomplete[AutocompleteId]["selectedIndex"]==tmp.find('div[class="odd"]').length-1)
			arrAutocomplete[AutocompleteId]["selectedIndex"] = 0;
		else
			arrAutocomplete[AutocompleteId]["selectedIndex"]++;
	}else if (secim=='dec'){//up			
		if (arrAutocomplete[AutocompleteId]["selectedIndex"]==0)
			arrAutocomplete[AutocompleteId]["selectedIndex"] = tmp.find('div[class="odd"]').length-1;
		else
			arrAutocomplete[AutocompleteId]["selectedIndex"]--;
	}
	setAtt(AutocompleteId,arrAutocomplete[AutocompleteId]["selectedIndex"],true);
}
	
function setAtt(AutocompleteId,selectedIndex, passiveSelection){
	
	
	if (selectedIndex==-1) selectedIndex = 0;
	//var tmp = document.getElementById(AutocompleteId+'_div_'+js_autocomplete_create_count_).getElementsByTagName('div');
	//var tmp = document.getElementById(AutocompleteId+'_div_'+js_autocomplete_create_count_).getElementsByTagName('div');
	var tmp = $("#"+AutocompleteId+'_div_'+js_autocomplete_create_count_).find('div[class="odd"]');

	console.log ()

	arrAutocomplete[AutocompleteId]["selectedIndex"] = selectedIndex;

	/**
	 * Atama işlemi için bir alan adı yerine bir fonksiyon belirilmiş ise değer fonksiyona dallandırıldı.
	 * Callback mekanizması gereken durumlarda bu yöntem kullanılmalı
	 * 2018-10-18 HY
	 */
	var functionToCheck = arrAutocomplete[AutocompleteId]["obj_value_input"];
	if (functionToCheck && {}.toString.call(functionToCheck) === '[object Function]')
	{
		functionToCheck(tmp[selectedIndex].getElementsByTagName('input')[0].value);
		document.getElementById(arrAutocomplete[AutocompleteId]["divName"]).style.display='none';
		arrAutocomplete[AutocompleteId]["startIndex"] = 0;
	}
	else
	{
		var obj_text_input_arr = arrAutocomplete[AutocompleteId]["obj_value_input"].split(",");	
		if (arrAutocomplete[AutocompleteId]["isCompleteText"]){
			for (var i=0;i<obj_text_input_arr.length;i++)
			{
				//Bir form alanına değişik DB alanlarını düsürmek icin eklendi LS 20120629
				//Eger form alanı bir onceki ile aynıysa icini bosaltma
				if(document.getElementById(obj_text_input_arr[i-1]) != undefined && document.getElementById(obj_text_input_arr[i-1]) == document.getElementById(obj_text_input_arr[i]))
				{
					if(tmp[selectedIndex].getElementsByTagName('input')[i+1].value != "") //bir onceki form alanı mevcut olana esitse ve DB den gelen deger doluysa ata
					{
						document.getElementById(obj_text_input_arr[i]).value = tmp[selectedIndex].getElementsByTagName('input')[i+1].value;	
					}
				}
				else//Eger alanlar birbirinden farklıysa orn:'CONSUMER_ID,EMPLOYEE_ID,PARTNER_ID','consumer_id,employee_id,partner_id'
				{
					var el = $('.odd');
					$('#obj_text_input_arr').eq(i).val(el.find("input").eq(i+1).val()); 
				}
			}
			arrAutocomplete[AutocompleteId]["obj_text_input"].value = tmp[selectedIndex].getElementsByTagName('input')[0].value.split("||")[0].replace(/^\s+|\s+$/g,"").replace(/<.*?>/g,'');
		}
		if (!passiveSelection){
			try{
			for (var i=0;i<obj_text_input_arr.length;i++)
			{
				//Bir form alanına değişik DB alanlarını düsürmek icin eklendi LS 20120629
				//Eger form alanı bir onceki ile aynıysa icini bosaltma orn:'CONSUMER_ID,EMPLOYEE_ID,PARTNER_ID','member_id,member_id,member_id'
				if(document.getElementById(obj_text_input_arr[i-1]) != undefined && document.getElementById(obj_text_input_arr[i-1]) == document.getElementById(obj_text_input_arr[i]))
				{
					if(tmp[selectedIndex].getElementsByTagName('input')[i+1].value!="")
					{					
						document.getElementById(obj_text_input_arr[i]).value = tmp[selectedIndex].getElementsByTagName('input')[i+1].value;	
					}
				}
				else//Eger alanlar birbirinden farklıysa orn:'CONSUMER_ID,EMPLOYEE_ID,PARTNER_ID','consumer_id,employee_id,partner_id'
				{				
					document.getElementById(obj_text_input_arr[i]).value = tmp[selectedIndex].getElementsByTagName('input')[i+1].value;
				}
			}
			}catch(err){}
			
			try{
			var text_degeri_ = arrAutocomplete[AutocompleteId]["obj_text_input"].value;
			if(list_len(text_degeri_,';') == 1)
				{
				arrAutocomplete[AutocompleteId]["obj_text_input"].value = '';
				arrAutocomplete[AutocompleteId]["obj_text_input"].value += tmp[selectedIndex].getElementsByTagName('input')[0].value.split("||")[0].replace(/^\s+|\s+$/g,"").replace(/<.*?>/g,'');
				}
			else
				{
				liste_uzunluk_ = list_len(text_degeri_,';');
				son_deger_ = list_setat(text_degeri_,liste_uzunluk_,'',';');
				arrAutocomplete[AutocompleteId]["obj_text_input"].value = son_deger_ + tmp[selectedIndex].getElementsByTagName('input')[0].value.split("||")[0].replace(/^\s+|\s+$/g,"").replace(/<.*?>/g,'');
				}
	/*		arrAutocomplete[AutocompleteId]["obj_text_input"].value = tmp[selectedIndex].getElementsByTagName('input')[0].value.split("||")[0].replace(/^\s+|\s+$/g,"").replace(/<.*?>/g,'');
	*/		}catch(err){}
			
			document.getElementById(arrAutocomplete[AutocompleteId]["divName"]).style.display='none';
			arrAutocomplete[AutocompleteId]["startIndex"] = 0;
		}
	}
	try
	{	
	arrAutocomplete[AutocompleteId]["preClassName"] = tmp[selectedIndex].className;
	tmp[selectedIndex].className = 'selected';
	tmp[arrAutocomplete[AutocompleteId]["preSelectedIndex"]].className = "";
	}
	catch(err){}
	
	if (arrAutocomplete[AutocompleteId]["isCompleteText"])
		dhtmlXRange(AutocompleteId,arrAutocomplete[AutocompleteId]["startIndex"]+1,arrAutocomplete[AutocompleteId]["obj_text_input"].value.length);
	
	arrAutocomplete[AutocompleteId]["preSelectedIndex"] = selectedIndex;
	//arrAutocomplete[AutocompleteId]["obj_text_input"].focus();

	try{
		if(arrAutocomplete[AutocompleteId]["dropdown"].css('display')!='none')
			var control_auto = 1;
		eval(arrAutocomplete[AutocompleteId]["call_function"]);
	}catch(err){}
}


// MAİL SİSTEMLERİ İÇİN EKLEMELİ AUTOCOMPLETE



// MAİL SİSTEMLERİ İİ

function dhtmlXRange(AutocompleteId,Start, End){
	var Input = arrAutocomplete[AutocompleteId]["obj_text_input"];
	try{
		Input.focus();
	}catch(e){};
		
	var Length = Input.value.length;
	Start--;
	if (Start < 0 || Start > End || Start > Length)Start = 0;
	if (End > Length)End = Length;
	if (Start==End)return;
	if (Input.setSelectionRange){
		Input.setSelectionRange(Start, End);
	}else if (Input.createTextRange){ // IE
		var range = Input.createTextRange();
		range.moveStart('character', Start);
		range.moveEnd('character', End-Length);
		try{
			range.select();
		}catch(e){}
	}
}

function AutoComplete_GetLeft(element)
{
	var curNode = element;
	var left    = 0;
	do
	{
		if(curNode.tagName.toLowerCase() != 'div')//div ise kaymalara sebebe oluyor
			left += curNode.offsetLeft;
		curNode = curNode.offsetParent;
	}
	while(curNode.tagName.toLowerCase() != 'body' && curNode.tagName.toLowerCase() != 'html');
	left = left - 1;
	return left;
}

function urlencode (str) {
	str = (str+'').toString();
	return encodeURIComponent(str).replace(/!/g, '%21').replace(/'/g, '%27').replace(/\(/g, '%28').replace(/\)/g, '%29').replace(/\*/g, '%2A').replace(/%20/g, '+');
}


/*
---------------------------------
---------------------------------
---------------------------------
---------------------------------
---------------------------------
---------------------------------
---------------------------------
---------------------------------
---------------------------------
---------------------------------
---------------------------------
---------------------------------
---------------------------------
---------------------------------
---------------------------------
---------------------------------
---------------------------------
*/


function getFindingMail(AutocompleteId){
	var obj_input = arrAutocomplete[AutocompleteId]["obj_text_input"];
	var start = getLastSeperatorIndex(AutocompleteId);
	var len = obj_input.value.length;
	
	if (start!=-1)
		return obj_input.value.substring(start+1,len);
	else
		return obj_input.value;
}

function getLastSeperatorIndex(AutocompleteId){
	var obj_input = arrAutocomplete[AutocompleteId]["obj_text_input"];
	return obj_input.value.lastIndexOf(",");
}

function selectBeforeDelete(AutocompleteId){
	var obj_input = arrAutocomplete[AutocompleteId]["obj_text_input"];
	var lastIndex = getLastSeperatorIndex(AutocompleteId);
	var beforeLastIndex = obj_input.value.lastIndexOf(",",lastIndex);
}

function AutoComplete_GetTop(element)
{
	var curNode = element;
	var top  = 0;
	var kontrol   = 0;
	var bos   = 0;
	do
	{
		if(curNode.tagName.toLowerCase() != 'div')//div ise kaymalara sebebe oluyor
			top += curNode.offsetTop;
		else if(curNode.offsetParent.tagName.toLowerCase() == 'div')
			top += curNode.offsetTop;
		curNode = curNode.offsetParent;
	}
	while(curNode.tagName.toLowerCase() != 'body' && curNode.tagName.toLowerCase() != 'html');
	//top = top + 25; //GA, BK nin isteğiyle kaldırdı. objects2 de üye eklemede bu ekleme sorun yaratıyor.
	return top;
}


function AutoComplete_Create2(AutocompleteId,findfield_wrk,visible_field_wrk,query_wrk,extra_params,datafield_wrk,formfield_wrk,a1,a2,a3,isCompleteText,isCompleteText2){
	var obj_text_input = document.getElementById(AutocompleteId);
	obj_text_input.setAttribute("autocomplete","off");
	js_autocomplete_create_count_ = js_autocomplete_create_count_ + 1;
	var dropdown = document.createElement('div');
	dropdown.id = AutocompleteId+'_div_'+js_autocomplete_create_count_;
	dropdown.name = AutocompleteId+'_div_'+js_autocomplete_create_count_;
	dropdown.style.position = 'absolute';
	dropdown.style.top = AutoComplete_GetTop(obj_text_input) + obj_text_input.offsetHeight + 'px';
	dropdown.style.left = AutoComplete_GetLeft(obj_text_input) + 'px';
	//dropdown.style.marginLeft = '0px';
	//dropdown.style.marginTop = '0px';
	dropdown.style.width = 'auto';
	dropdown.style.maxHeight = '150px';
	dropdown.style.overflow = 'auto';
	dropdown.style.zIndex = '999998';
	dropdown.style.display = 'none';
	dropdown.className = "completeListbox";
	dropdown.style.filter="progid:DXImageTransform.Microsoft.Shadow(color='gray', Direction=135, Strength=4)";
	obj_text_input.parentNode.insertBefore(dropdown,obj_text_input.nextSibling);
	
	arrAutocomplete[AutocompleteId] = new Array();
	arrAutocomplete[AutocompleteId]["dropdown"] = dropdown;
	arrAutocomplete[AutocompleteId]["obj_text_input"] = obj_text_input;
	arrAutocomplete[AutocompleteId]["obj_value_input"] = formfield_wrk;	
	arrAutocomplete[AutocompleteId]["column_visible"] = visible_field_wrk;	
	arrAutocomplete[AutocompleteId]["column_value"] = datafield_wrk;
	arrAutocomplete[AutocompleteId]["column_text"] = findfield_wrk;	
	
	arrAutocomplete[AutocompleteId]["query"] = query_wrk;
	arrAutocomplete[AutocompleteId]["name"] = null;

	arrAutocomplete[AutocompleteId]["str"] = obj_text_input.value;
	if (extra_params!="") //for maxrow, always must be first parameters of queries
		extra_params = '50,'+escape(extra_params);
	else
		extra_params = '50';
	arrAutocomplete[AutocompleteId]["extra_params"] = extra_params;
	arrAutocomplete[AutocompleteId]["address"] = 'AutocompleteId='+AutocompleteId+'&query='+query_wrk+'&column_visible='+visible_field_wrk+'&column_text='+findfield_wrk+'&column_value='+datafield_wrk+'&divName='+AutocompleteId+'_div_'+js_autocomplete_create_count_+'&extra_params='+extra_params;

	arrAutocomplete[AutocompleteId]["divName"] =  AutocompleteId+'_div_'+js_autocomplete_create_count_;
	
	arrAutocomplete[AutocompleteId]["startIndex"] = 0;
	arrAutocomplete[AutocompleteId]["selectedIndex"] = -1;
	
	arrAutocomplete[AutocompleteId]["preSelectedIndex"] = -1;
	arrAutocomplete[AutocompleteId]["preClassName"] = "";
	
	arrAutocomplete[AutocompleteId]["writingStr"] = "";
	
	if (isCompleteText == true){ // for call_function
		arrAutocomplete[AutocompleteId]["isCompleteText"] = isCompleteText;
		arrAutocomplete[AutocompleteId]["call_function"] = isCompleteText2;
	}
	else
	{
		arrAutocomplete[AutocompleteId]["isCompleteText"] = isCompleteText2;
		arrAutocomplete[AutocompleteId]["call_function"] = isCompleteText;
	}
	
		obj_text_input.onkeydown = function (e)
		{		
			var evtobj=window.event? event : e //distinguish between IE's explicit event object (window.event) and Firefox's implicit.
			var unicode=evtobj.charCode? evtobj.charCode : evtobj.keyCode
			if (unicode==13)
			{
				if (arrAutocomplete[AutocompleteId]["obj_text_input"].value.length<3 || arrAutocomplete[AutocompleteId]["dropdown"].style.display=='none')
					return true;
				//sec(AutocompleteId,arrAutocomplete[AutocompleteId]["selectedIndex"]);
				return false;
			}
		}		
	
	obj_text_input.onkeyup = function (e){
		secim(AutocompleteId,e,'1',obj_text_input);
	}	

	obj_text_input.onblur = function(e)
	{
		try{
			if(arrAutocomplete[AutocompleteId]["dropdown"].style.display!='none')
				var control_auto = 1;
			eval(arrAutocomplete[AutocompleteId]["call_function"]);
		}catch(err){}
		//arrAutocomplete[AutocompleteId]["dropdown"].parentNode.removeChild(arrAutocomplete[AutocompleteId]["dropdown"]);
	}

	
}

function reloadOldValue(AutocompleteId,oldValue)
{
	$("#"+AutocompleteId).val(oldValue);	
}