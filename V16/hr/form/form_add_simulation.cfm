<cf_catalystHeader>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="56312.Simülasyon Ekle"></cfsavecontent>
<cf_box title="#message#">
    <form name="addsimulation" action="<cfoutput>#request.self#</cfoutput>?fuseaction=hr.emptypopup_add_simulation" method="post">
        <cf_box_elements>
            <div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12">
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                    <label><cf_get_lang dictionary_id='58820.Baslik'>*</label>
                </div>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <input type="text" name="head" id="head" maxlength="180">
                </div>
            </div>
            <div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12">
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                    <label><cf_get_lang dictionary_id='58497.Pozisyon'>*</label>
                </div>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <div class="input-group">
                        <input type="hidden" name="employee_id" id="employee_id" value="">
                        <input type="hidden" name="position_code" id="position_code" value="">
                        <input type="hidden" name="position_id" id="position_id" value="">
                        <input type="text" name="emp_name" id="emp_name" value="" required="yes" style="width:200px;" readonly="">
                        <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=addsimulation.employee_id&field_code=addsimulation.position_code&field_name=addsimulation.emp_name&field_id=addsimulation.position_id</cfoutput>','list')"></span>
                    </div>
                </div>
            </div>
        </cf_box_elements>
        <div class="ui-form-list-btn">
            <cf_workcube_buttons type_format="1" is_upd='0' add_function='control()'>
        </div>
    </form>
</cf_box>
<script type="text/javascript">
function control()
{
	if(addsimulation.head.value == "")
	{
		alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58820.Başlık'>!");
		return false;
	}
	if(addsimulation.position_code.value == "")
	{
		alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58497.Pozisyon'>!");
		return false;
	}
}
</script>
