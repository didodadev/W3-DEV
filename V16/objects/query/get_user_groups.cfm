<cfquery name="GET_USER_GROUPS" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		USER_GROUP
	<cfif not get_module_power_user(67)><!--- not session.ep.ehesap--->
	WHERE
		IS_DEFAULT = 1
	</cfif>
	ORDER BY 
		USER_GROUP_NAME
</cfquery>
<!--- bu dosya ile ilgili pozisyon ekle ve update sayfalarinda kontrol var baska yerde mumkun oldugunca kullanmayiniz 12102004 YO--->
