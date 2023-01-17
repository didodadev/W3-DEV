<cf_get_lang_set module_name="ehesap">
<cfparam name="attributes.is_virtual_puantaj" default="0">
<cfset main_puantaj_table = "EMPLOYEES_PUANTAJ">
<cfset row_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS">
<cfset add_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS_ADD">
<cfset maas_puantaj_table = "EMPLOYEES_SALARY">
<cfparam name="icmal_border" default="0">

<cfif not evaluate("#query_name#.recordcount")>
	<script type="text/javascript">
		alert("Kayıt bulunamadı!");
		history.back();
	</script>
	<cfexit method="exittemplate">
</cfif>
<cfscript>
	t_salary = 0;
	t_base_salary = 0;
	t_sgk_base = 0;

	//tutar toplamları
	t_normal_amount = 0;
	t_haftalik_tatil_amount = 0;
	t_offdays_amount = 0;
	
	t_reel_ssk_days = 0;
	t_ssdf_ssk_days = 0;
	t_ssk_matrahi = 0;
	t_devreden = 0;
	t_devirden_gelen = 0;
	t_toplam_kazanc = 0;
	t_vergi_iadesi = 0;
	t_vergi_iadesi_alan = 0;
	t_vergi_indirimi_5084 = 0;
	t_vergi_indirimi_5746_days = 0;
	t_vergi_indirimi_5746 = 0;
	t_vergi_indirimi_5746_all = 0;
	t_vergi_indirimi_4691 = 0;
	t_vergi_indirimi_4691_all = 0;
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
	t_ext_salary = 0;
	t_ssk_matrah_muafiyet = 0;
	t_vergi_matrah_muafiyet = 0;
	t_avans = 0;
	ssk_say = 0;

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
	t_extra_pay = 0;
	t_additional_score = 0;
	t_normal_additional_score = 0;
	t_audit_compensation_amount = 0;
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
<cfoutput query="#query_name#">
	<cfscript>
		//Aylık tutar
		t_salary = t_salary + salary;

		if(len(extra_pay))
			t_extra_pay = t_extra_pay + extra_pay; 

		if(len(NORMAL_ADDITIONAL_SCORE))
			t_normal_additional_score =  t_normal_additional_score + NORMAL_ADDITIONAL_SCORE;
		if(len(audit_compensation_amount))
			t_audit_compensation_amount = t_audit_compensation_amount + audit_compensation_amount;
			
		if(len(SSK_MATRAH_EXEMPTION))
			SSK_MATRAH_EXEMPTION_ = SSK_MATRAH_EXEMPTION;
		else
			SSK_MATRAH_EXEMPTION_ = 0;
		
		if(len(TAX_MATRAH_EXEMPTION))
			TAX_MATRAH_EXEMPTION_ = TAX_MATRAH_EXEMPTION;
		else
			TAX_MATRAH_EXEMPTION_ = 0;	
		if(len(ADDITIONAL_SCORE))
			t_additional_score =  t_additional_score + ADDITIONAL_SCORE;
		t_ssk_matrah_muafiyet = t_ssk_matrah_muafiyet + SSK_MATRAH_EXEMPTION_ + TOTAL_PAY + TOTAL_PAY_TAX;
		t_vergi_matrah_muafiyet = t_vergi_matrah_muafiyet + TAX_MATRAH_EXEMPTION_;
		
		if(len(VERGI_ISTISNA_TOTAL))
		t_vergi_istisna_net_yaz = t_vergi_istisna_net_yaz + VERGI_ISTISNA_TOTAL;
		
		t_vergi_istisna_tutar = t_vergi_istisna_tutar + VERGI_ISTISNA_DAMGA_NET;
		t_vergi_istisna_yaz = t_vergi_istisna_yaz + VERGI_ISTISNA_SSK + VERGI_ISTISNA_VERGI + VERGI_ISTISNA_DAMGA;
		t_toplam_kazanc = t_toplam_kazanc + TOTAL_SALARY;

		if(is_4691_control eq 0)
		{
			t_vergi_indirimi_4691_all = t_vergi_indirimi_4691_all + gelir_vergisi_indirimi_4691;
			t_vergi_indirimi_4691 = t_vergi_indirimi_4691 + gelir_vergisi_indirimi_4691;
		}
		
		if(IS_START_CUMULATIVE_TAX eq 1 and isnumeric(START_CUMULATIVE_TAX) /* and sal_year eq year(START_DATE) */)
			t_kum_gelir_vergisi = t_kum_gelir_vergisi + START_CUMULATIVE_TAX;
		//Ücret kartından Dönem Başı Kümüle Vergi Matrahı geliyorsa e bordroya yansıtılıyorsa
		if(len(CUMULATIVE_TAX_TOTAL) and  isnumeric(START_CUMULATIVE_TAX) /* and sal_year eq year(START_DATE) */)
			t_kum_gelir_vergisi_matrahi = t_kum_gelir_vergisi_matrahi + CUMULATIVE_TAX_TOTAL;
		t_gelir_vergisi_matrahi = t_gelir_vergisi_matrahi + gelir_vergisi_matrah;
		t_gelir_vergisi = t_gelir_vergisi + gelir_vergisi;
		t_damga_vergisi = t_damga_vergisi + damga_vergisi;
		
		t_kesinti = t_kesinti + ssk_isci_hissesi + ssdf_isci_hissesi + issizlik_isci_hissesi + damga_vergisi;
		t_net_ucret = t_net_ucret + net_ucret;
		t_vergi_iadesi = t_vergi_iadesi + vergi_iadesi;
		if(len(vergi_iadesi))
			t_vergi_iadesi_alan = t_vergi_iadesi_alan + 1;

	
		t_damga_vergisi_matrahi = t_damga_vergisi_matrahi + DAMGA_VERGISI_MATRAH ;

		
		ssk_devir_toplam = 0;
		if(len(ssk_devir))
		{
			ssk_devir_toplam = ssk_devir_toplam + ssk_devir;
			t_devirden_gelen = t_devirden_gelen + ssk_devir;
		}
		if(len(ssk_devir_last))
		{
			ssk_devir_toplam = ssk_devir_toplam + ssk_devir_last;
			t_devirden_gelen = t_devirden_gelen + ssk_devir_last;
		}

		
		t_total_pay_ssk_tax = t_total_pay_ssk_tax + total_pay_ssk_tax;
		t_total_pay_ssk = t_total_pay_ssk + total_pay_ssk;
		t_total_pay_tax = t_total_pay_tax + total_pay_tax;
		t_total_pay = t_total_pay + total_pay;
		
		if(len(ext_salary))
			t_ext_Salary = t_ext_Salary + ext_salary;

	</cfscript>
	<cfquery name="get_devreden" datasource="#dsn#">
		SELECT 
			AMOUNT 
		FROM 
			#add_puantaj_table# 
		WHERE 
			EMPLOYEE_PUANTAJ_ID = #EMPLOYEE_PUANTAJ_ID# AND 
			<cfif isdefined('attributes.sal_year_end') and len(attributes.sal_year_end) and isdefined('attributes.sal_mon_end') and len(attributes.sal_mon_end)>
				(
					(SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
					OR
					(
						SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
						SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
						(
							SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">
							OR
							(SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
						)
					)
					OR
					(
						SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
						(
							SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">
							OR
							(SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
						)
					)
					OR
					(
						SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> AND
						SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
						SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#">
					)
				)
			<cfelse>
				SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
				SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
			</cfif>
	</cfquery>
	<cfif get_devreden.recordcount>
		<cfset t_devreden = t_devreden + get_devreden.amount>
	</cfif>
</cfoutput>
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
                        <tr>
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
                        </tr>
                    </cfoutput>
                </cf_grid_list>
            </div>
        </div>
        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
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
                                <cf_get_lang dictionary_id='53249.Gelir Vergisi Matrahı'>
                            </td>
                            <td style="text-align:right">#tlformat(t_gelir_vergisi_matrahi)#</td>
                        </tr>
						<cfif get_puantaj_personal.STATUE_TYPE neq 9>
							<tr>
								<td width="300px">
									<cf_get_lang dictionary_id='53659.Asgari Geçim İndirimi'>
								</td>
								<td style="text-align:right">#TLFormat(t_vergi_iadesi)#</td>
							</tr>
						<cfelse>
							<tr>
								<td width="300px">
									<cf_get_lang dictionary_id='53570.Overtime - Hours'>
								</td>
								<td style="text-align:right">#ext_total_hours_0+ext_total_hours_1 +ext_total_hours_2 +ext_total_hours_5 #</td>
							</tr>
						</cfif>
                    </cfoutput>
                </cf_grid_list>         
            </div>
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cf_grid_list align="center">  
                    <cfoutput>
                        <tr>
                            <td width="300px">
                                <cfif get_puantaj_personal.STATUE_TYPE neq 9><cf_get_lang dictionary_id='63271.Sözleşme Tazminatı'><cfelse>&nbsp;</cfif>
                            </td>
                            <td style="text-align:right"><cfif get_puantaj_personal.STATUE_TYPE neq 9>?</cfif></td>
                        </tr>
                        <tr>
                            <td width="300px">&nbsp;
                            </td>
                            <td style="text-align:right"></td>
                        </tr>
                    </cfoutput>
                </cf_grid_list>         
            </div>
        </div>
        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cf_grid_list align="center">  
					<cfset t_istisna = 0>
					<!--- Toplam vergi indirimi --->
					<cfoutput query="get_vergi_istisnas" group="COMMENT_PAY">
						<cfset tmp_total = 0>
						<cfoutput>
							<cfif PAY_METHOD eq 2>
								<cfset tmp_total = tmp_total + amount_2>
								<cfset t_istisna = t_istisna + amount_2>
							<cfelse>
								<cfset tmp_total = tmp_total + amount>
								<cfset t_istisna = t_istisna + amount>
							</cfif>
						</cfoutput>
					</cfoutput>
                    <cfoutput>
						<cfif get_puantaj_personal.STATUE_TYPE neq 9 and get_puantaj_personal.STATUE_TYPE neq 10>
							<tr>
								<td width="300px">
									<cf_get_lang dictionary_id='63662.Aylık Tutar'>
								</td>
								<td style="text-align:right">#tlformat(t_salary)#</td>
							</tr>
						<cfelseif get_puantaj_personal.STATUE_TYPE neq 10>
							<tr>
								<td width="300px">
									<cf_get_lang dictionary_id='53718.Overtime Amount'>
								</td>
								<td style="text-align:right">#tlformat(t_ext_Salary)#</td>
							</tr>
						</cfif>
                        <tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='40452.Gelir vergisi'>
                            </td>
                            <td style="text-align:right">#TLFormat(t_gelir_vergisi)#</td>
                        </tr>
                        <tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='41439.Damga Vergisi'>
                            </td>
                            <td style="text-align:right">#TLFormat(t_damga_vergisi)#</td>
                        </tr> 
                    </cfoutput>
                </cf_grid_list>
            </div>
             <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cf_grid_list align="center">  
                    <cfoutput>
                        <tr>
                            <td width="300px"><cf_get_lang dictionary_id='63289.Hakedişler Toplamı'></td>
                            <td width="300px">#TLFormat(t_toplam_kazanc)#</td>
                        </tr>
                        <tr>
                            <td width="300px"><cf_get_lang dictionary_id='63290.Kesintiler Toplamı'></td>
                            <td width="300px">#TLFormat(t_toplam_kazanc - t_net_ucret)#</td>
                        </tr>
                    </cfoutput>
                </cf_grid_list>
            </div>
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cf_grid_list align="center">  
                    <cfoutput>
                        <tr>
                            <td width="300px"><cf_get_lang dictionary_id='40400.Net Ödeme'></td>
                            <td width="300px">#TLFormat(t_net_ucret)#</td>
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