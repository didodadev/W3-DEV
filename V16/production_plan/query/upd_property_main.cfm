<cfquery name="ADD_PRPT" datasource="#DSN1#">
	UPDATE  
		PRODUCT_PROPERTY
	SET		
		PROPERTY = '#attributes.PROPERTY#',
		<cfif isdefined("size_color") and (size_color eq 1)>
		PROPERTY_SIZE = 1,
		PROPERTY_COLOR = 0,
		<cfelseif isdefined("size_color") and (size_color eq 0)>
		PROPERTY_SIZE = 0,
		PROPERTY_COLOR = 1,
		</cfif>
		DETAIL = '#attributes.detail#',
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_DATE = #now()#,
		UPDATE_IP = '#cgi.remote_addr#'
	WHERE
		PROPERTY_ID = #attributes.property_id#
</cfquery>


<script type="text/javascript">
	closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
</script>
