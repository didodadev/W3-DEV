<cfif salary gte 0>
	<cflock name="#CreateUUID()#" timeout="20">
		<cftransaction>
			<cfquery name="add_puantaj" datasource="#dsn#" result="MAX_ID">
				INSERT INTO
					#row_puantaj_table#
					(
						IN_OUT_ID,
						PUANTAJ_ID,
						EMPLOYEE_ID,
						SSK_NO,
						SALARY_TYPE,
						SALARY,
						MONEY,
						DAMGA_VERGISI_MATRAH,
						COCUK_PARASI,
						TOTAL_DAYS,
						TOTAL_HOURS,
						SSK_MATRAH,
						DAMGA_VERGISI,
						GELIR_VERGISI_MATRAH,
						GELIR_VERGISI,
						SSK_ISVEREN_CARPAN,
						SSK_ISCI_CARPAN,
						ISSIZLIK_ISCI_CARPAN,
						TAX_RATIO,
						KUMULATIF_GELIR_MATRAH,
						SSDF_ISCI_HISSESI,
						SSDF_ISVEREN_HISSESI,
						VERGI_INDIRIMI,
						OZEL_KESINTI,
						OZEL_KESINTI_2,
						EXT_TOTAL_HOURS_0,
						EXT_TOTAL_HOURS_1,
						EXT_TOTAL_HOURS_2,
						EXT_TOTAL_HOURS_3,
						SAKATLIK_INDIRIMI,
						TOTAL_SALARY,
						EXT_SALARY,
						GOCMEN_INDIRIMI,
						VERGI_IADESI,
						VERGI_IADE_DAMGA_VERGISI,
						ISSIZLIK_ISVEREN_HISSESI,
						SSK_ISVEREN_HISSESI,
						SSK_ISVEREN_HISSESI_GOV,
						SSK_ISVEREN_HISSESI_GOV_100,
						SSK_ISVEREN_HISSESI_GOV_80,
						SSK_ISVEREN_HISSESI_GOV_60,
						SSK_ISVEREN_HISSESI_GOV_40,
						SSK_ISVEREN_HISSESI_GOV_20,
						SSK_ISVEREN_HISSESI_GOV_100_DAY,
						SSK_ISVEREN_HISSESI_GOV_80_DAY,
						SSK_ISVEREN_HISSESI_GOV_60_DAY,
						SSK_ISVEREN_HISSESI_GOV_40_DAY,
						SSK_ISVEREN_HISSESI_GOV_20_DAY,
						SSK_ISVEREN_HISSESI_5921,
						SSK_ISVEREN_HISSESI_5921_DAY,
						SSK_ISVEREN_HISSESI_5084,
						SSK_ISVEREN_HISSESI_5510,
						SSK_ISVEREN_HISSESI_5746,
						SSK_ISVEREN_HISSESI_4691,
						SSK_ISVEREN_HISSESI_6111,
						SSK_ISVEREN_HISSESI_6486,
						SSK_ISVEREN_HISSESI_6322,
						GELIR_VERGISI_INDIRIMI_4691,		
						TOPLAM_YUVARLAMA,
						ISSIZLIK_ISCI_HISSESI,
						SSK_ISCI_HISSESI,
						NET_UCRET,
						TOTAL_PAY_SSK_TAX,
						TOTAL_PAY_SSK,
						TOTAL_PAY_TAX,
						TOTAL_PAY,
						KIDEM_WORKER,
						KIDEM_BOSS,
						GROSS_NET,
						SUNDAY_COUNT,
						OFFDAYS_COUNT,
						OFFDAYS_SUNDAY_COUNT,
						IZINLI_SUNDAY_COUNT,
						PAID_IZINLI_SUNDAY_COUNT,
						IZIN,
						IZIN_COUNT,
						IZIN_PAID,
						IZIN_PAID_COUNT,
						TRADE_UNION_DEDUCTION,
						AVANS,
						KIDEM_AMOUNT,
						IHBAR_AMOUNT,
						IHBAR_AMOUNT_NET,
						YILLIK_IZIN_AMOUNT,
						YILLIK_IZIN_AMOUNT_NET,
						SSK_MATRAH_SALARY,
						GVM_IZIN,
						GVM_IHBAR,
						SSK_WORK_HOURS,
						VERGI_INDIRIMI_5084,
						MAHSUP_G_VERGISI,
						SSK_ISCI_HISSESI_DUSULECEK,
						ISSIZLIK_ISCI_HISSESI_DUSULECEK,
						VERGI_ISTISNA_DAMGA_NET,
						VERGI_ISTISNA_DAMGA,
						VERGI_ISTISNA_SSK_NET,
						VERGI_ISTISNA_SSK,
						VERGI_ISTISNA_VERGI_NET,
						VERGI_ISTISNA_VERGI,
						VERGI_ISTISNA_TOTAL,
						ACCOUNT_BILL_TYPE,
						ACCOUNT_CODE,
						EXPENSE_CODE,
						ROW_DEPARTMENT_HEAD,
						UPDATE_DATE,
						UPDATE_IP,
						UPDATE_EMP,
						IS_KISMI_ISTIHDAM,
						EXT_TOTAL_HOURS_5,
						SUNDAY_COUNT_HOUR,
						IZINLI_SUNDAY_COUNT_HOUR,
						PAID_IZINLI_SUNDAY_COUNT_HOUR,
						OFFDAYS_COUNT_HOUR,
						OFFDAYS_SUNDAY_COUNT_HOUR,
						WORK_DAY_HOUR,
						ABSENT_DAYS,
						TOTAL_SALARY_HOURS,
                        HALF_OFFTIME_DAY_TOTAL,
                        HALF_OFFTIME_TOTAL_HOUR,
						EXT_TOTAL_HOURS_8,
						EXT_TOTAL_HOURS_9,
						EXT_TOTAL_HOURS_10,
						EXT_TOTAL_HOURS_11,
						EXT_TOTAL_HOURS_12
					)
				VALUES
				(
					#attributes.in_out_id#,
					#puantaj_id#,
					#attributes.EMPLOYEE_ID#,
					'#attributes.SOCIALSECURITY_NO#',
					<cfif len(get_hr_salary.salary_type)>
						#get_hr_salary.salary_type#,
					<cfelse>
						NULL,
					</cfif>
					<cfif len(get_hr_salary.salary)>
						#wrk_round(get_hr_salary.salary)#,
					<cfelse>
						NULL,
					</cfif>
					'#get_hr_salary.money#',
					#wrk_round(damga_vergisi_matrah)#,
					0,
					<cfif get_hr_salary.salary_type eq 0>
						#work_days#,
						#TOTAL_HOURS#,
					<cfelseif get_hr_salary.salary_type eq 1>
						#work_days#,
						0,
					<cfelseif get_hr_salary.salary_type eq 2>
						#ssk_days#,
						0,
					</cfif>
					#wrk_round(SSK_MATRAH)#,
					#wrk_round(DAMGA_VERGISI)#,
					#wrk_round(GELIR_VERGISI_MATRAH)#,
					#wrk_round(GELIR_VERGISI)#,
					#wrk_round(ssk_isveren_carpan)#,
					#wrk_round(ssk_isci_carpan)#,
					#wrk_round(issizlik_isci_carpan)#,
					#wrk_round(tax_carpan)#,
					#wrk_round(kumulatif_gelir+GELIR_VERGISI_MATRAH)#,
					#wrk_round(SSDF_ISCI_HISSESI)#,
					#wrk_round(SSDF_ISVEREN_HISSESI)#,
					#wrk_round(VERGI_ISTISNA)#,
					#wrk_round(OZEL_KESINTI)#,
					#wrk_round(OZEL_KESINTI_2)#,
					#EXT_TOTAL_HOURS_0#,
					#EXT_TOTAL_HOURS_1#,
					#EXT_TOTAL_HOURS_2#,
					#EXT_TOTAL_HOURS_3#,
					#wrk_round(SAKATLIK_INDIRIMI)#,
					#wrk_round(SALARY)#,
					#wrk_round(EXT_SALARY)#,
					#wrk_round(GOCMEN_INDIRIMI)#,
					#wrk_round(VERGI_IADESI)#,
					#wrk_round(VERGI_IADE_DAMGA_VERGISI)#,
					#wrk_round(ISSIZLIK_ISVEREN_HISSESI)#,
					#wrk_round(SSK_ISVEREN_HISSESI)#,
					#wrk_round(ssk_isveren_hissesi_gov)#,
					#wrk_round(ssk_isveren_hissesi_gov_100)#,
					#wrk_round(ssk_isveren_hissesi_gov_80)#,
					#wrk_round(ssk_isveren_hissesi_gov_60)#,
					#wrk_round(ssk_isveren_hissesi_gov_40)#,
					#wrk_round(ssk_isveren_hissesi_gov_20)#,
					#ssk_isveren_hissesi_gov_100_day#,
					#ssk_isveren_hissesi_gov_80_day#,
					#ssk_isveren_hissesi_gov_60_day#,
					#ssk_isveren_hissesi_gov_40_day#,
					#ssk_isveren_hissesi_gov_20_day#,
					#ssk_isveren_hissesi_5921#,
					#ssk_isveren_hissesi_5921_day#,
					#ssk_isveren_hissesi_5084#,
					#ssk_isveren_hissesi_5510#,
					#ssk_isveren_hissesi_5746#,
					#ssk_isveren_hissesi_4691#,
					#ssk_isveren_hissesi_6111#,
					#ssk_isveren_hissesi_6486#,
					#ssk_isveren_hissesi_6322#,
					#gelir_vergisi_indirimi_5746#,
					#gelir_vergisi_indirimi_4691#,
					0,
					#wrk_round(ISSIZLIK_ISCI_HISSESI)#,
					#wrk_round(SSK_ISCI_HISSESI)#,
					#wrk_round(NET_UCRET)#,
					#wrk_round(TOTAL_PAY_SSK_TAX)#,
					#wrk_round(TOTAL_PAY_SSK)#,
					#wrk_round(TOTAL_PAY_TAX)#,
					#wrk_round(TOTAL_PAY + TOTAL_PAY_D)#,
					#wrk_round(kidem_isci_payi)#,
					#wrk_round(kidem_isveren_payi)#,
					#get_hr_salary.gross_net#,
					#SUNDAY_COUNT#,
					#OFFDAYS_COUNT#,
					#OFFDAYS_SUNDAY_COUNT#,
					#IZINLI_SUNDAY_COUNT#,
					#PAID_IZINLI_SUNDAY_COUNT#,
					#IZIN#,
					#IZIN_COUNT#,
					#IZIN_PAID#,
					#IZIN_PAID_COUNT#,
					#sendika_indirimi#,
					#AVANS#,
					#wrk_round(attributes.KIDEM_AMOUNT)#,
					#wrk_round(attributes.IHBAR_AMOUNT)#,
					#wrk_round(attributes.ihbar_amount_net)#,
					#wrk_round(attributes.YILLIK_IZIN_AMOUNT)#,
					<cfif izin_netten_hesaplama eq 1 and attributes.yillik_izin_amount gt 0>
						#wrk_round(attributes.yillik_izin_amount_net)#,
					<cfelse>
						NULL,
					</cfif>
					#wrk_round(SSK_MATRAH_SALARY)#,
					#wrk_round(GVM_IZIN)#,
					#wrk_round(GVM_IHBAR)#,
					#GET_HOURS.SSK_WORK_HOURS#,
					#wrk_round(vergi_indirim_5084)#,
					#wrk_round(mahsup_edilecek_gelir_vergisi_)#,
					#wrk_round(ssk_isci_hissesi_dusulecek)#,
					#wrk_round(issizlik_isci_hissesi_dusulecek)#,
					#wrk_round(vergi_istisna_damga_tutar_net)#,
					#wrk_round(vergi_istisna_damga_tutar)#,
					#wrk_round(vergi_istisna_ssk_tutar_net)#,
					#wrk_round(vergi_istisna_ssk_tutar)#,
					#wrk_round(vergi_istisna_vergi_tutar_net)#,
					#wrk_round(vergi_istisna_vergi_tutar)#,
					#wrk_round(vergi_istisna_total)#,
					<cfif len(this_account_bill_type_)>
						#this_account_bill_type_#
					<cfelse>
						NULL
					</cfif>,
					'#this_account_code_#',
					'#this_expense_code_#',
					'#attributes.row_department_head#',
					#now()#,
					'#CGI.REMOTE_ADDR#',
					#SESSION.EP.USERID#,
					<cfif Len(get_hr_ssk.IS_KISMI_ISTIHDAM)>
						#get_hr_ssk.IS_KISMI_ISTIHDAM#
					<cfelse>
						0
					</cfif>,
					#EXT_TOTAL_HOURS_5#,
					#sunday_count_hour#,
					#izinli_sunday_count_hour#,
					#paid_izinli_sunday_count_hour#,
					#offdays_count_hour#,
					#offdays_sunday_count_hour#,
					#work_day_hour#,
					#absent_days#,
					<cfif get_hr_salary.salary_type eq 0>
						#work_days#
					<cfelse>
						0
					</cfif>,
                    #half_offtime_day_total#,
                    #get_half_offtimes_total_hour#,
					#EXT_TOTAL_HOURS_8#,
					#EXT_TOTAL_HOURS_9#,
					#EXT_TOTAL_HOURS_10#,
					#EXT_TOTAL_HOURS_11#,
					#EXT_TOTAL_HOURS_12#
				)
			</cfquery>
		</cftransaction>
	</cflock>
	
	<cfif ssk_matrah_bu_ay_devreden gt 0>
		<cfquery name="ADD_EXTRAS" datasource="#DSN#">
			INSERT INTO #add_puantaj_table#
				(
				PUANTAJ_ID,
				EMPLOYEE_PUANTAJ_ID,
				AMOUNT,
				AMOUNT_USED,
				IN_OUT_ID,
				EMPLOYEE_ID,
				SAL_MON,
				SAL_YEAR
				)
			VALUES
				(
				#puantaj_id#,
				#MAX_ID.IDENTITYCOL#,
				#ssk_matrah_bu_ay_devreden#,
				0,
				#attributes.in_out_id#,
				#attributes.EMPLOYEE_ID#,
				#attributes.sal_mon#,
				#attributes.sal_year#
				)
		</cfquery>
	</cfif>
	
	<cfquery name="upd_" datasource="#dsn#">
		UPDATE 
			#row_puantaj_table# 
		SET 
			SSK_DEVIR = #gecen_aydan_dusulecek#,
			SSK_DEVIR_LAST = #onceki_aydan_dusulecek#
		WHERE
			 EMPLOYEE_PUANTAJ_ID = #MAX_ID.IDENTITYCOL#
	</cfquery>
	
	<cfquery name="get_bank" datasource="#dsn#" maxrows="1">
		SELECT EMP_BANK_ID FROM EMPLOYEES_BANK_ACCOUNTS WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND DEFAULT_ACCOUNT = 1
	</cfquery>
	<cfif get_bank.recordcount>
		<cfquery name="upd_" datasource="#dsn#">
		UPDATE 
			#row_puantaj_table# 
		SET 
			EMP_BANK_ID = #get_bank.EMP_BANK_ID#
		WHERE
			EMPLOYEE_PUANTAJ_ID = #MAX_ID.IDENTITYCOL#
	</cfquery>
	</cfif>
	
	<!--- EK ÖDENEK KESİNTİ VE VERGİ MUAFİYETLERİ EKLENİR --->
	<cfloop from="1" to="#ArrayLen(puantaj_exts)#" index="ai">
		<cfquery name="ADD_EXTRAS" datasource="#DSN#">
			INSERT INTO #ext_puantaj_table#
				(
				PUANTAJ_ID,
				EMPLOYEE_PUANTAJ_ID,
				COMMENT_PAY,
				COMMENT_PAY_ID,
				PAY_METHOD,
				AMOUNT,
				AMOUNT_2,
				SSK,
				TAX,
				EXT_TYPE,
				CALC_DAYS,
				FROM_SALARY,
				IS_KIDEM,
				IS_ALL_PAY,
				YUZDE_SINIR,
				AMOUNT_PAY,
				COMPANY_ID,
				ACCOUNT_CODE,
				ACCOUNT_NAME,
				CONSUMER_ID,
				ACC_TYPE_ID
				)
			VALUES
				(
				#puantaj_id#,
				#MAX_ID.IDENTITYCOL#,
				'#puantaj_exts[ai][1]#',<!--- comment --->
				<cfif arraylen(puantaj_exts[ai]) gt 15 and len(puantaj_exts[ai][16])><!--- comment_pay_id --->
					#puantaj_exts[ai][16]#,
				<cfelse>
					NULL,
				</cfif>
				#puantaj_exts[ai][2]#,<!--- pay_method --->
				#puantaj_exts[ai][3]#,<!--- amount --->
				<cfif puantaj_exts[ai][6] eq 1 and puantaj_exts[ai][2] eq 2><!--- kesinti icin amount_2 yüzde karşılığı--->
					<cfif len(puantaj_exts[ai][9]) and (puantaj_exts[ai][9] eq 0)><!--- netden kesinti --->
						#(ozel_kesinti_net_ucreti / 100) * puantaj_exts[ai][3]#,
					<cfelse>
						#puantaj_exts[ai][8]#,
					</cfif>
				<cfelseif puantaj_exts[ai][8] gt 0>
					#puantaj_exts[ai][8]#,
				#puantaj_exts[ai][4]#,<!--- ssk --->
				#puantaj_exts[ai][5]#,<!--- tax --->
				#puantaj_exts[ai][6]#,<!--- ext_type --->
				#puantaj_exts[ai][7]#,<!--- calc_days --->
			<cfif len(puantaj_exts[ai][9])><!--- from_salary --->
				#puantaj_exts[ai][9]#,
			<cfelse>
				NULL,
			</cfif>
			<cfif len(puantaj_exts[ai][10])>
				#puantaj_exts[ai][10]#,
			<cfelse>
				NULL,
			</cfif>
			<cfif arraylen(puantaj_exts[ai]) gt 11 and len(puantaj_exts[ai][12])>
				#puantaj_exts[ai][12]#,
			<cfelse>
				0,
			</cfif>
			<cfif len(puantaj_exts[ai][11])>
				#puantaj_exts[ai][11]#
			<cfelse>
				NULL
			</cfif>,
			<cfif arraylen(puantaj_exts[ai]) gt 14 and len(puantaj_exts[ai][15])>
				#puantaj_exts[ai][15]#,
			<cfelse>
				NULL,
			</cfif>
			<cfif arraylen(puantaj_exts[ai]) gt 16 and len(puantaj_exts[ai][17])>
				'#puantaj_exts[ai][17]#',
			<cfelse>
				NULL,
			</cfif>
			<cfif arraylen(puantaj_exts[ai]) gt 17 and len(puantaj_exts[ai][18])>
				'#puantaj_exts[ai][18]#'
			<cfelse>
				NULL
			</cfif>,
			<cfif arraylen(puantaj_exts[ai]) gt 18 and len(puantaj_exts[ai][19])>
				'#puantaj_exts[ai][19]#',
			<cfelse>
				NULL,
			</cfif>
			<cfif arraylen(puantaj_exts[ai]) gt 19 and len(puantaj_exts[ai][20])>
				#puantaj_exts[ai][20]#,
			<cfelse>
				NULL,
			</cfif>
			<cfif arraylen(puantaj_exts[ai]) gt 20 and len(puantaj_exts[ai][21])>
				#puantaj_exts[ai][21]#
			<cfelse>
				NULL
			</cfif>
				)
		</cfquery>
	</cfloop>
	<!--- // EK ÖDENEK KESİNTİ VE VERGİ MUAFİYETLERİ EKLENİR --->
</cfif>
