<cfquery name="addtest_cat" datasource="#DSN#">
	INSERT INTO TEST_CAT
    (
    	CATEGORY_NAME,
        CATEGORY_DETAIL,
        RECORD_DATE,
        RECORD_IP,
        RECORD_EMP
    )
    VALUES
    (
    	'#attributes.test_name#',
        '#attributes.detail#',
       	#now()#,
        '#cgi.remote_addr#',
    	#session.ep.userid#
     )
     
</cfquery>
<script>
    location.href = document.referrer;
 </script>
