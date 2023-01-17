<cfquery name="GET_ALL_FAVORITES" datasource="#DSN#">
	SELECT * FROM FAVORITES WHERE EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
</cfquery>
<cfif isdefined("attributes.act") and not len(attributes.act)>
	<cfset attributes.act = "home.welcome">
</cfif>
<cfset url_chars_list = '%,/,\,-,?'>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='57424.Sık Kullanılanlar'></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box title="#message#" popup_box="1">
<cfform action="#request.self#?fuseaction=myhome.add_favorites" name="send" method="post">
	<cfoutput>
        <cfif not isdefined("attributes.upd")>
            <cf_box_elements vertical="1">
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
					<div class="form-group">
						<label><cf_get_lang dictionary_id='30972.Sayfa Tanımı'>*</label>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='30939.Sayfa Tanımı Girmelisiniz'>!</cfsavecontent>
						<cfinput type="text" required="yes" message="#message#" name="FAVORITE_NAME" id="FAVORITE_NAME" maxlength="20">		
					</div>
					<div class="form-group">
						<label><cf_get_lang dictionary_id ='31506.Kısayol'> CTRL + SHIFT +</label>
						<cfinput type="text" name="FAVORITE_SHORTCUT_KEY" id="FAVORITE_SHORTCUT_KEY" maxlength="1">
					</div>
					<div class="form-group">
						<label><cf_get_lang dictionary_id ='31507.Yeni Pencerede Açılsın'><cfinput type="checkbox" name="IS_NEW_PAGE" id="IS_NEW_PAGE" maxlength="1"></label>
						<cfinput type="hidden" name="IS_NEW_PAGE_" maxlength="1">
					</div>
					<div class="form-group">
						<label><cf_get_lang dictionary_id='30973.Bağlantı Yolu'>*</label>
						<cfif not isdefined('attributes.act')>
							<div style="width:400px; height:auto; overflow:auto;">#CGI.HTTP_REFERER#</div>
							<cfset fuseAll = ''>
							<cfif use_https eq 1>
								<cfset fuseAll = Replace(CGI.HTTP_REFERER,'https://#employee_url#/#request.self#?fuseaction=','')>
							<cfelse>
								<cfset fuseAll = Replace(CGI.HTTP_REFERER,'http://#employee_url#/#request.self#?fuseaction=','')>
							</cfif>
							<input id="FAVORITE" type="hidden" name="FAVORITE" value="#fuseAll#">
						<cfelse> 
							<input type="text" id="connection_way" name="connection_way" value="http://#cgi.SERVER_NAME#/#request.self#?fuseaction=#urlDecode(attributes.act)#" required>
							<input type="hidden" name="FAVORITE" id="FAVORITE"  value="#attributes.act#">
						</cfif>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer><cf_workcube_buttons is_upd='0' add_function='kontrol()'></cf_box_footer>
        <cfelse>
            <cfquery name="GET_DET" datasource="#DSN#">
				SELECT * FROM FAVORITES WHERE FAVORITE_ID = #attributes.upd#
			</cfquery>
			<cf_box_elements vertical="1">
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
					<div class="form-group">
						<label><cf_get_lang dictionary_id='30972.Sayfa Tanımı'>*</label>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='30939.Sayfa Tanımı Girmelisiniz !'></cfsavecontent>
						<cfinput type="text" required="yes" message="#message#" name="FAVORITE_NAME" value="#get_det.FAVORITE_NAME#" maxlength="20">
					</div>
					<div class="form-group">
						<label><cf_get_lang dictionary_id ='31506.Kısayol'> CTRL + SHIFT +</label>
						<cfinput type="text" name="FAVORITE_SHORTCUT_KEY" maxlength="1">
					</div>
					<div class="form-group">
						<label><cf_get_lang dictionary_id ='31507.Yeni Pencerede Açılsın'><cfinput type="checkbox" name="IS_NEW_PAGE" maxlength="5"></label>
                        <cfinput type="hidden" name="IS_NEW_PAGE_" maxlength="1">
					</div>
					<div class="form-group">
						<label><cf_get_lang dictionary_id='30973.Bağlantı Yolu'>*</label>
						<input type="text" id="connection_way" name="connection_way" value="http://#cgi.SERVER_NAME#/#request.self#?fuseaction=#GET_DET.FAVORITE#" required>
						<input type="hidden" value="#attributes.upd#" name="UPD" id="UPD">
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer><cf_workcube_buttons is_delete="0" is_upd='1' add_function='kontrol2()'></cf_box_footer>
        </cfif>
	</cfoutput> 
