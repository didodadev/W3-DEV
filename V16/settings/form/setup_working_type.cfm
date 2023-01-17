<!---
    File: V16\settings\form\setup_working_type.cfm
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 2021-10-28
    Description: Mesai türlerinin tanımlandığı sayfadır.
        
    History:
        
    To Do:

--->
<cfset get_component = createObject("component","V16.settings.cfc.setup_working_type")>
<cfset get_setup_working_type = get_component.get_setup_working_type()>
<cfset get_setup_offtime = get_component.get_setup_offtime()>


<!--Muzaffer Bas-->
<cfset get_fuseaction_property = createObject("component","V16.objects.cfc.fuseaction_properties")>
<cfset Akdi_Gun = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'ehesap.form_upd_program_parameters',
    property_name : 'x_Akdi_Gun'  
    )>
    <cfset x_Akdi_Gun = Akdi_Gun.PROPERTY_VALUE>
    <cfset Akdi_Gun_FM = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'ehesap.form_upd_program_parameters',
    property_name : 'x_akdi_day_work'
    )>
	<cfset x_akdi_day_work = Akdi_Gun_FM.PROPERTY_VALUE>

	<cfset Hafta_tatili_FM = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'ehesap.form_upd_program_parameters',
    property_name : 'x_weekly_day_work'
    )>
	<cfset x_weekly_day_work = Hafta_tatili_FM.PROPERTY_VALUE>

	<cfset Resmi_Tatil_Gun = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'ehesap.form_upd_program_parameters',
    property_name : 'x_official_day_work'
    )>
	<cfset x_official_day_work = Resmi_Tatil_Gun.PROPERTY_VALUE>

	<cfset Arefe_Gun_FM = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'ehesap.form_upd_program_parameters',
    property_name : 'x_Arefe_day_work'
    )>
	<cfset x_Arefe_day_work = Arefe_Gun_FM.PROPERTY_VALUE>

	<cfset Dini_Gun_FM = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'ehesap.form_upd_program_parameters',
    property_name : 'x_Dini_day_work'
    )>
	<cfset x_Dini_day_work = Dini_Gun_FM.PROPERTY_VALUE>
<!--Muzaffer Bit-->

<cfif isdefined("attributes.working_type_id") and len(attributes.working_type_id)>
    <cfset get_setup_working_type_upd = get_component.GET_SETUP_WORKING_TYPE(working_type_id: attributes.working_type_id)>
    <cfset action_path = "V16/settings/cfc/setup_working_type:upd_setup_working_type">
<cfelse>
    <cfset action_path = "V16/settings/cfc/setup_working_type:add_setup_working_type">
</cfif>

