<!--- Önceki dönemde toplu ödenecek senet girişiyle girilmiş senetlerin kasası boş olarak kaydedilip,
 bordrosuna kasa kaydedildiği için, ödenmedi durumunda olan senetlerin aktarımına kontrol konuldu. SK20160129 --->
<cfsetting enablecfoutputonly="yes">
<cfflush interval="100">

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
<cfset f_pyear = DB_CONTROL_OUT.PERIOD_YEAR>	<!--- senetleri aktarılacak şirketin period yılı --->
<cfset f_cmp = DB_CONTROL_OUT.OUR_COMPANY_ID>	<!--- senetleri aktarılacak şirket id --->
<cfset f_period = DB_CONTROL_OUT.PERIOD_ID>	<!--- senetleri aktarılacak şirketin periodu--->
<cfset t_pyear = DB_CONTROL_IN.PERIOD_YEAR>	<!--- senetlerin aktarılacağı şirketin period yılı --->
<cfset t_cmp = DB_CONTROL_IN.OUR_COMPANY_ID>		<!--- senetlerin aktarılacağı şirket id --->
<cfset t_period = DB_CONTROL_IN.PERIOD_ID>	<!--- senetlerin aktarılacağı şirketin periodu --->
<cfset islem_tarihi = CreateDateTime(t_pyear,1,1,0,0,0)>
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


