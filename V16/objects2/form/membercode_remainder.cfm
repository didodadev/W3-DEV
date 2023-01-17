<cfif isdefined("form.old_code")>
	<cf_cryptedpassword	password='#form.password#' output='PASS' mod=1>
	<cfquery name="get_" datasource="#dsn#">
		SELECT
			C.MEMBER_CODE
		FROM
			COMPANY C,
			COMPANY_PARTNER CP
		WHERE
			C.COMPANY_ID = CP.COMPANY_ID AND
			CP.COMPANY_PARTNER_USERNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.username#"> AND
			CP.COMPANY_PARTNER_PASSWORD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pass#"> AND
			C.OZEL_KOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.old_code#">
	</cfquery>
	<cfif get_.recordcount neq 1>
		<script type="text/javascript">
			alert("<cf_get_lang no ='1338.Üye Bilgilerini Hatalı Girdiniz! Lütfen Düzenleyiniz'>!");
			window.location.href='http://<cfoutput>#listfirst(server_url,';')#/#request.self#</cfoutput>?fuseaction=objects2.popup_membercode_remainder';
		</script>
		<cfabort>
	</cfif>
<table width="100%" border="0" cellspacing="1" cellpadding="2" height="100%" class="color-border">
<tr class="color-list" height="35">
  <td class="headbold">&nbsp;<cf_get_lang no='997.Üye Bilgileri Hatırlatıcı'></td>
</tr>
<tr class="color-row">
  <td valign="top">
			<table>
			  <cfoutput>
			  <tr>
			  	<td width="100"><cf_get_lang no='998.Yeni Üye Kodunuz'></td>
				<td class="headbold">#get_.MEMBER_CODE#</td>
			  </tr>
			  <tr>
				<td><cf_get_lang no='999.Eski Üye Kodu'></td>
				<td>#attributes.old_code#</td>
			  </tr>
			   <tr>
				<td><cf_get_lang_main no='139.Kullanıcı Adı'></td>
				<td>#attributes.username#</td>
			  </tr>
			   <tr>
				<td><cf_get_lang_main no='140.Şifre'></td>
				<td>********</td>
			  </tr>
			  </cfoutput>
			</table>
  </td>
</tr>
</table>
<cfelse>
	<table width="100%" border="0" cellspacing="1" cellpadding="2" height="100%" class="color-border">
	<tr class="color-list" height="35">
	  <td class="headbold">&nbsp;<cf_get_lang no ='997.Üye Bilgileri Hatırlatıcı'></td>
	</tr>
	<tr class="color-row">
	  <td valign="top">
			  <cfform name="arrange_password" action="#request.self#?fuseaction=objects2.popup_membercode_remainder" method="post">
				<table>
				  <tr>
					<td width="100"><cf_get_lang no ='999.Eski Üye Kodu'></td>
					<cfsavecontent variable="alert"><cf_get_lang no ='1337.Üye Kodunuzu Giriniz'></cfsavecontent>
					<td><cfinput name="old_code" type="text" style="width:150px;" required="yes" message="#alert#"></td>
				  </tr>
				   <tr>
					<td><cf_get_lang_main no ='139.Kullanıcı Adı'></td>
					<cfsavecontent variable="alert"><cf_get_lang no ='6.Kullanıcı Adınızı Giriniz'></cfsavecontent>
					<td><cfinput name="username" type="text" style="width:150px;" required="yes" message="#alert#"></td>
				  </tr>
				   <tr>
					<td><cf_get_lang_main no ='140.Şifre'></td>
					<cfsavecontent variable="alert"><cf_get_lang no ='7.Şifrenizi Giriniz'></cfsavecontent>
					<td><cfinput name="password" type="password" style="width:150px;" required="yes" message="#alert#"></td>
				  </tr>
				  <tr>
					<td colspan="2" style="text-align:right;">
					<cf_workcube_buttons 
						is_upd='0' 
						insert_info='Gönder' 
						is_cancel='0'
						insert_alert=''>
					</td>
				  </tr>
				</table>
			  </cfform>
	  </td>
	</tr>
	</table>
</cfif>
