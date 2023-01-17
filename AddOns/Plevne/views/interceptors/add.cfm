<cfinclude template="../../config.cfm" runonce="true">
<cfinclude template="../../models/types.cfm" runonce="true">

<cfparam name="attributes.interceptor_category_id" default="">
<cfif len(attributes.interceptor_category_id) eq 0>
    Bu ekrana hatalı bir yerden ulaştınız!
    <cfexit>
</cfif>

<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="add_form" method="post">
            <input type="hidden" name="interceptor_category" value="<cfoutput>#attributes.interceptor_category_id#</cfoutput>">
            <cf_box_elements>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-interceptor_body">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="47708.Path"></label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="interceptor_path" required>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-status">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57756.Durum"></label>
                        <div class="col col-8 col-xs-12">
                            <select name="status" id="status">
                                <option value="1"><cf_get_lang dictionary_id='57493.Aktif'></option>
                                <option value="0"><cf_get_lang dictionary_id='57494.Pasif'></option>
                            </select>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
    function kontrol() {
        return document.getElementById("add_form").checkValidity();
    }
</script>