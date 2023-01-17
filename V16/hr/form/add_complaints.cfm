<cf_catalystHeader>
<cf_box closable="0" collapsable="0" title="Tedavi Tipi Ekle">    
    <cfform name="add_complaint" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_complaints">
        <input type="hidden" name="is_popup" id="is_popup" value="<cfif isdefined("attributes.is_popup")><cfoutput>#attributes.is_popup#</cfoutput></cfif>" />
        <cf_box_elements vertical="1">
            <div class="col col-6">
                <div class="form-group" id="item-complaint_status">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id='57493.Aktif'></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="Checkbox" name="complaint_status" id="complaint_status" value="1" checked>
                    </div>
                </div>
                <div class="form-group" id="item-code">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id='58585.kod'></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="text" name="code" id="code">
                    </div>
                </div>
                <div class="form-group" id="item-complaint">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id='32413.Tanı'></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="text" name="complaint" id="complaint">
                    </div>
                </div>
                <div class="form-group" id="item-code">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id='57629.Açıklama'></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <textarea name="description" id="description"></textarea>
                    </div>
                </div> 
            </div>               
        </cf_box_elements>
        <div class="ui-form-list-btn">
            <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
        </div>
    </cfform>
<script type="text/javascript">
function kontrol()
{
    if(document.getElementById("complaint").value == "")
    {
        alert("<cf_get_lang dictionary_id='57471.Eksik veri'> : <cf_get_lang dictionary_id='32413.Tanı'>!");
        return false;
    }
    return true;
}
</script>
