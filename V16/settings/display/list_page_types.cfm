<cfquery name="get_page_types" datasource="#dsn#">
	SELECT 
    	PAGE_TYPE_ID, 
        PAGE_TYPE, 
        PAGE_TYPE_DETAIL, 
        OUR_COMPANY_IDS, 
        RECORD_DATE, 
        RECORD_IP, 
        RECORD_EMP, 
        UPDATE_DATE, 
        UPDATE_IP, 
        UPDATE_EMP 
    FROM 
	    SETUP_PAGE_TYPES 
    ORDER BY 
    	PAGE_TYPE
</cfquery>
<cfsavecontent variable="title"><cf_get_lang dictionary_id='42251.Sayfa Tipleri'></cfsavecontent>
<cf_box title="#title#">
    <ul class="ui-list">    
        <cfif get_page_types.RecordCount>
            <cfoutput query="get_page_types">
                <li>    
                    <a href="#request.self#?fuseaction=settings.form_upd_page_type&page_type_id=#page_type_id#">                
                        <div class="ui-list-left">
                            <span class="ui-list-icon ctl-school-material-1"></span>
                            #page_type#
                        </div>                      
                    </a>             
                </li>                     
            </cfoutput>
        <cfelse>
            <li>      
                <font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font>
            </li>  
        </cfif>
    </ul>
</cf_box>
