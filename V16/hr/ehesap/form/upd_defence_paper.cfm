<cfinclude template="../query/get_defence_detail.cfm">
<cfparam name="attributes.defence_id" default="">
<cfparam name="attributes.event_id" default="">


<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Savunma Talep Yazısı',53295)#" print_href="#request.self#?fuseaction=ehesap.popup_detail_defence_paper&defence_id=#attributes.defence_id#">
        <cfform  name="add_defence" action="#request.self#?fuseaction=ehesap.emptypopup_upd_defence_paper" method="post">
            <cf_box_elements>
                <div class="col col-12 col-md-12 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58183.Yazan'>*</label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="defence_id" id="defence_id" value="<cfoutput>#attributes.defence_id#</cfoutput>">
								<input type="hidden" name="event_id" id="event_id" value="<cfoutput>#get_defence.EVENT_ID#</cfoutput>">
								<input type="hidden" name="writer_id" id="writer_id" value="<cfoutput>#get_defence.WRITER_ID#</cfoutput>">
								<cfset EMP_ID=get_defence.WRITER_ID>
								<cfif len(EMP_ID)>
									<cfinclude template="../query/get_action_emp.cfm">
									<cfset emp_name="#get_emp.EMPLOYEE_NAME# #get_emp.EMPLOYEE_SURNAME#">
								<cfelse>
									<cfset emp_name="">
								</cfif>
								<input type="text" name="writer" id="writer" value="<cfoutput>#emp_name#</cfoutput>" style="width:150px;">
								<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=add_defence.writer_id&field_emp_name=add_defence.writer','list');return false"></span> 
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='53297.İmza Tarihi'></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <cfinput validate="#validate_style#" type="text" name="PAPER_DATE" value="#dateformat(get_defence.PAPER_DATE,dateformat_style)#" style="width:150px;">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="PAPER_DATE"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col col-12 col-xs-12">
                            <cfmodule
							template="/fckeditor/fckeditor.cfm"
							toolbarSet="WRKContent"
							basePath="/fckeditor/"
							instanceName="detail"
							valign="top"
							value="#get_defence.DETAIL#"
							width="500"
							height="300">
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
