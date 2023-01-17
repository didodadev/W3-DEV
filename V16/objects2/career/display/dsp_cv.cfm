<!--- Özgeçmişim Önizleme --->

<cfif not isdefined("session.cp.userid")>
	<cflocation url="#request.self#?fuseaction=objects2.kariyer_login" addtoken="no">
</cfif>

<cfset get_components = createObject("component", "V16.objects2.career.cfc.data_career")>

<cfset attributes.empapp_id = session.cp.userid>
<cfset empapp_id = session.cp.userid>

<cfset GET_ID_CARD_CATS = get_components.GET_ID_CARD_CATS()>
<cfset GET_COUNTRY = get_components.GET_COUNTRY()>
<cfset GET_CITY = get_components.GET_CITY()>
<cfset GET_APP = get_components.GET_APP( empapp_id: empapp_id)>
<cfset get_app_identy = get_components.get_app_identy( )>
<cfset GET_APP_WORK = get_components.GET_WORK_INFO(empapp_id: empapp_id )>
<cfset GET_EMP_REFERENCE = get_components.GET_EMP_REFERENCE(empapp_id: empapp_id )>
<cfset GET_TEACHER_DETAIL = get_components.GET_TEACHER_INFO(empapp_id: empapp_id )>
<cfset GET_BRANCHES = get_components.GET_BRANCHES(empapp_id: empapp_id )>
<cfset GET_ADD_INFO = get_components.GET_ADD_INFO_WITH_BRANCH(empapp_id: empapp_id )>
<cfset GET_APP_EDU_UNIV = get_components.GET_EDU_INFO(type: "3,4,5,6",empapp_id: empapp_id )>
<cfset GET_APP_EDU_LISE = get_components.GET_EDU_INFO(type: "1",empapp_id: empapp_id )>

