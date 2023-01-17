<cfif len(ATTRIBUTES.START_DATE)>
	<cf_date tarih = "ATTRIBUTES.START_DATE">
</cfif>
<cfif len(ATTRIBUTES.FINISH_DATE)>
	<cf_date tarih = "ATTRIBUTES.FINISH_DATE">
</cfif>
<cfif len(ATTRIBUTES.WARNING_DATE)>
	<cf_date tarih = "ATTRIBUTES.WARNING_DATE">
</cfif>

<cfif Len(attributes.SECUREFUND_FILE)>
	<cftry>
		<cfset file_name = createUUID()>
		<cffile action="UPLOAD" nameconflict="MAKEUNIQUE" filefield="SECUREFUND_FILE" destination="#upload_folder#member">
		<cffile action="rename" source="#upload_folder#member#dir_seperator##cffile.serverfile#" destination="#upload_folder#member#dir_seperator##file_name#.#cffile.serverfileext#">
		<!---Script dosyalarını engelle  02092010 FA-ND --->
		<cfset assetTypeName = listlast(cffile.serverfile,'.')>
		<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
		<cfif listfind(blackList,assetTypeName,',')>
			<cffile action="delete" file="#upload_folder#member#dir_seperator##file_name#.#cffile.serverfileext#">
			<script type="text/javascript">
				alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
				history.back();
			</script>
			<cfabort>
		</cfif>
		<cfif FileExists("#upload_folder#member#dir_seperator##attributes.OLDSECUREFUND_FILE#")>
			<!--- <cffile action="delete" file="#upload_folder#member#dir_seperator##attributes.OLDSECUREFUND_FILE#"> --->
			<cf_del_server_file output_file="member/consumer/#attributes.OLDSECUREFUND_FILE#" output_server="#attributes.OLDSECUREFUND_FILE_SERVER_ID#">
		</cfif>	
		<cfcatch>
			<script type="text/javascript">
				alert("<cf_get_lang_main no ='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'>!");
				history.back();
			</script>
			<cfabort>
		</cfcatch>
	</cftry>
</cfif>

<cfquery name="add_secure" datasource="#dsn#">
UPDATE CONSUMER_SECUREFUND SET
			SECUREFUND_STATUS = <cfif isdefined("attributes.SECUREFUND_STATUS")>1,<cfelse>0,</cfif>
			CONSUMER_ID = #attributes.consumer_id#,
			OUR_COMPANY_ID = #attributes.our_company_id#,
			SECUREFUND_CAT_ID = #attributes.SECUREFUND_CAT_ID#,
			GIVE_TAKE = #attributes.give_take#,
			SECUREFUND_TOTAL = #ATTRIBUTES.SECUREFUND_TOTAL#,
			MONEY_CAT = '#attributes.money_type#',
			<cfif len(attributes.money_cat_expense)>MONEY_CAT_EXPENSE = '#attributes.money_cat_expense#',<cfelse>MONEY_CAT_EXPENSE = NULL,</cfif>
			<cfif len(attributes.EXPENSE_TOTAL)>EXPENSE_TOTAL = #ATTRIBUTES.EXPENSE_TOTAL#,<cfelse>EXPENSE_TOTAL = NULL,</cfif>
			BANK = '#ATTRIBUTES.BANK#',
			BANK_BRANCH = '#ATTRIBUTES.BANK_BRANCH#',
			REALESTATE_DETAIL = '#ATTRIBUTES.REALESTATE_DETAIL#',
			<cfif len(ATTRIBUTES.START_DATE)>START_DATE = #ATTRIBUTES.START_DATE#,</cfif>
			<cfif len(ATTRIBUTES.FINISH_DATE)>FINISH_DATE = #ATTRIBUTES.FINISH_DATE#,</cfif>
			<cfif len(ATTRIBUTES.WARNING_DATE)>WARNING_DATE = #ATTRIBUTES.WARNING_DATE#,</cfif>
			<cfif Len(attributes.SECUREFUND_FILE)>SECUREFUND_FILE = '#file_name#.#cffile.serverfileext#',</cfif>
			UPDATE_EMP = #SESSION.EP.USERID#,
			UPDATE_IP = '#REMOTE_ADDR#',
			UPDATE_DATE = #NOW()#
		WHERE SECUREFUND_ID = #ATTRIBUTES.SECUREFUND_ID#
</cfquery>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
