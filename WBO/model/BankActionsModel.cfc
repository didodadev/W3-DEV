<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Deniz Taşdemir		
Analys Date : 01/04/2016			Dev Date	: 30/05/2016		
Description :
	Bu component BANK ACTIONS tablosuna ait CRUD ve list fonksiyonlarını gerceklestirir.
----------------------------------------------------------------------->

<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn = "#dsn#">
    <cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">
    
    <cfinclude template="../fbx_workcube_funcs.cfm">
    
    <!--- list--->
    <cffunction name="list" access="remote" returntype="string" returnformat="plain">
    	<cfargument name="id" default="0" type="numeric"  required="yes" hint="Data ID">
    	<cfargument name="keyword" type="string" default="" required="no" hint="Filtre">
        <cfargument name="paper_number" type="string" default="" required="no" hint="Belge No">
        <cfargument name="account_status" type="numeric" default="-1" required="no" hint="Hesap Status">
        <cfargument name="special_definition_id" type="numeric" default="0" required="no" hint="Ödeme/Tahsilat Tipi">
        <cfargument name="emp_id" type="numeric" default="0" required="no" hint="Kişi ID">
        <cfargument name="emp_type" type="numeric" default="0" required="no" hint="Kişi Type">
        <cfargument name="emp_name" type="string" default="" required="no" hint="Kişi Ad">
        <cfargument name="search_type" type="string" default="" required="no" hint="">
        <cfargument name="search_id" type="numeric" default="0" required="no" hint="">
        <cfargument name="action_bank" type="numeric" default="-1" required="no" hint="Giriş / Çıkış İşlemi Mi">
        <cfargument name="action_type" type="numeric" default="0" required="no" hint="İşlem Tipi">
        <cfargument name="process_cat" type="numeric" default="0" required="no" hint="İşlem Kategorisi">
        <cfargument name="record_date" type="date" default="0" required="no" hint="Kayıt Tarih">
        <cfargument name="record_date2" type="date" default="0" required="no" hint="Kayıt Tarih">
        <cfargument name="date1" type="date" default="0" required="no" hint="İşlem Tarihi">
        <cfargument name="date2" type="date" default="0" required="no" hint="İşlem Tarihi">
        <cfargument name="project_id" type="numeric" default="0" required="no" hint="Proje ID">
        <cfargument name="project_head" type="string" default="" required="no" hint="Proje Ad">
        <cfargument name="record_emp_id" type="numeric" default="0" required="no" hint="Kaydeden ID">
        <cfargument name="record_emp_name" type="string" default="" required="no" hint="Kaydeden Ad">
        <cfargument name="account" type="string" default="" required="no" hint="Hesap">
        <cfargument name="branch_id" type="numeric" default="0" required="no" hint="Şube">
        <cfargument name="acc_type_id" type="numeric" default="-1" required="no" hint="Sıralama Kolonu">
        <cfargument name="sortField" type="string" default="ACTION_ID" required="no" hint="Taşı">
        <cfargument name="sortType" type="string" default="DESC" required="no" hint="Sıralama Türü">
        <cfargument name="maxrows" type="numeric" default="0" required="no" hint="Sayfalama : Sayfa başına satır sayısı">
        <cfargument name="pagenum" type="numeric" default="0" required="no" hint="Sayfalama : Sayfa no">
        
        <cfinclude template="../objects/query/get_acc_types.cfm">
        
        <cfquery name="list" datasource="#dsn#">
        	WITH CTE1 AS (
               SELECT 
                    BA.ACTION_ID,
                    BA.ACTION_TYPE,
                    BA.ACTION_TO_CASH_ID,
                    BA.ACTION_FROM_ACCOUNT_ID,
                    BA.ACTION_VALUE,
                    BA.ACTION_EMPLOYEE_ID,
                    BA.PROCESS_CAT,
                    BA.ACTION_CURRENCY_ID,
                    BA.FROM_BRANCH_ID ,
                    BA.PAPER_NO,
                    BA.ACTION_DATE,
                    BA.OTHER_CASH_ACT_VALUE,
                    BA.ACTION_DETAIL,
                    BA.ACTION_TYPE_ID,
                    BA.ACTION_FROM_CASH_ID,
                    BA.ACTION_TO_ACCOUNT_ID,
                    BA.TO_BRANCH_ID,
                    BA.UPDATE_DATE,
                    BA.RECORD_DATE,
                    BA.MASRAF,
                    ISNULL(COMP.FULLNAME,ISNULL(CONS.CONSUMER_NAME +' '+ CONS.CONSUMER_SURNAME,EMP.EMPLOYEE_NAME +' '+ EMP.EMPLOYEE_SURNAME)) AS COMPANY_NAME,
                    (CASE WHEN LEN(BA.ACTION_TO_ACCOUNT_ID)>0 THEN 
                    (
                        CASE  WHEN BA.ACTION_TYPE_ID IN (243,24,1043,294) THEN BA.ACTION_VALUE + BA.MASRAF 
                        WHEN LEN(BA.MASRAF)>0 THEN BA.ACTION_VALUE - BA.MASRAF 
                        ELSE BA.ACTION_VALUE END
                    ) ELSE 0 END )AS BORC,
                    (CASE WHEN LEN(BA.ACTION_FROM_ACCOUNT_ID)>0 THEN 
                    (
                        CASE  WHEN BA.ACTION_TYPE_ID IN (243,24,1043,294) THEN BA.ACTION_VALUE  
                        WHEN LEN(BA.MASRAF)>0 THEN BA.ACTION_VALUE - BA.MASRAF 
                        ELSE BA.ACTION_VALUE END
                    ) ELSE 0 END )AS ALACAK,
                    PP.PROJECT_ID,
                    PP.PROJECT_NUMBER,
                    PP.PROJECT_HEAD,
                    A.ACCOUNT_ID AS TO_ACCOUNT_ID,
                    A.ACCOUNT_NAME AS TO_ACCOUNT_NAME,
                    AC.ACCOUNT_ID AS FROM_ACCOUNT_ID,
                    AC.ACCOUNT_NAME AS FROM_ACCOUNT_NAME,
                    CASH.CASH_ID,
                    CASH.CASH_NAME,
                    BRN.BRANCH_ID,
                    BRN.BRANCH_NAME,
                    EC.EXPENSE_ID,
                    EC.EXPENSE,
                    EI.EXPENSE_ITEM_ID,
                    EI.EXPENSE_ITEM_NAME,
                    EMPRECORD.EMPLOYEE_NAME +' '+ EMPRECORD.EMPLOYEE_SURNAME AS RECORD_EMP,
                    EMPUPD.EMPLOYEE_NAME +' '+ EMPUPD.EMPLOYEE_SURNAME AS UPDATE_EMP,
                    ROW_NUMBER() OVER (
                    	<cfif len(sortField) and len(sortType)>
	                    	ORDER BY #arguments.sortField# #arguments.sortType#
                        <cfelse>
                        	ORDER BY (SELECT 0)
                        </cfif>
                    ) AS ROWNUM
                    <cf_extendedFields type="1" controllerFileName="bankActions" selectClause="1" mainTableAlias="BA">
                FROM
                    #dsn2#.BANK_ACTIONS BA
                    LEFT JOIN #dsn#.COMPANY COMP ON COMP.COMPANY_ID = ISNULL(BA.ACTION_FROM_COMPANY_ID,BA.ACTION_TO_COMPANY_ID)
                    LEFT JOIN #dsn#.CONSUMER CONS ON CONS.CONSUMER_ID = ISNULL(BA.ACTION_FROM_CONSUMER_ID,BA.ACTION_TO_CONSUMER_ID)
                    LEFT JOIN #dsn#.EMPLOYEES EMP ON EMP.EMPLOYEE_ID = ISNULL(BA.ACTION_FROM_EMPLOYEE_ID,BA.ACTION_TO_EMPLOYEE_ID)
                    LEFT JOIN #dsn#.EMPLOYEES EMPRECORD ON EMPRECORD.EMPLOYEE_ID = BA.RECORD_EMP
                    LEFT JOIN #dsn#.EMPLOYEES EMPUPD ON EMPUPD.EMPLOYEE_ID = BA.UPDATE_EMP
                    LEFT JOIN #dsn#.PRO_PROJECTS PP ON PP.PROJECT_ID = BA.PROJECT_ID
                    LEFT JOIN #dsn2#.CASH CASH ON CASH.CASH_ID = ISNULL(BA.ACTION_FROM_CASH_ID,BA.ACTION_TO_CASH_ID)
                    LEFT JOIN #dsn#.BRANCH BRN ON BRN.BRANCH_ID = ISNULL(BA.FROM_BRANCH_ID,BA.TO_BRANCH_ID)
                    LEFT JOIN #dsn2#.EXPENSE_CENTER EC ON EC.EXPENSE_ID = BA.EXPENSE_CENTER_ID
                    LEFT JOIN #dsn2#.EXPENSE_ITEMS EI ON EI.EXPENSE_ITEM_ID = BA.EXPENSE_ITEM_ID
                    LEFT JOIN #dsn3#.ACCOUNTS A ON A.ACCOUNT_ID = BA.ACTION_TO_ACCOUNT_ID
                    LEFT JOIN #dsn3#.ACCOUNTS AC ON AC.ACCOUNT_ID = BA.ACTION_FROM_ACCOUNT_ID
					<cfif  ListFind("240,253",arguments.action_type)>
                    	LEFT JOIN #dsn2#.BANK_ACTIONS_MULTI BAM ON BAM.MULTI_ACTION_ID = BA.MULTI_ACTION_ID
                    </cfif>
                WHERE
                	1 = 1
                    <cfif arguments.id neq 0>
                        AND ACTION_ID=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id#">
                    </cfif>
                    <cfif session.ep.isBranchAuthorization >
                        AND	(TO_BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) OR FROM_BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">))
                    </cfif>
					<cfif  len(arguments.keyword)>
                        AND
                            (
                                <cfif len(arguments.keyword) gt 3>
                                    BA.ACTION_TYPE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                                <cfelse>
                                    BA.ACTION_TYPE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#">
                                </cfif> OR
                                <cfif len(arguments.keyword) gt 3>
                                    BA.PAPER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                                <cfelse>
                                    BA.PAPER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#%">
                                </cfif> OR
                                <cfif len(arguments.keyword) gt 3>
                                    BA.ACTION_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                                <cfelse>
                                    BA.ACTION_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#%">
                                </cfif>
                            )
                    </cfif>
                    <cfif len(arguments.paper_number)>
                        <cfif len(arguments.paper_number) gt 3>
                            AND BA.PAPER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.paper_number#%">
                        <cfelse>
                            AND BA.PAPER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.paper_number#%">
                        </cfif>
                    </cfif>
                    <cfif arguments.account_status neq -1>
                        AND ((BA.ACTION_FROM_ACCOUNT_ID IN(SELECT ACCOUNT_ID FROM #dsn3#.ACCOUNTS WHERE ACCOUNT_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.account_status#">)) OR (BA.ACTION_TO_ACCOUNT_ID IN(SELECT ACCOUNT_ID FROM #dsn3#.ACCOUNTS WHERE ACCOUNT_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.account_status#">)))
                    </cfif>
                    <cfif arguments.record_date neq 0 and len(arguments.record_date) and isdate(arguments.record_date) and not isdate(arguments.record_date2)>
                        AND BA.RECORD_DATE >= #arguments.record_date#
                    <cfelseif arguments.record_date2 neq 0 and len(arguments.record_date2) and isdate(arguments.record_date2) and not isdate(arguments.record_date)>
                        AND BA.RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,arguments.record_date2)#">
                    <cfelseif arguments.record_date2 neq 0 and arguments.record_date neq 0 and len(arguments.record_date) and len(arguments.record_date2) and  isdate(arguments.record_date) and  isdate(arguments.record_date2)>
                        AND BA.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.record_date#"> AND BA.RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,arguments.record_date2)#">
                    </cfif>
                    <cfif arguments.record_emp_id neq 0 and  len(arguments.record_emp_name)>
                        AND BA.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.record_emp_id#">
                    </cfif>
                    <cfif arguments.date1 neq 0>
                        AND BA.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.DATE1#">
                    </cfif>
                    <cfif arguments.date2 neq 0>
                        AND BA.ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,arguments.DATE2)#">
                    </cfif>
                    <cfif arguments.special_definition_id neq 0>
                        <cfif arguments.special_definition_id eq '-1'>
                            AND BA.SPECIAL_DEFINITION_ID IN (SELECT SPECIAL_DEFINITION_ID FROM #dsn_alias#.SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 1)
                        <cfelseif isDefined("arguments.special_definition_id") and len(arguments.special_definition_id) and arguments.special_definition_id eq '-2'>
                            AND BA.SPECIAL_DEFINITION_ID IN (SELECT SPECIAL_DEFINITION_ID FROM #dsn_alias#.SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 2)
                        <cfelseif isDefined("arguments.special_definition_id") and len(arguments.special_definition_id)>
                            AND BA.SPECIAL_DEFINITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.special_definition_id#">
                        </cfif>
                    </cfif>
                    <cfif  arguments.action_type neq 0 and arguments.process_cat neq 0>
                        <cfif arguments.process_cat eq 0>
                            AND BA.ACTION_TYPE_ID IN (#arguments.action_type#)
                        <cfelseif arguments.process_cat neq 0>
                            AND BA.PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_cat#">
                        </cfif>
                    </cfif>
                    <cfif len(arguments.ACCOUNT)>
                        AND 
                            (
                                BA.ACTION_FROM_ACCOUNT_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ACCOUNT#"> OR
                                BA.ACTION_TO_ACCOUNT_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ACCOUNT#">
                            )
                    </cfif>
                    <cfif arguments.emp_id neq 0 >
                        AND (BA.ACTION_TO_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#"> OR BA.ACTION_FROM_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">)
                    <cfelseif  len(arguments.search_type) and (arguments.search_type is "partner") and len(arguments.emp_name) and isdefined("arguments.emp_name")>
                          AND 
                            (
                                BA.ACTION_FROM_COMPANY_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.search_id#"> OR
                                BA.ACTION_TO_COMPANY_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.search_id#"> 
                            )
                    <cfelseif len(arguments.search_type) and (arguments.search_type is "consumer") and len(arguments.emp_name) and isdefined("arguments.emp_name")>
                         AND
                            (	
                                BA.ACTION_FROM_CONSUMER_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.search_id#"> OR
                                BA.ACTION_TO_CONSUMER_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.search_id#">
                            )
                    </cfif>
                    <cfif (session.ep.isBranchAuthorization) or (arguments.branch_id neq 0)>
                        AND (<!--- burdaki kontroller mantıklı bir sıkıntı yok,örn hesaba para yatırmada kasaya bakmalı vs. --->
                                <!--- (
                                    ACTION_TYPE_ID = 23 AND<!--- Virman işlemi için iki banka hasebının da şubeye ait olmadığını kontrol ediyor --->
                                    FROM_BRANCH_ID = #control_branch_id# AND
                                    TO_BRANCH_ID = #control_branch_id#
                                ) OR --->
                                (
                                    BA.ACTION_TYPE_ID = 21 AND<!--- Para yatırma işlemi için banka ve kasanın şubeye ait olmadığını kontrol ediyor --->
                                    BA.TO_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#"> 
                                ) OR
                                (
                                    BA.ACTION_TYPE_ID = 22 AND<!--- Para çekme işlemi için banka ve kasanın şubeye ait olmadığını kontrol ediyor --->
                                    BA.FROM_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#"> 
                                ) OR
                                (
                                    BA.ACTION_TYPE_ID NOT IN (21,22<!--- ,23 --->) AND<!--- Diğer işlemlerde to veya from account_id ye bakmak yeterli --->
                                    (BA.FROM_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#"> OR
                                    BA.TO_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">)
                                )
                            )
                    </cfif>
                    <cfif arguments.action_bank neq -1>
                        <cfif arguments.action_bank eq 1>
                            AND BA.ACTION_TO_ACCOUNT_ID IS NOT NULL
                        <cfelseif  arguments.action_bank eq 0>
                            AND BA.ACTION_FROM_ACCOUNT_ID IS NOT NULL
                        </cfif>
                    </cfif>
                    <cfif arguments.acc_type_id neq -1>
                        AND BA.ACC_TYPE_ID = #arguments.acc_type_id#
                    </cfif>
                    <cfif arguments.project_id neq 0>
                        AND BA.PROJECT_ID = #arguments.project_id#
                    </cfif>
                    <cfif len(hr_type_list) or len(ehesap_type_list) or len(other_type_list)><!--- İk veya ehesap süper kullanıcı yetkisine bakılacak tip varsa --->
                        AND #control_acc_type_list#
                    <cfelseif not get_module_power_user(48)>
                        AND BA.ACTION_TO_EMPLOYEE_ID IS NULL 
                        AND BA.ACTION_FROM_EMPLOYEE_ID IS NULL
                    </cfif>
				<cf_extendedFields type="1" controllerFileName="bankActions" whereClause="1" mainTableAlias="BA">
            )
            SELECT
            	*,
                (SELECT COUNT(*) FROM CTE1) AS TOTALROWS
            FROM
            	CTE1
            WHERE
            	1 = 1
			<cfif maxrows gt 0>
                AND ROWNUM BETWEEN #pagenum * maxrows + 1# AND #(pagenum + 1) * maxrows#
            </cfif>
            ORDER BY
            	ROWNUM
        </cfquery>
       
        <cfreturn SerializeJQXFormat(list)>
    </cffunction>
    
    <!--- get --->
    <cffunction name="get" access="public" returntype="query">
    	<cfargument name="id" default="0" type="numeric"  required="yes" hint="Data ID">
        
        <cfquery name="get" datasource="#dsn#">
           SELECT 
                BA.ACTION_ID,
                BA.ACTION_TYPE,
                BA.ACTION_TO_CASH_ID,
                BA.ACTION_FROM_ACCOUNT_ID,
                BA.ACTION_VALUE,
                BA.ACTION_EMPLOYEE_ID,
                BA.PROCESS_CAT,
                BA.ACTION_CURRENCY_ID,
                BA.FROM_BRANCH_ID ,
                BA.PAPER_NO,
                BA.ACTION_DATE,
                BA.OTHER_CASH_ACT_VALUE,
                BA.ACTION_DETAIL,
                BA.ACTION_TYPE_ID,
                BA.ACTION_FROM_CASH_ID,
                BA.ACTION_TO_ACCOUNT_ID,
                BA.TO_BRANCH_ID,
                BA.UPDATE_DATE,
                BA.RECORD_DATE,
                BA.RECORD_EMP,
                BA.UPDATE_EMP,
                ISNULL(BA.MASRAF,0) AS MASRAF,
                BA.EXPENSE_CENTER_ID,
                BA.EXPENSE_ITEM_ID,
                BA.OTHER_MONEY,
                BA.PROJECT_ID,
                PP.PROJECT_HEAD,
                BA.WITH_NEXT_ROW,
                ISNULL(COMP.FULLNAME,ISNULL(CONS.CONSUMER_NAME +' '+ CONS.CONSUMER_SURNAME,EMP.EMPLOYEE_NAME +' '+ EMP.EMPLOYEE_SURNAME)) AS COMPANY_NAME
            FROM
                #dsn2#.BANK_ACTIONS BA
                LEFT JOIN #dsn#.COMPANY COMP ON COMP.COMPANY_ID = ISNULL(BA.ACTION_FROM_COMPANY_ID,BA.ACTION_TO_COMPANY_ID)
                LEFT JOIN #dsn#.CONSUMER CONS ON CONS.CONSUMER_ID = ISNULL(BA.ACTION_FROM_CONSUMER_ID,BA.ACTION_TO_CONSUMER_ID)
                LEFT JOIN #dsn#.EMPLOYEES EMP ON EMP.EMPLOYEE_ID = ISNULL(BA.ACTION_FROM_EMPLOYEE_ID,BA.ACTION_TO_EMPLOYEE_ID)
                LEFT JOIN #dsn#.PRO_PROJECTS PP ON PP.PROJECT_ID = BA.PROJECT_ID
            WHERE
                 ACTION_ID=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id#">
                <cfif session.ep.isBranchAuthorization >
                    AND	(TO_BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) OR FROM_BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">))
                </cfif>
    	</cfquery>
        
        <cfreturn get>         
    </cffunction>
    
    <!--- getMulti --->
    <cffunction name="getMulti" access="public" returntype="struct">
    	<cfargument name="multiId" default="0" type="numeric"  required="yes" hint="Multi ID">
        
        <cfquery name="getMultiData" datasource="#dsn#">
           SELECT 
                *
            FROM
                #dsn2#.BANK_ACTIONS_MULTI BAM
            WHERE
                 MULTI_ACTION_ID=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.multiId#">
    	</cfquery>
        <cfquery name="getRows" datasource="#dsn#">
           SELECT 
                BA.ACTION_ID,
                BA.ACTION_TYPE,
                BA.ACTION_TO_CASH_ID,
                BA.ACTION_FROM_ACCOUNT_ID,
                BA.ACTION_VALUE,
                BA.ACTION_EMPLOYEE_ID,
                BA.PROCESS_CAT,
                BA.ACTION_CURRENCY_ID,
                BA.FROM_BRANCH_ID ,
                BA.PAPER_NO,
                BA.ACTION_DATE,
                BA.OTHER_CASH_ACT_VALUE,
                BA.ACTION_DETAIL,
                BA.ACTION_TYPE_ID,
                BA.ACTION_FROM_CASH_ID,
                CASE ACTION_TYPE_ID WHEN 23 THEN (SELECT ACTION_TO_ACCOUNT_ID FROM #dsn2#.BANK_ACTIONS WHERE ACTION_ID = BA.ACTION_ID + 1) ELSE BA.ACTION_TO_ACCOUNT_ID END AS ACTION_TO_ACCOUNT_ID,
                BA.TO_BRANCH_ID,
                BA.UPDATE_DATE,
                BA.RECORD_DATE,
                BA.RECORD_EMP,
                BA.UPDATE_EMP,
                BA.MASRAF,
                BA.EXPENSE_CENTER_ID,
                BA.EXPENSE_ITEM_ID,
                BA.OTHER_MONEY,
                BA.PROJECT_ID,
                PP.PROJECT_HEAD,
                BA.WITH_NEXT_ROW,
                BA.MULTI_ACTION_ID,
                EC.EXPENSE,
                EI.EXPENSE_ITEM_NAME,
                ISNULL(COMP.FULLNAME,ISNULL(CONS.CONSUMER_NAME +' '+ CONS.CONSUMER_SURNAME,EMP.EMPLOYEE_NAME +' '+ EMP.EMPLOYEE_SURNAME)) AS COMPANY_NAME
            FROM
                #dsn2#.BANK_ACTIONS BA
                LEFT JOIN #dsn#.COMPANY COMP ON COMP.COMPANY_ID = ISNULL(BA.ACTION_FROM_COMPANY_ID,BA.ACTION_TO_COMPANY_ID)
                LEFT JOIN #dsn#.CONSUMER CONS ON CONS.CONSUMER_ID = ISNULL(BA.ACTION_FROM_CONSUMER_ID,BA.ACTION_TO_CONSUMER_ID)
                LEFT JOIN #dsn#.EMPLOYEES EMP ON EMP.EMPLOYEE_ID = ISNULL(BA.ACTION_FROM_EMPLOYEE_ID,BA.ACTION_TO_EMPLOYEE_ID)
                LEFT JOIN #dsn#.PRO_PROJECTS PP ON PP.PROJECT_ID = BA.PROJECT_ID
                LEFT JOIN #dsn2#.EXPENSE_CENTER EC ON EC.EXPENSE_ID = BA.EXPENSE_CENTER_ID
                LEFT JOIN #dsn2#.EXPENSE_ITEMS EI ON EI.EXPENSE_ITEM_ID = BA.EXPENSE_ITEM_ID
            WHERE
                 BA.MULTI_ACTION_ID=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.multiId#">
                 AND (ACTION_TYPE_ID <> 23 OR WITH_NEXT_ROW = 1)
    	</cfquery>
        
        <cfset multiData = structNew()>
        <cfset multiData.mainData = getMultiData>
        <cfset multiData.rowData = getRows>
        <cfreturn multiData>         
    </cffunction>
    
     <!--- add --->
    <cffunction name="add" access="public" returntype="numeric">
    	<cfargument name="process_cat" type="numeric"  required="yes" hint="işlem Kategorisi">
        <cfargument name="action_type" type="string"  default="" required="yes" hint="İşlem Açıklama">
        <cfargument name="process_type" type="numeric" required="yes" hint="işlem Tipi">
        <cfargument name="action_value" type="numeric" default="0" required="yes" hint="Tutar">
        <cfargument name="masraf" type="numeric" default="0" required="yes" hint="Masraf Tutarı">
        <cfargument name="expense_center_id" type="numeric" default="0" required="yes" hint="Masraf Merkezi">
        <cfargument name="expense_item_id" type="numeric" default="0" required="yes" hint="Bütçe Kalemi">
    	<cfargument name="currency_id" type="string" default="0" required="yes" hint="Para Birimi">
        <cfargument name="action_date" type="string" default="" required="yes" hint="İşlem Tarihi">
        <cfargument name="from_account_id" type="numeric" default="0" required="yes" hint="Hesap ID">
        <cfargument name="to_account_id" type="numeric" default="0" required="yes" hint="Hesap ID">
        <cfargument name="TO_CASH_ID" type="numeric" default="0" required="yes" hint="Kasa ID">
        <cfargument name="FROM_CASH_ID" type="numeric" default="0" required="yes" hint="Kasa ID">
        <cfargument name="EMPLOYEE_ID" type="numeric" default="0" required="yes" hint="Çalışan ID">
        <cfargument name="action_detail" type="string" default="" required="no" hint="Açıklama">
        <cfargument name="other_cash_act_value" type="numeric" default="0" required="no" hint="Dövizli Tutar">
        <cfargument name="money_type" type="string" default="" required="no" hint="Döviz Para Birimi">
        <cfargument name="is_account" type="boolean" default="1" required="yes" hint="Muahasebe İşlemi Yapıyor Mu">
        <cfargument name="is_account_type" type="numeric" default="0"  required="yes" hint="Muahasebe İşlemi Tip">
        <cfargument name="paper_number" type="string" required="no" hint="Belge No">
        <cfargument name="to_branch_id" type="numeric" default="0" required="yes" hint="Şube ID">
    	<cfargument name="from_branch_id" type="numeric" default="0" required="yes" hint="Şube ID">
        <cfargument name="system_amount" type="numeric" default="0" required="yes" hint="Sistem Tutarı">
        <cfargument name="action_value2" type="numeric" default="0" required="yes" hint="İşlem Para Birimi">
        <cfargument name="with_next_row" type="string" default="" required="no" hint="Bağlantı Kolonu">
        <cfargument name="multi_action_id" type="numeric" default="0" required="no" hint="Çoklu İşlem Id">
        
        <cfquery name="add" datasource="#dsn2#" result="MAX_ID">
            INSERT INTO
                BANK_ACTIONS
                (
                    ACTION_TYPE,
                    PROCESS_CAT,
                    ACTION_TYPE_ID,
                    ACTION_VALUE,
                    ACTION_CURRENCY_ID,
                    ACTION_DATE,
                    ACTION_FROM_ACCOUNT_ID,
                    ACTION_TO_CASH_ID,
                    ACTION_TO_ACCOUNT_ID,
                    ACTION_FROM_CASH_ID,
                    ACTION_EMPLOYEE_ID,
                    ACTION_DETAIL,
                    OTHER_CASH_ACT_VALUE,
                    OTHER_MONEY,
                    IS_ACCOUNT,
                    IS_ACCOUNT_TYPE,
                    PAPER_NO,
                    RECORD_EMP,
                    RECORD_IP,
                    RECORD_DATE,
                    FROM_BRANCH_ID,
                    TO_BRANCH_ID,
                    SYSTEM_ACTION_VALUE,
                    SYSTEM_CURRENCY_ID,
                    WITH_NEXT_ROW,
                    MULTI_ACTION_ID,
                    MASRAF,
                    EXPENSE_CENTER_ID,
                    EXPENSE_ITEM_ID
                    <cfif len(session.ep.money2)>
                        ,ACTION_VALUE_2
                        ,ACTION_CURRENCY_ID_2
                    </cfif>
                ) 
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_type#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.process_cat#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.process_type#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.action_value + arguments.masraf eq 0#" value="#arguments.action_value + arguments.masraf#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" null="#not len(arguments.currency_id)#" value="#arguments.currency_id#">,
                    <cfif len(arguments.ACTION_DATE)>#arguments.ACTION_DATE#</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.from_account_id eq 0#" value="#arguments.from_account_id#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.TO_CASH_ID eq 0#" value="#arguments.TO_CASH_ID#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.to_account_id eq 0#" value="#arguments.to_account_id#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.FROM_CASH_ID eq 0#" value="#arguments.FROM_CASH_ID#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric"null="#arguments.EMPLOYEE_ID eq 0#"  value="#arguments.EMPLOYEE_ID#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" null="#not len(arguments.ACTION_DETAIL)#" value="#arguments.ACTION_DETAIL#">,
                    <cfqueryparam cfsqltype="cf_sql_float" null="#arguments.OTHER_CASH_ACT_VALUE eq 0#" value="#arguments.OTHER_CASH_ACT_VALUE#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" null="#not len(arguments.money_type)#" value="#money_type#">,
                    <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_account#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.is_account_type#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" null="#not len(arguments.paper_number)#" value="#arguments.paper_number#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.EP.USERID#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar"  value="#CGI.REMOTE_ADDR#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.from_branch_id eq 0#" value="#arguments.from_branch_id#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.to_branch_id eq 0#" value="#arguments.to_branch_id#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.system_amount eq 0#" value="#arguments.system_amount#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" null="#not len(arguments.with_next_row)#" value="#arguments.with_next_row#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.multi_action_id eq 0#" value="#arguments.multi_action_id#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.masraf eq 0#" value="#arguments.masraf#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.expense_center_id eq 0#" value="#arguments.expense_center_id#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.expense_item_id eq 0#" value="#arguments.expense_item_id#">
                    <cfif len(session.ep.money2)>
                        ,<cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.currency_multiplier eq 0#" value="#arguments.currency_multiplier#">
                        ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
                    </cfif>				
                )
        </cfquery>
        <cfreturn MAX_ID.IDENTITYCOL>
	</cffunction> 
    
     <!--- addMulti --->
    <cffunction name="addMulti" access="public" returntype="numeric">
    	<cfargument name="process_cat" type="numeric"  required="yes" hint="işlem Kategorisi">
        <cfargument name="action_date" type="string" default="" required="yes" hint="İşlem Tarihi">
        
        <cfquery name="addMulti" datasource="#dsn2#" result="MAX_ID">
            INSERT INTO
                BANK_ACTIONS_MULTI
                (
                    ACTION_TYPE_ID,
                    PROCESS_CAT,
                    ACTION_DATE
                ) 
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_type#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.process_cat#">,
                    <cfif len(arguments.ACTION_DATE)>#arguments.ACTION_DATE#</cfif>
                )
        </cfquery>
        <cfreturn MAX_ID.IDENTITYCOL>
	</cffunction>
    
    <!--- upd --->
    <cffunction name="upd" access="public" returntype="numeric">
    	<cfargument name="id" default="0" type="numeric"  required="yes" hint="Data ID">
    	<cfargument name="process_cat" type="numeric"  required="yes" hint="işlem Kategorisi">
        <cfargument name="process_type" type="numeric" required="yes" hint="işlem Tipi">
        <cfargument name="action_value" type="numeric" default="0" required="yes" hint="Tutar">
        <cfargument name="masraf" type="numeric" default="0" required="yes" hint="Masraf Tutarı">
        <cfargument name="expense_center_id" type="numeric" default="0" required="yes" hint="Masraf Merkezi">
        <cfargument name="expense_item_id" type="numeric" default="0" required="yes" hint="Bütçe Kalemi">
    	<cfargument name="currency_id" type="string" default="0" required="yes" hint="Para Birimi">
        <cfargument name="action_date" type="string" default="0" required="yes" hint="İşlem Tarihi">
        <cfargument name="from_account_id" type="numeric" default="0" required="yes" hint="Hesap ID">
        <cfargument name="to_account_id" type="numeric" default="0" required="yes" hint="Hesap ID">
        <cfargument name="TO_CASH_ID" type="numeric" default="0" required="yes" hint="Kasa ID">
        <cfargument name="FROM_CASH_ID" type="numeric" default="0" required="yes" hint="Kasa ID">
        <cfargument name="EMPLOYEE_ID" type="numeric" default="0" required="yes" hint="Çalışan ID">
        <cfargument name="action_detail" type="string" default="" required="no" hint="Açıklama">
        <cfargument name="other_cash_act_value" type="numeric" default="0" required="no" hint="Dövizli Tutar">
        <cfargument name="money_type" type="string" default="" required="no" hint="Döviz Para Birimi">
        <cfargument name="is_account" type="numeric" default="-1"  required="yes" hint="Muahasebe İşlemi Yapıyor Mu">
        <cfargument name="paper_number" type="string" required="no" hint="Belge No">
        <cfargument name="to_branch_id" type="numeric" default="0" required="yes" hint="Şube ID">
    	<cfargument name="from_branch_id" type="numeric" default="0" required="yes" hint="Şube ID">
        <cfargument name="system_amount" type="numeric" default="0" required="yes" hint="Sistem Tutarı">
        <cfargument name="action_value2" type="numeric" default="0" required="yes" hint="İşlem Para Birimi">
        <cfargument name="is_account_type" type="numeric" default="-1"  required="yes" hint="Muahasebe İşlemi Tip">
        <cfargument name="multi_action_id" type="numeric" default="0"  required="yes" hint="Multi İşlem ID">
        
        <cfquery name="upd" datasource="#dsn2#" result="r">
            UPDATE
                BANK_ACTIONS
            SET		
                PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.process_cat#">,
                ACTION_VALUE = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.action_value + arguments.masraf#">,
                ACTION_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.currency_id#">,
                ACTION_DATE = <cfif len(arguments.ACTION_DATE)>#arguments.ACTION_DATE#</cfif>,
                ACTION_FROM_ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.from_account_id eq 0#" value="#arguments.from_account_id#">,
                ACTION_TO_ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.to_account_id eq 0#" value="#arguments.to_account_id#">,
                ACTION_TO_CASH_ID = <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.TO_CASH_ID eq 0#"  value="#arguments.TO_CASH_ID#">,
                ACTION_FROM_CASH_ID = <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.FROM_CASH_ID eq 0#" value="#arguments.FROM_CASH_ID#">,
                ACTION_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" null="#not len(arguments.ACTION_DETAIL)#" value="#ACTION_DETAIL#">,
                OTHER_CASH_ACT_VALUE =<cfqueryparam cfsqltype="cf_sql_float" null="#arguments.OTHER_CASH_ACT_VALUE eq 0#" value="#arguments.OTHER_CASH_ACT_VALUE#">,
                OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" null="#not len(arguments.money_type)#" value="#arguments.money_type#">,
                IS_ACCOUNT = <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.is_account eq -1#" value="#arguments.is_account#">,
                IS_ACCOUNT_TYPE = <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.is_account_type eq -1#" value="#arguments.is_account_type#">,
                ACTION_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.EMPLOYEE_ID eq 0#" value="#arguments.EMPLOYEE_ID#">,
                PAPER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" null="#not len(arguments.paper_number)#" value="#arguments.paper_number#">,
                FROM_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.from_branch_id eq 0#" value="#arguments.from_branch_id#">,
                TO_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.to_branch_id eq 0#" value="#arguments.to_branch_id#">,
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.EP.USERID#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                SYSTEM_ACTION_VALUE = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.system_amount#">,
                SYSTEM_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#session.ep.money#">,
                WITH_NEXT_ROW = <cfqueryparam cfsqltype="cf_sql_varchar" null="#not len(arguments.with_next_row)#" value="#arguments.with_next_row#">,
                MULTI_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.multi_action_id eq 0#" value="#arguments.multi_action_id#">,
                MASRAF = <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.masraf eq 0#" value="#arguments.masraf#">,
                EXPENSE_CENTER_ID = <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.expense_center_id eq 0#" value="#arguments.expense_center_id#">,
                EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.expense_item_id eq 0#" value="#arguments.expense_item_id#">
                <cfif len(session.ep.money2)>
                    ,ACTION_VALUE_2 = <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.currency_multiplier * arguments.action_value eq 0#" value="#arguments.currency_multiplier * arguments.action_value#">
                    ,ACTION_CURRENCY_ID_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
                </cfif>				
            WHERE
                ACTION_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id#">
        </cfquery>
        
        <cfreturn arguments.id>
	</cffunction> 
    
     <!--- updMulti --->
    <cffunction name="updMulti" access="public" returntype="numeric">
    	<cfargument name="multi_action_id" type="numeric"  required="yes" hint="Çoklu İşlem Id">
    	<cfargument name="process_cat" type="numeric"  required="yes" hint="işlem Kategorisi">
        <cfargument name="action_type" type="numeric"  required="yes" hint="işlem Tipi">
        <cfargument name="action_date" type="string" default="" required="yes" hint="İşlem Tarihi">
        
        <cfquery name="updMulti" datasource="#dsn2#" result="MAX_ID">
            UPDATE
                BANK_ACTIONS_MULTI
            SET
            	ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_type#">,
                PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.process_cat#">,
                ACTION_DATE = <cfif len(arguments.ACTION_DATE)>#arguments.ACTION_DATE#</cfif>
            WHERE
            	MULTI_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.multi_action_id#">
        </cfquery>
        <cfreturn arguments.multi_action_id>
	</cffunction>   
    
    <!--- del --->
    <cffunction name="del" access="public" returntype="numeric">
		<cfargument name="id" type="numeric"  required="yes" hint="BANK_ACTION Tablosu İçin Data ID">
		<cfquery name="del" datasource="#dsn2#">
        	DELETE FROM BANK_ACTIONS WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id#">
			DELETE FROM BANK_ACTION_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id#">
		</cfquery>	
        
		<cfreturn arguments.id>
	</cffunction>
    
    <!--- delMulti --->
    <cffunction name="delMulti" access="public" returntype="numeric">
		<cfargument name="multi_id" type="numeric"  required="yes" hint="BANK_ACTION Tablosu İçin Data ID">
        
		<cfquery name="del" datasource="#dsn2#">
        	DELETE FROM BANK_ACTIONS WHERE MULTI_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.multi_id#">
        	DELETE FROM BANK_ACTIONS_MULTI WHERE MULTI_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.multi_id#">
			DELETE FROM BANK_ACTION_MULTI_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.multi_id#">
		</cfquery>	
        
		<cfreturn arguments.multi_id>
	</cffunction>
    
    <cffunction name="getControlPaperNo" access="public" returntype="query">
    	<cfargument name="paper_number" type="string" default="" required="yes" hint="Belge No">
    	<cfargument name="id" type="numeric" default="0"  required="yes" hint="Data ID">
        
        <cfquery name="control_paper_no" datasource="#dsn2#">
            SELECT 
            	PAPER_NO 
            FROM 
            	BANK_ACTIONS 
            WHERE 
            	PAPER_NO='#arguments.paper_number#' <cfif arguments.id neq 0>AND ACTION_ID <> #arguments.id#</cfif>
        </cfquery>
        
        <cfreturn control_paper_no>
    </cffunction>
</cfcomponent>

