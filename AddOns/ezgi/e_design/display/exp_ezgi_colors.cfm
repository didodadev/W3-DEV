﻿<cfset FileName = "Renk_Tablosu_#DateFormat(now(),'YYYYMMDD')#_#TimeFormat(DateAdd('h',session.ep.time_zone,now()),'HHMMSS')#.csv">
<cfset myFile = "#upload_folder#production/#FileName#">
<cfset readFile = "#file_web_path#production/#FileName#">
<cfquery name="GetStuff" datasource="#dsn3#">
   SELECT COLOR_ID, COLOR_NAME FROM EZGI_COLORS
</cfquery>
<cffile action="write" file="#myFile#" output="Renk ID;Renk" addnewline="Yes">
<cfloop query="GetStuff">
   <cffile action="append" file="#myFile#" output="#COLOR_ID#;#COLOR_NAME#" addnewline="Yes">
</cfloop>
<script type="text/javascript">
  	alert('<cfoutput>#FileName#</cfoutput> <cf_get_lang_main no='3043.Adlı Dosya Oluşturulmuştur.'>');
</script>
<table width="100%">
<tr>
	<td height="30px">
		<a href="javascript://" onclick="windowopen('<cfoutput>#readFile#</cfoutput>','medium')" class="tableyazi"><cfoutput>#FileName#</cfoutput></a> <cf_get_lang_main no='3047.Dosyasını Buradan Yükleyiniz'>
	</td>
</tr>