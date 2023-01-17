<!--- Bu sayfada COMPANY_SECUREFUND tablosundaki BRANCH_ID alanina related_id degerini attigi tespit edilmistir.
	Daha sonra bununla ilgili bir UPDATE yazilabilir. BK 20070605--->
<cfif len(attributes.start_date)><cf_date tarih = "attributes.start_date"></cfif>
<cfif len(attributes.finish_date)><cf_date tarih = "attributes.finish_date"></cfif>
<cfif len(attributes.warning_date)><cf_date tarih = "attributes.warning_date"></cfif>
<cfif len(attributes.securefund_file)>
	<cftry>
		<cfset file_name = createUUID()>
		<cffile action="UPLOAD" nameconflict="MAKEUNIQUE" filefield="SECUREFUND_FILE" destination="#upload_folder#member">
		<cffile action="rename" source="#upload_folder#member#dir_seperator##cffile.serverfile#" destination="#upload_folder#member#dir_seperator##file_name#.#cffile.serverfileext#">
		<!---Script dosyalarını engelle  02092010 ND --->
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
				alert("<cf_get_lang_main no ='43.Dosyanız Upload Edilemedi ! Dosyanizi Kontrol Ediniz'>!");
				history.back();
			</script>
			<cfabort>
		</cfcatch>
	</cftry>
</cfif>
<cfscript>
	our_company_id_first = listfirst(attributes.our_company_id,',');
	our_company_id_last = listgetat(attributes.our_company_id,2,',');
</cfscript>
<cflock timeout="60">
	<cftransaction>
		<cfquery name="ADD_SECURE" datasource="#DSN#" result="MAX_ID">
			INSERT INTO
				COMPANY_SECUREFUND
			(
				SECUREFUND_STATUS,
				COMPANY_ID,
				BRANCH_ID,
				OUR_COMPANY_ID,
				SECUREFUND_CAT_ID,
				GIVE_TAKE,
				SECUREFUND_TOTAL,
				MONEY_CAT,
				MONEY_CAT_EXPENSE,
				EXPENSE_TOTAL,
				BANK,
				BANK_BRANCH,
				REALESTATE_DETAIL,
				START_DATE,
				FINISH_DATE,
				WARNING_DATE,
				SECUREFUND_FILE,
				SECUREFUND_FILE_SERVER_ID,
				PROCESS_CAT,
				IS_ACTIVE,
				MORTGAGE_OWNER,
				MORTGAGE_TOTAL,
				MORTGAGE_MONEY_CURRENCY,
				EXPERT_TOTAL,
				EXPERT_MONEY_CURRENCY,
				MORTGAGE_RATE,
                MORTGAGE_BANK_DEPT,
                MORTGAGE_BANK_DEPT_MONEY,
                MORTGAGE_BANK,
                MORTGAGE_TOTAL2,
                MORTGAGE_TOTAL2_MONEY,
                MORTGAGE_TYPE,
				RECORD_EMP,
				RECORD_IP,
				RECORD_DATE,
				IS_CRM
			)
			VALUES
			(
				<cfif isdefined("attributes.securefund_status")>1<cfelse>0</cfif>,
				#attributes.company_id#,
				#our_company_id_last#,
				#our_company_id_first#,
				#attributes.securefund_cat_id#,
				#attributes.give_take#,
				#attributes.securefund_total#,
				'#attributes.money_type#',
				<cfif len(attributes.money_cat_expense)>'#attributes.money_cat_expense#'<cfelse>NULL</cfif>,
				<cfif len(attributes.expense_total)>#attributes.expense_total#<cfelse>NULL</cfif>,
				'#attributes.bank#',
				'#attributes.bank_branch#',
				'#attributes.realestate_detail#',
				<cfif len(attributes.start_date)>#attributes.start_date#<cfelse>NULL</cfif>,
				<cfif len(attributes.finish_date)>#attributes.finish_date#<cfelse>NULL</cfif>,
				<cfif len(attributes.warning_date)>#attributes.warning_date#<cfelse>NULL</cfif>,
				<cfif len(attributes.securefund_file)>'#file_name#.#cffile.serverfileext#'<cfelse>NULL</cfif>,
				<cfif len(attributes.securefund_file)>#fusebox.server_machine#<cfelse>NULL</cfif>,				
				#attributes.process_stage#,
				0,
				'#attributes.mortgage_owner#',
				<cfif len(attributes.mortgage_total)>#attributes.mortgage_total#<cfelse>0</cfif>,
				'#attributes.mortgage_money_type#',
				<cfif len(attributes.expert_total)>#attributes.expert_total#<cfelse>0</cfif>,
				'#attributes.expert_money_type#',
				<cfif len(attributes.mortgage_rate)>#attributes.mortgage_rate#<cfelse>0</cfif>,
                <cfif len(attributes.mortgage_bank_dept)>#attributes.mortgage_bank_dept#<cfelse>NULL</cfif>,
                '#attributes.bank_money_type#',
                '#attributes.mortgage_bank#',
                <cfif len(attributes.mortgage_total2)>#attributes.mortgage_total2#<cfelse>NULL</cfif>,
                '#attributes.mortgage_money_type2#',
                '#attributes.mortgage_type#',
				#session.ep.userid#,
				'#cgi.remote_addr#',
				#now()#	,
				1			
			)
		</cfquery>
		<cfset securefund_id = MAX_ID.IDENTITYCOL>
		<cfquery name="ADD_NOTE" datasource="#DSN#">
			INSERT INTO 
				NOTES
			(
				ACTION_SECTION,
				ACTION_ID,
				NOTE_HEAD,
				NOTE_BODY,
				IS_SPECIAL,
				IS_WARNING,
				COMPANY_ID,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
			)
			VALUES
			(
				'SECUREFUND_ID',
				 #MAX_ID.IDENTITYCOL#,
				'#left(attributes.realestate_detail,75)#',
				'#attributes.realestate_detail#',
				 0,
				 0,
				 #session.ep.company_id#,
				 #session.ep.userid#,
				 #now()#,
				'#cgi.remote_addr#'
			)
		</cfquery>
	</cftransaction>
</cflock>

<cf_workcube_process 
	is_upd='1' 
	old_process_line='0'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#' 
	record_date='#now()#' 
	action_page='#request.self#?fuseaction=crm.detail_company&cpid=#attributes.company_id#&is_open_securefund=1&action_id=#MAX_ID.IDENTITYCOL#' 
	action_id='#MAX_ID.IDENTITYCOL#'
	warning_description = 'Teminat Talebi : #attributes.member#'>
<script type="text/javascript">
	location.href= "<cfoutput>#request.self#?fuseaction=crm.list_company_securefund&event=upd&securefund_id=#MAX_ID.IDENTITYCOL#</cfoutput>"
</script>
