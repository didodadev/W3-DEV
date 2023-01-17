<cfif not isdefined('status')>
	<cfset status = 0>
</cfif>
<cftry>
<cfquery name="add_DEFECT_LOCATION" datasource="#dsn_ts#">
	INSERT INTO
		SETUP_DEFECT_LOCATION
		(
		DEFECT_LOCATION,
		DEFECT_LOCATION_DETAIL,
		STATUS,
		DEFECT_LOCATION_ID,
		RECORD_EMP,
		RECORD_IP,
		RECORD_DATE
		)
	VALUES
		(
		'#DEFECT_LOCATION#',
		'#DEFECT_LOCATION_DETAIL#',
		'#STATUS#',
		'#DEFECT_LOCATION_ID#',
		#SESSION.EP.USERID#,
		'#CGI.REMOTE_ADDR#',
		#NOW()#
		)
</cfquery>

<cfset i='1'>
<cfcatch type="database"> 
<cfoutput>'İlişkisel Veri Tabanı Sebebiyle Aynı Kodlu İki Kayıt Ekleyemezsiniz! Farklı Bir Defo Yeri Kodu Giriniz'</cfoutput>
<cfset i='2'>
</cfcatch>
</cftry>
<cfif i eq '1'>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
</cfif>
