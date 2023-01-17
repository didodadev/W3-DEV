<cfparam name="attributes.is_submitted" default="">
<cfparam name="attributes.vehicle_type" default="">
<cfparam name="attributes.model" default="">
<cfparam name="attributes.brand_type_id" default="">
<cfinclude template="../query/get_usage_purpose.cfm">
<cfinclude template="../query/get_vehicle_cat.cfm">
<cfinclude template="../query/get_assetp_groups.cfm">
<cf_box>
    <cfform method="post" name="search_count">
        <input type="hidden" name="is_submitted" id="is_submitted" value="1">
        <cf_box_search more="0">
            <div class="form-group">
                <div class="input-group">
                    <input type="hidden" name="depot_id"  id="depot_id" value="<cfif isdefined('attributes.depot_id') and len(attributes.depot_id)><cfoutput>#attributes.depot_id#</cfoutput></cfif>">
                    <input type="Text" name="depot" value="<cfif isdefined('attributes.depot') and len(attributes.depot)><cfoutput>#attributes.depot#</cfoutput></cfif>" placeholder="<cfoutput>#getLang('','',48041)#</cfoutput>">
                    <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_name=search_count.depot&field_branch_id=search_count.depot_id')"></span>                   
                </div>
            </div>
            <div class="form-group">
                <div class="input-group">
                    <cf_wrkBrandTypeCat
                        returnInputValue="brand_name,brand_type_id"
                        returnQueryValue="BRAND_TYPE_CAT_HEAD,BRAND_TYPE_ID"
                        brand_type_id="#attributes.brand_type_id#"
                        width="160"
                        compenent_name="getBrandType1"
                        boxwidth="180"
                        boxheight="150"
                        is_type_cat_id=0
                        value="#attributes.brand_type_id#"> 
                </div>
            </div>
            <div class="form-group">
                <select name="vehicle_type" id="vehicle_type" >
                    <option value=""><cf_get_lang dictionary_id='47973.Araç Tipi'></option>
                    <cfoutput query="get_vehicle_cat">
                        <option value="#assetp_catid#" <cfif len(attributes.vehicle_type) and attributes.vehicle_type eq assetp_catid>selected="selected"</cfif>>#assetp_cat#</option>
                    </cfoutput>
                </select>
            </div>
            <div class="form-group">
                <select name="model" id="model">
                    <option value=""><cf_get_lang dictionary_id='58225.Model'></option>
                    <cfoutput>
                    <cfloop index="i" from="#dateformat(now(),"yyyy")#" to="1970" step="-1">
                        <option value="#i#" <cfif len(attributes.model) and attributes.model eq i>selected="selected"</cfif>>#i#</option>
                    </cfloop>
                    </cfoutput>
                </select>
            </div>
            <div class="form-group">
                <cf_wrk_search_button button_type="4">
            </div>
        </cf_box_search>
    </cfform>
</cf_box>