<font color="FF0000">Cari Aktarım İşlemi Gerçekleştiriliyor. Lütfen Sayfayı Yenilemeyin  !!</font><br/><br/>
<cfif DB_CONTROL_OUT.recordcount and DB_CONTROL_IN.recordcount>
	<cfquery name="get_vouchers" datasource="#db_out#">
		SELECT	
			P.COMPANY_ID AS PAYROLL_COMP,
			P.CONSUMER_ID AS PAYROLL_CONS,
			P.EMPLOYEE_ID AS PAYROLL_EMP,
			CASE WHEN P2.TRANSFER_CASH_ID IS NOT NULL THEN P2.TRANSFER_CASH_ID ELSE P2.PAYROLL_CASH_ID END AS PAYROLL_CASH_ID,
			P2.PAYROLL_ACCOUNT_ID,
			ISNULL(P.PROJECT_ID,0) PROJECT_ID,
			V.*,
			VH.OTHER_MONEY_VALUE AS HIST_OTHER_MONEY_VALUE,
			VH.OTHER_MONEY AS HIST_OTHER_MONEY,
			VH.OTHER_MONEY_VALUE2 AS HIST_OTHER_MONEY_VALUE2,
			VH.OTHER_MONEY2 AS HIST_OTHER_MONEY2,
			ISNULL((SELECT TOP 1 CHH.STATUS FROM VOUCHER_HISTORY CHH WHERE CHH.VOUCHER_ID = V.VOUCHER_ID AND CHH.HISTORY_ID =(SELECT MAX(CH_.HISTORY_ID) FROM VOUCHER_HISTORY CH_ WHERE CH_.VOUCHER_ID=V.VOUCHER_ID AND CH_.HISTORY_ID <> VH.HISTORY_ID)),V.OLD_STATUS) OLD_STATUS_ID
		<cfif isDefined("attributes.is_cheque_voucher_based_action")>
			,V.OTHER_MONEY_VALUE/(VOUCHER_PAYROLL_MONEY.RATE2/VOUCHER_PAYROLL_MONEY.RATE1) V_OTHER_MONEY_VALUE
			,P.PAYROLL_OTHER_MONEY V_OTHER_MONEY
		</cfif>
		FROM
			VOUCHER V,
			VOUCHER_HISTORY VH,
			VOUCHER_PAYROLL P,
			VOUCHER_PAYROLL P2	
			<cfif isDefined("attributes.is_cheque_voucher_based_action")>,VOUCHER_PAYROLL_MONEY</cfif>
		WHERE
			V.VOUCHER_ID = VH.VOUCHER_ID AND
			VH.HISTORY_ID = (SELECT MAX(HISTORY_ID) FROM VOUCHER_HISTORY WHERE VOUCHER_ID=V.VOUCHER_ID)
			AND VH.PAYROLL_ID = P2.ACTION_ID
			AND P.ACTION_ID = V.VOUCHER_PAYROLL_ID
		<cfif isDefined("attributes.is_cheque_voucher_based_action")>
			AND P.PAYROLL_OTHER_MONEY = VOUCHER_PAYROLL_MONEY.MONEY_TYPE 
			AND	P.ACTION_ID = VOUCHER_PAYROLL_MONEY.ACTION_ID
		</cfif>
			AND (V.VOUCHER_STATUS_ID IN (2,13,6,10) OR (V.VOUCHER_STATUS_ID = 1 AND P.PAYMETHOD_ID IS NULL))
		UNION ALL
		SELECT	
			P.COMPANY_ID AS PAYROLL_COMP,
			P.CONSUMER_ID AS PAYROLL_CONS,
			P.EMPLOYEE_ID AS PAYROLL_EMP,
			'' PAYROLL_CASH_ID,
			'' PAYROLL_ACCOUNT_ID,
			ISNULL(P.PROJECT_ID,0) PROJECT_ID,
			V.*,
			VH.OTHER_MONEY_VALUE AS HIST_OTHER_MONEY_VALUE,
			VH.OTHER_MONEY AS HIST_OTHER_MONEY,
			VH.OTHER_MONEY_VALUE2 AS HIST_OTHER_MONEY_VALUE2,
			VH.OTHER_MONEY2 AS HIST_OTHER_MONEY2,
			ISNULL((SELECT TOP 1 CHH.STATUS FROM VOUCHER_HISTORY CHH WHERE CHH.VOUCHER_ID = V.VOUCHER_ID AND CHH.HISTORY_ID =(SELECT MAX(CH_.HISTORY_ID) FROM VOUCHER_HISTORY CH_ WHERE CH_.VOUCHER_ID=V.VOUCHER_ID AND CH_.HISTORY_ID <> VH.HISTORY_ID)),V.OLD_STATUS) OLD_STATUS_ID
		<cfif isDefined("attributes.is_cheque_voucher_based_action")>
			,V.OTHER_MONEY_VALUE/(VOUCHER_PAYROLL_MONEY.RATE2/VOUCHER_PAYROLL_MONEY.RATE1) V_OTHER_MONEY_VALUE
			,P.PAYROLL_OTHER_MONEY V_OTHER_MONEY
		</cfif>
		FROM
			VOUCHER V,
			VOUCHER_HISTORY VH,
			VOUCHER_PAYROLL P
			<cfif isDefined("attributes.is_cheque_voucher_based_action")>,VOUCHER_PAYROLL_MONEY</cfif>
		WHERE
			V.VOUCHER_ID = VH.VOUCHER_ID AND
			VH.HISTORY_ID = (SELECT MAX(HISTORY_ID) FROM VOUCHER_HISTORY WHERE VOUCHER_ID=V.VOUCHER_ID)
			AND P.ACTION_ID = V.VOUCHER_PAYROLL_ID
			<cfif isDefined("attributes.is_cheque_voucher_based_action")>
				AND P.PAYROLL_OTHER_MONEY = VOUCHER_PAYROLL_MONEY.MONEY_TYPE 
				AND	P.ACTION_ID = VOUCHER_PAYROLL_MONEY.ACTION_ID
			</cfif>
			AND V.VOUCHER_STATUS_ID = 5
		UNION ALL
		SELECT	
			P.COMPANY_ID AS PAYROLL_COMP,
			P.CONSUMER_ID AS PAYROLL_CONS,
			P.EMPLOYEE_ID AS PAYROLL_EMP,
			P.PAYROLL_CASH_ID,
			P.PAYROLL_ACCOUNT_ID,
			ISNULL(P.PROJECT_ID,0) PROJECT_ID,
			V.*,
			VH.OTHER_MONEY_VALUE AS HIST_OTHER_MONEY_VALUE,
			VH.OTHER_MONEY AS HIST_OTHER_MONEY,
			VH.OTHER_MONEY_VALUE2 AS HIST_OTHER_MONEY_VALUE2,
			VH.OTHER_MONEY2 AS HIST_OTHER_MONEY2,
			ISNULL((SELECT TOP 1 CHH.STATUS FROM VOUCHER_HISTORY CHH WHERE CHH.VOUCHER_ID = V.VOUCHER_ID AND CHH.HISTORY_ID =(SELECT MAX(CH_.HISTORY_ID) FROM VOUCHER_HISTORY CH_ WHERE CH_.VOUCHER_ID=V.VOUCHER_ID AND CH_.HISTORY_ID <> VH.HISTORY_ID)),V.OLD_STATUS) OLD_STATUS_ID
		<cfif isDefined("attributes.is_cheque_voucher_based_action")>
			,V.OTHER_MONEY_VALUE/(VOUCHER_PAYROLL_MONEY.RATE2/VOUCHER_PAYROLL_MONEY.RATE1) V_OTHER_MONEY_VALUE
			,P.PAYROLL_OTHER_MONEY V_OTHER_MONEY
		</cfif>
		FROM
			VOUCHER V,
			VOUCHER_HISTORY VH,
			VOUCHER_PAYROLL P
			<cfif isDefined("attributes.is_cheque_voucher_based_action")>,VOUCHER_PAYROLL_MONEY</cfif>
		WHERE
			V.VOUCHER_ID = VH.VOUCHER_ID AND
			VH.HISTORY_ID = (SELECT MAX(HISTORY_ID) FROM VOUCHER_HISTORY WHERE VOUCHER_ID=V.VOUCHER_ID)
			AND P.ACTION_ID = V.VOUCHER_PAYROLL_ID
			<cfif isDefined("attributes.is_cheque_voucher_based_action")>
				AND P.PAYROLL_OTHER_MONEY = VOUCHER_PAYROLL_MONEY.MONEY_TYPE 
				AND	P.ACTION_ID = VOUCHER_PAYROLL_MONEY.ACTION_ID
			</cfif>
			AND V.VOUCHER_STATUS_ID = 12
		<cfif isDefined("attributes.is_cheque_voucher_based_action")><!--- eğer carileşme yapılıyorsa payrol_money kayıtları olmayanlar için cari rows tan baktık --->
			UNION ALL
			SELECT	
				P.COMPANY_ID AS PAYROLL_COMP,
				P.CONSUMER_ID AS PAYROLL_CONS,
				P.EMPLOYEE_ID AS PAYROLL_EMP,
				P2.PAYROLL_CASH_ID,
				P2.PAYROLL_ACCOUNT_ID,
				ISNULL(P.PROJECT_ID,0) PROJECT_ID,
				V.*,
				VH.OTHER_MONEY_VALUE AS HIST_OTHER_MONEY_VALUE,
				VH.OTHER_MONEY AS HIST_OTHER_MONEY,
				VH.OTHER_MONEY_VALUE2 AS HIST_OTHER_MONEY_VALUE2,
				VH.OTHER_MONEY2 AS HIST_OTHER_MONEY2,
				ISNULL((SELECT TOP 1 CHH.STATUS FROM VOUCHER_HISTORY CHH WHERE CHH.VOUCHER_ID = V.VOUCHER_ID AND CHH.HISTORY_ID =(SELECT MAX(CH_.HISTORY_ID) FROM VOUCHER_HISTORY CH_ WHERE CH_.VOUCHER_ID=V.VOUCHER_ID AND CH_.HISTORY_ID <> VH.HISTORY_ID)),V.OLD_STATUS) OLD_STATUS_ID,
				CR.OTHER_CASH_ACT_VALUE  V_OTHER_MONEY_VALUE,
				CR.OTHER_MONEY V_OTHER_MONEY
			FROM
				VOUCHER V,
				VOUCHER_HISTORY VH,
				VOUCHER_PAYROLL P,
				VOUCHER_PAYROLL P2,
				CARI_ROWS CR
			WHERE
				V.VOUCHER_ID = VH.VOUCHER_ID AND
				VH.HISTORY_ID = (SELECT MAX(HISTORY_ID) FROM VOUCHER_HISTORY WHERE VOUCHER_ID=V.VOUCHER_ID)
				AND VH.PAYROLL_ID = P2.ACTION_ID
				AND P.ACTION_ID = V.VOUCHER_PAYROLL_ID
				AND (V.VOUCHER_STATUS_ID IN (2,13,6,10) OR (V.VOUCHER_STATUS_ID = 1 AND P.PAYMETHOD_ID IS NULL))
				AND V.VOUCHER_ID = CR.ACTION_ID
				AND CR.ACTION_TYPE_ID = 107
				AND V.VOUCHER_PAYROLL_ID NOT IN(SELECT VPM.ACTION_ID FROM VOUCHER_PAYROLL_MONEY VPM)
			UNION ALL
			SELECT	
				P.COMPANY_ID AS PAYROLL_COMP,
				P.CONSUMER_ID AS PAYROLL_CONS,
				P.EMPLOYEE_ID AS PAYROLL_EMP,
				'' PAYROLL_CASH_ID,
				'' PAYROLL_ACCOUNT_ID,
				ISNULL(P.PROJECT_ID,0) PROJECT_ID,
				V.*,
				VH.OTHER_MONEY_VALUE AS HIST_OTHER_MONEY_VALUE,
				VH.OTHER_MONEY AS HIST_OTHER_MONEY,
				VH.OTHER_MONEY_VALUE2 AS HIST_OTHER_MONEY_VALUE2,
				VH.OTHER_MONEY2 AS HIST_OTHER_MONEY2,
				ISNULL((SELECT TOP 1 CHH.STATUS FROM VOUCHER_HISTORY CHH WHERE CHH.VOUCHER_ID = V.VOUCHER_ID AND CHH.HISTORY_ID =(SELECT MAX(CH_.HISTORY_ID) FROM VOUCHER_HISTORY CH_ WHERE CH_.VOUCHER_ID=V.VOUCHER_ID AND CH_.HISTORY_ID <> VH.HISTORY_ID)),V.OLD_STATUS) OLD_STATUS_ID,
				CR.OTHER_CASH_ACT_VALUE  V_OTHER_MONEY_VALUE,
				CR.OTHER_MONEY V_OTHER_MONEY
			FROM
				VOUCHER V,
				VOUCHER_HISTORY VH,
				VOUCHER_PAYROLL P,
				CARI_ROWS CR
			WHERE
				V.VOUCHER_ID = VH.VOUCHER_ID AND
				VH.HISTORY_ID = (SELECT MAX(HISTORY_ID) FROM VOUCHER_HISTORY WHERE VOUCHER_ID=V.VOUCHER_ID)
				AND P.ACTION_ID = V.VOUCHER_PAYROLL_ID
				AND V.VOUCHER_ID = CR.ACTION_ID
				AND CR.ACTION_TYPE_ID = 107
				AND V.VOUCHER_PAYROLL_ID NOT IN(SELECT VPM.ACTION_ID FROM VOUCHER_PAYROLL_MONEY VPM)
				AND V.VOUCHER_STATUS_ID = 5
			UNION ALL
			SELECT	
				P.COMPANY_ID AS PAYROLL_COMP,
				P.CONSUMER_ID AS PAYROLL_CONS,
				P.EMPLOYEE_ID AS PAYROLL_EMP,
				P.PAYROLL_CASH_ID,
				P.PAYROLL_ACCOUNT_ID,
				ISNULL(P.PROJECT_ID,0) PROJECT_ID,
				V.*,
				VH.OTHER_MONEY_VALUE AS HIST_OTHER_MONEY_VALUE,
				VH.OTHER_MONEY AS HIST_OTHER_MONEY,
				VH.OTHER_MONEY_VALUE2 AS HIST_OTHER_MONEY_VALUE2,
				VH.OTHER_MONEY2 AS HIST_OTHER_MONEY2,
				ISNULL((SELECT TOP 1 CHH.STATUS FROM VOUCHER_HISTORY CHH WHERE CHH.VOUCHER_ID = V.VOUCHER_ID AND CHH.HISTORY_ID =(SELECT MAX(CH_.HISTORY_ID) FROM VOUCHER_HISTORY CH_ WHERE CH_.VOUCHER_ID=V.VOUCHER_ID AND CH_.HISTORY_ID <> VH.HISTORY_ID)),V.OLD_STATUS) OLD_STATUS_ID,
				CR.OTHER_CASH_ACT_VALUE  V_OTHER_MONEY_VALUE,
				CR.OTHER_MONEY V_OTHER_MONEY
			FROM
				VOUCHER V,
				VOUCHER_HISTORY VH,
				VOUCHER_PAYROLL P,
				CARI_ROWS CR
			WHERE
				V.VOUCHER_ID = VH.VOUCHER_ID AND
				VH.HISTORY_ID = (SELECT MAX(HISTORY_ID) FROM VOUCHER_HISTORY WHERE VOUCHER_ID=V.VOUCHER_ID)
				AND P.ACTION_ID = V.VOUCHER_PAYROLL_ID
				AND V.VOUCHER_ID = CR.ACTION_ID
				AND CR.ACTION_TYPE_ID = 107
				AND V.VOUCHER_PAYROLL_ID NOT IN(SELECT VPM.ACTION_ID FROM VOUCHER_PAYROLL_MONEY VPM)
				AND V.VOUCHER_STATUS_ID = 12
		</cfif>
	</cfquery>	
	<cfquery name="get_vouchers_payroll_2" datasource="#db_out#">
		SELECT DISTINCT
			V.VOUCHER_PAYROLL_ID,
			P.PAYROLL_CASH_ID
		FROM
			VOUCHER V,
			VOUCHER_PAYROLL P
		WHERE
			P.ACTION_ID = V.VOUCHER_PAYROLL_ID
			AND (V.VOUCHER_STATUS_ID = 11 OR (V.VOUCHER_STATUS_ID = 1 AND P.PAYMETHOD_ID IS NOT NULL))
	</cfquery>
	<cfscript>
		cash_payroll_list='';
		account_payroll_list='';
		chq_cash_list='';
		chq_account_list='';
	</cfscript>
	<cfoutput query="get_vouchers">
		<cfif len(project_id)>
			<cfif len(get_vouchers.PAYROLL_CASH_ID)>
				<cfset chq_cash_list=listappend(chq_cash_list,"#get_vouchers.PAYROLL_CASH_ID#;#get_vouchers.project_id#")>
			</cfif>
			<cfif len(get_vouchers.PAYROLL_ACCOUNT_ID)>
				<cfset chq_account_list=listappend(chq_account_list,"#get_vouchers.PAYROLL_ACCOUNT_ID#;#get_vouchers.project_id#")>
			</cfif>
		<cfelse>
			<cfif len(get_vouchers.PAYROLL_CASH_ID)>
				<cfset chq_cash_list=listappend(chq_cash_list,"#get_vouchers.PAYROLL_CASH_ID#;0")>
			</cfif>
			<cfif len(get_vouchers.PAYROLL_ACCOUNT_ID)>
				<cfset chq_account_list=listappend(chq_account_list,"#get_vouchers.PAYROLL_ACCOUNT_ID#;0")>
			</cfif>
		</cfif>
	</cfoutput>
	<!--- Kasa aktarımları kontrol ediliyor --->
	<cfif len(chq_cash_list)>
		<cfloop list="#chq_cash_list#" index="cash_index">
			<cfif listfirst(cash_index,';') neq 0>
				<cfquery name="get_cash_in" datasource="#db_in#">
					SELECT CASH_ID,BRANCH_ID FROM CASH WHERE CASH_ID = #listfirst(cash_index,';')#
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
	<cfset voucher_count_ = 0>
	<cfif get_vouchers.recordcount or get_vouchers_payroll_2.recordcount>
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
				IS_CHEQUE = 0
				AND FROM_CHEQUE_VOUCHER_ID IN(SELECT VOUCHER_ID FROM #db_out#.VOUCHER WHERE VOUCHER_STATUS_ID IN(1,2,5,6,10,12,11))
		</cfquery>
		<cfif control.recordcount eq 0> --->
        <!--- senet donem acilisi disinda hareket olup olup olmadigi kontrol ediliyor  20140602 --->
        <cfquery name="get_voucher_process" datasource="#db_in#">
            SELECT 
                CH.PAYROLL_ID
            FROM 
                VOUCHER_PAYROLL P,
                VOUCHER_HISTORY CH
            WHERE 
                P.ACTION_ID = CH.PAYROLL_ID
                AND P.PAYROLL_TYPE <> 107
                AND CH.VOUCHER_ID IN(SELECT TO_CHEQUE_VOUCHER_ID FROM #dsn_alias#.CHEQUE_VOUCHER_COPY_REF WHERE TO_PERIOD_ID = #t_period# AND IS_CHEQUE = 0)
            
            UNION ALL	
            
            SELECT 
                CH.PAYROLL_ID
            FROM 
                VOUCHER_HISTORY CH
            WHERE 
                CH.PAYROLL_ID IS NULL 
                AND CH.VOUCHER_ID IN(SELECT TO_CHEQUE_VOUCHER_ID FROM #dsn_alias#.CHEQUE_VOUCHER_COPY_REF WHERE TO_PERIOD_ID = #t_period# AND IS_CHEQUE = 0)
        </cfquery>
        <cfif get_voucher_process.recordcount eq 0>
        	<!--- eger devir disinda herhangi bir hareket yoksa, ceklere ait islemler silinir --->
            <cfquery name="del_previous_transfer" datasource="#db_in#">
                DELETE FROM VOUCHER_PAYROLL WHERE ACTION_ID IN (SELECT DISTINCT VOUCHER_PAYROLL_ID FROM VOUCHER WHERE VOUCHER_ID IN (SELECT TO_CHEQUE_VOUCHER_ID FROM #dsn_alias#.CHEQUE_VOUCHER_COPY_REF CHEQUE_VOUCHER_COPY_REF WHERE IS_CHEQUE = 0 AND TO_PERIOD_ID = #t_period# ))
	
				DELETE FROM VOUCHER_HISTORY WHERE VOUCHER_ID IN (SELECT TO_CHEQUE_VOUCHER_ID FROM #dsn_alias#.CHEQUE_VOUCHER_COPY_REF WHERE IS_CHEQUE = 0 AND TO_PERIOD_ID = #t_period# )
	
				DELETE FROM VOUCHER WHERE VOUCHER_ID IN (SELECT TO_CHEQUE_VOUCHER_ID FROM #dsn_alias#.CHEQUE_VOUCHER_COPY_REF WHERE IS_CHEQUE = 0 AND TO_PERIOD_ID = #t_period# )
	
				DELETE FROM #dsn_alias#.CHEQUE_VOUCHER_COPY_REF WHERE IS_CHEQUE = 0 AND TO_PERIOD_ID = #t_period#
	
				DELETE FROM CARI_ROWS WHERE ACTION_TYPE_ID = 107	
            </cfquery>
			<!--- odenmedi durumundaki senet listesinden eklenen senet icin payroll ekleniyor--->
			<cfset cash_payroll_list_6 =''>
			<cfset chq_project_list =''>
			<cfquery name="get_cheque_6" dbtype="query">
				SELECT * FROM get_vouchers WHERE VOUCHER_STATUS_ID=6 OR VOUCHER_STATUS_ID=5
			</cfquery>
			<cfif get_cheque_6.recordcount>
				<cfloop query="get_cheque_6">
					<cfquery name="ADD_PAYROLL" datasource="#db_in#">
						INSERT INTO VOUCHER_PAYROLL 
							(PAYROLL_NO,PAYROLL_TYPE,PROJECT_ID,PAYROLL_RECORD_DATE,RECORD_EMP,RECORD_IP,RECORD_DATE)
							VALUES
							('-1',107,#get_cheque_6.project_id#,#islem_tarihi#,#session.ep.userid#,'#cgi.remote_addr#',#now()#)
					</cfquery>
					<cfquery name="get_payroll_default" datasource="#db_in#">
						SELECT MAX(ACTION_ID) AS ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_TYPE = 107 AND PAYROLL_NO = '-1'
					</cfquery>
					<cfset chq_project_list=listappend(chq_project_list,get_cheque_6.project_id)>
					<cfset cash_payroll_list_6=listappend(cash_payroll_list_6,get_payroll_default.ACTION_ID)>
				</cfloop>
			</cfif>
			<!--- //odenmedi durumundaki senet listesinden eklenen senet icin --->
		
			<!--- portfoydeki senetlerin kasalarına gore payrollar ekleniyor. --->
			<cfif len(chq_cash_list)>
				<cfloop list="#chq_cash_list#" index="cash_index">
					 <cfquery name="get_cash_in" datasource="#db_in#">
						SELECT CASH_ID,BRANCH_ID FROM CASH WHERE CASH_ID = #listgetat(cash_index,1,';')#
					</cfquery>
					<cfif get_cash_in.recordcount>
						<cfset temp_cash_id = get_cash_in.CASH_ID>
						<cfset cash_branch_id = get_cash_in.BRANCH_ID>
					<cfelse>
						<cfset temp_cash_id =''>
						<cfset cash_branch_id = ''>
					</cfif>
					<cfquery name="ADD_PAYROLL_1" datasource="#db_in#">
						INSERT INTO VOUCHER_PAYROLL 
							(PAYROLL_NO,PAYROLL_TYPE,PAYROLL_CASH_ID,PROJECT_ID,PAYROLL_RECORD_DATE,RECORD_EMP,RECORD_IP,RECORD_DATE)
							VALUES
							('-1',107,<cfif len(temp_cash_id)>#temp_cash_id#<cfelse>NULL</cfif>,#listgetat(cash_index,2,';')#,#islem_tarihi#,#session.ep.userid#,'#cgi.remote_addr#',#now()#)
					</cfquery>
					<cfquery name="get_payroll_id" datasource="#db_in#">
						SELECT MAX(ACTION_ID) AS ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_TYPE = 107 AND PAYROLL_NO = '-1'
					</cfquery>
					<cfset cash_payroll_list=listappend(cash_payroll_list,get_payroll_id.ACTION_ID)>
				</cfloop>
			</cfif>
			<!--- //portfoydeki senetlerin kasalarına gore payrollar ekleniyor. --->
		
			<!--- bankadaki senetlerin banka_hesaplarına gore payrollar ekleniyor. --->
			<cfif len(chq_account_list)>
				<cfloop list="#chq_account_list#" index="account_index">
					<cfquery name="ADD_PAYROLL_2" datasource="#db_in#">
						INSERT INTO VOUCHER_PAYROLL 
							(PAYROLL_NO,PAYROLL_TYPE,PAYROLL_ACCOUNT_ID,PROJECT_ID,PAYROLL_RECORD_DATE,RECORD_EMP,RECORD_IP,RECORD_DATE)
							VALUES
							('-1',107,#listgetat(account_index,1,';')#,#listgetat(account_index,2,';')#,#islem_tarihi#,#session.ep.userid#,'#cgi.remote_addr#',#now()#)
					</cfquery>
					<cfquery name="get_payroll_id" datasource="#db_in#">
						SELECT MAX(ACTION_ID) AS ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_TYPE = 107 AND PAYROLL_NO = '-1'
					</cfquery>
					<cfset account_payroll_list=listappend(account_payroll_list,get_payroll_id.ACTION_ID)>
				</cfloop>
			</cfif>
			<!--- bankadaki senetlerin banka_hesaplarına gore payrollar ekleniyor. --->
		
			<cfoutput query="get_vouchers">
				<cfset voucher_count_ = voucher_count_ + 1>
				<!---#voucher_count_# - #get_vouchers.VOUCHER_NO# No'lu Senet Aktarımı Tamamlandı.<br/>--->
				<cfif len(PAYROLL_ACCOUNT_ID) and (VOUCHER_STATUS_ID eq 2 or VOUCHER_STATUS_ID eq 13)>
					<cfset temp_payroll_id = listgetat(account_payroll_list,listfind(chq_account_list,"#PAYROLL_ACCOUNT_ID#;#PROJECT_ID#",','))>
				<cfelseif len(PAYROLL_CASH_ID) and (VOUCHER_STATUS_ID eq 1 or VOUCHER_STATUS_ID eq 10 or VOUCHER_STATUS_ID eq 11 or VOUCHER_STATUS_ID eq 12)>
					<cfset temp_payroll_id = listgetat(cash_payroll_list,listfind(chq_cash_list,"#PAYROLL_CASH_ID#;#PROJECT_ID#",','))>
				<cfelseif VOUCHER_STATUS_ID eq 6 or VOUCHER_STATUS_ID eq 5>
					<cfset temp_payroll_id = listgetat(cash_payroll_list_6,listfind(chq_project_list,"#PROJECT_ID#",','))>
				</cfif>
	
				<cfquery name="ADD_VOUCHER" datasource="#db_in#">
					INSERT INTO
					VOUCHER
					(
						VOUCHER_CODE,
						VOUCHER_DUEDATE,
						VOUCHER_NO,
						VOUCHER_VALUE,
						OTHER_MONEY_VALUE,
						OTHER_MONEY,
						OTHER_MONEY_VALUE2,
						OTHER_MONEY2,							
						DEBTOR_NAME,
						VOUCHER_STATUS_ID,
						ACCOUNT_NO,
						VOUCHER_CITY,
						VOUCHER_PURSE_NO,
						CURRENCY_ID,
						SELF_VOUCHER,
						VOUCHER_PAYROLL_ID,
						COMPANY_ID,
						CONSUMER_ID,
						EMPLOYEE_ID,
						OWNER_COMPANY_ID,
						OWNER_CONSUMER_ID,
						OWNER_EMPLOYEE_ID,
						DELAY_INTEREST_SYSTEM_VALUE,
						DELAY_INTEREST_OTHER_VALUE,
						DELAY_INTEREST_VALUE2,
						EARLY_PAYMENT_SYSTEM_VALUE,
						EARLY_PAYMENT_OTHER_VALUE,
						EARLY_PAYMENT_VALUE2,
						RECORD_EMP,
						RECORD_IP,
						RECORD_DATE,
						CASH_ID	,
						CH_OTHER_MONEY_VALUE,
						CH_OTHER_MONEY,
						IS_PAY_TERM	,
						OLD_STATUS,
						ENTRY_DATE	
					)
					VALUES
					(
						<cfif len(VOUCHER_CODE)>'#VOUCHER_CODE#'<cfelse>NULL</cfif>,
						#CreateODBCDateTime(VOUCHER_DUEDATE)#,
						<cfif len(VOUCHER_NO)>'#VOUCHER_NO#'<cfelse>NULL</cfif>,
						#VOUCHER_VALUE#,	
						<cfif len(OTHER_MONEY_VALUE)>#OTHER_MONEY_VALUE#,<cfelse>NULL,</cfif>
						<cfif len(OTHER_MONEY)>'#OTHER_MONEY#',<cfelse>NULL,</cfif>
						<cfif len(OTHER_MONEY_VALUE2)>#OTHER_MONEY_VALUE2#,<cfelse>NULL,</cfif>
						<cfif len(OTHER_MONEY2)>'#OTHER_MONEY2#',<cfelse>NULL,</cfif>												
						<cfif len(DEBTOR_NAME)>'#DEBTOR_NAME#'<cfelse>NULL</cfif>,
						#VOUCHER_STATUS_ID#,
						<cfif len(ACCOUNT_NO)>'#ACCOUNT_NO#'<cfelse>NULL</cfif>,
						<cfif len(VOUCHER_CITY)>'#VOUCHER_CITY#'<cfelse>NULL</cfif>,
						<cfif len(VOUCHER_PURSE_NO)>'#VOUCHER_PURSE_NO#'<cfelse>NULL</cfif>,<!---PORTFOY NO--->
						<cfif len(CURRENCY_ID)>'#CURRENCY_ID#'<cfelse>NULL</cfif>,
						<cfif len(SELF_VOUCHER)>#SELF_VOUCHER#<cfelse>NULL</cfif>,
						#temp_payroll_id#,
						<cfif len(COMPANY_ID)>#COMPANY_ID#<cfelseif len(PAYROLL_COMP)>#PAYROLL_COMP#<cfelse>NULL</cfif>,
						<cfif len(CONSUMER_ID)>#CONSUMER_ID#<cfelseif len(PAYROLL_CONS)>#PAYROLL_CONS#<cfelse>NULL</cfif>,
						<cfif len(EMPLOYEE_ID)>#EMPLOYEE_ID#<cfelseif len(PAYROLL_EMP)>#PAYROLL_EMP#<cfelse>NULL</cfif>,
						<cfif len(OWNER_COMPANY_ID)>#OWNER_COMPANY_ID#<cfelseif len(COMPANY_ID)>#COMPANY_ID#<cfelseif len(PAYROLL_COMP)>#PAYROLL_COMP#<cfelse>NULL</cfif>,
						<cfif len(OWNER_CONSUMER_ID)>#OWNER_CONSUMER_ID#<cfelseif len(CONSUMER_ID)>#CONSUMER_ID#<cfelseif len(PAYROLL_CONS)>#PAYROLL_CONS#<cfelse>NULL</cfif>,
						<cfif len(OWNER_EMPLOYEE_ID)>#OWNER_EMPLOYEE_ID#<cfelseif len(EMPLOYEE_ID)>#EMPLOYEE_ID#<cfelseif len(PAYROLL_EMP)>#PAYROLL_EMP#<cfelse>NULL</cfif>,
						<cfif len(DELAY_INTEREST_SYSTEM_VALUE)>#DELAY_INTEREST_SYSTEM_VALUE#<cfelse>NULL</cfif>,
						<cfif len(DELAY_INTEREST_OTHER_VALUE)>#DELAY_INTEREST_OTHER_VALUE#<cfelse>NULL</cfif>,
						<cfif len(DELAY_INTEREST_VALUE2)>#DELAY_INTEREST_VALUE2#<cfelse>NULL</cfif>,
						<cfif len(EARLY_PAYMENT_SYSTEM_VALUE)>#EARLY_PAYMENT_SYSTEM_VALUE#<cfelse>NULL</cfif>,
						<cfif len(EARLY_PAYMENT_OTHER_VALUE)>#EARLY_PAYMENT_OTHER_VALUE#<cfelse>NULL</cfif>,
						<cfif len(EARLY_PAYMENT_VALUE2)>#EARLY_PAYMENT_VALUE2#<cfelse>NULL</cfif>,
						#session.ep.userid#,
						'#cgi.remote_addr#',
						#CreateODBCDateTime(RECORD_DATE)#,
                        <cfif voucher_status_id eq 6>
                        	<cfif len(cash_id)>#cash_id#<cfelseif len(payroll_cash_id)>#payroll_cash_id#<cfelse>NULL</cfif>
                        <cfelse>
                        	<cfif len(cash_id)>#cash_id#<cfelse>NULL</cfif>
                        </cfif>,
						<cfif len(CH_OTHER_MONEY_VALUE)>#CH_OTHER_MONEY_VALUE#<cfelse>NULL</cfif>,
						<cfif len(CH_OTHER_MONEY)>'#CH_OTHER_MONEY#'<cfelse>NULL</cfif>,
						<cfif len(IS_PAY_TERM)>#IS_PAY_TERM#<cfelse>NULL</cfif>,
						<cfif len(OLD_STATUS_ID)>#OLD_STATUS_ID#<cfelse>NULL</cfif>,
						<cfif len(ENTRY_DATE)>#CreateODBCDateTime(ENTRY_DATE)#<cfelse>NULL</cfif>
					)
				</cfquery>
				<cfquery name="get_max_id" datasource="#db_in#">
					SELECT MAX(VOUCHER_ID) AS MAX_ID FROM VOUCHER
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
						#get_max_id.MAX_ID#,
						#VOUCHER_ID#,
						#t_cmp#,
						#f_cmp#,
						#t_period#,
						#f_period#,
						0
					)
				</cfquery>
				<cfquery name="ADD_VOUCHER_HISTORY" datasource="#db_in#">
					INSERT INTO
						VOUCHER_HISTORY
							(
								ACT_DATE,
								VOUCHER_ID,
								PAYROLL_ID,
								STATUS,									
								SELF_VOUCHER,
								OTHER_MONEY_VALUE,
								OTHER_MONEY,
								OTHER_MONEY_VALUE2,
								OTHER_MONEY2,			
								RECORD_DATE
							)
						VALUES
							(
								#islem_tarihi#,
								#get_max_id.MAX_ID#,
								#temp_payroll_id#,
								#VOUCHER_STATUS_ID#,									
								<cfif len(SELF_VOUCHER)>
								#SELF_VOUCHER#,
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
				<cfif VOUCHER_STATUS_ID eq 6>
					<cfscript>
						carici(
							action_id : get_max_id.MAX_ID,
							workcube_process_type : 107,		
							process_cat : -1,
							account_card_type :13,
							action_table :'VOUCHER',
							islem_tarihi : islem_tarihi,
							islem_tutari : OTHER_MONEY_VALUE,
							other_money_value : V_OTHER_MONEY_VALUE,
							other_money : V_OTHER_MONEY,
							islem_belge_no : VOUCHER_NO,
							action_currency :session.ep.money,
							to_cash_id : iif((isdefined("temp_cash_id") and len(temp_cash_id)),temp_cash_id,de('')),
							due_date : createodbcdatetime(VOUCHER_DUEDATE),
							to_cmp_id : COMPANY_ID,
							to_consumer_id : CONSUMER_ID,
							to_employee_id : EMPLOYEE_ID,
							cari_db : db_in,
							payroll_id :temp_payroll_id,
							islem_detay : 'SENET AÇILIŞ DEVİR',
							to_branch_id : iif((isdefined("cash_branch_id") and len(cash_branch_id)),cash_branch_id,de(''))
							);
					</cfscript>
				<cfelse>
					<cfscript>
						carici(
							action_id : get_max_id.MAX_ID,
							workcube_process_type : 107,		
							process_cat : -1,
							account_card_type :13,
							action_table :'VOUCHER',
							islem_tarihi : islem_tarihi,
							islem_tutari : OTHER_MONEY_VALUE,
							other_money_value : V_OTHER_MONEY_VALUE,
							other_money : V_OTHER_MONEY,
							islem_belge_no : VOUCHER_NO,
							action_currency :session.ep.money,
							from_cash_id : iif((isdefined("temp_cash_id") and len(temp_cash_id)),temp_cash_id,de('')),
							due_date : createodbcdatetime(VOUCHER_DUEDATE),
							from_cmp_id : COMPANY_ID,
							from_consumer_id : CONSUMER_ID,
							from_employee_id : EMPLOYEE_ID,
							cari_db : db_in,
							payroll_id :temp_payroll_id,
							islem_detay : 'SENET AÇILIŞ DEVİR',
							from_branch_id : iif((isdefined("cash_branch_id") and len(cash_branch_id)),cash_branch_id,de(''))
							);
					</cfscript>
				</cfif>
			</cfif>
		</cfoutput>
			<cfoutput query="get_vouchers_payroll_2">
                 <cfquery name="get_cash_in" datasource="#db_in#">
                    SELECT CASH_ID,BRANCH_ID FROM CASH WHERE CASH_ID = #get_vouchers_payroll_2.PAYROLL_CASH_ID#
                </cfquery>
                <cfif get_cash_in.recordcount>
                    <cfset temp_cash_id = get_cash_in.CASH_ID>
                    <cfset cash_branch_id = get_cash_in.BRANCH_ID>
                </cfif>
                 <cfquery name="ADD_PAYROLL" datasource="#db_in#">
                     INSERT INTO
                        VOUCHER_PAYROLL
                        (
                            PROCESS_CAT,
                            PAYROLL_TYPE,
                            COMPANY_ID,
                            CONSUMER_ID,
                            PAYROLL_TOTAL_VALUE,
                            PAYROLL_OTHER_MONEY,
                            PAYROLL_OTHER_MONEY_VALUE, 
                            NUMBER_OF_VOUCHER,
                            CURRENCY_ID,
                            PAYROLL_REVENUE_DATE,
                            PAYROLL_NO,
                            VOUCHER_BASED_ACC_CARI,
                            PAYMENT_ORDER_ID,
                            PAYROLL_CASH_ID,
                            CASH_PAYMENT_VALUE,
                            PAYMETHOD_ID,
                            PAYROLL_AVG_DUEDATE,
                            RECORD_EMP,
                            RECORD_IP,
                            RECORD_DATE
                        )
                        SELECT
                            0,
                            107,
                            COMPANY_ID,
                            CONSUMER_ID,
                            PAYROLL_TOTAL_VALUE,
                            PAYROLL_OTHER_MONEY,
                            PAYROLL_OTHER_MONEY_VALUE, 
                            NUMBER_OF_VOUCHER,
                            CURRENCY_ID,
                            #islem_tarihi#,
                            -1,
                            VOUCHER_BASED_ACC_CARI,
                            PAYMENT_ORDER_ID,
                            #temp_cash_id#,
                            CASH_PAYMENT_VALUE,
                            PAYMETHOD_ID,
                            #islem_tarihi#,
                            #session.ep.userid#,
                            '#cgi.remote_addr#',
                            #now()#
                        FROM
                            #db_out#.VOUCHER_PAYROLL
                        WHERE
                            ACTION_ID = #get_vouchers_payroll_2.VOUCHER_PAYROLL_ID#
                 </cfquery>
                 <cfquery name="get_max_p" datasource="#db_in#">
                    SELECT MAX(ACTION_ID) AS MAX_PAYROLL_ID FROM VOUCHER_PAYROLL
                 </cfquery>
                <cfquery name="get_p_vouchers" datasource="#db_out#">
                    SELECT
                        V.* 
                    FROM
                        VOUCHER V
                            LEFT JOIN VOUCHER_PAYROLL VP ON VP.ACTION_ID = V.VOUCHER_PAYROLL_ID
                    WHERE
                        V.VOUCHER_PAYROLL_ID = #get_vouchers_payroll_2.VOUCHER_PAYROLL_ID#
                        AND (V.VOUCHER_STATUS_ID = 11 OR ( V.VOUCHER_STATUS_ID = 1 AND VP.PAYMETHOD_ID IS NOT NULL ))
                </cfquery>
                <cfloop query="get_p_vouchers">
                    <cfset voucher_count_ =voucher_count_+1>
                  <!---  #voucher_count_# - #get_p_vouchers.VOUCHER_NO# No'lu Senet Aktarımı Tamamlandı.<br/>--->
                    <cfquery name="ADD_VOUCHER" datasource="#db_in#">
                        INSERT INTO
                        VOUCHER
                        (
                            VOUCHER_CODE,
                            VOUCHER_DUEDATE,
                            VOUCHER_NO,
                            VOUCHER_VALUE,
                            OTHER_MONEY_VALUE,
                            OTHER_MONEY,
                            OTHER_MONEY_VALUE2,
                            OTHER_MONEY2,							
                            DEBTOR_NAME,
                            VOUCHER_STATUS_ID,
                            ACCOUNT_NO,
                            VOUCHER_CITY,
                            VOUCHER_PURSE_NO,
                            CURRENCY_ID,
                            SELF_VOUCHER,
                            VOUCHER_PAYROLL_ID,
                            COMPANY_ID,
                            CONSUMER_ID,
                            EMPLOYEE_ID,
                            DELAY_INTEREST_SYSTEM_VALUE,
                            DELAY_INTEREST_OTHER_VALUE,
                            DELAY_INTEREST_VALUE2,
                            EARLY_PAYMENT_SYSTEM_VALUE,
                            EARLY_PAYMENT_OTHER_VALUE,
                            EARLY_PAYMENT_VALUE2,
                            RECORD_EMP,
                            RECORD_IP,
                            RECORD_DATE,
                            CASH_ID,
                            CH_OTHER_MONEY_VALUE,
                            CH_OTHER_MONEY,
                            IS_PAY_TERM				
                        )
                        VALUES
                        (
                            <cfif len(VOUCHER_CODE)>'#get_p_vouchers.VOUCHER_CODE#'<cfelse>NULL</cfif>,
                            #CreateODBCDateTime(get_p_vouchers.VOUCHER_DUEDATE)#,
                            <cfif len(VOUCHER_NO)>'#get_p_vouchers.VOUCHER_NO#'<cfelse>NULL</cfif>,
                            #get_p_vouchers.VOUCHER_VALUE#,	
                            <cfif len(get_p_vouchers.OTHER_MONEY_VALUE)>#get_p_vouchers.OTHER_MONEY_VALUE#,<cfelse>NULL,</cfif>
                            <cfif len(get_p_vouchers.OTHER_MONEY)>'#get_p_vouchers.OTHER_MONEY#',<cfelse>NULL,</cfif>
                            <cfif len(get_p_vouchers.OTHER_MONEY_VALUE2)>#get_p_vouchers.OTHER_MONEY_VALUE2#,<cfelse>NULL,</cfif>
                            <cfif len(get_p_vouchers.OTHER_MONEY2)>'#get_p_vouchers.OTHER_MONEY2#',<cfelse>NULL,</cfif>												
                            <cfif len(get_p_vouchers.DEBTOR_NAME)>'#get_p_vouchers.DEBTOR_NAME#'<cfelse>NULL</cfif>,
                            #get_p_vouchers.VOUCHER_STATUS_ID#,
                            <cfif len(get_p_vouchers.ACCOUNT_NO)>'#get_p_vouchers.ACCOUNT_NO#'<cfelse>NULL</cfif>,
                            <cfif len(get_p_vouchers.VOUCHER_CITY)>'#get_p_vouchers.VOUCHER_CITY#'<cfelse>NULL</cfif>,
                            <cfif len(get_p_vouchers.VOUCHER_PURSE_NO)>'#get_p_vouchers.VOUCHER_PURSE_NO#'<cfelse>NULL</cfif>,
                            <cfif len(get_p_vouchers.CURRENCY_ID)>'#get_p_vouchers.CURRENCY_ID#'<cfelse>NULL</cfif>,
                            <cfif len(get_p_vouchers.SELF_VOUCHER)>#get_p_vouchers.SELF_VOUCHER#<cfelse>NULL</cfif>,
                            #get_max_p.MAX_PAYROLL_ID#,
                            <cfif len(get_p_vouchers.COMPANY_ID)>#get_p_vouchers.COMPANY_ID#<cfelse>NULL</cfif>,
                            <cfif len(get_p_vouchers.CONSUMER_ID)>#get_p_vouchers.CONSUMER_ID#<cfelse>NULL</cfif>,
                            <cfif len(get_p_vouchers.EMPLOYEE_ID)>#get_p_vouchers.EMPLOYEE_ID#<cfelse>NULL</cfif>,
                            <cfif len(get_p_vouchers.DELAY_INTEREST_SYSTEM_VALUE)>#get_p_vouchers.DELAY_INTEREST_SYSTEM_VALUE#<cfelse>NULL</cfif>,
                            <cfif len(get_p_vouchers.DELAY_INTEREST_OTHER_VALUE)>#get_p_vouchers.DELAY_INTEREST_OTHER_VALUE#<cfelse>NULL</cfif>,
                            <cfif len(get_p_vouchers.DELAY_INTEREST_VALUE2)>#get_p_vouchers.DELAY_INTEREST_VALUE2#<cfelse>NULL</cfif>,
                            <cfif len(get_p_vouchers.EARLY_PAYMENT_SYSTEM_VALUE)>#get_p_vouchers.EARLY_PAYMENT_SYSTEM_VALUE#<cfelse>NULL</cfif>,
                            <cfif len(get_p_vouchers.EARLY_PAYMENT_OTHER_VALUE)>#get_p_vouchers.EARLY_PAYMENT_OTHER_VALUE#<cfelse>NULL</cfif>,
                            <cfif len(get_p_vouchers.EARLY_PAYMENT_VALUE2)>#get_p_vouchers.EARLY_PAYMENT_VALUE2#<cfelse>NULL</cfif>,
                            #session.ep.userid#,
                            '#cgi.remote_addr#',
                            #CreateODBCDateTime(RECORD_DATE)#,
                            <cfif len(temp_cash_id)>#temp_cash_id#<cfelse>NULL</cfif>,
                            <cfif len(CH_OTHER_MONEY_VALUE)>#CH_OTHER_MONEY_VALUE#<cfelse>NULL</cfif>,
                            <cfif len(CH_OTHER_MONEY)>'#CH_OTHER_MONEY#'<cfelse>NULL</cfif>,
                            <cfif len(IS_PAY_TERM)>#IS_PAY_TERM#<cfelse>NULL</cfif>
                        )
                    </cfquery>
                    <cfquery name="get_max_id" datasource="#db_in#">
                        SELECT MAX(VOUCHER_ID) AS MAX_ID FROM VOUCHER
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
                            #get_max_p.MAX_PAYROLL_ID#,
                            #get_max_id.MAX_ID#,
                            #VOUCHER_ID#,
                            #t_cmp#,
                            #f_cmp#,
                            #t_period#,
                            #f_period#,
                            0
                        )
                    </cfquery>
                    <cfquery name="ADD_VOUCHER_HISTORY" datasource="#db_in#">
                        INSERT INTO
                            VOUCHER_HISTORY
                                (
                                    ACT_DATE,
                                    VOUCHER_ID,
                                    PAYROLL_ID,
                                    STATUS,									
                                    SELF_VOUCHER,
                                    OTHER_MONEY_VALUE,
                                    OTHER_MONEY,
                                    OTHER_MONEY_VALUE2,
                                    OTHER_MONEY2,			
                                    RECORD_DATE
                                )
                            VALUES
                                (
                                    #islem_tarihi#,
                                    #get_max_id.MAX_ID#,
                                    #get_max_p.MAX_PAYROLL_ID#,
                                    #get_p_vouchers.VOUCHER_STATUS_ID#,									
                                    <cfif len(get_p_vouchers.SELF_VOUCHER)>
                                    #get_p_vouchers.SELF_VOUCHER#,
                                    <cfelse>
                                    NULL,
                                    </cfif>
                                    <cfif len(get_p_vouchers.OTHER_MONEY_VALUE)>#get_p_vouchers.OTHER_MONEY_VALUE#,<cfelse>NULL,</cfif>
                                    <cfif len(get_p_vouchers.OTHER_MONEY)>'#get_p_vouchers.OTHER_MONEY#',<cfelse>NULL,</cfif>
                                    <cfif len(get_p_vouchers.OTHER_MONEY_VALUE2)>#get_p_vouchers.OTHER_MONEY_VALUE2#,<cfelse>NULL,</cfif>
                                    <cfif len(get_p_vouchers.OTHER_MONEY2)>'#get_p_vouchers.OTHER_MONEY2#',<cfelse>NULL,</cfif>	
                                    #NOW()#
                                )
                    </cfquery>
                    <cfif isDefined("attributes.is_cheque_voucher_based_action")>
                        <cfscript>
                            carici(
                                action_id : get_max_id.MAX_ID,
                                workcube_process_type : 107,		
                                process_cat : -1,
                                account_card_type :13,
                                action_table :'VOUCHER',
                                islem_tarihi : islem_tarihi,
                                islem_tutari : get_p_vouchers.OTHER_MONEY_VALUE,
                                other_money_value : get_p_vouchers.OTHER_MONEY_VALUE,
                                other_money : get_p_vouchers.OTHER_MONEY,
                                islem_belge_no : get_p_vouchers.VOUCHER_NO,
                                action_currency :session.ep.money,
                                from_cash_id : iif((isdefined("temp_cash_id") and len(temp_cash_id)),temp_cash_id,de('')),
                                due_date : createodbcdatetime(get_p_vouchers.VOUCHER_DUEDATE),
                                from_cmp_id : get_p_vouchers.COMPANY_ID,
                                from_consumer_id : get_p_vouchers.CONSUMER_ID,
                                from_employee_id : get_p_vouchers.EMPLOYEE_ID,
                                cari_db : db_in,
                                islem_detay : 'SENET AÇILIŞ DEVİR',
                                from_branch_id : iif((isdefined("cash_branch_id") and len(cash_branch_id)),cash_branch_id,de(''))
                                );
                        </cfscript>
                    </cfif>
                    <cfquery name="get_cari_id" datasource="#db_in#">
                        SELECT CARI_ACTION_ID,ACTION_TYPE_ID,FROM_CMP_ID,FROM_CONSUMER_ID FROM CARI_ROWS WHERE ACTION_ID = #get_max_id.MAX_ID# AND ACTION_TYPE_ID = 107
                    </cfquery>
                    <cfquery name="get_closed" datasource="#db_out#">
                        SELECT * FROM VOUCHER_CLOSED WHERE ACTION_ID = #VOUCHER_ID#
                    </cfquery>
                    <cfquery name="get_guarantors" datasource="#db_out#">
                        SELECT * FROM VOUCHER_GUARANTORS WHERE VOUCHER_ID = #VOUCHER_ID#
                    </cfquery>
                    <cfif get_closed.recordcount>
                        <cfloop query="get_closed">
                            <cfquery name="add_voucher_close" datasource="#db_in#">
                                INSERT INTO
                                    VOUCHER_CLOSED
                                (
                                    PAYROLL_ID,
                                    CARI_ACTION_ID,
                                    ACTION_ID,
                                    ACTION_TYPE_ID,
                                    ACTION_VALUE,
                                    CLOSED_AMOUNT,
                                    OTHER_CLOSED_AMOUNT,
                                    OTHER_MONEY,
                                    IS_VOUCHER_DELAY
                                )
                                VALUES
                                (
                                    #get_max_p.MAX_PAYROLL_ID#,
                                    <cfif get_cari_id.recordcount>#get_cari_id.cari_action_id#,<cfelse>NULL,</cfif>
                                    #get_max_id.MAX_ID#,
                                    <cfif get_cari_id.recordcount>#get_cari_id.action_type_id#,<cfelse>NULL,</cfif>
                                    #get_closed.ACTION_VALUE#,
                                    #get_closed.CLOSED_AMOUNT#,
                                    #get_closed.OTHER_CLOSED_AMOUNT#,
                                    '#get_closed.OTHER_MONEY#',
                                    <cfif len(get_closed.IS_VOUCHER_DELAY)>#get_closed.IS_VOUCHER_DELAY#<cfelse>NULL</cfif>
                                )
                            </cfquery>
                        </cfloop>
                    </cfif>
                    <cfif get_guarantors.recordcount>
                        <cfloop query="get_guarantors">
                            <cfquery name="add_voucher_gua" datasource="#db_in#">
                                INSERT INTO
                                    VOUCHER_GUARANTORS
                                (
                                    VOUCHER_ID,
                                    CONSUMER_ID,
                                    AMOUNT,
                                    AMOUNT2
                                )
                                VALUES
                                (
                                    #get_max_id.MAX_ID#,
                                    #get_guarantors.CONSUMER_ID#,
                                    #get_guarantors.AMOUNT#,
                                    #get_guarantors.AMOUNT2#
                                )
                            </cfquery>
                        </cfloop>
                    </cfif>
                </cfloop>
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
                    AND sysobjects.NAME IN('CARI_ROWS','VOUCHER','VOUCHER_HISTORY','VOUCHER_CLOSED')
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
             
        <!--- <cfelse>
            <cf_get_lang no ='2553.İlgili Dönemler Arasında Daha Önceden Senet Aktarımı Yapılmıştır'>
            <cfabort>
        </cfif> --->
        <cfelse>
            <script type="text/javascript">
                alert("Aktarım Yapılan Dönemde Senetlere Ait İşlemler Bulunmaktadır. Aktarım Yapılamaz. Lütfen Hareketi Olan Senet İşlemlerini Siliniz!");
                history.back();
            </script>
            <cfabort>	
        </cfif>
	<cfelse>
        <script type="text/javascript">
			alert("<cf_get_lang no ='2552.Aktarılacak Senet Yok'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang no ='2525.Aktarım Yapamazsınız'>!");
		history.back();
	</script>
    <cfabort>
</cfif>
<script type="text/javascript">
	alert("<cf_get_lang no ='2532.Senet Aktarımı Tamamlandı'>!");
	history.back();
</script>
<cfabort>
