<cfif len(SUPPORT_START_DATE)>
   <cf_date tarih="SUPPORT_START_DATE">
</cfif>
<cfif len(SUPPORT_FINISH_DATE)>
    <cf_date tarih="SUPPORT_FINISH_DATE">
</cfif>
<cfif attributes.document neq ''>
	<cftry>
		<cffile action = "upload" 
			fileField = "document" 
			destination = "#upload_folder#assetcare#dir_seperator#" 
			nameConflict = "MakeUnique" 
			mode="777">
		<cfset file_name = createUUID() & '.' & #cffile.serverfileext#>
		<cffile action="rename" source="#upload_folder#assetcare#dir_seperator##cffile.serverfile#" destination="#upload_folder#assetcare#dir_seperator##file_name#">
		<!---Script dosyalarını engelle  02092010 ND --->
		<cfset assetTypeName = listlast(cffile.serverfile,'.')>
		<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
		<cfif listfind(blackList,assetTypeName,',')>
			<cffile action="delete" file="#upload_folder#assetcare#dir_seperator##file_name#">
			<script type="text/javascript">
				alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
				history.back();
			</script>
			<cfabort>
		</cfif>	
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang no='18.Dosyaniz upload edilemedi ! Dosyanizi kontrol ediniz !'>");
				history.back();
			</script>
			<cfabort>
		</cfcatch>  
	</cftry>
</cfif>
<cfquery name="upd_asset_contract" datasource="#DSN#">
	UPDATE
		ASSET_CARE_CONTRACT
	SET
		ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">,
		CONTRACT_HEAD = <cfif len(contract_head)>'#contract_head#'<cfelse>NULL</cfif>,
		SUPPORT_COMPANY_ID = <cfif isdefined("company_id") and len(company_id)>#company_id#<cfelse>NULL</cfif>,
		SUPPORT_AUTHORIZED_ID = <cfif isdefined("authorized_id") and len(authorized_id)>#authorized_id#<cfelse>NULL</cfif>,
		SUPPORT_EMPLOYEE_ID = <cfif isdefined("employee_id") and len(employee_id)>#employee_id#<cfelse>NULL</cfif>,
		DETAIL = '#detail#',
		SUPPORT_START_DATE = <cfif len(SUPPORT_START_DATE)>#SUPPORT_START_DATE#<cfelse>NULL</cfif>,
		SUPPORT_FINISH_DATE = <cfif len(SUPPORT_FINISH_DATE)>#SUPPORT_FINISH_DATE#<cfelse>NULL</cfif>,
		<cfif isdefined("file_name") and len(file_name)>
			USE_CERTIFICATE = '#file_name#',
			USE_CERTIFICATE_SERVER_ID = #fusebox.server_machine#,
		</cfif>
		SUPPORT_CAT_ID = <cfif isdefined("support_cat") and len(support_cat)>#support_cat#<cfelse>NULL</cfif>,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_DATE = #now()#,
		UPDATE_IP = '#cgi.remote_addr#'
	WHERE 
		ASSET_CARE_CONTRACT_ID = #attributes.asset_care_contract_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
