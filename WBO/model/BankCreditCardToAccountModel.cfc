<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Sevda Kurt			Developer	: Sevda Kurt		
Analys Date : 23/05/2016			Dev Date	: 23/05/2016		
Description :
	Bu component Kredi Kartı Hesaba Geçiş objesine ait CRUD  fonksiyonlarını gerceklestirir.
----------------------------------------------------------------------->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2 = dsn & '_' & session.ep.period_year & '_' & session.ep.company_id>
    <cfset dsn3 = dsn & '_' & session.ep.company_id>
    <!--- get --->
	<cffunction name="get" access="public" returntype="query">
    	<cfargument name="actionId" type="numeric" hint="İşlem İd">
    	<cfquery name="get" datasource="#dsn2#">
        	SELECT
            	BA.ACTION_ID,
                BA.ACTION_TYPE_ID,
            	BA.ACTION_DATE,
                IIF(BA.ACTION_TYPE_ID = 243,BA.ACTION_TO_ACCOUNT_ID,BA.ACTION_FROM_ACCOUNT_ID) ACCOUNT_ID,
                BA.ACTION_VALUE,
                A.ACCOUNT_CURRENCY_ID,
                BA.MASRAF,
                BA.OTHER_CASH_ACT_VALUE,
                BA.OTHER_MONEY,
                BA.ACTION_DETAIL,
                A.ACCOUNT_NAME,
                BA.RECORD_EMP,
                BA.RECORD_DATE,
                BA.UPDATE_EMP,
                BA.UPDATE_DATE
            FROM
            	BANK_ACTIONS BA
                LEFT JOIN #dsn3#.ACCOUNTS A ON A.ACCOUNT_ID = IIF(BA.ACTION_TYPE_ID = 243,BA.ACTION_TO_ACCOUNT_ID,BA.ACTION_FROM_ACCOUNT_ID)
			WHERE
            	BA.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.actionId#">
        </cfquery>
		<cfreturn get>
	</cffunction>
    <cffunction name="getRows" access="public" returntype="query">
    	<cfargument name="checkedValue" type="any" hint="Listede Seçilmiş Olan Tahsilatlar">
        <cfquery name="getRows" datasource="#dsn2#">
            SELECT
                PAYMENTS_ROWS.ACTION_TO_ACCOUNT_ID,
                PAYMENTS_ROWS.PAYMENT_TYPE_ID,
                PAYMENTS_ROWS.BANK_ACTION_DATE,
                PAYMENTS_ROWS.OTHER_MONEY,
                SUM(DOVIZ_TOPLAM1-DOVIZ_TOPLAM2) DOVIZ_TOPLAM,
                SUM(COMS_TOPLAM1-COMS_TOPLAM2) COMS_TOPLAM,
                SUM(TOPLAM1-TOPLAM2) TOPLAM,
				A.ACCOUNT_ACC_CODE,
				CCPT.ACCOUNT_CODE ACC_CODE_PAYMENT_TYPE,
                CCPT.CARD_NO
            FROM
            (
                SELECT
                    CCP.ACTION_TO_ACCOUNT_ID,
                    CCP_R.PAYMENT_TYPE_ID,
                    CCP_R.BANK_ACTION_DATE,
                    <cfif session.ep.period_year lt 2009>
                        CASE WHEN(CCP.OTHER_MONEY = 'TL') THEN 'YTL' ELSE CCP.OTHER_MONEY END AS OTHER_MONEY,
                    <cfelse>
                        CASE WHEN(CCP.OTHER_MONEY = 'YTL') THEN 'TL' ELSE CCP.OTHER_MONEY END AS OTHER_MONEY,
                    </cfif>
                    SUM(CCP_R.AMOUNT/(CCP.SALES_CREDIT/CCP.OTHER_CASH_ACT_VALUE)) DOVIZ_TOPLAM1,
                    0 DOVIZ_TOPLAM2,
                    SUM(CCP_R.COMMISSION_AMOUNT) COMS_TOPLAM1,
                    0 COMS_TOPLAM2,
                    SUM(CCP_R.AMOUNT) TOPLAM1,
                    0 TOPLAM2
                FROM
                    #dsn3#.CREDIT_CARD_BANK_PAYMENTS CCP,
                    #dsn3#.CREDIT_CARD_BANK_PAYMENTS_ROWS CCP_R
                WHERE
                    CCP.CREDITCARD_PAYMENT_ID = CCP_R.CREDITCARD_PAYMENT_ID AND
                    CCP_R.CC_BANK_PAYMENT_ROWS_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#checkedValue#" list="yes">) AND
                    CCP.ACTION_TYPE_ID <> 245<!--- iptal dışındakiler--->
                GROUP BY
                    CCP.ACTION_TO_ACCOUNT_ID,
                    CCP.OTHER_MONEY,
                    CCP_R.PAYMENT_TYPE_ID,
                    CCP_R.BANK_ACTION_DATE
            UNION ALL
                SELECT
                    CCP.ACTION_TO_ACCOUNT_ID,
                    CCP_R.PAYMENT_TYPE_ID,
                    CCP_R.BANK_ACTION_DATE,
                    <cfif session.ep.period_year lt 2009>
                        CASE WHEN(CCP.OTHER_MONEY = 'TL') THEN 'YTL' ELSE CCP.OTHER_MONEY END AS OTHER_MONEY,
                    <cfelse>
                        CASE WHEN(CCP.OTHER_MONEY = 'YTL') THEN 'TL' ELSE CCP.OTHER_MONEY END AS OTHER_MONEY,
                    </cfif>
                    0 DOVIZ_TOPLAM1,
                    SUM(CCP_R.AMOUNT/(CCP.SALES_CREDIT/CCP.OTHER_CASH_ACT_VALUE)) DOVIZ_TOPLAM2,
                    0 COMS_TOPLAM1,
                    SUM(CCP_R.COMMISSION_AMOUNT) COMS_TOPLAM2,
                    0 TOPLAM1,
                    SUM(CCP_R.AMOUNT) TOPLAM2
                FROM
                    #dsn3#.CREDIT_CARD_BANK_PAYMENTS CCP,
                    #dsn3#.CREDIT_CARD_BANK_PAYMENTS_ROWS CCP_R
                WHERE
                    CCP.CREDITCARD_PAYMENT_ID = CCP_R.CREDITCARD_PAYMENT_ID AND
                    CCP_R.CC_BANK_PAYMENT_ROWS_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#checkedValue#" list="yes">) AND
                    CCP.ACTION_TYPE_ID = 245<!--- kredi kartı tahsilat iptal --->
                GROUP BY
                    CCP.ACTION_TO_ACCOUNT_ID,
                    CCP.OTHER_MONEY,
                    CCP_R.PAYMENT_TYPE_ID,
                    CCP_R.BANK_ACTION_DATE
            ) AS PAYMENTS_ROWS
				LEFT JOIN #dsn3#.ACCOUNTS A ON PAYMENTS_ROWS.ACTION_TO_ACCOUNT_ID = A.ACCOUNT_ID
				LEFT JOIN #dsn3#.CREDITCARD_PAYMENT_TYPE CCPT ON PAYMENTS_ROWS.PAYMENT_TYPE_ID = CCPT.PAYMENT_TYPE_ID
            GROUP BY
                PAYMENTS_ROWS.ACTION_TO_ACCOUNT_ID,
                PAYMENTS_ROWS.PAYMENT_TYPE_ID,
                PAYMENTS_ROWS.BANK_ACTION_DATE,
                PAYMENTS_ROWS.OTHER_MONEY,
				A.ACCOUNT_ACC_CODE,
				CCPT.ACCOUNT_CODE,
                CCPT.CARD_NO
            ORDER BY
                PAYMENTS_ROWS.PAYMENT_TYPE_ID
        </cfquery>
        <cfreturn getRows>
    </cffunction>
    <!--- add --->
    <cffunction name="add" access="public" returntype="numeric">
    	<cfargument name="processCat" type="numeric" required="yes" hint="İşlem Kategorisi">
    	<cfargument name="processType" type="numeric" required="yes" hint="İşlem Tipi">
        <cfargument name="paperNo" type="string" hint="Belge Numarası">
		<cfargument name="actionAccountId" type="numeric" required="yes" hint="Banka Hesabı">
        <cfargument name="actionValue" type="any" required="yes" hint="İşlem Tutarı">
        <cfargument name="expense" type="any" hint="Masraf Tutarı">
    	<cfargument name="startDate" type="date" required="yes" hint="Hesaba Geçiş Tarihi">
        <cfargument name="actionDetail" type="string" default="" hint="Açıklama">
        <cfargument name="otherMoneyValue" type="any" hint="Dövizli Tutar">
		<cfargument name="otherMoney" type="string" hint="Döviz">
        <cfargument name="expenseCenterId" type="numeric" default="0" hint="Masraf Merkezi">
        <cfargument name="expenseItemId" type="numeric" default="0" hint="Gider Kalemi">
        <cfargument name="actionValue2" type="any" hint="2. Döviz Tutarı">
        <cfargument name="isAccount" type="numeric" required="yes" hint="Muhasebe İşlemi Yapıyor mu?">
        <cfquery name="addBankAction" datasource="#dsn2#" result="MAX_ID">
            INSERT INTO
                BANK_ACTIONS
                (
                    ACTION_TYPE,
                    PROCESS_CAT,
                    ACTION_TYPE_ID,
                    PAPER_NO,
                    <cfif arguments.processType eq 243>ACTION_TO_ACCOUNT_ID,<cfelse>ACTION_FROM_ACCOUNT_ID,</cfif>
                    ACTION_VALUE,<!--- hesaba geçiş işlemlerinde masraf çıkarılmış tutar bank_actions a yazılır --->
                    MASRAF,
                    ACTION_DATE,
                    ACTION_CURRENCY_ID,
                    ACTION_DETAIL,
                    OTHER_CASH_ACT_VALUE,
                    OTHER_MONEY,
                    IS_ACCOUNT,
                    IS_ACCOUNT_TYPE,
                    RECORD_EMP,
                    RECORD_IP,
                    RECORD_DATE,
                    <cfif arguments.processType eq 243>TO_BRANCH_ID<cfelse>FROM_BRANCH_ID</cfif>,
                    SYSTEM_ACTION_VALUE,
                    SYSTEM_CURRENCY_ID,
                    EXPENSE_CENTER_ID,
                    EXPENSE_ITEM_ID
                    <cfif len(session.ep.money2)>
                        ,ACTION_VALUE_2
                        ,ACTION_CURRENCY_ID_2
                    </cfif>
                )
                VALUES
                (
                    <cfif arguments.processType eq 243>'<cf_get_lang dictionary_id="49595.KREDİ KARTI HESABA GEÇİŞ ">',<cfelse> "<cf_get_lang dictionary_id='49596.KREDİ KARTI HESABA GEÇİŞ İPTAL'>",</cfif>
                    #arguments.processCat#,
                    #arguments.processType#,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.paperNo#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.actionAccountId#">,
                    #abs(arguments.actionValue) - arguments.expense#,
                    #arguments.expense#,
                    #arguments.startDate#,
                    '#session.ep.money#',<!--- zaten tahsilatlar sistem para birimi dışnda olmadgndan sıkıntı olmaz --->
                    <cfif len(arguments.actionDetail)>'#left(arguments.actionDetail,250)#',<cfelse>NULL,</cfif>
                    <cfif len(arguments.otherMoneyValue)>#arguments.otherMoneyValue#,<cfelse>NULL,</cfif>
                    <cfif len(arguments.otherMoney)>'#arguments.otherMoney#',<cfelse>NULL,</cfif>
                    <cfif arguments.isAccount eq 1>1,13,<cfelse>0,13,</cfif>
                    #session.ep.userid#,
                    '#cgi.REMOTE_ADDR#',
                    #now()#,
                    #listgetat(session.ep.user_location,2,'-')#,
                    #abs(arguments.actionValue) - arguments.expense#,
                    '#session.ep.money#',
                    <cfif arguments.expenseCenterId neq 0>#arguments.expenseCenterId#<cfelse>NULL</cfif>,
                    <cfif arguments.expenseItemId neq 0>#arguments.expenseItemId#<cfelse>NULL</cfif>
                    <cfif len(session.ep.money2)>
                        ,#arguments.actionValue2#
                        ,'#session.ep.money2#'
                    </cfif>
                )
        </cfquery>
        <cfreturn MAX_ID.IDENTITYCOL>
    </cffunction>
    <!--- updBankActionId --->
    <cffunction name="updBankActionId" access="public" returntype="numeric">
    	<cfargument name="bankActionId" type="numeric" required="yes" hint="Banka İşlemlerindeki ID">
        <cfargument name="checkedValue" type="any" required="yes" hint="Listede Seçilmiş Olan Tahsilatlar">
    	<cfargument name="paymentTypeId" type="numeric" required="yes" hint="Ödeme Yöntemi">
        <cfargument name="bankActionDate" type="date" required="yes" hint="Banka İşlemi Tarihi">
    	<cfargument name="actionAccountId" type="numeric" required="yes" hint="Banka Hesabı">
        <cfargument name="otherMoney" type="any" required="yes" hint="Döviz">
        <cfquery name="updateCCBP" datasource="#dsn3#" result="MAX_ID">
            UPDATE
                CREDIT_CARD_BANK_PAYMENTS_ROWS
            SET
                BANK_ACTION_ID = #arguments.bankActionId#,
                BANK_ACTION_PERIOD_ID = #session.ep.period_id#
            WHERE
                CC_BANK_PAYMENT_ROWS_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.checkedValue#" list="yes">) AND
                PAYMENT_TYPE_ID = #arguments.paymentTypeId# AND
                BANK_ACTION_DATE = #CreateODBCDateTime(arguments.bankActionDate)# AND
                CREDITCARD_PAYMENT_ID IN 
                (
                    SELECT 
                        CREDIT_CARD_BANK_PAYMENTS.CREDITCARD_PAYMENT_ID
                    FROM
                        CREDIT_CARD_BANK_PAYMENTS CREDIT_CARD_BANK_PAYMENTS
                    WHERE
                        CREDIT_CARD_BANK_PAYMENTS.ACTION_TO_ACCOUNT_ID = #arguments.actionAccountId# AND
                    <cfif session.ep.period_year lt 2009>
                        CREDIT_CARD_BANK_PAYMENTS.OTHER_MONEY = '#arguments.otherMoney#' OR (CREDIT_CARD_BANK_PAYMENTS.OTHER_MONEY = 'TL' AND '#arguments.otherMoney#' = 'YTL')
                    <cfelse>
                        CREDIT_CARD_BANK_PAYMENTS.OTHER_MONEY = '#arguments.otherMoney#' OR (CREDIT_CARD_BANK_PAYMENTS.OTHER_MONEY = 'YTL' AND '#arguments.otherMoney#' = 'TL')
                    </cfif>
                        
                )
        </cfquery>
        <cfreturn arguments.bankActionId>
    </cffunction>
   	<!--- list --->
	<cffunction name="list" access="public" returntype="query">
		<cfargument name="record_emp_id" type="any" hint="Kaydeden Bilgisi">
        <cfargument name="record_emp_name" type="string" hint="Kaydeden Bilgisi">
        <cfargument name="keyword" type="string" hint="Filtre">
        <cfargument name="date_1" type="string" default="" hint="Başlangıç Tarihi">
        <cfargument name="date_2" type="string" default="" hint="Bitiş Tarihi">
        <cfargument name="bank_account" type="numeric" default="0" hint="Banka Hesabı">
		<cfargument name="branch_id" type="any" hint="Şube">
        <cfargument name="company_id" type="any" hint="Kurumsal Üye">
        <cfargument name="cons_id" type="any" hint="Bireysel Üye">
        <cfargument name="member_name" type="string" hint="Üye Adı">
        <cfargument name="payment_status" type="numeric" default="0" hint="Hesaba Geçiş Durumu">
        <cfargument name="action_type_" type="any" hint="İşlem Tipi">
        <cfargument name="bank_action_date" type="string" hint="Sıralama">
        <cfquery name="getCreditCardToAccount" datasource="#dsn3#" >
            SELECT 
                CCBPR.*,
                CCBP.CREDITCARD_PAYMENT_ID,
                CCBP.ACTION_FROM_COMPANY_ID,
                CCBP.CONSUMER_ID,
                CCBP.STORE_REPORT_DATE,
                CCBP.SALES_CREDIT,
                CCBP.TO_BRANCH_ID,
                ACCOUNTS.ACCOUNT_NAME AS ACCOUNT_BRANCH,
                ACCOUNTS.ACCOUNT_ID,
                CREDITCARD_PAYMENT_TYPE.CARD_NO,
                CCBP.ACTION_TYPE,
                CCBP.ACTION_TYPE_ID,
                COMPANY.FULLNAME,
                CONSUMER.CONSUMER_NAME,
                CONSUMER.CONSUMER_SURNAME,
                BRANCH.BRANCH_NAME
            FROM
                CREDIT_CARD_BANK_PAYMENTS_ROWS CCBPR
                LEFT JOIN CREDIT_CARD_BANK_PAYMENTS CCBP ON CCBPR.CREDITCARD_PAYMENT_ID = CCBP.CREDITCARD_PAYMENT_ID
                LEFT JOIN ACCOUNTS ON CCBP.ACTION_TO_ACCOUNT_ID = ACCOUNTS.ACCOUNT_ID
                LEFT JOIN CREDITCARD_PAYMENT_TYPE ON CCBP.PAYMENT_TYPE_ID = CREDITCARD_PAYMENT_TYPE.PAYMENT_TYPE_ID
                LEFT JOIN #dsn#.COMPANY ON COMPANY.COMPANY_ID = CCBP.ACTION_FROM_COMPANY_ID
                LEFT JOIN #dsn#.CONSUMER ON CONSUMER.CONSUMER_ID = CCBP.CONSUMER_ID
                LEFT JOIN #dsn#.BRANCH  ON BRANCH.BRANCH_ID = CCBP.TO_BRANCH_ID
            WHERE
                CCBP.STORE_REPORT_ID IS NULL AND
                CCBPR.AMOUNT > 0  AND 
                ISNULL(CCBP.IS_VOID,0) <> 1 AND	<!--- bir kredi karti tahsilat islemine ait iptal varsa, hem o tahsilat isleminin hem de iptal isleminin gelmemesi saglandi --->
                ISNULL(CCBP.RELATION_CREDITCARD_PAYMENT_ID,0) NOT IN (SELECT CCBP.CREDITCARD_PAYMENT_ID FROM CREDIT_CARD_BANK_PAYMENTS CCBP WHERE ISNULL(CCBP.IS_VOID,0) = 1)
                <cfif len(arguments.record_emp_id) and len(arguments.record_emp_name)>AND CCBP.RECORD_EMP = #arguments.record_emp_id#</cfif>
                <cfif len(arguments.keyword)>AND CREDITCARD_PAYMENT_TYPE.CARD_NO LIKE '%#arguments.keyword#%'</cfif>
                <cfif len(arguments.date_1)>AND CCBPR.BANK_ACTION_DATE >= #arguments.date_1#</cfif>
                <cfif len(arguments.date_2)>AND CCBPR.BANK_ACTION_DATE < #DATEADD("d",1,arguments.date_2)#</cfif>
                <cfif arguments.bank_account neq 0>AND CREDITCARD_PAYMENT_TYPE.BANK_ACCOUNT = #arguments.bank_account#</cfif>
                <cfif (session.ep.isBranchAuthorization) or (len(arguments.branch_id))>
                    AND CCBP.TO_BRANCH_ID = #arguments.branch_id#
                </cfif>
                <cfif len(arguments.company_id) and len(arguments.member_name)>
                    AND CCBP.ACTION_FROM_COMPANY_ID = #arguments.company_id#
                <cfelseif len(arguments.cons_id) and len(arguments.member_name)>
                    AND CCBP.CONSUMER_ID = #arguments.cons_id#
                </cfif>
                <cfif arguments.payment_status eq 1>AND CCBPR.BANK_ACTION_ID IS NOT NULL<cfelseif arguments.payment_status eq 2>AND CCBPR.BANK_ACTION_ID IS NULL</cfif>
                <cfif len(arguments.action_type_)>
                    AND CCBP.ACTION_TYPE_ID = #arguments.action_type_#
                </cfif>
            ORDER BY
                <cfif arguments.bank_action_date eq 1>
                    CCBPR.BANK_ACTION_DATE,
                <cfelseif arguments.bank_action_date eq 2>
                    CCBPR.BANK_ACTION_DATE DESC,
                </cfif>
                CCBP.CREDITCARD_PAYMENT_ID DESC
        </cfquery>
		<cfreturn getCreditCardToAccount>
	</cffunction>
    <!--- del --->
    <cffunction name="del" access="public" returntype="boolean">
    	<cfargument name="id" type="numeric" required="yes" hint="Silinecek İşlem Id">
        <cfquery name="delBankAction" datasource="#dsn2#">
            DELETE FROM BANK_ACTIONS WHERE ACTION_ID = #arguments.id#
        </cfquery>
        <cfquery name="delPaymentRows" datasource="#dsn2#">
            UPDATE
                #dsn3#.CREDIT_CARD_BANK_PAYMENTS_ROWS
            SET
                BANK_ACTION_ID = NULL,
                BANK_ACTION_PERIOD_ID = NULL
            WHERE
                BANK_ACTION_ID = #arguments.id# AND
                BANK_ACTION_PERIOD_ID = #session.ep.period_id#
        </cfquery>
        <cfreturn true>
    </cffunction>
    <!--- getPaymentId --->
    <cffunction name="getPaymentIds" access="public" returntype="query">
    	<cfargument name="bankActionId" type="numeric" required="yes" hint="Banka İşlemi Id">
        <cfquery name="getPaymentIds" datasource="#dsn3#">
			SELECT
            	CREDITCARD_PAYMENT_ID
            FROM
            	CREDIT_CARD_BANK_PAYMENTS_ROWS
            WHERE
            	BANK_ACTION_ID = #arguments.bankActionId#
                AND BANK_ACTION_PERIOD_ID = #session.ep.period_id#
            ORDER BY
            	CREDITCARD_PAYMENT_ID
        </cfquery>
        <cfreturn getPaymentIds>
    </cffunction>
</cfcomponent>