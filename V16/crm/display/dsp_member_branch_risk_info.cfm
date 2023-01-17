<!--- Sube Risk Bilgileri - Sube Risk Raporundan Gelen Alanlari Icerir- Tum Risk Yonetimi Sayfalarinda Kullaniliyor Dikkat FBS 20100317 --->
<cfif isDefined("form_branch_id") and Len(form_branch_id) and isDefined("form_company_id") and Len(form_company_id)>
	<cf_seperator title="#getLang('','Şube Risk Bilgileri','30550')#" id="branch_risk_info">
		<div id="branch_risk_info">
			<cftry>
				<cfquery name="Get_Authorized_Branch" datasource="#DSN#">
					SELECT
						BRANCH.BRANCH_NAME,
						BRANCH.BRANCH_ID,
						COMPANY_BOYUT_DEPO_KOD.BOYUT_KODU
					FROM 
						BRANCH,
						COMPANY_BOYUT_DEPO_KOD
					WHERE
						BRANCH.BRANCH_ID = #form_branch_id# AND
						COMPANY_BOYUT_DEPO_KOD.W_KODU = BRANCH.BRANCH_ID AND
						COMPANY_BOYUT_DEPO_KOD.AKTIF = 1 AND
						BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
					ORDER BY
						BRANCH_NAME
				</cfquery>
				<cfif Get_Authorized_Branch.RecordCount>
					<cfset Branch_Id_New_ = "">
					<cfoutput query="Get_Authorized_Branch">
						<cfset Values_ = "#branch_id#;#branch_name#;#boyut_kodu#">
						<cfif ListLen(Values_,';') and Not ListFind(Branch_Id_New_,Values_,',')>
							<cfset Branch_Id_New_ = ListAppend(Branch_Id_New_,Values_,',')>
						</cfif>
					</cfoutput>
					<cfloop from="1" to="#listlen(Branch_Id_New_,',')#" index="i">
						<cfset degisken_branch_id = listgetat(Branch_Id_New_,i,',')>
						<cfquery name="GET_COMPANY" datasource="#DSN#">
							SELECT DISTINCT
								COMPANY_CREDIT.TOTAL_RISK_LIMIT,
								COMPANY_CREDIT.MONEY,
								COMPANY.COMPANY_ID,
								COMPANY.MANAGER_PARTNER_ID,
								COMPANY.FULLNAME, 
								COMPANY.SEMT,
								COMPANY.COUNTY,
								COMPANY.CITY,
								COMPANY.IMS_CODE_ID,
								COMPANY.COMPANYCAT_ID,
								BRANCH.BRANCH_ID,
								BRANCH.BRANCH_NAME,
								COMPANY_BRANCH_RELATED.RELATED_ID,
								COMPANY_BRANCH_RELATED.OPS_RATE,
								COMPANY_BRANCH_RELATED.OPS_DAY,
								COMPANY_BRANCH_RELATED.BOX_OPS_RATE,
								COMPANY_BRANCH_RELATED.COMPANY_ID AS HEDEF_KODU,
								COMPANY_BRANCH_RELATED.MUSTERIDURUM,
								COMPANY_BRANCH_RELATED.CARIHESAPKOD,
								COMPANY_BRANCH_RELATED.CUSTOMER_CONTRACT_STATUTE
							FROM 
								COMPANY_CREDIT,
								COMPANY,
								COMPANY_BRANCH_RELATED,
								BRANCH,
								SALES_ZONES,
								SALES_ZONES_TEAM,
								SALES_ZONES_TEAM_IMS_CODE,
								COMPANY_BOYUT_DEPO_KOD,
								EMPLOYEE_POSITION_BRANCHES
							WHERE 
								COMPANY_CREDIT.BRANCH_ID = COMPANY_BRANCH_RELATED.RELATED_ID AND
								SALES_ZONES.RESPONSIBLE_BRANCH_ID = BRANCH.BRANCH_ID AND
								SALES_ZONES.SZ_ID = SALES_ZONES_TEAM.SALES_ZONES AND
								SALES_ZONES_TEAM.TEAM_ID = SALES_ZONES_TEAM_IMS_CODE.TEAM_ID AND
								SALES_ZONES_TEAM_IMS_CODE.IMS_ID = COMPANY.IMS_CODE_ID AND
								COMPANY_BRANCH_RELATED.COMPANY_ID = COMPANY.COMPANY_ID AND
								BRANCH.BRANCH_ID = COMPANY_BRANCH_RELATED.BRANCH_ID AND
								COMPANY_BOYUT_DEPO_KOD.W_KODU = BRANCH.BRANCH_ID AND
								EMPLOYEE_POSITION_BRANCHES.BRANCH_ID = COMPANY_BRANCH_RELATED.BRANCH_ID AND
								EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code# AND
								COMPANY_BRANCH_RELATED.DEPOT_DAK IS NOT NULL
								AND COMPANY.COMPANY_ID = #form_company_id#
								AND COMPANY_BRANCH_RELATED.BRANCH_ID IN (#listfirst(degisken_branch_id,';')#)
							ORDER BY
								COMPANY.FULLNAME
						</cfquery>
						<cfquery name="get_musteridurum_hedef" datasource="hedef_crm">
							SELECT
								HMD.KARSILIKSIZ_CEK_TUTAR, 
								HMD.KARSILIKSIZ_CEK_ORTGUN, 
								HMD.KARSILIKSIZ_SENET_TUTAR, 
								HMD.KARSILIKSIZ_SENET_ORTGUN, 
								HMD.KARSILIKSIZ_POS_TUTAR, 
								HMD.KARSILIKSIZ_POS_ORTGUN, 
								HMD.KARSILIKSIZ_KK_TUTAR, 
								HMD.KARSILIKSIZ_KK_ORTGUN, 
								HMD.KARSILIKSIZ_ACIKHESAP_TUTAR, 
								HMD.KARSILIKSIZ_ACIKHESAP_ORTGUN, 
								HMD.RISK_LIMIT, 
								HMD.RISK_TOPLAM, 
				
								((HMD.KARSILIKSIZ_CEK_TUTAR*HMD.KARSILIKSIZ_CEK_ORTGUN) + (HMD.KARSILIKSIZ_SENET_TUTAR*HMD.KARSILIKSIZ_SENET_ORTGUN) + (HMD.KARSILIKSIZ_POS_TUTAR*HMD.KARSILIKSIZ_POS_ORTGUN)+ (HMD.KARSILIKSIZ_KK_TUTAR*HMD.KARSILIKSIZ_KK_ORTGUN)+ (HMD.KARSILIKSIZ_ACIKHESAP_TUTAR*HMD.KARSILIKSIZ_ACIKHESAP_ORTGUN))/(HMD.KARSILIKSIZ_CEK_TUTAR+HMD.KARSILIKSIZ_SENET_TUTAR+HMD.KARSILIKSIZ_POS_TUTAR+HMD.KARSILIKSIZ_KK_TUTAR+HMD.KARSILIKSIZ_ACIKHESAP_TUTAR+1) TOTAL_ORT_GUN,
								(HMD.KARSILIKSIZ_CEK_TUTAR+HMD.KARSILIKSIZ_SENET_TUTAR+HMD.KARSILIKSIZ_POS_TUTAR+HMD.KARSILIKSIZ_KK_TUTAR+HMD.KARSILIKSIZ_ACIKHESAP_TUTAR+1) TOTAL_TUTAR,
								HMD.DEPO_KODU,
								HMD.HEDEFKODU
							FROM 
								(SELECT MAX(AKTARIM_TARIH) TARIH, HEDEFKODU, DEPO_KODU 
								FROM HEDEF.HEDEF_MUSTERI_DURUM WHERE DEPO_KODU IS NOT NULL 
								and hedefkodu > 0 and aktarim_tarih > sysdate-30 
								AND DEPO_KODU = '#listlast(degisken_branch_id,';')#'
							GROUP BY HEDEFKODU, DEPO_KODU ) Q1,
								HEDEF.HEDEF_MUSTERI_DURUM HMD
							WHERE
								HMD.AKTARIM_TARIH = Q1.TARIH AND
								HMD.aktarim_tarih > sysdate-30 and
								HMD.HEDEFKODU = Q1.HEDEFKODU AND
								HMD.DEPO_KODU = Q1.DEPO_KODU AND
								HMD.HEDEFKODU > 0 AND
								(HMD.KARSILIKSIZ_CEK_TUTAR+HMD.KARSILIKSIZ_SENET_TUTAR+HMD.KARSILIKSIZ_POS_TUTAR+HMD.KARSILIKSIZ_KK_TUTAR+HMD.KARSILIKSIZ_ACIKHESAP_TUTAR+1) <> 0 AND
								HMD.DEPO_KODU = '#listlast(degisken_branch_id,';')#'
						</cfquery>
						<cfquery name="get_musteridurum" dbtype="query">
							SELECT
								*
							FROM
								GET_MUSTERIDURUM_HEDEF,
								GET_COMPANY
							 WHERE
								GET_MUSTERIDURUM_HEDEF.HEDEFKODU = GET_COMPANY.COMPANY_ID
							ORDER BY
								GET_COMPANY.FULLNAME
						</cfquery>
						<!--- Bulunan ayin bir onceki ayin ilk gununun uc ay oncesi , Bulunan ayin bir unceki ayinin son gun (3 aylik ciro rakamlari icin eklendi) --->
						<cfquery name="get_musteridurum_ort" datasource="hedef_crm">
							SELECT
								SUM(NORMAL_FAT_TUTAR+ACIL_FAT_TUTAR+SERVIS_FAT_TUTAR+IADE_TUTAR)/3 UCAYLIK_ORTALAMA_TUTAR,
								HEDEFKODU
							FROM
								HEDEF.HEDEF_MUSTERI_FATSAY
							WHERE
								HEDEFKODU = #form_company_id# AND
								TARIH >= #DATEADD("m",-3,createdate(year(now()),month(now()),1))# AND
								TARIH <= #DATEADD("d",-1,createdate(year(now()),month(now()),1))# AND 
								DEPO_KODU = '#listlast(degisken_branch_id,';')#'
							GROUP BY
								HEDEFKODU
						</cfquery>
						<!--- Teminat Tablosu - Aktif olan kayıtların toplamlarini aliyor --->
						<cfquery name="get_securefund" datasource="#dsn#">
							SELECT
								SUM(SECUREFUND_TOTAL) SECURE_TOTAL,
								COMPANY_ID,
								BRANCH_ID,
								SECUREFUND_CAT_ID,
								MORTGAGE_RATE
							FROM
								COMPANY_SECUREFUND
							WHERE
								SECUREFUND_STATUS = 1 AND
								COMPANY_ID = #form_company_id#
							GROUP BY
								COMPANY_ID,
								BRANCH_ID,
								SECUREFUND_CAT_ID,
								MORTGAGE_RATE
						</cfquery>
						<cfif get_musteridurum.recordcount>
							<cfoutput query="get_musteridurum">
								<!--- NOT : Branch_id kolonuna related_id gonderildigi icin burada da kosul o sekilde duzenlendi --->
								<!--- Aktif, Kategorisi ipotek(21) ve ipotek derecesi 1 olan teminat tutarlari --->
								<cfquery name="get_secure_ipotek_1" dbtype="query">
									SELECT SUM(SECURE_TOTAL) SECURE_TOTAL FROM GET_SECUREFUND WHERE BRANCH_ID = #related_id# AND SECUREFUND_CAT_ID = 21 AND MORTGAGE_RATE = 1
								</cfquery>
								<!--- Aktif, Kategorisi ipotek(21) ve ipotek derecesi 1 olmayan teminat tutarlari --->
								<cfquery name="get_secure_ipotek_234" dbtype="query">
									SELECT SUM(SECURE_TOTAL) SECURE_TOTAL FROM GET_SECUREFUND WHERE BRANCH_ID = #related_id# AND SECUREFUND_CAT_ID = 21 AND MORTGAGE_RATE <> 1
								</cfquery>
								<!--- Aktif, Kategorisi teminat(1) olan teminat tutarlari --->
								<cfquery name="get_secure_teminat" dbtype="query">
									SELECT SUM(SECURE_TOTAL) SECURE_TOTAL FROM GET_SECUREFUND WHERE BRANCH_ID = #related_id# AND SECUREFUND_CAT_ID = 1
								</cfquery>
								<tr class="color-row">
									<td>
									<table>
										<tr>
											<td class="txtboldblue" width="160"><cf_get_lang dictionary_id="1. Derece İpotekler"></td>
											<td  style="text-align:right;"><cfif len(get_secure_ipotek_1.secure_total)>#TLFormat(get_secure_ipotek_1.secure_total)#</cfif></td>
											<td width="25">&nbsp;</td>
											<td class="txtboldblue" width="160"><cf_get_lang dictionary_id="56102.Çek Ort.Gün"></td>
											<td  style="text-align:right;">#karsiliksiz_cek_ortgun#</td>
											<td width="25">&nbsp;</td>
											<td class="txtboldblue" width="160">Top.Gec.Risk Seviye Tutar</td>
											<td  style="text-align:right;">#tlformat(total_tutar)#</td>
										</tr>
										<tr>
											<td class="txtboldblue"><cf_get_lang dictionary_id="56103.Diğer İpotekler"></td>
											<td  style="text-align:right;"><cfif len(get_secure_ipotek_234.secure_total)>#TLFormat(get_secure_ipotek_234.secure_total)#</cfif></td>
											<td>&nbsp;</td>
											<td class="txtboldblue"><cf_get_lang dictionary_id="56105.Çek Tutar"></td>
											<td  style="text-align:right;">#tlformat(karsiliksiz_cek_tutar)#</td>
											<td>&nbsp;</td>
											<td class="txtboldblue"><cf_get_lang dictionary_id="56106.Risk Ort.Gün"></td>
											<td  style="text-align:right;">#tlformat(total_ort_gun)#</td>
										</tr>
										<tr>
											<td class="txtboldblue"><cf_get_lang dictionary_id="58689.Teminat"></td>
											<td  style="text-align:right;"><cfif len(get_secure_teminat.secure_total)>#TLFormat(get_secure_teminat.secure_total)#</cfif></td>
											<td>&nbsp;</td>
											<td class="txtboldblue"><cf_get_lang dictionary_id="56107.Senet Ort.Gün"></td>
											<td  style="text-align:right;">#karsiliksiz_senet_ortgun#</td>
											<td>&nbsp;</td>
											<td class="txtboldblue"><cf_get_lang dictionary_id="56108.Depo Oluşan Risk"></td>
											<td  style="text-align:right;">#tlformat(risk_toplam)#</td>
										</tr>
										<tr>
											<td class="txtboldblue"><cf_get_lang dictionary_id="56113.OPG"></td>
											<td  style="text-align:right;">#ops_day#</td>
											<td>&nbsp;</td>
											<td class="txtboldblue"><cf_get_lang dictionary_id="50196.Senet Tutar"></td>
											<td  style="text-align:right;">#tlformat(karsiliksiz_senet_tutar)#</td>
											<td>&nbsp;</td>
											<td class="txtboldblue"><cf_get_lang dictionary_id="56124.3 Aylık Ciro"></td>
											<td  style="text-align:right;"><cfif len(get_musteridurum_ort.ucaylik_ortalama_tutar)>#tlformat(get_musteridurum_ort.ucaylik_ortalama_tutar)#<cfelse>#tlformat(0)#</cfif></td>
										</tr>
										<tr>
											<td class="txtboldblue"><cf_get_lang dictionary_id="56125.CPO"></td>
											<td  style="text-align:right;">#TLFormat(ops_rate)#</td>
											<td>&nbsp;</td>
											<td class="txtboldblue"><cf_get_lang dictionary_id="56156.Açık Hesap Ort.Gün"></td>
											<td  style="text-align:right;">#karsiliksiz_acikhesap_ortgun#</td>
											<td>&nbsp;</td>
											<td class="txtboldblue"><cf_get_lang dictionary_id="56177.RO/CO"></td>
											<td  style="text-align:right;"><cfif (len(get_musteridurum_ort.ucaylik_ortalama_tutar) and len(risk_toplam) and get_musteridurum_ort.ucaylik_ortalama_tutar neq 0 and risk_toplam neq 0)>#tlformat(risk_toplam/get_musteridurum_ort.ucaylik_ortalama_tutar)#<cfelse>-</cfif></td>							
										</tr>
										<tr>
											<td class="txtboldblue"><cf_get_lang dictionary_id="56178.KTPO"></td>
											<td  style="text-align:right;">#TLFormat(box_ops_rate)#</td>
											<td>&nbsp;</td>
											<td class="txtboldblue"><cf_get_lang dictionary_id="56181.Açık Hesap Tutar"></td>
											<td  style="text-align:right;">#tlformat(karsiliksiz_acikhesap_tutar)#</td>
											<td>&nbsp;</td>
											<td class="txtboldblue"><cf_get_lang dictionary_id="49667.Risk Limiti"></td>
											<td  style="text-align:right;">#tlFormat(total_risk_limit)#</td>
										</tr>
										<tr>
											<td colspan="6">&nbsp;</td>
											<td class="txtboldblue">RL/DOR (%)</td>
											<td  style="text-align:right;"><cfif len(total_risk_limit) and len(risk_toplam) and total_risk_limit neq 0 and risk_toplam neq 0>#tlFormat((((total_risk_limit-risk_toplam)/risk_toplam)*100))#<cfelse>-</cfif></td>
										</tr>
									</table>
									</td>
								</tr>
							</cfoutput>
						</cfif>
					</cfloop>
				<cfelse>
					<tr class="color-row" valign="top">
						<td valign="top"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
					</tr>
				</cfif>
				<cfcatch>
					<tr class="color-row" valign="top">
						<td valign="top"><cf_get_lang dictionary_id='52191.Oracle DB sinden Data Çekildiği İçin Test Ortamında Hata Verebilir !'> !</td>
					</tr>
				</cfcatch>
			</cftry>
		</div>
</cfif>
