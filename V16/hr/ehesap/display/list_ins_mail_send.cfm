<cfsavecontent variable = "title"><cf_get_lang dictionary_id ="38409.İşe Giriş Mail"></cfsavecontent>
<cf_form_box title="#title#">
<cftry>
	<cfmail 
		to="#attributes.to#" 
		from="#listgetat(server_detail,1)#" 
		subject="#attributes.subject#" 
		type="html">	
		<cfoutput>		
				#attributes.detayicerik#
		</cfoutput>
	</cfmail>	
	<cf_get_lang dictionary_id="56815.Mail Başarıyla Gönderildi.">
	<cfcatch type="any"><b style="color:red;"><cfoutput><cf_get_lang dictionary_id="35727.Mail Gönderiminde Hata Oluştu! Lütfen Bilgilerinizi Kontrol Ediniz">(#cfcatch.Message#)</cfoutput></b></cfcatch>
</cftry>
</cf_form_box>
