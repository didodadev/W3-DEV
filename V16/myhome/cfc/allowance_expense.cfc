<!---
    File: allowance_expense.cfc
    Controller: fuseaction is myhome = AllowenceExpenseController.cfm, fuseaction is hr = hrAllowenceExpenseController.cfm
    Author: Esma R. UYSAL
    Date: 13/12/2019 
    Description:
        Harcama Talepleri cfc lerinin bulunduğu dosyadır.
--->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2= "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">
    <cffunction  name="GET_EXPENSE">
        <cfargument name = "employee_id" default = "">
        <cfargument name = "emp_id" default = "">
        <cfargument name = "employee_name" default = "">
        <cfargument name = "branch_id" default = "">
        <cfargument name = "process_stage" default = "">
        <cfargument name = "keyword" default = "">
        <cfargument name = "startdate" default = "">
        <cfargument name = "finishdate" default = "">
        <cfargument name = "expense_type" default = "">
        <cfquery name="GET_EXPENSE" datasource="#dsn2#">
            SELECT 
                *,
                PTR.STAGE
            FROM 
                EXPENSE_ITEM_PLAN_REQUESTS EPR
                    LEFT JOIN #dsn#.PROCESS_TYPE_ROWS PTR  ON PTR.PROCESS_ROW_ID =  EPR.EXPENSE_STAGE     
            WHERE 
                1 = 1
                <cfif len(arguments.employee_id) or (len(arguments.emp_id) and len(arguments.employee_name))>
                    AND EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                </cfif>
                <cfif len(arguments.branch_id)>
                    AND BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">
                </cfif>
                <cfif len(arguments.process_stage)>
                    AND EXPENSE_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">
                </cfif>
                 <cfif len(arguments.keyword)>
                    AND PAPER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                </cfif>
                <cfif isDefined("arguments.STARTDATE")>
                    <cfif len(arguments.STARTDATE) AND len(arguments.FINISHDATE)>
                    <!--- IKI TARIH DE VAR --->
                    AND
                    (
                        (
                        EXPENSE_DATE >=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#"> AND
                        EXPENSE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finishdate#">
                        )
                    )
                <cfelseif len(arguments.STARTDATE)>
                    <!--- SADECE BAŞLANGIÇ --->
                    AND
                    (
                        EXPENSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#">
                    )
                <cfelseif len(arguments.FINISHDATE)>
                    <!--- SADECE BITIŞ --->
                    AND
                    (
                        EXPENSE_DATE<= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finishdate#">
                    )
                    </cfif>
                </cfif>
                <cfif len(arguments.expense_type)>
                    AND EPR.EXPENSE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_type#">
                </cfif>
            ORDER BY
                EXPENSE_DATE DESC
        </cfquery>
        <cfreturn  GET_EXPENSE>
    </cffunction>
    <cffunction  name="ADD_SALARYPARAM_PAY" access="public"  returntype="any">
        <cfargument name = "comment_pay" default = ""><!--- Ödenek İsmi --->
        <cfargument name = "comment_pay_id" default = ""><!---Ödenek Id --->
        <cfargument name = "amount_pay" default = ""><!--- Ödenek --->
        <cfargument name = "amount_multiplier" default = "">  <!--- Çarpan ---> 
        <cfargument name = "ssk" default = "1">  <!--- ssk 1 : muaf, 2: muaf değil ---> 
        <cfargument name = "tax" default = "2">  <!--- vergi 1 : muaf, 2: muaf değil---> 
        <cfargument name = "is_damga" default = "0">  <!--- damga vergisi --->
        <cfargument name = "is_issizlik" default = "0">  <!--- işsizlik ---> 
        <cfargument name = "show" default = "1">  <!--- bordroda görünsün ---> 
        <cfargument name = "method_pay" default = "">  <!--- 1: artı, 2 : ay , 3 : gün, 4 : saat---> 
        <cfargument name = "period_pay" default = "1">  <!--- 1: ayda 1, 2 : 3 ayda 1 , 3 : 6 ayda 1, 4 : yılda 1---> 
        <cfargument name = "start_sal_mon" default = "1"><!--- Başlangıç Ayı --->
        <cfargument name = "end_sal_mon" default = ""><!--- Bitiş Ayı --->
        <cfargument name = "employee_id" default = ""><!--- çalışan id --->
        <cfargument name = "term" default = ""><!--- yıl --->
        <cfargument name = "calc_days" default = ""><!---tutar günü 0 : tümü, 1: gün,2 : fiili gün --->
        <cfargument name = "is_kidem" default = ""><!--- kıdeme dahil 1:kıdeme ahil,0 kıdeme dahil değil --->
        <cfargument name = "in_out_id" default = ""><!--- Giriş çıkış id --->
        <cfargument name = "from_salary" default = ""><!--- 0 :net,1 : brüt --->
        <cfargument name = "is_ehesap" default = "0"><!--- üst düzey ik yetkisi 1 : dahi, 0 :dahil değil--->
        <cfargument name = "is_ayni_yardim" default = "0"><!--- ayni yardım --->
        <cfargument name = "ssk_exemption_rate" default = ""><!--- sgk muafiyet oranı --->
        <cfargument name = "ssk_exemption_type" default = ""><!--- sgk muafiyet tipi 1: tutara göre, 2 : asgari ücrete göre, 3 : günlük asgari ücrete göre--->
        <cfargument name = "tax_exemption_value" default = ""><!--- Gelir Vergisi Muafiyet Tutarı --->
        <cfargument name = "tax_exemption_rate" default = ""><!--- Gelir Vergisi Muafiyet Oranı--->
        <cfargument name = "money" default = ""><!--- Para birimi--->
        <cfargument name = "is_income" default = ""><!--- kazançlara dahil--->
        <cfargument name = "is_not_execution" default = ""><!--- İcraya Dahil Değil --->
        <cfargument name = "factor_type" default = "1"><!--- 1:Aylık Katsayı, 2 : Taban Aylık Katsayı, 3 : Yan Ödeme Katsayısı --->
        <cfargument name = "comment_type" default = ""><!--- 1: ek ödenek, 2: kazanc --->
        <cfargument name = "is_rd_damga" default = ""><!--- Damga Vergisi --->
        <cfargument name = "is_rd_gelir" default = ""><!--- Gelir Vergisi --->
        <cfargument name = "is_rd_ssk" default = ""><!--- SGK Matrahı --->
        <cfargument name = "expense_puantaj_id" default = ""><!--- Ödenek harcırahdan geliyorsa Harcırah ID'si --->
        <cfargument name = "detail" default = ""><!--- Detay --->
        <cfargument name = "expense_health_id" default = ""><!--- Detay --->
        <cfargument name = "project_id" default = ""><!--- Proje ID --->
        <cfargument name = "SSK_STATUE" default = ""><!--- SGK Durumu --->
        <cfargument name = "STATUE_TYPE" default = ""><!--- Bordro Tipi --->
        <cfargument name = "special_code" default = ""><!---Özel Kod --->
        <cfargument name = "total_hour" default = ""><!--- Toplam Saat --->
        <cfargument name = "paper_no" default = ""><!--- Belge Numarası --->
        <cfargument name = "process_stage" default = ""><!--- Süreç --->
        <cfquery name="ADD_SALARYPARAM_PAY" datasource="#dsn#">
            INSERT INTO SALARYPARAM_PAY
            (
                COMMENT_PAY,
                COMMENT_PAY_ID,
                AMOUNT_PAY,
                AMOUNT_MULTIPLIER,
                SSK,
                TAX,
                IS_DAMGA,
                IS_ISSIZLIK,
                SHOW,
                METHOD_PAY,
                PERIOD_PAY,
                START_SAL_MON,
                END_SAL_MON,
                EMPLOYEE_ID,
                TERM,
                CALC_DAYS,
                IS_KIDEM,
                IN_OUT_ID,
                FROM_SALARY,
                <cfif session.ep.ehesap>
                IS_EHESAP,
                </cfif>
                IS_AYNI_YARDIM,
                SSK_EXEMPTION_RATE,
                SSK_EXEMPTION_TYPE,
                TAX_EXEMPTION_VALUE,
                TAX_EXEMPTION_RATE,
                MONEY,
                IS_INCOME,
                IS_NOT_EXECUTION,                                        
                FACTOR_TYPE,
                COMMENT_TYPE,
                IS_RD_DAMGA,
                IS_RD_GELIR,
                IS_RD_SSK,
                RECORD_DATE,
                RECORD_EMP,
                RECORD_IP,
                DETAIL,
                EXPENSE_PUANTAJ_ID,
                EXPENSE_HEALTH_ID,
                PROJECT_ID,
                SSK_STATUE,
                STATUE_TYPE,
                SPECIAL_CODE,
                TOTAL_HOUR,
                PAPER_NO,
                PROCESS_STAGE
                )
            VALUES
                (
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.COMMENT_PAY#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.COMMENT_PAY_ID#">,
                <cfif len(arguments.AMOUNT_PAY)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.AMOUNT_PAY#"><cfelse>NULL</cfif>,
                <cfif len(arguments.amount_multiplier)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.amount_multiplier#"><cfelse>NULL</cfif>,
                <cfif len(arguments.SSK)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SSK#"><cfelse>NULL</cfif>,
                <cfif len(arguments.TAX)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TAX#"><cfelse>NULL</cfif>,
                <cfif len(arguments.IS_DAMGA)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.IS_DAMGA#"><cfelse>NULL</cfif>,
                <cfif len(arguments.IS_ISSIZLIK)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.IS_ISSIZLIK#"><cfelse>NULL</cfif>,
                <cfif len(arguments.SHOW)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.SHOW#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.METHOD_PAY#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PERIOD_PAY#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.START_SAL_MON#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.END_SAL_MON#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.EMPLOYEE_ID#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TERM#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.CALC_DAYS#">,
                <cfif len(arguments.IS_KIDEM)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.IS_KIDEM#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.in_out_id#">,
                <cfif len(arguments.from_salary)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.from_salary#"><cfelse>NULL</cfif>,
                <cfif session.ep.ehesap>
                    <cfif len(arguments.is_ehesap)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_ehesap#"><cfelse>NULL</cfif>,
                </cfif>
                <cfif len(arguments.is_ayni_yardim)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_ayni_yardim#"><cfelse>NULL</cfif>,
                <cfif len(arguments.SSK_EXEMPTION_RATE)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SSK_EXEMPTION_RATE#"><cfelse>NULL</cfif>,
                <cfif len(arguments.SSK_EXEMPTION_TYPE)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SSK_EXEMPTION_TYPE#"><cfelse>NULL</cfif>,
                <cfif len(arguments.TAX_EXEMPTION_VALUE)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.TAX_EXEMPTION_VALUE#"><cfelse>NULL</cfif>,
                <cfif len(arguments.TAX_EXEMPTION_RATE)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.TAX_EXEMPTION_RATE#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.money#">,
                <cfif len(arguments.is_income)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_income#"><cfelse>0</cfif>,
                <cfif len(arguments.is_not_execution)>#arguments.is_not_execution#<cfelse>0</cfif>,
                <cfif len(arguments.factor_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.factor_type#"><cfelse>NULL</cfif>,
                <cfif len(arguments.comment_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.comment_type#"><cfelse>1</cfif>,
                <cfif len(arguments.is_rd_damga)>#arguments.is_rd_damga#<cfelse>0</cfif>,
                <cfif len(arguments.is_rd_gelir)>#arguments.is_rd_gelir#<cfelse>0</cfif>,
                <cfif len(arguments.is_rd_ssk)>#arguments.is_rd_ssk#<cfelse>0</cfif>,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
                <cfif len(arguments.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detail#"><cfelse>NULL</cfif>	,				
                <cfif len(arguments.expense_puantaj_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_puantaj_id#"><cfelse>NULL</cfif>,
                <cfif len(arguments.expense_health_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_health_id#"><cfelse>NULL</cfif>,
                <cfif len(arguments.project_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#"><cfelse>NULL</cfif>,
                <cfif len(arguments.SSK_STATUE)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SSK_STATUE#"><cfelse>1</cfif>,
                <cfif len(arguments.SSK_STATUE) and len(arguments.STATUE_TYPE) and arguments.SSK_STATUE eq 2><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.STATUE_TYPE#"><cfelse>0</cfif>,
                <cfif len(arguments.special_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.special_code#"><cfelse>NULL</cfif>,
                <cfif len(arguments.total_hour)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.total_hour#"><cfelse>NULL</cfif>,
                <cfif len(arguments.paper_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.paper_no#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.process_stage") and len(arguments.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#"><cfelse>NULL</cfif>
                )
            </cfquery>
        <cfreturn 1>
    </cffunction>
    <cffunction  name="UPD_SALARYPARAM_PAY" access="public"  returntype="any">
        <cfargument name = "comment_pay" default = ""><!--- Ödenek İsmi --->
        <cfargument name = "comment_pay_id" default = ""><!---Ödenek Id --->
        <cfargument name = "amount_pay" default = ""><!--- Ödenek --->
        <cfargument name = "amount_multiplier" default = "">  <!--- Çarpan ---> 
        <cfargument name = "ssk" default = "1">  <!--- ssk 1 : muaf, 2: muaf değil ---> 
        <cfargument name = "tax" default = "2">  <!--- vergi 1 : muaf, 2: muaf değil---> 
        <cfargument name = "is_damga" default = "0">  <!--- damga vergisi --->
        <cfargument name = "is_issizlik" default = "0">  <!--- işsizlik ---> 
        <cfargument name = "show" default = "1">  <!--- bordroda görünsün ---> 
        <cfargument name = "method_pay" default = "">  <!--- 1: artı, 2 : ay , 3 : gün, 4 : saat---> 
        <cfargument name = "period_pay" default = "1">  <!--- 1: ayda 1, 2 : 3 ayda 1 , 3 : 6 ayda 1, 4 : yılda 1---> 
        <cfargument name = "start_sal_mon" default = "1"><!--- Başlangıç Ayı --->
        <cfargument name = "end_sal_mon" default = ""><!--- Bitiş Ayı --->
        <cfargument name = "employee_id" default = ""><!--- çalışan id --->
        <cfargument name = "term" default = ""><!--- yıl --->
        <cfargument name = "calc_days" default = ""><!---tutar günü 0 : tümü, 1: gün,2 : fiili gün --->
        <cfargument name = "is_kidem" default = ""><!--- kıdeme dahil 1:kıdeme ahil,0 kıdeme dahil değil --->
        <cfargument name = "in_out_id" default = ""><!--- Giriş çıkış id --->
        <cfargument name = "from_salary" default = ""><!--- 0 :net,1 : brüt --->
        <cfargument name = "is_ehesap" default = "0"><!--- üst düzey ik yetkisi 1 : dahi, 0 :dahil değil--->
        <cfargument name = "is_ayni_yardim" default = "0"><!--- ayni yardım --->
        <cfargument name = "ssk_exemption_rate" default = ""><!--- sgk muafiyet oranı --->
        <cfargument name = "ssk_exemption_type" default = ""><!--- sgk muafiyet tipi 1: tutara göre, 2 : asgari ücrete göre, 3 : günlük asgari ücrete göre--->
        <cfargument name = "tax_exemption_value" default = ""><!--- Gelir Vergisi Muafiyet Tutarı --->
        <cfargument name = "tax_exemption_rate" default = ""><!--- Gelir Vergisi Muafiyet Oranı--->
        <cfargument name = "money" default = ""><!--- Para birimi--->
        <cfargument name = "is_income" default = ""><!--- kazançlara dahil--->
        <cfargument name = "is_not_execution" default = ""><!--- İcraya Dahil Değil --->
        <cfargument name = "factor_type" default = "1"><!--- 1:Aylık Katsayı, 2 : Taban Aylık Katsayı, 3 : Yan Ödeme Katsayısı --->
        <cfargument name = "comment_type" default = ""><!--- 1: ek ödenek, 2: kazanc --->
        <cfargument name = "is_rd_damga" default = ""><!--- Damga Vergisi --->
        <cfargument name = "is_rd_gelir" default = ""><!--- Gelir Vergisi --->
        <cfargument name = "is_rd_ssk" default = ""><!--- SGK Matrahı --->
        <cfargument name = "expense_puantaj_id" default = ""><!--- Ödenek harcırahdan geliyorsa Harcırah ID'si --->
        <cfargument name = "detail" default = ""><!--- Detay --->
        <cfargument name = "spp_id" default = ""><!--- Ek Ödenek Id --->
        <cfquery name="UPD_SALARYPARAM_PAY" datasource="#dsn#">
            UPDATE
                SALARYPARAM_PAY
            SET
                COMMENT_PAY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.COMMENT_PAY#">,
                COMMENT_PAY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.COMMENT_PAY_ID#">,
                AMOUNT_PAY = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.AMOUNT_PAY#">,
                AMOUNT_MULTIPLIER = <cfif len(arguments.amount_multiplier)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.amount_multiplier#"><cfelse>NULL</cfif>,
                SSK = <cfif len(arguments.SSK)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SSK#"><cfelse>NULL</cfif>,
                TAX = <cfif len(arguments.TAX)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TAX#"><cfelse>NULL</cfif>,
                IS_DAMGA = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.IS_DAMGA#">,
                IS_ISSIZLIK = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.IS_ISSIZLIK#">,
                SHOW = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.SHOW#">,
                METHOD_PAY = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.METHOD_PAY#">,
                PERIOD_PAY = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PERIOD_PAY#">,
                START_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.START_SAL_MON#">,
                END_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.END_SAL_MON#">,
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.EMPLOYEE_ID#">,
                TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TERM#">,
                CALC_DAYS = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.CALC_DAYS#">,
                IS_KIDEM = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.IS_KIDEM#">,
                IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.in_out_id#">,
                FROM_SALARY = <cfif len(arguments.from_salary)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.from_salary#"><cfelse>NULL</cfif>,
                <cfif session.ep.ehesap>
                IS_EHESAP = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_ehesap#">,
                </cfif>
                IS_AYNI_YARDIM = <cfif len(arguments.is_ayni_yardim)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_ayni_yardim#"><cfelse>NULL</cfif>,
                SSK_EXEMPTION_RATE = <cfif len(arguments.SSK_EXEMPTION_RATE)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SSK_EXEMPTION_RATE#"><cfelse>NULL</cfif>,
                SSK_EXEMPTION_TYPE = <cfif len(arguments.SSK_EXEMPTION_TYPE)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SSK_EXEMPTION_TYPE#"><cfelse>NULL</cfif>,
                TAX_EXEMPTION_VALUE = <cfif len(arguments.TAX_EXEMPTION_VALUE)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.TAX_EXEMPTION_VALUE#"><cfelse>NULL</cfif>,
                TAX_EXEMPTION_RATE = <cfif len(arguments.TAX_EXEMPTION_RATE)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.TAX_EXEMPTION_RATE#"><cfelse>NULL</cfif>,
                MONEY =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.money#">,
                IS_INCOME = <cfif len(arguments.is_income)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_income#"><cfelse>0</cfif>,
                IS_NOT_EXECUTION = <cfif len(arguments.is_not_execution)>#arguments.is_not_execution#<cfelse>0</cfif>,                               
                FACTOR_TYPE = <cfif len(arguments.factor_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.factor_type#"><cfelse>NULL</cfif>,
                COMMENT_TYPE =  <cfif len(arguments.comment_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.comment_type#"><cfelse>1</cfif>,
                IS_RD_DAMGA = <cfif len(arguments.is_rd_damga)>#arguments.is_rd_damga#<cfelse>0</cfif>,
                IS_RD_GELIR = <cfif len(arguments.is_rd_gelir)>#arguments.is_rd_gelir#<cfelse>0</cfif>,
                IS_RD_SSK = <cfif len(arguments.is_rd_ssk)>#arguments.is_rd_ssk#<cfelse>0</cfif>,
                RECORD_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
                DETAIL = <cfif len(arguments.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detail#"><cfelse>NULL</cfif>,
                EXPENSE_PUANTAJ_ID = <cfif len(arguments.expense_puantaj_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_puantaj_id#"><cfelse>NULL</cfif>
            WHERE
                <cfif len(arguments.spp_id)>
                    SPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.spp_id#">
                </cfif>
                <cfif len(arguments.expense_puantaj_id)>
                    EXPENSE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_puantaj_id#">
                </cfif>
            </cfquery>
        <cfreturn 1>
    </cffunction>
    <cffunction  name="GET_IN_OUT_ID" access="public"  returntype="any">
        <cfargument name = "employee_id" default = ""><!--- Kullanıcı Id --->
        <cfargument name = "is_active" default="1"><!--- Çıkışının yapılıp yapılmama durumu --->
        <cfquery name="GET_IN_OUT_ID" datasource="#dsn#">
            SELECT 
                <cfif arguments.is_active eq 0>TOP 1</cfif>
                EIO.IN_OUT_ID,
                EIO.FINISH_DATE,
                EIO.BRANCH_ID,
                EIO.DEPARTMENT_ID,
                EIO.PUANTAJ_GROUP_IDS,
                EMPLOYEES.IN_COMPANY_REASON_ID
            FROM 
                EMPLOYEES 
                LEFT JOIN EMPLOYEES_IN_OUT EIO ON EIO.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID 
            WHERE 
                EMPLOYEES.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                <cfif arguments.is_active eq 1>
                    AND EIO.FINISH_DATE IS NULL
                </cfif>
            ORDER BY EIO.IN_OUT_ID desc
        </cfquery>
        <cfreturn GET_IN_OUT_ID>
    </cffunction>
    <cffunction  name="GET_PUANTAJ_KONTROL" access="public"  returntype="any"><!--- Puantajı oluşturulmu mu?--->
        <cfargument name="expense_date" default = ""><!--- Belge Tarihi --->
        <cfargument name="employee_id" default = ""><!--- Çalışan Id --->

        <cfset query_get_in_out_id = GET_IN_OUT_ID(arguments.employee_id)>
        
        <cfif query_get_in_out_id.recordcount eq 0 or len(query_get_in_out_id.IN_OUT_ID) eq 0>
            <cfreturn { recordcount: 0 }>
        </cfif>
        <cfquery name="GET_PUANTAJ_KONTROL" datasource="#dsn#">
            SELECT
                EPR.PUANTAJ_ID
            FROM
                EMPLOYEES_PUANTAJ EP,
                EMPLOYEES_PUANTAJ_ROWS EPR
            WHERE
                EP.PUANTAJ_ID = EPR.PUANTAJ_ID
                AND EPR.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#query_get_in_out_id.in_out_id#">
                AND EP.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#month(arguments.expense_date)#">
                AND EP.SAL_YEAR >= <cfqueryparam cfsqltype="cf_sql_integer" value="#year(arguments.expense_date)#">
        </cfquery>
        <cfreturn GET_PUANTAJ_KONTROL>
    </cffunction>
    <cffunction  name="GET_HARCIRAH_KONTROL" access="public"  returntype="any"><!--- Puantajı oluşturulmu mu?--->
        <cfargument name = "expense_puantaj_id" default = ""><!--- Belge Puantaj Id --->
        <cfquery name="GET_HARCIRAH_KONTROL" datasource="#dsn#">
            SELECT
                SPP_ID
            FROM
                SALARYPARAM_PAY
            WHERE
                EXPENSE_PUANTAJ_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_puantaj_id#" list = "yes">)
        </cfquery>
        <cfreturn GET_HARCIRAH_KONTROL>
    </cffunction>
    <cffunction  name="DELETE_SALARYPARAM_PAY" access="public"  returntype="any"><!--- Puantajı oluşturulmu mu?--->
        <cfargument name = "expense_puantaj_id" default = ""><!--- Belge Puantaj Id --->
        <cfquery name="DELETE_SALARYPARAM_PAY" datasource="#dsn#">
            DELETE FROM SALARYPARAM_PAY WHERE EXPENSE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_puantaj_id#">
        </cfquery>
        <cfreturn 1>
    </cffunction>
    <cffunction  name="ADD_SALARYPARAM_GET" access="public"  returntype="any"><!--- Kesinti Ekle 20191026ERU--->
        <cfargument name = "comment_get" default = ""><!--- Kesinti İsmi --->
        <cfargument name = "comment_get_id" default = ""><!---Kesinti Id --->
        <cfargument name = "amount_get" default = ""><!--- kesitni ücreti --->
        <cfargument name = "total_get" default = ""><!--- kesitni ücreti --->
        <cfargument name = "period_get" default = "1">  <!--- 1: ayda 1, 2 : 3 ayda 1 , 3 : 6 ayda 1, 4 : yılda 1---> 
        <cfargument name = "method_get" default = "">  <!--- 1: eksi, 2 : ay , 3 : gün, 4 : saat---> 
        <cfargument name = "show" default = "1">  <!--- bordroda görünsün ---> 
        <cfargument name = "start_sal_mon" default = "1"><!--- Başlangıç Ayı --->
        <cfargument name = "end_sal_mon" default = ""><!--- Bitiş Ayı --->
        <cfargument name = "employee_id" default = ""><!--- çalışan id --->
        <cfargument name = "term" default = ""><!--- yıl --->
        <cfargument name = "calc_days" default = ""><!---tutar günü 0 : tümü, 1: gün,2 : fiili gün --->
        <cfargument name = "from_salary" default = ""><!--- 0 :net,1 : brüt --->
        <cfargument name = "in_out_id" default = ""><!--- Giriş çıkış id --->
        <cfargument name = "is_inst_avans" default = ""><!--- Taksitlendirilmiş Avans --->
        <cfargument name = "is_ehesap" default = "0"><!--- üst düzey ik yetkisi 1 : dahi, 0 :dahil değil--->
        <cfargument name = "money" default = ""><!--- Para birimi--->
        <cfargument name = "tax" default = "1">  <!--- vergi 1 :  Gelir Vergisi  + Damga Vergisi , 2:  Gelir Vergisi , 3 :muaf değil---> 
        <cfargument name = "expense_health_id" default = "">
        <cfargument name = "coution_id" default = ""><!--- disiplin işlemi --->
        <cfargument name = "detail" default = ""><!--- açıklama --->
       
        <cfquery name="ADD_SALARYPARAM_GET" datasource="#dsn#">
            INSERT INTO 
            SALARYPARAM_GET
            (
                COMMENT_GET,
                COMMENT_GET_ID,
                AMOUNT_GET,
                TOTAL_GET,
                PERIOD_GET,
                METHOD_GET,
                SHOW,
                START_SAL_MON,
                END_SAL_MON,
                EMPLOYEE_ID,
                TERM,
                CALC_DAYS,
                FROM_SALARY,
                IN_OUT_ID,
                IS_INST_AVANS,
                IS_EHESAP,
                MONEY,
                TAX,
                EXPENSE_HEALTH_ID,
                CAUTION_ID,
                DETAIL
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.comment_get#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.comment_get_id#">,
                <cfif len(arguments.amount_get)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.amount_get#"><cfelse>NULL</cfif>,
                <cfif len(arguments.total_get)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.total_get#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_get#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.method_get#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.SHOW#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.START_SAL_MON#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.END_SAL_MON#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.EMPLOYEE_ID#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TERM#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.CALC_DAYS#">,
                <cfif len(arguments.from_salary)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.from_salary#"><cfelse>NULL</cfif>,
                <cfif len(arguments.in_out_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.in_out_id#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.IS_INST_AVANS#">,
                <cfif session.ep.ehesap and len(arguments.is_ehesap)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_ehesap#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.money#">,
                <cfif len(arguments.TAX)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TAX#"><cfelse>NULL</cfif>,
                <cfif len(arguments.expense_health_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_health_id#"><cfelse>NULL</cfif>,
                <cfif len(arguments.coution_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.coution_id#"><cfelse>NULL</cfif>,
                <cfif len(arguments.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detail#"><cfelse>NULL</cfif>
                )
            </cfquery>
        <cfreturn 1>
    </cffunction>
    <cffunction  name="DELETE_SALARYPARAM_PAY_FROM_HEALTH_ID" access="public"  returntype="any"><!--- Health id ye göre ödenek silme--->
        <cfargument name = "expense_health_id" default = ""><!--- sağlık Id --->
        <cfquery name="DELETE_SALARYPARAM_PAY_FROM_HEALTH_ID" datasource="#dsn#">
            DELETE FROM SALARYPARAM_PAY WHERE EXPENSE_HEALTH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_health_id#">
        </cfquery>
        <cfreturn 1>
    </cffunction>
    <cffunction  name="DELETE_SALARYPARAM_GET_FROM_HEALTH_ID" access="public"  returntype="any"><!--- Health id ye göre kesinti silme--->
        <cfargument name = "expense_health_id" default = ""><!--- sağlık Id --->
        <cfquery name="DELETE_SALARYPARAM_GET_FROM_HEALTH_ID" datasource="#dsn#">
            DELETE FROM SALARYPARAM_GET WHERE EXPENSE_HEALTH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_health_id#">
        </cfquery>
        <cfreturn 1>
    </cffunction>
    <cffunction name="get_emp_pos" access="public" returntype="query">
        <cfargument name="emp_id" default="">
        <cfquery name="get_emp_pos" datasource="#dsn#">
            SELECT POSITION_CODE,POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.emp_id#">
        </cfquery>
        <cfreturn get_emp_pos>
    </cffunction>
    <cffunction name="get_position_detail" access="public" returntype="query">
        <cfargument name="employee_id" default="">
        <cfquery name="get_position_detail" datasource="#dsn#">
            SELECT UPPER_POSITION_CODE,UPPER_POSITION_CODE2,POSITION_NAME,POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_POSITIONS.EMPLOYEE_ID =   <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#"> AND IS_MASTER = 1
        </cfquery>
        <cfreturn get_position_detail>
    </cffunction>
    <cffunction name="get_employee_detail" access="public" returntype="query">
        <cfargument name="employee_id" default="">
        <cfquery name="get_employee_detail" datasource="#dsn#">
            SELECT EMPLOYEE_NO FROM EMPLOYEES WHERE EMPLOYEES.EMPLOYEE_ID =   <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
        </cfquery>
        <cfreturn get_employee_detail>
    </cffunction>
    <cffunction name="GET_EXPENSE_UPD" access="remote" returntype="query">
        <cfargument name="request_id" default="">
        <cfquery name="GET_EXPENSE_UPD" datasource="#dsn2#">
            SELECT * FROM EXPENSE_ITEM_PLAN_REQUESTS WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.request_id#">
        </cfquery>
        <cfreturn GET_EXPENSE_UPD>
    </cffunction>
    <cffunction name="GET_PROCESS_CAT" access="remote" returntype="query">
        <cfargument name="process_cat_id" default="">
        <cfquery name="GET_PROCESS_CAT" datasource="#dsn3#">
            SELECT * FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_cat_id#">	
        </cfquery>
        <cfreturn GET_PROCESS_CAT>
    </cffunction>
    <cffunction name="GET_EXPENSE_CENTER_LIST" access="remote" returntype="query">
        <cfargument name="expense_center_list" default="">
        <cfquery name="get_expense_center_list" datasource="#dsn2#">
            SELECT EXPENSE_ID, EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_center_list#" list="yes">) ORDER BY EXPENSE_ID
        </cfquery>
        <cfreturn GET_EXPENSE_CENTER_LIST>
    </cffunction>
    <cffunction name="GET_EXPENSE_ITEM_LIST" access="remote" returntype="query">
        <cfargument name="expense_item_list" default="">
        <cfquery name="get_expense_item_list" datasource="#dsn2#">
            SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME,ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.expense_item_list#" list="yes">) ORDER BY EXPENSE_ITEM_ID
        </cfquery>
        <cfreturn GET_EXPENSE_ITEM_LIST>
    </cffunction>
    <cffunction name="GET_ROWS" access="remote" returntype="query">
        <cfargument name="request_id" default="">
        <cfquery name="GET_ROWS" datasource="#dsn2#">
            SELECT 
                IPR.*,
                EHR.EXPENSE_HR_RULES_DETAIL
            FROM 
                EXPENSE_ITEM_PLAN_REQUESTS_ROWS IPR
            LEFT JOIN  #dsn#.EXPENSE_HR_RULES EHR ON IPR.ALLOWANCE_TYPE_ID = EHR.EXPENSE_HR_RULES_ID
                WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.request_id#">
        </cfquery>
        <cfreturn GET_ROWS>
    </cffunction>
    <cffunction name="GET_TRAVEL" access="remote" returntype="query">
        <cfargument name="expense_travel_id" default="">
        <cfquery name="get_travel" datasource="#dsn#">
            SELECT * FROM EMPLOYEES_TRAVEL_DEMAND WHERE TRAVEL_DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_travel_id#"> AND MANAGER1_VALID = 1  ORDER BY PAPER_NO
        </cfquery>
        <cfreturn GET_TRAVEL>
    </cffunction>
    <cffunction name="GET_PAY_METHOD" access="remote" returntype="query">
        <cfargument name="paymethod_id" default="">
        <cfquery name="get_pay_method" datasource="#dsn#">
            SELECT PAYMETHOD FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.paymethod_id#">
        </cfquery>
        <cfreturn GET_PAY_METHOD>
    </cffunction>
</cfcomponent>