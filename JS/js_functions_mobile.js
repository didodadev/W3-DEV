function windowopen(theURL,winSize) { /*v3.0*/
//fonsiyon 3 parametrede alabiliyor 3. parametre de isim yollana bilir ozaman aynı pencere tekrar acilmaz
	if (winSize == 'page') 					{ myWidth=750 ; myHeight=500 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
	else if (winSize == 'print_page') 		{ myWidth=750 ; myHeight=500 ; features = 'scrollbars=0, resizable=1, menubar=1' ; }
	else if (winSize == 'list') 			{ myWidth=700 ; myHeight=555 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
	else if (winSize == 'medium') 			{ myWidth=600 ; myHeight=470 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
	else if (winSize == 'small') 			{ myWidth=400 ; myHeight=300 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
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

function list_getat(gelen_,number,delim_)
/* cf deki listgetat in javascript hali*/
/*Düzenleme 20060405 */
{
	if(!delim_) delim_ = ',';	
	gelen_1=gelen_.split(delim_);

	if((gelen_.length == 0) || (number > gelen_1.length) || (number < 1))
		return '';
	else
		return gelen_1[number-1];
}

function ajax_request_script(html){
	var hd = document.getElementsByTagName("head")[0];
	var re = /(?:<script([^>]*)?>)((\n|\r|.)*?)(?:<\/script>)/ig;
	var srcRe = /\ssrc=([\'\"])(.*?)\1/i;
	var typeRe = /\stype=([\'\"])(.*?)\1/i;
	var match;
	while(match = re.exec(html)){
		var attrs = match[1];
		var srcMatch = attrs ? attrs.match(srcRe) : false;
		var textToEval = "";
		if(srcMatch && srcMatch[2]){
			var s = document.createElement("script");
			s.src = srcMatch[2];
			var typeMatch = attrs.match(typeRe);
			if(typeMatch && typeMatch[2]){
			s.type = typeMatch[2];
			}
			hd.appendChild(s);
		}else if(match[2] && match[2].length > 0){
			textToEval = match[2].replace("<!--", "").replace("-->", "").replace("//-->", "");
			if(window.execScript) { 
				window.execScript(textToEval);
			} else {
				window.eval(textToEval);
			}
		}
	}
	return html.replace(/(?:<script.*?>)((\n|\r|.)*?)(?:<\/script>)/ig, "");
}

/*
AJAX XHR nesnesi döndürür. Tarayıcı AJAX desteklemiyorsa,
kullanıcıya hata mesajı gösterir. Geriye olumsuz bir değer döndürür.
*/

function GetAjaxConnector() {
	// Kullanım: myAjaxConnector = GetAjaxConnector();
    var xmlHttp=null;
    try{
        // Firefox, Opera 8.0+, Safari
        xmlHttp=new XMLHttpRequest();
    }catch (e){
        // Internet Explorer
        try{
            xmlHttp=new ActiveXObject('Msxml2.XMLHTTP');
        }catch (e){
            xmlHttp=new ActiveXObject('Microsoft.XMLHTTP');
        }
    }
	if (xmlHttp==null) {
		alert ('Tarayıcınız Ajax Desteklemiyor!');
		return;
    }
    return xmlHttp;
}

function AjaxRequest(ajaxConnector,url,method,data,callback) {
	
	if (ajaxConnector!=null)
	{
		if(url.substr(0,4) == 'http')
			ajaxConnector.open(method,url+'&ajax=1&'+data, true);
		else
			ajaxConnector.open(method,'/'+url+'&ajax=1&'+data, true);
		ajaxConnector.setRequestHeader('If-Modified-Since', 'Sat, 1 Jan 2000 00:00:00 GMT');
		ajaxConnector.setRequestHeader('Content-Type','application/x-www-form-urlencoded; charset=utf-8');
		if (data != null) {
			ajaxConnector.setRequestHeader('Content-length', data.length);//alert(data);//form ile gelen değerleri görmek için alert'i açın eksik değer varmı kontrol edebilirsiniz.;
		}
		/*ajaxConnector.setRequestHeader('Connection', 'close');*/ //bu case 25 ekim 2011 de yunus ozay tarafından kaldirildi
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


function list_len(gelen,delim)
/* cf deki listlen in javascript hali*/
{
	if(!delim) delim = ',';
	if(gelen.length == 0)
		return 0;
	else
		return gelen.split(delim).length;
}


var deger_ = 0;
function AjaxPageLoad(url,target,error_detail,loader_message,li_id){
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
				} else 
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
		var request=AjaxRequest(ajaxConn,new_url,"get", null, function() {
			if ((ajaxConn.readyState==4 && ajaxConn.status == 200)) {
				if(li_id)//li id gönderilmiş ise
				ajax_tab(li_id);
				set_html(target, ajaxConn.responseText);
				ajax_request_script(ajaxConn.responseText);
			} else if (ajaxConn.readyState==4) {
				if (error_detail == true) {
					set_html(target, ajaxConn.responseText);
				} else {
					set_html(target, "<strong style='color:red'>WorkCube Hata! Sistem yöneticisine başvurun.</strong>");
				}
			}
		});
		if(request) {
			if(loader_message == undefined) loader_message = loader_div_message_;
			set_html(target,"<div id='divPageLoad' style='background:url(/images/loading.gif) no-repeat; padding:3px; text-align:left; font-weight:bold; color:F66633;'>&nbsp;&nbsp;"+loader_message+"</div>");
			return true;
		} else {
			return false;
		}
	
}


