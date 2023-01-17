<!--- dinamik bordro excel alma 
 NOT:view_dynamic_bordro.cfm dosyasında yapilan degisiklikler burada da yapılmalı.
 SG 20140905--->
<cfset odenek_names_yeni = "">
<cfloop from="1" to="#listlen(odenek_names)#" index="i">
	<cfset deger = "#listGetAt(odenek_names,i)#;#i#">
	<cfset odenek_names_yeni = listappend(odenek_names_yeni,deger,',')>
</cfloop>
<cfset kesinti_names_yeni = "">
<cfloop from="1" to="#listlen(kesinti_names)#" index="y">
	<cfset deger_ = "#listGetAt(kesinti_names,y)#;#y#">
	<cfset kesinti_names_yeni = listappend(kesinti_names_yeni,deger_,',')>
</cfloop>
<cfset vergi_istisna_names_yeni = "">
<cfloop from="1" to="#listlen(vergi_istisna_names)#" index="m">
	<cfset istisna_deger = "#listGetAt(vergi_istisna_names,m)#;#m#">
	<cfset vergi_istisna_names_yeni = listappend(vergi_istisna_names_yeni,istisna_deger,',')>
</cfloop>
<cfquery name="get_dep_lvl" datasource="#dsn#">
    SELECT DISTINCT LEVEL_NO FROM DEPARTMENT WHERE LEVEL_NO IS NOT NULL ORDER BY LEVEL_NO
</cfquery>
<cfquery name="get_temp_table" datasource="#dsn#">
    IF object_id('tempdb..##Puantaj_Rows_Temp') IS NOT NULL
       BEGIN DROP TABLE ##Puantaj_Rows_Temp END
</cfquery>
<CFTRANSACTION>
<cfquery name="temp_table" datasource="#dsn#">
    CREATE TABLE ##Puantaj_Rows_Temp 
    ( 
        ID int
        <cfloop list="#attributes.b_obj_hidden_new#" index="xlr">
        <cfswitch expression="#xlr#">
        	<cfcase value="b_sira_no">,SIRA_NO int</cfcase>
            <cfcase value="b_mon_info">,PUANTAJ_AY int</cfcase>
            <cfcase value="b_year_info">,PUANTAJ_YIL int</cfcase>
            <cfcase value="b_sgk_no">,SSK_NO nvarchar(100)</cfcase>
            <cfcase value="b_ad_soyad">,AD_SOYAD nvarchar(100)</cfcase>
            <cfcase value="b_tc_kimlik">,KIMLIK_NO nvarchar(100)</cfcase>
            <cfcase value="b_employee_no">,CALISAN_NO nvarchar(100)</cfcase>
            <cfcase value="b_statu">,STATU nvarchar(50)</cfcase>
            <cfcase value="b_sex">,CINSIYET nvarchar(50) </cfcase>
            <cfcase value="b_ilgili_sirket">,ILGILI_SIRKET nvarchar(100)</cfcase>
            <cfcase value="b_sube">,SUBE nvarchar(100)</cfcase>
            <cfcase value="b_departman">
				<cfif isdefined('attributes.is_dep_level')>
                    <cfloop query="get_dep_lvl">
                        ,DEPARTMAN_#level_no# nvarchar(100)
                    </cfloop>
                </cfif>
            	,DEPARTMAN nvarchar(100)
            </cfcase>
            <cfcase value="b_pozisyon_sube">,POZISYON_SUBE nvarchar(100)</cfcase>
            <cfcase value="b_pozisyon_departman">,POZISYON_DEPARTMAN nvarchar(100)</cfcase>
            <cfcase value="b_ise_giris"> ,ISE_GIRIS nvarchar(100)</cfcase>
            <cfcase value="b_isten_cikis">,ISTEN_CIKIS nvarchar(100)</cfcase>
            <cfcase value="b_gruba_giris">,GRUBA_GIRIS nvarchar(100)</cfcase>
            <cfcase value="b_kidem_date">,KIDEM_BAZ nvarchar(100)</cfcase>
            <cfcase value="b_imza">,IMZA nvarchar(50)</cfcase>
            <cfcase value="b_ozel_kod">
                ,HIERARCHY_ nvarchar(50)
                ,OZEL_KOD nvarchar(50)
                ,OZEL_KOD2 nvarchar(50)
                <cfif fusebox.dynamic_hierarchy>,DYNAMIC_HIERARCHY nvarchar(50)</cfif>
            </cfcase>
            <cfcase value="b_unvan">,UNVAN nvarchar(100)</cfcase>
            <cfcase value="b_pozisyon_tipi">,POZISYON_TIPI nvarchar(100)</cfcase>
            <cfcase value="b_collar_type">,YAKA_TIPI nvarchar(100)</cfcase>
            <cfcase value="b_grade_step">,DERECE_KADEME nvarchar(100)</cfcase>
            <cfcase value="b_pozisyon">,POZISYON nvarchar(100)</cfcase>
            <cfcase value="b_org_step">,KADEME nvarchar(100)</cfcase>
            <cfcase value="b_duty_type">,GOREV_TIPI nvarchar(100)</cfcase>
            <cfcase value="b_ucret_yontemi">,UCRET_YONTEMI nvarchar(100)</cfcase>
            <cfcase value="b_kg">,KISMI_ISTIHDAM_GUN nvarchar(100)</cfcase>
            <cfcase value="b_ks">,KISMI_ISTIHDAM_SAAT nvarchar(100)</cfcase>
            <cfcase value="b_net_brut">,NET_BRUT nvarchar(100)</cfcase>
            <cfcase value="b_maas">,UCRET nvarchar(100)</cfcase>
            <cfcase value="b_ss_gunu">,SS_GUNU nvarchar(100)</cfcase>
            <cfcase value="b_hs_gunu">,HS_GUNU nvarchar(100)</cfcase>
            <cfcase value="b_genel_tatil_gunu">,GENEL_TATIL_GUNU nvarchar(100)</cfcase>
            <cfcase value="b_ucretli_izin">,UCRETLI_IZIN nvarchar(100)</cfcase>
            <cfcase value="b_ucretli_izin_pazar">,UCRETLI_IZIN_PAZAR nvarchar(100)</cfcase>
            <cfcase value="b_ucretsiz_izin">,UCRETSIZ_IZIN nvarchar(100)</cfcase>
            <cfcase value="b_toplam_gun">,TOPLAM_GUN nvarchar(100)</cfcase>
            <cfcase value="b_toplam_calisma_gunu">,CALISMA_GUNU nvarchar(100)</cfcase>
            <cfcase value="b_ssk_gunu">,SGK_GUNU nvarchar(100)</cfcase>
            <cfcase value="b_idari_amir">,BIRINCI_AMIR nvarchar(100)</cfcase>
            <cfcase value="b_exp">,ISTEN_CIKIS_NEDENI nvarchar(200)</cfcase>
            <cfcase value="b_reason">,SIRKET_ICI_GEREKCE nvarchar(200)</cfcase>
            <cfcase value="b_ex_in_out_id">,GIRIS_GEREKCE nvarchar(200)</cfcase>
            <cfcase value="b_fonksiyonel_amir">,IKINCI_AMIR nvarchar(200)</cfcase>
            <cfcase value="b_business_code">
                ,MESLEK_KODU nvarchar(100)
                ,MESLEK_GRUBU nvarchar(100)
            </cfcase>
            <cfcase value="b_hi_saat">
                ,SS_GUNU_SAAT nvarchar(100)
                ,HS_GUNU_SAAT nvarchar(100)
                ,GENEL_TATIL_GUNU_SAAT nvarchar(100)
                ,UCRETLI_IZIN_SAAT nvarchar(100)
                ,UCRETLI_IZIN_PAZAR_SAAT nvarchar(100)
                ,UCRETSIZ_IZIN_SAAT nvarchar(100)
                ,TOPLAM_SAAT nvarchar(100)
            </cfcase>
            <cfcase value="b_hafta_ici_mesai">,HAFTA_ICI_MESAI nvarchar(100)</cfcase>
            <cfcase value="b_hafta_sonu_mesai">,HAFTA_SONU_MESAI nvarchar(100)</cfcase>
            <cfcase value="b_resmi_tatil_mesai">,RESMI_TATIL_MESAI nvarchar(100)</cfcase>
            <cfcase value="b_gece_mesai_saat">,GECE_MESAISI nvarchar(100)</cfcase>
            <cfcase value="b_aylik_mesaisiz">,AYLIK_MESAISIZ nvarchar(100)</cfcase>
            <cfcase value="b_fazla_mesai">,FAZLA_MESAI nvarchar(100)</cfcase>
            <cfcase value="b_fazla_mesai_net">,FAZLA_MESAI_NET nvarchar(100)</cfcase>
            <cfcase value="b_gunluk_ucret">,GUNLUK_UCRET nvarchar(100)</cfcase>
            <cfcase value="b_aylik_ucret">,AYLIK_UCRET nvarchar(100)</cfcase>
            <cfcase value="b_aylik_brut_ucret">,AYLIK_BRUT_UCRET nvarchar(100)</cfcase>
            <cfcase value="b_ek_odenek">,EK_ODENEK nvarchar(100)</cfcase>
            <cfcase value="b_toplam_kazanc">,TOPLAM_KAZANC nvarchar(100)</cfcase>
            <cfcase value="b_sgk_matrahi">,SGK_MATRAHI nvarchar(100)</cfcase>
            <cfcase value="b_sgk_isci_hissesi">
                ,SGK_ISCI_HISSESI nvarchar(100)
                ,SGDP_ISCI_HISSESI nvarchar(100)
            </cfcase>
            <cfcase value="b_bes_isci_hissesi">,BES_ISCI_HISSESI nvarchar(100)</cfcase>
            <cfcase value="b_issizlik_isci_hissesi">,ISSIZLIK_SIGORTASI_ISCI_PRIMI nvarchar(100)</cfcase>
            <cfcase value="b_gelir_vergisi_indirimi">,GELIR_VERGISI_INDIRIMI nvarchar(100)</cfcase>
            <cfcase value="b_gelir_vergisi_matrahi">,GELIR_VERGISI_MATRAHI nvarchar(100)</cfcase>
            <cfcase value="b_gelir_vergisi_hesaplanan">,GELIR_VERGISI_HESAPLANAN nvarchar(100)</cfcase>
            <cfcase value="b_asgari_gecim_indirimi">,ASGARI_GECIM_INDIRIMI nvarchar(100)</cfcase>
            <cfcase value="b_gelir_vergisi_indirimi_5746">,GELIR_VERGISI_INDIRIMI_5746 nvarchar(100)</cfcase>
            <cfcase value="b_gelir_vergisi_indirimi_4691">,GELIR_VERGISI_INDIRIMI_4691 nvarchar(100)</cfcase>
            <cfcase value="b_gelir_vergisi">,GELIR_VERGISI nvarchar(100)</cfcase>
            <cfcase value="b_vergi_indirimi_5615"> ,VERGI_INDIRIMI_5084 nvarchar(100)</cfcase>
            <cfcase value="b_kum_gelir_vergisi_matrahi">,KUMULATIF_GELIR_VERGISI_MATRAHI nvarchar(100)</cfcase>
            <cfcase value="b_damga_vergisi">,DAMGA_VERGISI nvarchar(100)</cfcase>
            <cfcase value="b_damga_vergisi_matrah">,DAMGA_VERGISI_MATRAHI nvarchar(100)</cfcase>
            <cfcase value="b_toplam_yasal_kesinti">,TOPLAM_YASAL_KESINTI nvarchar(100)</cfcase>
            <cfcase value="b_onceki_aydan_devreden_kum_mat">,ONCEKI_AYDAN_DEVREDEN_KUMULATIF_MATRAH nvarchar(100)</cfcase>
            <cfcase value="b_sgk_devir_isci_hissesi_fark">,SGK_DEVIR_ISCI_HISSESI_FARK nvarchar(100)</cfcase>
            <cfcase value="b_sgk_devir_issizlik_hissesi_fark">,SGK_DEVIR_ISSIZLIK_HISSESI_FARK nvarchar(100)</cfcase>
            <cfcase value="b_sgdp_isci_primi_fark">,SGDP_ISCI_PRIMI_FARK nvarchar(100)</cfcase>
            <cfcase value="b_muhtelif_kesintiler">,MUHTELIF_KESINTILER nvarchar(100)</cfcase>
            <cfcase value="b_net_ucret">,NET_UCRET nvarchar(100)</cfcase>
            <cfcase value="b_toplam_net_odenecek">,TOPLAM_NET_ODENECEK nvarchar(100)</cfcase>
            <cfcase value="b_sgk_isveren_primi_hesaplanan">
                ,SGK_ISVEREN_PRIMI_HESAPLANAN nvarchar(100)
                ,SGDP_ISVEREN_PRIMI_HESAPLANAN nvarchar(100) 
            </cfcase>
            <cfcase value="b_muhasebe_kod_group">,MUHASEBE_KOD_GRUBU nvarchar(100)</cfcase>
            <cfcase value="b_sgk_5084">,SGK_ISVEREN_PRIMI_INDIRIMI_5084 nvarchar(100)</cfcase>
            <cfcase value="b_sgk_5763">,SGK_ISVEREN_PRIMI_INDIRIMI_5763 nvarchar(100)</cfcase>
            <cfcase value="b_sgk_5510">,SGK_ISVEREN_PRIMI_INDIRIMI_5510 nvarchar(100)</cfcase>
            <cfcase value="b_sgk_5921">,SGK_ISVEREN_PRIMI_INDIRIMI_5921 nvarchar(100)</cfcase>
            <cfcase value="b_sgk_5746">,SGK_ISVEREN_PRIMI_INDIRIMI_5746 nvarchar(100)</cfcase>
            <cfcase value="b_sgk_4691">,SGK_ISVEREN_PRIMI_INDIRIMI_4691 nvarchar(100)</cfcase>
            <cfcase value="b_sgk_6111">,SGK_ISVEREN_PRIMI_INDIRIMI_6111 nvarchar(100)</cfcase>
            <cfcase value="b_sgk_6486">,SGK_ISVEREN_PRIMI_INDIRIMI_6486 nvarchar(100)</cfcase>
            <cfcase value="b_sgk_6322">,SGK_ISVEREN_PRIMI_INDIRIMI_6322 nvarchar(100)</cfcase>
            <cfcase value="b_sgk_14857">,SGK_ISVEREN_PRIMI_INDIRIMI_14857 nvarchar(100)</cfcase>

            <cfcase value="b_sgk_isci_7103">,SSK_ISCI_HISSESI_7103 nvarchar(100)</cfcase>
            <cfcase value="b_issizlik_isci_7103">,ISSIZLIK_ISCI_HISSESI_7103 nvarchar(100)</cfcase>
            <cfcase value="b_gelir_verigisi_7103">,GELIR_VERGISI_INDIRIMI_7103 nvarchar(100)</cfcase>
            <cfcase value="b_damga_vergisi_7103">,DAMGA_VERGISI_INDIRIMI_7103 nvarchar(100)</cfcase>
            <cfcase value="b_sgk_isveren_7103">,SSK_ISVEREN_HISSESI_7103 nvarchar(100)</cfcase>
            <cfcase value="b_issizlik_isveren_7103">,ISSIZLIK_ISVEREN_HISSESI_7103 nvarchar(100)</cfcase>

            <cfcase value="b_sgk_isveren_hissesi">
                ,SGK_ISVEREN_PRIMI nvarchar(100)
                ,SGDP_ISVEREN_PRIMI nvarchar(100)
            </cfcase>
            <cfcase value="b_toplam_sgk_prim">,TOPLAM_SGK_PRIM nvarchar(100)</cfcase>
            <cfcase value="b_issizlik_isveren_hissesi">,ISSIZLIK_SIGORTASI_ISVEREN_PRIMI nvarchar(100)</cfcase>
            <cfcase value="b_yillik_izin_tutari">,YILLIK_IZIN_TUTARI nvarchar(100)</cfcase>
            <cfcase value="b_kidem_tazminati">,KIDEM_TAZMINATI nvarchar(100)</cfcase>
            <cfcase value="b_ihbar_tazminati">,IHBAR_TAZMINATI nvarchar(100)</cfcase>
            <cfcase value="b_toplam_isveren_maliyeti">,TOPLAM_ISVEREN_MALIYETI nvarchar(100)</cfcase>
            <cfcase value="b_toplam_isveren_maliyeti_indirimsiz">,TOPLAM_ISVEREN_MALIYETI_INDIRIMSIZ nvarchar(100)</cfcase>
            <cfcase value="b_ucret_tipi">,UCRET_TIPI nvarchar(100)</cfcase>
            <cfcase value="b_odeme_metodu">,ODEME_METHODU nvarchar(100)</cfcase>
            <cfcase value="b_fonksiyon">,FONKSIYON nvarchar(100)</cfcase>
            <cfcase value="b_vergi_istisna_toplam">,VERGI_ISTISNASI_TOPLAM nvarchar(100)</cfcase>
            <cfcase value="b_vergi_istisna_sgk">,VERGI_ISTISNASI_SGK nvarchar(100)</cfcase>
            <cfcase value="b_vergi_istisna_sgk_net">,VERGI_ISTISNASI_SGK_NET nvarchar(100)</cfcase>
            <cfcase value="b_vergi_istisna_vergi">,VERGI_ISTISNASI_VERGI nvarchar(100)</cfcase>
            <cfcase value="b_vergi_istisna_vergi_net">,VERGI_ISTISNASI_VERGI_NET nvarchar(100)</cfcase>
            <cfcase value="b_vergi_istisna_damga">,VERGI_ISTISNASI_DAMGA nvarchar(100)</cfcase>
            <cfcase value="b_vergi_istisna_damga_net">,VERGI_ISTISNASI_DAMGA_NET nvarchar(100)</cfcase>
            <cfcase value="b_masraf_merkezi">,MASRAF_MERKEZI nvarchar(100)</cfcase>
            <cfcase value="b_masraf_merkezi_kodu">,MASRAF_MERKEZI_KODU nvarchar(100)</cfcase>
            <cfcase value="b_muhasebe_kodu">,MUHASEBE_KODU nvarchar(100)</cfcase>
            <cfcase value="b_banka">,BANKA_ADI nvarchar(100)</cfcase>
            <cfcase value="b_hesap_no">,HESAP_NO nvarchar(100)</cfcase>
            <cfcase value="b_iban_no">,IBAN_NO nvarchar(100)</cfcase>
            <cfcase value="b_toplam_devreden_sgk_matrahi">,TOPLAM_DEVREDEN_SGK_MATRAH nvarchar(100)</cfcase>
            <cfcase value="b_2_onceki_aydan_devreden_sgk_matrahi">,IKI_ONCEKI_AYDAN_DEVREDEN_SGK_MATRAHI nvarchar(100)</cfcase>
            <cfcase value="b_1_onceki_aydan_devreden_sgk_matrahi">,BIR_ONCEKI_AYDAN_DEVREDEN_SGK_MATRAHI nvarchar(100)</cfcase>
            <cfcase value="b_buaydan_devreden_sgk_matrahi">,BU_AYDAN_DEVREDEN_SGK_MATRAHI nvarchar(100)</cfcase>
            <cfcase value="b_kesinti_ve_agi_oncesi_net">,KESINTI_VE_AGI_ONCESI_NET nvarchar(100)</cfcase>
       		<cfcase value="b_ek_odenekler">
                <cfloop list="#odenek_names_yeni#" index="cca">
                    ,<cfoutput>ODENEK_#listlast(cca,';')#</cfoutput> nvarchar(100)
                    <cfif x_payment_type eq 1>
                        ,<cfoutput>ODENEK_#listlast(cca,';')#</cfoutput>_TANIMLANAN nvarchar(100)
                    </cfif>
                </cfloop>
            </cfcase>
            <cfcase value="b_kesintiler">
                ,Avans nvarchar(100)
                <cfloop list="#kesinti_names_yeni#" index="cca">
                    ,<cfoutput>KESINTI_#listlast(cca,';')#</cfoutput> nvarchar(100)
                </cfloop>
            </cfcase>
            <cfcase value="b_vergi_istisna">
                <cfloop list="#vergi_istisna_names_yeni#" index="cca">
                    ,<cfoutput>ISTISNA_#listlast(cca,';')#</cfoutput> nvarchar(100)
                    ,<cfoutput>ISTISNA_#listlast(cca,';')#</cfoutput>_Net nvarchar(100)
                </cfloop>
            </cfcase>
        </cfswitch>
        </cfloop>
        ,COLOR int
    ) 
