<cfparam name="attributes.layout_id" default="">
<cfquery name="get_layouts" datasource="#dsn_dev#">
	SELECT * FROM SEARCH_TABLES_LAYOUTS_NEW
</cfquery>
<cfquery name="get_my_layout" datasource="#dsn_dev#">
	SELECT * FROM  SEARCH_TABLES_LAYOUTS_USERS WHERE USER_ID = #session.ep.userid#
</cfquery>

<cfif get_my_layout.recordcount>
	<cfset attributes.layout_id = get_my_layout.layout_id>
</cfif>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent variable="head"><cf_get_lang dictionary_id='61666.Tablo Tanımlama'></cfsavecontent>
    <cf_box title="#head#">
        <cfform name="add_form" action="">
            <cf_box_elements>
                <div class="form-group">
                    <div class="input-group">
                        <select name="layout_id" id="layout_id">
                            <option value=""><cf_get_lang dictionary_id='32796.Görünüm'></option>
                            <cfoutput query="get_layouts">
                                <option value="#layout_id#" <cfif attributes.layout_id eq layout_id>selected</cfif>>#layout_name#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>