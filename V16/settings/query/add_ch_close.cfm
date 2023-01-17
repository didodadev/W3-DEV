<cfsetting showDebugOutput = "no" requestTimeOut = "9999">
<cfset line_error =0>
<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT 
		PROCESS_TYPE
	 FROM 
	 	SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = #form.process_cat#
</cfquery>
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
    	PERIOD_ID = #listfirst(attributes.period,';')#
</cfquery>
<cfquery name="get_new_period" datasource="#dsn#">
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
	    OUR_COMPANY_ID=#get_period.OUR_COMPANY_ID# and PERIOD_YEAR = #get_period.PERIOD_YEAR+1#
</cfquery>
<cfif len(get_period.OTHER_MONEY) and len(get_new_period.OTHER_MONEY) and get_period.OTHER_MONEY eq get_new_period.OTHER_MONEY>
	<cfset money2_aktar =1> <!---money2_aktar, sistem 2. parabirimi bakiyesinin aktarımını kontrol eder.. --->
<cfelse>
	<cfset money2_aktar =0>
</cfif>
<cfset islem_tarihi2 = CreateDateTime(get_period.PERIOD_YEAR,1,1,0,0,0)>
<cfif attributes.is_from_donem eq 1>
	<cfif len(attributes.action_date_rate)>
		<cf_date tarih = "attributes.action_date_rate">
		<cfset islem_tarihi = attributes.action_date_rate>
	<cfelse>
		<cfset islem_tarihi = CreateDateTime(get_period.PERIOD_YEAR+1,1,1,0,0,0)>
	</cfif>
<cfelse>
	<cfif len(attributes.action_date)>
		<cf_date tarih = "attributes.action_date">
		<cfset islem_tarihi = attributes.action_date>
	<cfelse>
		<cfset islem_tarihi = CreateDateTime(get_period.PERIOD_YEAR+1,1,1,0,0,0)>
	</cfif>
</cfif>
<cfset donem_eski = '#dsn#_#get_period.PERIOD_YEAR#_#get_period.OUR_COMPANY_ID#'>
<cfset donem_db = '#dsn#_#get_period.PERIOD_YEAR+1#_#get_period.OUR_COMPANY_ID#'>
<cfif isdefined("attributes.check_date_rate")>
	<cfset "rate_#session.ep.money#" = 1>
	<cfquery name="get_money" datasource="#donem_eski#">
		SELECT * FROM SETUP_MONEY
	</cfquery>
	<cfloop query="get_money">
		<cfquery name="get_rate" datasource="#dsn#" maxrows="1">
			SELECT
				<cfif attributes.xml_money_type eq 0>
					(RATE2/RATE1) AS RATE
				<cfelseif attributes.xml_money_type eq 1>
					(RATE3/RATE1) AS RATE
				<cfelseif attributes.xml_money_type eq 2>
					(RATE2/RATE1) AS RATE
				<cfelseif attributes.xml_money_type eq 3>
					(EFFECTIVE_PUR/RATE1) AS RATE
				<cfelseif attributes.xml_money_type eq 4>
					(EFFECTIVE_SALE/RATE1) AS RATE
				<cfelse>
					(RATE2/RATE1) AS RATE
				</cfif>,MONEY 
			FROM 
				MONEY_HISTORY
			WHERE 
				VALIDATE_DATE <= #islem_tarihi#
				AND COMPANY_ID = #get_period.OUR_COMPANY_ID#
				AND PERIOD_ID = #get_period.PERIOD_ID#
				AND MONEY = '#get_money.MONEY#'
			ORDER BY
				VALIDATE_DATE DESC,
				MONEY_HISTORY_ID DESC
		</cfquery>
		<cfoutput query="get_rate">
			<cfset "rate_#money#" = rate>
		</cfoutput>
	</cfloop>
</cfif>
<cfif isDefined("attributes.is_make_age") and attributes.is_make_age eq 1 and attributes.is_from_donem eq 1><!--- Ödeme performansından hesapla seçeneği seçilmişse --->
	<cfinclude template="create_file_for_comp_remainder.cfm">
<cfelseif isDefined("attributes.is_make_age_manuel") and attributes.is_make_age_manuel eq 1 and attributes.is_from_donem eq 1><!--- manuel Ödeme performansından hesapla seçeneği seçilmişse --->
	<cfinclude template="create_file_for_comp_remainder_manuel.cfm">
