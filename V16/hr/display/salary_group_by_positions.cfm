<div id="list_salary_by_positions">
    <cfset dashboard_cmp = createObject("component","V16.hr.cfc.hr_dashboard") />
    <cfparam name="attributes.active_year_positions" default="#year(now())#">
    <cfset get_period_years = dashboard_cmp.GET_PERIOD_YEARS(
        company_id : session.ep.company_id
    )/>
    <cfset get_positions_salary = dashboard_cmp.GET_POSITIONS_SALARY(
        active_year : attributes.active_year_positions
    )/>
<cf_box_elements>
    <div class="col col-4 col-xs-12">
        <div class="form-group" id="sel_active_year">
            <label class="col col-12"><cf_get_lang dictionary_id="57493.Aktif"><cf_get_lang dictionary_id="58455.Yıl"></label>
            <div class="col col-12">
                <select name="active_year_positions" id="active_year_positions" onChange="change_active_year_positions();">
                    <cfoutput query="get_period_years">
                        <option value="#PERIOD_YEAR#" <cfif attributes.active_year_positions eq PERIOD_YEAR>selected</cfif>>#PERIOD_YEAR#</option>
                    </cfoutput>
                </select>
            </div>
        </div>
    </div>
</cf_box_elements>  
    <div class="col col-12">
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id="59004.Pozisyon Tipi"></th>
                    <th><cf_get_lang dictionary_id="39384.Maaş"></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_positions_salary.recordcount>
                    <cfoutput query="get_positions_salary">
                        <tr>
                            <td>#POSITION_CAT#</td>
                            <td class="text-right">#TLFormat(MAAS)#</td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="2"><cf_get_lang dictionary_id="58486.Kayıt Bulunamadı"></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
    </div>
</div>
<script type="text/javascript">
	function change_active_year_positions()
	{
        active_year_positions = $("#active_year_positions").val();
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.emptypopup_dashboard_salary_group_by_positions&active_year_positions='+active_year_positions,'list_salary_by_positions',1);
		return true;
	}
</script>