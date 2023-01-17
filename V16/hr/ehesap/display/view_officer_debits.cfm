<cf_get_lang_set module_name="ehesap">
<cfparam name="attributes.is_virtual_puantaj" default="0">
<cfset main_puantaj_table = "EMPLOYEES_PUANTAJ">
<cfset row_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS">
<cfset add_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS_ADD">
<cfset maas_puantaj_table = "EMPLOYEES_SALARY">
<cfparam name="icmal_border" default="0">
<cfset get_title_cmp = createObject('component','V16.hr.cfc.add_rapid_emp')>
<cfif not evaluate("#query_name#.recordcount")>
	<script type="text/javascript">
		alert("Kayıt bulunamadı!");
		history.back();
	</script>
	<cfexit method="exittemplate">
</cfif>
<cfscript>
	//Gün Toplamları
	t_paid_izin = 0;
	t_paid_izin_hours = 0;
	t_haftalik_tatil = 0;
	t_haftalik_tatil_hours = 0;
	t_normal_gun = 0;
	t_normal_hours = 0;
	t_paid_izinli_sundays = 0;
	t_paid_izinli_sundays_hours = 0;
	t_izin = 0;
	t_izin_hours = 0;
	t_total_days = 0;
	t_total_hours = 0;
	t_offdays = 0;
	t_offdays_hours = 0;
	t_ext_work_hours_0 = 0;
	t_ext_work_hours_1 = 0;
	t_ext_work_hours_2 = 0;
	t_ext_work_hours_5 = 0;
	t_salary = 0;
	t_base_salary = 0;
	t_retirement_allowance = 0;
	t_retirement_allowance_personal = 0;
	t_retirement_allowance_personal_interruption = 0;
	t_general_health_insurance = 0;
	t_sgk_base = 0;
	t_additional_indicator_compensation = 0;
	t_extra_pay = 0;
	t_additional_score = 0;
	t_normal_additional_score = 0;
	t_audit_compensation_amount = 0;
	t_retired_academic = 0;

	//tutar toplamları
	t_normal_amount = 0;
	t_haftalik_tatil_amount = 0;
	t_offdays_amount = 0;
	t_izin_amount = 0;
	t_izin_paid_amount = 0;
	t_izin_paid_amount_ht = 0;
	t_kidem_amount = 0;
	t_ihbar_amount = 0;
	t_yillik_izin_amount = 0;
	t_ext_salary_0 = 0;
	t_ext_salary_1 = 0;
	t_ext_salary_2 = 0;
	t_ext_salary_5 = 0;
	t_collective_agreement_bonus = 0;
	t_high_education_compensation = 0;
	t_land_compensation_amount = 0;
	
	t_reel_ssk_days = 0;
	t_ssdf_ssk_days = 0;
	t_ssk_matrahi = 0;
	t_sgdp_devir = 0; 
	t_devirden_gelen = 0;
	t_toplam_kazanc = 0;
	t_vergi_iadesi = 0;
	t_vergi_iadesi_alan = 0;
	t_kum_gelir_vergisi_matrahi = 0;
	t_gelir_vergisi_matrahi = 0;
	t_gelir_vergisi = 0;
	t_damga_vergisi = 0;
	t_damga_vergisi_matrahi = 0;
	t_kesinti = 0;
	t_net_ucret = 0;
	t_ssk_primi_isci = 0;
	t_bes_primi_isci = 0;
	t_ssk_primi_isci_devirsiz = 0;
	t_ssk_primi_isveren_hesaplanan = 0;
	t_ssk_primi_isveren = 0;
	t_ssk_primi_isveren_gov = 0;


	t_issizlik_isci_hissesi = 0;
	t_issizlik_isci_hissesi_devirsiz = 0;
	t_issizlik_isveren_hissesi = 0;
	t_ozel_kesinti = 0;
	t_ozel_kesinti_2 = 0;
	t_ozel_kesinti_2_net = 0;
	t_ozel_kesinti_2_net_fark = 0;
	ssk_count = 0;
	t_ssdf_days = 0;
	t_ssdf_matrah = 0;
	t_ssdf_isci_hissesi = 0;
	t_ssdf_isveren_hissesi = 0;
	t_sakatlik = 0;
	t_gocmen_indirimi = 0;
	t_ext_salary = 0;
	t_ext_salary_net = 0;
	t_ssk_matrah_muafiyet = 0;
	t_vergi_matrah_muafiyet = 0;
	t_avans = 0;
	ssdf_say = 0;
	ssk_say = 0;
	sakat_say = 0;
	t_short_working_calc = 0;//kısa çalışma ödeneği
	t_isci_primi_indirimli = 0;
	t_issizlik_isci_primi_indirimli = 0;
	t_issizlik_isveren_primi_indirimli = 0;
	t_plus_retired = 0;//Artış %100
    t_plus_retired_person = 0;//Kişi Devlet %100
	t_penance_deduction = 0;//Kefaret kesintisi

	if (isnumeric(get_kumulatif_gelir_vergisi.toplam))
		t_kum_gelir_vergisi = get_kumulatif_gelir_vergisi.toplam;
	else
		t_kum_gelir_vergisi = 0;

	if (isdefined("get_kumulatif_gelir_vergisi.toplam_matrah") and isnumeric(get_kumulatif_gelir_vergisi.toplam_matrah))
		t_kum_gelir_vergisi_matrahi = get_kumulatif_gelir_vergisi.toplam_matrah;
	else
		t_kum_gelir_vergisi_matrahi = 0;
		
	t_total_pay_ssk_tax = 0;
	t_total_pay_ssk = 0;
	t_total_pay_tax = 0;
	t_total_pay = 0;
	t_vergi_istisna_yaz = 0;
	t_vergi_istisna_net_yaz = 0;
	t_vergi_istisna_tutar = 0;
	fmesai_sayac_1 = 0;
	fmesai_sayac_2 = 0;
	fmesai_sayac_3 = 0;
	fmesai_sayac_4 = 0;	
	T_VERGI_ISTISNA_DAMGA = 0;
	T_VERGI_ISTISNA_VERGI = 0;
	fazla_mesai_toplam = 0;

    t_additional_indicators = 0; //ek gösterge puanı
    t_university_allowance = 0;//üniversite ödeneği
    t_private_service_compensation = 0;//Özel Hizmet tazminatı
    t_family_assistance = 0;//Eş YArdımı
    t_child_assistance = 0;//Çocuk yardımı;
    t_severance_pension = 0;//Kıdem Aylığı
    t_language_allowance = 0;//dil tazminatı
    t_academic_incentive_allowance_amount = 0;//akademik teşvik ödeneği
    t_executive_indicator_compensation = 0;//Makam tazminatı
    t_administrative_duty_allowance = 0;//idari görev tazminatı
    t_education_allowance = 0;//eğitim öğretim ödeneği
    t_administrative_compensation = 0;//Görev tazminatı
	
	t_retirement_allowance_5510 = 0;
	t_retirement_allowance_personal_5510 = 0;
	t_health_insurance_premium_5510 = 0;
	t_health_insurance_premium_personal_5510 = 0;
    diff_salary = 0;
