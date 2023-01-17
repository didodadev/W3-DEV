<cfquery name="get_object_design" datasource="#dsn#">
	SELECT 
    	DESIGN_ID, 
        DESIGN_NAME, 
        DESIGN_DETAIL, 
        DESIGN_PATH, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP 
    FROM 
	    MAIN_SITE_OBJECT_DESIGN 
    ORDER BY 
    	DESIGN_ID
</cfquery>
<cfsavecontent variable="title"><cf_get_lang dictionary_id='29792.Tasarım'></cfsavecontent>
<cf_box title="#title#">
    <ul class="ui-list">   
        <cfif get_object_design.RecordCount>
            <cfoutput query="get_object_design"> 
                <li>
                    <a href="#request.self#?fuseaction=settings.form_upd_object_design&id=#design_id#">
                        <div class="ui-list-left">
                            <span class="ui-list-icon ctl-packing-3"></span>
                            #design_id# - #DESIGN_NAME#
                        </div> 
                    </a>
                </li>                         
            </cfoutput>
        <cfelse> 
            <cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!           
        </cfif>
    </ul>
</cf_box>

