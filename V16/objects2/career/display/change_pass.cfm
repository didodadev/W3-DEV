<cfif not isdefined("session.cp.userid")>
&nbsp;&nbsp;&nbsp;<cf_get_lang no ='218.Üye Girişi Yapmalısınız'>!!
<cfexit method="exittemplate">
</cfif>
<table width="300" class="ik1">
<cfform name="change_pass" action="#request.self#?fuseaction=objects2.emptypopup_add_change_pass" method="post">
 	<cfif isDefined("session.error_text")>
	<tr>
	  <td colspan="2"><font color="#FF0000"><cfoutput>#session.error_text#</cfoutput></font></td>
	</tr>
		<cfscript>
			if (isdefined("session.error_text")) 
				{
				structdelete(session,"error_text");
				}
		</cfscript>
	</cfif>
	<tr>
		<td bgcolor="#FFB74A" class="form-title">&nbsp;<cf_get_lang_main no='16.E Posta Adresiniz'></td>
		<td>
			<cfsavecontent variable="message"><cf_get_lang no='238.E Posta Adresinizi Girin'></cfsavecontent>
			<cfinput type="text" name="username" value="" validate="email" required="yes" message="#message#!">
		</td>
	</tr>
	<tr>
		<td bgcolor="#FFB74A" class="form-title">&nbsp;<cf_get_lang_main no='140.Şifreniz'></td>
		<cfsavecontent variable="alert"><cf_get_lang no ='1149.Eski Şifrenizi Girin'></cfsavecontent>
		<td><cfinput type="password" name="old_password" value="" required="yes" maxlength="16" message="#alert#"></td>
	</tr>
	<tr>
		<td bgcolor="#FFB74A" class="form-title">&nbsp;<cf_get_lang no='769.Yeni Şifreniz'></td>
		<cfsavecontent variable="alert"><cf_get_lang no ='1150.Yeni Şifrenizi Girin'></cfsavecontent>
		<td><cfinput type="password" name="new_password" value="" required="yes" maxlength="16" message="#alert#"></td>
	</tr>
	<tr>
		<td bgcolor="#FFB74A" class="form-title">&nbsp;<cf_get_lang no='769.Yeni Şifreniz'> (<cf_get_lang no='698.Tekrar'>)</td>
		<cfsavecontent variable="alert"><cf_get_lang no ='1151.Yeni Şifrenizin Tekrarını Girin'></cfsavecontent>
		<td><cfinput type="password" name="new_password2" value="" required="yes" maxlength="16" message="#alert#"></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td><input type="submit" name="giris" id="giris" value="<cf_get_lang_main no='142.Giriş'>"></td>
	</tr>
</cfform>
</table>
</div>
<script type="text/javascript">
	change_pass.username.focus();
</script>

