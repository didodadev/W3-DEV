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
INSERT 
	INTO
		CONSUMER_SECUREFUND
			(
			SECUREFUND_STATUS,
			CONSUMER_ID,
			OUR_COMPANY_ID,
			SECUREFUND_CAT_ID,
			GIVE_TAKE,
			SECUREFUND_TOTAL,
			MONEY_CAT,
			<cfif len(attributes.money_cat_expense)>MONEY_CAT_EXPENSE,</cfif>			
			<cfif len(attributes.EXPENSE_TOTAL)>EXPENSE_TOTAL,</cfif>
			BANK,
			BANK_BRANCH,
			REALESTATE_DETAIL,
			<cfif len(ATTRIBUTES.START_DATE)>START_DATE,</cfif>
			<cfif len(ATTRIBUTES.FINISH_DATE)>FINISH_DATE,</cfif>
			<cfif len(ATTRIBUTES.WARNING_DATE)>WARNING_DATE,</cfif>
			<cfif Len(attributes.SECUREFUND_FILE)>SECUREFUND_FILE,</cfif>
			RECORD_EMP,
			RECORD_IP,
			RECORD_DATE
			)
	VALUES
			(
			<cfif isdefined("attributes.SECUREFUND_STATUS")>1,<cfelse>0,</cfif>
			#attributes.CONSUMER_ID#,
			#attributes.our_company_id#,
			#attributes.SECUREFUND_CAT_ID#,
			#attributes.give_take#,
			#ATTRIBUTES.SECUREFUND_TOTAL#,
			'#attributes.money_type#',
			<cfif len(attributes.money_cat_expense)>'#attributes.money_cat_expense#',</cfif>
			<cfif len(attributes.EXPENSE_TOTAL)>#ATTRIBUTES.EXPENSE_TOTAL#,</cfif>
			'#ATTRIBUTES.BANK#',
			'#ATTRIBUTES.BANK_BRANCH#',
			'#ATTRIBUTES.REALESTATE_DETAIL#',
			<cfif len(ATTRIBUTES.START_DATE)>#ATTRIBUTES.START_DATE#,</cfif>
			<cfif len(ATTRIBUTES.FINISH_DATE)>#ATTRIBUTES.FINISH_DATE#,</cfif>
			<cfif len(ATTRIBUTES.WARNING_DATE)>#ATTRIBUTES.WARNING_DATE#,</cfif>
			<cfif Len(attributes.SECUREFUND_FILE)>
			'#file_name#.#cffile.serverfileext#',
			</cfif>
			#SESSION.EP.USERID#,
			'#REMOTE_ADDR#',
			#NOW()#
			)
</cfquery>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
