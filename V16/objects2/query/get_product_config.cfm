<cfquery name="GET_SETUP_PRODUCT_CONFIGURATOR" datasource="#DSN3#">
	SELECT CONFIGURATOR_IMAGE, CONFIGURATOR_SERVER_IMAGE_ID, PRODUCT_CONFIGURATOR_ID, CONFIGURATOR_NAME, CONFIGURATOR_DETAIL FROM SETUP_PRODUCT_CONFIGURATOR WHERE IS_ACTIVE=1
</cfquery>