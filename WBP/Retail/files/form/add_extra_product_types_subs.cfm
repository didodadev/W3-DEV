<cfquery name="get_types" datasource="#dsn_dev#">
	SELECT * FROM EXTRA_PRODUCT_TYPES ORDER BY TYPE_NAME
</cfquery>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="add_form" action="">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-type_id">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='34074.Kriter'></label>
                        <div class="col col-8 col-sm-12">
                            <cfselect name="type_id" required="yes" message="Kriter Seçmelisiniz!">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_types">
                                <option value="#type_id#">#type_name#</option>
                                </cfoutput>
                            </cfselect>
                        </div>
                    </div>
                    <div class="form-group" id="item-sub_type_name">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61721.Alt Tanım'></label>
                        <div class="col col-8 col-sm-12">
                            <cfsavecontent  variable="message"><cf_get_lang dictionary_id='61722.Alt Tanım Girmelisiniz'>!</cfsavecontent>
                            <cfinput type="text" name="sub_type_name" required="yes" message="#message#" maxlength="100" style="width:200px;">
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
