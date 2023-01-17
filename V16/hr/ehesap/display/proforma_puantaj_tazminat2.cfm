<cfsetting showdebugoutput="no">
<cfset start_hour = '00'>
<cfset start_min = '00'>
<cfset finish_hour = '00'>
<cfset finish_min = '00'>

<cfset p_baslangic = createodbcdatetime(createdatetime(attributes.sal_year,attributes.sal_mon,1))>
<cfset aydaki_gun_sayisi = daysinmonth(p_baslangic)>
<cfset p_bitis = createodbcdatetime(createdatetime(attributes.sal_year,attributes.sal_mon,aydaki_gun_sayisi))>

<cfparam name="attributes.gun_say" default="365">
<cfparam name="attributes.finish_date" default="#dateformat(now(),'dd/mm/yyyy')#">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_name" default="">
<cfquery name="GET_GENERAL_OFFTIMES" datasource="#dsn#">
	SELECT * FROM SETUP_GENERAL_OFFTIMES
</cfquery>
<cfset offday_list = ''>
<cfset halfofftime_list = ''><!--- yarım gunluk izin kayıtları--->
<cfset halfofftime_list2 = ''>
<cfoutput query="GET_GENERAL_OFFTIMES">
	<cfscript>
		offday_gun = datediff('d',GET_GENERAL_OFFTIMES.start_date,GET_GENERAL_OFFTIMES.finish_date)+1;
		offday_startdate = date_add("h", session.ep.time_zone, GET_GENERAL_OFFTIMES.start_date); 
		offday_finishdate = date_add("h", session.ep.time_zone, GET_GENERAL_OFFTIMES.finish_date);
		
		for (mck=0; mck lt offday_gun; mck=mck+1)
		{
			temp_izin_gunu = date_add("d",mck,offday_startdate);
			daycode = '#dateformat(temp_izin_gunu,'dd/mm/yyyy')#';
			if(not listfindnocase(offday_list,'#daycode#'))
				offday_list = listappend(offday_list,'#daycode#');
			if(GET_GENERAL_OFFTIMES.is_halfofftime is 1 and dayofweek(temp_izin_gunu) neq 1) //pazar haricindeki yarım günlük izin günleri sayılsın
			{
				halfofftime_list = listappend(halfofftime_list,'#daycode#');
			}
		}
	</cfscript>
</cfoutput>
<cfquery name="get_progress_payment_outs" datasource="#dsn#">
	SELECT EMP_ID,START_DATE,FINISH_DATE,PROGRESS_TIME,IS_KIDEM,IS_YEARLY FROM EMPLOYEE_PROGRESS_PAYMENT_OUT
</cfquery>
<cfquery name="get_offtime_limits" datasource="#dsn#">
	SELECT 
		LIMIT_ID,
		<cfloop from="1" to="5" index="i">
		LIMIT_#i#,
		LIMIT_#i#_DAYS,
		</cfloop> 
		MIN_YEARS,
		MAX_YEARS,
		MIN_MAX_DAYS,
		SATURDAY_ON,
		DAY_CONTROL,
		STARTDATE,
		FINISHDATE
	FROM 
		SETUP_OFFTIME_LIMIT
</cfquery>


<cfquery name="get_hours" datasource="#dsn#">
	SELECT		
		OUR_COMPANY_HOURS.WEEKLY_OFFDAY
	FROM
		OUR_COMPANY_HOURS
	WHERE
		OUR_COMPANY_HOURS.DAILY_WORK_HOURS > 0 AND
		OUR_COMPANY_HOURS.SSK_MONTHLY_WORK_HOURS > 0 AND
		OUR_COMPANY_HOURS.SSK_WORK_HOURS > 0 AND
		OUR_COMPANY_HOURS.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>

<cfset ay_listesi ="Ocak,Şubat,Mart,Nisan,Mayıs,Haziran,Temmuz,Ağustos,Eylül,Ekim,Kasım,Aralık">

