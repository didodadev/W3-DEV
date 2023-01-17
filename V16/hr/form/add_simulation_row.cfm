<cfquery name="GET_POSITION_CATS" datasource="#dsn#">
	SELECT 
        POSITION_CAT_ID, 
        POSITION_CAT, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        HIERARCHY
    FROM 
	    SETUP_POSITION_CAT 
    ORDER BY
    	POSITION_CAT 
</cfquery>
<cfquery name="GET_ORGANIZATION_STEPS" datasource="#dsn#">
	SELECT ORGANIZATION_STEP_ID, ORGANIZATION_STEP_NAME FROM SETUP_ORGANIZATION_STEPS ORDER BY ORGANIZATION_STEP_NAME
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="55170.Çalışan Ekle"></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#message#">
        <cfform name="add_notes" method="post" action="#request.self#?fuseaction=hr.emptypopup_add_simulation_row">
            <input type="hidden" name="simulation_id" id="simulation_id" value="<cfoutput>#attributes.simulation_id#</cfoutput>">
            <cf_box_elements vertical="1">
                <cfif isdefined("attributes.hierarchy")>
                    <input type="hidden" name="hierarchy" id="hierarchy" value="<cfoutput>#attributes.hierarchy#</cfoutput>">
                </cfif>
                <cfquery name="GET_POSITION" datasource="#dsn#">
                    SELECT POSITION_ID,POSITION_NAME,EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_ID = #attributes.up_position_id#
                </cfquery>
            <div class="form-group col col-3 col-md-3 col-sm-6 col-xs-12">
                <label><cf_get_lang dictionary_id ='55978.Üst Pozisyon'></label>
                    <input type="hidden" name="up_position_id" id="up_position_id" value="<cfoutput>#attributes.up_position_id#</cfoutput>">
                    <input type="text" readonly="" name="up_employee_name" id="up_employee_name" style="width:230px;" value="<cfoutput>#get_position.position_name# - #get_position.employee_name# #get_position.employee_surname#</cfoutput>">
            </div>
            <div class="form-group col col-3 col-md-3 col-sm-6 col-xs-12">
                    <label><cf_get_lang dictionary_id='58497.Pozisyon'>*</label>
                    <div class="input-group">
                        <input type="hidden" name="position_code" id="position_code" value="">
                        <input type="hidden" name="employee_id" id="employee_id" value="" />
                        <input type="text" name="position_name" id="position_name"  onFocus="AutoComplete_Create('position_name','FULLNAME','POSITION_NAME','get_emp_pos','','POSITION_CODE,POSITION_NAME,EMPLOYEE_ID','position_code,position_name,employee_id','add_notes','3','162');" value="" style="width:230px;">
                        <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=add_notes.position_code&position_employee=add_notes.position_name&field_emp_id=add_notes.employee_id&show_empty_pos=1','list','popup_list_positions');return false"></span>
                    </div>
                </div>
                <div class="form-group col col-3 col-md-3 col-sm-6 col-xs-12">
                    <label><cf_get_lang dictionary_id='59004.Pozisyon Tipi'>*</label>
                    <select name="position_cat_id" id="position_cat_id" style="width:230px;">
                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <cfoutput query="get_position_cats">
                            <option value="#position_cat_id#">#position_cat#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group col col-3 col-md-3 col-sm-6 col-xs-12">
                    <label><cf_get_lang dictionary_id='58710.Kademe'>*</label>
                    <select name="organization_step_id" id="organization_step_id" style="width:230px;">
                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'>
                        <cfoutput query="get_organization_steps">
                            <option value="#organization_step_id#">#organization_step_name#
                        </cfoutput>
                    </select>
                </div>
            </cf_box_elements>
            <div class="ui-form-list-btn"><cf_workcube_buttons type_format="1" is_upd='0' add_function='kontrol()'></div>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
function kontrol()
{	
	if(add_notes.position_name.value == "")
	{
		alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58497.Pozisyon'>!");
		return false;
	}
	x = document.add_notes.position_cat_id.selectedIndex;
	if (document.add_notes.position_cat_id[x].value == "")
	{ 
		alert ("<cf_get_lang dictionary_id ='56323.Lütfen Pozisyon Tipi Seçiniz'>!");
		return false;
	}	
	x = document.add_notes.organization_step_id.selectedIndex;
	if (document.add_notes.organization_step_id[x].value == "")
	{ 
		alert ("<cf_get_lang dictionary_id ='56322.Lütfen Kademe Seçiniz'>!");
		return false;
	}	
}
</script>
