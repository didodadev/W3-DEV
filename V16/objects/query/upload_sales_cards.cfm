<cf_date tarih="attributes.processdate">
<!--- Hatali gelebilecek format icin ilk kontrol --->
<cfif not isdefined("form.department_id") and not isdefined("attributes.processdate")>
	<script type="text/javascript">
		alert("Lütfen Girdiğiniz Bilgileri Tekrar Kontrol Ediniz!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfset attributes.import_detail = Replace(attributes.import_detail,",","","all")>
<cfset attributes.upload_folder = "#upload_folder#store#dir_seperator#">
<cfscript>
	if (listlen(form.department_id,"-") eq 2)
	{
		department_id = listfirst(form.department_id,"-");
		department_location = listlast(form.department_id,"-");
	}
	else
		department_id = listfirst(form.department_id,"-");
</cfscript>

<!--- Ayni gunde ayni magaza icin satis kontrolu --->
<cfquery name="CHECK_SAME" datasource="#DSN2#">
	SELECT
		INVOICE_ID,
		I_ID
	FROM
		FILE_IMPORTS
	WHERE
		STARTDATE = #attributes.processdate# AND
		DEPARTMENT_ID = #department_id# AND
		PROCESS_TYPE = -2 AND
		SOURCE_SYSTEM = #attributes.target_pos#
		<cfif isDefined("DEPARTMENT_LOCATION") and len(DEPARTMENT_LOCATION)>
			AND DEPARTMENT_LOCATION = #DEPARTMENT_LOCATION#
		</cfif>
		<cfif attributes.target_pos eq -2 or attributes.target_pos eq -6>
			AND IMPORT_DETAIL = '#attributes.import_detail#'
		</cfif><!---  Mpos ve ESPOS icin eklendi --->
</cfquery>
<cfif not check_same.recordcount>
	<cfset file_name_2 = ''>
	<cfif not isDefined("Schedules")><!--- Schedule Yazilirken Kullanilmayacak --->
		<cftry>
			<cffile action = "upload" fileField="uploaded_file" destination="#attributes.upload_folder#" nameConflict="MakeUnique" mode="777">
			<cfif attributes.target_pos eq -2>
				<cfset file_name = "#createUUID()#_#cffile.serverfileext#.MPOS">
			<cfelse>
				<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
			</cfif>
			<cffile action="rename" source="#attributes.upload_folder##cffile.serverfile#" destination="#attributes.upload_folder##file_name#">
			<!---Script dosyalarını engelle  02092010 FA-ND --->
			<cfset assetTypeName = listlast(cffile.serverfile,'.')>
			<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
			<cfif listfind(blackList,assetTypeName,',')>
				<cffile action="delete" file="#attributes.upload_folder##file_name#">
				<script type="text/javascript">
					alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
					history.back();
				</script>
				<cfabort>
			</cfif>
			<cfset file_size = cffile.filesize>
			
			<cfif attributes.target_pos eq -82>
				<cffile action = "upload" fileField="uploaded_file2" destination="#attributes.upload_folder#" nameConflict="MakeUnique" mode="777">
				<cfset file_name_2 = "#createUUID()#.#cffile.serverfileext#">	
				<cffile action="rename" source="#attributes.upload_folder##cffile.serverfile#" destination="#attributes.upload_folder##file_name_2#">
				
				<cfset assetTypeName = listlast(cffile.serverfile,'.')>
				<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
				<cfif listfind(blackList,assetTypeName,',')>
					<cffile action="delete" file="#attributes.upload_folder##file_name_2#">
					<script type="text/javascript">
						alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
						history.back();
					</script>
					<cfabort>
				</cfif>
			</cfif>			
			<cfcatch type="Any">
				<script type="text/javascript">
					alert("Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz !");
					history.back();
				</script>
				<cfabort>
			</cfcatch>
		</cftry>
	<cfelse>
		<cffile action="move" source="#File_Directory##dir_seperator##Old_File_Name#" destination="#attributes.upload_folder##File_Name#">
	</cfif>
	<cfquery name="ADD_FILE" datasource="#DSN2#">
		INSERT INTO
			FILE_IMPORTS
		(	
			SOURCE_SYSTEM,
			PROCESS_TYPE,
			STARTDATE,
			FILE_NAME,
			FILE_SERVER_ID,
			FILE_SIZE,
			FILE_NAME_2,
			IS_MUHASEBE,
			DEPARTMENT_ID,
			DEPARTMENT_LOCATION,
			IMPORTED,
			IMPORT_DETAIL,
			RECORD_DATE,
			RECORD_IP,
			RECORD_EMP
		)
		VALUES
		(
			#attributes.target_pos#,
			-2,
			#attributes.processdate#,
			'#file_name#',
			#fusebox.server_machine#,
			#file_size#,
			'#file_name_2#',
			0,
			#department_id#,
			<cfif isdefined("department_location")>#department_location#<cfelse>NULL</cfif>,
			0,
			'#attributes.import_detail#',
			#now()#,		
			'#cgi.remote_addr#',
			<cfif isdefined("Ep_UserId")>#Ep_UserId#<cfelse>#session.ep.userid#</cfif>
		)
	</cfquery>
	<cfif not isDefined("Schedules")><!--- Schedule Yazilirken Kullanilmayacak --->
		<script type="text/javascript">
			alert('Dosyanız upload edildi !');
			wrk_opener_reload();
			window.close();
		</script>
	</cfif>
<cfelse>
	<!--- Olusturulmus bir kayit varsa neden onu da siliyor? Bu musterilerde sorun oldugundan kapatildi, fbs 20121030
	
	<!--- Kayit Varsa --->
	<cfquery name="CHECK_INVOICE" datasource="#DSN2#">
		SELECT
			INVOICE_ID,
			INVOICE_NUMBER,
			'' AS I_ID
		FROM
			INVOICE
		WHERE
			INVOICE_DATE = #attributes.processdate# AND
			INVOICE_CAT = 67 AND
			DEPARTMENT_ID = #department_id#
		<cfif attributes.target_pos eq -1><!--- Genius --->
			AND INVOICE_NUMBER LIKE 'GNDSALES%'
		<cfelseif attributes.target_pos eq -2><!--- MPOS --->
			AND INVOICE_NUMBER LIKE 'MPOSSALES%'
		<cfelseif attributes.target_pos eq -3><!--- NCR --->
			AND INVOICE_NUMBER LIKE 'NCRSALES%'
		</cfif>
		<cfif isDefined("department_location") and len(department_location)>
			AND DEPARTMENT_LOCATION = #department_location#
		</cfif>
	</cfquery>
	<cfif attributes.target_pos eq -2 and CHECK_INVOICE.recordcount>
		<cfset inv_numbers = valuelist(CHECK_INVOICE.invoice_number,',')>				
		<cfloop from="1" to="#listlen(inv_numbers,',')#" index="inv_i">
			<cfif attributes.import_detail is right(listgetat(inv_numbers,inv_i,','),len(attributes.import_detail))>
				<cfquery name="CHECK_INVOICE2" datasource="#DSN2#">
					SELECT INVOICE_ID, '' AS I_ID FROM INVOICE WHERE INVOICE_NUMBER = '#listgetat(inv_numbers,inv_i,',')#'
				</cfquery>
			</cfif>
		</cfloop>
	</cfif>
	<cfif CHECK_INVOICE.recordcount>
		<cfset DONTSTOP = 1>
		<cfset attributes.INVOICE_ID = check_same.invoice_id>
		<cfset attributes.I_ID = check_same.i_id>
		<cfinclude template="del_sale_import.cfm">
	<cfelse>
	 --->
	<cfif not isDefined("Schedules")><!--- Schedule Yazilirken Kullanilmayacak --->
		<script type="text/javascript">
			alert('Aynı Tarihte Girilmiş Başka Bir Kayıt Bulunmaktadır, Lütfen Kontrol Ediniz!');
			window.close();
		</script>
	</cfif>
	<!--- </cfif> --->
</cfif>
