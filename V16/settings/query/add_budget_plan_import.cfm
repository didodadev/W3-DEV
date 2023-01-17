<cfsetting showdebugoutput="no">
<cfset upload_folder_ = "#upload_folder#settings#dir_seperator#">
<cftry>
	<cffile action = "upload" 
			fileField = "uploaded_file" 
			destination = "#upload_folder_#"
			nameConflict = "MakeUnique"  
			mode="777" charset="#attributes.file_format#">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
	<cffile action="rename" source="#upload_folder_##cffile.serverfile#" destination="#upload_folder_##file_name#" charset="#attributes.file_format#">	
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
	<cffile action="read" file="#upload_folder_##file_name#" variable="dosya" charset="#attributes.file_format#">
	<cffile action="delete" file="#upload_folder_##file_name#">
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
<cfset baslangic = 2>
<cfset belge_sayisi = 1>
<cfset satir_sayisi = attributes.line_count_each_document>
<cfloop index="aaa" from="2" to="#line_count#" step="#satir_sayisi#">
<cfset income_total_list = 0>
<cfset expense_total_list = 0>
        <cfquery name="get_process_cat" datasource="#dsn3#">
            SELECT PROCESS_TYPE FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #attributes.process_cat#
        </cfquery>
        <cfquery name="add_" datasource="#dsn#" result="MAXID">
        INSERT INTO
            BUDGET_PLAN
        (
            PROCESS_STAGE,
            PROCESS_TYPE,
            PROCESS_CAT,
            PAPER_NO,
            BUDGET_PLAN_DATE,
            BRANCH_ID,
            ACC_DEPARTMENT_ID,
            PERIOD_ID,
            OUR_COMPANY_ID,
            IS_SCENARIO,
            OTHER_MONEY,
            RECORD_EMP,
            RECORD_DATE,
            RECORD_IP
        )
        VALUES
        (
            #attributes.PROCESS_STAGE#,
            #get_process_cat.PROCESS_TYPE#,
            #attributes.PROCESS_CAT#,
            'BGP_I_#belge_sayisi#',
            #now()#,
            #attributes.acc_branch_id#,
            #attributes.acc_department_id#,
            #session.ep.period_id#,
            #session.ep.company_id#,
            0,
            'TL',
            #session.ep.userid#,
            #now()#,
            '#cgi.REMOTE_ADDR#'
        )
        </cfquery>
        <cfset BUDGET_PLAN_ID = MAXID.IDENTITYCOL>
        <cfquery name="add_money" datasource="#dsn#">
        INSERT INTO
        	BUDGET_PLAN_MONEY
        (
        	ACTION_ID,
            MONEY_TYPE,
            RATE1,
            RATE2,
            IS_SELECTED
        )
        SELECT
        	#BUDGET_PLAN_ID#,
            MONEY,
            1,
            RATE2,
            CASE WHEN MONEY = 'TL' THEN 1 ELSE 0 END AS IS_SELECTED
        FROM
        	#dsn2_alias#.SETUP_MONEY
        </cfquery>
    <cfloop from="#baslangic#" to="#baslangic+satir_sayisi-1#" index="i">
        <cfset expense_total = 0>
        <cfset income_total = 0>
        <cfif baslangic gte line_count>
            <cfbreak>
        </cfif>
        <cfset kont=1>
        <cftry>
            <cfset expense_date = trim(listgetat(dosya[i],1,';'))>
            <cfset detail = trim(listgetat(dosya[i],2,';'))>
            <cfset expence_center_id = trim(listgetat(dosya[i],3,';'))>
            <cfset expence_item_id = trim(listgetat(dosya[i],4,';'))>
            <cfset account_code = trim(listgetat(dosya[i],5,';'))>
            <cfset activity_type = trim(listgetat(dosya[i],6,';'))>
            <cfset workgroup_id = trim(listgetat(dosya[i],7,';'))>
            <cfset comp_code = trim(listgetat(dosya[i],8,';'))>
            <cfset cons_code = trim(listgetat(dosya[i],9,';'))>
            <cfset income_total = trim(ListGetAt(dosya[i],10,";"))>
            <cfif listlen(dosya[i],';') eq 11>
                <cfset expense_total = trim(ListGetAt(dosya[i],11,";"))>
            </cfif>
            <cf_date tarih='expense_date'>
            <cfif not len(income_total)>
                <cfset income_total = 0>
            </cfif>
            <cfif not len(expense_total)>
                <cfset expense_total = 0>
            </cfif>
            <cfquery name="ADD_ROW" datasource="#dsn#">
                INSERT INTO
                    BUDGET_PLAN_ROW
                (
                    BUDGET_PLAN_ID,
                    PLAN_DATE,
                    DETAIL,
                    EXP_INC_CENTER_ID,
                    BUDGET_ITEM_ID,
                    BUDGET_ACCOUNT_CODE,
                    ACTIVITY_TYPE_ID,
                    WORKGROUP_ID,
                    RELATED_EMP_ID,
                    RELATED_EMP_TYPE,
                    ROW_TOTAL_INCOME,
                    ROW_TOTAL_EXPENSE,
                    ROW_TOTAL_DIFF,
                    OTHER_ROW_TOTAL_INCOME,
                    OTHER_ROW_TOTAL_EXPENSE,
                    OTHER_ROW_TOTAL_DIFF,
                    ROW_TOTAL_INCOME_2,
                    ROW_TOTAL_EXPENSE_2,
                    ROW_TOTAL_DIFF_2
                )
                VALUES
                (
                    #BUDGET_PLAN_ID#,
                    <cfif len(expense_date)>#expense_date#<cfelse>NULL</cfif>,
                    <cfif len(detail)>'#detail#'<cfelse>NULL</cfif>,
                    <cfif len(expence_center_id)>#expence_center_id#<cfelse>NULL</cfif>,
                    <cfif len(expence_item_id)>#expence_item_id#<cfelse>NULL</cfif>,
                    <cfif len(account_code)>'#account_code#'<cfelse>NULL</cfif>,
                    <cfif len(activity_type)>#activity_type#<cfelse>NULL</cfif>,
                    <cfif len(workgroup_id)>#workgroup_id#<cfelse>NULL</cfif>,
                    <cfif len(comp_code)>#comp_code#<cfelseif len(cons_code)>#cons_code#<cfelse>NULL</cfif>,
                    <cfif len(comp_code)>'consumer'<cfelseif len(cons_code)>'partner'<cfelse>NULL</cfif>,
                    #income_total#,
                    #expense_total#,
                    #income_total-expense_total#,
                    #income_total#,
                    #expense_total#,
                    #income_total-expense_total#,
                    #income_total#,
                    #expense_total#,
                    #income_total-expense_total#
                )
            </cfquery>
            
            <cfcatch type="Any">
                <cfif i lte line_count>
                    <cfoutput>#i#</cfoutput>. satır 1. adımda sorun oluştu.<br/>
                    <cfset error_flag = 1>
                </cfif>
            </cfcatch>
        </cftry>
        <cfset income_total_list = income_total_list + income_total>
        <cfset expense_total_list = expense_total_list + expense_total>
    </cfloop>
    <cfquery name="upd_totals" datasource="#dsn#">
        UPDATE 
            BUDGET_PLAN 
        SET
        	OTHER_MONEY = 'TL',
            INCOME_TOTAL = #income_total_list# ,
            EXPENSE_TOTAL = #expense_total_list#,
            DIFF_TOTAL = #income_total_list-expense_total_list#,
            INCOME_TOTAL_2 = #income_total_list# ,
            EXPENSE_TOTAL_2 = #expense_total_list#,
            DIFF_TOTAL_2 = #income_total_list-expense_total_list#,
            OTHER_INCOME_TOTAL = #income_total_list#,
            OTHER_EXPENSE_TOTAL = #expense_total_list#,
            OTHER_DIFF_TOTAL = #income_total_list-expense_total_list#
        WHERE 
            BUDGET_PLAN_ID = #BUDGET_PLAN_ID#
    </cfquery>
    <cfset belge_sayisi = belge_sayisi + 1>
    <cfset baslangic = baslangic + satir_sayisi>
</cfloop>

<cflocation url="#request.self#?fuseaction=budget.list_plan_rows&form_submitted=1" addtoken="no">
