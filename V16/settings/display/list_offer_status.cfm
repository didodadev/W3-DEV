<cfquery name="OFFERS" datasource="#dsn#">
	SELECT * FROM OFFER_STATUS
</cfquery>		
<cfif offers.recordcount>
	<cfoutput query="offers">
		<a href="#request.self#?fuseaction=settings.form_upd_offer_status&ID=#offerStatus_ID#">#offerStatus#</a><br/>
	</cfoutput>
<cfelse>
	<font class="ikaz"><cf_get_lang no='137.Kayıtlı Kategori yok'></font>
</cfif>

