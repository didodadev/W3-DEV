<cfquery name="getOrderNo" datasource="#dsn#">
	SELECT ORDER_NO FROM TEST_SUBJECT WHERE ORDER_NO='#attributes.order_id#' AND SUBJECT_ID <>#attributes.id#
</cfquery>
<cfif getOrderNo.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no='353.Sıra no kullanımda'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfquery name="upd_category" datasource="#dsn#">
	UPDATE
    	TEST_SUBJECT
    SET
    	CATEGORY_ID=#attributes.cate_id#,
        SUBJECT='#attributes.test_name#',
        ORDER_NO=<cfif len(attributes.order_id)>#attributes.order_id#<cfelse>NULL</cfif>,
		IS_ACTIVE=<cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
		DETAIL='#attributes.detail#',
		TYPE=<cfif isdefined("attributes.wbo_type") and len(attributes.wbo_type)>'#attributes.wbo_type#'<cfelse>NULL</cfif>,
        UPDATE_EMP=#session.ep.userid#,
        UPDATE_DATE= #now()#,
        UPDATE_IP='#cgi.remote_addr#'
   WHERE
   		SUBJECT_ID=#attributes.id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.add_subject_cat" addtoken="no">
