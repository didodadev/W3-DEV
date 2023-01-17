<!--- project import --->
<cfsetting showdebugoutput="no">
<cfquery name="GET_PROJECTS" datasource="#DSN#">
	SELECT
		PROJECT_HEAD
	FROM
		PRO_PROJECTS
</cfquery>
<cfif not DirectoryExists("#upload_folder#temp")>
	<cfdirectory action="create" directory="#upload_folder#temp">
</cfif>
<cfset upload_folder_ = "#upload_folder#temp#dir_seperator#">
<cftry>
	<cffile action = "upload" 
			fileField = "uploaded_file" 
			destination = "#upload_folder_#"
			nameConflict = "MakeUnique"  
			mode="777" charset="utf-8">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
	<cffile action="rename" source="#upload_folder_##cffile.serverfile#" destination="#upload_folder_##file_name#" charset="utf-8">	
	<cfset file_size = cffile.filesize>
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
			history.back();
		</script>
		<cfabort>
	</cfcatch>  
</cftry>
<cftry>
	<cffile action="read" file="#upload_folder_##file_name#" variable="dosya" charset="utf-8">
	<cffile action="delete" file="#upload_folder_##file_name#">
<cfcatch>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1653.Dosya Okunamadı Karakter Seti Yanlış Seçilmiş Olabilir'>.");
		history.back();
	</script>
	<cfabort>
</cfcatch>

</cftry>
<cfscript>
	CRLF = Chr(13) & Chr(10);// satır atlama karakteri
	dosya = Replace(dosya,';;','; ;','all');
	dosya = Replace(dosya,';;','; ;','all');
	dosya = ListToArray(dosya,CRLF);
	line_count = ArrayLen(dosya);
	counter = 0;
	liste = "";
