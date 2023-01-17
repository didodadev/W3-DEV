<cfquery name="INSTITLE" datasource="#dsn#">
	INSERT 
	INTO SOCIAL_MEDIA_SEARCH_WORDS 
		(
		WORD,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP
	) 
	VALUES 
	(
		'#WORD#',
		#SESSION.EP.USERID#,
		#NOW()#,
		'#CGI.REMOTE_ADDR#'
	)
</cfquery>
<!---<cflocation url="#cgi.http_referer#" addtoken="no">--->


<!---SONRADAN EKLEDIM     --->
<cfif IsDefined('attributes.form_popup') and attributes.form_popup eq 1>
	<script type="text/javascript">
        wrk_opener_reload();
        window.close();
    </script>
<cfelse>
    <cflocation url="#request.self#?fuseaction=settings.form_social_media_search_words" addtoken="no">
</cfif>

<!---SONRADAN EKLEDIM     --->



