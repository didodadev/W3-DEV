<cfif not isdefined("get_id_card_cats")>
	<cfinclude template="../query/get_id_card_cats.cfm">
</cfif>
<cfquery name="get_hr_detail" datasource="#DSN#">
	SELECT
		ED.*,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		E.RECORD_EMP,
		E.UPDATE_EMP,
		E.RECORD_DATE,
		E.UPDATE_DATE
	FROM
		EMPLOYEES_DETAIL ED,
		EMPLOYEES E
	WHERE
		ED.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
		AND E.EMPLOYEE_ID = ED.EMPLOYEE_ID
</cfquery>
<cfquery name="GET_DRIVER_LIS" datasource="#DSN#">
	SELECT
		*
	FROM
		SETUP_DRIVERLICENCE
	ORDER BY
		LICENCECAT
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="55126.Kişisel Bilgiler"></cfsavecontent>
<cf_box title="#message# : <cfoutput>#get_hr_detail.employee_name# #get_hr_detail.employee_surname#</cfoutput>" scroll="1" closable="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="employe_personal" method="post" action="#request.self#?fuseaction=hr.emptypopup_upd_emp_personal">
    <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
        <cf_box_elements>
            <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-5 col-md-5 col-sm-5 col-xs-12">
                    <label><cf_get_lang dictionary_id ='56602.Sigara Kullanıyor musunuz'>?</label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <div class="checkbox checbox-switch">
                        <label>
                            <input type="checkbox" name="use_cigarette" id="use_cigarette" value="1" <cfif get_hr_detail.use_cigarette eq 1>checked</cfif>/>
                            <span></span>
                        </label>
                    </div>
                </div>
            </div>
            <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-5 col-md-5 col-sm-5 col-xs-12">
                    <label><cf_get_lang dictionary_id ='56139.Şehit Yakını Misiniz'></label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <div class="checkbox checbox-switch">
                        <label>
                            <input type="checkbox" name="martyr_relative" id="martyr_relative" value="1" <cfif get_hr_detail.martyr_relative eq 1>checked</cfif>/>
                            <span></span>
                        </label>
                    </div>
                </div>
            </div>
            <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-5 col-md-5 col-sm-5 col-xs-12">
                    <label><cf_get_lang dictionary_id='55614.Engelli'>?</label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                        <div class="checkbox checbox-switch">
                        <label>
                            <input type="checkbox" name="defected" id="defected" value="1" <cfif get_hr_detail.defected eq 1>checked</cfif> onClick="seviye();"/>
                            <span></span>
                        </label>
                    </div>
                    </div>
                    <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                        <select name="defected_level" id="defected_level" <cfif get_hr_detail.defected eq 0 or not get_hr_detail.recordcount>disabled</cfif>>
                            <cfloop from="0" to="100" index="a">
                                <cfoutput><option value="#a#">#a#%</option></cfoutput>
                                <cfif get_hr_detail.defected_level eq a>
                                    <cfoutput><option value="#a#" selected>#a#%</option></cfoutput>
                                </cfif>
                            </cfloop>
                        </select>
                    </div>
                </div>
            </div>
            <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-5 col-md-5 col-sm-5 col-xs-12">
                    <label><cf_get_lang dictionary_id='55628.Ek Kart/No'></label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                        <div class="col col-5 col-md-5 col-sm-5 col-xs-12">
                            <select name="identycard_cat" id="identycard_cat" style="width:80px;">
                                <cfoutput query="get_id_card_cats">
                                    <option value="#identycat_id#" <cfif get_hr_detail.identycard_cat eq identycat_id>selected</cfif>>#identycat# 
                                </cfoutput>
                            </select>
                        </div>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                            <cfinput type="text" name="identycard_no" maxlength="50"  value="#get_hr_detail.identycard_no#">
                        </div>
                    </div>
                </div>
            </div>
            <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-5 col-md-5 col-sm-5 col-xs-12">
                    <label><cf_get_lang dictionary_id='31670.Hüküm Giydi mi'>?</label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <div class="checkbox checbox-switch">
                        <label>
                            <input type="checkbox" name="sentenced" id="sentenced" value="1" <cfif get_hr_detail.sentenced eq 1>checked</cfif>/>
                            <span></span>
                        </label>
                    </div>
                </div>
            </div>
            <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-5 col-md-5 col-sm-5 col-xs-12">
                    <label><cf_get_lang dictionary_id='55963.Terör Mağdurumu'></label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <div class="checkbox checbox-switch">
                        <label>
                            <input type="checkbox" name="terror_wronged" id="terror_wronged" value="1" <cfif get_hr_detail.terror_wronged eq 1>checked</cfif>/>
                            <span></span>
                        </label>
                    </div>
                </div>
            </div>
            <div class="form-group col col-9 col-md-9 col-sm-9 col-xs-12">
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                    <label><cf_get_lang dictionary_id='55619.Askerlik'></label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <span><input type="radio" name="military_status" id="military_status" value="0" <cfif get_hr_detail.military_status eq 0>checked</cfif> onClick="tecilli_fonk(this.value)"><cf_get_lang dictionary_id='55624.Yapmadı'></span>
                    <span><input type="radio" name="military_status" id="military_status" value="1" <cfif get_hr_detail.military_status eq 1>checked</cfif> onClick="tecilli_fonk(this.value)"><cf_get_lang dictionary_id='55625.Yaptı'></span>
                    <span><input type="radio" name="military_status" id="military_status" value="2" <cfif get_hr_detail.military_status eq 2>checked</cfif> onClick="tecilli_fonk(this.value)"><cf_get_lang dictionary_id='55626.Muaf'></span>
                    <span><input type="radio" name="military_status" id="military_status" value="3" <cfif get_hr_detail.military_status eq 3>checked</cfif> onClick="tecilli_fonk(this.value)"><cf_get_lang dictionary_id='55627.Yabancı'></span>
                    <span><input type="radio" name="military_status" id="military_status" value="4" <cfif get_hr_detail.military_status eq 4>checked</cfif> onClick="tecilli_fonk(this.value)"><cf_get_lang dictionary_id='55340.Tecilli'></span>
                </div>
            </div>
            <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12" <cfif get_hr_detail.military_status neq 4></cfif> style="display:none" id="Tecilli">
                <div class="col col-5 col-md-5 col-sm-5 col-xs-12">
                    <label><cf_get_lang dictionary_id='55339.Tecil Gerekçesi'></label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <cfinput type="text" name="military_delay_reason" style="width:150px;" maxlength="30" value="#get_hr_detail.military_delay_reason#">
                    </div>
                    <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                        <label><cf_get_lang dictionary_id='55338.Tecil Süresi'></label>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='55338.Tecil Süresi'></cfsavecontent>
                            <cfinput type="text" style="width:65px;" name="military_delay_date" value="#dateformat(get_hr_detail.military_delay_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="military_delay_date"></span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12" <cfif get_hr_detail.military_status neq 1>style="display:none"</cfif> id="Yapti">
                <div class="col col-5 col-md-5 col-sm-5 col-xs-12">
                    <label><cf_get_lang dictionary_id ='56144.Terhis Tarihi'></label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='55796.Tecil Süresi Girmelisiniz'></cfsavecontent>
                            <cfinput type="text" style="width:65px;" name="military_finishdate" value="#dateformat(get_hr_detail.military_finishdate,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="military_finishdate"></span>
                        </div>
                    </div>
                    <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                        <label><cf_get_lang dictionary_id ='56145.Süresi'> (<cf_get_lang dictionary_id='58724.Ay'>)</label>
                    </div>
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='56147.Askerlik Süresi Girmelisiniz'>'></cfsavecontent>
                        <cfinput type="text" name="military_month" value="#get_hr_detail.military_month#" validate="integer" maxlength="2" message="#message#">
                    </div>
                </div>
            </div>
            <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12" <cfif get_hr_detail.military_status neq 1>style="display:none"</cfif> id="Yapti1">
                <div class="col col-5 col-md-5 col-sm-5 col-xs-12">
                    <label><cf_get_lang dictionary_id='55619.Askerlik'></label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <span><input type="radio" name="military_rank" id="military_rank" value="0" <cfif get_hr_detail.military_rank eq 0>checked</cfif>><cf_get_lang dictionary_id ='56148.Er'></span>
                    <span><input type="radio" name="military_rank" id="military_rank" value="1" <cfif get_hr_detail.military_rank eq 1>checked</cfif>> <cf_get_lang dictionary_id ='56149.Yedek Subay'></span>
                </div>
            </div>
            <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12" <cfif get_hr_detail.military_status neq 2>style="display:none"</cfif> id="Muaf">
                <div class="col col-5 col-md-5 col-sm-5 col-xs-12">
                    <label><cf_get_lang dictionary_id ='56143.Muaf Olma Nedeni'></label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <input type="text" style="width:150px;" name="military_exempt_detail" id="military_exempt_detail" maxlength="100" value="<cfoutput>#get_hr_detail.military_exempt_detail#</cfoutput>">
                </div>
            </div>
            <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-5 col-md-5 col-sm-5 col-xs-12">
                    <label><cf_get_lang dictionary_id='55964.6 aydan fazla hüküm giydi mi'>?</label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <div class="checkbox checbox-switch">
                        <label>
                            <input type="checkbox" name="sentenced_six_month" id="sentenced_six_month" value="1" <cfif get_hr_detail.sentenced_six_month eq 1>checked</cfif>/>
                            <span></span>
                        </label>
                    </div>
                </div>
            </div>
            <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-5 col-md-5 col-sm-5 col-xs-12">
                    <label><cf_get_lang dictionary_id='55343.Bir suç zannıyla tutuklandınız mı veya mahkumiyetiniz oldu mu ?'></label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <div class="checkbox checbox-switch">
                        <label>
                            <input type="checkbox" name="defected_probability" id="defected_probability" value="1" <cfif get_hr_detail.defected_probability eq 1>checked</cfif>/>
                            <span></span>
                        </label>
                    </div>
                </div>
            </div>
            <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-5 col-md-5 col-sm-5 col-xs-12">
                    <label><cf_get_lang dictionary_id='55342.Devam eden bir hastalığınız veya bedeni sorununuz var mı ? Varsa nedir ?'></label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <div class="checkbox checbox-switch">
                        <label>
                            <input type="checkbox" name="illness_probability" id="illness_probability" value="1" <cfif get_hr_detail.illness_probability eq 1>checked</cfif> onclick="illness();"/>
                            <span></span>
                        </label>
                    </div>
                </div>
            </div>
            <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-5 col-md-5 col-sm-5 col-xs-12">
                    <label>&nbsp;</label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <textarea <cfif get_hr_detail.illness_detail eq 0 or len(get_hr_detail.illness_detail) eq 0>disabled</cfif> name="illness_detail" id="illness_detail" style="width:350px;"><cfoutput>#get_hr_detail.illness_detail#</cfoutput></textarea>
                </div>
            </div>
            <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-5 col-md-5 col-sm-5 col-xs-12">
                    <label><cf_get_lang dictionary_id='55965.Devam eden bir davanız var mı Varsa açıklayınız'></label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <div class="checkbox checbox-switch">
                        <label>
                            <input type="checkbox" name="suit_probability" id="suit_probability" value="1" <cfif get_hr_detail.suit_probability eq 1>checked</cfif> onclick="suit();"/>
                            <span></span>
                        </label>
                    </div>
                </div>
            </div>
            <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-5 col-md-5 col-sm-5 col-xs-12">
                    <label>&nbsp;</label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <textarea <cfif get_hr_detail.suit_detail eq 0 or len(get_hr_detail.suit_detail) eq 0>disabled</cfif> name="suit_detail" id="suit_detail" style="width:350px;" ><cfoutput>#get_hr_detail.suit_detail#</cfoutput></textarea>
                </div>
            </div>
            <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-5 col-md-5 col-sm-5 col-xs-12">
                    <label><cf_get_lang dictionary_id ='56605.Üye Olduğunuz Klüp ve Dernekler'></label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <textarea name="club" id="club" style="width:350px;"><cfoutput>#get_hr_detail.club#</cfoutput></textarea>
                </div>
            </div>
        </cf_box_elements>
        <cfset RELATIVE_URL_STRING="">
        <cfset SSK_EK="">
        <!--- <cfinclude template="../display/list_emp_relatives.cfm"> --->
        <div class="col col-12">
            <cf_box_footer>
                <cf_record_info query_name="get_hr_detail">
                <cf_workcube_buttons type_format="1" is_upd='0' add_function="loadPopupBox('employe_personal')">
            </cf_box_footer>
        </div>
    </cfform>
