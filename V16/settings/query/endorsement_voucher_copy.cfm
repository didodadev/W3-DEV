
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
<cfif DB_CONTROL_OUT.recordcount and DB_CONTROL_IN.recordcount>
<cfset f_pyear = DB_CONTROL_OUT.PERIOD_YEAR>	<!--- senetleri aktarılacak şirketin period yılı --->
<cfset f_cmp = DB_CONTROL_OUT.OUR_COMPANY_ID>	<!--- senetleri aktarılacak şirket id --->
<cfset f_period = DB_CONTROL_OUT.PERIOD_ID>	<!--- senetleri aktarılacak şirketin periodu--->
<cfset t_pyear = DB_CONTROL_IN.PERIOD_YEAR>	<!--- senetlerin aktarılacağı şirketin period yılı --->
<cfset t_cmp = DB_CONTROL_IN.OUR_COMPANY_ID>		<!--- senetlerin aktarılacağı şirket id --->
<cfset t_period =  DB_CONTROL_IN.PERIOD_ID>	<!--- senetlerin aktarılacağı şirketin periodu --->
<cfset islem_tarihi = CreateDateTime(t_pyear,1,1,0,0,0)>
<!--- tablo gelen veriye göre belirlenir --->
<cfset db_out = '#DSN#_#f_pyear#_#f_cmp#'> 
<cfset db_in = '#DSN#_#t_pyear#_#t_cmp#'>
<cf_date tarih = "attributes.due_date">
	<cfquery name="get_vouchers" datasource="#db_out#">
		SELECT	
			VP.COMPANY_ID AS PAYROLL_COMP,
			VP.CONSUMER_ID AS PAYROLL_CONS,
			VP.EMPLOYEE_ID AS PAYROLL_EMP,
			VP.PAYROLL_CASH_ID,
			VP2.PAYROLL_ACCOUNT_ID,
			V.*
		<cfif isDefined("attributes.is_cheque_based_action")>
			,V.OTHER_MONEY_VALUE/(VOUCHER_PAYROLL_MONEY.RATE2/VOUCHER_PAYROLL_MONEY.RATE1) V_OTHER_MONEY_VALUE
			,VP.PAYROLL_OTHER_MONEY V_OTHER_MONEY
		</cfif>
		FROM
			VOUCHER V,
			VOUCHER_HISTORY VH,
			VOUCHER_PAYROLL VP,
			VOUCHER_PAYROLL VP2	
		<cfif isDefined("attributes.is_cheque_based_action")>,VOUCHER_PAYROLL_MONEY</cfif>
		WHERE
			V.VOUCHER_ID = VH.VOUCHER_ID
			AND VH.HISTORY_ID =(SELECT TOP 1 HISTORY_ID FROM VOUCHER_HISTORY WHERE VOUCHER_ID=V.VOUCHER_ID ORDER BY VOUCHER_HISTORY.ACT_DATE DESC, VOUCHER_HISTORY.HISTORY_ID DESC)
			AND VH.PAYROLL_ID = VP2.ACTION_ID
			AND VP.ACTION_ID = V.VOUCHER_PAYROLL_ID
			AND V.VOUCHER_STATUS_ID = 4 <!--- ciro edilmis  ---> 
			AND V.VOUCHER_DUEDATE > #attributes.due_date#
		<cfif isDefined("attributes.is_cheque_based_action")>
			AND VP.PAYROLL_OTHER_MONEY = VOUCHER_PAYROLL_MONEY.MONEY_TYPE 
			AND	VP.ACTION_ID = VOUCHER_PAYROLL_MONEY.ACTION_ID
		</cfif>
		<cfif isDefined("attributes.is_cheque_voucher_based_action")><!--- eğer carileşme yapılıyorsa payrol_money kayıtları olmayanlar için cari rows tan baktık --->
			UNION ALL
			SELECT	
				VP.COMPANY_ID AS PAYROLL_COMP,
				VP.CONSUMER_ID AS PAYROLL_CONS,
				VP.EMPLOYEE_ID AS PAYROLL_EMP,
				VP.PAYROLL_CASH_ID,
				VP2.PAYROLL_ACCOUNT_ID,
				V.*,
				CR.OTHER_CASH_ACT_VALUE  V_OTHER_MONEY_VALUE,
				CR.OTHER_MONEY V_OTHER_MONEY
			FROM
				VOUCHER V,
				VOUCHER_HISTORY VH,
				VOUCHER_PAYROLL VP,
				VOUCHER_PAYROLL VP2	,
				CARI_ROWS CR
			WHERE
				V.VOUCHER_ID = VH.VOUCHER_ID
				AND VH.HISTORY_ID =(SELECT TOP 1 HISTORY_ID FROM VOUCHER_HISTORY WHERE VOUCHER_ID=V.VOUCHER_ID ORDER BY VOUCHER_HISTORY.ACT_DATE DESC, VOUCHER_HISTORY.HISTORY_ID DESC)
				AND VH.PAYROLL_ID = VP2.ACTION_ID
				AND VP.ACTION_ID = V.VOUCHER_PAYROLL_ID
				AND V.VOUCHER_STATUS_ID = 4 <!--- ciro edilmis  ---> 
				AND V.VOUCHER_DUEDATE > #attributes.due_date#
				AND V.VOUCHER_ID = CR.ACTION_ID
				AND CR.ACTION_TYPE_ID = 107
				AND V.VOUCHER_PAYROLL_ID NOT IN(SELECT VPM.ACTION_ID FROM VOUCHER_PAYROLL_MONEY VPM)
		</cfif>
	</cfquery>

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

	<cfscript>
		chq_cash_list=listsort(ListDeleteDuplicates(valuelist(get_vouchers.PAYROLL_CASH_ID,',')),"numeric","asc",",");
		chq_account_list=listsort(ListDeleteDuplicates(valuelist(get_vouchers.PAYROLL_ACCOUNT_ID,',')),"numeric","asc",",");
		cash_payroll_list='';
		account_payroll_list='';
		temp_cash_id ='';
		cash_branch_id ='';
	</cfscript>
	<!--- Kasa aktarımları kontrol ediliyor --->
	<cfif len(chq_cash_list)>
		<cfloop list="#chq_cash_list#" index="cash_index">
			<cfquery name="get_cash_in" datasource="#db_in#">
				SELECT CASH_ID,BRANCH_ID FROM CASH WHERE CASH_ID = #cash_index#
			</cfquery>
			<cfif len(cash_index) and cash_index neq 0 and get_cash_in.recordcount eq 0>
				<script type="text/javascript">
					alert("Kasa Aktarımlarınız Eksik Yapıldığı İçin Aktarım Yapamazsınız !");
					history.back();
				</script>
				<cfabort>
			</cfif>
		</cfloop>
	</cfif>
	 <cfif get_vouchers.recordcount>
	 	<cfquery name="control" datasource="#dsn#">
			SELECT
				TO_CHEQUE_VOUCHER_ID
			FROM
				CHEQUE_VOUCHER_COPY_REF
			WHERE 
				TO_PERIOD_ID = #t_period# AND
				FROM_PERIOD_ID = #f_period# AND
				IS_CHEQUE = 0
				AND FROM_CHEQUE_VOUCHER_ID IN(SELECT VOUCHER_ID FROM #db_out#.VOUCHER WHERE VOUCHER_STATUS_ID = 4)
		</cfquery>
		<cfif control.recordcount eq 0>
			<!--- kasa ve banka bilgileri bos olan ciro cekler icin--->
			<cfquery name="get_payroll_default" datasource="#db_in#">
				SELECT MAX(ACTION_ID) AS ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_TYPE = 107 AND PAYROLL_NO = '-1' AND PAYROLL_CASH_ID IS NULL AND PAYROLL_ACCOUNT_ID IS NULL
			</cfquery>
			<cfif not get_payroll_default.recordcount or not len(get_payroll_default.action_id)>
				<cfquery name="ADD_PAYROLL" datasource="#db_in#">
					INSERT INTO VOUCHER_PAYROLL 
						(PAYROLL_NO,PAYROLL_TYPE,PAYROLL_RECORD_DATE,RECORD_EMP,RECORD_IP,RECORD_DATE)
						VALUES
						('-1',107,#now()#,#session.ep.userid#,'#cgi.remote_addr#',#now()#)
				</cfquery>
				<cfquery name="get_payroll_default" datasource="#db_in#">
					SELECT MAX(ACTION_ID) AS ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_TYPE = 107 AND PAYROLL_NO = '-1'
				</cfquery>
			</cfif>
			<!--- // kasa ve banka bilgileri olmayan ciro cekler icin --->
	
			<!--- ciro edilmis ceklerin kasalarına gore payrollar ekleniyor. --->
			<cfif len(chq_cash_list)>
				<cfloop list="#chq_cash_list#" index="cash_index">
					<cfquery name="get_cash_in" datasource="#db_in#">
						SELECT CASH_ID,BRANCH_ID FROM CASH WHERE CASH_ID = #cash_index#
					</cfquery>
					<cfif get_cash_in.recordcount>
						<cfset temp_cash_id = get_cash_in.CASH_ID>
						<cfset cash_branch_id = get_cash_in.BRANCH_ID>
					</cfif>
					<cfquery name="get_payroll_id" datasource="#db_in#"><!--- daha once bu kasa icin kaydedilmis acılıs bordrosu varsa o kullanılıyor --->
						SELECT ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_TYPE = 107 AND PAYROLL_NO = '-1' AND PAYROLL_CASH_ID=#temp_cash_id#
					</cfquery>
					<cfif not get_payroll_id.recordcount>
						<cfquery name="ADD_PAYROLL_1" datasource="#db_in#">
							INSERT INTO VOUCHER_PAYROLL 
								(PAYROLL_NO,PAYROLL_TYPE,PAYROLL_CASH_ID,PAYROLL_RECORD_DATE,RECORD_EMP,RECORD_IP,RECORD_DATE)
								VALUES
								('-1',107,#temp_cash_id#,#now()#,#session.ep.userid#,'#cgi.remote_addr#',#now()#)
						</cfquery>
						<cfquery name="get_payroll_id" datasource="#db_in#">
							SELECT MAX(ACTION_ID) AS ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_TYPE = 107 AND PAYROLL_NO = '-1'
						</cfquery>
					</cfif>
					<cfset cash_payroll_list=listappend(cash_payroll_list,get_payroll_id.ACTION_ID)>
				</cfloop>
			</cfif>
			<!--- //ciro edilmis ceklerin kasalarına gore payrollar ekleniyor. --->
			
			<!--- ciro ceklerin banka_hesaplarına gore payrollar ekleniyor. --->
			<cfif len(chq_account_list)>
				<cfloop list="#chq_account_list#" index="account_index">
					<cfquery name="get_payroll_id" datasource="#db_in#"><!--- daha once bu banka  icin kaydedilmis acılıs bordrosu varsa o kullanılıyor --->
						SELECT ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_TYPE = 107 AND PAYROLL_NO = '-1' AND PAYROLL_ACCOUNT_ID=#account_index#
					</cfquery>
					<cfif not get_payroll_id.recordcount>
						<cfquery name="ADD_PAYROLL_2" datasource="#db_in#">
							INSERT INTO VOUCHER_PAYROLL 
								(PAYROLL_NO,PAYROLL_TYPE,PAYROLL_ACCOUNT_ID,PAYROLL_RECORD_DATE,RECORD_EMP,RECORD_IP,RECORD_DATE)
								VALUES
								('-1',107,#account_index#,#now()#,#session.ep.userid#,'#cgi.remote_addr#',#now()#)
						</cfquery>
						<cfquery name="get_payroll_id" datasource="#db_in#">
							SELECT MAX(ACTION_ID) AS ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_TYPE = 107 AND PAYROLL_NO = '-1'
						</cfquery>
					</cfif>
					<cfset account_payroll_list=listappend(account_payroll_list,get_payroll_id.ACTION_ID)>
				</cfloop>
			</cfif>
			<!--- ciro ceklerin banka_hesaplarına gore payrollar ekleniyor. --->
			
			<cfoutput query="get_vouchers">
				<cfif len(PAYROLL_ACCOUNT_ID)>
					<cfset temp_payroll_id = listgetat(account_payroll_list,listfind(chq_account_list,PAYROLL_ACCOUNT_ID,','))>
				<cfelseif len(PAYROLL_CASH_ID)>
					<cfset temp_payroll_id = listgetat(cash_payroll_list,listfind(chq_cash_list,PAYROLL_CASH_ID,','))>
				<cfelse>
					<cfset temp_payroll_id = get_payroll_default.ACTION_ID>
				</cfif>
				<cfquery name="GET_COMP_INFO" datasource="#db_out#">
					SELECT COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID FROM VOUCHER_PAYROLL WHERE ACTION_ID = (SELECT MAX(PAYROLL_ID) FROM VOUCHER_HISTORY WHERE STATUS = 4 AND VOUCHER_ID = #get_vouchers.VOUCHER_ID#)
				</cfquery>
				<cfquery name="add_voucher" datasource="#db_in#" result="MAX_ID">
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
						ACCOUNT_CODE,
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
						CH_OTHER_MONEY	
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
						<cfif len(VOUCHER_PURSE_NO)>'#VOUCHER_PURSE_NO#'<cfelse>NULL</cfif>,
						<cfif len(CURRENCY_ID)>'#CURRENCY_ID#'<cfelse>NULL</cfif>,
						<cfif len(SELF_VOUCHER)>#SELF_VOUCHER#<cfelse>NULL</cfif>,
						#temp_payroll_id#,
						<cfif len(ACCOUNT_CODE)>'#ACCOUNT_CODE#'<cfelse>NULL</cfif>,
						<cfif len(PAYROLL_COMP)>#PAYROLL_COMP#<cfelseif len(GET_COMP_INFO.COMPANY_ID)>#GET_COMP_INFO.COMPANY_ID#<cfelse>NULL</cfif>,
						<cfif len(PAYROLL_CONS)>#PAYROLL_CONS#<cfelseif len(GET_COMP_INFO.CONSUMER_ID)>#GET_COMP_INFO.CONSUMER_ID#<cfelse>NULL</cfif>,
						<cfif len(PAYROLL_EMP)>#PAYROLL_EMP#<cfelseif len(GET_COMP_INFO.EMPLOYEE_ID)>#GET_COMP_INFO.EMPLOYEE_ID#<cfelse>NULL</cfif>,
						<cfif len(OWNER_COMPANY_ID)>#OWNER_COMPANY_ID#<cfelse>NULL</cfif>,
						<cfif len(OWNER_CONSUMER_ID)>#OWNER_CONSUMER_ID#<cfelse>NULL</cfif>,
						<cfif len(OWNER_EMPLOYEE_ID)>#OWNER_EMPLOYEE_ID#<cfelse>NULL</cfif>,
						<cfif len(DELAY_INTEREST_SYSTEM_VALUE)>#DELAY_INTEREST_SYSTEM_VALUE#<cfelse>NULL</cfif>,
						<cfif len(DELAY_INTEREST_OTHER_VALUE)>#DELAY_INTEREST_OTHER_VALUE#<cfelse>NULL</cfif>,
						<cfif len(DELAY_INTEREST_VALUE2)>#DELAY_INTEREST_VALUE2#<cfelse>NULL</cfif>,
						<cfif len(EARLY_PAYMENT_SYSTEM_VALUE)>#EARLY_PAYMENT_SYSTEM_VALUE#<cfelse>NULL</cfif>,
						<cfif len(EARLY_PAYMENT_OTHER_VALUE)>#EARLY_PAYMENT_OTHER_VALUE#<cfelse>NULL</cfif>,
						<cfif len(EARLY_PAYMENT_VALUE2)>#EARLY_PAYMENT_VALUE2#<cfelse>NULL</cfif>,
						#session.ep.userid#,
						'#cgi.remote_addr#',
						#CreateODBCDateTime(RECORD_DATE)#,
						<cfif len(cash_id)>#cash_id#<cfelse>NULL</cfif>,
						<cfif len(CH_OTHER_MONEY_VALUE)>#CH_OTHER_MONEY_VALUE#<cfelse>NULL</cfif>,
						<cfif len(CH_OTHER_MONEY)>'#CH_OTHER_MONEY#'<cfelse>NULL</cfif>	
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
						#VOUCHER_ID#,
						#t_cmp#,
						#f_cmp#,
						#t_period#,
						#f_period#,
						0
					)
				</cfquery>
				<cfquery name="add_voucher_history" datasource="#db_in#">
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
								#MAX_ID.IDENTITYCOL#,
								#temp_payroll_id#,
								#VOUCHER_STATUS_ID#,									
								<cfif len(SELF_VOUCHER)>
								#SELF_VOUCHER#,
								<cfelse>
								NULL,
								</cfif>
								<cfif len(OTHER_MONEY_VALUE)>#OTHER_MONEY_VALUE#,<cfelse>NULL,</cfif>
								<cfif len(OTHER_MONEY)>'#OTHER_MONEY#',<cfelse>NULL,</cfif>	
								<cfif len(OTHER_MONEY_VALUE2)>#OTHER_MONEY_VALUE2#,<cfelse>NULL,</cfif>
								<cfif len(OTHER_MONEY2)>'#OTHER_MONEY2#',<cfelse>NULL,</cfif>			
								#NOW()#
							)
				</cfquery>
				<cfif isDefined("attributes.is_cheque_based_action")><!--- satır bazında carileştirmek için --->
					<cfquery name="get_voucher_company" datasource="#db_out#">
						SELECT 
                        	CR.OTHER_CASH_ACT_VALUE,
                            CR.OTHER_MONEY,
                            CR.ACTION_VALUE_2,
                            CR.ACTION_CURRENCY_2,
                            CR.TO_CASH_ID,
							VOUCHER_PAYROLL.*,
							VOUCHER_HISTORY.STATUS
						FROM
							VOUCHER_HISTORY,
							VOUCHER_PAYROLL,
                            CARI_ROWS CR
						WHERE
                        	VOUCHER_HISTORY.PAYROLL_ID = VOUCHER_PAYROLL.ACTION_ID AND
                            CR.ACTION_ID = VOUCHER_HISTORY.VOUCHER_ID AND
                            CR.PAYROLL_ID = VOUCHER_PAYROLL.ACTION_ID AND
                            CR.ACTION_TABLE = 'VOUCHER' AND 
							VOUCHER_ID = #get_vouchers.voucher_id#
					</cfquery>
					<cfset temp_other_money_value = get_vouchers.OTHER_MONEY_VALUE>
					<cfset temp_voucher_no = get_vouchers.VOUCHER_NO>
					<cfset temp_voucher_duedate = get_vouchers.VOUCHER_DUEDATE>
					<cfloop query="get_voucher_company">
						<cfscript>
							carici(
								action_id : MAX_ID.IDENTITYCOL,
								workcube_process_type : 107,		
								process_cat : -1,
								account_card_type :13,
								action_table :'VOUCHER',
								islem_tarihi : createodbcdatetime(dateformat(now(),dateformat_style)),
								islem_tutari : temp_other_money_value,
								other_money_value : get_voucher_company.OTHER_CASH_ACT_VALUE,
								other_money : get_voucher_company.OTHER_MONEY,
								action_value2 : get_voucher_company.ACTION_VALUE_2,
								action_currency_2 : get_voucher_company.ACTION_CURRENCY_2,
								islem_belge_no : temp_voucher_no,
								action_currency :session.ep.money,
								to_cash_id : iif(len(get_voucher_company.TO_CASH_ID),get_voucher_company.TO_CASH_ID,de('')),
								due_date : createodbcdatetime(temp_voucher_duedate),
								from_cmp_id : iif((get_voucher_company.STATUS eq 1 and len(get_voucher_company.COMPANY_ID)),get_voucher_company.COMPANY_ID,de('')),
								from_consumer_id : iif((get_voucher_company.STATUS eq 1 and len(get_voucher_company.CONSUMER_ID)),get_voucher_company.CONSUMER_ID,de('')),
								from_employee_id : iif((get_voucher_company.STATUS eq 1 and len(get_voucher_company.EMPLOYEE_ID)),get_voucher_company.EMPLOYEE_ID,de('')),
								to_cmp_id : iif((get_voucher_company.STATUS eq 4 and len(get_voucher_company.COMPANY_ID)),get_voucher_company.COMPANY_ID,de('')),
								to_consumer_id : iif((get_voucher_company.STATUS eq 4 and len(get_voucher_company.CONSUMER_ID)),get_voucher_company.CONSUMER_ID,de('')), 
								to_employee_id : iif((get_voucher_company.STATUS eq 4 and len(get_voucher_company.EMPLOYEE_ID)),get_voucher_company.EMPLOYEE_ID,de('')), 
								cari_db : db_in,
								islem_detay : 'SENET AÇILIŞ DEVİR',
								payroll_id :temp_payroll_id,
								from_branch_id : iif(len(cash_branch_id),cash_branch_id,de(''))
							);
						</cfscript>
					</cfloop>
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
					AND sysobjects.NAME IN('CARI_ROWS','VOUCHER','VOUCHER_HISTORY')
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
				alert("<cf_get_lang no ='2532.Senet Aktarımı Tamamlandı'>!");
				history.back();
			</script>
		<cfelse>
			<script type="text/javascript">
				alert("<cf_get_lang no ='2523.İlgili Dönemler Arasında Daha Önceden Çek Aktarımı Yapılmıştır'> !");
				history.back();
			</script>
			<cfabort>
		</cfif>
	<cfelse>
		<script type="text/javascript">
			alert("<cf_get_lang no ='2533.Aktaracak Senet Yok'> !");
			history.back();
		</script>
		<cfabort>
	</cfif>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang no ='2531.Seçtiğiniz Dönemler Arasında Aktarım Yapılamaz'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfabort>
