<!--- Başvuru Arama --->

<cfset get_components = createObject("component", "V16.objects2.career.cfc.data_career")>

<cfset know_levels = get_components.know_levels()>
<cfset GET_MONEYS = get_components.GET_MONEYS(period_id: session.pp.period_id)>
<cfset GET_CITY = get_components.GET_CITY()>
<cfset GET_EDU_LEVEL = get_components.GET_EDU_LEVEL()>

<cfif isdefined("attributes.is_search") and len(attributes.is_search)>
    <cfinclude template="list_search_app.cfm">
<cfelse>
    <cfform name="employe_detail" method="post" action="#request.self#">
        <cfinput name="is_search" value="1" type="hidden">
        <div class="form-group row">
            <label class="col-md-3 col-form-label"><cf_get_lang dictionary_id='34511.Başvurulardan Ara'></label>
            <div class="col-md-5 col-lg-3 col-xl-2 mt-3">        
                <input type="checkbox" name="search_app_pos" id="search_app_pos" value="1">             
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <p class="font-weight-bold"><cf_get_lang dictionary_id='35245.Başvuru Kriterleri'></p>
            </div>
        </div>
        <div class="form-group row">
            <label class="col-md-3 col-form-label"><cf_get_lang dictionary_id='57756.Durum'></label>
            <div class="col-md-4 col-lg-3 col-xl-2 py-1">        
                <select class="form-control" name="status_app_pos" id="status_app_pos">
                    <option value=""><cf_get_lang dictionary_id='57708.Tümü'>
                    <option value="1" selected><cf_get_lang dictionary_id='57493.Aktif'>
                    <option value="0"><cf_get_lang dictionary_id='57494.Pasif'>			                        
                </select>            
            </div>
            <div class="col-md-4 col-lg-3 col-xl-2 py-1">        
                <select class="form-control" name="date_status" id="date_status">
                    <option value="1" <cfif isdefined("attributes.date_status") and  attributes.date_status eq 1>selected</cfif>><cf_get_lang dictionary_id='57926.Azalan Tarih'>
                    <option value="2" <cfif isdefined("attributes.date_status") and attributes.date_status eq 2>selected</cfif>><cf_get_lang dictionary_id='57925.Artan Tarih'>
                    <option value="3" <cfif isdefined("attributes.date_status") and attributes.date_status eq 3>selected</cfif>><cf_get_lang dictionary_id='35246.Azalan Kayıt No'>
                    <option value="4" <cfif isdefined("attributes.date_status") and attributes.date_status eq 4>selected</cfif>><cf_get_lang dictionary_id='35247.Artan Kayıt No'>
                    <option value="5" <cfif isdefined("attributes.date_status") and attributes.date_status eq 5>selected</cfif>><cf_get_lang dictionary_id='35248.Alfabetik Azalan'>
                    <option value="6" <cfif isdefined("attributes.date_status") and attributes.date_status eq 6>selected</cfif>><cf_get_lang dictionary_id='35249.Alfabetik Artan'>
                </select>            
            </div>
        </div>
        <div class="form-group row">
            <label class="col-md-3 col-form-label"><cf_get_lang dictionary_id='31334.İlan'></label>
            <div class="col-md-4 col-lg-3 col-xl-2">        
                <input type="hidden" name="notice_id" id="notice_id" value="">
                <input type="text" class="form-control" name="notice_head" id="notice_head" value="">            
            </div>
            <div class="col-md-4 col-lg-3 col-xl-2 mt-2">
                <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_list_notices&field_id=employe_detail.notice_id&field_name=employe_detail.notice_head','list');" title="<cf_get_lang dictionary_id='32205.İlan Ekle'>"><img src="/images/plus_list.gif" align="absmiddle" border="0" alt="<cf_get_lang dictionary_id='32205.İlan Ekle'>" /></a>                                  
            </div>
        </div>
        <div class="form-group row">
            <label class="col-md-3 col-form-label"><cf_get_lang dictionary_id='31362.Başvuru Tarihi'></label>
            <div class="col-md-4 col-lg-3 col-xl-2 py-1">        
                <cfinput type="text" class="form-control" name="app_date1" id="app_date1" validate="eurodate" value="">
                <cf_wrk_date_image date_field="app_date1">           
            </div>
            <div class="col-md-4 col-lg-3 col-xl-2 py-1">
                <cfinput type="text" class="form-control" name="app_date2" id="app_date2" validate="eurodate" value="">
                <cf_wrk_date_image date_field="app_date2">
            </div>
        </div>
        <div class="form-group row">
            <label class="col-md-3 col-form-label"><cf_get_lang dictionary_id='32327.Çalışmak İstediği Yer'></label>
            <div class="col-md-4 col-lg-3 col-xl-2">        
                <select class="form-control" name="prefered_city" id="prefered_city" multiple>
                    <option value=""><cf_get_lang dictionary_id='31704.Tüm Türkiye'></option>			
                    <cfoutput query="get_city">
                    <option value="#city_id#">#city_name#</option>
                    </cfoutput>
                </select>
            </div>
        </div>
        <div class="form-group row">
            <label class="col-md-3 col-form-label"><cf_get_lang dictionary_id='31954.İstenen Ücret'></label>
            <div class="col-md-3 col-lg-2 col-xl-1 py-1">        
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='31957.İstenen Ücret Giriniz'></cfsavecontent>
                <cfinput type="text" class="form-control text-right" name="salary_wanted1" id="salary_wanted1" validate="float" message="#message#" passthrough = "onkeyup=""return(formatcurrency(this,event));""">
            </div>
            <div class="col-md-3 col-lg-2 col-xl-1 py-1">
                <cfinput type="text" class="form-control text-right" name="salary_wanted2" id="salary_wanted2" validate="float" message="#message#" passthrough = "onkeyup=""return(formatcurrency(this,event));""">
            </div>
            <div class="col-md-2 col-lg-2 col-xl-1 py-1">
                <select class="form-control" name="salary_wanted_money" id="salary_wanted_money">
                    <cfoutput query="get_moneys">
                    <option value="#money#" <cfif money eq session_base.money>selected</cfif>>#money#</option> 
                    </cfoutput>
                </select>
            </div>
        </div>
        <div class="form-group row">
            <label class="col-md-3 col-form-label"><cf_get_lang dictionary_id='34510.Özgeçmişlerden Ara'></label>
            <div class="col-md-4 col-lg-2 col-xl-2 mt-3">        
                <input type="checkbox" name="search_app" id="search_app" value="1">             
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <p class="font-weight-bold"><cf_get_lang dictionary_id='35250.Özgeçmiş Kriterleri'></p>
            </div>
        </div>
        <div class="form-group row">
            <label class="col-md-3 col-form-label"><cf_get_lang dictionary_id='57756.Durum'></label>
            <div class="col-md-4 col-lg-3 col-xl-2">        
                <select class="form-control" name="status_app" id="status_app">
                    <option value=""><cf_get_lang dictionary_id='57708.Tümü'>	
                    <option value="1" selected><cf_get_lang dictionary_id='57493.Aktif'>
                    <option value="0"><cf_get_lang dictionary_id='57494.Pasif'>			                        
                </select>            
            </div>
        </div>
        <p class="font-weight-bold"><cf_get_lang dictionary_id='31234.Kimlik Bilgileri'></p>
        <div class="form-group row">
            <label class="col-md-3 col-form-label"><cf_get_lang dictionary_id='57631.Ad'></label>
            <div class="col-md-4 col-lg-3 col-xl-2">        
                <input type="text" class="form-control" name="app_name" id="app_name" value="">             
            </div>
        </div>
        <div class="form-group row">
            <label class="col-md-3 col-form-label"><cf_get_lang dictionary_id='58726.Soyad'></label>
            <div class="col-md-4 col-lg-3 col-xl-2">        
                <input type="text" class="form-control" name="app_surname" id="app_surname" value="">             
            </div>
        </div>
        <div class="form-group row">
            <label class="col-md-3 col-form-label"><cf_get_lang dictionary_id='30496.Yaş'></label>
            <div class="col-md-2 col-lg-1 col-xl-1 py-1">        
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='32330.Yaşı Rakamla Girmelisiniz'></cfsavecontent>
                <cfinput type="text" class="form-control" name="birth_date1" value="" validate="integer" range="1," maxlength="2" message="#message#">            
            </div>
            <div class="col-md-2 col-lg-1 col-xl-1 py-1">        
                <cfinput type="text" class="form-control" name="birth_date2" value="" validate="integer" range="1," maxlength="2" message="#message#">
            </div>
        </div>
        <div class="form-group row">
            <label class="col-md-3 col-form-label"><cf_get_lang dictionary_id='57790.Doğum Yeri'></label>
            <div class="col-md-4 col-lg-3 col-xl-2">        
                <cfinput type="text" class="form-control" name="birth_place" maxlength="100" value="">           
            </div>
        </div>
        <div class="form-group row">
            <label class="col-md-3 col-form-label"><cf_get_lang dictionary_id='31203.Medeni Durum'></label>
            <div class="col-md-4 col-lg-3 col-xl-2 mt-2">        
                <input type="checkbox" name="married" id="married" value="0"> <cf_get_lang dictionary_id='30694.Bekar'> 
                <input type="checkbox" name="married" id="married" value="1"> <cf_get_lang dictionary_id='30501.Evli'>
            </div>
        </div>
        <div class="form-group row">
            <label class="col-md-3 col-form-label"><cf_get_lang dictionary_id='31660.Nüfusa Kayıtlı Olduğu İl'></label>
            <div class="col-md-4 col-lg-3 col-xl-2">        
                <cfinput type="text" class="form-control" name="city" id="city" value="" maxlength="100">          
            </div>
        </div>
        <p class="font-weight-bold"><cf_get_lang dictionary_id='30236.Kişisel Bilgiler'></p>
        <div class="form-group row">
            <label class="col-md-3 col-form-label"><cf_get_lang dictionary_id='57764.Cinsiyet'></label>
            <div class="col-md-4 col-lg-3 col-xl-2 mt-2">        
                <input type="checkbox" name="sex" id="sex" value="1"> <cf_get_lang dictionary_id='58959.Erkek'>   
                <input type="checkbox" name="sex" id="sex" value="0"> <cf_get_lang dictionary_id='58958.Kadın'>
            </div>
        </div> 
        <div class="form-group row">
            <label class="col-md-3 col-form-label"><cf_get_lang dictionary_id='31231.Şehit Yakını Mısınız?'></label>
            <div class="col-md-4 col-lg-3 col-xl-2 mt-2">        
                <input type="checkbox" name="martyr_relative" id="martyr_relative" value="1"> <cf_get_lang dictionary_id='57495.Evet'>          
            </div>    
        </div>  
        <div class="form-group row">
            <label class="col-md-3 col-form-label"><cf_get_lang dictionary_id='31705.Seyahat Edebilir misiniz'>?</label>
            <div class="col-md-4 col-lg-3 col-xl-2 mt-2 pt-1">        
                <input type="checkbox" name="is_trip" id="is_trip" value="1">          
            </div>    
        </div>
        <div class="form-group row">
            <label class="col-md-3 col-form-label"><cf_get_lang dictionary_id='55255.Ehliyeti Var mı'>?</label>
            <div class="col-md-4 col-lg-3 col-xl-1 mt-2 pt-1">        
                <input type="checkbox" name="driver_licence" id="driver_licence" value="1">         
            </div>       
        </div>
        <div class="form-group row">
            <label class="col-md-3 col-form-label"><cf_get_lang dictionary_id='48586.Ehliyet Sınıfı'></label>
            <div class="col-md-2 col-lg-2 col-xl-1">
                <cfinput type="Text" class="form-control" name="driver_licence_type" maxlength="15">
            </div>
        </div>
        <div class="form-group row">
            <label class="col-md-3 col-form-label"><cf_get_lang dictionary_id='35139.Hiç Yargılandı mı ve/veya Hüküm Giydi  mi'>?</label>
            <div class="col-md-4 col-lg-3 col-xl-2 mt-2">        
                <input type="radio" name="sentenced" id="sentenced" value="1"> <cf_get_lang dictionary_id='57495.Evet'>   
                <input type="radio" name="sentenced" id="sentenced" value="0"> <cf_get_lang dictionary_id='57496.Hayır'>
            </div>
        </div>
        <div class="form-group row">
            <label class="col-md-3 col-form-label"><cf_get_lang dictionary_id='35140.Fiziksel Engeli Var mı?'></label>
            <div class="col-md-3 col-lg-2 col-xl-2 mt-2">        
                <input type="radio" name="defected" id="defected" value="1"> <cf_get_lang dictionary_id='57495.Evet'>   
                <input type="radio" name="defected" id="defected" value="0"> <cf_get_lang dictionary_id='57496.Hayır'>
            </div>
            <div class="col-md-2 col-lg-2 col-xl-1">
                <select class="form-control" name="defected_level" id="defected_level">
                    <option value="0">%0</option>
                    <option value="10">%10</option>
                    <option value="20">%20</option>
                    <option value="30">%30</option>
                    <option value="40">%40</option>
                    <option value="50">%50</option>
                    <option value="60">%60</option>
                    <option value="70">%70</option>
                    <option value="80">%80</option>
                    <option value="90">%90</option>
                    <option value="100">%100</option>
                </select>
            </div>
        </div> 
        <div class="form-group row">
            <label class="col-md-3 col-form-label"><cf_get_lang dictionary_id='35141.Askerlik Durumu'></label>
            <div class="col-md-9 col-lg-9 col-xl-9 mt-2">        
                <input type="checkbox" name="military_status" id="military_status" value="0"> <cf_get_lang dictionary_id='31210.Yapmadı'>          
            
                <input type="checkbox" name="military_status" id="military_status" value="1"> <cf_get_lang dictionary_id='44595.Yaptı'>
            
                <input type="checkbox" name="military_status" id="military_status" value="2"> <cf_get_lang dictionary_id='31212.Muaf'>
            
                <input type="checkbox" name="military_status" id="military_status" value="3"> <cf_get_lang dictionary_id='31213.Yabancı'>
        
                <input type="checkbox" name="military_status" id="military_status" value="4"> <cf_get_lang dictionary_id='31214.Tecilli'>
            </div>
        </div>
        <div class="form-group row">
            <label class="col-md-3 col-form-label"><cf_get_lang dictionary_id='56191.Yaşadığı Yer'></label>
            <div class="col-md-4 col-lg-3 col-xl-2">        
                <select class="form-control" name="homecity" id="homecity" multiple>
                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                    <cfoutput query="get_city">
                        <option value="#city_id#">#city_name#</option>
                    </cfoutput>
                </select>         
            </div>   
        </div>
        <p class="font-weight-bold"><cf_get_lang dictionary_id='30422.İletişim Bilgileri'></p>
        <div class="form-group row">
            <label class="col-md-3 col-form-label"><cf_get_lang dictionary_id='57428.E-posta'></label>
            <div class="col-md-4 col-lg-3 col-xl-2">        
                <cfinput type="text" class="form-control" name="email" maxlength="100" validate="email" message="<cf_get_lang_main no='1072.E mail adresinizi kontrol ediniz'>!">        
            </div>   
        </div>
        <p class="font-weight-bold"><cf_get_lang dictionary_id='34673.Eğitim ve Deneyim Bilgileri'></p>    
        <div class="form-group row">
            <label class="col-md-3 col-form-label"><cf_get_lang dictionary_id='35155.Eğitim Seviyesi'></label>
            <div class="col-md-9 col-lg-6 col-xl-4 mt-2">        
                <cfoutput query="GET_EDU_LEVEL">
                    <input type="checkbox" name="training_level" id="training_level" value="#GET_EDU_LEVEL.EDU_LEVEL_ID#" checked> #GET_EDU_LEVEL.EDUCATION_NAME#
                </cfoutput>
            </div>       
        </div>
        <div class="form-group row">
            <label class="col-md-3 pb-1 col-form-label"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>   
            <div class="col-md-4 col-lg-2 col-xl-1">
                <cfinput type="text" class="form-control" name="edu_finish" maxlength="4">  
            </div>
        </div>  
        <div class="form-group row">
            <label class="col-md-3 col-form-label"><cf_get_lang dictionary_id='34535.Deneyim'></label>
            <div class="col-md-2 col-lg-1 col-xl-1 py-1">        
                <cfinput name="exp_year_s1" class="form-control" value="" validate="integer" range="0,99" maxlength="2" message="<cf_get_lang no='932.Deneyimi rakamla giriniz'>!">
            </div>     
            <div class="col-md-2 col-lg-1 col-xl-1 py-1">
                <cfinput name="exp_year_s2" class="form-control" value="" validate="integer" range="0,99" maxlength="2" message="<cf_get_lang no='932.Deneyimi rakamla giriniz'>!">   
            </div> 
            <label class="col-md-1 col-form-label"><cf_get_lang dictionary_id='58455.Yıl'></label>  
        </div>
        <div class="form-group row">
            <cfset get_lang = get_components.GET_LANGUAGES()>
            <label class="col-md-3 col-form-label"><cf_get_lang dictionary_id='58996.Dil'></label>
            <div class="col-md-9 col-lg-6 col-xl-3">        
                <cfloop query="GET_LANG">
                    <input name="lang" id="lang" type="checkbox" value="<cfoutput>#get_lang.language_id#</cfoutput>"> <cfoutput>#get_lang.language_set#</cfoutput>
                </cfloop>
            </div>
        </div>
        <div class="form-group row">
            <label class="col-md-3 col-form-label"><cf_get_lang dictionary_id='36466.Seviye'></label>
            <div class="col-md-4 col-lg-3 col-xl-2">        
                <select class="form-control" name="lang_level" id="lang_level">
                    <cfoutput query="know_levels">
                    <option value="#knowlevel_id#">#knowlevel# 
                    </cfoutput>
                </select>
            </div>     
        </div>
        <div class="form-group row">
            <label class="col-md-3 col-form-label"><cf_get_lang dictionary_id='35255.Dil Arama Kriteri'></label>
            <div class="col-md-4 col-lg-2 col-xl-1">        
                <cf_get_lang dictionary_id='57989.ve'> <input type="radio" name="lang_par" id="lang_par" value="AND" checked>
            
                <cf_get_lang dictionary_id='57998.veya'> <input type="radio" name="lang_par" id="lang_par" value="OR">
            </div>     
        </div>
        <div class="row">
            <div class="col-md-6">
                <div class="form-group row">
                    <label class="col-md-6 col-form-label"><cf_get_lang dictionary_id='30480.Lise'></label>
                    <div class="col-md-6 col-lg-6 col-xl-4">        
                        <cfinput type="text" class="form-control" name="edu3" maxlength="75">
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="form-group row">
                    <label class="col-md-2 col-form-label"><cf_get_lang dictionary_id='57995.Bölüm'></label>
                    <div class="col-md-8 col-lg-6 col-xl-4">
                        <cfset get_edu3_part = get_components.GET_HIGH_SCHOOL_PART()>
                        <select class="form-control" name="edu3_part" id="edu3_part" multiple>
                            <option value="" selected><cf_get_lang_main no='322.Seçiniz'></option>
                            <cfloop query="get_edu3_part">
                                <option value="<cfoutput>#get_edu3_part.high_part_id#</cfoutput>"><cfoutput>#get_edu3_part.high_part_name#</cfoutput></option>
                            </cfloop>
                        </select>
                    </div> 
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-md-6">
                <div class="form-group row">

                    <cfset get_edu4_name = get_components.GET_SCHOOL()>
                    <cfset get_edu4_part_name = get_components.GET_SCHOOL_PART()>
                    
                    <label class="col-md-6 col-form-label"><cf_get_lang dictionary_id='29755.Üniversite'></label>
                    <div class="col-md-6 col-lg-6 col-xl-4">        
                        <select class="form-control" name="edu4_id" id="edu4_id" multiple>
                            <option value="" selected><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfloop query="get_edu4_name">
                            <option value="<cfoutput>#get_edu4_name.school_id#</cfoutput>"><cfoutput>#get_edu4_name.school_name#</cfoutput></option>
                            </cfloop>
                        </select>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="form-group row">
                    <label class="col-md-2 col-form-label"><cf_get_lang dictionary_id='57995.Bölüm'></label>
                    <div class="col-md-8 col-lg-6 col-xl-4">
                        <select class="form-control" name="edu4_part_id" id="edu4_part_id" multiple>
                            <option value="" selected><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfloop query="get_edu4_part_name">
                                <option value="<cfoutput>#get_edu4_part_name.part_id#</cfoutput>"><cfoutput>#get_edu4_part_name.part_name#</cfoutput></option>
                            </cfloop>
                        </select>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-md-6">
                <div class="form-group row">
                    <cfquery name="GET_EDU4" datasource="#DSN#">
                        SELECT DISTINCT
                            EDU_NAME
                        FROM
                            EMPLOYEES_APP_EDU_INFO
                        WHERE
                            EDU_NAME <> '' AND
                            EDU_ID = -1 AND
                            EDU_TYPE IN (4,5)
                        ORDER BY EDU_NAME
                    </cfquery>
                    <cfquery name="GET_EDU4_PART" datasource="#DSN#">
                        SELECT DISTINCT
                            EDU_PART_NAME
                        FROM
                            EMPLOYEES_APP_EDU_INFO
                        WHERE
                            EDU_PART_NAME <> '' AND
                            EDU_PART_ID = -1 AND
                            EDU_TYPE IN (4,5)
                        ORDER BY EDU_PART_NAME
                    </cfquery>
                    <label class="col-md-6 col-form-label"><cf_get_lang dictionary_id='58156.Diğer'><cf_get_lang dictionary_id='56155.Üniversiteler'></label>
                    <div class="col-md-6 col-lg-6 col-xl-4">        
                        <select class="form-control" name="edu4" id="edu4" multiple>
                            <option value="" selected><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfloop query="GET_EDU4">
                            <option value="<cfoutput>#EDU_NAME#</cfoutput>"><cfoutput>#GET_EDU4.EDU_NAME#</cfoutput></option>
                            </cfloop>
                        </select>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="form-group row">            
                    <label class="col-md-2 col-form-label"><cf_get_lang dictionary_id='58156.Diğer'> <cf_get_lang dictionary_id='58139.Bölümler'></label>
                    <div class="col-md-8 col-lg-6 col-xl-4">
                        <select class="form-control" name="edu4_part" id="edu4_part" multiple>
                            <option value="" selected><cf_get_lang_main no='322.Seçiniz'></option>
                            <cfloop query="GET_EDU4_PART">
                            <option value="<cfoutput>#EDU_PART_NAME#</cfoutput>"><cfoutput>#GET_EDU4_PART.EDU_PART_NAME#</cfoutput></option>
                            </cfloop>
                        </select> 
                    </div>     
                </div>        
            </div>
        </div>
        <p class="font-weight-bold"><cf_get_lang dictionary_id='31699.Çalışmak İstediğiniz Birimler'></p>
        <div class="form-group row">
            <cfset get_cv_unit = get_components.get_cv_unit()>
            
            <cfif get_cv_unit.recordcount>
            
            <div class="col-md-6 col-lg-4 col-xl-3">        
                <cfoutput query="get_cv_unit">
                    <cfif get_cv_unit.currentrow-1 mod 3 eq 0></cfif>
                    #get_cv_unit.unit_name#
                    <input type="checkbox" name="unit_id" id="unit_id" value="#get_cv_unit.unit_id#">
                    <cfif get_cv_unit.currentrow mod 3 eq 0 and get_cv_unit.currentrow-1 neq 0></cfif>	  
                </cfoutput>                  
            </div>
            <div class="col-md-2 col-lg-1 col-xl-1">
                <cfinput type="text" class="form-control" name="unit_row" value="9" validate="integer" maxlength="1">
            </div>
            <cfelse>
            <div class="col-md-6 col-lg-4 col-xl-3">
                <cf_get_lang dictionary_id='31702.Sisteme kayıtlı birim yok'>.
            </div>
        </cfif>    
        </div>
        <p class="font-weight-bold"><cf_get_lang dictionary_id='31695.Referans Bilgileri'></p>
        <div class="form-group row">
            <label class="col-md-3 col-form-label"><cf_get_lang dictionary_id='57570.Ad Soyad'></label>
            <div class="col-md-4 col-lg-3 col-xl-2">        
                <input type="text" class="form-control" name="referance" id="referance" value="">             
            </div>
        </div>
        <p class="font-weight-bold"><cf_get_lang dictionary_id='55734.Kullanılabilen Araçlar'></p>
        <p>(<cf_get_lang dictionary_id='35257.Program isimlerini virgülle ayırarak giriniz'>.)</p>
        <div class="form-group row">
            <label class="col-md-3 col-form-label"><cf_get_lang dictionary_id='31301.Bilgisayar Bilgisi'></label>
            <div class="col-md-4 col-lg-3 col-xl-2">        
                <textarea class="form-control" name="tool" id="tool"></textarea>             
            </div>
        </div>
        <div class="form-group row">
            <label class="col-md-3 col-form-label"><cf_get_lang dictionary_id='35215.Sertifika'></label>
            <div class="col-md-4 col-lg-3 col-xl-2">        
                <textarea class="form-control" name="kurs" id="kurs"></textarea>           
            </div>
        </div>    
        <div class="form-group row">
            <label class="col-md-3 col-form-label"><cf_get_lang dictionary_id='35258.Aranacak Kelimeler'></label>
            <div class="col-md-4 col-lg-3 col-xl-2">        
                <textarea class="form-control" name="other" id="other"></textarea>
                <input type="radio" name="other_if" id="other_if" value="0" checked> <cf_get_lang dictionary_id='35259.Geçen'>
                <input type="radio" name="other_if" id="other_if" value="1"> <cf_get_lang dictionary_id='35260.Geçmeyen'>          
            </div>
        </div> 
        <cfsavecontent variable="button_title">
            <cf_get_lang dictionary_id="57565.Ara">
        </cfsavecontent>
        <div class="form-group row">
            <cf_workcube_buttons is_upd='0' insert_info='#button_title#' insert_alert='' add_function='kontrol()'>
        </div>
    </cfform>
</cfif>
<script type="text/javascript">
function kontrol()
{
	if ( (employe_detail.search_app.checked != 1) && (employe_detail.search_app_pos.checked != 1) )
	{
		alert("<cf_get_lang no='940.Arama Yapılması İçin Özgeçmiş veya Başvuruları Seçmelisiniz'>!");
		return false;
	}
	employe_detail.salary_wanted1.value = filterNum(employe_detail.salary_wanted1.value);
	employe_detail.salary_wanted2.value = filterNum(employe_detail.salary_wanted2.value);
	return true;
}
</script>
