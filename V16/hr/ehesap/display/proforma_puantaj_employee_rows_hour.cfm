<cfsetting showdebugoutput="no">

<cfset p_baslangic = createodbcdatetime(createdatetime(attributes.sal_year,attributes.sal_mon,1))>
<cfset aydaki_gun_sayisi = daysinmonth(p_baslangic)>
<cfset p_bitis = createodbcdatetime(createdatetime(attributes.sal_year,attributes.sal_mon,aydaki_gun_sayisi))>

<cfquery name="get_emps" datasource="#dsn#">
SELECT DISTINCT
	*
FROM
	(
	SELECT
		ISNULL((SELECT TOP 1 ES.M#MONTH(p_baslangic)# FROM EMPLOYEES_SALARY ES WHERE ES.PERIOD_YEAR = #YEAR(p_baslangic)# AND ES.EMPLOYEE_ID = E.EMPLOYEE_ID),0) AS MAAS,
        ISNULL((SELECT SUM(datediff(n,START_TIME,END_TIME)) FROM EMPLOYEES_EXT_WORKTIMES EEW WHERE YEAR(START_TIME) = #YEAR(p_baslangic)# AND MONTH(START_TIME) = #MONTH(p_baslangic)# AND EEW.EMPLOYEE_ID = E.EMPLOYEE_ID AND EEW.DAY_TYPE = 0 AND EEW.IS_PUANTAJ_OFF = 0),0) AS NORMAL_MESAI,
        ISNULL((SELECT SUM(datediff(n,START_TIME,END_TIME)) FROM EMPLOYEES_EXT_WORKTIMES EEW WHERE YEAR(START_TIME) = #YEAR(p_baslangic)# AND MONTH(START_TIME) = #MONTH(p_baslangic)# AND EEW.EMPLOYEE_ID = E.EMPLOYEE_ID AND EEW.DAY_TYPE = 2 AND EEW.IS_PUANTAJ_OFF = 0),0) AS RESMI_TATIL_MESAI,
        E.EMPLOYEE_ID,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		EIO.IN_OUT_ID,
		EIO.START_DATE,
		EIO.FINISH_DATE,
        EIO.DUTY_TYPE,
        EIO.SSK_STATUTE,
		EI.TC_IDENTY_NO
	FROM
		EMPLOYEES_IN_OUT EIO,
		EMPLOYEES_IDENTY EI,
		EMPLOYEES E
	WHERE
		EIO.BRANCH_ID = #attributes.ssk_office# AND
		EIO.START_DATE <= #p_bitis# AND
		(EIO.FINISH_DATE >= #p_baslangic# OR EIO.FINISH_DATE IS NULL) AND
		EI.EMPLOYEE_ID = E.EMPLOYEE_ID AND
		E.EMPLOYEE_ID = EIO.EMPLOYEE_ID
	) T1
ORDER BY
	EMPLOYEE_NAME ASC,
	EMPLOYEE_SURNAME ASC
</cfquery>


<cfif not get_emps.recordcount>
	Çalışan Bulunamadı!
	<cfexit method="exittemplate">
</cfif>
<cfset calisanlar = valuelist(get_emps.EMPLOYEE_ID)>

<cf_flat_list>
	<thead>
		<tr>
			<th style="width:20px;text-align:center;  color:black; font-weight:bold;"><cf_get_lang dictionary_id='58577.Sıra'></th>
			<th><cf_get_lang dictionary_id='58025.TC Kimlik No'></th>
			<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
			<th style="text-align:right;  color:black; font-weight:bold;"><cf_get_lang dictionary_id='53570.Fazla Mesai Saat'></th>
			<th style="text-align:right;  color:black; font-weight:bold;"><cf_get_lang dictionary_id='59208.Fazla Mesai'>(<cfoutput>#session.ep.money#</cfoutput>)</th>
			<th style="text-align:right;  color:black; font-weight:bold;"><cf_get_lang dictionary_id='64873.Resmi Tatil Saat'></th>
			<th style="text-align:right;  color:black; font-weight:bold;"><cf_get_lang dictionary_id='38246.Resmi Tatil'>(<cfoutput>#session.ep.money#</cfoutput>)</th>
			<th style="text-align:right;  color:black; font-weight:bold;"><cf_get_lang dictionary_id='59384.Fazla Mesai Toplamları'></th>
		</tr>
	</thead>
	<tbody>
	<cfset gun_toplam = 0>
    
    <cfset t_normal_mesai_saat = 0>
    <cfset t_normal_mesai_tutar = 0>
    
    <cfset t_resmi_mesai_saat = 0>
    <cfset t_resmi_mesai_tutar = 0>
    
    <cfset t_genel = 0>
    
	<cfoutput query="get_emps">
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
		
        <cfif NORMAL_MESAI gt 0>
        	<cfset normal_mesai_saat = NORMAL_MESAI/60>
            <cfset normal_mesai_tutar = MAAS / 225 * normal_mesai_saat * 1.5>
        <cfelse>
        	<cfset normal_mesai_saat = 0>
            <cfset normal_mesai_tutar = 0>
        </cfif>
        
        <cfif RESMI_TATIL_MESAI gt 0>
        	<cfset resmi_mesai_saat = RESMI_TATIL_MESAI/60>
            <cfset resmi_mesai_tutar = MAAS / 225 * resmi_mesai_saat * 1>
        <cfelse>
        	<cfset resmi_mesai_saat = 0>
            <cfset resmi_mesai_tutar = 0>
        </cfif>
        
        <cfset t_normal_mesai_saat = t_normal_mesai_saat + normal_mesai_saat>
		<cfset t_normal_mesai_tutar = t_normal_mesai_tutar + normal_mesai_tutar>
        
        <cfset t_resmi_mesai_saat = t_resmi_mesai_saat + resmi_mesai_saat>
        <cfset t_resmi_mesai_tutar = t_resmi_mesai_tutar + resmi_mesai_tutar>
        
        <cfset t_genel = t_genel + resmi_mesai_tutar + normal_mesai_tutar>
        
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
				<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=ehesap.list_ext_worktimes&event=add&in_out_id=#in_out_id#&employee_id=#employee_id#','medium');">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a>
				<cfif DUTY_TYPE eq 6>(<cf_get_lang dictionary_id='55896.Kısmi İstihdam'>)</cfif>
                 <cfif SSK_STATUTE eq 2 or SSK_STATUTE eq 18>(<cf_get_lang dictionary_id='58541.Emekli'>)</cfif><!---Muzaffer Yeraltı Emeli--->
            </td>
			<td style="text-align:right;"><cfif NORMAL_MESAI gt 0>#tlformat(normal_mesai_saat)#</cfif></td>
			<td style="text-align:right;"><cfif NORMAL_MESAI gt 0>#tlformat(normal_mesai_tutar)#</cfif></td>
			<td style="text-align:right;"><cfif RESMI_TATIL_MESAI gt 0>#tlformat(resmi_mesai_saat)#</cfif></td>
			<td style="text-align:right;"><cfif RESMI_TATIL_MESAI gt 0>#tlformat(resmi_mesai_tutar)#</cfif></td>
			<td style="text-align:right;">
			<cfif normal_mesai_tutar + resmi_mesai_tutar gt 0>
            	<a href="javascript://" <!--- onclick="windowopen('#request.self#?fuseaction=proforma.popup_manage_ext_worktimes&employee_id=#employee_id#&sal_mon=#month(p_baslangic)#&sal_year=#year(p_baslangic)#','list');" --->>#tlformat(resmi_mesai_tutar + normal_mesai_tutar)#</a>
            </cfif>
            </td>
		</tr>
	</cfoutput>
	</tbody>
	<tfoot>
	<cfoutput>
		<tr class="color-list">
			<td></td>
			<td class="formbold" ><cf_get_lang dictionary_id='53263.Toplamlar'></td>
			<td class="formbold">#get_emps.recordcount# <cf_get_lang dictionary_id='29831.Kişi'></td>
			<td style="text-align:right;" class="formbold">#tlformat(t_normal_mesai_saat)#</td>
			<td style="text-align:right;" class="formbold">#tlformat(t_normal_mesai_tutar)#</td>
			<td style="text-align:right;" class="formbold">#tlformat(t_resmi_mesai_saat)#</td>
			<td style="text-align:right;" class="formbold">#tlformat(t_resmi_mesai_tutar)#</td>
			<td style="text-align:right;" class="formbold">#tlformat(t_genel)#</td>
		</tr>
	</cfoutput>
	</tfoot>
</cf_flat_list>
<cf_box_footer>
	<input type="button" value="<cfoutput>#getLang('','Toplu Mesai Ekle','64874')#</cfoutput>" onclick="add_toplu_mesai()"/>
</cf_box_footer>
<script>
function add_toplu_mesai()
{
	<cfoutput>
		windowopen('index.cfm?fuseaction=ehesap.popup_add_overtime_all&branch_id=#attributes.ssk_office#&startdate=#dateformat(kisi_start,"dd/mm/yyyy")#&finishdate=#dateformat(kisi_finish,"dd/mm/yyyy")#','page');
	</cfoutput>
}
</script>