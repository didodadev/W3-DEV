<cfquery name="DB_CONTROL_OUT" datasource="#DSN#">
	SELECT 
		* 
	FROM  
		SETUP_PERIOD
	WHERE
		PERIOD_ID = #attributes.from_cmp#
</cfquery>
<cfquery name="DB_CONTROL_IN" datasource="#DSN#">
	SELECT 
		* 
	FROM  
		SETUP_PERIOD
	WHERE
		PERIOD_ID = #attributes.to_cmp#
</cfquery>
<cfset f_pyear = DB_CONTROL_OUT.PERIOD_YEAR>	<!--- çekleri aktarılacak şirketin period yılı --->
<cfset f_cmp = DB_CONTROL_OUT.OUR_COMPANY_ID>	<!--- çekleri aktarılacak şirket id --->
<cfset f_period = DB_CONTROL_OUT.PERIOD_ID>	<!--- çekleri aktarılacak şirketin periodu--->
<cfset t_pyear =  DB_CONTROL_IN.PERIOD_YEAR>	<!--- çeklerin aktarılacağı şirketin period yılı --->
<cfset t_cmp =  DB_CONTROL_IN.OUR_COMPANY_ID>		<!--- çeklerin aktarılacağı şirket id --->
<cfset t_period =  DB_CONTROL_IN.PERIOD_ID>	<!--- çeklerin aktarılacağı şirketin periodu --->

<!--- tablo gelen veriye göre belirlenir --->
<cfset db_out = '#DSN#_#f_pyear#_#f_cmp#'> 
<cfset db_in = '#DSN#_#t_pyear#_#t_cmp#'>

<cfscript>
	if (database_type IS 'MSSQL'){
		db_out = '#DSN#_#f_pyear#_#f_cmp#';
		db_in = '#DSN#_#t_pyear#_#t_cmp#';
	}
	else if (database_type IS 'DB2') {
		db_out = '#DSN#_#f_cmp#_#right(f_pyear,2)#';
		db_in = '#DSN#_#t_cmp#_#right(t_pyear,2)#';
	}
</cfscript>


