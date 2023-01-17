<cfcomponent>
    <cfprocessingdirective pageencoding="utf-8"/>
	<cffunction name="getChequeExcel" access="public" returntype="any">
		<cfargument name="start_date">
        <cfargument name="finish_date">
        <cfargument name="record_date1">
        <cfargument name="record_date2">
        <cfargument name="payroll_date1">
        <cfargument name="payroll_date2">
        <cfargument name="oby">
        <cfargument name="status">
        <cfargument name="company">
        <cfargument name="company_id">
        <cfargument name="consumer_id">
        <cfargument name="employee_id">
        <cfargument name="member_type">
        <cfargument name="owner_company">
        <cfargument name="process_cat_id">
        <cfargument name="owner_company_id">
        <cfargument name="owner_consumer_id">
        <cfargument name="owner_employee_id">
        <cfargument name="owner_member_type">
        <cfargument name="debt_company">
        <cfargument name="keyword">
        <cfargument name="list_bank_name">
        <cfargument name="list_bank_branch_name">
        <cfargument name="account_id">
        <cfargument name="cash">
        <cfargument name="project_head">
        <cfargument name="project_id">
        <cfargument name="fuseaction">
        <cfargument name="x_is_dsp_notes">
        <cfargument name="x_bordro_no">
        <cfargument name="title_list">
        <cfset dsn = this.dsn>
        <cfset dsn_alias = this.dsn_alias>
        <cfset dsn3_alias = this.dsn3_alias>
		<cfset columnlist = ''>
        <cfset attributes.fuseaction = arguments.fuseaction>
        <cfquery name="GET_EXCEL" datasource="#this.dsn2#">
        	WITH CTE1 AS
            (
                SELECT 
                	PAYROLL.ACTION_ID,
                    PAYROLL.PAYROLL_NO,
                    PAYROLL.PAYROLL_CASH_ID,
                    PAYROLL.PAYROLL_TYPE,
                    CHEQUE.CHEQUE_PAYROLL_ID,
                    CHEQUE.CHEQUE_ID,
                    CHEQUE.CHEQUE_CODE,
                    CHEQUE.CHEQUE_DUEDATE,
                    CHEQUE.CHEQUE_NO,
                    CHEQUE.CHEQUE_STATUS_ID,
                    CHEQUE.CHEQUE_PURSE_NO,
                    CHEQUE.BANK_NAME,
                    CHEQUE.BANK_BRANCH_NAME,
                    ISNULL(CO.FULLNAME,ISNULL(CON.CONSUMER_NAME + ' ' + CON.CONSUMER_SURNAME,EMP.EMPLOYEE_NAME + ' ' + EMP.EMPLOYEE_SURNAME)) AS FULLNAME,
                    ISNULL(CO.COMPANY_ID,ISNULL(CON.CONSUMER_ID,EMP.EMPLOYEE_ID)) AS ID,
                    CHEQUE.DEBTOR_NAME,
                    NOTES.NOTE_BODY,
                    NOTES.NOTE_ID,
                    CHEQUE.CHEQUE_VALUE,
                    CHEQUE.CURRENCY_ID,
                    CHEQUE.OTHER_MONEY_VALUE,
                    CHEQUE.OTHER_MONEY,
                    CHEQUE.OTHER_MONEY_VALUE2,
                    CHEQUE.OTHER_MONEY2,
                    CHEQUE.RECORD_DATE,
                    (
                        SELECT
                            MAX(ISNULL(CH.ACT_DATE,CH.RECORD_DATE))
                        FROM
                            CHEQUE_HISTORY CH
                        WHERE
                            CH.CHEQUE_ID = CHEQUE.CHEQUE_ID
                    ) MAX_ACT_DATE,
                    AC.ACCOUNT_NAME,
                    ISNULL(PAYROLL.PAYROLL_ACCOUNT_ID,CHEQUE.ACCOUNT_ID) AS CHEQUE_ACCOUNT_ID,
                    ROW_NUMBER() OVER (
						<cfif arguments.oby eq 2>
                            ORDER BY CHEQUE.CHEQUE_DUEDATE
                        <cfelseif arguments.oby eq 3>
                            ORDER BY CHEQUE_PURSE_NO
                        <cfelseif arguments.oby eq 4>
                            ORDER BY CHEQUE_PURSE_NO DESC
                        <cfelse>
                            ORDER BY CHEQUE.CHEQUE_DUEDATE DESC
                        </cfif>
                    ) ROWNUM
                FROM
                    CHEQUE
                    LEFT JOIN PAYROLL  ON CHEQUE.CHEQUE_PAYROLL_ID = PAYROLL.ACTION_ID
                    LEFT JOIN #dsn_alias#.NOTES  ON CHEQUE.CHEQUE_ID = NOTES.ACTION_ID AND ACTION_SECTION = 'CHEQUE_ID' AND NOTES.COMPANY_ID = #session.ep.company_id#
                    LEFT JOIN #dsn_alias#.COMPANY AS CO ON CO.COMPANY_ID = ISNULL(CHEQUE.OWNER_COMPANY_ID, CHEQUE.COMPANY_ID)
                    LEFT JOIN #dsn_alias#.CONSUMER AS CON ON CON.CONSUMER_ID = ISNULL(CHEQUE.OWNER_CONSUMER_ID, CHEQUE.CONSUMER_ID)
                    LEFT JOIN #dsn_alias#.EMPLOYEES AS EMP ON EMP.EMPLOYEE_ID = ISNULL(CHEQUE.OWNER_EMPLOYEE_ID, CHEQUE.EMPLOYEE_ID)
                    LEFT JOIN #dsn3_alias#.ACCOUNTS AS AC ON AC.ACCOUNT_ID=ISNULL(
                            (SELECT TOP 1
                                PAYROLL_ACCOUNT_ID
                            FROM
                                PAYROLL P,
                                CHEQUE_HISTORY CH
                            WHERE
                                P.ACTION_ID = CH.PAYROLL_ID AND
                                CH.CHEQUE_ID = CHEQUE.CHEQUE_ID AND
                                P.PAYROLL_TYPE IN (93,105,106,133) AND
                                P.PAYROLL_ACCOUNT_ID IS NOT NULL
                            ORDER BY
                                P.ACTION_ID DESC
                                ),CHEQUE.ACCOUNT_ID)
                     
                    <cfif (isDefined("arguments.account_id") and len(arguments.account_id)) or (session.ep.isBranchAuthorization and not (isdefined("arguments.cash") and len(arguments.cash)) and not len(arguments.account_id))>
                        ,CHEQUE_HISTORY
                    </cfif>
                WHERE
                    CHEQUE.CHEQUE_ID IS NOT NULL
                <cfif not((isDefined("arguments.account_id") and len(arguments.account_id)) or (session.ep.isBranchAuthorization and not (isdefined("arguments.cash") and len(arguments.cash)) and not len(arguments.account_id)))>
                    AND CHEQUE.CHEQUE_PAYROLL_ID = PAYROLL.ACTION_ID
                </cfif>
                <cfif len(arguments.company) and len(arguments.company_id) and arguments.member_type eq 'partner'>
                    AND 
                    (
                        CHEQUE.CHEQUE_ID IN
                        (
                            SELECT
                                C.CHEQUE_ID
                            FROM
                                CHEQUE C,
                                CHEQUE_HISTORY CH,
                                PAYROLL P
                            WHERE
                                C.CHEQUE_ID = CH.CHEQUE_ID
                                AND CH.PAYROLL_ID = P.ACTION_ID
                                AND P.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
                                AND P.PAYROLL_TYPE = 91
                        )
                        OR CHEQUE.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
                    )
                <cfelseif len(arguments.company) and len(arguments.consumer_id) and arguments.member_type eq 'consumer'>
                    AND 
                    (
                        CHEQUE.CHEQUE_ID IN
                        (
                            SELECT
                                C.CHEQUE_ID
                            FROM
                                CHEQUE C,
                                CHEQUE_HISTORY CH,
                                PAYROLL P
                            WHERE
                                C.CHEQUE_ID = CH.CHEQUE_ID
                                AND CH.PAYROLL_ID = P.ACTION_ID
                                AND P.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
                                AND P.PAYROLL_TYPE = 91
                        )
                        OR CHEQUE.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
                    )
                <cfelseif len(arguments.company) and len(arguments.employee_id) and arguments.member_type eq 'employee'>
                    AND 
                    (
                        CHEQUE.CHEQUE_ID IN
                        (
                            SELECT
                                C.CHEQUE_ID
                            FROM
                                CHEQUE C,
                                CHEQUE_HISTORY CH,
                                PAYROLL P
                            WHERE
                                C.CHEQUE_ID = CH.CHEQUE_ID
                                AND CH.PAYROLL_ID = P.ACTION_ID
                                AND P.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                                AND P.PAYROLL_TYPE = 91
                        )
                        OR CHEQUE.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                    )
                </cfif>
                <cfif len(arguments.owner_company) and len(arguments.owner_company_id) and arguments.owner_member_type eq 'partner'>
                    AND CHEQUE.OWNER_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.owner_company_id#">
                <cfelseif len(arguments.owner_company) and len(arguments.owner_consumer_id) and arguments.owner_member_type eq 'consumer'>
                    AND CHEQUE.OWNER_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.owner_consumer_id#">
                <cfelseif len(arguments.owner_company) and len(arguments.owner_employee_id) and arguments.owner_member_type eq 'employee'>
                    AND CHEQUE.OWNER_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.owner_employee_id#">
                </cfif>
                <cfif isdefined("arguments.cash") and len(arguments.cash)>
                    AND CHEQUE.CHEQUE_PAYROLL_ID = PAYROLL.ACTION_ID
                    AND CHEQUE.CASH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cash#">
                </cfif>
                <cfif isDefined("arguments.account_id") and len(arguments.account_id)>
                    AND CHEQUE_HISTORY.HISTORY_ID = (SELECT MAX(HISTORY_ID) HISTORY_ID FROM CHEQUE_HISTORY WHERE CHEQUE_HISTORY.CHEQUE_ID = CHEQUE.CHEQUE_ID AND CHEQUE_HISTORY.PAYROLL_ID IS NOT NULL)
                    AND CHEQUE_HISTORY.PAYROLL_ID = PAYROLL.ACTION_ID
                    AND CHEQUE_HISTORY.CHEQUE_ID = CHEQUE.CHEQUE_ID
                    AND (
                        (
                            PAYROLL.PAYROLL_ACCOUNT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account_id#" list="yes">)
                            AND PAYROLL.PAYROLL_TYPE IN (93,105,106,133)
                        )
                        OR
                        (
                            CHEQUE.ACCOUNT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account_id#" list="yes">)
                            AND PAYROLL.PAYROLL_TYPE IN (91,106)
                        )	
                    )
                </cfif>
                <cfif len(arguments.debt_company)>
                    AND DEBTOR_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.debt_company#%">
                </cfif>
                <cfif isdefined("arguments.status") and len(arguments.status)>
                    AND CHEQUE_STATUS_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.STATUS#" list="yes">)
                </cfif>
                <cfif isDefined("arguments.keyword") and len(arguments.keyword)>
                    AND	( CHEQUE_PURSE_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#"> OR CHEQUE_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#"> OR CHEQUE_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#%">)
                </cfif>
                <cfif isDefined("arguments.list_bank_name") and len(arguments.list_bank_name)>
                    AND	BANK_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.list_bank_name#%">
                </cfif>
                <cfif isDefined("arguments.list_bank_branch_name") and len(arguments.list_bank_branch_name)>
                    AND	BANK_BRANCH_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.list_bank_branch_name#%">
                </cfif>
                <cfif isdefined("arguments.money_type") and len(arguments.money_type)>
                    AND CHEQUE.CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.money_type#">
                </cfif>
                <cfif len(arguments.start_date)>
                    AND CHEQUE.CHEQUE_DUEDATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.start_date#">
                </cfif>
                <cfif len(arguments.finish_date)>
                    AND CHEQUE.CHEQUE_DUEDATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.finish_date#">
                </cfif>
                <cfif len(arguments.record_date1)>
                    AND CHEQUE.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.record_date1#">
                </cfif>
                <cfif len(arguments.record_date2)>
                    AND CHEQUE.RECORD_DATE < <cfqueryparam cfsqltype="cf_sql_date" value="#dateadd("d",1,arguments.record_date2)#">
                </cfif>
                <cfif len(arguments.payroll_date1)>
                    AND PAYROLL.PAYROLL_REVENUE_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.payroll_date1#">
                </cfif>
                <cfif len(arguments.payroll_date2)>
                    AND PAYROLL.PAYROLL_REVENUE_DATE < <cfqueryparam cfsqltype="cf_sql_date" value="#dateadd("d",1,arguments.payroll_date2)#">
                </cfif>
                <cfif len(arguments.project_head) and isdefined("arguments.project_id") and len(arguments.project_id)>
                    AND PAYROLL.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#"> 
                </cfif>
                <!---  Şube tarafındaki düzenlemeler sonrasında eklendi Sadece şubeye ait bankalardaki veya kasalardaki çekleri getiriyor. --->
                <cfif session.ep.isBranchAuthorization and not (isdefined("arguments.cash") and len(arguments.cash)) and not len(arguments.account_id)>
                    AND CHEQUE_HISTORY.HISTORY_ID = (SELECT MAX(HISTORY_ID) HISTORY_ID FROM CHEQUE_HISTORY WHERE CHEQUE_HISTORY.CHEQUE_ID = CHEQUE.CHEQUE_ID AND CHEQUE_HISTORY.PAYROLL_ID IS NOT NULL)
                    AND CHEQUE_HISTORY.PAYROLL_ID = PAYROLL.ACTION_ID
                    AND PAYROLL.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">
                </cfif>	
            )
            ,CTE2 AS(
                    SELECT
                        SUM(CHEQUE_VALUE) CHEQUE_TOTAL,
                        CURRENCY_ID,
                        ROW_NUMBER() OVER (ORDER BY CURRENCY_ID) AS RN
                    FROM
                        CTE1
                    GROUP BY
                        CURRENCY_ID		
            ),
            CTE3 AS
            (
                SELECT
                    SUM(OTHER_MONEY_VALUE) OTHER_TOTAL,
                    OTHER_MONEY
                FROM
                    CTE1
                WHERE
                    OTHER_MONEY = '#session.ep.money#'
                GROUP BY
                    OTHER_MONEY
            ),
            CTE4 AS
            (
                SELECT
                    SUM(OTHER_MONEY_VALUE2) OTHER_TOTAL2,
                    OTHER_MONEY2
                FROM
                    CTE1
                WHERE
                    OTHER_MONEY2 = '#session.ep.money2#'
                GROUP BY
                    OTHER_MONEY2
            )
            SELECT 
                ROWNUM <cfset columnlist = listAppend(columnlist,'Sıra',',')>
                ,CASE PAYROLL_NO
                    WHEN -1 THEN 'Açılış'
                    WHEN -2 THEN ''
                <cfif arguments.x_bordro_no eq 1>
                	ELSE
                    	CASE WHEN LEN(CHEQUE_CODE) > 0 THEN  PAYROLL_NO + '-' + CHEQUE_CODE
                        ELSE PAYROLL_NO
                        END
                <cfelse>
                	ELSE PAYROLL_NO
                </cfif>
                END AS PAYROLL <cfset columnlist = listAppend(columnlist,'Bordro',',')>
                ,CONVERT(VARCHAR(10),CHEQUE_DUEDATE,103) <cfset columnlist = listAppend(columnlist,'Vade Tarihi',',')>
                ,CHEQUE_NO <cfset columnlist = listAppend(columnlist,'Çek No',',')>
                ,CASE CHEQUE_STATUS_ID
                	<cfloop index="aaa" from="1" to="#listlen(arguments.title_list,',')#">
						<cfif aaa gte 11>
                        	WHEN #aaa+1# THEN <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(arguments.title_list,aaa,',')#">
                        <cfelse>
                        	WHEN #aaa# THEN <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(arguments.title_list,aaa,',')#">
                        </cfif>
                    </cfloop>
                END AS CHEQUE_STATUS <cfset columnlist = listAppend(columnlist,'Aşama',',')>
                ,ISNULL(BANK_NAME,'') + ' ' + ISNULL(BANK_BRANCH_NAME,'') <cfset columnlist = listAppend(columnlist,'Banka / Şube',',')>
                ,ACCOUNT_NAME <cfset columnlist = listAppend(columnlist,'Banka Hesabı',',')>
                ,FULLNAME <cfset columnlist = listAppend(columnlist,'Cari Hesap',',')>
                ,DEBTOR_NAME <cfset columnlist = listAppend(columnlist,'Borçlu',',')>
                <cfif arguments.x_is_dsp_notes eq 1>
                	,CONVERT(VARCHAR(50),NOTE_BODY) <cfset columnlist = listAppend(columnlist,'Not',',')>
                </cfif>
                ,CONVERT(MONEY,CHEQUE_VALUE) <cfset columnlist = listAppend(columnlist,'İşlem Tutarı',',')>
                ,CURRENCY_ID <cfset columnlist = listAppend(columnlist,'Para Br.',',')>
                ,CONVERT(MONEY,OTHER_MONEY_VALUE) <cfset columnlist = listAppend(columnlist,'Sistem Tutarı',',')>
                ,OTHER_MONEY <cfset columnlist = listAppend(columnlist,'Para Br.',',')>
                ,CONVERT(MONEY,OTHER_MONEY_VALUE2) <cfset columnlist = listAppend(columnlist,'2. Döviz Tutarı',',')>
                ,OTHER_MONEY2 <cfset columnlist = listAppend(columnlist,'Para Br.',',')>
                ,CONVERT(VARCHAR(10),RECORD_DATE,103) <cfset columnlist = listAppend(columnlist,'Kayıt',',')>
            FROM CTE1
        
            UNION
        
            SELECT
                (SELECT COUNT(*) FROM CTE1) + 1 AS ROWNUM ,
                '',
                '',
                '',
                '',
                '',
                '',
                '',
                '',
                <cfif arguments.x_is_dsp_notes eq 1>
                	'',
                </cfif>
                '',
                '',
                '',
                '',
                '',
                '',
                ''
                
            UNION
            
                SELECT
                 (SELECT COUNT(*) FROM CTE1) + 1 + CTE2.RN AS ROWNUM ,
                '',
                '',
                '',
                '',
                '',
                '',
                '',
                <cfif arguments.x_is_dsp_notes eq 1>
                	'',
                </cfif>
                CASE RN WHEN 1 THEN 'Toplam' ELSE '' END,
                CONVERT(VARCHAR,CONVERT(MONEY,CTE2.CHEQUE_TOTAL),1),
                CTE2.CURRENCY_ID,
                (SELECT(CONVERT(VARCHAR,CONVERT(MONEY,CTE3.OTHER_TOTAL),1)) FROM CTE3),
                '#session.ep.money#' OTHER_MONEY,
                (SELECT CONVERT(VARCHAR,CONVERT(MONEY,CTE4.OTHER_TOTAL2),1) FROM CTE4),
                '#session.ep.money2#' OTHER_MONEY2,
                ''
            FROM
                CTE2 
        
            ORDER BY
                ROWNUM
        </cfquery>
        <cfscript>
        	chequeSheet = SpreadsheetNew("CHEQUES");
			SpreadsheetAddRow(chequeSheet,columnlist,1,1);
            SpreadsheetAddRows(chequeSheet,get_excel);
			
			headerFormat = StructNew();
			headerFormat.fontsize="10";
			headerFormat.bold="true";
			headerFormat.alignment="left";
			headerFormat.textwrap="true";
			
			formatToLeft = StructNew();
			formatToLeft.alignment = "left";
			
			myDateFormat = StructNew();
			myDateFormat.alignment = "left";
			myDateFormat.dataformat = "DD.MM.YYYY";
			
			moneyFormat = StructNew();
			moneyFormat.alignment = "right";
			moneyFormat.dataformat = "##,##0.00";
			
			var columnlen = listlen(columnlist,',');
			var rowcount = get_excel.recordcount;
			SpreadsheetFormatColumns(chequeSheet,formatToLeft,"2,4");
			SpreadsheetFormatColumns(chequeSheet,myDateFormat,"3,#columnlen#");
			SpreadsheetFormatColumns(chequeSheet,moneyFormat,"#columnlen-2#,#columnlen-4#,#columnlen-6#");
			SpreadsheetFormatRow(chequeSheet,headerFormat,1);
			var kont = false;
			for(i=1;i>=-2;i--)
			{
				for(j=-4;j<=-1;j++)
				{
					if(not len(SpreadsheetGetCellValue(chequeSheet,rowcount+i-1,columnlen+j)))
					{
						kont = true;
						break;	
					}
					SpreadsheetSetCellValue(chequeSheet,'',rowcount+i,columnlen+j);
				}
				if(kont) break;	
			}
			prepareDirectory(this.upload_folder);
        </cfscript>
		<cfset uuid=CreateUUID()>
        <cfspreadsheet action="write" filename="#this.upload_folder#/reserve_files/#session.ep.userid#/cheques_#session.ep.userid#_#uuid#.xls" name="chequeSheet" sheet=1 sheetname="Çek Listesi" overwrite="true">
        <script type="text/javascript">
            <cfoutput>
                get_wrk_message_div("Excel","Excel","/documents/reserve_files/#session.ep.userid#/cheques_#session.ep.userid#_#uuid#.xls") ;
            </cfoutput>
        </script>
        <cf_get_lang_set module_name="#lcase(listgetat(arguments.fuseaction,1,'.'))#">
		<cfreturn GET_EXCEL>
	</cffunction>
    <cffunction name="prepareDirectory" access="private" returntype="any">
    	<cfargument name="upload_folder">
        <cftry>
			<cfif DirectoryExists("#upload_folder#reserve_files/#session.ep.userid#")>
                <cfdirectory action="delete" directory="#arguments.upload_folder#reserve_files/#session.ep.userid#" recurse="yes">
            </cfif>
            <cfset Sleep(3000)>
            <cfdirectory action="create" directory="#arguments.upload_folder#reserve_files/#session.ep.userid#">
        <cfcatch>
            <script type="text/javascript">
                alert('Klasorlerin silinmesi/olusturulmasi sirasinda bir hata olustu. Dosyalar ya da klasorler kullanimda olabilir.');
                window.history.back();
            </script>
        	<cfabort>
        </cfcatch>
        </cftry>
    </cffunction>
</cfcomponent>