</cfquery>
<cfoutput query="get_puantaj_rows" group="#type_#">
<cfquery name="Add_Puantaj_Rows_Temp" datasource="#dsn#">
        INSERT INTO ##Puantaj_Rows_Temp 
		(
        ID
        <cfloop list="#attributes.b_obj_hidden_new#" index="xlr">
            <cfswitch expression="#xlr#">
            	<cfcase value="b_sira_no">,SIRA_NO</cfcase>
                <cfcase value="b_mon_info">,PUANTAJ_AY</cfcase>
                <cfcase value="b_year_info">,PUANTAJ_YIL</cfcase>
			    <cfcase value="b_sgk_no">,SSK_NO</cfcase>
                <cfcase value="b_ad_soyad">,AD_SOYAD</cfcase>
                <cfcase value="b_tc_kimlik">,KIMLIK_NO</cfcase>
                <cfcase value="b_employee_no">,CALISAN_NO</cfcase>
                <cfcase value="b_statu">,STATU</cfcase>
                <cfcase value="b_sex">,CINSIYET</cfcase>
                <cfcase value="b_ilgili_sirket">,ILGILI_SIRKET</cfcase>
                <cfcase value="b_sube">,SUBE</cfcase>
                <cfcase value="b_departman">
					<cfif isdefined('attributes.is_dep_level')>
                        <cfloop query="get_dep_lvl">
                            ,DEPARTMAN_#level_no#
                        </cfloop>
                    </cfif>
                    ,DEPARTMAN
                </cfcase>
                <cfcase value="b_pozisyon_sube">,POZISYON_SUBE</cfcase>
                <cfcase value="b_pozisyon_departman">,POZISYON_DEPARTMAN</cfcase>
                <cfcase value="b_ise_giris">,ISE_GIRIS</cfcase>
                <cfcase value="b_isten_cikis">,ISTEN_CIKIS</cfcase>
                <cfcase value="b_gruba_giris">,GRUBA_GIRIS</cfcase>
                <cfcase value="b_kidem_date">,KIDEM_BAZ</cfcase>
                <cfcase value="b_imza">,IMZA</cfcase>
                <cfcase value="b_ozel_kod">
                   ,HIERARCHY_
                   ,OZEL_KOD
                   ,OZEL_KOD2
                   <cfif fusebox.dynamic_hierarchy>,DYNAMIC_HIERARCHY</cfif>
                </cfcase>
                <cfcase value="b_unvan">,UNVAN</cfcase>
                <cfcase value="b_pozisyon_tipi">,POZISYON_TIPI</cfcase>
                <cfcase value="b_collar_type">,YAKA_TIPI</cfcase>
                <cfcase value="b_grade_step">,DERECE_KADEME</cfcase>
                <cfcase value="b_pozisyon">,POZISYON</cfcase>
                <cfcase value="b_org_step">,KADEME</cfcase>
                <cfcase value="b_duty_type">,GOREV_TIPI</cfcase>
                <cfcase value="b_kg">,KISMI_ISTIHDAM_GUN</cfcase>
                <cfcase value="b_ks">,KISMI_ISTIHDAM_SAAT</cfcase>
                <cfcase value="b_ucret_yontemi">,UCRET_YONTEMI</cfcase>
                <cfcase value="b_net_brut">,NET_BRUT</cfcase>
                <cfcase value="b_maas">,UCRET</cfcase>
                <cfcase value="b_ss_gunu">,SS_GUNU</cfcase>
                <cfcase value="b_hs_gunu">,HS_GUNU</cfcase>
                <cfcase value="b_genel_tatil_gunu">,GENEL_TATIL_GUNU</cfcase>
                <cfcase value="b_ucretli_izin">,UCRETLI_IZIN</cfcase>
                <cfcase value="b_ucretli_izin_pazar">,UCRETLI_IZIN_PAZAR</cfcase>
                <cfcase value="b_ucretsiz_izin">,UCRETSIZ_IZIN</cfcase>
                <cfcase value="b_toplam_gun">,TOPLAM_GUN</cfcase>
                <cfcase value="b_toplam_calisma_gunu">,CALISMA_GUNU</cfcase>
                <cfcase value="b_ssk_gunu">,SGK_GUNU</cfcase>
                <cfcase value="b_idari_amir">,BIRINCI_AMIR</cfcase>
                <cfcase value="b_exp">,ISTEN_CIKIS_NEDENI</cfcase>
                <cfcase value="b_reason">,SIRKET_ICI_GEREKCE</cfcase>
                <cfcase value="b_ex_in_out_id">,GIRIS_GEREKCE</cfcase>
                <cfcase value="b_fonksiyonel_amir">,IKINCI_AMIR</cfcase>
                <cfcase value="b_business_code">
                    ,MESLEK_KODU
                    ,MESLEK_GRUBU
                </cfcase>
                <cfcase value="b_hi_saat">
                    ,SS_GUNU_SAAT
                    ,HS_GUNU_SAAT
                    ,GENEL_TATIL_GUNU_SAAT
                    ,UCRETLI_IZIN_SAAT
                    ,UCRETLI_IZIN_PAZAR_SAAT
                    ,UCRETSIZ_IZIN_SAAT
                    ,TOPLAM_SAAT
                </cfcase>
                <cfcase value="b_hafta_ici_mesai">,HAFTA_ICI_MESAI</cfcase>
                <cfcase value="b_hafta_sonu_mesai">,HAFTA_SONU_MESAI</cfcase>
                <cfcase value="b_resmi_tatil_mesai">,RESMI_TATIL_MESAI</cfcase>
                <cfcase value="b_gece_mesai_saat">,GECE_MESAISI</cfcase>
                <cfcase value="b_aylik_mesaisiz">,AYLIK_MESAISIZ</cfcase>
                <cfcase value="b_fazla_mesai">,FAZLA_MESAI</cfcase>
                <cfcase value="b_fazla_mesai_net">,FAZLA_MESAI_NET</cfcase>
                <cfcase value="b_gunluk_ucret">,GUNLUK_UCRET</cfcase>
                <cfcase value="b_aylik_ucret">,AYLIK_UCRET</cfcase>
                <cfcase value="b_aylik_brut_ucret">,AYLIK_BRUT_UCRET</cfcase>
                <cfcase value="b_ek_odenek">,EK_ODENEK</cfcase>
                <cfcase value="b_toplam_kazanc">,TOPLAM_KAZANC</cfcase>
                <cfcase value="b_sgk_matrahi">,SGK_MATRAHI</cfcase>
                <cfcase value="b_sgk_isci_hissesi">
                    ,SGK_ISCI_HISSESI
                   	,SGDP_ISCI_HISSESI
                 </cfcase>
                <cfcase value="b_bes_isci_hissesi">,BES_ISCI_HISSESI</cfcase>
                <cfcase value="b_issizlik_isci_hissesi">,ISSIZLIK_SIGORTASI_ISCI_PRIMI</cfcase>
                <cfcase value="b_gelir_vergisi_indirimi">,GELIR_VERGISI_INDIRIMI</cfcase>
                <cfcase value="b_gelir_vergisi_matrahi">,GELIR_VERGISI_MATRAHI</cfcase>
                <cfcase value="b_gelir_vergisi_hesaplanan">,GELIR_VERGISI_HESAPLANAN</cfcase>
                <cfcase value="b_asgari_gecim_indirimi">,ASGARI_GECIM_INDIRIMI</cfcase>
                <cfcase value="b_gelir_vergisi_indirimi_5746">,GELIR_VERGISI_INDIRIMI_5746</cfcase>
                <cfcase value="b_gelir_vergisi_indirimi_4691">,GELIR_VERGISI_INDIRIMI_4691</cfcase>
                <cfcase value="b_gelir_vergisi">,GELIR_VERGISI</cfcase>
                <cfcase value="b_vergi_indirimi_5615">,VERGI_INDIRIMI_5084</cfcase>
                <cfcase value="b_kum_gelir_vergisi_matrahi">,KUMULATIF_GELIR_VERGISI_MATRAHI</cfcase>
                <cfcase value="b_damga_vergisi">,DAMGA_VERGISI</cfcase>
                <cfcase value="b_damga_vergisi_matrah">,DAMGA_VERGISI_MATRAHI</cfcase>
                <cfcase value="b_toplam_yasal_kesinti">,TOPLAM_YASAL_KESINTI</cfcase>
                <cfcase value="b_onceki_aydan_devreden_kum_mat">,ONCEKI_AYDAN_DEVREDEN_KUMULATIF_MATRAH</cfcase>
                <cfcase value="b_sgk_devir_isci_hissesi_fark">,SGK_DEVIR_ISCI_HISSESI_FARK</cfcase>
                <cfcase value="b_sgk_devir_issizlik_hissesi_fark">,SGK_DEVIR_ISSIZLIK_HISSESI_FARK</cfcase>
                <cfcase value="b_sgdp_isci_primi_fark">,SGDP_ISCI_PRIMI_FARK</cfcase>
                <cfcase value="b_muhtelif_kesintiler">,MUHTELIF_KESINTILER</cfcase>
                <cfcase value="b_net_ucret">,NET_UCRET</cfcase>
                <cfcase value="b_toplam_net_odenecek">,TOPLAM_NET_ODENECEK</cfcase>
                <cfcase value="b_sgk_isveren_primi_hesaplanan">
                   	,SGK_ISVEREN_PRIMI_HESAPLANAN
                    ,SGDP_ISVEREN_PRIMI_HESAPLANAN
                </cfcase>
                <cfcase value="b_muhasebe_kod_group">,MUHASEBE_KOD_GRUBU</cfcase>
                <cfcase value="b_sgk_5084">,SGK_ISVEREN_PRIMI_INDIRIMI_5084</cfcase>
                <cfcase value="b_sgk_5763">,SGK_ISVEREN_PRIMI_INDIRIMI_5763</cfcase>
                <cfcase value="b_sgk_5510">,SGK_ISVEREN_PRIMI_INDIRIMI_5510</cfcase>
                <cfcase value="b_sgk_5921">,SGK_ISVEREN_PRIMI_INDIRIMI_5921</cfcase>
                <cfcase value="b_sgk_5746">,SGK_ISVEREN_PRIMI_INDIRIMI_5746</cfcase>
                <cfcase value="b_sgk_4691">,SGK_ISVEREN_PRIMI_INDIRIMI_4691</cfcase>
                <cfcase value="b_sgk_6111">,SGK_ISVEREN_PRIMI_INDIRIMI_6111</cfcase>
                <cfcase value="b_sgk_6486">,SGK_ISVEREN_PRIMI_INDIRIMI_6486</cfcase>
                <cfcase value="b_sgk_6322">,SGK_ISVEREN_PRIMI_INDIRIMI_6322</cfcase>
                <cfcase value="b_sgk_14857">,SGK_ISVEREN_PRIMI_INDIRIMI_14857</cfcase>
                
                <cfcase value="b_sgk_isci_7103">,SSK_ISCI_HISSESI_7103</cfcase>
                <cfcase value="b_issizlik_isci_7103">,ISSIZLIK_ISCI_HISSESI_7103</cfcase>
                <cfcase value="b_gelir_verigisi_7103">,GELIR_VERGISI_INDIRIMI_7103</cfcase>
                <cfcase value="b_damga_vergisi_7103">,DAMGA_VERGISI_INDIRIMI_7103</cfcase>
                <cfcase value="b_sgk_isveren_7103">,SSK_ISVEREN_HISSESI_7103</cfcase>
                <cfcase value="b_issizlik_isveren_7103">,ISSIZLIK_ISVEREN_HISSESI_7103</cfcase>
                
                <cfcase value="b_sgk_isveren_hissesi">
                    ,SGK_ISVEREN_PRIMI
                    ,SGDP_ISVEREN_PRIMI
                </cfcase>
                <cfcase value="b_toplam_sgk_prim">,TOPLAM_SGK_PRIM</cfcase>
                <cfcase value="b_issizlik_isveren_hissesi">,ISSIZLIK_SIGORTASI_ISVEREN_PRIMI</cfcase>
                <cfcase value="b_yillik_izin_tutari">,YILLIK_IZIN_TUTARI</cfcase>
                <cfcase value="b_kidem_tazminati">,KIDEM_TAZMINATI</cfcase>
                <cfcase value="b_ihbar_tazminati">,IHBAR_TAZMINATI</cfcase>
                <cfcase value="b_toplam_isveren_maliyeti">,TOPLAM_ISVEREN_MALIYETI</cfcase>
                <cfcase value="b_toplam_isveren_maliyeti_indirimsiz">,TOPLAM_ISVEREN_MALIYETI_INDIRIMSIZ</cfcase>
                <cfcase value="b_ucret_tipi">,UCRET_TIPI</cfcase>
                <cfcase value="b_odeme_metodu">,ODEME_METHODU</cfcase>
                <cfcase value="b_fonksiyon">,FONKSIYON</cfcase>
                <cfcase value="b_vergi_istisna_toplam">,VERGI_ISTISNASI_TOPLAM</cfcase>
                <cfcase value="b_vergi_istisna_sgk">,VERGI_ISTISNASI_SGK</cfcase>
                <cfcase value="b_vergi_istisna_sgk_net">,VERGI_ISTISNASI_SGK_NET</cfcase>
                <cfcase value="b_vergi_istisna_vergi">,VERGI_ISTISNASI_VERGI</cfcase>
                <cfcase value="b_vergi_istisna_vergi_net">,VERGI_ISTISNASI_VERGI_NET</cfcase>
                <cfcase value="b_vergi_istisna_damga">,VERGI_ISTISNASI_DAMGA</cfcase>
                <cfcase value="b_vergi_istisna_damga_net">,VERGI_ISTISNASI_DAMGA_NET</cfcase>
                <cfcase value="b_ek_odenekler">
                <cfloop list="#odenek_names_yeni#" index="cca">
                    ,ODENEK_#listlast(cca,';')#
                    <cfif x_payment_type eq 1>
                        ,ODENEK_#listlast(cca,';')#_TANIMLANAN
                    </cfif>
                </cfloop>
                </cfcase>
                <cfcase value="b_kesintiler">
                    ,Avans
                    <cfloop list="#kesinti_names_yeni#" index="cca">
                        ,KESINTI_#listlast(cca,';')#
                    </cfloop>
                </cfcase>
                <cfcase value="b_vergi_istisna">
                    <cfloop list="#vergi_istisna_names_yeni#" index="cca">
                        ,ISTISNA_#listlast(cca,';')#
                        ,ISTISNA_#listlast(cca,';')#_Net
                    </cfloop>
                </cfcase>
                <cfcase value="b_masraf_merkezi">,MASRAF_MERKEZI</cfcase>
                <cfcase value="b_masraf_merkezi_kodu">,MASRAF_MERKEZI_KODU</cfcase>
                <cfcase value="b_muhasebe_kodu">,MUHASEBE_KODU</cfcase>
                <cfcase value="b_banka">,BANKA_ADI</cfcase>
                <cfcase value="b_hesap_no">,HESAP_NO</cfcase>
                <cfcase value="b_iban_no">,IBAN_NO</cfcase>
                <cfcase value="b_toplam_devreden_sgk_matrahi">,TOPLAM_DEVREDEN_SGK_MATRAH</cfcase>
                <cfcase value="b_2_onceki_aydan_devreden_sgk_matrahi">,IKI_ONCEKI_AYDAN_DEVREDEN_SGK_MATRAHI</cfcase>
                <cfcase value="b_1_onceki_aydan_devreden_sgk_matrahi">,BIR_ONCEKI_AYDAN_DEVREDEN_SGK_MATRAHI</cfcase>
                <cfcase value="b_buaydan_devreden_sgk_matrahi">,BU_AYDAN_DEVREDEN_SGK_MATRAHI</cfcase>
                <cfcase value="b_kesinti_ve_agi_oncesi_net">,KESINTI_VE_AGI_ONCESI_NET</cfcase>
            </cfswitch>
        </cfloop>
        ,COLOR
		)
		VALUES
       
            <cfquery name="get_this_istisna" dbtype="query">
                SELECT SUM(VERGI_ISTISNA_AMOUNT) AS VERGI_ISTISNA_AMOUNT FROM get_vergi_istisna WHERE EMPLOYEE_PUANTAJ_ID = #EMPLOYEE_PUANTAJ_ID# AND VERGI_ISTISNA_AMOUNT IS NOT NULL
            </cfquery>
            <cfif get_this_istisna.recordcount>
                <cfset t_istisna_odenek = get_this_istisna.VERGI_ISTISNA_AMOUNT>
            </cfif>
            <cfif Len(evaluate("get_puantaj_rows.M#get_puantaj_rows.row_sal_mon#"))> 
                <cfset maas_ = evaluate("get_puantaj_rows.M#get_puantaj_rows.row_sal_mon#")>
				<cfset t_istisna_odenek = 0>
            </cfif>
            <cfscript>
                sgk_isci_hissesi_fark = 0;
                sgk_issizlik_hissesi_fark = 0;
                sgdp_isci_primi_fark = 0;
                _issizlik_isci_hissesi_devirsiz = 0;
                sayac = sayac+1;
                if (SALARY_TYPE eq 2)
                {
                    aylik = SALARY;
                    t_aylik_ucret = t_aylik_ucret + SALARY;
                    d_t_aylik_ucret = d_t_aylik_ucret + SALARY;
                }
                else if (SALARY_TYPE eq 1)
                {
                    aylik = (SALARY*30);
                    t_aylik_ucret = t_aylik_ucret + (SALARY*30);
                    d_t_aylik_ucret = d_t_aylik_ucret + (SALARY*30);
                }
                else if (SALARY_TYPE eq 0)
                {
                    aylik = (SALARY*SSK_WORK_HOURS*30);
                    t_aylik_ucret = t_aylik_ucret + (SALARY*SSK_WORK_HOURS*30);
                    d_t_aylik_ucret = d_t_aylik_ucret + (SALARY*SSK_WORK_HOURS*30);
                } 
                if(len(weekly_hour))
                    t_hi_saat = t_hi_saat + weekly_hour;
                if(len(weekend_hour))
                    t_ht_saat = t_ht_saat + weekend_hour;
                if(len(offdays_count_hour))
                    t_gt_saat = t_gt_saat + offdays_count_hour;					
                if(len(paid_izinli_sunday_count_hour))
                    t_paid_ht_izin_saat = t_paid_ht_izin_saat + paid_izinli_sunday_count_hour;
                t_saat = weekly_hour + weekend_hour + offdays_count_hour + izin_paid_count + paid_izinli_sunday_count_hour - paid_izinli_sunday_count_hour;
                gt_hi_saat = gt_hi_saat + t_hi_saat;								
                gt_ht_saat = gt_ht_saat + t_ht_saat;								
                gt_gt_saat = gt_gt_saat + t_gt_saat;								
                gt_paid_ht_izin_saat = gt_paid_ht_izin_saat + t_paid_ht_izin_saat;	
                gt_toplam_saat = gt_toplam_saat + t_saat;						
                gt_gece_mesai_saat = gt_gece_mesai_saat + EXT_TOTAL_HOURS_5;
                t_gece_mesai_saat = t_gece_mesai_saat + EXT_TOTAL_HOURS_5;
                t_paid_izin_saat = t_paid_izin_saat + izin_paid_count-paid_izinli_sunday_count_hour;
                gt_paid_izin_saat = gt_paid_izin_saat + izin_paid_count-paid_izinli_sunday_count_hour;			
                t_izin = t_izin + izin;
                d_t_izin = d_t_izin + izin;
                gt_izin_saat = gt_izin_saat + izin_count;	
                dt_izin_saat = dt_izin_saat + izin_count;							
                onceki_donem_kum_gelir_vergisi_matrahi = KUMULATIF_GELIR_MATRAH - gelir_vergisi_matrah;
                if(onceki_donem_kum_gelir_vergisi_matrahi lt 0)
                    onceki_donem_kum_gelir_vergisi_matrahi = 0;
        
                t_toplam_kazanc = t_toplam_kazanc + (total_salary-VERGI_ISTISNA_SSK-VERGI_ISTISNA_VERGI+VERGI_ISTISNA_AMOUNT_);
                t_vergi_indirimi = t_vergi_indirimi + vergi_indirimi;
                t_sakatlik_indirimi = t_sakatlik_indirimi + sakatlik_indirimi;
                t_kum_gelir_vergisi_matrahi =  t_kum_gelir_vergisi_matrahi + KUMULATIF_GELIR_MATRAH ;
                t_onceki_donem_kum_gelir_vergisi_matrahi = t_onceki_donem_kum_gelir_vergisi_matrahi + onceki_donem_kum_gelir_vergisi_matrahi;
                t_gelir_vergisi_matrahi = t_gelir_vergisi_matrahi + gelir_vergisi_matrah;
                t_gelir_vergisi = t_gelir_vergisi + gelir_vergisi-gelir_vergisi_indirimi_7103;
                t_asgari_gecim = t_asgari_gecim + vergi_iadesi;
                
                d_t_toplam_kazanc = d_t_toplam_kazanc + total_salary+VERGI_ISTISNA_AMOUNT;
                d_t_vergi_indirimi = d_t_vergi_indirimi + vergi_indirimi;
                d_t_sakatlik_indirimi = d_t_sakatlik_indirimi + sakatlik_indirimi;
                d_t_kum_gelir_vergisi_matrahi = d_t_kum_gelir_vergisi_matrahi + KUMULATIF_GELIR_MATRAH;
                d_t_onceki_donem_kum_gelir_vergisi_matrahi = d_t_onceki_donem_kum_gelir_vergisi_matrahi + onceki_donem_kum_gelir_vergisi_matrahi;
                d_t_gelir_vergisi_matrahi = d_t_gelir_vergisi_matrahi + gelir_vergisi_matrah;
                d_t_gelir_vergisi = d_t_gelir_vergisi + gelir_vergisi- gelir_vergisi_indirimi_7103;
                d_t_asgari_gecim = d_t_asgari_gecim + vergi_iadesi;
                
                if(not len(mahsup_g_vergisi))
                    mahsup_g_vergisi_ = 0;
                else 
                    mahsup_g_vergisi_ = mahsup_g_vergisi;
                    
                t_mahsup_g_vergisi = t_mahsup_g_vergisi + mahsup_g_vergisi_;
                t_gelir_vergisi_indirimi_5746 = t_gelir_vergisi_indirimi_5746 + gelir_vergisi_indirimi_5746;
                if(is_5746_control eq 0) //arge indiriminin gelir vergisinden düşülmemesi ile ilgili toplam icmal icin eklendi //SG 20140306
                {                
                    t_gelir_vergisi_indirimi_5746_ = t_gelir_vergisi_indirimi_5746_ + gelir_vergisi_indirimi_5746;
                }
                t_gelir_vergisi_indirimi_4691 = t_gelir_vergisi_indirimi_4691 + gelir_vergisi_indirimi_4691;
                if(is_4691_control eq 0) //arge indiriminin gelir vergisinden düşülmemesi ile ilgili toplam icmal icin eklendi
                {                
                    t_gelir_vergisi_indirimi_4691_ = t_gelir_vergisi_indirimi_4691_ + gelir_vergisi_indirimi_4691;
                }
                t_damga_vergisi_matrahi = t_damga_vergisi_matrahi + damga_vergisi_matrah;
                t_damga_vergisi = t_damga_vergisi + damga_vergisi- damga_vergisi_indirimi_7103;
                t_kesinti = t_kesinti + (ssk_isci_hissesi + ssdf_isci_hissesi + gelir_vergisi + damga_vergisi + issizlik_isci_hissesi);
                t_net_ucret = t_net_ucret + net_ucret;
                t_vergi_iadesi = t_vergi_iadesi + vergi_iadesi;
                t_kidem_isveren_payi = t_kidem_isveren_payi + kidem_boss;
                t_kidem_isci_payi = t_kidem_isci_payi + kidem_worker;
                t_total_pay_ssk_tax = t_total_pay_ssk_tax + total_pay_ssk_tax;
                t_total_pay_ssk = t_total_pay_ssk + total_pay_ssk;
                t_total_pay_tax = t_total_pay_tax + total_pay_tax;
                t_total_pay = t_total_pay + total_pay;
                t_ozel_kesinti = t_ozel_kesinti + ozel_kesinti;
                
                d_t_mahsup_g_vergisi = d_t_mahsup_g_vergisi + mahsup_g_vergisi_;
                d_t_gelir_vergisi_indirimi_5746 = d_t_gelir_vergisi_indirimi_5746 + gelir_vergisi_indirimi_5746;
                if(is_5746_control eq 0) //arge indiriminin gelir vergisinden düşülmemesi ile ilgili toplam icmal icin eklendi //SG 20140306
                {
                    d_t_gelir_vergisi_indirimi_5746_ = d_t_gelir_vergisi_indirimi_5746_ + gelir_vergisi_indirimi_5746;
                }
                d_t_gelir_vergisi_indirimi_4691 = d_t_gelir_vergisi_indirimi_4691 + gelir_vergisi_indirimi_4691;
                if(is_4691_control eq 0) //arge indiriminin gelir vergisinden düşülmemesi ile ilgili toplam icmal icin eklendi
                {
                    d_t_gelir_vergisi_indirimi_4691_ = d_t_gelir_vergisi_indirimi_4691_ + gelir_vergisi_indirimi_4691;
                }
                d_t_damga_vergisi_matrahi = d_t_damga_vergisi_matrahi + damga_vergisi_matrah;           	
                d_t_damga_vergisi = d_t_damga_vergisi + damga_vergisi- damga_vergisi_indirimi_7103;
                d_t_kesinti = d_t_kesinti + (ssk_isci_hissesi + ssdf_isci_hissesi + gelir_vergisi + damga_vergisi + issizlik_isci_hissesi);
                d_t_net_ucret = d_t_net_ucret + net_ucret;
                d_t_kidem_isveren_payi = d_t_kidem_isveren_payi + kidem_boss;
                d_t_kidem_isci_payi = d_t_kidem_isci_payi + kidem_worker;
                d_t_total_pay_ssk_tax = d_t_total_pay_ssk_tax + total_pay_ssk_tax;
                d_t_total_pay_ssk = d_t_total_pay_ssk + total_pay_ssk;
                d_t_total_pay_tax = d_t_total_pay_tax + total_pay_tax;
                d_t_total_pay = d_t_total_pay + total_pay;
                d_t_ozel_kesinti = d_t_ozel_kesinti + ozel_kesinti;
                
                if (len(OFFDAYS_COUNT)) 
                    OFFDAYS_COUNT_ = OFFDAYS_COUNT;
                else
                    OFFDAYS_COUNT_ = 0;
                if (len(OFFDAYS_SUNDAY_COUNT)) 
                    OFFDAYS_SUNDAY_COUNT_ = OFFDAYS_SUNDAY_COUNT;
                else
                    OFFDAYS_SUNDAY_COUNT_ = 0;
                
                t_offdays = t_offdays + OFFDAYS_COUNT_;
                t_offdays_sundays = t_offdays_sundays + OFFDAYS_SUNDAY_COUNT_;
                t_paid_izinli_sunday_count = t_paid_izinli_sunday_count + paid_izinli_sunday_count;
                t_sundays = t_sundays + sunday_count;
                t_kanun = t_kanun + VERGI_INDIRIMI_5084;
                t_maas = t_maas + maas_;
                
                d_t_offdays = d_t_offdays + OFFDAYS_COUNT_;
                d_t_offdays_sundays = d_t_offdays_sundays + OFFDAYS_SUNDAY_COUNT_;
                d_t_paid_izinli_sunday_count = d_t_paid_izinli_sunday_count + paid_izinli_sunday_count;
                d_t_sundays = d_t_sundays + sunday_count;
                d_t_kanun = d_t_kanun + VERGI_INDIRIMI_5084;
                d_t_maas = d_t_maas + maas_;
        
                ssk_devir_toplam = 0;
        
                if(len(trim(ssk_devir)))
                {
                    ssk_devir_ = ssk_devir;
                    ssk_devir_toplam = ssk_devir_toplam + ssk_devir;
                }
                else
                { ssk_devir_ = 0;}
                    
                if(len(trim(ssk_devir_last)))
                {
                    ssk_devir_last_ = ssk_devir_last;
                    ssk_devir_toplam = ssk_devir_toplam + ssk_devir_last;
                }
                else
                { ssk_devir_last_ = 0;}
                    
                if(len(trim(ssk_devir)))
                { 
                    d_t_ssk_devir = d_t_ssk_devir + ssk_devir;
                    t_ssk_devir = t_ssk_devir + ssk_devir;
                }
                if(len(trim(ssk_devir_last)))
                {
                    d_t_ssk_devir_last = d_t_ssk_devir_last + ssk_devir_last;
                    t_ssk_devir_last = t_ssk_devir_last + ssk_devir_last;
                }
                d_t_ssk_amount = d_t_ssk_amount + ssk_amount; 
                
                t_ssk_amount =  t_ssk_amount + ssk_amount;
                
                if (ssdf_isci_hissesi gt 0)
                {
                    t_ssdf_ssk_days = t_ssdf_ssk_days + total_days;
                    t_ssdf_days = t_ssdf_days + total_days - sunday_count;
                    t_ssdf_matrah = t_ssdf_matrah + SSK_MATRAH;
                    t_ssdf_isci_hissesi = t_ssdf_isci_hissesi + ssdf_isci_hissesi;
                    t_ssdf_isveren_hissesi = t_ssdf_isveren_hissesi + ssdf_isveren_hissesi;
                    isveren_b_5510_ = 0;
                    ssk_isveren_hissesi_5510_ = 0;
                    
                    d_t_ssdf_ssk_days = d_t_ssdf_ssk_days + total_days;
                    d_t_ssdf_days = d_t_ssdf_days + total_days - sunday_count;
                    d_t_ssdf_matrah = d_t_ssdf_matrah + SSK_MATRAH;
                    d_t_ssdf_isci_hissesi = d_t_ssdf_isci_hissesi + ssdf_isci_hissesi;
                    d_t_ssdf_isveren_hissesi = d_t_ssdf_isveren_hissesi + ssdf_isveren_hissesi;
        
                    if(Len(SSK_ISCI_HISSESI_DUSULECEK))
                        sgdp_isci_primi_fark = SSK_ISCI_HISSESI_DUSULECEK;
        
                    t_sgdp_isci_primi_fark = t_sgdp_isci_primi_fark + sgdp_isci_primi_fark;
                    d_t_sgdp_isci_primi_fark = d_t_sgdp_isci_primi_fark + sgdp_isci_primi_fark;
                    isveren_hesaplanan = 0;
                }
                else
                {
                    t_ssk_days = t_ssk_days + total_days;
                    t_work_days = t_work_days + total_days - sunday_count;
        
                    if (use_ssk eq 1)
                    {
                        t_ssk_primi_isci = t_ssk_primi_isci + ssk_isci_hissesi- ssk_isci_hissesi_7103;
        
                        t_ssk_matrahi = t_ssk_matrahi + SSK_MATRAH;
        
                        if(ssk_isci_hissesi gt 0 and ssk_devir_toplam gt 0)
                            t_ssk_primi_isci_devirsiz = wrk_round((SSK_MATRAH - ssk_devir_toplam) * 14 / 100);
                        else
                            t_ssk_primi_isci_devirsiz = ssk_isci_hissesi;
        
                        if(issizlik_isci_hissesi gt 0 and ssk_devir_toplam gt 0)
                            _issizlik_isci_hissesi_devirsiz = (SSK_MATRAH - ssk_devir_toplam) * 1 / 100;
                        else
                            _issizlik_isci_hissesi_devirsiz = issizlik_isci_hissesi;
        
                        sgk_isci_hissesi_fark = ssk_isci_hissesi - t_ssk_primi_isci_devirsiz;
                        sgk_issizlik_hissesi_fark = issizlik_isci_hissesi - _issizlik_isci_hissesi_devirsiz;
        
                        t_sgk_isci_hissesi_fark = t_sgk_isci_hissesi_fark + (ssk_isci_hissesi - t_ssk_primi_isci_devirsiz);
                        t_sgk_issizlik_hissesi_fark = t_sgk_issizlik_hissesi_fark + (issizlik_isci_hissesi - _issizlik_isci_hissesi_devirsiz);
        
                        d_t_sgk_isci_hissesi_fark = d_t_sgk_isci_hissesi_fark + (ssk_isci_hissesi - t_ssk_primi_isci_devirsiz);
                        d_t_sgk_issizlik_hissesi_fark = d_t_sgk_issizlik_hissesi_fark + (issizlik_isci_hissesi - _issizlik_isci_hissesi_devirsiz);
                    }
                    ssk_isveren_hissesi_5510_ = ssk_isveren_hissesi_5510;
                    
                    isveren_hesaplanan = ssk_isveren_hissesi + ssk_isveren_hissesi_5510 + ssk_isveren_hissesi_5084;
                    if(ssk_isci_hissesi eq 0)t_ssk_primi_isveren_hesaplanan = t_ssk_primi_isveren_hesaplanan + ssdf_isveren_hissesi;else t_ssk_primi_isveren_hesaplanan = t_ssk_primi_isveren_hesaplanan + isveren_hesaplanan;
                    
                    
                    t_ssk_primi_isveren_5510 = t_ssk_primi_isveren_5510 + wrk_round(ssk_isveren_hissesi_5510);
                    t_ssk_primi_isveren_5084 = t_ssk_primi_isveren_5084 + ssk_isveren_hissesi_5084;
                                
                    t_ssk_primi_isveren_5921 = t_ssk_primi_isveren_5921 + ssk_isveren_hissesi_5921;
                    t_ssk_primi_isveren_5746 = t_ssk_primi_isveren_5746 + ssk_isveren_hissesi_5746;
                    t_ssk_primi_isveren_4691 = t_ssk_primi_isveren_4691 + ssk_isveren_hissesi_4691;
                    if(len(ssk_isveren_hissesi_6111))
                        t_ssk_primi_isveren_6111 = t_ssk_primi_isveren_6111 + ssk_isveren_hissesi_6111;
                    else
                        ssk_isveren_hissesi_6111 = 0;
                        
                    if(len(ssk_isveren_hissesi_6486))
                        t_ssk_primi_isveren_6486 = t_ssk_primi_isveren_6486 + ssk_isveren_hissesi_6486;
                    else
                        ssk_isveren_hissesi_6486 = 0;
                    
                    if(len(ssk_isveren_hissesi_6322))
                        t_ssk_primi_isveren_6322 = t_ssk_primi_isveren_6322 + ssk_isveren_hissesi_6322;
                    else
                        ssk_isveren_hissesi_6322 = 0;
                    if(len(ssk_isci_hissesi_6322))
                        t_ssk_primi_isci_6322 = t_ssk_primi_isci_6322 + ssk_isci_hissesi_6322;
                    else
                        ssk_isci_hissesi_6322 = 0;
                        
                    if(len(ssk_isveren_hissesi_14857))
                        t_ssk_primi_isveren_14857 = t_ssk_primi_isveren_14857 + ssk_isveren_hissesi_14857;
                    else
                        t_ssk_primi_isveren_14857 = 0;	
                    
                    
                    t_ssk_isveren_hissesi_7103 = t_ssk_isveren_hissesi_7103 + ssk_isveren_hissesi_7103;
                    t_ssk_isci_hissesi_7103 = t_ssk_isci_hissesi_7103 + ssk_isci_hissesi_7103;
                    t_issizlik_isci_hissesi_7103 = t_issizlik_isci_hissesi_7103 + issizlik_isci_hissesi_7103;
                    t_issizlik_isveren_hissesi_7103 = t_issizlik_isveren_hissesi_7103 + issizlik_isveren_hissesi_7103;
                    t_gelir_vergisi_indirimi_7103 = t_gelir_vergisi_indirimi_7103 + gelir_vergisi_indirimi_7103;
                    t_damga_vergisi_indirimi_7103 = t_damga_vergisi_indirimi_7103 + damga_vergisi_indirimi_7103;
                    
                    t_ssk_primi_isveren_gov = t_ssk_primi_isveren_gov + ssk_isveren_hissesi_gov;
                    
                    t_issizlik_isci_hissesi = t_issizlik_isci_hissesi + issizlik_isci_hissesi- issizlik_isci_hissesi_7103;
                    t_issizlik_isveren_hissesi = t_issizlik_isveren_hissesi + issizlik_isveren_hissesi- issizlik_isveren_hissesi_7103;	
                    
                    d_t_ssk_days = d_t_ssk_days + total_days;
                    d_t_work_days = d_t_work_days + total_days - sunday_count;
                    d_t_ssk_matrahi = d_t_ssk_matrahi + SSK_MATRAH;
                    d_t_ssk_primi_isci = d_t_ssk_primi_isci + ssk_isci_hissesi;
                    
                    if(ssk_isci_hissesi eq 0)d_t_ssk_primi_isveren_hesaplanan = d_t_ssk_primi_isveren_hesaplanan + ssdf_isveren_hissesi;else d_t_ssk_primi_isveren_hesaplanan = d_t_ssk_primi_isveren_hesaplanan + isveren_hesaplanan;
                    
                    d_t_ssk_primi_isveren_5510 = d_t_ssk_primi_isveren_5510 + wrk_round(ssk_isveren_hissesi_5510);
                    d_t_ssk_primi_isveren_5084 = d_t_ssk_primi_isveren_5084 + ssk_isveren_hissesi_5084;
                                
                    d_t_ssk_primi_isveren_5921 = d_t_ssk_primi_isveren_5921 + ssk_isveren_hissesi_5921;
                    d_t_ssk_primi_isveren_5746 = d_t_ssk_primi_isveren_5746 + ssk_isveren_hissesi_5746;
                    d_t_ssk_primi_isveren_4691 = d_t_ssk_primi_isveren_4691 + ssk_isveren_hissesi_4691;
                    
                    if(len(ssk_isveren_hissesi_6111))
                        d_t_ssk_primi_isveren_6111 = d_t_ssk_primi_isveren_6111 + ssk_isveren_hissesi_6111;
                    
                    if(len(ssk_isveren_hissesi_6486))
                        d_t_ssk_primi_isveren_6486 = d_t_ssk_primi_isveren_6486 + ssk_isveren_hissesi_6486;
                    
                    if(len(ssk_isveren_hissesi_6322))
                        d_t_ssk_primi_isveren_6322 = d_t_ssk_primi_isveren_6322 + ssk_isveren_hissesi_6322;
                    if(len(ssk_isci_hissesi_6322))
                        d_t_ssk_primi_isci_6322 = d_t_ssk_primi_isci_6322 + ssk_isci_hissesi_6322;	
                        
                    if(len(ssk_isveren_hissesi_14857))	
                        d_t_ssk_primi_isveren_14857 = d_t_ssk_primi_isveren_14857 + ssk_isveren_hissesi_14857;
                    else
                        d_t_ssk_primi_isveren_14857 = 0;
                    
                    
                    d_t_ssk_isveren_hissesi_7103 = d_t_ssk_isveren_hissesi_7103 + ssk_isveren_hissesi_7103;
                    d_t_ssk_isci_hissesi_7103 = d_t_ssk_isci_hissesi_7103 + ssk_isci_hissesi_7103;
                    d_t_issizlik_isci_hissesi_7103 = d_t_issizlik_isci_hissesi_7103 + issizlik_isci_hissesi_7103;
                    d_t_issizlik_isveren_hissesi_7103 = d_t_issizlik_isveren_hissesi_7103 + issizlik_isveren_hissesi_7103;
                    d_t_gelir_vergisi_indirimi_7103 = d_t_gelir_vergisi_indirimi_7103 + gelir_vergisi_indirimi_7103;
                    d_t_damga_vergisi_indirimi_7103 = d_t_damga_vergisi_indirimi_7103 + damga_vergisi_indirimi_7103;
                    
                                    
                    d_t_ssk_primi_isveren_gov = d_t_ssk_primi_isveren_gov + ssk_isveren_hissesi_gov;
        
                    d_t_issizlik_isci_hissesi = d_t_issizlik_isci_hissesi + issizlik_isci_hissesi- issizlik_isci_hissesi_7103;
                    d_t_issizlik_isveren_hissesi = d_t_issizlik_isveren_hissesi + issizlik_isveren_hissesi- issizlik_isveren_hissesi_7103;	
        
                    d_t_ssk_primi_isveren = d_t_ssk_primi_isveren + (ssk_isveren_hissesi - ssk_isveren_hissesi_gov - ssk_isveren_hissesi_5921);
        
                    t_ssk_primi_isveren = t_ssk_primi_isveren + (ssk_isveren_hissesi - ssk_isveren_hissesi_gov - ssk_isveren_hissesi_5921);		
                }
                devir_tutar_ = 0;
                if(len(SSK_ISCI_HISSESI_DUSULECEK))
                    devir_tutar_ = devir_tutar_ + SSK_ISCI_HISSESI_DUSULECEK;
                    
                if(len(ISSIZLIK_ISCI_HISSESI_DUSULECEK))
                    devir_tutar_ = devir_tutar_ + ISSIZLIK_ISCI_HISSESI_DUSULECEK;
                    
                t_devir_fark = t_devir_fark + devir_tutar_;
                d_t_devir_fark = d_t_devir_fark + devir_tutar_;

                toplam_isveren_indirimsiz = total_salary+t_istisna_odenek+issizlik_isveren_hissesi+isveren_hesaplanan+ssdf_isveren_hissesi;
                
                //7103 tesvikten düsülecekler
                toplam_indirim_7103 = ssk_isveren_hissesi_7103 + ssk_isci_hissesi_7103 + issizlik_isci_hissesi_7103 + issizlik_isveren_hissesi_7103 + gelir_vergisi_indirimi_7103 + damga_vergisi_indirimi_7103;
                
                toplam_isveren = (total_salary+t_istisna_odenek+issizlik_isveren_hissesi+isveren_hesaplanan+ssdf_isveren_hissesi)-(ssk_isveren_hissesi_5510+ssk_isveren_hissesi_5084+ssk_isveren_hissesi_5921+ssk_isveren_hissesi_5746 +ssk_isveren_hissesi_4691+ssk_isveren_hissesi_6111+ssk_isveren_hissesi_6486+ssk_isveren_hissesi_6322+ssk_isci_hissesi_6322+ssk_isveren_hissesi_gov+ssk_isveren_hissesi_14857+toplam_indirim_7103);
                t_toplam_isveren = t_toplam_isveren + toplam_isveren;
                d_t_toplam_isveren = d_t_toplam_isveren + toplam_isveren;
                t_toplam_isveren_indirimsiz = t_toplam_isveren_indirimsiz + toplam_isveren_indirimsiz;
                d_t_toplam_isveren_indirimsiz = d_t_toplam_isveren_indirimsiz + toplam_isveren_indirimsiz;
                d_kidem_amount = d_kidem_amount + KIDEM_AMOUNT;
                d_ihbar_amount = d_ihbar_amount + IHBAR_AMOUNT;
                t_kidem_amount = t_kidem_amount + KIDEM_AMOUNT;
                t_ihbar_amount = t_ihbar_amount + IHBAR_AMOUNT;
                d_vergi_istisna_total = d_vergi_istisna_total + vergi_istisna_total;
                d_vergi_istisna_ssk = d_vergi_istisna_ssk + vergi_istisna_ssk;
                d_vergi_istisna_ssk_net = d_vergi_istisna_ssk_net + vergi_istisna_ssk_net;
                d_vergi_istisna_vergi = d_vergi_istisna_vergi + vergi_istisna_vergi;
                d_vergi_istisna_vergi_net = d_vergi_istisna_vergi_net + vergi_istisna_vergi_net;
                d_vergi_istisna_damga = d_vergi_istisna_damga + vergi_istisna_damga;
                d_vergi_istisna_damga_net = d_vergi_istisna_damga_net + vergi_istisna_damga_net;
                
                t_vergi_istisna_total = t_vergi_istisna_total + vergi_istisna_total;
                t_vergi_istisna_ssk = t_vergi_istisna_ssk + vergi_istisna_ssk;
                t_vergi_istisna_ssk_net = t_vergi_istisna_ssk_net + vergi_istisna_ssk_net;
                t_vergi_istisna_vergi = t_vergi_istisna_vergi + vergi_istisna_vergi;
                t_vergi_istisna_vergi_net = t_vergi_istisna_vergi_net + vergi_istisna_vergi_net;
                t_vergi_istisna_damga = t_vergi_istisna_damga + vergi_istisna_damga;
                t_vergi_istisna_damga_net = t_vergi_istisna_damga_net + vergi_istisna_damga_net;
                if(ssk_isci_hissesi gt 0)
                {
                    t_sgk_isveren_hissesi = t_sgk_isveren_hissesi + ssk_isveren_hissesi - ssk_isveren_hissesi_gov - ssk_isveren_hissesi_5921 - ssk_isveren_hissesi_5746 -ssk_isveren_hissesi_4691- ssk_isveren_hissesi_6111- ssk_isveren_hissesi_6486-ssk_isveren_hissesi_6322+ssk_isci_hissesi_6322-ssk_isveren_hissesi_7103;
                    d_t_sgk_isveren_hissesi = d_t_sgk_isveren_hissesi + ssk_isveren_hissesi - ssk_isveren_hissesi_gov - ssk_isveren_hissesi_5921 - ssk_isveren_hissesi_5746 -ssk_isveren_hissesi_4691- ssk_isveren_hissesi_6111 - ssk_isveren_hissesi_6486- ssk_isveren_hissesi_6322-ssk_isveren_hissesi_7103;
                }
            </cfscript>
            <cfset haftalik_tatil = weekend_day>
            <cfset normal_gun = weekly_day>
            <cfset normal_izinli = izin_paid - paid_izinli_sunday_count>
            <cfset genel_tatil = OFFDAYS_COUNT>
            <cfset yillik_izin = YILLIK_IZIN_AMOUNT>
            <cfif normal_gun lt 0>
                <cfset normal_gun = 0>
            </cfif>
            <cfset normal_gun_total = normal_gun + normal_gun_total>
            <cfset haftalik_tatil_total = haftalik_tatil + haftalik_tatil_total>
            <cfset genel_tatil_total = genel_tatil + genel_tatil_total>
            <cfset izin_total = izin_total + izin>
            <cfset yillik_izin_total = yillik_izin + yillik_izin_total>
            <cfset d_normal_gun_total = normal_gun + d_normal_gun_total>
            <cfset d_haftalik_tatil_total = haftalik_tatil + d_haftalik_tatil_total>
            <cfset d_genel_tatil_total = genel_tatil + d_genel_tatil_total>
            <cfset d_izin_total = d_izin_total + izin>
            <cfset d_yillik_izin_total = yillik_izin + d_yillik_izin_total>
            <cfif total_salary>
                <cfif SALARY_TYPE eq 2>
                <cfset ucretim = SALARY/30>
                <cfelseif SALARY_TYPE eq 1>
                <cfset ucretim = SALARY>
                <cfelseif SALARY_TYPE eq 0>
                <cfset ucretim = SALARY*SSK_WORK_HOURS>
                </cfif>
            <cfelse>
                <cfset ucretim = total_salary>
            </cfif>	  
            <cfset t_gunluk_ucret = t_gunluk_ucret + ucretim>
            <cfset d_t_gunluk_ucret = d_t_gunluk_ucret + ucretim>
            <cfset d_t_izin_paid = d_t_izin_paid + normal_izinli>
            <cfset t_izin_paid = t_izin_paid + normal_izinli>
            <cfset t_aylik = t_aylik + total_amount>
            <cfset t_aylik_fazla = t_aylik_fazla + ext_salary>
            <cfset t_aylik_fazla_mesai_net = t_aylik_fazla_mesai_net + ext_salary_net>
            <cfset d_t_aylik = d_t_aylik + total_amount>
            <cfset d_t_aylik_fazla = d_t_aylik_fazla + ext_salary>
            <cfset d_t_aylik_fazla_mesai_net = d_t_aylik_fazla_mesai_net + ext_salary_net>
            <cfset aylik_brut_ucret = total_amount-ext_salary-YILLIK_IZIN_AMOUNT-KIDEM_AMOUNT-IHBAR_AMOUNT>
            <cfset t_aylik_brut_ucret = t_aylik_brut_ucret+aylik_brut_ucret>
            <cfset ssk_count = ssk_count+1>

        (

			#currentrow#
            <cfloop list="#attributes.b_obj_hidden_new#" index="xlr">
            <cfswitch expression="#xlr#">
				<cfcase value="b_sira_no">,#sayac#</cfcase>                
                <cfcase value="b_sgk_no">,<cfif len(ssk_no)>'#ssk_no[ssk_count]#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_ad_soyad">,'#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#'</cfcase>
                <cfcase value="b_mon_info">,#ROW_SAL_MON#</cfcase>
                <cfcase value="b_year_info">,#ROW_SAL_YEAR#</cfcase>
                <cfcase value="b_tc_kimlik">,<cfif len(tc_identy_no)>'#tc_identy_no#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_employee_no">,'#employee_no#'</cfcase>
                <cfcase value="b_statu">,<cfif ssk_statute eq 1>'<cf_get_lang dictionary_id ="53043.Normal">'<cfelseif ssk_statute eq 2 or ssk_statute eq 18  >'<cf_get_lang dictionary_id="58541.Emekli">'<cfelse>'<cf_get_lang dictionary_id="58156.Diğer">'</cfif></cfcase>
                <cfcase value="b_sex">,<cfif sex eq 0>'<cf_get_lang dictionary_id="58958.Kadın">'<cfelseif sex eq 1>'<cf_get_lang dictionary_id="58959.Erkek">'</cfif></cfcase>
                <cfcase value="b_ilgili_sirket">,<cfif len(RELATED_COMPANY)>'#RELATED_COMPANY#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_sube">,<cfif len(BRANCH_NAME)>'#BRANCH_NAME#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_departman">
					<cfif isdefined('attributes.is_dep_level') and listlen(dep_level_list)>
						<cfset count_dep = 0>
                        <cfloop list="#dep_level_list#" index="mm">
                        	<cfset count_dep = count_dep + 1>
                            <cfif len(evaluate('DEPARTMAN#count_dep#'))>,'#evaluate("DEPARTMAN#count_dep#")#'<cfelse>,'-'</cfif>
                        </cfloop>
                    </cfif>
                  ,<cfif len(DEPARTMENT_HEAD)>'#DEPARTMENT_HEAD#'<cfelse>NULL</cfif>
                </cfcase>
                <cfcase value="b_pozisyon_sube">,<cfif listlen(branch_list) and len(position_branch_id)>'#get_branchs.branch_name[listfind(branch_list,position_branch_id,',')]#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_pozisyon_departman">,<cfif listlen(department_list) and len(position_department_id)>'#get_departments.department_head[listfind(department_list,position_department_id,',')]#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_ise_giris">,'#dateformat(START_DATE,dateformat_style)#'</cfcase>
                <cfcase value="b_isten_cikis">,<cfif len(FINISH_DATE) and (month(FINISH_DATE) eq ROW_SAL_MON and year(FINISH_DATE) eq ROW_SAL_YEAR)>'#dateformat(FINISH_DATE,'dd.mm.yyyy')#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_gruba_giris">,'#dateformat(group_startdate,dateformat_style)#'</cfcase>
                <cfcase value="b_kidem_date">,'#dateformat(KIDEM_DATE,dateformat_style)#'</cfcase>
                <cfcase value="b_imza">,NULL</cfcase>
                <cfcase value="b_exp">,<cfif len(explanation_id) and len(finish_date) and (month(finish_date) eq row_sal_mon and year(finish_date) eq row_sal_year)>'#get_explanation_name(explanation_id)#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_reason">,<cfif len(reason) and len(finish_date) and (month(finish_date) eq row_sal_mon and year(finish_date) eq row_sal_year)>'#reason#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_ex_in_out_id">,<cfif len(EX_IN)>'#EX_IN#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_ozel_kod">
                	,<cfif len(hierarchy)>'#hierarchy#'<cfelse>NULL</cfif>
                	,<cfif len(ozel_kod)>'#ozel_kod#'<cfelse>NULL</cfif>
                	,<cfif len(ozel_kod2)>'#ozel_kod2#'<cfelse>NULL</cfif>
                    <cfif fusebox.dynamic_hierarchy> ,'#dynamic_hierarchy#.#dynamic_hierarchy_add#'</cfif>
              </cfcase>
                <cfcase value="b_unvan">,<cfif listlen(title_list) and len(title_id)>'#get_titles.title[listfind(title_list,title_id,',')]#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_pozisyon_tipi">,<cfif listlen(position_cat_list) and len(position_cat_id)>'#get_position_cats.position_cat[listfind(position_cat_list,position_cat_id,',')]#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_collar_type">,<cfif collar_type eq 1>'<cf_get_lang dictionary_id="54055.Mavi Yaka">'<cfelseif collar_type eq 2>'<cf_get_lang dictionary_id="54056.Beyaz Yaka">'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_grade_step">,<cfif len(grade) or len(step)>'#grade#-#step#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_pozisyon">,<cfif len(position_name)>'#position_name#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_org_step">,<cfif len(organization_step_name)>'#organization_step_name#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_duty_type">,<cfif len(duty_type)>'#duty_type#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_idari_amir">,<cfif len(upper_position_employee)>'#upper_position_employee#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_fonksiyonel_amir">,<cfif len(upper_position_employee2)>'#upper_position_employee2#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_business_code">
                    ,<cfif len(BUSINESS_CODE_NAME)>'#BUSINESS_CODE#'<cfelse>NULL</cfif>
                    ,<cfif len(BUSINESS_CODE_NAME)>'#BUSINESS_CODE_NAME#'<cfelse>NULL</cfif>
                </cfcase>
                <cfcase value="b_ucret_yontemi">
                    , <cfif salary_type eq 0>
                           '<cf_get_lang dictionary_id ='53260.Saatlik'>' 
                        <cfelseif salary_type eq 1>
                            '<cf_get_lang dictionary_id='58457.Günlük'>'
                        <cfelseif salary_type eq 2>
                            '<cf_get_lang dictionary_id='58932.Aylık'>'
                        <cfelse>
                        	NULL
                        </cfif>
                </cfcase>
                <cfcase value="b_kg">,<cfif len(KISMI_ISTIHDAM_GUN)>#KISMI_ISTIHDAM_GUN#<cfelse>NULL</cfif></cfcase>
               	<cfcase value="b_ks">,<cfif len(KISMI_ISTIHDAM_SAAT)>#KISMI_ISTIHDAM_SAAT#<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_net_brut">,<cfif GROSS_NET eq 0>'<cf_get_lang dictionary_id="53131.Brüt">'<cfelse>'<cf_get_lang dictionary_id="58083.Net">'</cfif></cfcase>
                <cfcase value="b_maas">,<cfif len(maas_)>'#maas_#'<cfelse>NULL</cfif></cfcase>  
                <cfcase value="b_ss_gunu">,<cfif len(normal_gun)>'#normal_gun#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_hs_gunu">,<cfif len(haftalik_tatil)>'#haftalik_tatil#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_genel_tatil_gunu">,<cfif len(genel_tatil)>'#genel_tatil#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_ucretli_izin">,<cfif len(normal_izinli)>'#normal_izinli#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_ucretli_izin_pazar">,<cfif len(paid_izinli_sunday_count)>'#paid_izinli_sunday_count#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_ucretsiz_izin">,<cfif len(izin)>'#izin#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_toplam_gun">,<cfif len(total_days)>'#total_days#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_toplam_calisma_gunu">
                    ,<cfif len(total_days) or len(puantaj_gun_)><cfif total_days lt puantaj_gun_>'#total_days#'<cfelse>'#puantaj_gun_#'</cfif><cfelse>NULL</cfif>
                </cfcase>
                <cfcase value="b_ssk_gunu">
                    ,<cfif len(ssk_days)>'#ssk_days#'<cfelse>NULL</cfif>
              </cfcase>
                <cfcase value="b_hi_saat">
                    ,<cfif len(weekly_hour)>'#weekly_hour#'<cfelse>NULL</cfif>
                    ,<cfif len(weekend_hour)>'#weekend_hour#'<cfelse>NULL</cfif>
                    ,<cfif len(offdays_count_hour)>'#(offdays_count_hour)#'<cfelse>NULL</cfif>
                    ,<cfif len(izin_paid_count)>'#(izin_paid_count-paid_izinli_sunday_count_hour)#'<cfelse>NULL</cfif>
                    ,<cfif len(paid_izinli_sunday_count_hour)>'#(paid_izinli_sunday_count_hour)#'<cfelse>NULL</cfif>
                    ,<cfif len(izin_count)>'#(izin_count)#'<cfelse>NULL</cfif>
                    ,<cfif len(t_saat)>'#(t_saat)#'<cfelse>NULL</cfif>
                </cfcase>
                <cfcase value="b_hafta_ici_mesai">,<cfif len(EXT_TOTAL_HOURS_0)>'#(EXT_TOTAL_HOURS_0)#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_hafta_sonu_mesai">,<cfif len(EXT_TOTAL_HOURS_1)>'#(EXT_TOTAL_HOURS_1)#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_resmi_tatil_mesai">,<cfif len(EXT_TOTAL_HOURS_2)>'#(EXT_TOTAL_HOURS_2)#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_gece_mesai_saat">,<cfif len(EXT_TOTAL_HOURS_5)>'#(EXT_TOTAL_HOURS_5)#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_aylik_mesaisiz">,<cfif len(total_amount)>'#(total_amount - ext_salary)#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_fazla_mesai">,<cfif len(ext_salary)>'#(ext_salary)#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_fazla_mesai_net">,<cfif len(ext_salary_net)>'#(ext_salary_net)#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_gunluk_ucret">,<cfif len(ucretim)>'#(ucretim)#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_aylik_ucret">,<cfif len(total_amount)>'#(total_amount)#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_aylik_brut_ucret">,<cfif len(aylik_brut_ucret)>'#(aylik_brut_ucret)#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_ek_odenek">,<cfif len(total_pay_ssk_tax)>'#(total_pay_ssk_tax+total_pay_ssk+total_pay_tax+total_pay)#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_toplam_kazanc">,'#(TOTAL_SALARY-VERGI_ISTISNA_SSK-VERGI_ISTISNA_VERGI+VERGI_ISTISNA_AMOUNT_)#'</cfcase>
                <cfcase value="b_sgk_matrahi">,'#(SSK_MATRAH)#'</cfcase>
                <cfcase value="b_sgk_isci_hissesi">
                    ,'#(ssk_isci_hissesi-ssk_isci_hissesi_7103)#'
                    ,'#(ssdf_isci_hissesi)#'
                </cfcase>
                <cfcase value="b_bes_isci_hissesi">,'#(bes_isci_hissesi)#'</cfcase>
                <cfcase value="b_issizlik_isci_hissesi">,'#(issizlik_isci_hissesi-issizlik_isci_hissesi_7103)#'</cfcase>
                <cfcase value="b_gelir_vergisi_indirimi">,'#(vergi_indirimi+sakatlik_indirimi)#'</cfcase>
                <cfcase value="b_gelir_vergisi_matrahi">,'#(gelir_vergisi_matrah)#'</cfcase>
                <cfcase value="b_gelir_vergisi_hesaplanan">
                <cfset gelir_vergisi_hesaplanan_ = vergi_iadesi + gelir_vergisi + VERGI_INDIRIMI_5084>
					<cfif is_5746_control eq 0>
                       <cfset gelir_vergisi_hesaplanan_ = gelir_vergisi_hesaplanan_+ gelir_vergisi_indirimi_5746>
                        <!---'#(vergi_iadesi + gelir_vergisi + VERGI_INDIRIMI_5084 + gelir_vergisi_indirimi_5746)#'
                    <cfelse>
                        '#(vergi_iadesi + gelir_vergisi + VERGI_INDIRIMI_5084)#'--->
                    </cfif>
                    <cfif is_4691_control eq 0>
                        <cfset gelir_vergisi_hesaplanan_ = gelir_vergisi_hesaplanan_+ gelir_vergisi_indirimi_4691>
                    </cfif>
                    ,'#(gelir_vergisi_hesaplanan_)#'
                </cfcase>
                <cfcase value="b_asgari_gecim_indirimi">,'#(vergi_iadesi)#'</cfcase>
                <cfcase value="b_gelir_vergisi_indirimi_5746">,'#(gelir_vergisi_indirimi_5746)#'</cfcase>
                <cfcase value="b_gelir_vergisi_indirimi_4691">,'#(gelir_vergisi_indirimi_4691)#'</cfcase>
                <cfcase value="b_gelir_vergisi">,'#(gelir_vergisi-gelir_vergisi_indirimi_7103)#'</cfcase>
                <cfcase value="b_vergi_indirimi_5615">,'#(VERGI_INDIRIMI_5084)#'</cfcase>
                <cfcase value="b_kum_gelir_vergisi_matrahi">,'#(KUMULATIF_GELIR_MATRAH)#'</cfcase>
                <cfcase value="b_damga_vergisi">,'#(damga_vergisi-damga_vergisi_indirimi_7103)#'</cfcase>
                <cfcase value="b_damga_vergisi_matrah">,'#(damga_vergisi_matrah)#'</cfcase>
                <cfcase value="b_toplam_yasal_kesinti">,'#(ssk_isci_hissesi + ssdf_isci_hissesi + gelir_vergisi + damga_vergisi + issizlik_isci_hissesi)#'</cfcase>
                <cfcase value="b_onceki_aydan_devreden_kum_mat">
                	,<cfif isdefined("onceki_donem_kum_gelir_vergisi_matrahi")>
                       '#(onceki_donem_kum_gelir_vergisi_matrahi)#'
                    <cfelse>
                       '#(t_kum_gelir_vergisi_matrahi)#'
                    </cfif>
                </cfcase>
                <cfcase value="b_sgk_devir_isci_hissesi_fark">,'#(sgk_isci_hissesi_fark)#'</cfcase>
                <cfcase value="b_sgk_devir_issizlik_hissesi_fark">,'#(sgk_issizlik_hissesi_fark)#'</cfcase>
                <cfcase value="b_sgdp_isci_primi_fark">,'#(sgdp_isci_primi_fark)#'</cfcase>
                <cfcase value="b_muhtelif_kesintiler">,'#(ozel_kesinti)#'</cfcase>
                <cfcase value="b_net_ucret">,'#(net_ucret-vergi_iadesi)#'</cfcase>
                <cfcase value="b_toplam_net_odenecek">,'#(net_ucret)#'</cfcase>
                <cfcase value="b_sgk_isveren_primi_hesaplanan">
                    ,'#(isveren_hesaplanan)#'
                    ,'#(ssdf_isveren_hissesi)#'
                </cfcase>
                <cfcase value="b_muhasebe_kod_group">,<cfif listlen(def_list) and len(account_bill_type)>'#get_definition.DEFINITION[listfind(def_list,account_bill_type)]#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_sgk_5084">,<cfif ssk_isci_hissesi eq 0>'#(0)#'<cfelse>'#(ssk_isveren_hissesi_5084)#'</cfif></cfcase>
                <cfcase value="b_sgk_5763">,<cfif ssk_isci_hissesi eq 0>'#(0)#'<cfelse>'#(ssk_isveren_hissesi_gov)#'</cfif></cfcase>
                <cfcase value="b_sgk_5510">,'#(ssk_isveren_hissesi_5510_)#'</cfcase>
                <cfcase value="b_sgk_5921">,'#(ssk_isveren_hissesi_5921)#'</cfcase>
                <cfcase value="b_sgk_5746">,'#(ssk_isveren_hissesi_5746)#'</cfcase>
                <cfcase value="b_sgk_4691">,'#(ssk_isveren_hissesi_4691)#'</cfcase>
                <cfcase value="b_sgk_6111">,'#(ssk_isveren_hissesi_6111)#'</cfcase>
                <cfcase value="b_sgk_6486">,'#(ssk_isveren_hissesi_6486)#'</cfcase>
                <cfcase value="b_sgk_6322">,'#(ssk_isveren_hissesi_6322+ssk_isci_hissesi_6322)#'</cfcase>
                <cfcase value="b_sgk_14857">,'#(ssk_isveren_hissesi_14857)#'</cfcase>
                
                <cfcase value="b_sgk_isci_7103">,'#(SSK_ISCI_HISSESI_7103)#'</cfcase>
                <cfcase value="b_issizlik_isci_7103">,'#(ISSIZLIK_ISCI_HISSESI_7103)#'</cfcase>
                <cfcase value="b_gelir_verigisi_7103">,'#(GELIR_VERGISI_INDIRIMI_7103)#'</cfcase>
                <cfcase value="b_damga_vergisi_7103">,'#(DAMGA_VERGISI_INDIRIMI_7103)#'</cfcase>
                <cfcase value="b_sgk_isveren_7103">,'#(SSK_ISVEREN_HISSESI_7103)#'</cfcase>
                <cfcase value="b_issizlik_isveren_7103">,'#(ISSIZLIK_ISVEREN_HISSESI_7103)#'</cfcase>
                
                <cfcase value="b_sgk_isveren_hissesi">
                    ,'#(ssk_isveren_hissesi - ssk_isveren_hissesi_gov - ssk_isveren_hissesi_5921 - ssk_isveren_hissesi_5746 -ssk_isveren_hissesi_4691- ssk_isveren_hissesi_6111-ssk_isveren_hissesi_6486-ssk_isveren_hissesi_6322-ssk_isveren_hissesi_7103-ssk_isveren_hissesi_14857)#'
                    ,'#(ssdf_isveren_hissesi)#'
                </cfcase>
                <cfcase value="b_toplam_sgk_prim">,'#(ssk_isveren_hissesi - ssk_isveren_hissesi_gov - ssk_isveren_hissesi_5921 - ssk_isveren_hissesi_5746-ssk_isveren_hissesi_4691 - ssk_isveren_hissesi_6111-ssk_isveren_hissesi_6486-ssk_isveren_hissesi_6322-SSK_ISVEREN_HISSESI_7103 + ssk_isci_hissesi)#'</cfcase>
                <cfcase value="b_issizlik_isveren_hissesi">,'#(issizlik_isveren_hissesi-issizlik_isveren_hissesi_7103)#'</cfcase>
                <cfcase value="b_yillik_izin_tutari">,'#(yillik_izin)#'</cfcase>
                <cfcase value="b_kidem_tazminati">,'#(kidem_amount)#'</cfcase>
                <cfcase value="b_ihbar_tazminati">,'#(ihbar_amount)#'</cfcase>
                <cfcase value="b_toplam_isveren_maliyeti">,'#(toplam_isveren)#'</cfcase>
                <cfcase value="b_toplam_isveren_maliyeti_indirimsiz">,'#(toplam_isveren_indirimsiz)#'</cfcase>
                <cfcase value="b_ucret_tipi">,<cfif sabit_prim eq 0>'<cf_get_lang dictionary_id="58544.Sabit">'<cfelse>'<cf_get_lang dictionary_id ="53558.Primli">'</cfif></cfcase>
                <cfcase value="b_odeme_metodu">,<cfif len(paymethod_id)>'#GET_PAY_METHODS.paymethod[listfind(pay_list,paymethod_id,',')]#'<cfelse>NULL</cfif></cfcase>  
                <cfcase value="b_fonksiyon">,<cfif listlen(fonsiyonel_list) and len(FUNC_ID)>'#get_units.unit_name[listfind(fonsiyonel_list,func_id,',')]#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_vergi_istisna_toplam">,'#(vergi_istisna_total)#'</cfcase>
                <cfcase value="b_vergi_istisna_sgk">,'#(vergi_istisna_ssk)#'</cfcase>
                <cfcase value="b_vergi_istisna_sgk_net">,'#(vergi_istisna_ssk_net)#'</cfcase>
                <cfcase value="b_vergi_istisna_vergi">,'#(vergi_istisna_vergi)#'</cfcase>
                <cfcase value="b_vergi_istisna_vergi_net">,'#(vergi_istisna_vergi_net)#'</cfcase>
                <cfcase value="b_vergi_istisna_damga">,'#(vergi_istisna_damga)#'</cfcase>
                <cfcase value="b_vergi_istisna_damga_net">,'#(vergi_istisna_damga_net)#'</cfcase>
                <cfcase value="b_ek_odenekler">
                    <cfset count_ = 0>
                    <cfloop list="#odenek_names_yeni#" index="cca">
                        <cfset count_ = count_ + 1>
                        <cfset this_ = evaluate('ODENEK_#count_#')> 
                        <cfset this_net_ = evaluate('ODENEK_NET_#count_#')>
                        <cfif this_net_ eq 0>
                            <cfset this_net_ = this_>
                        </cfif>				
                        <!---<cfif evaluate('FROM_SALARY_#count_#') eq 0 and evaluate('CALC_DAYS_#count_#') eq 1 and total_days gt 0>
                            <cfset this_net_ = this_net_/30*#total_days#>
                        </cfif>--->
                        <cfset 't_odenek_#count_#' = evaluate("t_odenek_#count_#") + this_>
                        <cfset 'd_t_odenek_#count_#' = evaluate("d_t_odenek_#count_#") + this_>
                        <cfset 't_odenek_net_#count_#' = evaluate("t_odenek_net_#count_#") + this_net_>
                        <cfset 'd_t_odenek_net_#count_#' = evaluate("d_t_odenek_net_#count_#") + this_net_>
                        ,#this_#
                        <cfif x_payment_type eq 1>
                            ,#this_net_#
                        </cfif>
                    </cfloop>
                </cfcase>
                <cfcase value="b_vergi_istisna">
                    <cfset count_ = 0>
                    <cfloop list="#vergi_istisna_names_yeni#" index="cca">
                        <cfset count_ = count_ + 1>
                        <cfset this_ =  evaluate('VERGI_ISTISNA_#count_#')>
                        <cfset this_net_ =  evaluate('VERGI_ISTISNA_TOTAL_#count_#')>
                        <cfset 't_vergi_#count_#' = evaluate("t_vergi_#count_#") + this_>
                        <cfset 'd_t_vergi_#count_#' = evaluate("d_t_vergi_#count_#") + this_>
                        <cfset 't_vergi_net_#count_#' = evaluate("t_vergi_net_#count_#") + this_net_>
                        <cfset 'd_t_vergi_net_#count_#' = evaluate("d_t_vergi_net_#count_#") + this_net_>
                        ,#this_#
                        ,#this_net_#
                    </cfloop>
                </cfcase>
                <cfcase value="b_kesintiler">
                    <cfset this_avans_ =  avans>
                    <cfset t_avans = t_avans + this_avans_>
                    <cfset d_t_avans = d_t_avans + this_avans_>
                    ,#this_avans_#
                    <cfset count_ = 0>
                    <cfloop list="#kesinti_names_yeni#" index="cca">
                        <cfset count_ = count_ + 1>
                        <cfset this_ = evaluate('KESINTI_#count_#')>
                        <cfset 't_kesinti_#count_#' = evaluate("t_kesinti_#count_#") + this_>
                        <cfset 'd_t_kesinti_#count_#' = evaluate("d_t_kesinti_#count_#") + this_>
                        ,#this_#
                    </cfloop>
                </cfcase>
                <cfcase value="b_masraf_merkezi">,<cfif listlen(main_expense_list) and len(expense_code)>'#get_expenses.EXPENSE[listfind(main_expense_list,expense_code,';')]#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_masraf_merkezi_kodu">,<cfif len(expense_code)>'#expense_code#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_muhasebe_kodu">,<cfif len(account_code)>'#account_code#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_banka">,<cfif len(BANK_NAME)>'#BANK_NAME#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_hesap_no">,<cfif len(BANK_BRANCH_CODE) or len(BANK_ACCOUNT_NO)>'#BANK_BRANCH_CODE#-#BANK_ACCOUNT_NO#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_iban_no">,<cfif len(IBAN_NO)>'#IBAN_NO#'<cfelse>NULL</cfif></cfcase>
                <cfcase value="b_toplam_devreden_sgk_matrahi">,'#(ssk_devir_ + ssk_devir_last_)#'</cfcase>
                <cfcase value="b_2_onceki_aydan_devreden_sgk_matrahi">,'#ssk_devir_last_#'</cfcase>
                <cfcase value="b_1_onceki_aydan_devreden_sgk_matrahi">,'#ssk_devir_#'</cfcase>
                <cfcase value="b_buaydan_devreden_sgk_matrahi">,'#ssk_amount#'</cfcase>
                <cfcase value="b_kesinti_ve_agi_oncesi_net">,'#(net_ucret-vergi_iadesi+ozel_kesinti+bes_isci_hissesi)#'</cfcase>
            </cfswitch>
          </cfloop>
          ,<cfif len(finish_date) and isdate(finish_date) and (month(finish_date) eq row_sal_mon and year(finish_date) eq row_sal_year)>1<cfelseif len(start_date) and (month(start_date) eq row_sal_mon and year(start_date) eq row_sal_year)>2<cfelse>NULL</cfif>
		)
