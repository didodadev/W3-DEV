<cfquery name="GET_BRANCH_RELATED" datasource="#DSN#">
	SELECT 
		BRANCH.BRANCH_ID, 
		BRANCH.BRANCH_NAME, 
		COMPANY_BOYUT_DEPO_KOD.BOYUT_KODU, 
		COMPANY_BRANCH_RELATED.CARIHESAPKOD
	FROM 
		BRANCH, 
		COMPANY_BRANCH_RELATED, 
		COMPANY_BOYUT_DEPO_KOD
	WHERE 
		COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
		COMPANY_BRANCH_RELATED.IS_SELECT = 1 AND
		COMPANY_BRANCH_RELATED.COMPANY_ID = #attributes.cpid# AND
		COMPANY_BRANCH_RELATED.BRANCH_ID = BRANCH.BRANCH_ID AND 
		COMPANY_BOYUT_DEPO_KOD.W_KODU = COMPANY_BRANCH_RELATED.BRANCH_ID AND 
		BRANCH.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
</cfquery>

<cfparam name="attributes.start_year" default="#dateformat(date_add('m',-1,now()),'yyyy')#">
<cfparam name="attributes.start_month" default="#dateformat(date_add('m',-1,now()),'mm')#">
<cfsavecontent variable="ay1"><cf_get_lang_main no='180.Ocak'></cfsavecontent>
<cfsavecontent variable="ay2"><cf_get_lang_main no='181.Şubat'></cfsavecontent>
<cfsavecontent variable="ay3"><cf_get_lang_main no='182.Mart'></cfsavecontent>
<cfsavecontent variable="ay4"><cf_get_lang_main no='183.Nisan'></cfsavecontent>
<cfsavecontent variable="ay5"><cf_get_lang_main no='184.Mayıs'></cfsavecontent>
<cfsavecontent variable="ay6"><cf_get_lang_main no='185.Haziran'></cfsavecontent>
<cfsavecontent variable="ay7"><cf_get_lang_main no='186.Temmuz'></cfsavecontent>
<cfsavecontent variable="ay8"><cf_get_lang_main no='187.Ağustos'></cfsavecontent>
<cfsavecontent variable="ay9"><cf_get_lang_main no='188.Eylül'></cfsavecontent>
<cfsavecontent variable="ay10"><cf_get_lang_main no='189.Ekim'></cfsavecontent>
<cfsavecontent variable="ay11"><cf_get_lang_main no='190.Kasım'></cfsavecontent>
<cfsavecontent variable="ay12"><cf_get_lang_main no='191.Aralık'></cfsavecontent>
<cfset ay_listesi = "#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#">
<cfsavecontent variable="title"><cf_get_lang dictionary_id='52208.Product Analysis'></cfsavecontent>
<cf_box title="#title#">
  
    <cfform name="dsp_prdouct_analysis" method="post" action="#request.self#?fuseaction=crm.popup_dsp_prdouct_analysis&iframe=1">
        <input type="hidden" name="frame_fuseaction" id="frame_fuseaction" value="<cfif isdefined("attributes.frame_fuseaction") and len(attributes.frame_fuseaction)><cfoutput>#attributes.frame_fuseaction#</cfoutput></cfif>">
        <input type="hidden" name="cpid" id="cpid" value="<cfoutput>#attributes.cpid#</cfoutput>">
        <cf_box_search>
            <cfoutput>
                <div class="form-group">
                    <select name="start_year" id="start_year">
                        <cfloop from="2007" to="#year(now())#" index="i">
                            <option value="#i#" <cfif i eq attributes.start_year>selected</cfif>>#i#</option>
                        </cfloop>
                    </select>
                </div>
                <div class="form-group">
                    <select name="start_month" id="start_month">
                        <cfloop index="i" from="1" to="#ListLen(ay_listesi)#">
                            <option value="#NumberFormat(i,'00')#" <cfif attributes.start_month eq i>selected</cfif>>#ListGetAt(ay_listesi,i)#</option>
                        </cfloop>
                    </select>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>                    
            </cfoutput>
        </cf_box_search>
    </cfform>  