<cfset islem_tarihi = CreateDateTime(t_pyear,1,1,0,0,0)>
<cfif DB_CONTROL_OUT.recordcount and DB_CONTROL_IN.recordcount>
	<cfquery name="get_cheques" datasource="#db_out#">
		SELECT	
			P.COMPANY_ID AS PAYROLL_COMP,
			P.CONSUMER_ID AS PAYROLL_CONS,
			P.EMPLOYEE_ID AS PAYROLL_EMP,
			CASE WHEN P2.TRANSFER_CASH_ID IS NOT NULL THEN P2.TRANSFER_CASH_ID ELSE P2.PAYROLL_CASH_ID END AS PAYROLL_CASH_ID,
			P2.PAYROLL_ACCOUNT_ID,
			ISNULL(P.PROJECT_ID,0) PROJECT_ID,
			C.*,
			CH.OTHER_MONEY_VALUE AS HIST_OTHER_MONEY_VALUE,
			CH.OTHER_MONEY AS HIST_OTHER_MONEY,
			CH.OTHER_MONEY_VALUE2 AS HIST_OTHER_MONEY_VALUE2,
			CH.OTHER_MONEY2 AS HIST_OTHER_MONEY2,
			ISNULL((SELECT TOP 1 CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.HISTORY_ID =(SELECT MAX(CH_.HISTORY_ID) FROM CHEQUE_HISTORY CH_ WHERE CH_.CHEQUE_ID=C.CHEQUE_ID AND CH_.HISTORY_ID <> CH.HISTORY_ID)),C.OLD_STATUS) OLD_STATUS_ID
		<cfif isDefined("attributes.is_cheque_voucher_based_action")>
			,C.OTHER_MONEY_VALUE/(PAYROLL_MONEY.RATE2/PAYROLL_MONEY.RATE1) C_OTHER_MONEY_VALUE
			,P.PAYROLL_OTHER_MONEY C_OTHER_MONEY
		</cfif>
		FROM
			CHEQUE C,
			CHEQUE_HISTORY CH,
			PAYROLL P,
			PAYROLL P2
			<cfif isDefined("attributes.is_cheque_voucher_based_action")>,PAYROLL_MONEY</cfif>
		WHERE
			C.CHEQUE_ID = CH.CHEQUE_ID
			AND CH.HISTORY_ID =(SELECT MAX(HISTORY_ID) FROM CHEQUE_HISTORY WHERE CHEQUE_ID=C.CHEQUE_ID)
			AND CH.PAYROLL_ID = P2.ACTION_ID
			AND P.ACTION_ID = C.CHEQUE_PAYROLL_ID
		<cfif isDefined("attributes.is_cheque_voucher_based_action")>
			AND P.PAYROLL_OTHER_MONEY = PAYROLL_MONEY.MONEY_TYPE 
			AND	P.ACTION_ID = PAYROLL_MONEY.ACTION_ID
		</cfif>
			AND C.CHEQUE_STATUS_ID IN (1,2,6,10,13)<!--- Portföyde,Bankada,Ödenmedi,Karşılıksız ,icra--->
	UNION ALL
		SELECT	
			P.COMPANY_ID AS PAYROLL_COMP,
			P.CONSUMER_ID AS PAYROLL_CONS,
			P.EMPLOYEE_ID AS PAYROLL_EMP,
			'' PAYROLL_CASH_ID,
			'' PAYROLL_ACCOUNT_ID,
			ISNULL(P.PROJECT_ID,0) PROJECT_ID,
			C.*,
			CH.OTHER_MONEY_VALUE AS HIST_OTHER_MONEY_VALUE,
			CH.OTHER_MONEY AS HIST_OTHER_MONEY,
			CH.OTHER_MONEY_VALUE2 AS HIST_OTHER_MONEY_VALUE2,
			CH.OTHER_MONEY2 AS HIST_OTHER_MONEY2,
			ISNULL((SELECT TOP 1 CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.HISTORY_ID =(SELECT MAX(CH_.HISTORY_ID) FROM CHEQUE_HISTORY CH_ WHERE CH_.CHEQUE_ID=C.CHEQUE_ID AND CH_.HISTORY_ID <> CH.HISTORY_ID)),C.OLD_STATUS) OLD_STATUS_ID
		<cfif isDefined("attributes.is_cheque_voucher_based_action")>
			,C.OTHER_MONEY_VALUE/(PAYROLL_MONEY.RATE2/PAYROLL_MONEY.RATE1) C_OTHER_MONEY_VALUE
			,P.PAYROLL_OTHER_MONEY C_OTHER_MONEY
		</cfif>
		FROM
			CHEQUE C,
			CHEQUE_HISTORY CH,
			PAYROLL P
			<cfif isDefined("attributes.is_cheque_voucher_based_action")>,PAYROLL_MONEY</cfif>
		WHERE
			C.CHEQUE_ID = CH.CHEQUE_ID
			AND CH.HISTORY_ID =(SELECT MAX(HISTORY_ID) FROM CHEQUE_HISTORY WHERE CHEQUE_ID=C.CHEQUE_ID)
			AND P.ACTION_ID = C.CHEQUE_PAYROLL_ID
		<cfif isDefined("attributes.is_cheque_voucher_based_action")>
			AND P.PAYROLL_OTHER_MONEY = PAYROLL_MONEY.MONEY_TYPE 
			AND	P.ACTION_ID = PAYROLL_MONEY.ACTION_ID
		</cfif>
			AND C.CHEQUE_STATUS_ID IN (5,12)<!--- Portföyde,Bankada,Ödenmedi,Karşılıksız --->
		<cfif isDefined("attributes.is_cheque_voucher_based_action")><!--- eğer carileşme yapılıyorsa payrol_money kayıtları olmayanlar için cari rows tan baktık --->
		UNION ALL
			SELECT	
				P.COMPANY_ID AS PAYROLL_COMP,
				P.CONSUMER_ID AS PAYROLL_CONS,
				P.EMPLOYEE_ID AS PAYROLL_EMP,
				P2.PAYROLL_CASH_ID,
				P2.PAYROLL_ACCOUNT_ID,
				ISNULL(P.PROJECT_ID,0) PROJECT_ID,
				C.*,
				CH.OTHER_MONEY_VALUE AS HIST_OTHER_MONEY_VALUE,
				CH.OTHER_MONEY AS HIST_OTHER_MONEY,
				CH.OTHER_MONEY_VALUE2 AS HIST_OTHER_MONEY_VALUE2,
				CH.OTHER_MONEY2 AS HIST_OTHER_MONEY2,
				ISNULL((SELECT TOP 1 CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.HISTORY_ID =(SELECT MAX(CH_.HISTORY_ID) FROM CHEQUE_HISTORY CH_ WHERE CH_.CHEQUE_ID=C.CHEQUE_ID AND CH_.HISTORY_ID <> CH.HISTORY_ID)),C.OLD_STATUS) OLD_STATUS_ID,
				CR.OTHER_CASH_ACT_VALUE  C_OTHER_MONEY_VALUE,
				CR.OTHER_MONEY C_OTHER_MONEY
			FROM
				CHEQUE C,
				CHEQUE_HISTORY CH,
				PAYROLL P,
				PAYROLL P2,
				CARI_ROWS CR
			WHERE
				C.CHEQUE_ID = CH.CHEQUE_ID
				AND CH.HISTORY_ID =(SELECT MAX(HISTORY_ID) FROM CHEQUE_HISTORY WHERE CHEQUE_ID=C.CHEQUE_ID)
				AND CH.PAYROLL_ID = P2.ACTION_ID
				AND P.ACTION_ID = C.CHEQUE_PAYROLL_ID
				AND C.CHEQUE_ID = CR.ACTION_ID
				AND CR.ACTION_TYPE_ID = 106
				AND 
				(
					(C.COMPANY_ID IS NOT NULL AND C.COMPANY_ID = ISNULL(CR.FROM_CMP_ID,TO_CMP_ID))
					OR
					(C.CONSUMER_ID IS NOT NULL AND C.CONSUMER_ID = ISNULL(CR.FROM_CONSUMER_ID,TO_CONSUMER_ID))
					OR
					(C.EMPLOYEE_ID IS NOT NULL AND C.EMPLOYEE_ID = ISNULL(CR.FROM_EMPLOYEE_ID,TO_EMPLOYEE_ID))
				)
				AND C.CHEQUE_PAYROLL_ID NOT IN(SELECT PM.ACTION_ID FROM PAYROLL_MONEY PM)
				AND C.CHEQUE_STATUS_ID IN (1,2,6,10,13)<!--- Portföyde,Bankada,Ödenmedi,Karşılıksız,icra --->
		UNION ALL
			SELECT	
				P.COMPANY_ID AS PAYROLL_COMP,
				P.CONSUMER_ID AS PAYROLL_CONS,
				P.EMPLOYEE_ID AS PAYROLL_EMP,
				'' PAYROLL_CASH_ID,
				'' PAYROLL_ACCOUNT_ID,
				ISNULL(P.PROJECT_ID,0) PROJECT_ID,
				C.*,
				CH.OTHER_MONEY_VALUE AS HIST_OTHER_MONEY_VALUE,
				CH.OTHER_MONEY AS HIST_OTHER_MONEY,
				CH.OTHER_MONEY_VALUE2 AS HIST_OTHER_MONEY_VALUE2,
				CH.OTHER_MONEY2 AS HIST_OTHER_MONEY2,
				ISNULL((SELECT TOP 1 CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.HISTORY_ID =(SELECT MAX(CH_.HISTORY_ID) FROM CHEQUE_HISTORY CH_ WHERE CH_.CHEQUE_ID=C.CHEQUE_ID AND CH_.HISTORY_ID <> CH.HISTORY_ID)),C.OLD_STATUS) OLD_STATUS_ID,
				CR.OTHER_CASH_ACT_VALUE  C_OTHER_MONEY_VALUE,
				CR.OTHER_MONEY C_OTHER_MONEY
			FROM
				CHEQUE C,
				CHEQUE_HISTORY CH,
				PAYROLL P,
				CARI_ROWS CR
			WHERE
				C.CHEQUE_ID = CH.CHEQUE_ID
				AND CH.HISTORY_ID =(SELECT MAX(HISTORY_ID) FROM CHEQUE_HISTORY WHERE CHEQUE_ID=C.CHEQUE_ID)
				AND P.ACTION_ID = C.CHEQUE_PAYROLL_ID
				AND C.CHEQUE_ID = CR.ACTION_ID
				AND CR.ACTION_TYPE_ID = 106
				AND C.CHEQUE_PAYROLL_ID NOT IN(SELECT PM.ACTION_ID FROM PAYROLL_MONEY PM)
				AND C.CHEQUE_STATUS_ID IN(5,12)<!--- Portföyde,Bankada,Ödenmedi,Karşılıksız --->
		</cfif>
	</cfquery>
	<cfscript>
		cash_payroll_list='';
		account_payroll_list='';
		chq_cash_list='';
		chq_account_list='';
	</cfscript>
	<cfoutput query="get_cheques">
		<cfif len(project_id)>
			<cfif len(get_cheques.PAYROLL_CASH_ID)>
				<cfset chq_cash_list=listappend(chq_cash_list,"#get_cheques.PAYROLL_CASH_ID#;#get_cheques.project_id#")>
			</cfif>
			<cfif len(get_cheques.PAYROLL_ACCOUNT_ID)>
				<cfset chq_account_list=listappend(chq_account_list,"#get_cheques.PAYROLL_ACCOUNT_ID#;#get_cheques.project_id#")>
			</cfif>
		<cfelse>
			<cfif len(get_cheques.PAYROLL_CASH_ID)>
				<cfset chq_cash_list=listappend(chq_cash_list,"#get_cheques.PAYROLL_CASH_ID#;0")>
			</cfif>
			<cfif len(get_cheques.PAYROLL_ACCOUNT_ID)>
				<cfset chq_account_list=listappend(chq_account_list,"#get_cheques.PAYROLL_ACCOUNT_ID#;0")>
			</cfif>
		</cfif>
	</cfoutput>
	<!--- Kasa aktarımları kontrol ediliyor--->
	<cfif len(chq_cash_list)>
		<cfloop list="#chq_cash_list#" index="cash_index">
			<cfif listgetat(cash_index,1,';') neq 0>
				<cfquery name="get_cash_in" datasource="#db_in#">
					SELECT CASH_ID,BRANCH_ID FROM CASH WHERE CASH_ID = #listgetat(cash_index,1,';')#
				</cfquery>
				<cfif len(cash_index) and cash_index neq 0 and get_cash_in.recordcount eq 0>
					<script type="text/javascript">
						alert("Kasa Aktarımlarınız Eksik Yapıldığı İçin Aktarım Yapamazsınız !");
						history.back();
					</script>
					<cfabort>
				</cfif>
			</cfif>
		</cfloop>
	</cfif> 
	<cfif get_cheques.recordcount>
		<!--- aynı donemlerde aktarim yapildigina dair kontrol kaldırıldı 20140602 --->
		<!--- aynı donemler aktarım yapılıp yapılmadıgı kontrol ediliyor --->
		<!--- <cfquery name="control" datasource="#dsn#">
			SELECT
				TO_CHEQUE_VOUCHER_ID
			FROM
				CHEQUE_VOUCHER_COPY_REF
			WHERE 
				TO_PERIOD_ID = #t_period# AND
				FROM_PERIOD_ID = #f_period# AND
				IS_CHEQUE = 1
				AND FROM_CHEQUE_VOUCHER_ID IN(SELECT CHEQUE_ID FROM #db_out#.CHEQUE WHERE CHEQUE_STATUS_ID IN(1,2,5,6,10,12))
		</cfquery>
		<cfif control.recordcount eq 0>  --->
        <!--- cek donem acilisi disinda hareket olup olup olmadigi kontrol ediliyor  20140602 --->
        <cfquery name="get_cheque_process" datasource="#db_in#">
            SELECT 
                CH.PAYROLL_ID
            FROM 
                PAYROLL P,
                CHEQUE_HISTORY CH
            WHERE 
                P.ACTION_ID = CH.PAYROLL_ID
                AND P.PAYROLL_TYPE <> 106
                AND CH.CHEQUE_ID IN(SELECT TO_CHEQUE_VOUCHER_ID FROM #dsn_alias#.CHEQUE_VOUCHER_COPY_REF WHERE TO_PERIOD_ID = #t_period# AND IS_CHEQUE = 1)
            
            UNION ALL	
            
            SELECT 
                CH.PAYROLL_ID
            FROM 
                CHEQUE_HISTORY CH
            WHERE 
                CH.PAYROLL_ID IS NULL 
                AND CH.CHEQUE_ID IN(SELECT TO_CHEQUE_VOUCHER_ID FROM #dsn_alias#.CHEQUE_VOUCHER_COPY_REF WHERE TO_PERIOD_ID = #t_period# AND IS_CHEQUE = 1)
        </cfquery>
        <cfif get_cheque_process.recordcount eq 0>
            <!--- eger devir disinda herhangi bir hareket yoksa, ceklere ait islemler silinir --->
            <cfquery name="del_previous_transfer" datasource="#db_in#">
                DELETE FROM PAYROLL WHERE ACTION_ID IN (SELECT DISTINCT CHEQUE_PAYROLL_ID FROM CHEQUE WHERE CHEQUE_ID IN(SELECT TO_CHEQUE_VOUCHER_ID FROM #dsn_alias#.CHEQUE_VOUCHER_COPY_REF CHEQUE_VOUCHER_COPY_REF WHERE IS_CHEQUE = 1 AND TO_PERIOD_ID = #t_period#))
            
                DELETE FROM CHEQUE_HISTORY WHERE CHEQUE_ID IN (SELECT TO_CHEQUE_VOUCHER_ID FROM #dsn_alias#.CHEQUE_VOUCHER_COPY_REF CHEQUE_VOUCHER_COPY_REF WHERE IS_CHEQUE = 1 AND TO_PERIOD_ID = #t_period# )

                DELETE FROM CHEQUE WHERE CHEQUE_ID IN (SELECT TO_CHEQUE_VOUCHER_ID FROM #dsn_alias#.CHEQUE_VOUCHER_COPY_REF CHEQUE_VOUCHER_COPY_REF WHERE IS_CHEQUE = 1 AND TO_PERIOD_ID = #t_period# )

                DELETE FROM #dsn_alias#.CHEQUE_VOUCHER_COPY_REF WHERE IS_CHEQUE = 1 AND TO_PERIOD_ID = #t_period#

                DELETE FROM CARI_ROWS WHERE ACTION_TYPE_ID = 106 	
            </cfquery>
            <!--- odenmedi durumundaki cek listesinden eklenen cekler icin payroll ekleniyor--->
            <cfset cash_payroll_list_6 =''>
            <cfset chq_project_list =''>
            <cfquery name="get_cheque_6" dbtype="query">
                SELECT DISTINCT PROJECT_ID FROM get_cheques WHERE CHEQUE_STATUS_ID=6
            </cfquery>
            <cfif get_cheque_6.recordcount>
                <cfloop query="get_cheque_6">
                    <cfquery name="ADD_PAYROLL" datasource="#db_in#">
                        INSERT INTO PAYROLL 
                            (PAYROLL_NO,PAYROLL_TYPE,PROJECT_ID,PAYROLL_RECORD_DATE,RECORD_EMP,RECORD_IP,RECORD_DATE)
                            VALUES
                            ('-1',106,#get_cheque_6.project_id#,#islem_tarihi#,#session.ep.userid#,'#cgi.remote_addr#',#now()#)
                    </cfquery>
                    <cfquery name="get_payroll_default" datasource="#db_in#">
                        SELECT MAX(ACTION_ID) AS ACTION_ID FROM PAYROLL WHERE PAYROLL_TYPE = 106 AND PAYROLL_NO = '-1'
                    </cfquery>
                    <cfset chq_project_list=listappend(chq_project_list,get_cheque_6.project_id)>
                    <cfset cash_payroll_list_6=listappend(cash_payroll_list_6,get_payroll_default.ACTION_ID)>
                </cfloop>
            </cfif>
            <!--- //odenmedi durumundaki cek listesinden eklenen cekler icin --->
            <cfset temp_cash_id =''>
            <cfset cash_branch_id =''>
            <!--- portfoydeki ceklerin kasalarına gore payrollar ekleniyor. --->
            <cfif len(chq_cash_list)>
                <cfloop list="#chq_cash_list#" index="cash_index">
                    <cfquery name="get_cash_in" datasource="#db_in#">
                        SELECT CASH_ID,BRANCH_ID FROM CASH WHERE CASH_ID = #listgetat(cash_index,1,';')#
                    </cfquery>
                    <cfif get_cash_in.recordcount>
                        <cfset temp_cash_id = get_cash_in.CASH_ID>
                        <cfset cash_branch_id = get_cash_in.BRANCH_ID>
                    </cfif>
                    <cfquery name="ADD_PAYROLL_1" datasource="#db_in#">
                        INSERT INTO PAYROLL 
                            (PAYROLL_NO,PAYROLL_TYPE,PAYROLL_CASH_ID,PROJECT_ID,PAYROLL_RECORD_DATE,RECORD_EMP,RECORD_IP,RECORD_DATE)
                            VALUES
                            ('-1',106,<cfif len(temp_cash_id)>#temp_cash_id#<cfelse>NULL</cfif>,#listgetat(cash_index,2,';')#,#islem_tarihi#,#session.ep.userid#,'#cgi.remote_addr#',#now()#)
                    </cfquery>
                    <cfquery name="get_payroll_id" datasource="#db_in#">
                        SELECT MAX(ACTION_ID) AS ACTION_ID FROM PAYROLL WHERE PAYROLL_TYPE = 106 AND PAYROLL_NO = '-1'
                    </cfquery>
                    <cfset cash_payroll_list=listappend(cash_payroll_list,get_payroll_id.ACTION_ID)>
                </cfloop>
            </cfif>
            <!--- //portfoydeki ceklerin kasalarına gore payrollar ekleniyor. --->
            
            <!--- bankadaki ceklerin banka_hesaplarına gore payrollar ekleniyor. --->
            <cfif len(chq_account_list)>
                <cfloop list="#chq_account_list#" index="account_index">
                    <cfquery name="ADD_PAYROLL_2" datasource="#db_in#">
                        INSERT INTO PAYROLL 
                            (PAYROLL_NO,PAYROLL_TYPE,PAYROLL_ACCOUNT_ID,PROJECT_ID,PAYROLL_RECORD_DATE,RECORD_EMP,RECORD_IP,RECORD_DATE)
                            VALUES
                            ('-1',106,#listgetat(account_index,1,';')#,#listgetat(account_index,2,';')#,#islem_tarihi#,#session.ep.userid#,'#cgi.remote_addr#',#now()#)
                    </cfquery>
                    <cfquery name="get_payroll_id" datasource="#db_in#">
                        SELECT MAX(ACTION_ID) AS ACTION_ID FROM PAYROLL WHERE PAYROLL_TYPE = 106 AND PAYROLL_NO = '-1'
                    </cfquery>
                    <cfset account_payroll_list=listappend(account_payroll_list,get_payroll_id.ACTION_ID)>
                </cfloop>
            </cfif>
            <!--- bankadaki ceklerin banka_hesaplarına gore payrollar ekleniyor. --->
            <cfoutput query="get_cheques">
                <cfif len(PAYROLL_ACCOUNT_ID) and (CHEQUE_STATUS_ID eq 2 or CHEQUE_STATUS_ID eq 13 or CHEQUE_STATUS_ID eq 12)>
                    <cfset temp_payroll_id = listgetat(account_payroll_list,listfind(chq_account_list,"#PAYROLL_ACCOUNT_ID#;#PROJECT_ID#",','))>
                <cfelseif len(PAYROLL_CASH_ID) and (CHEQUE_STATUS_ID eq 1 or CHEQUE_STATUS_ID eq 10 or CHEQUE_STATUS_ID eq 12)>
                    <cfset temp_payroll_id = listgetat(cash_payroll_list,listfind(chq_cash_list,"#PAYROLL_CASH_ID#;#PROJECT_ID#",','))>
                <cfelseif CHEQUE_STATUS_ID eq 6>
                    <cfset temp_payroll_id = listgetat(cash_payroll_list_6,listfind(chq_project_list,"#PROJECT_ID#",','))>
                </cfif>	
                <cfquery name="add_cheque" datasource="#db_in#" result="MAX_ID">
                    INSERT INTO
                    CHEQUE
                    (
                        CHEQUE_CODE,
                        CHEQUE_DUEDATE,
                        CHEQUE_NO,
                        CHEQUE_VALUE,
                        OTHER_MONEY_VALUE,
                        OTHER_MONEY,
                        OTHER_MONEY_VALUE2,
                        OTHER_MONEY2,							
                        DEBTOR_NAME,
                        CHEQUE_STATUS_ID,
                        BANK_NAME,
                        BANK_BRANCH_NAME,
                        ACCOUNT_NO,
                        CHEQUE_CITY,
                        TAX_NO,
                        TAX_PLACE,
                        CHEQUE_PURSE_NO,
                        CURRENCY_ID,
                        SELF_CHEQUE,
                        CHEQUE_PAYROLL_ID,
                        ACCOUNT_ID,
                        COMPANY_ID,
                        CONSUMER_ID,
                        EMPLOYEE_ID,
                        OWNER_COMPANY_ID,
                        OWNER_CONSUMER_ID,
                        OWNER_EMPLOYEE_ID,
                        RESULT_ID,
                        RECORD_EMP,
                        RECORD_IP,
                        RECORD_DATE	,
                        CASH_ID,
                        CH_OTHER_MONEY_VALUE,
                        CH_OTHER_MONEY,
                        OLD_STATUS,
                        ENTRY_DATE
                    )
                    VALUES
                    (
                        <cfif len(CHEQUE_CODE)>'#CHEQUE_CODE#'<cfelse>NULL</cfif>,
                        #CreateODBCDateTime(CHEQUE_DUEDATE)#,
                        <cfif len(CHEQUE_NO)>'#CHEQUE_NO#'<cfelse>NULL</cfif>,
                        #CHEQUE_VALUE#,	
                        <cfif len(OTHER_MONEY_VALUE)>#OTHER_MONEY_VALUE#,<cfelse>NULL,</cfif>
                        <cfif len(OTHER_MONEY)>'#OTHER_MONEY#',<cfelse>NULL,</cfif>
                        <cfif len(OTHER_MONEY_VALUE2)>#OTHER_MONEY_VALUE2#,<cfelse>NULL,</cfif>
                        <cfif len(OTHER_MONEY2)>'#OTHER_MONEY2#',<cfelse>NULL,</cfif>												
                        <cfif len(DEBTOR_NAME)>'#DEBTOR_NAME#'<cfelse>NULL</cfif>,
                        #CHEQUE_STATUS_ID#,
                        <cfif len(BANK_NAME)>'#BANK_NAME#'<cfelse>NULL</cfif>,
                        <cfif len(BANK_BRANCH_NAME)>'#BANK_BRANCH_NAME#'<cfelse>NULL</cfif>,
                        <cfif len(ACCOUNT_NO)>'#ACCOUNT_NO#'<cfelse>NULL</cfif>,
                        <cfif len(CHEQUE_CITY)>'#CHEQUE_CITY#'<cfelse>NULL</cfif>,
                        <cfif len(TAX_NO)>'#TAX_NO#'<cfelse>NULL</cfif>,
                        <cfif len(TAX_PLACE)>'#TAX_PLACE#'<cfelse>NULL</cfif>,
                        <cfif len(CHEQUE_PURSE_NO)>'#CHEQUE_PURSE_NO#'<cfelse>NULL</cfif>,<!---PORTFOY NO--->
                        <cfif len(CURRENCY_ID)>'#CURRENCY_ID#'<cfelse>NULL</cfif>,
                        <cfif len(SELF_CHEQUE)>#SELF_CHEQUE#<cfelse>NULL</cfif>,
                        #temp_payroll_id#,
                        <cfif len(ACCOUNT_ID)>#ACCOUNT_ID#<cfelse>NULL</cfif>,
                        <cfif len(COMPANY_ID)>#COMPANY_ID#<cfelseif len(PAYROLL_COMP)>#PAYROLL_COMP#<cfelse>NULL</cfif>,
                        <cfif len(CONSUMER_ID)>#CONSUMER_ID#<cfelseif len(PAYROLL_CONS)>#PAYROLL_CONS#<cfelse>NULL</cfif>,
                        <cfif len(EMPLOYEE_ID)>#EMPLOYEE_ID#<cfelseif len(PAYROLL_EMP)>#PAYROLL_EMP#<cfelse>NULL</cfif>,
                        <cfif len(OWNER_COMPANY_ID)>#OWNER_COMPANY_ID#<cfelseif len(COMPANY_ID)>#COMPANY_ID#<cfelseif len(PAYROLL_COMP)>#PAYROLL_COMP#<cfelse>NULL</cfif>,
                        <cfif len(OWNER_CONSUMER_ID)>#OWNER_CONSUMER_ID#<cfelseif len(CONSUMER_ID)>#CONSUMER_ID#<cfelseif len(PAYROLL_CONS)>#PAYROLL_CONS#<cfelse>NULL</cfif>,
                        <cfif len(OWNER_EMPLOYEE_ID)>#OWNER_EMPLOYEE_ID#<cfelseif len(EMPLOYEE_ID)>#EMPLOYEE_ID#<cfelseif len(PAYROLL_EMP)>#PAYROLL_EMP#<cfelse>NULL</cfif>,
                        <cfif len(RESULT_ID)>#RESULT_ID#<cfelse>NULL</cfif>,
                        #session.ep.userid#,
                        '#cgi.remote_addr#',
                        #CreateODBCDateTime(RECORD_DATE)#,
                        <cfif len(cash_id)>#cash_id#<cfelse>NULL</cfif>,
                        <cfif len(CH_OTHER_MONEY_VALUE)>#CH_OTHER_MONEY_VALUE#<cfelse>NULL</cfif>,
                        <cfif len(CH_OTHER_MONEY)>'#CH_OTHER_MONEY#'<cfelse>NULL</cfif>,
                        <cfif len(OLD_STATUS_ID)>#OLD_STATUS_ID#<cfelse>NULL</cfif>,
                        <cfif len(ENTRY_DATE)>#CreateODBCDateTime(ENTRY_DATE)#<cfelse>NULL</cfif>
                    )
                </cfquery>
                <cfquery name="add_copy" datasource="#dsn#">
                    INSERT INTO
                        CHEQUE_VOUCHER_COPY_REF
                    (
                        PAYROLL_ID,
                        TO_CHEQUE_VOUCHER_ID,
                        FROM_CHEQUE_VOUCHER_ID,
                        TO_CMP_ID,
                        FROM_CMP_ID,
                        TO_PERIOD_ID,
                        FROM_PERIOD_ID,
                        IS_CHEQUE
                    )
                    VALUES
                    (
                        #temp_payroll_id#,
                        #MAX_ID.IDENTITYCOL#,
                        #CHEQUE_ID#,
                        #t_cmp#,
                        #f_cmp#,
                        #t_period#,
                        #f_period#,
                        1
                    )
                </cfquery>
                <cfquery name="ADD_CHEQUE_HISTORY" datasource="#db_in#">
                    INSERT INTO
                        CHEQUE_HISTORY
                    (
                        ACT_DATE,
                        CHEQUE_ID,
                        PAYROLL_ID,
                        STATUS,									
                        SELF_CHEQUE,
                        OTHER_MONEY_VALUE,
                        OTHER_MONEY,
                        OTHER_MONEY_VALUE2,
                        OTHER_MONEY2,		
                        RECORD_DATE
                    )
                    VALUES
                    (
                        #islem_tarihi#,
                        #MAX_ID.IDENTITYCOL#,
                        #temp_payroll_id#,
                        #CHEQUE_STATUS_ID#,									
                        <cfif len(SELF_CHEQUE)>
                        #SELF_CHEQUE#,
                        <cfelse>
                        NULL,
                        </cfif>
                        <cfif len(HIST_OTHER_MONEY_VALUE)>#HIST_OTHER_MONEY_VALUE#,<cfelse>NULL,</cfif>
                        <cfif len(HIST_OTHER_MONEY)>'#HIST_OTHER_MONEY#',<cfelse>NULL,</cfif>
                        <cfif len(HIST_OTHER_MONEY_VALUE2)>#HIST_OTHER_MONEY_VALUE2#,<cfelse>NULL,</cfif>
                        <cfif len(HIST_OTHER_MONEY2)>'#HIST_OTHER_MONEY2#',<cfelse>NULL,</cfif>	
                        #NOW()#
                    )
                </cfquery>
                <cfif isDefined("attributes.is_cheque_voucher_based_action")>
                    <cfif cheque_status_id eq 6>
                        <cfscript>
                            carici(
                                action_id : MAX_ID.IDENTITYCOL,
                                workcube_process_type : 106,		
                                process_cat : -1,
                                account_card_type :13,
                                action_table :'CHEQUE',
                                islem_tarihi : islem_tarihi,
                                islem_tutari : OTHER_MONEY_VALUE,
                                other_money_value : C_OTHER_MONEY_VALUE,
                                other_money : C_OTHER_MONEY,
                                islem_belge_no : CHEQUE_NO,
                                action_currency :session.ep.money,
                                to_cash_id : iif(len(temp_cash_id),temp_cash_id,de('')),
                                due_date : createodbcdatetime(CHEQUE_DUEDATE),
                                to_cmp_id : COMPANY_ID,
                                to_consumer_id : CONSUMER_ID,
                                to_employee_id : EMPLOYEE_ID,
                                cari_db : db_in,
                                payroll_id :temp_payroll_id,
                                islem_detay : 'ÇEK AÇILIŞ DEVİR',
                                to_branch_id : iif(len(cash_branch_id),cash_branch_id,de(''))
                                );
                        </cfscript>
                    <cfelse>
                        <cfscript>
                            carici(
                                action_id : MAX_ID.IDENTITYCOL,
                                workcube_process_type : 106,		
                                process_cat : -1,
                                account_card_type :13,
                                action_table :'CHEQUE',
                                islem_tarihi : islem_tarihi,
                                islem_tutari : OTHER_MONEY_VALUE,
                                other_money_value : C_OTHER_MONEY_VALUE,
                                other_money : C_OTHER_MONEY,
                                islem_belge_no : CHEQUE_NO,
                                action_currency :session.ep.money,
                                from_cash_id : iif(len(temp_cash_id),temp_cash_id,de('')),
                                due_date : createodbcdatetime(CHEQUE_DUEDATE),
                                from_cmp_id : OWNER_COMPANY_ID,
                                from_consumer_id : OWNER_CONSUMER_ID,
                                from_employee_id : OWNER_EMPLOYEE_ID,
                                cari_db : db_in,
                                payroll_id :temp_payroll_id,
                                islem_detay : 'ÇEK AÇILIŞ DEVİR',
                                from_branch_id : iif(len(cash_branch_id),cash_branch_id,de(''))
                                );
                        </cfscript>
                    </cfif>
                </cfif>
            </cfoutput>
            <cfquery name="GET_" datasource="#db_in#">
                SELECT 
                    sysobjects.NAME TABLE_NAME,
                    syscolumns.NAME COLUM_NAME
                FROM 
                    syscolumns,
                    sysobjects
                WHERE
                    sysobjects.id=syscolumns.id AND
                    syscolumns.xusertype IN (231,99,35,167)	AND 
                    sysobjects.xtype='U' AND sysobjects.name<>'dtproperties' AND SUBSTRING(sysobjects.name,1,1) <> '_'
                    AND sysobjects.NAME IN('CARI_ROWS','CHEQUE','CHEQUE_HISTORY')
                ORDER BY
                    sysobjects.NAME
            </cfquery> 
            <cfoutput query="GET_">
                <cfquery name="GET1" datasource="#db_in#">
                    SELECT #COLUM_NAME# FROM #TABLE_NAME# WHERE  #COLUM_NAME# = 'YTL'
                </cfquery>
                <cfif GET1.RECORDCOUNT>
                    <cfquery name="upd_" datasource="#db_in#">
                        UPDATE #TABLE_NAME#  SET #COLUM_NAME# = 'TL' WHERE #COLUM_NAME# = 'YTL'
                    </cfquery>
                </cfif>
            </cfoutput>
            <script type="text/javascript">
                alert("<cf_get_lang no ='2522.Çek Aktarımı Tamamlandı'>!");
                history.back();
            </script>
        <cfelse>
            <script type="text/javascript">
                alert("Aktarım Yapılan Dönemde Çeklere Ait İşlemler Bulunmaktadır. Aktarım Yapılamaz. Lütfen Hareketi Olan Çek İşlemlerini Siliniz!");
                history.back();
            </script>
            <cfabort>	
        </cfif>
        <!--- <cfelse>
            <script type="text/javascript">
                alert("<cf_get_lang no ='2523.İlgili Dönemler Arasında Daha Önceden Çek Aktarımı Yapılmıştır'> !");
                history.back();
            </script>
            <cfabort>
        </cfif> --->
	<cfelse>
		<script type="text/javascript">
			alert("<cf_get_lang no ='2524.Aktaracak Çek Yok'> !");
			history.back();
		</script>
		<cfabort>
	</cfif>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang no ='2525.Aktarım Yapamazsınız'> !");
		history.back();
	</script>
	<cfabort>
</cfif>