<cfscript>
	get_days = createObject("component","V16.hr.ehesap.cfc.proforma_puantaj");
	get_days.dsn = dsn;
	get_days.ssk_office = attributes.ssk_office;
	get_days.sal_year = attributes.sal_year;
	get_days.sal_mon = attributes.sal_mon;
	
	get_emps = get_days.get_emps();
</cfscript>

<cfif not get_emps.recordcount>
	<cfexit method="exittemplate">
</cfif>

<cfset puantaj_gun_ = day(attributes.finish_date)>
<cfset puantaj_start_ = p_baslangic>
<cfset puantaj_finish_ = p_bitis>
<cfset my_baz_date = puantaj_finish_>
<cfset attributes.months = attributes.sal_mon>
<cfset attributes.years = attributes.sal_year>
<cfquery name="get_seniority_comp_max" datasource="#dsn#">
	SELECT ISNULL(SENIORITY_COMPANSATION_MAX,0) AS SENIORITY_COMPANSATION_MAX FROM INSURANCE_PAYMENT WHERE STARTDATE <= #puantaj_start_#  AND FINISHDATE >= #puantaj_start_#
</cfquery>
<cfset kidem_max = get_seniority_comp_max.seniority_compansation_max>

<cfif isdefined("attributes.out_date") and len(attributes.out_date) and isdate(attributes.out_date)>
	<cf_date tarih='attributes.out_date'>
<cfelse>
	<cfset attributes.out_date = puantaj_finish_>
</cfif>

