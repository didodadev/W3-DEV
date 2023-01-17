<cf_date tarih="attributes.startdate">
<cf_date tarih="attributes.finishdate">
<cfquery name="ADD_RELATED_PRODUCT" datasource="#dsn3#">
	UPDATE
		PRODUCT_VISION 
	SET 
		IS_ACTIVE = <cfif isdefined("attributes.is_active")>1,<cfelse>0,</cfif>
		IS_PUBLIC = <cfif isdefined("attributes.is_public")>1,<cfelse>0,</cfif>
		IS_PARTNER = <cfif isdefined("attributes.is_partner")>1,<cfelse>0,</cfif>
		VISION_TYPE = ',#attributes.vision_type#,',
		PRODUCT_ID = #attributes.product_id#,
		STOCK_ID = #attributes.stock_id#,
		DETAIL='#attributes.detail#',
		STARTDATE = #attributes.startdate#,
		FINISHDATE = #attributes.finishdate#,
		UPDATE_DATE = #NOW()#,
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#'
	WHERE
		VISION_ID = #attributes.vision_id#
</cfquery>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');
		location.reload();
	</cfif>
</script>
