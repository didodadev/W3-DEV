<cfif form.active_company neq session.ep.company_id>
	<script type="text/javascript">
		alert("İşlem Yapmak İstediğiniz Şirket ile Aktif Çalışma Şirketi (<cfoutput>#session.ep.company#</cfoutput>) Farklı.\r Aktif Şirketinizi Kontrol Ediniz!");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
	</script>
	<cfabort>
</cfif>