</cfscript>
<cfloop from="2" to="#line_count#" index="i">
	<cfset kont=1>
	<cftry>
		<cfset project_head = trim(listgetat(dosya[i],1,';'))>
		<cfset process_cat = trim(listgetat(dosya[i],2,';'))>
		<cfset pro_priority_id = trim(listgetat(dosya[i],3,';'))>
		<cfset workgroup_id = trim(listgetat(dosya[i],4,';'))>
		<cfset project_number = trim(listgetat(dosya[i],5,';'))>
		<cfif len(trim(listgetat(dosya[i],6,';')))>
			<cfset agreement_no = trim(listgetat(dosya[i],6,';'))>
		<cfelse>
			<cfset agreement_no = ''>
		</cfif>      
		<cfset partner_id_no = trim(listgetat(dosya[i],7,';'))>
        <cfset consumer_id_no = trim(listgetat(dosya[i],8,';'))>		
		<cfset project_detail = trim(listgetat(dosya[i],9,';'))>
		<cfset project_target = trim(listgetat(dosya[i],10,';'))>
		<cfset expected_budget = trim(listgetat(dosya[i],11,';'))>
		<cfset budget_currency_id = trim(listgetat(dosya[i],12,';'))>
		<cfset expected_cost = trim(listgetat(dosya[i],13,';'))>
		<cfset cost_currency_id = trim(listgetat(dosya[i],14,';'))>
		<cfset expense_id = trim(listgetat(dosya[i],15,';'))>
		<cfif len(trim(listgetat(dosya[i],16,';')))>
			<cfset related_project_id = trim(listgetat(dosya[i],16,';'))>
		<cfelse>
			<cfset related_project_id = ''>
		</cfif>
		<cfset target_start = trim(listgetat(dosya[i],17,';'))>
		<cfset start_hour = trim(listgetat(dosya[i],18,';'))>
		<cfset target_finish = trim(listgetat(dosya[i],19,';'))>
		<cfset finish_hour = trim(listgetat(dosya[i],20,';'))>
		<cfset project_emp_id = trim(listgetat(dosya[i],21,';'))>
		<cfif trim(listgetat(dosya[i],22,';'))>
			<cfset pro_currency_id = trim(listgetat(dosya[i],22,';'))>
		<cfelse>
			<cfset pro_currency_id = ''>
		</cfif>
		<cfcatch type="Any">
			<cfoutput>#i#</cfoutput>. satır 1. adımda sorun oluştu.<br/>
				<cfset error_flag = 1>
		</cfcatch>  
	</cftry>
	<cfquery name="SAME_PROJECT" dbtype="query">
		SELECT 
			PROJECT_HEAD 
		FROM 
			GET_PROJECTS 
		WHERE
			PROJECT_HEAD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#project_head#">
	</cfquery>
	<cfif same_project.recordcount>
		<cfoutput>#i#</cfoutput>. satırın proje adı daha önceden sistemde kayıtlı<br />
		<cfset same_pro = 1>
	<cfelse>
		<cfset same_pro = 0>
	</cfif>
	<cfif len(target_start) and len(start_hour)>
		<cf_date tarih ="target_start">
		<cfset s_saat = listgetat(start_hour,1,':') * 60>
		<cfset s_saat = s_saat + listgetat(start_hour,2,':')>
		<cfset target_start = dateadd('n',s_saat, target_start)>
		<cfset target_start = dateadd('h',-session.ep.time_zone, target_start)>
	</cfif>
	<cfif len(target_finish) and len(finish_hour)>
		<cf_date tarih ="target_finish">
		<cfset saat = listgetat(finish_hour,1,':') * 60>
		<cfset saat = saat + listgetat(finish_hour,2,':')>
		<cfset target_finish = dateadd('n',saat, target_finish)>
		<cfset target_finish = dateadd('h',-session.ep.time_zone, target_finish)>
	</cfif>
	
	<cfif len(partner_id_no) and (isNumeric(partner_id_no) and partner_id_no neq 0) and not len(consumer_id_no)>
		<cfquery name="get_company" datasource="#dsn#">
			SELECT C.COMPANY_ID,CP.PARTNER_ID FROM COMPANY C,COMPANY_PARTNER CP WHERE C.COMPANY_ID = CP.COMPANY_ID AND <cfif attributes.report_type eq 1>CP.PARTNER_ID<cfelseif attributes.report_type eq 2>C.MEMBER_CODE</cfif> = '#partner_id_no#'
		</cfquery>
		<cfset get_consumer.consumer_id = ''>
	<cfelseif len(consumer_id_no) and (isNumeric(consumer_id_no) and consumer_id_no neq 0) and not len(partner_id_no)>
		<cfquery name="get_consumer" datasource="#dsn#">
			SELECT CONSUMER_ID FROM CONSUMER WHERE <cfif attributes.report_type eq 1>CONSUMER_ID<cfelseif attributes.report_type eq 2>MEMBER_CODE</cfif> = <cfqueryparam cfsqltype="cf_sql_varchar" value="#consumer_id_no#">
		</cfquery>
		<cfset get_company.company_id = ''>
		<cfset get_company.partner_id = ''>
	<cfelseif (len(partner_id_no) and isNumeric(partner_id_no) and partner_id_no neq 0) or (len(consumer_id_no) and isNumeric(consumer_id_no) and consumer_id_no neq 0)>
		<cfset get_company.company_id = ''>
		<cfset get_company.partner_id = ''>
		<cfset get_consumer.consumer_id = ''>
	<cfelse>
		<cfset get_company.company_id = ''>
		<cfset get_company.partner_id = ''>
		<cfset get_consumer.consumer_id = ''>
	</cfif>
	
	<cfif len(budget_currency_id)>
		<cfquery name="GET_MONEY" datasource="#DSN#">
			SELECT MONEY FROM SETUP_MONEY WHERE MONEY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#budget_currency_id#">
		</cfquery>
	<cfelse>
		<cfset get_money.money = ''>
	</cfif>
	<cfif len(cost_currency_id)>
		<cfquery name="GET_MONEY2" datasource="#DSN#">
			SELECT MONEY FROM SETUP_MONEY WHERE MONEY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#cost_currency_id#">
		</cfquery>
	<cfelse>
		<cfset get_money2.money = ''>
	</cfif>
	<cfif len(process_cat)>
		<cfquery name="get_process_cat" datasource="#DSN#">
			SELECT MAIN_PROCESS_CAT_ID FROM SETUP_MAIN_PROCESS_CAT WHERE MAIN_PROCESS_CAT_ID = #process_cat#
		</cfquery>
	<cfelse>
		<cfset get_process_cat.MAIN_PROCESS_CAT_ID = ''>
	</cfif>
	<cfif len(pro_currency_id)>
		<cfquery name="get_pro_currency_id" datasource="#DSN#">
			SELECT
				PTR.PROCESS_ROW_ID
			FROM
				PROCESS_TYPE PT,
				PROCESS_TYPE_ROWS PTR,
				PROCESS_TYPE_OUR_COMPANY PTOC
			WHERE
				PT.IS_ACTIVE = 1 AND
				PT.PROCESS_ID = PTR.PROCESS_ID AND
				PT.PROCESS_ID = PTOC.PROCESS_ID AND
				PTOC.OUR_COMPANY_ID = #session.ep.company_id# AND
				PT.FACTION LIKE '%project.addpro%' AND
				PTR.PROCESS_ROW_ID = #pro_currency_id#
		</cfquery>
	<cfelse>
		<cfset get_pro_currency_id.PROCESS_ROW_ID = ''>
	</cfif>
	<cfif len(expense_id)>
		<cfquery name="GET_EXPENSE" datasource="#DSN2#">
			SELECT EXPENSE_CODE FROM EXPENSE_CENTER WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#expense_id#">
		</cfquery>
	<cfelse>
		<cfset get_expense.expense_code = ''>
	</cfif>
	<cfif same_pro neq 1>
		<cflock name="#CreateUUID()#" timeout="60">
			<cftransaction>
				<cftry>
				<cfquery name="ADD_PROJECT_ITEMS" datasource="#DSN#">
					INSERT INTO 
						PRO_PROJECTS
					(
						PROJECT_HEAD,
						PROCESS_CAT,
						PRO_PRIORITY_ID,
						WORKGROUP_ID,
						PROJECT_NUMBER,
						AGREEMENT_NO,
						COMPANY_ID,
						PARTNER_ID,
						CONSUMER_ID,
						PROJECT_DETAIL,
						PROJECT_TARGET,
						EXPECTED_BUDGET,
						BUDGET_CURRENCY,
						EXPECTED_COST,
						COST_CURRENCY,
						EXPENSE_CODE,
						RELATED_PROJECT_ID,
						TARGET_START,
						TARGET_FINISH,
						PROJECT_EMP_ID,
						PRO_CURRENCY_ID, 
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP
					)
					VALUES
					(
						<cfif isdefined('project_head') and len(project_head)><cfqueryparam cfsqltype="cf_sql_varchar" value="#project_head#"><cfelse>NULL</cfif>,
						#get_process_cat.MAIN_PROCESS_CAT_ID#,
						<cfif isdefined('pro_priority_id') and len(pro_priority_id)>#pro_priority_id#<cfelse>NULL</cfif>,
						<cfif isdefined('workgroup_id') and len(workgroup_id)>#workgroup_id#<cfelse>NULL</cfif>,
						<cfif isdefined('project_number') and len(project_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#project_number#"><cfelse>NULL</cfif>,
						<cfif isdefined('agreement_no') and  len(agreement_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#agreement_no#"><cfelse>NULL</cfif>,
						<cfif len(get_company.company_id)>
							#get_company.company_id#,
							<cfif len(get_company.partner_id)>#get_company.partner_id#<cfelse>NULL</cfif>,
							NULL,
						<cfelseif len(get_consumer.consumer_id)>
							NULL,
							NULL,
							#get_consumer.consumer_id#,
						<cfelse>
							NULL,
							NULL,
							NULL,
						</cfif>
						<cfif isdefined('project_detail') and  len(project_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#project_detail#"><cfelse>NULL</cfif>,
						<cfif isdefined('project_target') and  len(project_target)><cfqueryparam cfsqltype="cf_sql_varchar" value="#project_target#"><cfelse>NULL</cfif>,
						<cfif isdefined('expected_budget') and  len(expected_budget)>#expected_budget#<cfelse>NULL</cfif>,
						<cfif isdefined('get_money.money') and  len(get_money.money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_money.money#"><cfelse>NULL</cfif>,
						<cfif isdefined('expected_cost') and  len(expected_cost)>#expected_cost#<cfelse>NULL</cfif>,
						<cfif isdefined('get_money2.money') and  len(get_money2.money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_money2.money#"><cfelse>NULL</cfif>,
						<cfif isdefined('get_expense.expense_code') and  len(get_expense.expense_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_expense.expense_code#"><cfelse>NULL</cfif>,
						<cfif isdefined('related_project_id') and  len(related_project_id)>#related_project_id#<cfelse>NULL</cfif>,
						<cfif isdefined('target_start') and  len(target_start)>#target_start#<cfelse>NULL</cfif>,
						<cfif isdefined('target_finish') and  len(target_finish)>#target_finish#<cfelse>NULL</cfif>,
						<cfif isdefined('project_emp_id') and  len(project_emp_id)>#project_emp_id#<cfelse>NULL</cfif>,
						#get_pro_currency_id.PROCESS_ROW_ID#,
						#now()#,
						#session.ep.userid#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">								
					)
				</cfquery>
				<cfquery name="GET_LAST_PROJECT" datasource="#DSN#">
					SELECT
						MAX(PROJECT_ID) PROJECT_ID
					FROM
						PRO_PROJECTS
				</cfquery>
				<cfquery name="ADD_PROJECT_ITEM" datasource="#DSN#">
					INSERT INTO 
						PRO_HISTORY
					(
						PROJECT_ID,
						<!---PRO_PRIORITY_ID,
						PROJECT_NUMBER,
						AGREEMENT_NO,
						COMPANY_ID,
						EXPENSE_CODE,
						TARGET_START,
						TARGET_FINISH,
						PROJECT_EMP_ID,
						PRO_CURRENCY_ID--->
						UPDATE_DATE
					)
					VALUES
					(
						#get_last_project.project_id#,
						<!---<cfif isdefined('pro_priority_id') and len(pro_priority_id)>#pro_priority_id#<cfelse>NULL</cfif>,
						<cfif isdefined('project_number') and len(project_number)>'#project_number#'<cfelse>NULL</cfif>,
						<cfif isdefined('agreement_no') and  len(agreement_no)>'#agreement_no#'<cfelse>NULL</cfif>,
						<cfif isdefined('company_id') and  len(company_id)>#company_id#<cfelse>NULL</cfif>,
						<cfif isdefined('get_expense.expense_code') and  len(get_expense.expense_code)>'#get_expense.expense_code#'<cfelse>NULL</cfif>,
						<cfif isdefined('target_start') and  len(target_start)>#target_start#<cfelse>NULL</cfif>,
						<cfif isdefined('target_finish') and  len(target_finish)>#target_finish#<cfelse>NULL</cfif>,
						<cfif isdefined('project_emp_id') and  len(project_emp_id)>#project_emp_id#<cfelse>NULL</cfif>,
						<cfif isdefined('pro_currency_id') and len(pro_currency_id)>#pro_currency_id#<cfelse>NULL</cfif>,--->	
						#now()#					
					)
				</cfquery>
				<cfcatch type="Any">
					<cfoutput>
						#i#. Satırda;<br/>
							<cfif not len(get_process_cat.MAIN_PROCESS_CAT_ID)>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Kategori<br/>
							</cfif>
							<cfif not len(get_pro_currency_id.PROCESS_ROW_ID)>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Aşama<br/>
							</cfif>
							<cfif not len(target_start)>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Başlangıç Tarihi<br/>
							</cfif>
							<cfif not len(start_hour)>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Başlangıç Saati<br/>
							</cfif>
							<cfif not len(target_finish)>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Bitiş Tarihi<br/>
							</cfif>
							<cfif not len(finish_hour)>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Bitiş Saati<br/>
							</cfif>
							&nbsp;&nbsp;&nbsp;&nbsp;<cf_get_lang no ='3130.Eksik Olduğu için Import Yapılamadı'>!<br /> 
					</cfoutput>	
					<cfset kont=0>
				</cfcatch>
				</cftry>
				<cfif kont eq 1>
					<cfoutput>#i#. Satır İmport Edildi...<br/></cfoutput>
				</cfif>
			</cftransaction>
		</cflock>
	</cfif>
</cfloop>
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_project_import';
</script>

