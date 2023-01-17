<cf_box title="#getLang('hr',797)# : #getLang('main',2352)#" closable="0" collapsable="0">
	<cfform name="add_decisine_medicine" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_decisionmedicine">
        <input type="hidden" name="is_popup" id="is_popup" value="<cfif isdefined("attributes.is_popup")><cfoutput>#attributes.is_popup#</cfoutput></cfif>" />
            <cf_box_elements vertical="1">
                <div class="col col-6">
                    <div class="form-group">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
                        </div>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">                        
                            <input type="Checkbox" name="medicine_status" id="medicine_status" value="1" checked>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57633.Barkod'></label>
                        </div>                        
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                            <cfinput type="text" name="barcode" maxlength="50"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='55884.İlaç'></label>
                        </div>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                            <cfinput type="text" name="decisionmedicine" id="decisionmedicine"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58585.Kod'></label>
                        </div>                        
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                            <cfinput type="text" name="code" maxlength="50"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='55883.Etken Madde'></label>
                        </div>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                            <cfinput type="text" name="active_ingredient" />
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <div class="ui-form-list-btn">
                <cf_workcube_buttons is_upd='0' add_function='kontrol()'>             
            </div>
    </cfform>
</cf_box>
<script type="text/javascript">
function kontrol()
{
	if(document.getElementById("decisionmedicine").value == "")
	{
		alert("<cf_get_lang dictionary_id='57471.Eksik veri'> : <cf_get_lang dictionary_id='42099.İlaç'>!");
		return false;
	}
	return true;
}
</script>

