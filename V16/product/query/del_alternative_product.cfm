<cfsetting showdebugoutput="no">
<cfquery name="DEL_ALTERNATIVE_PRODUCTS" datasource="#dsn3#">
	DELETE 
    	ALTERNATIVE_PRODUCTS 
    WHERE 
    	ALTERNATIVE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.anative_id#">
</cfquery>
<script type="text/javascript">
	<cfif isDefined('attributes.draggable')>
		closeBoxDraggable(<cfoutput>#attributes.modal_id#</cfoutput>);
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
	<cfelse>
		wrk_opener_reload();
		window.close();
	</cfif>
	
</script> 


