<cfif isdefined('attributes.is_production')>
	<cfquery name="GET_BRANCH" datasource="#DSN#">
		SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH ORDER BY BRANCH_NAME
	</cfquery>
</cfif>
<cf_catalystHeader>
<cfform name="add_shift" action="#request.self#?fuseaction=ehesap.emptypopup_add_shift" method="post">
    <cf_box>
        <cf_box_elements>
            <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-is_production">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="36795.Çalışma Programı"></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='53070.Vardiya Adı girmelisiniz'></cfsavecontent>
                        <cfinput type="text" name="shift_name" maxlength="100" required="yes" message="#message#">
                        <cfif isdefined('attributes.is_production')>
                            <input type="hidden" name="is_production" id="is_production" value="<cfoutput>#attributes.is_production#</cfoutput>">
                        </cfif>
                    </div>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_workcube_buttons is_upd='0'>
        </cf_box_footer>
    </cf_box>
</cfform>
