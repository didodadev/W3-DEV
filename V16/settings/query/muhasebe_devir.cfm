<cfsetting showdebugoutput="no">
<cfif isDefined('attributes.is_from_donem')>
	<cfset attributes.is_from_donem = 1>
<cfelse>
	<cfset attributes.is_from_donem = 0>
</cfif>
<cfquery name="get_period" datasource="#dsn#">
	SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = #attributes.period#
</cfquery>
<cfif get_period.recordcount>
	<cfset islem_tarihi = CreateDateTime(get_period.PERIOD_YEAR+1,1,1,0,0,0)>
    <cfif attributes.is_from_donem>
		<cfset muhasebe_db = '#dsn#_#get_period.PERIOD_YEAR+1#_#get_period.OUR_COMPANY_ID#'>
    <cfelse>
   		<cfset muhasebe_db = '#dsn#_#get_period.PERIOD_YEAR#_#get_period.OUR_COMPANY_ID#'>
    </cfif> 
    <!--- e-defter islem kontrolu SP yapilacak FA --->
	<cfif session.ep.our_company_info.is_edefter eq 1>
        <cfstoredproc procedure="GET_NETBOOK" datasource="#muhasebe_db#">
        	<cfprocparam cfsqltype="cf_sql_timestamp" value="#islem_tarihi#">
            <cfprocparam cfsqltype="cf_sql_timestamp" value="#islem_tarihi#">
            <cfprocparam cfsqltype="cf_sql_varchar" value="">
            <cfprocresult name="getNetbook">
        </cfstoredproc>
        <cfif getNetbook.recordcount>
            <script language="javascript">
                alert('Muhasebeci : İşlemi yapamazsınız. İşlem tarihine ait e-defter bulunmaktadır.');
                history.back();
            </script>
            <cfabort>
        </cfif>
    </cfif>
    <!--- e-defter islem kontrolu SP yapilacak FA --->
    
	<cfif attributes.is_from_donem><!--- donemden acilis --->
		<cfquery name="control_get_period" datasource="#dsn#">
			SELECT * FROM SETUP_PERIOD WHERE PERIOD_YEAR = #(get_period.PERIOD_YEAR+1)# AND OUR_COMPANY_ID=#get_period.OUR_COMPANY_ID#
		</cfquery>
		<cfif not control_get_period.recordcount>
			<script type="text/javascript">
				alert('Aktarım Yapılacak Dönem Tanımlı Değil!');
				history.back();
			</script>
			<cfabort>
		</cfif>
		<cfset muhasebe_db_eski = '#dsn#_#get_period.PERIOD_YEAR#_#get_period.OUR_COMPANY_ID#'>
		<cfquery name="control_bill_no" datasource="#muhasebe_db#">
			SELECT * FROM BILLS
		</cfquery>
		<cfif not control_bill_no.recordcount>
			<font color="##FF0000">
				<a href="<cfoutput>#request.self#?fuseaction=account.bill_no</cfoutput>" class="tableyazi"><cf_get_lang_main no='1616.Lütfen Muhasebe Fiş Numaralarını Düzenleyiniz'></a>
			</font>
			<cfabort>
		</cfif>
		<cfset new_dsn3_ = '#dsn#_#get_period.OUR_COMPANY_ID#'>
		<cfquery name="CONTROL_ACC_CARD_PROCESS_" datasource="#new_dsn3_#"> <!---fiş türüne ait default olarak tanımlanmış işlem kategorisi bulunuyor --->
			SELECT
				PROCESS_CAT_ID,
                PROCESS_CAT,
				PROCESS_TYPE,
                DOCUMENT_TYPE,
                PAYMENT_TYPE
			FROM
				SETUP_PROCESS_CAT
			WHERE
				PROCESS_TYPE=10
				AND IS_DEFAULT=1		
		</cfquery>
		<cfif not len(CONTROL_ACC_CARD_PROCESS_.PROCESS_CAT_ID)>
			<script type="text/javascript">
				alert('Açılış Fişi Tanımı Yapılmamış.\n İşlem Kategorileri Bölümünde Fiş Tanımlarınızı Yapınız!');
				history.back();
			</script>
			<cfabort>
		</cfif>
		<cftry>
			<cfif isdefined('attributes.is_other_money') and attributes.is_other_money eq 1>
				<cfquery name="get_period_money" datasource="#muhasebe_db_eski#">
					SELECT MONEY AS PERIOD_MONEY FROM SETUP_MONEY WHERE RATE1=1 AND RATE2=1 AND MONEY_STATUS=1
				</cfquery>
				<cfif get_period_money.recordcount>
					<cfset temp_other_money=get_period_money.PERIOD_MONEY>
				<cfelse>
					<cfset temp_other_money=session.ep.money>
				</cfif>
				<cfquery name="get_bakiye" datasource="#muhasebe_db_eski#">
					SELECT
						A2.ACCOUNT_CODE, 
						A2.BAKIYE,
						A2.BORC,
						A2.ALACAK,
						A2.BAKIYE2, 
						A2.BORC2,
						A2.ALACAK2,
						A2.BAKIYE3, 
						A2.BORC3,
						A2.ALACAK3,
						A2.OTHER_MONEY
						<cfif isdefined('attributes.is_branch') and attributes.is_branch eq 1>
							,A2.ACC_BRANCH_ID
						</cfif>
						<cfif isdefined('attributes.is_department') and attributes.is_department eq 1>
							,A2.ACC_DEPARTMENT_ID
						</cfif>
						<cfif isdefined('attributes.is_project') and attributes.is_project eq 1>
							,A2.ACC_PROJECT_ID
						</cfif>		
					FROM	
					(
						SELECT
							SUM(ACC_M.BORC - ACC_M.ALACAK) AS BAKIYE, 
							SUM(ACC_M.BORC) AS BORC,
							SUM(ACC_M.ALACAK) AS ALACAK, 
							SUM(ACC_M.BORC_2 - ACC_M.ALACAK_2) AS BAKIYE2, 
							SUM(ACC_M.BORC_2) AS BORC2,
							SUM(ACC_M.ALACAK_2) AS ALACAK2,
							SUM(ACC_M.BORC_3 - ACC_M.ALACAK_3) AS BAKIYE3, 
							SUM(ACC_M.BORC_3) AS BORC3,
							SUM(ACC_M.ALACAK_3) AS ALACAK3,
							ACCOUNT_PLAN.ACCOUNT_CODE,
							ISNULL(ACC_M.OTHER_MONEY,'#temp_other_money#') AS OTHER_MONEY
							<cfif isdefined('attributes.is_branch') and attributes.is_branch eq 1>
								,ACC_M.ACC_BRANCH_ID
							</cfif>
							<cfif isdefined('attributes.is_department') and attributes.is_department eq 1>
								,ACC_M.ACC_DEPARTMENT_ID
							</cfif>
							<cfif isdefined('attributes.is_project') and attributes.is_project eq 1>
								,ACC_M.ACC_PROJECT_ID
							</cfif>							
						FROM
							ACCOUNT_PLAN,
							(
								SELECT
									0 AS ALACAK,
									SUM(ACCOUNT_CARD_ROWS.AMOUNT) AS BORC,	
									0 AS ALACAK_2,
									SUM(ISNULL(ACCOUNT_CARD_ROWS.AMOUNT_2,0)) AS BORC_2,	
									0 AS ALACAK_3,
									SUM(ISNULL(ACCOUNT_CARD_ROWS.OTHER_AMOUNT,0)) AS BORC_3
									<cfif isdefined('attributes.is_other_money') and attributes.is_other_money eq 1>
										,ACCOUNT_CARD_ROWS.OTHER_CURRENCY AS OTHER_MONEY
									</cfif>
									<cfif isdefined('attributes.is_branch') and attributes.is_branch eq 1>
										,ISNULL(ACCOUNT_CARD_ROWS.ACC_BRANCH_ID,0) ACC_BRANCH_ID
									</cfif>
									<cfif isdefined('attributes.is_department') and attributes.is_department eq 1>
										,ISNULL(ACCOUNT_CARD_ROWS.ACC_DEPARTMENT_ID,0) ACC_DEPARTMENT_ID
									</cfif>
									<cfif isdefined('attributes.is_project') and attributes.is_project eq 1>
										,ISNULL(ACCOUNT_CARD_ROWS.ACC_PROJECT_ID,0) ACC_PROJECT_ID
									</cfif>
									,ACCOUNT_CARD_ROWS.ACCOUNT_ID
									,ACCOUNT_CARD.ACTION_DATE
									,ACCOUNT_CARD.CARD_TYPE
									,ACCOUNT_CARD.CARD_CAT_ID
								FROM
									ACCOUNT_CARD_ROWS,ACCOUNT_CARD
								WHERE
									BA = 0 AND 
                                    ACCOUNT_CARD.CARD_ID = ACCOUNT_CARD_ROWS.CARD_ID
                                    <cfif isdefined('attributes.acc_code_1') and len(attributes.acc_code_1)>AND ACCOUNT_CARD_ROWS.ACCOUNT_ID >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.acc_code_1#"></cfif>
                					<cfif isdefined('attributes.acc_code_2') and len(attributes.acc_code_2)>AND ACCOUNT_CARD_ROWS.ACCOUNT_ID <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.acc_code_2#"></cfif>
								GROUP BY
									ACCOUNT_CARD_ROWS.ACCOUNT_ID,
									ACCOUNT_CARD.ACTION_DATE,
									ACCOUNT_CARD.CARD_TYPE,
									ACCOUNT_CARD.CARD_CAT_ID
									<cfif isdefined('attributes.is_other_money') and attributes.is_other_money eq 1>
										,ACCOUNT_CARD_ROWS.OTHER_CURRENCY
									</cfif>
									<cfif isdefined('attributes.is_branch') and attributes.is_branch eq 1>
										,ISNULL(ACCOUNT_CARD_ROWS.ACC_BRANCH_ID,0)
									</cfif>
									<cfif isdefined('attributes.is_department') and attributes.is_department eq 1>
										,ISNULL(ACCOUNT_CARD_ROWS.ACC_DEPARTMENT_ID,0)
									</cfif>
									<cfif isdefined('attributes.is_project') and attributes.is_project eq 1>
										,ISNULL(ACCOUNT_CARD_ROWS.ACC_PROJECT_ID,0)
									</cfif>
								UNION
								SELECT
									SUM(ACCOUNT_CARD_ROWS.AMOUNT)AS ALACAK,
									0 AS BORC,	
									SUM(ISNULL(ACCOUNT_CARD_ROWS.AMOUNT_2,0))AS ALACAK_2,
									0 AS BORC_2,	
									SUM(ISNULL(ACCOUNT_CARD_ROWS.OTHER_AMOUNT,0))AS ALACAK_3,
									0 AS BORC_3
									<cfif isdefined('attributes.is_other_money') and attributes.is_other_money eq 1>
										,ACCOUNT_CARD_ROWS.OTHER_CURRENCY AS OTHER_MONEY
									</cfif>
									<cfif isdefined('attributes.is_branch') and attributes.is_branch eq 1>
										,ISNULL(ACCOUNT_CARD_ROWS.ACC_BRANCH_ID,0) ACC_BRANCH_ID
									</cfif>
									<cfif isdefined('attributes.is_department') and attributes.is_department eq 1>
										,ISNULL(ACCOUNT_CARD_ROWS.ACC_DEPARTMENT_ID,0) ACC_DEPARTMENT_ID
									</cfif>
									<cfif isdefined('attributes.is_project') and attributes.is_project eq 1>
										,ISNULL(ACCOUNT_CARD_ROWS.ACC_PROJECT_ID,0) ACC_PROJECT_ID
									</cfif>
									,ACCOUNT_CARD_ROWS.ACCOUNT_ID
									,ACCOUNT_CARD.ACTION_DATE
									,ACCOUNT_CARD.CARD_TYPE
									,ACCOUNT_CARD.CARD_CAT_ID
								FROM
									ACCOUNT_CARD_ROWS,
									ACCOUNT_CARD
								WHERE
									BA = 1 AND 
                                    ACCOUNT_CARD.CARD_ID = ACCOUNT_CARD_ROWS.CARD_ID
                                    <cfif isdefined('attributes.acc_code_1') and len(attributes.acc_code_1)>AND ACCOUNT_CARD_ROWS.ACCOUNT_ID >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.acc_code_1#"></cfif>
                					<cfif isdefined('attributes.acc_code_2') and len(attributes.acc_code_2)>AND ACCOUNT_CARD_ROWS.ACCOUNT_ID <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.acc_code_2#"></cfif>
								GROUP BY
									ACCOUNT_CARD_ROWS.ACCOUNT_ID,
									ACCOUNT_CARD.ACTION_DATE,
									ACCOUNT_CARD.CARD_TYPE,
									ACCOUNT_CARD.CARD_CAT_ID
									<cfif isdefined('attributes.is_other_money') and attributes.is_other_money eq 1>
										,ACCOUNT_CARD_ROWS.OTHER_CURRENCY
									</cfif>
									<cfif isdefined('attributes.is_branch') and attributes.is_branch eq 1>
										,ISNULL(ACCOUNT_CARD_ROWS.ACC_BRANCH_ID,0)
									</cfif>
									<cfif isdefined('attributes.is_department') and attributes.is_department eq 1>
										,ISNULL(ACCOUNT_CARD_ROWS.ACC_DEPARTMENT_ID,0)
									</cfif>
									<cfif isdefined('attributes.is_project') and attributes.is_project eq 1>
										,ISNULL(ACCOUNT_CARD_ROWS.ACC_PROJECT_ID,0)
									</cfif>
							)
							ACC_M
						WHERE
							ACCOUNT_PLAN.SUB_ACCOUNT=0 
							AND ACC_M.ACCOUNT_ID = ACCOUNT_PLAN.ACCOUNT_CODE
							AND	ACC_M.CARD_TYPE <> 19<!--- Kapanış fişleri gelmesin --->							
							<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)>
								AND	ACC_M.CARD_CAT_ID IN (#attributes.acc_card_type#)
							</cfif>			
						GROUP BY
							ACCOUNT_PLAN.ACCOUNT_CODE,
							ISNULL(ACC_M.OTHER_MONEY,'#temp_other_money#')
							<cfif isdefined('attributes.is_branch') and attributes.is_branch eq 1>
								,ACC_M.ACC_BRANCH_ID
							</cfif>
							<cfif isdefined('attributes.is_department') and attributes.is_department eq 1>
								,ACC_M.ACC_DEPARTMENT_ID
							</cfif>
							<cfif isdefined('attributes.is_project') and attributes.is_project eq 1>
								,ACC_M.ACC_PROJECT_ID
							</cfif>
					) AS A2
					WHERE
						round(A2.BAKIYE,2) <> 0
				</cfquery>
			<cfelse>
				<cfquery name="get_bakiye" datasource="#muhasebe_db_eski#">
					SELECT
						A1.ACCOUNT_CODE, 
						A1.BAKIYE,
						A1.BORC,
						A1.ALACAK,
						A1.BAKIYE_2 AS BAKIYE2, 
						A1.BORC_2 AS BORC2,
						A1.ALACAK_2 AS ALACAK2
						<cfif isdefined('attributes.is_branch') and attributes.is_branch eq 1>
							,A1.ACC_BRANCH_ID
						</cfif>
						<cfif isdefined('attributes.is_department') and attributes.is_department eq 1>
							,A1.ACC_DEPARTMENT_ID
						</cfif>
						<cfif isdefined('attributes.is_project') and attributes.is_project eq 1>
							,A1.ACC_PROJECT_ID
						</cfif>	
					FROM
					(
						SELECT
							SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC - ACCOUNT_ACCOUNT_REMAINDER.ALACAK) AS BAKIYE, 
							SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC) AS BORC,
							SUM(ACCOUNT_ACCOUNT_REMAINDER.ALACAK) AS ALACAK, 
							SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC_2 - ACCOUNT_ACCOUNT_REMAINDER.ALACAK_2) AS BAKIYE_2, 
							SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC_2) AS BORC_2,
							SUM(ACCOUNT_ACCOUNT_REMAINDER.ALACAK_2) AS ALACAK_2, 
							ACCOUNT_PLAN.ACCOUNT_CODE
							<cfif isdefined('attributes.is_branch') and attributes.is_branch eq 1>
								,ACCOUNT_ACCOUNT_REMAINDER.ACC_BRANCH_ID
							</cfif>
							<cfif isdefined('attributes.is_department') and attributes.is_department eq 1>
								,ACCOUNT_ACCOUNT_REMAINDER.ACC_DEPARTMENT_ID
							</cfif>
							<cfif isdefined('attributes.is_project') and attributes.is_project eq 1>
								,ACCOUNT_ACCOUNT_REMAINDER.ACC_PROJECT_ID
							</cfif>		
						FROM
							ACCOUNT_PLAN,
							(
								SELECT
									0 AS ALACAK,
									SUM(ACCOUNT_CARD_ROWS.AMOUNT) AS BORC,	
									0 AS ALACAK_2,
									SUM(ISNULL(ACCOUNT_CARD_ROWS.AMOUNT_2,0)) AS BORC_2,	
									0 AS ALACAK_3,
									SUM(ISNULL(ACCOUNT_CARD_ROWS.OTHER_AMOUNT,0)) AS BORC_3,
									<cfif isdefined('attributes.is_other_money') and attributes.is_other_money eq 1>
										ACCOUNT_CARD_ROWS.OTHER_CURRENCY AS OTHER_MONEY,
									</cfif>
									<cfif isdefined('attributes.is_branch') and attributes.is_branch eq 1>
										ISNULL(ACCOUNT_CARD_ROWS.ACC_BRANCH_ID,0) ACC_BRANCH_ID,
									</cfif>
									<cfif isdefined('attributes.is_department') and attributes.is_department eq 1>
										ISNULL(ACCOUNT_CARD_ROWS.ACC_DEPARTMENT_ID,0) ACC_DEPARTMENT_ID,
									</cfif>
									<cfif isdefined('attributes.is_project') and attributes.is_project eq 1>
										ISNULL(ACCOUNT_CARD_ROWS.ACC_PROJECT_ID,0) ACC_PROJECT_ID,
									</cfif>
									ACCOUNT_CARD_ROWS.ACCOUNT_ID,
									ACCOUNT_CARD.ACTION_DATE,
									ACCOUNT_CARD.CARD_TYPE,
									ACCOUNT_CARD.CARD_CAT_ID
								FROM
									ACCOUNT_CARD_ROWS,ACCOUNT_CARD
								WHERE
									BA = 0 AND 
                                    ACCOUNT_CARD.CARD_ID = ACCOUNT_CARD_ROWS.CARD_ID
                                    <cfif isdefined('attributes.acc_code_1') and len(attributes.acc_code_1)>AND ACCOUNT_CARD_ROWS.ACCOUNT_ID >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.acc_code_1#"></cfif>
                					<cfif isdefined('attributes.acc_code_2') and len(attributes.acc_code_2)>AND ACCOUNT_CARD_ROWS.ACCOUNT_ID <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.acc_code_2#"></cfif>
								GROUP BY
									ACCOUNT_CARD_ROWS.ACCOUNT_ID,
									ACCOUNT_CARD.ACTION_DATE,
									ACCOUNT_CARD.CARD_TYPE,
									ACCOUNT_CARD.CARD_CAT_ID
									<cfif isdefined('attributes.is_other_money') and attributes.is_other_money eq 1>
										,ACCOUNT_CARD_ROWS.OTHER_CURRENCY
									</cfif>
									<cfif isdefined('attributes.is_branch') and attributes.is_branch eq 1>
										,ISNULL(ACCOUNT_CARD_ROWS.ACC_BRANCH_ID,0)
									</cfif>
									<cfif isdefined('attributes.is_department') and attributes.is_department eq 1>
										,ISNULL(ACCOUNT_CARD_ROWS.ACC_DEPARTMENT_ID,0)
									</cfif>
									<cfif isdefined('attributes.is_project') and attributes.is_project eq 1>
										,ISNULL(ACCOUNT_CARD_ROWS.ACC_PROJECT_ID,0)
									</cfif>
								UNION
								SELECT
									SUM(ACCOUNT_CARD_ROWS.AMOUNT)AS ALACAK,
									0 AS BORC,	
									SUM(ISNULL(ACCOUNT_CARD_ROWS.AMOUNT_2,0))AS ALACAK_2,
									0 AS BORC_2,	
									SUM(ISNULL(ACCOUNT_CARD_ROWS.OTHER_AMOUNT,0))AS ALACAK_3,
									0 AS BORC_3,
									<cfif isdefined('attributes.is_branch') and attributes.is_branch eq 1>
										ISNULL(ACCOUNT_CARD_ROWS.ACC_BRANCH_ID,0) ACC_BRANCH_ID,
									</cfif>
									<cfif isdefined('attributes.is_department') and attributes.is_department eq 1>
										ISNULL(ACCOUNT_CARD_ROWS.ACC_DEPARTMENT_ID,0) ACC_DEPARTMENT_ID,
									</cfif>
									<cfif isdefined('attributes.is_project') and attributes.is_project eq 1>
										ISNULL(ACCOUNT_CARD_ROWS.ACC_PROJECT_ID,0) ACC_PROJECT_ID,
									</cfif>
									ACCOUNT_CARD_ROWS.ACCOUNT_ID,
									ACCOUNT_CARD.ACTION_DATE,
									ACCOUNT_CARD.CARD_TYPE,
									ACCOUNT_CARD.CARD_CAT_ID
								FROM
									ACCOUNT_CARD_ROWS,
									ACCOUNT_CARD
								WHERE
									BA = 1 AND 
                                    ACCOUNT_CARD.CARD_ID=ACCOUNT_CARD_ROWS.CARD_ID
                                    <cfif isdefined('attributes.acc_code_1') and len(attributes.acc_code_1)>AND ACCOUNT_CARD_ROWS.ACCOUNT_ID >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.acc_code_1#"></cfif>
                					<cfif isdefined('attributes.acc_code_2') and len(attributes.acc_code_2)>AND ACCOUNT_CARD_ROWS.ACCOUNT_ID <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.acc_code_2#"></cfif>
								GROUP BY
									ACCOUNT_CARD_ROWS.ACCOUNT_ID,
									ACCOUNT_CARD.ACTION_DATE,
									ACCOUNT_CARD.CARD_TYPE,
									ACCOUNT_CARD.CARD_CAT_ID
									<cfif isdefined('attributes.is_branch') and attributes.is_branch eq 1>
										,ISNULL(ACCOUNT_CARD_ROWS.ACC_BRANCH_ID,0)
									</cfif>
									<cfif isdefined('attributes.is_department') and attributes.is_department eq 1>
										,ISNULL(ACCOUNT_CARD_ROWS.ACC_DEPARTMENT_ID,0)
									</cfif>
									<cfif isdefined('attributes.is_project') and attributes.is_project eq 1>
										,ISNULL(ACCOUNT_CARD_ROWS.ACC_PROJECT_ID,0)
									</cfif>
							)
							ACCOUNT_ACCOUNT_REMAINDER
						WHERE
							ACCOUNT_PLAN.SUB_ACCOUNT=0 
							AND ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID = ACCOUNT_PLAN.ACCOUNT_CODE	
							AND	ACCOUNT_ACCOUNT_REMAINDER.CARD_TYPE <> 19<!--- Kapanış fişleri gelmesin --->			
						<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)>
							AND	ACCOUNT_ACCOUNT_REMAINDER.CARD_CAT_ID IN (#attributes.acc_card_type#)
						</cfif>			
						GROUP BY
							ACCOUNT_PLAN.ACCOUNT_CODE
							<cfif isdefined('attributes.is_branch') and attributes.is_branch eq 1>
								,ACCOUNT_ACCOUNT_REMAINDER.ACC_BRANCH_ID
							</cfif>
							<cfif isdefined('attributes.is_department') and attributes.is_department eq 1>
								,ACCOUNT_ACCOUNT_REMAINDER.ACC_DEPARTMENT_ID
							</cfif>
							<cfif isdefined('attributes.is_project') and attributes.is_project eq 1>
								,ACCOUNT_ACCOUNT_REMAINDER.ACC_PROJECT_ID
							</cfif>	
					) AS A1
					WHERE
						round(A1.BAKIYE,2) <> 0
				</cfquery>
			</cfif>
			<cfcatch>
				<cfset islem_ok_flag = false>
			</cfcatch>
		</cftry>
	<cfelse><!--- dosyadan acilis --->
		<cfset muhasebe_db = '#dsn#_#get_period.PERIOD_YEAR#_#get_period.OUR_COMPANY_ID#'>
		<cfset new_dsn3__ = '#dsn#_#get_period.OUR_COMPANY_ID#'>
		<cfquery name="CONTROL_ACC_CARD_PROCESS_" datasource="#new_dsn3__#"> <!---fiş türüne ait default olarak tanımlanmış işlem kategorisi bulunuyor --->
			SELECT
				PROCESS_CAT_ID,
                PROCESS_CAT,
				PROCESS_TYPE,
                DOCUMENT_TYPE,
                PAYMENT_TYPE
			FROM
				SETUP_PROCESS_CAT
			WHERE
				PROCESS_TYPE=10
				AND IS_DEFAULT=1		
		</cfquery>
		<cfif not len(CONTROL_ACC_CARD_PROCESS_.PROCESS_CAT_ID)>
			<script type="text/javascript">
				alert('Açılış Fişi Tanımı Yapılmamış.\n İşlem Kategorileri Bölümünde Fiş Tanımlarınızı Yapınız!');
				history.back();
			</script>
			<cfabort>
		</cfif>
		<cfset islem_tarihi = CreateDateTime(get_period.PERIOD_YEAR,1,1,0,0,0)>
		<cfset upload_folder = "#upload_folder#settings#dir_seperator#">
		<cfif isdefined("attributes.muhasebe_file") and len(attributes.muhasebe_file)>		
			<cftry>
				<cffile action="upload" filefield="muhasebe_file" destination="#upload_folder#" nameconflict="MakeUnique" mode="777">
				<cfcatch>
					<script type="text/javascript">
						alert("<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz '>!");
						history.back();
					</script>
					<cfabort>
				</cfcatch>  
			</cftry>
			<cfset file_name = "#createUUID()#.#cffile.serverfileext#">
			<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#">
			<cffile action="read" file="#upload_folder##file_name#" variable="dosya">
			<cfscript>
				CRLF = Chr(13) & Chr(10);
				dosya = ListToArray(dosya,CRLF);
				line_count = ArrayLen(dosya);
			</cfscript>
		<cfelse>
			<cfset islem_ok_flag = false>
		</cfif>
	</cfif>
	<cfset islem_ok_flag = true>
	<cftry>
		<cfquery name="get_acc_plan" datasource="#muhasebe_db#"><!--- her halukarda islem yapilacak donem hesap planina bakilacak asagida --->
			SELECT ACCOUNT_CODE,SUB_ACCOUNT FROM ACCOUNT_PLAN WHERE SUB_ACCOUNT = 0
		</cfquery>
		<cfquery name="get_money_rate" datasource="#muhasebe_db#">
			SELECT (RATE2/RATE1) RATE, MONEY FROM SETUP_MONEY ORDER BY MONEY
		</cfquery>
		<!--- default acılıs fisi islem kategorisine kayıtlı fis varsa silinip yeniden olusturuluyor --->
		<cfquery name="GET_CARD_ID" datasource="#muhasebe_db#">
			SELECT CARD_ID FROM ACCOUNT_CARD WHERE CARD_TYPE = #CONTROL_ACC_CARD_PROCESS_.PROCESS_TYPE# AND CARD_CAT_ID=#CONTROL_ACC_CARD_PROCESS_.PROCESS_CAT_ID#
		</cfquery>
		<cfif GET_CARD_ID.RECORDCOUNT>
            <cflock name="#createUUID()#" timeout="20">
                <cftransaction>
                    <cfif not isdefined("is_update_old_fis") or attributes.is_from_donem eq 0>
                        <cfquery name="DEL_ACCOUNT_CARD" datasource="#muhasebe_db#">
                            DELETE FROM ACCOUNT_CARD WHERE CARD_ID=#GET_CARD_ID.CARD_ID#
                        </cfquery>
                        <cfquery name="DEL_ACCOUNT_CARD_ROWS" datasource="#muhasebe_db#">
                            DELETE FROM ACCOUNT_CARD_ROWS WHERE CARD_ID=#GET_CARD_ID.CARD_ID#
                        </cfquery>
                    <cfelse>
                        <cfquery name="DEL_ACCOUNT_CARD_ROWS" datasource="#muhasebe_db#">
                            DELETE FROM 
                            	ACCOUNT_CARD_ROWS 
                            WHERE 
                            	CARD_ID=#GET_CARD_ID.CARD_ID#
								<cfif isdefined('attributes.acc_code_1') and len(attributes.acc_code_1)>AND ACCOUNT_CARD_ROWS.ACCOUNT_ID >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.acc_code_1#"></cfif>
                                <cfif isdefined('attributes.acc_code_2') and len(attributes.acc_code_2)>AND ACCOUNT_CARD_ROWS.ACCOUNT_ID <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.acc_code_2#"></cfif>
                        </cfquery>
                    </cfif>
                </cftransaction>
            </cflock>
        </cfif>
		<cfcatch>
			<cfset islem_ok_flag = false>
		</cfcatch>
	</cftry>
