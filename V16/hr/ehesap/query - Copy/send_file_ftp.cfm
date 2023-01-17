<cfquery name="get_ftp_info" datasource="#dsn#">
	SELECT
		FTP_SERVER_NAME,
		FTP_FILE_PATH,
		FTP_USERNAME,
		FTP_PASSWORD,
		EXPORT_TYPE,
		XML_FILE_NAME
	FROM
		SETUP_BANK_TYPES SB,
		EMPLOYEES_BANK_PAYMENTS EB
	WHERE
		SB.BANK_ID = EB.BANK_ID
		AND EB.BANK_PAYMENT_ID = #attributes.payment_id#
</cfquery>
<cfif get_ftp_info.recordcount and len(get_ftp_info.ftp_server_name) and len(get_ftp_info.ftp_username) and len(get_ftp_info.ftp_password)>
	<cftry>
		<cfset folder_name = "#upload_folder#finance#dir_seperator#bank">
		<cfftp
			action="putFile"
			server="#get_ftp_info.ftp_server_name#"
			username="#get_ftp_info.ftp_username#"
			password="#Decrypt(get_ftp_info.ftp_password,get_ftp_info.EXPORT_TYPE,"CFMX_COMPAT","Hex")#"
			localfile="#upload_folder#\hr\eislem\#get_ftp_info.xml_file_name#"
			secure="yes"
			remotefile="#get_ftp_info.ftp_file_path#/#get_ftp_info.xml_file_name#">
			<cfquery name="upd_payment" datasource="#dsn#">
				UPDATE EMPLOYEES_BANK_PAYMENTS SET IS_SENT_FTP = 1 WHERE BANK_PAYMENT_ID = #attributes.payment_id#
			</cfquery>
			<script language="javascript">
				alert("Belge FTP 'ye Gönderildi");
				history.back();
			</script>
		<cfcatch>
			<script language="javascript">
				alert("Belge FTP 'ye Gönderilemedi");
				history.back();
			</script>
		</cfcatch>
	</cftry>
<cfelse>
	<script language="javascript">
		alert("FTP Parametreleri Eksik , Lütfen Bilgileri Kontrol Ediniz !");
		history.back();
	</script>
</cfif>

