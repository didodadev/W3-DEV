<cfsetting showdebugoutput="no">
<cfset 'form.#attributes.name#_HashText' = attributes.text_name>
<cfset 'form.#attributes.name#_HashReference' = attributes.reference_name>
<cf_wrk_captcha name="#attributes.name#" action="validate">
<script type="text/javascript">
	<cfif evaluate("#attributes.name#.validationResult") eq false>
		<cfoutput>document.all.#attributes.name#_HashError.value = '1';</cfoutput>
	<cfelse>
		<cfoutput>document.all.#attributes.name#_HashError.value = '0';</cfoutput>
	</cfif>
</script>

