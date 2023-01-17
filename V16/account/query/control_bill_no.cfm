<cfquery name="kontrol" datasource="#DSN2#">
	SELECT BILL_ID FROM BILLS
</cfquery>
<cfif not kontrol.recordcount>
	<font color="##FF0000">
		<a href="<cfoutput>#request.self#?fuseaction=account.bill_no</cfoutput>" class="tableyazi"><cf_get_lang_main no ='1616.LUtfen Muhasebe Fis Numaralarini Duzenleyiniz'> </a>
	</font>
	<cfabort>
</cfif>
