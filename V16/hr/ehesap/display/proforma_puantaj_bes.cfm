<cfsetting showdebugoutput="no">

<cfset p_baslangic = createodbcdatetime(createdatetime(attributes.sal_year,attributes.sal_mon,1))>
<cfset aydaki_gun_sayisi = daysinmonth(p_baslangic)>
<cfset p_bitis = createodbcdatetime(createdatetime(attributes.sal_year,attributes.sal_mon,aydaki_gun_sayisi))>


<cfquery name="get_emp_bes" datasource="#dsn#">
	SELECT
		E.EMPLOYEE_ID,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		EIO.IN_OUT_ID,
		EIO.START_DATE,
		EIO.FINISH_DATE,
        EIO.DUTY_TYPE,
        EIO.SSK_STATUTE,
		SB.START_SAL_MON,
		SB.END_SAL_MON,
		SB.RATE_BES,
        EI.TC_IDENTY_NO
	FROM
		EMPLOYEES_IN_OUT EIO,
		EMPLOYEES_IDENTY EI,
		EMPLOYEES E,
		SALARYPARAM_BES SB
	WHERE
		EIO.IN_OUT_ID = SB.IN_OUT_ID AND
		SB.START_SAL_MON <= #attributes.sal_mon# AND 
		SB.END_SAL_MON >= #attributes.sal_mon# AND
		SB.TERM = #attributes.sal_year# AND
		EIO.BRANCH_ID = #attributes.ssk_office# AND
		EIO.START_DATE <= #p_bitis# AND
		(EIO.FINISH_DATE >= #p_baslangic# OR EIO.FINISH_DATE IS NULL) AND
		EI.EMPLOYEE_ID = E.EMPLOYEE_ID AND
		E.EMPLOYEE_ID = EIO.EMPLOYEE_ID
	ORDER BY
		E.EMPLOYEE_NAME ASC,
		E.EMPLOYEE_SURNAME ASC
</cfquery>

<cfif not get_emp_bes.recordcount>
	<cf_get_lang dictionary_id='33572.Çalışan bulunamadı'>!
	<cfexit method="exittemplate">
</cfif>
<cfset calisanlar = valuelist(get_emp_bes.EMPLOYEE_ID)>

<cf_ajax_list>
	<thead>
		<cfoutput>
        <tr>
			<th><cf_get_lang dictionary_id='58577.Sıra'></th>
			<th><cf_get_lang dictionary_id='58025.TC Kimlik No'></th>
			<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
			<th style="width:70px;"><cf_get_lang dictionary_id='53132.Başlangıç Ay'></th>
            <th style="width:50px;"><cf_get_lang dictionary_id='53133.Bitiş Ay'></th>
			<th style="text-align:right;"><cf_get_lang dictionary_id='45126.BES Oranı'></th>
		</tr>
        </cfoutput>
	</thead>
	<tbody>
	<cfset gun_toplam = 0>
    <cfset p_toplam = 0>
    <cfset e_toplam = 0>
    <cfset i_toplam = 0>
    <cfset a_toplam = 0>
	<cfoutput query="get_emp_bes">
		<cfset employee_id_ = employee_id>
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
		
		<cfif calisma_gun_sayisi eq 31>
			<cfset calisma_gun_sayisi = 30>
		</cfif>
		<cfset gun_toplam = gun_toplam + calisma_gun_sayisi>
		<tr class="color-row">
			<td>#currentrow#</td>
			<td>
            	<cfif listgetat(session.ep.user_level, 3)>
                    <a href="#request.self#?fuseaction=hr.form_upd_emp&employee_id=#employee_id#" target="hr_profil" class="tableyazi">#tc_identy_no#</a>
                <cfelse>
                    #tc_identy_no#
                </cfif>
            </td>
			<td style="font-weight:bold;color:<cfif bu_ay_basladi eq 1>green<cfelseif bu_ay_cikti eq 1>red<cfelseif reel_calisma_gun_sayisi lt aydaki_gun_sayisi>blue</cfif>;" nowrap="nowrap">
            	#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#
            	<cfif DUTY_TYPE eq 6>(<cf_get_lang dictionary_id='55896.Kısmi İstihdam'>)</cfif>
                <cfif SSK_STATUTE eq 2 or SSK_STATUTE eq 18>(<cf_get_lang dictionary_id='58541.Emekli'>)</cfif><!---Muzaffer Yeraltı Emeli--->
            </td>
			<td>#listgetat(ay_list(),START_SAL_MON)#</td>
			<td>#listgetat(ay_list(),END_SAL_MON)#</td>
			<td style="text-align:right;">%#TLFormat(rate_bes)#</td>
		</tr>
	</cfoutput>
	</tbody>
</cf_ajax_list>