<cfquery name="UPD_ITASSET" datasource="#dsn#">
	UPDATE
	ASSETP_IT
	SET
		ASSETP_ID = #ASSETP_ID#,
		<cfif LEN(IT_PRO)>
		IT_PRO = '#IT_PRO#',
		</cfif>
		IT_MEMORY = '#IT_MEMORY#',
		IT_HDD = '#IT_HDD#', 
		IT_CON = '#IT_CON#',
		IT_PROPERTY1 = '#IT_PROPERTY1#', 
		IT_PROPERTY2 = '#IT_PROPERTY2#',
		IT_PROPERTY3 = '#IT_PROPERTY3#',
		IT_PROPERTY4 = '#IT_PROPERTY4#',
		IT_PROPERTY5 = '#IT_PROPERTY5#',
		UPD_EMP = #SESSION.EP.USERID#,
		UPD_IP = '#CGI.REMOTE_ADDR#',
		UPD_DATE = #NOW()#
	WHERE  
		ASSETP_ID = #ASSETP_ID#
</cfquery>
<script type="text/javascript">
 	wrk_opener_reload();
 	window.close();
</script>
