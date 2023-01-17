<cfscript>
yillik_izin_net = 0;
yillik_izin_gelir_vergisi = 0;
yillik_izin_damga_vergisi = 0;
yillik_izin_isveren_toplam = 0;
yillik_izin_isci_toplam = 0;
yillik_izin_isveren_issizlik_toplam = 0;
yillik_izin_isci_issizlik_toplam = 0;

kidem_net = 0;
kidem_damga_vergisi = 0;

ihbar_net = 0;
ihbar_gelir_vergisi = 0;
ihbar_damga_vergisi = 0;
</cfscript>

<cfset total_ssk_days = 0>
<cfset total_deneme_days = 0>
<cfset kidem_dahil_odenek = 0>
<cfset no_kidem = 0>
<cfset no_ihbar = 0>
<cfset ihbar_hesap = 1>
<cfset kidem_hesap = 1>
<cfset attributes.startdate = START_DATE>
<cfset attributes.progress_time = 0>

<cfif len(FINISH_DATE)>
	<cfset attributes.finishdate = createodbcdatetime(FINISH_DATE)>
    <cfset attributes.ihbardate = createodbcdatetime(FINISH_DATE)>
<cfelse>
	<cfset attributes.finishdate = attributes.out_date>
    <cfset attributes.ihbardate = attributes.out_date>
</cfif>
<cfset attributes.group_id = PUANTAJ_GROUP_IDS>
<cfset attributes.branch_id = attributes.SSK_OFFICE>

<cfset cikis_start_date = kidem_date>

