<cfsetting showdebugoutput="no">
<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
	<cftry>
		<cfset bu_ay_sonu = createdate(year(now()),month(now()),DaysInMonth(now()))>
		<cfquery name="GET_COMPANY" datasource="#DSN#">
			SELECT GRUP_RISK_LIMIT, MONEY_CURRENCY , ENDORSE_PERIOD, ENDORSE_PAYMENT, ENDORSE_CURRENCY FROM COMPANY WHERE COMPANY_ID = #attributes.cpid#
		</cfquery>
		<cfquery name="GET_RELATED_DEPOTS" datasource="#dsn#">
			SELECT 
				BOYUT_KODU
			FROM 
				COMPANY_BOYUT_DEPO_KOD 
			WHERE 
				W_KODU = #attributes.branch_id#
		</cfquery>
		<cfquery name="GET_FINANCE_INFO" datasource="hedef_crm">
			SELECT 
				*
			FROM 
				HEDEF.HEDEF_MUSTERI_DURUM 
			WHERE 
				DEPO_KODU = #get_related_depots.boyut_kodu# AND
				HEDEFKODU = #attributes.cpid# AND
				AKTARIM_TARIH = (SELECT MAX(AKTARIM_TARIH) AKTARIM_TARIH  FROM HEDEF.HEDEF_MUSTERI_DURUM WHERE HEDEFKODU = #attributes.cpid# AND DEPO_KODU = #get_related_depots.boyut_kodu#)
				<!--- TO_CHAR(AKTARIM_TARIH,'yyyy-mm-dd') = '#dateformat(now(),'yyyy-mm-dd')#'  --->
			ORDER BY 
				AKTARIM_TARIH 
			DESC
		</cfquery>
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
		</cfscript>
		<cfoutput query="get_related_depots">
			<cfquery name="GET_FATSAY_MUSTERI" datasource="hedef_crm">
				SELECT
					SUM(NORMAL_FAT_TUTAR+ACIL_FAT_TUTAR+SERVIS_FAT_TUTAR+IADE_TUTAR) TOPLAM_TUTAR,
					HEDEFKODU,
					DEPO_KODU
				FROM 
					HEDEF.HEDEF_MUSTERI_FATSAY
				WHERE
					HEDEFKODU = #attributes.cpid# AND
					TARIH <= #bu_ay_sonu# AND
					DEPO_KODU = #get_related_depots.boyut_kodu#
				GROUP BY
					HEDEFKODU,
					DEPO_KODU
			</cfquery>
			<cfquery name="GET_CREDIT" datasource="#DSN#">
				SELECT
					COMPANY_CREDIT.TOTAL_RISK_LIMIT,
					COMPANY_CREDIT.MONEY
				FROM
					COMPANY_BRANCH_RELATED,
					COMPANY_CREDIT
				WHERE
					COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
					COMPANY_BRANCH_RELATED.BRANCH_ID = #attributes.branch_id# AND
					COMPANY_CREDIT.COMPANY_ID = #attributes.cpid# AND
					COMPANY_BRANCH_RELATED.RELATED_ID = COMPANY_CREDIT.BRANCH_ID
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
				if(len(get_finance_info.borc))
				{
					xx1 = get_finance_info.borc;
					toplam40 = toplam40 + get_finance_info.borc;
				}
				else
				{
					xx1 = 0;
				}
				if(len(get_finance_info.alacak))
				{
					xx2 = get_finance_info.alacak;
					toplam41 = toplam41 + get_finance_info.alacak;
				}
				else
				{
					xx2 = 0;
				}
				if(len(get_finance_info.devir_borc))
				{
					xx3 = get_finance_info.devir_borc;
				}
				else
				{
					xx3 = 0;
				}
				if(len(get_finance_info.devir_alacak))
				{
					xx4 = get_finance_info.devir_alacak;
				}
				else
				{
					xx4 = 0;
				}
				toplam42 = toplam42 + xx1-xx2+xx3-xx4;
				if(len(get_finance_info.karsiliksiz_cek_adet))
					toplam1 = toplam1 + get_finance_info.karsiliksiz_cek_adet;
				if(len(get_finance_info.karsiliksiz_senet_adet))
					toplam1 = toplam1 + get_finance_info.karsiliksiz_senet_adet;
				if(len(get_finance_info.karsiliksiz_senet_adet))
					toplam1 = toplam1 + get_finance_info.karsiliksiz_pos_adet;
				if(len(get_finance_info.karsiliksiz_senet_adet))
					toplam1 = toplam1 + get_finance_info.karsiliksiz_kk_adet;
				
				if(len(get_finance_info.karsiliksiz_cek_tutar))
					{
					toplam2 = toplam2 + get_finance_info.karsiliksiz_cek_tutar;
					if(len(get_finance_info.karsiliksiz_cek_ortgun))
						{
							toplam11 = toplam11 + get_finance_info.karsiliksiz_cek_tutar*get_finance_info.karsiliksiz_cek_ortgun;
						}
					}
				if(len(get_finance_info.karsiliksiz_senet_tutar))
					{
					toplam2 = toplam2 + get_finance_info.karsiliksiz_senet_tutar;
					if(len(get_finance_info.karsiliksiz_senet_ortgun))
						{
							toplam11 = toplam11 + get_finance_info.karsiliksiz_senet_tutar*get_finance_info.karsiliksiz_senet_ortgun;
						}
					}
				if(len(get_finance_info.karsiliksiz_pos_tutar))
					{
					toplam2 = toplam2 + get_finance_info.karsiliksiz_pos_tutar;
					if(len(get_finance_info.karsiliksiz_pos_ortgun))
						{
							toplam11 = toplam11 + get_finance_info.karsiliksiz_pos_tutar*get_finance_info.karsiliksiz_pos_ortgun;
						}
					}
				if(len(get_finance_info.karsiliksiz_kk_tutar))
					{
					toplam2 = toplam2 + get_finance_info.karsiliksiz_kk_tutar;
					if(len(get_finance_info.karsiliksiz_kk_ortgun))
						{
							toplam11 = toplam11 + get_finance_info.karsiliksiz_kk_tutar*get_finance_info.karsiliksiz_kk_ortgun;
						}
					}
				if(toplam2 neq 0)
					deger_gecmis_ortalama_gun = toplam11/toplam2;
					
				if(len(get_finance_info.vadeli_cek_adet))
					toplam3 = toplam3 + get_finance_info.vadeli_cek_adet;
				if(len(get_finance_info.vadeli_senet_adet))
					toplam3 = toplam3 + get_finance_info.vadeli_senet_adet;
				if(len(get_finance_info.vadeli_senet_adet))
					toplam3 = toplam3 + get_finance_info.vadeli_pos_adet;
				if(len(get_finance_info.vadeli_senet_adet))
					toplam3 = toplam3 + get_finance_info.vadeli_kk_adet;
				
				if(len(get_finance_info.vadeli_cek_tutar))
					{
					toplam4 = toplam4 + get_finance_info.vadeli_cek_tutar;
					if(len(get_finance_info.vadeli_cek_ortgun))
						{
							toplam12 = toplam12 + get_finance_info.vadeli_cek_tutar*get_finance_info.vadeli_cek_ortgun;
						}
					}
				if(len(get_finance_info.vadeli_senet_tutar))
					{
					toplam4 = toplam4 + get_finance_info.vadeli_senet_tutar;
					if(len(get_finance_info.vadeli_senet_ortgun))
						{
							toplam12 = toplam12 + get_finance_info.vadeli_senet_tutar*get_finance_info.vadeli_senet_ortgun;
						}
					}
				if(len(get_finance_info.vadeli_pos_tutar))
					toplam4 = toplam4 + get_finance_info.vadeli_pos_tutar;
					if(len(get_finance_info.vadeli_pos_ortgun))
						{
							toplam12 = toplam12 + get_finance_info.vadeli_pos_tutar*get_finance_info.vadeli_pos_ortgun;
						}
				if(len(get_finance_info.vadeli_kk_tutar))
					toplam4 = toplam4 + get_finance_info.vadeli_kk_tutar;
					if(len(get_finance_info.vadeli_kk_ortgun))
						{
							toplam12 = toplam12 + get_finance_info.vadeli_kk_tutar*get_finance_info.vadeli_kk_ortgun;
						}
				if(toplam4 neq 0)
					deger_vadeli_ortalama_gun = toplam12 / toplam4;
					
				if(len(get_finance_info.risk_toplam))
					toplam5 = get_finance_info.risk_toplam;
				
				if(len(get_credit.total_risk_limit))
					toplam6 = get_credit.total_risk_limit;
					
				if(len(get_finance_info.acik_hesap_bakiye))
					{ value1 = value1 + get_finance_info.acik_hesap_bakiye; }
				value2 = value2 + toplam1;
				value3 = value3 + toplam2;
				value4 = value4 + toplam3;
				value5 = value5 + toplam4;
				value6 = value6 + toplam5;
				value7 = value7 + toplam6;
				value8 = value8 + toplam6 - toplam5;
				if(len(get_finance_info.borc))
					{ value9 = value9 + get_finance_info.borc; }
				if(len(get_finance_info.devir_borc))
					{ value9 = value9 - get_finance_info.devir_borc ; }
				if(len(get_finance_info.karsiliksiz_cek_tutar) and len(get_finance_info.karsiliksiz_cek_ortgun))
				{
					toplam7 = toplam7 + get_finance_info.karsiliksiz_cek_tutar * get_finance_info.karsiliksiz_cek_ortgun;
					toplam8 = toplam8 + get_finance_info.karsiliksiz_cek_ortgun;
				}
				if(len(get_finance_info.karsiliksiz_kk_tutar) and len(get_finance_info.karsiliksiz_kk_ortgun))
				{
					toplam7 = toplam7 + get_finance_info.karsiliksiz_kk_tutar * get_finance_info.karsiliksiz_kk_ortgun;
					toplam8 = toplam8 + get_finance_info.karsiliksiz_kk_ortgun;
				}
				if(len(get_finance_info.karsiliksiz_pos_tutar) and len(get_finance_info.karsiliksiz_pos_ortgun))
				{
					toplam7 = toplam7 + get_finance_info.karsiliksiz_pos_tutar * get_finance_info.karsiliksiz_pos_ortgun;
					toplam8 = toplam8 + get_finance_info.karsiliksiz_pos_ortgun;
				}
				
				if(len(get_finance_info.karsiliksiz_senet_tutar) and len(get_finance_info.karsiliksiz_senet_ortgun))
				{
					toplam7 = toplam7 + get_finance_info.karsiliksiz_senet_tutar * get_finance_info.karsiliksiz_senet_ortgun;
					toplam8 = toplam8 + get_finance_info.karsiliksiz_senet_ortgun;
				}
				if(toplam8 gt 0)
				{
					value10 = toplam7 / toplam8;
				}
				else
				{
					value10 = 0;
				}
				if(len(get_finance_info.vadeli_cek_tutar) and len(get_finance_info.vadeli_cek_ortgun))
				{
					toplam9 = toplam9 + get_finance_info.vadeli_cek_tutar * get_finance_info.vadeli_cek_ortgun;
					toplam10 = toplam10 + get_finance_info.vadeli_cek_ortgun;
				}
				if(len(get_finance_info.vadeli_kk_tutar) and len(get_finance_info.vadeli_kk_ortgun))
				{
					toplam9 = toplam9 + get_finance_info.vadeli_kk_tutar * get_finance_info.vadeli_kk_ortgun;
					toplam10 = toplam10 + get_finance_info.vadeli_kk_ortgun;
				}
				if(len(get_finance_info.vadeli_pos_tutar) and len(get_finance_info.vadeli_pos_ortgun))
				{
					toplam9 = toplam9 + get_finance_info.vadeli_pos_tutar * get_finance_info.vadeli_pos_ortgun;
					toplam10 = toplam10 + get_finance_info.vadeli_pos_ortgun;
				}
				if(len(get_finance_info.vadeli_senet_tutar) and len(get_finance_info.vadeli_senet_ortgun))
				{
					toplam9 = toplam9 + get_finance_info.vadeli_senet_tutar * get_finance_info.vadeli_senet_ortgun;
					toplam10 = toplam10 + get_finance_info.vadeli_senet_ortgun;
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
			<cfset deger_value_ciro = 0>
			<cfif len(get_finance_info.borc)>
				<cfset deger_value_ciro = deger_value_ciro + get_finance_info.borc>
			</cfif>
			<cfif len(get_finance_info.devir_borc)>
				<cfset deger_value_ciro = deger_value_ciro - get_finance_info.devir_borc>
			</cfif>
			<table>
                <tr>
                    <td class="txtbold"><font color="##FF6600"><cf_get_lang no='677.Aktarım Tarihi'></font></td>
                    <td class="txtbold"><font color="##FF6600">: #dateformat(get_finance_info.aktarim_tarih,dateformat_style)#</font></td>
                </tr>
                <tr>
                    <td class="txtbold"><font color="##FF6600">Kümüle <cf_get_lang no='1.Ciro'> #year(now())#</font></td>
                    <td class="txtbold" nowrap><font color="##FF6600">: #tlformat(get_fatsay_musteri.toplam_tutar)# #session.ep.money#</font></td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang_main no='175.Borç'></td>
                    <td>: #tlformat(toplam40)# #session.ep.money#</td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang_main no='176.Alacak'></td>
                    <td>: #tlformat(toplam41)# #session.ep.money#</td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang_main no='177.Bakiye'></td>
                    <td>: #tlformat(toplam42)# #session.ep.money#</td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang no='475.Açık Hesap'></td>
                    <td>: <cfif len(get_finance_info.acik_hesap_bakiye)>#tlformat(get_finance_info.acik_hesap_bakiye)#<cfelse>#tlformat(0)#</cfif> #session.ep.money#</td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang no='511.Vd  Geçmiş Evr  Ad '></td>
                    <td nowrap>: #tlformat(toplam1,0)# Adet</td>
                </tr>
                <tr>
                    <td class="txtbold">&nbsp;&nbsp;&nbsp;<cf_get_lang no='517.Vd  Geçmiş Çek Ad '></td>
                    <td nowrap>: #tlformat(get_finance_info.karsiliksiz_cek_adet,0)# Adet</td>
                </tr>
                <tr>
                    <td class="txtbold">&nbsp;&nbsp;&nbsp;<cf_get_lang no='518.Vd  Geçmiş Senet Ad '></td>
                    <td nowrap>: #tlformat(get_finance_info.karsiliksiz_senet_adet,0)# Adet</td>
                </tr>
                <tr>
                    <td class="txtbold">&nbsp;&nbsp;&nbsp;<cf_get_lang no='520.Vd  Geçmiş Pos Ad '></td>
                    <td nowrap>: #tlformat(get_finance_info.karsiliksiz_pos_adet,0)# Adet</td>
                </tr>
                <tr>
                    <td class="txtbold">&nbsp;&nbsp;&nbsp;<cf_get_lang no='527.Vd  Geçmiş KK Ad '></td>
                    <td nowrap>: #tlformat(get_finance_info.karsiliksiz_kk_adet,0)# Adet</td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang no='528.Vd  Geçmiş Evr  Ttr '></td>
                    <td nowrap>: #tlformat(toplam2)# #session.ep.money#</td>
                </tr>
                <tr>
                    <td class="txtbold">&nbsp;&nbsp;&nbsp;<cf_get_lang no='529.Vd  Geçmiş Çek Ttr '></td>
                    <td nowrap>: #tlformat(get_finance_info.karsiliksiz_cek_tutar)# #session.ep.money#</td>
                </tr>
                <tr>
                    <td class="txtbold">&nbsp;&nbsp;&nbsp;<cf_get_lang no='530.Vd  Geçmiş Senet Ttr '></td>
                    <td nowrap>: #tlformat(get_finance_info.karsiliksiz_senet_tutar)# #session.ep.money#</td>
                </tr>
                <tr>
                    <td class="txtbold">&nbsp;&nbsp;&nbsp;<cf_get_lang no='531.Vd  Geçmiş Pos Ttr '></td>
                    <td nowrap>: #tlformat(get_finance_info.karsiliksiz_pos_tutar)# #session.ep.money#</td>
                </tr>
                <tr>
                    <td class="txtbold">&nbsp;&nbsp;&nbsp;<cf_get_lang no='532.Vd  Geçmiş KK Ttr '></td>
                    <td nowrap>: #tlformat(get_finance_info.karsiliksiz_kk_tutar)# #session.ep.money#</td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang no='569.Vd  Geçmiş Evr  Ort  Gün'></td>
                    <td nowrap>: #tlformat(deger_gecmis_ortalama_gun,0,1)# Gün</td>
                </tr>
                <tr>
                    <td class="txtbold">&nbsp;&nbsp;&nbsp;<cf_get_lang no='571.Vd  Geçmiş Evr  Ort  Çek Gün'></td>
                    <td nowrap>: #get_finance_info.karsiliksiz_cek_ortgun# Gün</td>
                </tr>
                <tr>
                    <td class="txtbold">&nbsp;&nbsp;&nbsp;<cf_get_lang no='597.Vd  Geçmiş Evr  Ort  Senet Gün'></td>
                    <td nowrap>: #get_finance_info.karsiliksiz_senet_ortgun# Gün</td>
                </tr>
                <tr>
                    <td class="txtbold">&nbsp;&nbsp;&nbsp;<cf_get_lang no='624.Vd  Geçmiş Evr  Ort  Pos Gün'></td>
                    <td nowrap>: #tlformat(get_finance_info.karsiliksiz_pos_ortgun,0)# Gün</td>
                </tr>
                <tr>
                    <td class="txtbold">&nbsp;&nbsp;&nbsp;<cf_get_lang no='626.Vd  Geçmiş Evr  Ort  KK Gün'></td>
                    <td nowrap>: #tlformat(get_finance_info.karsiliksiz_kk_ortgun,0)# Gün</td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang no='628.Vd  Gelmemiş Evr  Ad '></td>
                    <td nowrap>: #tlformat(toplam3,0)# Adet</td>
                </tr>
                <tr>
                    <td class="txtbold">&nbsp;&nbsp;&nbsp;<cf_get_lang no='631.Vd  Gelmemiş Çek Ad '></td>
                    <td nowrap>: #tlformat(get_finance_info.vadeli_cek_adet,0)# Adet</td>
                </tr>
                <tr>
                    <td class="txtbold">&nbsp;&nbsp;&nbsp;<cf_get_lang no='632.Vd  Gelmemiş Senet Ad '></td>
                    <td nowrap>: #tlformat(get_finance_info.vadeli_senet_adet,0)# Adet</td>
                </tr>
                <tr>
                    <td class="txtbold">&nbsp;&nbsp;&nbsp;<cf_get_lang no='633.Vd  Gelmemiş Pos Ad '></td>
                    <td nowrap>: #tlformat(get_finance_info.vadeli_pos_adet,0)# Adet</td>
                </tr>
                <tr>
                    <td class="txtbold">&nbsp;&nbsp;&nbsp;<cf_get_lang no='634.Vd  Gelmemiş KK Ad '></td>
                    <td nowrap>: #tlformat(get_finance_info.vadeli_kk_adet,0)# Adet</td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang no='635.Vd  Gelmemiş Evr  Ttr '></td>
                    <td nowrap>: #tlformat(toplam4)# #session.ep.money#</td>
                </tr>
                <tr>
                    <td class="txtbold">&nbsp;&nbsp;&nbsp;<cf_get_lang no='635.Vd  Gelmemiş Çek Ttr '></td>
                    <td nowrap>: #tlformat(get_finance_info.vadeli_cek_tutar)# #session.ep.money#</td>
                </tr>
                <tr>
                    <td class="txtbold">&nbsp;&nbsp;&nbsp;<cf_get_lang no='636.Vd  Gelmemiş Senet Ttr '></td>
                    <td nowrap>: #tlformat(get_finance_info.vadeli_senet_tutar)# #session.ep.money#</td>
                </tr>
                <tr>
                    <td class="txtbold">&nbsp;&nbsp;&nbsp;<cf_get_lang no='636.Vd  Gelmemiş Pos Ttr '></td>
                    <td nowrap>: #tlformat(get_finance_info.vadeli_pos_tutar)# #session.ep.money#</td>
                </tr>
                <tr>
                    <td class="txtbold">&nbsp;&nbsp;&nbsp;<cf_get_lang no='638.Vd  Gelmemiş KK Ttr '></td>
                    <td nowrap>: #tlformat(get_finance_info.vadeli_kk_tutar)# #session.ep.money#</td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang no='639.Vd  Gelmemiş Evr  Ort  Gün'></td>
                    <td nowrap>: #tlformat(deger_vadeli_ortalama_gun,0,1)# Gün</td>
                </tr>
                <tr>
                    <td class="txtbold">&nbsp;&nbsp;&nbsp;<cf_get_lang no='640.Vd  Gelmemiş Evr  Ort  Çek Gün'></td>
                    <td nowrap>: #get_finance_info.vadeli_cek_ortgun# Gün</td>
                </tr>
                <tr>
                    <td class="txtbold">&nbsp;&nbsp;&nbsp;<cf_get_lang no='641.Vd  Gelmemiş Evr  Ort  Senet Gün'></td>
                    <td nowrap>: #get_finance_info.vadeli_senet_ortgun# Gün</td>
                </tr>
                <tr>
                    <td class="txtbold">&nbsp;&nbsp;&nbsp;<cf_get_lang no='643.Vd  Gelmemiş Evr  Ort  Pos Gün'></td>
                    <td nowrap>: #get_finance_info.vadeli_pos_ortgun# Gün</td>
                </tr>
                <tr>
                    <td class="txtbold">&nbsp;&nbsp;&nbsp;<cf_get_lang no='652.Vd  Gelmemiş Evr  Ort  KK Gün'></td>
                    <td nowrap>: #get_finance_info.vadeli_kk_ortgun# Gün</td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang_main no='460.Toplam Risk'></td>
                    <td nowrap>: #tlformat(toplam5)# #session.ep.money#</td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang no='135. Risk Limiti'></td>
                    <td nowrap>: #tlformat(toplam6)# #session.ep.money#</td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang no='331.Grup Risk Limiti'></td>
                    <td nowrap>: #tlformat(get_company.grup_risk_limit)# #get_company.money_currency#</td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang_main no='1171.Fark'></td>
                    <td nowrap>: 
                        <cfif len(get_company.grup_risk_limit)>
                            <cfset grup_risk_limit_deger = get_company.grup_risk_limit>
                        <cfelse>
                            <cfset grup_risk_limit_deger = 0>
                        </cfif>
                        <cfif grup_risk_limit_deger - toplam6 lt 0>
                            <font color="##FF0000">#tlformat(grup_risk_limit_deger-toplam6)# #get_company.money_currency#</font>
                        <cfelseif grup_risk_limit_deger - toplam6 eq 0>
                            <font color="##FFFF66">#tlformat(grup_risk_limit_deger-toplam6)# #get_company.money_currency#</font>
                        <cfelse>
                            <font color="##33CC33">#tlformat(grup_risk_limit_deger-toplam6)# #get_company.money_currency#</font>
                        </cfif>
                    </td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang no='151.Tahmini Ciro'></td>
                    <td nowrap>: 
                        <cfif len(get_company.endorse_period)>
                            <cfif get_company.endorse_period eq 1><cf_get_lang no='659.Aylik'></cfif>
                            <cfif get_company.endorse_period eq 2>2 <cf_get_lang no='659.Aylik'></cfif>
                            <cfif get_company.endorse_period eq 3>3 <cf_get_lang no='659.Aylik'></cfif>
                            <cfif get_company.endorse_period eq 4>4 <cf_get_lang no='659.Aylik'></cfif>
                            <cfif get_company.endorse_period eq 5>6 <cf_get_lang no='659.Aylik'></cfif>
                            <cfif get_company.endorse_period eq 6><cf_get_lang no='742.Yillik'></cfif> - 
                        </cfif>
                        <cfif len(get_company.endorse_payment)>#tlformat(get_company.endorse_payment)# #get_company.endorse_currency#</cfif>
                    </td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang no='134.Serbesti'></td>
                    <td nowrap>: <cfif toplam6-toplam5 eq 0>#tlformat(0)#<cfelse>#tlformat(toplam6-toplam5)#</cfif> #session.ep.money#</td>
                </tr>
            </table>
			</cfoutput>
		<cfcatch>
			<table>
				<tr>
					<td valign="top"><cf_get_lang no='744.Oracle DB sinden Data Çekildiği İçin Test Ortamında Hata Verebilir !'> !</td>
				</tr>
			</table>
		</cfcatch>
	</cftry>
<cfelse>
	<table>
		<tr>
			<td valign="top"><cf_get_lang_main no='1167.Lütfen Şube Seçiniz '>!</td>
		</tr>
	</table>
</cfif>
