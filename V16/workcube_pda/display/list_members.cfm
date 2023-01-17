<cfif isDefined('xml_list_type') and xml_list_type eq 0>
    <cf_get_lang_set module_name="member">
    <cfquery name="GET_COUNTRY" datasource="#DSN#">
        SELECT
            COUNTRY_ID
        FROM
            SETUP_COUNTRY
        WHERE
            IS_DEFAULT = 1
    </cfquery>
    <table border="0" cellpadding="0" cellspacing="0" align="center" style="width:98%">
        <tr style="height:35px;">
            <td class="headbold">Üyeler</td>
            <td align="right"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=pda.form_add_company" class="txtsubmenu"><img src="/images/plus_list.gif" border="0" align="absmiddle" class="form_icon"></a></td>
        </tr>
    </table>
    <cfform id="form_add_company" name="form_add_company" method="post" action="" enctype="multipart/form-data"> 
        <table cellpadding="2" cellspacing="1" border="0" class="color-border" align="center" style="width:98%">	
            <tr>
                <td class="color-row">
                    <table align="center" style="width:99%">			 
                        <tr>
                            <td class="infotag" style="width:30%"><cf_get_lang_main no='159.Unvan'></td>
                            <td>
                                <input type="text" name="fullname" id="fullname" value="<cfif isdefined("attributes.fullname")><cfoutput>#attributes.fullname#</cfoutput></cfif>"  maxlength="250" style="width:172px;">
                                <a href="javascript://" onClick="get_turkish_letters_div('document.form_add_company.fullname','turkish_letters_div');"><img src="/images/plus_thin.gif" border="0" align="absmiddle" class="form_icon"></a>
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td><div id="turkish_letters_div"></div></td>
                        </tr>
                        <tr>
                            <td class="infotag"><cf_get_lang_main no='166.Yetkili'><cf_get_lang_main no='485.Ad'><cf_get_lang_main no='1138.Soyad'></td>
                            <td>
                                <input type="text" name="name" id="name" value="<cfif isdefined("attributes.name")><cfoutput>#attributes.name#</cfoutput></cfif>" maxlength="50" style="width:90px;">
                                <input type="text" name="surname" id="surname" value="<cfif isdefined("attributes.surname")><cfoutput>#attributes.surname#</cfoutput></cfif>" maxlength="50" style="width:92px;">
                            </td>
                        </tr>
                        <tr>
                            <td class="infotag">Kod/Telefon</td>
                            <td>
                                <input type="text" name="telcode" id="telcode" maxlength="5" onKeyup="isNumber(this);" onblur="isNumber(this);" value="" style="width:57px;">						
                                <input type="text" name="telno" id="telno" maxlength="7" onKeyup="isNumber(this);" onblur="isNumber(this);" value="<cfif isdefined("attributes.tel1")><cfoutput>#attributes.tel1#</cfoutput></cfif>" style="width:94px;">
                            </td>
                        </tr>
                        <tr>
                            <td class="infotag">Mobil Kod/Telefon</td>
                            <td>
                                <input type="text" name="mobile_telcode" id="mobile_telcode" maxlength="5"  onKeyup="isNumber(this);" onblur="isNumber(this);" value="<cfif isdefined("attributes.cep_telcod")><cfoutput>#attributes.cep_telcod#</cfoutput></cfif>" style="width:57px;">						
                                <input type="text" name="mobile_telno" id="mobile_telno" maxlength="7" onKeyup="isNumber(this);" onblur="isNumber(this);" value="<cfif isdefined("attributes.cep_tel")><cfoutput>#attributes.cep_tel#</cfoutput></cfif>" style="width:94px;">
                            </td>
                        </tr>
                        <input type="hidden" name="country" id="country" value="<cfoutput>#get_country.country_id#</cfoutput>">
                        <tr>
                            <td class="infotag">Şehir</td>
                            <td>
                                <input type="hidden" name="city_id" id="city_id" value="<cfif isdefined("attributes.city_id")><cfoutput>#attributes.city_id#</cfoutput></cfif>">
                                <input type="text" name="city" id="city" value="<cfif isdefined("attributes.city")><cfoutput>#attributes.city#</cfoutput></cfif>"  style="width:162px;"><!--- readonly --->
                                <a href="javascript://" onClick="get_city_div();"><img src="/images/buyutec.jpg" border="0" align="absmiddle" class="form_icon"></a>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <div id="city_div"></div>
                            </td>
                        </tr>
                        <tr>
                            <td class="infotag"><cf_get_lang_main no='1226.Ilçe'></td>
                            <td>
                                <input type="hidden" name="county_id" id="county_id" value="<cfif isdefined("attributes.county_id")><cfoutput>#attributes.county_id#</cfoutput></cfif>" readonly="">
                                <input type="text" name="county" id="county" value="<cfif isdefined("attributes.county")><cfoutput>#attributes.county#</cfoutput></cfif>" maxlength="30" style="width:162px;"><!--- readonly --->
                                <a href="javascript://" onClick="get_county_div();"><img src="/images/buyutec.jpg" border="0" align="absmiddle" class="form_icon"></a>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <div id="county_div"></div>
                            </td>
                        </tr>
                        <tr>
                            <td>Durum</td>
                            <td>
                                <select name="company_status" id="company_status" style="width:70px;">
                                    <option value="">Tümü</option>                            	
                                    <option value="1">Aktif</option>
                                    <option value="0">Pasif</option>
                                </select>
                            </td>
                        </tr>
                        <tr style="height:30px;">
                            <td>&nbsp;</td>
                            <td align="right">
                                <input type="button" onClick="kontrol_prerecord();" class="button" value="Listele">
                                <!--- <cf_workcube_buttons is_upd='0' add_function="kontrol_prerecord()"> --->
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <div id="kontrol_precompany_div"></div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <div id="kontrol_preconsumer_div"></div>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </cfform>
    <br/>
    <script type="text/javascript">
        function remove_adress()
        {
            document.getElementById('county_id').value = '';
            document.getElementById('county').value = '';
        }
        
        function get_city_div()//&field_id=form_add_company.city_id&field_name=form_add_company.city&field_phone_code=form_add_company.telcod+'&div_name='+'city_div'
        {
            goster(city_div);
            AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_get_city_div&is_my=0&country_id='+document.getElementById('country').value+'&keyword='+encodeURI(document.getElementById('city').value),'city_div');
            return remove_adress();
        }
        function add_city_div(city_id,city,phone_code)
        {
            document.getElementById('city_id').value = city_id;
            document.getElementById('city').value = city;
            document.getElementById('telcode').value = phone_code;
            gizle(city_div);
        }
        
        function get_county_div()//&field_id=form_add_company.county_id&field_name=form_add_company.county+'&div_name='+'county_div'
        {
            if(document.getElementById('city_id').value == "")
            {
                alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='1196.Il'>");
            }
            else
            {
                goster(county_div);
                AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_get_county_div&city_id=' + document.getElementById('city_id').value+'&keyword='+encodeURI(document.getElementById('county').value),'county_div');
            }
        }
        function add_county_div(county_id,county)
        {
            document.getElementById('county_id').value = county_id;
            document.getElementById('county').value = county;
            gizle(county_div);
        }
        
        function kontrol_prerecord()
        {
            if(document.getElementById('fullname').value == '' && document.getElementById('name').value == '' && document.getElementById('surname').value == '' && document.getElementById('telcode').value == '' && document.getElementById('telno').value == '' && document.getElementById('mobile_telcode').value == '' && document.getElementById('mobile_telno').value == '' && document.getElementById('city_id').value == '' && document.getElementById('county_id').value == '' && document.getElementById('city').value == '' && document.getElementById('county').value == '')
            {
                alert("Lütfen listelemek için en az bir alanda filtreleme yapınız !");
                return false;
            }
            if(document.getElementById('fullname').value != '' && document.form_add_company.fullname.value.length < 1)
            {
                alert("Lütfen Ünvan alanı için en az 1 karakter giriniz !");
                return false;
            }
            goster(kontrol_precompany_div);
            goster(kontrol_preconsumer_div);
            AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_list_company_div&is_my=0&fullname='+ document.getElementById('fullname').value +'&name=' + encodeURI(document.getElementById('name').value)  +'&surname=' + encodeURI(document.getElementById('surname').value) +'&telcode='+ document.getElementById('telcode').value +'&telno=' + document.getElementById('telno').value  +'&mobile_telcode='+ document.getElementById('mobile_telcode').value +'&mobile_telno=' + document.getElementById('mobile_telno').value +'&city_id=' + document.getElementById('city_id').value +'&county_id=' + document.getElementById('county_id').value +'&city=' + document.getElementById('city').value +'&county=' + document.getElementById('county').value+'','kontrol_precompany_div');		
            /*AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_list_consumers_div&type=1&name='+ document.getElementById('name').value +'&surname=' + document.getElementById('surname').value +'&telcode='+ document.getElementById('telcode').value +'&telno=' + document.getElementById('telno').value  +'&mobile_telcode='+ document.getElementById('mobile_telcode').value +'&mobile_telno=' + document.getElementById('mobile_telno').value +'&city_id=' + document.getElementById('city_id').value +'&county_id=' + document.getElementById('county_id').value +'&city=' + document.getElementById('city').value +'&county=' + document.getElementById('county').value+'','kontrol_preconsumer_div');	*/	
            return false;
        }
        
        document.getElementById('fullname').focus();
    </script>
    
    <cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
<cfelse>
	<cfinclude template="list_my_members.cfm">
</cfif>