</cf_box>
<script type="text/javascript">
    function seviye()
    {
        if(document.employe_personal.defected_level.disabled==true)
            document.employe_personal.defected_level.disabled=false;
        else
            document.employe_personal.defected_level.disabled=true;
    }

    function illness()
    {
        if(document.employe_personal.illness_detail.disabled==true)
            document.employe_personal.illness_detail.disabled=false;
        else
            document.employe_personal.illness_detail.disabled=true;
    }

    function suit()
    {
        if(document.employe_personal.suit_detail.disabled==true)
            document.employe_personal.suit_detail.disabled=false;
        else
            document.employe_personal.suit_detail.disabled=true;
    }


    function tecilli_fonk(gelen)
    {
        if (gelen == 4)
        {
            Tecilli.style.display='';
            Yapti.style.display='none';
            Yapti1.style.display='none';
            Muaf.style.display='none';
        }
        else if(gelen == 1)
        {
            Yapti.style.display='';
            Yapti1.style.display='';
            Tecilli.style.display='none';
            Muaf.style.display='none';
        }
        else if(gelen == 2)
        {
            Muaf.style.display='';
            Tecilli.style.display='none';
            Yapti.style.display='none';
            Yapti1.style.display='none';
        }
        else
        {
            Tecilli.style.display='none';
            Yapti.style.display='none';
            Yapti1.style.display='none';
            Muaf.style.display='none';
        }
    }        
</script>
