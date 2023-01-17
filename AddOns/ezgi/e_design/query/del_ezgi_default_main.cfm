<cftransaction>
    <cfquery name="del_main_default" datasource="#dsn3#">
    	DELETE FROM EZGI_DESIGN_MAIN_ROW_SETUP WHERE MAIN_ROW_SETUP_ID = #attributes.main_id#
    </cfquery>
</cftransaction>
<cflocation url="#request.self#?fuseaction=prod.list_ezgi_default_main" addtoken="No">