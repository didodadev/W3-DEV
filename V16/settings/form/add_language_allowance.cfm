<!---
    File: V16\settings\cfc\language_allowance.cfc
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 2021-05-27
    Description: Yabancı Dil Tazminatı Gösterge Rakamı güncelleme ve ekleme sayfasıdır.
        
    History:
        
    To Do:

--->
<cfset get_component = createObject("component","V16.settings.cfc.language_allowance")>
<cfset get_setup_language_list = get_component.GET_SETUP_LANGUAGE_ALLOWANCE()>
<cfif isdefined("attributes.language_allowance_id") and len(attributes.language_allowance_id)>
    <cfset get_setup_language_upd = get_component.GET_SETUP_LANGUAGE_ALLOWANCE(language_allowance_id: attributes.language_allowance_id)>
    <cfset action_path = "V16/settings/cfc/language_allowance.cfc?method=upd_setup_language_allowance&language_allowance_id=#attributes.language_allowance_id#">
<cfelse>
    <cfset action_path = "V16/settings/cfc/language_allowance.cfc?method=add_setup_language_allowance">
</cfif>

<cfsavecontent variable="title">
    <cf_get_lang dictionary_id='62899.Yabancı Dil Tazminatı Gösterge Rakamı'>
</cfsavecontent>

<div class="col col-12 col-xs-12">
	<cf_box title="#title#" add_href="#request.self#?fuseaction=settings.add_language_allowance">
        <cfform action="#action_path#" method="post" name="language_allowance">
            <cf_box_elements>		
				<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="1" sort="true">
                    <table width="200" cellpadding="0" cellspacing="0" border="0">
                        <cfoutput query="get_setup_language_list" group="LANGUANGE_STATUE">
                            <cfif LANGUANGE_STATUE eq 1>
                                <tr>
                                    <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
                                    <td nowrap="nowrap">&nbsp;<cf_get_lang dictionary_id='62897.Yabancı dilden faydalanılması durumunda'></td>
                                </tr>
                            <cfelse>
                                <tr>
                                    <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
                                    <td nowrap="nowrap">&nbsp;<cf_get_lang dictionary_id='62901.Yabancı dilden faydalanılmadığı durumda'></td>
                                </tr>
                            </cfif>
                            <cfoutput>
                                <tr>
                                    <td width="20" align="right" valign="baseline" style="text-align:right;"></td>
                                    <td width="170"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i>&nbsp;<a href="#request.self#?fuseaction=settings.add_language_allowance&language_allowance_id=#LANGUAGE_ALLOWANCE_ID#" clasS="tableyazi">#language_level#</a></td>
                                </tr>
                            </cfoutput>
                        </cfoutput>
                    </table>
				</div>	
				<div class="col col-9 col-md-9 col-sm-9 col-xs-12" type="column" index="2" sort="true">
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
						<div class="form-group" id="item-languange_statue">
							<label class="col col-3 col-md-6 col-xs-12"><cf_get_lang dictionary_id='62900.Yabancı Dil Durumu'>*</label>
							<div class="col col-8 col-md-6 col-xs-12">
								<select name="languange_statue" id="languange_statue" style="width:180px;">
                                    <option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <option value="1" <cfif isdefined("attributes.language_allowance_id") and len(attributes.language_allowance_id) and get_setup_language_upd.LANGUANGE_STATUE eq 1>selected</cfif>><cf_get_lang dictionary_id='62897.Yabancı dilden faydalanılması durumunda'></option>
                                    <option value="2" <cfif isdefined("attributes.language_allowance_id") and len(attributes.language_allowance_id) and get_setup_language_upd.LANGUANGE_STATUE eq 2>selected</cfif>><cf_get_lang dictionary_id='62901.Yabancı dilden faydalanılmadığı durumda'></option>
                                </select>
							</div>
						</div>
                        <div class="form-group" id="item-language_level">
                            <label class="col col-3 col-md-6 col-xs-12"><cf_get_lang dictionary_id='62902.Yabancı Dil Düzeyi'>*</label>
                            <div class="col col-8 col-md-6 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='62902.Yabancı Dil Düzeyi'></cfsavecontent>
                                <cfif isdefined('attributes.language_allowance_id') and len(attributes.language_allowance_id) and len(get_setup_language_upd.language_level)>
                                    <div class="input-group">
                                        <cfinput type="Text" name="language_level" value="#get_setup_language_upd.language_level#" required="Yes" message="#message#">
                                        <span class="input-group-addon">
                                            <cf_language_info 
                                            table_name="SETUP_LANGUAGE_ALLOWANCE" 
                                            column_name="LANGUAGE_LEVEL" 
                                            column_id_value="#url.language_allowance_id#" 
                                            maxlength="500" 
                                            datasource="#dsn#" 
                                            column_id="LANGUAGE_ALLOWANCE_ID" 
                                            control_type="0">
                                        </span>	
                                    </div>
                                <cfelse>
                                    <cfinput type="Text" name="language_level" value="" required="Yes" message="#message#">							
                                </cfif>
                            </div>
                        </div>
                        <div class="form-group" id="item-language_amount">
                            <label class="col col-3 col-md-6 col-xs-12"><cf_get_lang dictionary_id='57673.Tutar'>*</label>
                            <div class="col col-8 col-md-6 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57673.Tutar'></cfsavecontent>
                                <cfif isdefined('attributes.language_allowance_id') and len(attributes.language_allowance_id) and len(get_setup_language_upd.language_amount)>
                                    <cfinput type="Text" name="language_amount" id="language_amount"  value="#tlFormat(get_setup_language_upd.language_amount)#" class="moneybox" onkeyup="return(formatcurrency(this,event));" required="Yes" message="#message#">							
                                <cfelse>
                                    <cfinput type="Text" name="language_amount" id="language_amount"  value="" class="moneybox" onkeyup="return(formatcurrency(this,event));" required="Yes" message="#message#">							
                                </cfif>
                            </div>
                        </div>
					</div>
			    </div>
			</cf_box_elements>
			<cf_box_footer>
            <cfif isdefined("attributes.language_allowance_id") and len(attributes.language_allowance_id)>
                <cf_record_info query_name="get_setup_language_upd">
			    <cf_workcube_buttons is_upd='1' add_function='control()' delete_page_url='V16/settings/cfc/language_allowance.cfc?method=del_setup_language_allowance&language_allowance_id=#attributes.language_allowance_id#'>
            <cfelse>
			    <cf_workcube_buttons is_upd='0' add_function='control()'>
            </cfif> 
		</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script>
    function control()
    {
        if($("#languange_statue").val() == 0)
        {
            alert("<cf_get_lang dictionary_id='62900.Yabancı Dil Durumu'>*");
            return false;
        }
        $("#language_amount").val(filterNum( $("#language_amount").val()));
    }
  </script>