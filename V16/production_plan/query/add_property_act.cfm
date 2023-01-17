<cfquery name="ADD_PRPT" datasource="#DSN1#">
	INSERT INTO 
	PRODUCT_PROPERTY_DETAIL 
	(
		PROPERTY_DETAIL,
		PRPT_ID
	)
	VALUES	
	(
		'#FORM.PROP#',
		#FORM.PRPT_ID#
	)
</cfquery>
<script type="text/javascript">
	closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
</script>