<div class="table-responsive">
	<h1><cf_get_lang dictionary_id='34531.CV Önizleme'></h1>
    <table class="table table-borderless">
        <tr>
            <td><cf_workcube_file_action pdf='1' mail='0' doc='0' print='1' tag_module='curriculum_cv'></td>
        </tr>
    </table>
    <div class="curriculum_cv">
        <table class="table table-borderless">
            <tr class="main-bg-color">
                <td class="font-weight-bold"><cfoutput>#get_app.name#</cfoutput> <cfoutput>#get_app.surname#</cfoutput></td>
            </tr>
            <tr>
                <td>
                    <table class="table table-borderless">
                        <tr>
                            <td class="font-weight-bold"><cf_get_lang dictionary_id='30324.Adres Bilgileri'></td><td>: 
                            <cfoutput>#get_app.homeaddress#&nbsp;#get_app.homepostcode#</cfoutput>
							<cfif len(get_app.homecounty)>
                                <cfset GET_COUNTY = get_components.GET_COUNTY(county_id : get_app.homecounty)>
                                <cfoutput>#get_county.county_name#</cfoutput>
                            </cfif>
                            <cfif len(get_app.homecity)>
                                <cfquery name="GET_HOMECITY" dbtype="query">
                                    SELECT CITY_NAME FROM GET_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_app.homecity#">
                                </cfquery>
                                <cfoutput>#get_homecity.city_name#</cfoutput>
                            </cfif>
                            <cfoutput query="get_country">
                                <cfif get_app.homecountry eq get_country.country_id>#get_country.country_name#</cfif>
                            </cfoutput>
                            </td>
                        </tr>
                        <tr>
                            <td class="font-weight-bold"><cf_get_lang dictionary_id='58813.Cep Telefonu'></td><td>: <cfoutput>#trim(get_app.mobilcode)# #trim(get_app.mobil)#</cfoutput></td>
                        </tr>
                         <tr>
                            <td class="font-weight-bold"><cf_get_lang dictionary_id='57428.E-posta'></td><td>: <cfoutput>#get_app.email#</cfoutput></td>
                        </tr>
                    </table>
                </td>
                <td><cfif len(get_app.photo)><div class="curriculum_cv_imaj"><img src="<cfoutput>#file_web_path#hr/#get_app.photo#</cfoutput>" alt="<cf_get_lang dictionary_id='34528.Fotoğraf'>" title="<cf_get_lang dictionary_id='34528.Fotoğraf'>" /></div></cfif></td>
            </tr>
            <tr class="main-bg-color">
                <td class="font-weight-bold"><cf_get_lang dictionary_id='30236.Kişisel Bilgiler'></td>
            </tr>
            <tr>
            	<td>
                    <table class="table table-borderless">
                    	<tr>
                            <td class="font-weight-bold"><cf_get_lang dictionary_id='58727.Doğum Tarihi'></td>
                            <td>: <cfif len(get_app_identy.birth_date)><cfoutput>#dateformat(get_app_identy.birth_date,'dd/mm/yyyy')#</cfoutput></cfif></td>
                            <td class="font-weight-bold"><cf_get_lang dictionary_id='57790.Doğum Yeri'></td><td>: <cfoutput>#get_app_identy.birth_place#</cfoutput></td>
                        </tr>
                        <tr>
                            <td class="font-weight-bold"><cf_get_lang dictionary_id='31230.Sigara Kullanıyor Musunuz?'></td>
                            <td>: <cfif get_app.use_cigarette eq 1><cf_get_lang dictionary_id='57495.Evet'><cfelse><cf_get_lang dictionary_id='57496.Hayır'></cfif></td>
                            <td class="font-weight-bold"><cf_get_lang_main no='352.Cinsiyetiniz'></td><td>: <cfif get_app.sex eq 1 or not len(get_app.sex)><cf_get_lang dictionary_id='58959.Erkek'><cfelseif get_app.sex eq 0><cf_get_lang dictionary_id='58958.Kadın'></cfif></td>
                        </tr>
                        <tr>
                            <td class="font-weight-bold"><cf_get_lang dictionary_id='35140.Fiziksel Engeli Var mı?'></td>
                            <td>: <cfif get_app.defected eq 1><cf_get_lang dictionary_id='57495.Evet'>  %<cfoutput>#get_app.defected_level#</cfoutput><cfelse><cf_get_lang dictionary_id='57496.Hayır'></cfif></td>
                            <td class="font-weight-bold"><cf_get_lang dictionary_id='31227.Ehliyet Tip / Yıl'></td><td>: 
								<cfif len(get_app.licencecat_id)>
                                    <cfset GET_DRIVER_LIS = get_components.GET_DRIVER_LIS(licencecat_id:get_app.licencecat_id)>
                                    <cfoutput>#get_driver_lis.licencecat#</cfoutput>
                                </cfif>
                                <cfoutput>/ #DateFormat(get_app.licence_start_date,'dd/mm/yyyy')#</cfoutput>
                            </td>
                        </tr>
                        <cfif get_app.sex eq 1 or not len(get_app.sex)>
                            <tr>
                                <td class="font-weight-bold"><cf_get_lang dictionary_id='35141.Askerlik Durumu'></td>
                                <td nowrap>: 
                                    <cfif get_app.military_status eq 0>
                                        <cf_get_lang dictionary_id='31210.Yapmadı'>&nbsp;
                                    <cfelseif get_app.military_status eq 1>
                                        <cf_get_lang dictionary_id='34641.Yaptı'>
                                        <cfif get_app.military_rank eq 0 or not len(get_app.military_rank)> - Er<cfelseif get_app.military_rank eq 1> - <cf_get_lang no='824.Yedek Subay'></cfif>
                                        &nbsp;
                                    <cfelseif get_app.military_status eq 2>
                                        <cf_get_lang dictionary_id='31212.Muaf'>
                                    <cfelseif get_app.military_status eq 3>
                                        <cf_get_lang dictionary_id='31213.Yabancı'>
                                    <cfelseif get_app.military_status eq 4>
                                        <cf_get_lang dictionary_id='31214.Tecilli'>
                                    </cfif>
                                </td>
                                <td nowrap="nowrap" class="pl-0">
									<cfif get_app.military_status eq 1>
                                        <table id="Yapti">
                                            <tr>
                                                <td nowrap="nowrap"><span class="font-weight-bold"><cf_get_lang dictionary_id='31217.Terhis Tarihi'></span>
                                                : <cfif len(get_app.military_finishdate)><cfoutput>#dateformat(get_app.military_finishdate,'dd/mm/yyyy')#</cfoutput></cfif><br />
                                                <span class="font-weight-bold"><cf_get_lang dictionary_id='31219.Süresi (Ay Olarak Giriniz)'></span>
                                                : <cfoutput>#get_app.military_month#</cfoutput></td>
                                            </tr>
                                        </table>
                                    </cfif>
                                    <cfif get_app.military_status eq 2>
                                        <table id="Muaf">
                                            <tr>
                                                <td class="font-weight-bold"><cf_get_lang no='327.Muaf Olma Nedeniniz'> *</td>
                                                <td>: <cfoutput>#get_app.military_exempt_detail#</cfoutput></td>
                                            </tr>
                                        </table>
                                    </cfif>
                                    <cfif get_app.military_status eq 4>
                                        <table id="Tecilli">
                                            <tr>
                                                <td class="font-weight-bold"><cf_get_lang no='324.Tecil Gerekçeniz'></td>
                                                <td>: <cfoutput>#get_app.military_delay_reason#</cfoutput></td>
                                            </tr>
                                            <tr>
                                                <td class="font-weight-bold"><cf_get_lang no='325.Tecil Süreniz'></td>
                                                <td>: <cfif len(get_app.military_delay_date)><cfoutput>#dateformat(get_app.military_delay_date,'dd/mm/yyyy')#</cfoutput></cfif></td>
                                            </tr>
                                        </table>
                                    </cfif>	
                            	</td>
                            </tr>
                        </cfif>
                    </table>
                </td>
            </tr>
            <tr class="main-bg-color">
               <td class="font-weight-bold"><cf_get_lang dictionary_id='30644.Eğitim Bilgileri'></td>
            </tr>
            <tr>
            	<td>
                	<cfinclude template="../query/get_edu_level.cfm">
                    <cfinclude template="../query/get_know_levels.cfm">
                    <cfinclude template="../query/get_school.cfm">
                    <cfinclude template="../query/get_school_part.cfm">
                    <cfinclude template="../query/get_high_school_part.cfm">
                    <cfinclude template="../query/get_languages.cfm">
                    <cfinclude template="../query/get_empapp.cfm">
                	<table cellpadding="5" cellspacing="5">
                    	<tr>
                        	<td class="font-weight-bold"><cf_get_lang dictionary_id='35155.Eğitim Seviyesi'> </td>
                            <td>:
                            	<cfoutput query="get_edu_level">
									<cfif edu_level_id eq get_app.training_level>#education_name#</cfif>
                                </cfoutput>
                            </td>
                        </tr>
                        <tr>
                        	<td colspan="2">
                            	<table class="table">
                                	<thead>
                                        <tr>
                                            <th></th>
                                            <th class="font-weight-bold"><cf_get_lang dictionary_id='30645.Okul Adı'></th>
                                            <th class="font-weight-bold"><cf_get_lang dictionary_id='31556.Giriş Yılı'></th>
                                            <th class="font-weight-bold"><cf_get_lang dictionary_id='31050.Mezuniyet Yılı'></th>
                                            <th class="font-weight-bold"><cf_get_lang dictionary_id='31482.Not Ort'>.</th>
                                            <th class="font-weight-bold"><cf_get_lang_main no="583.Bölüm"></th>
                                        </tr>
                                    </thead>
                                    <cfoutput query="get_app_edu_univ">
                                        <tr>
                                            <td class="font-weight-bold">
												<cfif get_app_edu_univ.edu_type eq 4 or get_app_edu_univ.edu_type eq 3>
                                                	<cf_get_lang dictionary_id='29755.Üniversite'>
												<cfelseif get_app_edu_univ.edu_type eq 5>
                                                	<cf_get_lang dictionary_id='30483.Yüksek Lisans'>
												<cfelseif get_app_edu_univ.edu_type eq 6>
                                                    <cf_get_lang dictionary_id='31293.Doktora'>
												</cfif>
                                            </td>
                                            <td>#get_app_edu_univ.edu_name#</td>
                                            <td>#get_app_edu_univ.edu_start#</td>
                                            <td>#get_app_edu_univ.edu_finish#</td>
                                            <td>#get_app_edu_univ.edu_rank#</td>
                                            <td>#get_app_edu_univ.edu_part_name#</td>
                                        </tr>
                                    </cfoutput>
                                    <cfoutput>
                                        <tr>
                                            <td class="font-weight-bold"><cf_get_lang dictionary_id='30480.Lise'></td>
                                            <td>#get_app_edu_lise.edu_name#</td>
                                            <td><cfif len(get_app_edu_lise.edu_start)>#get_app_edu_lise.edu_start#<cfelse>-</cfif></td>
                                            <td><cfif len(get_app_edu_lise.edu_finish)>#get_app_edu_lise.edu_finish#<cfelse>-</cfif></td>
                                            <td>#get_app_edu_lise.edu_rank#</td>
                                            <td>#get_app_edu_lise.edu_part_name#</td>
                                        </tr>
                                    </cfoutput>
                                    <cfset GET_APP_LANG = get_components.GET_APP_LANG()>
                                    <tr>
                                        <td class="font-weight-bold"><cf_get_lang dictionary_id='33172.Yabancı Dil'></td>
                                        <td class="font-weight-bold"><cf_get_lang dictionary_id='58996.Dil'></td>
                                        <td class="font-weight-bold"><cf_get_lang dictionary_id='31304.Konuşma'></td>
                                        <td class="font-weight-bold"><cf_get_lang dictionary_id='33175.Anlama'></td>
                                        <td class="font-weight-bold"><cf_get_lang dictionary_id='31306.Yazma'></td>
                                        <td class="font-weight-bold"><cf_get_lang dictionary_id='31307.Öğrenildiği Yer'></td>
                                    </tr>
                                    <cfloop query="get_app_lang">
										<tr>
                                            <td></td>
                                            <td><cfoutput query="get_languages">
                                                    <cfif get_languages.language_id eq get_app_lang.lang_id>#language_set#</cfif>
                                                </cfoutput>
                                            </td>
                                            <td><cfoutput query="know_levels">
                                                    <cfif get_app_lang.lang_speak eq knowlevel_id>#knowlevel# </cfif>
                                                </cfoutput>
                                            </td>
                                            <td><cfoutput query="know_levels">
                                                    <cfif get_app_lang.lang_mean eq knowlevel_id>#knowlevel#</cfif>
                                                </cfoutput>
                                            </td>
                                            <td><cfoutput query="know_levels">
                                                    <cfif get_app_lang.lang_write eq knowlevel_id>#knowlevel#</cfif>
                                                </cfoutput>
                                            </td>
                                            <td><cfoutput>#get_app_lang.lang_where#</cfoutput></td>
                                        </tr>
                            		</cfloop>
                                    <cfif len(get_app.kurs1) or len(get_app.kurs2) or len(get_app.kurs3)>
                                        <tr>
                                            <td class="font-weight-bold"><cf_get_lang dictionary_id='35473.Kurs ve Seminer'></td>
                                            <td class="font-weight-bold"><cf_get_lang dictionary_id='57480.Konu'></td>
                                            <td class="font-weight-bold"><cf_get_lang dictionary_id='58455.Yıl'></td>
                                            <td class="font-weight-bold"><cf_get_lang dictionary_id='57490.Gün'></td>
                                            <td class="font-weight-bold" colspan="2"><cf_get_lang dictionary_id='47653.Yer'></td>
                                            <td></td>
                                        </tr>
                                    </cfif>
                                    <cfoutput>
                                        <cfif len(get_app.kurs1)>
                                        <tr>
                                            <td></td>
                                            <td>#get_app.kurs1#</td>
                                            <td>#dateformat(get_app.kurs1_yil,'yyyy')#</td>
                                            <td>#get_app.kurs1_gun#</td>
                                            <td colspan="2">#get_app.kurs1_yer#</td>
                                            <td></td>
                                        </tr>
                                        </cfif>
                                        <cfif len(get_app.kurs2)>
                                        <tr>
                                            <td></td>
                                            <td>#get_app.kurs2#</td>
                                            <td>#dateformat(get_app.kurs2_yil,'yyyy')#</td>
                                            <td>#get_app.kurs2_gun#</td>
                                            <td colspan="2">#get_app.kurs2_yer#</td>
                                            <td></td>
                                        </tr>
                                        </cfif>
                                        <cfif len(get_app.kurs3)>
                                        <tr>
                                            <td></td>
                                            <td>#get_app.kurs3#</td>
                                            <td>#dateformat(get_app.kurs3_yil,'yyyy')#</td>
                                            <td>#get_app.kurs3_gun#</td>
                                            <td colspan="2">#get_app.kurs3_yer#</td>
                                            <td></td>
                                        </tr>
                                        </cfif>
                                    </cfoutput>
                                </table>
                            </td>
                        </tr>
                        <cfif len(get_app.comp_exp) or (get_teacher_detail.recordcount and len(get_teacher_detail.computer_education))>
                            <tr>
                                <td class="font-weight-bold"><cf_get_lang dictionary_id='35168.Bilgisayar Bilgisi'></td>
                                <td>:
                                    <cfif get_teacher_detail.recordcount and len(get_teacher_detail.computer_education)>
                                        <cfset computer_education_list = listsort(get_teacher_detail.computer_education,"numeric","ASC",",")>
                                        <cfset comp_edu_list=computer_education_list>
                                        <cfif listfind(computer_education_list,-1,',')>
                                            <cfset comp_edu_list=listdeleteat(comp_edu_list,listfindnocase(comp_edu_list,-1))>
                                        </cfif>
                                        <cfif len(comp_edu_list)>
                                            <cfset GET_COMPUTER_INFO = get_components.GET_COMPUTER_INFO(comp_edu_list: comp_edu_list)>
                                            <cfoutput query="get_computer_info">
                                                #computer_info_name# <cfif currentrow neq get_computer_info.recordcount></cfif>
                                            </cfoutput>
                                        </cfif>
                                        <cfif listfind(computer_education_list,-1,',')><cfif len(comp_edu_list)></cfif><cfoutput>#get_app.comp_exp#</cfoutput></cfif>
                                    </cfif>
                                </td>
                            </tr>
                        </cfif>
                    </table>
                </td>
            </tr>
            <cfif get_add_info.recordcount>
                <tr class="main-bg-color">
                   <td colspan="2" class="font-weight-bold"><cf_get_lang dictionary_id='58565.Branş'></td>
                </tr>
                <tr>
                    <td>
                        <table class="table table-borderless">
                            <cfoutput query="get_branches">	
                                <cfquery name="GET_ALL_BRANCHES" dbtype="query">
                                    SELECT * FROM GET_ADD_INFO WHERE BRANCHES_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_branches.branches_id#">
                                </cfquery>
                                <tr>
                                    <td class="font-weight-bold">#get_branches.branches_name#</td>
                                    <td>: <cfloop query="get_all_branches">
                                            #branches_name_row#<cfif get_all_branches.currentrow neq get_all_branches.recordcount></cfif>
                                        </cfloop>
                                    </td>
                                </tr>
                            </cfoutput>
                        </table>
                    </td>
                </tr>
            </cfif>
            <cfif get_app_work.recordcount>
                <tr class="main-bg-color">
                    <td colspan="2" class="font-weight-bold"><cf_get_lang dictionary_id='35226.İş Tecrübeleri'></td>
                </tr>
                <tr>
                     <td>
                        <cfoutput query="get_app_work">
                            <table class="table">
                                <tr>
                                    <td class="font-weight-bold"><cf_get_lang dictionary_id='32336.Deneyim'></td>
                                    <td colspan="3">: #currentrow#</td>
                                </tr>
                                <tr>
                                    <td class="font-weight-bold"><cf_get_lang dictionary_id='57574.Şirket'></td>
                                    <td>: #exp#</td>
                                    <td class="font-weight-bold"><cf_get_lang dictionary_id='57501.Başlangıç'></td>
                                    <td>: <cfif len(exp_start)>#dateformat(exp_start,'dd/mm/yyyy')#</cfif></td>
                                </tr>
                                <tr>
                                    <td class="font-weight-bold"><cf_get_lang dictionary_id='57571.Ünvan'></td>
                                    <td>: 
                                        <cfif len(exp_task_id)>
                                            <cfset GET_TASK= get_components.GET_TASK(partner_pos_id: exp_task_id)>
                                            #get_task.partner_position#
                                        </cfif>
                                    </td>
                                    <td class="font-weight-bold"><cf_get_lang dictionary_id='57502.Bitiş'></td>
                                    <td>: <cfif len(exp_finish)>#dateformat(exp_finish,'dd/mm/yyyy')#</cfif></td>
                                </tr>
                                <cfif len(exp_salary) or (len(exp_telcode) and len(exp_tel))>
                                    <tr>
                                        <td class="font-weight-bold"><cf_get_lang dictionary_id='30174.Kod/Telefon'></td>
                                        <td>: #exp_telcode# #exp_tel#</td>
                                        <td class="font-weight-bold"><cf_get_lang dictionary_id='55123.Ücret'> (<cf_get_lang dictionary_id='35228.Son Ayın Net Ücreti'>)</td>
                                        <td>: <cfif len(exp_salary)>#TLFormat(exp_salary)#</cfif> <cfif len(exp_money_type)>#exp_money_type#</cfif></td>
                                    </tr>
                                </cfif>
                                <cfif len(exp_extra_salary)>
                                    <tr>
                                        <td colspan="2" class="font-weight-bold"><cf_get_lang dictionary_id='31283.Ek Ödemeler'></td>
                                        <td colspan="2">: #exp_extra_salary#</td>
                                    </tr>
                                </cfif>
                                <cfif len(exp_extra)>
                                    <tr>
                                        <td class="font-weight-bold"><cf_get_lang dictionary_id='31284.Görev Sorumluluk ve Ek Açıklamalar'></td>
                                        <td colspan="3">: #exp_extra#</td>
                                    </tr>
                                </cfif>
                                <tr>
                                    <td class="font-weight-bold"><cf_get_lang dictionary_id='31530.Ayrılma Nedeni'></td>
                                    <td colspan="3">: #exp_reason#</td>
                                </tr>
                            </table>
                        </cfoutput>
                        <cfif get_emp_references.recordcount>
                            <table class="table">
                                <tr>
                                    <td class="font-weight-bold"><cf_get_lang dictionary_id='35174.Hakkınızda Bilgi Edinebileceğimiz Kişiler'></td>
                                </tr>
                                <tr>
                                    <td>
                                        <table class="table">
                                            <thead>
                                                <tr>
                                                    <th></th>
                                                    <th class="font-weight-bold"><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
                                                    <th class="font-weight-bold"><cf_get_lang dictionary_id='57574.Şirket'></th>
                                                    <th class="font-weight-bold"><cf_get_lang dictionary_id='58497.Pozisyon'></th>
                                                    <th class="font-weight-bold"><cf_get_lang dictionary_id='49272.Tel'></th>
                                                    <th class="font-weight-bold"><cf_get_lang dictionary_id='57428.E-posta'></th>
                                                </tr>
                                            </thead>
                                            <cfoutput query="get_emp_references">
                                                <tr>
                                                    <td>#currentrow#</td>
                                                    <td>#reference_name#</td>
                                                    <td>#reference_company#</td>
                                                    <td>#reference_position#</td>
                                                    <td>#reference_telcode# #reference_tel#</td>
                                                    <td>#reference_email#</td>
                                                </tr>
                                            </cfoutput>
                                         </table>
                                    </td>
                                </tr>
                            </table>
                        </cfif>
                        <cfif len(get_app.hobby) or len(get_app.club)>
                            <table class="table">
                                <tr>
                                    <td class="font-weight-bold"><cf_get_lang dictionary_id='35178.Özel İlgi Alanlarınız'></td>
                                    <td>: <cfoutput>#get_app.hobby#</cfoutput></td>
                                </tr>
                                <tr>
                                    <td class="font-weight-bold"><cf_get_lang dictionary_id='35179.Üye Olduğunuz Klüp Ve Dernekler'></td>
                                    <td>: <cfoutput>#get_app.club#</cfoutput></td>
                                </tr>
                                <cfset GET_RELATIVES = get_components.GET_RELATIVES()>
                                <cfif get_relatives.recordcount>
                                    <tr>
                                        <td class="font-weight-bold" colspan="2"><cf_get_lang dictionary_id='31698.Aile Bilgileri'></td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <cfif get_relatives.recordcount>
                                                <table class="form_table" id="table_list">
                                                	<thead>
                                                        <tr class="font-weight-bold">
                                                            <th><cf_get_lang dictionary_id='57631.Ad'></th>
                                                            <th><cf_get_lang dictionary_id='58726.Soyad'></th>
                                                            <th><cf_get_lang dictionary_id='56171.Yakınlık Derecesi'></th>
                                                            <th></th>
                                                        </tr>
                                                    </thead>
                                                    <cfoutput query="get_relatives">
                                                        <tr>
                                                            <td>#get_relatives.name#</td>
                                                            <td>#get_relatives.surname#</td>
                                                            <td><cfif get_relatives.relative_level eq 1><cf_get_lang dictionary_id='35116.Babası'>
                                                                <cfelseif get_relatives.relative_level eq 2><cf_get_lang dictionary_id='31963.Annesi'>
                                                                <cfelseif get_relatives.relative_level eq 3><cf_get_lang dictionary_id='55275.Eşi'>
                                                                <cfelseif get_relatives.relative_level eq 4><cf_get_lang dictionary_id='31330.Oğlu'>
                                                                <cfelseif get_relatives.relative_level eq 5><cf_get_lang dictionary_id='31331.Kızı'>
                                                                <cfelseif get_relatives.relative_level eq 6><cf_get_lang dictionary_id='31449.Kardeşi'></cfif>
                                                            </td>
                                                            <td></td>
                                                        </tr>
                                                    </cfoutput>
                                                </table>
                                            </cfif>
                                        </td>
                                    </tr>
                                </cfif>
                             </table>
                         </cfif>
                     </td>
                </tr>
            </cfif>
            <cfset GET_APP_UNIT = get_components.GET_APP_UNIT()>
            <cfset GET_CV_UNIT = get_components.GET_CV_UNIT()>
            <cfif get_cv_unit.recordcount>
                <tr class="main-bg-color">
                   <td  colspan="2" class="font-weight-bold"><cf_get_lang dictionary_id='35474.Çalışmak İstenilen Birim'></td>
                </tr>
                <tr>
                	<td>
                    	<table class="table">
                        	<tr>
                            	<td class="font-weight-bold"><cf_get_lang dictionary_id='35474.Çalışmak İstenilen Birim'></td>
                                <td colspan="4">:
                                	<cfset liste = valuelist(get_app_unit.unit_id)>
									<cfset liste_row = valuelist(get_app_unit.unit_row)>					
                                    <cfoutput query="get_cv_unit">
                                        <cfif listfind(liste,get_cv_unit.unit_id,',')>
                                            <table>
                                                <tr>
                                                    <td>#listgetat(liste_row,listfind(liste,get_cv_unit.unit_id,','),',')# -</td>
                                                    <td>#get_cv_unit.unit_name#</td>
                                                </tr>
                                            </table>
                                        </cfif>
                                    </cfoutput>
                                </td>
                            </tr>
                            <tr>
								<cfif len(get_app.preference_branch)>
                                     <td colspan="4" class="font-weight-bold"><cf_get_lang dictionary_id='35187.Çalışmak İstediği Şube'></td>
                                </cfif>
                            </tr>
                            <cfif len(get_app.preference_branch)>
								<cfset branch_list= listsort(listdeleteduplicates(valuelist(get_app.preference_branch,',')),'numeric','ASC',',')>
                            </cfif>
                            <tr>
                            	<cfif len(get_app.preference_branch)>
                                    <td colspan="4">
                                        <table>
                                            <cfset GET_BRANCH = get_components.GET_BRANCH(branch_list: branch_list)>
                                            <cfoutput query="get_branch">
                                                <tr>
                                                    <td>#branch_name# - #branch_city#</td>
                                                </tr>
                                            </cfoutput>
                                        </table>
                                    </td>
                                </cfif>
                            </tr>
                            <tr>
                            	<td class="font-weight-bold"><cf_get_lang dictionary_id='31705.Seyahat Edebilir misiniz'>?</td>
                                <td>: 
									<cfif get_app.is_trip is 1 or get_app.is_trip is ""> 
                                    	<cf_get_lang_main no='83.Evet'>
									<cfelseif get_app.is_trip is 0>
                                    	<cf_get_lang_main no='84.Hayır'>
									</cfif>	
                                </td>
                                <td class="font-weight-bold"><cf_get_lang dictionary_id='31706.İstenilen Ücret (Net)'></td>
                                <td>:
                                    <cfif len(get_teacher_detail.salary_range)>
                                        <cfif get_teacher_detail.salary_range eq 1>250
                                        <cfelseif get_teacher_detail.salary_range eq 2>250-500
                                        <cfelseif get_teacher_detail.salary_range eq 3>500-1000
                                        <cfelseif get_teacher_detail.salary_range eq 4>1000-1500
                                        <cfelseif get_teacher_detail.salary_range eq 5>1500-2000
                                        <cfelseif get_teacher_detail.salary_range eq 6>2000-2500
                                        <cfelseif get_teacher_detail.salary_range eq 7>2500-3000
                                        <cfelseif get_teacher_detail.salary_range eq 8>3000-3500
                                        <cfelseif get_teacher_detail.salary_range eq 9>3500-4000
                                        <cfelseif get_teacher_detail.salary_range eq 10>4000-4500
                                        <cfelseif get_teacher_detail.salary_range eq 11>4500-5000
                                        <cfelseif get_teacher_detail.salary_range eq 12>5000-5500
                                        <cfelseif get_teacher_detail.salary_range eq 13>5500-6000
                                        <cfelseif get_teacher_detail.salary_range eq 14>6000-6500
                                        <cfelseif get_teacher_detail.salary_range eq 15>6500-7000
                                        <cfelseif get_teacher_detail.salary_range eq 16>7000-7500
                                        <cfelseif get_teacher_detail.salary_range eq 17>7500-8000
                                        <cfelseif get_teacher_detail.salary_range eq 18>8000-8500
                                        <cfelseif get_teacher_detail.salary_range eq 19>8500-9000
                                        <cfelseif get_teacher_detail.salary_range eq 20>9000-9500
                                        <cfelseif get_teacher_detail.salary_range eq 21>9500-10000
                                        </cfif><cfoutput>#session_base.money#</cfoutput>
                                    <cfelse>
                                        <cfif len(get_app.expected_price)><cfoutput>#TLFormat(get_app.expected_price)# #get_app.expected_money_type#</cfoutput></cfif>
                                    </cfif>		 	
                                </td>
                             </tr>
                            <cfif len(get_app.applicant_notes)>
                                 <tr>
                                    <td class="font-weight-bold"><cf_get_lang dictionary_id='31707.Eklemek İstedikleriniz'></td>
                                    <td colspan="3">: <cfoutput>#get_app.applicant_notes#</cfoutput></td>
                                 </tr>
                             </cfif>
                         </table>
                    </td>
                </tr>
            </cfif>
        </table>
    </div>
    <br />
    <div class="text-right">
    	<cfif isdefined('attributes.is_fast_cv') and attributes.is_fast_cv eq 1>
            <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.form_upd_cv_1" class="trubuttonaktif"><cf_get_lang dictionary_id='34536.Özgeçmişinizi güncellemek için tıklayınız'></a>
        </cfif>
    </div>
</div>
