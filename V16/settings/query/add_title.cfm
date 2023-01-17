<cfquery name="INSTITLE" datasource="#dsn#">
	INSERT 
	INTO 
		SETUP_TITLE
	(
		TITLE,
		TITLE_DETAIL,
		HIERARCHY,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP
	) 
	VALUES 
	(
		N'#TITLE#',
		'#TITLE_DETAIL#',
		<cfif len(HIERARCHY)>'#HIERARCHY#'<cfelse>NULL</cfif>,
		#SESSION.EP.USERID#,
		#NOW()#,
		'#122.12.12.111#'
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
    <cflocation url="#request.self#?fuseaction=settings.form_add_title" addtoken="no">
</cfif>

<!---SONRADAN EKLEDIM     --->



