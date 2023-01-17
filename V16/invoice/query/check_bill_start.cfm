<!--- muhasebe fis baslangic no var mi --->
<cfquery name="bill_control" datasource="#dsn2#">
	SELECT * FROM BILLS
</cfquery>
<cfif not bill_control.recordcount>
	<cfif not isdefined('xml_import')>
		<script type="text/javascript">
			alert("<cf_get_lang no='75.Muhasebe Fiş Numaralarınız Tanımlı değil Lütfen Tanımlayınız !'>");
			window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
			//history.back();
		</script>
		<cfabort>
	<cfelse>
		<cf_get_lang no='75.Muhasebe Fiş Numaralarınız Tanımlı değil.Lütfen Tanımlayınız !'><br/>
		<cfset error_flag =1>
	</cfif>
</cfif>
