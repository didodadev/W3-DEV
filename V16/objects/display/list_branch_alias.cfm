<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
	<cfquery name="GET_COMPANY" datasource="#DSN#">
    	SELECT C.IS_PERSON,C.TAXNO,C.MANAGER_PARTNER_ID,CP.TC_IDENTITY FROM COMPANY C,COMPANY_PARTNER CP WHERE C.MANAGER_PARTNER_ID = CP.PARTNER_ID AND C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
	</cfquery>
    <cfquery name="GET_ALIAS" datasource="#DSN#">
        SELECT ALIAS, REGISTER_DATE,ALIAS_CREATION_DATE FROM EINVOICE_COMPANY_IMPORT WHERE TAX_NO = <cfif get_company.is_person eq 1><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_company.tc_identity#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_company.taxno#"></cfif>
    </cfquery>
<cfelse>
	<cfset get_alias.recordcount=0>
</cfif>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='30221.Şube Alias Tanımları'></cfsavecontent>
<cf_box title='#message#'>
	<cf_grid_list>
    <thead>
        <tr> 
            <th width="55"><cf_get_lang dictionary_id='57487.No'></th>
            <th><cf_get_lang dictionary_id='30221.Alias Tanımı'></th>
            <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
            <th><cf_get_lang dictionary_id='60078.Alias'> <cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
        </tr>
    </thead>
    <tbody>
        <cfif get_alias.recordcount>
            <cfoutput query="get_alias">
                <tr>
                    <td>#currentrow#</td>
                    <td><a href="javascript://" onclick="add_alias('#alias#');" class="tableyazi">#alias#</a></td>
                    <td>#dateformat(register_date,dateformat_style)#</td>
                  	<td>#dateformat(alias_creation_date,dateformat_style)#</td>
                </tr>
            </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                </tr>
        </cfif>
    </tbody>
	</cf_grid_list>
</cf_box>
<script type="text/javascript">
function add_alias(alias,name)
{
	<cfif isdefined("attributes.field_alias")>
		opener.<cfoutput>#field_alias#</cfoutput>.value = alias;
	</cfif>
	window.close();
}
</script>
