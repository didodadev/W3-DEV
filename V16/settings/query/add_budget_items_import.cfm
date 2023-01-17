<cfif not DirectoryExists("#upload_folder#temp#dir_seperator#")>
	<cfdirectory action="create" directory="#upload_folder#temp#dir_seperator#">
</cfif>
<cfsetting showdebugoutput="no">
<cfset upload_folder_ = "#upload_folder#temp#dir_seperator#">
<cftry>
	<cffile action = "upload" 
			fileField = "uploaded_file" 
			destination = "#upload_folder_#"
			nameConflict = "MakeUnique"  
			mode="777" charset="utf-8">
	<cfset file_name = "#createUUID()#">
 	<cffile action="rename" source="#upload_folder_##cffile.serverfile#" destination="#upload_folder_##file_name#.#cffile.serverfileext#" charset="utf-8">	
	<cfset file_size = cffile.filesize>
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
			history.back();
		</script>
		<cfabort>
	</cfcatch>  
</cftry>
<cfif cffile.serverfileext neq 'csv'>
	<cf_del_server_file output_file="#upload_folder_##file_name#.#cffile.serverfileext#" output_server="#fusebox.server_machine#">
	<script type="text/javascript">
		alert("Girdiğiniz Dosya Bir CSV Dosyası Değil !");
		history.back();
	</script>
	<cfabort>
</cfif>
<cftry>
	<cffile action="read" file="#upload_folder_##file_name#.#cffile.serverfileext#" variable="dosya" charset="utf-8">
	<cffile action="delete" file="#upload_folder_##file_name#.#cffile.serverfileext#">
<cfcatch>
	<script type="text/javascript">
		alert("Dosya Okunamadı! Karakter Seti Yanlış Seçilmiş Olabilir.");
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
<cfset expense_code = ''>
<cfset expense_code_list = ''>
<cfset expense_cat_id_ = ''>
<cfset expense_id_list = ''>
<cfloop from="2" to="#line_count#" index="i">
	<cfset expense_code = trim(listgetat(dosya[i],3,';'))>
	<cfset expense_code_list = listAppend(expense_code_list, expense_code)>
	<cfset expense_cat_id_ = trim(listgetat(dosya[i],1,';'))>
	<cfset expense_id_list = listAppend(expense_id_list, expense_cat_id_)>
