<cfquery name="GET_DOMAINS" datasource="#DSN#">
	SELECT
        SITE_ID,
        DOMAIN
	FROM 
		PROTEIN_SITES
	WHERE 
	    STATUS = 1
    UNION
    SELECT
        MENU_ID AS SITE_ID,
        SITE_DOMAIN AS DOMAIN
	FROM 
        COMPANY_CONSUMER_DOMAINS  
    WHERE SITE_DOMAIN IS NOT NULL
    ORDER BY DOMAIN ASC
</cfquery>

<cfquery name="GET_CONSUMER_SELECTED_SITES" datasource="#DSN#">
	SELECT
        MENU_ID
	FROM 
        COMPANY_CONSUMER_DOMAINS
	WHERE 
        PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#">  
</cfquery>

<cfset selected_site = ValueList(GET_CONSUMER_SELECTED_SITES.MENU_ID)>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Site Erişim Hakları',58442)#" closable="1" collapsable="1" resize="0">
        <cfform name="upd_site_relation">
            <cfinput type="hidden" name="partner_id" value="#attributes.partner_id#">
            <cfinput type="hidden" name="domains" value="#GET_DOMAINS.recordcount#">
            
            <cfoutput query="GET_DOMAINS">
                <div class="form-group">
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <label>#domain#</label>
                    </div>
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <input type="hidden" name ="site_domain_#currentRow#" value="#DOMAIN#">
                        <div class="checkbox checbox-switch">
                            <label>
                                <input type="checkbox" name ="site_#currentRow#" value="#SITE_ID#" <cfif listFind(selected_site, SITE_ID)> checked</cfif>>
                                <span></span>
                            </label>
                        </div>
                    </div>
                </div>                
            </cfoutput>
           
            <cf_box_footer>
                <cf_workcube_buttons 
                    is_upd='1'
                    is_delete="0"
                    data_action = '/V16/objects/cfc/site_relaton:upd_site_relation'
                >
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>