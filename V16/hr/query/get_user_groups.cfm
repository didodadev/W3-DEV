<cfquery name="GET_USER_GROUPS" datasource="#dsn#">
	SELECT
    	USER_GROUP_ID, 
		IS_DEFAULT
	FROM 
		USER_GROUP
	WHERE
		IS_DEFAULT = 1	
</cfquery>
<!--- bu dosya ile ilgili pozisyon ekle ve update sayfalarinda kontrol var baska yerde mumkun oldugunca kullanmayiniz 12102004 YO--->
