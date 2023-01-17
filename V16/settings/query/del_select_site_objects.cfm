<cflock name="#CREATEUUID()#" timeout="20">
 	<cftransaction>
        <cfquery name="DEL_SITE_LAYOUT" datasource="#dsn#">
            DELETE FROM MAIN_SITE_LAYOUTS WHERE LAYOUT_ID = #attributes.layout_id# AND MENU_ID = #attributes.menu_id#
        </cfquery>
        
        <cfquery name="DEL_SITE_LAYOUT_ROW" datasource="#dsn#">
            DELETE FROM MAIN_SITE_LAYOUTS_SELECTS WHERE FACTION = '#attributes.faction#' AND MENU_ID = #attributes.menu_id#
        </cfquery>
	</cftransaction>
</cflock>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
