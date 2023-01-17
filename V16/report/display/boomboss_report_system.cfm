<cf_xml_page_edit fuseact="report.boomboss_report_system">
<table width="98%" height="98%" align="center" id="boomboss_container">
	<tr>
		<td>
        <!---
		
			İhtiyaç duyulan parametreler
			
			serverAddress			Sunucu adresi
			workcubeReportSystem	true
			db						rapor veritabanı (workcube_cf_report)
			langDB					dil veritabanı (workcube_cf)
			lang					session 'daki dil tag i
			employeeID				session 'daki çalışan id
			positionCode			session 'daki pozisyon kodu
			wal						xml setup 'ta sadece admin olan kişilerin sorgu ekleyip güncelleyebilmesi. 1 ya da 0
			
		--->
		<cfset flash_variables = "serverAddress=#cgi.HTTP_HOST#&workcubeReportSystem=true&db=#dsn_report#&langDB=#dsn#&lang=#session.ep.language#&employeeID=#session.ep.userid#&positionCode=#session.ep.position_code#&wal=#xml_is_admin#">
        <script src="/js/AC_RunActiveContent.js" type="text/javascript"></script>
        <script type="text/javascript">
        AC_FL_RunContent( 'codebase','http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,159,0','width','100%','height','700', 'id', 'boomboss','src','/com_mx/boomboss/boomboss','quality','high','pluginspage','http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash','movie','/com_mx/boomboss/boomboss','flashvars','<cfoutput>#flash_variables#</cfoutput>', 'allowScriptAccess', 'always','wmode','opaque'); //end AC code
        </script>
        <noscript>
        <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,159,0" width="100%" height="100%" id="boomboss">
            <param name="movie" value="/com_mx/boomboss/boomboss.swf" />
            <param name="wmode" value="opaque">
            <param name="quality" value="high" />
            <param name="flashvars" value="<cfoutput>#flash_variables#</cfoutput>"/>
            <param name="allowScriptAccess" value="always"/>
            <embed src="/com_mx/boomboss/boomboss.swf" quality="high" pluginspage="http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="100%" height="100%"></embed>
        </object>
        </noscript>
    	</td>
    </tr>
</table>
