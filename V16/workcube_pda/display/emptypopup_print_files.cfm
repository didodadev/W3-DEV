<cfquery name="Get_Print_Standart" datasource="#dsn#">
  	SELECT 
    	SPF.IS_XML,
		SPF.TEMPLATE_FILE,
		SPF.FORM_ID,
		SPF.IS_STANDART,
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
		SPF.ACTIVE = 1 AND
		SPF.IS_DEFAULT = 1 AND
		SPF.MODULE_ID = MOD.MODULE_ID AND
		SPFC.PRINT_TYPE = SPF.PROCESS_TYPE AND
		SPFC.PRINT_TYPE = #attributes.print_type#
	ORDER BY
		SPF.IS_XML,
		SPF.NAME
</cfquery>
<cfif Get_Print_Standart.is_standart eq 1>
	<cfinclude template="/#Get_Print_Standart.template_file#">
<cfelse>
	<cfinclude template="/documents/settings/#Get_Print_Standart.template_file#">
</cfif>
