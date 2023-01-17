<cfquery name="ICONS" datasource="#dsn3#">
	SELECT 
    	ICON_ID, 
        ICON, 
        IS_VISION,
        ICON_SERVER_ID, 
        RECORD_DATE, 
        RECORD_EMP, 
        UPDATE_DATE, 
        UPDATE_EMP 
    FROM 
	    SETUP_PROMO_ICON
</cfquery>

<cfsavecontent variable="title"><cf_get_lang no='123.Promosyon İkonları'></cfsavecontent>
<cf_box title="#title#">
    <ul class="ui-list">   
        <cfif icons.RecordCount>
            <cfoutput query="icons"> 
                <li class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    <a href="#request.self#?fuseaction=settings.form_upd_icon&ID=#icon_ID#">
                        <div class="ui-list-left" style="justify-content:center">                            
                            <cfif len(icon)><img src="/documents/sales/#icon#" height="50px" width="50px"></cfif>
                        </div> 
                    </a>
                </li>                         
            </cfoutput>
        <cfelse> 
            <cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!           
        </cfif>
    </ul>
</cf_box>