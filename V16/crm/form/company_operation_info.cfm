
<cfsavecontent variable="ay1"><cf_get_lang_main no ='180.Ocak'></cfsavecontent>
    <cfsavecontent variable="ay2"><cf_get_lang_main no ='181.Şubat'></cfsavecontent>
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
    <cfset aylar = "#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#">
    <cfset color_list = 'FFFFCC,CCFFCC,FFFFCC,FF0000,99CC99,FF0000,FFCC99,FF0000,FF0000,FF0000,FF0000'>
    <cfparam name="attributes.search_year" default="#year(now())#">
    <cfparam name="attributes.search_month" default="#month(now())#">
    <cfquery name="GET_BRANCH_RELATED" datasource="#dsn#">
        SELECT 
            BRANCH.BRANCH_ID, 
            BRANCH.BRANCH_NAME, 
            COMPANY_BOYUT_DEPO_KOD.BOYUT_KODU, 
            COMPANY_BRANCH_RELATED.CARIHESAPKOD,
            OUR_COMPANY.COMP_ID
        FROM 
            BRANCH, 
            COMPANY_BRANCH_RELATED, 
            COMPANY_BOYUT_DEPO_KOD,
            OUR_COMPANY
        WHERE 
            COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
            BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID AND
            COMPANY_BRANCH_RELATED.IS_SELECT = 1 AND
            COMPANY_BRANCH_RELATED.COMPANY_ID = #attributes.cpid# AND 
            COMPANY_BRANCH_RELATED.BRANCH_ID = BRANCH.BRANCH_ID AND 
            COMPANY_BOYUT_DEPO_KOD.W_KODU = COMPANY_BRANCH_RELATED.BRANCH_ID AND 
            BRANCH.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# )
    </cfquery>
    <cfquery name="GET_BRANCH_VAL" datasource="#dsn#">
        SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#
    </cfquery>
    <cfsavecontent variable="title"><cf_get_lang no='156.Operasyon Bilgileri'> </cfsavecontent>
    <cf_box title="#title#">
        <cfform name="search_form" action="" method="post">
            <input type="hidden" name="frame_fuseaction" id="frame_fuseaction" value="<cfif isdefined("attributes.frame_fuseaction") and len(attributes.frame_fuseaction)><cfoutput>#attributes.frame_fuseaction#</cfoutput></cfif>">
            <cf_box_search>
                <div class="form-group">
                    <cfif len(attributes.search_month)>
                        <cfoutput>- #listgetat(aylar,attributes.search_month,',')#/#attributes.search_year#</cfoutput>
                    <cfelse> - <cf_get_lang dictionary_id="43491.Kümülatif"></cfif>
                    <cfif attributes.cpid eq 10807><font color="#FF0000"><cf_get_lang dictionary_id="57467.Not">: <cf_get_lang dictionary_id="31749.Aşağıdaki veriler 5 Ağustos 2005 tarihindendir">.</font></cfif><!--- bu kod direncin istegi üzerine gecici olarak yazildi yo18082005--->
                </div>
                <div class="form-group">
                    <select name="search_year" id="search_year">
                        <cfoutput>
                            <cfloop from="2005" to="#year(now())#" index="i">
                                <option value="#i#" <cfif i eq attributes.search_year>selected</cfif>>#i#</option>
                            </cfloop>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group">
                    <select name="search_month" id="search_month">
                        <cfoutput>
                        <cfloop from="1" to="12" index="mnt">
                            <option value="#mnt#" <cfif attributes.search_month eq mnt>selected</cfif>>#ListGetAt(aylar,mnt)#</option>
                        </cfloop>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button search_function='hepsini_sec()' button_type="4">
                    
                </div>
            </cf_box_search>
    
        </cfform>
         <cftry>
            <cfscript>
                x31=0;x0=0;x1=0;x2=0;x3=0;x4=0;x5=0;x6=0;x7=0;x8=0;x9=0;x10=0;x11=0;x12=0;x13=0;x14=0;x15=0;x16=0;x17=0;x18=0;x19=0;x20=0;x21=0;x22=0;x23=0;x24=0;x25=0;x26=0;x27=0;x28=0;x29=0;x30=0;
            </cfscript>
            <cfoutput query="get_branch_related">
                <cfset baslangic_tarih = createdatetime(attributes.search_year,attributes.search_month,1,0,0,0)>
                <cfset bitis_tarih = date_add("m",1,baslangic_tarih)>
                <cfquery name="GET_OPERATION" datasource="hedef_crm">
                    SELECT 
                        SUM(NORMAL_FAT_ADET) AS NORMAL_FAT_ADET,
                        SUM(ACIL_FAT_ADET) AS ACIL_FAT_ADET,
                        SUM(SERVIS_FAT_ADET) AS SERVIS_FAT_ADET,
                        SUM(NORMAL_FAT_TUTAR) AS NORMAL_FAT_TUTAR,
                        SUM(ACIL_FAT_TUTAR) AS ACIL_FAT_TUTAR,
                        SUM(SERVIS_FAT_TUTAR) AS SERVIS_FAT_TUTAR,
                        SUM(NORMAL_FAT_KUTU_MIKTAR) AS NORMAL_FAT_KUTU_MIKTAR,
                        SUM(NORMAL_FAT_KUTU_MF) AS NORMAL_FAT_KUTU_MF,
                        SUM(ACIL_FAT_KUTU_MIKTAR) AS ACIL_FAT_KUTU_MIKTAR,
                        SUM(ACIL_FAT_KUTU_MF) AS ACIL_FAT_KUTU_MF,
                        SUM(SERVIS_FAT_KUTU_MIKTAR) AS SERVIS_FAT_KUTU_MIKTAR,
                        SUM(SERVIS_FAT_KUTU_MF) AS SERVIS_FAT_KUTU_MF,
                        SUM(NORMAL_FAT_SATIR) AS NORMAL_FAT_SATIR,
                        SUM(ACIL_FAT_SATIR) AS ACIL_FAT_SATIR,
                        SUM(SERVIS_FAT_SATIR) AS SERVIS_FAT_SATIR,
                        SUM(IADE_ADET) AS IADE_ADET,
                        SUM(IADE_TUTAR) AS IADE_TUTAR,
                        SUM(IPTAL_ADET) AS IPTAL_ADET,
                        SUM(IPTAL_TUTAR) AS IPTAL_TUTAR 
                    FROM 
                        HEDEF.HEDEF_MUSTERI_FATSAY 
                    WHERE 
                        HEDEFKODU = #attributes.cpid# AND 
                        DEPO_KODU = #get_branch_related.boyut_kodu# AND
                        TARIH >= #baslangic_tarih# AND
                        TARIH < #bitis_tarih#
                </cfquery>
                <cfscript>
                    toplam_fatura_adet = 0;
                    toplam_fatura_ytl = 0;
                    toplam_fatura_satir = 0;
                    toplam_fatura_kutu = 0;
                    if(len(get_operation.normal_fat_adet))
                        toplam_fatura_adet = toplam_fatura_adet + get_operation.normal_fat_adet;
                    if(len(get_operation.acil_fat_adet))
                        toplam_fatura_adet = toplam_fatura_adet + get_operation.acil_fat_adet;
                    if(len(get_operation.servis_fat_adet))
                        toplam_fatura_adet = toplam_fatura_adet + get_operation.servis_fat_adet;
                    if(len(get_operation.normal_fat_tutar))
                        toplam_fatura_ytl = toplam_fatura_ytl + get_operation.normal_fat_tutar;
                    if(len(get_operation.acil_fat_tutar))
                        toplam_fatura_ytl = toplam_fatura_ytl + get_operation.acil_fat_tutar;
                    if(len(get_operation.servis_fat_tutar))
                        toplam_fatura_ytl = toplam_fatura_ytl + get_operation.servis_fat_tutar;
                    if(len(get_operation.normal_fat_satir))
                        toplam_fatura_satir = toplam_fatura_satir + get_operation.normal_fat_satir;
                    if(len(get_operation.acil_fat_satir))
                        toplam_fatura_satir = toplam_fatura_satir + get_operation.acil_fat_satir;
                    if(len(get_operation.servis_fat_satir))
                        toplam_fatura_satir = toplam_fatura_satir + get_operation.servis_fat_satir;
                    if(len(get_operation.normal_fat_kutu_miktar))
                        toplam_fatura_kutu = toplam_fatura_kutu + get_operation.normal_fat_kutu_miktar;
                    if(len(get_operation.normal_fat_kutu_mf))
                        toplam_fatura_kutu = toplam_fatura_kutu + get_operation.normal_fat_kutu_mf;
                    if(len(get_operation.acil_fat_kutu_miktar))
                        toplam_fatura_kutu = toplam_fatura_kutu + get_operation.acil_fat_kutu_miktar;
                    if(len(get_operation.acil_fat_kutu_mf))
                        toplam_fatura_kutu = toplam_fatura_kutu + get_operation.acil_fat_kutu_mf;
                    if(len(get_operation.servis_fat_kutu_miktar))
                        toplam_fatura_kutu = toplam_fatura_kutu + get_operation.servis_fat_kutu_miktar;
                    if(len(get_operation.servis_fat_kutu_mf))
                        toplam_fatura_kutu = toplam_fatura_kutu + get_operation.servis_fat_kutu_mf;
                    if((toplam_fatura_adet gt 0) and len(toplam_fatura_adet))
                        oran1 = (get_operation.normal_fat_adet / toplam_fatura_adet)*100;
                    else
                        oran1 = 0;
                    if((toplam_fatura_adet gt 0) and len(get_operation.acil_fat_adet))
                        oran2 = (get_operation.acil_fat_adet / toplam_fatura_adet)*100;
                    else
                        oran2 = 0;
                    if((toplam_fatura_adet gt 0) and len(get_operation.servis_fat_adet))
                        oran3 = (get_operation.servis_fat_adet / toplam_fatura_adet)*100;
                    else
                        oran3 = 0;
                    if((toplam_fatura_adet gt 0) and len(get_operation.servis_fat_adet))
                        oran3 = (get_operation.servis_fat_adet / toplam_fatura_adet)*100;
                    else
                        oran3 = 0;
                    if((toplam_fatura_ytl gt 0) and len(get_operation.normal_fat_tutar))
                        oran11 = (get_operation.normal_fat_tutar / toplam_fatura_ytl)*100;
                    else
                        oran11 = 0;
                    if((toplam_fatura_ytl gt 0) and len(get_operation.acil_fat_tutar))
                        oran21 = (get_operation.acil_fat_tutar / toplam_fatura_ytl)*100;
                    else
                        oran21 = 0;
                    if((toplam_fatura_ytl gt 0) and len(get_operation.servis_fat_tutar))
                        oran31 = (get_operation.servis_fat_tutar / toplam_fatura_ytl)*100;
                    else
                        oran31 = 0;
                    x31 = x31 + toplam_fatura_ytl; 
                    x0 = x0 + toplam_fatura_adet;
                    if (len(get_operation.normal_fat_adet))
                        x1 = x1 + get_operation.normal_fat_adet;
                    else
                        x1 = x1 + 0;
                    if (len(get_operation.normal_fat_tutar))
                        x2 = x2 + get_operation.normal_fat_tutar;
                    else
                        x2 = x2 + 0;
                    if (len(get_operation.normal_fat_satir))
                        x3 = x3 + get_operation.normal_fat_satir;
                    else
                        x3 = x3 + 0;
                    if (len(get_operation.normal_fat_kutu_miktar) or len(get_operation.normal_fat_kutu_mf))
                        x4 = x4 + get_operation.normal_fat_kutu_miktar+get_operation.normal_fat_kutu_mf;
                    else
                        x4 = x4 + 0;
                    if (len(get_operation.acil_fat_adet))
                        x7 = x7 + get_operation.acil_fat_adet;
                    else
                        x7 = x7 + 0;
                    if(len(get_operation.acil_fat_tutar))
                        x8 = x8 + get_operation.acil_fat_tutar;
                    else
                        x8 = x8 + 0;
                    if(len(get_operation.acil_fat_satir))
                        x9 = x9 + get_operation.acil_fat_satir;
                    else
                        x9 = x9 + 0;
                    if (len(get_operation.acil_fat_kutu_miktar) or len(get_operation.acil_fat_kutu_mf))
                        x10 = x10 + get_operation.acil_fat_kutu_miktar+get_operation.acil_fat_kutu_mf;
                    else
                        x10 = x10 + 0;
                    if(len(get_operation.servis_fat_adet))
                        x11 = x11 + get_operation.servis_fat_adet;
                    else
                        x11 = x11 + 0;
                    if(len(get_operation.servis_fat_tutar))	
                        x12 = x12 + get_operation.servis_fat_tutar;
                    else
                        x12 = x12 + 0;
                    if(len(get_operation.servis_fat_satir))
                        x13 = x13 + get_operation.servis_fat_satir;
                    else
                        x13 = x13 + 0;
                    if (len(get_operation.servis_fat_kutu_miktar) or len(get_operation.servis_fat_kutu_mf))
                        x14 = x14 + get_operation.servis_fat_kutu_miktar+get_operation.servis_fat_kutu_mf;
                    else
                        x14 = x14 + 0;
                    if(len(toplam_fatura_satir))
                        x15 = x15 + toplam_fatura_satir;
                    else
                        x15 = x15 + 0;
                    if(len(toplam_fatura_kutu))
                        x16 = x16 + toplam_fatura_kutu;
                    else
                        x16 = x16 + 0;
                    if(len(get_operation.iade_adet))
                        x17 = x17 + get_operation.iade_adet;
                    else
                        x17 = x17 + 0;
                    if(len(get_operation.iade_tutar))
                        x18 = x18 + get_operation.iade_tutar;
                    else
                        x18 = x18 + 0;
                    if(len(get_operation.iptal_adet))
                        x19 = x19 + get_operation.iptal_adet;
                    else
                        x19 = x19 + 0;
                    if(len(get_operation.iptal_tutar))
                        x20 = x20 + get_operation.iptal_tutar;
                    else
                        x20 = x20 + 0;
                </cfscript>
                <cf_flat_list>
                    <tr>
                        <td height="25" colspan="7" class="txtboldblue" bgcolor="#listgetat(color_list,comp_id,',')#">#get_branch_related.branch_name#</td>
                    </tr>
                    <tr class="txtboldblue">
                        <td width="140">&nbsp;</td>
                        <td width="90"  valign="bottom" style="text-align:right;"><cf_get_lang no='295.Fat Adedi'></td>
                        <td width="90"  valign="bottom" style="text-align:right;"><cf_get_lang no='296.Fatura YTL si'></td>
                        <td width="90"  valign="bottom" style="text-align:right;"><cf_get_lang dictionary_id="40305.Fatura Satır"></td>
                        <td width="90"  valign="bottom" style="text-align:right;"><cf_get_lang dictionary_id="31956.Fatura Kutu"></td>
                        <td width="90"  valign="bottom" style="text-align:right;"><cf_get_lang no='297.% Adet'></td>
                        <td  valign="bottom" style="text-align:right;"><cf_get_lang no='298.% Tl'></td>  
                    </tr>
                    <tr>
                     <td><cf_get_lang dictionary_id="31935.Normal Faturalar"></td>
                     <td class="txtbold"><input type="text" style="width:90px;" name="norm_adet" id="norm_adet" readonly="" class="box" value="<cfif len(get_operation.normal_fat_adet)>#get_operation.normal_fat_adet#<cfelse>0</cfif>"></td>
                     <td class="txtbold"><input type="text" style="width:90px;" name="norm_ytl" id="norm_ytl" readonly="" class="box" value="<cfif len(get_operation.normal_fat_tutar)>#tlformat(get_operation.normal_fat_tutar)#<cfelse><cfoutput>#tlformat(0)#</cfoutput></cfif>"></td>
                     <td class="txtbold"><input type="text" style="width:90px;" name="norm_satir" id="norm_satir" readonly="" class="box" value="<cfif len(get_operation.normal_fat_satir)>#get_operation.normal_fat_satir#<cfelse>0</cfif>"></td>
                     <td class="txtbold"><input type="text" style="width:90px;" name="norm_kutu" id="norm_kutu" readonly="" class="box" value="<cfif len(get_operation.normal_fat_kutu_miktar)>#tlformat(get_operation.normal_fat_kutu_miktar+get_operation.normal_fat_kutu_mf)#<cfelse>0</cfif>"></td>
                     <td class="txtbold"><input type="text" style="width:90px;" name="norm_yuzde_adet" id="norm_yuzde_adet" readonly="" class="box" value="#tlformat(oran1)#"></td>
                     <td class="txtbold"><input type="text" style="width:90px;" name="norm_yuzde_ytl" id="norm_yuzde_ytl" readonly="" class="box" value="#tlformat(oran11)#"></td>
                    </tr>
                    <tr>
                      <td><cf_get_lang dictionary_id="31934.Acil Faturalar"></td>
                      <td class="txtbold"><input type="text" style="width:90px;" name="acil_adet" id="acil_adet" readonly="" class="box" value="<cfif len(get_operation.acil_fat_adet)>#get_operation.acil_fat_adet#<cfelse>0</cfif>"></td>
                      <td class="txtbold"><input type="text" style="width:90px;" name="acil_ytl" id="acil_ytl" readonly="" class="box" value="<cfif len(get_operation.acil_fat_tutar)>#tlformat(get_operation.acil_fat_tutar)#<cfelse><cfoutput>#tlformat(0)#</cfoutput></cfif>"></td>
                      <td class="txtbold"><input type="text" style="width:90px;" name="acil_satir" id="acil_satir" readonly="" class="box" value="<cfif len(get_operation.acil_fat_satir)>#get_operation.acil_fat_satir#<cfelse>0</cfif>"></td>
                      <td class="txtbold"><input type="text" style="width:90px;" name="acil_kutu" id="acil_kutu" readonly="" class="box" value="<cfif len(get_operation.acil_fat_kutu_miktar)>#tlformat(get_operation.acil_fat_kutu_miktar+get_operation.acil_fat_kutu_mf)#<cfelse>0</cfif>"></td>
                      <td class="txtbold"><input type="text" style="width:90px;" name="acil_yuzde_adet" id="acil_yuzde_adet" readonly="" class="box" value="#tlformat(oran2)#"></td>
                      <td class="txtbold"><input type="text" style="width:90px;" name="acil_yuzde_ytl" id="acil_yuzde_ytl" readonly="" class="box" value="#tlformat(oran21)#"></td>
                      </tr>
                    <tr>
                      <td><cf_get_lang dictionary_id="31926.Servis Acil Faturalar"></td>
                      <td class="txtbold"><input type="text" style="width:90px;" name="servis_acil_adet" id="servis_acil_adet" class="box" readonly="" value="<cfif len(get_operation.servis_fat_adet)>#get_operation.servis_fat_adet#<cfelse>0</cfif>"></td>
                      <td class="txtbold"><input type="text" style="width:90px;" name="servis_acil_ytl" id="servis_acil_ytl" class="box" readonly="" value="<cfif len(get_operation.servis_fat_tutar)>#tlformat(get_operation.servis_fat_tutar)#<cfelse><cfoutput>#tlformat(0)#</cfoutput></cfif>"></td>
                      <td class="txtbold"><input type="text" style="width:90px;" name="servis_acil_satir" id="servis_acil_satir" class="box" readonly="" value="<cfif len(get_operation.servis_fat_satir)>#get_operation.servis_fat_satir#<cfelse>0</cfif>"></td>
                      <td class="txtbold"><input type="text" style="width:90px;" name="servis_acil_kutu"  id="servis_acil_kutu" class="box" readonly="" value="<cfif len(get_operation.servis_fat_kutu_miktar)>#tlformat(get_operation.servis_fat_kutu_miktar+get_operation.servis_fat_kutu_mf)#<cfelse>0</cfif>"></td>
                      <td class="txtbold"><input type="text" style="width:90px;" name="servis_yuzde_adet" id="servis_yuzde_adet" class="box" readonly="" value="#tlformat(oran3)#"></td>
                      <td class="txtbold"><input type="text" style="width:90px;" name="servis_yuzde_ytl" id="servis_yuzde_ytl" class="box" readonly="" value="#tlformat(oran31)#"></td>
                    </tr>
                    <tr>
                      <td><cf_get_lang no='301.Toplam  Fatura'></td>
                      <td class="txtbold"><input type="text" style="width:90px;" name="sum_acil_adet" id="sum_acil_adet" class="box" readonly="" value="#toplam_fatura_adet#"></td>
                      <td class="txtbold"><input type="text" style="width:90px;" name="sum_acil_ytl" id="sum_acil_ytl" class="box" readonly="" value="#tlformat(toplam_fatura_ytl)#"></td>
                      <td class="txtbold"><input type="text" style="width:90px;" name="sum_acil_satir" id="sum_acil_satir" class="box" readonly="" value="#toplam_fatura_satir#"></td>
                      <td class="txtbold"><input type="text" style="width:90px;" name="sum_acil_kutu" id="sum_acil_kutu" class="box" readonly="" value="#toplam_fatura_kutu#"></td>
                      <td class="txtbold"><input type="text" style="width:90px;" name="sum_yuzde_adet" id="sum_yuzde_adet" class="box" readonly="" value="#tlformat(oran1+oran2+oran3)#"></td>
                      <td class="txtbold"><input type="text" style="width:90px;" name="sum_yuzde_ytl" id="sum_yuzde_ytl" class="box" readonly="" value="#tlformat(oran11+oran21+oran31)#"></td>
                    </tr>
                    <tr>
                        <td><cf_get_lang no='303.Satır Başına Düşen'> </td>
                        <td class="txtbold">&nbsp;</td>
                        <td class="txtbold"><input tyie="text" style="width:90px;" name="per_row_box" id="per_row_box" class="box" readonly="" value="<cfif toplam_fatura_satir gt 0>#tlformat(toplam_fatura_ytl/toplam_fatura_satir)#<cfelse>0</cfif>"></td>
                        <td class="txtbold">&nbsp;</td>
                        <td class="txtbold"><input tyie="text" style="width:90px;" name="per_row_tl" id="per_row_tl" class="box" readonly="" value="<cfif toplam_fatura_satir gt 0>#tlformat(toplam_fatura_kutu/toplam_fatura_satir)#<cfelse>0</cfif>"></td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr class="txtboldblue">
                        <td height="25" width="140">&nbsp;</td>
                        <td  valign="bottom" style="text-align:right;"><cf_get_lang no='295.Fat Adedi'></td>
                        <td  valign="bottom" style="text-align:right;"><cf_get_lang_main no='29.Fatura'>&nbsp;#session.ep.money#</td>
                    </tr>
                    <tr>
                        <td height="25"><cf_get_lang no='305.Müşteriye İade Fatura'></td>
                        <td class="txtbold"><input type="text" style="width:90px;" name="servis_acil_adet" id="servis_acil_adet" class="box" readonly="" value="<cfif len(get_operation.iade_adet)>#get_operation.iade_adet#<cfelse>0</cfif>"></td>
                        <td class="txtbold"><input type="text" style="width:90px;" name="servis_acil_ytl" id="servis_acil_ytl" class="box" readonly="" value="<cfif len(get_operation.iade_tutar)>#tlformat(get_operation.iade_tutar)#<cfelse>#tlformat(0)#</cfif>"></td>
                    </tr>
                    <tr>
                        <td height="25"><cf_get_lang no='306.İptal Edilmiş Fatura'></td>
                        <td class="txtbold"><input type="text" style="width:90px;" name="servis_acil_adet" id="servis_acil_adet" class="box" readonly="" value="<cfif len(get_operation.iptal_adet)>#get_operation.iptal_adet#<cfelse>0</cfif>"></td>
                        <td class="txtbold"><input type="text" style="width:90px;" name="servis_acil_ytl" id="servis_acil_ytl" class="box" readonly="" value="<cfif len(get_operation.iptal_tutar)>#tlformat(get_operation.iptal_tutar)#<cfelse>#tlformat(0)#</cfif>"></td>
                    </tr>
                    </cfoutput>
                    <cfscript>
                        if(x0 neq 0)
                            {
                                x5 = x5 + (x1/x0)*100;
                                x21 = x21 + (x7/x0)*100;
                                x23 = x23 + (x11/x0)*100;
                            }
                        else
                            {
                                x5 = 0;
                                x21 = 0;
                                x23 = 0;
                            }
                        if(x31 neq 0)
                            {
                                x6 = x6 + (x2/x31)*100;
                                x22 = x22 + (x8/x31)*100;
                                x24 = x24 + (x12/x31)*100;
                            }
                        else
                            {
                                x6 = 0;
                                x22 = 0;
                                x24 = 0;
                            }
                    </cfscript>
                    <cfif ((get_branch_related.recordcount gt 1) and (get_branch_val.recordcount gt 1) or (get_branch_related.recordcount eq 1) and (get_branch_val.recordcount gte 1))>
                        <cfoutput>
                        <tr>
                            <td height="25" colspan="7" class="txtboldblue"><cf_get_lang dictionary_id="50969.Grup Toplam"></td>
                        </tr>
                        <tr class="txtboldblue">
                            <td width="140">&nbsp;</td>
                            <td width="90"  valign="bottom" style="text-align:right;"><cf_get_lang no='295.Fat Adedi'></td>
                            <td width="90"  valign="bottom" style="text-align:right;"><cf_get_lang_main no='29.Fatura'>&nbsp;#session.ep.money#</td>
                            <td width="90"  valign="bottom" style="text-align:right;"><cf_get_lang dictionary_id="40305.Fatura Satır"></td>
                            <td width="90"  valign="bottom" style="text-align:right;"><cf_get_lang dictionary_id="31956.Fatura Kutu"></td>
                            <td width="90"  valign="bottom" style="text-align:right;"><cf_get_lang no='297.% Adet'></td>
                            <td  valign="bottom" style="text-align:right;"><cf_get_lang no='298.% Tl'></td>  
                        </tr>
                        <tr>
                         <td><cf_get_lang dictionary_id="31935.Normal Faturalar"></td>
                         <td class="txtbold"><input type="text" style="width:90;" name="norm_adet" id="norm_adet" readonly="" class="box" value="#x1#"></td>
                         <td class="txtbold"><input type="text" style="width:90;" name="norm_ytl" id="norm_ytl" readonly="" class="box" value="#tlformat(x2)#"></td>
                         <td class="txtbold"><input type="text" style="width:90;" name="norm_satir" id="norm_satir" readonly="" class="box" value="#x3#"></td>
                         <td class="txtbold"><input type="text" style="width:90;" name="norm_kutu" id="norm_kutu" readonly="" class="box" value="#tlformat(x4)#"></td>
                         <td class="txtbold"><input type="text" style="width:90;" name="norm_yuzde_adet" id="norm_yuzde_adet" readonly="" class="box" value="#tlformat(x5)#"></td>
                         <td class="txtbold"><input type="text" style="width:90;" name="norm_yuzde_ytl" id="norm_yuzde_ytl" readonly="" class="box" value="#tlformat(x6)#"></td>
                        </tr>
                        <tr>
                          <td><cf_get_lang dictionary_id="31934.Acil Faturalar"></td>
                          <td class="txtbold"><input type="text" style="width:90;" name="acil_adet" id="acil_adet" readonly="" class="box" value="#x7#"></td>
                          <td class="txtbold"><input type="text" style="width:90;" name="acil_ytl" id="acil_ytl" readonly="" class="box" value="#tlformat(x8)#"></td>
                          <td class="txtbold"><input type="text" style="width:90;" name="acil_satir" id="acil_satir" readonly="" class="box" value="#x9#"></td>
                          <td class="txtbold"><input type="text" style="width:90;" name="acil_kutu" id="acil_kutu" readonly="" class="box" value="#tlformat(x10)#"></td>
                          <td class="txtbold"><input type="text" style="width:90;" name="acil_yuzde_adet" id="acil_yuzde_adet" readonly="" class="box" value="#tlformat(x21)#"></td>
                          <td class="txtbold"><input type="text" style="width:90;" name="acil_yuzde_ytl" id="acil_yuzde_ytl" readonly="" class="box" value="#tlformat(x22)#"></td>
                          </tr>
                        <tr>
                          <td><cf_get_lang dictionary_id="31926.Servis Acil Faturalar"></td>
                          <td class="txtbold"><input type="text" style="width:90;" name="servis_acil_adet" id="servis_acil_adet" class="box" readonly="" value="#x11#"></td>
                          <td class="txtbold"><input type="text" style="width:90;" name="servis_acil_ytl" id="servis_acil_ytl" class="box" readonly="" value="#tlformat(x12)#"></td>
                          <td class="txtbold"><input type="text" style="width:90;" name="servis_acil_satir" id="servis_acil_satir" class="box" readonly="" value="#x13#"></td>
                          <td class="txtbold"><input type="text" style="width:90;" name="servis_acil_kutu" id="servis_acil_kutu" class="box" readonly="" value="#tlformat(x14)#"></td>
                          <td class="txtbold"><input type="text" style="width:90;" name="servis_yuzde_adet" id="servis_yuzde_adet" class="box" readonly="" value="#tlformat(x23)#"></td>
                          <td class="txtbold"><input type="text" style="width:90;" name="servis_yuzde_ytl" id="servis_yuzde_ytl" class="box" readonly="" value="#tlformat(x24)#"></td>
                        </tr>
                        <tr>
                          <td><cf_get_lang no='301.Toplam  Fatura'></td>
                          <td class="txtbold"><input type="text" style="width:90;" name="sum_acil_adet" id="sum_acil_adet" class="box" readonly="" value="#x0#"></td>
                          <td class="txtbold"><input type="text" style="width:90;" name="sum_acil_ytl" id="sum_acil_ytl" class="box" readonly="" value="#tlformat(x31)#"></td>
                          <td class="txtbold"><input type="text" style="width:90;" name="sum_acil_satir" id="sum_acil_satir" class="box" readonly="" value="#x15#"></td>
                          <td class="txtbold"><input type="text" style="width:90;" name="sum_acil_kutu" id="sum_acil_kutu" class="box" readonly="" value="#tlformat(x16)#"></td>
                          <td class="txtbold"><input type="text" style="width:90;" name="sum_yuzde_adet" id="sum_yuzde_adet" class="box" readonly="" value="#tlformat(x5+x21+x23)#"></td>
                          <td class="txtbold"><input type="text" style="width:90;" name="sum_yuzde_ytl" id="sum_yuzde_ytl" class="box" readonly="" value="#tlformat(x6+x22+x24)#"></td>
                        </tr>
                        <tr>
                            <td><cf_get_lang no='303.Satır Başına Düşen'> </td>
                            <td class="txtbold">&nbsp;</td>
                            <td class="txtbold"><input tyie="text" style="width:90px;" name="per_row_box" id="per_row_box" class="box" readonly="" value="<cfif x15 gt 0>#tlformat(x31/x15)#<cfelse>0</cfif>"></td>
                            <td class="txtbold">&nbsp;</td>
                            <td class="txtbold"><input tyie="text" style="width:90px;" name="per_row_tl" id="per_row_tl" class="box" readonly="" value="<cfif x15 gt 0>#tlformat(x16/x15)#<cfelse>0</cfif>"></td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr class="txtboldblue">
                            <td height="25" width="140">&nbsp;</td>
                            <td  valign="bottom" style="text-align:right;"><cf_get_lang no='295.Fat Adedi'></td>
                            <td  valign="bottom" style="text-align:right;"><cf_get_lang_main no='29.Fatura'>&nbsp;#session.ep.money#</td>
                        </tr>
                        <tr>
                            <td height="25"><cf_get_lang no='305.Müşteriye İade Fatura'></td>
                            <td class="txtbold"><input type="text" style="width:90px;" name="servis_acil_adet" id="servis_acil_adet" class="box" readonly="" value="#x17#"></td>
                            <td class="txtbold"><input type="text" style="width:90px;" name="servis_acil_ytl" id="servis_acil_ytl" class="box" readonly="" value="#tlformat(x18)#"></td>
                        </tr>
                        <tr>
                            <td height="25"><cf_get_lang no='306.İptal Edilmiş Fatura'></td>
                            <td class="txtbold"><input type="text" style="width:90px;" name="servis_acil_adet" id="servis_acil_adet" class="box" readonly="" value="#x19#"></td>
                            <td class="txtbold"><input type="text" style="width:90px;" name="servis_acil_ytl" id="servis_acil_ytl" class="box" readonly="" value="#tlformat(x20)#"></td>
                        </tr>
                        </cfoutput>
                    </cfif>
                  </table>
        <cfcatch><cf_get_lang no='762.Oracle DB sinden Data Çekildiği İçin Test Ortamında Hata Verebilir'> !</cfcatch>
        </cftry>
    </cf_box>
    <script type="text/javascript">
    function hepsini_sec()
    {
        return true;
    }
    </script>
    