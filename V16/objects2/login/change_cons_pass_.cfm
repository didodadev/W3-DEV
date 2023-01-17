<cf_get_lang_set module_name="objects2"><!--- sayfanin en altinda kapanisi var --->
<cfif isdefined('session.pp.userid')>
	<cfquery name="GET_USERNAME" datasource="#DSN#">
		SELECT
			PARTNER_ID,
			MEMBER_CODE,
			COMPANY_PARTNER_USERNAME
		FROM
			COMPANY_PARTNER
		WHERE
			PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
	</cfquery>
	<table border="0">
		<cfform name="change_pass" action="#request.self#?fuseaction=objects2.emptypopup_add_change_cons_pass" method="post">
			<input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#get_username.partner_id#</cfoutput>" />
			<tr>
				<td width="130">&nbsp;<cf_get_lang_main no='146.Üye No'></td>
				<td><cfinput type="text" name="member_code" value="#get_username.member_code#" maxlength="16" readonly="yes"></td>
			</tr>
			<tr>
				<td>&nbsp;<cf_get_lang_main no='139.Kullanıcı Adı'></td>
				<td><cfinput type="text" name="username" value="#get_username.company_partner_username#" maxlength="16" readonly="yes"></td>
			</tr>
			<tr>
				<td><cf_get_lang no='769.Yeni Sifreniz'> *</td>
				<td><cfsavecontent variable="alert1"><cf_get_lang no='1534.Lütfen Yeni Şifrenizi Giriniz!'></cfsavecontent>
					<cfinput type="password" name="new_password" id="new_password" value="" maxlength="16" required="yes" message="#alert1#"></td>
			</tr>
			<tr>
				<td><cf_get_lang no='769.Yeni Sifreniz'> (<cf_get_lang no='698.Tekrar'> *)</td>
				<td><cfsavecontent variable="alert2"><cf_get_lang no='1534.Lütfen Yeni Şifrenizi Giriniz!'>!</cfsavecontent>
					<cfinput type="password" name="new_password2" id="new_password2" value="" maxlength="16" required="yes" message="#alert2#"></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<cfsavecontent variable="update_btn"><cf_get_lang_main no='52.Güncelle'></cfsavecontent>
				<td>
					<!---<cf_workcube_buttons is_upd='0' insert_info='#update_btn#' add_function='kontrol()' is_cancel='0'>--->
					<input type="button" name="gonder" value="Güncelle" onClick="return kontrol()"/>
				</td>
			</tr>
			<tr>
				<td colspan="2"><div id="SHOW_INFO" style="float:left;"></div></td>
			</tr>
		</cfform>
	</table>
	</div>
</cfif>

<cfif isdefined('url.ma') and len(url.ma)>
	<cfset mail_addr = decrypt(url.ma,'AERTYASD6G6SA3E7',"CFMX_COMPAT","Hex")>
	<cfif isdefined('attributes.mt') and attributes.mt eq 1>
		<cfquery name="GET_USERNAME" datasource="#DSN#">
			SELECT
				CONSUMER_USERNAME MEMBER_USERNAME
			FROM
				CONSUMER
			WHERE
				CONSUMER_EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#mail_addr#">
		</cfquery>
	<cfelseif isdefined('attributes.mt') and attributes.mt eq 2> 
		<cfquery name="GET_USERNAME" datasource="#DSN#">
			SELECT
				COMPANY_PARTNER_USERNAME MEMBER_USERNAME
			FROM
				COMPANY_PARTNER
			WHERE
				COMPANY_PARTNER_EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#mail_addr#">
		</cfquery>
	</cfif>
	<div class="haber_liste_1" style="width:100%;margin-left:-5px;">
		<div class="haber_liste_11" style="width:100%;"><h1><cf_get_lang no='85.Şifre Güncelleme'></h1></div>
	</div>
	<table border="0" style="margin-top:30px; width:55%;">
		<cfform name="change_pass" action="#request.self#?fuseaction=objects2.emptypopup_add_change_cons_pass" method="post">
			<input type="hidden" name="ma" id="ma" value="<cfoutput>#url.ma#</cfoutput>" />
			<input type="hidden" name="mt" id="mt" value="<cfif isDefined('attributes.mt') and len(attributes.mt)><cfoutput>#attributes.mt#</cfoutput></cfif>" />
			<tr>
				<td>&nbsp;<div class="uyegirisi_1" style="width:200px;"><span style=" text-align:left"><cf_get_lang_main no='139.Kullanıcı Adı'></span></div></td>
				<td><cfinput type="text" name="username" value="#get_username.member_username#" maxlength="16" readonly="yes" class="txt_1"></td>
			</tr>
			<tr>
				<td>&nbsp;<div class="uyegirisi_1" style="width:200px;"><span style=" text-align:left"><cf_get_lang no='769.Yeni Sifreniz'></span></div></td>
				<td><cfsavecontent variable="alert1"><cf_get_lang no='1534.Lütfen Yeni Şifrenizi Giriniz!'></cfsavecontent>
					<cfinput type="password" name="new_password" id="new_password" value="" maxlength="16" required="yes" message="#alert1#" class="txt_1"></td>
			</tr>
			<tr>
				<td>&nbsp;<div class="uyegirisi_1" style="width:200px;"><span style="width:200px; text-align:left"><cf_get_lang no='769.Yeni Sifreniz'> (<cf_get_lang no='698.Tekrar'> *)</span></div></td
				><td><cfsavecontent variable="alert2"><cf_get_lang no='1534.Lütfen Yeni Şifrenizi Giriniz!'></cfsavecontent>
					<cfinput type="password" name="new_password2" id="new_password2" value="" maxlength="16" required="yes" message="#alert2#" class="txt_1"></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<cfsavecontent variable="update_btn"><cf_get_lang_main no='52.Güncelle'></cfsavecontent>
				<td>
					<cf_workcube_buttons is_upd='0' insert_info='#update_btn#' add_function='kontrol()' is_cancel='0'>
					<!---<input type="button" class="btn_1" name="gonder" value="<cf_get_lang_main no='52.Güncelle'>" onClick="return kontrol()"/>--->
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td><div id="SHOW_INFO" style="float:right; margin-top:3px; width:80px;margin-left:180px; height:200px;position:static;"></div></td>
			</tr>
		</cfform>
	</table>
<cfelse>
	<script>
		alert("Yetkidışı Erişim");
		history.back(-1);
	</script>
	<cfabort>
</cfif>

<style type="text/css">
	input{clip:rect( );font-size:11px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;color : #333333;padding-left: 2px;}
	.color-row {background-color: #f1f0ff;}
	.color-border {background-color:#6699cc;}
</style>

<script type="text/javascript">
	function kontrol()
	{
		if(document.getElementById('new_password').value.length < 6)
		{
			alert("<cf_get_lang no='1533.Şifre En Az 6 Karakterli ve Sadece Rakamlardan Oluşmalıdır'>");
			return false;
		}
		if(document.getElementById('new_password').value != document.getElementById('new_password2').value)
		{
			alert("Lütfen her iki şifreyide aynı giriniz.");
			return false;
		}	
		AjaxFormSubmit('change_pass','SHOW_INFO',1,'Güncelleniyor','Güncellendi');
		alert('Şifreniz Güncellenmiştir!');
		window.location.href='<cfoutput>http://#cgi.HTTP_HOST#/#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#</cfoutput>.welcome'; 
	}
	change_pass.username.focus();
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->

