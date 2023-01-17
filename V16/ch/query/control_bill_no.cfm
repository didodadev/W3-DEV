<cfquery name="kontrol" datasource="#DSN2#">
	SELECT
		*
	FROM
		BILLS
</cfquery>
<cfif not kontrol.recordcount>
	<font color="##FF0000">
		<a href="<cfoutput>#request.self#?fuseaction=account.bill_no</cfoutput>" class="tableyazi"><cf_get_lang_main no='1616.Lütfen Muhasebe Fiş numaralarını Düzenleyiniz !'></a>
	</font>
	<cfabort>
</cfif>
