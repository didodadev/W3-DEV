<cfset company_cmp = createObject("component","V16.member.cfc.member_company")>
<cfif isDefined("session.pp")>
    <cfset company_id = session.pp.company_id>
    <cfset language = session.pp.language>
<cfelseif isDefined("session.ww")>
    <cfset company_id = session.ww.company_id>
    <cfset language = session.ww.language>
</cfif>
<cfscript>
    get_company = company_cmp.get_company_list_fnc_protein(
        cpid : company_id
    );

    get_partner = company_cmp.get_partner_(
        cpid : company_id
    );

    get_partner_positions = company_cmp.GET_PARTNER_POSITIONS();

    GET_COUNTRY = company_cmp.GET_COUNTRY_(
        language : language
    );
</cfscript>

<cfoutput query="get_company">

    <cfquery name="get_partner_" dbtype="query">
        SELECT * FROM get_partner WHERE PARTNER_ID = #MANAGER_PARTNER_ID#
    </cfquery>

    <cfset get_city = company_cmp.GET_CITY(
        event:"upd",
        country_id:'#iIf(len(COUNTRY),"COUNTRY",DE(""))#'
    )>

   
    <cfform name="add_company" method="post">
        <cfinput type="hidden" name="company_id" value="#company_id#">
        <div class="row mx-auto mt-3">
            <div class="col-md-12">
                <h6 class="mb-3 header-color"><cf_get_lang dictionary_id='32212.Şirket Bilgileri'></h6>
                
                <div class="row mb-3">
                    <div class="col-md-12 col-lg-8 col-xl-6 pr-1">
                        <div class="form-group mb-3">
                            <label class="font-weight-bold"><cf_get_lang dictionary_id='57571.Title'></label>
                            <input type="text" name="fullname" id="fullname" class="form-control" placeholder="<cf_get_lang dictionary_id='61823.?'>" value="#FULLNAME#">
                        </div>
                    </div>
                </div>

                <div class="form-row mb-3">
                    <div class="form-group col-md-6 col-lg-4 col-xl-3 mb-3">
                        <label class="font-weight-bold"><cf_get_lang dictionary_id='58762.Tax Office'></label>
                        <input type="text" name="taxoffice" id="textoffice" class="form-control" placeholder="<cf_get_lang dictionary_id='61824.?'>" value="#TAXOFFICE#">
                    </div>
                    <div class="form-group col-md-6 col-lg-4 col-xl-3 mb-3">
                        <label class="font-weight-bold"><cf_get_lang dictionary_id='57752.TIN'></label>
                        <input type="text" name="taxno" id="taxno" class="form-control" placeholder="<cf_get_lang dictionary_id='61824.?'>" value="#TAXNO#">
                    </div>
                </div>
                
                <div class="row mb-3">
                    <div class="col-md-12 col-lg-8 col-xl-6 pr-1">
                        <div class="form-group mb-3">
                            <label class="font-weight-bold"><cf_get_lang dictionary_id='51251.Web Address'></label>
                            <input type="text" name="homepage" id="homepage" class="form-control" placeholder="<cf_get_lang dictionary_id='61824.?'>" value="#HOMEPAGE#">
                        </div>
                    </div>
                </div>    

                <div class="row mb-3">
                    <div class="col-md-12 col-lg-8 col-xl-6 pr-1">
                        <div class="form-group mb-3">
                            <label class="font-weight-bold"><cf_get_lang dictionary_id='39186.E-Mail'></label>
                            <input type="email" name="company_email" id="company_email" class="form-control" placeholder="<cf_get_lang dictionary_id='61824.?'>" value="#COMPANY_EMAIL#">
                        </div>
                    </div>
                </div>     

                <div class="form-row mb-3">
                    <div class="form-group col-md-6 col-lg-4 col-xl-3 mb-3">
                        <label class="font-weight-bold"><cf_get_lang dictionary_id='61819.?'></label>
                        <input type="text" name="company_telcode" id="company_telcode" class="form-control" placeholder="<cf_get_lang dictionary_id='61824.?'>" value="#COMPANY_TELCODE#">
                    </div>
                    <div class="form-group col-md-6 col-lg-4 col-xl-3 mb-3">
                        <label class="font-weight-bold">&nbsp;</label>
                        <input type="text" name="company_tel1" id="company_tel1" class="form-control" placeholder="<cf_get_lang dictionary_id='61824.?'>" value="#COMPANY_TEL1#">
                    </div>
                </div>
                
                <h6 class="mb-3 header-color"><cf_get_lang dictionary_id='61820.?'></h6>
                <div class="row">
                    <div class="col-md-6 col-lg-6 col-xl-4">
                        <div class="form-group mb-3">
                            <label class="font-weight-bold"><cf_get_lang dictionary_id='57631.Name'><cf_get_lang dictionary_id='58726.Last Name'></label>
                            <select class="form-control" name="manager_partner_id" id="manager_partner_id">
                                <option><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfloop query="get_partner">
                                    <option value="#partner_id#" <cfif partner_id is get_company.manager_partner_id>selected</cfif>>#company_partner_name# #company_partner_surname#</option>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                </div>

                <h6 class="mb-3 header-color"><cf_get_lang dictionary_id='30324.Address Information'></h6>
                <div class="form-row">
                    <div class="form-group col-md-5 col-lg-4 col-xl-3">
                        <label class="font-weight-bold"><cf_get_lang dictionary_id='58219.Country'></label>
                        <select name="country" id="country" class="form-control" onchange="LoadCity(this.value,'city_id','county_id',0);">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfloop query="get_country">
                                <option value="#country_id#" <cfif country_id eq get_company.country>selected</cfif>>#country_name#</option>
                            </cfloop>
                        </select>
                    </div>
                </div>     
                    
                <div class="form-row">
                    <div class="form-group col-md-5 col-lg-4 col-xl-3 mb-3">
                        <label class="font-weight-bold"><cf_get_lang dictionary_id='57971.Province'></label>
                        <select name="city_id" id="city_id" class="form-control" onchange="LoadCounty(this.value,'county_id','company_telcode')">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfloop query="get_city">
                                <option value="#city_id#" <cfif get_company.city eq city_id>selected</cfif>>#city_name#</option>
                            </cfloop>
                        </select>
                    </div>

                    <div class="form-group col-md-5 col-lg-4 col-xl-3 mb-3">
                        <label class="font-weight-bold"><cf_get_lang dictionary_id='58723.Adres'></label>
                        <input type="text" name="company_address" id="company_address" class="form-control" placeholder="<cf_get_lang dictionary_id='59266.Avenue'>-<cf_get_lang dictionary_id='30630.Street'>" value="#COMPANY_ADDRESS#">
                    </div>
                </div>

                <div class="form-row mb-3">
                    <div class="form-group col-md-5 col-lg-4 col-xl-3 mb-3">
                        <label class="font-weight-bold"><cf_get_lang dictionary_id='58638.İlçe'></label>
                        <select  name="county_id" id="county_id" class="form-control" onChange="LoadDistrict(this.value,'district_id');">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfif len(city)>
                                <cfset GET_COUNTY = company_cmp.GET_COUNTY(city_id:city)>
                                <cfloop query="get_county">
                                    <option value="#county_id#" <cfif get_company.county eq county_id>selected</cfif>>#county_name#</option>
                                </cfloop>
                            </cfif>
                        </select>
                    </div>
                    <div class="form-group col-md-5 col-lg-4 col-xl-3 mb-3">
                        <label class="font-weight-bold"><cf_get_lang dictionary_id='58132.Semt'></label>
                        <input type="text" name="semt" id="semt" class="form-control" placeholder="<cf_get_lang dictionary_id='58132.Semt'>" value="#SEMT#">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group col-md-5 col-lg-4 col-xl-3 mb-3">
                        <label class="font-weight-bold"><cf_get_lang dictionary_id='58735.Neighborhood'></label>
                        <select name="district_id" id="district_id" class="form-control" onchange="get_ims_code();">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfif len(county)>
                                <cfset get_district_name = company_cmp.get_district_name(county_id:county)>
                                <cfloop query="get_district_name">
                                    <option value="#district_id#" <cfif get_company.district_id eq district_id>selected</cfif>>#district_name#</option>
                                </cfloop>
                            </cfif>
                        </select>
                    </div>

                    <div class="form-group col-md-5 col-lg-4 col-xl-3 mb-3">
                        <label class="font-weight-bold"><cf_get_lang dictionary_id='57472.Zip Code'></label>
                        <div class="col-md-8 col-lg-6 px-0">
                            <input type="text" name="company_postcode" id="company_postcode" class="form-control" placeholder="<cf_get_lang dictionary_id='61824.?'>" value="#COMPANY_POSTCODE#">
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <cf_workcube_buttons is_insert="1" data_action="/V16/member/cfc/member_company:upd_member_protein" next_page="/company" >
                </div>
            </div>
        </div>
    </cfform>
            
</cfoutput>

<script type="text/javascript">

    function get_ims_code() {
        get_ims_code_ = wrk_safe_query("mr_get_ims_code","dsn",0,document.getElementById('district_id').value);
        get_district_ = wrk_safe_query("mr_get_district","dsn",0,document.getElementById('district_id').value);
        if(get_ims_code_.IMS_CODE !=undefined && get_ims_code_.PART_NAME!=undefined)
        {		
            document.getElementById('semt').value=get_ims_code_.PART_NAME;
            document.getElementById('company_postcode').value=get_ims_code_.POST_CODE;
        }
        else if (get_district_.PART_NAME != undefined || get_district_.POST_CODE != undefined)
        {
            document.getElementById('semt').value = get_district_.PART_NAME;
            document.getElementById('company_postcode').value = get_district_.POST_CODE;
        }
        else
        {
            document.getElementById('semt').value = '';
            document.getElementById('company_postcode').value = '';
        }
    }

</script>