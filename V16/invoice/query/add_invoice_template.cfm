
	<cftry>
		<cfset file_name = createUUID()>
		<cffile action="UPLOAD" nameconflict="MAKEUNIQUE" filefield="template_file" destination="#upload_folder#invoice">
		<cffile action="rename" source="#upload_folder#invoice#dir_seperator##cffile.serverfile#" destination="#upload_folder#invoice#dir_seperator##file_name#.#cffile.serverfileext#">
		<!---Script dosyalarını engelle  02092010 FA-ND --->
		<cfset assetTypeName = listlast(cffile.serverfile,'.')>
		<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
		<cfif listfind(blackList,assetTypeName,',')>
			<cffile action="delete" file="#upload_folder#invoice#dir_seperator##file_name#.#cffile.serverfileext#">
			<script type="text/javascript">
				alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
				history.back();
			</script>
			<cfabort>
		</cfif>
		
		<cfcatch>
			<script type="text/javascript">
				alert("Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz !");
				history.back();
			</script>
			<cfabort>
		</cfcatch>
	</cftry>



<cfif isdefined("attributes.active")>
	<cfquery name="get_templates" datasource="#dsn3#">
	 	SELECT NAME FROM PRINTFORM_INVOICE
	</CFQUERY>
	<cfif get_templates.recordcount>
		<cfquery name="get_templates" datasource="#dsn3#">
			UPDATE PRINTFORM_INVOICE SET ACTIVE = 0
		</CFQUERY>
	</cfif>
</cfif>

<cfquery name="add_" datasource="#dsn3#">
	  INSERT INTO PRINTFORM_INVOICE
	  (
	  ACTIVE,	
	  NAME,
	  TEMPLATE_FILE,
	  RECORD_EMP,
	  RECORD_DATE,
	  RECORD_IP
	  )   
	  VALUES
	  (
	  <cfif isdefined("attributes.active")>1,<cfelse>0,</cfif>
	  '#ATTRIBUTES.TEMPLATE_HEAD#',
	  '#file_name#.#cffile.serverfileext#',
	  #session.ep.userid#,
	  #now()#,
	  '#CGI.REMOTE_ADDR#'
	  )
</cfquery>


<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
