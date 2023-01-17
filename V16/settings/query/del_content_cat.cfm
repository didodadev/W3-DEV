<cfquery name="DOSYALAR" datasource="#dsn#">
	SELECT 
		CONTENTCAT_IMAGE1, 
		CONTENTCAT_IMAGE2 ,
		CONTENTCAT_IMAGE_SERVER_ID1,
		CONTENTCAT_IMAGE_SERVER_ID2
	FROM 
		CONTENT_CAT 
	WHERE 
		CONTENTCAT_ID=#CONTENTCAT_ID#
</cfquery>
<cfif len(DOSYALAR.CONTENTCAT_IMAGE1)>
	<CFTRY>
		<cf_del_server_file output_file="settings/#DOSYALAR.CONTENTCAT_IMAGE1#" output_server="#DOSYALAR.CONTENTCAT_IMAGE_SERVER_ID1#">
		<CFCATCH TYPE="ANY">
			<cfoutput><cf_get_lang no='637.Dosya Klasörde Bulunamadı Ama Veritabanından Silindi !'></cfoutput><cf_del_server_file output_file="settings/#DOSYALAR.CONTENTCAT_IMAGE2#" output_server="#DOSYALAR.CONTENTCAT_IMAGE_SERVER_ID2#">
		</CFCATCH>
	</CFTRY>
</cfif>
<cfif len(DOSYALAR.CONTENTCAT_IMAGE2)>
	<CFTRY>
		<cf_del_server_file output_file="settings/#DOSYALAR.CONTENTCAT_IMAGE2#" output_server="#DOSYALAR.CONTENTCAT_IMAGE_SERVER_ID2#">
		<CFCATCH TYPE="ANY">
			<cfoutput><cf_get_lang no='637.Dosya Klasörde Bulunamadı Ama Veritabanından Silindi !'></cfoutput>
		</CFCATCH>
	</CFTRY>
</cfif>
<cfquery name="DELCONTENTCAT" datasource="#dsn#">
	DELETE 
	FROM 
		CONTENT_CAT	
	WHERE 
		CONTENTCAT_ID=#CONTENTCAT_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_content_cat" addtoken="no">
