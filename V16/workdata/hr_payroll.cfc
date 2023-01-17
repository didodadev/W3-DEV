<cfcomponent>
    
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2= "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">
    
    <cffunction name="GET_EXPENSE_RULES" access="remote"  returntype="any">
        <cfargument name="expense_hr_rules_id" default="">
        <cfargument name="keyword" default="">
        <cfargument name="position_cat_id" default="">
        <cfquery name="GET_EXPENSE_RULES" datasource="#dsn#" result="MAX_ID">
            SELECT 
                EHR.EXPENSE_HR_RULES_ID,
                EHR.EXPENSE_HR_RULES_TYPE,
                EHR.EXPENSE_HR_RULES_DESCRIPTION,
                EHR.EXPENSE_HR_RULES_DETAIL,
                EHR.DAILY_PAY_MAX,
                EHR.MONEY_TYPE,
                EHR.FIRST_LEVEL_DAY_MAX,
                EHR.FIRST_LEVEL_PAY_RATE,
                EHR.SECOND_LEVEL_DAY_MAX,
                EHR.SECOND_LEVEL_PAY_RATE,
                EHR.RULE_START_DATE,
                EHR.TAX_EXCEPTION_AMOUNT,
                EHR.TAX_EXCEPTION_MONEY_TYPE,
                EHR.IS_INCOME_TAX_INCLUDE,
                EHR.IS_STAMP_TAX,
                EHR.TAX_RANK_FACTOR,
                EHR.EXPENSE_CENTER,
                EHR.EXPENSE_ITEM_ID,
                EC.EXPENSE,
                EI.EXPENSE_ITEM_NAME,
                EHR.UPDATE_DATE,
                EHR.UPDATE_EMP,
                EHR.UPDATE_IP,
                EHR.RECORD_DATE,
                EHR.RECORD_EMP,
                EHR.RECORD_IP,               
                EHR.IS_COUNTRY_OUT,
                EHR.IS_ACTIVE,
                EHR.ADDITIONAL_ALLOWANCE_ID
            FROM 
              EXPENSE_HR_RULES EHR
              LEFT JOIN #dsn2#.EXPENSE_CENTER EC ON EHR.EXPENSE_CENTER=EC.EXPENSE_ID
              LEFT JOIN #dsn2#.EXPENSE_ITEMS EI ON EHR.EXPENSE_ITEM_ID=EI.EXPENSE_ITEM_ID
            WHERE 
                EHR.IS_ACTIVE = 1
                <cfif isdefined("arguments.expense_hr_rules_id") and len(arguments.expense_hr_rules_id)>
                  AND EHR.EXPENSE_HR_RULES_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_hr_rules_id#">
                </cfif>
                <cfif isdefined("arguments.keyword") and len(arguments.keyword)>
                  AND EHR.EXPENSE_HR_RULES_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                </cfif>
                <cfif isDefined("arguments.position_cat_id") and len(arguments.position_cat_id)>
                  AND EHR.EXPENSE_HR_RULES_ID IN (SELECT EXPENSE_HR_RULES_ID FROM MARCHING_MONEY_POSITION_CATS WHERE POSITION_CAT_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.position_cat_id#'>)
                </cfif>
        </cfquery>
        <cfreturn GET_EXPENSE_RULES>
    </cffunction>
    
    <cffunction name="get_employee_position">
      <cfargument name="employee_id">

      <cfquery name="query_employee_position" datasource="#dsn#">
        SELECT POSITION_CAT_ID
        FROM 
        EMPLOYEE_POSITIONS
        WHERE EMPLOYEE_POSITIONS.EMPLOYEE_ID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.employee_id#">
      </cfquery>

      <cfif query_employee_position.recordcount gt 0>
        <cfreturn query_employee_position.POSITION_CAT_ID>
      <cfelse>
        <cfreturn "">
      </cfif>
    </cffunction>

    <cffunction name="calculate_expense_puantaj" access="remote"  returntype="any">
      <cfargument name = "in_out_id">
      <cfargument name = "expense_date">
      <cfargument name = "employee_id">
      <cfargument name = "sal_mon">
      <cfargument name = "total_amount">
      <cfargument name = "branch_id">
      <cfargument name = "group_id">
      <cfargument name = "expense_puantaj_id">
      <cfargument name = "expense_type">
      <cfargument name = "expense_type_id">
      <cfargument name = "expense_day">
      <cfargument name = "sal_year">
      <cfquery name="get_hr_ssk" datasource="#dsn#">
        SELECT
          E.EMPLOYEE_ID,
          BRANCH.BRANCH_ID,
          EIO.PUANTAJ_GROUP_IDS,
          EIO.IN_OUT_ID,
          EIO.CUMULATIVE_TAX_TOTAL,
          EIO.IS_TAX_FREE,
          EIO.IS_DAMGA_FREE,
          EIO.USE_SSK,
          EIO.SSK_STATUTE
        FROM
          EMPLOYEES_IDENTY EI,
          EMPLOYEES_DETAIL ED,
          EMPLOYEES_IN_OUT EIO,
          BRANCH,
          DEPARTMENT,
          OUR_COMPANY,
          EMPLOYEES E
        WHERE
          EIO.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
          BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID AND
          E.EMPLOYEE_ID = EI.EMPLOYEE_ID AND
          E.EMPLOYEE_ID = ED.EMPLOYEE_ID AND
          E.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND
          (EIO.IS_PUANTAJ_OFF = 0 OR EIO.IS_PUANTAJ_OFF IS NULL) AND
          EIO.IN_OUT_ID = #arguments.in_out_id#
          AND BRANCH.BRANCH_ID = EIO.BRANCH_ID
      </cfquery>
      <cfquery name="get_factor_definition" datasource="#dsn#" maxrows="1">
        SELECT SALARY_FACTOR FROM SALARY_FACTOR_DEFINITION WHERE STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.expense_date#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.expense_date#">  AND SALARY_FACTOR>0
      </cfquery>
      <cfif get_factor_definition.recordcount eq 0>
        <script type="text/javascript">
          alert("İlgili Dönemde Aylık Katsayı Tanımı Bulunamadı !");
          history.back();
        </script>
        <cfabort>
      </cfif>
      <cfquery name="get_position_cat" datasource="#dsn#">
        SELECT TITLE_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#"> AND IS_MASTER = 1
      </cfquery>
      <cfquery name="get_expense_factor" datasource="#dsn#" maxrows="1">
        SELECT 
          <cfif arguments.expense_type eq 0>
            DOMESTIC_FACTOR FACTOR
          <cfelse>
            OVERSEAS_FACTOR	FACTOR
          </cfif>
        FROM 
          MARCHING_MONEY_MAIN M1,
          MARCHING_MONEY_FACTORS M2,
          MARCHING_MONEY_POSITION_CATS M3 
        WHERE 
          M1.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.expense_date#"> 
          AND M1.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.expense_date#"> 
          AND M1.MARCHING_MONEY_MAIN_ID = M2.MARCHING_MONEY_MAIN_ID
          AND M2.MARCH_MONEY_ID = M3.MARCH_MONEY_ID
          AND M3.TITLE_ID = #get_position_cat.title_id#
          <cfif arguments.expense_type eq 1>
            AND DOMESTIC_FACTOR > 0
          <cfelse>
            AND OVERSEAS_FACTOR	> 0
          </cfif>
      </cfquery>
      <cfif get_expense_factor.recordcount eq 0>
        <script type="text/javascript">
          alert("İlgili Dönemde Harcırah Katsayısı Tanımı Bulunamadı !");
          history.back();
        </script>
        <cfabort>
      </cfif>
      <cfquery name="get_insurance" datasource="#dsn#">
        SELECT * FROM INSURANCE_PAYMENT WHERE STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.expense_date#">  AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.expense_date#"> 
      </cfquery>
      <cfif isdefined("arguments.expense_type_id") and len(arguments.expense_type_id)>
        <cfset salary_factor = 0>
      <cfelseif get_factor_definition.recordcount>
        <cfset salary_factor = get_factor_definition.salary_factor>
      <cfelse>
        <cfset salary_factor = 0>
      </cfif>
      <cfif get_expense_factor.recordcount>
        <cfset expense_factor = get_expense_factor.factor>
      <cfelse>
        <cfset expense_factor = 0>
      </cfif>
      <cfscript>
        last_month_1 = CreateDateTime(arguments.sal_year, arguments.sal_mon,1,0,0,0);
        last_month_30 = CreateDateTime(arguments.sal_year, arguments.sal_mon,daysinmonth(last_month_1),23,59,59);
        if(len(arguments.total_amount))
          puantaj_amount = arguments.total_amount;
        else 
          puantaj_amount = salary_factor*expense_factor*arguments.expense_day;
        last_branch_id = get_hr_ssk.BRANCH_ID;
        arguments.branch_id = get_hr_ssk.BRANCH_ID;
        arguments.group_id = "";
        if(len(get_hr_ssk.puantaj_group_ids))
          arguments.group_id = "#get_hr_ssk.PUANTAJ_GROUP_IDS#,";
      </cfscript>
      <cfinclude template="../query/get_program_parameter.cfm">
      <cfquery name="get_active_program_parameter" dbtype="query">
        SELECT * FROM get_program_parameters
      </cfquery>
      <cfquery name="get_active_tax_slice" datasource="#dsn#">
        SELECT 
          MIN_PAYMENT_1, MIN_PAYMENT_2, MIN_PAYMENT_3, MIN_PAYMENT_4, MIN_PAYMENT_5, MIN_PAYMENT_6,
          MAX_PAYMENT_1, MAX_PAYMENT_2, MAX_PAYMENT_3, MAX_PAYMENT_4, MAX_PAYMENT_5, MAX_PAYMENT_6,
          RATIO_1, RATIO_2, RATIO_3, RATIO_4, RATIO_5, RATIO_6, SAKAT1, SAKAT2, SAKAT3, SAKAT_STYLE
        FROM 
          SETUP_TAX_SLICES 
        WHERE 
          STARTDATE <= #last_month_1# AND FINISHDATE >= #DATEADD("d", -1, last_month_30)#
      </cfquery>
      <cfif len(get_active_program_parameter.TAX_ACCOUNT_STYLE)>
        <cfset this_tax_account_style_ = get_active_program_parameter.TAX_ACCOUNT_STYLE>
      <cfelse>
        <cfset this_tax_account_style_ = 0>
      </cfif>
      <cfquery name="get_kumulative" datasource="#dsn#" maxrows="1">
        SELECT 
          KUMULATIF_GELIR_MATRAH 
        FROM 
          EMPLOYEES_EXPENSE_PUANTAJ EPR
          <cfif this_tax_account_style_ eq 1>
            ,BRANCH B
          </cfif>
        WHERE 
          <cfif this_tax_account_style_ eq 1>
            EPR.BRANCH_ID = B.BRANCH_ID AND
            B.COMPANY_ID = (SELECT B2.COMPANY_ID FROM BRANCH B2 WHERE B2.BRANCH_ID = #get_hr_ssk.BRANCH_ID#) AND
          </cfif>
          EPR.EMPLOYEE_ID = #arguments.employee_id# AND 
          EPR.EXPENSE_DATE <= #arguments.expense_date# AND 
          YEAR(EPR.EXPENSE_DATE) >= #year(arguments.expense_date)# AND 
          MONTH(EPR.EXPENSE_DATE) = #month(arguments.expense_date)#
          <cfif isdefined("arguments.expense_puantaj_id")>
            AND EXPENSE_PUANTAJ_ID<>#arguments.expense_puantaj_id#
          </cfif>
        ORDER BY 
          EPR.EXPENSE_DATE DESC
      </cfquery>
      <cfif arguments.SAL_MON neq 1>
        <cfif not get_kumulative.recordcount>
          <cfquery name="get_kumulative" datasource="#dsn#" maxrows="1">
            SELECT 
              KUMULATIF_GELIR_MATRAH 
            FROM 
              EMPLOYEES_PUANTAJ EP,
              EMPLOYEES_PUANTAJ_ROWS EPR
              <cfif this_tax_account_style_ eq 1>
                ,BRANCH B
              </cfif>
            WHERE 
              <cfif this_tax_account_style_ eq 1>
                EP.SSK_BRANCH_ID = B.BRANCH_ID AND
                B.COMPANY_ID = (SELECT B2.COMPANY_ID FROM BRANCH B2 WHERE B2.BRANCH_ID = #get_hr_ssk.BRANCH_ID#) AND
              </cfif>
              EP.PUANTAJ_ID = EPR.PUANTAJ_ID AND 
              EPR.EMPLOYEE_ID = #arguments.employee_id# AND 
              EP.SAL_YEAR = #arguments.sal_year# AND 
              EP.SAL_MON = #arguments.sal_mon#
            ORDER BY 
              EPR.EMPLOYEE_PUANTAJ_ID DESC 
          </cfquery>
          <cfif not get_kumulative.recordcount>
            <cfquery name="get_kumulative" datasource="#dsn#" maxrows="1">
              SELECT 
                KUMULATIF_GELIR_MATRAH 
              FROM 
                EMPLOYEES_PUANTAJ EP,
                EMPLOYEES_PUANTAJ_ROWS EPR
                <cfif this_tax_account_style_ eq 1>
                  ,BRANCH B
                </cfif>
              WHERE 
                <cfif this_tax_account_style_ eq 1>
                  EP.SSK_BRANCH_ID = B.BRANCH_ID AND
                  B.COMPANY_ID = (SELECT B2.COMPANY_ID FROM BRANCH B2 WHERE B2.BRANCH_ID = #get_hr_ssk.BRANCH_ID#) AND
                </cfif>
                EP.PUANTAJ_ID = EPR.PUANTAJ_ID AND 
                EPR.EMPLOYEE_ID = #arguments.employee_id# AND 
                EP.SAL_YEAR = #arguments.sal_year# AND 
                EP.SAL_MON < #arguments.SAL_MON#
              ORDER BY 
                EPR.EMPLOYEE_PUANTAJ_ID DESC 
            </cfquery>
          </cfif>
        </cfif>
      </cfif>
      <cfif arguments.SAL_MON eq 1 and not (isdefined("get_kumulative") and get_kumulative.recordcount)>
        <cfset kontrol_matrah = 0>
        <cfset kontrol_kumulative = 1>
      <cfelse>
        <cfset kontrol_kumulative = get_kumulative.recordcount>
        <cfif len(get_kumulative.KUMULATIF_GELIR_MATRAH)>
          <cfset kontrol_matrah = get_kumulative.KUMULATIF_GELIR_MATRAH>
        <cfelse>
          <cfset kontrol_matrah = 0>
        </cfif>
      </cfif>
      <cfscript>
        kazanca_dahil_olan_odenek_tutar_muaf = 0;
        brut_salary = puantaj_amount;
        ilk_salary = puantaj_amount;
        tutar_ = puantaj_amount;
        ilk_sal_temp = puantaj_amount;
        is_mesai_ = 0;
        is_izin_ = 0;
        is_tax_ = 1;
        is_ssk_ = 0;
        total_pay_tax = 0;
        is_issizlik_ = 1;
        devir_matrah_ = 0;
        ssk_isci_carpan = 0;
        issizlik_isci_carpan = 0;
        sakatlik_indirimi = 0;
        vergi_istisna = 0;
        puantaj_exts = ArrayNew(2);
        ssk_matrah_taban = get_insurance.MIN_PAYMENT;
        ssk_matrah_tavan = get_insurance.MAX_PAYMENT;
        get_hr_salary.gross_net = 1;
        if (kontrol_kumulative eq 1)
          kumulatif_gelir = kontrol_matrah;
        else if(len(get_hr_ssk.CUMULATIVE_TAX_TOTAL))
          kumulatif_gelir = get_hr_ssk.CUMULATIVE_TAX_TOTAL;
        else
          kumulatif_gelir = 0;
        onceki_ay_kumulatif_gelir_vergisi_matrah = kumulatif_gelir;
        odenek_oncesi_gelir_vergisi_matrah = 0;
        ssk_isveren_carpan = 0;
        issizlik_isveren_carpan = 0;
        sendika_indirimi = 0;
        odenek_oncesi_gelir_vergisi = 0;
        odenek_oncesi_damga_vergisi = 0;
        damga_vergisi = 0;
        total_pay_ssk_tax = 0;
        ssk_days = 30;
        include('get_hr_compass_from_net_odenek.cfm');
        damga_vergisi = ((eklenen) * get_active_program_parameter.STAMP_TAX_BINDE ) / 1000;
      </cfscript>
    </cffunction>
</cfcomponent>

