<cf_xml_page_edit fuseact="account.popup_add_sum_bills">
<cfset card_type_list = "">
<cfif isdefined('attributes.process_type') and len(attributes.process_type)>
	<cfset attributes.process_type=listdeleteduplicates(attributes.process_type)>
</cfif>
<cfset old_bill_no = ''>
<cfif isdefined("attributes.main_card_id")>
	<cfquery name="get_card_type" datasource="#dsn2#">
		SELECT CARD_TYPE,ACTION_DATE FROM ACCOUNT_CARD WHERE CARD_ID = #attributes.main_card_id#
	</cfquery>
	<cfset attributes.card_type = get_card_type.card_type>
	<cfset attributes.process_date = dateformat(get_card_type.action_date,dateformat_style)>
</cfif>
<cfif isdefined('attributes.is_temporary_solve') and attributes.is_temporary_solve eq 1 and isdefined('attributes.card_id') and len(attributes.card_id)>
	<!--- geçici olarak açılmış fiş yeniden birleştiriliyor  --->
	<cfset old_card_info=''>
	<cfquery name="GET_OLD_CARDS" datasource="#dsn2#">
		SELECT ACTION_ID,ACTION_TYPE,PROCESS_DATE,CARD_ID FROM ACCOUNT_CARD_SAVE WHERE NEW_CARD_ID=#attributes.card_id# AND IS_TEMPORARY_SOLVED=1
	</cfquery>    
	<cfset attributes.PROCESS_DATE=dateformat(GET_OLD_CARDS.PROCESS_DATE,dateformat_style)>
	<cfset old_card_row_info= valuelist(GET_OLD_CARDS.CARD_ID)>
	<cfif isdate(attributes.process_date) and len(attributes.process_date)>
		<cf_date tarih="attributes.process_date">
	</cfif>
	<cfquery name="GET_CARD_IDS" datasource="#DSN2#">
		SELECT DISTINCT
			ACS.NEW_BILL_NO OLD_BILL_NO_,
			ACS.NEW_CARD_TYPE_NO OLD_CARD_TYPE_NO_,
			ACS.NEW_CARD_DETAIL OLD_CARD_DETAIL_,
            ACC.CARD_TYPE,
            ACC.IS_OTHER_CURRENCY,
            ACC.CARD_ID,
            ACC.ACTION_DATE,
            ACC.RECORD_DATE ,
            ACC.RECORD_EMP,
            ACC.RECORD_IP,
            ACC.ACTION_ID,
            ACC.CARD_DETAIL,
            ACC.CARD_CAT_ID,
            ACC.ACTION_TYPE,
            ACC.ACTION_CAT_ID,
            ACC.BILL_NO,
            ACC.IS_ACCOUNT,
            ACC.CARD_TYPE_NO,
            ACC.PAPER_NO,
            ACC.IS_COMPOUND,
            ACC.IS_RATE_DIFF,
            ACC.ACTION_TABLE,
            ACC.CARD_DOCUMENT_TYPE,
            ACC.CARD_PAYMENT_METHOD
		FROM
			ACCOUNT_CARD ACC,
			ACCOUNT_CARD_SAVE ACS
		WHERE
			(ACC.IS_COMPOUND IS NULL OR ACC.IS_COMPOUND=0) <!--- birlestirilmis fislerin tekrar fis birlestirmeye dahil edilmesini engellemek icin --->
			AND ACC.ACTION_ID=ACS.ACTION_ID
			AND ACC.ACTION_TYPE=ACS.ACTION_TYPE
			AND ACS.NEW_CARD_ID=#attributes.card_id#
			AND ACS.IS_TEMPORARY_SOLVED=1
	</cfquery>    
	<cfquery name="GET_CARD_IDS2" datasource="#DSN2#">
		SELECT
			ACS.NEW_BILL_NO OLD_BILL_NO_,
			ACS.NEW_CARD_TYPE_NO OLD_CARD_TYPE_NO_,
			ACS.NEW_CARD_DETAIL OLD_CARD_DETAIL_
		FROM
			ACCOUNT_CARD ACC,
			ACCOUNT_CARD_SAVE ACS
		WHERE
			(ACC.IS_COMPOUND IS NULL OR ACC.IS_COMPOUND=0) <!--- birlestirilmis fislerin tekrar fis birlestirmeye dahil edilmesini engellemek icin --->
			AND ACC.ACTION_ID=ACS.ACTION_ID
			AND ACC.ACTION_TYPE<>ACS.ACTION_TYPE
			AND ACC.ACTION_TYPE IN(48,49,52,53,54,55,56,57,58,59,60,62,63,65,66,531,532,561,591,601)
			AND ACS.ACTION_TYPE IN(48,49,52,53,54,55,56,57,58,59,60,62,63,65,66,531,532,561,591,601)
			AND ACS.NEW_CARD_ID=#attributes.card_id#
			AND ACS.IS_TEMPORARY_SOLVED=1
	</cfquery>
	<cfset old_bill_no = GET_CARD_IDS.OLD_BILL_NO_>
	<cfset old_card_no = GET_CARD_IDS.OLD_CARD_TYPE_NO_>
	<cfset old_detail = GET_CARD_IDS.OLD_CARD_DETAIL_>
	<cfif GET_CARD_IDS2.recordcount>
		<script type="text/javascript">
			alert("Birleştirilmiş Fişin İçerisinde İşlem Tipi Değişen Fatura Mevcut , Fiş Birleştirme İşlemi Yapamazsınız !");
			window.close();
		</script>
		<cfabort>
	</cfif>
