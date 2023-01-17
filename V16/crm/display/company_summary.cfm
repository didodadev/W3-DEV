<cfsetting showdebugoutput="no">
<cfquery name="GET_COMPANY" datasource="#DSN#">
	SELECT 
		( SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = COMPANY.CITY ) AS CITY_NAME, 
		COMPANY.FULLNAME, 
		COMPANY_PARTNER.COMPANY_PARTNER_NAME, 
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME, 
		COMPANY.COMPANY_ID, 
		COMPANY.COMPANY_TELCODE, 
		COMPANY.COMPANY_TEL1, 
		COMPANY.TAXNO, 
		COMPANY.COUNTY, 
		COMPANY.DISTRICT, 
		COMPANY.TAXOFFICE, 
		COMPANY.MAIN_STREET, 
		COMPANY.COMPANY_ADDRESS, 
		COMPANY.DUKKAN_NO, 
		COMPANY.COMPANY_TEL2, 
		COMPANY.COMPANY_TEL3, 
		COMPANY.SEMT, 
		COMPANY.COMPANY_FAX_CODE, 
		COMPANY.COMPANY_FAX, 
		COMPANY.COMPANY_EMAIL, 
		COMPANY.CITY, 
		COMPANY.COMPANY_POSTCODE, 
		COMPANY.COUNTRY, 
		COMPANY.HOMEPAGE, 
		COMPANY.MANAGER_PARTNER_ID, 
		COMPANY_PARTNER.PARTNER_ID, 
		COMPANY_CAT.COMPANYCAT, 
		COMPANY_CAT.COMPANYCAT_ID, 
		COMPANY.STREET, 
		SETUP_IMS_CODE.IMS_CODE, 
		SETUP_IMS_CODE.IMS_CODE_NAME, 
		SETUP_COUNTY.COUNTY_NAME, 
		SETUP_CITY.CITY_NAME, 
		SETUP_COUNTRY.COUNTRY_NAME
	FROM 
		COMPANY, 
		COMPANY_CAT, 
		COMPANY_PARTNER, 
		SETUP_COUNTY, 
		SETUP_CITY,
		SETUP_IMS_CODE, 
		SETUP_COUNTRY
	WHERE 
		COMPANY.COMPANY_ID = #attributes.cpid# AND 
		COMPANY_CAT.COMPANYCAT_ID = COMPANY.COMPANYCAT_ID AND 
		COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID AND 
		SETUP_IMS_CODE.IMS_CODE_ID = COMPANY.IMS_CODE_ID AND
		COMPANY_PARTNER.PARTNER_ID = COMPANY.MANAGER_PARTNER_ID AND 
		SETUP_COUNTY.COUNTY_ID = COMPANY.COUNTY AND 
		SETUP_CITY.CITY_ID = COMPANY.CITY AND 
		SETUP_COUNTRY.COUNTRY_ID = COMPANY.COUNTRY
	ORDER BY 
		COMPANY.FULLNAME
</cfquery>
<input type="hidden" name="frame_fuseaction" id="frame_fuseaction" value="<cfif isdefined("attributes.frame_fuseaction") and len(attributes.frame_fuseaction)><cfoutput>#attributes.frame_fuseaction#</cfoutput></cfif>">
<cfif get_company.recordcount eq 0>
	<p align="center"><b><cf_get_lang no='493.Bu Müşteri Crm Modulu Kullanılarak Girilmiş Bir Müşteri Değil  Lütfen Bu Müşterinin Bilgilerini Member Modulunu Kullanarak İnceleyiniz'> !</b></p>
	<cfabort>
</cfif>
<cfquery name="GET_COMPANY_PARTNER" datasource="#DSN#">
	SELECT 
		COMPANY_PARTNER.PARTNER_ID, 
		COMPANY_PARTNER.ASSISTANCE_STATUS, 
		COMPANY_PARTNER.MAIL, 
		COMPANY_PARTNER.MOBILTEL, 
		COMPANY_PARTNER.MOBIL_CODE, 
		SETUP_PARTNER_POSITION.PARTNER_POSITION_ID, 
		SETUP_PARTNER_POSITION.PARTNER_POSITION, 
		SETUP_PARTNER_POSITION.IS_UNIVERSITY 
	FROM 
		COMPANY_PARTNER, 
		SETUP_PARTNER_POSITION 
	WHERE 
		COMPANY_PARTNER.COMPANY_ID = #attributes.cpid# AND 
		COMPANY_PARTNER.PARTNER_ID <> #get_company.manager_partner_id# AND 
		SETUP_PARTNER_POSITION.PARTNER_POSITION_ID =COMPANY_PARTNER.ASSISTANCE_STATUS
