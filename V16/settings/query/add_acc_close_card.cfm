<cfsetting showdebugoutput="no">
<cfset islem_ok_flag = true>
<cfquery name="get_period" datasource="#dsn#">
	SELECT 
    	PERIOD_ID, 
        PERIOD, 
        PERIOD_YEAR, 
        OUR_COMPANY_ID, 
        OTHER_MONEY, 
        RECORD_DATE, 
        RECORD_IP, 
        RECORD_EMP, 
        UPDATE_DATE, 
        UPDATE_IP, 
        UPDATE_EMP
    FROM 
    	SETUP_PERIOD 
    WHERE 
	    PERIOD_ID = #attributes.acc_period#
</cfquery>
<cfset new_dsn2 = '#dsn#_#get_period.PERIOD_YEAR#_#get_period.OUR_COMPANY_ID#'>
<cfset new_dsn3 = '#dsn#_#get_period.OUR_COMPANY_ID#'>
<cfset islem_tarihi = CreateDateTime(get_period.PERIOD_YEAR,12,31,0,0,0)>

<!--- e-defter islem kontrolu SP yapilacak FA --->
<cfif session.ep.our_company_info.is_edefter eq 1>
	<cfstoredproc procedure="GET_NETBOOK" datasource="#new_dsn2#">
        <cfprocparam cfsqltype="cf_sql_timestamp" value="#islem_tarihi#">
        <cfprocparam cfsqltype="cf_sql_timestamp" value="#islem_tarihi#">
        <cfprocparam cfsqltype="cf_sql_varchar" value="">
        <cfprocresult name="getNetbook">
    </cfstoredproc>
	<cfif getNetbook.recordcount>
		<script language="javascript">
            alert('<cf_get_lang dictionary_id='63221.Muhasebeci : İşlemi yapamazsınız. İşlem tarihine ait e-defter bulunmaktadır.'>');
			history.back();
        </script>
        <cfabort>
    </cfif>
</cfif>
<!--- e-defter islem kontrolu SP yapilacak FA --->

<cfif len(get_period.OTHER_MONEY)>
	<cfset temp_period_money_2=get_period.OTHER_MONEY>
<cfelse>
	<cfset temp_period_money_2=''>
</cfif>
<cfquery name="get_period_money" datasource="#new_dsn2#">
	SELECT MONEY AS PERIOD_MONEY FROM SETUP_MONEY WHERE RATE1=1 AND RATE2=1 AND MONEY_STATUS=1
</cfquery>
<cfset temp_period_money=get_period_money.PERIOD_MONEY>
<cfquery name="control_process_type" datasource="#new_dsn3#"> <!---işlem kategorilerinde default kapanış fişi tanımlı mı kontrol ediliyor--->
	SELECT
		PROCESS_CAT_ID,PROCESS_CAT,
		PROCESS_TYPE,DISPLAY_FILE_NAME,
		DISPLAY_FILE_FROM_TEMPLATE
	FROM
		SETUP_PROCESS_CAT
	WHERE
		PROCESS_TYPE=19
		AND IS_DEFAULT=1		
</cfquery>
<cfif not len(control_process_type.PROCESS_CAT_ID)>
	<script type="text/javascript">
		alert('<cf_get_lang dictionary_id='65403.Kapanış Fişi Tanımı Yapılmamış'>.\n <cf_get_lang dictionary_id='56845.İşlem Kategorileri Bölümünde Fiş Tanımlarınızı Yapınız'>');
		history.back();
	</script>
	<cfabort>