</cfform>
</cf_box>
</div>
<script type="text/javascript">
	var reserve_chars_for_all_browser = 'B,G,I,P,T';
	var reserve_chars_for_chrome_and_ie = 'D,N';
	var reserve_chars_for_chrome_and_moz = 'J,R,W,Q';
	var reserve_chars_for_ie_and_moz = 'H,K,L';
	var reserve_chars_for_chrome = 'C,O';
	var reserve_chars_for_moz = 'A,E,M,S';
	
	var alert_ = "<cf_get_lang dictionary_id ='29686.Seçmiş Olduğunuz Kısayol Tuşu Aşağıdaki Tarayıcıların Standart Tuşları Arasındadır Bu Şekilde Seçilmesi Durumunda Sorun Yaşayabilirsiniz Devam Etmek İstiyor Musunuz?'>\n";
	var alert_all = alert_+'- '+'<cf_get_lang dictionary_id ="30052.Chrome">'+'\n'+'- '+'<cf_get_lang dictionary_id ="30053.Internet Explorer">'+'\n'+'- '+'<cf_get_lang dictionary_id ="30054.Mozilla">';
	var alert_c_i = alert_+'- '+'<cf_get_lang dictionary_id ="30052.Chrome">'+'\n'+'- '+'<cf_get_lang dictionary_id ="30053.Internet Explorer">';
	var alert_c_m = alert_+'- '+'<cf_get_lang dictionary_id ="30052.Chrome">'+'\n'+'- '+'<cf_get_lang dictionary_id ="30054.Mozilla">';
	var alert_c = alert_+'- '+'<cf_get_lang dictionary_id ="30052.Chrome">';
	var alert_m = alert_+'- '+'<cf_get_lang dictionary_id ="30054.Mozilla">';
	
	function kontrol2()//güncelle kontrolü
	{
		if($('#connection_way').val() == ''){ 
			alert("<cf_get_lang dictionary_id='30973.Bağlantı Yolu'>!");
			return false;
		}
		if($("input[name='FAVORITE_NAME']").val() == ''){ 
			alert("<cf_get_lang dictionary_id='30939.Sayfa Tanımı Girmelisiniz !'>!");
			return false;
		}
		if(list_find(reserve_chars_for_all_browser,document.getElementById('FAVORITE_SHORTCUT_KEY').value.toUpperCase(),','))
		{
			if(confirm(alert_all))
				return true;
			else
				return false;
		}
		else if(list_find(reserve_chars_for_chrome_and_ie,document.getElementById('FAVORITE_SHORTCUT_KEY').value.toUpperCase(),','))
		{
			if(confirm(alert_c_i))
				return true;
			else
				return false;
		}
		else if(list_find(reserve_chars_for_chrome_and_moz,document.getElementById('FAVORITE_SHORTCUT_KEY').value.toUpperCase(),','))
		{
			if(confirm(alert_c_m))
				return true;
			else
				return false;
		}
		else if(list_find(reserve_chars_for_ie_and_moz,document.getElementById('FAVORITE_SHORTCUT_KEY').value.toUpperCase(),','))
		{
			if(confirm(alert_i_m))
				return true;
			else
				return false;
		}
		else if(list_find(reserve_chars_for_chrome,document.getElementById('FAVORITE_SHORTCUT_KEY').value.toUpperCase(),','))
		{
			if(confirm(alert_c))
				return true;
			else
				return false;
		}
		else if(list_find(reserve_chars_for_moz,document.getElementById('FAVORITE_SHORTCUT_KEY').value.toUpperCase(),','))
		{
			if(confirm(alert_m))
				return true;
			else
				return false;
		}
		document.getElementById('FAVORITE_SHORTCUT_KEY').value = document.getElementById('FAVORITE_SHORTCUT_KEY').value.toUpperCase();
		<cfif isdefined('attributes.upd')>
			<cfoutput query="get_all_favorites">
			
			if(document.getElementById('FAVORITE_NAME').value == '#FAVORITE_NAME#' && #FAVORITE_ID# != #attributes.upd#)
			{
				alert("<cf_get_lang dictionary_id ='31510.Sayfa Tanımı Daha Önce Girilmiş'>");
				return false;
			}
			else if('#FAVORITE_SHORTCUT_KEY#' != '' &&  #FAVORITE_ID# == #attributes.upd# )
			{
			 if(document.getElementById('FAVORITE_SHORTCUT_KEY').value == '#FAVORITE_SHORTCUT_KEY#' && #FAVORITE_ID# != #attributes.upd#)
			   {
				alert("<cf_get_lang dictionary_id ='31508.Kısayol Daha Önce Farklı Bir Kayıt İçin Girilmiş'>");
				return false;
			   }
			 }
			</cfoutput>		
		</cfif>
		switch (document.getElementById('FAVORITE_SHORTCUT_KEY').value)
		{
			case 'ü':{alert("<cf_get_lang dictionary_id ='31777.Lütfen Kısayol Tuşunu Türkçe Karakter Belirlemeyiniz'>");return false;break;}
			case 'Ü':{alert("<cf_get_lang dictionary_id ='31777.Lütfen Kısayol Tuşunu Türkçe Karakter Belirlemeyiniz'>");return false;break;}
			case 'ğ':{alert("<cf_get_lang dictionary_id ='31777.Lütfen Kısayol Tuşunu Türkçe Karakter Belirlemeyiniz'>");return false;break;}
			case 'Ğ':{alert("<cf_get_lang dictionary_id ='31777.Lütfen Kısayol Tuşunu Türkçe Karakter Belirlemeyiniz'>");return false;break;}
			case 'ş':{alert("<cf_get_lang dictionary_id ='31777.Lütfen Kısayol Tuşunu Türkçe Karakter Belirlemeyiniz'>");return false;break;}
			case 'Ş':{alert("<cf_get_lang dictionary_id ='31777.Lütfen Kısayol Tuşunu Türkçe Karakter Belirlemeyiniz'>");return false;break;}
			case 'ç':{alert("<cf_get_lang dictionary_id ='31777.Lütfen Kısayol Tuşunu Türkçe Karakter Belirlemeyiniz'>");return false;break;}
			case 'Ç':{alert("<cf_get_lang dictionary_id ='31777.Lütfen Kısayol Tuşunu Türkçe Karakter Belirlemeyiniz'>");return false;break;}
			case 'ı':{alert("<cf_get_lang dictionary_id ='31777.Lütfen Kısayol Tuşunu Türkçe Karakter Belirlemeyiniz'>");return false;break;}
			case 'İ':{alert("<cf_get_lang dictionary_id ='31777.Lütfen Kısayol Tuşunu Türkçe Karakter Belirlemeyiniz'>");return false;break;}			
		}
		
		if (document.getElementById('IS_NEW_PAGE').checked)  
			document.getElementById('IS_NEW_PAGE_').value="1";
		else
			document.getElementById('IS_NEW_PAGE_').value="0";	
		return true;
	}
	function kontrol()//yeni ekleme kontrolü
	{
		if($('#connection_way').val() == ''){ 
			alert("<cf_get_lang dictionary_id='30973.Bağlantı Yolu'>!");
			return false;
		}
		if($("input[name='FAVORITE_NAME']").val() == ''){ 
			alert("<cf_get_lang dictionary_id='30939.Sayfa Tanımı Girmelisiniz !'>!");
			return false;
		}
		if(list_find(reserve_chars_for_all_browser,document.getElementById('FAVORITE_SHORTCUT_KEY').value.toUpperCase(),','))
		{
			if(confirm(alert_all))
				return true;
			else
				return false;
		}
		else if(list_find(reserve_chars_for_chrome_and_ie,document.getElementById('FAVORITE_SHORTCUT_KEY').value.toUpperCase(),','))
		{
			if(confirm(alert_c_i))
				return true;
			else
				return false;
		}
		else if(list_find(reserve_chars_for_chrome_and_moz,document.getElementById('FAVORITE_SHORTCUT_KEY').value.toUpperCase(),','))
		{
			if(confirm(alert_c_m))
				return true;
			else
				return false;
		}
		else if(list_find(reserve_chars_for_ie_and_moz,document.getElementById('FAVORITE_SHORTCUT_KEY').value.toUpperCase(),','))
		{
			if(confirm(alert_i_m))
				return true;
			else
				return false;
		}
		else if(list_find(reserve_chars_for_chrome,document.getElementById('FAVORITE_SHORTCUT_KEY').value.toUpperCase(),','))
		{
			if(confirm(alert_c))
				return true;
			else
				return false;
		}
		else if(list_find(reserve_chars_for_moz,document.getElementById('FAVORITE_SHORTCUT_KEY').value.toUpperCase(),','))
		{
			if(confirm(alert_m))
				return true;
			else
				return false;
		}
		
		<cfif isdefined("attributes.act") and attributes.act contains '%/'>
			<cfset attributes.act = Replace(attributes.act,'%/','%25%2F','all')>
		</cfif>
		<cfif isdefined("attributes.act") and attributes.act contains '/'>
			<cfset attributes.act = Replace(attributes.act,'/','%2F','all')>
		</cfif>
		<cfif isdefined("attributes.act") and attributes.act contains '\'>
			<cfset attributes.act = Replace(attributes.act,'\','%5C','all')>
		</cfif>
		<cfif isdefined("attributes.act") and attributes.act contains '-'>
			<cfset attributes.act = Replace(attributes.act,'-','%2D','all')>
		</cfif>
		<cfif isdefined("attributes.act") and attributes.act contains '?'>
			<cfset attributes.act = Replace(attributes.act,'?','%3F','all')>
		</cfif>
		<cfif isdefined("attributes.act") and attributes.act contains '%&'>
			<cfset attributes.act = Replace(attributes.act,'%&','%25&','all')>
		</cfif>
		<cfif isdefined("attributes.act") and attributes.act contains '"'>
			<cfset attributes.act = Replace(attributes.act,'"',"%22",'all')>
		</cfif>
		<cfif isdefined("attributes.act") and attributes.act contains '&&'>
			<cfset attributes.act = Replace(attributes.act,'&&','%26&','all')>
		</cfif>
		<!--- <cfif isdefined("attributes.act")>
			document.getElementById('FAVORITE').value = '<cfoutput>#attributes.act#</cfoutput>';
		</cfif> --->
		document.getElementById('FAVORITE_SHORTCUT_KEY').value = document.getElementById('FAVORITE_SHORTCUT_KEY').value.toUpperCase();	
		<cfoutput query="get_all_favorites">
			
			if(document.getElementById('FAVORITE_NAME').value == '#FAVORITE_NAME#' )
			{ 
				alert("<cf_get_lang dictionary_id ='31510.Sayfa Tanımı Daha Önce Girilmiş'>");		
				return false;
			}
		   else if('#FAVORITE_SHORTCUT_KEY#' != '')
		  {
				if(document.getElementById('FAVORITE_SHORTCUT_KEY').value == '#FAVORITE_SHORTCUT_KEY#')
			{    
				alert("<cf_get_lang dictionary_id ='31508.Kısayol Daha Önce Farklı Bir Kayıt İçin Girilmiş'>");
				return false;
			}	
		 }		
		</cfoutput>
		
		switch (document.getElementById('FAVORITE_SHORTCUT_KEY').value)
		{
			case 'ü':{alert("<cf_get_lang dictionary_id ='31777.Lütfen Kısayol Tuşunu Türkçe Karakter Belirlemeyiniz'>");return false;break;}
			case 'Ü':{alert("<cf_get_lang dictionary_id ='31777.Lütfen Kısayol Tuşunu Türkçe Karakter Belirlemeyiniz'>");return false;break;}
			case 'ğ':{alert("<cf_get_lang dictionary_id ='31777.Lütfen Kısayol Tuşunu Türkçe Karakter Belirlemeyiniz'>");return false;break;}
			case 'Ğ':{alert("<cf_get_lang dictionary_id ='31777.Lütfen Kısayol Tuşunu Türkçe Karakter Belirlemeyiniz'>");return false;break;}
			case 'ş':{alert("<cf_get_lang dictionary_id ='31777.Lütfen Kısayol Tuşunu Türkçe Karakter Belirlemeyiniz'>");return false;break;}
			case 'Ş':{alert("<cf_get_lang dictionary_id ='31777.Lütfen Kısayol Tuşunu Türkçe Karakter Belirlemeyiniz'>");return false;break;}
			case 'ç':{alert("<cf_get_lang dictionary_id ='31777.Lütfen Kısayol Tuşunu Türkçe Karakter Belirlemeyiniz'>");return false;break;}
			case 'Ç':{alert("<cf_get_lang dictionary_id ='31777.Lütfen Kısayol Tuşunu Türkçe Karakter Belirlemeyiniz'>");return false;break;}
			case 'ı':{alert("<cf_get_lang dictionary_id ='31777.Lütfen Kısayol Tuşunu Türkçe Karakter Belirlemeyiniz'>");return false;break;}
			case 'İ':{alert("<cf_get_lang dictionary_id ='31777.Lütfen Kısayol Tuşunu Türkçe Karakter Belirlemeyiniz'>");return false;break;}
			case 'ö':{alert("<cf_get_lang dictionary_id ='31777.Lütfen Kısayol Tuşunu Türkçe Karakter Belirlemeyiniz'>");return false;break;}
			case 'Ö':{alert("<cf_get_lang dictionary_id ='31777.Lütfen Kısayol Tuşunu Türkçe Karakter Belirlemeyiniz'>");return false;break;}			
		}
		if (document.getElementById('IS_NEW_PAGE').checked)  
			document.getElementById('IS_NEW_PAGE_').value="1";
		else
			document.getElementById('IS_NEW_PAGE_').value="0";
		return true;
	}
</script>	  
