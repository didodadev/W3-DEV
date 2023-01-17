<cfset bugun = createdate(year(now()),month(now()),day(now()))>
<cfset bu_ay_sonu = createdate(year(now()),month(now()),DaysInMonth(now()))>
<cfquery name="GET_RELATED_DEPOTS" datasource="#dsn#">
	SELECT 
		BRANCH.BRANCH_NAME, 
		OUR_COMPANY.NICK_NAME, 
		COMPANY_BOYUT_DEPO_KOD.BOYUT_KODU ,
		COMPANY_BRANCH_RELATED.RELATED_ID, 
		OUR_COMPANY.COMP_ID, 
		BRANCH.BRANCH_NAME, 
		BRANCH.BRANCH_ID 
	FROM 
		COMPANY_BRANCH_RELATED, 
		BRANCH, 
		OUR_COMPANY, 
		COMPANY_BOYUT_DEPO_KOD, 
		EMPLOYEE_POSITION_BRANCHES 
	WHERE 
		COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
		COMPANY_BRANCH_RELATED.IS_SELECT = 1 AND
		COMPANY_BRANCH_RELATED.COMPANY_ID = #attributes.cpid# AND 
		BRANCH.BRANCH_ID = COMPANY_BRANCH_RELATED.BRANCH_ID AND 
		OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID AND 
		COMPANY_BRANCH_RELATED.MUSTERIDURUM NOT IN (1,2) AND 
		COMPANY_BOYUT_DEPO_KOD.W_KODU = BRANCH.BRANCH_ID AND 
		EMPLOYEE_POSITION_BRANCHES.BRANCH_ID = BRANCH.BRANCH_ID AND 
		EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code# AND
		EMPLOYEE_POSITION_BRANCHES.DEPARTMENT_ID IS NULL
	ORDER BY 
		COMPANY_BRANCH_RELATED.BRANCH_ID
</cfquery>
<cftry>
	<cfquery name="GET_FINANCE_INFO" datasource="hedef_crm">
		SELECT 
			*
		FROM 
			HEDEF.HEDEF_MUSTERI_DURUM WHERE HEDEFKODU = #attributes.cpid# AND 
			AKTARIM_TARIH = #bugun#
		ORDER BY 
			AKTARIM_TARIH DESC
	</cfquery>
	<cfcatch>
	
	</cfcatch>
</cftry>
<cfquery name="GET_BRANCH_VAL" datasource="#dsn#">
	SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#
</cfquery>
  <input type="hidden" name="frame_fuseaction" id="frame_fuseaction" value="<cfif isdefined("attributes.frame_fuseaction") and len(attributes.frame_fuseaction)><cfoutput>#attributes.frame_fuseaction#</cfoutput></cfif>">
<cfsavecontent variable="title"><cf_get_lang no='155.Risk Bilgileri'></cfsavecontent>
  
<cf_box title="#title#" edit_href="javascript:openBoxDraggable('#request.self#?fuseaction=crm.popup_calculate_fix_date')">

