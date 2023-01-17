<cfif form.active_company neq session.ep.company_id>
	<script type="text/javascript">
		alert("<cf_get_lang no ='522.İşlemin Muhasebe Dönemi İle Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>...!");
		window.location.href='<cfoutput>#request.self#?fuseaction=stock.list_purchase</cfoutput>';
	</script>
	<cfabort>
</cfif>
