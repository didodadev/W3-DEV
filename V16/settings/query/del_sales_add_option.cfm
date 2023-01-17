<cflock name="#createUUID()#" timeout="60">			
	<cftransaction>
		<cfquery name="DEL_SALE_ADD_OPTIONS" datasource="#dsn3#">
			DELETE FROM SETUP_SALES_ADD_OPTIONS WHERE SALES_ADD_OPTION_ID = #attributes.sale_option_id#
		</cfquery>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.add_sales_add_option" addtoken="no">
