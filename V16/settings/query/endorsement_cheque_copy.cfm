<!--- 
kasa kontrolü eklenecek
ciro carisi kontrol edilcek
ciro ve porfydekilerin dövizine göre carilemesi kontrol edilecek

 --->
<!--- Aktarılan çekin carisi son işlemin bordrosundan alınıyordu. CHEQUE tablosundaki carisi aktarılacak şekilde düzenleme yapıldı. SK20151109 --->


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
<cfset t_pyear = DB_CONTROL_IN.PERIOD_YEAR>	<!--- çeklerin aktarılacağı şirketin period yılı --->
<cfset t_cmp = DB_CONTROL_IN.OUR_COMPANY_ID>		<!--- çeklerin aktarılacağı şirket id --->
<cfset t_period = DB_CONTROL_IN.PERIOD_ID>	<!--- çeklerin aktarılacağı şirketin periodu --->
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
<cfif DB_CONTROL_OUT.recordcount and DB_CONTROL_IN.recordcount>
<cf_date tarih = "attributes.due_date">
	<cfquery name="get_cheques" datasource="#db_out#">
		SELECT	
			P.COMPANY_ID AS PAYROLL_COMP,
			P.CONSUMER_ID AS PAYROLL_CONS,
			P.EMPLOYEE_ID AS PAYROLL_EMP,
			CASE WHEN P2.TRANSFER_CASH_ID IS NOT NULL THEN P2.TRANSFER_CASH_ID ELSE P.PAYROLL_CASH_ID END AS PAYROLL_CASH_ID,
			P2.PAYROLL_ACCOUNT_ID,
            C.COMPANY_ID CHEQUE_COMP,
            C.CONSUMER_ID CHEQUE_CONS,
            C.EMPLOYEE_ID CHEQUE_EMP,
			C.*
		<cfif isDefined("attributes.is_cheque_based_action")>
			,C.OTHER_MONEY_VALUE/(PAYROLL_MONEY.RATE2/PAYROLL_MONEY.RATE1) C_OTHER_MONEY_VALUE
			,P.PAYROLL_OTHER_MONEY C_OTHER_MONEY
		</cfif>
		FROM
			CHEQUE C,
			CHEQUE_HISTORY CH,
			PAYROLL P,
			PAYROLL P2	
		<cfif isDefined("attributes.is_cheque_based_action")>,PAYROLL_MONEY</cfif>
		WHERE
			C.CHEQUE_ID = CH.CHEQUE_ID
			AND CH.HISTORY_ID =(SELECT TOP 1 HISTORY_ID FROM CHEQUE_HISTORY WHERE CHEQUE_ID=C.CHEQUE_ID ORDER BY CHEQUE_HISTORY.ACT_DATE DESC, CHEQUE_HISTORY.HISTORY_ID DESC)
			AND CH.PAYROLL_ID = P2.ACTION_ID
			AND P.ACTION_ID = C.CHEQUE_PAYROLL_ID
			AND C.CHEQUE_STATUS_ID = 4 <!--- ciro edilmis  ---> 
			AND C.CHEQUE_DUEDATE > #attributes.due_date#
		<cfif isDefined("attributes.is_cheque_based_action")>
			AND P.PAYROLL_OTHER_MONEY = PAYROLL_MONEY.MONEY_TYPE 
			AND	P2.ACTION_ID = PAYROLL_MONEY.ACTION_ID
		</cfif>
		<cfif isDefined("attributes.is_cheque_voucher_based_action")><!--- eğer carileşme yapılıyorsa payrol_money kayıtları olmayanlar için cari rows tan baktık --->
			UNION ALL
			SELECT	
				P.COMPANY_ID AS PAYROLL_COMP,
				P.CONSUMER_ID AS PAYROLL_CONS,
				P.EMPLOYEE_ID AS PAYROLL_EMP,
				P.PAYROLL_CASH_ID,
				P2.PAYROLL_ACCOUNT_ID,
                C.COMPANY_ID CHEQUE_COMP,
                C.CONSUMER_ID CHEQUE_CONS,
                C.EMPLOYEE_ID CHEQUE_EMP,
				C.*,
				CR.OTHER_CASH_ACT_VALUE  C_OTHER_MONEY_VALUE,
				CR.OTHER_MONEY C_OTHER_MONEY
			FROM
				CHEQUE C,
				CHEQUE_HISTORY CH,
				PAYROLL P,
				CARI_ROWS CR
			WHERE
				C.CHEQUE_ID = CH.CHEQUE_ID
				AND CH.HISTORY_ID =(SELECT TOP 1 HISTORY_ID FROM CHEQUE_HISTORY WHERE CHEQUE_ID=C.CHEQUE_ID ORDER BY CHEQUE_HISTORY.ACT_DATE DESC, CHEQUE_HISTORY.HISTORY_ID DESC)
				AND CH.PAYROLL_ID = P2.ACTION_ID
				AND P.ACTION_ID = C.CHEQUE_PAYROLL_ID
				AND C.CHEQUE_STATUS_ID = 4 <!--- ciro edilmis  ---> 
				AND C.CHEQUE_DUEDATE > #attributes.due_date#
				AND C.CHEQUE_ID = CR.ACTION_ID
				AND CR.ACTION_TYPE_ID = 106
				AND C.CHEQUE_PAYROLL_ID NOT IN(SELECT PM.ACTION_ID FROM PAYROLL_MONEY PM)
		</cfif>
	</cfquery>
	<cfscript>
		chq_cash_list=listsort(ListDeleteDuplicates(valuelist(get_cheques.PAYROLL_CASH_ID,',')),"numeric","asc",",");
		chq_account_list=listsort(ListDeleteDuplicates(valuelist(get_cheques.PAYROLL_ACCOUNT_ID,',')),"numeric","asc",",");
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
	 <cfif get_cheques.recordcount>
	 	<!---<cfquery name="control" datasource="#dsn#">
			SELECT
				TO_CHEQUE_VOUCHER_ID
			FROM
				CHEQUE_VOUCHER_COPY_REF
			WHERE 
				TO_PERIOD_ID = #t_period# AND
				FROM_PERIOD_ID = #f_period# AND
				IS_CHEQUE = 1
				AND FROM_CHEQUE_VOUCHER_ID IN(SELECT CHEQUE_ID FROM #db_out#.CHEQUE WHERE CHEQUE_STATUS_ID = 4)
		</cfquery>
		<cfif control.recordcount eq 0> --->
			<!--- kasa ve banka bilgileri bos olan ciro cekler icin--->
			<cfquery name="get_payroll_default" datasource="#db_in#">
				SELECT MAX(ACTION_ID) AS ACTION_ID FROM PAYROLL WHERE PAYROLL_TYPE = 106 AND PAYROLL_NO = '-1' AND PAYROLL_CASH_ID IS NULL AND PAYROLL_ACCOUNT_ID IS NULL
			</cfquery>
			<cfif not get_payroll_default.recordcount or not len(get_payroll_default.action_id)>
				<cfquery name="ADD_PAYROLL" datasource="#db_in#">
					INSERT INTO PAYROLL 
						(PAYROLL_NO,PAYROLL_TYPE,PAYROLL_RECORD_DATE,RECORD_EMP,RECORD_IP,RECORD_DATE)
						VALUES
						('-1',106,#now()#,#session.ep.userid#,'#cgi.remote_addr#',#now()#)
				</cfquery>
				<cfquery name="get_payroll_default" datasource="#db_in#">
					SELECT MAX(ACTION_ID) AS ACTION_ID FROM PAYROLL WHERE PAYROLL_TYPE = 106 AND PAYROLL_NO = '-1'
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
						SELECT ACTION_ID FROM PAYROLL WHERE PAYROLL_TYPE = 106 AND PAYROLL_NO = '-1' AND PAYROLL_CASH_ID=#temp_cash_id# AND COMPANY_ID IS NULL AND CONSUMER_ID IS NULL
					</cfquery>
					<cfif not get_payroll_id.recordcount>
						<cfquery name="ADD_PAYROLL_1" datasource="#db_in#">
							INSERT INTO PAYROLL 
								(PAYROLL_NO,PAYROLL_TYPE,PAYROLL_CASH_ID,PAYROLL_RECORD_DATE,RECORD_EMP,RECORD_IP,RECORD_DATE)
								VALUES
								('-1',106,#temp_cash_id#,#now()#,#session.ep.userid#,'#cgi.remote_addr#',#now()#)
						</cfquery>
						<cfquery name="get_payroll_id" datasource="#db_in#">
							SELECT MAX(ACTION_ID) AS ACTION_ID FROM PAYROLL WHERE PAYROLL_TYPE = 106 AND PAYROLL_NO = '-1'
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
						SELECT ACTION_ID FROM PAYROLL WHERE PAYROLL_TYPE = 106 AND PAYROLL_NO = '-1' AND PAYROLL_ACCOUNT_ID=#account_index#
					</cfquery>
					<cfif not get_payroll_id.recordcount>
						<cfquery name="ADD_PAYROLL_2" datasource="#db_in#">
							INSERT INTO PAYROLL 
								(PAYROLL_NO,PAYROLL_TYPE,PAYROLL_ACCOUNT_ID,PAYROLL_RECORD_DATE,RECORD_EMP,RECORD_IP,RECORD_DATE)
								VALUES
								('-1',106,#account_index#,#now()#,#session.ep.userid#,'#cgi.remote_addr#',#now()#)
						</cfquery>
						<cfquery name="get_payroll_id" datasource="#db_in#">
							SELECT MAX(ACTION_ID) AS ACTION_ID FROM PAYROLL WHERE PAYROLL_TYPE = 106 AND PAYROLL_NO = '-1'
						</cfquery>
					</cfif>
					<cfset account_payroll_list=listappend(account_payroll_list,get_payroll_id.ACTION_ID)>
				</cfloop>
			</cfif>
			<!--- ciro ceklerin banka_hesaplarına gore payrollar ekleniyor. --->
			
			<cfoutput query="get_cheques">
				<cfif len(PAYROLL_ACCOUNT_ID)>
					<cfset temp_payroll_id = listgetat(account_payroll_list,listfind(chq_account_list,PAYROLL_ACCOUNT_ID,','))>
				<cfelseif len(PAYROLL_CASH_ID)>
					<cfset temp_payroll_id = listgetat(cash_payroll_list,listfind(chq_cash_list,PAYROLL_CASH_ID,','))>
				<cfelse>
					<cfset temp_payroll_id = get_payroll_default.ACTION_ID>
				</cfif>
				<cfquery name="GET_COMP_INFO" datasource="#db_out#">
					SELECT COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID FROM PAYROLL WHERE ACTION_ID = (SELECT TOP 1 PAYROLL_ID FROM CHEQUE_HISTORY WHERE STATUS = 4 AND CHEQUE_ID = #get_cheques.CHEQUE_ID# ORDER BY HISTORY_ID DESC)
				</cfquery>
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
						CASH_ID	,
						CH_OTHER_MONEY_VALUE,
						CH_OTHER_MONEY		
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
						<cfif len(CHEQUE_COMP)>#CHEQUE_COMP#<cfelseif len(GET_COMP_INFO.COMPANY_ID)>#GET_COMP_INFO.COMPANY_ID#<cfelseif len(PAYROLL_COMP)>#PAYROLL_COMP#<cfelse>NULL</cfif>,
						<cfif len(CHEQUE_CONS)>#CHEQUE_CONS#<cfelseif len(GET_COMP_INFO.CONSUMER_ID)>#GET_COMP_INFO.CONSUMER_ID#<cfelseif len(PAYROLL_CONS)>#PAYROLL_CONS#<cfelse>NULL</cfif>,
						<cfif len(CHEQUE_EMP)>#CHEQUE_EMP#<cfelseif len(GET_COMP_INFO.EMPLOYEE_ID)>#GET_COMP_INFO.EMPLOYEE_ID#<cfelseif len(PAYROLL_EMP)>#PAYROLL_EMP#<cfelse>NULL</cfif>,
						<cfif len(OWNER_COMPANY_ID)>#OWNER_COMPANY_ID#<cfelse>NULL</cfif>,
						<cfif len(OWNER_CONSUMER_ID)>#OWNER_CONSUMER_ID#<cfelse>NULL</cfif>,
						<cfif len(OWNER_EMPLOYEE_ID)>#OWNER_EMPLOYEE_ID#<cfelse>NULL</cfif>,
						<cfif len(RESULT_ID)>#RESULT_ID#<cfelse>NULL</cfif>,
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
							<cfif len(OTHER_MONEY_VALUE)>#OTHER_MONEY_VALUE#,<cfelse>NULL,</cfif>
							<cfif len(OTHER_MONEY)>'#OTHER_MONEY#',<cfelse>NULL,</cfif>	
							<cfif len(OTHER_MONEY_VALUE2)>#OTHER_MONEY_VALUE2#,<cfelse>NULL,</cfif>
							<cfif len(OTHER_MONEY2)>'#OTHER_MONEY2#',<cfelse>NULL,</cfif>			
							#NOW()#
						)
				</cfquery>
				<cfif isDefined("attributes.is_cheque_based_action")><!--- satır bazında carileştirmek için --->
					<cfquery name="GET_CHEQUE_COMPANY" datasource="#db_out#">
                    	SELECT 
                        	CR.OTHER_CASH_ACT_VALUE,
                            CR.OTHER_MONEY,
                            CR.ACTION_VALUE_2,
                            CR.ACTION_CURRENCY_2,
                            PAYROLL.*,
                            CHEQUE_HISTORY.STATUS
                        FROM
                            CHEQUE_HISTORY,
                            PAYROLL,
                            CARI_ROWS CR
                        WHERE
                            CHEQUE_HISTORY.PAYROLL_ID = PAYROLL.ACTION_ID AND
                            CR.ACTION_ID = CHEQUE_HISTORY.CHEQUE_ID AND
                            CR.PAYROLL_ID = PAYROLL.ACTION_ID AND
                            CR.ACTION_TABLE = 'CHEQUE' AND 
                            CHEQUE_ID = #get_cheques.CHEQUE_ID# AND
                            STATUS IN(1,4)
					</cfquery>
					<cfset temp_other_money_value = get_cheques.OTHER_MONEY_VALUE>
					<cfset temp_cheque_no = get_cheques.CHEQUE_NO>
					<cfset temp_cheque_duedate = get_cheques.CHEQUE_DUEDATE>
					<cfloop query="GET_CHEQUE_COMPANY">
						<cfscript>
							carici(
								action_id : MAX_ID.IDENTITYCOL,
								workcube_process_type : 106,		
								process_cat : -1,
								account_card_type :13,
								action_table :'CHEQUE',
								islem_tarihi : islem_tarihi,
								islem_tutari : temp_other_money_value,
								other_money_value : GET_CHEQUE_COMPANY.OTHER_CASH_ACT_VALUE,
								other_money : GET_CHEQUE_COMPANY.OTHER_MONEY,
								action_value2 : GET_CHEQUE_COMPANY.ACTION_VALUE_2,
								action_currency_2 : GET_CHEQUE_COMPANY.ACTION_CURRENCY_2,
								islem_belge_no : temp_cheque_no,
								action_currency :session.ep.money,
								to_cash_id : iif(len(temp_cash_id),temp_cash_id,de('')),
								due_date : createodbcdatetime(temp_cheque_duedate),
								from_cmp_id : iif((GET_CHEQUE_COMPANY.STATUS eq 1 and len(GET_CHEQUE_COMPANY.COMPANY_ID)),GET_CHEQUE_COMPANY.COMPANY_ID,de('')),
								from_consumer_id : iif((GET_CHEQUE_COMPANY.STATUS eq 1 and len(GET_CHEQUE_COMPANY.CONSUMER_ID)),GET_CHEQUE_COMPANY.CONSUMER_ID,de('')),
								from_employee_id : iif((GET_CHEQUE_COMPANY.STATUS eq 1 and len(GET_CHEQUE_COMPANY.EMPLOYEE_ID)),GET_CHEQUE_COMPANY.EMPLOYEE_ID,de('')),
								to_cmp_id : iif((GET_CHEQUE_COMPANY.STATUS eq 4 and len(GET_CHEQUE_COMPANY.COMPANY_ID)),GET_CHEQUE_COMPANY.COMPANY_ID,de('')),
								to_consumer_id : iif((GET_CHEQUE_COMPANY.STATUS eq 4 and len(GET_CHEQUE_COMPANY.CONSUMER_ID)),GET_CHEQUE_COMPANY.CONSUMER_ID,de('')), 
								to_employee_id : iif((GET_CHEQUE_COMPANY.STATUS eq 4 and len(GET_CHEQUE_COMPANY.EMPLOYEE_ID)),GET_CHEQUE_COMPANY.EMPLOYEE_ID,de('')), 
								cari_db : db_in,
								payroll_id :temp_payroll_id,
								islem_detay : 'ÇEK AÇILIŞ DEVİR',
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
		<!---<cfelse>
			<script type="text/javascript">
				alert("<cf_get_lang no ='2523.İlgili Dönemler Arasında Daha Önceden Çek Aktarımı Yapılmıştır'> !");
				history.back();
			</script>
			<cfabort>
		</cfif>--->
	<cfelse>
		<script type="text/javascript">
			alert("<cf_get_lang no ='2524.Aktaracak Çek Yok'> !");
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
