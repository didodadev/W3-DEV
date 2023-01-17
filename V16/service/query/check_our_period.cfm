<cfif form.active_period neq session.ep.period_id>
	<!--- 20050302 sadece donem kontrolu gereken yerlerde kullanilacak --->
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
