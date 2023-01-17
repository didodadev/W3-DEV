<cf_date tarih="form.plus_date">
<cfquery name="ADD_PLUS" datasource="#dsn3#">
	UPDATE 
		CATALOG_PROMOTION_PLUS 
	SET
		 PLUS_SUBJECT = '#ATTRIBUTES.PLUS_SUBJECT#', 
		 PLUS_CONTENT = '#ATTRIBUTES.PLUS_CONTENT#',
		 PLUS_DATE = #form.plus_date#,
		 COMMETHOD_ID = #ATTRIBUTES.COMMETHOD_ID#,
		 UPDATE_DATE = #NOW()#,
		 UPDATE_IP = '#CGI.REMOTE_ADDR#',
		 UPDATE_EMP = #SESSION.EP.USERID#
	WHERE
		PLUS_ID = #ATTRIBUTES.PLUS_ID# 
</cfquery>
<script type="text/javascript">
	<cfif isdefined("attributes.draggable")>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
	<cfelse>
		wrk_opener_reload();
		window.close();
	</cfif>
</script>
