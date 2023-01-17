<cftry>
<cfquery name="del_defect_location" datasource="#dsn_ts#">
	DELETE
		SETUP_DEFECT_LOCATION
	WHERE
		DEFECT_LOCATION_ID='#DEFECT_LOCATION_ID#'
</cfquery>
<cfset i='1'>
<cfcatch type="database"> 
<cfoutput>'İlişkisel Veri Tabanı Sebebiyle Eşsiz Tanımlayıcı Başka Tablolarda da Kullanıldığından Kaydınız Silinememektedir!'</cfoutput>
<cfset i='2'>
</cfcatch>
</cftry>
<cfif i eq '1'>
 <script type="text/javascript">
	wrk_opener_reload();
	window.close();
 </script>
</cfif>
