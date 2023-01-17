//sadece pda tarafında kullanılan js ler içindir.
function gizle(id)
{
	id.style.display = 'none';
	//document.getElementById(id).style.display = 'none';
}

function goster(id)
{
	id.style.display = '';
	//document.getElementById(id).style.display = '';
}

function gizle_goster(id)
{
	if(id.style.display=='')
	{
		id.style.display='none';
	} else {
		id.style.display='';
	}
}

function list_len(gelen,delim)
{
	if(!delim) delim = ',';
	if(gelen.length == 0)
		return 0;
	else
		return gelen.split(delim).length;
}

function ajax_request_script(html)
{
	var hd = document.getElementsByTagName("head")[0];
	var re = /(?:<script([^>]*)?>)((\n|\r|.)*?)(?:<\/script>)/ig;
	var srcRe = /\ssrc=([\'\"])(.*?)\1/i;
	var typeRe = /\stype=([\'\"])(.*?)\1/i;
	var match;
	while(match = re.exec(html))
	{
		var attrs = match[1];
		var srcMatch = attrs ? attrs.match(srcRe) : false;
		var textToEval = "";
		if(srcMatch && srcMatch[2])
		{
			//<SCRIPT SRC="..."> şeklinde ayarlanan external Javascript'leri sayfaya ekle
			var s = document.createElement("script");
			s.src = srcMatch[2];
			var typeMatch = attrs.match(typeRe);
			if(typeMatch && typeMatch[2]){
			s.type = typeMatch[2];
			}
			hd.appendChild(s);
		}
		else if(match[2] && match[2].length > 0)
		{
			/*
			<script type="text/javascript">...</SCRIPT> şeklinde yazılmış Javascript kodlarını sayfaya ekle (eval et)
			ColdFusion <CFFORM> etiketleri, karmaşık Javascript kodları oluşturur.
			Bu kodlardaki HTML comment expression'ları IE'de eval error'una neden olur.
			Bu sorunu aşmak için work around.
			*/
			textToEval = match[2].replace("<!--", "").replace("-->", "").replace("//-->", "");
			if(window.execScript)
				window.execScript(textToEval);
			else
				window.eval(textToEval);
		}
	}
	//<script type="text/javascript"> etiketlerini HTML'den kaldır. Yeni HTML'i geri döndür
	return html.replace(/(?:<script.*?>)((\n|\r|.)*?)(?:<\/script>)/ig, "");
}

/*
AJAX XHR nesnesi döndürür. Tarayıcı AJAX desteklemiyorsa,
kullanıcıya hata mesajı gösterir. Geriye olumsuz bir değer döndürür.
*/

function GetAjaxConnector()
{
// Kullanım: myAjaxConnector = GetAjaxConnector();
    var xmlHttp=null;
    try
	{
        // Firefox, Opera 8.0+, Safari
        xmlHttp=new XMLHttpRequest();
    }
	catch (e)
	{
        // Internet Explorer
        try
		{
            xmlHttp=new ActiveXObject('Msxml2.XMLHTTP');
        }
		catch (e)
		{
            xmlHttp=new ActiveXObject('Microsoft.XMLHTTP');
        }
    }
	if (xmlHttp==null)
	{
		alert ('Tarayıcınız Ajax Desteklemiyor!');
		return;
    }
    return xmlHttp;
}

/* pop upları sayfanın tam ortasında açar... pencere boyutları önceden belirleniyor..*/
function windowopen(theURL,winSize) { /*v3.0*/
//fonsiyon 3 parametrede alabiliyor 3. parametre de isim yollana bilir ozaman aynı pencere tekrar acilmaz
	if (winSize == 'page') 					{ myWidth=750 ; myHeight=500 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
	else if (winSize == 'print_page') 		{ myWidth=750 ; myHeight=500 ; features = 'scrollbars=0, resizable=1, menubar=1' ; }
	else if (winSize == 'list') 			{ myWidth=700 ; myHeight=555 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
	else if (winSize == 'medium') 			{ myWidth=600 ; myHeight=470 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
	else if (winSize == 'small') 			{ myWidth=500 ; myHeight=350 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
	else if (winSize == 'date') 			{ myWidth=275 ; myHeight=190 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
	else if (winSize == 'project') 			{ myWidth=800 ; myHeight=620 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
	else if (winSize == 'large') 			{ myWidth=615 ; myHeight=550 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
	else if (winSize == 'horizantal') 		{ myWidth=1600 ; myHeight=300 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
	else if (winSize == 'list_horizantal')	{ myWidth=1100 ; myHeight=400 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
	else if (winSize == 'wide') 			{ myWidth=980 ; myHeight=600 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
	else if (winSize == 'wide2') 			{ myWidth=1100 ; myHeight=600 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
	else if (winSize == 'longpage') 		{ myWidth=1200 ; myHeight=500 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
	else if (winSize == 'page_horizantal') 	{ myWidth=800 ; myHeight=500 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
	else if (winSize == 'video') 			{ myWidth=480 ; myHeight=420 ; features = 'scrollbars=0, resizable=0, menubar=0' ; }
	else if (winSize == 'online_contact') 	{ myWidth=600 ; myHeight=500 ; features = 'scrollbars=0, resizable=0, menubar=0' ; } 
	else if (winSize == 'wwide') 			{ myWidth=1600 ; myHeight=860 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }  
	else if (winSize == 'long_menu') 		{ myWidth=200 ; myHeight=500 ; features = 'scrollbars=0, resizable=0' ; }
	else if (winSize == 'adminTv') 			{ myWidth=1040 ; myHeight=870 ; features = 'scrollbars=1, resizable=1, menubar=0' ; }
	else if (winSize == 'userTv') 			{ myWidth=565 ; myHeight=487 ; features = 'scrollbars=0, resizable=0, menubar=0' ; }
    else if (winSize == 'video_conference')	{ myWidth=740 ; myHeight=610 ; features = 'scrollbars=0, resizable=0, menubar=0' ; }
    else if (winSize == 'white_board')		{ myWidth=1000 ; myHeight=730 ; features = 'scrollbars=0, resizable=1, menubar=0' ; }
 	else if (winSize == 'wwide1') 			{ myWidth=1200 ; myHeight=700 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
	else { myWidth=400 ; myHeight=400 ; features = 'scrollbars=0, resizable=0' ; }

	if(window.screen)
	{
		var myLeft = (screen.width-myWidth)/2;
		var myTop =  (screen.height-myHeight)/2;
		
		features+=(features!='')?',':''; 
		features+=',left='+myLeft+',top='+myTop; 
	}
  	if (arguments[2]==null)
		window.open(theURL,'',features+((features!='')?',':'')+'width='+myWidth+',height='+myHeight); 
	else		
		window.open(theURL,arguments[2],features+((features!='')?',':'')+'width='+myWidth+',height='+myHeight); 
}

function GetFormData(form)
{
	var args = [];
	for (var i=0; i< form.elements.length; i++)
	{      
		if (!form.elements[i].name) continue;
		if (form.elements[i].tagname = 'input' && (form.elements[i].type == 'checkbox' || form.elements[i].type == 'radio') && !form.elements[i].checked) continue;
		
		if (form.elements[i].tagname = 'select' && form.elements[i].multiple)
		{
			for (j=0; j< form.elements[i].options.length; j++) 
			{
				if (form.elements[i].options[j].selected) 
					args.push(form.elements[i].name + "=" + encodeURIComponent(form.elements[i].options[j].value));
			}
		} 
		else 
			args.push(form.elements[i].name + "=" + encodeURIComponent(form.elements[i].value));
	}
	return args.join("&");
}

function AjaxRequest(ajaxConnector,url,method,data,callback)
{
	if (ajaxConnector!=null)
	{
		if(url.substr(0,4) == 'http')
			ajaxConnector.open(method,url+'&ajax=1&'+data, true);
		else
			ajaxConnector.open(method,'/'+url+'&ajax=1&'+data, true);
		ajaxConnector.setRequestHeader('If-Modified-Since', 'Sat, 1 Jan 2000 00:00:00 GMT');
		ajaxConnector.setRequestHeader('Content-Type','application/x-www-form-urlencoded; charset=utf-8');
		if (data != null)
		{
			ajaxConnector.setRequestHeader('Content-length', data.length);//alert(data)//form ile gelen değerleri görmek için alert'i açın eksik değer varmı kontrol edebilirsiniz.;
		}
		/*
		Bu satır önemlidir. Zira, ColdFusion is_ajax_requesy() fonksiyonu, gelen bu request'i inceler.
		Aşağıdaki header sayesinde, request'in bir ajax request olduğuna karar verir
		*/
		ajaxConnector.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
		ajaxConnector.onreadystatechange=callback;
		ajaxConnector.send(data);
		return true;
	}
	return false;
}

var deger_ = 0;
var loader_div_message_ = "Yükleniyor..";
function AjaxPageLoad(url,target,error_detail,loader_message,li_id)
{
	function ajax_tab(li_id)
	{
		var ullist=li_id.parentNode.getElementsByTagName("li");//gelen li nin üstü olan ul nin içinde olan li lerin listesi
		for (var i=0; i < ullist.length; i++) //ul içindeki lileri döndürüyoruz
		{
			if(li_id.id == ullist[i].id)//eğer tıklanan  li_id ise classını değiştiriyoruz.
				ullist[i].className="selected";
			else//degilse classını boşaltıyoruz.
				ullist[i].className=""
		}
	}
	function set_html(target,html)
	{
		deger_ = deger_ + 1;
		//object gönderilmişse, AJAX windowa content yüklenecek demektir.
		if(typeof(target) == 'object')
		{
			target.setBody(html);
			target.render();
			target.center();
		//IDsi gönderilen elemente yüklenecek demektir
		}
		else 
		{
			try
			{
				document.getElementById(target).innerHTML = html;
			}
			catch(err)
			{
				return false;
			}
		}
	}
	var ajaxConn=GetAjaxConnector();		
	var url_len=list_len(url,'=');
	if(url_len > 3)
	{
		new_url = list_getat(url,1,'&');
		for(u_l=2;u_l<=url_len;u_l++)
		{
			var new_variable = list_getat(list_getat(url,u_l,'&'),1,'=');
			var new_value = encodeURIComponent(list_getat(list_getat(url,u_l,'&'),2,'='));
			new_url+='&'+new_variable+'='+new_value;
		}
	}
	else
	{
		new_url = url;
	}
	var request=AjaxRequest(ajaxConn,new_url,"get", null, function()
	{
		if ((ajaxConn.readyState==4 && ajaxConn.status == 200))
		{
			if(li_id)//li id gönderilmiş ise
				ajax_tab(li_id);
			set_html(target, ajaxConn.responseText);
			ajax_request_script(ajaxConn.responseText);
		}
		else if (ajaxConn.readyState==4)
		{
			if (error_detail == true)
			{
				set_html(target, ajaxConn.responseText);
			}
			else
			{
				set_html(target, "<strong style='color:red'>WorkCube Hata! Sistem yöneticisine başvurun.</strong>");
			}
		}
	});
	if(request)
	{
		if(loader_message == undefined) loader_message = loader_div_message_;
			set_html(target,"<div id='divPageLoad' style='background:url(/images/loading.gif) no-repeat; padding:3px; text-align:left; font-weight:bold; color:F66633;'>&nbsp;&nbsp;"+loader_message+"</div>");
		return true;
	}
	else
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
	if(parseFloat(str) < 0) negatif_flag = 1;str = str.replace('-','');
	if (str.indexOf(',')>0)/*sadece YTL gecisi icin gecici olarak calisiyor, silinmeli*/
	{
		alert('commaSplit e verilen '+str+' degeri'+' float a cevrilerek verilmelidir.\r -filterNum() ve f2() konbinasyonları kullanılabilir-\rYine de değeriniz düzeltildi (HS)');
		str = filterNum(f2(filterNum(str)));
	}
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

function filterNum(str,no_of_decimal) 
{
	/*form submit edilmeden önce float veya integer alanların temizliği için*/
	if (str.length == 0) return '';
	if(!no_of_decimal && no_of_decimal!=0) no_of_decimal=2;
	strCheck = '-0123456789,';
	newStr = '';
	for(var i=0; i < str.length; i++) if (strCheck.indexOf(str.charAt(i)) != -1) newStr += str.charAt(i);/*i=0 ifadesi var i=0 oldu.*/
	newStr = newStr.replace(',', '.');
	while(newStr.indexOf(',') > 0) newStr = newStr.replace(',','');
	return wrk_round(newStr,no_of_decimal);
}

/* checkbox action fonksiyonu*/
function wrk_select_all(main_checkbox,row_checkbox)
{
	var check_len = document.getElementsByName(row_checkbox).length;
	for(var cl_ind=0; cl_ind < check_len; cl_ind++)
	{
		if(document.getElementsByName(row_checkbox)[cl_ind].disabled != true)
			document.getElementsByName(row_checkbox)[cl_ind].checked = (document.getElementById(main_checkbox).checked)?true:false;
	}
}

function wrk_round(ValToRnd, no_of_decimal){
	/*Aldigi degerler matematik deger olmalidir.
	Bunun sonucunu ekranda gormek icin cogu zaman commaSplit e vermek yeterlidir*/
	if(!no_of_decimal && no_of_decimal!=0) no_of_decimal=2;
	/* ValToRnd= filterNum(ValToRnd); */
	decimal_carpan = Math.pow(10,no_of_decimal);
	if(ValToRnd!=0) return (Math.round(ValToRnd*decimal_carpan)/decimal_carpan);
	else return 0;
	/*return f2(ValToRnd);*/
}

function FormatCurrency(fld,e) 
{
	return formatcurrency(fld,e);
}
function formatcurrency(fld,e,no_of_decimal) 
{
	if(!e) return false;
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
			{
			fld.value = commaSplit(filterNum(fld.value,no_of_decimal),no_of_decimal);
			}
		}
	else
		fld.value = commaSplit(filterNum(fld.value),0);
	return false;
}

function trim(inputString)
{
  /*Removes leading and trailing spaces from the passed string. Also removes
     consecutive spaces and replaces it with one space. If something besides
     a string is passed in (null, custom object, etc.) then return the input.*/
   if (typeof inputString != "string") { return inputString; }
   var retValue = inputString;
   var ch = retValue.substring(0, 1);
   while (ch == " ")
   { /*Check for spaces at the beginning of the string*/
      retValue = retValue.substring(1, retValue.length);
      ch = retValue.substring(0, 1);
   }
   ch = retValue.substring(retValue.length-1, retValue.length);
   while (ch == " ")
   { /*Check for spaces at the end of the string*/
      retValue = retValue.substring(0, retValue.length-1);
      ch = retValue.substring(retValue.length-1, retValue.length);
   }
   while (retValue.indexOf("  ") != -1)
   { /*Note that there are two spaces in the string - look for multiple spaces within the string*/
      retValue = retValue.substring(0, retValue.indexOf("  ")) + retValue.substring(retValue.indexOf("  ")+1, retValue.length); /*Again, there are two spaces in each of the strings*/
   }
   return retValue; /*Return the trimmed string back to the user*/
}

function list_find(listem,degerim,delim)
{ 
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

function list_getat(gelen,number,delim)
{
	if(!delim) delim = ',';
	gelen_1=gelen.split(delim);
	if((gelen.length == 0) || (number > gelen_1.length) || (number < 1))
		return '';
	else
		return gelen_1[number-1];
}

function wrk_query(str_query,data_source,maxrows)
{
	/*
	by  Workcube
	Created 20060315
	Modified 20060324
	Usage:
		my_query = query('SELECT COL1,COL2 FROM TABLE1 WHERE COL2=1');
		veya
		my_query = query('SELECT COL1,COL2 FROM TABLE1 WHERE COL2=1','dsn2');
		veya
		my_query = query('SELECT COL1,COL2 FROM TABLE1 WHERE COL2=1 ORDER BY COL2 DESC','dsn2',1);
		ifadesi ile my_query degiskeni cfquery ile donen sonucun tamamen aynisi bir javascript query degeri alir
		data_source : optional , default olarak 'dsn' kullaniliyor
		maxrows : optional , default olarak 0 ataniyor, 0 olunca query sonucundaki tum kayitlar gelir
	*/
	var new_query=new Object();
	var req;
	if(!data_source) data_source='dsn';
	if(!maxrows) maxrows=0;
	function callpage(url) {
		req = false;
		if(window.XMLHttpRequest)
			try
				{req = new XMLHttpRequest();}
			catch(e)
				{req = false;}
		else if(window.ActiveXObject)
			try {req = new ActiveXObject("Msxml2.XMLHTTP");}/*burasi*/
			catch(e)
				{
				try {req = new ActiveXObject("Microsoft.XMLHTTP");}
				catch(e)
					{req = false;}
				}
		if(req)
			{
			req.onreadystatechange = function ()
				{
				if (req.readyState == 4 && req.status == 200)
					try
						{
							eval(req.responseText);
							new_query = get_js_query;/*alert('Cevap:\n\n'+req.responseText);*/}
					catch(e)
						{new_query = false;/*20060619 alert('DB Sorgunuz ile ilgili problem olustu!\n\nDsn: '+data_source+'\n\nmaxrows: '+maxrows+'\n\nSorgu: '+str_query);new_query = false;*/}
				}
			req.open("post", url+'&xmlhttp=1', false);
			req.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
			req.setRequestHeader('pragma','nocache');
			req.send('str_sql='+encodeURI(str_query)+'&data_source='+data_source+'&maxrows='+maxrows);
			}
		
	}
	callpage('/index.cfm?fuseaction=objects2.emptypopup_get_js_query');
	//alert(new_query);
	return new_query;
}


function isNumber(nesne) 
{
	var inputStr=nesne.value;
	if(inputStr.length>0)
	{
		for(var i=0;i<inputStr.length;i++)
		{
			var oneChar = inputStr.substring(i,i+1);
			if (oneChar < "0" || oneChar > "9") 
			{
				nesne.value=inputStr.substring(0,i);
				return false;
			}
		}
	}
}

function ismaxlength(obj){
var mlength=obj.getAttribute? parseInt(obj.getAttribute("maxlength")) : "";
if (obj.getAttribute && obj.value.length>mlength)
	{
	if(obj.getAttribute("message"))
		{
		obj.value=obj.value.substring(0,mlength);
		alert(obj.getAttribute("message"));
		}
	else
		{
		obj.value=obj.value.substring(0,mlength);
		}
	}
}

function fix_date(field,name)
{
	/* 
	 parametre 1 : form_name.field_name
	 parametre 2 : alan adı
	 Verilen alanın boş değil ise en az 8 karakter içermesini kontrol eder
	 alan eğer 1/1/2002 ise bunu 01/01/2002 yapar 
	 alan eğer 1.1.2002 ise bunu 01.01.2002 yapar 
	*/
	if ( (field.value.length > 0) && (field.value.length < 8) )
		{
		alert(name + ' alanını kontrol ediniz !');
		return false;
		}		
	if (field.value.length >= 8)
		{
		if (field.value.indexOf('.') != -1)
			{
			/*liste '.' ile oluşturulmuş*/
			if (field.value.indexOf('.') == 1)
				field.value = '0' + field.value;
			if (field.value.lastIndexOf('.') == 3)
				field.value = field.value.substr(0,3) + '01' + field.value.substr(3,5);
			if (field.value.lastIndexOf('.') == 4)
				field.value = field.value.substr(0,3) + '0' + field.value.substr(3,6);
			}
		else if (field.value.indexOf('/') != -1)
			{
			/*liste '/' ile oluşturulmuş*/
			if (field.value.indexOf('/') == 1)
				field.value = '0' + field.value;
			if (field.value.lastIndexOf('/') == 3)
				field.value = field.value.substr(0,3) + '01' + field.value.substr(3,5);
			if (field.value.lastIndexOf('/') == 4)
				field.value = field.value.substr(0,3) + '0' + field.value.substr(3,6);
			}
		else
			{
			alert(name + ' alanını kontrol ediniz ! ' + field.value.length + '');
			return false;
			}
		}
	if ((field.value.length > 0) && (field.value.length < 10))
		{
		alert(name + ' alanını kontrol ediniz ! ' + field.value.length + '');
		return false;
		}
	return true;	
}

function time_check(tarih1, saat1, dakika1, tarih2, saat2, dakika2, msg)
{
	/* 
	tarih1 ===> document.assetp_reserve.startdate gibi bir form alanı olmalı
	tarih2 ===> document.assetp_reserve.finishdate gibi bir form alanı olmalı
	saat1 ===> document.assetp_reserve.starttime gibi bir form alanı olmalı
	saat2 ===> document.assetp_reserve.finishtime gibi bir form alanı olmalı
	tarih1 > tarih2 kontrol edilir
	msg hata durumunda alert edilecek mesaj
	*/
	f = true;	
	f = ( fix_date(tarih1,tarih1.name) && fix_date(tarih2,tarih2.name) );	
		
	tarih1_ = tarih1.value.substr(6,4) + tarih1.value.substr(3,2) + tarih1.value.substr(0,2);
	tarih2_ = tarih2.value.substr(6,4) + tarih2.value.substr(3,2) + tarih2.value.substr(0,2);

	if (saat1.value.length < 2) saat1_ = '0' + saat1.value; else saat1_ = saat1.value;
	if (dakika1.value.length < 2) dakika1_ = '0' + dakika1.value; else dakika1_ = dakika1.value;
	if (saat2.value.length < 2) saat2_ = '0' + saat2.value; else saat2_ = saat2.value;
	if (dakika2.value.length < 2) dakika2_ = '0' + dakika2.value; else dakika2_ = dakika2.value;

	tarih1_ = tarih1_ + saat1_ + dakika1_;
	tarih2_ = tarih2_ + saat2_ + dakika2_;	
	
	if (tarih1_ >= tarih2_) 
		{
		alert(msg);
		tarih1.focus();
		return false;
		}
	else
		{				
		return f;
		}
}

function date_check(tarih1, tarih2, msg, is_equal)
{
	/* 
	tarih1 ===> document.assetp_reserve.startdate gibi bir form alanı olmalı
	tarih2 ===> document.assetp_reserve.finishdate gibi bir form alanı olmalı
	msg ===> hata durumunda alert edilecek mesaj
	is_equal ===> 1 olursa esitlik kontrolu de yapilir.
	tarih1 > tarih2  veya tarih1 = tarih2 kontrol edilir
	*/
	fix_date(tarih1,tarih1.name);
	fix_date(tarih2,tarih2.name);
	if(is_equal == undefined)
		is_equal = 0;
	tarih1_ = tarih1.value.substr(6,4) + tarih1.value.substr(3,2) + tarih1.value.substr(0,2);
	tarih2_ = tarih2.value.substr(6,4) + tarih2.value.substr(3,2) + tarih2.value.substr(0,2);
	
	if (tarih1_ > tarih2_ || (is_equal == 1 && tarih1_ == tarih2_)) 
	{
		if (msg != '')
		{
			alert(msg);
			tarih1.focus();
		}
		else
		{
			alert('Hata Mesajı Ayarlanmamış !');
			tarih1.focus();
		}
		return false;
	}
	else
		return true;
}

function AjaxFormSubmit(formName,messageBoxId,showError,watingMessage,successMessage,load_url,load_div,load_script) 
{  
	var form;
	if (formName.split) {
		form=document.forms[formName];
	} else {
		form=formName;
	}
	//form.submit(); // Eğer ajax işlemi düzgün çalışmıyorsa action sayfasındaki hatayı görebilmek için form'u normal şekilde submit edin (yani bu kısmı açın)
	var ajaxConn=GetAjaxConnector();
	var messageBox=document.getElementById(messageBoxId);
	var request=AjaxRequest(ajaxConn, form.action, form.method, GetFormData(form), function() {
	if (ajaxConn.readyState==4 && ajaxConn.status == 200) {
		if(load_script)
			messageBox.innerHTML =ajax_request_script(ajaxConn.responseText);
		if (!successMessage) {successMessage="<strong style='color:black'>Kaydedildi!</strong>";}
		messageBox.innerHTML ="<strong style='color:black'>"+ successMessage + "</strong>";
		if(load_url && load_div)//eğer 2.ci div çalıştırılmak isteniyorsa
			AjaxPageLoad(load_url,load_div);
	} 
	else if (ajaxConn.readyState==4) {
		if (showError && showError==true) {
			messageBox.innerHTML=ajaxConn.responseText;
		} else {
			messageBox.innerHTML = "<strong style='color:red'>WorkCube Hata! Sistem yöneticisine başvurun.</strong>";
		}
	}
});
	if(request) {
		if (!watingMessage) {watingMessage="<strong style='color:black'>Kaydediliyor...</strong>";}
		messageBox.innerHTML ="<strong style='color:black'>"+ watingMessage + "</strong>";
		return true;
	} else {
		return false;
	}
}
function GetFormData(form) {
	var args = [];
	for (var i=0; i<form.elements.length; i++) {
		if (!form.elements[i].name) continue;
		if (form.elements[i].tagname = 'input' && (form.elements[i].type == 'checkbox' || form.elements[i].type == 'radio') && !form.elements[i].checked) continue;
		
		if (form.elements[i].tagname = 'select' && form.elements[i].multiple) {
			for (j=0; j<form.elements[i].options.length; j++) {
				if (form.elements[i].options[j].selected) args.push(form.elements[i].name + "=" + encodeURIComponent(form.elements[i].options[j].value));
			}
		} else {
			args.push(form.elements[i].name + "=" + encodeURIComponent(form.elements[i].value));
		}
	}
	return args.join("&");
}
function workdata(qry,prmt,maxrows)
{
	var new_query=new Object();
	var req;
	if(!qry) return false;
	if(prmt == undefined) prmt='';
	if(maxrows == undefined) maxrows='';
	function callpage(url)
	{
		req = false;
		if(window.XMLHttpRequest)
			try
			{
				req = new XMLHttpRequest();
			}
			catch(e)
			{
				req = false;
			}
		else if(window.ActiveXObject)
			try {req = new ActiveXObject("Msxml2.XMLHTTP");}
			catch(e)
			{
				try{
					req = new ActiveXObject("Microsoft.XMLHTTP");
				}
				catch(e)
				{
					req = false;
				}
		}
		if(req)
		{
			req.onreadystatechange = function ()
			{
			if (req.readyState == 4 && req.status == 200)
				try
				{	//alert(req.responseText);
					eval(req.responseText);
					new_query = get_js_query;
				}
				catch(e)
				{
					new_query = false;
				}
			}
			req.open("post", url, false);//+'&xmlhttp=1'
			req.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
			req.setRequestHeader('pragma','nocache');
			var extra_params='';//gelen parametrelerin sınırsız olabilmesi için
			var prm_count=0;
			for(var prms_i=3; prms_i < workdata.arguments.length;prms_i++)
			{
				if(workdata.arguments[prms_i]!=undefined)
				{
					prm_count++;
					if(prm_count==1)
						param_name='extra';
					else
						param_name='extra'+prm_count;
					extra_params=extra_params+'&'+param_name+'='+encodeURI(workdata.arguments[prms_i]);
				}
			}
			req.send('qry='+qry+'&prmt='+encodeURI(prmt)+'&maxrows='+maxrows+extra_params);
		}
	}
	callpage('index.cfm?fuseaction=objects2.emptypopup_get_workdata');//index.cfm?fuseaction=objects2.emptypopup_get_js_query2   http://ep.workcube/objects/query/get_js_query2.cfm
	return new_query;
}
function get_turkish_letters_div(input_name,div_name)
{
	div_id = eval(div_name);
	goster(div_id);
	AjaxPageLoad('index.cfm?fuseaction=pda.emptypopup_list_turkish_letters_div&input_name='+ input_name +'&div_name='+div_name ,div_name);		
	return false;
}

function wrk_safe_query(str_code,data_source,maxrows,ext_params)
{
	var new_query=new Object();
	if(!data_source) data_source='dsn';
	if(!maxrows) maxrows=0;
	if(!ext_params) ext_params='';
		function callpage(url) 
			{
			var new_url = url;
			var myAjaxConnector=GetAjaxConnector();
			if(myAjaxConnector)
				{
					data = 'str_code='+str_code+'&data_source='+data_source+'&maxrows='+maxrows+'&ext_params='+encodeURI(ext_params);
						function return_function_()
						{
						if (myAjaxConnector.readyState == 4 && myAjaxConnector.status == 200)
							{
								try
									{
										eval(myAjaxConnector.responseText);
										new_query = get_js_query;
									}
								catch(e)
									{new_query = false;}
							}
						}
						myAjaxConnector.open("post",url+'&xmlhttp=1', false);
						myAjaxConnector.setRequestHeader('If-Modified-Since', 'Sat, 1 Jan 2000 00:00:00 GMT');
						myAjaxConnector.setRequestHeader('Content-Type','application/x-www-form-urlencoded; charset=utf-8');
						myAjaxConnector.setRequestHeader('Content-length',data.length);
						myAjaxConnector.setRequestHeader('Connection', 'close');
						myAjaxConnector.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
						//myAjaxConnector.onreadystatechange=aaa;
						myAjaxConnector.send(data);
						return_function_();
						}
			}
	callpage('/index.cfm?fuseaction=objects2.emptypopup_get_js_query2');
	return new_query;
}
function paper_control(obj_name,paper_type,purchase_sales,upd_id,paper_number,company_id,consumer_id,employee_id,dsn_type,is_only_number)
{	
	//TolgaS 20080515 belge no kontrol paper_type dan sonrasi gelmez ise default degerleri alır **paper_number gelir ise yeni numara üretilmez yollanan deger yazılır
	//FBS20101221 is_only_number parametresi eklendi, no ile number degerleri bazi durumlarda ayri alanlara yazildigindan, degisen degerlerin de ayri atilmasi gerekiyordu
	
	if(list_find('SHIP,INVOICE',paper_type) && trim(eval(obj_name).value)=='')
	{
		alert(language.belge_numarası);
		return false;
	}
	var get_paper_control = workdata('get_paper_control',eval(obj_name).value,'',paper_type,purchase_sales,upd_id,company_id,consumer_id,employee_id,dsn_type);
	if(get_paper_control.recordcount)
	{
		if(purchase_sales==true || purchase_sales == undefined) var msg_auto_change='Değer Otomatik Değişecektir '; else var msg_auto_change ='';
		
		alert(eval(obj_name).value+' Belge Numarası Kullanılmıştır. '+msg_auto_change+'!');
		
		if((purchase_sales == true || purchase_sales == undefined) && (upd_id == 0 || upd_id == undefined))//eklerken satıslarda düzenlenecek
		{
			var get_paper = workdata('get_paper',paper_type);
			if(get_paper.recordcount)
			{
				if(is_only_number != undefined && is_only_number == 1)
					eval(obj_name).value = String(parseFloat(eval('get_paper.'+paper_type+'_NUMBER'))+1);
				else
					eval(obj_name).value = String(eval('get_paper.'+paper_type+'_NO')) +'-'+ String(parseFloat(eval('get_paper.'+paper_type+'_NUMBER'))+1);
			}
			else
				eval(obj_name).value = '';
			return false;
		}
		else if(paper_number == '')//fbs 20100511 daha once belge numarasi tanimli degilse bos deger atmak yerine, yine sistemden en son noyu alsin
		{
			var get_paper = workdata('get_paper',paper_type);
			if(get_paper.recordcount)
			{
				if(is_only_number != undefined && is_only_number == 1)
					eval(obj_name).value = String(parseFloat(eval('get_paper.'+paper_type+'_NUMBER'))+1);
				else
					eval(obj_name).value = String(eval('get_paper.'+paper_type+'_NO')) +'-'+ String(parseFloat(eval('get_paper.'+paper_type+'_NUMBER'))+1);
			}
			else
				eval(obj_name).value = '';
		}
		else
		{
			eval(obj_name).value = paper_number;
			return false;
		}
	}
	else
		return true;
}