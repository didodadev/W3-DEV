<!--- vergi tanımları yapılmış mı kontrolü --->
<cfset inventory_product_exists = 0 >
<cfset temp_tax_list = "">
<cfloop from="1" to="#attributes.rows_#" index="tax_i">
    <cfif not listfind(temp_tax_list, evaluate("attributes.tax#tax_i#"), ",")>
		<cfset temp_tax_list = ListAppend(temp_tax_list, evaluate("attributes.tax#tax_i#"), ",")>
	</cfif>
	<cfif evaluate("attributes.is_inventory#tax_i#") eq 1>
		<cfset inventory_product_exists = 1>
	</cfif> 
</cfloop>
<cfquery name="get_taxes" datasource="#dsn2#">
	SELECT 
		*
    FROM 
    	SETUP_TAX 
    WHERE 
    	TAX IN (#temp_tax_list#)
</cfquery>
<cfset tax_list = valuelist(get_taxes.tax)>

<cfif ListLen(temp_tax_list,",") neq get_taxes.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no='47.Seçtiğiniz Kdv Değerlerinin İçinde Tanımlı Olmayan Kdvler var !'>");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
		//history.back();
	</script>
	<cfabort>
</cfif>