<cfinclude template="/V16/hr/ehesap/query/get_program_parameter.cfm">
<cfif GROSS_NET_ eq 1>
	<cfif salary_type_ eq 1>
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
			EP.SSK_OFFICE = '#this_ssk_office_#' AND
			EP.SSK_OFFICE_NO = '#this_ssk_no_#' AND
			EPR.EMPLOYEE_ID = #employee_id_# AND
			EPR.TOTAL_DAYS > 0 AND		
			EPR.PUANTAJ_ID = EP.PUANTAJ_ID AND
			(
				(
				EP.SAL_YEAR = #attributes.sal_year#
				AND
				EP.SAL_MON <= #attributes.sal_mon#
				)
				OR
				(
				EP.SAL_YEAR = #YEAR(cikis_start_date)#
				AND
				EP.SAL_MON >= #MONTH(cikis_start_date)#
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
			ISNULL(((EPR.TOTAL_SALARY - (EPR.TOTAL_PAY + EPR.TOTAL_PAY_TAX + EPR.TOTAL_PAY_SSK + EPR.TOTAL_PAY_SSK_TAX + EPR.EXT_SALARY)) / EPR.TOTAL_DAYS * 30),0) AS TOPLAM_KAZANC,
			ISNULL((SELECT SUM(AMOUNT) FROM EMPLOYEES_PUANTAJ_ROWS_EXT EPRE WHERE EPRE.EMPLOYEE_PUANTAJ_ID = EPR.EMPLOYEE_PUANTAJ_ID AND ISNULL(EPRE.IS_INCOME,0) = 1),0) AS TOPLAM_ODENEK,
			EPR.TOTAL_SALARY,
			EPR.TOTAL_PAY,
			EPR.TOTAL_PAY_TAX,
			EPR.TOTAL_PAY_SSK,
			EPR.TOTAL_PAY_SSK_TAX
		FROM
			EMPLOYEES_PUANTAJ_ROWS EPR,
			EMPLOYEES_PUANTAJ EP
		WHERE
			EP.SSK_OFFICE = '#this_ssk_office_#' AND
			EP.SSK_OFFICE_NO = '#this_ssk_no_#' AND
			EPR.EMPLOYEE_ID = #employee_id_# AND
			EPR.TOTAL_DAYS > 0 AND		
			EPR.PUANTAJ_ID = EP.PUANTAJ_ID AND
			(
				(
				EP.SAL_YEAR = #attributes.sal_year#
				AND
				EP.SAL_MON <= #attributes.sal_mon#
				)
				OR
				(
				EP.SAL_YEAR = #YEAR(cikis_start_date)#
				AND
				EP.SAL_MON >= #MONTH(cikis_start_date)#
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
				<cfif isdefined("get_hr_ssk_1.salary_type") and get_hr_ssk_1.salary_type eq 1>
					(M#attributes.sal_mon# * 30) AS TOPLAM_KAZANC
				<cfelseif isdefined("get_hr_ssk_1.salary_type") and get_hr_ssk_1.salary_type eq 0>
					(M#attributes.sal_mon# * 225) AS TOPLAM_KAZANC
				<cfelse>
					M#attributes.sal_mon# AS TOPLAM_KAZANC
				</cfif>
			FROM
				EMPLOYEES_SALARY
			WHERE
				PERIOD_YEAR = #attributes.sal_year# AND
				IN_OUT_ID = #this_in_out_#
		</cfquery>
		<cfset izin_baz_tutar = get_last_maas.TOPLAM_KAZANC>
	<cfelseif get_son_maas.recordcount>
		<cfset izin_baz_tutar = get_son_maas.TOPLAM_KAZANC><!---  + get_son_maas.TOPLAM_ODENEK 22062017 nagihan istegi ile kalkti--->
	<cfelse>
		<cfset izin_baz_tutar = 0>
	</cfif>
<cfelse>
	<cfquery name="get_son_maas" datasource="#dsn#" maxrows="1">
		SELECT
			<cfif salary_type_ eq 1>
				(M#attributes.sal_mon# * 30) AS TOPLAM_KAZANC
			<cfelseif salary_type_ eq 0>
				(M#attributes.sal_mon# * 225) AS TOPLAM_KAZANC
			<cfelse>
				M#attributes.sal_mon# AS TOPLAM_KAZANC
			</cfif>
			,0 AS TOPLAM_ODENEK
		FROM
			EMPLOYEES_SALARY
		WHERE
			PERIOD_YEAR = #attributes.sal_year# AND
			IN_OUT_ID = #this_in_out_#
	</cfquery>
	<cfset izin_baz_tutar = get_son_maas.TOPLAM_KAZANC>
</cfif>

<cfquery name="GET_SIGORTA" datasource="#dsn#" maxrows="1">
	SELECT
		(VERGI_ISTISNA_SSK + VERGI_ISTISNA_VERGI + VERGI_ISTISNA_DAMGA) AS TOPLAM_SIGORTA
	FROM
		EMPLOYEES_PUANTAJ_ROWS EPR,
		EMPLOYEES_PUANTAJ EP
	WHERE
		EPR.EMPLOYEE_ID = #employee_id_# AND
		EPR.TOTAL_DAYS > 0 AND		
		EPR.PUANTAJ_ID = EP.PUANTAJ_ID AND
		(
			(
			EP.SAL_YEAR = #attributes.sal_year#
			AND
			EP.SAL_MON <= #attributes.sal_mon#
			)
			OR
			(
			EP.SAL_YEAR = #YEAR(cikis_start_date)#
			AND
			EP.SAL_MON >= #MONTH(cikis_start_date)#
			)
			OR
			(
			EP.SAL_YEAR < #attributes.sal_year#
			)
		)
	ORDER BY 
		EP.SAL_YEAR DESC,
		EP.SAL_MON DESC
</cfquery>


<cfset ayni_yardim_total = 0>
<cfquery name="get_ayni_yardims" datasource="#dsn#">
	SELECT
		SUM(AMOUNT_PAY) AS AYNI_TOTAL
	FROM
		SALARYPARAM_PAY
	WHERE
		IS_AYNI_YARDIM = 1 AND
		START_SAL_MON <= #attributes.sal_mon# AND
		END_SAL_MON >= #attributes.sal_mon# AND
		TERM = #attributes.sal_year# AND
		IN_OUT_ID = #this_in_out_#
</cfquery>
<cfif get_ayni_yardims.recordcount and len(get_ayni_yardims.AYNI_TOTAL)>
	<cfset ayni_yardim_total = get_ayni_yardims.AYNI_TOTAL>
</cfif>

<cfquery name="get_emp_in_outs" datasource="#dsn#">
	SELECT
		*
	FROM
		EMPLOYEES_IN_OUT
	WHERE
		EMPLOYEE_ID = #employee_id_#
		AND
		TOTAL_SSK_DAYS <> 0
		AND
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
			AND EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = #employee_id_#
			AND EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS_EXT.EMPLOYEE_PUANTAJ_ID
			AND EMPLOYEES_PUANTAJ_ROWS_EXT.IS_KIDEM = 1
			AND EMPLOYEES_PUANTAJ_ROWS_EXT.EXT_TYPE = 0
			AND ISNULL(EMPLOYEES_PUANTAJ_ROWS_EXT.IS_INCOME,0) = 0
			AND
			(
				(
				EMPLOYEES_PUANTAJ.SAL_YEAR = #year(attributes.finishdate)# AND
				EMPLOYEES_PUANTAJ.SAL_MON <= #month(attributes.finishdate)#
				)				
				OR
				(
				EMPLOYEES_PUANTAJ.SAL_YEAR < #year(attributes.finishdate)# AND
				EMPLOYEES_PUANTAJ.SAL_YEAR > #year(attributes.finishdate)-2# AND
       			EMPLOYEES_PUANTAJ.SAL_MON > #month(attributes.finishdate)#
				)
			)
		ORDER BY
			EMPLOYEES_PUANTAJ.SAL_YEAR DESC,
			EMPLOYEES_PUANTAJ.SAL_MON DESC
	</cfquery>


	<cfif get_emp_kidem_dahil_odeneks.recordcount>
		<!--- kıdem toplamı gün yüzde dikkate alınarak toplanacak ortalaması alınacak --->
        <cfset TEMP_AVG = 0>
        <cfoutput query="get_emp_kidem_dahil_odeneks">
            <cfif AMOUNT_2 EQ 0><!--- ARTI --->
                <cfset TEMP_AVG = TEMP_AVG + AMOUNT>
            <cfelse><!--- YÜZDE --->
                <cfset TEMP_AVG = TEMP_AVG + AMOUNT_2>
            </cfif>
        </cfoutput>
        
        <cfset datediff_ = datediff('d',attributes.startdate,attributes.finishdate)/30>
        <cfif datediff_ eq 0><cfset datediff_ = 1></cfif>
        <cfif datediff_ mod 30 neq 0>
            <cfset datediff_ = Int(datediff_)+1>
        </cfif>
        
        <cfif year(now()) eq 2016>
            <cfset datediff_ = month(now())>
        </cfif>
        
        <cfquery name="get_ay_sayisi" dbtype="query">
        	SELECT SAL_MON,SAL_YEAR FROM get_emp_kidem_dahil_odeneks GROUP BY SAL_MON,SAL_YEAR
        </cfquery>
        <cfset datediff_ = get_ay_sayisi.recordcount>
        
        <cfif datediff_ gt 12><cfset datediff_ = 12></cfif>
        <cfset kidem_dahil_odenek = TEMP_AVG / datediff_>
    </cfif>
    
    <cfquery name="get_salaryparam_pay" datasource="#dsn#">
    	SELECT 
        	SUM(AMOUNT_PAY) AS TOTAL_EK
        FROM 
        	SALARYPARAM_PAY 
       	WHERE 
        	SHOW = 0 AND 
            IS_KIDEM = 1 AND
            EMPLOYEE_ID = #employee_id_# AND 
            START_SAL_MON = #attributes.sal_mon# AND 
            END_SAL_MON = #attributes.sal_mon# AND 
            TERM = #attributes.sal_year#
    </cfquery>
    <cfif get_salaryparam_pay.recordcount and len(get_salaryparam_pay.TOTAL_EK)>
    	   <cfset kidem_dahil_odenek = kidem_dahil_odenek + get_salaryparam_pay.TOTAL_EK> 	
    </cfif>
</cfif>



<!---
	<cfset izin_baz_tutar = izin_baz_tutar + kidem_dahil_odenek><!--- 18022017 nagihan icin eklendi --->
--->

<cfquery name="get_emp_offtimes" datasource="#dsn#">
	SELECT
		SUM(DATEDIFF(DAY,OFFTIME.STARTDATE, OFFTIME.FINISHDATE)) + 1 AS TOPLAM_GUN
	FROM
		OFFTIME,
		SETUP_OFFTIME
	WHERE
	(
	(OFFTIME.STARTDATE >= #CREATEODBCDATETIME(cikis_start_date)# AND OFFTIME.STARTDATE <= #CREATEODBCDATETIME(attributes.finishdate)#) OR
	(OFFTIME.FINISHDATE >= #CREATEODBCDATETIME(cikis_start_date)# AND OFFTIME.STARTDATE <= #CREATEODBCDATETIME(attributes.finishdate)#)
	) AND	
	OFFTIME.EMPLOYEE_ID = #employee_id_# AND
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
		EMPLOYEE_ID = #employee_id_#
</cfquery>

<cfscript>
if (isnumeric(get_emp_offtimes.TOPLAM_GUN) and this_duty_ neq 6)
	toplam_izin = get_emp_offtimes.TOPLAM_GUN;
else
	toplam_izin = 0;
	

if(get_program_parameters.FINISH_DATE_COUNT_TYPE eq 1) //çıkış günü hesaplama şekli (yıl/ay/gün)
	{
		//cikis_start_ = dateadd('d',attributes.progress_time,cikis_start_date); //kıdemden sayılmayacak gun degerininde dusulerek hesaplanması icin eklendi. SG20130621
		cikis_start_ = cikis_start_date;
		if (isdefined("attributes.ihbardate") and len(attributes.ihbardate))
			total_ssk_years = datediff("yyyy",cikis_start_,attributes.ihbardate);
		else
			total_ssk_years = datediff("yyyy",cikis_start_,attributes.finishdate);
		
		
		if(total_ssk_years gte 1)
		{
		if (isdefined("attributes.ihbardate") and len(attributes.ihbardate))
			total_ssk_months = datediff("m",cikis_start_,date_add("yyyy",-total_ssk_years,attributes.ihbardate));
		else
			total_ssk_months = datediff("m",cikis_start_,date_add("yyyy",-total_ssk_years,attributes.finishdate));
		}
		else
		{
		if (isdefined("attributes.ihbardate") and len(attributes.ihbardate))
			total_ssk_months = datediff("m",cikis_start_,attributes.ihbardate);
		else
			total_ssk_months = datediff("m",cikis_start_,attributes.finishdate);	
		}
		
		
		if (isdefined("attributes.ihbardate") and len(attributes.ihbardate))
			{
			new_date = attributes.ihbardate;
			if(total_ssk_years gte 1) new_date = date_add("yyyy",-total_ssk_years,attributes.ihbardate);
			if(total_ssk_months gte 1) new_date = date_add("m",-total_ssk_months,new_date);
			total_ssk_days_2 = datediff("d",cikis_start_,new_date);
			}
		else
			{
			new_date = attributes.finishdate; 
			if(total_ssk_years gte 1) new_date = date_add("yyyy",-total_ssk_years,attributes.finishdate);
			if(total_ssk_months gte 1) new_date = date_add("m",-total_ssk_months,new_date);
			total_ssk_days_2 = datediff("d",cikis_start_,new_date);
			}
			
		if(total_ssk_days eq 0 and datediff("d",attributes.finishdate,cikis_start_) eq 0)
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
		cikis_start_ = dateadd('d',attributes.progress_time,cikis_start_date); //kıdemden sayılmayacak gun degerininde dusulerek hesaplanması icin eklendi. SG20130705
		if (isdefined("attributes.ihbardate") and len(attributes.ihbardate))
			new_date = attributes.ihbardate;
		else
			new_date = attributes.finishdate;
			
		total_ssk_days = datediff("d",cikis_start_date,new_date) + 1;
		
		
		if(total_ssk_days eq 0 and datediff("d",attributes.finishdate,cikis_start_) eq 0)
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
else if(SURELI_IS_AKDI EQ 1 and (not len(get_program_parameters.IS_SURELI_IS_AKDI_OFF) or get_program_parameters.IS_SURELI_IS_AKDI_OFF eq 0))
	no_ihbar = 1;
else if(SURELI_IS_AKDI EQ 1 and get_program_parameters.IS_SURELI_IS_AKDI_OFF eq 1 and len(SURELI_IS_FINISHDATE) and datediff("d",SURELI_IS_FINISHDATE,attributes.finishdate) lt 1)
	no_ihbar = 1;
else
	no_ihbar = 0;
</cfscript>

<cfquery name="get_offtime" datasource="#dsn#">
	SELECT 
		OFFTIME.*,
		SETUP_OFFTIME.OFFTIMECAT_ID,
		SETUP_OFFTIME.OFFTIMECAT
	FROM 
		OFFTIME,
		SETUP_OFFTIME
	WHERE
		SETUP_OFFTIME.OFFTIMECAT_ID=OFFTIME.OFFTIMECAT_ID AND
		OFFTIME.IS_PUANTAJ_OFF = 0 AND
		OFFTIME.VALID = 1 AND
		SETUP_OFFTIME.IS_PAID = 1 AND
		SETUP_OFFTIME.IS_YEARLY = 1	AND
		EMPLOYEE_ID=#employee_id_#		
	ORDER BY
		STARTDATE DESC
</cfquery>

<cfquery name="get_emp" datasource="#dsn#">
	SELECT 
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		E.KIDEM_DATE,
		E.IZIN_DATE,
		E.IZIN_DAYS,
		EI.BIRTH_DATE,
		E.GROUP_STARTDATE
	FROM
		EMPLOYEES E,
		EMPLOYEES_IDENTY EI
	WHERE 
		E.EMPLOYEE_ID=#employee_id_# AND
		EI.EMPLOYEE_ID=#employee_id_#
</cfquery>
<cfif len(get_emp.IZIN_DAYS)>
	<cfset old_izin_days_ = get_emp.IZIN_DAYS>
<cfelse>
	<cfset old_izin_days_ = 0>
</cfif>

<cfset izin_sayilmayan = 0>
<cfset genel_izin_toplam = 0>
<cfif get_offtime.recordcount>
	<cfoutput query="get_offtime">
        <cfquery name="get_pre_offtime" dbtype="query">
            SELECT
                STARTDATE
            FROM
                get_offtime
            WHERE
                STARTDATE < '#get_offtime.startdate#'
            ORDER BY 
                STARTDATE DESC
        </cfquery>
        <cfif len(get_emp.IZIN_DATE)>
            <cfset kidem = datediff('d',get_emp.IZIN_DATE,get_offtime.startdate)>
        <cfelse>
            <cfset kidem=0>
        </cfif>
        <cfset kidem_yil=kidem/365>
    
        <cfquery name="get_offtime_cat" datasource="#dsn#" maxrows="1">
            SELECT * FROM SETUP_OFFTIME_LIMIT WHERE STARTDATE <= '#get_offtime.startdate#' AND FINISHDATE >= '#get_offtime.startdate#'
        </cfquery>
        <cfif get_offtime_cat.recordcount and len(get_offtime_cat.SATURDAY_ON)>
            <cfset saturday_on = get_offtime_cat.SATURDAY_ON>
        <cfelse>
            <cfset saturday_on = 1>
        </cfif>
    
        <cfscript>
            temporary_sunday_total = 0;
            temporary_offday_total = 0;
            total_izin = datediff('d',get_offtime.startdate,get_offtime.finishdate)+1;
            izin_startdate = date_add("h", session.ep.time_zone, get_offtime.startdate); 
            izin_finishdate = date_add("h", session.ep.time_zone, get_offtime.finishdate);
                
            for (mck = 0; mck lt total_izin; mck = mck + 1)
            {
                temp_izin_gunu = date_add("d",mck,izin_startdate);
                daycode = '#dateformat(temp_izin_gunu,'dd/mm/yyyy')#';
                if (dayofweek(temp_izin_gunu) eq 1)
                    temporary_sunday_total = temporary_sunday_total + 1;
                else if (dayofweek(temp_izin_gunu) eq 7 and saturday_on eq 0)
                    temporary_sunday_total = temporary_sunday_total + 1;
                else if(listfindnocase(offday_list,'#daycode#'))
                    temporary_offday_total = temporary_offday_total + 1;
            }
            
            //writeoutput('#datediff("d",izin_startdate,get_emp.IZIN_DATE)#');
            if(len(get_emp.IZIN_DATE) and datediff("d",izin_startdate,get_emp.IZIN_DATE) gt 0)
            {
                    genel_izin_toplam = genel_izin_toplam;
            }
            else	
                genel_izin_toplam = genel_izin_toplam + total_izin - temporary_sunday_total - temporary_offday_total;
        </cfscript>
        <cfset izin_sayilmayan = izin_sayilmayan + temporary_sunday_total + temporary_offday_total>
    </cfoutput>
</cfif>

<cfscript>
tck = 0;
toplam_hakedilen_izin = 0;
my_giris_date = get_emp.IZIN_DATE;
if(len(my_giris_date))
{
	flag = true;
	baslangic_tarih_ = my_giris_date;
	while(flag)
	{
	bitis_tarihi_ = createodbcdatetime(date_add("yyyy",1,baslangic_tarih_));
	baslangic_tarih_ = createodbcdatetime(baslangic_tarih_);
	get_bos_zaman_ = cfquery(Datasource="#dsn#",dbtype="query",sqlstring="SELECT * FROM get_progress_payment_outs WHERE (START_DATE <= #baslangic_tarih_# AND FINISH_DATE >= #baslangic_tarih_#) OR (START_DATE >= #baslangic_tarih_# AND FINISH_DATE <= #bitis_tarihi_#) OR ((START_DATE BETWEEN #baslangic_tarih_# AND #bitis_tarihi_#) AND FINISH_DATE >= #bitis_tarihi_#)");	

	if(get_bos_zaman_.recordcount eq 0)
		{
		tck = tck + 1; 
		kontrol_date = date_add("yyyy",tck-1,baslangic_tarih_);
		get_offtime_limit=cfquery(datasource="#dsn#",sqlstring="SELECT * FROM SETUP_OFFTIME_LIMIT WHERE STARTDATE <= #baslangic_tarih_# AND FINISHDATE >= #baslangic_tarih_#");	
			if(get_offtime_limit.recordcount)
				{
				if(tck lte get_offtime_limit.limit_1)
					eklenecek = get_offtime_limit.LIMIT_1_DAYS;
				else if(tck gt get_offtime_limit.limit_1 and tck lte get_offtime_limit.limit_2)
					eklenecek = get_offtime_limit.LIMIT_2_DAYS;
				else if(tck gt get_offtime_limit.limit_2 and tck lte get_offtime_limit.limit_3)
					eklenecek = get_offtime_limit.LIMIT_3_DAYS;
				else 
					eklenecek = get_offtime_limit.LIMIT_4_DAYS;
					
				if(len(get_emp.BIRTH_DATE) and eklenecek lt get_offtime_limit.MIN_MAX_DAYS and (datediff("yyyy",get_emp.BIRTH_DATE,kontrol_date) lt get_offtime_limit.MIN_YEARS or datediff("yyyy",get_emp.BIRTH_DATE,kontrol_date) gt get_offtime_limit.MAX_YEARS) )
					eklenecek = get_offtime_limit.MIN_MAX_DAYS;
				if(tck neq 1 and eklenecek neq 0) 
					{
					toplam_hakedilen_izin = toplam_hakedilen_izin + eklenecek;
					}
				}
			else
				{
				}
		
		}
	else
		{												
			eklenecek_gun = 0;
			for(izd = 1; izd lte get_bos_zaman_.recordcount; izd=izd+1)
				{
				if(datediff("d",get_bos_zaman_.start_date[izd],baslangic_tarih_) gt 0)
					{
					fark_ = datediff("d",baslangic_tarih_,get_bos_zaman_.finish_date[izd]);
					}
				else if(datediff("d",get_bos_zaman_.start_date[izd],baslangic_tarih_) lte 0)
					{
					fark_ = datediff("d",get_bos_zaman_.start_date[izd],get_bos_zaman_.finish_date[izd]);
					}
				eklenecek_gun = eklenecek_gun + fark_;
				}
			bitis_tarihi_ = date_add("d",eklenecek_gun,bitis_tarihi_);
				
				tck = tck + 1; 
				kontrol_date = date_add("yyyy",tck-1,baslangic_tarih_);
				get_offtime_limit=cfquery(datasource="#dsn#",sqlstring="SELECT * FROM SETUP_OFFTIME_LIMIT WHERE STARTDATE <= #bitis_tarihi_# AND FINISHDATE >= #bitis_tarihi_#");	
					if(get_offtime_limit.recordcount)
						{
						if(tck lte get_offtime_limit.limit_1)
							eklenecek = get_offtime_limit.LIMIT_1_DAYS;
						else if(tck gt get_offtime_limit.limit_1 and tck lte get_offtime_limit.limit_2)
							eklenecek = get_offtime_limit.LIMIT_2_DAYS;
						else if(tck gt get_offtime_limit.limit_2 and tck lte get_offtime_limit.limit_3)
							eklenecek = get_offtime_limit.LIMIT_3_DAYS;
						else 
							eklenecek = get_offtime_limit.LIMIT_4_DAYS;
							
						if(len(get_emp.BIRTH_DATE) and eklenecek lt get_offtime_limit.MIN_MAX_DAYS and (datediff("yyyy",get_emp.BIRTH_DATE,kontrol_date) lt get_offtime_limit.MIN_YEARS or datediff("yyyy",get_emp.BIRTH_DATE,kontrol_date) gt get_offtime_limit.MAX_YEARS) )
							eklenecek = get_offtime_limit.MIN_MAX_DAYS;
						if(tck neq 1 and eklenecek neq 0) 
							{
							toplam_hakedilen_izin = toplam_hakedilen_izin + eklenecek;
							}
						}
					else
						{
						}
		}	
	ilk_tarih_ = baslangic_tarih_;
	baslangic_tarih_ = bitis_tarihi_;
	bitis_tarihi_ = date_add("yyyy",1,bitis_tarihi_);
	if(datediff("yyyy",bitis_tarihi_,now()) lt 0)				
		{
		flag = false;
		}
	}
}
</cfscript>


<cfscript>
	paid_kidem_days = 0;
	paid_ihbar_days = 0;
	ihbar_days = 0;
	baz_ucret = 0;
	last_limit_days = 0;
	ihbar_amount = 0;
	kidem_amount = 0;
	kidem_max = get_seniority_comp_max.seniority_compansation_max;
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
		
	/*
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
	*/
	baz_ucret = salary + kidem_dahil_odenek + yemek_tutar;
	
	sigorta_toplam = 0;
	if(GET_SIGORTA.recordcount and GET_SIGORTA.TOPLAM_SIGORTA gt 0)
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
		ihbar_fark_ = datediff("d",attributes.ihbardate,attributes.finishdate);
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
		//writeoutput('cikis_start_date:#cikis_start_date# ihbar_days:#ihbar_days#-  #total_ssk_days# #attributes.ihbardate# #attributes.finishdate# #(total_ssk_days-paid_ihbar_days)# -- #daily_baz# - #ihbar_days# - #daily_baz * ihbar_days#');
		
		}
	
	if (not no_kidem )
		{
		if (kidem_max lte baz_ucret)
			{
			kidem_amount = (kidem_max * (total_ssk_days-paid_kidem_days)) / 365;
			}
		else
			kidem_amount = (baz_ucret * (total_ssk_days-paid_kidem_days)) / 365;
		}
		//writeoutput("total_ssk_days:#total_ssk_days#paid_kidem_days:#paid_kidem_days#");
	//damga vergisi cikartilmaz kidem_amount = kidem_amount - toplam_damga_12_aylik;
	
	kullanilan_yillik_izin = genel_izin_toplam;
	
	if(len(izin_baz_tutar))
		yillik_izin_amount = (izin_baz_tutar / 30) * (toplam_hakedilen_izin - genel_izin_toplam - old_izin_days_);
	else
		yillik_izin_amount = 0;
</cfscript>