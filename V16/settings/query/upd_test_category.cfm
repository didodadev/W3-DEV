<cfquery name="upd_category" datasource="#dsn#">
	UPDATE
    	TEST_CAT
    SET
    	CATEGORY_NAME='#attributes.test_name#',
        CATEGORY_DETAIL='#attributes.detail#',
     	UPDATE_EMP=#session.ep.userid#,
        UPDATE_DATE= #now()#,
        UPDATE_IP='#cgi.remote_addr#'
   WHERE
   		ID=#attributes.id#
</cfquery>
<script>
   location.href = document.referrer;
</script>