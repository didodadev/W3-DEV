
<cfset upload_folder_ = "#upload_folder#settings#dir_seperator#">
<cftry>
    <cffile action = "upload"
            filefield = "uploaded_file"
            destination = "#upload_folder_#"
            nameconflict = "MakeUnique"
            mode="777" charset="utf-8">
    <cfset file_name = "#createUUID()#.#cffile.serverfileext#">
    <cffile action="rename" source="#upload_folder_##cffile.serverfile#" destination="#upload_folder_##file_name#" charset="utf-8">
    <cfset file_size = cffile.filesize>
    <cfcatch type="Any">
        <script type="text/javascript">
            alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
            window.location.replace(document.refferer);
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
            window.location.replace(document.refferer);
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
</cfscript>

<cfloop from="2" to="#line_count#" index="i">
    <cfset kont = 1>
    <cftry>
        <cfset securefund_cat_id = trim(listgetat(dosya[i],1,';'))>
        <cfset action_cat_id = trim(listgetat(dosya[i],2,';'))>
        <cfset our_company_id = trim(listgetat(dosya[i],3,';'))>
        <cfset company_id = trim(listgetat(dosya[i],4,';'))>
        <cfset status = trim(listgetat(dosya[i],5,';'))>
        <cfset action_value = trim(listgetat(dosya[i],6,';'))>
        <cfset commission_rate = trim(listgetat(dosya[i],7,';'))>
        <cfset securefund_total = trim(listgetat(dosya[i],8,';'))>
        <cfset give_take = trim(listgetat(dosya[i],9,';'))>
        <cfset money_cat = trim(listgetat(dosya[i],10,';'))>
        <cfset expense_total = trim(listgetat(dosya[i],11,';'))>
        <cfset expense_money_cat = trim(listgetat(dosya[i],12,';'))>
        <cfset bank_brach_id = trim(listgetat(dosya[i],13,';'))>
        <cfset detail = trim(listgetat(dosya[i],14,';'))>
        <cfset start_date = trim(listgetat(dosya[i],15,';'))>
        <cfset finish_date = trim(listgetat(dosya[i],16,';'))>
        <cfset action_value2 = trim(listgetat(dosya[i],17,';'))>
        <cfset given_acc_code = trim(listgetat(dosya[i],18,';'))>
        <cfset taken_acc_code = trim(listgetat(dosya[i],19,';'))>
        <cfset action_period_id = trim(listgetat(dosya[i],20,';'))>
        <cfset project_id = trim(listgetat(dosya[i],21,';'))>
        <cfset credit_limit_id = trim(listgetat(dosya[i],22,';'))>
        <cfset contract_id = trim(listgetat(dosya[i],23,';'))>
        <cfset offer_id = trim(listgetat(dosya[i],24,';'))>
        <cfset ourcomp_branch_id = trim(listgetat(dosya[i],25,';'))>
        <cfif len(start_date) and isDate(start_date)>
            <cf_date tarih="start_date">
        </cfif>
        <cfif len(finish_date) and isDate(finish_date)>
            <cf_date tarih="finish_date">
        </cfif>
        <cfcatch type="Any">
            <cfoutput>#i-1#</cfoutput>. satır 1. adımda sorun oluştu.<br/>
            <cfset error_flag = 1>
        </cfcatch>
    </cftry>

    <cftransaction>
        <cftry>
            <cfquery name="get_process_type" datasource="#dsn2#">
                SELECT 
                    PROCESS_TYPE,
                    IS_ACCOUNT,
                    IS_CARI
                 FROM 
                    #dsn3#.SETUP_PROCESS_CAT 
                WHERE 
                    PROCESS_CAT_ID = #action_cat_id#
            </cfquery>
            <cfquery name="GET_GENERAL_PAPERS" datasource="#dsn2#">
				SELECT
                    SECUREFUND_NO,
                    SECUREFUND_NUMBER
                FROM
                    #dsn3#.GENERAL_PAPERS 
                WHERE
                    PAPER_TYPE IS NULL
            </cfquery>
            <cfquery name="GET_MONEY" datasource="#dsn2#">
                SELECT
                    MONEY,
                    RATE1,
                    RATE2
                FROM
                    SETUP_MONEY
                WHERE
                    MONEY_STATUS = 1
                    AND MONEY <> <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#money_cat#">
                    <cfif money_cat neq session.ep.money2>
                        AND MONEY <> <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#session.ep.money2#">
                    </cfif>
            </cfquery>
            <cfset process_type = get_process_type.PROCESS_TYPE>
            <cfset belge_no = "#GET_GENERAL_PAPERS.SECUREFUND_NO#-#GET_GENERAL_PAPERS.SECUREFUND_NUMBER + 1#">
            <cfquery name="add_securefund" datasource="#dsn2#" result="MAX_ID">
                INSERT INTO #dsn#.COMPANY_SECUREFUND
                    (
                        SECUREFUND_CAT_ID,
                        ACTION_TYPE_ID,
                        ACTION_CAT_ID,
                        OUR_COMPANY_ID,
                        COMPANY_ID,
                        SECUREFUND_STATUS,
                        ACTION_VALUE,
                        COMMISSION_RATE,
                        SECUREFUND_TOTAL,
                        GIVE_TAKE,
                        MONEY_CAT,
                        EXPENSE_TOTAL,
                        MONEY_CAT_EXPENSE,
                        BANK_BRANCH_ID,
                        REALESTATE_DETAIL,
                        START_DATE,
                        FINISH_DATE,
                        ACTION_VALUE2,
                        GIVEN_ACC_CODE,
                        TAKEN_ACC_CODE,
                        ACTION_PERIOD_ID,
                        PROJECT_ID,
                        CREDIT_LIMIT,
                        CONTRACT_ID,
                        OFFER_ID,
                        OURCOMP_BRANCH,
                        PAPER_NO,
                        RECORD_EMP,
                        RECORD_IP,
                        RECORD_DATE
                    )
                VALUES
                    (
                        <cfif len(securefund_cat_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#securefund_cat_id#"><cfelse>NULL</cfif>,
                        <cfif len(process_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#process_type#"><cfelse>NULL</cfif>,
                        <cfif len(action_cat_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#action_cat_id#"><cfelse>NULL</cfif>,
                        <cfif len(our_company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#our_company_id#"><cfelse>NULL</cfif>,
                        <cfif len(company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#company_id#"><cfelse>NULL</cfif>,
                        <cfif len(status)><cfqueryparam cfsqltype="cf_sql_bit" value="#status#"><cfelse>NULL</cfif>,
                        <cfif len(action_value)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(action_value)#"><cfelse>NULL</cfif>,
                        <cfif len(commission_rate)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(commission_rate)#"><cfelse>NULL</cfif>,
                        <cfif len(securefund_total)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(securefund_total)#"><cfelse>NULL</cfif>,
                        <cfif len(give_take)><cfqueryparam cfsqltype="cf_sql_bit" value="#give_take#"><cfelse>NULL</cfif>,
                        <cfif len(money_cat)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#money_cat#"><cfelse>NULL</cfif>,
                        <cfif len(expense_total)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(expense_total)#"><cfelse>NULL</cfif>,
                        <cfif len(expense_money_cat)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#expense_money_cat#"><cfelse>NULL</cfif>,
                        <cfif len(bank_brach_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#bank_brach_id#"><cfelse>NULL</cfif>,
                        <cfif len(detail)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#detail#"><cfelse>NULL</cfif>,
                        <cfif len(start_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#start_date#"><cfelse>NULL</cfif>,
                        <cfif len(finish_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#finish_date#"><cfelse>NULL</cfif>,
                        <cfif len(action_value2)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(action_value2)#"><cfelse>NULL</cfif>,
                        <cfif len(given_acc_code)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#given_acc_code#"><cfelse>NULL</cfif>,
                        <cfif len(taken_acc_code)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#taken_acc_code#"><cfelse>NULL</cfif>,
                        <cfif len(action_period_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#action_period_id#"><cfelse>NULL</cfif>,
                        <cfif len(project_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#project_id#"><cfelse>NULL</cfif>,
                        <cfif len(credit_limit_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#credit_limit_id#"><cfelse>NULL</cfif>,
                        <cfif len(contract_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#contract_id#"><cfelse>NULL</cfif>,
                        <cfif len(offer_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#offer_id#"><cfelse>NULL</cfif>,
                        <cfif len(ourcomp_branch_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#ourcomp_branch_id#"><cfelse>NULL</cfif>,
                        <cfif isdefined("belge_no") and len(belge_no)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#belge_no#"><cfelse>NULL</cfif>,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    )
            </cfquery>
            <cfset money_currency_rate = filterNum(action_value) / filterNum(securefund_total)>
            <cfif money_cat neq session.ep.money2>
                <cfset money_currency_rate2 = filterNum(action_value) / filterNum(action_value2)>
                <cfquery name="ADD_MONEY_CAT" datasource="#dsn2#">
                    INSERT INTO
                        #dsn_alias#.COMPANY_SECUREFUND_MONEY
                        (
                            MONEY_TYPE,
                            ACTION_ID,
                            RATE2,
                            RATE1,
                            IS_SELECTED
                        )
                        VALUES
                        (
                            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#session.ep.money2#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">,
                            <cfqueryparam cfsqltype="cf_sql_float" value="#money_currency_rate2#">,
                            <cfqueryparam cfsqltype="cf_sql_float" value="1">,
                            0
                        )
                </cfquery>
            </cfif>
            <cfquery name="ADD_MONEY_CAT" datasource="#dsn2#">
                INSERT INTO
                    #dsn_alias#.COMPANY_SECUREFUND_MONEY
                    (
                        MONEY_TYPE,
                        ACTION_ID,
                        RATE2,
                        RATE1,
                        IS_SELECTED
                    )
                    VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#money_cat#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">,
                        <cfqueryparam cfsqltype="cf_sql_float" value="#money_currency_rate#">,
                        <cfqueryparam cfsqltype="cf_sql_float" value="1">,
                        1
                    )
            </cfquery>
            <cfoutput query="GET_MONEY">
                <cfquery name="ADD_MONEY" datasource="#dsn2#">
                    INSERT INTO
                        #dsn_alias#.COMPANY_SECUREFUND_MONEY
                        (
                            MONEY_TYPE,
                            ACTION_ID,
                            RATE2,
                            RATE1,
                            IS_SELECTED
                        )
                        VALUES
                        (
                            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#MONEY#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">,
                            <cfqueryparam cfsqltype="cf_sql_float" value="#RATE2#">,
                            <cfqueryparam cfsqltype="cf_sql_float" value="#RATE1#">,
                            0
                        )
                </cfquery>
            </cfoutput>
            <cfif len(belge_no)>
                <cfquery name="UPD_GENERAL_PAPERS" datasource="#dsn2#">
                    UPDATE 
                        #dsn3#.GENERAL_PAPERS
                    SET
                        SECUREFUND_NUMBER = #GET_GENERAL_PAPERS.SECUREFUND_NUMBER + 1#
                    WHERE
                        SECUREFUND_NUMBER IS NOT NULL
                </cfquery>
            </cfif>
            <cfcatch>
                <cfoutput>
                    #i-1#. Satırda Sorun Oluştu.
                </cfoutput>	
                <cfset kont=0>
            </cfcatch>
        </cftry>
        <cfif kont eq 1>
            <cfoutput>#i-1#. Satır İmport Edildi... <br/></cfoutput>
        </cfif>
    </cftransaction>
</cfloop>