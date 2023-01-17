<cfquery name="getOrderNo" datasource="#dsn#">
	SELECT ORDER_NO FROM TEST_SUBJECT WHERE ORDER_NO='#attributes.order_id#'
</cfquery>
<cfif getOrderNo.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no='353.Sıra no kullanımda'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfquery name="addtest_cat" datasource="#DSN#">
	INSERT INTO TEST_SUBJECT
    (
		IS_ACTIVE,
    	CATEGORY_ID,
        SUBJECT,
        ORDER_NO,
		DETAIL,
		TYPE,
        RECORD_DATE,
        RECORD_IP,
        RECORD_EMP
    )
    VALUES
    (
		<cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
    	#attributes.cate_id#,
        '#attributes.test_name#',
        <cfif len(attributes.order_id)>#attributes.order_id#<cfelse>NULL</cfif>,
		'#attributes.detail#',
		<cfif isdefined("attributes.wbo_type")>'#attributes.wbo_type#'<cfelse>NULL</cfif>,
        #now()#,
        '#cgi.remote_addr#',
    	#session.ep.userid#
     )
     
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.add_subject_cat" addtoken="no">
