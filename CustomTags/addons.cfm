<cfparam name="attributes.product_id" default="">
<cfif not len(attributes.product_id)>
    <cfthrow message="Addon kontrolünde id boş bırakılamaz!">
</cfif>

<cfobject name="data_addons" type="component" component="WEX.addonservices.data.addons">
<cfset query_license = data_addons.get_addon(attributes.product_id)>

<cfif query_license.recordCount>
    <cfif query_license.PROD_ID neq attributes.product_id>
        <cfif len(query_license.TRIAL_PROD_ID)>
            <cfif dateAdd('d', 21, query_license.TRIAL_START) lt now()>
                <cf_box 
                box_page="https://wex.workcube.com/wex.cfm/addons/expire?product_id=#attributes.product_id#" 
                popup_box="1"
                title="Trial End"
                id="box_trial_end"
                ></cf_box>
                <cfabort>
            </cfif>
        <cfelse>
            <cf_box 
            box_page="https://wex.workcube.com/wex.cfm/addons/register?product_id=#attributes.product_id#" 
            popup_box="1"
            title="Get an Addon"
            id="box_get_addon"
            ></cf_box>
            <cfabort>
        </cfif>
    </cfif>
</cfif>