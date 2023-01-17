<div id=main>
	<h5><cf_get_lang_main no='2036.Şifremi Unuttum'></h5>
	<table class="ik1" style="width:300px;">
		<cfform name="form_new_user" action="#request.self#?fuseaction=objects2.popup_lost_pass" method="post">
			<tr>
				<td bgcolor="#FFB74A" class="form-title"><cf_get_lang_main no='16.E-Posta'></td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang no='238.E-Posta Adresinizi Girin'></cfsavecontent>	
					<cfinput type="text" name="mail" id="mail" value="" validate="email" required="yes" message="#message#!">
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td><input type="submit" name="tamam" id="tamam" value="<cf_get_lang no='809.Şifremi Gönder'>"></td>
			</tr>
		</cfform>
	</table>
</div>
