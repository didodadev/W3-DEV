<cfset FileName = "Kalınlık_Tablosu_#DateFormat(now(),'YYYYMMDD')#_#TimeFormat(DateAdd('h',session.ep.time_zone,now()),'HHMMSS')#.csv">
<cfset myFile = "#upload_folder#production/#FileName#">
<cfset readFile = "#file_web_path#production/#FileName#">
<cfquery name="GetStuff" datasource="#dsn3#">
   SELECT THICKNESS_ID, THICKNESS_VALUE FROM EZGI_THICKNESS
</cfquery>
<cffile action="write" file="#myFile#" output="Kalınlık ID;Kalınlık Değeri" addnewline="Yes">
<cfloop query="GetStuff">
   <cffile action="append" file="#myFile#" output="#THICKNESS_ID#;#THICKNESS_VALUE#" addnewline="Yes">
</cfloop>
<script type="text/javascript">
  	alert('<cfoutput>#FileName#</cfoutput> <cf_get_lang_main no='3043.Adlı Dosya Oluşturulmuştur.'>');
</script>
<table width="100%">
<tr>
	<td height="30px">
		<a href="javascript://" onclick="windowopen('<cfoutput>#readFile#</cfoutput>','medium')" class="tableyazi"><cfoutput>#FileName#</cfoutput></a> Dosyasını Buradan Yükleyiniz
	</td>
</tr>