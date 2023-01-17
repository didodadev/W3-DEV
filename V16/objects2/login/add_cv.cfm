<!--- Kariyer Başvurusu --->
<cfset get_components = createObject("component", "V16.objects2.career.cfc.data_career")>

<cfif not isdefined("session.ww.userid") and not isdefined("session.pp.userid") and not isdefined("session.cp.userid")>
&nbsp;&nbsp;&nbsp;<cf_get_lang no='1018.CV Kaydedebilmek İçin Üye Girişi Yapmanız Gerekmektedir'>.
<cfexit method="exittemplate">
</cfif>

<cfset IM_CATS = get_components.GET_IM()>
<cfset GET_ID_CARD_CATS = get_components.GET_ID_CARD_CATS()>
<cfset KNOW_LEVELS = get_components.KNOW_LEVELS()>
<cfset MOBIL_CATS = get_components.MOBIL_CATS()>
<cfset GET_EDU_LEVEL = get_components.GET_EDU_LEVEL()>
<cfset GET_LANGUAGES = get_components.GET_LANGUAGES()>
<cfset GET_COUNTRY = get_components.GET_COUNTRY()>
<cfset GET_CITY = get_components.GET_CITY()>


<cfform name="employe_detail" method="post" enctype="multipart/form-data">
         
    <p class="font-weight-bold"><cf_get_lang dictionary_id='31671.CV Kayıt'></p>       
    <p class="font-weight-bold"><cf_get_lang dictionary_id='31647.Kimlik ve İletişim Bilgileri'></p>
    <div class="row">
        <div class="col-md-6">
            <div class="form-group row">
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='57631.Ad'> *</label>
                <div class="col-12 col-md-8 col-lg-6 col-xl-5">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58939.Ad Girmelisiniz'> !</cfsavecontent>
                    <cfinput type="text" class="form-control" name="name" id="name" maxlength="50" required="Yes" message="#message#">
                </div>
            </div>
            <div class="form-group row">
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='58726.Soyad'> *</label>
                <div class="col-12 col-md-8 col-lg-6 col-xl-5">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='29503.Soyad Girmelisiniz'></cfsavecontent>
                    <cfinput type="text" class="form-control" name="surname" id="surname" maxlength="50" required="Yes" message="#message#">
                </div>
            </div>
            <div class="form-group row">
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='57428.E-posta'></label>
                <div class="col-12 col-md-8 col-lg-6 col-xl-5">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='29707.Lütfen e-mail adresinizi giriniz'></cfsavecontent>
                    <cfinput type="text" class="form-control" name="email" id="email" maxlength="100" validate="email" message="#message#!">
                </div>
            </div>
            <div class="form-group row">
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='31261.Ev Tel'></label>
                <div class="col-4 col-md-3 col-lg-2 col-xl-2">
                    <input type="text" class="form-control" name="hometelcode" id="hometelcode" maxlength="3" onkeyup="isNumber(this);">
                </div>
                <div class="col-8 col-md-5 col-lg-4 col-xl-3">
                    <input type="text" class="form-control" name="hometel" id="hometel" maxlength="7" onkeyup="isNumber(this);" message="#message#">
                </div>
            </div>
            <div class="form-group row">
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='57472.Posta Kodu'></label>
                <div class="col-12 col-md-8 col-lg-6 col-xl-5">
                    <input type="text" class="form-control" name="homepostcode" id="homepostcode" maxlength="10" onkeyup="isNumber(this);"> 
                </div>
            </div>            
            <div class="form-group row">
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='30606.Ev Adresi'></label>
                <div class="col-12 col-md-8 col-lg-6 col-xl-5">
                    <cfsavecontent variable="message1"><cf_get_lang dictionary_id='29484.Fazla Karakter Sayısı'></cfsavecontent>                     
                    <textarea class="form-control" name="homeaddress" id="homeaddress" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message1#</cfoutput>"></textarea>
                </div>
            </div>
            <div class="form-group row">
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='31653.Oturduğunuz Ev'></label>
                <div class="col-12 col-md-8 col-lg-6 col-xl-5 mt-2">
                    <input type="radio" name="home_status" id="home_status" value="1">&nbsp;<cf_get_lang dictionary_id='31654.Kendinizin'>
                    <input type="radio" name="home_status" id="home_status" value="2">&nbsp;<cf_get_lang dictionary_id='31655.Ailenizin'>
                    <input type="radio" name="home_status" id="home_status" value="3">&nbsp;<cf_get_lang dictionary_id='34655.Kira'>
                </div>
            </div>
            <div class="form-group row">
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='35352.Anlık Mesaj'></label>
                <div class="col-5 col-md-5 col-lg-4 col-xl-3">
                    <select class="form-control" name="imcat_id" id="imcat_id" >
                        <cfoutput query="im_cats">
                            <option value="#imcat_id#">#imcat# 
                        </cfoutput>
                    </select>
                </div>
                <div class="col-7 col-md-3 col-xl-3">
                    <input type="text" class="form-control" name="im" id="im" maxlength="30" >
                </div>
            </div>
            <div class="form-group row">
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='30243.Fotoğraf'></label>
                <div class="col-12 col-md-8 col-lg-6 col-xl-5">
                    <input type="file" name="photo" id="photo" >
                </div>                
            </div>
            <div class="form-group row">
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='58727.Doğum Tarihi'></label>
                <div class="col-12 col-md-8 col-lg-6 col-xl-5">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='51786.Doğum Tarihi Girmelisiniz'></cfsavecontent>
                    <cfinput type="text" class="form-control" name="birth_date" id="birth_date" value="" validate="eurodate" maxlength="10" message="#message#">
                    <cf_wrk_date_image date_field="birth_date">
                </div>                
            </div>            
            <div class="form-group row">
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='31658.Kimlik Kartı Tipi'></label>
                <div class="col-12 col-md-8 col-lg-6 col-xl-5">
                    <select class="form-control" name="identycard_cat" id="identycard_cat">
                        <cfoutput query="get_id_card_cats">
                            <option value="#identycat_id#">#identycat# 
                        </cfoutput>
                    </select>
                </div>                
            </div>              
            <div class="form-group row">
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='31660.Nüfusa Kayıtlı Olduğu İl'></label>
                <div class="col-12 col-md-8 col-lg-6 col-xl-5">
                    <input type="text" class="form-control" name="city" id="city" value="" maxlength="100">
                </div>                
            </div>
        </div>
        <div class="col-md-6">
            <div class="form-group row">
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='31648.Direkt Tel'></label>
                <div class="col-4 col-md-3 col-lg-2 col-xl-2">
                    <input type="text" class="form-control" name="worktelcode" maxlength="3" onkeyup="isNumber(this);">
                </div>
                <div class="col-8 col-md-5 col-lg-4 col-xl-3">
                    <input type="text" class="form-control" name="worktel" maxlength="7" onkeyup="isNumber(this);">
                </div>
            </div>
            <div class="form-group row">
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='31650.Dahili Tel'></label>
                <div class="col-12 col-md-8 col-lg-6 col-xl-5">
                    <input type="text" class="form-control" name="extension" id="extension" maxlength="5" onkeyup="isNumber(this);">
                </div>                
            </div>
            <div class="form-group row">
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='58482.Mobil Tel'></label>
                <div class="col-4 col-md-3 col-lg-3 col-xl-2">
                    <select class="form-control" name="mobilcode" id="mobilcode">
                        <cfoutput query="mobil_cats">
                        <option value="#mobilcat#">#mobilcat#
                        </cfoutput>
                    </select>
                </div>
                <div class="col-8 col-md-5 col-lg-3 col-xl-3">
                    <input type="text" class="form-control" name="mobil" id="mobil" maxlength="7" onkeyup="isNumber(this);">
                </div>                
            </div>
            <div class="form-group row">
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='58482.Mobil Tel'> 2</label>
                <div class="col-4 col-md-3 col-lg-3 col-xl-2">
                    <select class="form-control" name="mobilcode2" id="mobilcode2">
                        <cfoutput query="mobil_cats">
                            <option value="#mobilcat#">#mobilcat#
                        </cfoutput>
                    </select>
                </div>
                <div class="col-8 col-md-5 col-lg-3 col-xl-3">
                    <input type="text" class="form-control" name="mobil2" id="mobil2" maxlength="7" onkeyup="isNumber(this);">
                </div>                
            </div>
            <div class="form-group row">
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='30502.Uyruğu'></label>
                <div class="col-12 col-md-8 col-lg-6 col-xl-5">
                    <select class="form-control" name="nationality" id="nationality">
                        <cfoutput query="get_country">
                            <option value="#country_id#" <cfif get_country.country_name eq "Türkiye">selected</cfif>>#country_name#</option>
                        </cfoutput>
                    </select>
                </div>                
            </div>
            <div class="form-group row">
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='58638.İlçe'></label>
                <div class="col-12 col-md-8 col-lg-6 col-xl-5">
                    <input type="hidden" name="county_id" id="county_id" value="">
                    <input type="text" class="form-control" name="homecounty" id="homecounty" value=""> 
                </div>
                <div class="col-xl-1 mt-2">
                    <a href="javascript://" onClick="pencere_ac();"><cf_get_lang dictionary_id='62713.'></a>              
                </div>                
            </div>
            <div class="form-group row">
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='57971.Şehir'></label>
                <div class="col-12 col-md-8 col-lg-6 col-xl-5">
                    <input type="hidden" name="homecity" id="homecity" value="">
                    <input type="text" class="form-control" name="homecity_name" id="homecity_name" value="">                   
                </div>
                <div class="col-xl-1 mt-2">
                    <a href="javascript://" onClick="pencere_ac_city();"><cf_get_lang dictionary_id='31416.Please Select City'></a>
                </div>                
            </div>
            <div class="form-group row">
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='58219.Ülke'></label>
                <div class="col-12 col-md-8 col-lg-6 col-xl-5">
                    <select class="form-control" name="homecountry" id="homecountry" >
                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <cfoutput query="get_country">
                            <option value="#get_country.country_id#" <cfif get_country.is_default eq 1>selected</cfif>>#get_country.country_name#</option>
                        </cfoutput>
                    </select>                  
                </div>                              
            </div>
            <div class="form-group row">
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='58762.Vergi Dairesi'></label>
                <div class="col-12 col-md-8 col-lg-6 col-xl-5">
                    <input type="text" class="form-control" name="tax_office" id="tax_office" maxlength="50">                 
                </div>                              
            </div>
            <div class="form-group row">
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='57752.Vergi No'></label>
                <div class="col-12 col-md-8 col-lg-6 col-xl-5">
                    <input type="text" class="form-control"  name="tax_number" id="tax_number" maxlength="50" onkeyup="isNumber(this);">                 
                </div>                              
            </div>
            <div class="form-group row">
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='57790.Doğum Yeri'></label>
                <div class="col-12 col-md-8 col-lg-6 col-xl-5">
                    <cfinput type="text" class="form-control" name="birth_place" id="birth_place" value="" maxlength="100">                 
                </div>                              
            </div>
            <div class="form-group row">
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='31659.Kimlik Kartı No'></label>
                <div class="col-12 col-md-8 col-lg-6 col-xl-5">
                    <input type="text" class="form-control" name="identycard_no" id="identycard_no" maxlength="50" onkeyup="isNumber(this);">                 
                </div>                              
            </div>
            <div class="form-group row">
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='58025.TC Kimlik No'></label>
                <div class="col-12 col-md-8 col-lg-6 col-xl-5">
                    <input type="text" class="form-control" name="tc_identy_no" id="tc_identy_no" maxlength="10" onkeyup="isNumber(this);">                
                </div>                              
            </div>            
        </div>
    </div>
    <p class="font-weight-bold"><cf_get_lang dictionary_id='31674.Kişisel Bilgileri Giriniz'></p>
    <div class="row">
        <div class="col-md-6">
            <div class="form-group row">
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='57764.Cinsiyet'></label>
                <div class="col-12 col-md-8 col-lg-6 col-xl-5 mt-2">
                    <input type="radio" name="sex" id="sex" value="1"checked>
                    <cf_get_lang dictionary_id='58959.Erkek'>
                    <input type="radio" name="sex" id="sex" value="0">
                    <cf_get_lang dictionary_id='58958.Kadın'>
                </div>                              
            </div>
            <div class="form-group row">
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='31667.Sigara Kullanıyor mu'>?</label>
                <div class="col-12 col-md-8 col-lg-6 col-xl-5 mt-2">
                    <input type="radio" name="use_cigarette" id="use_cigarette" value="1">
                    <cf_get_lang dictionary_id='57495.Evet'>
                    <input type="radio" name="use_cigarette" id="use_cigarette" value="0" checked>
                    <cf_get_lang dictionary_id='57496.Hayır'>
                </div>                              
            </div>          
            <div class="form-group row">
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='35140.Fiziksel Engeli Var mı?'></label>
                <div class="col-6 col-sm-4 col-md-4 col-lg-4 col-xl-3 mt-2">
                    <input type="radio" name="defected" id="defected" value="1" onClick="seviye();">
                    <cf_get_lang dictionary_id='57495.Evet'>
                    <input type="radio" name="defected" id="defected" value="0" checked onClick="seviye();">
                    <cf_get_lang dictionary_id='57496.Hayır'>
                </div> 
                <div class="col-6 col-sm-4 col-md-4 col-lg-3 col-xl-2">
                    <select class="form-control" name="defected_level" id="defected_level"  disabled>
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
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='31670.Hüküm Giydi mi'></label>
                <div class="col-12 col-md-8 col-lg-6 col-xl-5 mt-2">
                    <input type="radio" name="sentenced" id="sentenced" value="1">
                    <cf_get_lang dictionary_id='57495.Evet'> 
                    <input type="radio" name="sentenced" id="sentenced" value="0" checked>
                    <cf_get_lang dictionary_id='57496.Hayır'></td>
                </div>                              
            </div>
            <div class="form-group row">
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='31675.Göçmen'></label>
                <div class="col-12 col-md-8 col-lg-6 col-xl-5 mt-2">
                    <input type="radio" name="immigrant" id="immigrant" value="1">
                    <cf_get_lang dictionary_id='57495.Evet'>
                    <input type="radio" name="immigrant" id="immigrant" value="0" checked>
                    <cf_get_lang dictionary_id='57496.Hayır'>
                </div>                              
            </div>
            <div class="form-group row">
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='31677.Bir suç zannıyla tutuklandınız mı veya mahkumiyetiniz oldu mu'>?</label>
                <div class="col-12 col-md-8 col-lg-6 col-xl-5 mt-2">
                    <input type="radio" name="defected_probability" id="defected_probability" value="1"> <cf_get_lang dictionary_id='57495.Evet'>
                    <input type="radio" name="defected_probability" id="defected_probability" value="0" checked> <cf_get_lang dictionary_id='57496.Hayır'>
                </div>                              
            </div>
            <div class="form-group row">
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='31678.Koğuşturma'></label>
                <div class="col-12 col-md-8 col-lg-6 col-xl-5 mt-2">
                    <cfinput type="text" class="form-control" name="investigation" id="investigation" value="" maxlength="150">
                </div>                              
            </div>
            <div class="form-group row">
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='31679.Devam eden bir hastalık veya bedeni sorununuz var mı'>?</label>
                <div class="col-12 col-md-8 col-lg-6 col-xl-5 mt-2">
                    <input type="radio" name="illness_probability" id="illness_probability" value="1"> <cf_get_lang dictionary_id='57495.Evet'>
                        <input type="radio" name="illness_probability" id="illness_probability" value="0" checked> <cf_get_lang dictionary_id='57496.Hayır'>
                </div>                              
            </div>
            <div class="form-group row">
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='31371.Varsa nedir?'></label>
                <div class="col-12 col-md-8 col-lg-6 col-xl-5">
                    <textarea class="form-control" name="illness_detail" id="illness_detail"></textarea>
                 </div>                              
            </div>
            <div class="form-group row">
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='31680.Geçirdiğiniz Ameliyat'></label>
                <div class="col-12 col-md-8 col-lg-6 col-xl-5">
                    <textarea class="form-control" name="surgical_operation" id="surgical_operation" maxlength="150" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message1#</cfoutput>"></textarea>
                 </div>                              
            </div>            
            <div class="form-group row">
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='31209.Askerlik'></label>
                <div class="col-12 col-md-8 col-lg-6 col-xl-8">
                    <input type="radio" name="military_status" id="military_status" value="0" onClick="tecilli_fonk(this.value)" checked>
                    <cf_get_lang dictionary_id='34640.Yapmadı'>&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="military_status" id="military_status" value="1" onClick="tecilli_fonk(this.value)">
                    <cf_get_lang dictionary_id='34641.Yaptı'>&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="military_status" id="military_status" value="2" onClick="tecilli_fonk(this.value)">
                    <cf_get_lang dictionary_id='31212.Muaf'>&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="military_status" id="military_status" value="3" onClick="tecilli_fonk(this.value)">
                    <cf_get_lang dictionary_id='31213.Yabancı'> &nbsp;&nbsp;&nbsp;
                    <input type="radio" name="military_status" id="military_status" value="4" onClick="tecilli_fonk(this.value)">
                    <cf_get_lang dictionary_id='31214.Tecilli'>
                </div>                              
            </div>
            <div id="Tecilli" style="display:none;">
                <div class="form-group row">
                    <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='31215.Tecil Gerekçesi'></label>
                    <div class="col-12 col-md-8 col-lg-6 col-xl-5">
                        <cfinput type="text" name="military_delay_reason" id="military_delay_reason" value="" maxlength="30">
                     </div>                              
                </div>
                <div class="form-group row">
                    <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='31216.Tecil Süresi'></label>
                    <div class="col-12 col-md-8 col-lg-6 col-xl-5">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='31218.Tecil Süresi Girmelisiniz'></cfsavecontent>
                        <cfinput type="text" class="form-control" name="military_delay_date" id="military_delay_date" value="" validate="eurodate" maxlength="10" message="#message#">
                        <cf_wrk_date_image date_field="military_delay_date">
                     </div>                              
                </div>
            </div>
            <div id="Muaf" style="display:none;">
                <div class="form-group row">
                    <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='31223.Muaf Olma Nedeni'></label>
                    <div class="col-12 col-md-8 col-lg-6 col-xl-5">
                        <input type="text" class="form-control" name="military_exempt_detail" id="military_exempt_detail" maxlength="100" value="">
                     </div>                              
                </div>
            </div>
            <div id="Yapti" style="display:none;">
                <div class="form-group row">
                    <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='31217.Terhis Tarihi'></label>
                    <div class="col-12 col-md-8 col-lg-6 col-xl-5">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='31218.Tecil Süresi Girmelisiniz'></cfsavecontent>
                        <cfinput type="text" class="form-control" name="military_finishdate" value="" validate="eurodate" maxlength="10" message="#message#">
                        <cf_wrk_date_image date_field="military_finishdate"> 
                    </div>                              
                </div>
                <div class="form-group row">
                    <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='31219.Süresi (Ay Olarak Giriniz)'></label>
                    <div class="col-12 col-md-8 col-lg-6 col-xl-5">
                        <input type="text" class="form-control" name="military_month" id="military_month" value="" maxlength="2">
                    </div>                              
                </div>
                <div class="form-group row">                   
                    <div class="col-12 col-md-8 col-lg-6 col-xl-5">
                        <input type="radio" name="military_rank" id="military_rank" value="0"> <cf_get_lang dictionary_id='31221.Er'>
                        <input type="radio" name="military_rank" id="military_rank" value="1"> <cf_get_lang dictionary_id='31222.Yedek Subay'>
                    </div>                              
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="form-group row">
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='30513.Medeni Durumu'></label>
                <div class="col-12 col-md-8 col-lg-6 col-xl-5 mt-2">
                    <input type="radio" name="married" id="married" value="0" checked>
                    <cf_get_lang dictionary_id='30694.Bekar'>
                    <input type="radio" name="married" id="married" value="1">
                    <cf_get_lang dictionary_id='30501.Evli'>
                </div>                              
            </div>
            <div class="form-group row">
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='31231.Şehit Yakını Mısınız?'></label>
                <div class="col-12 col-md-8 col-lg-6 col-xl-5 mt-2">
                    <input type="radio" name="martyr_relative" id="martyr_relative" value="1">
                    <cf_get_lang dictionary_id='57495.Evet'>
                    <input type="radio" name="martyr_relative" id="martyr_relative" value="0" checked>
                    <cf_get_lang dictionary_id='57496.Hayır'>
                </div>                              
            </div>            
            <div class="form-group row">
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='31661.Ehliyet Sınıf / Yıl'></label>
                <div class="col-4 col-md-3 col-lg-3 col-xl-2">
                    <cfset GET_DRIVER_LIS = get_components.GET_DRIVER_LIS()>
                    <select class="form-control" name="driver_licence_type" id="driver_licence_type">
                          <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                          <cfoutput query="get_driver_lis">
                                <option value="#licencecat_id#">#licencecat#</option>
                          </cfoutput>
                    </select>
                </div>
                <div class="col-8 col-md-5 col-lg-3 col-xl-3">
                    <cfsavecontent variable="message_driver"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'></cfsavecontent>
                    <cfinput type="text" class="form-control" name="licence_start_date" id="licence_start_date" value="" maxlength="10" validate="eurodate" message="#message_driver#">
                    <cf_wrk_date_image date_field="licence_start_date">   
                </div>                              
            </div>
            <div class="form-group row">
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='31228.Ehliyet No'></label>
                <div class="col-12 col-md-8 col-lg-6 col-xl-5">
                    <input type="Text" class="form-control" name="driver_licence" id="driver_licence" value="" maxlength="40" onkeyUp="isNumber(this);">
                </div>                              
            </div>
            <div class="form-group row">
                <label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='31369.Kaç Yıldır Aktif Olarak Araba Kulanıyorsunuz?'></label>
                <div class="col-4 col-md-4 col-lg-3 col-xl-2">
                    <input type="Text" class="form-control" name="driver_licence_actived" id="driver_licence_actived" value="" maxlength="2" onkeyUp="isNumber(this);">
                </div>                              
            </div>
        </div>
    </div>
    <p class="font-weight-bold"><cf_get_lang dictionary_id='31685.Eğitim ve Deneyim Bilgilerini Giriniz'></p>
    <div class="form-group row">
        <label class="col-md-2 col-form-label"><cf_get_lang dictionary_id='31686.Eğitim Seviyesi'></label>
        <div class="col-12 col-md-8 col-lg-6 col-xl-2">
            <select class="form-control" name="training_level" id="training_level">
                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                <cfloop query="get_edu_level">
                    <option value="<cfoutput>#get_edu_level.edu_level_id#</cfoutput>"><cfoutput>#get_edu_level.education_name#</cfoutput></option>
                </cfloop>
            </select>
        </div>                              
    </div>		
    <!--- Eğitim --->
    <div class="table-responsive">             
        <table id="table_edu_info" class="table table-borderless">
            <input type="hidden" name="row_edu" id="row_edu" value="0">
            <tr class="main-bg-color">
                <td><cf_get_lang dictionary_id='35156.Okul Türü'></td>
                <td><cf_get_lang dictionary_id='30645.Okul Adı'></td>
                <td>&nbsp;</td>
                <td><cf_get_lang dictionary_id='56483.Başl Yılı'></td>
                <td><cf_get_lang dictionary_id='31554.Bitiş Yılı'></td>
                <td><cf_get_lang dictionary_id='31482.Not Ort'>.</td>
                <td><cf_get_lang dictionary_id='57995.Bölüm'></td>
                <td><input name="record_numb_edu" id="record_numb_edu" type="hidden" value="0"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_add_edu_info&ctrl_edu=0','medium');"><img src="/images/plus_list.gif" title="<cf_get_lang dictionary_id='31555.Eğitim Bilgisi Ekle'>" border="0"></a></td>
            </tr>
                <input type="hidden" name="edu_type" id="edu_type" value="">
                <input type="hidden" name="edu_id" id="edu_id" value="">
                <input type="hidden" name="edu_name" id="edu_name" value="">
                <input type="hidden" name="edu_start" id="edu_start" value="">
                <input type="hidden" name="edu_finish" id="edu_finish" value="">
                <input type="hidden" name="edu_rank" id="edu_rank" value="">
                <input type="hidden" name="edu_high_part_id" id="edu_high_part_id" value="">
                <input type="hidden" name="edu_part_id" id="edu_part_id" value="">
                <input type="hidden" name="edu_part_name" id="edu_part_name" value="">
                <input type="hidden" name="is_edu_continue" id="is_edu_continue" value="">
        </table>
    </div> 
    <div class="table-responsive">
        <table class="table table-borderless">
            
            <tr class="main-bg-color">
                <td><cf_get_lang dictionary_id='33172.Yabancı Dil'></td>
                <td><cf_get_lang dictionary_id='58996.Dil'></td>
                <td><cf_get_lang dictionary_id='31304.Konuşma'></td>
                <td><cf_get_lang dictionary_id='35164.Anlama'></td>
                <td><cf_get_lang dictionary_id='31306.Yazma'></td>
                <td><cf_get_lang dictionary_id='31307.Öğrenildiği Yer'></td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id='58996.Dil'> 1</td>
                <td>
                    <select class="form-control" name="lang1" id="lang1">
                        <option value=""><cf_get_lang dictionary_id='35167.Dil Seçiniz'>
                        <cfoutput query="get_languages">
                            <option value="#language_id#">#language_set# 
                        </cfoutput>
                    </select>
                </td>
                <td>
                    <select class="form-control" name="lang1_speak" id="lang1_speak">
                        <cfoutput query="know_levels">
                            <option value="#knowlevel_id#">#knowlevel# 
                        </cfoutput>
                    </select>
                </td>
                <td>
                    <select class="form-control" name="lang1_mean" id="lang1_mean">
                        <cfoutput query="know_levels">
                            <option value="#knowlevel_id#">#knowlevel# 
                        </cfoutput>
                    </select>
                </td>
                <td>
                    <select class="form-control" name="lang1_write" id="lang1_write">
                        <cfoutput query="know_levels">
                            <option value="#knowlevel_id#">#knowlevel# 
                        </cfoutput>
                    </select>
                </td>
                <td><input type="text" class="form-control" name="lang1_where" id="lang1_where" value="" maxlength="50"></td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id='58996.Dil'> 2</td>
                <td>
                    <select class="form-control" name="lang2" id="lang2">
                        <option value=""><cf_get_lang dictionary_id='35167.Dil Seçiniz'>
                        <cfoutput query="get_languages">
                            <option value="#language_id#">#language_set# 
                        </cfoutput>
                    </select>
                </td>
                <td>
                    <select class="form-control" name="lang2_speak" id="lang2_speak">
                        <cfoutput query="know_levels">
                        <option value="#knowlevel_id#">#knowlevel# 
                        </cfoutput>
                    </select>
                </td>
                <td>
                    <select class="form-control" name="lang2_mean" id="lang2_mean">
                        <cfoutput query="know_levels">
                            <option value="#knowlevel_id#">#knowlevel# 
                        </cfoutput>
                    </select>
                </td>
                <td>
                    <select class="form-control" name="lang2_write" id="lang2_write">
                        <cfoutput query="know_levels">
                            <option value="#knowlevel_id#">#knowlevel# 
                        </cfoutput>
                    </select>
                </td>
                <td><input type="text" class="form-control" name="lang2_where" id="lang2_where" value="" maxlength="50"></td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id='58996.Dil'> 3</td>
                <td>
                    <select class="form-control" name="lang3" id="lang3">
                        <option value=""><cf_get_lang dictionary_id='35167.Dil Seçiniz'>
                        <cfoutput query="get_languages">
                            <option value="#language_id#">#language_set# 
                        </cfoutput>
                    </select>
                </td>
                <td>
                    <select class="form-control" name="lang3_speak" id="lang3_speak">
                        <cfoutput query="know_levels">
                            <option value="#knowlevel_id#">#knowlevel# 
                        </cfoutput>
                    </select>
                </td>
                <td>
                    <select class="form-control" name="lang3_mean" id="lang3_mean">
                        <cfoutput query="know_levels">
                            <option value="#knowlevel_id#">#knowlevel# 
                        </cfoutput>
                    </select>
                </td>
                <td>
                    <select class="form-control" name="lang3_write" id="lang3_write">
                        <cfoutput query="know_levels">
                            <option value="#knowlevel_id#">#knowlevel# 
                        </cfoutput>
                    </select>
                </td>
                <td><input type="text" class="form-control" name="lang3_where" id="lang3_where" value="" maxlength="50"></td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id='58996.Dil'> 4</td>
                <td>
                    <select class="form-control" name="lang4" id="lang4">
                        <option value=""><cf_get_lang dictionary_id='35167.Dil Seçiniz'> 
                        <cfoutput query="get_languages">
                            <option value="#language_id#">#language_set# 
                        </cfoutput>
                    </select>
                </td>
                <td>
                    <select class="form-control" name="lang4_speak" id="lang4_speak">
                        <cfoutput query="know_levels">
                            <option value="#knowlevel_id#">#knowlevel# 
                        </cfoutput>
                    </select>
                </td>
                <td>
                    <select class="form-control" name="lang4_mean" id="lang4_mean">
                        <cfoutput query="know_levels">
                            <option value="#knowlevel_id#">#knowlevel# 
                        </cfoutput>
                    </select>
                </td>
                <td>
                    <select class="form-control" name="lang4_write" id="lang4_write">
                        <cfoutput query="know_levels">
                            <option value="#knowlevel_id#">#knowlevel# 
                        </cfoutput>
                    </select>
                </td>
                <td><input type="text" class="form-control" name="lang4_where" id="lang4_where" value="" maxlength="50"></td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id='58996.Dil'> 5</td>
                <td>
                    <select class="form-control" name="lang5" id="lang5">
                        <option value=""><cf_get_lang dictionary_id='35167.Dil Seçiniz'> 
                        <cfoutput query="get_languages">
                            <option value="#language_id#">#language_set# 
                        </cfoutput>
                    </select>
                </td>
                <td>
                    <select class="form-control" name="lang5_speak" id="lang5_speak">
                        <cfoutput query="know_levels">
                            <option value="#knowlevel_id#">#knowlevel# 
                        </cfoutput>
                    </select>
                </td>
                <td>
                    <select class="form-control" name="lang5_mean" id="lang5_mean">
                        <cfoutput query="know_levels">
                            <option value="#knowlevel_id#">#knowlevel# 
                        </cfoutput>
                    </select>
                </td>
                <td>
                    <select class="form-control" name="lang5_write" id="lang5_write">
                        <cfoutput query="know_levels">
                            <option value="#knowlevel_id#">#knowlevel# 
                        </cfoutput>
                    </select>
                </td>
                <td><input type="text" class="form-control" name="lang5_where" id="lang5_where" value="" maxlength="50"></td>
            </tr>
        </table>
    </div> 
          
    <!--- Eğitim  bitti  --->
        
    <!--- Deneyim --->
            
    <div class="table-responsive">
        <table id="table_work_info" class="table table-borderless">
            <input type="hidden" name="row_count" id="row_count" value="0">
            <tr>
            <td colspan="7" class="font-weight-bold"><cf_get_lang dictionary_id='31527.Deneyim Bilgileri'></td>
            </tr>
            <tr class="main-bg-color">
                <td><cf_get_lang dictionary_id='31549.Çalışılan Yer'></td>
                <td><cf_get_lang dictionary_id='58497.Pozisyon'></td>
                <td><cf_get_lang dictionary_id='57579.Sektör'></td>
                <td><cf_get_lang dictionary_id='57571.Ünvan'></td>
                <td><cf_get_lang dictionary_id='57655.Başlama Tarihi'></td>
                <td><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></td>
                <td><input type="hidden" name="record_numb" id="record_numb" value="0"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_upd_work_info&control=0</cfoutput>','medium');"><img src="/images/button_gri.gif" title="<cf_get_lang dictionary_id='31526.İş Tecrübesi Ekle'>" border="0"></a></td>
            </tr>
                <input type="hidden" name="exp_name" id="exp_name" value="">
                <input type="hidden" name="exp_position" id="exp_position" value="">
                <input type="hidden" name="exp_sector_cat" id="exp_sector_cat" value="">
                <input type="hidden" name="exp_task_id" id="exp_task_id" value="">
                <input type="hidden" name="exp_start" id="exp_start" value="">
                <input type="hidden" name="exp_finish" id="exp_finish" value="">
                <input type="hidden" name="exp_telcode" id="exp_telcode" value="">
                <input type="hidden" name="exp_tel" id="exp_tel" value="">
                <input type="hidden" name="exp_salary" id="exp_salary" value="">
                <input type="hidden" name="exp_extra_salary" id="exp_extra_salary" value="">
                <input type="hidden" name="exp_extra" id="exp_extra" value="">
                <input type="hidden" name="exp_reason" id="exp_reason" value="">
                <input type="hidden" name="is_cont_work" id="is_cont_work" value="">
        </table>
    </div>
           
    <!--- deneyim bitti --->
    <!---hobi--->
    <div class="table-responsive">
        <table class="table table-borderless">
            <tr>
                <td colspan="4" class="font-weight-bold"><cf_get_lang dictionary_id='31697.Özel İlgi Alanları'> - <cf_get_lang dictionary_id='31300.Üye Olunan Klüp Ve Dernekler'></td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id='31697.Özel İlgi Alanları'></td>
                <td colspan="2"><textarea class="form-control" name="hobby" id="hobby" maxlength="150" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message1#</cfoutput>" style="width:250px;"></textarea></td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id='31300.Üye Olunan Klüp Ve Dernekler'></td>
                <td><textarea class="form-control" name="club" id="club" maxlength="250" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message1#</cfoutput>" style="width:250px;"></textarea></td>
            </tr>
        </table>
    </div>
          
    <!---//hobi--->

    <!---çalışmak istediği dep--->
    <div class="table-responsive">
        <table class="table table-borderless">
            <tr>
                <td colspan="4"><strong><cf_get_lang dictionary_id='35474.Çalışmak İstenilen Birim'></strong>&nbsp;&nbsp;<cf_get_lang dictionary_id='31700.(Öncelik sıralarını yandaki kutulara yazınız...)'></td>
            </tr>
            <cfset GET_CV_UNIT = get_components.GET_CV_UNIT()>
            <cfif get_cv_unit.recordcount>
                <cfoutput query="get_cv_unit">
                    <cfif get_cv_unit.currentrow-1 mod 3 eq 0><tr></cfif>
                    <td>#get_cv_unit.unit_name#</td>
                    <cfsavecontent variable="alert"><cf_get_lang dictionary_id='33933.Sayı Giriniz'></cfsavecontent>
                    <td><cfinput type="text" class="form-control" name="unit#get_cv_unit.unit_id#" value="" validate="integer" message="#alert#" maxlength="1" style="width:40px;" onchange="seviye_kontrol(this)"></td>
                    <cfif get_cv_unit.currentrow mod 3 eq 0 and get_cv_unit.currentrow-1 neq 0></tr></cfif>	  
                </cfoutput>
            <cfelse>
                <tr>
                    <td><cf_get_lang dictionary_id='31702.Sisteme kayıtlı birim yok'>.</td>
                </tr>
            </cfif>
        </table>
    </div>
    <!---//calışmak istediği--->
    <!--- araçlar --->
    
    <!---- Ek --->
    <div class="table-responsive">
        <table class="table table-borderless">
            <tr>
                <td><strong><cf_get_lang dictionary_id='31703.Çalışmak İstediğiniz Şehir'></strong></td>
            </tr>
            <tr>
                <td rowspan="2">
                    <select class="form-control" name="prefered_city" id="prefered_city" multiple>
                        <option value=""><cf_get_lang dictionary_id='31704.Tüm Türkiye'></option>
                        <cfoutput query="get_city">
                            <option value="#city_id#">#city_name#</option>
                        </cfoutput>
                    </select>
                </td>
            </tr>
            <tr>
                <td>
                    <table>
                        <tr>
                            <td><strong><cf_get_lang dictionary_id='31705.Seyahat Edebilir misiniz'>?</strong></td>
                            <td>
                                <input type="radio" name="is_trip" id="is_trip" value="1"><cf_get_lang_main no='83.Evet'>
                                <input type="radio" name="is_trip" id="is_trip" value="0" checked><cf_get_lang_main no='84.Hayır'>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td><strong><cf_get_lang dictionary_id='31707.Eklemek İstedikleriniz'></strong></td>
            </tr>
            <tr>
                <td colspan="2">
                    <textarea class="form-control" name="applicant_notes" id="applicant_notes" maxlength="300" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message1#</cfoutput>" cols="45" rows="5" style="width:530px;"></textarea>
                </td>
            </tr>
        </table>
    </div>        
    <!--- <cf_workcube_buttons is_upd='0'> --->
    <cf_workcube_buttons is_insert='1'	data_action="/V16/objects2/career/cfc/add_cv:add_cv" next_page="/welcome">
