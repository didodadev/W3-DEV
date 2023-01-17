<cfset not_Field = "page,maxrows,totalrecords">
<cfloop list="#ListSort(ListDeleteDuplicates(fieldnames),'text','asc',',')#" index="fn">
	<cfif not ListContainsNoCase(not_Field,fn)>
		<cfparam name="attributes.#fn#" default="">
	</cfif>
</cfloop>
<cfinclude template="get_detail_search_result.cfm">
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#search_results.recordcount#'>
<cfparam name="attributes.is_excel" default="">
<cfif attributes.maxrows gt 20><cfset attributes.maxrows = 20></cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfoutput>
            <cfform action="" method="post" name="search">
                <cf_box_search>
                <cfloop list="#ListSort(ListDeleteDuplicates(fieldnames),'text','asc',',')#" index="i">
                    <cfif not ListContainsNoCase(not_Field,i)>
                    <input type="hidden" name="#i#" id="#i#" value="#evaluate(i)#">
                    </cfif>
                </cfloop>
                <div class="form-group ">
                    <label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>
                </div>
                <div class="form-group small">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group">
                    <cfsavecontent variable="message"><cf_get_lang_main no ='499.Çalıştır'></cfsavecontent>
						<cf_wrk_search_button button_type="4"  search_function="satir_kontrol()"  >
                </div>
                <div class="form-group">
                    <a class="ui-btn ui-btn-gray" href="javascript://" onClick="record_control_event();"><i class="fa fa-clock-o" title="<cf_get_lang dictionary_id='32364.Ziyaret'>"></i></a>
                </div>
                <div class="form-group">
                    <a class="ui-btn ui-btn-gray" href="javascript://" onClick="record_control_activity();"><i class="fa fa-users" title="<cf_get_lang dictionary_id='29465.Etkinlik'>"></i></a>
                </div>
                <cfif get_module_user(15)>
                    <div class="form-group">
                        <a class="ui-btn ui-btn-gray" href="javascript://" onClick="record_control_target();"><i class="fa fa-hand-o-left" title="#getLang('','hedef kitle','51479')#"></i></a>
                    </div>
                </cfif>
                </cf_box_search>
            </cfform>
        </cfoutput>
       
    </cf_box>
    <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
        <cfset filename = "#createuuid()#">
        <cfheader name="Expires" value="#Now()#">
        <cfcontent type="application/vnd.msexcel;charset=utf-16">
        <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-16">
    </cfif>
    <cfsavecontent variable="title_">
        <cfif isdefined('attributes.is_excel') and attributes.is_excel neq 1>
            <cf_get_lang dictionary_id='52115.Hedef Kodu'> <cfif isdefined("search_results.recordcount")><cfoutput> [<cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='59085.Sonuç'> : #search_results.recordcount#]</cfoutput></cfif>
        </cfif>
    </cfsavecontent>
    <cf_box  title="#title_#" uidrop="1" hide_table_column="1" >
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="30px"><cf_get_lang dictionary_id='57487.No'></th>
                    <th><cf_get_lang dictionary_id='52115.Hedef Kodu'></th>
                    <th><cf_get_lang dictionary_id='57457.Müşteri'></th>
                    <th><cf_get_lang dictionary_id='44592.İsim'><cf_get_lang dictionary_id='44593.Soyisim'></th>
                    <cfif isdefined("attributes.TAXNUM_NAME_VIEW")><th><cf_get_lang dictionary_id='56085.Vergi Numarası'></th></cfif>
                    <cfif isdefined("attributes.TAXOFFICE_NAME_VIEW")><th><cf_get_lang dictionary_id='58762.Vergi Dairesi'></th></cfif>
                    <cfif isdefined("attributes.TELEPHONE_NAME_VIEW")><th><cf_get_lang dictionary_id='57220.Telefon Numarası'></th></cfif>
                    <cfif isdefined("attributes.EMAIL_NAME_VIEW")><th><cf_get_lang dictionary_id='39210.Email'></th></cfif>
                    <cfif isdefined("attributes.COMPANYCAT_VIEW")><th><cf_get_lang dictionary_id='57292.Müşteri Tipi'></th></cfif>
                    <cfif isdefined("attributes.IMS_CODE_VIEW")><th><cf_get_lang dictionary_id='58134.Mikro Bolge Kodu'></th></cfif>
                    <cfif isdefined("attributes.CITY_NAME_VIEW")><th><cf_get_lang dictionary_id='58608.İl'></th></cfif>
                    <cfif isdefined("attributes.COUNTY_NAME_VIEW")><th><cf_get_lang dictionary_id='58638.İlçe'></th></cfif>
                    <cfif isdefined("attributes.COMPANY_ADDRESS_VIEW")><th><cf_get_lang dictionary_id='58735.Mahalle'></th></cfif>
                    <cfif isdefined("attributes.SEMT_VIEW")><th><cf_get_lang dictionary_id='58132.Semt'></th></cfif>
                    <cfif isdefined("attributes.CADDE_VIEW")><th><cf_get_lang dictionary_id='59266.Cadde'></th></cfif>
                    <cfif isdefined("attributes.SOKAK_VIEW")><th><cf_get_lang dictionary_id='59267.Sokak'></th></cfif>
                    <cfif isdefined("attributes.NO_VIEW")><th><cf_get_lang dictionary_id='57487.No'></th></cfif>		  
                    <cfif isdefined("attributes.PLASIYER_ID_VIEW")><th><cf_get_lang dictionary_id='51548.Saha Satış Görevlisi'></th></cfif>
                    <cfif isdefined("attributes.BSM_ID_VIEW")><th><cf_get_lang dictionary_id="51549.Bölge Satış Müdürü"></th></cfif>
                    <cfif isdefined("attributes.TELEFON_ID_VIEW")><th><cf_get_lang dictionary_id="51877.Telefonla Satış Görevlisi"></th></cfif>
                    <cfif isdefined("attributes.TAHSILAT_ID_VIEW")><th><cf_get_lang dictionary_id="51652.Tahsilat Görevlisi"></th></cfif>
                    <cfif isdefined("attributes.ITRIYAT_ID_VIEW")><th><cf_get_lang dictionary_id="52045.Itriyat Görevlisi"></th></cfif>
                    <cfif isdefined("attributes.BOLGE_KODU_VIEW")><th><cf_get_lang dictionary_id="51897.Bölge Kodu"></th></cfif>
                    <cfif isdefined("attributes.RISK_LIMIT_VIEW")><th  style="text-align:right;"><cf_get_lang dictionary_id="49667.Risk Limiti"></th></cfif>
                    <cfif isdefined("attributes.ODEME_SEKLI_VIEW")><th><cf_get_lang dictionary_id="30057.Ödeme Şekli"></th></cfif>
                    <cfif isdefined("attributes.CEP_SIRA_VIEW")><th><cf_get_lang dictionary_id="52046.Cep Sıra"></th></cfif>
                    <cfif isdefined("attributes.TR_STATUS_VIEW")><th><cf_get_lang dictionary_id="52047.Müşteri Durum"></th></cfif>
                    <cfif isdefined("attributes.NICK_NAME_VIEW")><th><cf_get_lang dictionary_id='57453.Şube'></th></cfif>
                    <cfif isdefined("attributes.PARTNER_RELATION_VIEW")><th><cf_get_lang dictionary_id='52200.Şube İle İlişkisi'></th></cfif>
                    <cfif isdefined("attributes.RESOURCE_VIEW")><th><cf_get_lang dictionary_id='52201.İlişki Başlangıcı'></th></cfif>
                    <cfif isdefined("attributes.CARIHESAPKOD_VIEW")><th><cf_get_lang dictionary_id="51673.Cari Hesap Kodu"></th></cfif>
                    <cfif isdefined("attributes.ISCUSTOMERCONTRACT_VIEW")><th><cf_get_lang dictionary_id="51451.Anlaşma Müşteri Statü"></th></cfif>
                    <cfif isdefined("attributes.IS_TYPE_VIEW")><th><cf_get_lang dictionary_id='58497.Pozisyon'></th></cfif>
                    <cfif isdefined("attributes.ASSISTANCE_STATUS_VIEW")><th><cf_get_lang dictionary_id='58497.Pozisyon'></th></cfif>
                    <cfif isdefined("attributes.BIRTHPLACE_VIEW")><th><cf_get_lang dictionary_id='57790.Doğum Yeri'></th></cfif>
                    <cfif isdefined("attributes.BIRTHDATE_VIEW")><th><cf_get_lang dictionary_id='58727.Doğum Tarihi'></th></cfif>
                    <cfif isdefined("attributes.MARRIED_DATE_VIEW")><th><cf_get_lang dictionary_id='51522.Evlenme Tarihi'></th></cfif>
                    <cfif isdefined("attributes.MARITAL_STATUS_NAME_VIEW")><th><cf_get_lang dictionary_id='56525.Medeni Hali'></th></cfif>
                    <cfif isdefined("attributes.UNIVERSITY_NAME_VIEW")><th><cf_get_lang dictionary_id='46569.Mezun Olduğu Okul'></th></cfif>
                    <cfif isdefined("attributes.GRADUATE_YEAR_VIEW")><th><cf_get_lang dictionary_id='46569.Mezuniyet yılı'></th></cfif>
                    <cfif isdefined("attributes.SEX_NAME_VIEW")><th><cf_get_lang dictionary_id='57764.Cinsiyet'></th></cfif>
                    <cfif isdefined("attributes.HOBBY_NAME_VIEW")><th><cf_get_lang dictionary_id='56599.Hobiler'></th></cfif>
                    <cfif isdefined("attributes.MOBIL_CODE_VIEW")><th><cf_get_lang dictionary_id='51710.Cep Tel Kodu'></th></cfif>
                    <cfif isdefined("attributes.TC_IDENTITY_VIEW")><th><cf_get_lang dictionary_id="58025.TC Kimlik No"></th></cfif>
                    <cfif isdefined("attributes.SOCIETY_VIEW")><th><cf_get_lang dictionary_id='42846.Sosyal Güvenlik Kurumları'></th></cfif>
                    <cfif isdefined("attributes.GENEL_KONUM_VIEW")><th><cf_get_lang dictionary_id='51567.Müşterinin Genel Konumu'></th></cfif>
                    <cfif isdefined("attributes.SECTOR_CAT_VIEW")><th><cf_get_lang dictionary_id='51594.Uğraştığı Diğer İşler'></th></cfif>
                    <cfif isdefined("attributes.NOBET_DURUMU_VIEW")><th><cf_get_lang dictionary_id='51570.Müşteri Nöbet Durumu'></th></cfif>
                    <cfif isdefined("attributes.BURO_YAZILIMLARI_VIEW")><th><cf_get_lang dictionary_id='51595.Büro Yazılımları'></th></cfif>		
                    <cfif isdefined("attributes.SETUP_STOCK_AMOUNT_VIEW")><th><cf_get_lang dictionary_id='42040.Stok ve Raf Durumu'></th></cfif>		
                    <cfif isdefined("attributes.CONNECTION_NAME_VIEW")><th><cf_get_lang dictionary_id='51569.İnternet Bağlantısı'></th></cfif>		
                    <cfif isdefined("attributes.PC_NUMBER_VIEW")><th><cf_get_lang dictionary_id='51597.Bilgisayar Sayısı'></th></cfif>
                    <cfif isdefined("attributes.CONCERN_NAME_VIEW")><th><cf_get_lang dictionary_id='51568.IT Teknolojilerine Yakınlığı'></th></cfif>
                    <cfif isdefined("attributes.ISSMS_VIEW")><th><cf_get_lang dictionary_id='51571.SMS İstiyor mu'>?</th></cfif>
                    <cfif isdefined("attributes.RIVAL_NAME_VIEW")><th><cf_get_lang dictionary_id='51709.Rakip Depolar'></th></cfif>
                    <cfif isdefined("attributes.SUNULAN_OPSIYON_VIEW")><th><cf_get_lang dictionary_id='51724.Tercih Nedeni'></th></cfif>
                    <cfif isdefined("attributes.YAPILAN_ETKINLIKLER_VIEW")><th><cf_get_lang dictionary_id='51723.Yapılan Etkinlikler'></th></cfif>
                    <cfif isdefined("attributes.SERVIS_SAYISI_VIEW")><th><cf_get_lang dictionary_id='51722.Servis Sayısı'></th></cfif>
                    <cfif isdefined("attributes.ILISKI_DUZEYI_VIEW")><th><cf_get_lang dictionary_id='51738.İlişki Düzeyi'></th></cfif>
                    <cfif isdefined("attributes.OZEL_BILGILER_VIEW")><th><cf_get_lang dictionary_id='51737.Özel Bilgiler'></th></cfif>
                </tr>
            </thead>
            <tbody>
                <cfif search_results.recordcount>
                    <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                        <cfset attributes.startrow=1>
                        <cfset attributes.maxrows=search_results.recordcount>
                    </cfif>
                    <cfoutput query="search_results" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                        <cfif isdefined("attributes.NICK_NAME_VIEW") or isdefined("attributes.PARTNER_RELATION_VIEW") or isdefined("attributes.RESOURCE_VIEW") or isdefined("attributes.PLASIYER_ID_VIEW") or isdefined("attributes.BSM_ID_VIEW") or isdefined("attributes.TELEFON_ID_VIEW") or isdefined("attributes.TAHSILAT_ID_VIEW") or isdefined("attributes.ITRIYAT_ID_VIEW")  or isdefined("attributes.BOLGE_KODU_VIEW") or isdefined("attributes.ODEME_SEKLI_VIEW") or isdefined("attributes.CEP_SIRA_VIEW") or isdefined("attributes.TR_STATUS_VIEW") or isdefined("attributes.CARIHESAPKOD_VIEW") or isdefined("attributes.ISCUSTOMERCONTRACT_VIEW")>
                            <cfquery name="GET_MUSTERIDURUM" dbtype="query">
                                SELECT MUSTERIDURUM,PLASIYER_ID,SALES_DIRECTOR,TEL_SALE_PREID,TAHSILATCI,ITRIYAT_GOREVLI,CUSTOMER_CONTRACT_STATUTE FROM GET_NICKNAME WHERE COMPANY_ID = #company_id#
                            </cfquery>	 
                        <cfelse>
                            <cfset get_musteridurum.recordcount = 0>
                        </cfif>
                        <tr>
                            <td valign="top">#currentrow#</td>
                            <td valign="top">#company_id#</td>
                            <td valign="top"><cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>#fullname#<cfelseif companycat_type eq 0><a href="#request.self#?fuseaction=crm.detail_company&cpid=#company_id#" class="tableyazi">#fullname#</a><cfelse><a href="#request.self#?fuseaction=member.form_list_company&event=det&cpid=#company_id#" class="tableyazi">#fullname#</a></cfif></td>
                            <td valign="top"><cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>#company_partner_name# #company_partner_surname#<cfelse><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_par_det&par_id=#partner_id#');" >#company_partner_name# #company_partner_surname#</a></cfif></td>
                            <cfif isdefined("attributes.TAXNUM_NAME_VIEW")><td valign="top">#taxno#</td></cfif>
                            <cfif isdefined("attributes.TAXOFFICE_NAME_VIEW")><td valign="top">#taxoffice#</td></cfif>
                            <cfif isdefined("attributes.TELEPHONE_NAME_VIEW")><td valign="top">#company_telcode# #company_tel1#</td></cfif>
                            <cfif isdefined("attributes.EMAIL_NAME_VIEW")><td valign="top">#company_email#</td></cfif>
                            <cfif isdefined("attributes.COMPANYCAT_VIEW")>
                            <td valign="top">
                                <cfif len(companycat_id)>
                                    <cfquery name="GET_CAT" dbtype="query">
                                        SELECT COMPANYCAT FROM GET_COMPANYCAT WHERE COMPANYCAT_ID = #companycat_id#
                                    </cfquery>
                                    #get_cat.companycat#
                                </cfif>
                            </td>
                            </cfif>
                            <cfif isdefined("attributes.IMS_CODE_VIEW")>
                            <td valign="top">
                                <cfif len(ims_code_id)>
                                    <cfquery name="GET_IMS" dbtype="query">
                                        SELECT IMS_CODE, IMS_CODE_NAME FROM GET_IMS_CODE WHERE IMS_CODE_ID = #ims_code_id#
                                    </cfquery>
                                    #get_ims.ims_code# #get_ims.ims_code_name#
                                </cfif>
                            </td>
                            </cfif>
                            <cfif isdefined("attributes.CITY_NAME_VIEW")>
                            <td valign="top">
                                <cfif len(city_id)>
                                    <cfquery name="CITY" dbtype="query">
                                        SELECT CITY_NAME FROM GET_CITY WHERE CITY_ID = #city_id#
                                    </cfquery>
                                    #city.city_name#
                                </cfif>
                            </td>
                            </cfif>
                            <cfif isdefined("attributes.COUNTY_NAME_VIEW")>
                            <td valign="top">
                                <cfif len(county_id)>
                                    <cfquery name="COUNTY" dbtype="query">
                                        SELECT COUNTY_NAME FROM GET_COUNTY WHERE COUNTY_ID = #county_id#
                                    </cfquery>
                                    #county.county_name#
                                </cfif>
                            </td>
                            </cfif>
                            <cfif isdefined("attributes.COMPANY_ADDRESS_VIEW")><td valign="top">#district#</td></cfif>
                            <cfif isdefined("attributes.SEMT_VIEW")><td valign="top">#semt#</td></cfif>
                            <cfif isdefined("attributes.CADDE_VIEW")><td valign="top">#main_street#</td></cfif>
                            <cfif isdefined("attributes.SOKAK_VIEW")><td valign="top">#street#</td></cfif>
                            <cfif isdefined("attributes.NO_VIEW")><td valign="top">#dukkan_no#</td></cfif>
                            <cfif isdefined("attributes.PLASIYER_ID_VIEW")><td>
                            <cfif get_musteridurum.recordcount>
                            <cfloop from="1" to="#get_musteridurum.recordcount#" index="k">
                                <cfif len(get_musteridurum.plasiyer_id[k])>#get_emp_info(get_musteridurum.plasiyer_id[k],1,0)#</cfif><br/>
                            </cfloop>
                            </cfif>
                            </td>
                            </cfif>
                            <cfif isdefined("attributes.BSM_ID_VIEW")><td>
                                <cfif get_musteridurum.recordcount>
                                    <cfloop from="1" to="#get_musteridurum.recordcount#" index="k">
                                        <cfif len(get_musteridurum.sales_director[k])>#get_emp_info(get_musteridurum.sales_director[k],1,0)#</cfif><br/>
                                    </cfloop>
                                </cfif>		  
                            </td>
                            </cfif>
                            <cfif isdefined("attributes.TELEFON_ID_VIEW")><td>
                                <cfif get_musteridurum.recordcount>
                                    <cfloop from="1" to="#get_musteridurum.recordcount#" index="k">
                                        <cfif len(get_musteridurum.tel_sale_preid[k])>#get_emp_info(get_musteridurum.tel_sale_preid[k],1,0)#</cfif><br/>
                                    </cfloop>
                                </cfif>			  
                            </td>
                            </cfif>
                            <cfif isdefined("attributes.TAHSILAT_ID_VIEW")><td>
                                <cfif get_musteridurum.recordcount>
                                    <cfloop from="1" to="#get_musteridurum.recordcount#" index="k">
                                        <cfif len(get_musteridurum.tahsilatci[k])>#get_emp_info(get_musteridurum.tahsilatci[k],1,0)#</cfif><br/>
                                    </cfloop>
                                </cfif>		  
                            </td>
                            </cfif>
                            <cfif isdefined("attributes.ITRIYAT_ID_VIEW")><td>
                                <cfif get_musteridurum.recordcount>
                                    <cfloop from="1" to="#get_musteridurum.recordcount#" index="k">
                                        <cfif len(get_musteridurum.itriyat_gorevli[k])>#get_emp_info(get_musteridurum.itriyat_gorevli[k],1,0)#</cfif><br/>
                                    </cfloop>
                                </cfif>
                            </td></cfif>
                            <cfif isdefined("attributes.BOLGE_KODU_VIEW")><td>#get_nickname.bolge_kodu#</td></cfif>
                            <cfif isdefined("attributes.RISK_LIMIT_VIEW")>
                            <td  style="text-align:right;">
                                <cfquery name="GET_LIMIT" dbtype="query">
                                    SELECT TOTAL_RISK_LIMIT,MONEY FROM GET_RISK WHERE COMPANY_ID = #company_id# <cfif len(attributes.RISK_LIMIT_MAX)>AND TOTAL_RISK_LIMIT BETWEEN #attributes.RISK_LIMIT_MAX#</cfif><cfif len(attributes.RISK_LIMIT_MIN)> AND  #attributes.RISK_LIMIT_MIN#</cfif>
                                </cfquery>
                                #tlformat(get_limit.total_risk_limit)# #get_limit.money#
                            </td>
                            </cfif>
                            <cfif isdefined("attributes.ODEME_SEKLI_VIEW")><td>#get_nickname.calisma_sekli#</td></cfif>
                            <cfif isdefined("attributes.CEP_SIRA_VIEW")><td>#get_nickname.cep_sira#</td></cfif>
                            <cfif isdefined("attributes.TR_STATUS_VIEW")>
                            <td>
                            <cfif get_musteridurum.recordcount>
                            <cfloop from="1" to="#get_musteridurum.recordcount#" index="k">
                                <cfif len(get_musteridurum.musteridurum[k])>
                                    <cfquery name="GET_STATUS_ROW" dbtype="query">
                                        SELECT TR_NAME FROM GET_STATUS WHERE TR_ID = #get_musteridurum.musteridurum[k]#
                                    </cfquery>
                                    <cfloop query="get_status_row">#get_status_row.tr_name#<br/></cfloop>
                                <cfelse>
                                    <br/>
                                </cfif>
                            </cfloop>
                            </cfif>
                            </td>
                            </cfif>
                            <cfif isdefined("attributes.NICK_NAME_VIEW")>
                            <td valign="top">
                                <cfquery name="BRANCH" dbtype="query">
                                    SELECT BRANCH_NAME FROM GET_NICKNAME WHERE COMPANY_ID = #company_id#
                                </cfquery>
                                <cfloop query="branch">#branch_name#<br/></cfloop>
                            </td>
                            </cfif>
                            <cfif isdefined("attributes.PARTNER_RELATION_VIEW")>
                            <td>
                            <cfif len(get_nickname.relation_status)>
                                <cfquery name="GET_RELATION" datasource="#DSN#">
                                    SELECT PARTNER_RELATION FROM SETUP_PARTNER_RELATION WHERE PARTNER_RELATION_ID = #get_nickname.relation_status#
                                </cfquery>
                                #get_relation.partner_relation#</cfif>
                            </td>
                            </cfif>
                            <cfif isdefined("attributes.RESOURCE_VIEW")><td>
                                <cfif len(get_nickname.relation_start)>
                                    <cfquery name="RELATION_START" datasource="#DSN#">
                                        SELECT RESOURCE FROM COMPANY_PARTNER_RESOURCE WHERE RESOURCE_ID = #get_nickname.relation_start#
                                    </cfquery>
                                    #relation_start.resource#
                                </cfif>
                            </td>
                            </cfif>
                            <cfif isdefined("attributes.CARIHESAPKOD_VIEW")>
                            <td>
                                <cfquery name="BRANCH" dbtype="query">
                                    SELECT CARIHESAPKOD FROM GET_NICKNAME WHERE COMPANY_ID = #company_id#
                                </cfquery>
                                <cfloop query="branch">#carihesapkod#<br/></cfloop>
                            </td>
                            </cfif>
                            <cfif isdefined("attributes.ISCUSTOMERCONTRACT_VIEW")>
                            <td>
                                <cfquery name="BRANCH" dbtype="query">
                                    SELECT CUSTOMER_CONTRACT_STATUTE FROM GET_NICKNAME WHERE COMPANY_ID = #company_id#
                                </cfquery>
                                <cfloop query="branch"><cfif customer_contract_statute eq 1>A<cfelse>A <cf_get_lang dictionary_id='53620.Değil'></cfif><br/></cfloop>
                            </td>
                            </cfif>
                            <cfif isdefined("attributes.IS_TYPE_VIEW")>
                            <td><cfif attributes.is_type eq 1><cf_get_lang dictionary_id='52048.Eczacı'><cfelseif attributes.is_type eq 2><cf_get_lang dictionary_id='52049.Yardımcı'><cfelse><cfif manager_partner_id eq partner_id><cf_get_lang dictionary_id='52048.Eczacı'><cfelse><cf_get_lang dictionary_id='52049.Yardımcı'></cfif></cfif></td>
                            </cfif>
                            <cfif isdefined("attributes.ASSISTANCE_STATUS_VIEW")><td>
                                <cfif len(mission)>
                                    <cfquery name="MISSION" dbtype="query">
                                        SELECT PARTNER_POSITION FROM GET_MISSION WHERE PARTNER_POSITION_ID = #mission#
                                    </cfquery>
                                    #mission.partner_position#
                                </cfif>
                            </td>
                            </cfif>
                            <cfif isdefined("attributes.BIRTHPLACE_VIEW")><td>#birthplace#</td></cfif>
                            <cfif isdefined("attributes.BIRTHDATE_VIEW")><td>#dateformat(birthdate,dateformat_style)#</td></cfif>
                            <cfif isdefined("attributes.MARRIED_DATE_VIEW")><td>#dateformat(married_date,dateformat_style)#</td></cfif>
                            <cfif isdefined("attributes.MARITAL_STATUS_NAME_VIEW")><td><cfif married eq 2><cf_get_lang dictionary_id='55743.Evli'><cfelseif married eq 1><cf_get_lang dictionary_id='55744.Bekar'><cfelseif married eq 3><cf_get_lang dictionary_id='51555.Dul'></cfif></td></cfif>
                            <cfif isdefined("attributes.UNIVERSITY_NAME_VIEW")><td>
                                <cfif len(university_id)>
                                    <cfquery name="UNIVERSTY"  dbtype="query">
                                        SELECT UNIVERSITY_NAME FROM GET_UNIVERSTY WHERE UNIVERSITY_ID = #university_id#
                                    </cfquery>
                                #universty.university_name#</cfif>
                            </td>
                            </cfif>
                            <cfif isdefined("attributes.GRADUATE_YEAR_VIEW")><td>#graduate_year#</td></cfif>
                            <cfif isdefined("attributes.SEX_NAME_VIEW")><td><cfif sex eq 1><cf_get_lang dictionary_id='58959.Erkek'><cfelseif sex eq 2><cf_get_lang dictionary_id='58958.Kadın'><cfelse><cf_get_lang dictionary_id='51453.İşlenmedi'></cfif></td></cfif>
                            <cfif isdefined("attributes.HOBBY_NAME_VIEW")><td>
                                <cfquery name="HOBBY" dbtype="query">
                                    SELECT HOBBY_NAME FROM GET_HOBBY WHERE PARTNER_ID = #partner_id#
                                </cfquery>
                                <cfloop query="hobby">#hobby.hobby_name#<br/></cfloop>
                            </td>
                            </cfif>
                            <cfif isdefined("attributes.MOBIL_CODE_VIEW")><td>#mobil_code# #mobiltel#</td></cfif>
                            <cfif isdefined("attributes.TC_IDENTITY_VIEW")><td>#tc_identity#</td></cfif>
                            <cfif isdefined("attributes.SOCIETY_VIEW")><td>
                                <cfquery name="society_value" dbtype="query">
                                SELECT SOCIETY FROM GET_SOCIETY WHERE COMPANY_ID = #company_id#
                                </cfquery>
                                <cfloop query="society_value">#society_value.society#<br/></cfloop>
                            </td>
                            </cfif>
                            <cfif isdefined("attributes.GENEL_KONUM_VIEW")><td>
                                <cfif len(attributes.GENEL_KONUM)>
                                <cfquery name="POSITION" dbtype="query">
                                    SELECT POSITION_NAME FROM GET_POSITION WHERE COMPANY_ID = #company_id#
                                </cfquery><cfloop query="position">#position.position_name#<br/></cfloop>
                            </cfif>
                            </td>
                            </cfif>
                            <cfif isdefined("attributes.SECTOR_CAT_VIEW")><td>
                                <cfif len(attributes.SECTOR_CAT)>
                                    <cfquery name="SECTOR" dbtype="query">
                                        SELECT SECTOR_CAT FROM GET_SECTORCAT WHERE COMPANY_ID = #company_id#
                                    </cfquery>
                                    <cfloop query="sector">#sector_cat#<br/></cfloop>
                                </cfif>
                            </td>
                            </cfif>
                            <cfif isdefined("attributes.NOBET_DURUMU_VIEW")><td>
                                <cfif len(duty_period)>
                                    <cfquery name="NOBET" dbtype="query">
                                        SELECT PERIOD_NAME FROM GET_NOBET WHERE PERIOD_ID = #duty_period#
                                    </cfquery>
                                    #nobet.period_name#
                                </cfif>
                            </td>
                            </cfif>
                            <cfif isdefined("attributes.BURO_YAZILIMLARI_VIEW")><td>
                                <cfquery name="SOFTWARE" dbtype="query">
                                    SELECT STUFF_NAME FROM GET_STUFF WHERE COMPANY_ID = #company_id#
                                </cfquery>
                                <cfloop query="software">#stuff_name#<br/></cfloop>
                            </td>
                            </cfif>
                            <cfif isdefined("attributes.SETUP_STOCK_AMOUNT_VIEW")><td>
                                <cfif len(stock_amount)>
                                    <cfquery name="GET_STOCKS" datasource="#DSN#">
                                        SELECT STOCK_ID, STOCK_NAME FROM SETUP_STOCK_AMOUNT WHERE STOCK_ID = #stock_amount#
                                    </cfquery>
                                    #get_stocks.stock_name#
                                </cfif>
                            </td>
                            </cfif>		
                            <cfif isdefined("attributes.CONNECTION_NAME_VIEW")><td>
                                <cfquery name="CONNECTION" dbtype="query">
                                    SELECT CONNECTION_NAME FROM GET_NET_CONNECTION WHERE COMPANY_ID = #company_id#
                                </cfquery>
                                #connection.connection_name#
                            </td>
                            </cfif>		
                            <cfif isdefined("attributes.PC_NUMBER_VIEW")><td>
                                <cfquery name="PCNUMBER" dbtype="query">
                                    SELECT UNIT_NAME FROM GET_PC_NUMBER WHERE COMPANY_ID = #company_id#
                                </cfquery>
                                #pcnumber.unit_name#
                            </td>
                            </cfif>
                            <cfif isdefined("attributes.CONCERN_NAME_VIEW")><td>
                                <cfquery name="CONCERN" dbtype="query">
                                    SELECT CONCERN_NAME FROM GET_CONCERN WHERE COMPANY_ID = #company_id#
                                </cfquery>
                                #concern.concern_name#
                            </td>
                            </cfif>
                            <cfif isdefined("attributes.ISSMS_VIEW")><td><cfif (is_sms eq 1)><cf_get_lang_main no="83.Evet"><cfelse><cf_get_lang_main no="84.Hayır"></cfif></td></cfif>
                            <cfif isdefined("attributes.RIVAL_NAME_VIEW")><td>
                                <cfquery name="RIVAL" dbtype="query">
                                    SELECT RIVAL_NAME FROM GET_RIVAL WHERE COMPANY_ID = #company_id#
                                </cfquery>
                                <cfloop query="rival">#rival.rival_name#<br/></cfloop>
                            </td>
                            </cfif>
                            <cfif isdefined("attributes.SUNULAN_OPSIYON_VIEW")><td>
                                <cfquery name="APPLY" dbtype="query">
                                    SELECT PREFERENCE_REASON FROM GET_APPLY WHERE COMPANY_ID = #company_id#
                                </cfquery>
                                #apply.preference_reason#
                            </td>
                            </cfif>
                            <cfif isdefined("attributes.YAPILAN_ETKINLIKLER_VIEW")><td>
                                <cfquery name="ETKINLIK" dbtype="query">
                                SELECT ACTIVITY_NAME FROM GET_ETKINLIK WHERE COMPANY_ID = #company_id#
                                </cfquery>
                                <cfloop query="etkinlik">#etkinlik.activity_name#</cfloop>
                            </td>
                            </cfif>
                            <cfif isdefined("attributes.SERVIS_SAYISI_VIEW")><td>
                                <cfquery name="SERVICE" dbtype="query">
                                    SELECT SERVICE_NUMBER FROM GET_RIVAL_DETAIL WHERE COMPANY_ID = #company_id#
                                </cfquery>
                                <cfif service.service_number eq -1>0<cfelse>#service.service_number#</cfif>
                            </td>
                            </cfif>
                            <cfif isdefined("attributes.ILISKI_DUZEYI_VIEW")><td>
                                <cfif len(attributes.ILISKI_DUZEYI)>
                                    <cfquery name="GET_REL" datasource="#DSN#">
                                        SELECT 
                                            PARTNER_RELATION 
                                        FROM 
                                            SETUP_PARTNER_RELATION,
                                            COMPANY_RIVAL_DETAIL
                                        WHERE 
                                            COMPANY_RIVAL_DETAIL.COMPANY_ID = #company_id# AND
                                            PARTNER_RELATION_ID = #attributes.ILISKI_DUZEYI# AND
                                            SETUP_PARTNER_RELATION.PARTNER_RELATION_ID = COMPANY_RIVAL_DETAIL.RELATION_LEVEL
                                    </cfquery>
                                    #get_rel.partner_relation#
                                </cfif>
                            </td>
                            </cfif>
                            <cfif isdefined("attributes.OZEL_BILGILER_VIEW")><td>
                                <cfquery name="SPECIAL" dbtype="query">
                                    SELECT SPECIAL_INFO FROM GET_SPECIAL WHERE COMPANY_ID = #company_id#
                                </cfquery>
                                #special.special_info#
                            </td>
                            </cfif>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <cfoutput>
                    <tr>
                        <td colspan="50"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</td>
                    </tr>
                    </cfoutput>
                </cfif>
            </tbody>
        </cf_grid_list>
   
        <cfset url_str = "">
        <cfloop list="#ListSort(ListDeleteDuplicates(fieldnames),'text','asc',',')#" index="fnu">
            <cfif not ListContainsNoCase(not_Field,fnu)>
                <cfif Evaluate("attributes.#fnu#") neq "NULL" and #fnu# contains "DATE" and #fnu# DOES NOT CONTAIN '_'>
                    <cfset url_str = "#url_str#&#fnu#=#dateformat(Evaluate("attributes.#fnu#"),dateformat_style)#">
                <cfelse>
                    <cfset url_str = "#url_str#&#fnu#=#Evaluate("attributes.#fnu#")#">
                </cfif>​
            </cfif>
        </cfloop>
        <cf_paging page="#attributes.page#"
        maxrows="#attributes.maxrows#"
        totalrecords="#attributes.totalrecords#"
        startrow="#attributes.startrow#"
        adres="#attributes.fuseaction##url_str#">
    </cf_box>
</div>
<script type="text/javascript">
function satir_kontrol()
{
	if(document.search.is_excel.checked==false)
		{
			document.search.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.detail_search_report</cfoutput>";
			return true;
		}
	else 
		document.search.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_detail_search_report</cfoutput>";
        document.search.submit();
}
function record_control_event()
{
	<cfif search_results.recordcount gt 255>
		alert("<cf_get_lang dictionary_id='34083.Kayıt Sayısı Çok Fazla Lütfen Yeni Arama Kriterleri Giriniz'> !");
		return false;
	<cfelse>
		
        window.open('<cfoutput>#request.self#?fuseaction=crm.form_add_visit&is_detail_search=1&is_target=1&target_company_id=#valuelist(search_results.partner_id, ',')#</cfoutput>');
		return true;
	</cfif>
}

function record_control_activity()
{
	<cfif search_results.recordcount gt 255>
		alert("<cf_get_lang dictionary_id='34083.Kayıt Sayısı Çok Fazla Lütfen Yeni Arama Kriterleri Giriniz'>!");
		return false;
	<cfelse>
        window.open('<cfoutput>#request.self#?fuseaction=crm.form_add_activity&is_detail_search=1&is_target=1&target_company_id=#valuelist(search_results.partner_id, ',')#</cfoutput>');
		return true;
	</cfif>
}
function record_control_target()
{
	<cfif search_results.recordcount >
        openBoxDraggable('<cfoutput>#request.self#?fuseaction=crm.popup_add_search_report_campaign&target_company_id=#valuelist(search_results.partner_id, ',')#</cfoutput>');
      
		return true;
	<cfelse>
        alert("<cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!");
		return false;
	</cfif>
}

</script>
