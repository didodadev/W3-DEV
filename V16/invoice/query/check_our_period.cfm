<cfinclude template = "../../objects/query/session_base.cfm">
<cfif attributes.active_period neq session_base.period_id>
	<!--- 20050302 sadece donem kontrolu gereken yerlerde kullanilacak --->
	<script type="text/javascript">
		alert("İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı.\rMuhasebe Döneminizi Kontrol Ediniz!");
		<cfif attributes.fuseaction contains '_cost'>
			window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.welcome</cfoutput>';
		<cfelse>
			window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.welcome</cfoutput>';
		</cfif>
	</script>
	<cfabort>
</cfif>
