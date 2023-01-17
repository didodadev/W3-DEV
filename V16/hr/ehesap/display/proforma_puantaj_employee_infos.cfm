<cfset warning = 0>
<br>
<cfscript>
	get_days = createObject("component","V16.hr.ehesap.cfc.proforma_puantaj");
	get_days.dsn = dsn;
	get_days.ssk_office = attributes.ssk_office;
	get_days.sal_year = attributes.sal_year;
	get_days.sal_mon = attributes.sal_mon;
	
	get_emps = get_days.get_emps();
</cfscript>
<cfset p_baslangic = createodbcdatetime(createdatetime(attributes.sal_year,attributes.sal_mon,1))>
<cfset aydaki_gun_sayisi = daysinmonth(p_baslangic)>
<cfset p_bitis = createodbcdatetime(createdatetime(attributes.sal_year,attributes.sal_mon,aydaki_gun_sayisi))>

<cfif not get_emps.recordcount>
	<cf_get_lang dictionary_id='46130.İlgili Şubeye Ait Puantaj Oluşturulacak Çalışan Kaydı Bulunamadı.'> <br>
	<cfexit method="exittemplate">
</cfif>

<cf_ajax_list>
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id='58577.Sıra'></th>
			<th><cf_get_lang dictionary_id='58025.TC Kimlik No'></th>
			<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
			<th><cf_get_lang dictionary_id='57521.Banka'></th>
            <th><cf_get_lang dictionary_id='58178.Hesap No'></th>
        </tr>
	</thead>
	<tbody>
	<cfset gun_toplam = 0>
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
        
        <cfif isdefined("kisi_gun_ek_#employee_id#")>
        	<cfset calisma_gun_sayisi = calisma_gun_sayisi + evaluate("kisi_gun_ek_#employee_id#")>
        </cfif>
		
		<cfif calisma_gun_sayisi gt 30>
			<cfset calisma_gun_sayisi = 30>
		</cfif>
		<cfset gun_toplam = gun_toplam + calisma_gun_sayisi>
		
		<tr class="color-row">
			<td>#currentrow#</td>
			<td>
            <cfif listgetat(session.ep.user_level, 3)>
            	<a href="#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#employee_id#" target="hr_profil" class="tableyazi">#tc_identy_no#</a>
            <cfelse>
            	#tc_identy_no#
            </cfif>    
            </td>
			<td style="font-weight:bold;" nowrap="nowrap">
            	<a href="javascript://" style="color:<cfif bu_ay_basladi eq 1>green<cfelseif bu_ay_cikti eq 1>red<cfelseif reel_calisma_gun_sayisi lt aydaki_gun_sayisi>blue</cfif>;" class="tableyazi">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a>
            	<cfif DUTY_TYPE eq 6>(<cf_get_lang dictionary_id='55896.Kısmi İstihdam'>)</cfif>
                <cfif SSK_STATUTE eq 2 or SSK_STATUTE eq 18>(<cf_get_lang dictionary_id='58541.Emekli'>)</cfif><!---Muzaffer Yeraltı Emeli--->
            </td>
            <td nowrap="nowrap">#BANKA_ADI#</td>
            <td nowrap="nowrap"><cfif len(BANKA_HESAP)>#BANKA_HESAP#<cfelse><a href="javascript://" onclick="windowopen('index.cfm?fuseaction=objects.popup_form_add_bank_account&employee_id=#employee_id#','medium')" class="tableyazi"><cf_get_lang dictionary_id='46125.Tanımla'></a></cfif></td>
		</tr>
	</cfoutput>
	</tbody>
	<tfoot>
	<cfoutput>
		<tr class="color-list">
			<td colspan="4" class="formbold" style="text-align:right;"><cf_get_lang dictionary_id='53263.Toplamlar'></td>
			<td style="text-align:center;" class="formbold">#get_emps.recordcount# <cf_get_lang dictionary_id='29831.Kişi'></td>
		</tr>
	</cfoutput>
	</tfoot>
</cf_ajax_list>