<div class="col col-12 col-xs-12">
	<cf_box title="#getLang('','mesai Tipleri',64124)#" add_href="#request.self#?fuseaction=settings.working_type">
        <cfform action="#action_path#" method="post" name="language_allowance">
            <cfif isdefined("attributes.working_type_id") and len(attributes.working_type_id)>
                <cfinput type="hidden" name="working_type_id" value="#attributes.working_type_id#">
            </cfif>
            <cf_box_elements>		
				<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="1" sort="true">
                    <table width="200" cellpadding="0" cellspacing="0" border="0">
                        <cfoutput query="get_setup_working_type">
                            <tr>
                                <td width="20" align="right" valign="baseline"></td>
                                <!--- todo: detail alanı değiştirilecek --->
                                <td width="170"><i class="fa fa-cube" style="font-size:12px;color:#chr(35)##get_setup_working_type.color_code#;"></i>&nbsp;<a href="#request.self#?fuseaction=settings.working_type&working_type_id=#working_type_id#" clasS="tableyazi">#DETAIL#</a></td>
                            </tr>
                        </cfoutput>
                    </table>
				</div>	
				<div class="col col-9 col-md-9 col-sm-9 col-xs-12" type="column" index="2" sort="true">
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
						<div class="form-group" id="item-working_type">
							<label class="col col-3 col-md-6 col-xs-12"><cfoutput>#getLang('','yasal tanım',64126)#</cfoutput>*</label>
							<div class="col col-8 col-md-6 col-xs-12">
								<select name="working_type" id="working_type" style="width:180px;">
                                    <option value="-5" <cfif isdefined("attributes.working_type_id") and len(attributes.working_type_id) and get_setup_working_type_upd.working_type eq -5>selected</cfif>><cf_get_lang dictionary_id='55753.Çalışma Günü'></option>
                                    <cfif x_Akdi_Gun eq 1>
                                            <option value="-13" <cfif isdefined("attributes.working_type_id") and len(attributes.working_type_id) and get_setup_working_type_upd.working_type eq -13>selected</cfif>>Akdi Gün</option>
                                    </cfif>
                                    <option value="-6" <cfif isdefined("attributes.working_type_id") and len(attributes.working_type_id) and get_setup_working_type_upd.working_type eq -6>selected</cfif>><cf_get_lang dictionary_id='58867.Hafta Tatili'></option>
                                    <option value="-7" <cfif isdefined("attributes.working_type_id") and len(attributes.working_type_id) and get_setup_working_type_upd.working_type eq -7>selected</cfif>><cf_get_lang dictionary_id='29482.Genel Tatil'></option>
                                    <option value="-1" <cfif isdefined("attributes.working_type_id") and len(attributes.working_type_id) and get_setup_working_type_upd.working_type eq -1>selected</cfif>><cf_get_lang dictionary_id='55753.Çalışma Günü'> <cf_get_lang dictionary_id='53539.FM'></option>
                                    <option value="-2" <cfif isdefined("attributes.working_type_id") and len(attributes.working_type_id) and get_setup_working_type_upd.working_type eq -2>selected</cfif>><cf_get_lang dictionary_id='58867.Hafta Tatili'> <cf_get_lang dictionary_id='53539.FM'></option> 
                                    <option value="-3" <cfif isdefined("attributes.working_type_id") and len(attributes.working_type_id) and get_setup_working_type_upd.working_type eq -3>selected</cfif>><cf_get_lang dictionary_id='31473.Resmi Tatil'> <cf_get_lang dictionary_id='53539.FM'></option>
                                    <option value="-4" <cfif isdefined("attributes.working_type_id") and len(attributes.working_type_id) and get_setup_working_type_upd.working_type eq -4>selected</cfif>><cf_get_lang dictionary_id='54251.Gece Çalışması'> <cf_get_lang dictionary_id='53539.FM'></option>     
                                    <cfif x_weekly_day_work eq 1>
                                            <option value="-8" <cfif isdefined("attributes.working_type_id") and len(attributes.working_type_id) and get_setup_working_type_upd.working_type eq -8>selected</cfif>> Hafta Tatili - Gün <cf_get_lang dictionary_id='53539.FM'></option>   
                                    </cfif>
                                    <cfif x_akdi_day_work eq 1>
                                            <option value="-9" <cfif isdefined("attributes.working_type_id") and len(attributes.working_type_id) and get_setup_working_type_upd.working_type eq -9>selected</cfif>> Akdi Tatil - Gün <cf_get_lang dictionary_id='53539.FM'></option> 
                                    </cfif>
                                    <cfif x_official_day_work eq 1>
                                            <option value="-10" <cfif isdefined("attributes.working_type_id") and len(attributes.working_type_id) and get_setup_working_type_upd.working_type eq -10>selected</cfif>> Resmi Tatil - Gün  <cf_get_lang dictionary_id='53539.FM'></option>  
                                    </cfif>
                                    <cfif x_Arefe_day_work eq 1>
                                            <option value="-11" <cfif isdefined("attributes.working_type_id") and len(attributes.working_type_id) and get_setup_working_type_upd.working_type eq -11>selected</cfif>> Arefe Tatil - Gün <cf_get_lang dictionary_id='53539.FM'></option>
                                    </cfif>
                                    <cfif x_Dini_day_work eq 1>
                                            <option value="-12" <cfif isdefined("attributes.working_type_id") and len(attributes.working_type_id) and get_setup_working_type_upd.working_type eq -12>selected</cfif>> Dini Bayram - Gün <cf_get_lang dictionary_id='53539.FM'></option> 
                                    </cfif> 
                                    <cfoutput query = "get_setup_offtime">
                                        <option value="#OFFTIMECAT_ID#" <cfif isdefined("attributes.working_type_id") and len(attributes.working_type_id) and get_setup_working_type_upd.working_type eq OFFTIMECAT_ID>selected</cfif>>#OFFTIMECAT#</option>
                                    </cfoutput>
                                </select>
							</div>
						</div>
                        <div class="form-group" id="item-working_abbreviation">
                            <label class="col col-3 col-md-6 col-xs-12"><cfoutput>#getLang('','kod',58585)#</cfoutput>*</label>
                            <div class="col col-8 col-md-6 col-xs-12">
                                <cfsavecontent variable="message"><cfoutput>#getLang('','kod',58585)#</cfoutput></cfsavecontent>
                                <cfif isdefined('attributes.working_type_id') and len(attributes.working_type_id) and len(get_setup_working_type_upd.working_abbreviation)>
                                    <cfinput type="Text" name="working_abbreviation" value="#get_setup_working_type_upd.working_abbreviation#" required="Yes" message="#get_setup_working_type_upd.working_abbreviation#">	
                                <cfelse>
                                    <cfinput type="Text" name="working_abbreviation" value="" required="Yes" message="#message#">							
                                </cfif>
                            </div>
                        </div>
                        <div class="form-group" id="item-detail">
                            <label class="col col-3 col-md-6 col-xs-12"><cfoutput>#getLang('','detay',57771)#</cfoutput>*</label>
                            <div class="col col-8 col-md-6 col-xs-12">
                                <cfsavecontent variable="message"><cfoutput>#getLang('','detay',57771)#</cfoutput></cfsavecontent>
                                <cfif isdefined('attributes.working_type_id') and len(attributes.working_type_id) and len(get_setup_working_type_upd.detail)>
                                    <cfinput type="Text" name="detail" id="detail"  value="#get_setup_working_type_upd.detail#"  required="Yes" message="#message#">							
                                <cfelse>
                                    <cfinput type="Text" name="detail" id="detail"  value="" required="Yes" message="#message#">							
                                </cfif>
                            </div>
                        </div>
                        <div class="form-group" id="item-detail">
                            <label class="col col-3 col-md-6 col-xs-12"><cfoutput>#getLang('','renk kodu',36555)#</cfoutput>*</label>
                            <div class="col col-8 col-md-6 col-xs-12">
                                <cfsavecontent variable="message"><cfoutput>#getLang('','renk kodu',36555)#</cfoutput></cfsavecontent>
                                <cfif isdefined('attributes.working_type_id') and len(attributes.working_type_id) and len(get_setup_working_type_upd.detail)>
                                    <cf_workcube_color_picker name="color_code" id="color_code" width="200" value="#get_setup_working_type.color_code#">						
                                <cfelse>
                                    <cf_workcube_color_picker name="color_code" id="color_code" width="200">						
                                </cfif>
                            </div>
                        </div>
					</div>
			    </div>
			</cf_box_elements>
			<cf_box_footer>
            <cfif isdefined("attributes.working_type_id") and len(attributes.working_type_id)>
                <cf_record_info query_name="get_setup_working_type_upd">
			    <cf_workcube_buttons is_upd='1' add_function='control()' data_action = "#action_path#" delete_page_url='V16/settings/cfc/setup_working_type.cfc?method=del_setup_working_type&working_type_id=#attributes.working_type_id#' next_page="#request.self#?fuseaction=settings.working_type&working_type_id=">
            <cfelse>
			    <cf_workcube_buttons is_upd='0'  data_action = "#action_path#" add_function='control()' next_page="#request.self#?fuseaction=settings.working_type">
            </cfif> 
		</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script>
    function control()
    {
        if($("#color_code").val() == '')
        {
            alert("<cfoutput>#getLang('','detay',57771)#</cfoutput>*");
            return false;
        }
    }
  </script>