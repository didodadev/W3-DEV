<cfinclude template="../../config.cfm" runonce="true">
<cfinclude template="../../models/types.cfm" runonce="true">

<cfparam name="attributes.expression_category_id" default="">
<cfif len(attributes.expression_category_id) eq 0>
    Bu ekrana hatalı bir yerden ulaştınız!
    <cfexit>
</cfif>

<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="add_form" method="post">
            <input type="hidden" name="expression_category" value="<cfoutput>#attributes.expression_category_id#</cfoutput>">
            <cf_box_elements vertical="1">
                <div class="col col-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-expression_body">
                        <label class="col col-12"><cf_get_lang dictionary_id="58233.Tanım"></label>
                        <div class="col col-12">
                            <textarea name="expression_body" rows="6" id="expression_body" required></textarea>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-status">
                        <label class="col col-12"><cf_get_lang dictionary_id="57756.Durum"></label>
                        <div class="col col-12">
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