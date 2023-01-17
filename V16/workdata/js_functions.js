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

function GetFormData(form) {
	//alert(form.elements);
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
					{
					args.push(form.elements[i].name + "=" + encodeURIComponent(form.elements[i].options[j].value));
					}
			}
		} 
		else 
		{
			args.push(form.elements[i].name + "=" + encodeURIComponent(form.elements[i].value));
			/*args.push(form.elements[i].name + "=" + form.elements[i].value);*/
		}
	}
	return args.join("&");
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
			ajaxConnector.setRequestHeader('Content-length', data.length);//alert(data)//form ile gelen değerleri görmek için alert'i açın eksik değer varmı kontrol edebilirsiniz.;
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


function AjaxFormSubmit(formName,messageBoxId,showError,watingMessage,successMessage,load_url,load_div,load_script)
{   
	var form;
	if (formName.split) 
		{
		form=document.forms[formName];
		} 
	else
		{
		form=formName;
		}
	
	var ajaxConn=GetAjaxConnector();
/*	if (navigator.appVersion.indexOf("MSIE") == -1)
	{
		form.submit(); // Eğer ajax işlemi düzgün çalışmıyorsa action sayfasındaki hatayı görebilmek için form'u normal şekilde submit edin (yani bu kısmı açın)
	}*/
	
	var messageBox=document.getElementById(messageBoxId);

	//var request=AjaxRequest(ajaxConn,new_url,"get", null, function() {
	var request=AjaxRequest(ajaxConn,form.action,form.method,GetFormData(form),function(){
	if (ajaxConn.readyState==4 && ajaxConn.status == 200) 
	{  
	  if(load_script)
			messageBox.innerHTML = ajax_request_script(ajaxConn.responseText);
		if (!successMessage) 
			{
			successMessage="<strong style='color:black'>Kaydedildi!</strong>";
			}
		messageBox.innerHTML ="<strong style='color:black'>"+ successMessage + "</strong>";
			if(load_url && load_div)//eger 2.ci div calistirmak isteniyorsa
				AjaxPageLoad(load_url+'&'+GetFormData(form),load_div,1);
	} 
	else if (ajaxConn.readyState==4)
		{  
		if (showError && showError==true) 
			{
			messageBox.innerHTML=ajaxConn.responseText;
			}
		else 
			{
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

/*
Adresi belirtilen sayfayı request eder. İçeriğini sayfada istenilen yerde gösterir.
Parametreler:
url: request edilecek sayfanın adresi
target: yüklenen sayfanın içeriğinin gösterileceği yer. Bir element'in (örn: div) ID'si veya AJAX window object.
error_detail: yüklenen sayfada sorun varsa, CF error ekranda gösterilsin mi. Varsayılan: false
loader_message: sayfa yüklenirken, ekranda gösterilecek yazı. Varsayılan: 'Yükleniyor...'
*/



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
						myAjaxConnector.send(data);
						return_function_();
						}
			}
	callpage('/index.cfm?fuseaction=objects2.emptypopup_get_js_query2');
	return new_query;
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
			function return_function_()
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
			return_function_();
			}
		
	}
	//TolgaS 20070124 objects yetkisi olmayan partnerlar var diye fuseaction objects2 yapildi
	callpage('/index.cfm?fuseaction=objects2.emptypopup_get_js_query');
	//alert(new_query);
	return new_query;
}