<cf_grid_list>
	<thead>
		<tr>
			<th style="width:20px;text-align:center;font-weight:bold;"><cf_get_lang dictionary_id='58577.Sıra'></th>
			<th style="text-align:center;font-weight:bold;"><cf_get_lang dictionary_id='58025.TC Kimlik No'></th>
			<th style="text-align:center;font-weight:bold;"><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
            <th style="text-align:center;font-weight:bold;"><cf_get_lang dictionary_id='55738.Gruba Giriş'></th>
            <th style="text-align:center;font-weight:bold;"><cf_get_lang dictionary_id='44255.İzin Baz Tarihi'></th>
            <th style="text-align:center;font-weight:bold;"><cf_get_lang dictionary_id='53261.Kıdem Baz'></th>
            <th style="text-align:center;font-weight:bold;" nowrap="nowrap">
            	<cf_get_lang dictionary_id='29438.Çıkış Tarihi'> (<cfoutput>#dateformat(attributes.out_date,'dd/mm/yyyy')#</cfoutput>)
            </th>
            <th style="text-align:center;font-weight:bold;"><cf_get_lang dictionary_id='58727.Doğum Tarihi'></th>
            
            <th style="text-align:center;font-weight:bold;"><cf_get_lang dictionary_id='64899.Ücret Maaş'></th>
            <th style="text-align:center;font-weight:bold;"><cf_get_lang dictionary_id='45778.Yemek'></th>
            <th style="text-align:center;font-weight:bold;"><cf_get_lang dictionary_id='56249.Ek Ödenek'></th>
            <th></th>
            
            <th style="text-align:center;font-weight:bold;"><cf_get_lang dictionary_id='39388.Kıdem Günü'></th>
            <th style="text-align:center;font-weight:bold;"><cf_get_lang dictionary_id='64885.Kıdem Brüt'></th>
            <th style="text-align:center;font-weight:bold;"><cf_get_lang dictionary_id='64900.Kıdem Damga'></th>
            <th style="text-align:center;font-weight:bold;"><cf_get_lang dictionary_id='64887.Kıdem Net'></th>
            <th></th>
            
            <th style="text-align:center;font-weight:bold;"><cf_get_lang dictionary_id='39406.İhbar Günü'></th>
            <th style="text-align:center;font-weight:bold;"><cf_get_lang dictionary_id='64888.İhbar Brüt'></th>
            <th style="text-align:center;font-weight:bold;"><cf_get_lang dictionary_id='64889.İhbar Damga V.'></th>
            <th style="text-align:center;font-weight:bold;"><cf_get_lang dictionary_id='64890.İhbar Gelir V.'></th>
            <th style="text-align:center;font-weight:bold;"><cf_get_lang dictionary_id='64891.İhbar Net'></th>
            <th></th>
            
            <th style="text-align:center;font-weight:bold;"><cf_get_lang dictionary_id='53803.Yıllık İzin Günü'></th>
            <th style="text-align:center;font-weight:bold;"><cf_get_lang dictionary_id='64892.Yıllık İzin Brüt'></th>
            <th style="text-align:center;font-weight:bold;"><cf_get_lang dictionary_id='64893.Yıllık İzin Damga V.'></th>
            <th style="text-align:center;font-weight:bold;"><cf_get_lang dictionary_id='64894.Yıllık İzin Gelir V.'></th>
            <th style="text-align:center;font-weight:bold;"><cf_get_lang dictionary_id='64901.Yıllık İzin SGK'></th>
            <th style="text-align:center;font-weight:bold;"><cf_get_lang dictionary_id='64902.Yıllık İzin İşsizlik'></th>
			
			<th style="text-align:center;font-weight:bold;"><cf_get_lang dictionary_id='64903.Yıllık İzin SGK İşveren'></th>
            <th style="text-align:center;font-weight:bold;"><cf_get_lang dictionary_id='64902.Yıllık İzin İşsizlik'><cf_get_lang dictionary_id='56406.İşveren'></th>
			
            <th style="text-align:center;font-weight:bold;"><cf_get_lang dictionary_id='64897.Yıllık İzin Net'></th>
			
			<th style="text-align:center;font-weight:bold;"><cf_get_lang dictionary_id='64904.Yıllık İzin Maliyet'></th>
        </tr>
	</thead>
	<tbody>
     <cfscript>
		t_salary = 0;
		t_yemek = 0;
		t_kidem_dahil_odenek = 0;
		t_kidem_gunu = 0;
		t_kidem_amount = 0;
		t_kidem_damga = 0;
		t_kidem_net = 0;
		t_ihbar_days = 0;
		t_ihbar_amount = 0;
		t_ihbar_damga_vergisi = 0;
		t_ihbar_gelir_vergisi = 0;
		t_ihbar_net = 0;
		t_izin_gun = 0;
		t_yillik_izin_amount = 0;
		t_yillik_izin_damga_vergisi = 0;
		t_yillik_izin_gelir_vergisi = 0;
		t_yillik_izin_sgk = 0;
		t_yillik_izin_issizlik = 0;
		t_yillik_izin_net = 0;
		
		t_yillik_izin_sgk_isveren = 0;
		t_yillik_izin_issizlik_isveren = 0;
	</cfscript>
	<cfset gun_toplam = 0>
	<cfoutput query="get_emps">
		<cfset employee_id_ = get_emps.employee_id>
        <cfset GROSS_NET_ = GROSS_NET>
        <cfset salary_type_ = salary_type>
        <cfset this_in_out_ = IN_OUT_ID>
        <cfset this_duty_ = DUTY_TYPE>
        
        <cfset yemek_tutar = 0>
        
        <cfset this_ssk_office_ = SSK_OFFICE>
        <cfset this_ssk_no_ = SSK_NO>
        
        <cfinclude template="proforma_puantaj_tazminat_calc.cfm">
        
		<cfif year(start_date) eq year(p_baslangic) and month(start_date) eq month(p_baslangic)>
			<cfset kisi_start = start_date>
			<cfset bu_ay_basladi = 1>
		<cfelse>
			<cfset kisi_start = p_baslangic>
			<cfset bu_ay_basladi = 0>
		</cfif>
		<cfif len(FINISH_DATE) and year(FINISH_DATE) eq year(p_bitis) and month(FINISH_DATE) eq month(p_bitis)>
			<cfset kisi_finish= FINISH_DATE>
			<cfset bu_ay_cikti = 1>
		<cfelse>
			<cfset kisi_finish = p_bitis>
			<cfset bu_ay_cikti = 0>
		</cfif>
		<cfset calisma_gun_sayisi = datediff('d',kisi_start,kisi_finish)+1>

		<cfset reel_calisma_gun_sayisi = datediff('d',kisi_start,kisi_finish)+1>
		
		<cfif isdefined("kisi_ucretsiz_total_#employee_id#")>
			<cfset calisma_gun_sayisi = calisma_gun_sayisi - evaluate("kisi_ucretsiz_total_#employee_id#")>
		</cfif>
        
        <cfif isdefined("kisi_gun_ek_#employee_id#")>
        	<cfset calisma_gun_sayisi = calisma_gun_sayisi + evaluate("kisi_gun_ek_#employee_id#")>
        </cfif>
		
		<cfif calisma_gun_sayisi gt 30>
			<cfset calisma_gun_sayisi = 30>
		</cfif>
		<cfset gun_toplam = gun_toplam + calisma_gun_sayisi>
        
        <cfif kidem_amount gt 0>
        	<cfset kidem_damga = wrk_round(kidem_amount * 7.59 /1000)>
            <cfset kidem_net = wrk_round(kidem_amount - kidem_damga)>
        <cfelse>
        	<cfset kidem_damga = 0>
            <cfset kidem_net = 0>
        </cfif>
		
        <cfif ihbar_amount gt 0>
        	<cfset ihbar_damga_vergisi = wrk_round(ihbar_amount * 7.59 /1000)>
            <cfset ihbar_gelir_vergisi = wrk_round(ihbar_amount * 15 / 100)>
			<cfset ihbar_net = wrk_round(ihbar_amount - ihbar_gelir_vergisi - ihbar_damga_vergisi)>
        <cfelse>
        	<cfset ihbar_damga_vergisi = 0>
            <cfset ihbar_gelir_vergisi = 0>
			<cfset ihbar_net = 0>
        </cfif>
        
        <cfif yillik_izin_amount gt 0>
        	<cfset yillik_izin_damga_vergisi = wrk_round(yillik_izin_amount * 7.59 /1000)>
            <cfset yillik_izin_sgk = wrk_round(yillik_izin_amount * 14 / 100)>
            <cfset yillik_izin_issizlik = wrk_round(yillik_izin_amount * 1 / 100)>
            <cfset yillik_izin_gelir_vergisi = wrk_round((yillik_izin_amount - yillik_izin_issizlik - yillik_izin_sgk) * 15 / 100)>
			<cfset yillik_izin_net = wrk_round(yillik_izin_amount - yillik_izin_sgk - yillik_izin_damga_vergisi - yillik_izin_issizlik - yillik_izin_gelir_vergisi)>
			
			<cfset yillik_izin_sgk_isveren = wrk_round(yillik_izin_amount * 15.5 / 100)>
            <cfset yillik_izin_issizlik_isveren = wrk_round(yillik_izin_amount * 2 / 100)>
        <cfelse>
        	<cfset yillik_izin_damga_vergisi = 0>
            <cfset yillik_izin_sgk = 0>
            <cfset yillik_izin_issizlik = 0>
            <cfset yillik_izin_gelir_vergisi = 0>
			<cfset yillik_izin_net = 0>
			
			<cfset yillik_izin_sgk_isveren = 0>
            <cfset yillik_izin_issizlik_isveren = 0>
        </cfif>
        
		<tr>
			<td>#currentrow#</td>
			<td>
            <cfif get_module_user(3)>
            	<a href="#request.self#?fuseaction=hr.form_upd_emp&employee_id=#employee_id#" target="hr_profil" class="tableyazi">#tc_identy_no#</a>
            <cfelse>
            	#tc_identy_no#
            </cfif>    
            </td>
			<td style="font-weight:bold;" nowrap="nowrap">
            <cfif get_module_user(48)>
            	<cfset add_adress_ = "#request.self#?fuseaction=ehesap.offtimes&event=add&is_request=0&project_id=#attributes.project_id#&employee_id=#employee_id_#&kalan_izin=0">
            <cfelse>
            	<cfset add_adress_ = "#request.self#?fuseaction=myhome.my_offtimes&event=add&is_request=0&project_id=#attributes.project_id#&employee_id=#employee_id_#&kalan_izin=0">
            </cfif>
            	<a href="javascript://" style="color:<cfif bu_ay_basladi eq 1>green<cfelseif bu_ay_cikti eq 1>red<cfelseif reel_calisma_gun_sayisi lt aydaki_gun_sayisi>blue</cfif>;" onclick="windowopen('#add_adress_#','medium');" class="tableyazi">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a>
            	<cfif DUTY_TYPE eq 6>(<cf_get_lang dictionary_id='55896.Kısmi İstihdam'>)</cfif>
				<cfif SSK_STATUTE eq 2>(<cf_get_lang dictionary_id='58541.Emekli'>)</cfif>
                <cfif SSK_STATUTE eq 18>(Yeraltı Emekli)</cfif><!---Muzaffer Köse yeraltı Emekli--->
            </td>
            <td>#dateformat(GROUP_STARTDATE,'dd/mm/yyyy')#</td>
            <td>#dateformat(IZIN_DATE,'dd/mm/yyyy')#</td>
            <td>#dateformat(KIDEM_DATE,'dd/mm/yyyy')#</td>
            <td>#dateformat(attributes.finishdate,'dd/mm/yyyy')#</td>
            <td>#dateformat(BIRTH_DATE,'dd/mm/yyyy')#</td>
            
            <td style="text-align:center;">#tlformat(salary)#</td>
            <td style="text-align:center;">#tlformat(yemek_tutar)#</td>
            <td style="text-align:center;">#tlformat(kidem_dahil_odenek)#</td>
            <td></td>
            
            <td style="text-align:center;">#tlformat((total_ssk_days-paid_kidem_days),0)#</td>
            <td style="text-align:center;">#tlformat(kidem_amount)#</td>
            <td style="text-align:center;">#tlformat(kidem_damga)#</td>
            <td style="text-align:center;">#tlformat(kidem_net)#</td>
            <td></td>
            
            <td style="text-align:center;">#tlformat(ihbar_days,0)#</td>
            <td style="text-align:center;">#tlformat(ihbar_amount)#</td>
            <td style="text-align:center;">#tlformat(ihbar_damga_vergisi)#</td>
            <td style="text-align:center;">#tlformat(ihbar_gelir_vergisi)#</td>
            <td style="text-align:center;">#tlformat(ihbar_net)#</td>
            <td></td>
            
            <td style="text-align:center;">#tlformat((toplam_hakedilen_izin - genel_izin_toplam - old_izin_days_),0)#</td>
            <td style="text-align:center;">#tlformat(yillik_izin_amount)#</td>
            <td style="text-align:center;">#tlformat(yillik_izin_damga_vergisi)#</td>
            <td style="text-align:center;">#tlformat(yillik_izin_gelir_vergisi)#</td>
            <td style="text-align:center;">#tlformat(yillik_izin_sgk)#</td>
            <td style="text-align:center;">#tlformat(yillik_izin_issizlik)#</td>
			
			<td style="text-align:center;">#tlformat(yillik_izin_sgk_isveren)#</td>
            <td style="text-align:center;">#tlformat(yillik_izin_issizlik_isveren)#</td>
			
            <td style="text-align:center; background-color:##61D89F;">#tlformat(yillik_izin_net)#</td>
			
			<td style="text-align:center; background-color:##cfcfcf;">#tlformat(yillik_izin_amount + yillik_izin_sgk_isveren + yillik_izin_issizlik_isveren)#</td>
		</tr>
        <cfscript>
			t_salary = t_salary + salary;
			t_yemek = t_yemek + yemek_tutar;
			t_kidem_dahil_odenek = t_kidem_dahil_odenek + kidem_dahil_odenek;
			t_kidem_gunu = t_kidem_gunu + (total_ssk_days-paid_kidem_days);
			t_kidem_amount = t_kidem_amount + kidem_amount;
			t_kidem_damga = t_kidem_damga + kidem_damga;
			t_kidem_net = t_kidem_net + kidem_net;
			t_ihbar_days = t_ihbar_days + ihbar_days;
			t_ihbar_amount = t_ihbar_amount + ihbar_amount;
			t_ihbar_damga_vergisi = t_ihbar_damga_vergisi + ihbar_damga_vergisi;
			t_ihbar_gelir_vergisi = t_ihbar_gelir_vergisi + ihbar_gelir_vergisi;
			t_ihbar_net = t_ihbar_net + ihbar_net;
			t_izin_gun = t_izin_gun + (toplam_hakedilen_izin - genel_izin_toplam - old_izin_days_);
			t_yillik_izin_amount = t_yillik_izin_amount + yillik_izin_amount;
			t_yillik_izin_damga_vergisi = t_yillik_izin_damga_vergisi + yillik_izin_damga_vergisi;
			t_yillik_izin_gelir_vergisi = t_yillik_izin_gelir_vergisi + yillik_izin_gelir_vergisi;
			t_yillik_izin_sgk = t_yillik_izin_sgk + yillik_izin_sgk;
			t_yillik_izin_issizlik = t_yillik_izin_issizlik + yillik_izin_issizlik;
			t_yillik_izin_net = t_yillik_izin_net + yillik_izin_net;
			
			t_yillik_izin_sgk_isveren = t_yillik_izin_sgk_isveren + yillik_izin_sgk_isveren;
			t_yillik_izin_issizlik_isveren = t_yillik_izin_issizlik_isveren + yillik_izin_issizlik_isveren;
		</cfscript>
	</cfoutput>
	</tbody>
	<tfoot>
	<cfoutput>
		<tfoot>
			<tr>
				<td colspan="2" class="formbold" style="text-align:right;"><cf_get_lang dictionary_id='53263.Toplamlar'></td>
				<td style="text-align:center;" class="formbold">#get_emps.recordcount# <cf_get_lang dictionary_id='29831.Kişi'></td>
				<td style="text-align:center;">&nbsp;</td>
				<td style="text-align:center;">&nbsp;</td>
				<td style="text-align:center;">&nbsp;</td>
				<td style="text-align:center;">&nbsp;</td>
				<td style="text-align:center;">&nbsp;</td>
				
				<td style="text-align:center;">#tlformat(t_salary)#</td>
				<td style="text-align:center;">#tlformat(t_yemek)#</td>
				<td style="text-align:center;">#tlformat(t_kidem_dahil_odenek)#</td>
				<td></td>
				
				<td style="text-align:center;">#tlformat(t_kidem_gunu,0)#</td>
				<td style="text-align:center;">#tlformat(t_kidem_amount)#</td>
				<td style="text-align:center;">#tlformat(t_kidem_damga)#</td>
				<td style="text-align:center;">#tlformat(t_kidem_net)#</td>
				<td></td>
				
				<td style="text-align:center;">#tlformat(t_ihbar_days,0)#</td>
				<td style="text-align:center;">#tlformat(t_ihbar_amount)#</td>
				<td style="text-align:center;">#tlformat(t_ihbar_damga_vergisi)#</td>
				<td style="text-align:center;">#tlformat(t_ihbar_gelir_vergisi)#</td>
				<td style="text-align:center;">#tlformat(t_ihbar_net)#</td>
				<td></td>
				
				<td style="text-align:center;">#tlformat(t_izin_gun,0)#</td>
				<td style="text-align:center;">#tlformat(t_yillik_izin_amount)#</td>
				<td style="text-align:center;">#tlformat(t_yillik_izin_damga_vergisi)#</td>
				<td style="text-align:center;">#tlformat(t_yillik_izin_gelir_vergisi)#</td>
				<td style="text-align:center;">#tlformat(t_yillik_izin_sgk)#</td>
				<td style="text-align:center;">#tlformat(t_yillik_izin_issizlik)#</td>
				
				<td style="text-align:center;">#tlformat(t_yillik_izin_sgk_isveren)#</td>
				<td style="text-align:center;">#tlformat(t_yillik_izin_issizlik_isveren)#</td>
				
				<td style="text-align:center; background-color:##61D89F;">#tlformat(t_yillik_izin_net)#</td>
				
				<td style="text-align:center; background-color:##cfcfcf;">#tlformat(t_yillik_izin_net + t_yillik_izin_sgk_isveren + t_yillik_izin_issizlik_isveren)#</td>
			</tr>
		</tfoot>
	</cfoutput>
	</tfoot>
</cf_grid_list>
