<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2 = dsn & '_' & session.ep.period_year & '_' & session.ep.company_id>
	<cffunction name="get" access="public" returntype="query">
		<cfargument name="actionId" type="numeric" required="yes" hint="İşlem Id">
        <cfargument name="isCopy" type="numeric" default="0" hint="Kopyalamadan Çağırılma Kontrolü">
        <cfargument name="locationBranch" type="string" default="#ListGetAt(session.ep.user_location,2,"-")#" hint="Session'da bulunan şube bilgisi">
        <cfquery name="getActionDetail" datasource="#dsn2#">
        	SELECT
            	BA.ACTION_ID,
                BA.ACTION_TYPE_ID,
                BA.BANK_ORDER_ID,
                BA.PROCESS_CAT,
                BA.PROCESS_STAGE,
                BA.ACTION_FROM_ACCOUNT_ID,
                BA.FROM_BRANCH_ID,
                BA.TO_BRANCH_ID,
                BA.SPECIAL_DEFINITION_ID,
                BA.ACC_DEPARTMENT_ID,
                BA.ACTION_TO_COMPANY_ID,
                BA.ACTION_TO_CONSUMER_ID,
                BA.ACTION_TO_EMPLOYEE_ID,
                BA.ACC_TYPE_ID,
                BA.PROJECT_ID,
                BA.ASSETP_ID,
                BA.PAPER_NO,
                BA.ACTION_DATE,
                BA.ACTION_VALUE,
                BA.MASRAF,
                BA.OTHER_CASH_ACT_VALUE,
                BA.OTHER_MONEY,
                BA.ACTION_DETAIL,
                BA.EXPENSE_CENTER_ID,
                BA.EXPENSE_ITEM_ID,
                BA.RECORD_EMP,
                BA.RECORD_DATE,
                BA.UPDATE_EMP,
                BA.UPDATE_DATE,
                PP.PROJECT_HEAD
            FROM
            	BANK_ACTIONS BA
                	LEFT JOIN #dsn#.PRO_PROJECTS AS PP ON PP.PROJECT_ID = BA.PROJECT_ID
            WHERE
            	ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.actionId#">
               	<cfif session.ep.isBranchAuthorization>
                	<cfif arguments.isCopy>
                        AND                    
                        (
                            ACTION_TYPE_ID NOT IN (21,22,23) AND
                            (FROM_BRANCH_ID = #arguments.locationBranch# OR
                            TO_BRANCH_ID = #arguments.locationBranch#)
                        )
                    <cfelse>
                    	AND	
                        (
                        	TO_BRANCH_ID IN
                            (
                            	SELECT
                                	BRANCH_ID
                                FROM
                                	#dsn#.EMPLOYEE_POSITION_BRANCHES
                                WHERE
                                	POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
                            )
                            OR 
                            FROM_BRANCH_ID IN
                            (
                            	SELECT
                                	BRANCH_ID
                                FROM
                                	#dsn#.EMPLOYEE_POSITION_BRANCHES
                                WHERE
                                	POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
                            )
						)
                    </cfif>
                </cfif>
        </cfquery>
		<cfreturn getActionDetail>
	</cffunction>
    <cffunction name="getBankOrder" access="public" returntype="query">
    	<cfargument name="orderId" type="numeric" required="yes" default="0" hint="Banka Talimat Id">
        <cfargument name="memberType" type="numeric" required="no" default="0" hint="Company : 1,Consumer :2,Employee:3">
        <cfquery name="getOrder" datasource="#dsn2#">
            SELECT 
                BON.*,
                BB.BANK_NAME,
                BB.BANK_BRANCH_NAME,
                A.ACCOUNT_NO,
                A.ACCOUNT_ORDER_CODE
				<cfif arguments.memberType eq 1>
                    ,C.FULLNAME
                <cfelseif arguments.memberType eq 2>
                    ,C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME AS FULLNAME
                <cfelseif arguments.memberType eq 3>
                    ,EMP.EMPLOYEE_NAME + ' ' + EMP.EMPLOYEE_SURNAME AS FULLNAME
                </cfif>
            FROM 
                BANK_ORDERS BON
                	LEFT JOIN #dsn3#.ACCOUNTS A ON A.ACCOUNT_ID = BON.ACCOUNT_ID
                	LEFT JOIN #dsn3#.BANK_BRANCH BB ON A.ACCOUNT_BRANCH_ID = BB.BANK_BRANCH_ID
					<cfif arguments.memberType eq 1>
                        LEFT JOIN #dsn#.COMPANY C ON C.COMPANY_ID = BON.COMPANY_ID
                    <cfelseif arguments.memberType eq 2>
                        LEFT JOIN #dsn#.CONSUMER C ON C.CONSUMER_ID = BON.CONSUMER_ID
                    <cfelseif arguments.memberType eq 3>
                        LEFT JOIN #dsn#.EMPLOYEES EMP ON EMP.EMPLOYEE_ID = BON.EMPLOYEE_ID
                    </cfif>
            WHERE 		
                BON.BANK_ORDER_ID = #arguments.orderId#
        </cfquery>
        <cfreturn getOrder>
    </cffunction>
    <cffunction name="getMulti" access="public" returntype="query">
    	<cfargument name="multiId" type="numeric" default="0" hint="Toplu Havale Id">
        <cfargument name="puantajId" type="numeric" default="0" hint="Puantajdan Oluşturulan Havaleler İçin">
        <cfargument name="isVirtualPuantaj" type="numeric" default="0" hint="Sanal Puantaj Kontrolü">
        <cfargument name="collactedTransferList" type="string" hint="Talimattan mı geliyor">
        <cfargument name="collactedProcessCat" type="string" hint="Talimat listesinde seçilen işlem kategorisi">
        <cfargument name="locationBranch" type="string" hint="Sessiondaki Şube Bilgisi">
        <cfargument name="isCopy" type="numeric" default="0" hint="Kopyalamadan mı Geliyor?">
        <cfargument name="dsn" type="string" default="#dsn2#" hint="">
        <cfif arguments.multiId neq 0>
        	<cfquery name="getActionDet" datasource="#arguments.dsn#">
                SELECT
                    BA.ACC_DEPARTMENT_ID,
                    BAM.*,
                    BA.ACTION_TO_COMPANY_ID AS ACTION_COMPANY_ID,
                    BA.ACTION_TO_CONSUMER_ID AS ACTION_CONSUMER_ID,
                    BA.ACTION_TO_EMPLOYEE_ID AS ACTION_EMPLOYEE_ID,
                    BA.OTHER_CASH_ACT_VALUE AS ACTION_VALUE_OTHER,
                    BA.PAPER_NO,
                    BA.PROJECT_ID,
                    BA.ACTION_ID,
                    BA.ACTION_VALUE,
                    BA.ACTION_DETAIL,
                    BA.OTHER_MONEY AS ACTION_CURRENCY,
                    BA.MASRAF,
                    BA.EXPENSE_CENTER_ID,
                    BA.EXPENSE_ITEM_ID,
                    BA.ASSETP_ID,
                    BA.FROM_BRANCH_ID,
                    BA.SPECIAL_DEFINITION_ID,
                    BA.ACC_TYPE_ID
                FROM
                    BANK_ACTIONS_MULTI BAM
                    LEFT JOIN BANK_ACTIONS BA ON BAM.MULTI_ACTION_ID = BA.MULTI_ACTION_ID
                WHERE
                    BAM.MULTI_ACTION_ID = #arguments.multiId#
                    <cfif session.ep.isBranchAuthorization and arguments.isCopy eq 1>
                        AND                    
                        (
                            BA.ACTION_TYPE_ID NOT IN (21,22,23) AND
                            (BA.FROM_BRANCH_ID = #arguments.locationBranch# OR
                            BA.TO_BRANCH_ID = #arguments.locationBranch#)
                        )
                    </cfif>
                ORDER BY
                    BA.ACTION_ID
            </cfquery>
        <cfelseif arguments.puantajId neq 0>
        	<cfquery name="getActionDet" datasource="#dsn#">
                SELECT
                    EP.DEKONT_ID,
                    '' PROCESS_CAT,
                    EP.ACTION_DATE,
                    '' AS ACTION_COMPANY_ID,
                    '' AS ACTION_CONSUMER_ID,
                    EPCR.EMPLOYEE_ID AS ACTION_EMPLOYEE_ID,
                    ((EPCR.ACTION_VALUE
                    -
                    ISNULL(
                    (
                        SELECT 
                            SUM(#dsn#.IS_ZERO(AMOUNT_2,AMOUNT))
                        FROM
                            EMPLOYEES_PUANTAJ_ROWS_EXT EXT,
                            EMPLOYEES_PUANTAJ_ROWS EPR
                        WHERE
                            EPR.EMPLOYEE_PUANTAJ_ID = EXT.EMPLOYEE_PUANTAJ_ID
                            AND (EPR.IN_OUT_ID = EPCR.IN_OUT_ID OR EPCR.IN_OUT_ID IS NULL)
                            AND EPR.PUANTAJ_ID = #arguments.puantajId#
                            AND EPR.EMPLOYEE_ID = EPCR.EMPLOYEE_ID
                            AND EXT.EXT_TYPE = 1
                    )
                    ,0))/(EPCR.ACTION_VALUE/EPCR.OTHER_ACTION_VALUE)) ACTION_VALUE_OTHER,
                    '' PAPER_NO,
                    '' PROJECT_ID,
                    '' ACTION_ID,
                    (EPCR.ACTION_VALUE
                    -
                    ISNULL(
                    (
                        SELECT 
                            SUM(#dsn#.IS_ZERO(AMOUNT_2,AMOUNT))
                        FROM
                            EMPLOYEES_PUANTAJ_ROWS_EXT EXT,
                            EMPLOYEES_PUANTAJ_ROWS EPR
                        WHERE
                            EPR.EMPLOYEE_PUANTAJ_ID = EXT.EMPLOYEE_PUANTAJ_ID
                            AND (EPR.IN_OUT_ID = EPCR.IN_OUT_ID OR EPCR.IN_OUT_ID IS NULL)
                            AND EPR.PUANTAJ_ID = #arguments.puantajId#
                            AND EPR.EMPLOYEE_ID = EPCR.EMPLOYEE_ID
                            AND EXT.EXT_TYPE = 1
                    )
                    ,0)
                    ) ACTION_VALUE,
                    EP.ACTION_DETAIL,
                    EP.OTHER_MONEY AS ACTION_CURRENCY,
                    0 UPD_STATUS,
                    0 MASRAF,
                    EPCR.EXPENSE_CENTER_ID,
                    EPCR.EXPENSE_ITEM_ID,
                    '' ASSETP_ID,
                    '' FROM_BRANCH_ID,
                    '' SPECIAL_DEFINITION_ID,
                    EPCR.ACC_TYPE_ID
                FROM
                    EMPLOYEES_PUANTAJ_CARI_ACTIONS EP INNER JOIN 
                    EMPLOYEES_PUANTAJ_CARI_ACTIONS_ROW EPCR ON EP.DEKONT_ID = EPCR.DEKONT_ID 
                    LEFT JOIN SETUP_ACC_TYPE SA ON SA.ACC_TYPE_ID = EPCR.ACC_TYPE_ID
                WHERE
                    EP.PUANTAJ_ID = #arguments.puantajId# AND
                    EP.IS_VIRTUAL = #arguments.isVirtualPuantaj#
                    AND EPCR.ACTION_VALUE > 0
                    AND (EPCR.ACC_TYPE_ID IS NULL OR EPCR.ACC_TYPE_ID < 0 OR SA.IS_SALARY_ACCOUNT = 1)<!--- sadece standart işlem tipindeki satırlar gelsin --->
                    AND 
                    (
                        (EPCR.ACTION_VALUE
                        -
                        ISNULL(
                        (
                            SELECT 
                                SUM(#dsn#.IS_ZERO(AMOUNT_2,AMOUNT))
                            FROM
                                EMPLOYEES_PUANTAJ_ROWS_EXT EXT,
                                EMPLOYEES_PUANTAJ_ROWS EPR
                            WHERE
                                EPR.EMPLOYEE_PUANTAJ_ID = EXT.EMPLOYEE_PUANTAJ_ID
                                AND (EPR.IN_OUT_ID = EPCR.IN_OUT_ID OR EPCR.IN_OUT_ID IS NULL)
                                AND EPR.PUANTAJ_ID = #arguments.puantajId#
                                AND EPR.EMPLOYEE_ID = EPCR.EMPLOYEE_ID
                                AND EXT.EXT_TYPE = 1
                        )
                        ,0)
                        ) > 0
                        AND (EPCR.IS_TAX_REFUND <>1)
                    ) 
                UNION
                SELECT
                    EP.DEKONT_ID,
                    '' PROCESS_CAT,
                    EP.ACTION_DATE,
                    '' AS ACTION_COMPANY_ID,
                    '' AS ACTION_CONSUMER_ID,
                    EPCR.EMPLOYEE_ID AS ACTION_EMPLOYEE_ID,
                    ((EPCR.ACTION_VALUE)/(EPCR.ACTION_VALUE/EPCR.OTHER_ACTION_VALUE)) ACTION_VALUE_OTHER,
                    '' PAPER_NO,
                    '' PROJECT_ID,
                    '' ACTION_ID,
                    (EPCR.ACTION_VALUE) AS ACTION_VALUE,
                    EP.ACTION_DETAIL,
                    EP.OTHER_MONEY AS ACTION_CURRENCY,
                    0 UPD_STATUS,
                    0 MASRAF,
                    EPCR.EXPENSE_CENTER_ID,
                    EPCR.EXPENSE_ITEM_ID,
                    '' ASSETP_ID,
                    '' FROM_BRANCH_ID,
                    '' SPECIAL_DEFINITION_ID,
                    EPCR.ACC_TYPE_ID
                FROM
                    EMPLOYEES_PUANTAJ_CARI_ACTIONS EP INNER JOIN 
                    EMPLOYEES_PUANTAJ_CARI_ACTIONS_ROW EPCR ON EP.DEKONT_ID = EPCR.DEKONT_ID
                    LEFT JOIN SETUP_ACC_TYPE SA ON SA.ACC_TYPE_ID = EPCR.ACC_TYPE_ID
                WHERE
                    EP.PUANTAJ_ID = #arguments.puantajId# AND
                    EP.IS_VIRTUAL = #arguments.isVirtualPuantaj#
                    AND EPCR.ACTION_VALUE > 0
                    AND (EPCR.ACC_TYPE_ID IS NULL OR EPCR.ACC_TYPE_ID < 0 OR SA.IS_SALARY_ACCOUNT = 1)<!--- sadece standart işlem tipindeki satırlar gelsin --->
                    AND 
                    (
                        (EPCR.ACTION_VALUE) >0
                        AND EPCR.IS_TAX_REFUND =1
                    )
            </cfquery>
        <cfelseif len(collactedTransferList)>
        	<cfquery name="getActionDet" datasource="#dsn2#">
                SELECT
                    BO.COMPANY_ID AS ACTION_COMPANY_ID,
                    BO.CONSUMER_ID AS ACTION_CONSUMER_ID,
                    BO.EMPLOYEE_ID AS ACTION_EMPLOYEE_ID,
                    BO.OTHER_MONEY_VALUE AS ACTION_VALUE_OTHER,
                    BO.PROJECT_ID AS PROJECT_ID,
                    '' PAPER_NO,
                    '' ACTION_ID,
                    BO.ACTION_VALUE AS ACTION_VALUE,
                    '' ACTION_DETAIL,
                    BO.OTHER_MONEY AS ACTION_CURRENCY,
                    '' FROM_BRANCH_ID,
                    '' MASRAF,
                    '' EXPENSE_CENTER_ID,
                    '' EXPENSE_ITEM_ID,
                    '' ASSETP_ID,
                    SPECIAL_DEFINITION_ID,
                    '' ACC_DEPARTMENT_ID,
                    '' ACC_TYPE_ID,
                    '' MULTI_ACTION_ID,
                    '' ACTION_TYPE_ID,
                    '' AS FROM_ACCOUNT_ID,
                    BO.PAYMENT_DATE AS ACTION_DATE,
                    #arguments.collactedProcessCat# PROCESS_CAT,
                    BANK_ORDER_TYPE_ID,
                    BANK_ORDER_ID
                FROM
                    BANK_ORDERS BO
                WHERE
                    BO.BANK_ORDER_ID IN (#arguments.collactedTransferList#)
            </cfquery>
        </cfif>
        <cfreturn getActionDet>
    </cffunction>
    <cffunction name="getPayments" access="public" returntype="query">
        <cfargument name="paymentIds" type="string" hint="">
        <cfargument name="cariActionIdList" type="string" hint="">
        <cfquery name="getPayments" datasource="#dsn#">
			<cfif len(arguments.paymentIds)>
                SELECT 
                    CP.ID,
                    CP.TO_EMPLOYEE_ID,
                    (SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = CP.TO_EMPLOYEE_ID) AS NAMESURNAME,
                    CP.AMOUNT,
                    CP.MONEY,
                    CP.PERIOD_ID,
                    (SELECT EXPENSE_ID FROM EXPENSE_CENTER EC,EMPLOYEES_IN_OUT_PERIOD EIP WHERE EC.EXPENSE_CODE = EIP.EXPENSE_CODE AND EIP.PERIOD_ID = CP.PERIOD_ID AND CP.IN_OUT_ID = EIP.IN_OUT_ID) AS EXPENSE_ID,
                    (SELECT EXPENSE FROM EXPENSE_CENTER EC,EMPLOYEES_IN_OUT_PERIOD EIP WHERE EC.EXPENSE_CODE = EIP.EXPENSE_CODE AND EIP.PERIOD_ID = CP.PERIOD_ID AND CP.IN_OUT_ID = EIP.IN_OUT_ID) AS EXPENSE_NAME,
                    (SELECT EXPENSE_CODE FROM EMPLOYEES_IN_OUT_PERIOD WHERE IN_OUT_ID = EI.IN_OUT_ID AND PERIOD_ID = CP.PERIOD_ID) AS EXPENSE_CODE,
                    (SELECT EXPENSE_CODE_NAME FROM EMPLOYEES_IN_OUT_PERIOD WHERE IN_OUT_ID = EI.IN_OUT_ID AND PERIOD_ID = CP.PERIOD_ID) AS EXPENSE_CODE_NAME,
                    (SELECT EXPENSE_ITEM_ID FROM EMPLOYEES_IN_OUT_PERIOD WHERE IN_OUT_ID = EI.IN_OUT_ID AND PERIOD_ID = CP.PERIOD_ID) AS EXPENSE_ITEM_ID,
                    (SELECT EXPENSE_ITEM_NAME FROM EMPLOYEES_IN_OUT_PERIOD WHERE IN_OUT_ID = EI.IN_OUT_ID AND PERIOD_ID = CP.PERIOD_ID) AS EXPENSE_ITEM_NAME,
                    (SELECT TOP 1 EA.ACCOUNT_CODE FROM EMPLOYEES_ACCOUNTS EA WHERE EA.EMPLOYEE_ID = CP.TO_EMPLOYEE_ID AND EA.IN_OUT_ID = EI.IN_OUT_ID AND EA.PERIOD_ID=CP.PERIOD_ID AND EA.ACC_TYPE_ID=ISNULL((SELECT ACC_TYPE_ID FROM SETUP_PAYMENT_INTERRUPTION WHERE ODKES_ID = DEMAND_TYPE),-2)) AS ACCOUNT_CODE ,
                    E.EMPLOYEE_NO,
                    ISNULL((SELECT ACC_TYPE_ID FROM SETUP_PAYMENT_INTERRUPTION WHERE ODKES_ID = CP.DEMAND_TYPE),-2) AS ACC_TYPE_ID,
                    (SELECT ACC_TYPE_NAME FROM SETUP_ACC_TYPE WHERE ACC_TYPE_ID = ISNULL((SELECT ACC_TYPE_ID FROM SETUP_PAYMENT_INTERRUPTION WHERE ODKES_ID = CP.DEMAND_TYPE),-2)) ACC_TYPE_NAME,
                    CP.DETAIL,
                    CP.PROJECT_ID,
                    (SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = CP.PROJECT_ID) AS PROJECT_HEAD
                FROM 
                    CORRESPONDENCE_PAYMENT CP,
                    EMPLOYEES E,
                    EMPLOYEES_IN_OUT EI
                WHERE 
                    CP.ID IN(#arguments.paymentIds#) AND
                    CP.IN_OUT_ID = EI.IN_OUT_ID AND 
                    EI.EMPLOYEE_ID = E.EMPLOYEE_ID
            <cfelseif len(arguments.cariActionIdList)>
                SELECT DISTINCT
                    CP.CARI_ACTION_ID,
                    CP.FROM_EMPLOYEE_ID,
                    (SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = CP.FROM_EMPLOYEE_ID) AS NAMESURNAME,
                    CP.ACTION_VALUE,
                    CP.ACTION_CURRENCY_ID,
                    (SELECT EXPENSE_ID FROM EXPENSE_CENTER EC,EMPLOYEES_IN_OUT_PERIOD EIP WHERE EC.EXPENSE_CODE = EIP.EXPENSE_CODE AND EIP.PERIOD_ID = #session.ep.period_id# AND EI.IN_OUT_ID = EIP.IN_OUT_ID) AS EXPENSE_ID,
                    (SELECT EXPENSE FROM EXPENSE_CENTER EC,EMPLOYEES_IN_OUT_PERIOD EIP WHERE EC.EXPENSE_CODE = EIP.EXPENSE_CODE AND EIP.PERIOD_ID = #session.ep.period_id# AND EI.IN_OUT_ID = EIP.IN_OUT_ID) AS EXPENSE_NAME,
                    (SELECT EXPENSE_CODE FROM EMPLOYEES_IN_OUT_PERIOD WHERE IN_OUT_ID = EI.IN_OUT_ID AND PERIOD_ID = #session.ep.period_id#) AS EXPENSE_CODE,
                    (SELECT EXPENSE_CODE_NAME FROM EMPLOYEES_IN_OUT_PERIOD WHERE IN_OUT_ID = EI.IN_OUT_ID AND PERIOD_ID = #session.ep.period_id#) AS EXPENSE_CODE_NAME,
                    (SELECT EXPENSE_ITEM_ID FROM EMPLOYEES_IN_OUT_PERIOD WHERE IN_OUT_ID = EI.IN_OUT_ID AND PERIOD_ID = #session.ep.period_id#) AS EXPENSE_ITEM_ID,
                    (SELECT EXPENSE_ITEM_NAME FROM EMPLOYEES_IN_OUT_PERIOD WHERE IN_OUT_ID = EI.IN_OUT_ID AND PERIOD_ID = #session.ep.period_id#) AS EXPENSE_ITEM_NAME,
                    (SELECT TOP 1 EA.ACCOUNT_CODE FROM EMPLOYEES_ACCOUNTS EA WHERE EA.EMPLOYEE_ID = CP.TO_EMPLOYEE_ID AND EA.IN_OUT_ID = EI.IN_OUT_ID AND EA.PERIOD_ID=#session.ep.period_id# AND EA.ACC_TYPE_ID=CP.ACC_TYPE_ID) AS ACCOUNT_CODE ,
                    E.EMPLOYEE_NO,
                    CP.ACC_TYPE_ID,
                    SC.ACC_TYPE_NAME
                FROM 
                    #dsn2#.CARI_ROWS CP
                    LEFT JOIN EMPLOYEES_IN_OUT EI ON CP.FROM_EMPLOYEE_ID = EI.EMPLOYEE_ID
                    LEFT JOIN EMPLOYEES E ON EI.EMPLOYEE_ID = E.EMPLOYEE_ID
                    LEFT JOIN SETUP_ACC_TYPE SC ON CP.ACC_TYPE_ID = SC.ACC_TYPE_ID
                WHERE 
                    CP.CARI_ACTION_ID IN(#arguments.cariActionIdList#) AND
                    EI.FINISH_DATE IS NULL
            </cfif>        	
        </cfquery>
        <cfreturn getPayments>
    </cffunction>
    <cffunction name="setClosedInfo" access="public" returntype="boolean">
    	<cfargument name="orderId" required="yes" type="numeric" hint="Ödeme Emri ID">
        <cfargument name="correspondence_info" required="no" type="any" hint="">
        <cfargument name="order_row_id" required="no" type="string" hint="">
        <cfargument name="cariActionId" required="no" type="numeric" hint="Cari İşlem ID">
        <cfargument name="closedRowId" required="no" type="numeric" hint="Kapama Satır ID">
		<cfquery name="GET_CLOSED" datasource="#dsn2#">
			SELECT P_ORDER_DEBT_AMOUNT_VALUE,P_ORDER_CLAIM_AMOUNT_VALUE FROM CARI_CLOSED WHERE CLOSED_ID = #arguments.orderId#
		</cfquery>
		<cfquery name="UPD_CLOSED" datasource="#dsn2#">
			UPDATE
				CARI_CLOSED
			SET
				IS_CLOSED = 1,
				<cfif GET_CLOSED.P_ORDER_DEBT_AMOUNT_VALUE neq 0>
					DEBT_AMOUNT_VALUE = P_ORDER_DEBT_AMOUNT_VALUE,
					CLAIM_AMOUNT_VALUE = P_ORDER_DEBT_AMOUNT_VALUE,
				<cfelse>
					DEBT_AMOUNT_VALUE = P_ORDER_CLAIM_AMOUNT_VALUE,
					CLAIM_AMOUNT_VALUE = P_ORDER_CLAIM_AMOUNT_VALUE,
				</cfif>
				DIFFERENCE_AMOUNT_VALUE = 0
			WHERE
				CLOSED_ID = #arguments.orderId#
		</cfquery>
		<cfquery name="UPD_CLOSED" datasource="#dsn2#">
			UPDATE
				CARI_CLOSED_ROW
			SET
            	<cfif len(arguments.correspondence_info)>
                	RELATED_CLOSED_ROW_ID = 0,
                    RELATED_CARI_ACTION_ID = #arguments.cariActionId#,
                <cfelseif len(arguments.closedRowId)>
                	RELATED_CLOSED_ROW_ID = #arguments.closedRowId#,
                </cfif>
				CLOSED_AMOUNT = P_ORDER_VALUE,
				OTHER_CLOSED_AMOUNT = OTHER_P_ORDER_VALUE
			WHERE
				CLOSED_ID = #arguments.orderId#
                <cfif len(arguments.order_row_id)>
                	AND CLOSED_ROW_ID IN (#arguments.order_row_id#)
                </cfif>
		</cfquery>
        <cfreturn true>
    </cffunction>
    <cffunction name="addClosedInfo" access="public" returntype="numeric">
		<cfargument name="orderId" required="yes" type="numeric" hint="Ödeme Emri ID">
        <cfargument name="cariActionId" required="yes" type="numeric" hint="Cari İşlem ID">
        <cfargument name="bankActionId" required="yes" type="numeric" hint="Banka İşlemi ID">
		<cfargument name="actionType" required="yes" type="numeric" hint="İşlem Tipi">
        <cfargument name="systemAmount" required="yes" type="any" hint="İşlem Tutarı">
        <cfargument name="otherMoneyValue" required="yes" type="any" hint="Dövizli Tutar">
        <cfargument name="otherMoney" required="yes" type="string" hint="Döviz Birimi">
        <cfargument name="dueDate" required="yes" type="string" hint="Vade Tarihi">
		<cfquery name="UPD_CLOSED" datasource="#dsn2#" result="MAX_ID">
			INSERT INTO
				CARI_CLOSED_ROW
			(
				CLOSED_ID,
				CARI_ACTION_ID,
				ACTION_ID,
				ACTION_TYPE_ID,
				ACTION_VALUE,
				CLOSED_AMOUNT,
				OTHER_CLOSED_AMOUNT,
				P_ORDER_VALUE,
				OTHER_P_ORDER_VALUE,							
				OTHER_MONEY,
				DUE_DATE
			)
			VALUES
			(
				#arguments.orderId#,
				#arguments.cariActionId#,
				#arguments.bankActionId#,
				#arguments.actionType#,
				#arguments.systemAmount#,
				#arguments.systemAmount#,
				#arguments.otherMoneyValue#,
				#arguments.systemAmount#,
				#arguments.otherMoneyValue#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.otherMoney#">,
				#arguments.dueDate#
			)
		</cfquery>
        <cfreturn MAX_ID.IDENTITYCOL>
    </cffunction>
    <!--- getAllAction --->
    <cffunction name="getAllAction" access="public" returntype="query">
    	<cfargument name="multiId" type="numeric" required="yes" hint="Toplu İşlem ID">
        <cfquery name="get_all_action" datasource="#dsn2#">
            SELECT
            	ACTION_ID,
                ACTION_TYPE_ID
            FROM
            	BANK_ACTIONS
            WHERE
            	MULTI_ACTION_ID = #arguments.multiId#
        </cfquery>
        <cfreturn get_all_action>
    </cffunction>
</cfcomponent>