</cfform>
<br/>
<form name="form_work_info" method="post" action="">
	<input type="hidden" name="exp_name_new" id="exp_name_new" value="">
	<input type="hidden" name="exp_position_new" id="exp_position_new" value="">
	<input type="hidden" name="exp_sector_cat_new" id="exp_sector_cat_new" value="">
	<input type="hidden" name="exp_task_id_new" id="exp_task_id_new" value="">
	<input type="hidden" name="exp_start_new" id="exp_start_new" value="">
	<input type="hidden" name="exp_finish_new" id="exp_finish_new" value="">
	<input type="hidden" name="exp_telcode_new" id="exp_telcode_new" value="">
	<input type="hidden" name="exp_tel_new" id="exp_tel_new" value="">
	<input type="hidden" name="exp_salary_new" id="exp_salary_new" value="">
	<input type="hidden" name="exp_extra_salary_new" id="exp_extra_salary_new" value="">
	<input type="hidden" name="exp_extra_new" id="exp_extra_new" value="">
	<input type="hidden" name="exp_reason_new" id="exp_reason_new" value="">
	<input type="hidden" name="is_cont_work_new" id="is_cont_work_new" value="">
</form>
<br/>
<form name="form_edu_info" method="post" action="">
	<input type="hidden" name="edu_type_new" id="edu_type_new" value="">
	<input type="hidden" name="edu_id_new" id="edu_id_new" value="">
	<input type="hidden" name="edu_name_new" id="edu_name_new" value="">
	<input type="hidden" name="edu_start_new" id="edu_start_new" value="">
	<input type="hidden" name="edu_finish_new" id="edu_finish_new" value="">
	<input type="hidden" name="edu_rank_new" id="edu_rank_new" value="">
	<input type="hidden" name="edu_high_part_id_new" id="edu_high_part_id_new" value="">
	<input type="hidden" name="edu_part_id_new" id="edu_part_id_new" value="">
	<input type="hidden" name="edu_part_name_new" id="edu_part_name_new" value="">
	<input type="hidden" name="is_edu_continue_new" id="is_edu_continue_new" value="">
