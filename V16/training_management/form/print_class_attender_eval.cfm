<cfset attributes.class_id = attributes.id>
<cfinclude template="../query/get_class_attender_eval.cfm">

<cfquery name="get_emp_att" datasource="#dsn#">
  SELECT EMP_ID FROM TRAINING_CLASS_ATTENDER WHERE CLASS_ID=#attributes.CLASS_ID# AND EMP_ID IS NOT NULL AND PAR_ID IS NULL AND CON_ID IS NULL
</cfquery>

<cfinclude template="../display/view_class.cfm">

<table cellpadding="0" cellspacing="0" width="650" align="center">
<tr>
<td class="headbold" height="35"><cf_get_lang no='224.Katılımcı Değerlendirme Formu'></td>
</tr>
</table>

<table width="650" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr class="color-border">
    <td>
<table width="100%" border="0" cellspacing="1" cellpadding="2" height="100%">
  <tr class="color-row">
    <td valign="top" colspan="2">
					<table border="0" width="100%">
                      <tr class="txtboldblue">
                        <td width="150" height="25" valign="bottom"><cf_get_lang_main no='158.Ad Soyad'></td>
                        <td width="15" style="writing-mode : tb-rl;direction : rtl;"><cf_get_lang no='225.Seminere İlgi'></td>
                        <td width="15" style="writing-mode : tb-rl;direction : rtl;"><cf_get_lang no='226.Tartışmalara Katılım'></td>
                        <td width="15" style="writing-mode : tb-rl;direction : rtl;"><cf_get_lang no='227.Öğrenme Motivasyonu'></td>
                        <td width="15" style="writing-mode : tb-rl;direction : rtl;"><cf_get_lang no='228.Fikir Üretme'></td>
                        <td width="15" style="writing-mode : tb-rl;direction : rtl;"><cf_get_lang no='229.Karşı Fikre Saygı'></td>
                        <td width="15" style="writing-mode : tb-rl;direction : rtl;"><cf_get_lang no='230.Yeniliğe Açıklık'></td>
                        <td width="15" style="writing-mode : tb-rl;direction : rtl;"><cf_get_lang no='231.Değişime İnanç'></td>
                        <td width="15" style="writing-mode : tb-rl;direction : rtl;"><cf_get_lang_main no='678.İletişim Becerisi'></td>
                        <td valign="bottom"><cf_get_lang_main no='10.Notlar'></td>
                      </tr>
					  <cfoutput query="GET_CLASS_ATTENDER_EVAL">
					  <cfset attributes.employee_id = EMP_ID>	
					  <cfinclude template="../query/get_employee.cfm">
                      <tr class="color-list">
                        <td nowrap class="txtbold" height="20">
							#GET_EMPLOYEE.EMPLOYEE_NAME# #GET_EMPLOYEE.EMPLOYEE_SURNAME#
						</td>
                        <td align="center">#SEMINERE_ILGI#</td>
                        <td align="center">#TARTISMALARA_KATILIM#</td>
                        <td align="center">#OGRENME_MOTIVASYONU#</td>
                        <td align="center">#FIKIR_URETME#</td>
                        <td align="center">#KARSI_FIKRE_SAYGI#</td>
                        <td align="center">#YENILIGE_ACIKLIK#</td>
                        <td align="center">#DEGISIME_INANC#</td>
                        <td align="center">#ILETISIM_BECERISI#</td>
                        <td>#NOTE#</td>
                      </tr>					 
					  </cfoutput>
					   <tr>
					   <td class="txtboldblue"><cf_get_lang no='383.Ortalama'></td>
					   
					   <td class="txtbold" align="center">
					   <cfoutput>
						<cfset toplam_seminere_ilgi=0>
						<cfset sayi=0>
						<cfloop query="get_class_attender_eval">
						<cfif len(seminere_ilgi)>
						<cfset toplam_seminere_ilgi=toplam_seminere_ilgi+seminere_ilgi>
						<cfset sayi=sayi+1>
						</cfif>
						</cfloop>
						<cfset deger_seminere_ilgi = toplam_seminere_ilgi/sayi>
						#TLFormat(deger_seminere_ilgi)#
						</td>
                        <td class="txtbold" align="center">
						<cfset toplam_tartismalara_katilim=0>
						<cfset sayi=0>
						<cfloop query="get_class_attender_eval">
						<cfif len(tartismalara_katilim)>
						<cfset toplam_tartismalara_katilim=toplam_tartismalara_katilim+tartismalara_katilim>
						<cfset sayi=sayi+1>
						</cfif>
						</cfloop>
						<cfset deger_tartismalara_katilim=toplam_tartismalara_katilim/sayi>
						#TLFormat(deger_tartismalara_katilim)#
						</td>
                        <td class="txtbold" align="center">
						<cfset toplam_OGRENME_MOTIVASYONU=0>
						<cfset sayi=0>
						<cfloop query="get_class_attender_eval">
						<cfif len(OGRENME_MOTIVASYONU)>
						<cfset toplam_OGRENME_MOTIVASYONU=toplam_OGRENME_MOTIVASYONU+OGRENME_MOTIVASYONU>
						<cfset sayi=sayi+1>
						</cfif>
						</cfloop>
						<cfset deger_OGRENME_MOTIVASYONU=toplam_OGRENME_MOTIVASYONU/sayi>
						#TLFormat(deger_OGRENME_MOTIVASYONU)#
						</td>
                        <td class="txtbold" align="center">
						<cfset toplam_FIKIR_URETME=0>
						<cfset sayi=0>
						<cfloop query="get_class_attender_eval">
						<cfif len(FIKIR_URETME)>
						<cfset toplam_FIKIR_URETME=toplam_FIKIR_URETME+FIKIR_URETME>
						<cfset sayi=sayi+1>
						</cfif>
						</cfloop>
						<cfset deger_FIKIR_URETME=toplam_FIKIR_URETME/sayi>
						#TLFormat(deger_FIKIR_URETME)#
						</td>
                        <td class="txtbold" align="center">
						<cfset toplam_KARSI_FIKRE_SAYGI=0>
						<cfset sayi=0>
						<cfloop query="get_class_attender_eval">
						<cfif len(KARSI_FIKRE_SAYGI)>
						<cfset toplam_KARSI_FIKRE_SAYGI=toplam_KARSI_FIKRE_SAYGI+KARSI_FIKRE_SAYGI>
						<cfset sayi=sayi+1>
						</cfif>
						</cfloop>
						<cfset deger_KARSI_FIKRE_SAYGI=toplam_KARSI_FIKRE_SAYGI/sayi>
						#TLFormat(deger_KARSI_FIKRE_SAYGI)#
						</td>
                        <td class="txtbold" align="center">
						<cfoutput>
						<cfset toplam_YENILIGE_ACIKLIK=0>
						<cfset sayi=0>
						<cfloop query="get_class_attender_eval">
						<cfif len(YENILIGE_ACIKLIK)>
						<cfset toplam_YENILIGE_ACIKLIK=toplam_YENILIGE_ACIKLIK+YENILIGE_ACIKLIK>
						<cfset sayi=sayi+1>
						</cfif>
						</cfloop>
						<cfset deger_YENILIGE_ACIKLIK=toplam_YENILIGE_ACIKLIK/sayi>
						#TLFormat(deger_YENILIGE_ACIKLIK)#
						</cfoutput></td>
                        <td class="txtbold" align="center">
						<cfset toplam_DEGISIME_INANC=0>
						<cfset sayi=0>
						<cfloop query="get_class_attender_eval">
						<cfif len(DEGISIME_INANC)>
						<cfset toplam_DEGISIME_INANC=toplam_DEGISIME_INANC+DEGISIME_INANC>
						<cfset sayi=sayi+1>
						</cfif>
						</cfloop>
						<cfset deger_DEGISIME_INANC=toplam_DEGISIME_INANC/sayi>
						#TLFormat(deger_DEGISIME_INANC)#
						</td>
                        <td class="txtbold" align="center">
						<cfset toplam_ILETISIM_BECERISI=0>
						<cfset sayi=0>
						<cfloop query="get_class_attender_eval">
						<cfif len(ILETISIM_BECERISI)>
						<cfset toplam_ILETISIM_BECERISI=toplam_ILETISIM_BECERISI+ILETISIM_BECERISI>
						<cfset sayi=sayi+1>
						</cfif>
						</cfloop>
						<cfset deger_ILETISIM_BECERISI=toplam_ILETISIM_BECERISI/sayi>
						#TLFormat(deger_ILETISIM_BECERISI)#
						</cfoutput>
						</td>
                      </tr>
                         <tr>
                        <td height="20" colspan="10" class="txtbold" style="text-align:right;">
							1 = <cf_get_lang no='233.Çok Zayıf'>&nbsp;&nbsp;&nbsp;
							2 = <cf_get_lang no='234.Zayıf'>&nbsp;&nbsp;&nbsp;
							3 = <cf_get_lang_main no='516.Orta'>&nbsp;&nbsp;&nbsp;
							4 = <cf_get_lang no='236.İyi'>&nbsp;&nbsp;&nbsp;
							5 = <cf_get_lang no='237.Çok İyi'>
						</td>
                      </tr>
            </table>
	</td>
  </tr>
</table>
	</td>
  </tr>
</table>			

