<cfquery name="tevkifats" datasource="#dsn3#">
    SELECT 
        TEVKIFAT_ID, 
        STATEMENT_RATE, 
        DETAIL, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE,
        UPDATE_EMP,
        UPDATE_IP, 
        STATEMENT_RATE_NUMERATOR, 
        STATEMENT_RATE_DENOMINATOR, 
        IS_ACTIVE 
    FROM 
	    SETUP_TEVKIFAT 
    ORDER BY 
    	TEVKIFAT_ID
</cfquery>
<cfset beyan_kodlari= ListSort(ValueList(tevkifats.STATEMENT_RATE,','),'numeric','ASC',',')>

    <cfif tevkifats.recordcount>
        <cfoutput query="tevkifats">
            <div>
                <ul class="ui-list">
                    <li>
                        <a href="#request.self#?fuseaction=settings.form_upd_tevkifat&ID=#TEVKIFAT_ID#" clasS="tableyazi"><i class="fa fa-cube"></i>#STATEMENT_RATE_NUMERATOR#/#STATEMENT_RATE_DENOMINATOR#</a>
                    </li>
                </ul>
            </div>
        </cfoutput>
    <cfelse>
        <div>
            <ul class="ui-list">
                <li><i class="fa fa-cube"></i><cf_get_lang dictionary_id="58486.Kayıt Bulunamadı">!</li>
            </ul>
        </div>
    </cfif>