</cfif>
<cftry>
	<cfquery name="get_period_money" datasource="#new_dsn2#">
		SELECT MONEY AS PERIOD_MONEY FROM SETUP_MONEY WHERE RATE1=1 AND RATE2=1 AND MONEY_STATUS=1
	</cfquery>
	<cfquery name="get_alacak_bakiye" datasource="#new_dsn2#"><!--- alacak bakiye --->
		SELECT
			AP.ACCOUNT_CODE,
			AP.IFRS_CODE,
			AP.ACCOUNT_CODE2,
			round(AART.BAKIYE,2) BAKIYE,
			round(AART.BAKIYE_2,2) AS BAKIYE2
			<cfif isdefined('attributes.is_other_money') and attributes.is_other_money eq 1>
				,round(AART.BAKIYE_3,2) BAKIYE3
				,AART.OTHER_MONEY
			</cfif>
			<cfif isdefined('attributes.is_branch') and attributes.is_branch eq 1>
				,AART.ACC_BRANCH_ID
			</cfif>
			<cfif isdefined('attributes.is_department') and attributes.is_department eq 1>
				,AART.ACC_DEPARTMENT_ID
			</cfif>
			<cfif isdefined('attributes.is_project') and attributes.is_project eq 1>
				,AART.ACC_PROJECT_ID
			</cfif>
		FROM
			(
				SELECT
					ACC_M.ACCOUNT_ID AS ACCOUNT_CODE,
					SUM(ACC_M.BORC - ACC_M.ALACAK) AS BAKIYE, 
					SUM(ACC_M.BORC) AS BORC,
					SUM(ACC_M.ALACAK) AS ALACAK, 
					<cfif isdefined('attributes.is_other_money') and attributes.is_other_money eq 1>
						SUM(ACC_M.BORC2 - ACC_M.ALACAK2) AS BAKIYE_2, 
						SUM(ACC_M.BORC2) AS BORC_2,
						SUM(ACC_M.ALACAK2) AS ALACAK_2,
						SUM(ACC_M.BORC3) AS BORC3,
						SUM(ACC_M.ALACAK3) AS ALACAK3,
						SUM(ACC_M.BORC3-ACC_M.ALACAK3) AS BAKIYE_3,
						ISNULL(ACC_M.OTHER_MONEY,'#session.ep.money#') AS OTHER_MONEY
					<cfelse>
						SUM(ACC_M.BORC2 - ACC_M.ALACAK2) AS BAKIYE_2, 
						SUM(ACC_M.BORC2) AS BORC_2,
						SUM(ACC_M.ALACAK2) AS ALACAK_2
					</cfif>
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
				(
					SELECT
						0 AS ALACAK,
						SUM(ACCOUNT_CARD_ROWS.AMOUNT) AS BORC,	
						0 AS ALACAK2,
						SUM(ISNULL(ACCOUNT_CARD_ROWS.AMOUNT_2,0)) AS BORC2,	
						0 AS ALACAK3,
						SUM(ISNULL(ACCOUNT_CARD_ROWS.OTHER_AMOUNT,0)) AS BORC3,
						ACCOUNT_CARD_ROWS.ACCOUNT_ID,
						ACCOUNT_CARD.ACTION_DATE,
						ACCOUNT_CARD.CARD_TYPE,
						ACCOUNT_CARD.CARD_CAT_ID
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
						
					FROM
						ACCOUNT_CARD_ROWS,ACCOUNT_CARD
					WHERE
						BA = 0 AND ACCOUNT_CARD.CARD_ID=ACCOUNT_CARD_ROWS.CARD_ID
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
						SUM(ISNULL(ACCOUNT_CARD_ROWS.AMOUNT_2,0))AS ALACAK2,
						0 AS BORC2,	
						SUM(ISNULL(ACCOUNT_CARD_ROWS.OTHER_AMOUNT,0))AS ALACAK3,
						0 AS BORC3,
						ACCOUNT_CARD_ROWS.ACCOUNT_ID,
						ACCOUNT_CARD.ACTION_DATE,
						ACCOUNT_CARD.CARD_TYPE,
						ACCOUNT_CARD.CARD_CAT_ID
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
					FROM
						ACCOUNT_CARD_ROWS,
						ACCOUNT_CARD
					WHERE
						BA = 1 AND ACCOUNT_CARD.CARD_ID=ACCOUNT_CARD_ROWS.CARD_ID
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
				)ACC_M
				WHERE
					ACC_M.CARD_TYPE <> 19<!--- Kapanış fişleri gelmesin --->
					<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)>
						AND ACC_M.CARD_CAT_ID IN (#attributes.acc_card_type#)
					</cfif>
				GROUP BY
					ACC_M.ACCOUNT_ID
					<cfif isdefined('attributes.is_other_money') and attributes.is_other_money eq 1>
						,ISNULL(ACC_M.OTHER_MONEY,'#session.ep.money#')
					</cfif>
					<cfif isdefined('attributes.is_branch') and attributes.is_branch eq 1>
						,ACC_M.ACC_BRANCH_ID
					</cfif>
					<cfif isdefined('attributes.is_department') and attributes.is_department eq 1>
						,ACC_M.ACC_DEPARTMENT_ID
					</cfif>
					<cfif isdefined('attributes.is_project') and attributes.is_project eq 1>
						,ACC_M.ACC_PROJECT_ID
					</cfif>
			) AS AART,
			ACCOUNT_PLAN AP
		WHERE
			round(AART.BAKIYE,2) < 0 AND
			AP.ACCOUNT_CODE = AART.ACCOUNT_CODE AND
			AP.SUB_ACCOUNT = 0
	</cfquery>
	<cfquery name="get_borc_bakiye" datasource="#new_dsn2#"><!--- borc bakiye --->
		SELECT
			AP.ACCOUNT_CODE,
			AP.IFRS_CODE,
			AP.ACCOUNT_CODE2,
			round(AART.BAKIYE,2) BAKIYE,
			round(AART.BAKIYE_2,2) AS BAKIYE2
			<cfif isdefined('attributes.is_other_money') and attributes.is_other_money eq 1>
				,round(AART.BAKIYE_3,2) BAKIYE3
				,AART.OTHER_MONEY
			</cfif>
			<cfif isdefined('attributes.is_branch') and attributes.is_branch eq 1>
				,AART.ACC_BRANCH_ID
			</cfif>
			<cfif isdefined('attributes.is_department') and attributes.is_department eq 1>
				,AART.ACC_DEPARTMENT_ID
			</cfif>
			<cfif isdefined('attributes.is_project') and attributes.is_project eq 1>
				,AART.ACC_PROJECT_ID
			</cfif>
		FROM
			(
				SELECT
					ACC_M.ACCOUNT_ID AS ACCOUNT_CODE,
					SUM(ACC_M.BORC - ACC_M.ALACAK) AS BAKIYE, 
					SUM(ACC_M.BORC) AS BORC,
					SUM(ACC_M.ALACAK) AS ALACAK, 
					<cfif isdefined('attributes.is_other_money') and attributes.is_other_money eq 1>
						SUM(ACC_M.BORC2 - ACC_M.ALACAK2) AS BAKIYE_2, 
						SUM(ACC_M.BORC2) AS BORC_2,
						SUM(ACC_M.ALACAK2) AS ALACAK_2,
						SUM(ACC_M.BORC3) AS BORC3,
						SUM(ACC_M.ALACAK3) AS ALACAK3,
						SUM(ACC_M.BORC3-ACC_M.ALACAK3) AS BAKIYE_3,
						ISNULL(ACC_M.OTHER_MONEY,'#session.ep.money#') AS OTHER_MONEY
					<cfelse>
						SUM(ACC_M.BORC2 - ACC_M.ALACAK2) AS BAKIYE_2, 
						SUM(ACC_M.BORC2) AS BORC_2,
						SUM(ACC_M.ALACAK2) AS ALACAK_2
					</cfif>
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
				(
					SELECT
						0 AS ALACAK,
						SUM(ACCOUNT_CARD_ROWS.AMOUNT) AS BORC,	
						0 AS ALACAK2,
						SUM(ISNULL(ACCOUNT_CARD_ROWS.AMOUNT_2,0)) AS BORC2,	
						0 AS ALACAK3,
						SUM(ISNULL(ACCOUNT_CARD_ROWS.OTHER_AMOUNT,0)) AS BORC3,
						ACCOUNT_CARD_ROWS.ACCOUNT_ID,
						ACCOUNT_CARD.ACTION_DATE,
						ACCOUNT_CARD.CARD_TYPE,
						ACCOUNT_CARD.CARD_CAT_ID
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
					FROM
						ACCOUNT_CARD_ROWS,ACCOUNT_CARD
					WHERE
						BA = 0 AND ACCOUNT_CARD.CARD_ID=ACCOUNT_CARD_ROWS.CARD_ID
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
						SUM(ISNULL(ACCOUNT_CARD_ROWS.AMOUNT_2,0))AS ALACAK2,
						0 AS BORC2,	
						SUM(ISNULL(ACCOUNT_CARD_ROWS.OTHER_AMOUNT,0))AS ALACAK3,
						0 AS BORC3,
						ACCOUNT_CARD_ROWS.ACCOUNT_ID,
						ACCOUNT_CARD.ACTION_DATE,
						ACCOUNT_CARD.CARD_TYPE,
						ACCOUNT_CARD.CARD_CAT_ID
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
					FROM
						ACCOUNT_CARD_ROWS,
						ACCOUNT_CARD
					WHERE
						BA = 1 AND ACCOUNT_CARD.CARD_ID=ACCOUNT_CARD_ROWS.CARD_ID
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
				)ACC_M
				WHERE
					ACC_M.CARD_TYPE <> 19<!--- Kapanış fişleri gelmesin --->
					<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)>
						AND ACC_M.CARD_CAT_ID IN (#attributes.acc_card_type#)
					</cfif>
				GROUP BY
					ACC_M.ACCOUNT_ID
					<cfif isdefined('attributes.is_other_money') and attributes.is_other_money eq 1>
						,ISNULL(ACC_M.OTHER_MONEY,'#session.ep.money#')
					</cfif>
					<cfif isdefined('attributes.is_branch') and attributes.is_branch eq 1>
						,ACC_M.ACC_BRANCH_ID
					</cfif>
					<cfif isdefined('attributes.is_department') and attributes.is_department eq 1>
						,ACC_M.ACC_DEPARTMENT_ID
					</cfif>
					<cfif isdefined('attributes.is_project') and attributes.is_project eq 1>
						,ACC_M.ACC_PROJECT_ID
					</cfif>
			) AS AART,
			ACCOUNT_PLAN AP
		WHERE
			round(AART.BAKIYE,2) > 0 AND
			AP.ACCOUNT_CODE = AART.ACCOUNT_CODE AND
			AP.SUB_ACCOUNT = 0
	</cfquery>
	<cfcatch>
		<cfset islem_ok_flag = false>
	</cfcatch>