<cfelse>
	<cfset islem_ok_flag = false>
</cfif>

<cfif islem_ok_flag>
	<cfif attributes.is_from_donem>
		<cfset aciklama = '#get_period.PERIOD_YEAR+1# DEVIR ISLEMI'>
	<cfelse>
		<cfset aciklama = '#get_period.PERIOD_YEAR# DEVIR ISLEMI'>
	</cfif>
	<cfquery name="GET_BILL_NO" datasource="#muhasebe_db#">
		SELECT * FROM BILLS
	</cfquery>
	<cflock name="#createUUID()#" timeout="60">
		<cftransaction>
        	<cfif isdefined("is_update_old_fis") and GET_CARD_ID.recordcount and is_from_donem eq 1>
                <cfquery name="UPD_ACCOUNT_CARD" datasource="#muhasebe_db#">
                	UPDATE
                        ACCOUNT_CARD
                    SET
                        CARD_TYPE = #CONTROL_ACC_CARD_PROCESS_.PROCESS_TYPE#,
                        CARD_CAT_ID = #CONTROL_ACC_CARD_PROCESS_.PROCESS_CAT_ID#,
                        ACTION_DATE = #islem_tarihi#,
                        CARD_DOCUMENT_TYPE = <cfif len(control_acc_card_process_.document_type)>#control_acc_card_process_.document_type#<cfelse>NULL</cfif>,
                        CARD_PAYMENT_METHOD = <cfif len(control_acc_card_process_.payment_type)>#control_acc_card_process_.payment_type#<cfelse>NULL</cfif>,
                        UPDATE_EMP = #session.ep.userid#,
                        UPDATE_IP = '#CGI.REMOTE_ADDR#',
                        UPDATE_DATE = #now()#
                   	WHERE
                    	CARD_ID = #GET_CARD_ID.CARD_ID#	
                </cfquery>
                <cfset MAX_ID.IDENTITYCOL = GET_CARD_ID.CARD_ID>
            <cfelse>
            	<cfquery name="ADD_ACCOUNT_CARD" datasource="#muhasebe_db#" result="MAX_ID">
                    INSERT INTO
                        ACCOUNT_CARD
                        (
                            CARD_DETAIL,
                            BILL_NO,
                            CARD_TYPE,
                            CARD_CAT_ID,
                            ACTION_DATE,
                            CARD_DOCUMENT_TYPE,
                    		CARD_PAYMENT_METHOD,
                            RECORD_EMP,
                            RECORD_IP,
                            RECORD_DATE
                        )
                    VALUES
                        (
                            '#aciklama#',
                            #get_bill_no.bill_no#,
                            #control_acc_card_process_.process_type#,
                            #control_acc_card_process_.process_cat_id#,
                            #islem_tarihi#,
                            <cfif len(control_acc_card_process_.document_type)>#control_acc_card_process_.document_type#<cfelse>NULL</cfif>,
                    		<cfif len(control_acc_card_process_.payment_type)>#control_acc_card_process_.payment_type#<cfelse>NULL</cfif>,
                            #session.ep.userid#,
                            '#cgi.remote_addr#',
                            #now()#
                        )
                </cfquery>
            </cfif>
			<cftry>
				<cfif attributes.is_from_donem><!--- onceki donemden yeni donemine devir --->
					<cfloop query="get_bakiye">
						<cfquery name="CONTROL_BAKIYE_" dbtype="query">
							SELECT ACCOUNT_CODE, SUM(BAKIYE) FROM get_bakiye WHERE ACCOUNT_CODE ='#get_bakiye.ACCOUNT_CODE#' <cfif isdefined('attributes.is_other_money') and attributes.is_other_money eq 1> AND OTHER_MONEY = '#get_bakiye.OTHER_MONEY#'</cfif> GROUP BY ACCOUNT_CODE HAVING SUM(BAKIYE) <> 0
						</cfquery>
						<cfif CONTROL_BAKIYE_.recordcount>
							<cfif BORC gt ALACAK>
								<cfset BA = 0>
							<cfelse>
								<cfset BA = 1>
							</cfif>
							<cfif get_period.PERIOD_YEAR eq 2004>
								<cfset tutar = round(abs(BAKIYE)/10000)/100 ><!--- YTL cevrimi --->
							<cfelse>
								<cfset tutar = abs(BAKIYE)>
							</cfif>
							<cfif tutar neq 0>
								<cfquery name="get_acc_plan_1" dbtype="query">
									SELECT ACCOUNT_CODE FROM get_acc_plan WHERE ACCOUNT_CODE = '#get_bakiye.ACCOUNT_CODE#'
								</cfquery>
								<cfif get_acc_plan_1.recordcount>
									<cfquery name="add_muhas_ac" datasource="#muhasebe_db#">
										INSERT INTO
											ACCOUNT_CARD_ROWS
											(
												CARD_ID,
												ACCOUNT_ID,
												DETAIL,
												BA,
												AMOUNT,
												AMOUNT_CURRENCY,
												AMOUNT_2,
												AMOUNT_CURRENCY_2
                                                ,OTHER_AMOUNT
                                                ,OTHER_CURRENCY
												<cfif isdefined('attributes.is_branch') and attributes.is_branch eq 1>
													,ACC_BRANCH_ID
												</cfif>
												<cfif isdefined('attributes.is_department') and attributes.is_department eq 1>
													,ACC_DEPARTMENT_ID
												</cfif>
												<cfif isdefined('attributes.is_project') and attributes.is_project eq 1>
													,ACC_PROJECT_ID
												</cfif>
											)
										VALUES
											(
												#MAX_ID.IDENTITYCOL#,
												'#get_bakiye.ACCOUNT_CODE#',
												'#aciklama#',
												#BA#,
												#wrk_round(tutar,2)#,
												<cfif (get_period.PERIOD_YEAR+1) gte 2009>'TL'<cfelse>'#session.ep.money#'</cfif>,
												<cfif len(get_bakiye.BAKIYE2)>#wrk_round(abs(get_bakiye.BAKIYE2),2)#<cfelse>NULL</cfif>,
												<cfif len(get_period.OTHER_MONEY)>'#get_period.OTHER_MONEY#'<cfelse>NULL</cfif>
												<cfif isdefined('attributes.is_other_money') and attributes.is_other_money eq 1>
													,<cfif len(get_bakiye.BAKIYE3)>#wrk_round(abs(get_bakiye.BAKIYE3),2)#<cfelse>NULL</cfif>
													<cfif len(get_bakiye.OTHER_MONEY) and get_bakiye.OTHER_MONEY eq 'YTL' and (get_period.PERIOD_YEAR+1) gte 2009>
														,'TL'
													<cfelseif len(get_bakiye.OTHER_MONEY)>
														,'#get_bakiye.OTHER_MONEY#'
													<cfelse>
														,NULL
													</cfif>
                                                <cfelse>
                                                	,#wrk_round(tutar,2)#
                                                    ,'#session.ep.money#'
												</cfif>
												<cfif isdefined('attributes.is_branch') and attributes.is_branch eq 1>
													<cfif get_bakiye.acc_branch_id neq 0>,#get_bakiye.acc_branch_id#<cfelse>,NULL</cfif>
												</cfif>
												<cfif isdefined('attributes.is_department') and attributes.is_department eq 1>
													<cfif get_bakiye.acc_department_id neq 0>,#get_bakiye.acc_department_id#<cfelse>,NULL</cfif>
												</cfif>
												<cfif isdefined('attributes.is_project') and attributes.is_project eq 1>
													<cfif get_bakiye.acc_project_id neq 0>,#get_bakiye.acc_project_id#<cfelse>,NULL</cfif>
												</cfif>
										)
									</cfquery>
								</cfif>
							</cfif>
						</cfif>
					</cfloop>
				<cfelse><!--- dosyadan doneme devir --->
					<cfset islem_kesildi = 0>
					<script type="text/javascript">
						var count = 0;
					</script>
					<cfloop from="1" to="#line_count#" index="add_muh_index">
						<script type="text/javascript">
							count = count +1;
						</script>
						<cfquery name="get_acc_plan_1" dbtype="query">
							SELECT ACCOUNT_CODE,SUB_ACCOUNT FROM get_acc_plan WHERE ACCOUNT_CODE = '#listgetat(dosya[add_muh_index],1,";")#'
						</cfquery>
						<cfif len(listgetat(dosya[add_muh_index],4,";")) and listgetat(dosya[add_muh_index],4,";") neq 0>
							<cfquery name="money_rate_1" dbtype="query">
								SELECT RATE FROM get_money_rate WHERE MONEY = '#listgetat(dosya[add_muh_index],4,";")#'
							</cfquery>
						</cfif>
						<cfif get_acc_plan_1.recordcount and listgetat(dosya[add_muh_index],3,';') neq 0 and get_acc_plan_1.SUB_ACCOUNT eq 0>
							<cfquery name="add_muhas_ac" datasource="#muhasebe_db#">
								INSERT INTO
									ACCOUNT_CARD_ROWS
									(
										CARD_ID,
										ACCOUNT_ID,
										DETAIL,
										BA,
										AMOUNT,
										AMOUNT_CURRENCY,
										AMOUNT_2,
										AMOUNT_CURRENCY_2,
										OTHER_AMOUNT,
										OTHER_CURRENCY,
										ACC_BRANCH_ID,
										ACC_DEPARTMENT_ID,
										ACC_PROJECT_ID
									)
								VALUES
									(
										#MAX_ID.IDENTITYCOL#,
										'#listgetat(dosya[add_muh_index],1,";")#',
										'#aciklama#',
										<cfif listgetat(dosya[add_muh_index],2,';') is 'B'>0<cfelse>1</cfif>,
										#wrk_round(listgetat(dosya[add_muh_index],3,';'),2)#,
										<cfif get_period.PERIOD_YEAR gte 2009>'TL',<cfelse>'#session.ep.money#',</cfif>
										<cfif len(listgetat(dosya[add_muh_index],4,";")) and listgetat(dosya[add_muh_index],4,";") neq 0>#wrk_round(listgetat(dosya[add_muh_index],3,';')/money_rate_1.rate,2)#,<cfelse>NULL,</cfif>
										<cfif len(listgetat(dosya[add_muh_index],4,";")) and listgetat(dosya[add_muh_index],4,";") neq 0>'#listgetat(dosya[add_muh_index],4,";")#',<cfelse>'#session.ep.money2#',</cfif>
										<cfif len(listgetat(dosya[add_muh_index],5,";")) and listgetat(dosya[add_muh_index],5,";") neq 0>#wrk_round(listgetat(dosya[add_muh_index],5,";"),2)#,<cfelse>NULL,</cfif>
										<cfif len(listgetat(dosya[add_muh_index],6,";")) and listgetat(dosya[add_muh_index],6,";") neq 0>'#listgetat(dosya[add_muh_index],6,";")#'<cfelse>NULL</cfif>,
										<cfif listlen(dosya[add_muh_index],';') gte 7 and len(listgetat(dosya[add_muh_index],7,";")) and listgetat(dosya[add_muh_index],7,";") neq 0>'#listgetat(dosya[add_muh_index],7,";")#'<cfelse>NULL</cfif>,
										<cfif listlen(dosya[add_muh_index],';') gte 8 and len(listgetat(dosya[add_muh_index],8,";")) and listgetat(dosya[add_muh_index],8,";") neq 0>'#listgetat(dosya[add_muh_index],8,";")#'<cfelse>NULL</cfif>,
										<cfif listlen(dosya[add_muh_index],';') gte 9 and len(listgetat(dosya[add_muh_index],9,";")) and listgetat(dosya[add_muh_index],9,";") neq 0>'#listgetat(dosya[add_muh_index],9,";")#'<cfelse>NULL</cfif>
									)
							</cfquery> 
						<cfelse>
							<cfset islem_kesildi = 1>
							<cfbreak>
						</cfif>
					</cfloop>
					<cffile action="delete" file="#upload_folder##file_name#">
					<cfif isdefined("islem_kesildi") and islem_kesildi eq 1>
						<script type="text/javascript">
							alert(count + ".Satır: Alt Hesabı Mevcuttur. Lütfen Kontrol Ediniz.");
							history.back();
						</script>
						<cfabort>
					</cfif>
				</cfif>
				<cfcatch></cfcatch>
			</cftry>
		</cftransaction>
	</cflock>
</cfif> 
<script type="text/javascript">
	alert("<cf_get_lang no ='2536.İşlem Tamamlandı'>!");
	history.back();
</script>