<cf_grid_list>
<cftry>
    <cfif get_branch_related.recordcount>
    <cfloop query="get_branch_related">
        <cfquery name="GET_SATIS_OZET" datasource="hedef_urun_analiz">
            SELECT
                URUN_ADI,
                ALIM_SAYISI,
                ALINAN_ADET,
                MF_ADET,
                TOPLAM_KUTU_FIYATI TOPLAM_KUTU_FIYATI_YTL,
                YASAL_ECZ_KAR YASAL_ECZACI_KARI_YTL,
                MF_ISKONTO_TUTAR MF_ISKONTO_TUTARI_YTL,
                KURUM_ISK_TUTAR KURUM_ISKONTO_TUTARI_YTL,
                TICARI_ISK_TUTAR TICARI_ISKONTO_TUTARI_YTL,
                INORMAL_ISK_TUTAR EK_ISKONTOLAR_TUTARI_YTL, 
                TOPLAM_NET_ODENEN TOPLAM_NET_ODENEN_TUTAR_YTL,
                ORT_VADE_GUN ORTALAMA_VADE_GUN,
                SATIS_KDV, 
                CASE 
                WHEN ((NVL(TOPLAM_KUTU_FIYATI,0)/(1+(SATIS_KDV/100))-NVL(TOPLAM_NET_ODENEN,0))/(NVL(TOPLAM_NET_ODENEN,0)+0.0001))*100<=0 THEN  '+KAR'
                ELSE TO_CHAR(ROUND((((TOPLAM_KUTU_FIYATI-KURUM_ISK_TUTAR)/(1+(SATIS_KDV/100))-TOPLAM_NET_ODENEN)/(TOPLAM_NET_ODENEN+0.0001)*100),2)) 
                END ORAN   
            FROM 
                ETICARET.SATIS_OZET 
            WHERE
                HEDEFKODU = #attributes.cpid# AND
                DEPO_KODU = #get_branch_related.boyut_kodu# AND
                DONEM = '#attributes.start_year##attributes.start_month#'
            ORDER BY
                ALIM_SAYISI
        </cfquery>
        <thead>
            <tr>
                <th colspan="15"><cfoutput>#branch_name#</cfoutput></th>
            </tr>
            <tr>
                <cfoutput>
                <th><cf_get_lang_main no='75.No'></th>
                <th><cf_get_lang no='809.Urun Adi'></th>
                <th><cf_get_lang no='763.Alım'><br/><cf_get_lang no='764.Sayısı'></th>
                <th><cf_get_lang_main no='1076.Alınan'><br/><cf_get_lang_main no='670.Adet'></th>
                <th>MF<br/><cf_get_lang_main no='670.Adet'></th>
                <th>Top Kutu<br/><cf_get_lang no='765.Fiyatı'><br/>(#session.ep.money#)</th>
                <th>Yasal Ecz.<br/>Karı<br/>(#session.ep.money#)</th>
                <th>MF İsk.<br/>Tut.<br/>(#session.ep.money#)</th>
                <th><cf_get_lang_main no='300.Kurum'> İsk.<br/>Tut.<br/>(#session.ep.money#)</th>
                <th><cf_get_lang_main no='1649.Ticari'> İsk.<br/>Tut.<br/>(#session.ep.money#)</th>
                <th><cf_get_lang no='767.Normal'> İsk.<br/>Tut.<br/>(#session.ep.money#)</th>
                <th>Top. Net<br/>Ödenen<br/>(#session.ep.money#)</th>
                <th>Ort. Vade<br/>Gün</th>
                <th><cf_get_lang no='768.Toplam Kar'><br/><cf_get_lang_main no='1259.Oranı'></th>
                <th><cf_get_lang_main no='36.Satış'> <br/>KDV</th>
                </cfoutput>
            </tr>
        </thead>
        <tbody>
        <cfif get_satis_ozet.recordcount>
            <cfoutput query="get_satis_ozet">
            <tr>
                <td>#currentrow#</td>
                <td nowrap style="font-size:9px;">#urun_adi#</td>
                <td style="text-align:right;">#tlformat(alim_sayisi,0)#</td>
                <td style="text-align:right;">#tlformat(alinan_adet,0)#</td>				
                <td style="text-align:right;">#tlformat(mf_adet,0)#</td>
                <td style="text-align:right;">#tlformat(toplam_kutu_fiyati_ytl)#</td>
                <td style="text-align:right;">#tlformat(yasal_eczaci_kari_ytl)#</td>
                <td style="text-align:right;">#tlformat(mf_iskonto_tutari_ytl)#</td>
                <td style="text-align:right;">#tlformat(kurum_iskonto_tutari_ytl)#</td>
                <td style="text-align:right;">#tlformat(ticari_iskonto_tutari_ytl)#</td>
                <td style="text-align:right;">#tlformat(ek_iskontolar_tutari_ytl)#</td>
                <td style="text-align:right;">#tlformat(toplam_net_odenen_tutar_ytl)#</td>
                <td style="text-align:right;">#tlformat(ortalama_vade_gun,0)#</td>
                <td style="text-align:right;">#tlformat(oran,0)#</td>			   
                <td style="text-align:right;">#tlformat(satis_kdv,0)#</td>
            </tr>
            </cfoutput>
        <cfelse>
            <tr class="color-row" height="20">
                <td colspan="15"><cf_get_lang no='771.İlgili Şubede'> <cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
            </tr>
        </cfif>
        </tbody>
        </cfloop>
    <cfelse>
        <tbody>
            <tr>
                <td colspan="15"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
            </tr>
        </tbody>
    </cfif>
    <cfcatch>
        <tbody>
            <tr>
                <td colspan="15"><cf_get_lang no='762.Oracle DB sinden Data Çekildiği İçin Test Ortamında Hata Verebilir'> ! </td>
            </tr>
        </tbody>
    </cfcatch> 
</cftry>
</cf_grid_list>
</cf_box>

