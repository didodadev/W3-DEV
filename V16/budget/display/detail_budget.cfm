<cfinclude template="../query/get_general_budget.cfm">
<!---<cfsavecontent variable="right">
			<cfoutput><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=budget.detail_budget&action_name=budget_id&action_id=#attributes.budget_id#','list');"><img src="/images/uyar.gif" alt="<cf_get_lang dictionary_id='345.Uyarılar'>" title="<cf_get_lang dictionary_id='345.Uyarılar'>" align="absmiddle" border="0"></a></cfoutput>
			<a href="<cfoutput>#request.self#?fuseaction=budget.detail_budget_report&general_budget_id=#attributes.budget_id#</cfoutput>"><img src="images/report.gif" alt="<cf_get_lang dictionary_id='1648.Bütçe Raporu'>" title="<cf_get_lang dictionary_id='1648.Bütçe Raporu'>" align="absmiddle" border="0"></a>
			<a href="<cfoutput>#request.self#?fuseaction=budget.list_budget_plan_row&budget_id=#attributes.budget_id#</cfoutput>"><img src="images/properties.gif" alt="<cf_get_lang no='80.Bütçe Planı'>" align="absmiddle" title="<cf_get_lang no='80.Bütçe Planı'>" border="0"></a>
			<a href="<cfoutput>#request.self#?fuseaction=budget.add_budget_plan&budget_id=#attributes.budget_id#</cfoutput>"><img src="/images/money_plus.gif" align="absmiddle" alt="<cf_get_lang no='78.Gelir/Gider Planı Ekle'>" title="<cf_get_lang no='78.Gelir/Gider Planı Ekle'>" border="0"></a>
			<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=budget.popup_upd_budget&budget_id=#attributes.budget_id#</cfoutput>','medium');"><img src="images/refer.gif" align="absmiddle" alt="<cf_get_lang dictionary_id='52.güncelle'>" title="<cf_get_lang dictionary_id='52.güncelle'>" border="0"></a>
			<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=budget.popup_add_budget','medium');"><img src="/images/plus1.gif" align="absmiddle" alt="<cf_get_lang dictionary_id='170.Ekle'>" title="<cf_get_lang dictionary_id='170.Ekle'>" border="0"></a>
			<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.budget_id#&print_type=330</cfoutput>','page');"><img src="/images/print.gif" align="absmiddle" border="0" alt="<cf_get_lang dictionary_id='62.Yazdır'>" title="<cf_get_lang dictionary_id='62.Yazdır'>"></a> 

</cfsavecontent>--->
<cf_catalystHeader>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent variable="title"><cf_get_lang dictionary_id="57524.Bütçeler"></cfsavecontent>
    <cf_box title="#title#" closable="0">
        <cfoutput>
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group">
                        <label class="col col-3 col-xs-3"><cf_get_lang dictionary_id='57559.Bütçe'>:</label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                #GET_BUDGET_DETAIL.BUDGET_NAME#
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-3 col-xs-3"><cf_get_lang dictionary_id='58472.Dönem'>:</label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                #GET_BUDGET_DETAIL.PERIOD_YEAR#
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-3 col-xs-3"><cf_get_lang dictionary_id='57482.Aşama'>:</label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                #GET_BUDGET_DETAIL.STAGE#
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group">
                        <label class="col col-3 col-xs-3"><cf_get_lang dictionary_id='57453.Şube'>:</label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <cfif len(GET_BUDGET_DETAIL.BRANCH_ID)>
                                    <cfquery name="BRANCHES" datasource="#DSN#">
                                        SELECT BRANCH_NAME FROM BRANCH WHERE BRANCH_ID = #GET_BUDGET_DETAIL.BRANCH_ID#
                                    </cfquery>
                                    #BRANCHES.BRANCH_NAME#
                                </cfif>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-3 col-xs-3"><cf_get_lang dictionary_id='57572.Departman'>:</label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <cfif len(GET_BUDGET_DETAIL.DEPARTMENT_ID)>
                                    <cfquery name="DEPARTMENTS" datasource="#DSN#">
                                        SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = #GET_BUDGET_DETAIL.DEPARTMENT_ID#
                                    </cfquery>
                                    #DEPARTMENTS.DEPARTMENT_HEAD#
                                </cfif>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-3 col-xs-3"><cf_get_lang dictionary_id='57629.Açıklama'>:</label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                #get_budget_detail.detail#
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group">
                        <label class="col col-3 col-xs-3"><cf_get_lang dictionary_id ='57416.Proje'>:</label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <cfif len(GET_BUDGET_DETAIL.PROJECT_ID)>
                                    <cfquery name="GET_PROJECT" datasource="#DSN#">
                                        SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID=#GET_BUDGET_DETAIL.PROJECT_ID#
                                    </cfquery>
                                    #GET_PROJECT.PROJECT_HEAD#
                                </cfif>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-3 col-xs-3"><cf_get_lang dictionary_id='58140.İş Grubu'>:</label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <cfif len(GET_BUDGET_DETAIL.WORKGROUP_ID)>
                                    <cfquery name="GET_WORKGROUP" datasource="#dsn#">
                                        SELECT WORKGROUP_NAME FROM WORK_GROUP WHERE WORKGROUP_ID = #GET_BUDGET_DETAIL.WORKGROUP_ID#
                                    </cfquery>
                                #GET_WORKGROUP.WORKGROUP_NAME#
                                </cfif>
                            </div>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
        </cfoutput>	
            <cf_box_footer>
                <div class="col col-12">        
                    <cf_record_info query_name="GET_BUDGET_DETAIL">
                </div>
            </cf_box_footer>
        </cf_box>
        <!--- <div class="row">
        	<div class="col col-12"> --->
				<cfinclude template="list_budget_plans.cfm">
            <!--- </div>
        </div> --->