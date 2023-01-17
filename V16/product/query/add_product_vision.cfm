<cf_date tarih="attributes.startdate">
<cf_date tarih="attributes.finishdate">
<cfquery name="ADD_RELATED_PRODUCT" datasource="#dsn3#">
	INSERT INTO PRODUCT_VISION
		(
		IS_ACTIVE,
		IS_PUBLIC,
		IS_PARTNER,
		VISION_TYPE,
		PRODUCT_ID,
		STOCK_ID,
		DETAIL,
		STARTDATE,
		FINISHDATE,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP
		)
	VALUES
		(
		<cfif isdefined("attributes.is_active")>1,<cfelse>0,</cfif>
		<cfif isdefined("attributes.is_public")>1,<cfelse>0,</cfif>
		<cfif isdefined("attributes.is_partner")>1,<cfelse>0,</cfif>
		',#attributes.vision_type#,',
		#attributes.product_id#,
		<cfif len(attributes.stock_id)>#attributes.stock_id#,<cfelse>NULL,</cfif>
		<cfif len(attributes.detail)>'#attributes.detail#',<cfelse>NULL,</cfif>
		#attributes.startdate#,
		#attributes.finishdate#,
		#NOW()#,
		#SESSION.EP.USERID#,
		'#CGI.REMOTE_ADDR#'
		)
</cfquery>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' , 'unique__dsp_showed_vision_' );
	</cfif>
</script>
