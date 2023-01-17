<cfinclude template="../../config.cfm" runonce="true">
<cfinclude template="../../models/types.cfm" runonce="true">

<cfparam name="attributes.expression_category_id" default="">
<cfparam name="attributes.id" default="0">
<cfif len(attributes.expression_category_id) eq 0>
    Bu ekrana hatalı bir yerden ulaştınız!
    <cfexit>
</cfif>

<cfobject name="inst_expression" type="component" component="#addonns#.domains.expressions">
<cfset query_expression = inst_expression.get_expressions(expression_id: attributes.id)>

<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="add_form" method="post">
            <input type="hidden" name="expression_category" value="<cfoutput>#attributes.expression_category_id#</cfoutput>">
            <input type="hidden" name="expression_id" value="<cfoutput>#attributes.id#</cfoutput>">
            <cf_box_elements vertical="1">
                <div class="col col-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-expression_body">
                        <label class="col col-12"><cf_get_lang dictionary_id="58233.Tanım"></label>
                        <div class="col col-12">
                            <textarea name="expression_body" rows="6" id="expression_body" required><cfoutput>#query_expression.expression_body#</cfoutput></textarea>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-status">
                        <label class="col col-12"><cf_get_lang dictionary_id="57756.Durum"></label>
                        <div class="col col-12">
                            <select name="status" id="status">
                                <option value="1" <cfif query_expression.status eq "1">selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                                <option value="0" <cfif query_expression.status eq "0">selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                            </select>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url="#request.self#?fuseaction=plevne.expression&event=del&expression_id=#query_expression.expression_id#">
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
    function kontrol() {
        return document.getElementById("add_form").checkValidity();
    }
</script>