</cfscript>
<cfif icmal_type is 'genel' and (not isdefined("attributes.func_id") or (isdefined("attributes.func_id") and not len(attributes.func_id)))>
	<!--- önceki aydan devreden kümülatif matrah calisanların bir onceki aydaki en son puantajındaki kumulatif degerlere bakmalı.sube --->
	<cfquery name="get_old_puantaj_rows" datasource="#dsn#">
		SELECT
			SUM(EPR.KUMULATIF_GELIR_MATRAH) AS KUM_TOPLAM,
			SUM(EPR.GELIR_VERGISI) AS GELIR_TOPLAM
		FROM
			EMPLOYEES_PUANTAJ_ROWS EPR INNER JOIN
			(SELECT 
				EPR.EMPLOYEE_ID,
				MAX(EPR.EMPLOYEE_PUANTAJ_ID) AS EMPLOYEE_PUANTAJ_ID
			FROM 
				EMPLOYEES_PUANTAJ_ROWS EPR INNER JOIN EMPLOYEES_PUANTAJ EP
				ON EPR.PUANTAJ_ID = EP.PUANTAJ_ID
			WHERE 
				EP.SAL_YEAR = <cfif isdefined("attributes.sal_year") and isnumeric(attributes.sal_year)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year#"></cfif> AND
				EP.SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.SAL_MON-1#"> AND
				EPR.EMPLOYEE_ID IN (#evaluate('valueList(#query_name#.EMPLOYEE_ID)')#) 
			GROUP BY
				EPR.EMPLOYEE_ID
				) AS ROW_TABLE ON EPR.EMPLOYEE_PUANTAJ_ID = ROW_TABLE.EMPLOYEE_PUANTAJ_ID	
	</cfquery>
	<cfif get_old_puantaj_rows.recordcount and len(get_old_puantaj_rows.kum_toplam)>
		<cfset onceki_donem_kum_gelir_vergisi_matrahi = get_old_puantaj_rows.kum_toplam>
		<cfset onceki_donem_kum_gelir_vergisi = get_old_puantaj_rows.gelir_toplam>
	</cfif>
</cfif>
<cfset bu_ay_basi = createdate(attributes.sal_year,attributes.sal_mon, 1)>
<cfif isdefined('attributes.sal_year_end') and len(attributes.sal_year_end) and isdefined('attributes.sal_mon_end') and len(attributes.sal_year_end)>
	<cfset temp_ay_basi = createdate(attributes.sal_year_end,attributes.sal_mon_end, 1)>
	<cfset bu_ay_sonu = date_add('s',-1,date_add('m',1,temp_ay_basi))>
<cfelse>
	<cfset bu_ay_sonu = date_add('s',-1,date_add('m',1,bu_ay_basi))>
</cfif>
<cfquery name="get_izins" datasource="#dsn#">
	SELECT
		OFFTIME.EMPLOYEE_ID,
		OFFTIME.STARTDATE,
		OFFTIME.FINISHDATE,
		SETUP_OFFTIME.EBILDIRGE_TYPE_ID,
		SETUP_OFFTIME.IS_YEARLY,
		SETUP_OFFTIME.SIRKET_GUN,
		SETUP_OFFTIME.IS_PAID
	FROM
		OFFTIME,SETUP_OFFTIME
	WHERE
		SETUP_OFFTIME.OFFTIMECAT_ID = OFFTIME.OFFTIMECAT_ID AND
		OFFTIME.VALID = 1 AND
		OFFTIME.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_sonu#"> AND
		OFFTIME.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_basi#"> AND 
		OFFTIME.IS_PUANTAJ_OFF = 0
	ORDER BY
		OFFTIME.EMPLOYEE_ID
</cfquery>

<cfquery name="get_personal_salary" dbtype="query">
	SELECT * FROM get_puantaj_personal WHERE STATUE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
</cfquery>
<cfquery name="get_personal_debits" dbtype="query">
	SELECT * FROM get_puantaj_personal WHERE STATUE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="11">
</cfquery>

<cfif icmal_type is 'personal'>
<!-- sil -->
</cfif>

<cfif isdefined("url.fuseaction") and url.fuseaction eq 'ehesap.popupflush_view_puantaj_print_pdf'>
	<cfset uidrop_value="0">
	<cfset title="">
<cfelse>
	<cfset uidrop_value="1">
	<cfset title="Bordro">
</cfif>
<cfquery name="GET_PROTESTS" datasource="#DSN#" maxrows="1">
	SELECT * FROM EMPLOYEES_PUANTAJ_PROTESTS WHERE SAL_MON=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND SAL_YEAR=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND EMPLOYEE_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> ORDER BY PROTEST_ID DESC
</cfquery>

<cfset puantaj_action = createObject("component", "V16.hr.ehesap.cfc.create_puantaj")>
<cfset puantaj_action.dsn = dsn />
<cfset get_relatives = puantaj_action.get_relatives(attributes.EMPLOYEE_ID,attributes.sal_mon,attributes.sal_year)/>
<!--- Eş Durumu (Eşi Çalışmıyorsa) --->
<cfquery name="get_emp_family" dbtype="query">
	SELECT * FROM get_relatives WHERE RELATIVE_LEVEL = '3'
</cfquery>

<!--- Çocuk Sayısı --->
<cfquery name="get_emp_child" dbtype="query">
	SELECT * FROM get_relatives WHERE  (RELATIVE_LEVEL = '5' OR RELATIVE_LEVEL = '4') AND WORK_STATUS = 0
</cfquery>

<cf_box title="#title#" closable="0" uidrop="#uidrop_value#">
	<div <cfif icmal_type is 'personal' and listFirst(attributes.fuseaction,".") is 'myhome'>class="col col-10"<cfelse>class="col col-12"</cfif>>
        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <cf_grid_list cellspacing="0" cellpadding="2" align="center" >  
                    <cfoutput>
                       <!---  <tr>
                            <td width="50%" colspan="2" class="icmal_border_last_td">
                                <b><cf_get_lang_main no="1073.Şirket Adı"> :</b>
                                <cfif icmal_type is 'personal'>
                                    <cfoutput>#GET_PUANTAJ_PERSONAL.COMP_FULL_NAME# - #GET_PUANTAJ_PERSONAL.PUANTAJ_BRANCH_FULL_NAME#<br />
                                    <b><cf_get_lang_main no='667.İnternet'> :</b> #WEB#<br />
                                    <b><cf_get_lang_main no="1311.Adres"> :</b> #ADDRESS#<br />
                                    <cfif len(mersis_no)>
                                    <b>Mersis No :</b> #mersis_no#
                                    <cfelse>
                                    <b><cf_get_lang no='549.Ticaret Sicil No'> :</b> #T_NO#
                                    </cfif>
                                    </cfoutput>
                                <cfelseif icmal_type is 'genel'>
                                    <cfset o_comp_list = listdeleteduplicates(valuelist(get_puantaj_rows.COMP_FULL_NAME))>
                                    <cfoutput>#o_comp_list#</cfoutput><br />
                                    <cfset b_list = listdeleteduplicates(valuelist(get_puantaj_rows.PUANTAJ_BRANCH_FULL_NAME))>
                                    <cfoutput>#b_list#</cfoutput>
                                    <cfif listlen(o_comp_list) eq 1><!--- isdefined("attributes.branch_id") and listlen(attributes.branch_id) eq 1--->
                                        <br /><cfset web_list = listdeleteduplicates(valuelist(get_puantaj_rows.WEB))>
                                        <cfoutput><b><cf_get_lang_main no='667.İnternet'> :</b> #web_list#</cfoutput><br />
                                        <cfif isdefined("attributes.branch_id") and listlen(attributes.branch_id) and listlen(b_list) eq 1>
                                            <cfoutput><b><cf_get_lang_main no="1311.Adres"> :</b> #get_puantaj_rows.BRANCH_ADDRESS# #get_puantaj_rows.BRANCH_COUNTY# #get_puantaj_rows.BRANCH_CITY#</cfoutput><br />
                                        <cfelse>
                                            <cfset o_comp_address_list = listdeleteduplicates(valuelist(get_puantaj_rows.ADDRESS))>
                                            <cfoutput><b><cf_get_lang_main no="1311.Adres"> :</b> #o_comp_address_list#</cfoutput><br />
                                        </cfif>
                                        <cfset o_mersis_list = listdeleteduplicates(valuelist(get_puantaj_rows.mersis_no))>
                                        <cfset o_tno_list = listdeleteduplicates(valuelist(get_puantaj_rows.T_NO))>
                                        <cfoutput>
                                            <cfif len(o_mersis_list)><b>Mersis No :</b> #o_mersis_list#<cfelse><b><cf_get_lang no='549.Ticaret Sicil No'> :</b> #o_tno_list#</cfif>
                                        </cfoutput>
                                    </cfif>
                                <cfelseif icmal_type is 'masraf merkezi'>
                                    <cfif Len(attributes.ssk_office)>
                                        <cfoutput>#ListLast(attributes.ssk_office, '-')# - #ListGetAt(attributes.ssk_office, 3, '-')#</cfoutput>
                                    </cfif>
                                </cfif>
                                <cfif isdefined("attributes.department") and listlen(attributes.department)>
                                    <br><b><cf_get_lang_main no="160.Departman">:</b>
                                    <cfset d_list = listdeleteduplicates(valuelist(get_puantaj_rows.ROW_DEPARTMENT_HEAD))>
                                    <cfoutput>#d_list#</cfoutput><br />
                                </cfif>
                            </td>
                            <td width="50%" colspan="2" class="icmal_border_last_td">
                                <table cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td>
                                            #listgetat(ay_list(),attributes.sal_mon)# 
                                            #attributes.sal_year#
                                            <cfif not (isdefined("attributes.view_type") and attributes.view_type eq 1)>
                                                &nbsp;
                                                <cfif isdefined('attributes.sal_year_end') and len(attributes.sal_year_end) and isdefined('attributes.sal_mon_end') and len(attributes.sal_year_end) and ((attributes.sal_year_end eq attributes.sal_year and attributes.sal_mon_end neq attributes.sal_mon) or attributes.sal_year_end neq attributes.sal_year)> - #listgetat(ay_list(),attributes.sal_mon_end)# #attributes.sal_year_end#</cfif>&nbsp; 
                                            </cfif>
                                            <cfif not attributes.fuseaction contains "popup_view_price_compass"><cf_get_lang_main no="1172.İcmal"><cfelse><cf_get_lang no="29.Ücret Pusulası"></cfif>
                                        </td>
                                        <td style="text-align:right" class="txtbold">
                                            <cfif icmal_type is "personal">
                                                <cf_get_lang_main no="160.Departman"> : #GET_PUANTAJ_PERSONAL.ROW_DEPARTMENT_HEAD#
                                            </cfif>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" class="icmal_border_without_top">
                                <cfif icmal_type is "genel">
                                    <b><cf_get_lang no="779.Şube SGK">:</b> 
                                    <cfset s_info_list = listdeleteduplicates(valuelist(get_puantaj_rows.SUBE_SSK_INFO))>
                                    #s_info_list#
                                </cfif>
                                <cfif icmal_type is "personal">
                                    <cf_get_lang no="779.Şube SGK"> : #ssk_m##SSK_JOB##SSK_BRANCH##SSK_BRANCH_OLD##B_SSK_NO##SSK_CITY##SSK_COUNTRY##SSK_CD##SSK_AGENT#<br/>
                                    <cf_get_lang no="823.Adı Soyadı"> : #employee_name# #employee_surname#<br/>
                                    <cf_get_lang dictionary_id='63668.Personel No'> : #EMPLOYEE_NO#
									<cfset attributes.branch_id = GET_PUANTAJ_PERSONAL.branch_id></br>
                                    <cfif x_get_sgkno eq 1><cf_get_lang no="291.SGK No"> : #GET_PUANTAJ_PERSONAL.SOCIALSECURITY_NO#<br/></cfif>
                                    <cf_get_lang no='1319.TC No'> : #GET_PUANTAJ_PERSONAL.tc_identy_no#<br>
									<cf_get_lang dictionary_id='32329.Kurum Sicil No'> : #GET_PUANTAJ_PERSONAL.REGISTRY_NO#<br>
									<cf_get_lang dictionary_id='63673.Emekli Sicil No'> : #GET_PUANTAJ_PERSONAL.RETIRED_REGISTRY_NO#<br>
                                </cfif>
                                <cfif isdefined("attributes.ssk_statute") and listlen(attributes.ssk_statute)>
                                    <br><b><cf_get_lang no="607.SGK Statüleri"> :</b>
                                    <cfset s_list = attributes.ssk_statute>
                                    <cfloop list="#s_list#" index="ccc">
                                        <cfoutput>#listgetat(list_ucret_names(),listfindnocase(list_ucret(),ccc,','),'*')#</cfoutput><cfif ccc - 1 neq ListLen(s_list) AND ccc gt 1>,</cfif>
                                    </cfloop>
                                </cfif>
                                <cfif icmal_type is "genel">
                                    <cfif isdefined("attributes.EXPENSE_CENTER") and len(attributes.EXPENSE_CENTER)>
                                        <br>
                                    <cfset exp_code_list = listdeleteduplicates(valuelist(get_puantaj_rows.EXP_NAME))>
                                        <b><cf_get_lang_main no="1048.Masraf Merkezi">:</b> #exp_code_list#
                                    </cfif>
                                    <cfif isdefined('attributes.duty_type') and len(attributes.duty_type)>
                                        <br />
                                        <cfset duty_type_name = "">
                                        <cfset duty_type_list = listdeleteduplicates(valuelist(get_puantaj_rows.duty_type))>
                                        <cfif len(duty_type_list)>
                                        <cfloop list="#duty_type_list#" delimiters="," index="t">
                                            <cfif t eq 2>
                                                <cfsavecontent variable="message"><cf_get_lang_main no="164.Çalışan"></cfsavecontent>
                                            <cfelseif t eq 1>
                                                <cfsavecontent variable="message"><cf_get_lang no="194.İşveren Vekili"></cfsavecontent>
                                            <cfelseif t eq 0>
                                                <cfsavecontent variable="message"><cf_get_lang no='604.İşveren'></cfsavecontent>
                                            <cfelseif t eq 3>
                                                <cfsavecontent variable="message"><cf_get_lang no="206.Sendikalı"></cfsavecontent>
                                            <cfelseif t eq 4>
                                                <cfsavecontent variable="message"><cf_get_lang no="232.Sözleşmeli"></cfsavecontent>
                                            <cfelseif t eq 5>
                                                <cfsavecontent variable="message"><cf_get_lang no="223.Kapsam Dışı"></cfsavecontent>
                                            <cfelseif t eq 6>
                                                <cfsavecontent variable="message"><cf_get_lang no="236.Kısmi İstihdam"></cfsavecontent>
                                            <cfelseif t eq 7>
                                                <cfsavecontent variable="message"><cf_get_lang no="253.Taşeron"></cfsavecontent>
                                            </cfif>
                                            <cfset duty_type_name = listappend(duty_type_name,"#message#",',')>						
                                        </cfloop>
                                        </cfif>
                                        <b><cf_get_lang_main no="1126.Görev Tipi"> : </b> #duty_type_name#
                                    </cfif>
                                    <cfif isdefined('attributes.period_code_cat') and len(attributes.period_code_cat)>				
                                        <br />
                                        <cfset account_code_list = listdeleteduplicates(valuelist(get_puantaj_rows.definition))>
                                        <b><cf_get_lang no='1171.Muhasebe Kod Grubu'>:</b> #account_code_list#
                                    </cfif>
                                </cfif>
                            </td>
                            <td colspan="2" class="icmal_border_last_td_without_top">
                                <cfif icmal_type is not "personal">
                                    <b><cf_get_lang no="824.Kişi Sayısı">  :</b>#kisi_say#
                                <cfelse>
									<cfif isdefined("attributes.currentrow")>
										<cf_get_lang dictionary_id='31253.Sıra No'>:#attributes.currentrow#
									</cfif>
                                    <cfif x_get_groupdate eq 1>&nbsp;<cf_get_lang no='758.Gruba Giriş'> : #dateformat(GROUP_STARTDATE,dateformat_style)#</cfif><br/>
                                    <cfif x_get_kidemdate eq 1><cf_get_lang no='695.Kıdem Baz Tarihi'> : #dateformat(KIDEM_DATE,dateformat_style)#</cfif><br/>
									<cfif x_get_kidemdate eq 1><cf_get_lang dictionary_id='56292.Kıdem Yıl'> : #dateDiff('yyyy',KIDEM_DATE,now())#</cfif><br/>
                                    <cf_get_lang no="756.İşe Giriş"> : #dateformat(GET_PUANTAJ_PERSONAL.START_DATE,dateformat_style)#
                                    <cfif len(GET_PUANTAJ_PERSONAL.FINISH_DATE) and (month(FINISH_DATE) eq attributes.sal_mon and year(FINISH_DATE) eq attributes.sal_year)>- <cf_get_lang_main no="19.Çıkış"> : #dateformat(GET_PUANTAJ_PERSONAL.FINISH_DATE,dateformat_style)#</cfif></br>
									<cf_get_lang dictionary_id='46602.Medeni Hali'> : <cfif get_emp_family.recordcount gt 0><cf_get_lang dictionary_id='44602.Evli'><cfelse><cf_get_lang dictionary_id='44603.Bekar'></cfif><br>
									<cf_get_lang dictionary_id='46572.Çocuk Sayısı'> : #get_emp_child.recordcount#<br>
									<cf_get_lang dictionary_id='63979.Emekliye Esas'> <cf_get_lang dictionary_id='62877.Ek Gösterge Puanı'> : #tlformat(t_additional_score)#<br>
									<cf_get_lang dictionary_id='63980.Esas Ek Gösterge Tutarı'> : #tlformat(t_normal_additional_score)#<br>
									<cf_get_lang dictionary_id='63272.Gösterge Tutarı'> : #tlformat(indicator_score)#
                                </cfif>
                            </td>
                        </tr> --->
                        <tr>
                            <td>#ucase(getLang('','Personelin Ünvanı ve Adı Soyadı',65237))#</td>
                            <td>
                                <cfset get_title = get_title_cmp.get_titles(title_id: GET_PUANTAJ_PERSONAL.TITLE_ID)>
								#get_title.title# #employee_name# #employee_surname#
                            </td>
                        </tr> 
                        <tr>
                            <td>#ucase(getLang('','TC Kimlik No',58025))#</td>
                            <td>
                                #GET_PUANTAJ_PERSONAL.tc_identy_no#
                            </td>
                        </tr>
                        <tr>
                            <td>#ucase(getLang('','Tahakkuk Birimi',65238))#</td>
                            <td>
                                #GET_PUANTAJ_PERSONAL.PUANTAJ_BRANCH_FULL_NAME#
                            </td>
                        </tr>
                        <tr>
                            <td>#ucase(getLang('','Medeni Durumu',30513))#</td>
                            <td>
                                <cfif get_emp_family.recordcount gt 0><cf_get_lang dictionary_id='44602.Evli'><cfelse><cf_get_lang dictionary_id='44603.Bekar'></cfif>
                            </td>
                        </tr>
                        <tr>
                            <td>#ucase(getLang('','Ayrılma Nedeni',44307))# <cf_get_lang dictionary_id='57989.ve'> #ucase(getLang('','tarihi',58593))#</td>
                            <td>
                                #len(GET_PUANTAJ_PERSONAL.explanation_id) ? ListGetAt(law_list(),explanation_id,",") : ''# -#len(GET_PUANTAJ_PERSONAL.FINISH_DATE) ? dateformat(GET_PUANTAJ_PERSONAL.FINISH_DATE,dateformat_style) : ''#
                            </td>
                        </tr> 
                        <tr>
                            <td>#ucase(getLang('','Ödenmesi Gereken Gün Sayısı',65239))#</td>
                            <td>
                                #ssk_days# / #total_days#
                            </td>
                        </tr>
                        <tr>
                            <td>#ucase(getLang('','Adres Bilgisi',65240))#</td>
                            <td>
                                #ADDRESS#
                            </td>
                        </tr> 
                        <tr>
                            <td>#ucase(getLang('','Telefon Bilgisi',65241))#</td>
                            <td>
                                #MOBILTEL#
                            </td>
                        </tr> 
                        <tr>
                            <td>#ucase(getLang('','Mail Bilgisi',65242))#</td>
                            <td>
                                #EMPLOYEE_EMAIL#
                            </td>
                        </tr>
                    </cfoutput>
                </cf_grid_list>
            </div>
        </div>
        <!---<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
             <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cf_grid_list align="center">  
                    <cfoutput>
                        <tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='63979.Emekliye Esas'> <cf_get_lang dictionary_id='37566.Derece / Kademe'>
                            </td>
                            <td style="text-align:center">#GET_PUANTAJ_PERSONAL.GRADE# / #GET_PUANTAJ_PERSONAL.step#</td>
                        </tr>
						<tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='37566.Derece / Kademe'>
                            </td>
                            <td style="text-align:center">#GET_PUANTAJ_PERSONAL.NORMAL_GRADE# / #GET_PUANTAJ_PERSONAL.normal_step#</td>
                        </tr>
                        <tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='64051.Geçen Aylar Vergi Matrahı Toplam'>
                            </td>
                            <td style="text-align:right">#TLFormat(t_kum_gelir_vergisi_matrahi)#<!--- #TLFormat(t_kum_gelir_vergisi_matrahi+t_gelir_vergisi_matrahi)# ---></td>
                        </tr> 
                    </cfoutput>
                </cf_grid_list>
            </div>
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cf_grid_list align="center">  
                    <cfoutput>
                        <tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='63270.Raporlu Gün Sayısı'>
                            </td>
                            <td width="300px">#t_izin#</td>
                        </tr>
                        <tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='53249.Gelir Vergisi Matrahı'>
                            </td>
                            <td style="text-align:right">#tlformat(t_gelir_vergisi_matrahi)#</td>
                        </tr>
                        <tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='53659.Asgari Geçim İndirimi'>
                            </td>
                            <td style="text-align:right">#TLFormat(t_vergi_iadesi)#</td>
                        </tr>
                    </cfoutput>
                </cf_grid_list>         
            </div>
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cf_grid_list align="center">  
                    <cfoutput>
                        <tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='63271.Sözleşme Tazminatı'>
                            </td>
                            <td style="text-align:right">?</td>
                        </tr>
                        <tr>
                            <td width="300px">&nbsp;
                            </td>
                            <td style="text-align:right"></td>
                        </tr>
                        <tr>
                            <td width="300px">&nbsp;
                            </td>
                            <td style="text-align:right"></td>
                        </tr>
                    </cfoutput>
                </cf_grid_list>         
            </div>
        </div> --->
        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <cf_grid_list align="center">  
                    <cfoutput>
                        <tr class="bold">
                            <td colspan="4">
                                #ucase(getLang('','Tablo',43570))# 1 : #ucase(getLang('','Aylık ve Yan Ödemeler',65225))# 
                            </td>
                        </tr>
                        <tr class="bold">
                            <td width="300px" class="bold">
                                #ucase(getLang('','Aylık Unsurlar',65222))#
                            </td>
                            <td>#ucase(getLang('','Tahakkuk Ettirilen',65223))#</td>
                            <td>#ucase(getLang('','Asıl Hakedişi',65224))#</td>
                            <td>#ucase(getLang('','Fark',58583))#</td>
                        </tr>
						<tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='63662.Aylık Tutar'>
                            </td>
                            <td style="text-align:right">#tlformat(abs(get_personal_salary.salary))#</td>
                            <td style="text-align:right">#tlformat(abs(get_personal_debits.salary))#</td>
                            <td style="text-align:right">#tlformat(abs(get_personal_salary.salary - get_personal_debits.salary))#</td>
                        </tr>
                        <tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='32589.Ek'> <cf_get_lang dictionary_id='63272.Gösterge Tutarı'>
                            </td>
                            <td style="text-align:right">#TLFormat(get_personal_salary.additional_indicators)#</td>
                            <td style="text-align:right">#TLFormat(get_personal_debits.additional_indicators)#</td>
                            <td style="text-align:right">#TLFormat(abs(get_personal_salary.additional_indicators - get_personal_debits.additional_indicators))#</td>
                        </tr> 
                        <tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='38971.Vergi İndirimi'>
                            </td>
                            <td style="text-align:right">#TLFormat(t_istisna + get_personal_salary.TAX_MATRAH_EXEMPTION)#</td>
                            <td style="text-align:right">#TLFormat(t_istisna + get_personal_debits.TAX_MATRAH_EXEMPTION)#</td>
                            <td style="text-align:right">#TLFormat(abs(get_personal_salary.TAX_MATRAH_EXEMPTION - get_personal_debits.TAX_MATRAH_EXEMPTION))#</td>
                        </tr>
                        <tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='62884.Üniversite Ödeneği'>
                            </td>
                            <td style="text-align:right">#TLFormat(get_personal_salary.university_allowance)#</td>
                            <td style="text-align:right">#TLFormat(get_personal_debits.university_allowance)#</td>
                            <td style="text-align:right">#TLFormat(abs(get_personal_salary.university_allowance - get_personal_debits.university_allowance))#</td>
                        </tr>
                        <tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='63274.Özel Hizmet Tazminatı'>
                            </td>
                            <td style="text-align:right">#tlformat(get_personal_salary.private_service_compensation)#</td>
                            <td style="text-align:right">#tlformat(get_personal_debits.private_service_compensation)#</td>
                            <td style="text-align:right">#tlformat(abs(get_personal_salary.private_service_compensation - get_personal_debits.private_service_compensation))#</td>
                        </tr>
                        <tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='63275.Yan Ödeme'>
                            </td>
                            <td style="text-align:right">#tlformat(get_personal_salary.business_risk)#</td>
                            <td style="text-align:right">#tlformat(get_personal_debits.business_risk)#</td>
                            <td style="text-align:right">#tlformat(abs(get_personal_salary.business_risk - get_personal_debits.business_risk))#</td>
                        </tr>
                        <tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='63664.Eş Yardımı'>
                            </td>
                            <td style="text-align:right">#tlformat(get_personal_salary.family_assistance)#</td>
                            <td style="text-align:right">#tlformat(get_personal_debits.family_assistance)#</td>
                            <td style="text-align:right">#tlformat(abs(get_personal_salary.family_assistance - get_personal_debits.family_assistance))#</td>
                        </tr>
						<tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='46080.Çocuk Yardımı'>
                            </td>
                            <td style="text-align:right">#tlformat(get_personal_salary.child_assistance)#</td>
                            <td style="text-align:right">#tlformat(get_personal_debits.child_assistance)#</td>
                            <td style="text-align:right">#tlformat(abs(get_personal_salary.child_assistance - get_personal_debits.child_assistance))#</td>
                        </tr>
                        <tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='63277.Taban Aylığı'>
                            </td>
                            <td style="text-align:right">#tlformat(get_personal_salary.base_salary)#</td>
                            <td style="text-align:right">#tlformat(get_personal_debits.base_salary)#</td>
                            <td style="text-align:right">#tlformat(abs(get_personal_salary.base_salary - get_personal_debits.base_salary))#</td>
                        </tr>
                        <tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='63278.Kıdem Aylığı'>
                            </td>
                            <td style="text-align:right">#tlformat(get_personal_salary.severance_pension)#</td>
                            <td style="text-align:right">#tlformat(get_personal_debits.severance_pension)#</td>
                            <td style="text-align:right">#tlformat(abs(get_personal_salary.severance_pension - get_personal_debits.severance_pension))#</td>
                        </tr>
                        <tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='62883.Dil Tazminatı'>
                            </td>
                            <td style="text-align:right">#tlformat(get_personal_salary.language_allowance)#</td>
                            <td style="text-align:right">#tlformat(get_personal_debits.language_allowance)#</td>
                            <td style="text-align:right">#tlformat(abs(get_personal_salary.language_allowance - get_personal_debits.language_allowance))#</td>
                        </tr>
                        <tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='62936.Akademik Teşvik Ödeneği'>
                            </td>
                            <td style="text-align:right">#tlformat(get_personal_salary.academic_incentive_allowance_amount)#</td>
                            <td style="text-align:right">#tlformat(get_personal_debits.academic_incentive_allowance_amount)#</td>
                            <td style="text-align:right">#tlformat(abs(get_personal_salary.academic_incentive_allowance_amount - get_personal_debits.academic_incentive_allowance_amount))#</td>
                        </tr>
                        <tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='63280.Makam Tazminatı'>
                            </td>
                            <td style="text-align:right">#tlformat(get_personal_salary.executive_indicator_compensation)#</td>
                            <td style="text-align:right">#tlformat(get_personal_debits.executive_indicator_compensation)#</td>
                            <td style="text-align:right">#tlformat(abs(get_personal_salary.executive_indicator_compensation - get_personal_debits.executive_indicator_compensation))#</td>
                        </tr>
                        <tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='63281.İdari Görev Tazminatı'>
                            </td>
                            <td style="text-align:right">#TLFormat(get_personal_salary.administrative_duty_allowance)#</td>
                            <td style="text-align:right">#TLFormat(get_personal_debits.administrative_duty_allowance)#</td>
                            <td style="text-align:right">#TLFormat(abs(get_personal_salary.administrative_duty_allowance - get_personal_debits.administrative_duty_allowance))#</td>
                        </tr> 
						<cfif t_education_allowance gt 0>
							<tr>
								<td width="300px">
									<cf_get_lang dictionary_id='63282.Eğitim Öğretim Ödeneği'>
								</td>
								<td style="text-align:right">#TLFormat(get_personal_salary.education_allowance)#</td>
                                <td style="text-align:right">#TLFormat(get_personal_debits.education_allowance)#</td>
                                <td style="text-align:right">#TLFormat(abs(get_personal_salary.education_allowance - get_personal_debits.education_allowance))#</td>
							</tr>
						</cfif>

                        <tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='63283.Görev Tazminatı'>
                            </td>
                            <td style="text-align:right">#tlformat(get_personal_salary.administrative_compensation)#</td>
                            <td style="text-align:right">#tlformat(get_personal_debits.administrative_compensation)#</td>
                            <td style="text-align:right">#tlformat(abs(get_personal_salary.administrative_compensation - get_personal_debits.administrative_compensation))#</td>
                        </tr>
                        
                    </cfoutput>
                    <!------ All ---->
                    <cfset t_istisna_odenek = 0>
                    <cfset t_istisna_odenek_net = 0>
                    <cfoutput query="get_vergi_istisnas" group="COMMENT_PAY">
                        <cfset tmp_total = 0>
                        <cfset tmp_total2 = 0>
                        <cfoutput><!--- 20040824 ellemeyin yanlis kullanim degil --->
                            <cfif len(VERGI_ISTISNA_AMOUNT)>
                                <cfset tmp_total = tmp_total + VERGI_ISTISNA_AMOUNT>
                                <cfset t_istisna_odenek = t_istisna_odenek + VERGI_ISTISNA_AMOUNT>
                            </cfif>
                            <cfif len(VERGI_ISTISNA_TOTAL)>
                                <cfset tmp_total2 = tmp_total2 + VERGI_ISTISNA_TOTAL>
                                <cfset t_istisna_odenek_net = t_istisna_odenek_net + VERGI_ISTISNA_TOTAL>
                            </cfif>
                        </cfoutput>
                        <cfif tmp_total gt 0>
                            <tr>
                                <td width="300px">#comment_pay#</td>
                                <td style="text-align:right">#TLFormat(tmp_total)#
                                <cfif is_view_net eq 1>
									 (#TLFormat(tmp_total2)#)
                                </cfif>
								</td>
                            </tr>
                        </cfif>
                    </cfoutput>
                    <cfset genel_odenek_total = t_istisna_odenek>
                    <cfset genel_odenek_total_net = t_istisna_odenek_net>
                    <cfset odenek_say = 0>
                    <cfquery name="get_odeneks_" dbtype="query">
                        SELECT * FROM get_odeneks WHERE COMMENT_TYPE <> 2
                    </cfquery>
                    <cfoutput query="get_odeneks_" group="COMMENT_PAY">
                        <cfquery name="get_odenek_say" dbtype="query">
                            SELECT DISTINCT EMPLOYEE_PUANTAJ_ID FROM get_odeneks_ WHERE COMMENT_PAY = '#comment_pay#'
                        </cfquery>
                        <cfif get_odenek_say.recordcount><cfset odenek_say = get_odenek_say.recordcount></cfif>
                        <cfset tmp_total = 0>
                        <cfset amount_pay_total = 0>
                        <cfoutput>
                            <cfif listfindnocase('2,3,4',PAY_METHOD)>
                                <cfset tmp_total = tmp_total + amount_2>
                            <cfelse>
                                <cfset tmp_total = tmp_total + amount>
                            </cfif>
                            <cfif len(amount_pay)>
                                <cfset amount_pay_total = amount_pay_total+amount_pay>
                            </cfif>
                        </cfoutput>
                        <tr>
                            <td width="300px">#comment_pay# <cfif icmal_type is 'genel'>(#odenek_say#)</cfif></td>
                            <td style="text-align:right">#TLFormat(tmp_total)#</td>
                            <!--- <cfif is_view_net eq 1>
                                <td style="text-align:right">#TLFormat(amount_pay_total)#</td>
                            </cfif> --->
                        </tr>
                        <cfif not (len(is_income) and is_income eq 1)>
                            <cfset genel_odenek_total = genel_odenek_total + tmp_total>
                            <cfset genel_odenek_total_net = genel_odenek_total_net + amount_pay_total>
                        </cfif>
                    </cfoutput>
                    <!------ All ---->
                    <cfoutput>
                        <!--- <tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='31283.Ek Ödemeler'>
                            </td>
                            <td style="text-align:right">
                                
                                #tlformat(genel_odenek_total)#
                            </td>
                        </tr> --->
						<tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='63949.Ek Ödeme (666 KHK)'>
                            </td>
                            <td style="text-align:right">
                                #tlformat(get_personal_salary.additional_indicator_compensation)#
                            </td>
                            <td style="text-align:right">
                                #tlformat(get_personal_debits.additional_indicator_compensation)#
                            </td>
                            <td style="text-align:right">
                                #tlformat(abs(get_personal_salary.additional_indicator_compensation - get_personal_debits.additional_indicator_compensation))#
                            </td>
                        </tr>
						<!--- <tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='63949.Ek Ödeme (666 KHK)'>
                            </td>
                            <td style="text-align:right">
                                #tlformat(t_extra_pay)#
                            </td>
                        </tr> --->
                        <tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='62937.Yüksek Öğretim Tazminatı'>
                            </td>
                            <td style="text-align:right">#tlformat(get_personal_salary.high_education_compensation_payroll)#</td>
                            <td style="text-align:right">#tlformat(get_personal_debits.high_education_compensation_payroll)#</td>
                            <td style="text-align:right">#tlformat(abs(get_personal_salary.high_education_compensation_payroll - get_personal_debits.high_education_compensation_payroll))#</td>
                        </tr>
						<tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='64569.Arazi Tazminatı'>
                            </td>
                            <td style="text-align:right">#tlformat(get_personal_salary.land_compensation_amount)#</td>
                            <td style="text-align:right">#tlformat(get_personal_debits.land_compensation_amount)#</td>
                            <td style="text-align:right">#tlformat(abs(get_personal_salary.land_compensation_amount - get_personal_debits.land_compensation_amount))#</td>
                        </tr>
						<cfif t_audit_compensation_amount gt 0>
							<tr>
								<td width="300px">
									<cf_get_lang dictionary_id='64065.Denetim Tazminatı'>
								</td>
								<td style="text-align:right">#tlformat(get_personal_salary.audit_compensation_amount)#</td>
                                <td style="text-align:right">#tlformat(get_personal_debits.audit_compensation_amount)#</td>
                                <td style="text-align:right">#tlformat(abs(get_personal_salary.audit_compensation_amount - get_personal_debits.audit_compensation_amount))#</td>
							</tr>
						</cfif>
                        <tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='63284.Toplu Sözleşme İkramiyesi'>
                            </td>
                            <td style="text-align:right">#tlformat(get_personal_salary.collective_agreement_bonus)#</td>
                            <td style="text-align:right">#tlformat(get_personal_debits.collective_agreement_bonus)#</td>
                            <td style="text-align:right">#tlformat(abs(get_personal_salary.collective_agreement_bonus - get_personal_debits.collective_agreement_bonus))#</td>
                        </tr>
                        <tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='57492.Toplam'>
                            </td>
                            <cfset total_add_salary = get_personal_salary.salary + get_personal_salary.additional_indicators + get_personal_salary.TAX_MATRAH_EXEMPTION + get_personal_salary.university_allowance +
                                get_personal_salary.private_service_compensation + get_personal_salary.business_risk + get_personal_salary.family_assistance + get_personal_salary.child_assistance +
                                get_personal_salary.base_salary + get_personal_salary.severance_pension + get_personal_salary.language_allowance + get_personal_salary.academic_incentive_allowance_amount +
                                get_personal_salary.executive_indicator_compensation + get_personal_salary.administrative_duty_allowance + get_personal_salary.education_allowance + get_personal_salary.administrative_compensation + 
                                get_personal_salary.additional_indicator_compensation + get_personal_salary.high_education_compensation_payroll + get_personal_salary.land_compensation_amount +
                                get_personal_salary.audit_compensation_amount + get_personal_salary.collective_agreement_bonus>
                            <cfset total_add_debits = get_personal_debits.salary + get_personal_debits.additional_indicators + get_personal_debits.TAX_MATRAH_EXEMPTION + get_personal_debits.university_allowance +
                                get_personal_debits.private_service_compensation + get_personal_debits.business_risk + get_personal_debits.family_assistance + get_personal_debits.child_assistance +
                                get_personal_debits.base_salary + get_personal_debits.severance_pension + get_personal_debits.language_allowance + get_personal_debits.academic_incentive_allowance_amount +
                                get_personal_debits.executive_indicator_compensation + get_personal_debits.administrative_duty_allowance + get_personal_debits.education_allowance + get_personal_debits.administrative_compensation +
                                get_personal_debits.additional_indicator_compensation + get_personal_debits.high_education_compensation_payroll + get_personal_debits.land_compensation_amount +
                                get_personal_debits.audit_compensation_amount + get_personal_debits.collective_agreement_bonus>
                            <td style="text-align:right">#tlformat(total_add_salary)#</td>
                            <td style="text-align:right">#tlformat(total_add_debits)#</td>
                            <td style="text-align:right">
                                <cfset diff_salary = diff_salary + (total_add_salary - total_add_debits)>
                                #tlformat(abs(total_add_salary -total_add_debits) )#
                            </td>
                        </tr>
                    </cfoutput>
                </cf_grid_list>
            </div>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <cf_grid_list align="center">  
                    <cfoutput>
                        <tr class="bold">
                            <td colspan="4">
                                #ucase(getLang('','Tablo',43570))# 2 : #ucase(getLang('','Kesinti Yapılan Katkı Payları',65226))# (<cf_get_lang dictionary_id='44806.Devlet'>)
                            </td>
                        </tr>
                        <tr class="bold">
                            <td width="300px" class="bold">
                                #ucase(getLang('','Aylık Unsurlar',65222))#
                            </td>
                            <td>#ucase(getLang('','Tahakkuk Ettirilen',65223))#</td>
                            <td>#ucase(getLang('','Asıl Hakedişi',65224))#</td>
                            <td>#ucase(getLang('','Fark',58583))#</td>
                        </tr>
                        <cfif t_retirement_allowance_5510 gt 0>
							<tr>
								<td width="300px">
									<cf_get_lang dictionary_id='63273.Emekli Keseneği'> / <cf_get_lang dictionary_id='63844.Malul Yaşlı'>(<cf_get_lang dictionary_id='44806.Devlet'>) %11
								</td>
								<td style="text-align:right">#TLFormat(get_personal_salary.retirement_allowance_5510)#</td>
                                <td style="text-align:right">#TLFormat(get_personal_debits.retirement_allowance_5510)#</td>
                                <td style="text-align:right">#TLFormat(abs(get_personal_salary.retirement_allowance_5510 - get_personal_debits.retirement_allowance_5510))#</td>
							</tr> 
						</cfif>
						<cfif t_retirement_allowance gt 0>
							<tr>
								<td width="300px">
									<cf_get_lang dictionary_id='63273.Emekli Keseneği'> <cf_get_lang dictionary_id='44806.Devlet'> %20
								</td>
								<td style="text-align:right">#tlformat(get_personal_salary.retirement_allowance)#</td>
                                <td style="text-align:right">#tlformat(get_personal_debits.retirement_allowance)#</td>
                                <td style="text-align:right">#tlformat(abs(get_personal_salary.retirement_allowance - get_personal_debits.retirement_allowance))#</td>
							</tr>
						</cfif>
                       
                        <cfif t_health_insurance_premium_5510 gt 0 or (GET_PUANTAJ_PERSONAL.is_veteran eq 1 and t_health_insurance_premium_5510 eq 0)>
							<tr>
								<td width="300px">
									<cf_get_lang dictionary_id='63279.Sağlık Sigortası Primi'>(<cf_get_lang dictionary_id='44806.Devlet'>) 5510 %7.5
								</td>
								<td style="text-align:right">#TLFormat(get_personal_salary.health_insurance_premium_5510)#</td>
                                <td style="text-align:right">#TLFormat(get_personal_debits.health_insurance_premium_5510)#</td>
                                <td style="text-align:right">#TLFormat(abs(get_personal_salary.health_insurance_premium_5510 - get_personal_debits.health_insurance_premium_5510))#</td>
							</tr> 
						</cfif>
                        <tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='57492.Toplam'>
                            </td>
                            <cfset total_pay_salary = get_personal_salary.retirement_allowance_5510 + get_personal_salary.retirement_allowance + get_personal_salary.health_insurance_premium_5510>
                            <cfset total_pay_debits = get_personal_debits.retirement_allowance_5510 + get_personal_debits.retirement_allowance + get_personal_debits.health_insurance_premium_5510>
                            <td style="text-align:right">#tlformat(total_pay_salary)#</td>
                            <td style="text-align:right">#tlformat(total_pay_debits)#</td>
                            <td style="text-align:right">
                                #tlformat(abs(total_pay_salary - total_pay_debits) )#
                            </td>
                        </tr>
                        <!--- <cfif t_plus_retired gt 0>
							<tr>
								<td width="300px">
									<cf_get_lang dictionary_id='48315.Artış'> %100
								</td>
								<td style="text-align:right">#TLFormat(t_plus_retired)#</td>
							</tr> 
							<tr>
								<td width="300px">
									<cf_get_lang dictionary_id='29831.Kişi'> <cf_get_lang dictionary_id='44806.Devlet'> %100
								</td>
								<td style="text-align:right">#TLFormat(t_plus_retired_person)#</td>
							</tr> 
						</cfif> --->
                    </cfoutput>
                </cf_grid_list>
            </div>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <cf_grid_list align="center">  
                    <cfoutput>
                        <tr class="bold">
                            <td colspan="4">
                                #ucase(getLang('','Tablo',43570))# 3 : #ucase(getLang('','Kesinti Yapılan Katkı Payları',65226))# (<cf_get_lang dictionary_id='29831.Kişi'>)
                            </td>
                        </tr>
                        <tr class="bold">
                            <td width="300px" class="bold">
                                #ucase(getLang('','Aylık Unsurlar',65222))#
                            </td>
                            <td>#ucase(getLang('','Tahakkuk Ettirilen',65223))#</td>
                            <td>#ucase(getLang('','Asıl Hakedişi',65224))#</td>
                            <td>#ucase(getLang('','Fark',58583))#</td>
                        </tr>
                        <cfif t_retirement_allowance_personal_5510 gt 0>
							<tr>
								<td width="300px">
									<cf_get_lang dictionary_id='63273.Emekli Keseneği'> / <cf_get_lang dictionary_id='63844.Malul Yaşlı'>(<cf_get_lang dictionary_id='29831.Kişi'>) 5510 %9
								</td>
								<td style="text-align:right">#TLFormat(get_personal_salary.retirement_allowance_personal_5510)#</td>
                                <td style="text-align:right">#TLFormat(get_personal_debits.retirement_allowance_personal_5510)#</td>
                                <td style="text-align:right">#TLFormat(abs(get_personal_salary.retirement_allowance_personal_5510 - get_personal_debits.retirement_allowance_personal_5510))#</td>
							</tr> 
						</cfif>
						<cfif t_retirement_allowance_personal gt 0>
							<tr>
								<td width="300px">
									<cf_get_lang dictionary_id='63273.Emekli Keseneği'> <cf_get_lang dictionary_id='29831.Kişi'> %16
								</td>
								<td style="text-align:right">#tlformat(get_personal_salary.retirement_allowance_personal)#</td>
                                <td style="text-align:right">#tlformat(get_personal_debits.retirement_allowance_personal)#</td>
                                <td style="text-align:right">#tlformat(abs(get_personal_salary.retirement_allowance_personal - get_personal_debits.retirement_allowance_personal))#</td>
							</tr>
						</cfif>
						<cfif t_health_insurance_premium_personal_5510 gt 0>
							<tr>
								<td width="300px">
									<cf_get_lang dictionary_id='63279.Sağlık Sigortası Primi'>(<cf_get_lang dictionary_id='29831.Kişi'>) 5510 %5
								</td>
								<td style="text-align:right">#TLFormat(get_personal_salary.health_insurance_premium_personal_5510)#</td>
                                <td style="text-align:right">#TLFormat(get_personal_debits.health_insurance_premium_personal_5510)#</td>
                                <td style="text-align:right">#TLFormat(abs(get_personal_salary.health_insurance_premium_personal_5510 - get_personal_debits.health_insurance_premium_personal_5510))#</td>
							</tr> 
						</cfif>
                        <tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='57492.Toplam'>
                            </td>
                            <cfset total_pay_salary_person = get_personal_salary.health_insurance_premium_personal_5510 + get_personal_salary.retirement_allowance_personal + get_personal_salary.retirement_allowance_personal_5510>
                            <cfset total_pay_debits_person = get_personal_debits.health_insurance_premium_personal_5510 + get_personal_debits.retirement_allowance_personal + get_personal_debits.retirement_allowance_personal_5510>
                            <td style="text-align:right">#tlformat(total_pay_salary_person)#</td>
                            <td style="text-align:right">#tlformat(total_pay_debits_person)#</td>
                            <td style="text-align:right">
                                #tlformat(abs(total_pay_salary_person - total_pay_debits_person) )#
                                <cfset diff_salary = diff_salary + (total_pay_salary_person - total_pay_debits_person)>
                            </td>
                        </tr>
						<!--- <cfif t_general_health_insurance gt 0>
							<tr>
								<td width="300px">
									<cf_get_lang dictionary_id='53191.Genel Sağlık Sigortası'>
								</td>
								<td style="text-align:right">#tlformat(t_general_health_insurance)#</td>
							</tr>
						</cfif>
						<tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='53245.SGK Matrahı'>
                            </td>
                            <td style="text-align:right">#tlformat(t_sgk_base)#</td>
                        </tr> --->
                    </cfoutput>
                </cf_grid_list>
            </div>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <cf_grid_list align="center">  
                    <cfoutput>
                        <tr class="bold">
                            <td colspan="4">
                                #ucase(getLang('','Tablo',43570))# 4 : #ucase(getLang('','Yasal Kesintiler',59396))#
                            </td>
                        </tr>
                        <tr class="bold">
                            <td width="300px" class="bold">
                                #ucase(getLang('','Aylık Unsurlar',65222))#
                            </td>
                            <td>#ucase(getLang('','Tahakkuk Ettirilen',65223))#</td>
                            <td>#ucase(getLang('','Asıl Hakedişi',65224))#</td>
                            <td>#ucase(getLang('','Fark',58583))#</td>
                        </tr>
                        <tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='40452.Gelir vergisi'>
                            </td>
                            <td style="text-align:right">#TLFormat(get_personal_salary.gelir_vergisi)#</td>
                            <td style="text-align:right">#TLFormat(get_personal_debits.gelir_vergisi)#</td>
                            <td style="text-align:right">#TLFormat(abs(get_personal_salary.gelir_vergisi - get_personal_debits.gelir_vergisi))#</td>
                        </tr>
                        <tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='41439.Damga Vergisi'>
                            </td>
                            <td style="text-align:right">#TLFormat(get_personal_salary.damga_vergisi)#</td>
                            <td style="text-align:right">#TLFormat(get_personal_debits.damga_vergisi)#</td>
                            <td style="text-align:right">#TLFormat(abs(get_personal_salary.damga_vergisi - get_personal_debits.damga_vergisi))#</td>
                        </tr>
                        <tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='59344.Otomatik Bes'>
                            </td>
                            <td style="text-align:right">#tlformat(get_personal_salary.bes_isci_hissesi)#</td>
                            <td style="text-align:right">#tlformat(get_personal_debits.bes_isci_hissesi)#</td>
                            <td style="text-align:right">#tlformat(abs(get_personal_salary.bes_isci_hissesi - get_personal_debits.bes_isci_hissesi))#</td>
                        </tr> 
						<cfif t_penance_deduction gt 0>
							<tr>
								<td width="300px">
									<cf_get_lang dictionary_id='64057.Kefaret Kesintisi'>
								</td>
								<td style="text-align:right">#TLFormat(get_personal_salary.penance_deduction)#</td>
                                <td style="text-align:right">#TLFormat(get_personal_debits.penance_deduction)#</td>
                                <td style="text-align:right">#TLFormat(abs(get_personal_salary.penance_deduction - get_personal_debits.penance_deduction))#</td>
							</tr> 
						</cfif>
                    </cfoutput>
                    <!------ All ---->
                    <cfset t_istisna_kesinti = 0>
                    <cfoutput query="get_vergi_istisnas" group="COMMENT_PAY">
                        <cfset tmp_total = 0>
                        <cfoutput>
                            <cfif len(VERGI_ISTISNA_TOTAL)>
                                <cfset tmp_total = tmp_total + VERGI_ISTISNA_TOTAL>
                                <cfset t_istisna_kesinti = t_istisna_kesinti + VERGI_ISTISNA_TOTAL>
                            </cfif>
                        </cfoutput>
                        <cfif tmp_total gt 0>
                            <tr>
                                <td width="300px">#comment_pay#</td>
                                <td style="text-align:right">#TLFormat(tmp_total)#</td>
                            </tr>
                        </cfif>
                    </cfoutput>
                    <cfquery name="get_kesintis_" dbtype="query">
                        SELECT * FROM get_kesintis WHERE EMPLOYEE_PUANTAJ_ID = #get_personal_salary.employee_puantaj_id# or  EMPLOYEE_PUANTAJ_ID = #get_personal_debits.employee_puantaj_id# 
                    </cfquery>
                    <cfset pay_ = 0>
                    <cfset diff_ = 0>
                    <cfset pay_ext = 0>
                    <cfset diff_ext = 0>
                    <cfset pay_exe = 0>
                    <cfset diff_exe = 0>
                    <cfoutput query="get_kesintis_" group="COMMENT_PAY">
                        <cfquery name="get_kesinti_say" dbtype="query">
                            SELECT DISTINCT EMPLOYEE_PUANTAJ_ID FROM get_kesintis_ WHERE COMMENT_PAY = '#comment_pay#'
                        </cfquery>
                        <cfset tmp_total = 0>
                        <tr>	
                            <td width="300px">#comment_pay#</td>
                               
                                <cfoutput group="EMPLOYEE_PUANTAJ_ID" >
                                    <td style="text-align:right">
                                        <cfif ext_type eq 1>
                                            <cfif listfindnocase('2,3,4,5',PAY_METHOD)>
                                                <cfset tmp_total = amount_2>
                                            <cfelse>
                                                <cfset tmp_total = amount>
                                            </cfif>
                                        <cfelse> <!--- calisan icra kesintisinden geliyorsa--->
                                            <cfif listfindnocase('1',PAY_METHOD)>
                                                <cfset tmp_total = amount_2>
                                            <cfelse>
                                                <cfset tmp_total = amount>
                                            </cfif>
                                        </cfif>
                                        <cfif EMPLOYEE_PUANTAJ_ID eq get_personal_salary.employee_puantaj_id>
                                            <cfset pay_ = pay_ + tmp_total>
                                        <cfelse>
                                            <cfset diff_ = diff_ + tmp_total>
                                        </cfif>
                                       
                                        #tlformat(tmp_total)#
                                    </td>
                                </cfoutput>
                                <td style="text-align:right">
                                    #tlformat(abs(pay_ - diff_))#
                                </td>
                            </td>                           
                        </tr>
                    </cfoutput>
                    <cfif t_ozel_kesinti_2 gt 0>
                        <cfquery name="get_kesintis_brut_" dbtype="query">
                            SELECT * FROM get_kesintis_brut WHERE EMPLOYEE_PUANTAJ_ID = #get_personal_salary.employee_puantaj_id# or  EMPLOYEE_PUANTAJ_ID = #get_personal_debits.employee_puantaj_id# 
                        </cfquery>
                        <cfoutput query="get_kesintis_brut_" group="COMMENT_PAY">
                            <cfquery name="get_kesinti_say" dbtype="query">
                                SELECT DISTINCT EMPLOYEE_PUANTAJ_ID FROM get_kesintis_brut_ WHERE COMMENT_PAY = '#comment_pay#'
                            </cfquery>
                            <cfset tmp_total = 0>
                            <tr>	
                                <td width="300px">#comment_pay#</td>
                                <cfoutput group="EMPLOYEE_PUANTAJ_ID">
                                    <cfif ext_type eq 1>
                                        <cfif listfindnocase('2,3,4,5',PAY_METHOD)>
                                            <cfset tmp_total = amount_2>
                                        <cfelse>
                                            <cfset tmp_total = amount>
                                        </cfif>
                                    <cfelse> <!--- calisan icra kesintisinden geliyorsa--->
                                        <cfif listfindnocase('1',PAY_METHOD)>
                                            <cfset tmp_total = amount_2>
                                        <cfelse>
                                            <cfset tmp_total = amount>
                                        </cfif>
                                    </cfif>
                                    <cfif EMPLOYEE_PUANTAJ_ID eq get_personal_salary.employee_puantaj_id>
                                        <cfset pay_ext = pay_ext + tmp_total>
                                    <cfelse>
                                        <cfset diff_ext = diff_ext + tmp_total>
                                    </cfif>
                                    <td style="text-align:right">
                                        #tlformat(tmp_total)#
                                    </td>
                                </cfoutput>	
                                <td style="text-align:right">
                                    #tlformat(abs(pay_ext - diff_ext))#
                                </td>
                            </tr>							
                        </cfoutput>
                    </cfif>	
                    <cfquery name="get_vergi_istisnas_" dbtype="query">
                        SELECT * FROM get_vergi_istisnas WHERE EMPLOYEE_PUANTAJ_ID = #get_personal_salary.employee_puantaj_id# or  EMPLOYEE_PUANTAJ_ID = #get_personal_debits.employee_puantaj_id# 
                    </cfquery>
                    <cfoutput query="get_vergi_istisnas_" group="COMMENT_PAY">
                        <cfset tmp_total = 0>
                        <tr>
                            <td width="300px">#comment_pay#</td>
                            <cfoutput group="EMPLOYEE_PUANTAJ_ID">
                                <cfif PAY_METHOD eq 2>
                                    <cfset tmp_total = amount_2>
                                    <cfset t_istisna = amount_2>
                                <cfelse>
                                    <cfset tmp_total = amount>
                                    <cfset t_istisna =  amount>
                                </cfif>
                                <cfif EMPLOYEE_PUANTAJ_ID eq get_personal_salary.employee_puantaj_id>
                                    <cfset pay_exe = pay_exe + t_istisna>
                                <cfelse>
                                    <cfset diff_exe = diff_exe + t_istisna>
                                </cfif>
                                <td style="text-align:right">#TLFormat(tmp_total)#</td>
                            </cfoutput>
                            <td style="text-align:right">
                                #tlformat(abs(pay_exe - diff_exe))#
                            </td>
                        </tr>
                    </cfoutput>
                    <!------ All ---->
                    <cfoutput>
                        <tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='57492.Toplam'>
                            </td>
                            <cfset total_execution_salary = get_personal_salary.gelir_vergisi + get_personal_salary.damga_vergisi + get_personal_salary.bes_isci_hissesi + pay_ + pay_ext + pay_exe>
                            <cfset total_execution_debits = get_personal_debits.gelir_vergisi + get_personal_debits.damga_vergisi + get_personal_debits.bes_isci_hissesi + diff_ + diff_ext + diff_exe>
                            <td style="text-align:right">#tlformat(total_execution_salary)#</td>
                            <td style="text-align:right">#tlformat(total_execution_debits)#</td>
                            <td style="text-align:right">
                                #tlformat(abs(total_execution_salary - total_execution_debits) )#
                                <cfset diff_salary = diff_salary + (total_execution_salary - total_execution_debits)>
                            </td>
                        </tr>		
                    </cfoutput>
                </cf_grid_list>
            </div>
        </div>
        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <cf_grid_list align="center">  
                    <cfoutput>
                        <tr>
                            <cfif diff_salary gt 0>
                                <td width="300px"><cf_get_lang dictionary_id='65236.Kişiden Alınması Gereken Tutar'></td>
                                <td width="300px" style="text-align:right">#TLFormat(diff_salary)#</td>
                            <cfelse>
                                <td width="300px"><cf_get_lang dictionary_id='65299.Kişiye Verilmesi Gereken Tutar'></td>
                                <td width="300px" style="text-align:right">#TLFormat(abs(diff_salary))#</td>
                            </cfif>
                        </tr>
                    </cfoutput>
                </cf_grid_list>
            </div>
        </div>
        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <cf_grid_list align="center">  
                    <cfoutput>
                        <tr>
                            <td><cf_get_lang dictionary_id='64961.Gerçekleştirme Görevlisi'></td>
                            <td width="300px"><cf_get_lang dictionary_id='58180.Borçlu'></td>
                        </tr>
                        <tr>
                            <td width="300px"></td>
                            <td width="300px">#employee_name# #employee_surname#</td>
                        </tr>
                    </cfoutput>
                </cf_grid_list>
            </div>
        </div>
    </div>
	<cfif icmal_type is 'personal' and listFirst(attributes.fuseaction,".") is 'myhome'>
		<div class="col col-2">
			<ul class="ui-list padding-top-20">
				<li class="bold mb-0">
					<cf_get_lang dictionary_id ='31779.Puantaj Hazırlandı'>
				</li>
				<li class="bold mb-0">
					<cf_get_lang dictionary_id ='31780.Bordro Okundu'><cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>
				</li>
				<cfquery name="get_apply_status" datasource="#dsn#">
					SELECT 
						APPLY_DATE,
						ROW_ID
					FROM 
						EMPLOYEES_PUANTAJ_MAILS 
					WHERE 
						EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.employee_id#"> AND
						BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.branch_id#"> AND 
						SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.sal_mon#"> AND 
						SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.sal_year#">
				</cfquery>	
				<cfif get_apply_status.recordcount>
					<li class="bold mb-0">
						<p id="bordro_onay_td">
							<cfif len(get_apply_status.apply_date)>
								Bordro Onaylandı <cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>
							<cfelse>
								<span class="btnPointer" class="btnPointer" onclick="bordro_onayla('<cfoutput>#get_apply_status.ROW_ID#</cfoutput>');">Bordro Onayla</span>
							</cfif>
						</p>
					</li>
				</cfif>
				<cfoutput>
					<cfif get_protests.recordcount>
						<li class="bold mb-0">
							<span class="btnPointer" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_bordro_protests&sal_mon=#attributes.sal_mon#&sal_year=#attributes.sal_year#&emp_puantaj_id=#GET_PUANTAJ_PERSONAL.EMPLOYEE_PUANTAJ_ID#&puantaj_id=#GET_PUANTAJ_PERSONAL.PUANTAJ_ID#','list');"><cf_get_lang dictionary_id ='31784.İtirazlarım'></span>
						</li>
					</cfif>
					<cfif get_protests.recordcount and len(get_protests.answer_date)>
						<li class="bold mb-0">
							<span class="btnPointer" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_bordro_protests&sal_mon=#attributes.sal_mon#&sal_year=#attributes.sal_year#&emp_puantaj_id=#GET_PUANTAJ_PERSONAL.EMPLOYEE_PUANTAJ_ID#&puantaj_id=#GET_PUANTAJ_PERSONAL.PUANTAJ_ID#','list');"><cf_get_lang dictionary_id ='31785.İtirazlara Cevaplar'></span>
						</li>
					</cfif>
					<cfif not get_protests.recordcount>
						<li class="bold mb-0">
							<span class="btnPointer" onclick="windowopen('#request.self#?fuseaction=myhome.popup_add_puantaj_protest&sal_mon=#attributes.sal_mon#&sal_year=#attributes.sal_year#&emp_puantaj_id=#GET_PUANTAJ_PERSONAL.EMPLOYEE_PUANTAJ_ID#&puantaj_id=#GET_PUANTAJ_PERSONAL.PUANTAJ_ID#&branch_id=#GET_PUANTAJ_PERSONAL.branch_id#','small');"><cf_get_lang dictionary_id ='31715.İtiraz Et'></span>
						</li>
					</cfif>
				</cfoutput>
			</ul>
		</div>
	</cfif>
</cf_box>

<cf_get_lang_set module_name="#fusebox.circuit#">
	<script type="text/javascript">
		function bordro_onayla(row_id)
		{
			$.ajax({                
					url: '<cfoutput>#request.self#?fuseaction=myhome.emptypopup_apply_puantaj&row_id=</cfoutput>'+row_id,
					type: "GET",
					success: function (returnData) {
						document.getElementById('bordro_onay_td').innerHTML = 'Bordro Onaylandı <cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>';
					}
					
				});
		}
	</script>