<cfquery name="ADD_PRPT" datasource="#DSN1#">
	INSERT INTO 
		PRODUCT_PROPERTY 
	(
		PROPERTY,
		PROPERTY_SIZE,
		PROPERTY_COLOR,
		DETAIL,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP
	)
	VALUES	
	(
		'#form.property#',
		 <cfif isDefined("size_color") and size_color eq 1>1,0,<cfelse>0,1,</cfif>
		'#detail#',
		#session.ep.userid#,
		#now()#,
		'#cgi.remote_addr#'
	)
</cfquery>
<script type="text/javascript">
	closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
</script>
