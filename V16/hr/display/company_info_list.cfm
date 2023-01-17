<cfquery name="get_company" datasource="#dsn#">
	SELECT
		COMP_ID,
		COMPANY_NAME,
		NICK_NAME
	FROM
		OUR_COMPANY
	ORDER BY
		COMPANY_NAME
</cfquery>
<cfif isdefined("attributes.hr")>
	<cfset formun_adresi = 'hr.company_info_list&hr=1'>
<cfelse>
	<cfset formun_adresi = 'settings.company_info_list'>
</cfif>
<cf_box title="#getLang('main',1734)#">
    <cf_box_search>  
        <div class="form-group">
            <cfif isdefined("attributes.hr")><cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'></cfif>
        </div>
    </cf_box_search>
    <cf_flat_list>
        <thead>
            <tr> 
                <th><cf_get_lang dictionary_id="58485.Şirket Adı"></th>
            </tr>
        </thead>
        <tbody>
            <cfif get_company.RecordCount>
                <cfoutput query="get_company"> 
                    <tr>
                        <td>
                            <a href="#request.self#?fuseaction=hr.company_info&comp_id=#COMP_ID#">#COMPANY_NAME#</a>
                        </td>
                    </tr>
                </cfoutput> 
                <cfelse>
                    <tr> 
                        <td colspan="6"><cf_get_lang dictionary_id="58486.Kayıt Bulunamadı">!</td>
                    </tr>
            </cfif>
        </tbody>
    </cf_flat_list>
</cf_box>