</cfquery>
<cfquery name="GET_COMPANY_BRANCH_RELATED1" datasource="#DSN#">
	SELECT 
		COMPANY_BRANCH_RELATED.SALES_DIRECTOR, 
		COMPANY_BRANCH_RELATED.MUSTERIDURUM, 
		COMPANY_BRANCH_RELATED.PLASIYER_ID, 
		COMPANY_BRANCH_RELATED.TEL_SALE_PREID, 
		COMPANY_BRANCH_RELATED.RELATED_ID,
		BRANCH.BRANCH_NAME, 
		OUR_COMPANY.NICK_NAME, 
		OUR_COMPANY.COMP_ID,
		COMPANY_BOYUT_DEPO_KOD.BOYUT_KODU,
		BRANCH.BRANCH_ID		
	FROM 
		COMPANY_BRANCH_RELATED, 
		BRANCH, 
		OUR_COMPANY, 
		COMPANY_BOYUT_DEPO_KOD
	WHERE 
		COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
		COMPANY_BRANCH_RELATED.COMPANY_ID = #attributes.cpid# AND 
		BRANCH.BRANCH_ID = COMPANY_BRANCH_RELATED.BRANCH_ID AND 
		OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID AND 
		COMPANY_BRANCH_RELATED.MUSTERIDURUM NOT IN (1,2) AND 
		COMPANY_BOYUT_DEPO_KOD.W_KODU = BRANCH.BRANCH_ID 
	ORDER BY 
		COMPANY_BRANCH_RELATED.BRANCH_ID
</cfquery>
<cfquery name="GET_COMPANY_BRANCH_RELATED" datasource="#DSN#">
	SELECT 
		COMPANY_BRANCH_RELATED.SALES_DIRECTOR, 
		COMPANY_BRANCH_RELATED.MUSTERIDURUM, 
		COMPANY_BRANCH_RELATED.PLASIYER_ID, 
		COMPANY_BRANCH_RELATED.TEL_SALE_PREID,
		COMPANY_BRANCH_RELATED.RELATED_ID,
		BRANCH.BRANCH_NAME, 
		OUR_COMPANY.NICK_NAME, 
		COMPANY_BOYUT_DEPO_KOD.BOYUT_KODU
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
		EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code# 
	ORDER BY 
		COMPANY_BRANCH_RELATED.BRANCH_ID
</cfquery>
<cfquery name="GET_BRANCH_VAL" datasource="#DSN#">
	SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#
