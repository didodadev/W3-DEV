<cfquery name="get_genius_general" datasource="#dsn_dev#">
	SELECT * FROM GENIUS_GENERAL
</cfquery>

<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="add_" method="post" action="">
            <cf_box_elements>
                <div class="col col-6 col-md-4 col-sm-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-main_computer_ip">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61687.Ana Makina IP'></label>
                        <div class="col col-8 col-sm-12">
                            <cfinput type="text" name="main_computer_ip" value="#get_genius_general.main_computer_ip#" style="width:250px;">
                        </div>
                    </div>
                </div>
                <div class="col col-6 col-md-4 col-sm-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-main_folder">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='42300.Klasör'></label>
                        <div class="col col-8 col-sm-12">
                            <cfinput type="text" name="main_folder" value="#get_genius_general.main_folder#" style="width:250px;">
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd="1" is_delete="0">
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
