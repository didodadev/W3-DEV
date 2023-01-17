<cfif len(attributes.start_date)><cf_date tarih = "attributes.start_date"></cfif>
<cfif len(attributes.finish_date)><cf_date tarih = "attributes.finish_date"></cfif>
<cfif len(attributes.warning_date)><cf_date tarih = "attributes.warning_date"></cfif>
<cfif len(attributes.SECUREFUND_FILE)>
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
		<cfif FileExists("#upload_folder#member#dir_seperator##attributes.OLDSECUREFUND_FILE#")>
			<!--- <cffile action="delete" file="#upload_folder#member#dir_seperator##attributes.OLDSECUREFUND_FILE#"> --->
			<cf_del_server_file output_file="member/#attributes.OLDSECUREFUND_FILE#" output_server="#attributes.oldsecurefund_file_server_id#">
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
		<cfquery name="ADD_SECURE" datasource="#DSN#">
			UPDATE 
				COMPANY_SECUREFUND
			SET
				SECUREFUND_STATUS = <cfif isdefined("attributes.securefund_status")>1<cfelse>0</cfif>,
				COMPANY_ID = #attributes.company_id#,
				BRANCH_ID = #our_company_id_last#,
				OUR_COMPANY_ID = #our_company_id_first#,
				SECUREFUND_CAT_ID = #attributes.securefund_cat_id#,
				GIVE_TAKE = #attributes.give_take#,
				SECUREFUND_TOTAL = #attributes.securefund_total#,
				MONEY_CAT = '#attributes.money_type#',
				MONEY_CAT_EXPENSE = <cfif len(attributes.money_cat_expense)>'#attributes.money_cat_expense#'<cfelse>NULL</cfif>,
				EXPENSE_TOTAL = <cfif len(attributes.expense_total)>#attributes.expense_total#<cfelse>NULL</cfif>,
				BANK = '#attributes.bank#',
				BANK_BRANCH = '#attributes.bank_branch#',
				REALESTATE_DETAIL = '#attributes.realestate_detail#',
				START_DATE = <cfif len(attributes.start_date)>#attributes.start_date#<cfelse>NULL</cfif>,
				FINISH_DATE = <cfif len(attributes.finish_date)>#attributes.finish_date#<cfelse>NULL</cfif>,
				WARNING_DATE = <cfif len(attributes.warning_date)>#attributes.warning_date#<cfelse>NULL</cfif>,
				SECUREFUND_FILE = <cfif Len(attributes.securefund_file)>'#file_name#.#cffile.serverfileext#'<cfelse>NULL</cfif>,
				SECUREFUND_FILE_SERVER_ID = <cfif Len(attributes.securefund_file)>#fusebox.server_machine#<cfelse>NULL</cfif>,
				RECORD_EMP = #session.ep.userid#,
				UPDATE_IP = '#cgi.remote_addr#',
				UPDATE_DATE = #now()#,
				PROCESS_CAT = #attributes.process_stage#,
				<!--- BK kaldirdi 120 gune siline 20080625 IS_ACTIVE = 0, --->
				MORTGAGE_OWNER = '#attributes.mortgage_owner#',
				MORTGAGE_TOTAL = <cfif len(attributes.mortgage_total)>#attributes.mortgage_total#<cfelse>0</cfif>,
				MORTGAGE_MONEY_CURRENCY = '#attributes.mortgage_money_type#',
				EXPERT_TOTAL = <cfif len(attributes.expert_total)>#attributes.expert_total#<cfelse>0</cfif>,
				EXPERT_MONEY_CURRENCY = '#attributes.expert_money_type#',
				MORTGAGE_RATE = <cfif len(attributes.mortgage_rate)>#attributes.mortgage_rate#<cfelse>0</cfif>,
                MORTGAGE_BANK_DEPT = <cfif len(attributes.mortgage_bank_dept)>#attributes.mortgage_bank_dept#<cfelse>0</cfif>,
                MORTGAGE_BANK_DEPT_MONEY = '#attributes.bank_money_type#',
                MORTGAGE_BANK = '#attributes.mortgage_bank#',
                MORTGAGE_TOTAL2 = <cfif len(attributes.mortgage_total2)>#attributes.mortgage_total2#<cfelse>0</cfif>,
                MORTGAGE_TOTAL2_MONEY = '#attributes.mortgage_money_type2#',
                MORTGAGE_TYPE = <cfif len(attributes.mortgage_type)>#attributes.mortgage_type#<cfelse>NULL</cfif>,
				IS_CRM = 1
			WHERE
				SECUREFUND_ID = #attributes.securefund_id#
		</cfquery>
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
				 #attributes.securefund_id#,
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
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#' 
	record_date='#now()#' 
	action_page='#request.self#?fuseaction=crm.detail_company&cpid=#attributes.company_id#&is_open_securefund=1&action_id=#attributes.securefund_id#' 
	action_id='#attributes.securefund_id#'
	old_process_line='#attributes.old_process_line#'
	warning_description = 'Teminat Talebi : #attributes.member#'>

<script type="text/javascript">
	location.href= document.referrer;
</script>