</form>

<script type="text/javascript">
	document.getElementById('name').focus();
    function pencere_ac_city()
	{
		x = document.employe_detail.homecountry.selectedIndex;
		if (document.employe_detail.homecountry[x].value == "")
		{
			alert("<cf_get_lang no='31.İlk Olarak Ülke Seçmelisiniz'> !");
		}	
		else
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_dsp_city&field_id=employe_detail.homecity&field_name=employe_detail.homecity_name&country_id=' + document.getElementById('homecountry').value,'small');
		}
	}
	<!---özürlü seviyesi select pasif aktif yapma--->
	function seviye()
	{
		if(document.getElementById('defected_level').disabled==true)
		{
			document.getElementById('defected_level').disabled=false;
		}
		else
		{
			document.getElementById('defected_level').disabled=true;
		}
	}
	
	function pencere_ac()
	{
		x = document.employe_detail.homecountry.selectedIndex;
		if (document.employe_detail.homecountry[x].value == "")
		{
			alert("<cf_get_lang no='31.İlk Olarak Ülke Seçmelisiniz'>.");
		}	
		else if(document.getElementById('homecity').value == "")
		{
			alert("<cf_get_lang no='32.İl Seçiniz'> !");
		}
		else
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_dsp_county&field_id=employe_detail.county_id&field_name=employe_detail.homecounty&city_id=' + document.getElementById('homecity').value,'small');
		}
	}
	
	
	
	<cfoutput>
		<cfif get_cv_unit.recordcount>
			unit_count=#get_cv_unit.recordcount#;
		<cfelse>
			unit_count=0;
		</cfif>
	</cfoutput>
	
	function seviye_kontrol(nesne)
	{
		for(var j=1;j<=unit_count;j++)
		{
			diger_nesne=eval("document.getElementById('unit"+j+"')");
			if(diger_nesne!=nesne)
			{
				if(nesne.value==diger_nesne.value && diger_nesne.value.length!=0)
				{
					alert("<cf_get_lang no='868.İki tane aynı seviye giremezsiniz'>!");
					diger_nesne.value='';
				}
			}
		}
	}
	
	function kontrol()
	{
		var obj =  document.getElementById('photo').value;
		if ((obj != "") && !((obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'jpg')   || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'gif') || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'png'))){
			alert("<cf_get_lang no='515.Lütfen bir resim dosyası(gif,jpg veya png) giriniz'>!!");        
			return false;
		}
	}
	
	function tecilli_fonk(gelen)
	{
		if (gelen == 4)
		{
			Tecilli.style.display='';
			Yapti.style.display='none';
			Muaf.style.display='none';
		}
		else if(gelen == 1)
		{
			Yapti.style.display='';
			Tecilli.style.display='none';
			Muaf.style.display='none';
		}
		else if(gelen == 2)
		{
			Muaf.style.display='';
			Tecilli.style.display='none';
			Yapti.style.display='none';
		}
		else
		{
			Tecilli.style.display='none';
			Yapti.style.display='none';
			Muaf.style.display='none';
		}
	}
	
	row_count=0;
	satir_say=0;
	function sil(sy)
	{
		var my_element=eval("document.getElementById('row_kontrol"+sy+"')");
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
		satir_say--;
	}
	function gonder(exp_name,exp_position,exp_start,exp_finish,exp_sector_cat,exp_task_id,exp_telcode,exp_tel,exp_salary,exp_extra_salary,exp_extra,exp_reason,control,my_count,is_cont_work)
	{
		if(control == 1)
		{
			eval("document.getElementById('exp_name"+my_count+"')").value=exp_name;
			eval("document.getElementById('exp_position"+my_count+"')").value=exp_position;
			eval("document.getElementById('exp_start"+my_count+"')").value=exp_start;
			eval("document.getElementById('exp_finish"+my_count+"')").value=exp_finish;
			eval("document.getElementById('exp_sector_cat"+my_count+"')").value=exp_sector_cat;
			if(exp_sector_cat != '')
			{
				var get_emp_cv_new = wrk_safe_query("obj2_get_emp_cv_new",'dsn',0,exp_sector_cat);
				var exp_sector_cat_name = get_emp_cv_new.SECTOR_CAT;
			}
			else
				var exp_sector_cat_name = '';
				
			eval("document.getElementById('exp_sector_cat_name"+my_count+"')").value=exp_sector_cat_name;
			eval("document.getElementById('exp_task_id"+my_count+"')").value=exp_task_id;
			if(exp_task_id != '')
			{
				var get_emp_task_cv_new = wrk_safe_query("obj2_get_emp_task_cv_new",'dsn',0,exp_task_id);
				/*if(get_emp_task_cv_new.recordcount)*/
				var exp_task_name = get_emp_task_cv_new.PARTNER_POSITION;
			}
			else
				var exp_task_name = '';
				
			eval("document.getElementById('exp_task_name"+my_count+"')").value=exp_task_name;
			eval("document.getElementById('exp_telcode"+my_count+"')").value=exp_telcode;
			eval("document.getElementById('exp_tel"+my_count+"')").value=exp_tel;
			eval("document.getElementById('exp_salary"+my_count+"')").value=exp_salary;
			eval("document.getElementById('exp_extra_salary"+my_count+"')").value=exp_extra_salary;
			eval("document.getElementById('exp_extra"+my_count+"')").value=exp_extra;
			eval("document.getElementById('exp_reason"+my_count+"')").value=exp_reason;
			eval("document.getElementById('is_cont_work"+my_count+"')").value=is_cont_work;
		}
		else
		{
			row_count++;
			employe_detail.row_count.value = row_count;
			satir_say++;
			var new_Row;
			var new_Cell;
			get_emp_cv='';
			new_Row = document.getElementById("table_work_info").insertRow(document.getElementById("table_work_info").rows.length);
			new_Row.setAttribute("name","frm_row" + row_count);
			new_Row.setAttribute("id","frm_row" + row_count);		
			new_Row.setAttribute("NAME","frm_row" + row_count);
			new_Row.setAttribute("ID","frm_row" + row_count);		
			new_Cell = new_Row.insertCell();
			new_Cell.innerHTML = '<input type="text" name="exp_name' + row_count + '" id="exp_name' + row_count + '" value="'+ exp_name +'" style="width:150px;" class="boxtext" readonly>';
			new_Cell = new_Row.insertCell();
			new_Cell.innerHTML = '<input type="text" name="exp_position' + row_count + '" id="exp_position' + row_count + '" value="'+ exp_position +'" style="width:100px;" class="boxtext" readonly>';
			if(exp_sector_cat != '')
			{
				var get_emp_cv = wrk_safe_query("obj2_get_emp_cv_new",'dsn',0,exp_sector_cat);
				/*if(get_emp_cv.recordcount)*/
					var exp_sector_cat_name = get_emp_cv.SECTOR_CAT;
			}
			else
				var exp_sector_cat_name = '';
			new_Cell = new_Row.insertCell();
			new_Cell.innerHTML = '<input type="text" name="exp_sector_cat_name' + row_count + '" id="exp_sector_cat_name' + row_count + '" value="'+exp_sector_cat_name+'" style="width:120px;" class="boxtext" readonly>';
			if(exp_task_id != '')
			{
				var get_emp_task_cv = wrk_safe_query("obj2_get_emp_task_cv_new",'dsn',0,exp_task_id);
				/*if(get_emp_task_cv.recordcount)*/
				var exp_task_name = get_emp_task_cv.PARTNER_POSITION;
			}
			else
				var exp_task_name = '';
			new_Cell = new_Row.insertCell();
			new_Cell.innerHTML = '<input type="text" name="exp_task_name' + row_count + '" id="exp_task_name' + row_count + '" value="'+exp_task_name+'" style="width:120px;" class="boxtext" readonly>';
			new_Cell = new_Row.insertCell();
			new_Cell.innerHTML = '<input type="text" name="exp_start' + row_count + '" id="exp_start' + row_count + '" value="'+ exp_start +'" style="width:100px;" class="boxtext" readonly>';
			new_Cell = new_Row.insertCell();
			new_Cell.innerHTML = '<input type="text" name="exp_finish' + row_count + '" id="exp_finish' + row_count + '" value="'+ exp_finish +'" style="width:85px;" class="boxtext" readonly>';
			new_Cell = new_Row.insertCell();
			new_Cell.innerHTML = '<a href="javascript://" onClick="gonder_add('+row_count+');"><img src="/images/update_list.gif" border="0" align="absbottom"></a>';
			new_Cell = new_Row.insertCell();
			new_Cell.innerHTML = '<input  type="hidden" value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" ><a href="javascript://" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0"></a>';
			new_Cell = new_Row.insertCell();
			new_Cell.innerHTML = '<input type="hidden" name="exp_sector_cat' + row_count + '" id="exp_sector_cat' + row_count + '" value="'+ exp_sector_cat +'">';
			new_Cell = new_Row.insertCell();
			new_Cell.innerHTML = '<input type="hidden" name="exp_task_id' + row_count + '" id="exp_task_id' + row_count + '" value="'+ exp_task_id +'">';
			new_Cell = new_Row.insertCell();
			new_Cell.innerHTML = '<input type="hidden" name="exp_telcode' + row_count + '" id="exp_telcode' + row_count + '" value="'+ exp_telcode +'">';
			new_Cell = new_Row.insertCell();
			new_Cell.innerHTML = '<input type="hidden" name="exp_tel' + row_count + '" id="exp_tel' + row_count + '" value="'+ exp_tel +'">';
			new_Cell = new_Row.insertCell();
			new_Cell.innerHTML = '<input type="hidden" name="exp_salary' + row_count + '" id="exp_salary' + row_count + '" value="'+ exp_salary +'">';
			new_Cell = new_Row.insertCell();
			new_Cell.innerHTML = '<input type="hidden" name="exp_extra_salary' + row_count + '" id="exp_extra_salary' + row_count + '" value="'+ exp_extra_salary +'">';
			new_Cell = new_Row.insertCell();
			new_Cell.innerHTML = '<input type="hidden" name="exp_extra' + row_count + '" id="exp_extra' + row_count + '" value="'+ exp_extra +'">';
			new_Cell = new_Row.insertCell();
			new_Cell.innerHTML = '<input type="hidden" name="exp_reason' + row_count + '" id="exp_reason' + row_count + '" value="'+ exp_reason +'">';
			new_Cell = new_Row.insertCell();
			new_Cell.innerHTML = '<input type="hidden" name="is_cont_work' + row_count + '" id="is_cont_work' + row_count + '" value="'+ is_cont_work +'">';
		}
	}
	
	function gonder_add(count)
	{
		document.getElementById('exp_name_new').value = eval("document.getElementById('exp_name"+count+"')").value;
		document.getElementById('exp_position_new').value = eval("document.getElementById('exp_position"+count+"')").value;
		document.getElementById('exp_sector_cat_new').value = eval("document.getElementById('exp_sector_cat"+count+"')").value;
		document.getElementById('exp_task_id_new').value = eval("document.getElementById('exp_task_id"+coun+"')").value;
		document.getElementById('exp_start_new').value = eval("document.getElementById('exp_start"+count+"')").value;
		document.getElementById('exp_finish_new').value = eval("document.getElementById('exp_finish"+count+"')").value;
		document.getElementById('exp_telcode_new').value = eval("document.getElementById('exp_telcode"+count+"')").value;
		document.getElementById('exp_tel_new').value = eval("document.getElementById('exp_tel"+count+"')").value;
		document.getElementById('exp_salary_new').value = eval("document.getElementById('exp_salary"+count+"')").value;
		document.getElementById('exp_extra_salary_new').value = eval("document.getElementById('exp_extra_salary"+count+"')").value;
		document.getElementById('exp_extra_new').value = eval("document.getElementById('exp_extra"+count+"')").value;
		document.getElementById('exp_reason_new').value = eval("document.getElementById('exp_reason"+count+"')").value;
		document.getElementById('is_cont_work_new').value = eval("document.getElementById('is_cont_work"+count+"')").value;
		windowopen('','large','add_kariyer_pop');
		form_work_info.target='add_kariyer_pop';
		form_work_info.action = '<cfoutput>#request.self#?fuseaction=objects2.popup_upd_work_info&my_count='+count+'&control=1</cfoutput>';
		form_work_info.submit();	
	}
	

</script>