</cfquery>
</cfoutput> 
<cfquery name="Get_Puantaj_Rows_Temp" datasource="#dsn#" result="getRow">
	SELECT
        ID
        <cfloop list="#attributes.b_obj_hidden_new#" index="xlr">
        <cfswitch expression="#xlr#">
		<cfcase value="b_sira_no">,SIRA_NO AS '<cf_get_lang dictionary_id="53109.Sıra No">'</cfcase>        
        <cfcase value="b_mon_info">,PUANTAJ_AY AS '<cf_get_lang dictionary_id="58650.Puantaj"> <cf_get_lang dictionary_id="58724.Ay">'</cfcase>
        <cfcase value="b_year_info">,PUANTAJ_YIL AS '<cf_get_lang dictionary_id="58650.Puantaj"> <cf_get_lang dictionary_id="58455.Yıl">'</cfcase>
        <cfcase value="b_sgk_no">,SSK_NO AS '<cf_get_lang dictionary_id ="53237.SSK No">'</cfcase>
        <cfcase value="b_ad_soyad">,AD_SOYAD AS '<cf_get_lang dictionary_id ="57570.Adı Soyadı">'</cfcase>
        <cfcase value="b_tc_kimlik">,KIMLIK_NO AS '<cf_get_lang dictionary_id ="58025.TC Kimlik No">'</cfcase>
        <cfcase value="b_employee_no">,CALISAN_NO AS '<cf_get_lang dictionary_id ="58487.Calisan No">'</cfcase>
        <cfcase value="b_statu">,STATU AS '<cf_get_lang dictionary_id ="57894.Statü">'</cfcase>
        <cfcase value="b_sex">,CINSIYET AS '<cf_get_lang dictionary_id ="57764.Cinsiyet">'</cfcase>
        <cfcase value="b_ilgili_sirket">,ILGILI_SIRKET AS '<cf_get_lang dictionary_id ="53701.İlgili Şirket">'</cfcase>
        <cfcase value="b_sube">,SUBE AS '<cf_get_lang dictionary_id ="57453.Şube">'</cfcase>
        <cfcase value="b_departman">
			<cfif isdefined('attributes.is_dep_level')>
                <cfloop query="get_dep_lvl">
                    ,DEPARTMAN_#level_no#
                </cfloop>
            </cfif>
        ,DEPARTMAN AS '<cf_get_lang dictionary_id ='57572.Departman'>'</cfcase>
        <cfcase value="b_pozisyon_sube">,POZISYON_SUBE AS '<cf_get_lang dictionary_id ="53729.Pozisyon Şube">'</cfcase>
        <cfcase value="b_pozisyon_departman">,POZISYON_DEPARTMAN AS '<cf_get_lang dictionary_id ="53728.Pozisyon Departman">'</cfcase>
        <cfcase value="b_ise_giris"> ,ISE_GIRIS AS '<cf_get_lang dictionary_id ="53702.İşe Giriş">'</cfcase>
        <cfcase value="b_isten_cikis">,ISTEN_CIKIS AS '<cf_get_lang dictionary_id ="29832.İşten Çıkış">'</cfcase>
        <cfcase value="b_gruba_giris">,GRUBA_GIRIS AS '<cf_get_lang dictionary_id ="53704.Gruba Girişi">'</cfcase>
        <cfcase value="b_kidem_date">,KIDEM_BAZ AS '<cf_get_lang dictionary_id ="53641.Kıdem Baz Tarihi">'</cfcase>
        <cfcase value="b_imza">,IMZA AS '<cf_get_lang dictionary_id="58957.İmza">'</cfcase>
        <cfcase value="b_ozel_kod">
            ,HIERARCHY_ AS '<cf_get_lang dictionary_id ="57789.Özel Kod">'
            ,OZEL_KOD AS '<cf_get_lang dictionary_id ="57789.Özel Kod">1'
            ,OZEL_KOD2 AS '<cf_get_lang dictionary_id ="57789.Özel Kod">'
        	<cfif fusebox.dynamic_hierarchy>,DYNAMIC_HIERARCHY AS '<cf_get_lang dictionary_id="54354.Dinamik Hiyerarşi">'</cfif>
        </cfcase>
        <cfcase value="b_unvan">,UNVAN AS '<cf_get_lang dictionary_id ="57571.Ünvan">'</cfcase>
        <cfcase value="b_pozisyon_tipi">,POZISYON_TIPI AS '<cf_get_lang dictionary_id="59004.Pozisyon Tipi">'</cfcase>
        <cfcase value="b_collar_type">,YAKA_TIPI AS '<cf_get_lang dictionary_id="54054.Yaka Tipi">'</cfcase>
        <cfcase value="b_grade_step">,DERECE_KADEME AS '<cf_get_lang dictionary_id="54179.Derece"> - <cf_get_lang dictionary_id="58710.Kademe">'</cfcase>
        <cfcase value="b_pozisyon">,POZISYON AS '<cf_get_lang dictionary_id ="53164.Pozisyon">'</cfcase>
        <cfcase value="b_org_step">,KADEME AS '<cf_get_lang dictionary_id ="58710.Kademe">'</cfcase>
        <cfcase value="b_duty_type">,GOREV_TIPI AS '<cf_get_lang dictionary_id ="58538.Görev Tipi">'</cfcase>
        <cfcase value="b_ucret_yontemi">,UCRET_YONTEMI AS '<cf_get_lang dictionary_id ="53714.Ücret Yöntemi">'</cfcase>
        <cfcase value="b_kg">,KISMI_ISTIHDAM_GUN AS '<cf_get_lang dictionary_id ="53804.KG">'</cfcase>
        <cfcase value="b_ks">,KISMI_ISTIHDAM_SAAT AS '<cf_get_lang no ="1410.KS">'</cfcase>
        <cfcase value="b_net_brut">,NET_BRUT AS '<cf_get_lang dictionary_id="58083.Net"> / <cf_get_lang dictionary_id="53131.Brüt">'</cfcase>
        <cfcase value="b_maas">,ROUND(UCRET,2) AS '<cf_get_lang dictionary_id="53127.Ücret">'</cfcase>
        <cfcase value="b_ss_gunu">,SS_GUNU AS '<cf_get_lang dictionary_id ="53715.SS Günü">'</cfcase>
        <cfcase value="b_hs_gunu">,HS_GUNU AS '<cf_get_lang dictionary_id ="53716.HS Günü">'</cfcase>
        <cfcase value="b_genel_tatil_gunu">,GENEL_TATIL_GUNU AS '<cf_get_lang dictionary_id ="53706.Genel Tatil Günü">'</cfcase>
        <cfcase value="b_ucretli_izin">,UCRETLI_IZIN AS '<cf_get_lang dictionary_id ="53686.Ücretli İzin">'</cfcase>
        <cfcase value="b_ucretli_izin_pazar">,UCRETLI_IZIN_PAZAR AS '<cf_get_lang dictionary_id ="53687.Ücretli İzin Pazar">'</cfcase>
        <cfcase value="b_ucretsiz_izin">,UCRETSIZ_IZIN AS '<cf_get_lang dictionary_id ="53688.Ücretsiz İzin">'</cfcase>
        <cfcase value="b_toplam_gun">,TOPLAM_GUN AS '<cf_get_lang dictionary_id="53745.Toplam Gün">'</cfcase>
        <cfcase value="b_toplam_calisma_gunu">,CALISMA_GUNU AS '<cf_get_lang dictionary_id ="53727.Çalışma Günü">'</cfcase>
        <cfcase value="b_ssk_gunu">,SGK_GUNU AS '<cf_get_lang dictionary_id="53816.SGK Günü"> '</cfcase>
        <cfcase value="b_idari_amir">,BIRINCI_AMIR AS '<cf_get_lang dictionary_id="53705.Birinci Amir">'</cfcase>
       	<cfcase value="b_exp">,ISTEN_CIKIS_NEDENI AS '<cf_get_lang dictionary_id="53882.İşten Çıkış Nedeni">'</cfcase>
       	<cfcase value="b_reason">,SIRKET_ICI_GEREKCE AS '<cf_get_lang dictionary_id="53643.Şirket İçi Gerekçe">'</cfcase>
       	<cfcase value="b_ex_in_out_id">,GIRIS_GEREKCE AS '<cf_get_lang dictionary_id="57554.Giriş"> <cf_get_lang dictionary_id="52990.Gerekçe">'</cfcase>
       	<cfcase value="b_fonksiyonel_amir">,IKINCI_AMIR AS '<cf_get_lang dictionary_id="53713.İkinci Amir">'</cfcase>
       	<cfcase value="b_business_code">
            ,MESLEK_KODU AS "<cf_get_lang dictionary_id='55494.Meslek'> <cf_get_lang dictionary_id='32646.Kodu'>"
            ,MESLEK_GRUBU AS "<cf_get_lang dictionary_id='53861.Meslek Grubu'>"
        </cfcase>
        <cfcase value="b_hi_saat">
            ,SS_GUNU_SAAT AS '<cf_get_lang dictionary_id ="53715.SS Günü"> (<cf_get_lang dictionary_id="57491.Saat">)'
            ,HS_GUNU_SAAT AS '<cf_get_lang dictionary_id ="53716.HS Günü"> (<cf_get_lang dictionary_id="57491.Saat">)'
            ,GENEL_TATIL_GUNU_SAAT AS '<cf_get_lang dictionary_id ="53706.Genel Tatil Günü"> (<cf_get_lang dictionary_id="57491.Saat">)'
            ,UCRETLI_IZIN_SAAT AS '<cf_get_lang dictionary_id ="53686.Ücretli İzin"> (<cf_get_lang dictionary_id="57491.Saat">)'
            ,UCRETLI_IZIN_PAZAR_SAAT AS '<cf_get_lang dictionary_id ="53687.Ücretli İzin Pazar"> (<cf_get_lang dictionary_id="57491.Saat">)'
            ,UCRETSIZ_IZIN_SAAT AS '<cf_get_lang dictionary_id ="53688.Ücretsiz İzin"> (<cf_get_lang dictionary_id="57491.Saat">)'
            ,TOPLAM_SAAT AS '<cf_get_lang dictionary_id="57492.Toplam"> <cf_get_lang dictionary_id="57491.Saat">'
        </cfcase>
        <cfcase value="b_hafta_ici_mesai">,HAFTA_ICI_MESAI AS '<cf_get_lang dictionary_id ="53744.Hafta İçi Mesai">'</cfcase>
        <cfcase value="b_hafta_sonu_mesai">,HAFTA_SONU_MESAI AS '<cf_get_lang dictionary_id ="53743.Hafta Sonu Mesai">'</cfcase>
        <cfcase value="b_resmi_tatil_mesai">,RESMI_TATIL_MESAI AS '<cf_get_lang dictionary_id ="53742.Resmi Tatil Mesai">'</cfcase>
        <cfcase value="b_gece_mesai_saat">,GECE_MESAISI AS '<cf_get_lang dictionary_id="54329.Gece Mesaisi">'</cfcase>
        <cfcase value="b_aylik_mesaisiz">,ROUND(AYLIK_MESAISIZ,2) AS '<cf_get_lang dictionary_id ="53717.Aylık Mesaisiz">'</cfcase>
        <cfcase value="b_fazla_mesai">,ROUND(FAZLA_MESAI,2) AS '<cf_get_lang dictionary_id ="53718.Fazla Mesai">'</cfcase>
        <cfcase value="b_fazla_mesai_net">,ROUND(FAZLA_MESAI_NET,2) AS '<cf_get_lang dictionary_id ="53718.Fazla Mesai"> <cf_get_lang dictionary_id="58083.Net">'</cfcase>
        <cfcase value="b_gunluk_ucret">,ROUND(GUNLUK_UCRET,2) AS '<cf_get_lang dictionary_id ="53242.Günlük Ücret">'</cfcase>
        <cfcase value="b_aylik_ucret">,ROUND(AYLIK_UCRET,2) AS '<cf_get_lang dictionary_id ="53243.Aylık Ücret">'</cfcase>
        <cfcase value="b_aylik_brut_ucret">,ROUND(AYLIK_BRUT_UCRET,2) AS 'Aylık Brüt Ücret'</cfcase>
       	<cfcase value="b_ek_odenek">,ROUND(EK_ODENEK,2) AS '<cf_get_lang dictionary_id ="53082.Ek Ödenek">'</cfcase>
        <cfcase value="b_toplam_kazanc">,ROUND(TOPLAM_KAZANC,2) AS '<cf_get_lang dictionary_id ="53244.Toplam Kazanç">'</cfcase>
        <cfcase value="b_sgk_matrahi">,ROUND(SGK_MATRAHI,2) AS '<cf_get_lang dictionary_id ="53245.SSK Matrahı">'</cfcase>
        <cfcase value="b_sgk_isci_hissesi">
            ,ROUND(SGK_ISCI_HISSESI,2) AS "<cf_get_lang dictionary_id ='53246.SSK İşçi H'>"
            ,ROUND(SGDP_ISCI_HISSESI,2) AS "<cf_get_lang dictionary_id ='47802.SSK İşçi H'>"
        </cfcase>
        <cfcase value="b_bes_isci_hissesi">,ROUND(BES_ISCI_HISSESI,2) AS 'BES Katılım Payı'</cfcase>
        <cfcase value="b_issizlik_isci_hissesi">,ROUND(ISSIZLIK_SIGORTASI_ISCI_PRIMI,2) AS '<cf_get_lang dictionary_id="54330.İşsizlik Sigortası İşçi Primi">'</cfcase>
        <cfcase value="b_gelir_vergisi_indirimi">,ROUND(GELIR_VERGISI_INDIRIMI,2) AS '<cf_get_lang dictionary_id ="53248.Gelir Vergisi İndirimi">'</cfcase>
        <cfcase value="b_gelir_vergisi_matrahi">,ROUND(GELIR_VERGISI_MATRAHI,2) AS '<cf_get_lang dictionary_id ="53249.Gelir Vergisi Matrahı">'</cfcase>
        <cfcase value="b_gelir_vergisi_hesaplanan">,ROUND(GELIR_VERGISI_HESAPLANAN,2) AS '<cf_get_lang dictionary_id ="53689.Gelir Vergisi Hesaplanan">'</cfcase>
        <cfcase value="b_asgari_gecim_indirimi">,ROUND(ASGARI_GECIM_INDIRIMI,2) AS '<cf_get_lang dictionary_id ="53659.Asgari Geçim İndirimi">'</cfcase>
        <cfcase value="b_gelir_vergisi_indirimi_5746">,ROUND(GELIR_VERGISI_INDIRIMI_5746,2) AS '<cf_get_lang dictionary_id ="53250.Gelir Vergisi"> <cf_get_lang dictionary_id="54268.İndirimi"> 5746'</cfcase>
        <cfcase value="b_gelir_vergisi_indirimi_4691">,ROUND(GELIR_VERGISI_INDIRIMI_4691,2) AS '<cf_get_lang dictionary_id ="53250.Gelir Vergisi"> <cf_get_lang dictionary_id="54268.İndirimi"> 4691'</cfcase>
        <cfcase value="b_gelir_vergisi">,ROUND(GELIR_VERGISI,2) AS '<cf_get_lang dictionary_id ="53250.Gelir Vergisi">'</cfcase>
        <cfcase value="b_vergi_indirimi_5615"> ,ROUND(VERGI_INDIRIMI_5084,2) AS '<cf_get_lang dictionary_id ="53690.Vergi İndirimi"> <cfif (attributes.sal_year eq 2007 and attributes.sal_mon gt 6) or attributes.sal_year gte 2008>5615<cfelse>5084</cfif>'</cfcase>
        <cfcase value="b_kum_gelir_vergisi_matrahi">,ROUND(KUMULATIF_GELIR_VERGISI_MATRAHI,2) AS '<cf_get_lang dictionary_id ="53251.Küm Gel Ver Matrah">'</cfcase>
        <cfcase value="b_damga_vergisi">,ROUND(DAMGA_VERGISI,2) AS '<cf_get_lang dictionary_id ="53252.Damga Vergisi">'</cfcase>
        <cfcase value="b_damga_vergisi_matrah">,ROUND(DAMGA_VERGISI_MATRAHI,2) AS '<cf_get_lang dictionary_id="59363.Damga Vergisi Matrahı">'</cfcase>
        <cfcase value="b_toplam_yasal_kesinti">,ROUND(TOPLAM_YASAL_KESINTI,2) AS '<cf_get_lang dictionary_id ="53722.Toplam Yasal Kesinti">'</cfcase>
        <cfcase value="b_onceki_aydan_devreden_kum_mat">,ROUND(ONCEKI_AYDAN_DEVREDEN_KUMULATIF_MATRAH,2) AS '<cf_get_lang dictionary_id="54297.Önceki Aydan Dev Küm Matrah">'</cfcase>
        <cfcase value="b_sgk_devir_isci_hissesi_fark">,ROUND(SGK_DEVIR_ISCI_HISSESI_FARK,2) AS '<cf_get_lang dictionary_id="54300.SGK Devir Isci Hissesi Fark">'</cfcase>
        <cfcase value="b_sgk_devir_issizlik_hissesi_fark">,ROUND(SGK_DEVIR_ISSIZLIK_HISSESI_FARK,2) AS '<cf_get_lang dictionary_id="54301.SGK Devir İşsizlik Hissesi Fark">'</cfcase>
        <cfcase value="b_sgdp_isci_primi_fark">,ROUND(SGDP_ISCI_PRIMI_FARK,2) AS '<cf_get_lang dictionary_id="54302.SGDP İşçi Primi Fark">'</cfcase>
        <cfcase value="b_muhtelif_kesintiler">,ROUND(MUHTELIF_KESINTILER,2) AS '<cf_get_lang dictionary_id ="53254.Muhtelif Kesintiler">'</cfcase>
        <cfcase value="b_net_ucret">,ROUND(NET_UCRET,2) AS '<cf_get_lang dictionary_id ="53255.Net Ücret">'</cfcase>
        <cfcase value="b_toplam_net_odenecek">,ROUND(TOPLAM_NET_ODENECEK,2) AS '<cf_get_lang dictionary_id ="53691.Toplam Net Ödenecek">'</cfcase>
        <cfcase value="b_sgk_isveren_primi_hesaplanan">
            ,ROUND(SGK_ISVEREN_PRIMI_HESAPLANAN,2) AS '<cf_get_lang dictionary_id="53698.SGK İşveren Primi Hesaplanan">'
            ,ROUND(SGDP_ISVEREN_PRIMI_HESAPLANAN,2) AS '<cf_get_lang dictionary_id="59364.SGDP İşveren Primi Hesaplanan">'
        </cfcase>
		<cfcase value="b_muhasebe_kod_group">,MUHASEBE_KOD_GRUBU AS '<cf_get_lang dictionary_id='54117.Muhasebe Kod Grubu'>'</cfcase>
        <cfcase value="b_sgk_5084">,ROUND(SGK_ISVEREN_PRIMI_INDIRIMI_5084,2) AS '<cf_get_lang dictionary_id="54331.SGK İşv Primi"> 5084 <cf_get_lang dictionary_id="54268.İndirimi">'</cfcase>
        <cfcase value="b_sgk_5763">,ROUND(SGK_ISVEREN_PRIMI_INDIRIMI_5763,2) AS '<cf_get_lang dictionary_id="54331.SGK İşv Primi"> 5763 <cf_get_lang dictionary_id="54268.İndirimi">'</cfcase>
        <cfcase value="b_sgk_5510">,ROUND(SGK_ISVEREN_PRIMI_INDIRIMI_5510,2) AS '<cf_get_lang dictionary_id="54331.SGK İşv Primi"> 5510 <cf_get_lang dictionary_id="54268.İndirimi">'</cfcase>
        <cfcase value="b_sgk_5921">,ROUND(SGK_ISVEREN_PRIMI_INDIRIMI_5921,2) AS '<cf_get_lang dictionary_id="54331.SGK İşv Primi"> 5921 <cf_get_lang dictionary_id="54268.İndirimi">'</cfcase>
        <cfcase value="b_sgk_5746">,ROUND(SGK_ISVEREN_PRIMI_INDIRIMI_5746,2) AS '<cf_get_lang dictionary_id="54331.SGK İşv Primi"> 5746 <cf_get_lang dictionary_id="54268.İndirimi">'</cfcase>
        <cfcase value="b_sgk_4691">,ROUND(SGK_ISVEREN_PRIMI_INDIRIMI_4691,2) AS '<cf_get_lang dictionary_id="54331.SGK İşv Primi"> 4691 <cf_get_lang dictionary_id="54268.İndirimi">'</cfcase>
        <cfcase value="b_sgk_6111">,ROUND(SGK_ISVEREN_PRIMI_INDIRIMI_6111,2) AS '<cf_get_lang dictionary_id="54331.SGK İşv Primi"> 6111 <cf_get_lang dictionary_id="54268.İndirimi">'</cfcase>
        <cfcase value="b_sgk_6486">,ROUND(SGK_ISVEREN_PRIMI_INDIRIMI_6486,2) AS '<cf_get_lang dictionary_id="54331.SGK İşv Primi"> 6486 <cf_get_lang dictionary_id="54268.İndirimi">'</cfcase>
        <cfcase value="b_sgk_6322">,ROUND(SGK_ISVEREN_PRIMI_INDIRIMI_6322,2) AS '<cf_get_lang dictionary_id="54331.SGK İşv Primi"> 6322 <cf_get_lang dictionary_id="54268.İndirimi">'</cfcase>
        <cfcase value="b_sgk_14857">,ROUND(SGK_ISVEREN_PRIMI_INDIRIMI_14857,2) AS '<cf_get_lang dictionary_id="54331.SGK İşv Primi"> 14857 <cf_get_lang dictionary_id="54268.İndirimi">'</cfcase>
        
        <cfcase value="b_sgk_isci_7103">,ROUND(SSK_ISCI_HISSESI_7103,2) AS '<cf_get_lang dictionary_id="53719.SGK İşçi Primi"> <cf_get_lang dictionary_id="54268.İndirimi"> 7103'</cfcase>
        <cfcase value="b_issizlik_isci_7103">,ISSIZLIK_ISCI_HISSESI_7103 AS '<cf_get_lang dictionary_id="59369.İssizlik İşçi Primi"> 7103'</cfcase>
        <cfcase value="b_gelir_verigisi_7103">,GELIR_VERGISI_INDIRIMI_7103 AS '<cf_get_lang dictionary_id="53248.Gelir Vergisi İndirimi"> 7103'</cfcase>
        <cfcase value="b_damga_vergisi_7103">,DAMGA_VERGISI_INDIRIMI_7103 AS '<cf_get_lang dictionary_id="59370.Damga Vergisi İndirimi"> 7103'</cfcase>
        <cfcase value="b_sgk_isveren_7103">,SSK_ISVEREN_HISSESI_7103 AS '<cf_get_lang dictionary_id="59371.SGK İşveren İndirimi"> 7103'</cfcase>
        <cfcase value="b_issizlik_isveren_7103">,ISSIZLIK_ISVEREN_HISSESI_7103 AS '<cf_get_lang dictionary_id="59372.İşsizlik İşveren İndirimi"> 7103'</cfcase>
        
		<cfcase value="b_sgk_isveren_hissesi">
            ,ROUND(SGK_ISVEREN_PRIMI,2) AS '<cf_get_lang dictionary_id="53256.SGK İşveren Primi">'
            ,ROUND(SGDP_ISVEREN_PRIMI,2) AS '<cf_get_lang dictionary_id="54311.SGDP İşveren Primi">'
        </cfcase>
        <cfcase value="b_toplam_sgk_prim">,ROUND(TOPLAM_SGK_PRIM,2) AS '<cf_get_lang dictionary_id="59373.SGK Primi">'</cfcase>
        <cfcase value="b_issizlik_isveren_hissesi">,ROUND(ISSIZLIK_SIGORTASI_ISVEREN_PRIMI,2) AS '<cf_get_lang dictionary_id ="53257.İşsizlik Sigortası İşveren  Primi">'</cfcase>
        <cfcase value="b_yillik_izin_tutari">,ROUND(YILLIK_IZIN_TUTARI,2) AS '<cf_get_lang dictionary_id ="53393.Yıllık İzin T">'</cfcase>
        <cfcase value="b_kidem_tazminati">,ROUND(KIDEM_TAZMINATI,2) AS '<cf_get_lang dictionary_id="52991.Kıdem Tazminatı">'</cfcase>
        <cfcase value="b_ihbar_tazminati">,ROUND(IHBAR_TAZMINATI,2) AS '<cf_get_lang dictionary_id="52992.İhbar Tazminatı">'</cfcase>
        <cfcase value="b_toplam_isveren_maliyeti">,ROUND(TOPLAM_ISVEREN_MALIYETI,2) AS '<cf_get_lang dictionary_id ="53708.Toplam İşveren Maliyeti">'</cfcase>
        <cfcase value="b_toplam_isveren_maliyeti_indirimsiz">,ROUND(TOPLAM_ISVEREN_MALIYETI_INDIRIMSIZ,2) AS '<cf_get_lang dictionary_id ="59378.Toplam İşveren Maliyeti İndirimsiz">'</cfcase>
        <cfcase value="b_ucret_tipi">,UCRET_TIPI AS '<cf_get_lang dictionary_id ="53238.Ücret Tipi">'</cfcase>
        <cfcase value="b_odeme_metodu">,ODEME_METHODU AS '<cf_get_lang dictionary_id ="53557.Ödeme Metodu">'</cfcase>
        <cfcase value="b_fonksiyon">,FONKSIYON AS '<cf_get_lang dictionary_id='58701.Fonksiyon'>'</cfcase>
        <cfcase value="b_vergi_istisna_toplam">,ROUND(VERGI_ISTISNASI_TOPLAM,2) AS '<cf_get_lang dictionary_id="53017.Vergi İstisnası"> <cf_get_lang dictionary_id="57492.Toplam">'</cfcase>
        <cfcase value="b_vergi_istisna_sgk">,ROUND(VERGI_ISTISNASI_SGK,2) AS '<cf_get_lang dictionary_id="53017.Vergi İstisnası"> <cf_get_lang dictionary_id="58714.SGK">'</cfcase>
        <cfcase value="b_vergi_istisna_sgk_net">,ROUND(VERGI_ISTISNASI_SGK_NET,2) AS '<cf_get_lang dictionary_id="53017.Vergi İstisnası"> <cf_get_lang dictionary_id="58714.SGK"> <cf_get_lang dictionary_id="58083.Net">'</cfcase>
        <cfcase value="b_vergi_istisna_vergi">,ROUND(VERGI_ISTISNASI_VERGI,2) AS '<cf_get_lang dictionary_id="53017.Vergi İstisnası"> <cf_get_lang dictionary_id="53332.Vergi">'</cfcase>
        <cfcase value="b_vergi_istisna_vergi_net">,ROUND(VERGI_ISTISNASI_VERGI_NET,2) AS '<cf_get_lang dictionary_id="53017.Vergi İstisnası"> <cf_get_lang dictionary_id="53332.Vergi"> <cf_get_lang dictionary_id="58083.Net">'</cfcase>
        <cfcase value="b_vergi_istisna_damga">,ROUND(VERGI_ISTISNASI_DAMGA,2) AS '<cf_get_lang dictionary_id="53017.Vergi İstisnası"> <cf_get_lang dictionary_id="54121.Damga">'</cfcase>
        <cfcase value="b_vergi_istisna_damga_net">,ROUND(VERGI_ISTISNASI_DAMGA_NET,2) AS '<cf_get_lang dictionary_id="53017.Vergi İstisnası"> <cf_get_lang dictionary_id="54121.Damga"> <cf_get_lang dictionary_id="58083.Net">'</cfcase>
        <cfcase value="b_masraf_merkezi">,MASRAF_MERKEZI AS '<cf_get_lang dictionary_id="58460.Masraf Merkezi">'</cfcase>
        <cfcase value="b_masraf_merkezi_kodu">,MASRAF_MERKEZI_KODU AS '<cf_get_lang dictionary_id ="53747.Masraf Merkezi Kodu">'</cfcase>
        <cfcase value="b_muhasebe_kodu">,MUHASEBE_KODU AS '<cf_get_lang dictionary_id="58811.Muhasebe Kodu">'</cfcase>
        <cfcase value="b_banka">,BANKA_ADI AS '<cf_get_lang dictionary_id="57521.Banka"> <cf_get_lang dictionary_id="57897.Adı">'</cfcase>
        <cfcase value="b_hesap_no">,HESAP_NO AS '<cf_get_lang dictionary_id="58178.Hesap No">'</cfcase>
        <cfcase value="b_iban_no">,IBAN_NO AS '<cf_get_lang dictionary_id="54332.IBAN No">'</cfcase>
        <cfcase value="b_toplam_devreden_sgk_matrahi">,ROUND(TOPLAM_DEVREDEN_SGK_MATRAH,2) AS '<cf_get_lang dictionary_id="54333.Toplam Devreden SGK Matrahı">'</cfcase>
        <cfcase value="b_2_onceki_aydan_devreden_sgk_matrahi">,ROUND(IKI_ONCEKI_AYDAN_DEVREDEN_SGK_MATRAHI,2) AS '<cf_get_lang dictionary_id="54334.İki Önceki Aydan Devreden SGK Matrahı">'</cfcase>
        <cfcase value="b_1_onceki_aydan_devreden_sgk_matrahi">,ROUND(BIR_ONCEKI_AYDAN_DEVREDEN_SGK_MATRAHI,2) AS '<cf_get_lang dictionary_id="54335.Bir Önceki Aydan Devreden SGK Matrahı">'</cfcase>
       	<cfcase value="b_buaydan_devreden_sgk_matrahi">,ROUND(BU_AYDAN_DEVREDEN_SGK_MATRAHI,2) AS '<cf_get_lang dictionary_id="59375.Bu Aydan Devreden SGK Matrahı">'</cfcase>
        <cfcase value="b_kesinti_ve_agi_oncesi_net">,ROUND(KESINTI_VE_AGI_ONCESI_NET,2) AS '<cf_get_lang no="54310.Kesinti ve AGİ Öncesi Net">'</cfcase>
        <cfcase value="b_ek_odenekler">
            <cfloop list="#odenek_names_yeni#" index="cca">
                ,<cfoutput>ROUND(ODENEK_#listlast(cca,';')#,2)</cfoutput> AS '#listfirst(cca,';')#'
                <cfif x_payment_type eq 1>
                    ,ROUND(<cfoutput>ODENEK_#listlast(cca,';')#</cfoutput>_TANIMLANAN,2) AS '#listfirst(cca,';')#_Tanımlanan'
                </cfif>
            </cfloop>
        </cfcase>
        <cfcase value="b_kesintiler">
            ,ROUND(Avans,2) AS '<cf_get_lang dictionary_id="58204.Avans">'
            <cfloop list="#kesinti_names_yeni#" index="cca">
                ,<cfoutput>ROUND(KESINTI_#listlast(cca,';')#,2)</cfoutput> AS '#listfirst(cca,';')#'
            </cfloop>
        </cfcase>
        <cfcase value="b_vergi_istisna">
            <cfloop list="#vergi_istisna_names_yeni#" index="cca">
                ,<cfoutput>ROUND(ISTISNA_#listlast(cca,';')#,2)</cfoutput> AS '#listfirst(cca,';')#'
                ,ROUND(<cfoutput>ISTISNA_#listlast(cca,';')#</cfoutput>_Net,2) AS '#listfirst(cca,';')#_Net'
            </cfloop>
        </cfcase>
   	 </cfswitch>
    </cfloop>
    ,COLOR
    FROM 
    	##Puantaj_Rows_Temp
</cfquery>
</CFTRANSACTION>
