<cfparam name="attributes.form_type" default="31">
<cfquery name="GET_DET_FORM" datasource="#DSN#">
    SELECT 
        SPF.TEMPLATE_FILE,
        SPF.FORM_ID,
        SPF.IS_DEFAULT,
        SPF.NAME,
        SPF.PROCESS_TYPE,
        SPF.MODULE_ID,
        SPFC.PRINT_NAME
    FROM 
        #dsn3_alias#.SETUP_PRINT_FILES SPF,
        SETUP_PRINT_FILES_CATS SPFC,
        MODULES MOD
    WHERE
        SPF.FORM_ID = #attributes.form_type# AND
        SPF.ACTIVE = 1 AND
        SPF.MODULE_ID = MOD.MODULE_ID AND
        SPFC.PRINT_TYPE = SPF.PROCESS_TYPE AND 
        SPFC.PRINT_TYPE = 91
    ORDER BY
        SPF.NAME
</cfquery>

<cfif not isdefined("attributes.SELECT_ORDER") or not len(attributes.SELECT_ORDER)>
	<script>
		alert('Sipariş Seçmediniz!');
		window.close();
	</script>
    <cfabort>
</cfif>
<cfif isdefined("attributes.SELECT_ORDER") or len(attributes.SELECT_ORDER)>
	<cfset url.orders = attributes.SELECT_ORDER>
</cfif>
<cfinclude template="/documents/settings/#GET_DET_FORM.TEMPLATE_FILE#">