</cfif>
<cfif get_period.recordcount>
	<cfset islem_ok_flag = true>
	<cfif attributes.is_from_donem eq 1><!--- donemden acilis --->
		<cftry>
			<cfquery name="get_bakiye" datasource="#donem_eski#">
				SELECT
					<cfif isdefined("attributes.is_consumer")>
						CONSUMER_ID,
					<cfelseif isdefined("attributes.is_employee")>
						EMPLOYEE_ID,
                        ACC_TYPE_ID,
					<cfelse>
						COMPANY_ID,
					</cfif>
					SUM(BAKIYE-BAKIYE_CV) BAKIYE,
					<cfif isdefined('attributes.is_other_money_transfer') and attributes.is_other_money_transfer eq 1>
						SUM(BAKIYE3-BAKIYE3_CV) BAKIYE3,
						OTHER_MONEY,
						SUM(VADE_BORC-VADE_BORC_CV) VADE_BORC,
						SUM(VADE_ALACAK-VADE_ALACAK_CV) VADE_ALACAK,
					<cfelse>
						SUM(VADE_BORC-VADE_BORC_CV) VADE_BORC,
						SUM(VADE_ALACAK-VADE_ALACAK_CV) VADE_ALACAK,
					</cfif>
					<cfif isDefined("attributes.is_project_transfer")>PROJECT_ID,</cfif>
					<cfif isDefined("attributes.is_acc_type_transfer")>ACC_TYPE_ID,</cfif>
					<cfif isDefined("attributes.is_subscription_transfer")>SUBSCRIPTION_ID,</cfif>
					<cfif isDefined("attributes.is_branch_transfer")>BRANCH_ID,</cfif>
					SUM(BAKIYE2-BAKIYE2_CV) BAKIYE2
				FROM
					(				
						SELECT
							<cfif isdefined("attributes.is_consumer")>
								CONSUMER_ID,
							<cfelseif isdefined("attributes.is_employee")>
								EMPLOYEE_ID,
                                ACC_TYPE_ID,
							<cfelse>
								COMPANY_ID,
							</cfif>
							BAKIYE,
							0 BAKIYE_CV,
						<cfif isdefined('attributes.is_other_money_transfer') and attributes.is_other_money_transfer eq 1>
							BAKIYE3,
							0 BAKIYE3_CV,
							OTHER_MONEY,
							VADE_BORC3 VADE_BORC,
							VADE_ALACAK3 VADE_ALACAK,
							0 VADE_BORC_CV,
							0 VADE_ALACAK_CV,
						<cfelse>
							VADE_BORC,
							VADE_ALACAK,
							0 VADE_BORC_CV,
							0 VADE_ALACAK_CV,
						</cfif>
						<cfif isDefined("attributes.is_project_transfer")>PROJECT_ID,</cfif>
						<cfif isDefined("attributes.is_acc_type_transfer")>ACC_TYPE_ID,</cfif>
						<cfif isDefined("attributes.is_subscription_transfer")>SUBSCRIPTION_ID,</cfif>
						<cfif isDefined("attributes.is_branch_transfer")> BRANCH_ID,</cfif>
							BAKIYE2,
							0 BAKIYE2_CV
						FROM
							<cfif isdefined("attributes.is_consumer")>
								<cfif isDefined("attributes.is_branch_transfer")>
									<cfif isdefined('attributes.is_other_money_transfer') and attributes.is_other_money_transfer eq 1>
										<cfif isDefined("attributes.is_project_transfer")>CONSUMER_REMAINDER_MONEY_PROJECT_BRANCH<cfelse>CONSUMER_REMAINDER_MONEY_BRANCH</cfif>
									<cfelse>
										<cfif isDefined("attributes.is_project_transfer")>CONSUMER_REMAINDER_PROJECT_BRANCH<cfelse>CONSUMER_REMAINDER_BRANCH</cfif>
									</cfif>
								<cfelseif isDefined("attributes.is_subscription_transfer")> <!---abone bazlı --->
									<cfif isdefined('attributes.is_other_money_transfer') and attributes.is_other_money_transfer eq 1>
										<cfif isDefined("attributes.is_subscription_transfer")>CONSUMER_REMAINDER_MONEY_SUBSCRIPTION<cfelse>CONSUMER_REMAINDER_MONEY</cfif>
									<cfelse>
										<cfif isDefined("attributes.is_subscription_transfer")>CONSUMER_REMAINDER_SUBSCRIPTION<cfelse>CONSUMER_REMAINDER</cfif>
									</cfif>
								<cfelseif isDefined("attributes.is_acc_type_transfer")> <!---hesap tipi bazlı --->
									<cfif isdefined('attributes.is_other_money_transfer') and attributes.is_other_money_transfer eq 1>
										<cfif isDefined("attributes.is_acc_type_transfer")>CONSUMER_REMAINDER_MONEY_ACC_TYPE<cfelse>CONSUMER_REMAINDER_MONEY</cfif>
									<cfelse>
										<cfif isDefined("attributes.is_acc_type_transfer")>CONSUMER_REMAINDER_ACC_TYPE<cfelse>CONSUMER_REMAINDER</cfif>
									</cfif>
								<cfelse>
									<cfif isdefined('attributes.is_other_money_transfer') and attributes.is_other_money_transfer eq 1>
										<cfif isDefined("attributes.is_project_transfer")>CONSUMER_REMAINDER_MONEY_PROJECT<cfelse>CONSUMER_REMAINDER_MONEY</cfif>
									<cfelse>
										<cfif isDefined("attributes.is_project_transfer")>CONSUMER_REMAINDER_PROJECT<cfelse>CONSUMER_REMAINDER</cfif>
									</cfif>
								</cfif>
							<cfelseif isdefined("attributes.is_employee")>
								<cfif isDefined("attributes.is_branch_transfer")>
									<cfif isdefined('attributes.is_other_money_transfer') and attributes.is_other_money_transfer eq 1>
										<cfif isDefined("attributes.is_project_transfer")>EMPLOYEE_REMAINDER_MONEY_PROJECT_BRANCH<cfelse>EMPLOYEE_REMAINDER_MONEY_BRANCH</cfif>
									<cfelse>
										<cfif isDefined("attributes.is_project_transfer")>EMPLOYEE_REMAINDER_PROJECT_BRANCH<cfelse>EMPLOYEE_REMAINDER_BRANCH</cfif>
									</cfif>
								<cfelseif isDefined("attributes.is_subscription_transfer")> <!---abone bazlı --->
									<cfif isdefined('attributes.is_other_money_transfer') and attributes.is_other_money_transfer eq 1>
										<cfif isDefined("attributes.is_subscription_transfer")>EMPLOYEE_REMAINDER_MONEY_SUBSCRIPTION<cfelse>EMPLOYEE_REMAINDER_MONEY</cfif>
									<cfelse>
										<cfif isDefined("attributes.is_subscription_transfer")>EMPLOYEE_REMAINDER_SUBSCRIPTION<cfelse>EMPLOYEE_REMAINDER</cfif>
									</cfif>
								<cfelse>
									<cfif isdefined('attributes.is_other_money_transfer') and attributes.is_other_money_transfer eq 1>
										<cfif isDefined("attributes.is_project_transfer")>EMPLOYEE_REMAINDER_MONEY_PROJECT<cfelse>EMPLOYEE_REMAINDER_MONEY</cfif>
									<cfelse>
										<cfif isDefined("attributes.is_project_transfer")>EMPLOYEE_REMAINDER_PROJECT<cfelse>EMPLOYEE_REMAINDER</cfif>
									</cfif>
								</cfif>
							<cfelse>
								<cfif isDefined("attributes.is_branch_transfer")>
									<cfif isdefined('attributes.is_other_money_transfer') and attributes.is_other_money_transfer eq 1>
										<cfif isDefined("attributes.is_project_transfer")>COMPANY_REMAINDER_MONEY_PROJECT_BRANCH<cfelse>COMPANY_REMAINDER_MONEY_BRANCH</cfif>
									<cfelse>
										<cfif isDefined("attributes.is_project_transfer")>COMPANY_REMAINDER_PROJECT_BRANCH<cfelse>COMPANY_REMAINDER_BRANCH</cfif>
									</cfif>
								<cfelseif isDefined("attributes.is_subscription_transfer")> <!---abone bazlı --->
									<cfif isdefined('attributes.is_other_money_transfer') and attributes.is_other_money_transfer eq 1>
										<cfif isDefined("attributes.is_subscription_transfer")>COMPANY_REMAINDER_MONEY_SUBSCRIPTION<cfelse>COMPANY_REMAINDER_MONEY</cfif>
									<cfelse>
										<cfif isDefined("attributes.is_subscription_transfer")>COMPANY_REMAINDER_SUBSCRIPTION<cfelse>COMPANY_REMAINDER</cfif>
									</cfif>
								<cfelse>
									<cfif isdefined('attributes.is_other_money_transfer') and attributes.is_other_money_transfer eq 1>
										<cfif isDefined("attributes.is_project_transfer")>COMPANY_REMAINDER_MONEY_PROJECT<cfelse>COMPANY_REMAINDER_MONEY</cfif>
									<cfelse>
										<cfif isDefined("attributes.is_project_transfer")>COMPANY_REMAINDER_PROJECT<cfelse>COMPANY_REMAINDER</cfif>
									</cfif>
								</cfif>
							</cfif>
						WHERE
							1 = 1
							<cfif (isdefined('attributes.company_id') and  len(attributes.company_id) and len(attributes.company) and member_type is 'partner')>
								AND COMPANY_ID = #attributes.company_id#
							</cfif>
							<cfif (isdefined('attributes.consumer_id') and  len(attributes.consumer_id) and len(attributes.company) and member_type is 'consumer')>
								AND CONSUMER_ID = #attributes.consumer_id#
							</cfif>
							<cfif (isdefined('attributes.employee_id') and  len(attributes.employee_id) and len(attributes.company) and member_type is 'employee')>
								AND EMPLOYEE_ID = #attributes.employee_id#
							</cfif>
							<cfif isdefined("attributes.member_cat") and len(attributes.member_cat)>
								<cfif isdefined("attributes.is_consumer")>
									AND CONSUMER_ID IN(SELECT C.CONSUMER_ID FROM #dsn_alias#.CONSUMER C WHERE C.CONSUMER_CAT_ID IN(#attributes.member_cat#))
								<cfelseif isdefined("attributes.is_company")>
									AND COMPANY_ID IN(SELECT C.COMPANY_ID FROM #dsn_alias#.COMPANY C WHERE C.COMPANYCAT_ID IN(#attributes.member_cat#))
								</cfif>
							</cfif>
					<cfif isDefined("attributes.is_cheque_voucher_transfer")>
					UNION ALL
						SELECT
							<cfif isdefined("attributes.is_consumer")>
								CONSUMER_ID,
							<cfelseif isdefined("attributes.is_employee")>
								EMPLOYEE_ID,
                                ACC_TYPE_ID,
							<cfelse>
								COMPANY_ID,
							</cfif>
							0 BAKIYE,
							ROUND(SUM(ACTION_VALUE_B-ACTION_VALUE_A),5) AS BAKIYE_CV,
						<cfif isdefined('attributes.is_other_money_transfer') and attributes.is_other_money_transfer eq 1>
							0 BAKIYE3,
							ROUND(SUM(OTHER_CASH_ACT_VALUE_B-OTHER_CASH_ACT_VALUE_A),5) AS BAKIYE3_CV,
							OTHER_MONEY,
							0 VADE_BORC,
							0 VADE_ALACAK,
							CASE WHEN SUM(OTHER_CASH_ACT_VALUE_B)= 0 THEN SUM((OTHER_CASH_ACT_VALUE_B*DATE_DIFF)) ELSE ROUND((SUM((OTHER_CASH_ACT_VALUE_B*DATE_DIFF))/SUM(OTHER_CASH_ACT_VALUE_B)),0) END AS VADE_BORC_CV,
							CASE WHEN SUM(OTHER_CASH_ACT_VALUE_A)= 0 THEN SUM((OTHER_CASH_ACT_VALUE_A*DATE_DIFF)) ELSE ROUND((SUM((OTHER_CASH_ACT_VALUE_A*DATE_DIFF))/SUM(OTHER_CASH_ACT_VALUE_A)),0) END AS VADE_ALACAK_CV,
						<cfelse>
							0 VADE_BORC,
							0 VADE_ALACAK,
							CASE WHEN SUM(ACTION_VALUE_B)= 0 THEN SUM((ACTION_VALUE_B*DATE_DIFF)) ELSE ROUND((SUM((ACTION_VALUE_B*DATE_DIFF))/SUM(ACTION_VALUE_B)),0) END AS VADE_BORC_CV,
							CASE WHEN SUM(ACTION_VALUE_A)= 0 THEN SUM((ACTION_VALUE_A*DATE_DIFF)) ELSE ROUND((SUM((ACTION_VALUE_A*DATE_DIFF))/SUM(ACTION_VALUE_A)),0) END AS VADE_ALACAK_CV,
						</cfif>
							<cfif isDefined("attributes.is_project_transfer")>PROJECT_ID,</cfif>
							<cfif isDefined("attributes.is_branch_transfer")>BRANCH_ID,</cfif>
							0 BAKIYE2,
							ROUND(SUM(ACTION_VALUE2_B-ACTION_VALUE2_A),5) AS BAKIYE2_CV
						FROM
							<cfif isDefined("attributes.is_branch_transfer")>
								<cfif isdefined("attributes.is_consumer")>
									<cfif isDefined("attributes.is_project_transfer")>CHEQUE_VOUCHER_TOTAL_CONSUMER_PROJECT_BRANCH<cfelse>CHEQUE_VOUCHER_TOTAL_CONSUMER_BRANCH</cfif>
								<cfelseif isdefined("attributes.is_employee")>
									<cfif isDefined("attributes.is_project_transfer")>CHEQUE_VOUCHER_TOTAL_EMPLOYEE_PROJECT_BRANCH<cfelse>CHEQUE_VOUCHER_TOTAL_EMPLOYEE_BRANCH</cfif>
								<cfelse>
									<cfif isDefined("attributes.is_project_transfer")>CHEQUE_VOUCHER_TOTAL_PROJECT_BRANCH<cfelse>CHEQUE_VOUCHER_TOTAL_BRANCH</cfif>
								</cfif>
							<cfelse>
								<cfif isdefined("attributes.is_consumer")>
									<cfif isDefined("attributes.is_project_transfer")>CHEQUE_VOUCHER_TOTAL_CONSUMER_PROJECT<cfelse>CHEQUE_VOUCHER_TOTAL_CONSUMER</cfif>
								<cfelseif isdefined("attributes.is_employee")>
									<cfif isDefined("attributes.is_project_transfer")>CHEQUE_VOUCHER_TOTAL_EMPLOYEE_PROJECT<cfelse>CHEQUE_VOUCHER_TOTAL_EMPLOYEE</cfif>
								<cfelse>
									<cfif isDefined("attributes.is_project_transfer")>CHEQUE_VOUCHER_TOTAL_PROJECT<cfelse>CHEQUE_VOUCHER_TOTAL</cfif>
								</cfif>
							</cfif>
						WHERE
							1 = 1
							<cfif (isdefined('attributes.company_id') and  len(attributes.company_id) and len(attributes.company) and member_type is 'partner')>
								AND COMPANY_ID = #attributes.company_id#
							</cfif>
							<cfif (isdefined('attributes.consumer_id') and  len(attributes.consumer_id) and len(attributes.company) and member_type is 'consumer')>
								AND CONSUMER_ID = #attributes.consumer_id#
							</cfif>
							<cfif (isdefined('attributes.employee_id') and  len(attributes.employee_id) and len(attributes.company) and member_type is 'employee')>
								AND EMPLOYEE_ID = #attributes.employee_id#
							</cfif>
							<cfif isdefined("attributes.member_cat") and len(attributes.member_cat)>
								<cfif isdefined("attributes.is_consumer")>
									AND CONSUMER_ID IN(SELECT C.CONSUMER_ID FROM #dsn_alias#.CONSUMER C WHERE C.CONSUMER_CAT_ID IN(#attributes.member_cat#))
								<cfelseif isdefined("attributes.is_company")>
									AND COMPANY_ID IN(SELECT C.COMPANY_ID FROM #dsn_alias#.COMPANY C WHERE C.COMPANYCAT_ID IN(#attributes.member_cat#))
								</cfif>
							</cfif>
						GROUP BY
							<cfif isdefined("attributes.is_consumer")>
								CONSUMER_ID
							<cfelseif isdefined("attributes.is_employee")>
								EMPLOYEE_ID,
                                ACC_TYPE_ID
							<cfelse>
								COMPANY_ID
							</cfif>
							<cfif isDefined("attributes.is_project_transfer")>,PROJECT_ID</cfif>
							<cfif isDefined("attributes.is_branch_transfer")>,BRANCH_ID</cfif>
							<cfif isdefined('attributes.is_other_money_transfer') and attributes.is_other_money_transfer eq 1>
								,OTHER_MONEY
							</cfif>	
					</cfif>
					) AS COMP_REMAINDER
				GROUP BY
					<cfif isdefined("attributes.is_consumer")>
						CONSUMER_ID
					<cfelseif isdefined("attributes.is_employee")>
						EMPLOYEE_ID,
                        ACC_TYPE_ID
					<cfelse>
						COMPANY_ID
					</cfif>
					<cfif isDefined("attributes.is_project_transfer")>,PROJECT_ID</cfif>
					<cfif isDefined("attributes.is_acc_type_transfer")>,ACC_TYPE_ID</cfif>
					<cfif isDefined("attributes.is_subscription_transfer")>,SUBSCRIPTION_ID</cfif>
					<cfif isDefined("attributes.is_branch_transfer")>,BRANCH_ID</cfif>
					<cfif isdefined('attributes.is_other_money_transfer') and attributes.is_other_money_transfer eq 1>
						,OTHER_MONEY
					</cfif>	
			</cfquery>
			<cfcatch>
				<cfset islem_ok_flag = false>
			</cfcatch>
		</cftry>
	<cfelse><!--- dosyadan acilis --->
		<cfset donem_db = '#dsn#_#get_period.PERIOD_YEAR#_#get_period.OUR_COMPANY_ID#'>
        <cfset upload_folder_ = "#upload_folder#settings#dir_seperator#">
        
		<cfif isdefined("attributes.cari_file") and len(attributes.cari_file)>
        	<cftry>
                <cffile action = "upload" 
                        filefield = "cari_file" 
                        destination = "#upload_folder_#"
                        nameconflict = "MakeUnique"  
                        mode="777" charset="utf-8">
                <cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
                <cffile action="rename" source="#upload_folder_##cffile.serverfile#" destination="#upload_folder_##file_name#">
                <cffile action="read" file="#upload_folder_##file_name#" variable="dosya" charset="utf-8">
                <cfcatch type="Any">
					<cfdump  var="#cfcatch#">
                    <script type="text/javascript">
                        alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
                    //    history.back();
                    </script>
                    <cfabort>
                </cfcatch>  
            </cftry>
			<cfscript>
				CRLF = Chr(13) & Chr(10);
				dosya = Replace(dosya,';;','; ;','all');
				dosya = Replace(dosya,';;','; ;','all');
				dosya = ListToArray(dosya,CRLF);
				line_count = ArrayLen(dosya);
			</cfscript>
		<cfelse>
			<cfset islem_ok_flag = false>
		</cfif>
	</cfif>
	<cfif islem_ok_flag>
		<cftry>
		<!--- bireysel uye acılıs fislerinin silinmemesi icin cari_sil function kullanılmıyor --->
			<cfif attributes.is_from_donem eq 1 or isDefined("attributes.is_delete_all")><!--- dönemden veya dosyadaki öncekileri sil seçeneğinden --->
				<cfif isdefined("attributes.is_consumer")>
					<cfquery name="DEL_CONSUMER_CARI_ACTION" datasource="#donem_db#">
						DELETE FROM CARI_ROWS WHERE ACTION_TYPE_ID=40 AND ACTION_ID= -1 AND (TO_CONSUMER_ID IS NOT NULL OR FROM_CONSUMER_ID IS NOT NULL) 
						<cfif (isdefined('attributes.consumer_id') and  len(attributes.consumer_id) and len(attributes.company) and member_type is 'consumer')>
							AND ISNULL(TO_CONSUMER_ID,FROM_CONSUMER_ID) = #attributes.consumer_id#
						</cfif>
						<cfif isdefined("attributes.member_cat") and len(attributes.member_cat)>
							AND ISNULL(TO_CONSUMER_ID,FROM_CONSUMER_ID) IN(SELECT C.CONSUMER_ID FROM #dsn_alias#.CONSUMER C WHERE C.CONSUMER_CAT_ID IN(#attributes.member_cat#))
						</cfif>
					</cfquery>
				<cfelseif isdefined("attributes.is_employee")>
					<cfquery name="DEL_CONSUMER_CARI_ACTION" datasource="#donem_db#">
						DELETE FROM CARI_ROWS WHERE ACTION_TYPE_ID=40 AND ACTION_ID= -1 AND (TO_EMPLOYEE_ID IS NOT NULL OR FROM_EMPLOYEE_ID IS NOT NULL) 
						<cfif (isdefined('attributes.employee_id') and  len(attributes.employee_id) and len(attributes.company) and member_type is 'employee')>
							AND ISNULL(TO_EMPLOYEE_ID,FROM_EMPLOYEE_ID) = #attributes.employee_id#
						</cfif>
					</cfquery>
				<cfelse>
					<cfquery name="DEL_CONSUMER_CARI_ACTION" datasource="#donem_db#">
						DELETE FROM CARI_ROWS WHERE ACTION_TYPE_ID=40 AND ACTION_ID= -1 AND (TO_CMP_ID IS NOT NULL OR FROM_CMP_ID IS NOT NULL) 
						<cfif (isdefined('attributes.company_id') and  len(attributes.company_id) and len(attributes.company) and member_type is 'partner')>
							AND ISNULL(TO_CMP_ID,FROM_CMP_ID) = #attributes.company_id#
						</cfif>
						<cfif isdefined("attributes.member_cat") and len(attributes.member_cat)>
							AND ISNULL(TO_CMP_ID,FROM_CMP_ID) IN(SELECT C.COMPANY_ID FROM #dsn_alias#.COMPANY C WHERE C.COMPANYCAT_ID IN(#attributes.member_cat#))
						</cfif>
					</cfquery>
				</cfif>
			</cfif>
			<cfcatch>
				<cfset islem_ok_flag = false>
			</cfcatch>
		</cftry>
	</cfif>
<cfelse>
	<cfset islem_ok_flag = false>
</cfif>
<cfif islem_ok_flag>
	<cfif isdefined("attributes.is_consumer")>
		<cfquery name="get_companies" datasource="#dsn#">
			SELECT CONSUMER_ID,TAX_NO,MEMBER_CODE,OZEL_KOD FROM CONSUMER
		</cfquery>
	<cfelseif isdefined("attributes.is_employee")>
		<cfquery name="get_companies" datasource="#dsn#">
			SELECT EMPLOYEE_ID,EMPLOYEE_NO FROM EMPLOYEES
		</cfquery>
	<cfelse>
		<cfquery name="get_companies" datasource="#dsn#">
			SELECT COMPANY_ID,TAXNO,MEMBER_CODE,OZEL_KOD,OZEL_KOD_1,OZEL_KOD_2 FROM COMPANY
		</cfquery>
	</cfif>
	<cfif attributes.is_from_donem eq 1>
		<cfset aciklama = '#get_period.PERIOD_YEAR+1# DEVIR ISLEMI'>
	<cfelse>
		<cfset aciklama = '#get_period.PERIOD_YEAR# DEVIR ISLEMI'>
	</cfif>
	<cfif attributes.is_from_donem eq 1><!--- donemden acilis --->
		<cfoutput query="get_bakiye">
		<cfset acc_type_info = ''>
		<cfif isdefined('attributes.is_project_transfer') and attributes.is_project_transfer eq 1 and len(get_bakiye.project_id)>
			<cfset project_id_info = get_bakiye.project_id>
		<cfelse>
			<cfset project_id_info = "">
		</cfif>
		<cfif isdefined('attributes.is_subscription_transfer') and attributes.is_subscription_transfer eq 1 and len(get_bakiye.subscription_id)>
			<cfset subscription_id_info = get_bakiye.subscription_id>
		<cfelse>
			<cfset subscription_id_info = "">
		</cfif>
		<cfif isdefined('attributes.is_acc_type_transfer') and attributes.is_acc_type_transfer eq 1 and len(get_bakiye.acc_type_id)>
			<cfset acc_type_info = get_bakiye.acc_type_id>
		<cfelse>
			<cfset acc_type_info = "">
		</cfif>
		<cfif isdefined('attributes.is_branch_transfer') and attributes.is_branch_transfer eq 1 and len(get_bakiye.branch_id)>
			<cfset branch_id_info = get_bakiye.branch_id>
		<cfelse>
			<cfset branch_id_info = "">
		</cfif>
		<cfif isdefined("attributes.is_consumer")>
			<cfset consumer_info = get_bakiye.CONSUMER_ID>
			<cfset company_info = ''>
			<cfset employee_info = ''>
		<cfelseif isdefined("attributes.is_employee")>
			<cfset consumer_info = ''>
			<cfset company_info = ''>
			<cfset employee_info = get_bakiye.EMPLOYEE_ID>
			<cfset acc_type_info = get_bakiye.ACC_TYPE_ID>
		<cfelse>
			<cfset consumer_info = ''>
			<cfset company_info = get_bakiye.COMPANY_ID>
			<cfset employee_info = ''>
		</cfif>
		<cfscript>
			if(isdefined('attributes.is_other_money_transfer') and attributes.is_other_money_transfer eq 1)
				kontrol_bakiye = BAKIYE3;
			else
				kontrol_bakiye = BAKIYE;
			new_rate = 1;
			if(isdefined('attributes.is_other_money_transfer') and attributes.is_other_money_transfer eq 1)
				if(isdefined("rate_#other_money#") and isdefined("attributes.check_date_rate"))
				{
					new_rate = evaluate("rate_#other_money#");
				}
			if(len(kontrol_bakiye) and kontrol_bakiye lt 0)
			{
				if(get_period.PERIOD_YEAR eq 2004) alacak = round(abs(BAKIYE)/10000)/100; else alacak = abs(BAKIYE);
				if (alacak gt 0)
				{
					new_alacak = alacak;
					if(isdefined('attributes.is_other_money_transfer') and attributes.is_other_money_transfer eq 1)
					{/*islem dovizi aktar secilmisse bakiye3 aktarıma dahil ediliyor*/
						if(len(BAKIYE3)) alacak3 = abs(BAKIYE3); else  alacak3 = 0;
						temp_other_money=other_money;
						if(isdefined("new_rate") and isdefined("attributes.check_date_rate")) new_alacak = alacak3*new_rate;
					}
					else
					{
						alacak3 = 0;
						temp_other_money='';
					}
					kontrol_devir = 0;
					if(len(BAKIYE2)) alacak2 = abs(BAKIYE2); else  alacak2 = 0;
					if(isdefined('attributes.is_other_money_transfer') and attributes.is_other_money_transfer eq 1)
					{
						if(not isdefined("attributes.check_date_rate") and (BAKIYE lte 0 and BAKIYE3 gt 0) or (BAKIYE gt 0 and BAKIYE3 lte 0))//eğer kur farjkları kesilmemişse bakiyeler ters olacağı için 2 tane devir kaydedeceğiz
						{
							kontrol_devir = 1;
							//işlem dövizi dolu sistem dövizi 0
							if(BAKIYE3 neq 0 and alacak3 neq 0)
							{
								if(BAKIYE3 gt 0)
								{
									from_cmp_id = '';
									from_consumer_id = '';
									from_employee_id = '';
									to_cmp_id = company_info;
									to_consumer_id = consumer_info;
									to_employee_id = employee_info;
								}
								else
								{
									from_cmp_id = company_info;
									from_consumer_id = consumer_info;
									from_employee_id = employee_info;
									to_cmp_id = '';
									to_consumer_id = '';
									to_employee_id = '';
								}
								carici
								(
									action_id : -1,
									action_table : 'CARI_ROWS',
									cari_db : donem_db,
									process_cat : form.process_cat,
									workcube_process_type : get_process_type.process_type,
									islem_tutari : 0,
									action_value2 : iif(money2_aktar eq 1,de('#alacak2#'),de('')),
									other_money_value : iif((isdefined('attributes.is_other_money_transfer') and attributes.is_other_money_transfer eq 1),de('#alacak3#'),de('#alacak#')),
									other_money : iif((isdefined('attributes.is_other_money_transfer') and attributes.is_other_money_transfer eq 1),de('#temp_other_money#'),de('#session.ep.money#')),
									islem_tarihi : islem_tarihi,
									due_date : createodbcdate(date_add('d',VADE_ALACAK,islem_tarihi)),
									from_cmp_id : from_cmp_id,
									from_consumer_id : from_consumer_id,
									from_employee_id : from_employee_id,
									to_cmp_id : to_cmp_id,
									to_consumer_id : to_consumer_id,
									to_employee_id : to_employee_id,
									acc_type_id : acc_type_info,
									subscription_id : subscription_id_info,
									islem_detay : '#aciklama#',
									action_currency : '#session.ep.money#',
									account_card_type : 10,
									project_id : project_id_info,
									from_branch_id : branch_id_info
								);
							}
							//işlem dövizi 0 sistem dövizi dolu
							if(BAKIYE neq 0 and new_alacak neq 0)
							{
								if(BAKIYE gt 0)
								{
									from_cmp_id = '';
									from_consumer_id = '';
									from_employee_id = '';
									to_cmp_id = company_info;
									to_consumer_id = consumer_info;
									to_employee_id = employee_info;
								}
								else
								{
									from_cmp_id = company_info;
									from_consumer_id = consumer_info;
									from_employee_id = employee_info;
									to_cmp_id = '';
									to_consumer_id = '';
									to_employee_id = '';
								}
								carici
								(
									action_id : -1,
									action_table : 'CARI_ROWS',
									cari_db : donem_db,
									process_cat : form.process_cat,
									workcube_process_type : get_process_type.process_type,
									islem_tutari : new_alacak,
									action_value2 : iif(money2_aktar eq 1,de('#alacak2#'),de('')),
									other_money_value : 0,
									other_money : iif((isdefined('attributes.is_other_money_transfer') and attributes.is_other_money_transfer eq 1),de('#temp_other_money#'),de('#session.ep.money#')),
									islem_tarihi : islem_tarihi,
									due_date : createodbcdate(date_add('d',VADE_ALACAK,islem_tarihi)),
									from_cmp_id : from_cmp_id,
									from_consumer_id : from_consumer_id,
									from_employee_id : from_employee_id,
									to_cmp_id : to_cmp_id,
									to_consumer_id : to_consumer_id,
									to_employee_id : to_employee_id,
									acc_type_id : acc_type_info,
									subscription_id : subscription_id_info,
									islem_detay : '#aciklama#',
									action_currency : '#session.ep.money#',
									account_card_type : 10,
									project_id : project_id_info,
									from_branch_id : branch_id_info
								);
							}
						}
					}
					if(kontrol_devir eq 0 and new_alacak gt 0)
					{
						carici
						(
							action_id : -1,
							action_table : 'CARI_ROWS',
							cari_db : donem_db,
							process_cat : form.process_cat,
							workcube_process_type : get_process_type.process_type,
							islem_tutari : new_alacak,
							action_value2 : iif(money2_aktar eq 1,de('#alacak2#'),de('')),
							other_money_value : iif((isdefined('attributes.is_other_money_transfer') and attributes.is_other_money_transfer eq 1),de('#alacak3#'),de('#alacak#')),
							other_money : iif((isdefined('attributes.is_other_money_transfer') and attributes.is_other_money_transfer eq 1),de('#temp_other_money#'),de('#session.ep.money#')),
							islem_tarihi : islem_tarihi,
							due_date : createodbcdate(date_add('d',VADE_ALACAK,islem_tarihi)),
							from_cmp_id : company_info,
							from_consumer_id : consumer_info,
							from_employee_id : employee_info,
							acc_type_id : acc_type_info,
							subscription_id : subscription_id_info,
							islem_detay : '#aciklama#',
							action_currency : '#session.ep.money#',
							account_card_type : 10,
							project_id : project_id_info,
							from_branch_id : branch_id_info
						);
					}
				}
			}
			else if (len(kontrol_bakiye) and kontrol_bakiye gt 0){
				if(get_period.PERIOD_YEAR eq 2004) borc = round(abs(BAKIYE)/10000)/100;
				else borc = abs(BAKIYE);					
				if (borc gt 0)
				{
					new_borc = borc;
					if(isdefined('attributes.is_other_money_transfer') and attributes.is_other_money_transfer eq 1)
					{
						if(len(BAKIYE3)) borc3 = abs(BAKIYE3); else  borc3 = 0;
						temp_other_money=other_money;
						if(isdefined("new_rate") and isdefined("attributes.check_date_rate")) new_borc = borc3*new_rate;
					}
					else
					{
						borc3 = 0;
						temp_other_money='';
					}
					if(len(BAKIYE2)) borc2 = abs(BAKIYE2); else  borc2 = 0;
					kontrol_devir = 0;
					if(isdefined('attributes.is_other_money_transfer') and attributes.is_other_money_transfer eq 1)
					{
						if(not isdefined("attributes.check_date_rate") and (BAKIYE lte 0 and BAKIYE3 gt 0) or (BAKIYE gt 0 and BAKIYE3 lte 0))//eğer kur farjkları kesilmemişse bakiyeler ters olacağı için 2 tane devir kaydedeceğiz
						{
							kontrol_devir = 1;
							//işlem dövizi dolu sistem dövizi 0
							if(BAKIYE3 neq 0 and borc3 neq 0)
							{
								if(BAKIYE3 gt 0)
								{
									from_cmp_id = '';
									from_consumer_id = '';
									from_employee_id = '';
									to_cmp_id = company_info;
									to_consumer_id = consumer_info;
									to_employee_id = employee_info;
								}
								else
								{
									from_cmp_id = company_info;
									from_consumer_id = consumer_info;
									from_employee_id = employee_info;
									to_cmp_id = '';
									to_consumer_id = '';
									to_employee_id = '';
								}
								carici
								(
									action_id : -1,
									action_table : 'CARI_ROWS',
									cari_db : donem_db,
									process_cat : form.process_cat,
									workcube_process_type : get_process_type.process_type,
									islem_tutari : 0,
									action_value2 : iif(money2_aktar eq 1,de('#borc2#'),de('')),
									other_money_value : iif((isdefined('attributes.is_other_money_transfer') and attributes.is_other_money_transfer eq 1),de('#borc3#'),de('#borc#')),
									other_money : iif((isdefined('attributes.is_other_money_transfer') and attributes.is_other_money_transfer eq 1),de('#temp_other_money#'),de('#session.ep.money#')),
									islem_tarihi : islem_tarihi,
									due_date : createodbcdate(date_add('d',VADE_ALACAK,islem_tarihi)),
									from_cmp_id : from_cmp_id,
									from_consumer_id : from_consumer_id,
									from_employee_id : from_employee_id,
									to_cmp_id : to_cmp_id,
									to_consumer_id : to_consumer_id,
									to_employee_id : to_employee_id,
									acc_type_id : acc_type_info,
									subscription_id : subscription_id_info,
									islem_detay : '#aciklama#',
									action_currency : '#session.ep.money#',
									account_card_type : 10,
									project_id : project_id_info,
									from_branch_id : branch_id_info
								);
							}
							//işlem dövizi 0 sistem dövizi dolu
							if(BAKIYE neq 0 and new_borc neq 0)
							{
								if(BAKIYE gt 0)
								{
									from_cmp_id = '';
									from_consumer_id = '';
									from_employee_id = '';
									to_cmp_id = company_info;
									to_consumer_id = consumer_info;
									to_employee_id = employee_info;
								}
								else
								{
									from_cmp_id = company_info;
									from_consumer_id = consumer_info;
									from_employee_id = employee_info;
									to_cmp_id = '';
									to_consumer_id = '';
									to_employee_id = '';
								}
								carici
								(
									action_id : -1,
									action_table : 'CARI_ROWS',
									cari_db : donem_db,
									process_cat : form.process_cat,
									workcube_process_type : get_process_type.process_type,
									islem_tutari : new_borc,
									action_value2 : iif(money2_aktar eq 1,de('#borc2#'),de('')),
									other_money_value : 0,
									other_money : iif((isdefined('attributes.is_other_money_transfer') and attributes.is_other_money_transfer eq 1),de('#temp_other_money#'),de('#session.ep.money#')),
									islem_tarihi : islem_tarihi,
									due_date : createodbcdate(date_add('d',VADE_ALACAK,islem_tarihi)),
									from_cmp_id : from_cmp_id,
									from_consumer_id : from_consumer_id,
									from_employee_id : from_employee_id,
									to_cmp_id : to_cmp_id,
									to_consumer_id : to_consumer_id,
									to_employee_id : to_employee_id,
									acc_type_id : acc_type_info,
									subscription_id : subscription_id_info,
									islem_detay : '#aciklama#',
									action_currency : '#session.ep.money#',
									account_card_type : 10,
									project_id : project_id_info,
									from_branch_id : branch_id_info
								);
							}
						}
					}
					if(kontrol_devir eq 0 and new_borc neq 0)
					{
						carici
						(
							action_id : -1,
							action_table : 'CARI_ROWS',
							cari_db : donem_db,
							process_cat : form.process_cat,
							workcube_process_type :get_process_type.process_type,
							islem_tutari : new_borc,
							action_value2 : iif(money2_aktar eq 1,de('#borc2#'),de('')),
							other_money_value : iif((isdefined('attributes.is_other_money_transfer') and attributes.is_other_money_transfer eq 1),de('#borc3#'),de('#borc#')),
							other_money : iif((isdefined('attributes.is_other_money_transfer') and attributes.is_other_money_transfer eq 1),de('#temp_other_money#'),de('#session.ep.money#')),
							islem_tarihi : islem_tarihi,
							due_date : createodbcdate(date_add('d',VADE_BORC,islem_tarihi)),
							to_cmp_id : company_info,
							to_consumer_id : consumer_info,
							to_employee_id : employee_info,
							acc_type_id : acc_type_info,
							subscription_id : subscription_id_info,
							islem_detay : '#aciklama#',
							action_currency : '#session.ep.money#',
							account_card_type : 10,
							project_id : project_id_info,
							to_branch_id : branch_id_info
						);
					}
				}
			}
			</cfscript> 
		</cfoutput>
	<cfelse><!--- dosyadan acilis --->
		<cfif (get_period.PERIOD_YEAR eq 2004)>
			<cfset para_birimi = 'TL'>
		<cfelse>
			<cfset para_birimi = '#session.ep.money#'>
		</cfif>
		<cfloop from="1" to="#line_count#" index="add_cari_index">
			<cfif listlen(dosya[add_cari_index],';') lt 8>
				<cfset get_company.recordcount=0>
				<cfset line_error =1>
				<cfoutput>#add_cari_index#. Satırdaki Parametreler Eksik!<br/></cfoutput>
			<cfelse>
				<cfif isdefined("attributes.is_consumer")>
					<cfquery name="get_company" dbtype="query">
						SELECT 
							CONSUMER_ID 
						FROM 
							get_companies 
						WHERE
						<cfif attributes.file_comp_identifier eq 1>
							OZEL_KOD = '#trim(listgetat(dosya[add_cari_index],1,";"))#'
						<cfelseif  attributes.file_comp_identifier eq 4>
							MEMBER_CODE = '#trim(listgetat(dosya[add_cari_index],1,";"))#'
						<cfelse>
							TAX_NO = '#trim(listgetat(dosya[add_cari_index],1,";"))#'
						</cfif> 
					</cfquery>
				<cfelseif isdefined("attributes.is_employee")>
					<cfquery name="get_company" dbtype="query">
						SELECT 
							EMPLOYEE_ID 
						FROM 
							get_companies 
						WHERE
							EMPLOYEE_NO = '#trim(listgetat(dosya[add_cari_index],1,";"))#'
					</cfquery>
				<cfelse>
					<cfquery name="get_company" dbtype="query">
						SELECT 
							COMPANY_ID 
						FROM 
							get_companies 
						WHERE
						<cfif attributes.file_comp_identifier eq 1>
							OZEL_KOD = '#trim(listgetat(dosya[add_cari_index],1,";"))#'
						<cfelseif  attributes.file_comp_identifier eq 2>
							OZEL_KOD_1 = '#trim(listgetat(dosya[add_cari_index],1,";"))#'
						<cfelseif  attributes.file_comp_identifier eq 3>
							OZEL_KOD_2 = '#trim(listgetat(dosya[add_cari_index],1,";"))#'
						<cfelseif  attributes.file_comp_identifier eq 4>
							MEMBER_CODE = '#trim(listgetat(dosya[add_cari_index],1,";"))#'
						<cfelse>
							TAXNO = '#trim(listgetat(dosya[add_cari_index],1,";"))#'
						</cfif> 
					</cfquery>
				</cfif>
				<cfif not get_company.recordcount>
					<cfset line_error =1>
					<cfoutput>#add_cari_index#. Satırdaki #trim(listgetat(dosya[add_cari_index],1,";"))# Üye Bulunamadı!<br/></cfoutput>
				</cfif>
			</cfif>
			<cfif get_company.recordcount and trim(listgetat(dosya[add_cari_index],3,';')) neq 0>
				<cfset due_date = trim(listgetat(dosya[add_cari_index],8,';'))> <!--- odeme tarihi--->
				<cfif len(due_date) and due_date neq 0>
					<cfset due_date = createdate(right(due_date,4),mid(due_date,4,2),mid(due_date,1,2))> 
					<cfif isdate(due_date)>
						<cf_date due_date = 'due_date'>
					</cfif>
				</cfif>
				<cfif listlen(dosya[add_cari_index],';') gte 9>
					<cfset project_id_info = trim(listgetat(dosya[add_cari_index],9,';'))>
				<cfelse>
					<cfset project_id_info = "">
				</cfif>
				<cfif listlen(dosya[add_cari_index],';') gte 10>
					<cfset branch_id_info = trim(listgetat(dosya[add_cari_index],10,';'))>
				<cfelse>
					<cfset branch_id_info = "">
				</cfif>
				<cfif listlen(dosya[add_cari_index],';') gte 11 and len(trim(listgetat(dosya[add_cari_index],11,';')))>
					<cfset formatted_act_date = trim(listgetat(dosya[add_cari_index],11,';'))>
                    <cf_date tarih="formatted_act_date">
                    <cfset paper_act_date = formatted_act_date>
				<cfelse>
					<cfset paper_act_date = islem_tarihi>
				</cfif>
				<cfif listlen(dosya[add_cari_index],';') gte 12>
					<cfset cari_act_id = trim(listgetat(dosya[add_cari_index],12,';'))>
				<cfelse>
					<cfset cari_act_id = ''>
				</cfif>
				<cfif listlen(dosya[add_cari_index],';') gte 13>
					<cfset subscription_id_info = trim(listgetat(dosya[add_cari_index],13,';'))>
				<cfelse>
					<cfset subscription_id_info = ''>
				</cfif>
				<cfif isdefined("attributes.is_consumer")>
					<cfset consumer_info = get_company.CONSUMER_ID>
					<cfset company_info = ''>
					<cfset employee_info = ''>
				<cfelseif isdefined("attributes.is_employee")>
					<cfset consumer_info = ''>
					<cfset company_info = ''>
					<cfset employee_info = get_company.EMPLOYEE_ID>
				<cfelse>
					<cfset consumer_info = ''>
					<cfset company_info = get_company.COMPANY_ID>
					<cfset employee_info = ''>
				</cfif>
				<cfscript>
					bakiye = trim(listgetat(dosya[add_cari_index],3,';'));
					if(len(trim(listgetat(dosya[add_cari_index],6,';'))) and trim(listgetat(dosya[add_cari_index],6,';')) neq 0)
						other_money_value = trim(listgetat(dosya[add_cari_index],6,';'));
					else
						other_money_value = bakiye;
					if(len(trim(listgetat(dosya[add_cari_index],7,';'))) and trim(listgetat(dosya[add_cari_index],7,';')) neq 0)	
						other_money = trim(listgetat(dosya[add_cari_index],7,';'));
					else
						other_money = session.ep.money;
					if(len(trim(listgetat(dosya[add_cari_index],4,';'))) and trim(listgetat(dosya[add_cari_index],4,';')) neq 0)
						system_currency_2 = trim(listgetat(dosya[add_cari_index],4,';'));
					else
						system_currency_2 = session.ep.money2;
					if(len(trim(listgetat(dosya[add_cari_index],5,';'))) and trim(listgetat(dosya[add_cari_index],5,';')) neq 0)
						system_action_value_2 = trim(listgetat(dosya[add_cari_index],5,';'));
					else
						system_action_value_2 = '';
					if(trim(listgetat(dosya[add_cari_index],2,';')) is 'A'){
						alacak = abs(bakiye);
						carici
						(
							action_id : -1,
							action_table : 'CARI_ROWS',
							cari_db : donem_db,
							process_cat : form.process_cat,
							workcube_process_type : get_process_type.process_type,
							other_money_value : other_money_value,
							other_money : other_money,
							islem_tutari : alacak,
							islem_tarihi : islem_tarihi,
							from_cmp_id : company_info,
							from_consumer_id : consumer_info,
							from_employee_id : employee_info,
							from_branch_id : branch_id_info,
							islem_detay : '#aciklama#',
							action_currency : para_birimi,
							action_currency_2 : system_currency_2,
							action_value2 : iif(len(system_action_value_2),de('#system_action_value_2#'),de('')),
							due_date : iif((due_date neq 0),de('#due_date#'),de('')),
							paper_act_date : paper_act_date,
							account_card_type : 10,
							subscription_id : subscription_id_info,
							project_id : project_id_info,
							acc_type_id : cari_act_id
						);
					}
					else if (trim(listgetat(dosya[add_cari_index],2,';')) is 'B'){
						borc = abs(bakiye);
						carici
						(
							action_id : -1,
							action_table : 'CARI_ROWS',
							cari_db : donem_db,
							process_cat : form.process_cat,
							workcube_process_type : get_process_type.process_type,
							other_money_value : other_money_value,
							other_money : other_money,
							islem_tutari : borc,
							islem_tarihi : islem_tarihi,
							to_cmp_id : company_info,
							to_consumer_id : consumer_info,
							to_employee_id : employee_info,
							to_branch_id : branch_id_info,
							islem_detay : '#aciklama#',
							action_currency : para_birimi,
							action_currency_2 : system_currency_2,
							action_value2 : iif(len(system_action_value_2),de('#system_action_value_2#'),de('')),
							due_date : iif((due_date neq 0),de('#due_date#'),de('')),
							paper_act_date : paper_act_date,
							account_card_type : 10,
							project_id : project_id_info,
							subscription_id : subscription_id_info,
							acc_type_id : cari_act_id
						);
					}
				</cfscript>
			</cfif>
		</cfloop>
		<cffile action="delete" file="#upload_folder_##file_name#">
	</cfif>
</cfif>
<cfif line_error>
	<input type="button" value="<cf_get_lang_main no ='141.Kapat'>" onclick="self.close();">
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang no ='2510.Aktarım Tamamland'>!");
		self.close();
		wrk_opener_reload();
	</script>
	<cfabort>
</cfif>