</cfloop>
<cfset expense_code_list_unique = listDeleteDuplicates(expense_code_list)>
<cfset expense_id_list_unique = listDeleteDuplicates(expense_id_list)>
<cfloop from="1" to="#line_count-1#" index="i">
	<cfquery name="GET_EXPENSE_CATID" datasource="#dsn2#"><!--- gelen kategori id ile expense_code alıyorum--->
		SELECT EXPENSE_CAT_CODE FROM EXPENSE_CATEGORY WHERE EXPENSE_CAT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value='#trim(listgetat(dosya[i+1],1,';'))#' list="yes">
	</cfquery>
	<cfquery name="get_expense_codes" datasource="#dsn2#">
		SELECT EXPENSE_ITEM_CODE FROM EXPENSE_ITEMS 
		WHERE 
			<cfif GET_EXPENSE_CATID.recordcount>
				EXPENSE_ITEM_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_EXPENSE_CATID.EXPENSE_CAT_CODE#.#listgetat(expense_code_list,i,",")#" list="yes">
			<cfelse>
				EXPENSE_ITEM_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" list="yes" value="#listgetat(expense_code_list_unique,i,",")#">
			</cfif>		
	</cfquery>
	<cfif get_expense_codes.recordcount>
		<script type="text/javascript">
			alert("Aynı bütçe kalemi kodu birden fazla kullanılamaz !");
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfloop>
<cfloop from="2" to="#line_count#" index="i">
	<cfset kont=1>
	<cftry>
		<cfset expense_cat_id = trim(listgetat(dosya[i],1,';'))>
		<cfset expense_item_name = trim(listgetat(dosya[i],2,';'))>
		<cfset expense_code = trim(listgetat(dosya[i],3,';'))>
		<cfset account_code = trim(listgetat(dosya[i],4,';'))>
		<cfset income_expense = trim(listgetat(dosya[i],5,';'))>
		<cfset is_expense = trim(listgetat(dosya[i],6,';'))>
		<cfif (listlen(dosya[i],';') gte 7)>
			<cfset expense_item_detail = trim(listgetat(dosya[i],7,';'))>
		<cfelse>
			<cfset expense_item_detail = ''>
		</cfif>
		<cfcatch type="Any">
			<cfoutput>#i#</cfoutput>. satır 1. adımda sorun oluştu.<br/>
			<cfset error_flag = 1>
		</cfcatch>  
	</cftry>
	<cfif len(expense_cat_id) and isNumeric(expense_cat_id)>
		<cfquery name="get_expense_cat" datasource="#dsn2#">
			SELECT EXPENSE_CAT_ID,EXPENSE_CAT_CODE FROM EXPENSE_CATEGORY WHERE EXPENSE_CAT_ID IN (#expense_cat_id#)
		</cfquery>
	<cfelse>
		<cfset get_expense_cat.expense_cat_id = ''>
		<cfset get_expense_cat.expense_cat_code = ''>
	</cfif>
	<cfif isdefined("account_code") and len(account_code)>
		<cfquery name="get_account" datasource="#dsn2#">
			SELECT ACCOUNT_CODE FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE IN ('#account_code#')
		</cfquery>
	<cfelse>
		<cfset get_account.account_code = ''>
	</cfif>
	<cfif (len(income_expense) and income_expense eq 1) and (len(is_expense) and is_expense eq 1)>
		<cfset income_expense = 1>
		<cfset is_expense = 1>
	<cfelseif (len(income_expense) and income_expense eq 1) and not (len(is_expense) and is_expense eq 1)>
		<cfset income_expense = 1>
		<cfset is_expense = 0>
	<cfelseif not(len(income_expense) and income_expense eq 1) and (len(is_expense) and is_expense eq 1)>
		<cfset income_expense = 0>
		<cfset is_expense = 1>
	<cfelseif not(len(income_expense) and income_expense eq 1) and not(len(is_expense) and is_expense eq 1)>
		<cfset income_expense = ''>
		<cfset is_expense = ''>
	</cfif>
	<cflock name="#CreateUUID()#" timeout="60">
		<cftransaction>
			<cftry>
				<cfquery name="add_expense_items" datasource="#dsn2#">
					INSERT INTO 
						EXPENSE_ITEMS
					(
						IS_ACTIVE,
						EXPENSE_CATEGORY_ID,
						EXPENSE_ITEM_NAME,
						EXPENSE_ITEM_DETAIL,
                        EXPENSE_ITEM_CODE,
						ACCOUNT_CODE,			
						INCOME_EXPENSE,
						IS_EXPENSE,
						RECORD_EMP,
						RECORD_IP,
						RECORD_DATE
					)
					VALUES
					(
						1,
						#get_expense_cat.expense_cat_id#,
						<cfif len(expense_item_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#expense_item_name#"></cfif>,
						<cfif len(expense_item_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#expense_item_detail#"><cfelse>NULL</cfif>,
						<cfif len(expense_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_expense_cat.expense_cat_code#.#expense_code#"><cfelse>NULL</cfif>,
						<cfif len(get_account.account_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_account.account_code#"></cfif>,
						#income_expense#,
						#is_expense#,
						#session.ep.userid#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
						#now()#
					)
				</cfquery>
				<cfcatch type="Any">
					<cfoutput>
						#i#. Satırda <br/>
						<cfif not len(get_expense_cat.expense_cat_id)>
							&nbsp;&nbsp;&nbsp;&nbsp;*Kategori ID Eksik Veya Yanlış.<br/>
						</cfif> 
						<cfif not len(expense_item_name)>
							&nbsp;&nbsp;&nbsp;&nbsp;*Bütçe Adı Eksik.<br/>
						</cfif> <!---
                        <cfif not len(expense_code)>
							&nbsp;&nbsp;&nbsp;&nbsp;*Bütçe Kodu Eksik.<br/>
						</cfif>  --->
						<cfif not len(get_account.account_code)>
							&nbsp;&nbsp;&nbsp;&nbsp;*Muhasebe Kodu Eksik Veya Yanlış.<br/>
						</cfif> 
						<cfif not len(income_expense) or not len(is_expense)>
							&nbsp;&nbsp;&nbsp;&nbsp;*Gelir yada Gider Eksik.<br/>
						</cfif>
					</cfoutput>	
					<cfset kont=0>
				</cfcatch>
			</cftry>
			<cfif kont eq 1>
				<cfoutput>#i#. Satır İmport Edildi... <br/></cfoutput>
			</cfif>
		</cftransaction>
	</cflock>
</cfloop>
<script>
	location.href = document.referrer;
</script>