/* pop upları sayfanın tam ortasında açar... pencere boyutları önceden belirleniyor..*/
function windowopen(theURL,winSize) { /*v3.0*/
//fonsiyon 3 parametrede alabiliyor 3. parametre de isim yollana bilir ozaman aynı pencere tekrar acilmaz
	if (winSize == 'page') 					{ myWidth=750 ; myHeight=500 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
	else if (winSize == 'print_page') 		{ myWidth=750 ; myHeight=500 ; features = 'scrollbars=0, resizable=1, menubar=1' ; }
	else if (winSize == 'list') 			{ myWidth=700 ; myHeight=555 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
	else if (winSize == 'medium') 			{ myWidth=600 ; myHeight=470 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
	else if (winSize == 'small') 			{ myWidth=570 ; myHeight=350 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
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
	else if (winSize == 'norm_horizontal')	{ myWidth=950 ; myHeight=300 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
	else if (winSize == 'page_display')	{ myWidth=1100 ; myHeight=600 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
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

function ajaxwindow(theURL,winSize) {
	if (winSize == 'page') 		{ myWidth=750 ; myHeight=500 ;}
	else if (winSize == 'list') 		{ myWidth=700 ; myHeight=555 ;}
	else if (winSize == 'medium') 		{ myWidth=600 ; myHeight=470 ;}
	else if (winSize == 'small') 		{ myWidth=400 ; myHeight=300 ;}
	else if (winSize == 'date') 		{ myWidth=275 ; myHeight=190 ;}
	else if (winSize == 'project') 		{ myWidth=800 ; myHeight=620 ;}
	else if (winSize == 'large') 		{ myWidth=615 ; myHeight=550 ;}
	else if (winSize == 'horizantal') 	{ myWidth=950 ; myHeight=300 ;}
	else if (winSize == 'wide') 		{ myWidth=980 ; myHeight=600 ;}
	else if (winSize == 'longpage') 	{ myWidth=950 ; myHeight=500 ;}
	else if (winSize == 'page_horizantal') { myWidth=850 ; myHeight=500;}
	else if (winSize == 'video') 		{ myWidth=480 ; myHeight=420 ;}
	else if (winSize == 'wwide') 		{ myWidth=1600 ; myHeight=860 ;}
	else if (winSize == 'long_menu') 	{ myWidth=200 ; myHeight=500 ; }
	else if (winSize == 'adminTv') 		{ myWidth=1040 ; myHeight=800 ;}
    else if (winSize == 'userTv') 		{ myWidth=580 ; myHeight=520 ;}
	else if (winSize == 'mp3player') 	{ myWidth=500 ; myHeight=185 ;}
    else if (winSize == 'video_conference')	{ myWidth=740 ; myHeight=610 ;}
	else if (winSize == 'radio') 		{ myWidth=415 ; myHeight=180;}
    else if (winSize == 'VideoPlayer') 	{ myWidth=500 ; myHeight=457;}
    else if (winSize == 'white_board')	{ myWidth=1000 ; myHeight=730 ;}
    else if (winSize == 'high_radio')	{ myWidth=415 ; myHeight=230 ;}
	else { myWidth=400 ; myHeight=500 ;}
	
	if (arguments[2]==null)
		name_ = 'wrk_window';
	else
		name_ = arguments[2];
	
	if (arguments[3]==null)
		title_ = 'Workcube';
	else
		title_ = arguments[3];
	
	try 
	{ 
		ColdFusion.Window.destroy(name_,true); 
	} 
	catch(e) 
		{}
		
	function onhide() 
	{
		try 
			{ 
				ColdFusion.Window.destroy(name_,true); 
			} 
		catch(e) 
			{}
    }
	
	last_url_ = theURL + '&ajax=1';
	ColdFusion.Window.create(name_,title_,last_url_,{modal:false,initshow:true,bwidth:myWidth,height:myHeight,center:true,resizable:false,closable:true,draggable:true,destroyOnClose:true});
	ColdFusion.Window.onHide(name_, onhide);
}
	
function hide(id)
{
	document.getElementById(id).style.display='none';
	try
	{
		document.getElementById(id).style.visibility='hidden';
	}
	catch (e)
	{
	// Internet Explorer		
	}
}
function show(id)
{
	document.getElementById(id).style.display = '';
	try
	{
		document.getElementById(id).style.visibility='visible';
	}
	catch (e)
	{
	// Internet Explorer		
	}
}
function show_hide(id)
{
	if(document.getElementById(id).style.display == '' || document.getElementById(id).style.display == 'block')
	{
		hide(id);
	} 
	else 
	{
		show(id);
	}
}
function gizle(id)
{
	if(id.style != undefined) id.style.display='none';
}

function goster(id)
{
	id.style.display='';
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

/*table gizleme - gösterme  / imaj değişikliği yapıyor*/
function gizle_goster_img(id,id2,txt){
	if (document.getElementById(id).style.display=='')
		{
		document.getElementById(id).style.display='none';
		document.getElementById(id2).style.display='';
		document.getElementById(txt).style.display='none';
	} 
	else {
		document.getElementById(id).style.display='';
		document.getElementById(id2).style.display='none';
		document.getElementById(txt).style.display='';
	}
}

function gizle_goster_image(id,id2,txt){
	if (document.getElementById(id).style.display=='')
		{
		document.getElementById(id).style.display='none';
		document.getElementById(id2).style.display='';
		document.getElementById(txt).style.display='none';
	} 
	else {
		document.getElementById(id).style.display='';
		document.getElementById(id2).style.display='none';
		document.getElementById(txt).style.display='';
	}
}

function gizle_goster_basket(id)
{
	if(id.style.display=='')
	{
		id.style.display='none';
	} 
	else 
	{
		id.style.display='';
	}
	try
	{
		var id2 = eval(id.id + '_main_div');
		if(id2.style.display=='')
		{
			id2.style.display='none';
		} 
		else 
		{
			id2.style.display='';
		}
	}
	catch (e)
	{
		//
	}
	basket_set_height();
}

function gizle_goster_ikili(id1,id2)
{
	if(document.getElementById(id1).style.display=='')
	{
		document.getElementById(id1).style.display='none';
	} 
	else 
	{
		document.getElementById(id1).style.display='';
	}
	
	try
	{
		var id3 = id1 + '_main_div';
		if(document.getElementById(id3).style.display=='')
		{
			document.getElementById(id3).style.display='none';
		} 
		else 
		{
			document.getElementById(id3).style.display='';
		}
	}
	catch (e)
	{
		//
	}
		var $child = $('#'+id2);
		var h1 = $child.position().top;
		//h1 = AutoComplete_GetTop(document.getElementById(id2));
		h2 = document.body.clientHeight;
	try
	{
		footer_name_ = 'basket_footer_' + id2;
		h3 = parseInt(document.getElementById(footer_name_).style.height);
		document.getElementById(id2).style.height = h2 - h1 - 45 - h3 + 'px';
	}
	catch (e)
	{
		document.getElementById(id2).style.height = h2 - h1 - 45 + 'px';	
	}
}

function resize_basket(id)
{
	var $child = $('#'+id);
	var h1 = $child.position().top;
	//h1 = AutoComplete_GetTop(document.getElementById(id));
	h2 = document.body.clientHeight;
	try
	{
		footer_name_ = 'basket_footer_' + id;
		h3 = parseInt(document.getElementById(footer_name_).style.height);
		document.getElementById(id).style.height = h2 - h1 - 45 - h3 + 'px';
	}
	catch (e)
	{
		document.getElementById(id).style.height = h2 - h1 - 45 + 'px';	
	}
}


function show_hide_left_menu(left_menu_id)
{
	body_ = 'body_' + left_menu_id;
	img1_ = left_menu_id + '_img1';
	img2_ = left_menu_id + '_img2';
	if(document.getElementById(body_).style.display=='')
	{
		document.getElementById(left_menu_id).style.width='15px';
		document.getElementById(body_).style.display='none';
		document.getElementById(img1_).style.display='none';
		document.getElementById(img2_).style.display='';
		try
		{
			document.getElementById('wrk_layout_left_td').style.width='20px';
		}
		catch (e)
		{
			//
		}
	} 
	else 
	{
		document.getElementById(left_menu_id).style.width='150px';
		document.getElementById(body_).style.display='';
		document.getElementById(img1_).style.display='';
		document.getElementById(img2_).style.display='none';
		try
		{
			document.getElementById('wrk_layout_left_td').style.width='155px';
		}
		catch (e)
		{
			//
		}
	}
}
/* 
 parametre 1 : field_name.value
 parametre 2 : alan adı
 Verilen degiskenin boş değil ise en az 8 karakter içermesini kontrol eder
 alan eğer 1/1/2002 ise bunu 01/01/2002 yapar 
 alan eğer 1.1.2002 ise bunu 01.01.2002 yapar 
 arzu bt 06 2004
*/

function fix_date_value(field)
{
	field_tarih = field;
	if ((field_tarih.length > 0) && (field_tarih.length < 8) )
		{
			alert(' Tarih alanını kontrol ediniz !');
			return false;
		}		
	if (field_tarih.length >= 8)
		{
		if (field_tarih.indexOf('.') != -1)
			{
				if (field_tarih.indexOf('.') == 1)
					field_tarih = '0' + field_tarih;
				if (field_tarih.lastIndexOf('.') == 3)
					field_tarih = field_tarih.substr(0,3) + '01' + field_tarih.substr(3,5);
				if (field_tarih.lastIndexOf('.') == 4)
					field_tarih = field_tarih.substr(0,3) + '0' + field_tarih.substr(3,6);
			}
		else if (field_tarih.indexOf('/') != -1)
			{
			if (field_tarih.indexOf('/') == 1)
				field_tarih = '0' + field_tarih;
			if (field_tarih.lastIndexOf('/') == 3)
				field_tarih = field_tarih.substr(0,3) + '01' + field_tarih.substr(3,5);
			if (field_tarih.lastIndexOf('/') == 4)
				field_tarih = field_tarih.substr(0,3) + '0' + field_tarih.substr(3,6);
			}
		else
			{
			//	alert(' alanını kontrol ediniz ! ' + field_tarih.length + '');
				alert('Lütfen Tarihi Uygun Formatta Giriniz!');
				return false;
			}
		}
	if ((field_tarih.length > 0) && (field_tarih.length < 10))
		{
			// alert(' alanını kontrol ediniz ! ' + field_tarih.length + '');
			alert('Lütfen Tarihi Uygun Formatta Giriniz!');
			return false;
		}
	return(field_tarih);
}

/* 
 parametre 1 : form_name.field_name
 parametre 2 : alan adı
 Verilen alanın boş değil ise en az 8 karakter içermesini kontrol eder
 alan eğer 1/1/2002 ise bunu 01/01/2002 yapar 
 alan eğer 1.1.2002 ise bunu 01.01.2002 yapar 
*/
function fix_date(field,name)
{
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
			alert(name + ' alanını kontrol ediniz ! ' + field.value.length + 'karakter girdiniz!');
			return false;
			}
		}
	if ((field.value.length > 0) && (field.value.length < 10))
		{
		alert(name + ' alanını kontrol ediniz ! ' + field.value.length + 'karakter girdiniz!');
		return false;
		}
	return true;	
}

/* 
	tarih1 ===> document.assetp_reserve.startdate gibi bir form alanı olmalı
	tarih2 ===> document.assetp_reserve.finishdate gibi bir form alanı olmalı
	saat1 ===> document.assetp_reserve.starttime gibi bir form alanı olmalı
	saat2 ===> document.assetp_reserve.finishtime gibi bir form alanı olmalı
	tarih1 > tarih2 kontrol edilir
	msg hata durumunda alert edilecek mesaj
	ergün koçak
*/
function time_check(tarih1, saat1, dakika1, tarih2, saat2, dakika2, msg,is_equal)
{
	if(is_equal == undefined)
		is_equal = 0;
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
	
	if (tarih1_ > tarih2_ || (is_equal == 0 && tarih1_ == tarih2_)) 
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

/* 
tarih1 ===> document.assetp_reserve.startdate gibi bir form alanı olmalı
tarih2 ===> document.assetp_reserve.finishdate gibi bir form alanı olmalı
msg ===> hata durumunda alert edilecek mesaj
is_equal ===> 1 olursa esitlik kontrolu de yapilir.
tarih1 > tarih2  veya tarih1 = tarih2 kontrol edilir
*/
function date_check(tarih1, tarih2, msg, is_equal)
{
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


/* Hidden alanlarda focus problemi olmasın diye yazıldı. Onur P. 03012005 */
function date_check_hiddens(tarih1, tarih2, msg)
{
	tarih1_ = tarih1.value.substr(6,4) + tarih1.value.substr(3,2) + tarih1.value.substr(0,2);
	tarih2_ = tarih2.value.substr(6,4) + tarih2.value.substr(3,2) + tarih2.value.substr(0,2);
	
	if (tarih1_ > tarih2_) 
		{
		if (msg != '')
			{
			alert(msg);
			}
		else
			{
			alert('Hata Mesajı Ayarlanmamış !');
			}
		return false;
		}
	else
		return true;
}

function trim(inputString) {
   /*Removes leading and trailing spaces from the passed string. Also removes
     consecutive spaces and replaces it with one space. If something besides
     a string is passed in (null, custom object, etc.) then return the input.*/
   if (typeof inputString != "string") { return inputString; }
   var retValue = inputString;
   var ch = retValue.substring(0, 1);
   while (ch == " ") { /*Check for spaces at the beginning of the string*/
      retValue = retValue.substring(1, retValue.length);
      ch = retValue.substring(0, 1);
   }
   ch = retValue.substring(retValue.length-1, retValue.length);
   while (ch == " ") { /*Check for spaces at the end of the string*/
      retValue = retValue.substring(0, retValue.length-1);
      ch = retValue.substring(retValue.length-1, retValue.length);
   }
   while (retValue.indexOf("  ") != -1) { /*Note that there are two spaces in the string - look for multiple spaces within the string*/
      retValue = retValue.substring(0, retValue.indexOf("  ")) + retValue.substring(retValue.indexOf("  ")+1, retValue.length); /*Again, there are two spaces in each of the strings*/
   }
   return retValue; /*Return the trimmed string back to the user*/
} /*Ends the "trim" function*/


function list_len(gelen,delim)
/* cf deki listlen in javascript hali*/
{
	if(!delim) delim = ',';
	if(gelen.length == 0)
		return 0;
	else
		return gelen.split(delim).length;
}

function list_find(listem,degerim,delim)
{
	var kontrol=0;
	if(!delim) delim = ',';
	var listem_1=listem.split(delim);
	for (var m=0; m < listem_1.length; m++)
		if(listem_1[m]==degerim)
		{
			kontrol=1;
			break;
		}
	if(kontrol) 
		return m+1; 
	else 
		return 0;
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

function list_setat(listem,position,degerim,delim)
/* cf deki list_Setat in javascript hali*/
/*oluşturma 20060808 */
{ 
	var listem_2='';
	if(!delim) delim = ',';
	var listem_1=listem.split(delim);
	for (var m=0; m < listem_1.length; m++)
		if(position-1==m)
		{
				if(m==0)
					listem_2=degerim;
				else
					listem_2=listem_2+','+degerim;
		}
		else
		{
			if(m==0)listem_2=listem_1[m];
			else listem_2=listem_2+','+listem_1[m]
		}
	return listem_2;
}

function workcube_showHideLayers() 
	{ /*v3.0*/
		var i,p,v,obj,args=workcube_showHideLayers.arguments;
		for (i=0; i<(args.length-2); i+=3)
		if ((obj=findObj(args[i]))!=null) 
		{
			v=args[i+2];
			if (obj.style) {
				obj=obj.style;
			v=(v=='show')?'visible':(v='hide')?'hidden':v;
		}
		obj.visibility=v;
	}
}


function daysInMonth(month,year) 
{
	//gelen ay ve yıla göre o ayın kaç gün çektiğini döndürür
	var m = [31,28,31,30,31,30,31,31,30,31,30,31]; 
    if (month != 2) return m[month - 1]; 
    if (year%4 != 0) return m[1]; 
    if (year%100 == 0 && year%400 != 0) return m[1]; return m[1] + 1; 
} 

function isDate(y, m, d)
{ 
	//gelen tarihin valid olup olmadığını kontrol eder
	if(typeof y == "string" && m instanceof RegExp && d)
	{
		if(!m.test(y)) return 1; 
		y = RegExp["$" + d.y], m = RegExp["$" + d.m], d = RegExp["$" + d.d]; 
	} 
	d = Math.abs(d) || 0, m = Math.abs(m) || 0, y = Math.abs(y) || 0; 
	return arguments.length != 3 ? 1 : d < 1 || d > 31 ? 2 : m < 1 || m > 12 ? 3 : /4|6|9|11/.test(m) && d == 31 ? 4 : m == 2 && (d > ((y = !(y % 4) && (y % 1e2) || !(y % 4e2)) ? 29 : 28)) ? 5 + !!y : 0; 
}
function date_add(dpart,number,d,first_date,kontrol_month)
{
	/* 20051203 usage : date_add('m',3,'30/11/2005'),date_add('d',-2,'30/11/2005')
	cf teki gibi calisiyor ve ayni argumanlari aliyor : dpart 'd' = gun, dpart 'm' = ay
	d tarih gg/aa/yyyy veya gg.aa.yyyy olabilir, yil 2 hane girilebilir
    first_date : Eğer ardarda eklenen tarihler varsa , şubat ayı yüzünden günler bozuluyor , ilk tarih gönderilirse
    sonraki aylar da ilk tarihin gününe göre hesaplanıyor
    */
	if(number == 0) return d;
	if(kontrol_month == undefined) kontrol_month = 0;
	if(!d || !dpart || !number) return false;
	if(d.split('/').length==3) d = d.split('/');
	else if(d.split('.').length==3) d = d.split('.');
	else return false;
    if(first_date != undefined && first_date != '')
    {
        if(first_date.split('/').length==3) first_date = first_date.split('/');
        else if(first_date.split('.').length==3) first_date = first_date.split('.');
		var first_date = new Date(first_date[2],first_date[1]-1,first_date[0]);//javascript aylari 0-11 araliginda tutuyor
    }
	if(d[2].length == 2){
		var y = new Date();
		d[2] = y.getFullYear().toString().substr(0,2) + d[2];//yil 2 hane girilirse basina bu yilin ilk iki karakterini aliyoruz
		}
	var d = new Date(d[2],d[1]-1,d[0]);//javascript aylari 0-11 araliginda tutuyor
	if(dpart == 'd')
		d.setDate(d.getDate()+number);//gun eklenmek istenmis
	else if(dpart == 'm')
    {
		if(first_date == undefined || first_date == '')
		{
			if(d.getDate() > 28 && (d.getMonth() == 0) && number==1){//gün 28den büyük girilmiş ise... ve aylardan ocak ise 1 ay eklendiğinde sapıtıyordu o yüzden gün olarak ekleme yapıyoruz.
			if(d.getFullYear() % 4 == 0)
				d.setDate(d.getDate()+29);
			else
				d.setDate(d.getDate()+28);
			d = d.getDate()+'/'+(d.getMonth()+1)+'/'+d.getFullYear();return d;}
			d.setMonth(d.getMonth()+number);//ay eklenmek istenmis
	   }
	   else if(first_date != undefined && first_date != '' && (first_date.getDate() > 28 || kontrol_month == 1))
	   {
			if(d.getMonth() == 11)
				day_count = daysInMonth(1,d.getFullYear()+1);
			else
				day_count = daysInMonth((d.getMonth()+2),d.getFullYear()); 
				
			first_day_count = first_date.getDate();
			
			if(d.getMonth() == 11)
			{
				new_month = 1;
				new_year=d.getFullYear()+1;
			}
			else
			{
				new_month = d.getMonth()+2;
				new_year=d.getFullYear();
			}
			if(kontrol_month == 1 )
			{
				if(isDate(new_year,new_month,first_day_count) == 0 && first_day_count != daysInMonth((d.getMonth()+1),d.getFullYear()))
					var new_date = first_day_count+'/'+new_month+'/'+new_year;
				else
					var new_date = day_count+'/'+new_month+'/'+new_year;
			}
			else
			{
				if(isDate(new_year,new_month,first_day_count) == 0)
					var new_date = first_day_count+'/'+new_month+'/'+new_year;
				else
					var new_date = day_count+'/'+new_month+'/'+new_year;
			}
			return new_date;
		}
		else
			d.setMonth(d.getMonth()+number); 
    } 
	d = d.getDate()+'/'+(d.getMonth()+1)+'/'+d.getFullYear();
	return d;
}

function datediff(date1,date2,a)
{
	/*
	20071220 SM
	İki tarih arasındaki farku bulur. Son değişkene göre 30 a göre modunu alır.
	usage:
	datediff(date1,date2,1)------İki tarihin farkını alıp 30 a göre modunu sonuç olarak döndürür(standart vade hesapları için)
	datediff(date1,date2,0)------ İki tarih arasındaki net farkı bulur.
	*/	
	if(!date1 || !date2) return false;
	date1=date1.replace(/\./g,'/');
	date1=date1.replace(/-/g,'/');
	date1=date1.replace(/\\/g,'/');
	date2=date2.replace(/\./g,'/');
	date2=date2.replace(/-/g,'/');
	date2=date2.replace(/\\/g,'/');
	var one_day=1000*60*60*24; 
	var x=date1.split("/"); 
	var y=date2.split("/");
	var date1=new Date(x[2],(x[1]-1),x[0]);
	var date2=new Date(y[2],(y[1]-1),y[0])
	var diff=wrk_round(parseFloat((date2.getTime()-date1.getTime())/(one_day)),0); 
	if(a == 1 && diff > 30)
		var diff = diff - (diff % 30);
	return(diff);
}

function workdata(qry,prmt,maxrows)
{
	var new_query=new Object();
	var req;
	if(!qry) return false;
	if(prmt == undefined) prmt='';
	if(maxrows == undefined) maxrows='20';
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
			function return_function_()
			{
			if (req.readyState == 4 && req.status == 200)
				try
				{	
					eval(req.responseText);
					new_query = get_js_query;
				}
				catch(e)
				{
					new_query = false;
				}
			}
			req.open("post", url, false);
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
			return_function_();
		}
	}		 
	callpage('index.cfm?fuseaction=objects2.emptypopup_get_workdata');
	return new_query;
}

function js_date(tarih,saat){
/*20060316 TolgaS
cf_date gibi çalışıyor aynı şekilde 2. arguman yollanırsa createodbcdate gibi saatide ekler ancak 19:42 şeklinde gelmeli saat*/
	if(tarih.indexOf('ts'))
	{
		tarih=tarih.replace(/\./g,'/');
		tarih=tarih.replace(/-/g,'/');
		tarih=tarih.replace(/\\/g,'/');
		if(list_len(tarih,'/')==3)
		{
			var js_gun=list_getat(tarih,1,'/');
			var js_ay=list_getat(tarih,2,'/');
			var js_yil=list_getat(tarih,3,'/');
			if(js_gun.length==0) js_gun = "01";
			else if (js_gun.length==1) js_gun = "0"+js_gun;
			if(js_ay.length==0) js_ay = "01";
			else if(js_ay.length==1) js_ay = "0"+js_ay;
			if(js_yil.length!=4 || js_yil<1900)
			{
				var js_tdayDate=new Date();
				var js_yil=js_tdayDate.getYear();
			}
			if(CheckEurodate(js_gun+"/"+js_ay+"/"+js_yil,'Tarih Kullanımı'))
			{
				if(saat == undefined)
					tarih="{ts '"+js_yil+"-"+js_ay+"-"+js_gun+" 00:00:00'}";
				else
					tarih="{ts '"+js_yil+"-"+js_ay+"-"+js_gun+" "+saat+":00'}";
				return tarih;
			}else return '';
		}
	}	return tarih;
}

function date_format(gelen_tarih)
{
/*20070705 YunusOzay
dateformat gibi çalışıyor aynı şekilde tek arguman alıyor*/
	date_alan = '' + gelen_tarih; 

	js_yil = date_alan.substr(0,4);
	js_ay = date_alan.substr(5,2);
	js_gun = date_alan.substr(8,2);
	
	tarih = js_gun + "/" + js_ay + "/" + js_yil;
	return tarih;
}

function date_diff(tarih1,tarih2,fark,msg)
{
	/* 
	tarih1 ===> document.assetp_reserve.startdate gibi bir form alanı olmalı
	tarih2 ===> document.assetp_reserve.finishdate gibi bir form alanı olmalı
	fark ===> sayısal bir deger verilir. yil araligini belirler (ornegin : tarih1 ve tarih2 araligi en fazla 2 yil olmali gibi)
	msg hata durumunda alert edilecek mesaj
	Senay Gargaci 20060815
	*/
	fix_date(tarih1,tarih1.name);
	fix_date(tarih2,tarih2.name);
	tarih1_ = tarih1.value.substr(6,4);
	tarih2_ = tarih2.value.substr(6,4);
	deger_ = tarih2_ - tarih1_;
	if (deger_ > fark) 
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

function isNumber(nesne,type) 
{
	/* 
	Input alaninin onblur ve onkeyup fonsksiyonlarında kullanilir. Kullanımında ise sadece sayı ifadeleri ile giris yapilabilir.
	onkeyup="isNumber(this);" onblur='isNumber(this);'
	Tolga Sutlu & Barbaros Kuz 20061124
	Eğer type alanına 1 gönderilirse rakam ve virgül dışındakilere izin vermiyor , birşey gönderilmezse sadece rakamlara izin veriyor.
	*/
	var inputStr=nesne.value;
	if(inputStr.length>0)
	{
		for(var i=0;i < inputStr.length;i++)
		{
			var oneChar = inputStr.substring(i,i+1);
			if(type != undefined && type == 1)
			{
				if ((oneChar < "0" || oneChar > "9") && oneChar != ",") 
				{
					nesne.value=inputStr.substring(0,i);
					return false;
				}
			}
			else
				if (oneChar < "0" || oneChar > "9") 
				{
					nesne.value=inputStr.substring(0,i);
					return false;
				}
		}
	}
}

function isCharacter(nesne,type) 
{
/* 
	Input alaninin onblur ve onkeyup fonsksiyonlarında kullanilir. Kullanımında ise sadece alfabetik yada rakam ifadeleri ile giris yapilabilir. 
	bosluk karakteri girilebilir.
	onkeyup="isCharacter(this);" onblur='isCharacter(this);'
	Eğer type alanına 1 gönderilirse alfabetik yada rakam girisine izin veriyor,parametre gonderilmez ise sadece alfabetik girise izin veriyor.
	Barbaros Kuz 20120618
	' ^ + -  \ *  % & / ( ) = ? " @ < > £ # $ ½ { [ ] } \ |  _ `, , .
*/	
	

	//var prohibited='", #, $, %, &, ', (, ), *, +, ,, -, ., /, <, =, >, ?, @, [, \, ], ], _, `, {, |, }, , «, ';
	var prohibited_asci='34,35,36,37,38,39,40,41,42,43,44,45,46,47,60,61,62,63,64,91,92,93,93,95,96,123,124,125,156,171';

	var inputStr=nesne.value;
	if(inputStr.length>0)
	{
		if(type != undefined && type == 1)
		{
			for(var i=0;i < inputStr.length;i++)
			{
				var oneChar= inputStr.substring(i,i+1).charCodeAt();
				{
					if(!(!list_find(prohibited_asci,oneChar) || (oneChar == 32) || (48 <= oneChar && oneChar <= 57))) 
					{
						nesne.value=inputStr.substring(0,i);
						return false;
					}
				}
			}
		}
		else
		{
			for(var i=0;i < inputStr.length;i++)
			{
				var oneChar= inputStr.substring(i,i+1).charCodeAt();
				{
					if(!(!list_find(prohibited_asci,oneChar) || (oneChar == 32))) 
					{
						nesne.value=inputStr.substring(0,i);
						return false;
					}
				}
			}		
		}
	}
}

function wrk_date_image(gelen_alan,gelen_function)
{
	if(arguments[2]==null)
		{
		gelen_image_ = gelen_alan + "_image";
		gelen_ = eval(gelen_alan + "_td");
		gelen_.innerHTML = gelen_.innerHTML + '<img src="/images/calendar.gif" align="absbottom" id="' + gelen_image_ +'" border="0" style="cursor:pointer;">';
		
			if(arguments[1]==null)
				{
				Calendar.setup
					({
					inputField:gelen_alan,
					dateFormat:"%d/%m/%Y",
					trigger:gelen_image_,
					onSelect:function(){this.hide();},
					align:"Bl",
					singleClick:true
					});
				}
			else
				{		
					a=function this_get_function_1(cal,date)
						{
						 if (!cal.dateClicked) 
							 { 
							  return; //date was not clicked do nothing 
							 } 
						eval("document.all." + gelen_alan).value = date;
						eval("window."+gelen_function);
						}
					
					Calendar.setup
						({
						inputField:gelen_alan,
						dateFormat:"%d/%m/%Y",
						trigger:gelen_image_,
						align:"Bl",
						onSelect:function(){this.hide();eval("window."+gelen_function);this_get_function_1;},
						singleClick:true
						});
				}
		}
	else
		{
			gelen_image_ = String(gelen_alan + "_image");
			gelen_alan = String(gelen_alan);
			sira_ = arguments[2];
			Calendar.setup
					({
					inputField:gelen_alan,
					dateFormat:"%d/%m/%Y",
					trigger:gelen_image_,
					input_sira:sira_,
					onSelect:function(){this.hide();},
					align:"Bl",
					singleClick:true
					});
		}
}

function chk_process_cat(form_name,is_main)
{
	if(is_main==undefined || is_main==0)
		var deger = eval(form_name+'.process_cat');
	else
		var deger = eval(form_name+'.main_process_cat');
	if( deger[deger.selectedIndex].value.length == 0 )
	{
		alert("İşlem Tipi Seçiniz!");
		return false;
	}
	return true;
}

function wrk_call_function_js(call_function_name,call_function_parameters)
{//TS2008 istenilen fonksiyon ismi parametreleri yollanır parametrele bir array şeklinde sırası ile degerler gelir ve fonksiyon çalıştırılır
	var call_function = call_function_name+"(";
	for(i = 0; i < call_function_parameters.length-1; i++) 
		call_function += "'"+call_function_parameters[i]+"',";
	call_function += "'"+call_function_parameters[i]+"');";
	return eval(call_function);
}
function js_mid(str,start,len)
{
	//20080425 AE cf deki Mid in javascript hali. Kullanımı : js_mid(tam_kisim,2,1);
	if (start < 0 || len < 0) return "";
	var mid_str = str.substr(parseFloat(start)-1,len);
	return mid_str;
}
//WorkcubeObjeleri M.ER 01102008


function paper_control(obj_name,paper_type,purchase_sales_,upd_id,paper_number,company_id,consumer_id,employee_id,dsn_type,is_only_number,obj_name_extra)
{	
	//TolgaS 20080515 belge no kontrol paper_type dan sonrasi gelmez ise default degerleri alır **paper_number gelir ise yeni numara üretilmez yollanan deger yazılır
	//FBS20101221 is_only_number parametresi eklendi, no ile number degerleri bazi durumlarda ayri alanlara yazildigindan, degisen degerlerin de ayri atilmasi gerekiyordu
	//obj_name_extra parametresi fatura noları iki alandan oluştuğu için eklendi , 2.parametreye seri alanı gönderilir
	if(list_find('SHIP,INVOICE,INCOME_COST,EXPENSE_COST,STOCK_FIS',paper_type) && trim(eval(obj_name).value)=='')
	{
		alert(language.belge_numarası);
		return false;
	}
	if(obj_name_extra != undefined && eval(obj_name_extra).value != '')//obj_name_extra gonderilmis ama bos ise kontrol etmeye gerek yok
		paper_value = eval(obj_name_extra).value+'-'+eval(obj_name).value;
	else
		paper_value = eval(obj_name).value;
	
	var get_paper_control = workdata('get_paper_control',paper_value,'',paper_type,purchase_sales_,upd_id,company_id,consumer_id,employee_id,dsn_type);
	record_num = get_paper_control.recordcount;
	if(!(purchase_sales_== true || purchase_sales_ == undefined) && company_id == '' && consumer_id == '')
		record_num = 0;
	if(record_num != 0)
	{
		if(purchase_sales_==true || purchase_sales_ == undefined) var msg_auto_change='Değer Otomatik Değişecektir '; else var msg_auto_change ='';
		
		alert(paper_value+' Belge Numarası Kullanılmıştır '+msg_auto_change+'!');
		if((purchase_sales_ == true || purchase_sales_ == undefined) || (upd_id == 0 || upd_id == undefined))//eklerken satıslarda düzenlenecek
		{
			var get_paper = workdata('get_paper',paper_type);
			if(eval('get_paper.'+paper_type+'_NUMBER') != '')
			{
				if(get_paper.recordcount)
				{
					if(is_only_number != undefined && is_only_number == 1)
						eval(obj_name).value = String(parseFloat(eval('get_paper.'+paper_type+'_NUMBER'))+1);
					else
					{
						if(obj_name_extra != undefined)
						{
							eval(obj_name_extra).value = String(eval('get_paper.'+paper_type+'_NO'));
							eval(obj_name).value = String(parseFloat(eval('get_paper.'+paper_type+'_NUMBER'))+1);
						}
						else
							eval(obj_name).value = String(eval('get_paper.'+paper_type+'_NO')) +'-'+ String(parseFloat(eval('get_paper.'+paper_type+'_NUMBER'))+1);
					}
				}
				else
				{
					eval(obj_name).value = '';
				}
				return false;
			}
			else
			{
				alert('Bu İşlem Tipi İçin Belge Numarası Tanımlayınız !');
				eval(obj_name).value = '';
				return false;
			}
		}
		else if(paper_number == '' && (purchase_sales_ == true || purchase_sales_ == undefined))//fbs 20100511 daha once belge numarasi tanimli degilse bos deger atmak yerine, yine sistemden en son noyu alsin
		{
			var get_paper = workdata('get_paper',paper_type);
			if(get_paper.recordcount)
			{
				if(is_only_number != undefined && is_only_number == 1)
					eval(obj_name).value = String(parseFloat(eval('get_paper.'+paper_type+'_NUMBER'))+1);
				else
				{
					if(obj_name_extra != undefined)
					{
						eval(obj_name_extra).value = String(eval('get_paper.'+paper_type+'_NO'));
						eval(obj_name).value = String(parseFloat(eval('get_paper.'+paper_type+'_NUMBER'))+1);
					}
					else
						eval(obj_name).value = String(eval('get_paper.'+paper_type+'_NO')) +'-'+ String(parseFloat(eval('get_paper.'+paper_type+'_NUMBER'))+1);
				}
			}
			else
			{
				eval(obj_name).value = '';
			}
		}
		else
		{
			/* Uyari verildikten sonra zaten burada false donuyor, belge numarasini bosaltmaya gerek yok fbs 20120704
			eval(obj_name).value = '';
			*/
			return false;
		}
	}
	else
		return true;
}

function LoadCity(id_residence,field_select_city,field_select_county,field_zone_control,field_select_district,field_tel_code)
{   
	var city_len = document.getElementById(field_select_city).options.length;
	for(j=city_len;j>=0;j--)
		{
		eval('document.getElementById("' + field_select_city + '")').options[j] = null;
		}
	
	var county_len = document.getElementById(field_select_county).options.length;
	
	for(j=county_len;j>=0;j--)
		eval('document.getElementById("' + field_select_county + '")').options[j] = null;
	
	if(field_select_district != undefined && field_select_district != 0)
	{
		var district_len = document.getElementById(field_select_district).options.length;
		for(j=district_len;j>=0;j--)
			eval('document.getElementById("' + field_select_district + '")').options[j] = null;	
	}
	//Ulke secili ise
	if(id_residence != '')
	{    
		if(field_zone_control != undefined && field_zone_control != 0)
			var deger=workdata('get_residence',1,id_residence,field_zone_control);
		else 
			var deger=workdata('get_residence',1,id_residence);
		eval('document.getElementById("' + field_select_city + '")').options[0] = new Option('Seçiniz','');
		eval('document.getElementById("' + field_select_county + '")').options[0] = new Option('Seçiniz','');
		if(field_select_district != undefined && field_select_district != 0)
			eval('document.getElementById("' + field_select_district + '")').options[0] = new Option('Seçiniz','');
		
		if(field_tel_code != undefined && field_tel_code != 0)
			eval('document.getElementById("' + field_tel_code + '")').value = '';

		if(deger.recordcount)
		{
			for(var jj=0;jj < deger.recordcount;jj++)
				eval('document.getElementById("' + field_select_city + '")').options[jj+1]=new Option(deger.CITY_NAME[jj],deger.CITY_ID[jj]);
				
			if(field_tel_code != undefined && field_tel_code != 0)
				eval('document.getElementById("' + field_tel_code + '")').value = deger.PHONE_CODE[0];
		}
	}
	else
	{
		eval('document.getElementById("' + field_select_city + '")').options[0] = new Option('Seçiniz','');
		eval('document.getElementById("' + field_select_county + '")').options[0] = new Option('Seçiniz','');
		if(field_select_district != undefined && field_select_district != 0)
			eval('document.getElementById("' + field_select_district + '")').options[0] = new Option('Seçiniz','');
		
		if(field_tel_code != undefined && field_tel_code != 0)
			eval('document.getElementById("' + field_tel_code + '")').value = '';
	}
}

function LoadCounty(id_residence,field_select_county,field_telcode,is_name,field_select_district,telcod_type)
{   
	var county_len = eval("document.all." + field_select_county + ".options.length");
	for(j=county_len;j>=0;j--)
		eval("document.all." + field_select_county).options[j] = null;
	if(field_select_district != undefined && field_select_district != '')
	{
		var district_len = eval("document.all." + field_select_district + ".options.length");
		for(j=district_len;j>=0;j--)
			eval("document.all." + field_select_district).options[j] = null;	
	}
	//Il secili degilse
	if(id_residence != '')
	{
		var deger=workdata('get_residence',2,id_residence);
		eval("document.all." + field_select_county).options[0]=new Option('Seçiniz','');
		if(field_select_district != undefined && field_select_district != '')
			eval("document.all." + field_select_district).options[0] = new Option('Seçiniz','');
		for(var jj=0;jj < deger.recordcount;jj++)
		{
			if(is_name != undefined && is_name==1)
				eval("document.all." + field_select_county).options[jj+1]=new Option(deger.COUNTY_NAME[jj],deger.COUNTY_NAME[jj]);
			else
				eval("document.all." + field_select_county).options[jj+1]=new Option(deger.COUNTY_NAME[jj],deger.COUNTY_ID[jj]);
		}
		if(field_telcode != undefined && field_telcode != '' && deger.recordcount > 0)
		{
			if(telcod_type != undefined && telcod_type == 1)
				{
				eval("document.all." + field_telcode).value = '';
				eval("document.all." + field_telcode).value = deger.PHONE_CODE_LONG[0];
				}
			else
				{
				eval("document.all." + field_telcode).value = '';
				eval("document.all." + field_telcode).value = deger.PHONE_CODE[0];
				}
		}
	}
	else
	{
		eval("document.all." + field_select_county).options[0]=new Option('Seçiniz','');
		if(field_telcode != undefined)
			eval("document.all." + field_telcode).value = '';
		if(field_select_district != undefined)
			eval("document.all." + field_select_district).options[0] = new Option('Seçiniz','');
	}
}

function LoadDistrict(id_residence,field_select_district)
{
	var district_len = eval("document.all." + field_select_district + ".options.length");
	for(j=district_len;j>=0;j--)
		eval("document.all." + field_select_district).options[j] = null;
	//Ilçe secili degilse
	if(id_residence != '')
	{
		var deger=workdata('get_residence',3,id_residence);
		eval("document.all." + field_select_district).options[0]=new Option('Seçiniz','');
		for(var jj=0;jj < deger.recordcount;jj++)
		{
			eval("document.all." + field_select_district).options[jj+1]=new Option(deger.DISTRICT_NAME[jj],deger.DISTRICT_ID[jj]);
		}
	}
	else
	{
		eval("document.all." + field_select_district).options[0]=new Option('Seçiniz','');
	}
}

function WrkAccountControl(control_value,mesaj)
{
	var deger = workdata('get_account_code',control_value,1,0,1);
	if(deger.recordcount == 0)
	{
		alert(mesaj);
		return deger.recordcount;
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

function isDefined(variable)
{
	return (!(!(eval("document.all."+variable))));
}

function findObj(theObj, theDoc)
/*herhangi bir document icinde eleman arar 20041104*/
{
	var p, i, foundObj;
	if(!theDoc) theDoc = document;
	if( (p = theObj.indexOf("?")) > 0 && parent.frames.length)
	{
		theDoc = parent.frames[theObj.substring(p+1)].document;
		theObj = theObj.substring(0,p);
	}
	if(!(foundObj = theDoc[theObj]) && theDoc.all) foundObj = theDoc.all[theObj];
	for (i=0; !foundObj && i < theDoc.forms.length; i++) 
		foundObj = theDoc.forms[i][theObj];
	for(i=0; !foundObj && theDoc.layers && i < theDoc.layers.length; i++) 
		foundObj = findObj(theObj,theDoc.layers[i].document);
	if(!foundObj && document.getElementById) foundObj = document.getElementById(theObj);
	return foundObj;
}

function TusOku(event_)
{	
	if(typeof(event_)=='string'){
		if(event_ != -1){
			if (list_getat(event_,3,'|@|') == "1" )
				window.open('?fuseaction='+list_getat(event_,1,'|@|')+'','mywin','left=20,top=20,copyhistory=1,scrollbars=1,menubar=1,directories=1,status=1,location=1,toolbar=1,resizable=1');
			else				
				window.location='?fuseaction='+list_getat(event_,1,'|@|')+'';
		}
	}
	else if((window.event) && window.event.ctrlKey==true && window.event.shiftKey==true)
	{
		var List_Favorites = document.getElementById('URL');
		var Favorites_i;
		if (List_Favorites!=null)
		{
			for (Favorites_i = List_Favorites.length - 1; Favorites_i>=1; Favorites_i--) 
			{
				if (list_getat(List_Favorites[Favorites_i].value,2,'|@|') == String.fromCharCode(window.event.keyCode))
				{
					if (list_getat(List_Favorites[Favorites_i].value,3,'|@|')=="1")	
						FavoritesmyRef = window.open('?fuseaction='+list_getat(document.getElementById(Favorites_i).value,1,'|@|')+'','','left=20,top=20,copyhistory=1,scrollbars=1,menubar=1,directories=1,status=1,location=1,toolbar=1,resizable=1');
					else				
					window.location='?fuseaction='+list_getat(document.getElementById(Favorites_i).value,1,'|@|')+'';
				}
			}
		}
	}
}

/*
	[fav_location_page]
    TusOku fonksiyonundan gelen url string değerine göre name ve value'leri doldurarak form içinde gidilmek istenen kısayola gider,
    bunu yapmamın sebebi,önceden url'den gittiği için kaydedilmiş bir sayfaya erişildiğinde mesela tarihi değiştirse bile yada bir checkbox'u kaldırsa bile
    değerler bir sonraki listelemede hem url'den hemde formdan gittiği için,url değerleride sık kullanılanlarda ilk kaydedilmiş hali ile kaldığı için
    kullanıcının çalışan sayfa üzerinde bir değişiklik yapmasına olanak vermiyordu,bu sebeble form üzerinden gönderilerek bu sorun ortadan kaldırıldı..
    Form EP deki  SıkKullanılanlar checbox ının bulunduğu sayfada yer alıyor....(objects\display\favourites.cfm)
    M.ER 23 12 20008
*/
/*
    [form_warning]
    Boş olmaması gereken Satırların konrolünü kolaştırır..Fonksiyona objenin id'si ve uyarı mesajı gönderilir,
    fonksiyon alanın boş olup olmadığını kontrol return yada false döner,false döner ise nesneye focuslanarak 
    nesnenin arkaplan rengini değiştirir....
    Kullanım :
    if(!form_warning('q_control_no','Kalite Belge Numaralarını Tanımlayınız!'))return false;
    M.ER 01 08 20008
*/
function form_warning(field_id,warning_message,lenght){
	if(document.getElementById(field_id) != undefined)
	{
		if((lenght == undefined && document.getElementById(field_id).value=='') || (lenght != undefined && document.getElementById(field_id).value.length > 0 && document.getElementById(field_id).value.length != lenght)){
			alert(warning_message);
			document.getElementById(field_id).style.background='FF9900';
			document.getElementById(field_id).focus();
			return false;
		}
		else{
			if(document.getElementById(field_id).style.background =='#ff9900') document.getElementById(field_id).style.background='FFFFFF';	
			return true;
		}
	}
	else
		return true;
}

function allFilterNum(){
	for (var xi=0;xi<=arguments.length-1;xi++){
		if(document.getElementById(arguments[xi])){
			var degerim =document.getElementById(arguments[xi])
			degerim.value=filterNum(degerim.value,4);
		}
	}
}

function MyupdateClass()//fck editörün ajaxformsubmit ile kullanılması için gerekli olan function 
{
	this.updateEditorFormValue = function()
	{
			//Bu bölümde tüm FCKeditor alanlarının güncellenmesini sağlıyoruz.
			for (i = 0; i < parent.frames.length;i++)
				{
				if(parent.frames[i].FCK)
						{
						parent.frames[i].FCK.UpdateLinkedField();
						}
				}
	}
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

function search_char_control(fld)
{
	toplam_ = fld.value.length;
	deger_ = fld.value;
	yasaklilar_ = '<,>';
	if(toplam_>0)
	{
	for(var this_tus_=0; this_tus_< toplam_; this_tus_++)
		{
		tus_ = deger_.charAt(this_tus_);
		cont_ = list_find(yasaklilar_,tus_);
		if(cont_>0)
			{
			alert("Hatalı Arama Kriteri!");
			izin_ = '';
			fld.value = fld.value.replace(tus_,izin_);
			}
		}
	}
}

var Drag = {

	obj : null,

	init : function(o, oRoot, minX, maxX, minY, maxY, bSwapHorzRef, bSwapVertRef, fXMapper, fYMapper)
	{
		o.onmousedown	= Drag.start;

		o.hmode			= bSwapHorzRef ? false : true ;
		o.vmode			= bSwapVertRef ? false : true ;

		o.root = oRoot && oRoot != null ? oRoot : o ;

		if (o.hmode  && isNaN(parseInt(o.root.style.left  ))) o.root.style.left   = "0px";
		if (o.vmode  && isNaN(parseInt(o.root.style.top   ))) o.root.style.top    = "0px";
		if (!o.hmode && isNaN(parseInt(o.root.style.right ))) o.root.style.right  = "0px";
		if (!o.vmode && isNaN(parseInt(o.root.style.bottom))) o.root.style.bottom = "0px";

		o.minX	= typeof minX != 'undefined' ? minX : null;
		o.minY	= typeof minY != 'undefined' ? minY : null;
		o.maxX	= typeof maxX != 'undefined' ? maxX : null;
		o.maxY	= typeof maxY != 'undefined' ? maxY : null;

		o.xMapper = fXMapper ? fXMapper : null;
		o.yMapper = fYMapper ? fYMapper : null;

		o.root.onDragStart	= new Function();
		o.root.onDragEnd	= new Function();
		o.root.onDrag		= new Function();
	},

	start : function(e)
	{
		var o = Drag.obj = this;
		e = Drag.fixE(e);
		var y = parseInt(o.vmode ? o.root.style.top  : o.root.style.bottom);
		var x = parseInt(o.hmode ? o.root.style.left : o.root.style.right );
		o.root.onDragStart(x, y);

		o.lastMouseX	= e.clientX;
		o.lastMouseY	= e.clientY;

		if (o.hmode) {
			if (o.minX != null)	o.minMouseX	= e.clientX - x + o.minX;
			if (o.maxX != null)	o.maxMouseX	= o.minMouseX + o.maxX - o.minX;
		} else {
			if (o.minX != null) o.maxMouseX = -o.minX + e.clientX + x;
			if (o.maxX != null) o.minMouseX = -o.maxX + e.clientX + x;
		}

		if (o.vmode) {
			if (o.minY != null)	o.minMouseY	= e.clientY - y + o.minY;
			if (o.maxY != null)	o.maxMouseY	= o.minMouseY + o.maxY - o.minY;
		} else {
			if (o.minY != null) o.maxMouseY = -o.minY + e.clientY + y;
			if (o.maxY != null) o.minMouseY = -o.maxY + e.clientY + y;
		}

		document.onmousemove	= Drag.drag;
		document.onmouseup		= Drag.end;
		return false;
	},

	drag : function(e)
	{
		e = Drag.fixE(e);
		var o = Drag.obj;

		var ey	= e.clientY;
		var ex	= e.clientX;
		var y = parseInt(o.vmode ? o.root.style.top  : o.root.style.bottom);
		var x = parseInt(o.hmode ? o.root.style.left : o.root.style.right );
		var nx, ny;

		if (o.minX != null) ex = o.hmode ? Math.max(ex, o.minMouseX) : Math.min(ex, o.maxMouseX);
		if (o.maxX != null) ex = o.hmode ? Math.min(ex, o.maxMouseX) : Math.max(ex, o.minMouseX);
		if (o.minY != null) ey = o.vmode ? Math.max(ey, o.minMouseY) : Math.min(ey, o.maxMouseY);
		if (o.maxY != null) ey = o.vmode ? Math.min(ey, o.maxMouseY) : Math.max(ey, o.minMouseY);

		nx = x + ((ex - o.lastMouseX) * (o.hmode ? 1 : -1));
		ny = y + ((ey - o.lastMouseY) * (o.vmode ? 1 : -1));

		if (o.xMapper)		nx = o.xMapper(y)
		else if (o.yMapper)	ny = o.yMapper(x)

		Drag.obj.root.style[o.hmode ? "left" : "right"] = nx + "px";
		Drag.obj.root.style[o.vmode ? "top" : "bottom"] = ny + "px";
		Drag.obj.lastMouseX	= ex;
		Drag.obj.lastMouseY	= ey;

		Drag.obj.root.onDrag(nx, ny);
		return false;
	},

	end : function()
	{
		
		document.onmousemove = null;
		document.onmouseup   = null;
		Drag.obj.root.onDragEnd(	parseInt(Drag.obj.root.style[Drag.obj.hmode ? "left" : "right"]), 
									parseInt(Drag.obj.root.style[Drag.obj.vmode ? "top" : "bottom"]));
		//////
		Drag.obj = null;
	},

	fixE : function(e)
	{
		if (typeof e == 'undefined') e = window.event;
		if (typeof e.layerX == 'undefined') e.layerX = e.offsetX;
		if (typeof e.layerY == 'undefined') e.layerY = e.offsetY;
		return e;
	}
};
function set_div_position(div_id){//overflow yani scroll kullanılmak istenen yerlerde bligisayarın çözünürlüğüne göre divin boyutunun otomatik olarak ayarlamak için kullanılır.
	document.getElementById(div_id).style.width = window.screen.width-50;
}


function ReplaceAll(Source,stringToFind,stringToReplace){
  var temp = Source;
  var index = temp.indexOf(stringToFind);
        while(index != -1){
            temp = temp.replace(stringToFind,stringToReplace);
            index = temp.indexOf(stringToFind);
        }
        return temp;
}

function add_sequential_string(deger)
{
	//string ifadelerdeki ilk rakamı bulup 1 ekler. created MER 20091001
	var elde =0;
	var sonuc = '';
	var i_sonuc = 0;
	for(ki=deger.length-1;ki>=0;ki--)
	{
		var i_deger = parseInt(deger.substr(ki,1));//her elemanı tek tek alıyoruz..
		if(i_deger >= 0 && i_deger <= 9 && elde > -1)
		{//eleman sayısal ise ve elde işlemi yani önceki elemanlar için bir toplam işlemi yapılmadı ise..
			i_sonuc = parseInt(i_deger)+1;//ara işlem sonucu olarak elemanı 1 ile topluyoruz..
			//ara işlem sonucumuz  0 dan büyük ise (9+1 = 10) 
			//&& ve ana değerimizdeki şu andaki index'in 1 öncesi sayısal ise  toplam işlemi yapılmış olduğunu elde değişkenine 1 atark tutucaz. (T029 daki  örnekte 2'ye bakıyoruz.... )
			if(i_sonuc>9 && (deger.substr(ki-1,1)  >= 0 && deger.substr(ki-1,1) <= 9))
			{
				elde = 1;
				i_sonuc = 0;
			}
			else
				elde = -1;
			sonuc = i_sonuc + sonuc;//ifademizi string olarak birleştiriyoruz...
		}
		else
		{
			sonuc=deger.substr(ki,1)+sonuc;//eğer sayısal bir ifade değilse sonuc string ifadesi ile birleştiriyoruz.
		} 
	}
	if(elde == 0)//bu kısım sadece metin karakterlerinden oluşan degerler için eklendi Örn: ABC  gibi bir değer gelirse ABC1 yapıyoruz..
		sonuc = deger+1 
	else if(elde == 1 && i_deger == 9)//9VA gibi yada 9 veya 99 gibi bir değer girildiğinde en son eleman olan 9 üzerinde bir toplam işlemi yapılmış fakat elde işlemi sonuca uygulanamamış oluyordu bu durumu için yazıldı..
		sonuc = 1+sonuc;
	return sonuc;
}

function isIBAN(nesne,length) 
{
	/* 
    * Bir hesap numrasının gecerli IBAN formatında olup olmadını kontrol eder. 
    * "Registration Authority for ISO 13616" dökümanı doğrultusunda yazılmıştur. 
    * NOT: 
    * IBAN numarası en az 5 en fazla 34 karakter olabilir.
	* Türkiye icin IBAN numaraları 26 karakterdir 
	* Barbaros Kuz 20100615
	*/
	
	var iban=nesne.value;
	if (iban.length < 5 || iban.length >34) 
	{ 
		alert ('IBAN Numarası 5 Karakterden Küçük, 34 Karakterden Büyük Olamaz.'); 
		return false; 
	} 
	
	//Eger IBAN kodu TR ile basliyorsa uzunluk kontrolu olmalı
	if(iban.substr(0,2) == 'TR' && iban.length != 26)
	{ 
		alert ('TR ile Başlayan IBAN Numarası 26 Karakter Olmalıdır.'); 
		return false; 
	} 	
	
	var karakter1 = iban.charCodeAt(0);
	var karakter2 = iban.charCodeAt(1);
	var karakter3 = iban.charCodeAt(2);
	var karakter4 = iban.charCodeAt(3);
	
	// ilk iki karakter yalnızca buyuk harf olabilir
	if (!(65 <= karakter1 && karakter1 <= 90) || !(65 <= karakter2 && karakter2 <= 90)) 
	{
		alert('IBAN Numarasında 1. ve 2. Karakterler Büyük Harf Olmalıdır !');
		return false; 
	} 
	
	// 3 ve 4 karakter yalnizca rakam olabilir
	if (!(48 <= karakter3 && karakter3 <= 57) || !(48 <= karakter4 && karakter4 <= 57)) 
	{
		alert('IBAN Numarasında 3. ve 4. Karakterler Rakam Olmalıdır !'); 
		return false; 
	}
	
	new_iban = iban.substring(4) + iban.substring(0, 4); 
	for (i = 0, r = 0; i < new_iban.length; i++ ) 
	{ 
		karakter = new_iban.charCodeAt(i); 
		if (48 <= karakter && karakter <= 57) 
			k = karakter - 48; 
		else if (65 <= karakter && karakter <= 90) 
			k = karakter - 55; 
		else
		{ 
			alert('IBAN Numarası Sadece Rakam ve Büyük Harf Olmalıdır !'); 
			return false; 
		} 
		
		if (k > 9) 
			r = (100 * r + k) % 97; 
		else 
			r = (10 * r + k) % 97; 
	} 
	
	if (r != 1) 
	{ 
		alert('IBAN Numarası Geçersizdir.'); 
		return false; 
	}
	return true;
}

function isTCNUMBER(nesne)
{
	/* 
    * Girilen TC Kimlik Numarasinin gecerli TC Kimlik Numarasi olup olmadını kontrol eder. 
    * NOT: 
    * TC Kimlik Numarasi 11 karakter olmalidir.
	* Levent Saatci 20100620
	*/
	
	var sum_ten=0,odd_numbers=0,even_numbers=0;
	var tc_id_no = nesne.value;

	// TC Kimlik No 11 karakter olmalidir
	if(tc_id_no.length != 11) 
	{
		alert("TC Kimlik Numarasi 11 Karakter Olmalidir !");
		return false;
	}
	
	// ilk karakter sifir ile baslayamaz
	if(tc_id_no.substr(0,1) ==0)	
	{
		alert("TC Kimlik Numarasinin İlk Karakteri 0 Olamaz !");
		return false;
	}		
		
	// tek basamakların toplami 1,3,5,7,9
	even_numbers = parseInt(tc_id_no.substr(0,1)) + parseInt(tc_id_no.substr(2,1)) + parseInt(tc_id_no.substr(4,1)) + parseInt(tc_id_no.substr(6,1)) + parseInt(tc_id_no.substr(8,1));
	// cift basamakların toplami 2,4,6,8 (10 haric)
	odd_numbers = parseInt(tc_id_no.substr(1,1)) + parseInt(tc_id_no.substr(3,1)) + parseInt(tc_id_no.substr(5,1)) + parseInt(tc_id_no.substr(7,1)); 
	// ilk 10 basamak toplami
	sum_ten = even_numbers + odd_numbers + parseInt(tc_id_no.substr(9,1)); 
	
	// - 10. rakam,tek basamaklarin toplaminin 7 katı ile cift basamaklarin toplaminin mod 10 una esit olmalidir.Buradaki +20 işlemi negatif değere düşmesin diye eklenmiştir.
	// - 11 basamak ilk 10 basamagin toplamına esit olamalidir. 
	if(((even_numbers*7-odd_numbers)+20)%10 != tc_id_no.substr(9,1) || sum_ten%10 != tc_id_no.substr(10,1))	
	{
		alert("TC Kimlik Numarasini Yeniden Giriniz !");
		return false;
	}

	return true;
}

function wrk_form_set_js(form_name,form_object,form_object_value,form_object_type)
{//TS2008 fonksiyon sayesinde form adı(yollanmak zorunda değil),nesne,nesneye atılacak deger vede nesne tipi yollanırsa formadaki alanlara degerler doldurulur
	if(form_object_type!=undefined && list_len(form_object_type,',')) var type_control=1; else var type_control=0;
	object='document.getElementById(obj_name)';
	for(var frm_ind=1;frm_ind <= list_len(form_object,',');frm_ind++)
	{
		obj_name=list_getat(form_object,frm_ind,',');
		obj_value=list_getat(form_object_value,frm_ind,',');
		if(type_control && list_getat(form_object_type,frm_ind,',')!=undefined)
		    {
		      if(form_name!=undefined && form_name!='')
			     eval(form_name+'.'+obj_name).checked = true;
			  else
			     eval(object).checked= true;
		    }
		 else
		   {
		     if(form_name!=undefined && form_name!='')
			     eval(form_name+'.'+obj_name).value = obj_value;
		     else
		          eval(object).value=obj_value;
		    }
	}  
 } 
 
function add_speed_basket(type,unique_id,quantity)
{
	
	adress_ = 'index.cfm?fuseaction=objects.emptypopup_add_speed_basket';
	if(type == '0')
		adress_ = adress_ + '&product_id=' + unique_id;
	else
		adress_ = adress_ + '&stock_id=' + unique_id;
	
	adress_ = adress_ + '&quantity=' + quantity;
	AjaxPageLoad(adress_,'speed_basket_working',1,'Sepete Ekleniyor!');
}

function show_hide_widget_ekle(obj)
{
	var widget = document.getElementById("widget");								
	var left = AutoComplete_GetLeft(obj);
	var top = AutoComplete_GetTop(obj);
	widget.style.position = "absolute";
	widget.style.left = left + "px";
	widget.style.top = top + 19 + "px";
	widget.style.width = '250';
	//widget.style.height = '150';
	show_hide('widget');
}
function onScrollPassive(){
	document.onmouseup= null;
	document.onmousemove = null;
}

function refresh_box(box_id,box_page,box_drag)
{
	var body_div_ = 'body_' + box_id;
	var home_div_ = 'homebox_' + box_id;
	show(body_div_);
	if(box_drag == 1)
		AjaxPageLoad('index.cfm?fuseaction=myhome.emptypopup_menu_positions&islem=close&isClose=0&panelName=' + home_div_,'sonuc',1);	
	
	AjaxPageLoad(box_page,body_div_,1);
}

function show_hide_box(box_id,box_page,box_drag,this_fuseact)
{
	var body_div_ = 'body_' + box_id;
	var action_div_ = 'action_' + box_id;
	var home_div_ = 'homebox_' + box_id;
	show_hide(body_div_);
	
	if(document.getElementById(body_div_).style.display == '' || document.getElementById(body_div_).style.display == 'block')
		load_info_ = 0;
	else
		load_info_ = 1;
	
	adress_ = 'index.cfm?fuseaction=objects.xml_setting_personality';
	adress_ += '&bid=' + box_id;
	adress_ += '&fuse=' + this_fuseact;
	adress_ += '&action_name=unload_body';
	adress_ += '&action_value=' + load_info_;
	AjaxPageLoad(adress_,action_div_);
	
	if(box_drag == 1)
		{
		var box = document.getElementById(body_div_);
		if (box.style.display=='none')
			AjaxPageLoad('index.cfm?fuseaction=myhome.emptypopup_menu_positions&islem=close&isClose=1&panelName=' + home_div_,'sonuc',1);
		else
			AjaxPageLoad('index.cfm?fuseaction=myhome.emptypopup_menu_positions&islem=close&isClose=0&panelName=' + home_div_,'sonuc',1);
		}
		
	if(box_page != '')
		{
			var box = document.getElementById(body_div_);	
			if(box.style.display=='none')
				{
				//hicbir islem yapma
				}
			else
				{
				AjaxPageLoad(box_page,body_div_);
				}
		}
}

function show_hide_big_list(box_id,this_fuseact)
{
	var body_div_ = box_id + '_search_div';
	var action_div_ = 'action_' + box_id;
	//show_hide(body_div_);
	
	if(document.getElementById(body_div_).style.display == '' || document.getElementById(body_div_).style.display == 'block')
		load_info_ = 0;
	else
		load_info_ = 1;
	
	adress_ = 'index.cfm?fuseaction=objects.xml_setting_personality';
	adress_ += '&bid=' + box_id;
	adress_ += '&fuse=' + this_fuseact;
	adress_ += '&action_name=unload_body';
	adress_ += '&action_value=' + load_info_;
	AjaxPageLoad(adress_,action_div_);
}

function show_hide_medium_list(box_id,this_fuseact)
{
	var body_div_ = box_id + '_search_div';
	var action_div_ = 'action_' + box_id;
	//show_hide(body_div_);
	
	if(document.getElementById(body_div_).style.display == '' || document.getElementById(body_div_).style.display == 'block')
		load_info_ = 0;
	else
		load_info_ = 1;
	
	adress_ = 'index.cfm?fuseaction=objects.xml_setting_personality';
	adress_ += '&bid=' + box_id;
	adress_ += '&fuse=' + this_fuseact;
	adress_ += '&action_name=unload_body';
	adress_ += '&action_value=' + load_info_;
	AjaxPageLoad(adress_,action_div_);
}

function body_frame_main_height_control()
{
	try
	{
		if(document.getElementById("spry_menu_height_control") && document.getElementById("footer_height_control")){
			document.getElementById("body_frame_main").style.minHeight =  (document.body.offsetHeight - parseInt(parseInt(document.getElementById("spry_menu_height_control").style.height.substr(0,2)) + parseInt(document.getElementById("footer_height_control").style.height.substr(0,2)))) + "px";
			}
		if(document.getElementById("body_frame_left_menu")&& document.getElementById("spry_menu_height_control") && document.getElementById("footer_height_control")){
			document.getElementById("body_frame_left_menu").style.minHeight =  (document.body.offsetHeight - parseInt(parseInt(document.getElementById("spry_menu_height_control").style.height.substr(0,2)) + parseInt(document.getElementById("footer_height_control").style.height.substr(0,2)) + parseInt(document.getElementById("body_frame_header").style.height.substr(0,2)))) + "px";
			document.getElementById("after_click_gizle").style.minHeight = document.getElementById("body_frame_left_menu").style.minHeight;
			document.getElementById("body_frame_left_menu").style.height =  document.getElementById("body_frame_main").offsetHeight - 25 + "px";
			document.getElementById("after_click_gizle").style.height = document.getElementById("body_frame_left_menu").style.height;
		}
	}
	catch (e)
	{
	// Internet Explorer		
	}
}

function body_frame_main_height_control2()
{
	try
	{
		if(document.getElementById("spry_menu_height_control") && document.getElementById("footer_height_control")){
			document.getElementById("body_frame_main").style.minHeight =  (document.body.offsetHeight - parseInt(parseInt(document.getElementById("spry_menu_height_control").style.height.substr(0,2)) + parseInt(document.getElementById("footer_height_control").style.height.substr(0,2)))) + "px";
/*			alert(document.getElementById("body_frame_main").offsetHeight+" height");*/
			}
		if(document.getElementById("body_frame_left_menu")&& document.getElementById("spry_menu_height_control") && document.getElementById("footer_height_control")){
			document.getElementById("body_frame_left_menu").style.minHeight =  (document.body.offsetHeight - parseInt(parseInt(document.getElementById("spry_menu_height_control").style.height.substr(0,2)) + parseInt(document.getElementById("footer_height_control").style.height.substr(0,2)) + parseInt(document.getElementById("body_frame_header").style.height.substr(0,2)))) + "px";
			document.getElementById("after_click_gizle").style.minHeight = document.getElementById("body_frame_left_menu").style.minHeight;
/*			var D = document;
			document.getElementById("body_frame_left_menu").style.height = Math.max(Math.max(D.body.scrollHeight, D.documentElement.scrollHeight),Math.max(D.body.offsetHeight, D.documentElement.offsetHeight),Math.max(D.body.clientHeight, D.documentElement.clientHeight))-25 + "px";*/
/*			document.getElementById("body_frame_left_menu").style.height =  document.getElementById("body_frame_main").offsetHeight - 25;*/
			document.getElementById("after_click_gizle").style.height = document.getElementById("body_frame_left_menu").style.height;
		}
	}
	catch (e)
	{
	// Internet Explorer		
	}
}

function body_frame_main_popup_height_control()
{
	try
	{
		document.getElementById("body_frame_main_popup").style.minHeight =  document.body.offsetHeight + "px";
	}
	catch (e)
	{
	// Internet Explorer
	}	
}

function body_frame_main_width_control()
{
	 try
	 {
		document.getElementById("body_frame_main").style.width =  (document.body.offsetWidth) + "px";
		if(document.getElementById("body_frame_left_menu"))
			document.getElementById("body_frame_content_menu").style.width = document.body.offsetWidth - 150 + "px";
   	 }
	 catch (e)
	{
	// Internet Explorer
	}
}

function body_frame_main_popup_width_control()
{
	try
	{
		document.getElementById("body_frame_main_popup").style.width =  (document.body.offsetWidth) + "px";
	}
	 catch (e)
	{
	// Internet Explorer
	}	
}

function control_account_process(action_id,action_type_id)
{
	param_list=action_id+'*'+action_type_id;
	control_acc_process = wrk_safe_query('acc_control_account_process','dsn2',0,param_list);
	if(control_acc_process.recordcount)
	{
		alert("Güncellediğiniz Belge İle İlişkili Birleştirilmiş Fiş Bulunmaktadır. Belgeyi Güncelleyemez ya da Silemezsiniz.");
		return false;
	}
	else
	{
		//fbs 20120302 burasi kapatilmisti actim sorun oluyor ozellikle silme fonksiyonlarinda
		return true;
	}
}

function send_online_emp_message(employee_id)
	{
		windowopen('index.cfm?fuseaction=objects.popup_message&employee_id='+employee_id,'medium');	
	}
function send_online_partner_message(partner_id)
	{
		windowopen('index.cfm?fuseaction=objects.popup_message&partner_id='+partner_id,'medium');	
	}
function send_online_consumer_message(consumer_id)
	{
		windowopen('index.cfm?fuseaction=objects.popup_message&consumer_id='+consumer_id,'medium');	
	}
function send_online_emp_note(employee_id)
	{
		windowopen('index.cfm?fuseaction=objects.popup_add_nott&employee_id='+employee_id,'small');	
	}	

function get_wrk_message_div(message_header,message_body,file)
{
	if(arguments[2]!=null)
	{
		document.getElementById("message_div_main").style.top = (document.body.offsetHeight-120)/2 + "px";
		document.getElementById("message_div_main").style.left = (document.body.offsetWidth-400)/2 + "px";
		document.getElementById("message_div_main").style.zIndex = 99999;
		goster(message_div_main);
		gizle(working_div_main);
		document.getElementById("message_div_main_header_info").innerHTML = message_header;
		if(message_body == 'PDF')
			target = 'blank';	
		else
			target = '_self';
		document.getElementById("message_div_main_body").style.borderStyle = 'none';
		document.getElementById("message_div_main_body").innerHTML = '<br />'+file_type_download+':'; // file_type_download:special_functions'ın içinden geliyor. Dosya Türü yazısını getirmektedir.Genel bir kelime olduğu için farklı farklı alanlardan çağrılabilir.
		document.getElementById("message_div_main_body").innerHTML += '<b>' + message_body + '</b><br /><br />';
		document.getElementById("message_div_main_body").innerHTML += '<a href="' + file + '" target="'+ target +'" onclick="gizle(message_div_main);" class="tableyazi"><img src="/images/digital_asset.png" border="0" title="'+message_header+'" /></a>';
		document.getElementById('message_div_main_body').innerHTML += '<a href="javascript://" onclick="open_save_popup(\''+ file +'\');" class="tableyazi"><img src="/images/digital_asset_save.png" width="45" height="45" border="0" title="'+save_to_my_computer+'"></a>';

	}
	else
	{
		document.getElementById("working_div_main").style.top = (document.body.offsetHeight-120)/2 + "px";
		document.getElementById("working_div_main").style.left = (document.body.offsetWidth-400)/2 + "px";
		document.getElementById("working_div_main").style.zIndex = 99999;
		goster(working_div_main);
		gizle(message_div_main);
		document.getElementById("working_div_main_body").innerHTML = message_body;
		document.getElementById("working_div_main_body").innerHTML += ''; // eski sürüm browserlarda üstteki imaj görünmüyordu onun için eklendi.
	}
}

function open_save_popup(asset_file)
{
	windowopen('index.cfm?fuseaction=objects.popup_save_asset_file&asset_file=' + asset_file,'small');
}

function colorPicker_callBack(strColor) 
{
	//document.bgColor = strColor;
	eval("document." + my_form_ + "." + my_son_isim).value = strColor;
}
function workWarning()
{
	alert('Şuan yanlış yerden iş kaydı yapmaya çalışıyorsunuz.\n Lütfen iş kaydını ilgili sayfasında yapınız!');
}
function chan_css_design(css_id)
{
	AjaxPageLoad('index.cfm?fuseaction=myhome.emptypopup_settings_process&design_color='+css_id,'css_change_info',1);
	try{//flash renklerini degistirmek icin lütfen silmeyelim FA.
	getCSSColors();
	}
	catch(e){
	}
}