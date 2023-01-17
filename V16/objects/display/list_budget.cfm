<cf_xml_page_edit fuseact="objects.list_budget">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.search_year" default="#year(now())#">
<cfquery name="GET_BUDGET" datasource="#dsn#">
	SELECT
		BUDGET_ID,
		BUDGET_NAME
	FROM
		BUDGET
	WHERE
		BUDGET_ID IS NOT NULL AND
        OUR_COMPANY_ID = #session.ep.company_id#
		<cfif len(attributes.keyword)>
			AND BUDGET_NAME LIKE '%#attributes.keyword#%'
		</cfif>
		<cfif len(attributes.search_year)>
			AND PERIOD_YEAR = #attributes.search_year#
		</cfif>
		<cfif xml_authorized_budget eq 1>
			AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
		</cfif>
	ORDER BY 
		BUDGET_NAME
</cfquery>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_budget.recordcount#'>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1>

<cfset url_string = "">
<cfif isdefined("field_id")>
  <cfset url_string = "#url_string#&field_id=#field_id#">
</cfif>
<cfif isdefined("field_name")>
  <cfset url_string = "#url_string#&field_name=#field_name#">
</cfif>
<cfif isdefined("attributes.related_project_id") and len(attributes.related_project_id)>
  <cfset url_string = "#url_string#&related_project_id=#attributes.related_project_id#">
</cfif>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Bütçeler',57524)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="search_con" action="#request.self#?fuseaction=objects.popup_list_budget#url_string#" method="post">
            <cf_box_search>
                <div class="form-group">
                    <cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255" placeholder="#getLang('','Filtre',57460)#">
                </div>
                <div class="form-group">
                    <select name="search_year" id="search_year">
                        <option value=""><cf_get_lang dictionary_id='58455.Yıl'> / <cf_get_lang dictionary_id='58472.Dönem'></option>
                        <cfloop from="#evaluate(session.ep.period_year-1)#" to="#evaluate(session.ep.period_year+4)#" index="k">
                            <cfoutput><option value="#k#" <cfif isdefined("attributes.search_year") and attributes.search_year eq k>selected</cfif>>#k#</option></cfoutput>					
                        </cfloop>
                    </select>
                </div>
                <div class="form-group small">
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_con' , #attributes.modal_id#)"),DE(""))#">
                </div>
            </cf_box_search>
        </cfform>
        <cf_flat_list>
            <thead>
                <tr>
                    <th width="100"><cf_get_lang dictionary_id="57487.No"></th>
                    <th><cf_get_lang dictionary_id ='57559.Bütçe'></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_budget.recordcount>
                    <cfoutput query="get_budget" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td>
                                <cfif isdefined("related_project_id") and len(attributes.related_project_id)>
                                    <a href="#request.self#?fuseaction=objects.emptypopup_add_related_budget&budget_id=#budget_id#&related_project_id=#related_project_id#" class="tableyazi">#BUDGET_NAME#</a>
                                <cfelse>
                                    <a href="javascript://" onclick="gonder('#BUDGET_ID#','#BUDGET_NAME#');" class="tableyazi">#BUDGET_NAME#</a>
                                </cfif>
                            </td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="2" height="20"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
                    </tr>
                </cfif>
            </tbody>
        </cf_flat_list>
        <cfif attributes.maxrows lt attributes.totalrecords>
            <cfif isDefined("attributes.draggable") and len(attributes.draggable)>
				<cfset url_string = '#url_string#&draggable=#attributes.draggable#'>
			</cfif>
            <cf_paging page="#attributes.page#" 
                maxrows="#attributes.maxrows#" 
                totalrecords="#attributes.totalrecords#" 
                startrow="#attributes.startrow#" 
                adres="objects.popup_list_budget#url_string#&keyword=#attributes.keyword#&search_year=#attributes.search_year#"
                isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
        </cfif>
    </cf_box>
</div>
<script type="text/javascript">
	document.search_con.keyword.focus();
	function gonder(no,deger)
	{
		<cfif isDefined("attributes.field_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value=no;
		</cfif>
		<cfif isDefined("attributes.field_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value=deger;
		</cfif>
		<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
</script>


