<cf_xml_page_edit fuseact="ehesap.popup_form_fire2">

	<cfset get_payroll_job = createObject("component","V16.hr.ehesap.cfc.payroll_job")>

	<cf_date tarih="attributes.finish_date">
	<cfset total_ssk_days = 0>
	<cfset total_deneme_days = 0>
	<cfset kidem_dahil_odenek = 0>
	<cfif isdefined("attributes.ihbardate") and len(attributes.ihbardate)>
		<cf_date tarih="attributes.ihbardate">
	</cfif>
	<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
		<cf_date tarih="attributes.startdate">
	</cfif>
	<cfif isdefined("attributes.kidem_baz") and len(attributes.kidem_baz)>
		<cf_date tarih="attributes.kidem_baz">
	</cfif>
	<cfset attributes.sal_mon = month(attributes.finish_date)>
	<cfset attributes.sal_year = year(attributes.finish_date)>

	<cfif isdefined("attributes.is_kidem_baz")>
		<cfset cikis_start_date = attributes.kidem_baz>
	<cfelse>
		<cfset cikis_start_date = attributes.STARTDATE>
	</cfif>
	<cfquery name="get_hr_ssk_1" datasource="#dsn#">
		SELECT
			B.SSK_NO,
			B.BRANCH_ID,
			B.SSK_OFFICE,
			EMPLOYEES.KIDEM_DATE,
			EMPLOYEES.EMPLOYEE_ID,
			EMPLOYEES.EMPLOYEE_NO,
			EMPLOYEES.EMPLOYEE_NAME,
			EMPLOYEES.EMPLOYEE_SURNAME,
			EMPLOYEES.TASK,
			EMPLOYEES_IN_OUT.USE_SSK,
			EMPLOYEES_IN_OUT.USE_TAX,
			EMPLOYEES_IN_OUT.SALARY_TYPE,
			EMPLOYEES_IN_OUT.SURELI_IS_AKDI,
			EMPLOYEES_IN_OUT.SURELI_IS_FINISHDATE,
			EMPLOYEES_IN_OUT.SABIT_PRIM,
			EMPLOYEES_IN_OUT.SSK_STATUTE,
			EMPLOYEES_IN_OUT.GROSS_NET,
			EMPLOYEES_IN_OUT.START_DATE AS STARTDATE,
			EMPLOYEES_IN_OUT.FINISH_DATE AS FINISHDATE,
			EMPLOYEES_IN_OUT.DEFECTION_LEVEL,
			EMPLOYEES_IN_OUT.SOCIALSECURITY_NO,
			EMPLOYEES_IN_OUT.TRADE_UNION_DEDUCTION,
			EMPLOYEES_IN_OUT.BUSINESS_CODE_ID,
			EMPLOYEES_IN_OUT.PUANTAJ_GROUP_IDS,
			EMPLOYEES_IN_OUT.BRANCH_ID,
			EMPLOYEES_IN_OUT.DUTY_TYPE,
			EMPLOYEES_IN_OUT.IS_PUANTAJ_OFF,
			USE_SSK,
			(SELECT TOP 1 SSK_MONTHLY_WORK_HOURS FROM OUR_COMPANY_HOURS WHERE OUR_COMPANY_ID = B.COMPANY_ID) AS SSK_MONTHLY_WORK_HOURS,
			(SELECT TOP 1 MONEY FROM EMPLOYEES_SALARY WHERE IN_OUT_ID = EMPLOYEES_IN_OUT.IN_OUT_ID AND PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(attributes.finish_date)#">) AS MONEY      
		FROM
			EMPLOYEES,
			EMPLOYEES_IN_OUT,
			BRANCH B
		WHERE
			B.BRANCH_ID = EMPLOYEES_IN_OUT.BRANCH_ID AND
			EMPLOYEES_IN_OUT.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.IN_OUT_ID#">
			AND EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID
			AND EMPLOYEES_IN_OUT.FINISH_DATE IS NULL
	</cfquery>
	
	<cfset this_in_out_ = attributes.IN_OUT_ID>
	<cfset this_ssk_no_ = get_hr_ssk_1.SSK_NO>
	<cfset this_ssk_office_ = get_hr_ssk_1.SSK_OFFICE>
	<cfset this_branch_id_ = get_hr_ssk_1.BRANCH_ID>
	<cfset is_puantaj_off = get_hr_ssk_1.IS_PUANTAJ_OFF>
	
	<cfif not get_hr_ssk_1.recordcount>
		<cfoutput>
			<script type="text/javascript">
				alert("#attributes.employee_id# <cf_get_lang dictionary_id ='54156.numaralı çalışan için Maaş ve/veya SSK ve/veya İşe Giriş Bilgileri Eksik'>  !");
				closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');
			</script>
		</cfoutput>
		<cfabort>
	</cfif>
	
	<cfset attributes.branch_id = get_hr_ssk_1.BRANCH_ID>	
	<cfset attributes.group_id = "">
	<cfif len(get_hr_ssk_1.puantaj_group_ids)>
		<cfset attributes.group_id = "#get_hr_ssk_1.PUANTAJ_GROUP_IDS#,">
	</cfif>
	<cfinclude template="../query/get_program_parameter.cfm">
	
	<cfif datediff("d",attributes.finish_date,cikis_start_date) gt 0>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id ='54157.Çıkış Tarihi Giriş Tarihinden Önce Olamaz'> !");
			closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');
		</script>
		<cfabort>
	</cfif>
	
	<cfif isdefined("attributes.is_kidem_baz")>
		<cfif isdefined("attributes.ihbardate") and len(attributes.ihbardate) and datediff("d",attributes.ihbardate,attributes.kidem_baz) gt 0>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id ='54160.İhbar Tarihi Kıdem Baz Tarihinden Önce Olamaz'> !");
				closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');
			</script>
			<cfabort>
		</cfif>
	<cfelse>
		<cfif isdefined("attributes.ihbardate") and len(attributes.ihbardate) and datediff("d",attributes.ihbardate,get_hr_ssk_1.STARTDATE) gt 0>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id ='54158.İhbar Tarihi Giriş Tarihinden Önce Olamaz'>!");
				closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');
			</script>
			<cfabort>
		</cfif>
	</cfif>
	
	<cfif isdefined("attributes.ihbardate") and len(attributes.ihbardate) and datediff("d",attributes.finish_date,attributes.ihbardate) gt 0>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id ='54159.Çıkış Tarihi İhbar Tarihinden Önce Olamaz'>aa!");
			<cfif isdefined("attributes.modal_id")>
				closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');
			</cfif>
		</script>
		<cfabort>
	</cfif>
	
	<cfquery name="control_branch_puantaj" datasource="#dsn#">
		SELECT
			PUANTAJ_ID
		FROM
			EMPLOYEES_PUANTAJ
		WHERE
			(
			SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#">
			OR
				(
				SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
				SAL_MON > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
				)
			)
			AND SSK_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#this_branch_id_#"> AND
			PUANTAJ_TYPE = -1 <!--- gerçek puantaj--->
	</cfquery>
	<cfif control_branch_puantaj.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='59590.Çıkış Yapılan Şube İçin İleri Tarihli Puantaj Kaydı Var'>! <cf_get_lang dictionary_id='766.İşlem Yapılamaz'>");
			closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');
		</script>

	</cfif>
	
	<cfquery name="control_inout_puantaj" datasource="#dsn#">
		SELECT
			EP.PUANTAJ_ID
		FROM
			EMPLOYEES_PUANTAJ EP,
			EMPLOYEES_PUANTAJ_ROWS EPR
		WHERE
			EP.PUANTAJ_ID = EPR.PUANTAJ_ID AND
			EPR.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_hr_ssk_1.employee_id#"> AND
			(
			EP.SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#">
			OR
				(
				EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
				EP.SAL_MON > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
				)
			)
			AND SSK_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#this_branch_id_#"> AND
			EP.PUANTAJ_TYPE = -1 <!--- gerçek puantaj--->
	</cfquery>
	<cfif control_inout_puantaj.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='59589.Çıkış Yapılan Kişi İçin İleri Tarihli Puantaj Kaydı Var'>! <cf_get_lang dictionary_id='3570.İşlem Yapılamaz!'>");
			closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');
		</script>
	</cfif>
	<cfset day_ = attributes.finish_date>
	<cfset day_2 = attributes.ihbardate>
	<cfset attributes.finish_date = ''>
	<cfset attributes.ihbardate = ''>
	<!---<cfset attributes.sal_year = session.ep.period_year>---><!--- üst bölümde girilen çıkış tarihine göre yıl alınmaktadır. SG 20130422--->
	<cfif len(get_hr_ssk_1.puantaj_group_ids)>
		<cfset attributes.group_id = "#get_hr_ssk_1.PUANTAJ_GROUP_IDS#,">
	</cfif>
	<cfset attributes.branch_id = get_hr_ssk_1.branch_id>
	<cfset attributes.finish_date_ = day_><!---henüz çıkış tarihi ücret kartına atılmadığı için güne göre hesaplanan ödeneklerde sorun oluyordu bu nedenle girilen çıkış tarihi puantaj hesaplama sayfasına gönderildi. SG20140123 --->
	
	<cfif is_puantaj_off neq 1> <!--- Ücret kartındaki Puantaja Gelmesin checkboxı işaretli ise puantaj oluşturulmaması için eklendi. MA 20160612 --->
		
		<cfset from_fire_action = 1>
		<cfif get_hr_ssk_1.USE_SSK eq 2>
			<cfset last_month_1 = CreateDateTime(attributes.sal_year, attributes.sal_mon,get_program_parameters.FIRST_DAY_MONTH,0,0,0)>      
			<cfif attributes.finish_date_ lt last_month_1>
				<cfset attributes.sal_mon = month(dateadd("m",-1,last_month_1))>
			</cfif>
			<cfset get_payroll_job_ = get_payroll_job.create_payroll(
				sal_mon :  attributes.sal_mon,
				sal_year : attributes.sal_year,
				in_out_id : attributes.in_out_id,
				from_fire_action : 1,
				puantaj_type : -1,
				ssk_office : this_branch_id_,
				ssk_statue : 2,
				statue_type : 1)>
		<cfelse>
			<cfset is_execution = 1>
			<cfinclude template="../query/add_personal_puantaj_ajax.cfm">
		</cfif>
		
	</cfif>
	
	<cfset attributes.finish_date  = day_>
	<cfset attributes.ihbardate  = day_2>
	<cfquery name="get_rate" datasource="#dsn#"><!--- kur bilgileri--->
		SELECT 
		ISNULL((SELECT 
			TOP 1 RATE2
		FROM 
			MONEY_HISTORY 
		WHERE 
			(
				VALIDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
				OR
				VALIDATE_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
			) AND 
			COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND 
			PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND 
			MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_hr_ssk_1.money#">
		ORDER BY
			MONEY_HISTORY_ID DESC
		),1)RATE2,
		ISNULL((SELECT TOP 1
			   RATE2 
			 FROM 
				MONEY_HISTORY 
			WHERE 
				(VALIDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">OR
				VALIDATE_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">) AND 
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND 
				PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND 
				MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="TL">
			ORDER BY
				MONEY_HISTORY_ID DESC),1) RATE1
	</cfquery> 
	<cfquery name="get_salary_change" datasource="#dsn#"><!--- döviz karşılıkları--->
		SELECT COUNT(WORTH) AS SAY FROM EMPLOYEES_SALARY_CHANGE WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND SALARY_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(attributes.finish_date)#"> AND SALARY_MONTH = <cfqueryparam cfsqltype="cf_sql_integer" value="#month(attributes.finish_date)#">
	</cfquery>
	<!--- silmeyin EK 20030815 --->
	<cfif get_hr_ssk_1.GROSS_NET eq 1>
		<cfif get_hr_ssk_1.salary_type eq 1>
			<cfquery name="get_son_maas" datasource="#dsn#" maxrows="1">
			SELECT
				((EPR.TOTAL_SALARY - (EPR.TOTAL_PAY + EPR.TOTAL_PAY_TAX + EPR.TOTAL_PAY_SSK + EPR.TOTAL_PAY_SSK_TAX + EPR.EXT_SALARY)) / EPR.TOTAL_DAYS * 30) AS TOPLAM_KAZANC,
				ISNULL((SELECT SUM(AMOUNT) FROM EMPLOYEES_PUANTAJ_ROWS_EXT EPRE WHERE EPRE.EMPLOYEE_PUANTAJ_ID = EPR.EMPLOYEE_PUANTAJ_ID AND ISNULL(EPRE.IS_INCOME,0) = 1),0) AS TOPLAM_ODENEK,
				EP.SAL_MON,
				EPR.TOTAL_SALARY,
				EPR.TOTAL_PAY,
				EPR.TOTAL_PAY_TAX,
				EPR.TOTAL_PAY_SSK,
				EPR.TOTAL_PAY_SSK_TAX
			FROM
				EMPLOYEES_PUANTAJ_ROWS EPR,
				EMPLOYEES_PUANTAJ EP
			WHERE
				EP.SSK_OFFICE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this_ssk_office_#"> AND
				EP.SSK_OFFICE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this_ssk_no_#"> AND
				EPR.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#"> AND
				EPR.TOTAL_DAYS > 0 AND		
				EPR.PUANTAJ_ID = EP.PUANTAJ_ID AND
				(
					(
					EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#">
					AND
					EP.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
					)
					OR
					(
					EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#YEAR(cikis_start_date)#">
					AND
					EP.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#MONTH(cikis_start_date)#">
					)
				)
			ORDER BY 
				EP.SAL_YEAR DESC,
				EP.SAL_MON DESC
			</cfquery>
			<cfif get_son_maas.recordcount>
				<cfset ilgili_ay_ = get_son_maas.SAL_MON>
				<cfset gun_ = daysinmonth(ilgili_ay_)>
				<cfset get_son_maas.TOPLAM_KAZANC =  (get_son_maas.TOPLAM_KAZANC+get_son_maas.TOPLAM_ODENEK) / gun_ * 30>
			</cfif>
		<cfelse>
			<cfquery name="get_son_maas" datasource="#dsn#" maxrows="1">
			SELECT
				CASE
					WHEN ISNULL(EPR.SENIORITY_SALARY,0) > 0 THEN ISNULL((((EPR.SENIORITY_SALARY * EPR.TOTAL_DAYS / 30) - (EPR.TOTAL_PAY + EPR.TOTAL_PAY_TAX + EPR.TOTAL_PAY_SSK + EPR.TOTAL_PAY_SSK_TAX + EPR.EXT_SALARY)) / EPR.TOTAL_DAYS * 30),0) 
					ELSE ((EPR.TOTAL_SALARY - (EPR.TOTAL_PAY + EPR.TOTAL_PAY_TAX + EPR.TOTAL_PAY_SSK + EPR.TOTAL_PAY_SSK_TAX + EPR.EXT_SALARY)) / EPR.TOTAL_DAYS * 30)
				END AS TOPLAM_KAZANC,
				ISNULL((SELECT SUM(AMOUNT) FROM EMPLOYEES_PUANTAJ_ROWS_EXT EPRE WHERE EPRE.EMPLOYEE_PUANTAJ_ID = EPR.EMPLOYEE_PUANTAJ_ID AND ISNULL(EPRE.IS_INCOME,0) = 1),0) AS TOPLAM_ODENEK,
				EPR.TOTAL_SALARY,
				EPR.TOTAL_PAY,
				EPR.TOTAL_PAY_TAX,
				EPR.TOTAL_PAY_SSK,
				EPR.TOTAL_PAY_SSK_TAX,
				SENIORITY_SALARY
			FROM
				EMPLOYEES_PUANTAJ_ROWS EPR,
				EMPLOYEES_PUANTAJ EP,
				   EMPLOYEES_IN_OUT EIO
			WHERE
				EPR.IN_OUT_ID = EIO.IN_OUT_ID AND
				EP.SSK_OFFICE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this_ssk_office_#"> AND
				EP.SSK_OFFICE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this_ssk_no_#"> AND
				EPR.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#"> AND
				EPR.TOTAL_DAYS > 0 AND		
				EPR.PUANTAJ_ID = EP.PUANTAJ_ID AND
				(
					(
					EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
					EP.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
					)
					OR
					(
					EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#YEAR(cikis_start_date)#"> AND
					EP.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#MONTH(cikis_start_date)#">
					)
				)
			ORDER BY 
				EP.SAL_YEAR DESC,
				EP.SAL_MON DESC
		</cfquery>
		</cfif>
		<cfif get_program_parameters.GROSS_COUNT_TYPE eq 1>
			<cfquery name="get_last_maas" datasource="#dsn#" maxrows="1">
				SELECT
					<cfif get_hr_ssk_1.salary_type eq 1>
						(M#attributes.sal_mon# * 30) AS TOPLAM_KAZANC
					<cfelseif get_hr_ssk_1.salary_type eq 0>
						<cfif get_hr_ssk_1.SSK_MONTHLY_WORK_HOURS gt 0>
							(M#attributes.sal_mon# * #get_hr_ssk_1.SSK_MONTHLY_WORK_HOURS#) AS TOPLAM_KAZANC
						<cfelse>
							(M#attributes.sal_mon# * 225) AS TOPLAM_KAZANC
						</cfif>
					<cfelse>
						M#attributes.sal_mon# AS TOPLAM_KAZANC
					</cfif>
				FROM
					EMPLOYEES_SALARY
				WHERE
					PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
					IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#this_in_out_#">
			</cfquery>
			<cfset izin_baz_tutar = get_last_maas.TOPLAM_KAZANC>
		<cfelseif get_son_maas.recordcount>
			<cfset izin_baz_tutar = get_son_maas.TOPLAM_KAZANC+get_son_maas.TOPLAM_ODENEK>
		<cfelseif get_hr_ssk_1.salary_type neq 1 and get_son_maas.recordcount neq 0>
			<cfquery name="get_son_maas" datasource="#dsn#" maxrows="1">
				SELECT
					TOP 1
					ISNULL(((EPR.TOTAL_SALARY - (EPR.TOTAL_PAY + EPR.TOTAL_PAY_TAX + EPR.TOTAL_PAY_SSK + EPR.TOTAL_PAY_SSK_TAX + EPR.EXT_SALARY)) / EPR.TOTAL_DAYS * 30),0) AS TOPLAM_KAZANC,
					ISNULL((SELECT SUM(AMOUNT) FROM EMPLOYEES_PUANTAJ_ROWS_EXT EPRE WHERE EPRE.EMPLOYEE_PUANTAJ_ID = EPR.EMPLOYEE_PUANTAJ_ID AND ISNULL(EPRE.IS_INCOME,0) = 1),0) AS TOPLAM_ODENEK,
					EPR.TOTAL_SALARY,
					EPR.TOTAL_PAY,
					EPR.TOTAL_PAY_TAX,
					EPR.TOTAL_PAY_SSK,
					EPR.TOTAL_PAY_SSK_TAX
				FROM
					EMPLOYEES_PUANTAJ_ROWS EPR,
					EMPLOYEES_PUANTAJ EP,
					EMPLOYEES_IN_OUT EIO
				WHERE
					EPR.IN_OUT_ID = EIO.IN_OUT_ID AND
					EP.SSK_OFFICE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this_ssk_office_#"> AND
					EP.SSK_OFFICE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this_ssk_no_#"> AND
					EPR.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#"> AND
					EPR.TOTAL_DAYS > 0	
				ORDER BY 	
					EPR.EMPLOYEE_PUANTAJ_ID DESC
			</cfquery>
			<cfif get_son_maas.recordcount>
				<cfset izin_baz_tutar = get_son_maas.TOPLAM_KAZANC+get_son_maas.TOPLAM_ODENEK>
			<cfelse>
				<cfset izin_baz_tutar = 0>
			</cfif>
		<cfelse>
			<cfset izin_baz_tutar = 0>
		</cfif>
	<cfelse>
		<cfquery name="get_son_maas" datasource="#dsn#" maxrows="1">
			SELECT
				<cfif get_hr_ssk_1.salary_type eq 1>
					(M#attributes.sal_mon# * 30) AS TOPLAM_KAZANC
				<cfelseif get_hr_ssk_1.salary_type eq 0>
					<cfif get_hr_ssk_1.SSK_MONTHLY_WORK_HOURS gt 0>
						(M#attributes.sal_mon# * #get_hr_ssk_1.SSK_MONTHLY_WORK_HOURS#) AS TOPLAM_KAZANC
					<cfelse>                
						(M#attributes.sal_mon# * 225) AS TOPLAM_KAZANC
					</cfif>
				<cfelse>
					M#attributes.sal_mon# AS TOPLAM_KAZANC
				</cfif>
				,0 AS TOPLAM_ODENEK
			FROM
				EMPLOYEES_SALARY
			WHERE
				PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
				IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#this_in_out_#">
		</cfquery>
		<cfset izin_baz_tutar = get_son_maas.TOPLAM_KAZANC>
	</cfif>
	
	<cfquery name="GET_SUM_LAST_12_MONTHS" datasource="#dsn#" maxrows="12">
		SELECT
			AVG((EPR.TOTAL_SALARY/EPR.TOTAL_DAYS)*30) AS TOPLAM_KAZANC,
			COUNT(EPR.EMPLOYEE_ID) AS TOPLAM_AY,
			AVG(EPR.DAMGA_VERGISI) AS TOPLAM_DAMGA,
			AVG(EPR.GELIR_VERGISI) AS TOPLAM_GELIR
		FROM
			EMPLOYEES_PUANTAJ_ROWS EPR,
			EMPLOYEES_PUANTAJ EP
		WHERE
			EPR.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#"> AND
			EPR.TOTAL_DAYS > 0 AND		
			EPR.PUANTAJ_ID = EP.PUANTAJ_ID AND
			(
				(
				EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
				EP.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
				)
				OR
				(
				EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#YEAR(cikis_start_date)#"> AND
				EP.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#MONTH(cikis_start_date)#">
				)
				OR
				(
				EP.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#">
				)
			)
		GROUP BY
			EP.SAL_YEAR,
			EP.SAL_MON
		ORDER BY 
			EP.SAL_YEAR DESC,
			EP.SAL_MON DESC
	</cfquery>
	
	<cfquery name="GET_SIGORTA" datasource="#dsn#" maxrows="1">
		SELECT
			(VERGI_ISTISNA_SSK + VERGI_ISTISNA_VERGI + VERGI_ISTISNA_DAMGA) AS TOPLAM_SIGORTA
		FROM
			EMPLOYEES_PUANTAJ_ROWS EPR,
			EMPLOYEES_PUANTAJ EP
		WHERE
			EPR.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#"> AND
			EPR.TOTAL_DAYS > 0 AND		
			EPR.PUANTAJ_ID = EP.PUANTAJ_ID AND
			(
				(
				EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
				EP.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
				)
				OR
				(
				EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#YEAR(cikis_start_date)#"> AND
				EP.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#MONTH(cikis_start_date)#">
				)
				OR
				(
				EP.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#">
				)
			)
		ORDER BY 
			EP.SAL_YEAR DESC,
			EP.SAL_MON DESC
	</cfquery>
	
	<cfquery name="get_emp_offtimes" datasource="#dsn#">
		SELECT
			SUM(DATEDIFF(DAY,OFFTIME.STARTDATE, OFFTIME.FINISHDATE)+ 1)  AS TOPLAM_GUN
		FROM
			OFFTIME,
			SETUP_OFFTIME
		WHERE
		(
		(OFFTIME.STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CREATEODBCDATETIME(cikis_start_date)#"> AND OFFTIME.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CREATEODBCDATETIME(attributes.finish_date)#">) OR
		(OFFTIME.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CREATEODBCDATETIME(cikis_start_date)#"> AND OFFTIME.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CREATEODBCDATETIME(attributes.finish_date)#">)
		) AND	
		OFFTIME.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#"> AND
		OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID AND
		OFFTIME.VALID = 1 AND
		OFFTIME.IS_PUANTAJ_OFF = 0 AND
		(SETUP_OFFTIME.IS_KIDEM = 0 OR SETUP_OFFTIME.IS_KIDEM IS NULL)
	</cfquery>
	<cfquery name="get_days" datasource="#dsn#">
		SELECT 
			SUM(TOTAL_DAYS) AS TOPLAM_GUN
		FROM
			EMPLOYEES_PUANTAJ_ROWS
		WHERE 
			EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
	</cfquery>
	
	<cfset ayni_yardim_total = 0>
	<cfquery name="get_ayni_yardims" datasource="#dsn#">
		SELECT
			SUM(AMOUNT_PAY) AS AYNI_TOTAL
		FROM
			SALARYPARAM_PAY
		WHERE
			IS_AYNI_YARDIM = 1 AND
			START_SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
			END_SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
			TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
			IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#this_in_out_#">
	</cfquery>
	<cfif get_ayni_yardims.recordcount and len(get_ayni_yardims.AYNI_TOTAL)>
		<cfset ayni_yardim_total = get_ayni_yardims.AYNI_TOTAL>
	</cfif>
	<cfquery name="get_progress_payment_out" datasource="#dsn#">
		SELECT * FROM EMPLOYEE_PROGRESS_PAYMENT_OUT WHERE EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
	</cfquery>
	<cfquery name="get_progress_time" dbtype="query">
		SELECT SUM(PROGRESS_TIME) AS PROGRESS_TIME FROM get_progress_payment_out WHERE IS_KIDEM = 1
	</cfquery>
	
	<cfscript>
		if (get_progress_time.recordcount)
			attributes.progress_time = get_progress_time.PROGRESS_TIME;
		else
			attributes.progress_time = 0;
		if (isnumeric(get_emp_offtimes.TOPLAM_GUN))
			toplam_izin = get_emp_offtimes.TOPLAM_GUN;
		else
			toplam_izin = 0;
		
		if(get_program_parameters.FINISH_DATE_COUNT_TYPE eq 1) //çıkış günü hesaplama şekli (yıl/ay/gün)
		{
			//cikis_start_ = dateadd('d',attributes.progress_time,cikis_start_date); //kıdemden sayılmayacak gun degerininde dusulerek hesaplanması icin eklendi. SG20130621
			cikis_start_ = cikis_start_date;
	
			total_ssk_years = datediff("yyyy",cikis_start_,dateadd('d',1,attributes.finish_date));
				
			if(total_ssk_years gte 1)
				total_ssk_months = datediff("m",cikis_start_,date_add("yyyy",-total_ssk_years,attributes.finish_date));
			else
				total_ssk_months = datediff("m",cikis_start_,attributes.finish_date);	
	
			new_date = attributes.finish_date; 
			if(total_ssk_years gte 1) new_date = date_add("yyyy",-total_ssk_years,attributes.finish_date);
			if(total_ssk_months gte 1) new_date = date_add("m",-total_ssk_months,new_date);
			if(month(attributes.finish_date) eq 2 and (day(attributes.finish_date) gt daysinmonth(attributes.finish_date) or daysinmonth(attributes.finish_date) gte 28))
			{
				new_date = createdate(year(new_date),month(new_date),daysinmonth(new_date));
			}	
			total_ssk_days_2 = datediff("d",cikis_start_,new_date)+1;
				
			if(total_ssk_days eq 0 and datediff("d",attributes.finish_date,cikis_start_) eq 0)
			{
				total_ssk_days = 1;
			}
			if(total_ssk_years lt 0)
				total_ssk_years = 0;
			if(total_ssk_months lt 0)
				total_ssk_months = 0;
			if(total_ssk_days_2 lt 0)
				total_ssk_days_2 = 0;
			//20131030
			progress_time = attributes.progress_time + toplam_izin;
			if (progress_time gte 365)
				progress_time_years = progress_time \ 365; 
			else 
				progress_time_years = 0;
			temp_kalan = progress_time - (progress_time_years * 365);
			if (temp_kalan gte 30)
				progress_time_months = temp_kalan \ 30;
			else
				progress_time_months = 0;
			progress_time_days = temp_kalan - (progress_time_months * 30);
	
			if (total_ssk_days_2 gte progress_time_days)
				total_ssk_days_2 = total_ssk_days_2 - progress_time_days;
			else {
				if (total_ssk_months gt 0)
					total_ssk_months = total_ssk_months - 1;
				else {
					total_ssk_months = total_ssk_months + 11;
					total_ssk_years = total_ssk_years - 1;
				}
				total_ssk_days_2 = total_ssk_days_2 + 30;
				total_ssk_days_2 = total_ssk_days_2 - progress_time_days;
			}
			if (total_ssk_months gte progress_time_months)
				total_ssk_months = total_ssk_months - progress_time_months;
			else {
				total_ssk_months = total_ssk_months + 12;
				total_ssk_years = total_ssk_years - 1;
				total_ssk_months = total_ssk_months - progress_time_months;
			}		
			total_ssk_years = total_ssk_years - progress_time_years;
			//20131030
			total_ssk_days = (total_ssk_years * 365) + (total_ssk_months * 30) + total_ssk_days_2;
			//total_ssk_days = total_ssk_days - toplam_izin;
		}	
		else //çıkış günü hesaplama şekli (gün hesabı)
		{
			if( not len(attributes.progress_time))attributes.progress_time = 0;
			cikis_start_ = dateadd('d',attributes.progress_time,cikis_start_date); //kıdemden sayılmayacak gun degerininde dusulerek hesaplanması icin eklendi. SG20130705
			new_date = attributes.finish_date;
				
			total_ssk_days = datediff("d",cikis_start_date,new_date) + 1;
				
			if(total_ssk_days eq 0 and datediff("d",attributes.finish_date,cikis_start_) eq 0)
				total_ssk_days = 1;
				
			if(total_ssk_days eq 1 and day(new_date) neq day(cikis_start_))
			{
				total_ssk_days = 2;
			}
			total_ssk_days = total_ssk_days - toplam_izin - attributes.progress_time; //kıdemden sayılmayacak gun sayısı cıkarılıyor
			total_ssk_years = fix(total_ssk_days / 365);
			total_ssk_months = fix((total_ssk_days - (total_ssk_years * 365)) / 30);
			total_ssk_days_2 = total_ssk_days - (total_ssk_years * 365) - (total_ssk_months * 30);
		}
	
		if ((total_ssk_years lt 1) or (not isdefined("kidem_hesap")) )
			no_kidem = 1; // kıdem yok
		else
			no_kidem = 0; // kidem hesaplanacak
		
		if (not isdefined("ihbar_hesap"))
			no_ihbar = 1;
		else if(get_hr_ssk_1.SURELI_IS_AKDI EQ 1 and (not len(get_program_parameters.IS_SURELI_IS_AKDI_OFF) or get_program_parameters.IS_SURELI_IS_AKDI_OFF eq 0))
			no_ihbar = 1;
		else if(get_hr_ssk_1.SURELI_IS_AKDI EQ 1 and get_program_parameters.IS_SURELI_IS_AKDI_OFF eq 1 and len(get_hr_ssk_1.SURELI_IS_FINISHDATE) and datediff("d",get_hr_ssk_1.SURELI_IS_FINISHDATE,attributes.finish_date) lt 1)
			no_ihbar = 1;
		else
			no_ihbar = 0;
	</cfscript>
	<!--- izin hesabi --->
	<cfsavecontent variable="izin_hesap"><cfinclude template="/V16/hr/display/list_offtime_emp.cfm"></cfsavecontent>
	<!--- izin hesabi --->
	<cfquery name="get_offtime_limits" datasource="#dsn#">
		SELECT * FROM SETUP_OFFTIME_LIMIT WHERE STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
		<cfif len(get_hr_ssk_1.puantaj_group_ids)>
			AND (
					   <cfloop list="#get_hr_ssk_1.puantaj_group_ids#" index="i">
						','+PUANTAJ_GROUP_IDS+',' LIKE '%,#i#,%' <cfif i neq listlast(get_hr_ssk_1.puantaj_group_ids,',')>OR</cfif>
					</cfloop> OR PUANTAJ_GROUP_IDS IS NULL) ORDER BY PUANTAJ_GROUP_IDS DESC
		  </cfif>
	</cfquery>
	<cfif not get_offtime_limits.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id ='54161.Girilen Tarihlerde İzin Limitleri Girilmemiş'>!");
			closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');
		</script>
		<cfabort>
	</cfif>
	<cfquery name="get_emp_in_outs" datasource="#dsn#">
		SELECT
			IHBAR_AMOUNT,
			KIDEM_AMOUNT,
			TOTAL_SSK_DAYS
		FROM
			EMPLOYEES_IN_OUT
		WHERE
			EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
			TOTAL_SSK_DAYS <> 0 AND
			TOTAL_SSK_DAYS IS NOT NULL
	</cfquery>
	
	<cfif not no_kidem or not no_ihbar>
		<cfquery name="get_emp_kidem_dahil_odeneks" datasource="#dsn#">
			SELECT
				EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID,
				EMPLOYEES_PUANTAJ_ROWS.SALARY,
				EMPLOYEES_PUANTAJ_ROWS_EXT.COMMENT_PAY,
				EMPLOYEES_PUANTAJ_ROWS_EXT.AMOUNT,
				EMPLOYEES_PUANTAJ_ROWS_EXT.AMOUNT_2,
				EMPLOYEES_PUANTAJ.SAL_MON,
				EMPLOYEES_PUANTAJ.SAL_YEAR,
				EMPLOYEES_PUANTAJ.SSK_OFFICE,
				EMPLOYEES_PUANTAJ.SSK_OFFICE_NO,
				EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID,
				EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID
			FROM
				EMPLOYEES_PUANTAJ_ROWS_EXT,
				EMPLOYEES_PUANTAJ_ROWS,
				EMPLOYEES_PUANTAJ
			WHERE
				EMPLOYEES_PUANTAJ.PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID
				AND EMPLOYEES_PUANTAJ.PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS_EXT.PUANTAJ_ID
				AND EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#">
				AND EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS_EXT.EMPLOYEE_PUANTAJ_ID
				AND EMPLOYEES_PUANTAJ_ROWS_EXT.IS_KIDEM = 1
				AND EMPLOYEES_PUANTAJ_ROWS_EXT.EXT_TYPE = 0
				AND ISNULL(EMPLOYEES_PUANTAJ_ROWS_EXT.IS_INCOME,0) = 0
				AND
				(
					(
					EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
					EMPLOYEES_PUANTAJ.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
					)				
					OR
					(
					EMPLOYEES_PUANTAJ.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
					EMPLOYEES_PUANTAJ.SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year-2#"> AND
					   EMPLOYEES_PUANTAJ.SAL_MON > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
					)
				)
			ORDER BY
				EMPLOYEES_PUANTAJ.SAL_YEAR DESC,
				EMPLOYEES_PUANTAJ.SAL_MON DESC
		</cfquery>
		<!--- kıdem toplamı gün yüzde dikkate alınarak toplanacak ortalaması alınacak --->
		<cfset TEMP_AVG = 0>
		<cfoutput query="get_emp_kidem_dahil_odeneks">
			<cfif AMOUNT_2 EQ 0><!--- ARTI --->
				<cfset TEMP_AVG = TEMP_AVG + AMOUNT>
			<cfelse><!--- YÜZDE --->
				<cfset TEMP_AVG = TEMP_AVG + AMOUNT_2>
			</cfif>
		</cfoutput>	
		<cfset datediff_ = datediff('d',cikis_start_date,attributes.finish_date)/30><!--- Hesaplamalarda Kıdem Baz Tarihini Kullan seçili ise baslangiz tarihi kidem tarihi olacağı için duzenleme yapıldı SG 20140219 --->
		<!--- <cfset datediff_ = datediff('d',attributes.startdate,attributes.finish_date)/30> --->
		<cfif datediff_ eq 0>
			<cfset datediff_ = 1>
		</cfif>
		<cfif datediff_ mod 30 neq 0>
			<cfset datediff_ = Int(datediff_)+1>
		</cfif>
		<cfif datediff_ gt 12>
			<cfset datediff_ = 12>
		</cfif>
		<cfset kidem_dahil_odenek = TEMP_AVG / datediff_>
	</cfif>
	<cfquery name="get_seniority_comp_max" datasource="#dsn#">
		SELECT ISNULL(SENIORITY_COMPANSATION_MAX,0) AS SENIORITY_COMPANSATION_MAX FROM INSURANCE_PAYMENT WHERE STARTDATE <= #parameter_last_month_1#  AND FINISHDATE >= #parameter_last_month_1#
	</cfquery>
	<cfscript>
		paid_kidem_days = 0;
		paid_ihbar_days = 0;
		ihbar_days = 0;
		baz_ucret = 0;
		last_limit_days = 0;
		ihbar_amount = 0;
		kidem_amount = 0;
		if(get_hr_ssk_1.use_ssk eq 0 and get_hr_ssk_1.money neq 'TL' and get_salary_change.say eq 0) 
		//sgk lı değilse,ücret tanımları tl dışında ise ve döviz karşılıklarında kayıt yok ise--->
		{
			kidem_max = (get_seniority_comp_max.seniority_compansation_max*get_rate.rate1)/get_rate.rate2;
		}
		else
		{
			kidem_max = get_seniority_comp_max.seniority_compansation_max;
		}
		kullanilan_yillik_izin = 0;
		yillik_izin_amount = 0;
		//izin_baz_tutar = 0;
		if(get_son_maas.RECORDCOUNT and len(get_son_maas.TOPLAM_KAZANC))
		{
			salary = wrk_round(get_son_maas.TOPLAM_KAZANC+get_son_maas.TOPLAM_ODENEK);
			daily_salary = wrk_round((get_son_maas.TOPLAM_KAZANC+get_son_maas.TOPLAM_ODENEK) / 30);
		}
		else
		{
			salary = 0;
			daily_salary = 0;
		}
		if(GET_SUM_LAST_12_MONTHS.RECORDCOUNT)
		{
			toplam_damga_12_aylik = GET_SUM_LAST_12_MONTHS.TOPLAM_DAMGA;
			toplam_gelir_12_aylik = GET_SUM_LAST_12_MONTHS.TOPLAM_GELIR;
		}
		else
		{
			toplam_damga_12_aylik = 0;
			toplam_gelir_12_aylik = 0;
		}
		
		//if (get_hr_ssk_1.sabit_prim eq 1) // primli çalışan
			//{
			//if (isnumeric(GET_SUM_LAST_12_MONTHS.TOPLAM_KAZANC) )
				////baz_ucret = GET_SUM_LAST_12_MONTHS.TOPLAM_KAZANC;
			//}
		//else // sabit ücretli çalışan   
			//{
			baz_ucret = salary + kidem_dahil_odenek;
			//}
		sigorta_toplam = 0;
		if(GET_SIGORTA.recordcount and GET_SIGORTA.TOPLAM_SIGORTA gt 0 and attributes.x_tax_acc eq 1)
		{
			baz_ucret = baz_ucret + GET_SIGORTA.TOPLAM_SIGORTA;
			sigorta_toplam = GET_SIGORTA.TOPLAM_SIGORTA;
		}
		
		baz_ucret = baz_ucret + ayni_yardim_total;
		daily_baz = baz_ucret / 30;
		daily_baz_kidem  = (baz_ucret - kidem_dahil_odenek) / 30;
		
		for (k=1; k lte get_emp_in_outs.recordcount;k = k+1)
		{
			if (get_emp_in_outs.ihbar_amount[k] gt 0) paid_ihbar_days = paid_ihbar_days + get_emp_in_outs.TOTAL_SSK_DAYS[k];
			if (get_emp_in_outs.KIDEM_AMOUNT[k] gt 0) paid_kidem_days = paid_kidem_days + get_emp_in_outs.TOTAL_SSK_DAYS[k];
		}
		
		if (not no_ihbar)
		{
			ihbar_fark_ = datediff("d",attributes.ihbardate,attributes.finish_date);
			if ((total_ssk_days-paid_ihbar_days) gt get_program_parameters.DENUNCIATION_1_LOW AND (total_ssk_days-paid_ihbar_days) lte get_program_parameters.DENUNCIATION_1_HIGH)
			{	
				ihbar_days = get_program_parameters.DENUNCIATION_1;
			}
			else if ((total_ssk_days-paid_ihbar_days) gte get_program_parameters.DENUNCIATION_2_LOW AND (total_ssk_days-paid_ihbar_days) lte get_program_parameters.DENUNCIATION_2_HIGH)
			{
				ihbar_days = get_program_parameters.DENUNCIATION_2;
			}
			else if ((total_ssk_days-paid_ihbar_days) gte get_program_parameters.DENUNCIATION_3_LOW AND (total_ssk_days-paid_ihbar_days) lte get_program_parameters.DENUNCIATION_3_HIGH)
			{
				ihbar_days = get_program_parameters.DENUNCIATION_3;
			}
			else if ((total_ssk_days-paid_ihbar_days) gte get_program_parameters.DENUNCIATION_4_LOW AND (total_ssk_days-paid_ihbar_days) lte get_program_parameters.DENUNCIATION_4_HIGH)
			{
				ihbar_days = get_program_parameters.DENUNCIATION_4;
			}
			else if(len(get_program_parameters.DENUNCIATION_5_LOW) AND len(get_program_parameters.DENUNCIATION_5_HIGH) AND len(get_program_parameters.DENUNCIATION_5) AND (total_ssk_days-paid_ihbar_days) gte get_program_parameters.DENUNCIATION_5_LOW AND (total_ssk_days-paid_ihbar_days) lte get_program_parameters.DENUNCIATION_5_HIGH)
			{
				ihbar_days = get_program_parameters.DENUNCIATION_5;	
			}
			else if(len(get_program_parameters.DENUNCIATION_6_LOW) AND len(get_program_parameters.DENUNCIATION_6_HIGH) AND len(get_program_parameters.DENUNCIATION_6) AND (total_ssk_days-paid_ihbar_days) gte get_program_parameters.DENUNCIATION_6_LOW AND (total_ssk_days-paid_ihbar_days) lte get_program_parameters.DENUNCIATION_6_HIGH)
			{
				ihbar_days = get_program_parameters.DENUNCIATION_6;	
			}
			
			if(ihbar_fark_ gte ihbar_days)
			{
				ihbar_amount = 0;
			}
			else
			{
				ihbar_amount = daily_baz * ihbar_days;
			}
		}
	
		if (not no_kidem)
		{
			if(get_program_parameters.FINISH_DATE_COUNT_TYPE eq 1)
			{
				kidem_amount = 0;
				if (kidem_max lte baz_ucret)
					temp_kidem_ucret = kidem_max;
				else
					temp_kidem_ucret = baz_ucret;
				if (total_ssk_years gt 0)
					kidem_amount = kidem_amount + (temp_kidem_ucret * total_ssk_years);
				if (total_ssk_months gt 0)
					kidem_amount = kidem_amount + (temp_kidem_ucret / 12 * total_ssk_months);
				if (total_ssk_days_2 gt 0)
				{
					if(isDefined("x_calculate_kidem") and len(x_calculate_kidem) and x_calculate_kidem eq 365)
						kidem_amount = kidem_amount + (temp_kidem_ucret / 365 * total_ssk_days_2);
					else
						kidem_amount = kidem_amount + (temp_kidem_ucret / 12 / 30 * total_ssk_days_2);		
				}	
			}
			else
			{
				if (kidem_max lte baz_ucret)
				{
					kidem_amount = (kidem_max * (total_ssk_days-paid_kidem_days)) / 365;
				}
				else 
				{
					kidem_amount = (baz_ucret * (total_ssk_days-paid_kidem_days)) / 365;
				}
			}
		}
		//damga vergisi cikartilmaz kidem_amount = kidem_amount - toplam_damga_12_aylik;
		
		kullanilan_yillik_izin = genel_izin_toplam;
		if(isdefined("x_salary_pay_count") and len(x_salary_pay_count) and get_hr_ssk_1.GROSS_NET eq 0 and len(izin_baz_tutar))//Brütse
			yillik_izin_amount = (((izin_baz_tutar * x_salary_pay_count) / 12) / 30) * (toplam_hakedilen_izin - genel_izin_toplam - old_days);
		else if(len(izin_baz_tutar))
			yillik_izin_amount = (izin_baz_tutar / 30) * (toplam_hakedilen_izin - genel_izin_toplam - old_days);
		else
			yillik_izin_amount = 0;
	</cfscript>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box title="2- #getLang('','İşten Çıkarma','52993')# - #getLang('','İzin ve MAtrah Hesabı','56871')#" popup_box="1">
			<cfform name="fire_2" action="#request.self#?fuseaction=ehesap.list_fire&event=debit" method="post">
				<cfinput type="hidden" name="modal_id" value="#attributes.modal_id#">
				<cfoutput>
					<input type="hidden" name="in_out_id" id="in_out_id" value="#this_in_out_#">
					<input type="hidden" name="employee_id" id="employee_id" value="#attributes.employee_id#">
					<input type="hidden" name="startdate" id="startdate" value="#dateformat(attributes.startdate,dateformat_style)#">
					<input type="hidden" name="kidem_baz" id="kidem_baz" value="#dateformat(attributes.kidem_baz,dateformat_style)#">
					<input type="hidden" name="finish_date" id="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#">
					<input type="hidden" name="fire_detail" id="fire_detail" value="#fire_detail#">
					<input type="hidden" name="ihbardate"  id="fire_detail"value="#ihbardate#">
					<input type="hidden" name="explanation_id" id="explanation_id" value="#attributes.explanation_id#">
					<input type="hidden" name="finishdate" id="finishdate" value="#dateformat(attributes.finish_date,dateformat_style)#">
					<cfif isdefined("attributes.reason_id")>
						<input type="hidden" name="reason_id" id="reason_id" value="#attributes.reason_id#">
					</cfif>
					<cfif isdefined('attributes.is_kidem_baz')>
						<input type="hidden" name="is_kidem_baz" id="is_kidem_baz" value="#attributes.is_kidem_baz#">
					</cfif>
					<input type="hidden" name="GROSS_COUNT_TYPE" id="GROSS_COUNT_TYPE" value="<cfif get_hr_ssk_1.GROSS_NET eq 1 and get_program_parameters.GROSS_COUNT_TYPE eq 1>1<cfelse>0</cfif>">
					<cfif isdefined('attributes.is_kidem_ihbar_all_total')>
						<input type="hidden" name="is_kidem_ihbar_all_total" id="is_kidem_ihbar_all_total" value="#attributes.is_kidem_ihbar_all_total#">
					</cfif>
				</cfoutput>
				<cfset salary_extra_value = 0>
				<cfif get_hr_ssk_1.duty_type eq 8>
					<cfquery name="get_factor_definition" datasource="#dsn#" maxrows="1">
						SELECT SALARY_FACTOR,BASE_SALARY_FACTOR,BENEFIT_FACTOR FROM SALARY_FACTOR_DEFINITION WHERE STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDateTime(year(attributes.finish_date),month(attributes.finish_date),1,0,0,0)#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDateTime(year(attributes.finish_date),month(attributes.finish_date),daysinmonth(createdate(year(attributes.finish_date),month(attributes.finish_date),1)),0,0,0)#"> 
					</cfquery>	
					<cfif get_factor_definition.recordcount>
						<cfquery name="get_salary_factor_def" datasource="#dsn#" maxrows="1">
							SELECT GRADE,STEP FROM EMPLOYEES_RANK_DETAIL WHERE PROMOTION_START <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#parameter_last_month_30#"> AND PROMOTION_FINISH >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#parameter_last_month_30#"> AND EMPLOYEE_ID = #attributes.employee_id#
						</cfquery>
						<cfif get_salary_factor_def.recordcount>
							<cfquery name="get_salary_factor" datasource="#dsn#">
								SELECT
									EXTRA,
									<cfif get_salary_factor_def.step eq 1>
										GRADE1_VALUE GRADE_VALUE
									<cfelseif get_salary_factor_def.step eq 2>
										GRADE2_VALUE GRADE_VALUE
									<cfelseif get_salary_factor_def.step eq 3>
										GRADE3_VALUE GRADE_VALUE
									<cfelseif get_salary_factor_def.step eq 4>
										GRADE4_VALUE GRADE_VALUE
									</cfif>
								FROM
									SALARY_FACTORS
								WHERE
									GRADE = #get_salary_factor_def.GRADE#
							</cfquery>
							<cfif get_salary_factor.recordcount>
								<cfset salary_extra_value = get_salary_factor.extra>
								<cfset salary_extra_value = salary_extra_value + get_salary_factor.grade_value>
								<cfset salary_extra_value = salary_extra_value*get_factor_definition.SALARY_FACTOR>
							</cfif>
						</cfif>
					</cfif>        
				</cfif>
				<cf_box_elements>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-total_ssk_days">
							<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='52996.Toplam Çalıştığı Gün'></label>
							<div class="col col-7 col-xs-12">
								<cfinput type="text" name="total_ssk_days" value="#total_ssk_days#" validate="integer" onchange="re_calc();" style="width:125px;">
							</div>
						</div>
						<div class="form-group" id="item-progress_time">
							<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='54349.Kıdemden sayılmayacak gün'></label>
							<div class="col col-7 col-xs-12">
								<cfinput type="text" name="progress_time" value="#attributes.progress_time#" validate="integer" style="width:125px;">
							</div>
						</div>
						<div class="form-group" id="item-total_ssk_years">
							<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='58455.Yıl'></label>
							<div class="col col-7 col-xs-12">
								<cfinput type="text" name="total_ssk_years" value="#total_ssk_years#" validate="integer" readonly="yes" style="width:125px;">
							</div>
						</div>
						<div class="form-group" id="item-total_ssk_months">
							<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='58724.Ay'></label>
							<div class="col col-7 col-xs-12">
								<cfinput type="text" name="total_ssk_months" value="#total_ssk_months#" validate="integer" readonly="yes" style="width:125px;">
							</div>
						</div>
						<div class="form-group" id="item-total_ssk_days_2">
							<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='57490.Gün'></label>
							<div class="col col-7 col-xs-12">
								<cfinput type="text" name="total_ssk_days_2" value="#total_ssk_days_2#" validate="integer" readonly="yes" style="width:125px;">
							</div>
						</div>
						<div class="form-group" id="item-total_deneme_days">
							<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='53001.Deneme Süresi Gün'></label>
							<div class="col col-7 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='53386.Deneme Süresi gün girmelisiniz'></cfsavecontent>
								<cfinput type="text" name="total_deneme_days" value="#total_deneme_days#" required="yes" message="#message#" validate="integer" onchange="re_calc();" style="width:125px;">
							</div>
						</div>
						<div class="form-group" id="item-hakkedilen_izin">
							<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='53387.Toplam Yıllık İzin Hakkı'></label>
							<div class="col col-7 col-xs-12">
								<cfinput type="text" name="hakkedilen_izin" value="#toplam_hakedilen_izin#" required="yes" message="#getLang('','Toplam Yıllık İzin Hakkı',53387)#" validate="integer" readonly="yes" style="width:125px;">
							</div>
						</div>
						<div class="form-group" id="item-kullanilmayan_yillik_izin">
							<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='53388.Kullanmadığı Yıllık İzinler'></label>
							<div class="col col-7 col-xs-12">
								<cfinput type="text" name="kullanilmayan_yillik_izin" value="#toplam_hakedilen_izin - genel_izin_toplam - old_days#" required="yes" message="#getLang('','Kullanmadığı Yıllık İzinler',53388)#" validate="float" onchange="re_calc();" style="width:125px;">
							</div>
						</div>
						<div class="form-group" id="item-ihbar_days">
							<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='52997.Toplam İhbar Gün'></label>
							<label class="col col-7 col-xs-12">
								<cfif isdefined("attributes.ihbar_hesap") and (not no_ihbar)>
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='53390.Toplam İhbar gün girmelisiniz'></cfsavecontent>
									<cfinput type="text" name="ihbar_days" value="#ihbar_days#" required="yes" message="#message#" validate="integer" onchange="re_calc();" style="width:125px;">
								<cfelse>
									<input type="hidden" name="ihbar_days" id="ihbar_days" value="0">0
								</cfif>
							</label>
						</div>
						<div class="form-group" id="item-paid_ihbar_days">
							<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='53391.Ödenmiş İhbar Gün'></label>
							<label class="col col-7 col-xs-12">
								<cfoutput>#paid_ihbar_days#</cfoutput>
							</label>
						</div>
						<div class="form-group" id="item-paid_kidem_days">
							<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='53394.Ödenmiş Kıdem Gün'></label>
							<label class="col col-7 col-xs-12">
								<cfoutput>#paid_kidem_days#</cfoutput>
							</label>
						</div>
						<div class="form-group" id="item-VALIDATOR_POSITION_CODE">
							<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='57500.Onay'></label>
							<div class="col col-7 col-xs-12">
								<div class="input-group">
									<cfquery name="GET_USER_NAME" datasource="#DSN#">
										SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #session.ep.userid#
									</cfquery>
									<input type="hidden" name="VALIDATOR_POSITION_CODE" id="VALIDATOR_POSITION_CODE" value="<cfoutput>#session.ep.position_code#</cfoutput>">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='53395.onay verecek kişi girmelisiniz'></cfsavecontent>
									<cfinput type="text" name="employee" value="#get_user_name.employee_name# #get_user_name.employee_surname#" style="width:125px;" required="yes" message="#message#" readonly="yes">
									<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_positions&field_code=fire_2.VALIDATOR_POSITION_CODE&field_emp_name=fire_2.employee</cfoutput>');"></span>
								</div>
							</div>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-employee">
							<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'></label>
							<label class="col col-7 col-xs-12">
							<cfoutput>#form.employee#</cfoutput>
							</label>
						</div>
						<div class="form-group" id="item-cikis_start_date">
							<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='57628.Giriş Tarihi'></label>
							<label class="col col-7 col-xs-12">
							<cfoutput>#dateformat(cikis_start_date,dateformat_style)#</cfoutput>
							</label>
						</div>
						<div class="form-group" id="item-cikis_start_date">
							<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='53642.İhbar Edilen Çıkış Tarihi'></label>
							<label class="col col-7 col-xs-12"><cfoutput>#form.finish_date#</cfoutput></label>
						</div>
						<div class="form-group" id="item-ihbardate">
							<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id ='53644.İhbar Bildirim T'></label>
							<label class="col col-7 col-xs-12"><cfoutput>#form.ihbardate#</cfoutput></label>
						</div>
						<div class="form-group" id="item-baz_ucret">
							<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='53385.Tazminat Matrahı'></label>
							<div class="col col-7 col-xs-12">
							<cfinput value="#TLFormat(baz_ucret+salary_extra_value)#" type="text" name="baz_ucret" style="width:125px;" onchange="re_calc();">
							</div>
						</div>
						<div class="form-group" id="item-salary">
							<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='53234.Maaş'></label>
							<div class="col col-7 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='53102.Maaş girmelisiniz'></cfsavecontent>
								<cfif get_hr_ssk_1.duty_type neq 8>					
									<cfinput value="#TLFormat(salary)#" message="#message#" type="text" name="salary" style="width:125px;" readonly="yes">
								<cfelse>
									<cfinput value="#TLFormat(salary_extra_value)#" message="#message#" type="text" name="salary" style="width:125px;" readonly="yes">
								</cfif>
							</div>
						</div>
						<div class="form-group" id="item-kidem_amount">
							<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='52991.Kıdem Tazminatı'></label>
							<label class="col col-7 col-xs-12">
								<cfif isdefined("kidem_hesap")>
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='53389.Kıdem Tazminatı girmelisiniz'></cfsavecontent>
									<cfinput value="#wrk_round(kidem_amount)#" required="Yes" message="#message#" type="text" name="kidem_amount" style="width:125px;">
								<cfelse>
									<input type="hidden" name="kidem_amount" id="kidem_amount" value="0">0
								</cfif>
							</label>
						</div>
						<div class="form-group" id="item-ihbar_amount">
							<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='52992.İhbar Tazminatı'></label>
							<label class="col col-7 col-xs-12">
								<cfif isdefined("ihbar_hesap") and (not no_ihbar)>
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='53392.İhbar Tazminatı girmelisiniz'></cfsavecontent>
									<cfinput value="#wrk_round(ihbar_amount)#" required="Yes" message="#message#" type="text" name="ihbar_amount" style="width:125px;">
								<cfelse>
									<input type="hidden" name="ihbar_amount" id="ihbar_amount" value="0">0
								</cfif>
							</label>
						</div>
						<div class="form-group" id="item-yillik_izin_amount">
							<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='53393.Yıllık İzin Tutarı'><cfif get_program_parameters.GROSS_COUNT_TYPE eq 1>Net</cfif></label>
							<div class="col col-7 col-xs-12">
								<cfinput type="text" name="yillik_izin_amount" value="#wrk_round(yillik_izin_amount)#" required="yes" message="#getLang('','Yıllık İzin Tutarı',53393)#" onchange="re_calc();"  style="width:125px;">
							</div>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
						<cfif isdefined("attributes.IS_EMPTY_POSITION")>
							<div class="form-group" id="item-IS_EMPTY_POSITION">
								<label><input type="checkbox" name="IS_EMPTY_POSITION" id="c" value="1" <cfif isdefined("attributes.IS_EMPTY_POSITION") and attributes.IS_EMPTY_POSITION eq 1>checked</cfif>></label>
								<label><cf_get_lang dictionary_id='53419.Çıkış İşlemi Tamamlandığında Çalışan Pozisyonlarını da Boşalt'></label>
							</div>
						</cfif>
						<cfif isdefined("attributes.IS_STATUS_EMPLOYEE")>
							<div class="form-group" id="item-IS_STATUS_EMPLOYEE">
								<label><input type="hidden" name="IS_STATUS_EMPLOYEE" id="IS_STATUS_EMPLOYEE" value="1" <cfif isdefined("attributes.IS_STATUS_EMPLOYEE") and attributes.IS_STATUS_EMPLOYEE eq 1>checked</cfif>></label>
							</div>
						<cfelse>
							<input type="hidden" name="IS_STATUS_EMPLOYEE" id="IS_STATUS_EMPLOYEE" value="0">
						</cfif>
						<cfif isdefined("get_emp_kidem_dahil_odeneks") and get_emp_kidem_dahil_odeneks.recordcount>
							<cf_seperator id="calc_detail" title="#getLang('','Hesaplama Detayları','63480')#">
							<div id="calc_detail">
								 <div class="form-group" id="detail_pay">
									<cf_flat_list id="table2">
										<cfquery name="get_emp_kidem_dahil_odeneks_row" dbtype="query">
											SELECT DISTINCT COMMENT_PAY FROM get_emp_kidem_dahil_odeneks
										</cfquery>
										<cfquery name="get_emp_kidem_dahil_odeneks_row_2" dbtype="query">
											SELECT DISTINCT SAL_MON,SAL_YEAR FROM get_emp_kidem_dahil_odeneks
										</cfquery>
										<cfoutput query="get_emp_kidem_dahil_odeneks">
											<cfif AMOUNT_2 EQ 0>
												<cfset "amount_#sal_mon#_#sal_year#_#replacelist(replacelist(comment_pay,' ,(,),%,.,-,/,*,+,"',',,,,,,,,'),"'",",")#" = AMOUNT>
											<cfelse>
												<cfset "amount_#sal_mon#_#sal_year#_#replacelist(replacelist(comment_pay,' ,(,),%,.,-,/,*,+,"',',,,,,,,,'),"'",",")#" = AMOUNT_2>
											</cfif>
										</cfoutput>
										<thead>
											<tr>
												<th colspan="<cfoutput>#get_emp_kidem_dahil_odeneks_row.recordcount+2#</cfoutput>"><cf_get_lang dictionary_id="53399.Ek Ödenekler"></th>
											</tr>
											<tr>
												<th width="50"><cf_get_lang dictionary_id="58455.Yıl"></th>
												<th width="50"><cf_get_lang dictionary_id="58724.Ay"></th>
												<cfoutput query="get_emp_kidem_dahil_odeneks_row">
													<th nowrap class="text-right">#comment_pay#</th>
												</cfoutput>
											</tr>
										</thead>
										<tbody>
											<cfoutput query="get_emp_kidem_dahil_odeneks_row_2">
												<tr>
													<td>#sal_year#</td>
													<td>#sal_mon#</td>
													<cfloop query="get_emp_kidem_dahil_odeneks_row">
														<td style="text-align:right">
															<cfif isdefined("amount_#get_emp_kidem_dahil_odeneks_row_2.sal_mon#_#get_emp_kidem_dahil_odeneks_row_2.sal_year#_#replacelist(replacelist(get_emp_kidem_dahil_odeneks_row.comment_pay,' ,(,),%,.,-,/,*,+,"',',,,,,,,,'),"'",",")#")>
																<cfif isdefined("toplam_#replacelist(replacelist(get_emp_kidem_dahil_odeneks_row.comment_pay,' ,(,),%,.,-,/,*,+,"',',,,,,,,,'),"'",",")#")>
																	<cfset "toplam_#replacelist(replacelist(get_emp_kidem_dahil_odeneks_row.comment_pay,' ,(,),%,.,-,/,*,+,"',',,,,,,,,'),"'",",")#" = evaluate("toplam_#replacelist(replacelist(get_emp_kidem_dahil_odeneks_row.comment_pay,' ,(,),%,.,-,/,*,+,"',',,,,,,,,'),"'",",")#") + evaluate("amount_#get_emp_kidem_dahil_odeneks_row_2.sal_mon#_#get_emp_kidem_dahil_odeneks_row_2.sal_year#_#replacelist(replacelist(get_emp_kidem_dahil_odeneks_row.comment_pay,' ,(,),%,.,-,/,*,+,"',',,,,,,,,'),"'",",")#")>
																<cfelse>
																	<cfset "toplam_#replacelist(replacelist(get_emp_kidem_dahil_odeneks_row.comment_pay,' ,(,),%,.,-,/,*,+,"',',,,,,,,,'),"'",",")#" = evaluate("amount_#get_emp_kidem_dahil_odeneks_row_2.sal_mon#_#get_emp_kidem_dahil_odeneks_row_2.sal_year#_#replacelist(replacelist(get_emp_kidem_dahil_odeneks_row.comment_pay,' ,(,),%,.,-,/,*,+,"',',,,,,,,,'),"'",",")#")>
																</cfif>
																#tlformat(evaluate("amount_#get_emp_kidem_dahil_odeneks_row_2.sal_mon#_#get_emp_kidem_dahil_odeneks_row_2.sal_year#_#replacelist(replacelist(get_emp_kidem_dahil_odeneks_row.comment_pay,' ,(,),%,.,-,/,*,+,"',',,,,,,,,'),"'",",")#"))#
															<cfelse>
																#tlformat(0)#
															</cfif>
														</td>
													</cfloop>
												</tr>
											</cfoutput>
											<tr class="txtbold">
												<td colspan="2"><cf_get_lang dictionary_id="58659.Toplam"></td>
												<cfoutput>
													<cfloop query="get_emp_kidem_dahil_odeneks_row">
														<td style="text-align:right">
															<cfif isdefined("toplam_#replacelist(replacelist(get_emp_kidem_dahil_odeneks_row.comment_pay,' ,(,),%,.,-,/,*,+,"',',,,,,,,,'),"'",",")#")>
																#tlformat(evaluate("toplam_#replacelist(replacelist(get_emp_kidem_dahil_odeneks_row.comment_pay,' ,(,),%,.,-,/,*,+,"',',,,,,,,,'),"'",",")#"))#
															<cfelse>
																#tlformat(0)#
															</cfif>
														</td>
													</cfloop>
												</cfoutput>
											</tr>
											<cfoutput>
												<tr class="txtbold">
													<td colspan="2"><cf_get_lang dictionary_id="59303.Ek Ödenek Ortalaması"></td>
													<td style="text-align:right">#tlformat(kidem_dahil_odenek)#</td>
												</tr>
												<tr class="txtbold">
													<td colspan="2"><cf_get_lang dictionary_id="59302.Özel Sigorta"></td>
													<td style="text-align:right">#tlformat(sigorta_toplam)#</td>
												</tr>
												<tr class="txtbold">
													<td colspan="2"><cf_get_lang dictionary_id="59301.Diğer Ödemeler"></td>
													<td style="text-align:right">#tlformat(ayni_yardim_total)#</td>
												</tr>
											</cfoutput>
										</tbody>
									</cf_flat_list>
								</div> 
							</div>
						 </cfif>
					</div>
					<cfscript>
						get_kesintis = createObject("component","V16.hr.ehesap.cfc.get_salaryparam_get");
						get_kesintis.dsn = dsn;
						get_kesintis_ = get_kesintis.get_salary_get(
						in_out_id : this_in_out_,
						term : attributes.sal_year,
						sal_mon_ : attributes.sal_mon
						);
					</cfscript>  
					<cfif get_kesintis_.recordcount>
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
							<cfinclude template="../display/dsp_salaryparam_get.cfm">
						</div>
					</cfif>
					<cfset from_in_out = 1>
					<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="5" sort="true">
						<cfinclude template="../../../objects/display/list_page_work_detail_inner.cfm">
					</div>
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="6" sort="true">
						<cf_seperator id="exclude" title="#getLang('','İzin ve Kıdeme Dahil Olmayan Dönemler','63479')#">
							<div id="exclude">
								<cf_flat_list>
									<thead>
										<tr>
											<th width="65"><cf_get_lang dictionary_id='57501.Başlangıç'></th>
											<th width="65"><cf_get_lang dictionary_id='57502.Bitiş'></th>
											<th><cf_get_lang dictionary_id='57490.Gün'></th>
											<th><cf_get_lang dictionary_id ='56630.Kıdem'></th>
											<th><cf_get_lang dictionary_id='58575.İzin'></th>
										</tr>
									</thead>
									<cfif len(get_progress_payment_out.START_DATE) and len(get_progress_payment_out.FINISH_DATE)>
										<cfset gun = datediff('d',get_progress_payment_out.START_DATE,get_progress_payment_out.FINISH_DATE)+1>
									<cfelseif len(get_progress_payment_out.START_DATE)>
										<cfset gun = datediff('d',get_progress_payment_out.START_DATE,now())+1>
									</cfif>
									<tbody>
										<cfif get_progress_payment_out.recordcount or get_offtime_delay.recordcount>
											<cfoutput query="get_progress_payment_out">
											<tr>
												<td>#dateformat(start_date,dateformat_style)#</td>
												<td><cfif len(finish_date)>#dateformat(finish_date,dateformat_style)#</cfif></td>
												<td><cfif len(PROGRESS_TIME)>#PROGRESS_TIME#<cfelse>#gun#</cfif></td>
												<td><cfif IS_KIDEM eq 1><cf_get_lang dictionary_id='57495.Evet'></cfif></td>
												<td><cfif IS_YEARLY eq 1><cf_get_lang dictionary_id='57495.Evet'></cfif></td>
											</tr>
											</cfoutput>
											<cfoutput query="get_offtime_delay">
											<tr>
												<td>#dateformat(STARTDATE,dateformat_style)#</td>
												<td><cfif len(finishdate)>#dateformat(finishdate,dateformat_style)#</cfif></td>
												<td>#datediff("d",STARTDATE,finishdate) + 1#</td>
												<td></td>
												<td><cf_get_lang dictionary_id='57495.Evet'></td>
												<!-- sil --><td></td><!-- sil -->
											</tr>
											</cfoutput>
										</cfif>
									</tbody>
								</cf_flat_list>
								<cfif get_progress_payment_out.recordcount eq 0>
									<div class="ui-info-bottom">
										<p><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</p>
									</div>
								</cfif>
							</div>
					</div>

				</cf_box_elements>
				<cf_box_footer>
					<cf_workcube_buttons is_upd="0" add_function="UnformatFields()" insert_alert="">
				</cf_box_footer>
			</cfform>
		</cf_box>
	</div>
	<cfsavecontent variable="messages"><cf_get_lang dictionary_id ='57535.Kaydetmek istediğinize emin misiniz!'></cfsavecontent>
	<script type="text/javascript">
		/* sabitler */
		ihbar_alt_sinir_1 = <cfoutput>#get_program_parameters.DENUNCIATION_1_LOW#</cfoutput>;
		ihbar_alt_sinir_2 = <cfoutput>#get_program_parameters.DENUNCIATION_2_LOW#</cfoutput>;
		ihbar_alt_sinir_3 = <cfoutput>#get_program_parameters.DENUNCIATION_3_LOW#</cfoutput>;
		ihbar_alt_sinir_4 = <cfoutput>#get_program_parameters.DENUNCIATION_4_LOW#</cfoutput>;
		ihbar_ust_sinir_1 = <cfoutput>#get_program_parameters.DENUNCIATION_1_HIGH#</cfoutput>;
		ihbar_ust_sinir_2 = <cfoutput>#get_program_parameters.DENUNCIATION_2_HIGH#</cfoutput>;
		ihbar_ust_sinir_3 = <cfoutput>#get_program_parameters.DENUNCIATION_3_HIGH#</cfoutput>;
		ihbar_ust_sinir_4 = <cfoutput>#get_program_parameters.DENUNCIATION_4_HIGH#</cfoutput>;
		ihbar_gun_1 = <cfoutput>#get_program_parameters.DENUNCIATION_1#</cfoutput>;
		ihbar_gun_2 = <cfoutput>#get_program_parameters.DENUNCIATION_2#</cfoutput>;
		ihbar_gun_3 = <cfoutput>#get_program_parameters.DENUNCIATION_3#</cfoutput>;
		ihbar_gun_4 = <cfoutput>#get_program_parameters.DENUNCIATION_4#</cfoutput>;
		paid_kidem_days = <cfoutput>#paid_kidem_days#</cfoutput>;
		paid_ihbar_days = <cfoutput>#paid_ihbar_days#</cfoutput>;
		izin_limit_1 = <cfoutput>#get_offtime_limits.limit_1#</cfoutput>;
		izin_limit_1_days = <cfoutput>#get_offtime_limits.limit_1_days#</cfoutput>;
		<cfif get_offtime_limits.definition_type eq 1>
			izin_def_type = 1;
			izin_limit_2 = <cfoutput>#get_offtime_limits.LIMIT_2#</cfoutput>;
			izin_limit_3 = <cfoutput>#get_offtime_limits.LIMIT_3#</cfoutput>;
			izin_limit_4 = <cfoutput>#get_offtime_limits.LIMIT_4#</cfoutput>;
			<cfif isdefined("get_offtime_limits.LIMIT_5") and len(get_offtime_limits.LIMIT_5)>
				izin_limit_5 = <cfoutput>#get_offtime_limits.LIMIT_5#</cfoutput>;
				izin_limit_5_days = <cfoutput>#get_offtime_limits.LIMIT_5_days#</cfoutput>;
			<cfelse>
				izin_limit_5 = <cfoutput>#get_offtime_limits.LIMIT_4#</cfoutput>;
				izin_limit_5_days = <cfoutput>#get_offtime_limits.LIMIT_4_days#</cfoutput>;
			</cfif>
	
			izin_limit_2_days = <cfoutput>#get_offtime_limits.LIMIT_2_days#</cfoutput>;
			izin_limit_3_days = <cfoutput>#get_offtime_limits.LIMIT_3_days#</cfoutput>;
			izin_limit_4_days = <cfoutput>#get_offtime_limits.LIMIT_4_days#</cfoutput>;
	
		<cfelse>
			izin_def_type = 0;
		</cfif>
		daily_salary = <cfoutput>#daily_salary#</cfoutput>;
		salary = <cfoutput>#salary#</cfoutput>;
		daily_baz = <cfoutput>#daily_baz#</cfoutput>;
		<cfif len(kidem_max)>
			kidem_max = <cfoutput>#kidem_max#</cfoutput>;
		<cfelse>
			kidem_max = 100000;
		</cfif>
		
		function UnformatFields()
		{
			
			if(confirm('<cfoutput>#messages#</cfoutput>')) 
			{			
				document.fire_2.ihbar_amount.value = filterNum(document.fire_2.ihbar_amount.value);
				document.fire_2.salary.value = filterNum(document.fire_2.salary.value);
				document.fire_2.kidem_amount.value = filterNum(document.fire_2.kidem_amount.value);
				document.fire_2.yillik_izin_amount.value = filterNum(document.fire_2.yillik_izin_amount.value);
				document.fire_2.baz_ucret.value = filterNum(document.fire_2.baz_ucret.value);
				<cfif isDefined("attributes.draggable")>
					loadPopupBox('fire_2' , <cfoutput>#attributes.modal_id#</cfoutput>);
					return false;
				</cfif>
			}
			else 
				return false;
		}
		
		function re_calc()
		{
			<cfif izin_baz_tutar neq ''>
				izin_baz_ucret = <cfoutput>#izin_baz_tutar#</cfoutput>;
			<cfelse>
				izin_baz_ucret = 0;	
			</cfif>
			if(fire_2.kullanilmayan_yillik_izin.value == '')
			{
				fire_2.kullanilmayan_yillik_izin.value = 0;
			}	
			/*öncelikle virgülleri at*/
			baz_ucret = filterNum(fire_2.baz_ucret.value);
			total_deneme_days = fire_2.total_deneme_days.value;
			total_ssk_days = fire_2.total_ssk_days.value;
			yil_ = Math.floor(total_ssk_days / 365);
			ay_ = Math.floor((total_ssk_days - (yil_ * 365))  / 30);
			gun_ = Math.floor((total_ssk_days - (yil_ * 365) - (ay_ * 30)));
			
			toplam_damga_12_aylik = <cfoutput>#toplam_damga_12_aylik#</cfoutput>;
			toplam_gelir_12_aylik = <cfoutput>#toplam_gelir_12_aylik#</cfoutput>;
		
			<cfif (not no_ihbar)>
			if (((total_ssk_days-total_deneme_days-paid_ihbar_days) > ihbar_alt_sinir_1) && ((total_ssk_days-total_deneme_days-paid_ihbar_days) <= ihbar_ust_sinir_1))
				fire_2.ihbar_days.value = ihbar_gun_1;
			else if (((total_ssk_days-total_deneme_days-paid_ihbar_days) > ihbar_alt_sinir_2) && ((total_ssk_days-total_deneme_days-paid_ihbar_days) <= ihbar_ust_sinir_2))
				fire_2.ihbar_days.value = ihbar_gun_2;
			else if (((total_ssk_days-total_deneme_days-paid_ihbar_days) > ihbar_alt_sinir_3) && ((total_ssk_days-total_deneme_days-paid_ihbar_days) <= ihbar_ust_sinir_3))
				fire_2.ihbar_days.value = ihbar_gun_3;
			else if (((total_ssk_days-total_deneme_days-paid_ihbar_days) > ihbar_alt_sinir_4) && ((total_ssk_days-total_deneme_days-paid_ihbar_days) <= ihbar_ust_sinir_4))
				fire_2.ihbar_days.value = ihbar_gun_4;
			</cfif>
		
			
			<cfif isdefined("ihbar_hesap") and (not no_ihbar)>
			/* ihbar tazminatı hesaplanır*/
				ihbar_amount = fire_2.ihbar_days.value * daily_baz;//daily_salary;
				fire_2.ihbar_amount.value = commaSplit(ihbar_amount);
			</cfif>
		
			fire_2.total_ssk_years.value = yil_;
			fire_2.total_ssk_months.value = ay_;
			fire_2.total_ssk_days_2.value = gun_;

			<cfif isdefined("kidem_hesap")>
			/*kıdem tazminatı hesaplanır*/
			if(fire_2.total_ssk_years.value >=1)
			{
				if (kidem_max <= baz_ucret)
					kidem_amount = (kidem_max * (total_ssk_days-paid_kidem_days)) / 365;
				else
					kidem_amount = (baz_ucret * (total_ssk_days-paid_kidem_days)) / 365;
				//kidem_amount = kidem_amount - toplam_damga_12_aylik;
				//writeoutput("total_ssk_days:#total_ssk_days#paid_kidem_days:#paid_kidem_days#");
				fire_2.kidem_amount.value = commaSplit(kidem_amount);
			}
			</cfif>
			
			hakkedilen_izin = 0;
			/* hakedilen yıllık izin gün*/
			if (izin_def_type == 1)
			{
				for (i = 1; i <= fire_2.total_ssk_years.value;i++)
				{
					if (i < izin_limit_1)
						hakkedilen_izin += izin_limit_1_days;
					else if (i < izin_limit_2)
						hakkedilen_izin += izin_limit_2_days;
					else if (i < izin_limit_3)
						hakkedilen_izin += izin_limit_3_days;
					else if (i < izin_limit_4)
						hakkedilen_izin += izin_limit_4_days;
					else if (i < izin_limit_5)
						hakkedilen_izin += izin_limit_5_days;
				}
			}
			else if (izin_def_type == 0)
			{
				izin_total_month_ = ay_ + (fire_2.total_ssk_years.value * 12);
				kontrol_limit = izin_limit_1;
				for (i = 1; i <= izin_total_month_; i=i+izin_limit_1)
				{	
					kontrol_limit = kontrol_limit + i;
					if(kontrol_limit < izin_total_month_)
					{hakkedilen_izin += izin_limit_1_days;}
				}
			}
			fire_2.hakkedilen_izin.value = hakkedilen_izin;
			fire_2.yillik_izin_amount.value = ((izin_baz_ucret/30) * fire_2.kullanilmayan_yillik_izin.value);
			
			/*virgülleri koy*/
			fire_2.yillik_izin_amount.value = commaSplit(fire_2.yillik_izin_amount.value);
		}
		fire_2.ihbar_amount.value = commaSplit(fire_2.ihbar_amount.value);
		fire_2.kidem_amount.value = commaSplit(fire_2.kidem_amount.value);
		fire_2.yillik_izin_amount.value = commaSplit(fire_2.yillik_izin_amount.value);
	</script>
	