<cftry>
<cfif get_related_depots.recordcount>
		<cfscript>
			value1 = 0;
			value2 = 0;
			value3 = 0;
			value4 = 0;
			value5 = 0;
			value6 = 0;
			value7 = 0;
			value8 = 0;
			value9 = 0;
			value10 = 0;
			value11 = 0;
			value12 = 0;
			value13 = 0;
			value14 = 0;
			value15 = 0;
			value40 = 0;
			value41 = 0;
			value42 = 0;
			toplam_value_ciro = 0;
			toplam_value_ciro_years = '';
		</cfscript>
  <cfoutput query="get_related_depots">
	  <cfquery name="GET_RELATED" dbtype="query">
		SELECT * FROM GET_FINANCE_INFO WHERE DEPO_KODU = '#boyut_kodu#'
	  </cfquery>
	  <cfscript>
		toplam1 = 0;
		toplam2 = 0;
		toplam3 = 0;
		toplam4 = 0;
		toplam5 = 0;
		toplam6 = 0;
		toplam7 = 0;
		toplam8 = 0;
		toplam9 = 0;
		toplam10 = 0;
		toplam11 = 0;
		toplam12= 0;
		toplam40 = 0;
		toplam41 = 0;
		toplam42 = 0;
		deger_gecmis_ortalama_gun = 0;
		deger_vadeli_ortalama_gun = 0;
		
		if(len(get_related.borc))
		{
			xx1 = get_related.borc;
			toplam40 = toplam40 + get_related.borc;
		}
		else
		{
			xx1 = 0;
		}
		if(len(get_related.alacak))
		{
			xx2 = get_related.alacak;
			toplam41 = toplam41 + get_related.alacak;
		}
		else
		{
			xx2 = 0;
		}
		if(len(get_related.devir_borc))
		{
			xx3 = get_related.devir_borc;
		}
		else
		{
			xx3 = 0;
		}
		if(len(get_related.devir_alacak))
		{
			xx4 = get_related.devir_alacak;
		}
		else
		{
			xx4 = 0;
		}
		toplam42 = toplam42 + xx1-xx2+xx3-xx4;
		
		if(len(get_related.karsiliksiz_cek_adet))
			toplam1 = toplam1 + get_related.karsiliksiz_cek_adet;
		if(len(get_related.karsiliksiz_senet_adet))
			toplam1 = toplam1 + get_related.karsiliksiz_senet_adet;
		if(len(get_related.karsiliksiz_senet_adet))
			toplam1 = toplam1 + get_related.karsiliksiz_pos_adet;
		if(len(get_related.karsiliksiz_senet_adet))
			toplam1 = toplam1 + get_related.karsiliksiz_kk_adet;
		
		if(len(get_related.karsiliksiz_cek_tutar))
			{
			toplam2 = toplam2 + get_related.karsiliksiz_cek_tutar;
			if(len(get_related.karsiliksiz_cek_ortgun))
				{
					toplam11 = toplam11 + get_related.karsiliksiz_cek_tutar*get_related.karsiliksiz_cek_ortgun;
				}
			}
		if(len(get_related.karsiliksiz_senet_tutar))
			{
			toplam2 = toplam2 + get_related.karsiliksiz_senet_tutar;
			if(len(get_related.karsiliksiz_senet_ortgun))
				{
					toplam11 = toplam11 + get_related.karsiliksiz_senet_tutar*get_related.karsiliksiz_senet_ortgun;
				}
			}
		if(len(get_related.karsiliksiz_pos_tutar))
			{
			toplam2 = toplam2 + get_related.karsiliksiz_pos_tutar;
			if(len(get_related.karsiliksiz_pos_ortgun))
				{
					toplam11 = toplam11 + get_related.karsiliksiz_pos_tutar*get_related.karsiliksiz_pos_ortgun;
				}
			}
		if(len(get_related.karsiliksiz_kk_tutar))
			{
			toplam2 = toplam2 + get_related.karsiliksiz_kk_tutar;
			if(len(get_related.karsiliksiz_kk_ortgun))
				{
					toplam11 = toplam11 + get_related.karsiliksiz_kk_tutar*get_related.karsiliksiz_kk_ortgun;
				}
			}
		if(toplam2 neq 0)
			deger_gecmis_ortalama_gun = toplam11/toplam2;
			
		if(len(get_related.vadeli_cek_adet))
			toplam3 = toplam3 + get_related.vadeli_cek_adet;
		if(len(get_related.vadeli_senet_adet))
			toplam3 = toplam3 + get_related.vadeli_senet_adet;
		if(len(get_related.vadeli_senet_adet))
			toplam3 = toplam3 + get_related.vadeli_pos_adet;
		if(len(get_related.vadeli_senet_adet))
			toplam3 = toplam3 + get_related.vadeli_kk_adet;
		
		if(len(get_related.vadeli_cek_tutar))
			{
			toplam4 = toplam4 + get_related.vadeli_cek_tutar;
			if(len(get_related.vadeli_cek_ortgun))
				{
					toplam12 = toplam12 + get_related.vadeli_cek_tutar*get_related.vadeli_cek_ortgun;
				}
			}
		if(len(get_related.vadeli_senet_tutar))
			{
			toplam4 = toplam4 + get_related.vadeli_senet_tutar;
			if(len(get_related.vadeli_senet_ortgun))
				{
					toplam12 = toplam12 + get_related.vadeli_senet_tutar*get_related.vadeli_senet_ortgun;
				}
			}
		if(len(get_related.vadeli_pos_tutar))
			toplam4 = toplam4 + get_related.vadeli_pos_tutar;
			if(len(get_related.vadeli_pos_ortgun))
				{
					toplam12 = toplam12 + get_related.vadeli_pos_tutar*get_related.vadeli_pos_ortgun;
				}
		if(len(get_related.vadeli_kk_tutar))
			toplam4 = toplam4 + get_related.vadeli_kk_tutar;
			if(len(get_related.vadeli_kk_ortgun))
				{
					toplam12 = toplam12 + get_related.vadeli_kk_tutar*get_related.vadeli_kk_ortgun;
				}
		if(toplam4 neq 0)
			deger_vadeli_ortalama_gun = toplam12 / toplam4;
			
		if(len(get_related.risk_toplam))
			toplam5 = get_related.risk_toplam;
		
		if(len(get_related.risk_toplam))
			toplam6 = get_related.risk_limit;
			
		if(len(get_related.acik_hesap_bakiye))
			{ value1 = value1 + get_related.acik_hesap_bakiye; }
		value2 = value2 + toplam1;
		value3 = value3 + toplam2;
		value4 = value4 + toplam3;
		value5 = value5 + toplam4;
		value6 = value6 + toplam5;
		value7 = value7 + toplam6;
		value8 = value8 + toplam6 - toplam5;
		
		if(len(get_related.borc))
			{ value9 = value9 + get_related.borc; }
		if(len(get_related.devir_borc))
			{ value9 = value9 - get_related.devir_borc ; }
		
		if(len(get_related.karsiliksiz_cek_tutar) and len(get_related.KARSILIKSIZ_CEK_ORTGUN))
		{
			toplam7 = toplam7 + get_related.karsiliksiz_cek_tutar * get_related.KARSILIKSIZ_CEK_ORTGUN;
			toplam8 = toplam8 + get_related.KARSILIKSIZ_CEK_ORTGUN;
		}
		
		if(len(get_related.karsiliksiz_kk_tutar) and len(get_related.KARSILIKSIZ_KK_ORTGUN))
		{
			toplam7 = toplam7 + get_related.karsiliksiz_KK_tutar * get_related.KARSILIKSIZ_KK_ORTGUN;
			toplam8 = toplam8 + get_related.KARSILIKSIZ_KK_ORTGUN;
		}
		
		if(len(get_related.karsiliksiz_POS_tutar) and len(get_related.KARSILIKSIZ_POS_ORTGUN))
		{
			toplam7 = toplam7 + get_related.karsiliksiz_POS_tutar * get_related.KARSILIKSIZ_POS_ORTGUN;
			toplam8 = toplam8 + get_related.KARSILIKSIZ_POS_ORTGUN;
		}
		
		if(len(get_related.karsiliksiz_SENET_tutar) and len(get_related.karsiliksiz_SENET_ORTGUN))
		{
			toplam7 = toplam7 + get_related.karsiliksiz_SENET_tutar * get_related.karsiliksiz_SENET_ORTGUN;
			toplam8 = toplam8 + get_related.karsiliksiz_SENET_ORTGUN;
		}
			
		if(toplam8 gt 0)
		{
			value10 = toplam7 / toplam8;
		}
		else
		{
			value10 = 0;
		}
		
			
		if(len(get_related.vadeli_cek_tutar) and len(get_related.vadeli_cek_ortgun))
		{
			toplam9 = toplam9 + get_related.vadeli_cek_tutar * get_related.vadeli_cek_ortgun;
			toplam10 = toplam10 + get_related.vadeli_cek_ortgun;
		}
		
		if(len(get_related.vadeli_kk_tutar) and len(get_related.vadeli_kk_ortgun))
		{
			toplam9 = toplam9 + get_related.vadeli_kk_tutar * get_related.vadeli_kk_ortgun;
			toplam10 = toplam10 + get_related.vadeli_kk_ortgun;
		}
		
		if(len(get_related.vadeli_pos_tutar) and len(get_related.vadeli_pos_ortgun))
		{
			toplam9 = toplam9 + get_related.vadeli_pos_tutar * get_related.vadeli_pos_ortgun;
			toplam10 = toplam10 + get_related.vadeli_pos_ortgun;
		}
		
		if(len(get_related.vadeli_senet_tutar) and len(get_related.vadeli_senet_ortgun))
		{
			toplam9 = toplam9 + get_related.vadeli_senet_tutar * get_related.vadeli_senet_ortgun;
			toplam10 = toplam10 + get_related.vadeli_senet_ortgun;
		}
		
		if(toplam10 gt 0)
		{
			value11 = toplam9 / toplam10;
		}
		else
		{
			value11 = 0;
		}
		
		value14 = value14 + toplam11;
		value15 = value15 + toplam12;
		value40 = value40 + toplam40;
		value41 = value41 + toplam41;
		value42 = value42 + toplam42;
	</cfscript>
	<cfset color_list = 'FFFFCC,CCFFCC,FFFFCC,FF0000,99CC99,FF0000,FFCC99,FF0000,FF0000,FF0000'>
   
		<cf_grid_list>
			<thead>
				<tr>
				<th colspan="2">&nbsp;#branch_name#</th>
				</tr>
			</thead>
         
			 
				<cfquery name="GET_FATSAY_MUSTERI" datasource="hedef_crm">
					SELECT
						SUM(NORMAL_FAT_TUTAR+ACIL_FAT_TUTAR+SERVIS_FAT_TUTAR+IADE_TUTAR) TOPLAM_TUTAR ,
						HEDEFKODU,
						DEPO_KODU,
						TO_CHAR(TARIH,'yyyy') YIL
					FROM 
						HEDEF.HEDEF_MUSTERI_FATSAY
					WHERE
						HEDEFKODU = #attributes.cpid# AND
						TARIH <= #bu_ay_sonu# AND
						DEPO_KODU = #boyut_kodu#
					GROUP BY
						HEDEFKODU,
						DEPO_KODU,
						TO_CHAR(TARIH,'yyyy')
					ORDER BY
						TO_CHAR(TARIH,'yyyy') DESC
				</cfquery>
				
				<cfloop query="GET_FATSAY_MUSTERI">
					<cfset toplam_value_ciro = toplam_value_ciro + TOPLAM_TUTAR>
					<cfif not listfind(toplam_value_ciro_years,YIL,',')>
						<cfset 'toplam_value_ciro_#YIL#' = TOPLAM_TUTAR>
						<cfset toplam_value_ciro_years = ListAppend(toplam_value_ciro_years,YIL,',')>
					<cfelse>
						<cfset 'toplam_value_ciro_#YIL#' = evaluate('toplam_value_ciro_#YIL#') + TOPLAM_TUTAR>
					</cfif>
				  <tr>
					<td class="txtboldblue" width="300"><font color="##FF6600"><cf_get_lang dictionary_id="52192.Kümüle"> <cf_get_lang no='1.Ciro'> #YIL# :</font></td>
					<td width="200"  class="txtboldblue" style="text-align:right;"><font color="##FF6600" size="+1">#tlformat(TOPLAM_TUTAR)# #session.ep.money#</font></td>
				  </tr>
				</cfloop>
			  <tr>
				<td width="300" class="txtboldblue"><font color="##FF6600"><cf_get_lang dictionary_id="31899.Şube Risk Toplamı"></font></td>
				<td width="200"  style="text-align:right;"><font color="##FF6600">#tlformat(toplam5)# #session.ep.money#</font></td>
			  </tr>
              <tr>
			  	<td class="txtboldblue"><cf_get_lang dictionary_id="57587.Borç"></td>
				<td  style="text-align:right;"> #tlformat(toplam40)# #session.ep.money#</td>
			  </tr>
              <tr>
			  	<td class="txtboldblue"><cf_get_lang dictionary_id="57588.Alacak"></td>
				<td  style="text-align:right;"> #tlformat(toplam41)# #session.ep.money#</td>
			  </tr>
              <tr>
			  	<td class="txtboldblue"><cf_get_lang dictionary_id="57589.Bakiye"></td>
				<td  style="text-align:right;"> #tlformat(toplam42)# #session.ep.money#</td>
			  </tr>
			  <tr>
                <td class="txtboldblue"><cf_get_lang no='475.Açık Hesap'></td>
                <td  style="text-align:right;"> <cfif len(get_related.acik_hesap_bakiye)>#tlformat(get_related.acik_hesap_bakiye)#<cfelse>#tlformat(0)#</cfif> #session.ep.money#</td>
              </tr>
              <tr>
                <td class="txtboldblue"><cf_get_lang dictionary_id="52011.Vadesi Geçmiş Evrak Adedi"></td>
                <td  style="text-align:right;"> #tlformat(toplam1,0)# <cf_get_lang dictionary_id="58082.Adet"></td>
              </tr>
			  <tr>
			  	<td class="txtboldblue">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <cf_get_lang dictionary_id="31891.Vadesi Geçmiş Çek Adedi"></td>
				<td  style="text-align:right;"> #tlformat(get_related.karsiliksiz_cek_adet,0)# <cf_get_lang dictionary_id="58082.Adet"></td>
			  </tr>
			  <tr>
			  	<td class="txtboldblue">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <cf_get_lang dictionary_id="31906.Vadesi Geçmiş Senet Adedi"></td>
				<td  style="text-align:right;"> #tlformat(get_related.karsiliksiz_senet_adet,0)# <cf_get_lang dictionary_id="58082.Adet"></td>
			  </tr>
			  <tr>
			  	<td class="txtboldblue">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <cf_get_lang dictionary_id="32031.Vadesi Geçmiş Pos Adedi"></td>
				<td  style="text-align:right;"> #tlformat(get_related.karsiliksiz_pos_adet,0)# <cf_get_lang dictionary_id="58082.Adet"></td>
			  </tr>
			  <tr>
			  	<td class="txtboldblue">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <cf_get_lang dictionary_id="32030.Vadesi Geçmiş KK Adedi"></td>
				<td  style="text-align:right;"> #tlformat(get_related.karsiliksiz_kk_adet,0)# <cf_get_lang dictionary_id="58082.Adet"></td>
			  </tr>
              <tr>
                <td class="txtboldblue"><cf_get_lang dictionary_id="52012.Vadesi Geçmiş Evrak Tutarı"></td>
                <td  style="text-align:right;"> #tlformat(toplam2)# #session.ep.money#</td>
              </tr>
			  <tr>
			  	<td class="txtboldblue">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <cf_get_lang dictionary_id="32015.Vadesi Geçmiş Çek Tutarı"></td>
				<td  style="text-align:right;"> #tlformat(get_related.karsiliksiz_cek_tutar)# #session.ep.money#</td>
			  </tr>
			  <tr>
			  	<td class="txtboldblue">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <cf_get_lang dictionary_id="32013.Vadesi Geçmiş Senet Tutarı"></td>
				<td  style="text-align:right;"> #tlformat(get_related.karsiliksiz_senet_tutar)# #session.ep.money#</td>
			  </tr>
			  <tr>
			  	<td class="txtboldblue">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <cf_get_lang dictionary_id="32009.Vadesi Geçmiş Pos Tutarı"></td>
				<td  style="text-align:right;"> #tlformat(get_related.karsiliksiz_pos_tutar)# #session.ep.money#</td>
			  </tr>
			  <tr>
			  	<td class="txtboldblue">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <cf_get_lang dictionary_id="31999.Vadesi Geçmiş KK Tutarı"></td>
				<td  style="text-align:right;"> #tlformat(get_related.karsiliksiz_kk_tutar)# #session.ep.money#</td>
			  </tr>
			  <tr>
			  	<td class="txtboldblue"><cf_get_lang dictionary_id="31998.Vadesi Geçmiş Evrak Ortalama Gün"></td>
				<td  style="text-align:right;"> #tlformat(deger_gecmis_ortalama_gun,0,1)# <cf_get_lang dictionary_id="57490.Gün"></td>
			  </tr>
			  <tr>
			  	<td class="txtboldblue">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <cf_get_lang dictionary_id="31993.Vadesi Geçmiş Evrak Ortalama Çek Gün"></td>
				<td  style="text-align:right;"> #get_related.KARSILIKSIZ_CEK_ORTGUN# <cf_get_lang dictionary_id="57490.Gün"></td>
			  </tr>
			  <tr>
			  	<td class="txtboldblue">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <cf_get_lang dictionary_id="31992.Vadesi Geçmiş Evrak Ortalama Senet Gün"></td>
				<td  style="text-align:right;"> #get_related.KARSILIKSIZ_SENET_ORTGUN# <cf_get_lang dictionary_id="57490.Gün"></td>
			  </tr>
			  <tr>
			  	<td class="txtboldblue">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <cf_get_lang dictionary_id="31964.Vadesi Geçmiş Evrak Ortalama Pos Gün"></td>
				<td  style="text-align:right;"> #tlformat(get_related.KARSILIKSIZ_POS_ORTGUN,0)# <cf_get_lang dictionary_id="57490.Gün"></td>
			  </tr>
			  <tr>
			  	<td class="txtboldblue">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <cf_get_lang dictionary_id="32146.Vadesi Geçmiş Evrak Ortalama KK Gün"></td>
				<td  style="text-align:right;"> #tlformat(get_related.KARSILIKSIZ_KK_ORTGUN,0)# <cf_get_lang dictionary_id="57490.Gün"></td>
			  </tr>
              <tr>
                <td class="txtboldblue"><cf_get_lang dictionary_id="32094.Vadesi Gelmemiş Evrak Adet"></td>
                <td  style="text-align:right;"> #tlformat(toplam3,0)# <cf_get_lang dictionary_id="58082.Adet"></td>
              </tr>
			  <tr>
			  	<td class="txtboldblue">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <cf_get_lang dictionary_id="32091.Vadesi Gelmemiş Çek Adet"></td>
				<td  style="text-align:right;"> #tlformat(get_related.vadeli_cek_adet,0)# <cf_get_lang dictionary_id="58082.Adet"></td>
			  </tr>
			  <tr>
			  	<td class="txtboldblue">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <cf_get_lang dictionary_id="32088.Vadesi Gelmemiş Senet Adet"></td>
				<td  style="text-align:right;"> #tlformat(get_related.vadeli_senet_adet,0)# <cf_get_lang dictionary_id="58082.Adet"></td>
			  </tr>
			  <tr>
			  	<td class="txtboldblue">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cf_get_lang dictionary_id="32075.Vadesi Gelmemiş Pos Adet"></td>
				<td  style="text-align:right;"> #tlformat(get_related.vadeli_pos_adet,0)# <cf_get_lang dictionary_id="58082.Adet"></td>
			  </tr>
			  <tr>
			  	<td class="txtboldblue">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cf_get_lang dictionary_id="32042.Vadesi Gelmemiş KK Adet"></td>
				<td  style="text-align:right;"> #tlformat(get_related.vadeli_kk_adet,0)# <cf_get_lang dictionary_id="58082.Adet"></td>
			  </tr>
              <tr>
                <td class="txtboldblue"><cf_get_lang dictionary_id="32037.Vadesi Gelmemiş Evrak Tutar"></td>
                <td  style="text-align:right;"> #tlformat(toplam4)# #session.ep.money#</td>
              </tr>
			  <tr>
			  	<td class="txtboldblue">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <cf_get_lang dictionary_id="32085.Vadesi Gelmemiş Çek Tutar"></td>
				<td  style="text-align:right;"> #tlformat(get_related.vadeli_cek_tutar)# #session.ep.money#</td>
			  </tr>
			  <tr>
			  	<td class="txtboldblue">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <cf_get_lang dictionary_id="32082.Vadesi Gelmemiş Senet Tutar"></td>
				<td  style="text-align:right;"> #tlformat(get_related.vadeli_senet_tutar)# #session.ep.money#</td>
			  </tr>
			  <tr>
			  	<td class="txtboldblue">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <cf_get_lang dictionary_id="32274.Vadesi Gelmemiş Pos Tutar"></td>
				<td  style="text-align:right;"> #tlformat(get_related.vadeli_pos_tutar)# #session.ep.money#</td>
			  </tr>
			  <tr>
			  	<td class="txtboldblue">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <cf_get_lang dictionary_id="32240.Vadesi Gelmemiş KK Tutar"></td>
				<td  style="text-align:right;"> #tlformat(get_related.vadeli_kk_tutar)# #session.ep.money#</td>
			  </tr>
			  <tr>
			  	<td class="txtboldblue"><cf_get_lang dictionary_id="32217.Vadesi Gelmemiş Evrak Ortalama Gün"></td>
				<td  style="text-align:right;"> #tlformat(deger_vadeli_ortalama_gun,0,1)# <cf_get_lang dictionary_id="57490.Gün"></td>
			  </tr>
			  <tr>
			  	<td class="txtboldblue">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <cf_get_lang dictionary_id="32216.Vadesi Gelmemiş Evrak Ortalama Çek Gün"></td>
				<td  style="text-align:right;"> #get_related.VADELI_CEK_ORTGUN# <cf_get_lang dictionary_id="57490.Gün"></td>
			  </tr>
			  <tr>
			  	<td class="txtboldblue">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <cf_get_lang dictionary_id="32155.Vadesi Gelmemiş Evrak Ortalama Senet Gün"></td>
				<td  style="text-align:right;"> #get_related.VADELI_SENET_ORTGUN# <cf_get_lang dictionary_id="57490.Gün"></td>
			  </tr>
			  <tr>
			  	<td class="txtboldblue">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <cf_get_lang dictionary_id="32152.Vadesi Gelmemiş Evrak Ortalama Pos Gün"></td>
				<td  style="text-align:right;"> #get_related.VADELI_POS_ORTGUN# <cf_get_lang dictionary_id="57490.Gün"></td>
			  </tr>
			  <tr>
			  	<td class="txtboldblue">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <cf_get_lang dictionary_id="32296.Vadesi Gelmemiş Evrak Ortalama KK Gün"></td>
				<td  style="text-align:right;"> #get_related.VADELI_KK_ORTGUN# <cf_get_lang dictionary_id="57490.Gün"></td>
			  </tr>
              <tr>
                <td class="txtboldblue"><cf_get_lang_main no='460.Toplam Risk'></td>
                <td  style="text-align:right;"> #tlformat(toplam5)# #session.ep.money#</td>
              </tr>
              <tr>
                <td class="txtboldblue"><cf_get_lang no='135. Risk Limiti'></td>
                <td  style="text-align:right;"> #tlformat(toplam6)# #session.ep.money#</td>
              </tr>
              <tr>
                <td class="txtboldblue"><cf_get_lang no='134.Serbesti'></td>
                <td  style="text-align:right;"> <cfif toplam6-toplam5 eq 0>#tlformat(0)#<cfelse>#tlformat(toplam6-toplam5)#</cfif> #session.ep.money#</td>
              </tr>
             
           
          </cf_grid_list>
      
  </cfoutput>
  <cf_grid_list>
		<thead>
   
          <tr>
            <th colspan="2"><cf_get_lang no='315.Grup Toplamı'></th>
          </tr>
          <tr>
		  </thead>
            
			<cfif ((get_related_depots.recordcount gt 1) and (get_branch_val.recordcount gt 1) or (get_related_depots.recordcount eq 1) and (get_branch_val.recordcount gte 1))>
				<!--- <cfset toplam_value_ciro_years = listsort(toplam_value_ciro_years,'numeric','ASC',',')> --->
				<cfoutput>
				<cfloop list="#toplam_value_ciro_years#" index="i">
				  <tr>
					<td class="txtboldblue" width="300"><font color="##FF6600"><cf_get_lang dictionary_id="52192.Kümüle"> <cf_get_lang no='1.Ciro'> #i#:</font></td>
					<td width="200"  class="txtboldblue" style="text-align:right;"><font color="##FF6600" size="+1">#tlformat(evaluate('toplam_value_ciro_#i#'))# #session.ep.money#</font></td>
				  </tr>
				 </cfloop>
				  <tr>
					<td class="txtboldblue" width="300"><font color="##FF6600"><cf_get_lang dictionary_id="52192.Kümüle"> <cf_get_lang no='1.Ciro'>:</font></td>
					<td width="200"  class="txtboldblue" style="text-align:right;"><font color="##FF6600" size="+1">#tlformat(toplam_value_ciro)# #session.ep.money#</font></td>
				  </tr>
				  <tr>
					<td width="300" class="txtboldblue"><font color="##FF6600"><cf_get_lang dictionary_id="32288.Grup Risk Toplamı"></font></td>
					<td width="200"  style="text-align:right;"><font color="##FF6600">#tlformat(value6)# #session.ep.money# #session.ep.money#</font></td>
				  </tr>
				  <tr>
					<td width="300" class="txtboldblue"><cf_get_lang no='475.Açık Hesap'></td>
					<td width="200"  style="text-align:right;"> #tlformat(value1)# #session.ep.money#</td>
				  </tr>
				  <tr>
					<td class="txtboldblue"><cf_get_lang dictionary_id="57587.Borç"></td>
					<td  style="text-align:right;"> #tlformat(value40)# #session.ep.money#</td>
				  </tr>
				  <tr>
					<td class="txtboldblue"><cf_get_lang dictionary_id="57588.Alacak"></td>
					<td  style="text-align:right;"> #tlformat(value41)# #session.ep.money#</td>
				  </tr>
				  <tr>
					<td class="txtboldblue"><cf_get_lang dictionary_id="57589.Bakiye"></td>
					<td  style="text-align:right;"> #tlformat(value42)# #session.ep.money#</td>
				  </tr>

				  <tr>
					<td class="txtboldblue"><cf_get_lang dictionary_id="52011.Vadesi Geçmiş Evrak Adedi"></td>
					<td  style="text-align:right;"> #tlformat(value2,0)# <cf_get_lang dictionary_id="58082.Adet"></td>
				  </tr>
				  <tr>
					<td class="txtboldblue"><cf_get_lang dictionary_id="52012.Vadesi Geçmiş Evrak Tutarı"></td>
					<td  style="text-align:right;"> #tlformat(value3)# #session.ep.money#</td>
				  </tr>
				  <tr>
					<td class="txtboldblue"><cf_get_lang dictionary_id="31998.Vadesi Geçmiş Evrak Ortalama Gün"></td>
					<td  style="text-align:right;"> <cfif value3 neq 0>#tlformat((value14/value3),0,1)#<cfelse>0</cfif><cf_get_lang dictionary_id="57490.Gün"></td>
				  </tr>
				  <tr>
					<td class="txtboldblue"><cf_get_lang dictionary_id="32094.Vadesi Gelmemiş Evrak Adet"></td>
					<td  style="text-align:right;"> #tlformat(value4,0)# <cf_get_lang dictionary_id="58082.Adet"></td>
				  </tr>
				  <tr>
					<td class="txtboldblue"><cf_get_lang dictionary_id="32037.Vadesi Gelmemiş Evrak Tutar"></td>
					<td  style="text-align:right;"> #tlformat(value5)# #session.ep.money#</td>
				  </tr>
				  <tr>
					<td class="txtboldblue"><cf_get_lang dictionary_id="32217.Vadesi Gelmemiş Evrak Ortalama Gün"></td>
					<td  style="text-align:right;"> <cfif value5 neq 0>#tlformat((value15/value5),0,1)#<cfelse>0</cfif><cf_get_lang dictionary_id="57490.Gün"></td>
				  </tr>
				  <tr>
					<td class="txtboldblue"><cf_get_lang_main no='460.Toplam Risk'></td>
					<td  style="text-align:right;"> #tlformat(value6)# #session.ep.money#</td>
				  </tr>
				  <tr>
					<td class="txtboldblue"><cf_get_lang no='135.Risk Limiti'></td>
					<td  style="text-align:right;"> #tlformat(value7)# #session.ep.money#</td>
				  </tr>
				  <tr>
					<td class="txtboldblue"><cf_get_lang no='134.Serbesti'></td>
					<td  style="text-align:right;"> #tlformat(value8)# #session.ep.money#</td>
				  </tr>
				</cfoutput>
			</cfif>
              
       
  </cf_grid_list>
<cfelse>
<cf_grid_list>
	<tr>
		<td valign="top"><cf_get_lang dictionary_id="58486.Kayıt Bulunamadı">!</td>
	</tr>
</cf_grid_list>
</cfif>
<cfcatch>
<cf_grid_list>
	<tr>
		<td><cf_get_lang dictionary_id="57484.Kayıt Yok">!</td>
	</tr>
</cf_grid_list>
</cfcatch>
</cftry>
</cf_box>