</cftry>
<cfif islem_ok_flag and get_alacak_bakiye.recordcount and get_borc_bakiye.recordcount>
	<cfquery name="control_bakiye_1" dbtype="query">
		SELECT SUM(BAKIYE) TOTAL_ALACAK_BAKIYE FROM get_alacak_bakiye
	</cfquery>
	<cfquery name="control_bakiye_2" dbtype="query">
		SELECT SUM(BAKIYE) as TOTAL_BORC_BAKIYE FROM get_borc_bakiye
	</cfquery>
	<cfif len(control_bakiye_1.TOTAL_ALACAK_BAKIYE) and len(control_bakiye_2.TOTAL_BORC_BAKIYE) and (wrk_round(abs(control_bakiye_1.TOTAL_ALACAK_BAKIYE)-abs(control_bakiye_2.TOTAL_BORC_BAKIYE)) eq 0)><!--- abs(wrk_round(control_bakiye_1.TOTAL_ALACAK_BAKIYE)) eq abs(wrk_round(control_bakiye_2.TOTAL_BORC_BAKIYE)) --->
		<cfset acc_wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
		<cfset acc_detail_="#get_period.period_year# KAPANIŞ İŞLEMİ">
		<cfquery name="GET_BILL_NO" datasource="#new_dsn2#">
			SELECT 
                BILL_NO, 
                MAHSUP_BILL_NO 
            FROM 
	            BILLS
		</cfquery>
		<cfquery name="upd_bill_no" datasource="#new_dsn2#">
			UPDATE BILLS SET BILL_NO=#GET_BILL_NO.BILL_NO+1#,MAHSUP_BILL_NO=#GET_BILL_NO.MAHSUP_BILL_NO+1#
		</cfquery>
		<cflock name="#createUUID()#" timeout="20">
			<cftransaction>
				<cfquery name="ADD_ACCOUNT_CARD" datasource="#new_dsn2#" result="MAX_ID">
					INSERT INTO
						ACCOUNT_CARD
						(
							WRK_ID,
							CARD_DETAIL,
							BILL_NO,
							CARD_TYPE,
							CARD_CAT_ID,
							CARD_TYPE_NO,
							ACTION_DATE,
							RECORD_EMP,
							RECORD_IP,
							RECORD_DATE
						)
					VALUES
						(
							'#acc_wrk_id#',
							'#acc_detail_#',
							#GET_BILL_NO.BILL_NO#,
							#control_process_type.process_type#,
							#control_process_type.process_cat_id#,
							#GET_BILL_NO.MAHSUP_BILL_NO#,
							#islem_tarihi#,
							#session.ep.userid#,
							'#CGI.REMOTE_ADDR#',
							#now()#
						)
				</cfquery>
				<cfloop query="get_alacak_bakiye"><!--- alacak bakiye veren hesaplar kapanış fişinde borc tarafına yazılır --->
					<cfquery name="add_acc_borc" datasource="#new_dsn2#">
						INSERT INTO
							ACCOUNT_CARD_ROWS
							(
								CARD_ID,
								ACCOUNT_ID,
								IFRS_CODE,
								ACCOUNT_CODE2,								
								DETAIL,
								BA,
								AMOUNT,
								AMOUNT_CURRENCY,
								AMOUNT_2,
								AMOUNT_CURRENCY_2
								<cfif isdefined('attributes.is_other_money') and attributes.is_other_money eq 1>
									,OTHER_AMOUNT
									,OTHER_CURRENCY
								</cfif>
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
								'#get_alacak_bakiye.ACCOUNT_CODE#',
								<cfif len(get_alacak_bakiye.IFRS_CODE)>'#get_alacak_bakiye.IFRS_CODE#'<cfelse>NULL</cfif>,
								<cfif len(get_alacak_bakiye.ACCOUNT_CODE2)>'#get_alacak_bakiye.ACCOUNT_CODE2#'<cfelse>NULL</cfif>,
								'#acc_detail_#',
								0,
								#abs(get_alacak_bakiye.BAKIYE)#,
								'#temp_period_money#'
								<cfif len(temp_period_money_2) and len(get_alacak_bakiye.BAKIYE2)>
									,#abs(get_alacak_bakiye.BAKIYE2)#
									,'#temp_period_money_2#'
								<cfelse>
									,NULL
									,NULL
								</cfif>
								<cfif isdefined('attributes.is_other_money') and attributes.is_other_money eq 1>
									,<cfif len(get_alacak_bakiye.BAKIYE3)>#abs(get_alacak_bakiye.BAKIYE3)#<cfelse>NULL</cfif>
									<cfif len(get_alacak_bakiye.OTHER_MONEY) and get_alacak_bakiye.OTHER_MONEY eq 'YTL' and get_period.PERIOD_YEAR gte 2009>
										,'TL'
									<cfelseif len(get_alacak_bakiye.OTHER_MONEY)>
										,'#get_alacak_bakiye.OTHER_MONEY#'
									<cfelse>
										,NULL
									</cfif>
								</cfif>
								<cfif isdefined('attributes.is_branch') and attributes.is_branch eq 1>
									<cfif get_alacak_bakiye.acc_branch_id neq 0>,#get_alacak_bakiye.acc_branch_id#<cfelse>,NULL</cfif>
								</cfif>
								<cfif isdefined('attributes.is_department') and attributes.is_department eq 1>
									<cfif get_alacak_bakiye.acc_department_id neq 0>,#get_alacak_bakiye.acc_department_id#<cfelse>,NULL</cfif>
								</cfif>
								<cfif isdefined('attributes.is_project') and attributes.is_project eq 1>
									<cfif get_alacak_bakiye.acc_project_id neq 0>,#get_alacak_bakiye.acc_project_id#<cfelse>,NULL</cfif>
								</cfif>
							)
					</cfquery>
				</cfloop>
				<cfloop query="get_borc_bakiye"><!--- borc bakiye veren hesaplar kapanış fişinde alacak tarafına yazılır --->
					<cfquery name="add_acc_alacak" datasource="#new_dsn2#">
						INSERT INTO
							ACCOUNT_CARD_ROWS
							(
								CARD_ID,
								ACCOUNT_ID,
								IFRS_CODE,
								ACCOUNT_CODE2,								
								DETAIL,
								BA,
								AMOUNT,
								AMOUNT_CURRENCY,
								AMOUNT_2,
								AMOUNT_CURRENCY_2
								<cfif isdefined('attributes.is_other_money') and attributes.is_other_money eq 1>
									,OTHER_AMOUNT
									,OTHER_CURRENCY
								</cfif>
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
								'#get_borc_bakiye.ACCOUNT_CODE#',
								<cfif len(get_borc_bakiye.IFRS_CODE)>'#get_borc_bakiye.IFRS_CODE#'<cfelse>NULL</cfif>,
								<cfif len(get_borc_bakiye.ACCOUNT_CODE2)>'#get_borc_bakiye.ACCOUNT_CODE2#'<cfelse>NULL</cfif>,
								'#acc_detail_#',
								1,
								#get_borc_bakiye.BAKIYE#,
								'#temp_period_money#'
								<cfif len(temp_period_money_2) and len(get_borc_bakiye.BAKIYE2)>
									,#get_borc_bakiye.BAKIYE2#
									,'#temp_period_money_2#'
								<cfelse>
									,NULL
									,NULL
								</cfif>
								<cfif isdefined('attributes.is_other_money') and attributes.is_other_money eq 1>
									,<cfif len(get_borc_bakiye.BAKIYE3)>#get_borc_bakiye.BAKIYE3#<cfelse>NULL</cfif>
									<cfif len(get_borc_bakiye.OTHER_MONEY) and get_borc_bakiye.OTHER_MONEY eq 'YTL' and get_period.PERIOD_YEAR gte 2009>
										,'TL'
									<cfelseif len(get_borc_bakiye.OTHER_MONEY)>
										,'#get_borc_bakiye.OTHER_MONEY#'
									<cfelse>
										,NULL
									</cfif>
								</cfif>
								<cfif isdefined('attributes.is_branch') and attributes.is_branch eq 1>
									<cfif get_alacak_bakiye.acc_branch_id neq 0>,#get_alacak_bakiye.acc_branch_id#<cfelse>,NULL</cfif>
								</cfif>
								<cfif isdefined('attributes.is_department') and attributes.is_department eq 1>
									<cfif get_alacak_bakiye.acc_department_id neq 0>,#get_alacak_bakiye.acc_department_id#<cfelse>,NULL</cfif>
								</cfif>
								<cfif isdefined('attributes.is_project') and attributes.is_project eq 1>
									<cfif get_alacak_bakiye.acc_project_id neq 0>,#get_alacak_bakiye.acc_project_id#<cfelse>,NULL</cfif>
								</cfif>
							)
					</cfquery>
				</cfloop>
			</cftransaction>
		</cflock>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='29543.Kapanış Fişi'> <cf_get_lang dictionary_id='59184.Oluşturuldu'>!");
			history.back();
			window.open('<cfoutput>#request.self#?fuseaction=account.form_add_bill_cash2cash&event=upd&var_=cash2cash_card&card_id=#MAX_ID.IDENTITYCOL#</cfoutput>','popup_upd_bill_cash2cash','height=500,width=1100,scrollbars=1, resizable=1, menubar=0');
		</script>
	<cfelse>
		<script type="text/javascript">
			alert('<cf_get_lang dictionary_id='65404.Borç Alacak Bakiye Toplamları Eşit Olmadığından Kapanış Fişi Oluşturulamayacaktır'>!');
			history.back();
		</script>
		<cfabort>
	</cfif> 
<cfelseif not (get_alacak_bakiye.recordcount and get_borc_bakiye.recordcount)>
	<script type="text/javascript">
		alert('<cf_get_lang dictionary_id='65405.Borç ve Alacak Bakiyesi Olmadığından Kapanış Fişi Oluşturulamayacaktır'>!');
		history.back();
	</script>
	<cfabort>	
</cfif>
