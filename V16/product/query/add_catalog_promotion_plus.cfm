<cf_date tarih="form.plus_date">
<cfquery name="ADD_PLUS" datasource="#dsn3#">
    INSERT INTO 
        CATALOG_PROMOTION_PLUS 
    (
        CATALOG_PROMOTION_ID,
        PLUS_SUBJECT,
        PLUS_CONTENT,
        PLUS_DATE,
        COMMETHOD_ID,
        RECORD_DATE,
        RECORD_IP,
        RECORD_EMP
    )
    VALUES
    (
        #ATTRIBUTES.CATALOG_PROMOTION_ID#,
        '#ATTRIBUTES.PLUS_SUBJECT#',
        '#ATTRIBUTES.PLUS_CONTENT#',
        #FORM.PLUS_DATE#,
        <cfif len(attributes.COMMETHOD_ID)>#attributes.COMMETHOD_ID#,<cfelse>NULL,</cfif>
        #NOW()#,
        '#CGI.REMOTE_ADDR#',
        #SESSION.EP.USERID#
    )					
</cfquery>
<script type="text/javascript">
	<cfif isdefined("attributes.draggable")>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
	<cfelse>
		wrk_opener_reload();
		window.close();
	</cfif>
</script>
