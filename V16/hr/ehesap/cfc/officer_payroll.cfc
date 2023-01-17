<!---
    File: V16\hr\ehesap\cfc\officer_payroll.cfc
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 12.06.2021
    Description: Memur Bordrosu Fonksiyonları
        
    History:
        
    To Do:

--->
 
<cfcomponent displayname="OFFICER_PAYROLL_JOB">

    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'>
    <cfset dsn_alias = application.systemParam.systemParam().dsn>
    <cfset dsn2_alias = "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cfset dsn3_alias = '#dsn#_#session.ep.company_id#'>
    <cfset dir_seperator = application.systemParam.systemParam().dir_seperator>
    <cfset fusebox.use_period = application.systemParam.systemParam().fusebox.use_period>
    <cfset fusebox.dynamic_hierarchy = application.systemParam.systemParam().fusebox.dynamic_hierarchy>
    <cfset dateformat_style = session.ep.dateformat_style>

    <!--- Memur Puantaj Hesap Giriş --->
    <cffunction name="officer_payroll" access="public" returntype="any">

        <!--- Yabancı Dil Component --->
        <cfset get_component_lang = createObject("component","V16.settings.cfc.language_allowance")>

        <cfset salary = 0><!--- Maaş --->
        <cfset additional_indicators = 0><!--- Ek Gösterge --->
        <cfset severance_pension = 0> <!--- Kıdem Aylığı --->
        <cfset business_risk = 0> <!--- İş Güç /İş Riski --->
        <cfset university_allowance = 0 > <!--- Üniversite Ödeneği --->
        <cfset private_service_compensation = 0><!--- Özel Hizmet Tazminatı --->
        <cfset language_allowance = 0> <!--- Yabancı Dil Tazminatı --->
        <cfset executive_indicator_compensation = 0><!--- Makam Tazminatı --->
        <cfset administrative_compensation = 0> <!--- Görev Tazminatı --->
        <cfset administrative_duty_allowance = 0><!--- İdari Görev Ödeneği --->
        <cfset education_allowance = 0><!--- Eğitim Ödeneği --->
        <cfset family_assistance = 0><!--- Aile Yardımı --->
        <cfset child_assistance = 0><!--- Çocuk Yardımı --->
        <cfset extra_pay = 0><!--- Ek Ödeme --->
        <cfset promotion_difference = 0><!--- Terfi Farkı--->
        <cfset child_count = 0><!--- Terfi Farkı--->
        <cfset total_salary = 0><!--- Toplam--->
        

        <cfif not(len(get_hr_ssk.grade) and len(get_hr_ssk.step))>
            <cfsavecontent variable="grade_step"><cf_get_lang dictionary_id='63026.Çalışanın Memur Tanımlarını Yapınız'> (<cf_get_lang dictionary_id='37566.Derece / Kademe'>) !</cfsavecontent>
            <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: grade_step , in_out_id: attributes.in_out_id) /> 
        <cfelseif not len(get_hr_ssk.additional_score)>
            <cfsavecontent variable="grade_step"><cf_get_lang dictionary_id='63026.Çalışanın Memur Tanımlarını Yapınız'> (<cf_get_lang dictionary_id='62877.Ek Gösterge Puanı'>) !</cfsavecontent>
            <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: grade_step , in_out_id: attributes.in_out_id) /> 
        <cfelseif not(len(get_hr_ssk.perquisite_score))>
            <cfsavecontent variable="grade_step"><cf_get_lang dictionary_id='63026.Çalışanın Memur Tanımlarını Yapınız'> (<cf_get_lang dictionary_id='62878.Yan Ödeme Puanı'>) !</cfsavecontent>
            <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: grade_step , in_out_id: attributes.in_out_id) /> 
        <cfelseif not(len(get_hr_ssk.university_allowance))>
            <cfsavecontent variable="grade_step"><cf_get_lang dictionary_id='63026.Çalışanın Memur Tanımlarını Yapınız'> (<cf_get_lang dictionary_id='62884.Ünversite Ödeneği'> - <cf_get_lang dictionary_id='58456.Oran'> %) !</cfsavecontent>
            <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: grade_step , in_out_id: attributes.in_out_id) />  
        <cfelseif not(len(get_hr_ssk.private_service_score))>
            <cfsavecontent variable="grade_step"><cf_get_lang dictionary_id='63026.Çalışanın Memur Tanımlarını Yapınız'> (<cf_get_lang dictionary_id='62881.Özel Hizmet Tazminatı Gösterge Puanı'>) !</cfsavecontent>
            <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: grade_step , in_out_id: attributes.in_out_id) />  
        <cfelseif not(len(get_hr_ssk.executive_indicator_score))>
            <cfsavecontent variable="grade_step"><cf_get_lang dictionary_id='63026.Çalışanın Memur Tanımlarını Yapınız'> (<cf_get_lang dictionary_id='62879.Makam Tazminatı Gösterge Puanı'>) !</cfsavecontent>
            <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: grade_step , in_out_id: attributes.in_out_id) />  
        <cfelseif not(len(get_hr_ssk.administrative_indicator_score))>
            <cfsavecontent variable="grade_step"><cf_get_lang dictionary_id='63026.Çalışanın Memur Tanımlarını Yapınız'> (<cf_get_lang dictionary_id='62880.Görev Tazminatı Gösterge Puanı'>) !</cfsavecontent>
            <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: grade_step , in_out_id: attributes.in_out_id) />  
        <cfelseif not(len(get_hr_ssk.administrative_function_allowance))>
            <cfsavecontent variable="grade_step"><cf_get_lang dictionary_id='63026.Çalışanın Memur Tanımlarını Yapınız'> (<cf_get_lang dictionary_id='62882.İdari Görev Ödeneği'>) !</cfsavecontent>
            <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: grade_step , in_out_id: attributes.in_out_id) />  
        </cfif>

        <!--- Ayın ilk ve son günü --->
        <cfset start_month = CreateDateTime(attributes.sal_year,attributes.sal_mon,1,0,0,0)>
	    <cfset end_month = CreateDateTime(attributes.sal_year,attributes.sal_mon,daysinmonth(createdate(attributes.sal_year,attributes.sal_mon,1)),0,0,0)>
        
        <!--- Ücret Kuralları Memuriyet Gösterge Tablosu --->
        <cfset cmp_grade_step_params = createObject('component','V16.hr.ehesap.cfc.grade_step_params')>
        <cfset get_grade_step = cmp_grade_step_params.GET_EMPLOYEES_GRADE_STEP_PARAMS(
            start_month : start_month,
            end_month : end_month,
            grade : get_hr_ssk.grade,
            step : get_hr_ssk.step
        )>

        <!--- Memur Gösterge Tablosu Kontrolü --->
        <cfif get_grade_step.recordcount eq 0>
            <cfsavecontent variable="table_error"><cf_get_lang dictionary_id='62929.Girilen Tarihler Arasında Memur Gösterge Tablosu Bulunmaktadır!'></cfsavecontent>
            <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: table_error , in_out_id: attributes.in_out_id) />   
        <cfelse>
            <cfset indicator_score = evaluate("get_grade_step.step_#get_hr_ssk.step#")><!--- Gösterge Puanı --->
        </cfif>

        <!--- Katsayı Tablosu --->
        <cfset get_factor = this.get_factor_definition(
            start_month : start_month,
            end_month : end_month
        )>

        <!--- Katsayı Tablosu Kontrol --->
        <cfif get_factor.recordcount eq 0>
            <cfsavecontent variable="factor_error"><cf_get_lang dictionary_id='63027.Belirtilen Tarihler Arasında Katsayı Tanımı Bulunmamaktadır!'></cfsavecontent>
            <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: factor_error , in_out_id: attributes.in_out_id) />   
        <cfelse>
            <cfset factor = get_factor.salary_factor><!--- Aylık Katsayı --->
            <!--- Yan ödeme katsayısı kontrol --->
            <cfif not len(get_factor.benefit_factor)>
                <cfsavecontent variable="factor_error"><cf_get_lang dictionary_id='63027.Belirtilen Tarihler Arasında Katsayı Tanımı Bulunmamaktadır!'>(<cf_get_lang dictionary_id='59315.Yan Ödeme Katsayısı'>)</cfsavecontent>
                <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: factor_error , in_out_id: attributes.in_out_id) />   
            <cfelse>
                <cfset benefit_factor = get_factor.benefit_factor>
            </cfif>
            <!--- Aile Yardımı Puanı --->
            <cfif not len(get_factor.family_allowance_point)>
                <cfsavecontent variable="factor_error"><cf_get_lang dictionary_id='63027.Belirtilen Tarihler Arasında Katsayı Tanımı Bulunmamaktadır!'>(<cf_get_lang dictionary_id='62934.Aile Yardımı Puanı'>)</cfsavecontent>
                <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: factor_error , in_out_id: attributes.in_out_id) />   
            <cfelse>
                <cfset family_allowance_point = get_factor.family_allowance_point>
            </cfif>
            <!--- Çocuk Yardımı Puanı --->
            <cfif not (len(get_factor.child_benefit_first) or len(get_factor.child_benefit_second))>
                <cfsavecontent variable="factor_error"><cf_get_lang dictionary_id='63027.Belirtilen Tarihler Arasında Katsayı Tanımı Bulunmamaktadır!'>(<cf_get_lang dictionary_id='62935.Çocuk Yardımı Puanı'>)</cfsavecontent>
                <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: factor_error , in_out_id: attributes.in_out_id) />   
            </cfif>            
        </cfif>

        <!--- Tipi Maaş ise --->
        <cfif attributes.statue_type eq 1>
            <!--- Maaş Puantajı Hesap Fonksiyonu --->
            <cfset get_officer_payroll_wage = officer_payroll_wage()>
        </cfif>
        <!--- Insert Fonksiyonu --->
        <!--- <cfset add_officer_payroll = add_officer_payroll()> --->
    </cffunction>

    <!--- Maaş Puantajı --->
    <cffunction name="officer_payroll_wage" access="public" returntype="any">

        <!--- Maaş --->
        <cfset salary = indicator_score * factor><!--- Maaş (Maaş Göstergesi * Katsayı )--->
        <cfset additional_indicators = get_hr_ssk.additional_score * factor><!--- Ek Gösterge (Ekgösterge puanı * katsayı ) --->
        <cfset worked_year = dateDiff('yyyy',get_hr_ssk.KIDEM_DATE,now())><!--- Çalışılan yıl --->
        <cfset severance_pension = worked_year * 20 * factor> <!--- Kıdem Aylığı(Çalışılan Yıl * 20 (sabit rakamdır) * Katsayı) --->

        <!--- Ödenekler --->
        <cfset business_risk = get_hr_ssk.perquisite_score * benefit_factor><!--- İş Güç /İş Riski(Yan ödeme puanı * Yan ödeme Katsayısı) --->
        <cfset university_allowance = 9500 * factor * (get_hr_ssk.university_allowance / 100) > <!--- Üniversite Ödeneği(En yüksek devlet memuru maaşı katsayı (9.500) * Katsayı * Oran (Ünvana göre değişir Yrd.Doç. %165)) --->
        <cfset private_service_compensation = 9500 * factor * (get_hr_ssk.private_service_score / 100) ><!--- Özel Hizmet Tazminatı(En yüksek devlet memuru maaşı katsayı (9.500) * Katsayı * Oran ( %)) --->
        <cfloop index = "lang_indx" from = "1" to = "5"><!--- Yabancı Diller --->
            <cfif len(evaluate("get_hr_ssk.language_allowance_#lang_indx#"))>
                <cfset lang_val = get_component_lang.GET_SETUP_LANGUAGE_ALLOWANCE(language_allowance_id : evaluate("get_hr_ssk.language_allowance_#lang_indx#"))>
                <cfif lang_val.recordcount neq 0>
                    <cfset language_allowance = language_allowance + ( lang_val.LANGUAGE_AMOUNT * factor)><!--- Yabancı Dil Tazminatı (Düzey puanı * Katsayı) --->
                </cfif>
            </cfif>
        </cfloop>
        <cfset executive_indicator_compensation = get_hr_ssk.executive_indicator_score * factor><!--- Makam Tazminatı(Makam Tazminatı Göstergesi * Katsayı) --->
        <cfset administrative_compensation = get_hr_ssk.administrative_indicator_score * factor> <!--- Görev Tazminatı(Görev Tazminatı Göstergesi * Katsayı) --->
        <cfset administrative_duty_allowance = (indicator_score + additional_indicators) * factor * (get_hr_ssk.administrative_function_allowance / 100)><!--- İdari Görev Ödeneği	((Maaş Göstergesi + Ek göstergesi) * Katsayı * Oran %) --->
        <cfset education_allowance = (9500 * factor) / 12><!--- Eğitim Ödeneği (En yüksek devlet memuru maaşı katsayı (9.500) * Katsayı / 12) --->
        <!--- Eş Durumu (Eşi Çalışmıyorsa) --->
        <cfquery name="get_emp_family" dbtype="query">
			SELECT * FROM get_relatives WHERE RELATIVE_LEVEL = '3' AND WORK_STATUS = 0
		</cfquery>
        <cfif get_emp_family.recordcount gt 0>
            <cfset family_assistance = factor * family_allowance_point ><!--- Aile Yardımı (Katsayı * Puan (1500 - Değişebilir ) )--->
        </cfif>
        <!--- Çocuk Sayısı --->
        <cfquery name="get_emp_child" dbtype="query">
			SELECT * FROM get_relatives WHERE  (RELATIVE_LEVEL = '5' OR RELATIVE_LEVEL = '4') AND WORK_STATUS = 0
		</cfquery>
        <cfset first_child_factor = get_factor.child_benefit_first>
        <cfif get_emp_child.recordcount gt 0>
            <cfset child_count = get_emp_child.recordcount>
        <cfelse>
            <cfset child_count = 0>
        </cfif>
        <cfoutput query="get_emp_child">
            <cfset child_age = dateDiff('yyyy',get_emp_child.BIRTH_DATE,now())>
            <cfif child_age lte 6>
                <cfset child_count += 1>
            </cfif>
        </cfoutput>
        <cfset child_assistance = factor * child_count * first_child_factor><!--- Çocuk Yardımı (Katsayı * Puan (1 çocuk 250 puan - Değişebilir))--->
        
        <!--- Ücret Kartı History --->
        <cfset get_history = get_in_out_history()>
        <cfif get_history.recordcount gt 0>
            <!--- Önceki kayıtta kademe veya derece faklı ise --->
            <cfset grade_history = get_history.grade>
            <cfset step_history = get_history.step>

            <cfif (grade_history neq get_hr_ssk.grade or step_history neq get_hr_ssk.step) and (len(grade_history) and len(step_history))>
                <cfset get_grade_step_history = cmp_grade_step_params.GET_EMPLOYEES_GRADE_STEP_PARAMS(
                    start_month : start_month,
                    end_month : end_month,
                    grade : grade_history,
                    step : step_history
                )>
                
                <!--- Memur Gösterge Tablosu Kontrolü --->
                <cfif get_grade_step_history.recordcount eq 0>
                    <cfsavecontent variable="table_error"><cf_get_lang dictionary_id='62929.Girilen Tarihler Arasında Memur Gösterge Tablosu Bulunmaktadır!'></cfsavecontent>
                    <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: table_error , in_out_id: attributes.in_out_id) />   
                <cfelse>
                    <cfset get_history_val = evaluate("get_grade_step_history.step_#step_history#")><!--- Gösterge Puanı --->
                </cfif>
                <cfset diff_value = abs(get_history_val - indicator_score)>
                <cfset promotion_difference = diff_value * factor><!--- Terfi Farkı(Gösterge Farkları * Katsayı - (Bir önceki aya göre kademe ve derecesi değişmiş ise))--->
            </cfif>
        </cfif>
        <cfset extra_pay = 9500 * factor * (get_hr_ssk.additional_score / 100)><!--- Ek Ödeme (En yüksek devlet memuru maaş katsayısı (9.500) * Katsayı * Puan %) --->
        <!--- Tüm Hesap Toplamı --->
        <cfset total_salary = salary + additional_indicators + severance_pension + business_risk  + university_allowance + private_service_compensation + language_allowance + executive_indicator_compensation + administrative_compensation + administrative_duty_allowance + education_allowance + family_assistance + child_assistance + extra_pay + promotion_difference + child_count>
      
    </cffunction>

    <!--- Ekleme Queryleri --->
    <cffunction name="add_officer_payroll" access="public" returntype="any">
        <!--- Todo: employees_puantaj_rows tablosuna da atılacak. Salary  employees_puantaj_rows tablosuna atılacak.--->
      <!---   <cfquery name="add_payroll_rows" datasource="#dsn#" result="MAX_ID">
            INSERT INTO
            EMPLOYEES_PUANTAJ_ROWS
            (
                IN_OUT_ID,
                PUANTAJ_ID,
                EMPLOYEE_ID,
                SSK_NO,
                SALARY_TYPE,
                SALARY,
                MONEY,
                TOTAL_SALARY
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.puantaj_id#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#">,
                <cfif len(attributes.SOCIALSECURITY_NO)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.SOCIALSECURITY_NO#"><cfelse>NULL</cfif>,
                <cfif len(get_hr_ssk.salary_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_hr_ssk.salary_type#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_float" value="#salary#">,
                <cfif len(get_hr_ssk.money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_hr_ssk.money#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_float" value="#total_salary#">
            )
        </cfquery> --->
        
        <cfquery name="add_officer_payroll" datasource="#dsn#">
            INSERT INTO 
            OFFICER_PAYROLL_ROW
            (
                PAYROLL_ID
                ,EMPLOYEE_PAYROLL_ID
                ,ADDITIONAL_INDICATORS
                ,SEVERANCE_PENSION
                ,BUSINESS_RISK
                ,UNIVERSITY_ALLOWANCE
                ,PRIVATE_SERVICE_COMPENSATION
                ,LANGUAGE_ALLOWANCE
                ,EXECUTIVE_INDICATOR_COMPENSATION
                ,ADMINISTRATIVE_COMPENSATION
                ,ADMINISTRATIVE_DUTY_ALLOWANCE
                ,EDUCATION_ALLOWANCE
                ,FAMILY_ASSISTANCE
                ,CHILD_ASSISTANCE
                ,PROMOTION_DIFFERENCE
                ,EXTRA_PAY
                ,GRADE
                ,STEP
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.puantaj_id#">
                ,<cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#additional_indicators#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#severance_pension#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#business_risk#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#university_allowance#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#private_service_compensation#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#language_allowance#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#executive_indicator_compensation#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#administrative_compensation#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#administrative_duty_allowance#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#education_allowance#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#family_assistance#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#child_assistance#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#promotion_difference#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#extra_pay#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#get_hr_ssk.grade#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#get_hr_ssk.step#">
            )
        </cfquery>
        
        
    
        <!--- PAYROLL_JOB tablosuna json --->
        <cfset data = structnew()>
        <cfset data.puantaj_id = puantaj_id>
        <cfset data.employee_id = employee_id>
        <cfset data.in_out_id = attributes.in_out_id>
        <cfset data.SOCIALSECURITY_NO = attributes.SOCIALSECURITY_NO>
        <cfset data.salary_type = get_hr_ssk.salary_type>     
        <cfset data.maas = salary>   
        <cfset data.ek_gosterge = additional_indicators>   
        <cfset data.kidem_ayligi = severance_pension>   
        <cfset data.is_riski = business_risk>   
        <cfset data.universite_odenegi = university_allowance>   
        <cfset data.ozel_hizmet_tazminati = private_service_compensation>   
        <cfset data.yabanci_dil_tazminati = language_allowance>   
        <cfset data.makam_tazminati = executive_indicator_compensation>   
        <cfset data.gorev_tazminati = administrative_compensation> 
        <cfset data.idari_gorev_tazminati = administrative_duty_allowance>
        <cfset data.egitim_odenegi = education_allowance>
        <cfset data.aile_yardimi = family_assistance>
        <cfset data.cocuk_yardimi = child_assistance>
        <cfset data.ek_odeme = extra_pay>
        <cfset data.terfi_farki = promotion_difference>
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
                BRANCH_PAYROLL_ID = #attributes.puantaj_id#,
                PAYROLL_DRAFT = <cfqueryparam CFSQLType = "cf_sql_varchar" value = "#serializedStr#">,
                EMPLOYEE_PAYROLL_ID = <cfqueryparam CFSQLType = "cf_sql_varchar" value = "#MAX_ID.IDENTITYCOL#">
            WHERE 
                IN_OUT_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.in_out_id# " null = "no">
                AND BRANCH_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#branch_id#" null = "no">
                AND MONTH = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#sal_mon_#" null = "no">
                AND YEAR = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#sal_year_#" null = "no">
                AND PAYROLL_TYPE = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.puantaj_type#" null = "no">
                AND STATUE = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.ssk_statue#" null = "no">
                AND STATUE_TYPE = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.statue_type#" null = "no">
        </cfquery>

    </cffunction>

    <!--- Katsayılar --->
    <cffunction name="get_factor_definition" access="public" returntype="any">
        <cfargument  name="start_month">
        <cfargument  name="end_month">
        <cfquery name="get_factor_definition" datasource="#dsn#">
            SELECT
                *
            FROM
                SALARY_FACTOR_DEFINITION
            WHERE
                (
                    (STARTDATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.start_month)#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.end_month)#">) OR
                    (FINISHDATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.start_month)#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.end_month)#">) OR
                    (STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.start_month)#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.end_month)#">)
                )
        </cfquery>
        <cfreturn get_factor_definition>
    </cffunction>
    
    <!--- Ücret Kartı History --->
    <cffunction name="get_in_out_history" access="public" returntype="any">
        <cfargument  name="start_month">
        <cfargument  name="end_month">
        <cfset start_month_ = dateadd("m",-1,start_month)>
        <cfset end_month_ = dateadd("m",-1,end_month)>
        
        <cfquery name="get_in_out_history" datasource="#dsn#">
            SELECT
                OPR.GRADE,
                OPR.STEP
            FROM
                EMPLOYEES_PUANTAJ EP
                INNER JOIN EMPLOYEES_PUANTAJ_ROWS EPR ON EPR.PUANTAJ_ID = EP.PUANTAJ_ID
                INNER JOIN OFFICER_PAYROLL_ROW OPR ON OPR.PAYROLL_ID = EP.PUANTAJ_ID AND EPR.EMPLOYEE_PUANTAJ_ID = OPR.EMPLOYEE_PAYROLL_ID
            WHERE
                PUANTAJ_TYPE = #attributes.puantaj_type# AND
                SAL_MON = #month(start_month_)# AND
                SAL_YEAR = #year(start_month_)# AND
                SSK_BRANCH_ID = #branch_id#
                <cfif isdefined("attributes.hierarchy_puantaj") and len(attributes.hierarchy_puantaj)>
                    AND HIERARCHY = '#attributes.hierarchy_puantaj#'
                </cfif>
                AND STATUE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ssk_statue#">
                <cfif isdefined("attributes.ssk_statue") and len(attributes.ssk_statue) and attributes.ssk_statue eq 2>
                    AND STATUE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.statue_type#">
                </cfif>
                AND EPR.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
        </cfquery>
        <cfreturn get_in_out_history>
    </cffunction>
</cfcomponent>