</cfquery>
<cftry>
	<cfquery name="GET_FINANCE_INFO" datasource="hedef_crm">
		SELECT 
			HEDEFKODU, 
			DEPO_KODU, 
			MUSTERI_KODU, 
			AKTARIM_TARIH, 
			ACIK_HESAP_BAKIYE, 
			KARSILIKSIZ_CEK_ADET, 
			KARSILIKSIZ_CEK_TUTAR, 
			KARSILIKSIZ_SENET_ADET, 
			KARSILIKSIZ_SENET_TUTAR, 
			KARSILIKSIZ_POS_ADET, 
			KARSILIKSIZ_POS_TUTAR, 
			KARSILIKSIZ_KK_ADET, 
			KARSILIKSIZ_KK_TUTAR, 
			VADELI_CEK_ADET, 
			VADELI_CEK_TUTAR, 
			VADELI_SENET_ADET, 
			VADELI_SENET_TUTAR, 
			VADELI_POS_ADET, 
			VADELI_POS_TUTAR, 
			VADELI_KK_ADET, 
			VADELI_KK_TUTAR, 
			RISK_LIMIT, 
			RISK_TOPLAM, 
			BORC, 
			ALACAK, 
			DEVIR_BORC, 
			DEVIR_ALACAK 
		FROM 
			HEDEF.HEDEF_MUSTERI_DURUM 
		WHERE 
			HEDEFKODU = #attributes.cpid# AND
			(<cfloop from="1" to="#get_company_branch_related.recordcount#" index="loop_i">
				(
					AKTARIM_TARIH = (SELECT MAX(AKTARIM_TARIH) AKTARIM_TARIH FROM HEDEF.HEDEF_MUSTERI_DURUM WHERE HEDEFKODU = #attributes.cpid# AND DEPO_KODU = #get_company_branch_related.boyut_kodu[loop_i]#) AND
					DEPO_KODU = #get_company_branch_related.boyut_kodu[loop_i]#
				) <cfif loop_i neq get_company_branch_related.recordcount> OR</cfif>
			</cfloop>
			)			
		ORDER BY 
			AKTARIM_TARIH DESC
	</cfquery>	
	<cfcatch>
	</cfcatch>
</cftry>
<cfset color_list = 'FFFFCC,CCFFCC,FFFFCC,FF0000,99CC99,FF0000,FFCC99,FF0000,FF0000,FF0000,99FFFF,FF0000'>
<cf_box>
    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
	<cf_seperator title="#getLang('','',51552)#" id="ozet_bilgiler_">
        <cf_flat_list id="ozet_bilgiler_">
            <cfoutput>
            <tr>
                <td width="60" class="txtbold"><cf_get_lang_main no='338.İşyeri Adı'> </td>
                <td width="180">: #get_company.fullname#</td>
                <td width="70" class="txtbold"><cf_get_lang_main no='722.Mikro Bolge Kodu'></td>
                <td>: #get_company.ims_code# #get_company.ims_code_name#</td>
            </tr>
            <tr>
                <td class="txtbold"><cf_get_lang_main no='158.Müşteri Ad Soyad'></td>
                <td>: #get_par_info(get_company.partner_id,0,-1,1)#</td>
                <td class="txtbold"></td>
                <td></td>
            </tr>
            <tr>
                <td class="txtbold"><cf_get_lang no='668.Hedef Kodu'></td>
                <td>: #get_company.company_id#</td>
                <td class="txtbold"><cf_get_lang_main no='1323.Mahalle'></td>
                <td>: #get_company.district#</td>
            </tr>
            <tr>
                <td class="txtbold"><cf_get_lang no='35.Müşteri Tipi'></td>
                <td>: #get_company.companycat#</td>
                <td class="txtbold"><cf_get_lang no='45.Cadde'></td>
                <td>: #get_company.main_street#</td>
            </tr>
            <tr>
                <td class="txtbold"><cf_get_lang_main no='1350.Vergi Dairesi'></td>
                <td>: #get_company.taxoffice#</td>
                <td class="txtbold"><cf_get_lang no='46.Sokak'></td>
                <td>: #get_company.street#</td>
            </tr>
            <tr>
                <td class="txtbold"><cf_get_lang_main no='340.Vergi No'></td>
                <td>: #get_company.taxno#</td>
                <td class="txtbold"><cf_get_lang_main no='75.No'></td>
                <td>: #get_company.dukkan_no#</td>
            </tr>
            <tr>
                <td class="txtbold"><cf_get_lang_main no='1173.Kod'> / <cf_get_lang_main no='87.Tel'></td>
                <td>: #get_company.company_telcode# #get_company.company_tel1#</td>
                <td class="txtbold"><cf_get_lang_main no='60.Posta Kodu'></td>
                <td>: #get_company.company_postcode#</td>
            </tr>
            <tr>
                <td class="txtbold"><cf_get_lang_main no='87.Tel'> 2</td>
                <td>: #get_company.company_tel2#</td>
                <td class="txtbold"><cf_get_lang_main no='720.Semt'></td>
                <td>: #get_company.semt#</td>
            </tr>
            <tr>
                <td class="txtbold"><cf_get_lang_main no='87.Tel'> 3</td>
                <td>: #get_company.company_tel3#</td>
                <td class="txtbold"><cf_get_lang_main no='1226.İlçe'></td>
                <td>: #get_company.county_name#</td>
            </tr>
            <tr>
                <td class="txtbold"><cf_get_lang_main no='1173.Kod'> / <cf_get_lang_main no='76.Fax'></td>
                <td>: #get_company.company_fax_code# #get_company.company_fax#</td>
                <td class="txtbold"><cf_get_lang_main no='1196.Şehir'></td>
                <td>: #get_company.city_name#</td>
            </tr>
            <tr>
                <td class="txtbold"><cf_get_lang_main no='16.E-Mail'></td>
                <td>: #get_company.company_email#</td>
                <td class="txtbold"><cf_get_lang_main no='807.Ülke'></td>
                <td>: #get_company.country_name#</td>
            </tr>
            <tr>
                <td class="txtbold"><cf_get_lang_main no='667.Internet'></td>
                <td>: #get_company.homepage#</td>
            </tr>
            </cfoutput>
        </cf_flat_list>
    </div>
    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
 	<cf_seperator title="#getLang('','',51550)#" id="calistigi_depolar_">
    <cf_flat_list id="calistigi_depolar_">
    	<tr>
        	<td>
              <cftry>
					<cfset musteridurum_tr_list = "">
                    <cfset position_code_list = "">
                    <cfoutput query="get_company_branch_related1">
                        <cfif len(musteridurum) and not listfind(musteridurum_tr_list,musteridurum)>
                            <cfset musteridurum_tr_list=listappend(musteridurum_tr_list,musteridurum)>
                        </cfif>
                        <cfif len(sales_director) and not listfind(position_code_list,sales_director)>
                            <cfset position_code_list=listappend(position_code_list,sales_director)>
                        </cfif>
                        <cfif len(plasiyer_id) and not listfind(position_code_list,plasiyer_id)>
                            <cfset position_code_list=listappend(position_code_list,plasiyer_id)>
                        </cfif>
                        <cfif len(tel_sale_preid) and not listfind(position_code_list,tel_sale_preid)>
                            <cfset position_code_list=listappend(position_code_list,tel_sale_preid)>
                        </cfif>
                    </cfoutput>
                    <cfif len(musteridurum_tr_list)>
                        <cfquery name="get_status" datasource="#dsn#">
                            SELECT TR_ID,TR_NAME FROM SETUP_MEMBERSHIP_STAGES WHERE TR_ID IN (#musteridurum_tr_list#) ORDER BY TR_ID
                        </cfquery>
                        <cfset musteridurum_tr_list = listsort(listdeleteduplicates(valuelist(get_status.tr_id,',')),'numeric','ASC',',')>
                    </cfif>
                    <cfif len(position_code_list)>
                        <cfset position_code_list=listsort(position_code_list,"numeric","ASC",",")>		
                        <cfquery name="get_positions" datasource="#dsn#">
                            SELECT EMPLOYEE_ID,POSITION_CODE,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE IN (#position_code_list#) AND IS_MASTER = 1 ORDER BY POSITION_CODE
                        </cfquery>
                        <cfset position_code_list = listsort(listdeleteduplicates(valuelist(get_positions.position_code,',')),'numeric','ASC',',')>
                    </cfif>
                   <table>
                    <cfoutput query="get_company_branch_related1">
                        <tr>
                            <td class="txtbold" colspan="2" bgcolor="#listgetat(color_list,comp_id,',')#"><cf_get_lang_main no='41.Şube'> : #get_company_branch_related1.nick_name# / #get_company_branch_related1.branch_name#</td>
                        </tr>
                        <tr>
                            <td>
                            <table>
                                <tr>
                                    <td class="txtbold"><cf_get_lang_main no='482.Statü'></td>
                                    <td>: #get_status.tr_name[listfind(musteridurum_tr_list,musteridurum,',')]#</td>
                                </tr>
                                <tr>
                                    <td class="txtbold"><cf_get_lang no='102.Bolge Satis Muduru'></td>
                                    <td>:<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_positions.employee_id[listfind(position_code_list,sales_director,',')]#','medium','popup_emp_det');">
                                        #get_positions.employee_name[listfind(position_code_list,sales_director,',')]# #get_positions.employee_surname[listfind(position_code_list,sales_director,',')]#</a>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="txtbold"><cf_get_lang no='101.Plasiyer'></td>
                                    <td>
                                        :<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_positions.employee_id[listfind(position_code_list,plasiyer_id,',')]#','medium','popup_emp_det');">
                                        #get_positions.employee_name[listfind(position_code_list,plasiyer_id,',')]# #get_positions.employee_surname[listfind(position_code_list,plasiyer_id,',')]#</a>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="txtbold"><cf_get_lang no='657.Tel Satış Gör'></td>
                                    <td>
                                        :<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_positions.employee_id[listfind(position_code_list,tel_sale_preid,',')]#','medium','popup_emp_det');">
                                        #get_positions.employee_name[listfind(position_code_list,tel_sale_preid,',')]# #get_positions.employee_surname[listfind(position_code_list,tel_sale_preid,',')]#</a>	
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2"><hr></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    </cfoutput>
                   </table>
                   <table width="100%" border="0">
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
                    </cfscript>
                    <cfoutput query="get_company_branch_related">
                      <cfquery name="GET_RELATED" dbtype="query">
                        SELECT * FROM GET_FINANCE_INFO WHERE DEPO_KODU = '#boyut_kodu#'
                      </cfquery>
                      <!--- BK ekledi genel risk tutari icin--->		
                      <cfquery name="get_credit" datasource="#dsn#">
                        SELECT TOTAL_RISK_LIMIT, MONEY FROM COMPANY_CREDIT WHERE BRANCH_ID = #get_company_branch_related.related_id#
                      </cfquery>
                      <cfscript>
                        toplam1 = 0;
                        toplam2 = 0;
                        toplam3 = 0;
                        toplam4 = 0;
                        toplam5 = 0;
                        toplam6 = 0;
                        
                        if(len(get_related.karsiliksiz_cek_adet))
                            toplam1 = toplam1 + get_related.karsiliksiz_cek_adet;
                        if(len(get_related.karsiliksiz_senet_adet))
                            toplam1 = toplam1 + get_related.karsiliksiz_senet_adet;
                        if(len(get_related.karsiliksiz_senet_adet))
                            toplam1 = toplam1 + get_related.karsiliksiz_pos_adet;
                        if(len(get_related.karsiliksiz_senet_adet))
                            toplam1 = toplam1 + get_related.karsiliksiz_kk_adet;
                        
                        if(len(get_related.karsiliksiz_cek_tutar))
                            toplam2 = toplam2 + get_related.karsiliksiz_cek_tutar;
                        if(len(get_related.karsiliksiz_senet_tutar))
                            toplam2 = toplam2 + get_related.karsiliksiz_senet_tutar;
                        if(len(get_related.karsiliksiz_senet_tutar))
                            toplam2 = toplam2 + get_related.karsiliksiz_pos_tutar;
                        if(len(get_related.karsiliksiz_senet_tutar))
                            toplam2 = toplam2 + get_related.karsiliksiz_kk_tutar;
                        
                        if(len(get_related.vadeli_cek_adet))
                            toplam3 = toplam3 + get_related.vadeli_cek_adet;
                        if(len(get_related.vadeli_senet_adet))
                            toplam3 = toplam3 + get_related.vadeli_senet_adet;
                        if(len(get_related.vadeli_senet_adet))
                            toplam3 = toplam3 + get_related.vadeli_pos_adet;
                        if(len(get_related.vadeli_senet_adet))
                            toplam3 = toplam3 + get_related.vadeli_kk_adet;
                        
                        if(len(get_related.vadeli_cek_tutar))
                            toplam4 = toplam4 + get_related.vadeli_cek_tutar;
                        if(len(get_related.vadeli_senet_tutar))
                            toplam4 = toplam4 + get_related.vadeli_senet_tutar;
                        if(len(get_related.vadeli_senet_tutar))
                            toplam4 = toplam4 + get_related.vadeli_pos_tutar;
                        if(len(get_related.vadeli_senet_tutar))
                            toplam4 = toplam4 + get_related.vadeli_kk_tutar;
                    
                        if(len(get_related.risk_toplam))
                            toplam5 = get_related.risk_toplam;
                        
                        if(len(get_credit.total_risk_limit))
                            toplam6 = get_credit.total_risk_limit;
                            //toplam6 = get_related.risk_limit;
                            
                        if(len(get_related.acik_hesap_bakiye))
                            value1 = value1 + get_related.acik_hesap_bakiye;
                        value2 = value2 + toplam1;
                        value3 = value3 + toplam2;
                        value4 = value4 + toplam3;
                        value5 = value5 + toplam4;
                        value6 = value6 + toplam5;
                        value7 = value7 + toplam6;
                        value8 = value8 + toplam6 - toplam5;
                        if(len(get_related.borc))
                            value9 = value9 + get_related.borc;
                        if(len(get_related.devir_borc))
                            value9 = value9 - get_related.devir_borc ;
                    </cfscript>
                      <tr>
                        <td colspan="2" class="txtbold" height="20"><cf_get_lang no='132.Finansal Özet'> (<cf_get_lang no="677.Aktarım Tarihi"> : #dateformat(get_related.aktarim_tarih,dateformat_style)#)</td>
                      </tr>
                      <tr>
                        <td class="txtbold"><cf_get_lang_main no='41.Şube'></td>
                        <td>: #get_company_branch_related.nick_name# / <br/>&nbsp;&nbsp;#get_company_branch_related.branch_name#</td>
                      </tr>
                        <cfset deger_value_ciro = 0>
                        <cfif len(get_related.borc)>
                            <cfset deger_value_ciro = deger_value_ciro + get_related.borc>
                        </cfif>
                        <cfif len(get_related.devir_borc)>
                            <cfset deger_value_ciro = deger_value_ciro - get_related.devir_borc>
                        </cfif>
                      <tr>
                        <td width="140" class="txtbold"><cf_get_lang no='475.Açık Hesap'></td>
                        <td>: <cfif len(get_related.acik_hesap_bakiye)>#tlformat(get_related.acik_hesap_bakiye)#<cfelse>#tlformat(0)#</cfif> #session.ep.money#</td>
                      </tr>
                      <tr>
                        <td class="txtbold"><cf_get_lang no='564.Vadesi Geçmiş Evrak Adedi'></td>
                        <td>: #tlformat(toplam1,0)# <cf_get_lang_main no='670.Adet'></td>
                      </tr>
                      <tr>
                        <td class="txtbold"><cf_get_lang no='565.Vadesi Geçmiş Evrak Tutarı'></td>
                        <td>: #tlformat(toplam2)# #session.ep.money#</td>
                      </tr>
                      <tr>
                        <td class="txtbold"><cf_get_lang no='566.Vadesi Gel Evrak Adet'></td>
                        <td>: #tlformat(toplam3,0)# <cf_get_lang_main no='670.Adet'></td>
                      </tr>
                      <tr>
                        <td class="txtbold"><cf_get_lang no='567.Vadesi Gel Evrak Tutar'></td>
                        <td>: #tlformat(toplam4)# #session.ep.money#</td>
                      </tr>
                      <tr>
                        <td class="txtbold"><cf_get_lang_main no='460.Toplam Risk'></td>
                        <td>: #tlformat(toplam5)# #session.ep.money#</td>
                      </tr>
                      <tr>
                        <td class="txtbold"><cf_get_lang no='135. Risk Limiti'></td>
                        <td>: #tlformat(toplam6)# #session.ep.money#</td>
                      </tr>
                      <tr>
                        <td class="txtbold"><cf_get_lang no='134.Serbesti'></td>
                        <td>: <cfif toplam6-toplam5 eq 0>#tlformat(0)#<cfelse>#tlformat(toplam6-toplam5)#</cfif> #session.ep.money#</td>
                      </tr>
                      <tr>
                        <td colspan="2"><hr></td>
                      </tr>
                    </cfoutput> 
                    <cfif ((get_company_branch_related.recordcount gt 1) and (get_branch_val.recordcount gt 1) or (get_company_branch_related.recordcount eq 1) and (get_branch_val.recordcount gte 1))>
                        <cfoutput>
                          <tr>
                            <td colspan="2" class="txtbold" height="20"><cf_get_lang no='315.Grup Toplam'></td>
                          </tr>
                          <tr>
                            <td width="140" class="txtbold"><cf_get_lang no='475.Açık Hesap'></td>
                            <td>: #tlformat(value1)# #session.ep.money#</td>
                          </tr>
                          <tr>
                            <td class="txtbold"><cf_get_lang no='564.Vadesi Geçmiş Evrak Adedi'></td>
                            <td>: #tlformat(value2,0)# <cf_get_lang_main no="670.Adet"></td>
                          </tr>
                          <tr>
                            <td class="txtbold"><cf_get_lang no='565.Vadesi Geçmiş Evrak Tutarı'></td>
                            <td>: #tlformat(value3)# #session.ep.money#</td>
                          </tr>
                          <tr>
                            <td class="txtbold"><cf_get_lang no='566.Vadesi Gel Evrak Adet'></td>
                            <td>: #tlformat(value4,0)# <cf_get_lang_main no="670.Adet"></td>
                          </tr>
                          <tr>
                            <td class="txtbold"><cf_get_lang no='567.Vadesi Gel Evrak Tutar'></td>
                            <td>: #tlformat(value5)# #session.ep.money#</td>
                          </tr>
                          <tr>
                            <td class="txtbold"><cf_get_lang_main no='460.Toplam Risk'></td>
                            <td>: #tlformat(value6)# #session.ep.money#</td>
                          </tr>
                          <tr>
                            <td class="txtbold"><cf_get_lang no='135. Risk Limiti'></td>
                            <td>: #tlformat(value7)# #session.ep.money#</td>
                          </tr>
                          <tr>
                            <td class="txtbold"><cf_get_lang no='134.Serbesti'></td>
                            <td>: #tlformat(value8)# #session.ep.money#</td>
                          </tr>
                          <tr>
                            <td colspan="2"><hr></td>
                          </tr>
                        </cfoutput>
                    </cfif>
                   </table>
                <cfcatch>
                </cfcatch>
            </cftry>
          	</td>
         </tr>
    </cf_flat_list>
    </div>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
 	<cf_seperator title="#getLang('','',51607)#" id="yardimci_personel_bilgileri_">
	<cf_grid_list id="yardimci_personel_bilgileri_">
    	<thead>
        <tr>
            <th width="200" class="txtbold"><cf_get_lang_main no='158.Ad Soyad'></th>
            <th class="txtbold"><cf_get_lang_main no='1085.Pozisyon'></th>
            <th width="100" class="txtbold"><cf_get_lang_main no='731.İletişim'></th>
        </tr>
        </thead>
        <tbody>
        <cfif len(get_company_partner.recordcount)>
            <cfset partner_name_list = "">
            <cfoutput query="get_company_partner">
                <cfif len(partner_id) and not listfind(partner_name_list,partner_id)>
                    <cfset partner_name_list=listappend(partner_name_list,partner_id)>
                </cfif>
            </cfoutput>
            <cfif len(partner_name_list)>
                <cfquery name="list_partner_name" datasource="#dsn#">
                    SELECT 
                        PARTNER_ID,
                        <cfif (database_type is 'MSSQL')>
                            COMPANY_PARTNER_NAME + ' ' + COMPANY_PARTNER_SURNAME PARTNER_NAME
                        <cfelseif (database_type is 'DB2')>
                            COMPANY_PARTNER_NAME || ' ' || COMPANY_PARTNER_SURNAME PARTNER_NAME
                        </cfif>
                    FROM
                        COMPANY_PARTNER
                    WHERE
                        PARTNER_ID IN (#partner_name_list#)
                    ORDER BY
                        PARTNER_ID
                </cfquery>
                <cfset partner_name_list = listsort(listdeleteduplicates(valuelist(list_partner_name.partner_id,',')),'numeric','ASC',',')>
            </cfif>
        </cfif>
        <cfif get_company_partner.recordcount gt 0>
            <cfoutput query="get_company_partner">
                <tr>
                    <td><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#list_partner_name.partner_id[listfind(partner_name_list,partner_id,',')]#','medium','popup_par_det');">#list_partner_name.partner_name[listfind(partner_name_list,partner_id,',')]#</a></td>
                    <td>#partner_position#</td>
                    <td width="70"><cfif len(mail)><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_send_mail&special_mail=#mail#','list')"><img src="/images/mail.gif" alt="<cf_get_lang_main no='63.Mail Gönder'>" title="<cf_get_lang_main no='63.Mail Gönder'>" border="0"></a></cfif><cfif len(mobiltel)>&nbsp;<img src="/images/fax.gif" title="Fax:#mobil_code# - #mobiltel#" border="0"></cfif></td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
            </tr>
        </cfif>

        </tbody>
    </cf_grid_list>
    </div>
</cf_box>

