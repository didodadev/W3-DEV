<cfsetting showdebugoutput="no">
<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
	<cftry>
		<cfquery name="GET_FINANCE_INFO" datasource="hedef_crm">
			SELECT 
				*
			FROM 
				HEDEF.HEDEF_MUSTERI_DURUM 
			WHERE 
				HEDEFKODU = #attributes.cpid# AND 
				AKTARIM_TARIH = (SELECT MAX(AKTARIM_TARIH) AKTARIM_TARIH FROM HEDEF.HEDEF_MUSTERI_DURUM WHERE HEDEFKODU = #attributes.cpid#)
			ORDER BY 
				AKTARIM_TARIH 
			DESC
		</cfquery>
		<cfquery name="GET_RELATED_DEPOTS" datasource="#DSN#">
			SELECT BOYUT_KODU FROM COMPANY_BOYUT_DEPO_KOD WHERE W_KODU = #attributes.branch_id#
		</cfquery>
		<cfscript>
			toplam3 = 0;
			toplam4 = 0;
		</cfscript>
		<cfoutput query="get_finance_info">
			<cfscript>
				toplam3 = toplam3 + get_finance_info.risk_toplam;
				toplam4 = toplam4 + get_finance_info.risk_limit;
			</cfscript>
		</cfoutput>
		<cfoutput query="get_related_depots">
			<cfquery name="GET_DEPO_INFO" dbtype="query">
				SELECT * FROM GET_FINANCE_INFO WHERE DEPO_KODU = '#get_related_depots.boyut_kodu#'
			</cfquery>
			<cfscript>
				deger_risk_puan = 0;
				toplam1 = 0;
				toplam2 = 0;
				toplam5 = 0;
				toplam6 = 0;
				toplam7 = 0;
				bugun = createdatetime(year(now()),month(now()),daysinmonth(now()),0,0,0);
				ilkgun = date_add("m",-3,bugun);
			</cfscript>
			<cfquery name="GET_PUAN" dbtype="query">
				SELECT * FROM GET_FINANCE_INFO WHERE AKTARIM_TARIH <= #bugun# AND AKTARIM_TARIH >= #bugun#
			</cfquery>
			<cfloop query="get_depo_info">
				<cfscript>
					toplam1 = toplam1 + risk_toplam;
					toplam2 = toplam2 + risk_limit;
					toplam5 = toplam5 + karsiliksiz_cek_tutar + karsiliksiz_kk_tutar + karsiliksiz_pos_tutar + karsiliksiz_senet_tutar;
					toplam6 = toplam6 + vadeli_cek_tutar + vadeli_kk_tutar + vadeli_pos_tutar + vadeli_senet_tutar;
				</cfscript>
			</cfloop>
			<cfquery name="GET_FATSAY" datasource="hedef_crm">
				SELECT
					SUM(NORMAL_FAT_TUTAR+ACIL_FAT_TUTAR+SERVIS_FAT_TUTAR+IADE_TUTAR-IPTAL_TUTAR) TOPLAM_TUTAR 
				FROM 
					HEDEF.HEDEF_MUSTERI_FATSAY
				WHERE
					HEDEFKODU = #attributes.cpid# AND
					TARIH >= #ilkgun# AND
					TARIH <= #bugun# AND
					DEPO_KODU = #get_related_depots.boyut_kodu#
			</cfquery>
			<cfloop query="get_fatsay">
				<cfif len(get_fatsay.toplam_tutar)>
					<cfset toplam7 = toplam7 + get_fatsay.toplam_tutar>
				</cfif>
			</cfloop>
			<cfset deger_value_ciro = 0>
			<cfif len(get_finance_info.borc)>
				<cfset deger_value_ciro = deger_value_ciro + get_finance_info.borc>
			</cfif>
			<cfif len(get_finance_info.devir_borc)>
				<cfset deger_value_ciro = deger_value_ciro - get_finance_info.devir_borc>
			</cfif>
			<cfif (toplam7/3) neq 0>
				<cfset deger_risk_puan = toplam1 / (toplam7/3)>
			<cfelse>
				<cfset deger_risk_puan = 0>
			</cfif>
				<table cellspacing="1" cellpadding="1" width="100%" border="0" height="100%">
					<tr class="color-row">
					  <td valign="top">
					  <table>
					  <tr>
						<td class="txtboldblue"><font color="##FF6600"><cf_get_lang no='745.Kümüle'> <cf_get_lang no='1.Ciro'> #year(now())#</font></td>
						<td class="txtboldblue"><font color="##FF6600">: #tlformat(get_fatsay.toplam_tutar)# #session.ep.money#</font></td>
					  </tr>
					  <tr>
						<td class="txtboldblue"><cf_get_lang no='746.Şube Toplam Risk'></td>
						<td>: #tlformat(toplam1)# #session.ep.money#</td>
					  </tr>
					  <tr>
						<td class="txtboldblue"><cf_get_lang no='747.Şube Risk Limit'></td>
						<td>: #tlformat(toplam2)# #session.ep.money#</td>
					  </tr>
					  <tr>
						<td class="txtboldblue"><cf_get_lang no='748.Grup Toplam Risk'></td>
						<td>: #tlformat(toplam3)# #session.ep.money#</td>
					  </tr>
					  <tr>
						<td class="txtboldblue"><cf_get_lang no='331.Grup Risk Limit'></td>
						<td>: #tlformat(toplam4)# #session.ep.money#</td>
					  </tr>
					  <tr>
						<td class="txtboldblue"><cf_get_lang no='749.Şube Vadesi Geçmiş Evrak Toplamı'></td>
						<td>: #tlformat(toplam5)# #session.ep.money#</td>
					  </tr>
					  <tr>
						<td class="txtboldblue"><cf_get_lang no='776.Şube Vadesi Gelmemiş Evrak Toplamı'></td>
						<td>: #tlformat(toplam6)# #session.ep.money#</td>
					  </tr>
					  <tr>
						<td class="txtboldblue"><cf_get_lang no='777.Risk Puanı'></td>
						<td>: #tlformat(toplam7)# #session.ep.money#</td>
					  </tr>
					  </table>
					  </td></tr>
				  </table>
		  </cfoutput>
	<cfcatch>
        <table>
            <tr>
                <td><cf_get_lang no='744.Oracle DB sinden Data Çekildiği İçin Test Ortamında Hata Verebilir !'> !</td>
            </tr>
        </table>
	</cfcatch>
	</cftry>
<cfelse>
        <table>
            <tr>
                <td><cf_get_lang_main no='1167.Lütfen Şube Seçiniz'> !</td>
            </tr>
        </table>
</cfif>

