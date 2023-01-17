<cftry>
<cfif salary gte 0>
	<cfscript>
		POSITION_BRANCH_ID = '';
		POSITION_DEPARTMENT_ID = '';
		POSITION_CODE = '';
		POSITION_NAME = '';
		UPPER_POSITION_CODE = '';
		UPPER_POSITION_CODE2 = '';
		UPPER_POSITION_NAME = '';
		UPPER_POSITION_NAME2 = '';
		UPPER_POSITION_EMPLOYEE = '';
		UPPER_POSITION_EMPLOYEE2 = '';
		UPPER_POSITION_EMPLOYEE_ID = '';
		UPPER_POSITION_EMPLOYEE_ID2 = '';
		POSITION_CAT_ID = '';
		TITLE_ID = '';
		FUNC_ID = '';
		ORGANIZATION_STEP_ID = '';
		KISMI_ISTIHDAM_GUN = '';
		KISMI_ISTIHDAM_SAAT = '';
	
		if(attributes.sal_year gte 2022 and wrk_round(salary) eq wrk_round(daily_minimum_wage_base))
		{
			daily_minimum_wage_base = 0;
			all_basic_wage = 0;
			daily_minimum_income_tax = 0;
			daily_minimum_wage_stamp_tax = 0;
			daily_minimum_wage = 0;
		}else if(attributes.sal_year gte 2022 and daily_minimum_income_tax)
		{
		/* 	daily_minimum_income_tax = temp_first_min_wage;
			income_tax_temp = temp_first_min_wage; */
		}
		if(isdefined("gelir_vergisi_matrah_temp") and gelir_vergisi_matrah_temp gt 0 and gelir_vergisi_matrah eq 0)
			gelir_vergisi_matrah = gelir_vergisi_matrah_temp;

		//sadece izinden dv ve gv kesiliyorsa
		if(isdefined("temp_stamp_tax_temp") and isdefined("temp_daily_minimum_wage_stamp_tax") and isdefined("temp_income_tax_temp") and isdefined("temp_damga_vergisi_matrah") and isdefined("gelir_vergisi_matrah_include_tax")){
			stamp_tax_temp = temp_stamp_tax_temp;
			daily_minimum_wage_stamp_tax = temp_daily_minimum_wage_stamp_tax;
			income_tax_temp = temp_income_tax_temp;
			damga_vergisi_matrah = temp_damga_vergisi_matrah;
			gelir_vergisi_matrah = gelir_vergisi_matrah_include_tax;
		}

	</cfscript>
    <cfquery name="get_kismi_istihdam" datasource="#dsn#">
    	SELECT 
        	KISMI_ISTIHDAM_GUN,
            KISMI_ISTIHDAM_SAAT
       	FROM
        	EMPLOYEES_IN_OUT
       	WHERE
        	IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> AND
            DUTY_TYPE = 6
    </cfquery>
	<cfquery name="get_position_info" datasource="#dsn#">
		SELECT
			EP.POSITION_NAME,
			EP.POSITION_CODE,
			EP.DEPARTMENT_ID,
			D.BRANCH_ID,
			EP.POSITION_CAT_ID,
			EP.TITLE_ID,
			EP.FUNC_ID,
			EP.ORGANIZATION_STEP_ID,
			EP.UPPER_POSITION_CODE,
			EP.UPPER_POSITION_CODE2,
			EP_UP1.POSITION_NAME AS PNAME,
			EP_UP2.POSITION_NAME AS PNAME2,
			EP_UP1.EMPLOYEE_NAME + ' ' + EP_UP1.EMPLOYEE_SURNAME AS UP_EMPLOYEE,
			EP_UP2.EMPLOYEE_NAME + ' ' + EP_UP2.EMPLOYEE_SURNAME AS UP_EMPLOYEE2,
			EP_UP1.EMPLOYEE_ID AS EMPLOYEE_ID1,
			EP_UP2.EMPLOYEE_ID AS EMPLOYEE_ID2
		FROM
			EMPLOYEE_POSITIONS EP
			INNER JOIN DEPARTMENT D ON EP.DEPARTMENT_ID = D.DEPARTMENT_ID
			LEFT JOIN EMPLOYEE_POSITIONS EP_UP1 ON EP.UPPER_POSITION_CODE = EP_UP1.POSITION_CODE
			LEFT JOIN EMPLOYEE_POSITIONS EP_UP2 ON EP.UPPER_POSITION_CODE2 = EP_UP2.POSITION_CODE
		WHERE
			EP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#"> AND
			D.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#last_branch_id#">
	</cfquery>
	<cfif not get_position_info.recordcount>
		<cfquery name="get_position_info" datasource="#dsn#">
			SELECT
				EP.POSITION_NAME,
				EP.POSITION_CODE,
				EP.DEPARTMENT_ID,
				D.BRANCH_ID,
				EP.POSITION_CAT_ID,
				EP.TITLE_ID,
				EP.FUNC_ID,
				EP.ORGANIZATION_STEP_ID,
				EP.UPPER_POSITION_CODE,
				EP.UPPER_POSITION_CODE2,
				EP_UP1.POSITION_NAME AS PNAME,
				EP_UP2.POSITION_NAME AS PNAME2,
				EP_UP1.EMPLOYEE_NAME + ' ' + EP_UP1.EMPLOYEE_SURNAME AS UP_EMPLOYEE,
				EP_UP2.EMPLOYEE_NAME + ' ' + EP_UP2.EMPLOYEE_SURNAME AS UP_EMPLOYEE2,
				EP_UP1.EMPLOYEE_ID AS EMPLOYEE_ID1,
				EP_UP2.EMPLOYEE_ID AS EMPLOYEE_ID2
			FROM
				EMPLOYEE_POSITIONS EP
				INNER JOIN DEPARTMENT D ON EP.DEPARTMENT_ID = D.DEPARTMENT_ID
				LEFT JOIN EMPLOYEE_POSITIONS EP_UP1 ON EP.UPPER_POSITION_CODE = EP_UP1.POSITION_CODE
				LEFT JOIN EMPLOYEE_POSITIONS EP_UP2 ON EP.UPPER_POSITION_CODE2 = EP_UP2.POSITION_CODE
			WHERE
				EP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#"> AND
				EP.IS_MASTER = 1
		</cfquery>
	</cfif>
	<cfif get_position_info.recordcount>
		<cfscript>
			POSITION_BRANCH_ID = get_position_info.BRANCH_ID;
			POSITION_DEPARTMENT_ID = get_position_info.DEPARTMENT_ID;
			POSITION_CODE = get_position_info.POSITION_CODE;
			POSITION_NAME = get_position_info.POSITION_NAME;
			UPPER_POSITION_CODE = get_position_info.UPPER_POSITION_CODE;
			UPPER_POSITION_CODE2 = get_position_info.UPPER_POSITION_CODE2;
			UPPER_POSITION_NAME = get_position_info.PNAME;
			UPPER_POSITION_NAME2 = get_position_info.PNAME2;
			UPPER_POSITION_EMPLOYEE = get_position_info.UP_EMPLOYEE;
			UPPER_POSITION_EMPLOYEE2 = get_position_info.UP_EMPLOYEE2;
			UPPER_POSITION_EMPLOYEE_ID = get_position_info.EMPLOYEE_ID1;
			UPPER_POSITION_EMPLOYEE_ID2 = get_position_info.EMPLOYEE_ID2;
			POSITION_CAT_ID = get_position_info.POSITION_CAT_ID;
			TITLE_ID = get_position_info.TITLE_ID;
			FUNC_ID = get_position_info.FUNC_ID;
			ORGANIZATION_STEP_ID = get_position_info.ORGANIZATION_STEP_ID;
			KISMI_ISTIHDAM_GUN = get_kismi_istihdam.KISMI_ISTIHDAM_GUN;
			KISMI_ISTIHDAM_SAAT = get_kismi_istihdam.KISMI_ISTIHDAM_SAAT;
		</cfscript>
	</cfif>	
    <!--- buradaki kontrol get_hr_compass.cfm dosyasına taşındı SG 20160105 95347 idli iş kaydı--->
	<!--- SG 20140213 nakil olan personelin kumulatif gelir vergisi matrahının aktarılması
	<cfset devreden_kumulatif_gelir_matrah = 0>
	<cfif len(get_hr_ssk.ex_in_out_id) and attributes.sal_mon eq 1>
		<cfquery name="get_det" datasource="#dsn#">
			SELECT B.COMPANY_ID FROM EMPLOYEES_IN_OUT EIO INNER JOIN BRANCH B ON EIO.BRANCH_ID = B.BRANCH_ID WHERE EIO.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_hr_ssk.ex_in_out_id#"> 
		</cfquery>
		<cfif (get_det.company_id eq get_hr_ssk.COMP_ID and get_program_parameters.tax_account_style eq 1) or get_program_parameters.tax_account_style eq 0><!--- nakil oldugu şirket aynı ise ve akış parametrelerinde gelir vergisi devir durumu şirket içi devir ise veya akış paramtresinde grup içi devir seçili ise--->
			<cfquery name="get_gelir_matrah" datasource="#dsn#">
				SELECT
					SUM(KUMULATIF_GELIR_MATRAH) AS KUMULATIF_GELIR_MATRAH
				FROM
					EMPLOYEES_PUANTAJ EP INNER JOIN EMPLOYEES_PUANTAJ_ROWS EPR ON EP.PUANTAJ_ID = EPR.PUANTAJ_ID 
				WHERE
					EPR.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_hr_ssk.ex_in_out_id#"> AND
					EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
					EP.SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
			</cfquery>
			<cfif get_gelir_matrah.recordcount and get_gelir_matrah.KUMULATIF_GELIR_MATRAH gt 0>
				<cfset devreden_kumulatif_gelir_matrah = get_gelir_matrah.KUMULATIF_GELIR_MATRAH>
			</cfif>
		</cfif>
    <cfelseif attributes.sal_mon eq 1> <!--- ocak ayında birden fazla ücret kartı varsa--->
    <cfquery name="get_gelir_matrah" datasource="#dsn#">
        SELECT
            SUM(KUMULATIF_GELIR_MATRAH) AS KUMULATIF_GELIR_MATRAH
        FROM
            EMPLOYEES_PUANTAJ EP INNER JOIN EMPLOYEES_PUANTAJ_ROWS EPR ON EP.PUANTAJ_ID = EPR.PUANTAJ_ID 
        WHERE
            EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
            EP.SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
            EPR.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
    </cfquery>
    <cfif get_gelir_matrah.recordcount and get_gelir_matrah.KUMULATIF_GELIR_MATRAH gt 0>
        <cfset devreden_kumulatif_gelir_matrah = get_gelir_matrah.KUMULATIF_GELIR_MATRAH>
    </cfif>
	</cfif>--->
	<cflock name="#CreateUUID()#" timeout="20">
		<cftransaction>
			<cfif get_hr_salary.salary_type eq 0>
				<cfset total_days_ = work_days>
			<cfelseif get_hr_salary.salary_type eq 1>
				<cfset total_days_ = work_days>
			<cfelseif get_hr_salary.salary_type eq 2>
				<cfset total_days_ = ssk_days>
			</cfif>
			<cfif get_hr_salary.salary_type eq 0><!--- saat--->
				<cfif get_hr_salary.gross_net neq 1> <!---brüt --->
					<cfset new_salary = get_hr_salary.salary>
				<cfelse> <!--- net--->	
					<!--- SG 20130919 kapatıldı <cfset new_salary = get_hr_salary.salary - total_pay_ssk_tax - total_pay_ssk - total_pay_tax - total_pay - ext_salary - attributes.ihbar_amount - attributes.kidem_amount - attributes.yillik_izin_amount + ozel_kesinti_2 - vergi_istisna_vergi_tutar>--->
					<cfset new_salary = salary - total_pay_ssk_tax - total_pay_ssk - total_pay_tax - total_pay - total_pay_d - ext_salary - attributes.ihbar_amount - attributes.kidem_amount - attributes.yillik_izin_amount + ozel_kesinti_2>
					<cfif total_hours neq 0>
						<cfset new_salary = new_salary /total_hours>
					</cfif>
				</cfif>
			<cfelseif get_hr_salary.salary_type eq 1>
				<cfset new_salary = salary - total_pay_ssk_tax - total_pay_ssk - total_pay_tax - total_pay - total_pay_d  - ext_salary - attributes.ihbar_amount - attributes.kidem_amount - attributes.yillik_izin_amount + ozel_kesinti_2>
				<cfif work_days neq 0>
					<cfset new_salary = new_salary / work_days * ssk_full_days>
				</cfif>
			<cfelseif get_hr_salary.salary_type eq 2>
				<cfset new_salary = salary - total_pay_ssk_tax - total_pay_ssk - total_pay_tax - total_pay - total_pay_d  - ext_salary - attributes.ihbar_amount - attributes.kidem_amount - attributes.yillik_izin_amount + ozel_kesinti_2- vergi_istisna_vergi_tutar>
				<cfif ssk_days neq 0>
					<cfset new_salary = new_salary / ssk_days * ssk_full_days>
				</cfif>
			</cfif>
			<!--- <cfif wrk_round(abs(numberFormat(salary,'0.0') - salary)) eq 0.01 and get_hr_salary.gross_net neq 1 and use_ssk neq 2>
				<cfset salary =  numberFormat(salary,'0.0')>
			</cfif> --->
			<cfif wrk_round(abs(numberFormat(damga_vergisi_matrah,'0.0') - damga_vergisi_matrah)) eq 0.01 and get_hr_salary.gross_net neq 1>
				<cfset damga_vergisi_matrah =  numberFormat(damga_vergisi_matrah,'0.0')>
			</cfif>
			<cfif wrk_round(abs(numberFormat(net_ucret-VERGI_IADESI-(OZEL_KESINTI+OZEL_KESINTI_2+AVANS),'0.0')- (net_ucret-VERGI_IADESI-(OZEL_KESINTI+OZEL_KESINTI_2+AVANS)))) eq 0.02 
				and get_hr_salary.gross_net eq 1 
				and ((len(OZEL_KESINTI) and OZEL_KESINTI gt 0) or (len(OZEL_KESINTI_2) and OZEL_KESINTI_2 gt 0))
			>
				<cfset net_ucret = net_ucret-0.01>
			</cfif> 
			<cfif get_hr_salary.gross_net eq 1 and isdefined("this_net_ucret") and
				(
					wrk_round(abs(numberFormat(this_net_ucret+wrk_round(VERGI_IADESI-(OZEL_KESINTI+OZEL_KESINTI_2+AVANS)),'0.0')- net_ucret)) eq 0.01 
					or
					(
						wrk_round(abs(numberFormat(this_net_ucret+wrk_round(VERGI_IADESI-(OZEL_KESINTI+OZEL_KESINTI_2+AVANS)),'0.0')- net_ucret)) eq 0.02 
						and
						vergi_istisna_total neq 0
					)
				)
				and (this_net_ucret+wrk_round(VERGI_IADESI-(OZEL_KESINTI+OZEL_KESINTI_2+AVANS)) - net_ucret) neq 0>
				<cfset net_ucret = net_ucret + 0.01>
			</cfif>
			<!--- Bordro Akış Parametrelerinde  5746 Damga Vergisi Çalışana Yansıtılsın mı? EVET seçili ise--->
			<cfif get_program_parameters.IS_5746_STAMPDUTY eq 1>
				<cfset net_ucret = net_ucret + damga_vergisi_indirimi_5746>
				<cfset stampduty_5746 = damga_vergisi_indirimi_5746>
			<cfelse>
				<cfset stampduty_5746 = 0>
			</cfif>
			<cfscript>
				fazla_mesai_hafta_ici = (EXT_TOTAL_HOURS_0-EXT_TOTAL_HOURS_3) * get_program_parameters.EX_TIME_PERCENT / 100;			
				if(len(get_program_parameters.WEEKEND_MULTIPLIER))
					fazla_mesai_hafta_sonu = (EXT_TOTAL_HOURS_1 * get_program_parameters.WEEKEND_MULTIPLIER);
				else
					fazla_mesai_hafta_sonu = (EXT_TOTAL_HOURS_1 * get_program_parameters.EX_TIME_PERCENT / 100);				
				if(len(get_program_parameters.OFFICIAL_MULTIPLIER))	
					fazla_mesai_resmi_tatil = EXT_TOTAL_HOURS_2 * get_program_parameters.OFFICIAL_MULTIPLIER;
				else
					fazla_mesai_resmi_tatil = EXT_TOTAL_HOURS_2 * 100 / 100;				
				fazla_mesai_45 = EXT_TOTAL_HOURS_3 * get_program_parameters.EX_TIME_PERCENT_HIGH / 100;	
				if(len(get_program_parameters.NIGHT_MULTIPLIER))
					fazla_mesai_gece_calismasi = (EXT_TOTAL_HOURS_5 * get_program_parameters.NIGHT_MULTIPLIER);
				else
					fazla_mesai_gece_calismasi = (EXT_TOTAL_HOURS_5 * 10 / 100);	

					//----Muzaffer Bas---
					  
				if(len(get_program_parameters.WEEKEND_DAY_MULTIPLIER))
					fazla_mesai_hafta_sonu_gun=EXT_TOTAL_HOURS_8 * get_program_parameters.WEEKEND_DAY_MULTIPLIER;  //Hafta sonu Fazla Mesai Gün
				else 
					fazla_mesai_hafta_sonu_gun=EXT_TOTAL_HOURS_8 * get_program_parameters.EX_TIME_PERCENT/100;                            //Hafta sonu Fazla Mesai Gün
	
				if(len(get_program_parameters.AKDI_DAY_MULTIPLIER))
					fazla_mesai_akdi_gun=EXT_TOTAL_HOURS_9 * get_program_parameters.AKDI_DAY_MULTIPLIER;   //Akdi Fazla Mesai Gün
				else 
					fazla_mesai_akdi_gun=EXT_TOTAL_HOURS_9 * get_program_parameters.EX_TIME_PERCENT/100;                         //Akdi Fazla Mesai Gün	
						
				if(len(get_program_parameters.OFFICIAL_DAY_MULTIPLIER))
					fazla_mesai_resmi_tatil_gun=EXT_TOTAL_HOURS_10 * get_program_parameters.OFFICIAL_DAY_MULTIPLIER;  //Resmi Fazla Mesai Gün
				else 
					fazla_mesai_resmi_tatil_gun=EXT_TOTAL_HOURS_10 * get_program_parameters.EX_TIME_PERCENT/100;                            //Resmi Fazla Mesai Gün	
	
				if(len(get_program_parameters.ARAFE_DAY_MULTIPLIER))
					fazla_mesai_arafe_gun=EXT_TOTAL_HOURS_11 * get_program_parameters.ARAFE_DAY_MULTIPLIER;     //Arafe Fazla Mesai Gün
				else 
					fazla_mesai_arafe_gun=EXT_TOTAL_HOURS_11 * get_program_parameters.EX_TIME_PERCENT/100;                            //Arafe Fazla Mesai Gün
	
				if(len(get_program_parameters.DINI_DAY_MULTIPLIER))
					fazla_mesai_dini_gun=EXT_TOTAL_HOURS_12 * get_program_parameters.DINI_DAY_MULTIPLIER;       //Dini Bayram Fazla Mesai Gün
				else 
					fazla_mesai_dini_gun=EXT_TOTAL_HOURS_12 * get_program_parameters.EX_TIME_PERCENT/100;  		
			
				fazla_mesai_toplam =fazla_mesai_hafta_sonu_gun + fazla_mesai_akdi_gun + fazla_mesai_resmi_tatil_gun  + fazla_mesai_arafe_gun + fazla_mesai_dini_gun + fazla_mesai_hafta_ici + fazla_mesai_hafta_sonu + fazla_mesai_resmi_tatil + fazla_mesai_45 + fazla_mesai_gece_calismasi;
				//fazla_mesai_toplam = fazla_mesai_hafta_ici + fazla_mesai_hafta_sonu + fazla_mesai_resmi_tatil + fazla_mesai_45 + fazla_mesai_gece_calismasi;
					  //---Muzaffer Bit--		
		
				if (fazla_mesai_toplam neq 0)
				{
					t_ext_salary_0 = ((EXT_SALARY/fazla_mesai_toplam) * (fazla_mesai_hafta_ici + fazla_mesai_45));
					t_ext_salary_1 = ((EXT_SALARY/fazla_mesai_toplam) * fazla_mesai_hafta_sonu);
					t_ext_salary_2 = ((EXT_SALARY/fazla_mesai_toplam) * fazla_mesai_resmi_tatil);
					t_ext_salary_5 = ((EXT_SALARY/fazla_mesai_toplam) * fazla_mesai_gece_calismasi);
					//---Muzaffer Bas---
					t_ext_salary_8 = ((EXT_SALARY/fazla_mesai_toplam) * fazla_mesai_hafta_sonu_gun);
					t_ext_salary_9 = ((EXT_SALARY/fazla_mesai_toplam) * fazla_mesai_akdi_gun);
					t_ext_salary_10 = ((EXT_SALARY/fazla_mesai_toplam) * fazla_mesai_resmi_tatil_gun);
					t_ext_salary_11 = ((EXT_SALARY/fazla_mesai_toplam) * fazla_mesai_arafe_gun);
					t_ext_salary_12 = ((EXT_SALARY/fazla_mesai_toplam) * fazla_mesai_dini_gun);
				}
				else
				{
					t_ext_salary_0 = 0;
					t_ext_salary_1 = 0;
					t_ext_salary_2 = 0;
					t_ext_salary_5 = 0;
					//---Muzaffer Bas---
					t_ext_salary_8 = 0;
					t_ext_salary_9 = 0;
					t_ext_salary_10 = 0;
					t_ext_salary_11 = 0;
					t_ext_salary_12 = 0;
					//---Muzaffer Bit---
				}
			</cfscript>
			
            <cfif offdays_count gt total_days_>
				<cfset offdays_count_ = total_days_>
           <cfelse>
                <cfset offdays_count_ = offdays_count>
            </cfif>
			<cfif izin_paid gt total_days_>
            	<cfset izin_paid = total_days_>
            <cfelse>
            	<cfset izin_paid = izin_paid>
				<cfset normal_day = total_days_-(sunday_count-paid_izinli_sunday_count-offdays_sunday_count-izinli_sunday_count)-izin_paid-offdays_count_>
 
				<cfif isdefined("is_general_offtime") and is_general_offtime eq 1 and normal_day lt 0 >
					<cfset izin_paid = izin_paid + normal_day>
				</cfif> 
				<!--- 2 defa genel tatili çıkarıyor
				<cfif isdefined("is_general_offtime") and is_general_offtime eq 1>
					<cfset izin_paid = izin_paid - offdays_count_>
				</cfif>
				---->
			</cfif>
         
            <cfif get_hr_salary.salary_type eq 0> <!--- saat--->
                <cfset weekly_amount = (total_hours-(sunday_count_hour-paid_izinli_sunday_count_hour-offdays_sunday_count_hour-izinli_sunday_count_hour)-izin_paid_count-offdays_count_hour)*new_salary>
                <cfset weekend_amount = (sunday_count_hour-paid_izinli_sunday_count_hour-offdays_sunday_count_hour-izinli_sunday_count_hour)*new_salary>
                <cfset offdays_amount = offdays_count_hour*new_salary>
                <cfset izin_paid_amount = izin_paid_count*new_salary>
                <cfset izin_sunday_paid_amount = paid_izinli_sunday_count_hour*new_salary>
				<cfset t_akdi_total=akdi_day*new_salary>
			<cfelseif get_hr_salary.salary_type eq 1><!---- Günlük--->
				<cfset weekly_amount = (((total_days_-(sunday_count-paid_izinli_sunday_count-offdays_sunday_count-izinli_sunday_count)-izin_paid-offdays_count_) / ssk_full_days) * new_salary) >
				<cfif wrk_round(abs(numberFormat(weekly_amount,'0.0') - weekly_amount)) eq 0.01>
					<cfset weekly_amount =  numberFormat(weekly_amount,'0.0')>
				</cfif>
				<cfset weekend_amount = (sunday_count-paid_izinli_sunday_count-offdays_sunday_count-izinli_sunday_count)/ssk_full_days*new_salary>	
                <cfset offdays_amount = (offdays_count)/ssk_full_days*new_salary>	
                <cfset izin_paid_amount = (izin_paid)/ssk_full_days*new_salary>			
                <cfset izin_sunday_paid_amount = (paid_izinli_sunday_count)/ssk_full_days*new_salary>
            <cfelse>	
                <cfif (total_days_-(sunday_count-paid_izinli_sunday_count-offdays_sunday_count-izinli_sunday_count)-izin_paid-offdays_count_) lt 0><!--- 31 çeken aylarda total_days_ 30 olduğunda normal gün değeri - ye düşüyor bu nedenle kontrol eklendi--->
                    <cfset weekly_amount =0>
                <cfelse>
                    <cfset weekly_amount = (((total_days_-(sunday_count-paid_izinli_sunday_count-offdays_sunday_count-izinli_sunday_count)-izin_paid-offdays_count_) / ssk_full_days) * new_salary) - half_offtime_day_total>
                </cfif>	
                <cfset weekend_amount = (sunday_count-paid_izinli_sunday_count-offdays_sunday_count-izinli_sunday_count)/ssk_full_days*new_salary>	
                <cfset offdays_amount = (offdays_count)/ssk_full_days*new_salary>	
                <cfset izin_paid_amount = (izin_paid)/ssk_full_days*new_salary>
                <cfset izin_sunday_paid_amount = (paid_izinli_sunday_count)/ssk_full_days*new_salary>
            </cfif>
			<cfif not isdefined("get_half_offtimes_total_hour")>
            	<cfset get_half_offtimes_total_hour = get_half_offtimes.total_hour>
            </cfif>
            <cfquery name="GET_EMPLOYEE_TYPE" datasource="#dsn#">
            	SELECT TOP 1 GROSS_NET FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = #attributes.employee_id# ORDER BY IN_OUT_ID DESC
            </cfquery>          
            <cfif GET_EMPLOYEE_TYPE.GROSS_NET eq 0>
				<cfset totalControl = WEEKLY_AMOUNT+WEEKEND_AMOUNT+OFFDAYS_AMOUNT+IZIN_PAID_AMOUNT-BES_ISCI_HISSESI>
                <cfset totalKesinti = OZEL_KESINTI+OZEL_KESINTI_2+AVANS>
                
				<cfquery name="GET_START_FINISH" datasource="#dsn#">
                    SELECT 
                        EMPLOYEE_ID
                    FROM
                    	EMPLOYEES_IN_OUT
                    WHERE
                    	EMPLOYEE_ID = #attributes.employee_id#
                        AND
                    	(
							(
                                YEAR(START_DATE) = #attributes.sal_year#
                                AND MONTH(START_DATE) = #attributes.sal_mon#
								AND ISNULL(EX_IN_OUT_ID,0) = 0
                            )
                            OR
                            (
                                YEAR(FINISH_DATE) = #attributes.sal_year#
                                AND MONTH(FINISH_DATE) = #attributes.sal_mon#
                            )
                        )
    			</cfquery>
                
                <cfquery name="getPuantajRows" datasource="#dsn#">
                	SELECT
                        EPR.SSK_MATRAH,
                        EPR.SSK_DAYS,
                        EP.SAL_MON,
                        EPR.EXT_SALARY,
                        EPR.NET_UCRET,
                        EPR.VERGI_IADESI,
                        EPR.AVANS,
                        EP.PUANTAJ_ID,
                        EPR.EMPLOYEE_PUANTAJ_ID
                    FROM
                        EMPLOYEES_PUANTAJ EP,
                        EMPLOYEES_PUANTAJ_ROWS EPR
                    WHERE
                        EP.PUANTAJ_ID = EPR.PUANTAJ_ID AND
                        EPR.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> AND
                        EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#">
                        AND EPR.SSK_MATRAH > 0
                        AND EPR.SSK_DAYS > 0 AND EPR.SSK_MATRAH > 0 AND ROUND(EPR.SSK_MATRAH/EPR.SSK_DAYS,2) > 119.25 <!--- bu yilin günlük brüt asgari ucret tutarı (brüt/30)--->
                </cfquery>
                <cfif getPuantajRows.recordcount eq 0>
                    <cfquery name="getExtRows" datasource="#dsn#">
                        SELECT EMPLOYEE_PUANTAJ_EXT_ID FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE EMPLOYEE_PUANTAJ_ID IN (
                        SELECT
                            EPR.EMPLOYEE_PUANTAJ_ID
                        FROM
                            EMPLOYEES_PUANTAJ EP,
                            EMPLOYEES_PUANTAJ_ROWS EPR
                        WHERE
                            EP.PUANTAJ_ID = EPR.PUANTAJ_ID AND
                            EPR.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> AND
                            EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#">
                        )
						AND EXT_TYPE = 0 <!--- Sadece Ek Ödeneklere Bakması doğru --->
                    </cfquery>
                    <cfif getExtRows.recordcount eq 0 and get_hr_salary.SSK_STATUTE neq 3>
						<cfif listFindNoCase('8,9,10,11,12',attributes.sal_mon) and attributes.sal_year eq 2021 and is_discount_off_ neq 1><!--- İlave AGİ 2021 --->
							<cfif LSParseNumber(totalControl) lte 3577.5 and IZIN eq 0>
                                <cfif not GET_START_FINISH.recordcount>
                                    <cfset extraAgi = 2825.9 - net_ucret - totalKesinti>
                                    <cfif extraAgi gt 0>
                                        <cfset VERGI_IADESI = VERGI_IADESI + extraAgi>
                                        <cfset NET_UCRET = NET_UCRET + extraAgi>
                                        <cfset GELIR_VERGISI = GELIR_VERGISI - extraAgi>
										<cfif(ssk_days gt 0 and law_number_7103 neq 0 and gelir_vergisi_indirimi_7103 gte extraAgi)>
											<cfset	gelir_vergisi_indirimi_7103 = gelir_vergisi_indirimi_7103 - extraAgi>
										</cfif>
                                    </cfif>
                                </cfif>
                            <cfelse>
                                <cfset VERGI_IADESI = VERGI_IADESI>
                                <cfset NET_UCRET = NET_UCRET>
                                <cfset GELIR_VERGISI = GELIR_VERGISI>
                            </cfif>
                        </cfif>
                    </cfif>
                </cfif>
			</cfif>

			<!--- Normal Gün --->
		
			<cfif (total_days_-(sunday_count-paid_izinli_sunday_count-offdays_sunday_count-izinli_sunday_count)-izin_paid-offdays_count_) lt 0><!--- 31 çeken aylarda total_days_ 30 olduğunda normal gün değeri - ye düşüyor bu nedenle kontrol eklendi--->
				<cfset weekly_day = 0>
			<cfelse>
				<cfset weekly_day = (total_days_-(sunday_count-paid_izinli_sunday_count-offdays_sunday_count-izinli_sunday_count)-izin_paid-offdays_count_)>
			</cfif>
		
			<!--- Çalışan günlükse --->
			<cfif (total_days_-(sunday_count-paid_izinli_sunday_count-offdays_sunday_count-izinli_sunday_count)-izin_paid-offdays_count_) lt 0><!--- 31 çeken aylarda total_days_ 30 olduğunda normal gün değeri - ye düşüyor bu nedenle kontrol eklendi--->
				<cfset weekly_hour = 0>
			<cfelse>
				<cfset weekly_hour = (weekly_day-t_akdi_day)*get_hours.ssk_work_hours-half_time_hour>
			</cfif>

			<cfset weekend_hour = (sunday_count-paid_izinli_sunday_count-offdays_sunday_count-izinli_sunday_count)*get_hours.ssk_work_hours>
		
			<cfif get_hr_salary.salary_type eq 0><!--- Saatlik çalışan --->
				<cfset izin_paid_amount = izin_paid_count * new_salary><!--- ÜCretli izin tutarı --->
			<cfelse>
				<cfif included_in_tax_paid_amount_brut eq 0>
					<cfset izin_paid_amount = (izin_paid)* hourly_salary_brut * get_hours.ssk_work_hours>
				<cfelse>
					<cfset izin_paid_amount = included_in_tax_paid_amount_brut>
				</cfif>
			</cfif>

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
						TAX_DAYS_5746,
						SSK_DAYS_5746,
                        SSK_DAYS,
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
						OZEL_KESINTI_2_NET_FARK,
						OZEL_KESINTI_2_NET,
						EXT_TOTAL_HOURS_0,
						EXT_TOTAL_HOURS_1,
						EXT_TOTAL_HOURS_2,
						EXT_TOTAL_HOURS_3,
						SAKATLIK_INDIRIMI,
						TOTAL_SALARY,
						EXT_SALARY,
                        EXT_SALARY_NET,
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
						SSK_ISCI_HISSESI_6322,
						SSK_ISVEREN_HISSESI_25510,
                        SSK_ISVEREN_HISSESI_14857,
						SSK_ISVEREN_HISSESI_3294,
                        SSK_ISVEREN_HISSESI_6645,
                        SSK_ISVEREN_HISSESI_46486,
                        SSK_ISVEREN_HISSESI_56486,
                        SSK_ISVEREN_HISSESI_66486,
						GELIR_VERGISI_INDIRIMI_5746,
						DAMGA_VERGISI_INDIRIMI_5746,
						GELIR_VERGISI_INDIRIMI_4691,
						TOPLAM_YUVARLAMA,
						ISSIZLIK_ISCI_HISSESI,
						SSK_ISCI_HISSESI,
                        BES_ISCI_HISSESI,
                        BES_ISCI_CARPAN,
						NET_UCRET,
						TOTAL_PAY_SSK_TAX,
						TOTAL_PAY_SSK,
						TOTAL_PAY_TAX,
						TOTAL_PAY,
						KIDEM_WORKER,
						KIDEM_BOSS,
						GROSS_NET,
						SSK_STATUTE,
						SABIT_PRIM,
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
						IHBAR_AMOUNT,
						IHBAR_AMOUNT_NET,
						KIDEM_AMOUNT,
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
                        SSK_MATRAH_EXEMPTION,
						TAX_MATRAH_EXEMPTION,
						TAX_MATRAH_EXEMPTION_GET_ALL,
						TAX_MATRAH_EXEMPTION_GET,						
						TOTAL_SALARY_HOURS,
						POSITION_BRANCH_ID,
						POSITION_DEPARTMENT_ID,
						POSITION_CODE,
						POSITION_NAME,
						UPPER_POSITION_CODE,
						UPPER_POSITION_CODE2,
						UPPER_POSITION_NAME,
						UPPER_POSITION_NAME2,
						UPPER_POSITION_EMPLOYEE,
						UPPER_POSITION_EMPLOYEE2,
						UPPER_POSITION_EMPLOYEE_ID,
						UPPER_POSITION_EMPLOYEE_ID2,
						POSITION_CAT_ID,
						TITLE_ID,
						FUNC_ID,
						ORGANIZATION_STEP_ID,
                        KISMI_ISTIHDAM_GUN,
                        KISMI_ISTIHDAM_SAAT,
						DEPARTMENT_ID,
                        HALF_OFFTIME_DAY_TOTAL,
                        HALF_OFFTIME_DAY_TOTAL_NET,
                        HALF_OFFTIME_TOTAL_HOUR,
						YILLIK_IZIN_AMOUNT_GELIR_VERGISI,
						YILLIK_IZIN_AMOUNT_DAMGA_VERGISI,
						YILLIK_IZIN_AMOUNT_SSK_ISVEREN_HISSESI,
						YILLIK_IZIN_AMOUNT_SSK_ISCI_HISSESI,
						YILLIK_IZIN_AMOUNT_SSK_ISVEREN_ISSIZLIK,
						YILLIK_IZIN_AMOUNT_SSK_ISCI_ISSIZLIK,
						IHBAR_AMOUNT_GELIR_VERGISI,
						IHBAR_AMOUNT_DAMGA_VERGISI,
						KIDEM_AMOUNT_NET,
						KIDEM_AMOUNT_DAMGA_VERGISI,
						WEEKLY_DAY,
						WEEKLY_HOUR,
						WEEKEND_DAY,
						WEEKEND_HOUR,
						WEEKLY_AMOUNT,
						WEEKEND_AMOUNT,
						OFFDAYS_AMOUNT,
						IZIN_AMOUNT,
						IZIN_PAID_AMOUNT,
						IZIN_SUNDAY_PAID_AMOUNT,
						EXT_TOTAL_HOURS_0_AMOUNT,
						EXT_TOTAL_HOURS_1_AMOUNT,
						EXT_TOTAL_HOURS_2_AMOUNT,
						EXT_TOTAL_HOURS_5_AMOUNT,
						TOTAL_AMOUNT,
						SSK_AMOUNT,
						TAX_ACCOUNT_STYLE,
						IS_5746_CONTROL,
						IS_4691_CONTROL,
                        SSK_ISVEREN_HISSESI_687,
                        SSK_ISCI_HISSESI_687,
                        ISSIZLIK_ISCI_HISSESI_687,
                        ISSIZLIK_ISVEREN_HISSESI_687,
                        GELIR_VERGISI_INDIRIMI_687,
                        DAMGA_VERGISI_INDIRIMI_687,
                        SSK_ISVEREN_HISSESI_7103,
                        SSK_ISCI_HISSESI_7103,
                        ISSIZLIK_ISCI_HISSESI_7103,
                        ISSIZLIK_ISVEREN_HISSESI_7103,
                        GELIR_VERGISI_INDIRIMI_7103,
                        DAMGA_VERGISI_INDIRIMI_7103,
						DAMGA_VERGISI_MATRAH_5746,
						GELIR_VERGISI_MATRAH_5746,
						SSK_MATRAH_5746,
                        LAW_NUMBER_7103,
						SHORT_WORKING_CALC,
						GVM_MATRAH_5746,
						SSK_ISVEREN_HISSESI_7252,
						SSK_ISCI_HISSESI_7252,
						ISSIZLIK_ISCI_HISSESI_7252,
						ISSIZLIK_ISVEREN_HISSESI_7252,
						IS_7252_CONTROL,
						SSK_DAYS_7252,
						SSK_ISVEREN_HISSESI_7256,
						SSK_ISCI_HISSESI_7256,
						ISSIZLIK_ISCI_HISSESI_7256,
						ISSIZLIK_ISVEREN_HISSESI_7256,
						BASE_AMOUNT_7256,
						IS_7256_PLUS,
						STAMPDUTY_5746,
						PAST_AGI_DAY_PAYROLL,
						DAILY_MINIMUM_WAGE_BASE_CUMULATE,
						MINIMUM_WAGE_CUMULATIVE,
						DAILY_MINIMUM_INCOME_TAX,
						DAILY_MINIMUM_WAGE_STAMP_TAX,
						DAILY_MINIMUM_WAGE,
						INCOME_TAX_TEMP,
						STAMP_TAX_TEMP,
						EXT_TOTAL_HOURS_8,
						EXT_TOTAL_HOURS_9,
						EXT_TOTAL_HOURS_10,
						EXT_TOTAL_HOURS_11,
						EXT_TOTAL_HOURS_12,
						EXT_TOTAL_HOURS_8_AMOUNT,
						EXT_TOTAL_HOURS_9_AMOUNT,
						EXT_TOTAL_HOURS_10_AMOUNT,
						EXT_TOTAL_HOURS_11_AMOUNT,
						EXT_TOTAL_HOURS_12_AMOUNT,
						AKDI_DAY,
						AKDI_HOUR,
						AKDI_AMOUNT,
						HEALTH_INSURANCE_PREMIUM_WORKER,
						HEALTH_INSURANCE_PREMIUM_EMPLOYER,
						DEATH_INSURANCE_PREMIUM_WORKER,
						DEATH_INSURANCE_PREMIUM_EMPLOYER,
						SHORT_TERM_PREMIUM_EMPLOYER,
						SENIORITY_SALARY
					)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#puantaj_id#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.SOCIALSECURITY_NO#">,
					<cfif len(get_hr_salary.salary_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_hr_salary.salary_type#">,<cfelse>NULL,</cfif>
					<cfif len(get_hr_salary.salary)><cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(get_hr_salary.salary)#">,<cfelse>NULL,</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_hr_salary.money#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(damga_vergisi_matrah)#">,
					0,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arge_gunu_tax#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arge_gunu#">,
                    <cfif get_hr_ssk.use_ssk eq 3>0<cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#ceiling(ssk_days)#"></cfif>,
					<cfif get_hr_salary.salary_type eq 0>
						<cfqueryparam cfsqltype="cf_sql_float" value="#ceiling(work_days)#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#TOTAL_HOURS#">,
					<cfelseif get_hr_salary.salary_type eq 1>
						<cfqueryparam cfsqltype="cf_sql_float" value="#ceiling(work_days)#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#work_days*get_hours.ssk_work_hours#">,
					<cfelseif get_hr_salary.salary_type eq 2>
						<cfqueryparam cfsqltype="cf_sql_float" value="#ceiling(ssk_days)#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#work_days*get_hours.ssk_work_hours#">,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(SSK_MATRAH)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(DAMGA_VERGISI)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(GELIR_VERGISI_MATRAH)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(GELIR_VERGISI)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(ssk_isveren_carpan)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(ssk_isci_carpan)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(issizlik_isci_carpan)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(tax_carpan)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(kumulatif_gelir+GELIR_VERGISI_MATRAH)#">,<!--- +devreden_kumulatif_gelir_matrah SG 20160105--->
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(SSDF_ISCI_HISSESI)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(SSDF_ISVEREN_HISSESI)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(VERGI_ISTISNA)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(OZEL_KESINTI)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(OZEL_KESINTI_2)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(net_fark_ozel_kesinti_2)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(ozel_kesinti_2_net)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#EXT_TOTAL_HOURS_0#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#EXT_TOTAL_HOURS_1#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#EXT_TOTAL_HOURS_2#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#EXT_TOTAL_HOURS_3#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(SAKATLIK_INDIRIMI)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(SALARY)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(EXT_SALARY)#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(EXT_SALARY_NET)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(GOCMEN_INDIRIMI)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(VERGI_IADESI)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(VERGI_IADE_DAMGA_VERGISI)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(ISSIZLIK_ISVEREN_HISSESI)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(SSK_ISVEREN_HISSESI)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(ssk_isveren_hissesi_gov)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(ssk_isveren_hissesi_gov_100)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(ssk_isveren_hissesi_gov_80)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(ssk_isveren_hissesi_gov_60)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(ssk_isveren_hissesi_gov_40)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(ssk_isveren_hissesi_gov_20)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#ssk_isveren_hissesi_gov_100_day#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#ssk_isveren_hissesi_gov_80_day#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#ssk_isveren_hissesi_gov_60_day#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#ssk_isveren_hissesi_gov_40_day#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#ssk_isveren_hissesi_gov_20_day#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#ssk_isveren_hissesi_5921#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#ssk_isveren_hissesi_5921_day#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#ssk_isveren_hissesi_5084#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#ssk_isveren_hissesi_5510#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#ssk_isveren_hissesi_5746#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#ssk_isveren_hissesi_4691#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#ssk_isveren_hissesi_6111#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#ssk_isveren_hissesi_6486#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#ssk_isveren_hissesi_6322#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#ssk_isci_hissesi_6322#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#ssk_isveren_hissesi_25510#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#ssk_isveren_hissesi_14857#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#ssk_isveren_hissesi_3294#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#ssk_isveren_hissesi_6645#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#ssk_isveren_hissesi_46486#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#ssk_isveren_hissesi_56486#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#ssk_isveren_hissesi_66486#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#gelir_vergisi_indirimi_5746#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#damga_vergisi_indirimi_5746#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#gelir_vergisi_indirimi_4691#">,
					0,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(ISSIZLIK_ISCI_HISSESI)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(SSK_ISCI_HISSESI)#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(BES_ISCI_HISSESI)#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(BES_ISCI_CARPAN)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(NET_UCRET - wrk_round(bes_isci_hissesi))#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(TOTAL_PAY_SSK_TAX)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(TOTAL_PAY_SSK)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(TOTAL_PAY_TAX)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(TOTAL_PAY + TOTAL_PAY_D)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(kidem_isci_payi)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(kidem_isveren_payi)#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#get_hr_salary.gross_net#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#get_hr_salary.SSK_STATUTE#">,
					<cfif len(get_hr_salary.SABIT_PRIM)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_hr_salary.SABIT_PRIM#"><cfelse>0</cfif>,
					<cfif get_hr_salary.salary_type eq 0>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#sunday_count_hour/get_hours.ssk_work_hours#">,
					<cfelse>	
						<cfqueryparam cfsqltype="cf_sql_integer" value="#sunday_count#">,
					</cfif>
					<cfif get_hr_salary.use_pdks eq 3><!--- Tam bağlı gün ise --->
						<cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp_worktimes_days_gt.recordcount#">,
					<cfelseif get_hr_salary.salary_type eq 0>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#wrk_round(offdays_count_hour/get_hours.ssk_work_hours,2)#">,
					<cfelse>	
						<cfqueryparam cfsqltype="cf_sql_integer" value="#offdays_count#">,
					</cfif>
					<cfif get_hr_salary.salary_type eq 0>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#wrk_round(offdays_sunday_count_hour/get_hours.ssk_work_hours,2)#">,
					<cfelse>	
						<cfqueryparam cfsqltype="cf_sql_integer" value="#offdays_sunday_count#">,
					</cfif> 
					<cfif get_hr_salary.salary_type eq 0>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#wrk_round(izinli_sunday_count_hour/get_hours.ssk_work_hours,2)#">,
					<cfelse>	
						<cfqueryparam cfsqltype="cf_sql_integer" value="#izinli_sunday_count#">,
					</cfif>
					<cfif get_hr_salary.salary_type eq 0>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#wrk_round(paid_izinli_sunday_count_hour/get_hours.ssk_work_hours,2)#">,
					<cfelse>	
						<cfqueryparam cfsqltype="cf_sql_integer" value="#paid_izinli_sunday_count#">,
					</cfif>
					<cfif get_hr_salary.use_pdks eq 3><!--- Tam bağlı gün ise --->
						<cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp_offtimes_unpaid.recordcount#">,
					<cfelseif get_hr_salary.salary_type eq 0>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#fix(izin_count/get_hours.ssk_work_hours)#">,<!--- ucretsiz izin gunu alanında ondalıklı sayı gorunmemesi ve asagı yuvarlama icin fix yapıldı.SG20131113 --->
					<cfelse>	
						<cfqueryparam cfsqltype="cf_sql_float" value="#izin#">,
					</cfif>
					<cfif get_hr_salary.salary_type eq 0>
						<cfqueryparam cfsqltype="cf_sql_float" value="#izin_count#">,
					<cfelse>	
						<cfqueryparam cfsqltype="cf_sql_float" value="#izin*get_hours.ssk_work_hours#">,
					</cfif>
					<cfif get_hr_salary.use_pdks eq 3><!--- Tam bağlı gün ise --->
						<cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp_offtimes_paid.recordcount#">,
					<cfelseif get_hr_salary.salary_type eq 0>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#wrk_round(izin_paid_count/get_hours.ssk_work_hours,2)#">,
					<cfelse>	
						<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(izin_paid)#">,
					</cfif>
					<cfif get_hr_salary.salary_type eq 0>
						<cfqueryparam cfsqltype="cf_sql_float" value="#izin_paid_count#">,
					<cfelse>	
						<cfqueryparam cfsqltype="cf_sql_float" value="#izin_paid*get_hours.ssk_work_hours#">,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_float" value="#sendika_indirimi#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#AVANS#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(attributes.ihbar_amount)#">,
					<cfif ihbar_net gt 0>
                    	<cfqueryparam cfsqltype="cf_sql_float" value="#ihbar_net#">
                    <cfelse>
                    	<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(attributes.ihbar_amount_net)#">
                    </cfif>,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(attributes.kidem_amount)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(attributes.yillik_izin_amount)#">,
					<cfif yillik_izin_net gt 0>
						<cfqueryparam cfsqltype="cf_sql_float" value="#yillik_izin_net#">,
					<cfelse>
						<cfif izin_netten_hesaplama eq 1 and attributes.yillik_izin_amount gt 0>
							<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(attributes.yillik_izin_amount_net)#">,
						<cfelse>
							0,
						</cfif>
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(SSK_MATRAH_SALARY)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(GVM_IZIN)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(GVM_IHBAR)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#GET_HOURS.SSK_WORK_HOURS#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(vergi_indirim_5084)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(mahsup_edilecek_gelir_vergisi_)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(ssk_isci_hissesi_dusulecek)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(issizlik_isci_hissesi_dusulecek)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(vergi_istisna_damga_tutar_net)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(vergi_istisna_damga_tutar)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(vergi_istisna_ssk_tutar_net)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(vergi_istisna_ssk_tutar)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(vergi_istisna_vergi_tutar_net)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(vergi_istisna_vergi_tutar)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(vergi_istisna_total)#">,
					<cfif len(this_account_bill_type_)>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#this_account_bill_type_#">
					<cfelse>
						NULL
					</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#this_account_code_#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#this_expense_code_#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.row_department_head#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">,
					<cfif Len(get_hr_ssk.IS_KISMI_ISTIHDAM)>
						<cfqueryparam cfsqltype="cf_sql_bit" value="#get_hr_ssk.IS_KISMI_ISTIHDAM#">
					<cfelse>
						0
					</cfif>,
					<cfqueryparam cfsqltype="cf_sql_float" value="#EXT_TOTAL_HOURS_5#">,
					<cfif get_hr_salary.salary_type eq 0>
						<cfqueryparam cfsqltype="cf_sql_float" value="#sunday_count_hour#">,
					<cfelse>	
						<cfqueryparam cfsqltype="cf_sql_float" value="#sunday_count*get_hours.ssk_work_hours#">,
					</cfif> 
					<cfif get_hr_salary.salary_type eq 0>
						<cfqueryparam cfsqltype="cf_sql_float" value="#izinli_sunday_count_hour#">,
					<cfelse>	
						<cfqueryparam cfsqltype="cf_sql_float" value="#izinli_sunday_count*get_hours.ssk_work_hours#">,
					</cfif>
					<cfif get_hr_salary.salary_type eq 0>
						<cfqueryparam cfsqltype="cf_sql_float" value="#paid_izinli_sunday_count_hour#">,
					<cfelse>	 
						<cfqueryparam cfsqltype="cf_sql_float" value="#PAID_IZINLI_SUNDAY_COUNT*get_hours.ssk_work_hours#">,
					</cfif> 
					<cfif get_hr_salary.salary_type eq 0>
						<cfqueryparam cfsqltype="cf_sql_float" value="#offdays_count_hour#">,
					<cfelse>	
						<cfqueryparam cfsqltype="cf_sql_float" value="#offdays_count*get_hours.ssk_work_hours#">,
					</cfif>
					<cfif get_hr_salary.salary_type eq 0>
						<cfqueryparam cfsqltype="cf_sql_float" value="#offdays_sunday_count_hour#">,
					<cfelse>	
						<cfqueryparam cfsqltype="cf_sql_float" value="#offdays_sunday_count*get_hours.ssk_work_hours#">,
					</cfif>
					<cfif get_hr_salary.salary_type eq 0>
						<cfqueryparam cfsqltype="cf_sql_float" value="#work_day_hour#">,
					<cfelse>	 
						<cfqueryparam cfsqltype="cf_sql_float" value="#work_days*get_hours.ssk_work_hours#">,
					</cfif> 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#absent_days#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#ssk_matraha_dahil_olmayan_odenek_tutar#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#vergi_matraha_dahil_olmayan_odenek_tutar#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#vergi_matraha_dahil_olmayan_kesinti_tutar#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#damga_matraha_dahil_olmayan_kesinti_tutar#">,
					<cfif get_hr_salary.salary_type eq 0>
						<cfqueryparam cfsqltype="cf_sql_float" value="#work_days#">
					<cfelse> 
						<cfqueryparam cfsqltype="cf_sql_float" value="#work_days*get_hours.ssk_work_hours#">
					</cfif>,
					<cfif len(POSITION_BRANCH_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#POSITION_BRANCH_ID#"><cfelse>NULL</cfif>,
					<cfif len(POSITION_DEPARTMENT_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#POSITION_DEPARTMENT_ID#"><cfelse>NULL</cfif>,
					<cfif len(POSITION_CODE)><cfqueryparam cfsqltype="cf_sql_integer" value="#POSITION_CODE#"><cfelse>NULL</cfif>,
					<cfif len(POSITION_NAME)><cfqueryparam cfsqltype="cf_sql_varchar" value="#POSITION_NAME#"><cfelse>NULL</cfif>,
					<cfif len(UPPER_POSITION_CODE)><cfqueryparam cfsqltype="cf_sql_integer" value="#UPPER_POSITION_CODE#"><cfelse>NULL</cfif>,
					<cfif len(UPPER_POSITION_CODE2)><cfqueryparam cfsqltype="cf_sql_integer" value="#UPPER_POSITION_CODE2#"><cfelse>NULL</cfif>,
					<cfif len(UPPER_POSITION_NAME)><cfqueryparam cfsqltype="cf_sql_varchar" value="#UPPER_POSITION_NAME#"><cfelse>NULL</cfif>,
					<cfif len(UPPER_POSITION_NAME2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#UPPER_POSITION_NAME2#"><cfelse>NULL</cfif>,
					<cfif len(UPPER_POSITION_EMPLOYEE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#UPPER_POSITION_EMPLOYEE#"><cfelse>NULL</cfif>,
					<cfif len(UPPER_POSITION_EMPLOYEE2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#UPPER_POSITION_EMPLOYEE2#"><cfelse>NULL</cfif>,
					<cfif len(UPPER_POSITION_EMPLOYEE_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#UPPER_POSITION_EMPLOYEE_ID#"><cfelse>NULL</cfif>,
					<cfif len(UPPER_POSITION_EMPLOYEE_ID2)><cfqueryparam cfsqltype="cf_sql_integer" value="#UPPER_POSITION_EMPLOYEE_ID2#"><cfelse>NULL</cfif>,
					<cfif len(POSITION_CAT_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#POSITION_CAT_ID#"><cfelse>NULL</cfif>,
					<cfif len(TITLE_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#TITLE_ID#"><cfelse>NULL</cfif>,
					<cfif len(FUNC_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#FUNC_ID#"><cfelse>NULL</cfif>,
					<cfif len(ORGANIZATION_STEP_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#ORGANIZATION_STEP_ID#"><cfelse>NULL</cfif>,
                    <cfif len(KISMI_ISTIHDAM_GUN)><cfqueryparam cfsqltype="cf_sql_integer" value="#KISMI_ISTIHDAM_GUN#"><cfelse>NULL</cfif>,
                    <cfif len(KISMI_ISTIHDAM_SAAT)><cfqueryparam cfsqltype="cf_sql_float" value="#KISMI_ISTIHDAM_SAAT#"><cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#get_hr_ssk.DEPARTMENT_ID#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#half_offtime_day_total#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#half_offtime_day_total_net#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#get_half_offtimes_total_hour#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#yillik_izin_gelir_vergisi#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#yillik_izin_damga_vergisi#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#yillik_izin_isveren_toplam#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#yillik_izin_isci_toplam#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#yillik_izin_isveren_issizlik_toplam#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#yillik_izin_isci_issizlik_toplam#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#ihbar_gelir_vergisi#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#ihbar_damga_vergisi#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#kidem_net#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#kidem_damga_vergisi#">,
					<cfif get_hr_salary.use_pdks eq 3><!--- Tam bağlı gün ise --->
						<cfqueryparam cfsqltype="cf_sql_float" value="#get_emp_worktimes_days.recordcount#">
					<cfelseif get_hr_salary.salary_type eq 0>
						<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round((total_hours-(sunday_count_hour-offdays_sunday_count_hour-izinli_sunday_count_hour)-izin_paid_count-offdays_count_hour)/get_hours.ssk_work_hours,2)#">
					<cfelse>	
						#weekly_day#
					</cfif>,
					<cfif get_hr_salary.salary_type eq 0>
						<cfset weekly_hour = total_hours-(sunday_count_hour-offdays_sunday_count_hour-izinli_sunday_count_hour)-izin_paid_count-offdays_count_hour-half_time_hour>
						<cfqueryparam cfsqltype="cf_sql_float" value="#weekly_hour#">
					<cfelse>	
						<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(weekly_hour)#">
					</cfif>,
					<cfif get_hr_salary.salary_type eq 0>
						<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round((sunday_count_hour-offdays_sunday_count_hour-izinli_sunday_count_hour)/get_hours.ssk_work_hours,2)#">
					<cfelse>	
						<cfqueryparam cfsqltype="cf_sql_float" value="#sunday_count-paid_izinli_sunday_count-offdays_sunday_count-izinli_sunday_count#">
					</cfif>,
					<cfif get_hr_salary.salary_type eq 0>
						<cfqueryparam cfsqltype="cf_sql_float" value="#sunday_count_hour-offdays_sunday_count_hour-izinli_sunday_count_hour#">
					<cfelse>	
						<cfqueryparam cfsqltype="cf_sql_float" value="#weekend_hour#">
					</cfif>,
					<cfif get_hr_salary.salary_type eq 0> <!--- saat--->
						<cfset weekly_amount_calc = (total_hours-(sunday_count_hour-offdays_sunday_count_hour-izinli_sunday_count_hour)-izin_paid_count-offdays_count_hour)*new_salary>
						<cfset weekly_amount = (total_hours-(sunday_count_hour-paid_izinli_sunday_count_hour-offdays_sunday_count_hour-izinli_sunday_count_hour)-izin_paid_count-offdays_count_hour-t_akdi_hour)*new_salary>							
						<!---paid_izinli_sunday_count_hour kaldırılma sebebi 2 izin_paid_count içerisinde de bu değerin var olması. 2 defa çıkarıyor  --->
						<cfqueryparam cfsqltype="cf_sql_float" value="#weekly_amount_calc#">
					<cfelseif get_hr_salary.salary_type eq 1><!---- Günlük--->
						/*<cfset weekly_amount_calc = (((total_days_-(sunday_count-paid_izinli_sunday_count-offdays_sunday_count-izinli_sunday_count)-izin_paid-offdays_count_) / ssk_full_days) * new_salary) > */
						/* Günlük maaş üzerinden hesap yapıldı. */
						/*<cfset weekly_amount_calc = (((total_days_-(sunday_count-paid_izinli_sunday_count-offdays_sunday_count-izinli_sunday_count)-izin_paid-offdays_count_-t_akdi_day) / ssk_full_days) * new_salary) >*/<!---İmbat için bu çalışıyordu alt satır buna göre değiştirildi.--->
						<cfset weekly_amount_calc = (((total_days_-(sunday_count-paid_izinli_sunday_count-offdays_sunday_count-izinli_sunday_count)-izin_paid-offdays_count_-half_time_hour_day-t_akdi_day) * hourly_salary_brut * get_hours.ssk_work_hours)) >
						<cfif wrk_round(abs(numberFormat(weekly_amount_calc,'0.0') - weekly_amount_calc)) eq 0.01>
							<cfset weekly_amount_calc =  numberFormat(weekly_amount_calc,'0.0')>
						</cfif>
						<cfqueryparam cfsqltype="cf_sql_float" value="#weekly_amount_calc#">
					<cfelse>	
						<cfif (total_days_-(sunday_count-paid_izinli_sunday_count-offdays_sunday_count-izinli_sunday_count)-izin_paid-offdays_count_) lt 0><!--- 31 çeken aylarda total_days_ 30 olduğunda normal gün değeri - ye düşüyor bu nedenle kontrol eklendi--->
							<cfset weekly_amount_calc =0>
                            0
						<cfelse>
							<!--- <cfset weekly_amount = (((total_days_-(sunday_count-paid_izinli_sunday_count-offdays_sunday_count-izinli_sunday_count)-izin_paid-offdays_count_) / ssk_full_days) * (new_salary+half_offtime_day_total)) - half_offtime_day_total> --->
							<cfset weekly_amount_calc = weekly_hour  * hourly_salary_brut>
							<cfif wrk_round(abs(numberFormat(weekly_amount_calc,'0.0') - weekly_amount_calc)) eq 0.01>
								<cfset weekly_amount_calc =  numberFormat(weekly_amount_calc,'0.0')>
							</cfif>
                            <cfqueryparam cfsqltype="cf_sql_float" value="#weekly_amount_calc#">
						</cfif>					
                    </cfif>,
					<cfif get_hr_salary.salary_type eq 0>
						<cfset weekend_amount = (sunday_count_hour-paid_izinli_sunday_count_hour-offdays_sunday_count_hour-izinli_sunday_count_hour)*new_salary>
						<cfqueryparam cfsqltype="cf_sql_float" value="#(sunday_count_hour-offdays_sunday_count_hour-izinli_sunday_count_hour)*new_salary#">
					<cfelse>	
						<cfset weekend_amount = (sunday_count-paid_izinli_sunday_count-offdays_sunday_count-izinli_sunday_count) * hourly_salary_brut * get_hours.ssk_work_hours>
						<cfqueryparam cfsqltype="cf_sql_float" value="#weekend_amount#">
					</cfif>,
					<cfif get_hr_salary.salary_type eq 0>
						<cfset offdays_amount = offdays_count_hour*new_salary>
						<cfqueryparam cfsqltype="cf_sql_float" value="#offdays_amount#">
					<cfelse>	
						<cfset offdays_amount = (offdays_count)/ssk_full_days*new_salary>
						<cfqueryparam cfsqltype="cf_sql_float" value="#(offdays_count)* hourly_salary_brut * get_hours.ssk_work_hours#">
					</cfif>,
					<cfif get_hr_salary.salary_type eq 0>
						<cfqueryparam cfsqltype="cf_sql_float" value="#izin_count*new_salary#">
					<cfelse>	
						<!--- 
							Todo: İzinler saatlik ücrt üzerinden hesaplaması yapıldı. Sorun olmaz ise bu alan silinecek.
							<cfqueryparam cfsqltype="cf_sql_float" value="#(izin)/ssk_full_days*(new_salary+half_offtime_day_total)#">
						--->
						<cfqueryparam cfsqltype="cf_sql_float" value="#(izin) * hourly_salary_brut * get_hours.ssk_work_hours#"><!--- ücretsiz izin ücreti --->
					</cfif>,
					<cfif get_hr_salary.salary_type eq 0>
						<cfqueryparam cfsqltype="cf_sql_float" value="#izin_paid_amount#">
					<cfelse>	
						<cfqueryparam cfsqltype="cf_sql_float" value="#izin_paid_amount#">
					</cfif>,
					<cfif get_hr_salary.salary_type eq 0>
						<cfqueryparam cfsqltype="cf_sql_float" value="#paid_izinli_sunday_count_hour*new_salary#">
					<cfelse>	
						<cfqueryparam cfsqltype="cf_sql_float" value="#(paid_izinli_sunday_count)/ssk_full_days*(new_salary+half_offtime_day_total)#">
					</cfif>,
					<cfqueryparam cfsqltype="cf_sql_float" value="#t_ext_salary_0#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#t_ext_salary_1#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#t_ext_salary_2#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#t_ext_salary_5#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#attributes.yillik_izin_amount+attributes.kidem_amount+attributes.ihbar_amount+offdays_amount+weekly_amount_calc+weekend_amount+izin_paid_amount+t_ext_salary_0+t_ext_salary_1+t_ext_salary_2+t_ext_salary_5#">,
					<cfif len(ssk_matrah_bu_ay_devreden)><cfqueryparam cfsqltype="cf_sql_float" value="#ssk_matrah_bu_ay_devreden#"><cfelse>0</cfif>,
					<cfif len(this_tax_account_style_)><cfqueryparam cfsqltype="cf_sql_integer" value="#this_tax_account_style_#"><cfelse>0</cfif>,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#get_program_parameters.is_add_5746_control#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#get_program_parameters.is_add_4691_control#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#ssk_isveren_hissesi_687#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#ssk_isci_hissesi_687#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#issizlik_isci_hissesi_687#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#issizlik_isveren_hissesi_687#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#gelir_vergisi_indirimi_687#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#damga_vergisi_indirimi_687#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#ssk_isveren_hissesi_7103#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#ssk_isci_hissesi_7103#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#issizlik_isci_hissesi_7103#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#issizlik_isveren_hissesi_7103#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#gelir_vergisi_indirimi_7103#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#damga_vergisi_indirimi_7103#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#damga_vergisi_matrah_5746#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#gelir_vergisi_matrah_5746#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#ssk_matrah_5746#">,
                    <cfif law_number_7103 neq 0><cfqueryparam cfsqltype="cf_sql_integer" value="#law_number_7103#"><cfelse>NULL</cfif>,
					<cfif isdefined("short_working_calc") and len(short_working_calc)><cfqueryparam cfsqltype="cf_sql_float" value="#short_working_calc#"><cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_float" value="#gvm_matrah_5746#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(SSK_ISVEREN_HISSESI_7252,2)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(SSK_ISCI_HISSESI_7252,2)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(ISSIZLIK_ISCI_HISSESI_7252,2)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(ISSIZLIK_ISVEREN_HISSESI_7252,2)#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#IS_7252_CONTROL#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#SSK_DAYS_7252#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(SSK_ISVEREN_HISSESI_7256,2)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(SSK_ISCI_HISSESI_7256,2)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(ISSIZLIK_ISCI_HISSESI_7256,2)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(ISSIZLIK_ISVEREN_HISSESI_7256,2)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(base_amount_7256_temp,2)#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#IS_7256_PLUS#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#stampduty_5746#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#past_agi_day_payroll#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#daily_minimum_wage_base#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#all_basic_wage#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#daily_minimum_income_tax#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#daily_minimum_wage_stamp_tax#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#daily_minimum_wage#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#income_tax_temp#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#stamp_tax_temp#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#EXT_TOTAL_HOURS_8#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#EXT_TOTAL_HOURS_9#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#EXT_TOTAL_HOURS_10#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#EXT_TOTAL_HOURS_11#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#EXT_TOTAL_HOURS_12#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#t_ext_salary_8#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#t_ext_salary_9#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#t_ext_salary_10#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#t_ext_salary_11#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#t_ext_salary_12#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#t_akdi_day#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#t_akdi_hour#">,
					<cfif get_hr_salary.salary_type eq 1>
						<cfset t_akdi_total = (t_akdi_day)*hourly_salary_brut*get_hours.ssk_work_hours>
						<cfqueryparam cfsqltype="cf_sql_float" value="#t_akdi_total#">
						<cfelse>0					
					</cfif>,
					<cfqueryparam cfsqltype="cf_sql_float" value="#health_insurance_premium_worker#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#health_insurance_premium_employer#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#death_insurance_premium_worker#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#death_insurance_premium_employer#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#short_term_premium_employer#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#seniority_salary#">
				)
			</cfquery>
			<cfif attributes.puantaj_type eq -2>
				<cfquery name="get_old_puantaj" datasource="#dsn#">
					SELECT
						EPR.*
					FROM
						EMPLOYEES_PUANTAJ EP,
						EMPLOYEES_PUANTAJ_ROWS EPR
					WHERE
						EP.PUANTAJ_TYPE = -1
						AND EPR.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
						AND EP.SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
						AND EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#">
				</cfquery>
				<cfif get_old_puantaj.recordcount>
					<cfquery name="upd_puantaj" datasource="#dsn#">
						UPDATE
							EMPLOYEES_PUANTAJ_ROWS
						SET
							DAMGA_VERGISI_MATRAH = DAMGA_VERGISI_MATRAH - #get_old_puantaj.DAMGA_VERGISI_MATRAH#,
							COCUK_PARASI = COCUK_PARASI - #get_old_puantaj.COCUK_PARASI#,
							SSK_MATRAH = SSK_MATRAH - #get_old_puantaj.SSK_MATRAH#,
							DAMGA_VERGISI = DAMGA_VERGISI - #get_old_puantaj.DAMGA_VERGISI#,
							GELIR_VERGISI_MATRAH = GELIR_VERGISI_MATRAH - #get_old_puantaj.GELIR_VERGISI_MATRAH#,
							GELIR_VERGISI = GELIR_VERGISI - #get_old_puantaj.GELIR_VERGISI#,
							SSK_ISVEREN_CARPAN = GELIR_VERGISI - #get_old_puantaj.GELIR_VERGISI#,
							KUMULATIF_GELIR_MATRAH = KUMULATIF_GELIR_MATRAH - #get_old_puantaj.KUMULATIF_GELIR_MATRAH#,
							SSDF_ISCI_HISSESI = SSDF_ISCI_HISSESI - #get_old_puantaj.SSDF_ISCI_HISSESI#,
							SSDF_ISVEREN_HISSESI = SSDF_ISVEREN_HISSESI - #get_old_puantaj.SSDF_ISVEREN_HISSESI#,
							VERGI_INDIRIMI = VERGI_INDIRIMI - #get_old_puantaj.VERGI_INDIRIMI#,
							OZEL_KESINTI = OZEL_KESINTI - #get_old_puantaj.OZEL_KESINTI#,
							OZEL_KESINTI_2 = OZEL_KESINTI_2 - #get_old_puantaj.OZEL_KESINTI_2#,
							SAKATLIK_INDIRIMI = SAKATLIK_INDIRIMI - #get_old_puantaj.SAKATLIK_INDIRIMI#,
							TOTAL_SALARY = TOTAL_SALARY - #get_old_puantaj.TOTAL_SALARY#,
							EXT_SALARY = EXT_SALARY - #get_old_puantaj.EXT_SALARY#,
							EXT_SALARY_NET = EXT_SALARY_NET - #get_old_puantaj.EXT_SALARY_NET#,
							GOCMEN_INDIRIMI = GOCMEN_INDIRIMI - #get_old_puantaj.GOCMEN_INDIRIMI#,
							VERGI_IADESI = VERGI_IADESI - #get_old_puantaj.VERGI_IADESI#,
							VERGI_IADE_DAMGA_VERGISI = VERGI_IADE_DAMGA_VERGISI - #get_old_puantaj.VERGI_IADE_DAMGA_VERGISI#,
							ISSIZLIK_ISVEREN_HISSESI = ISSIZLIK_ISVEREN_HISSESI - #get_old_puantaj.ISSIZLIK_ISVEREN_HISSESI#,
							SSK_ISVEREN_HISSESI = SSK_ISVEREN_HISSESI - #get_old_puantaj.SSK_ISVEREN_HISSESI#,
							SSK_ISVEREN_HISSESI_GOV = SSK_ISVEREN_HISSESI_GOV - #get_old_puantaj.SSK_ISVEREN_HISSESI_GOV#,
							SSK_ISVEREN_HISSESI_GOV_100 = SSK_ISVEREN_HISSESI_GOV_100 - #get_old_puantaj.SSK_ISVEREN_HISSESI_GOV_100#,
							SSK_ISVEREN_HISSESI_GOV_80 = SSK_ISVEREN_HISSESI_GOV_80 - #get_old_puantaj.SSK_ISVEREN_HISSESI_GOV_80#,
							SSK_ISVEREN_HISSESI_GOV_60 = SSK_ISVEREN_HISSESI_GOV_60 - #get_old_puantaj.SSK_ISVEREN_HISSESI_GOV_60#,
							SSK_ISVEREN_HISSESI_GOV_40 = SSK_ISVEREN_HISSESI_GOV_40 - #get_old_puantaj.SSK_ISVEREN_HISSESI_GOV_40#,
							SSK_ISVEREN_HISSESI_GOV_20 = SSK_ISVEREN_HISSESI_GOV_20 - #get_old_puantaj.SSK_ISVEREN_HISSESI_GOV_20#,
							SSK_ISVEREN_HISSESI_GOV_100_DAY = SSK_ISVEREN_HISSESI_GOV_100_DAY - #get_old_puantaj.SSK_ISVEREN_HISSESI_GOV_100_DAY#,
							SSK_ISVEREN_HISSESI_GOV_80_DAY = SSK_ISVEREN_HISSESI_GOV_80_DAY - #get_old_puantaj.SSK_ISVEREN_HISSESI_GOV_80_DAY#,
							SSK_ISVEREN_HISSESI_GOV_60_DAY = SSK_ISVEREN_HISSESI_GOV_60_DAY - #get_old_puantaj.SSK_ISVEREN_HISSESI_GOV_60_DAY#,
							SSK_ISVEREN_HISSESI_GOV_40_DAY = SSK_ISVEREN_HISSESI_GOV_40_DAY - #get_old_puantaj.SSK_ISVEREN_HISSESI_GOV_40_DAY#,
							SSK_ISVEREN_HISSESI_GOV_20_DAY = SSK_ISVEREN_HISSESI_GOV_20_DAY - #get_old_puantaj.SSK_ISVEREN_HISSESI_GOV_20_DAY#,
							SSK_ISVEREN_HISSESI_5921 = SSK_ISVEREN_HISSESI_5921 - #get_old_puantaj.SSK_ISVEREN_HISSESI_5921#,
							SSK_ISVEREN_HISSESI_5921_DAY = SSK_ISVEREN_HISSESI_5921_DAY - #get_old_puantaj.SSK_ISVEREN_HISSESI_5921_DAY#,
							SSK_ISVEREN_HISSESI_5084 = SSK_ISVEREN_HISSESI_5084 - #get_old_puantaj.SSK_ISVEREN_HISSESI_5084#,
							SSK_ISVEREN_HISSESI_5510 = SSK_ISVEREN_HISSESI_5510 - #get_old_puantaj.SSK_ISVEREN_HISSESI_5510#,
							SSK_ISVEREN_HISSESI_5746 = SSK_ISVEREN_HISSESI_5746 - #get_old_puantaj.SSK_ISVEREN_HISSESI_5746#,
							SSK_ISVEREN_HISSESI_4691 = SSK_ISVEREN_HISSESI_4691 - #get_old_puantaj.SSK_ISVEREN_HISSESI_4691#,
							SSK_ISVEREN_HISSESI_6111 = SSK_ISVEREN_HISSESI_6111 - #get_old_puantaj.SSK_ISVEREN_HISSESI_6111#,
							SSK_ISVEREN_HISSESI_6486 = SSK_ISVEREN_HISSESI_6486 - #get_old_puantaj.SSK_ISVEREN_HISSESI_6486#,
							SSK_ISVEREN_HISSESI_6322 = SSK_ISVEREN_HISSESI_6322 - #get_old_puantaj.SSK_ISVEREN_HISSESI_6322#,
							SSK_ISCI_HISSESI_6322 = SSK_ISCI_HISSESI_6322 - #get_old_puantaj.SSK_ISCI_HISSESI_6322#,
							SSK_ISVEREN_HISSESI_25510 = SSK_ISVEREN_HISSESI_25510 - #get_old_puantaj.SSK_ISVEREN_HISSESI_25510#,
                            SSK_ISVEREN_HISSESI_14857 = SSK_ISVEREN_HISSESI_14857 - #get_old_puantaj.SSK_ISVEREN_HISSESI_14857#,
                            SSK_ISVEREN_HISSESI_6645 = SSK_ISVEREN_HISSESI_6645 - #get_old_puantaj.SSK_ISVEREN_HISSESI_6645#,
                            SSK_ISVEREN_HISSESI_46486 = SSK_ISVEREN_HISSESI_46486 - #get_old_puantaj.SSK_ISVEREN_HISSESI_46486#,
                            SSK_ISVEREN_HISSESI_56486 = SSK_ISVEREN_HISSESI_56486 - #get_old_puantaj.SSK_ISVEREN_HISSESI_56486#,
                            SSK_ISVEREN_HISSESI_66486 = SSK_ISVEREN_HISSESI_66486 - #get_old_puantaj.SSK_ISVEREN_HISSESI_66486#,
							GELIR_VERGISI_INDIRIMI_5746 = GELIR_VERGISI_INDIRIMI_5746 - #get_old_puantaj.GELIR_VERGISI_INDIRIMI_5746#,
							GELIR_VERGISI_INDIRIMI_4691 = GELIR_VERGISI_INDIRIMI_4691 - #get_old_puantaj.GELIR_VERGISI_INDIRIMI_5746#,
							TOPLAM_YUVARLAMA = TOPLAM_YUVARLAMA - #get_old_puantaj.TOPLAM_YUVARLAMA#,
							ISSIZLIK_ISCI_HISSESI = ISSIZLIK_ISCI_HISSESI - #get_old_puantaj.ISSIZLIK_ISCI_HISSESI#,
							SSK_ISCI_HISSESI = SSK_ISCI_HISSESI - #get_old_puantaj.SSK_ISCI_HISSESI#,
							NET_UCRET = NET_UCRET - #get_old_puantaj.NET_UCRET#,
							TOTAL_PAY_SSK_TAX = TOTAL_PAY_SSK_TAX - #get_old_puantaj.TOTAL_PAY_SSK_TAX#,
							TOTAL_PAY_SSK = TOTAL_PAY_SSK - #get_old_puantaj.TOTAL_PAY_SSK#,
							TOTAL_PAY_TAX = TOTAL_PAY_TAX - #get_old_puantaj.TOTAL_PAY_TAX#,
							TOTAL_PAY = TOTAL_PAY - #get_old_puantaj.TOTAL_PAY#,
							KIDEM_WORKER = KIDEM_WORKER - #get_old_puantaj.KIDEM_WORKER#,
							KIDEM_BOSS = KIDEM_BOSS - #get_old_puantaj.KIDEM_BOSS#,
							TRADE_UNION_DEDUCTION = TRADE_UNION_DEDUCTION - #get_old_puantaj.TRADE_UNION_DEDUCTION#,
							AVANS = AVANS - #get_old_puantaj.AVANS#,
							IHBAR_AMOUNT = IHBAR_AMOUNT - #get_old_puantaj.IHBAR_AMOUNT#,
							IHBAR_AMOUNT_NET = IHBAR_AMOUNT_NET - #get_old_puantaj.IHBAR_AMOUNT_NET#,
							KIDEM_AMOUNT = KIDEM_AMOUNT - #get_old_puantaj.KIDEM_AMOUNT#,
							YILLIK_IZIN_AMOUNT = YILLIK_IZIN_AMOUNT - #get_old_puantaj.YILLIK_IZIN_AMOUNT#,
							YILLIK_IZIN_AMOUNT_NET = YILLIK_IZIN_AMOUNT_NET - #get_old_puantaj.YILLIK_IZIN_AMOUNT_NET#,
							SSK_MATRAH_SALARY = SSK_MATRAH_SALARY - #get_old_puantaj.SSK_MATRAH_SALARY#,
							GVM_IZIN = GVM_IZIN - #get_old_puantaj.GVM_IZIN#,
							GVM_IHBAR = GVM_IHBAR - #get_old_puantaj.GVM_IHBAR#,
							VERGI_INDIRIMI_5084 = VERGI_INDIRIMI_5084 - #get_old_puantaj.VERGI_INDIRIMI_5084#,
							MAHSUP_G_VERGISI = MAHSUP_G_VERGISI - #get_old_puantaj.MAHSUP_G_VERGISI#,
							SSK_ISCI_HISSESI_DUSULECEK = SSK_ISCI_HISSESI_DUSULECEK - #get_old_puantaj.SSK_ISCI_HISSESI_DUSULECEK#,
							ISSIZLIK_ISCI_HISSESI_DUSULECEK = ISSIZLIK_ISCI_HISSESI_DUSULECEK - #get_old_puantaj.ISSIZLIK_ISCI_HISSESI_DUSULECEK#,
							VERGI_ISTISNA_DAMGA_NET = VERGI_ISTISNA_DAMGA_NET - #get_old_puantaj.VERGI_ISTISNA_DAMGA_NET#,
							VERGI_ISTISNA_DAMGA = VERGI_ISTISNA_DAMGA - #get_old_puantaj.VERGI_ISTISNA_DAMGA#,
							VERGI_ISTISNA_SSK_NET = VERGI_ISTISNA_SSK_NET - #get_old_puantaj.VERGI_ISTISNA_SSK_NET#,
							VERGI_ISTISNA_SSK = VERGI_ISTISNA_SSK - #get_old_puantaj.VERGI_ISTISNA_SSK#,
							VERGI_ISTISNA_VERGI_NET = VERGI_ISTISNA_VERGI_NET - #get_old_puantaj.VERGI_ISTISNA_VERGI_NET#,
							VERGI_ISTISNA_VERGI = VERGI_ISTISNA_VERGI - #get_old_puantaj.VERGI_ISTISNA_VERGI#,
							VERGI_ISTISNA_TOTAL = VERGI_IADESI - #get_old_puantaj.VERGI_IADESI#,
							SSK_MATRAH_EXEMPTION = SSK_MATRAH_EXEMPTION - #get_old_puantaj.SSK_MATRAH_EXEMPTION#,
							TAX_MATRAH_EXEMPTION = TAX_MATRAH_EXEMPTION - #get_old_puantaj.TAX_MATRAH_EXEMPTION#,
							TAX_MATRAH_EXEMPTION_GET_ALL = TAX_MATRAH_EXEMPTION_GET_ALL - #get_old_puantaj.TAX_MATRAH_EXEMPTION_GET_ALL#,
							TAX_MATRAH_EXEMPTION_GET = TAX_MATRAH_EXEMPTION_GET - #get_old_puantaj.TAX_MATRAH_EXEMPTION_GET#,						
							TOTAL_SALARY_HOURS = TOTAL_SALARY_HOURS - #get_old_puantaj.TOTAL_SALARY_HOURS#,
							HALF_OFFTIME_DAY_TOTAL = HALF_OFFTIME_DAY_TOTAL - #get_old_puantaj.HALF_OFFTIME_DAY_TOTAL#,
							HALF_OFFTIME_DAY_TOTAL_NET = HALF_OFFTIME_DAY_TOTAL_NET - #get_old_puantaj.HALF_OFFTIME_DAY_TOTAL_NET#,
							HALF_OFFTIME_TOTAL_HOUR = HALF_OFFTIME_TOTAL_HOUR - #get_old_puantaj.HALF_OFFTIME_TOTAL_HOUR#,
							YILLIK_IZIN_AMOUNT_GELIR_VERGISI = YILLIK_IZIN_AMOUNT_GELIR_VERGISI - #get_old_puantaj.YILLIK_IZIN_AMOUNT_GELIR_VERGISI#,
							YILLIK_IZIN_AMOUNT_DAMGA_VERGISI = YILLIK_IZIN_AMOUNT_DAMGA_VERGISI - #get_old_puantaj.YILLIK_IZIN_AMOUNT_DAMGA_VERGISI#,
							YILLIK_IZIN_AMOUNT_SSK_ISVEREN_HISSESI = YILLIK_IZIN_AMOUNT_SSK_ISVEREN_HISSESI - #get_old_puantaj.YILLIK_IZIN_AMOUNT_SSK_ISVEREN_HISSESI#,
							YILLIK_IZIN_AMOUNT_SSK_ISCI_HISSESI = YILLIK_IZIN_AMOUNT_SSK_ISCI_HISSESI - #get_old_puantaj.YILLIK_IZIN_AMOUNT_SSK_ISCI_HISSESI#,
							YILLIK_IZIN_AMOUNT_SSK_ISVEREN_ISSIZLIK = YILLIK_IZIN_AMOUNT_SSK_ISVEREN_ISSIZLIK - #get_old_puantaj.YILLIK_IZIN_AMOUNT_SSK_ISVEREN_ISSIZLIK#,
							YILLIK_IZIN_AMOUNT_SSK_ISCI_ISSIZLIK = YILLIK_IZIN_AMOUNT_SSK_ISCI_ISSIZLIK - #get_old_puantaj.YILLIK_IZIN_AMOUNT_SSK_ISCI_ISSIZLIK#,
							IHBAR_AMOUNT_GELIR_VERGISI = IHBAR_AMOUNT_GELIR_VERGISI - #get_old_puantaj.IHBAR_AMOUNT_GELIR_VERGISI#,
							IHBAR_AMOUNT_DAMGA_VERGISI = IHBAR_AMOUNT_DAMGA_VERGISI - #get_old_puantaj.IHBAR_AMOUNT_DAMGA_VERGISI#,
							KIDEM_AMOUNT_NET = KIDEM_AMOUNT_NET - #get_old_puantaj.KIDEM_AMOUNT_NET#,
							KIDEM_AMOUNT_DAMGA_VERGISI = KIDEM_AMOUNT_DAMGA_VERGISI - #get_old_puantaj.KIDEM_AMOUNT_DAMGA_VERGISI#
						WHERE
							EMPLOYEE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">
					</cfquery>
				</cfif>
			</cfif>
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
				<cfqueryparam cfsqltype="cf_sql_integer" value="#puantaj_id#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#ssk_matrah_bu_ay_devreden#">,
				0,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#">
				)
		</cfquery>
	</cfif>
	
	<cfquery name="get_bank" datasource="#dsn#" maxrows="1">
		SELECT EMP_BANK_ID FROM EMPLOYEES_BANK_ACCOUNTS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#"> AND DEFAULT_ACCOUNT = 1
	</cfquery>
	<cfif get_bank.recordcount>
		<cfquery name="upd_" datasource="#dsn#">
		UPDATE 
			#row_puantaj_table# 
		SET 
			EMP_BANK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_bank.EMP_BANK_ID#">
		WHERE
			EMPLOYEE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">
	</cfquery>
	</cfif>
	
	<cfquery name="upd_" datasource="#dsn#">
		UPDATE 
			#row_puantaj_table# 
		SET 
			SSK_DEVIR = <cfqueryparam cfsqltype="cf_sql_float" value="#gecen_aydan_dusulecek#">,
			SSK_DEVIR_LAST = <cfqueryparam cfsqltype="cf_sql_float" value="#onceki_aydan_dusulecek#">
		WHERE
			EMPLOYEE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">
	</cfquery>
	<!--- EK ÖDENEK KESİNTİ VE VERGİ MUAFİYETLERİ EKLENİR --->
	<cfloop from="1" to="#ArrayLen(puantaj_exts)#" index="ai">
		<cfif ArrayIsDefined(puantaj_exts[ai],6)  and listfindnocase('0,1,2,3',puantaj_exts[ai][6])>
			<cfset acc_type_id_ = ''>
			<cfif arraylen(puantaj_exts[ai]) gt 20 and len(puantaj_exts[ai][21])>
				<cfset acc_type_id_ = puantaj_exts[ai][21]>				
			</cfif>
			<cfif arraylen(puantaj_exts[ai]) gt 15 and len(puantaj_exts[ai][16]) and puantaj_exts[ai][6] eq 0 and not len(acc_type_id_)><!--- id varsa ve acc type id yoksa tanımdan çekecek --->
				<cfquery name="get_acc_type" datasource="#dsn#">
					SELECT ACC_TYPE_ID FROM SETUP_PAYMENT_INTERRUPTION WHERE ODKES_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#puantaj_exts[ai][16]#">
				</cfquery>
				<cfif get_acc_type.recordcount and len(get_acc_type.acc_type_id)>
					<cfset acc_type_id_ = get_acc_type.acc_type_id>
				</cfif>
			</cfif>
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
					ACC_TYPE_ID,
					SSK_ISVEREN_HISSESI,
					SSK_ISVEREN_ISSIZLIK_HISSESI,
					SSK_ISCI_HISSESI,
					SSK_ISCI_ISSIZLIK_HISSESI,
					GELIR_VERGISI,
					DAMGA_VERGISI,
					IS_INCOME,
					VERGI_ISTISNA_AMOUNT,
					VERGI_ISTISNA_TOTAL,
					FACTOR_TYPE,
					COMMENT_TYPE,
					DETAIL,
                    SSK_EXEMPTION_RATE,
                    SSK_EXEMPTION_TYPE,
					TOTAL_HOUR
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#puantaj_id#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#puantaj_exts[ai][1]#">,<!--- comment --->
					<cfif arraylen(puantaj_exts[ai]) gt 15 and len(puantaj_exts[ai][16])><!--- comment_pay_id --->
						<cfqueryparam cfsqltype="cf_sql_integer" value="#puantaj_exts[ai][16]#">,
					<cfelse>
						NULL,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#puantaj_exts[ai][2]#">,<!--- pay_method --->
					<cfqueryparam cfsqltype="cf_sql_float" value="#puantaj_exts[ai][3]#">,<!--- amount --->
					<cfif puantaj_exts[ai][6] eq 1 and listfindnocase('2,3,4,5',puantaj_exts[ai][2])><!--- kesinti icin amount_2 yüzde karşılığı--->
						<cfif len(puantaj_exts[ai][9]) and (puantaj_exts[ai][9] eq 0)><!--- netden kesinti --->
							<cfif puantaj_exts[ai][2] eq 5>
								#wrk_round((ozel_kesinti_net_ucreti / 100) * puantaj_exts[ai][3],2)#,
							<cfelseif puantaj_exts[ai][2] eq 3>
								#wrk_round((ozel_kesinti_net_ucreti_gun / 100) * puantaj_exts[ai][3],2)#,
							<cfelseif puantaj_exts[ai][2] eq 4>
								#wrk_round((ozel_kesinti_net_ucreti_saat / 100) * puantaj_exts[ai][3],2)#,
							<cfelseif puantaj_exts[ai][2] eq 2>
								#wrk_round((ozel_kesinti_net_ucreti_ay / 100) * puantaj_exts[ai][3],2)#,
							</cfif>
						<cfelse>
							#wrk_round(puantaj_exts[ai][8],3)#,
						</cfif>
					<cfelseif puantaj_exts[ai][8] gt 0>
						#wrk_round(puantaj_exts[ai][8],2)#,
					<cfelse>
						0,
					</cfif>
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
					<cfif arraylen(puantaj_exts[ai]) gt 14 and len(puantaj_exts[ai][15])>#puantaj_exts[ai][15]#,<cfelse>NULL,</cfif>
					<cfif arraylen(puantaj_exts[ai]) gt 16 and len(puantaj_exts[ai][17])>'#puantaj_exts[ai][17]#',<cfelse>NULL,</cfif>
					<cfif arraylen(puantaj_exts[ai]) gt 17 and len(puantaj_exts[ai][18])>'#puantaj_exts[ai][18]#'<cfelse>NULL</cfif>,
					<cfif arraylen(puantaj_exts[ai]) gt 18 and len(puantaj_exts[ai][19])>'#puantaj_exts[ai][19]#',<cfelse>NULL,</cfif>
					<cfif arraylen(puantaj_exts[ai]) gt 19 and len(puantaj_exts[ai][20])>#puantaj_exts[ai][20]#<cfelse>NULL</cfif>,
					<cfif len(acc_type_id_)>#acc_type_id_#<cfelse>NULL</cfif>,
					<cfif arraylen(puantaj_exts[ai]) gte 22 and len(puantaj_exts[ai][22])>#puantaj_exts[ai][22]#<cfelse>0</cfif>,
					<cfif arraylen(puantaj_exts[ai]) gte 23 and len(puantaj_exts[ai][23])>#puantaj_exts[ai][23]#<cfelse>0</cfif>,
					<cfif arraylen(puantaj_exts[ai]) gte 24 and len(puantaj_exts[ai][24])>#puantaj_exts[ai][24]#<cfelse>0</cfif>,
					<cfif arraylen(puantaj_exts[ai]) gte 24 and len(puantaj_exts[ai][25])>#puantaj_exts[ai][25]#<cfelse>0</cfif>,
					<cfif arraylen(puantaj_exts[ai]) gte 26 and len(puantaj_exts[ai][26])>#puantaj_exts[ai][26]#<cfelse>0</cfif>,
					<cfif arraylen(puantaj_exts[ai]) gte 27 and len(puantaj_exts[ai][27])>#puantaj_exts[ai][27]#<cfelse>0</cfif>,
					<cfif arraylen(puantaj_exts[ai]) gte 28 and len(puantaj_exts[ai][28])>#puantaj_exts[ai][28]#<cfelse>0</cfif>,
					<cfif arraylen(puantaj_exts[ai]) gte 29 and len(puantaj_exts[ai][29])>#puantaj_exts[ai][29]#<cfelse>0</cfif>,
					<cfif arraylen(puantaj_exts[ai]) gte 30 and len(puantaj_exts[ai][30])>#puantaj_exts[ai][30]#<cfelse>0</cfif>,
					<cfif arraylen(puantaj_exts[ai]) gte 31 and len(puantaj_exts[ai][31])>#puantaj_exts[ai][31]#<cfelse>0</cfif>,
					<cfif arraylen(puantaj_exts[ai]) gte 32 and len(puantaj_exts[ai][32])>#puantaj_exts[ai][32]#<cfelse>1</cfif>,
					<cfif arraylen(puantaj_exts[ai]) gte 35 and len(puantaj_exts[ai][35])><cfqueryparam cfsqltype="cf_sql_varchar" value="#puantaj_exts[ai][35]#"><cfelse>NULL</cfif>,
					<cfif arraylen(puantaj_exts[ai]) gte 36 and len(puantaj_exts[ai][36])>#puantaj_exts[ai][36]#<cfelse>NULL</cfif>,
					<cfif arraylen(puantaj_exts[ai]) gte 37 and len(puantaj_exts[ai][37])>#puantaj_exts[ai][37]#<cfelse>NULL</cfif>,
					<cfif arraylen(puantaj_exts[ai]) gte 48 and len(puantaj_exts[ai][48])>#puantaj_exts[ai][48]#<cfelse>0</cfif>
				)
			</cfquery>
		</cfif>
	</cfloop>
	<cfinclude template="end_icra_rows.cfm">
	<!--- // EK ÖDENEK KESİNTİ VE VERGİ MUAFİYETLERİ EKLENİR --->
</cfif>
<cfset data = structnew()>
<cfset data.puantaj_id = puantaj_id>
<cfset data.employee_id = employee_id>
<cfset data.in_out_id = attributes.in_out_id>
<cfset data.SOCIALSECURITY_NO = attributes.SOCIALSECURITY_NO>
<cfset data.salary_type = get_hr_salary.salary_type>     
<cfset data.salary = get_hr_salary.salary>    
<cfset data.money = get_hr_salary.money>   
<cfset data.damga_vergisi_matrah = TLFORMAT(damga_vergisi_matrah)>      
<cfif get_hr_salary.salary_type eq 0>
	<cfset data.TOTAL_HOURS = TLFORMAT(TOTAL_HOURS)>
<cfelseif get_hr_salary.salary_type eq 1>
	<cfset data.work_days = TLFORMAT(work_days)>
<cfelseif get_hr_salary.salary_type eq 2>
	<cfset data.ssk_days = TLFORMAT(ssk_days)>
</cfif>
<cfset data.SSK_MATRAH = TLFORMAT(SSK_MATRAH)>
<cfset data.DAMGA_VERGISI = TLFORMAT(DAMGA_VERGISI)>
<cfset data.GELIR_VERGISI_MATRAH = TLFORMAT(GELIR_VERGISI_MATRAH+attributes.kidem_amount)>
<cfset data.GELIR_VERGISI = TLFORMAT(GELIR_VERGISI)>
<cfset data.vergi_indirim_5084 = TLFORMAT(vergi_indirim_5084)>
<cfset data.kumulatif_gelir_vergisi_matrahi = TLFORMAT(kumulatif_gelir+GELIR_VERGISI_MATRAH+attributes.kidem_amount)>
<cfset data.SSDF_ISCI_HISSESI = TLFORMAT(SSDF_ISCI_HISSESI)>
<cfset data.SSDF_ISVEREN_HISSESI = TLFORMAT(SSDF_ISVEREN_HISSESI)>
<cfset data.VERGI_ISTISNA = TLFORMAT(VERGI_ISTISNA)>
<cfset data.OZEL_KESINTI = TLFORMAT(OZEL_KESINTI)>
<cfset data.OZEL_KESINTI_2 = TLFORMAT(OZEL_KESINTI_2)>
<cfset data.EXT_TOTAL_HOURS_0 = EXT_TOTAL_HOURS_0>
<cfset data.EXT_TOTAL_HOURS_1 = EXT_TOTAL_HOURS_1>
<cfset data.EXT_TOTAL_HOURS_2 = EXT_TOTAL_HOURS_2>
<cfset data.EXT_TOTAL_HOURS_3 = EXT_TOTAL_HOURS_3>
<cfset data.SAKATLIK_INDIRIMI = TLFORMAT(SAKATLIK_INDIRIMI)>
<cfset data.total_salary_ = TLFORMAT(SALARY)>
<cfset data.EXT_SALARY = TLFORMAT(EXT_SALARY)>
<cfset data.GOCMEN_INDIRIMI = TLFORMAT(GOCMEN_INDIRIMI)>
<cfset data.VERGI_IADESI = TLFORMAT(VERGI_IADESI)>
<cfset data.VERGI_IADE_DAMGA_VERGISI = TLFORMAT(VERGI_IADE_DAMGA_VERGISI)>
<cfset data.ISSIZLIK_ISVEREN_HISSESI = TLFORMAT(ISSIZLIK_ISVEREN_HISSESI)>
<cfset data.SSK_ISVEREN_HISSESI = TLFORMAT(SSK_ISVEREN_HISSESI)>
<cfset data.ISSIZLIK_ISCI_HISSESI = TLFORMAT(ISSIZLIK_ISCI_HISSESI)>
<cfset data.SSK_ISCI_HISSESI = TLFORMAT(SSK_ISCI_HISSESI)>
<cfset data.NET_UCRET = TLFORMAT(NET_UCRET)>
<cfset data.TOTAL_PAY_SSK_TAX = TLFORMAT(TOTAL_PAY_SSK_TAX)>
<cfset data.TOTAL_PAY_SSK = TLFORMAT(TOTAL_PAY_SSK)>
<cfset data.TOTAL_PAY_TAX = TLFORMAT(TOTAL_PAY_TAX)>
<cfset data.TOTAL_PAY = TLFORMAT(TOTAL_PAY)>
<cfset data.kidem_isci_payi = TLFORMAT(kidem_isci_payi)>
<cfset data.kidem_isveren_payi = TLFORMAT(kidem_isveren_payi)>
<cfset data.gross_net = TLFORMAT(get_hr_salary.gross_net)>
<cfset data.SSK_STATUTE = TLFORMAT(get_hr_salary.SSK_STATUTE)>
<cfset data.SSK_STATUTE = TLFORMAT(get_hr_salary.SABIT_PRIM)>
<cfset data.SUNDAY_COUNT = TLFORMAT(SUNDAY_COUNT)>
<cfset data.OFFDAYS_COUNT = OFFDAYS_COUNT>
<cfset data.OFFDAYS_SUNDAY_COUNT = OFFDAYS_SUNDAY_COUNT>
<cfset data.IZINLI_SUNDAY_COUNT = IZINLI_SUNDAY_COUNT>
<cfset data.PAID_IZINLI_SUNDAY_COUNT = PAID_IZINLI_SUNDAY_COUNT>
<cfset data.IZIN = IZIN>
<cfset data.IZIN_COUNT = IZIN_COUNT>
<cfset data.IZIN_PAID = IZIN_PAID>
<cfset data.IZIN_PAID_COUNT = IZIN_PAID_COUNT>
<cfset data.sendika_indirimi = TLFORMAT(sendika_indirimi)>
<cfset data.AVANS = TLFORMAT(AVANS)>
<cfset data.ihbar_amount = attributes.ihbar_amount>
<cfset data.kidem_amount = TLFORMAT(attributes.kidem_amount)>
<cfset data.yillik_izin_amount = TLFORMAT(attributes.yillik_izin_amount)>
<cfset data.SSK_MATRAH_SALARY = TLFORMAT(SSK_MATRAH_SALARY)>
<cfset data.GVM_IZIN = TLFORMAT(GVM_IZIN)>
<cfset data.GVM_IHBAR = TLFORMAT(GVM_IHBAR)>
<cfset data.SSK_WORK_HOURS = GET_HOURS.SSK_WORK_HOURS>
<cfset data.ssk_isveren_carpan = ssk_isveren_carpan>
<cfset data.gecen_aydan_dusulecek = gecen_aydan_dusulecek>
<cfset data.onceki_aydan_dusulecek = onceki_aydan_dusulecek>
<cfset data.ssk_matrah_kullanilan = ssk_matrah_kullanilan>           
<cfset serializedStr = Replace(SerializeJSON(data),'//','')>
<cfif isdefined("attributes.SSK_OFFICE") and len(attributes.SSK_OFFICE)>
	<cfset branch_id = attributes.SSK_OFFICE>
<cfelseif isdefined("attributes.BRANCH_ID") and len(attributes.BRANCH_ID)>
	<cfset branch_id = attributes.BRANCH_ID>
<cfelse>
	<cfset branch_id = ''>
</cfif>
<cfif isDefined("ilk_sal_mon_") and len(ilk_sal_mon_)>
	<cfset sal_mon_ = ilk_sal_mon_>
<cfelseif isDefined("attributes.sal_mon") and len(attributes.sal_mon)>
	<cfset sal_mon_ = attributes.sal_mon>
</cfif>
<cfif isDefined("ilk_sal_year_") and len(ilk_sal_year_)>
	<cfset sal_year_ = ilk_sal_year_>
<cfelseif isDefined("attributes.sal_year") and len(attributes.sal_year)>
	<cfset sal_year_ = attributes.sal_year>
</cfif>
<cfquery name="upd_payrol_job" datasource="#dsn#">
	UPDATE
		PAYROLL_JOB   
	SET
		PERCENT_COMPLETED  = <cfqueryparam CFSQLType = "cf_sql_bit" value = "1">,
		BRANCH_PAYROLL_ID = #puantaj_id#,
		PAYROLL_DRAFT = <cfqueryparam CFSQLType = "cf_sql_varchar" value = "#serializedStr#">,
		EMPLOYEE_PAYROLL_ID = <cfqueryparam CFSQLType = "cf_sql_varchar" value = "#MAX_ID.IDENTITYCOL#">
	WHERE 
		IN_OUT_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.in_out_id# " null = "no">
		AND BRANCH_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#branch_id#" null = "no">
		AND MONTH = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#sal_mon_#" null = "no">
		AND YEAR = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#sal_year_#" null = "no">
		AND IN_OUT_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.in_out_id#" null = "no">
		AND PAYROLL_TYPE = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.puantaj_type#" null = "no">
		<cfif isdefined("attributes.ssk_statue") and len(attributes.ssk_statue)>
			AND STATUE = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.ssk_statue#" null = "no">
			<cfif isdefined("attributes.statue_type") and len(attributes.statue_type) AND attributes.ssk_statue eq 2>
				AND STATUE_TYPE = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.statue_type#" null = "no">
			</cfif>
		</cfif>
</cfquery>
<cfif get_hr_ssk.USE_SSK eq 2 and not isdefined("attributes.from_employee_payroll") and isdefined('this.returnResult') and (isdefined("attributes.statue_type") and (attributes.statue_type neq 7 and attributes.statue_type neq 6 and attributes.statue_type neq 9 and attributes.statue_type neq 10))>
	<!--- Memur Bordrosu ise --->
	<!--- Bes --->
    <cfset bes_isci_hissesi =  fix(wrk_round(sgk_base/100) * bes_isci_carpan )>
	<!--- Insert Fonksiyonu --->
    <cfset add_officer_payroll = add_officer_payroll()>
</cfif>
<cfreturn  Replace(SerializeJSON(attributes.in_out_id),'//','')>
<cfcatch type="any">
	<cfif not isdefined("attributes.from_employee_payroll") and isdefined('this.returnResult')>
		<cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: cfcatch, in_out_id: attributes.in_out_id) />
	<cfelse>
		<cfdump var="#cfcatch#">
		<cfabort>
	</cfif>
</cfcatch>
</cftry>