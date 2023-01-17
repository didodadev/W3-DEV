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

<ul>

<cfif not get_emps.recordcount>
	<li><cf_get_lang dictionary_id='46130.İlgili Şubeye Ait Puantaj Oluşturulacak Çalışan Kaydı Bulunamadı.'></li>
	<cfexit method="exittemplate">
</cfif>

<cfquery name="get_emps_outs" dbtype="query">
	SELECT * FROM get_emps WHERE VALID IS NULL AND FINISH_DATE IS NOT NULL
</cfquery>
<cfif get_emps_outs.recordcount>
	<cfoutput query="get_emps_outs">
		<li>#employee_name# #employee_surname# <cf_get_lang dictionary_id='64863.Adlı Çalışanın Çıkış İşlemini Onaylayınız'>! </li>
	</cfoutput>
	<cfset warning = 1>
</cfif>


<cfscript>
	get_offtime_cats = get_days.get_offtime_cats();
	get_offtimes = get_days.get_offtimes(employee_ids:'#valuelist(get_emps.EMPLOYEE_ID)#');
</cfscript>

<cfset nonvalid_offtime = 0>
<cfset offtime_emp_list = ''>
<cfoutput query="get_offtimes">
	<cfif not listfind(offtime_emp_list,employee_id)>
		<cfset offtime_emp_list = listappend(offtime_emp_list,employee_id)>
    </cfif>
    
	<cfif year(start_date) eq year(p_baslangic) and month(start_date) eq month(p_baslangic)>
		<cfset kisi_start = start_date>
	<cfelse>
		<cfset kisi_start = p_baslangic>
	</cfif>
	<cfif len(FINISH_DATE) and year(FINISH_DATE) eq year(p_bitis) and month(FINISH_DATE) eq month(p_bitis)>
		<cfset kisi_finish = FINISH_DATE>
	<cfelse>
		<cfset kisi_finish = p_bitis>
	</cfif>
	
	<cfif datediff('d',startdate,kisi_start) gt 0>
		<cfset izin_start = kisi_start>
	<cfelse>
		<cfset izin_start = startdate>
	</cfif>
    
    <cfif datediff('d',kisi_finish,finishdate) gt 0>
		<cfset izin_bitis = kisi_finish>
        <cfset izin_bitis = dateadd("h",hour(FINISHDATE),izin_bitis)>
	<cfelse>
		<cfset izin_bitis = FINISHDATE>
	</cfif>
    
    <cfif datediff('d',p_bitis,izin_bitis) gt 0>
    	<cfset izin_bitis = p_bitis>
        <cfset izin_bitis = dateadd('h',hour(FINISHDATE),izin_bitis)>
    </cfif>

	<cfset fark_ = datediff('d',izin_start,izin_bitis)>
    
    <cfif day(izin_start) eq 1 and (month(izin_start) neq month(izin_bitis) or day(izin_bitis) eq aydaki_gun_sayisi)>
    	<cfset fark_ = aydaki_gun_sayisi - 1>
    </cfif>
    
    <cfif fark_ gt aydaki_gun_sayisi>
    	<cfset fark_ = aydaki_gun_sayisi - 1>
    </cfif>

	<cfloop from="0" to="#fark_#" index="day_">
		<cfscript>
			temp_izin_gunu = date_add("d",day_,izin_start);
			daycode = '#dateformat(temp_izin_gunu,"ddmmyyyy")#';
		</cfscript>
		
		<cfif month(temp_izin_gunu) eq month(p_baslangic) and year(temp_izin_gunu) eq year(p_baslangic)>
        	<cfif not len(VALID)>
                <cfset nonvalid_offtime = 1>
            </cfif>
       </cfif>
	</cfloop>    
</cfoutput>

<cfif nonvalid_offtime eq 1>
	<li><cf_get_lang dictionary_id='46157.Onaylanmamış İzin Kayıtlarını Onaylayınız'>!</li>
	<cfset warning = 1>
</cfif>

<cfif warning eq 0>	
	<li><cf_get_lang dictionary_id='46158.Puantaj İle İlgili Bir Uyarı Bulunmamaktadır'>.</li>
</cfif>

</ul>