<cfelse>
	<cfif not isdefined("attributes.card_id")>
		<cfif len(attributes.card_type)>
			<cfset CARD_TYPE = attributes.card_type>
		</cfif>
		<cfif len(attributes.finish_date)>
			<cf_date tarih="attributes.finish_date">
		</cfif>
		<cfif len(attributes.start_date)>
			<cf_date tarih="attributes.start_date">
		</cfif>
		<cfif isdate(attributes.process_date) and len(attributes.process_date)>
			<cf_date tarih="attributes.process_date">
		</cfif>
		<!--- fatura nosuna gore hareket birleştirme --->
		<cfif isdefined('attributes.invoice_start_no') and len(attributes.invoice_start_no) and isdefined('attributes.invoice_finish_no') and len(attributes.invoice_finish_no)>
			<cfscript>
				is_inv_start_numeric = 0;
				is_inv_finish_numeric = 0;
				inv_start_number='';
				inv_finish_number='';
			</cfscript>
			<cfloop from="#len(attributes.invoice_start_no)#" to="1" step="-1" index="i">
				<cfset karakter = mid(attributes.invoice_start_no,i,1)>
				<cfif not isnumeric(karakter)>
					<cfif listlen(attributes.invoice_start_no,karakter) gt 0>
						<cfset inv_start_number = listlast(attributes.invoice_start_no,karakter)>
						<cfset inv_start_text = listdeleteat(attributes.invoice_start_no,listlen(attributes.invoice_start_no,karakter),karakter) & karakter>
					</cfif>
					<cfbreak>
				<cfelse>
					<cfset is_inv_start_numeric = is_inv_start_numeric + 1>
				</cfif>
			</cfloop>
			<cfloop from="#len(attributes.invoice_finish_no)#" to="1" step="-1" index="i">
				<cfset karakter2 = mid(attributes.invoice_finish_no,i,1)>
				<cfif not isnumeric(karakter2)>			
					<cfif listlen(attributes.invoice_start_no,karakter) gt 0>
						<cfset inv_finish_number = listlast(attributes.invoice_finish_no,karakter)>
						<cfset inv_finish_text = listdeleteat(attributes.invoice_finish_no,listlen(attributes.invoice_finish_no,karakter2),karakter2) & karakter2>
					</cfif>
					<cfbreak>
				<cfelse>
					<cfset is_inv_finish_numeric = is_inv_finish_numeric + 1>
				</cfif>
			</cfloop>
			<cfif is_inv_start_numeric eq len(attributes.invoice_start_no)>
				<cfset inv_start_text = "">
				<cfset inv_start_number = attributes.invoice_start_no>
			</cfif>
			<cfif is_inv_finish_numeric eq len(attributes.invoice_finish_no)>
				<cfset inv_finish_text = "">
				<cfset inv_finish_number = attributes.invoice_finish_no>
			</cfif>
			<cfif not len(inv_start_number) or not len(inv_finish_number) or (inv_finish_text neq inv_start_text )>
				<script type="text/javascript">
					alert("<cf_get_lang no ='239.Girilen Aralık Geçerli Değil'>!");
					history.back();
				</script>
				<cfabort>
			</cfif>
		</cfif>
		<!--- //fatura nosuna gore hareket birleştirme --->
		<cfif isdefined('attributes.process_type_group') and len(attributes.process_type_group)>
			<cfquery name="get_act_group_list" datasource="#dsn3#">
				SELECT ACGR.PROCESS_TYPE FROM BILLS_PROCESS_GROUP ACGR WHERE ACGR.PROCESS_TYPE_GROUP_ID = #attributes.process_type_group#
			</cfquery>
			<cfset new_group_process_list = valuelist(get_act_group_list.process_type)>
		</cfif>
	</cfif>
	<cfquery name="GET_CARD_IDS" datasource="#DSN2#">
		SELECT
			*
		FROM
			ACCOUNT_CARD
		WHERE
			(IS_COMPOUND IS NULL OR IS_COMPOUND=0) <!--- birlestirilmis fislerin tekrar fis birlestirmeye dahil edilmesini engellemek icin --->
			<cfif not isdefined("attributes.card_id")>
				<cfif isdefined('attributes.process_type') and len(attributes.process_type)>
					AND(
					<cfloop list="#attributes.process_type#" delimiters="," index="type_i">
						(ACTION_TYPE = #listfirst(type_i,'-')# <cfif len(listlast(type_i,'-')) and listlast(type_i,'-') neq 0>AND ACTION_CAT_ID = #listlast(type_i,'-')#</cfif>)
						<cfif type_i neq listlast(attributes.process_type,',') and listlen(attributes.process_type,',') gte 1> OR</cfif>
					</cfloop>  
						)
				</cfif>
				<cfif isdefined('attributes.process_type_group') and len(attributes.process_type_group)>
					<cfif listlen(new_group_process_list) gt 0>
						AND ACTION_CAT_ID IN(#new_group_process_list#)
					<cfelse>
						AND 0 = 1
					</cfif>
				</cfif>
				<cfif isdefined('attributes.invoice_start_no') and len(attributes.invoice_start_no) and isdefined('attributes.invoice_finish_no') and len(attributes.invoice_finish_no)>
					AND ACTION_ID IN 
						(
						SELECT 
							INVOICE_ID
						FROM 
							INVOICE 
						WHERE 
							INVOICE_CAT = ACCOUNT_CARD.ACTION_TYPE AND
							LEN(INVOICE_NUMBER) = #len('#inv_start_text##inv_start_number#')# AND
							INVOICE_NUMBER BETWEEN '#inv_start_text#'+'#inv_start_number#' AND '#inv_finish_text#'+'#inv_finish_number#'
						)
				</cfif>
				<cfif isdefined('attributes.code1') and len(attributes.code1) and isdefined('attributes.code2') and len(attributes.code2)>
					AND CARD_ID IN 
						(
						SELECT 
							CARD_ID
						FROM 
							ACCOUNT_CARD_ROWS 
						WHERE 
							ACCOUNT_ID >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.code1#"> AND
							ACCOUNT_ID <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.code2#">
						)
				</cfif>
				<cfif isdefined('card_type') and len(card_type)>	
					<cfif listlen(card_type,'-') eq 1 or (listlen(card_type,'-') gt 1 and listlast(card_type,'-') eq 0)>
						AND CARD_TYPE=#listfirst(card_type,'-')#
					<cfelse>
						AND CARD_CAT_ID=#listlast(card_type,'-')#
					</cfif>
				</cfif>
				<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
					AND CARD_ID IN
					(
						SELECT 
							ACCR.CARD_ID 
						FROM 
							ACCOUNT_CARD_ROWS ACCR 
						WHERE 
							ACCR.CARD_ID = CARD_ID 
							AND ACCR.ACC_BRANCH_ID= #attributes.branch_id#
					)
				</cfif>
				<cfif (isdefined('attributes.start_date') and len(attributes.start_date)) and (isdefined('attributes.finish_date') and len(attributes.finish_date))>
					AND ACTION_DATE >=	#attributes.start_date#
					AND ACTION_DATE <=	#attributes.finish_date#
				</cfif>
				<cfif len(attributes.CARD_NO_STR) and  len(attributes.CARD_NO_FIN)>
					AND CARD_TYPE_NO >= #attributes.CARD_NO_STR#
					AND CARD_TYPE_NO <= #attributes.CARD_NO_FIN#
				</cfif>
				<cfif isdefined('attributes.employee_id')  and len(attributes.employee_id) and len(attributes.employee_name)>
					AND RECORD_EMP = #attributes.employee_id#
				</cfif>
			<cfelse>
				AND CARD_ID = #attributes.card_id#
			</cfif>
	</cfquery>
</cfif>
<cfif GET_CARD_IDS.recordcount eq 0>
	<cfif isdefined('attributes.is_temporary_solve') and attributes.is_temporary_solve eq 1 and isdefined('attributes.card_id') and len(attributes.card_id)>
		<cfquery name="del_old_fis_" datasource="#dsn2#">
			DELETE FROM ACCOUNT_CARD_SAVE_ROWS WHERE CARD_ID IN (#old_card_row_info#)
		</cfquery>
		<cfquery name="del_old_fis_" datasource="#dsn2#">
			DELETE FROM ACCOUNT_CARD_SAVE WHERE NEW_CARD_ID =#attributes.card_id# AND IS_TEMPORARY_SOLVED=1
		</cfquery>
		<script type="text/javascript">
			alert("<cf_get_lang no ='240.Birleştirilmiş Fiş İçerigindeki İşlemlere Ait Muhasebe Hareketi Bulunamadı'>!");
			window.close();
			wrk_opener_reload();	
		</script> 
	<cfelse>
		<script type="text/javascript">
			alert("<cf_get_lang no ='241.Birleştirilecek Muhasebe Fişi Bulunamadı'>");
			history.back();
		</script> 
	</cfif>
	<cfabort>	
</cfif>
<cfset card_type_list=listsort(listdeleteduplicates(valuelist(GET_CARD_IDS.CARD_TYPE,',')),'numeric','ASC',',')>
<cfif isdefined("attributes.main_card_id")>
	<cfset card_type_list = listappend(card_type_list,get_card_type.card_type)>
	<cfset card_type_list=listsort(listdeleteduplicates(card_type_list),'numeric','ASC',',')>
</cfif>
<cfif isdefined("card_type_list") and listlen(card_type_list) gt 1>
	<script type="text/javascript">
		alert("<cf_get_lang no ='242.Seçtiğiniz İşlem Tipleri Aynı Türde Fiş Oluşturmuyor'>!");
		history.back();
	</script> 
	<cfabort>	
</cfif>

<cfif not isdefined('attributes.is_temporary_solve') and len(attributes.card_type)>
	<cfset CARD_TYPE = listfirst(attributes.card_type,'-')>
<cfelse>
	<cfset CARD_TYPE = card_type_list>
</cfif>
<cfquery name="get_all_cards" dbtype="query">
	SELECT * FROM GET_CARD_IDS
</cfquery>
<cfquery name="control_other_currency" dbtype="query" maxrows="1">
	SELECT * FROM GET_CARD_IDS WHERE IS_OTHER_CURRENCY=1
</cfquery>
<cfquery name="GET_CARD_ID_ROWS" datasource="#DSN2#">
	SELECT DISTINCT
		--ACR.*,
        ACR.CARD_ROW_ID,
		ACR.ACCOUNT_ID,
        ACR.BA,
        ACR.AMOUNT,
        ACR.AMOUNT_CURRENCY,
        ACR.AMOUNT_2,
        ACR.AMOUNT_CURRENCY_2,
        ACR.IS_RATE_DIFF_ROW,
        ACR.ACCOUNT_CODE2,
        ACR.IFRS_CODE,
        ACR.OTHER_AMOUNT,
        ACR.OTHER_CURRENCY,
        ACR.DETAIL,
        ACR.ACC_DEPARTMENT_ID,
        ACR.ACC_BRANCH_ID,
        ACR.ACC_PROJECT_ID,
        ACR.QUANTITY,
        ACR.CARD_ID,
		AC.PAPER_NO,
		ISNULL(AC.ACTION_ID,0) ACTION_ID,
		ISNULL(AC.ACTION_TYPE,0) ACTION_TYPE,
		AC.ACTION_DATE
	FROM
		ACCOUNT_CARD_ROWS ACR,
		ACCOUNT_CARD AC
	WHERE
		ACR.CARD_ID = AC.CARD_ID
		<cfif GET_CARD_IDS.recordcount>
			AND ACR.CARD_ID IN (#ValueList(GET_CARD_IDS.CARD_ID)#)
		<cfelse>
			AND ACR.CARD_ID < 0
		</cfif>
</cfquery>

<cfif (isdefined('attributes.is_temporary_solve') and attributes.is_temporary_solve eq 1) or not len(attributes.card_type) or (len(attributes.card_type) and listlen(attributes.card_type,'-') neq 2)> <!--- işlem tipi secilmisse fis türü olarak default olan atanır  --->
	<cfquery name="GET_DEFAULT_PRO_TYPE" datasource="#DSN3#">
		SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT,IS_ACCOUNT FROM SETUP_PROCESS_CAT WHERE IS_DEFAULT=1 AND PROCESS_TYPE=#CARD_TYPE#
	</cfquery>
	<cfif GET_DEFAULT_PRO_TYPE.recordcount neq 0>
		<cfset card_process_cat_id=GET_DEFAULT_PRO_TYPE.PROCESS_CAT_ID>
	<cfelse>
		<script type="text/javascript">
			alert('Standart Muhasebe Fişi İşlem Kategorileri Tanımlı Değil!<br />İşlem Kategorileri Bölümünde Fiş Tanımlarınızı Yapınız!');
			history.back();
		</script>
		<cfabort>
	</cfif>
<cfelse>
	<cfset card_process_cat_id=listlast(attributes.card_type,'-')>
</cfif>

<cfset cardlist = listsort(valuelist(GET_CARD_IDS.CARD_ID,","),'numeric','asc',',')>
<cfif len(cardlist)>
	<cflock name="#CreateUUID()#" timeout="60">
		<cftransaction>
		<cfif isdefined("attributes.is_day_group")>
			<cfset day_count = datediff('d',attributes.start_date,attributes.finish_date)+1>
		<cfelse>
			<cfset day_count = 1>
		</cfif>
		<cfloop from="1" to="#day_count#" index="kk">
			<cfquery name="get_bills" datasource="#dsn2#">
				SELECT * FROM BILLS
			</cfquery>
			<cfset islem_bill_no = get_bills.BILL_NO>
			<cfif isdefined("old_bill_no") and len(old_bill_no)>
				<cfset islem_bill_no = old_bill_no>	
			</cfif>
			<cfswitch expression="#CARD_TYPE#">
				<cfcase value="11">
					<cfset islem_tip_bill_no = get_bills.TAHSIL_BILL_NO >
					<cfset alan_adi = "TAHSIL_BILL_NO" >
				</cfcase>
				<cfcase value="12">
					<cfset islem_tip_bill_no = get_bills.TEDIYE_BILL_NO >
					<cfset alan_adi = "TEDIYE_BILL_NO" >
				</cfcase>
				<cfcase value="13,14">
					<cfset islem_tip_bill_no = get_bills.MAHSUP_BILL_NO >
					<cfset alan_adi = "MAHSUP_BILL_NO" >				
				</cfcase>
			</cfswitch>
			<cfif isdefined("old_card_no") and len(old_card_no)>
				<cfset islem_tip_bill_no = old_card_no>	
			</cfif>
			<cfif isdefined("attributes.is_day_group")>
				<cfset date_info = dateadd('d',kk-1,attributes.start_date)>
				<cfquery name="get_card_rows_" dbtype="query">
					SELECT CARD_ID FROM GET_CARD_IDS WHERE ACTION_DATE = #date_info#
				</cfquery>
				<cfquery name="get_all_cards" dbtype="query">
					SELECT * FROM GET_CARD_IDS WHERE ACTION_DATE = #date_info#
				</cfquery>
				<cfset cardlist = listsort(valuelist(get_card_rows_.CARD_ID,","),'numeric','asc',',')>
			<cfelse>
				<cfset date_info = attributes.PROCESS_DATE>
			</cfif>
			<cfif GET_CARD_ID_ROWS.recordcount>
				<cfif isdefined("attributes.bill_detail") and len(attributes.bill_detail)>
                    <cfset row_detail = '#dateformat(date_info,dateformat_style)# #attributes.bill_detail#'>
                <cfelse>
                    <cfset row_detail = '#dateformat(date_info,dateformat_style)# Tarihli Fiş Birleştirme İşlemi'>
                </cfif>
                <cfif isdefined("old_detail") and len(old_detail)>
                    <cfset row_detail = old_detail>	
                </cfif>
                <cfif not isdefined("attributes.main_card_id")>
                    <cfquery name="add_new_card" datasource="#DSN2#">
                        INSERT INTO
                            ACCOUNT_CARD 
                            (
                                IS_COMPOUND,
                                CARD_DETAIL,
                                CARD_TYPE,
                                CARD_CAT_ID,
                                BILL_NO,
                                CARD_TYPE_NO,
                                ACTION_DATE,
                            <cfif control_other_currency.recordcount>
                                IS_OTHER_CURRENCY,		
                            </cfif>
                                RECORD_EMP,
                                RECORD_DATE,
                                RECORD_IP			
                            )
                        VALUES
                            (
                                 1,
                                 '#row_detail#',
                                 #CARD_TYPE#,
                            <cfif isdefined('card_process_cat_id') and len(card_process_cat_id)>#card_process_cat_id#<cfelse>NULL</cfif>,
                                 #islem_bill_no#,
                                 #islem_tip_bill_no#,
                            <cfif len(attributes.process_date)>#date_info#<cfelse>NULL</cfif>,
                            <cfif control_other_currency.recordcount>1,</cfif>
                                 #SESSION.EP.USERID#,
                                 #NOW()#,
                                 '#CGI.REMOTE_ADDR#'
                            )
                    </cfquery>
                    <cfquery name="get_max_acc_card_id" datasource="#DSN2#">
                        SELECT MAX(CARD_ID) AS MAX_CARD_ID FROM ACCOUNT_CARD
                    </cfquery>		
                <cfelse>
                    <cfset get_max_acc_card_id.max_card_id = attributes.main_card_id>
                </cfif>
                <cfquery name="check_temp_table" datasource="#dsn2#">
                    IF EXISTS(SELECT * FROM tempdb.sys.tables where name='####get_rows_#session.ep.userid#_#kk#')
                    drop table ####get_rows_#session.ep.userid#_#kk#
                </cfquery>
                <cfquery name="get_data_rows" datasource="#dsn2#">
                 	SELECT * INTO ####get_rows_#session.ep.userid#_#kk# FROM
                    (   
						<!--- borc --->
                        SELECT 
                        <cfif isdefined('attributes.is_account_group') and attributes.is_account_group eq 1 and (not x_is_group_debt_claim or (isdefined('attributes.is_debt_group') and attributes.is_debt_group eq 1))>
                            SUM(AMOUNT) AMOUNT,
                            SUM(AMOUNT_2) AMOUNT_2,
                            SUM(OTHER_AMOUNT) OTHER_AMOUNT,
                            SUM(QUANTITY) QUANTITY,
                            '' AS DETAIL,
                            '' AS PAPER_NO,
                            0 AS ACTION_ID,
                            0 AS ACTION_TYPE,
                        <cfelse>
                            AMOUNT,
                            AMOUNT_2,
                            OTHER_AMOUNT,
                            QUANTITY,
                            DETAIL, <!--- hesap bazında gruplama da satır bazlı acıklama alınmıyor --->
                            PAPER_NO,
                            ACTION_ID,
                            ACTION_TYPE,                    
                        </cfif>	
                        <cfif session.ep.our_company_info.is_ifrs eq 1>
                            ACCOUNT_CODE2,
                            IFRS_CODE,
                        </cfif>
                            AMOUNT_CURRENCY,
                            AMOUNT_CURRENCY_2,
                            OTHER_CURRENCY,
                            ACCOUNT_ID,
                            BA,
                            ACC_DEPARTMENT_ID,
                            ACC_BRANCH_ID,
                            ACC_PROJECT_ID
                        FROM
                            ACCOUNT_CARD_ROWS ACR,
                            ACCOUNT_CARD AC
                        WHERE
                            ACR.CARD_ID = AC.CARD_ID
                            <cfif GET_CARD_IDS.recordcount>
                            	AND ACR.CARD_ID IN (#ValueList(GET_CARD_IDS.CARD_ID)#)
                            <cfelse>
                           		AND ACR.CARD_ID < 0
                            </cfif> 
                            AND BA = 0
							<cfif isdefined("attributes.is_day_group")>
                                AND ACTION_DATE = #date_info#
                            </cfif>
						<cfif isdefined('attributes.is_account_group') and attributes.is_account_group eq 1 and (not x_is_group_debt_claim or (isdefined('attributes.is_debt_group') and attributes.is_debt_group eq 1))>
                            GROUP BY 
                                BA,
                                AMOUNT_CURRENCY,
                                AMOUNT_CURRENCY_2,
                                OTHER_CURRENCY,
                                ACCOUNT_ID,
                                <cfif session.ep.our_company_info.is_ifrs eq 1>
                                ACCOUNT_CODE2,
                                IFRS_CODE,
                                </cfif>
                                DETAIL,
                                ACC_DEPARTMENT_ID,
                                ACC_BRANCH_ID,
                                ACC_PROJECT_ID
                        </cfif>	
                        
                        UNION ALL
                        
                        <!--- alacak --->
                        SELECT 
							<cfif isdefined('attributes.is_account_group') and attributes.is_account_group eq 1 and (not x_is_group_debt_claim or (isdefined('attributes.is_claim_group') and attributes.is_claim_group eq 1))>
                                SUM(AMOUNT) AMOUNT,
                                SUM(AMOUNT_2) AMOUNT_2,
                                SUM(OTHER_AMOUNT) OTHER_AMOUNT,
                                SUM(QUANTITY) QUANTITY,
                                '' AS DETAIL,
                                '' AS PAPER_NO,
                                0 AS ACTION_ID,
                                0 AS ACTION_TYPE,
                            <cfelse>
                                AMOUNT,
                                AMOUNT_2,
                                OTHER_AMOUNT,
                                QUANTITY,
                                DETAIL, <!--- hesap bazında gruplama da satır bazlı acıklama alınmıyor --->
                                PAPER_NO,
                                ACTION_ID,
                                ACTION_TYPE,                    
                        	</cfif>	
							<cfif session.ep.our_company_info.is_ifrs eq 1>
                                ACCOUNT_CODE2,
                                IFRS_CODE,
                            </cfif>
                            AMOUNT_CURRENCY,
                            AMOUNT_CURRENCY_2,
                            OTHER_CURRENCY,
                            ACCOUNT_ID,
                            BA,
                            ACC_DEPARTMENT_ID,
                            ACC_BRANCH_ID,
                            ACC_PROJECT_ID
                        FROM 
                            ACCOUNT_CARD_ROWS ACR,
                            ACCOUNT_CARD AC
                        WHERE
                        	ACR.CARD_ID = AC.CARD_ID
							<cfif GET_CARD_IDS.recordcount>
                            	AND ACR.CARD_ID IN (#ValueList(GET_CARD_IDS.CARD_ID)#)
                            <cfelse>
                        		AND ACR.CARD_ID < 0
                        	</cfif>
                        	AND BA = 1
							<cfif isdefined("attributes.is_day_group")>    
                                AND ACTION_DATE = #date_info#
                            </cfif>
						<cfif isdefined('attributes.is_account_group') and attributes.is_account_group eq 1 and (not x_is_group_debt_claim or (isdefined('attributes.is_claim_group') and attributes.is_claim_group eq 1))>
                            GROUP BY 
                                BA,
                                AMOUNT_CURRENCY,
                                AMOUNT_CURRENCY_2,
                                OTHER_CURRENCY,
                                ACCOUNT_ID,
                                <cfif session.ep.our_company_info.is_ifrs eq 1>
                                ACCOUNT_CODE2,
                                IFRS_CODE,
                                </cfif>
                                DETAIL,
                                ACC_DEPARTMENT_ID,
                                ACC_BRANCH_ID,
                                ACC_PROJECT_ID
                        </cfif>	
                  	) AS TEMP 
                </cfquery>
                <cfquery name="insert_card_rows" datasource="#DSN2#">
					INSERT INTO
					ACCOUNT_CARD_ROWS
					(
						CARD_ID,
						ACCOUNT_ID,
						BA,
						AMOUNT,
						AMOUNT_CURRENCY,
						AMOUNT_2,
						AMOUNT_CURRENCY_2,
						DETAIL,
					<cfif session.ep.our_company_info.is_ifrs eq 1>
						ACCOUNT_CODE2,
						IFRS_CODE,
					</cfif>
						OTHER_AMOUNT,
						OTHER_CURRENCY,
						ROW_PAPER_NO,
						ROW_ACTION_ID,
						ROW_ACTION_TYPE_ID,
						QUANTITY,
						ACC_DEPARTMENT_ID,
						ACC_BRANCH_ID,
						ACC_PROJECT_ID
					)
					SELECT
						#get_max_acc_card_id.MAX_CARD_ID#,
						ACCOUNT_ID,
						BA,
                        AMOUNT,
                        AMOUNT_CURRENCY,
                        AMOUNT_2,
                        AMOUNT_CURRENCY_2,
                        DETAIL,
                        <cfif session.ep.our_company_info.is_ifrs eq 1>
                            ACCOUNT_CODE2,
                            IFRS_CODE,
                        </cfif>
                        OTHER_AMOUNT,
                        OTHER_CURRENCY,
                        PAPER_NO,
                        ACTION_ID,
                        ACTION_TYPE,
                        QUANTITY,
                        ACC_DEPARTMENT_ID,
                        ACC_BRANCH_ID,
                        ACC_PROJECT_ID
					FROM
                    	####get_rows_#session.ep.userid#_#kk#	
				</cfquery>
                <cfinclude template="sum_process_records.cfm">	
                	
                <cfquery datasource="#DSN2#" name="UPD_CARD">
                    DELETE FROM	ACCOUNT_CARD WHERE CARD_ID IN (#cardlist#)
                </cfquery>
				<cfif not isdefined("attributes.main_card_id")>
                    <cfquery name="del_row" datasource="#DSN2#">
                        DELETE FROM ACCOUNT_CARD_ROWS WHERE CARD_ID IN (#cardlist#)
                    </cfquery>
                </cfif>
                <cfif isdefined('attributes.is_temporary_solve') and attributes.is_temporary_solve eq 1 and isdefined('attributes.card_id') and len(attributes.card_id)>
                    <cfquery name="del_old_fis_" datasource="#dsn2#">
                        DELETE FROM ACCOUNT_CARD_SAVE_ROWS WHERE CARD_ID IN (#old_card_row_info#)
                    </cfquery>
                    <cfquery name="del_old_fis_" datasource="#dsn2#">
                        DELETE FROM ACCOUNT_CARD_SAVE WHERE NEW_CARD_ID =#attributes.card_id# AND IS_TEMPORARY_SOLVED=1
                    </cfquery>
                    <cfquery name="upd_acc_history_" datasource="#dsn2#"> <!---birleştirilmis fişin önceki history kayıtları bu yeni haline taşınır --->
                        UPDATE ACCOUNT_CARD_HISTORY SET CARD_ID = #get_max_acc_card_id.MAX_CARD_ID# WHERE CARD_ID =#attributes.card_id# AND ACTION_ID IS NULL
                    </cfquery>
                </cfif>
                <cfoutput query="get_all_cards">
                    <cfset attributes.imp_date = CreateODBCDateTime(ACTION_DATE)>
                    <cfset attributes.rec_date = CreateODBCDateTime(RECORD_DATE)>
                    <cfquery name="add_r_s" datasource="#dsn2#">
                        INSERT INTO
                        ACCOUNT_CARD_SAVE
                        (
                            CARD_ID,
                            NEW_CARD_ID,
                            ACTION_ID,
                            CARD_DETAIL,
                            ACTION_DATE,
                            CARD_TYPE,
                            CARD_CAT_ID,
                            ACTION_TYPE,
                            ACTION_CAT_ID,
                            BILL_NO,
                            IS_ACCOUNT,
                            CARD_TYPE_NO,
                            PAPER_NO,
                            IS_COMPOUND,
                            IS_ACCOUNT_GROUP,
                            IS_OTHER_CURRENCY,
                            IS_RATE_DIFF,
                            ACTION_TABLE,
                            RECORD_IP,
                            RECORD_DATE,
                        <cfif len(RECORD_EMP)>
                            RECORD_EMP_OLD,
                        <cfelseif len(RECORD_PAR)>
                            RECORD_PAR_OLD,
                        </cfif>
                            RECORD_IP_OLD,
                            RECORD_DATE_OLD,
                            PROCESS_DATE,
                            RECORD_EMP,
                            CARD_DOCUMENT_TYPE,
                            CARD_PAYMENT_METHOD
                        )
                        VALUES
                        (
                            #CARD_ID#,
                            #get_max_acc_card_id.MAX_CARD_ID#,
                            <cfif len(ACTION_ID) and ACTION_ID neq 0>#ACTION_ID#<cfelse>NULL</cfif>,
                            '#CARD_DETAIL#',
                            #attributes.imp_date#,
                            #CARD_TYPE#,
                            #CARD_CAT_ID#,
                            <cfif len(ACTION_TYPE) and ACTION_TYPE neq 0>#ACTION_TYPE#<cfelse>NULL</cfif>,
                            <cfif len(ACTION_CAT_ID)>#ACTION_CAT_ID#<cfelse>NULL</cfif>,
                            #BILL_NO#,
                            #IS_ACCOUNT#,
                            #CARD_TYPE_NO#,
                            '#PAPER_NO#',
                            <cfif len(IS_COMPOUND)>#IS_COMPOUND#<cfelse>NULL</cfif>,
                            <cfif isDefined("attributes.is_account_group")>1<cfelse>0</cfif>,
                            <cfif len(IS_OTHER_CURRENCY)>#IS_OTHER_CURRENCY#<cfelse>NULL</cfif>,
                            <cfif len(IS_RATE_DIFF)>#IS_RATE_DIFF#<cfelse>0</cfif>,
                            <cfif len(ACTION_TABLE)>'#ACTION_TABLE#'<cfelse>NULL</cfif>,
                            '#CGI.REMOTE_ADDR#',
                            #NOW()#,
                            <cfif len(RECORD_EMP)>#RECORD_EMP#,<cfelseif len(RECORD_PAR)>#RECORD_PAR#,</cfif>
                            '#RECORD_IP#',
                            #attributes.rec_date#,
                            <cfif len(attributes.process_date)>#date_info#<cfelse>NULL</cfif>,
                            #SESSION.EP.USERID#,
                            <cfif len(CARD_DOCUMENT_TYPE)>'#CARD_DOCUMENT_TYPE#'<cfelse>NULL</cfif>,
                            <cfif len(CARD_PAYMENT_METHOD)>'#CARD_PAYMENT_METHOD#'<cfelse>NULL</cfif>
                        )
                    </cfquery>
                    <cfset my_cur_id = get_all_cards.currentrow>
                    <cfquery name="GET_CARD_ID_ROWS_PR" dbtype="query">
                        SELECT * FROM GET_CARD_ID_ROWS WHERE CARD_ID = #CARD_ID#
                    </cfquery>
                    <cfloop query="GET_CARD_ID_ROWS_PR">
                        <cfquery name="add_r_s" datasource="#dsn2#">
                            INSERT INTO
                                ACCOUNT_CARD_SAVE_ROWS
                                (
                                    CARD_ID,
                                    ACCOUNT_ID,
                                    BA,
                                    AMOUNT,
                                    AMOUNT_CURRENCY,
                                    AMOUNT_2,
                                    AMOUNT_CURRENCY_2,
                                    IS_RATE_DIFF_ROW,
                                <cfif session.ep.our_company_info.is_ifrs eq 1>
                                    ACCOUNT_CODE2,
                                    IFRS_CODE,
                                </cfif>
                                    OTHER_AMOUNT,
                                    OTHER_CURRENCY,
                                    DETAIL,
                                    ACC_DEPARTMENT_ID,
                                    ACC_BRANCH_ID,
                                    ACC_PROJECT_ID,
                                    QUANTITY
                                )
                                VALUES
                                (
                                    #get_all_cards.CARD_ID[my_cur_id]#,
                                    '#ACCOUNT_ID#',
                                    #BA#,
                                    #AMOUNT#,
                                    '#AMOUNT_CURRENCY#',
                                    <cfif len(AMOUNT_2)>#AMOUNT_2#<cfelse>NULL</cfif>,
                                    <cfif len(AMOUNT_CURRENCY_2)>'#AMOUNT_CURRENCY_2#'<cfelse>NULL</cfif>,
                                    <cfif len(IS_RATE_DIFF_ROW)>#IS_RATE_DIFF_ROW#<cfelse>0</cfif>,
                                <cfif session.ep.our_company_info.is_ifrs eq 1>
                                    <cfif len(ACCOUNT_CODE2)>'#ACCOUNT_CODE2#'<cfelse>NULL</cfif>,
                                    <cfif len(IFRS_CODE)>'#IFRS_CODE#'<cfelse>NULL</cfif>,
                                </cfif>
                                    <cfif len(OTHER_AMOUNT)>#OTHER_AMOUNT#<cfelse>NULL</cfif>,
                                    <cfif len(OTHER_CURRENCY)>'#OTHER_CURRENCY#'<cfelse>NULL</cfif>,
                                    '#DETAIL#',
                                    <cfif len(ACC_DEPARTMENT_ID)>#ACC_DEPARTMENT_ID#<cfelse>NULL</cfif>,
                                    <cfif len(ACC_BRANCH_ID)>#ACC_BRANCH_ID#<cfelse>NULL</cfif>,
                                    <cfif len(ACC_PROJECT_ID)>#ACC_PROJECT_ID#<cfelse>NULL</cfif>,
                                    <cfif len(QUANTITY)>#QUANTITY#<cfelse>NULL</cfif>
                                )
                        </cfquery>
                    </cfloop>
                </cfoutput>
                <cfquery name="upd_bills" datasource="#dsn2#">
                    UPDATE BILLS SET
                        #alan_adi# = #islem_tip_bill_no+1#,
                        BILL_NO = BILL_NO+1
                </cfquery>				
			</cfif>
		</cfloop>
		</cftransaction>
	</cflock>
</cfif>

<cfif isdefined("attributes.x_open_add_page") and attributes.x_open_add_page eq 1>
	<script type="text/javascript">
		window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=account.popup_add_sum_bills';
	</script>	
<cfelse>
	<cfif isdefined("attributes.main_card_id")>
		<script type="text/javascript">
			window.opener.location.href='<cfoutput>#request.self#?fuseaction=account.popup_list_card_rows&card_id=#attributes.main_card_id#</cfoutput>';
			window.close();
		</script>	
	<cfelse>	
		<script type="text/javascript">
			window.open('<cfoutput>#request.self#?fuseaction=account.popup_list_card_rows&card_id=#get_max_acc_card_id.MAX_CARD_ID#</cfoutput>','page');
			wrk_opener_reload();	
			window.close();
		</script>	
	</cfif>
</cfif>
