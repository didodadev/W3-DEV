<cfset getComponent = createObject('component','V16.project.cfc.get_project_detail')>
<cf_box class="clever" scroll="0">
    <div class="portHeadLight">
        <div class="portHeadLightTitle">
            <span>
                <a href="javascript://"><cf_get_lang dictionary_id='57590.Katılımcılar'></a>
            </span>
        </div>
    </div>
    <div class="protein-table training_items">
        <cfform method="post" name="attenders_form">
            <table style="table-layout: fixed;">
                <tbody>
                    <cfset attender_types = "get_attender_emps,get_attender_pars,get_attender_cons,get_attender_grps">
                    <cfif get_attender_emps.recordcount>
                        <tbody>
                            <cfset counter = 0>
                            <cfoutput query="get_class_attenders_by_id">
                                <cfif len(get_class_attenders_by_id.emp_id) and len(get_training_groups.train_group_id) and len(get_training_groups.class_id)>
                                    <ul class="ui-list_type2">
                                        <li>
                                            <cfif get_training_groups.recordcount>
                                                <cfset get_joined = cfc.get_joined(train_group_id: get_training_groups.train_group_id, class_id: get_training_groups.class_id, ATTENDER_ID: get_class_attenders_by_id.emp_id)>
                                                <div class="ui-list-img">
                                                    <cfset employee_photo = getComponent.EMPLOYEE_PHOTO(employee_id:get_class_attenders_by_id.emp_id)>
                                                    <cfif len(employee_photo.photo)>
                                                        <cfset emp_photo ="../../documents/hr/#employee_photo.PHOTO#">
                                                    <cfelseif employee_photo.sex eq 1>
                                                        <cfset emp_photo ="images/male.jpg">
                                                    <cfelse>
                                                        <cfset emp_photo ="images/female.jpg">
                                                    </cfif>
                                                    <img src='#emp_photo#' />
                                                </div>
                                                <div class="ui-list-text">
                                                    <span class="name">#get_emp_info(get_class_attenders_by_id.emp_id,0,0)#</span>
                                                    <span class="title">#get_trainers.get_pos_cat(emp_id : get_class_attenders_by_id.emp_id)#</span>
                                                    <ul class="contact-list">
                                                        <cfif len(employee_photo.employee_email)><li><a href="mailto:#employee_photo.employee_email#"><i class="fa fa-envelope-open-o" title="#employee_photo.employee_email#"></i></a></li></cfif>
                                                        <li>
                                                            <a href="javascript://" onclick="cfmodal('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_class_attenders_by_id.emp_id#', 'warning_modal');"><i class="fa fa-user-o"></i></a>
                                                        </li>
                                                        <li>
                                                            <a href="#request.self#?fuseaction=objects.workflowpages&tab=1&subtab=2&employee_id=#get_class_attenders_by_id.emp_id#" target="_blank"><i class="fa fa-comment-o"></i></a>
                                                        </li>
                                                        <!--- <cfloop query="get_trainer_names">
                                                            <cfif T_ID eq session.ep.userid>
                                                                <li>
                                                                    <select name="joined" id="joined">
                                                                        <option value="0" <cfif get_joined.JOINED eq 0>selected<cfelse></cfif>><cf_get_lang dictionary_id='63441.Katılmadı'></option>
                                                                        <option value="1" <cfif get_joined.JOINED eq 1>selected<cfelse></cfif>><cf_get_lang dictionary_id='62465.Katıldı'></option>
                                                                        <option value="2" <cfif get_joined.JOINED eq 2>selected<cfelse></cfif>><cf_get_lang dictionary_id='40347.Mazeretli'></option>
                                                                        <option value="3" <cfif get_joined.JOINED eq 3>selected<cfelse></cfif>><cf_get_lang dictionary_id='63442.Geç Katıldı'></option>
                                                                    </select>
                                                                </li>
                                                            </cfif>
                                                        </cfloop> --->
                                                    </ul>
                                                </div>
                                            </cfif>
                                        </li>
                                    </ul>
                                    <input type="hidden" name="k_id" id="k_id" value="#get_class_attenders_by_id.emp_id#">
                                    <input type="hidden" name="class_attender_id" id="class_attender_id" value="#get_class_attenders_by_id.emp_id#">
                                    <input type="hidden" name="train_group_id" id="train_group_id" value="#get_training_groups.train_group_id#">
                                    <input type="hidden" name="class_id" id="class_id" value="#attributes.lesson_id#">
                                </cfif>
                            </cfoutput>
                        </tbody>
                    </cfif>
                    <cfif get_attender_pars.recordcount>
                        <tbody>
                            <cfset counter = 0>
                            <cfoutput query="get_class_attenders_by_id">
                                <cfif len(get_class_attenders_by_id.par_id) and len(get_training_groups.train_group_id) and len(get_training_groups.class_id)>
                                    <ul class="ui-list_type2">
                                        <li>
                                            <cfif get_training_groups.recordcount>
                                                <cfset get_joined = cfc.get_joined(train_group_id: get_training_groups.train_group_id, class_id: get_training_groups.class_id, ATTENDER_ID: get_class_attenders_by_id.par_id)>
                                                <div class="ui-list-img">
                                                    <cfset employee_photo = getComponent.EMPLOYEE_PHOTO(employee_id:get_class_attenders_by_id.par_id)>
                                                    <cfif len(employee_photo.photo)>
                                                        <cfset emp_photo ="../../documents/hr/#employee_photo.PHOTO#">
                                                    <cfelseif employee_photo.sex eq 1>
                                                        <cfset emp_photo ="images/male.jpg">
                                                    <cfelse>
                                                        <cfset emp_photo ="images/female.jpg">
                                                    </cfif>
                                                    <img src='#emp_photo#' />
                                                </div>
                                                <div class="ui-list-text">
                                                    <span class="name">#get_emp_info(get_class_attenders_by_id.par_id,0,0)#</span>
                                                    <ul class="contact-list">
                                                        <cfif len(employee_photo.employee_email)><li><a href="mailto:#employee_photo.employee_email#"><i class="fa fa-envelope-open-o" title="#employee_photo.employee_email#"></i></a></li></cfif>
                                                        <li>
                                                            <a href="javascript://" onclick="cfmodal('#request.self#?fuseaction=objects.popup_emp_det&par_id=#get_class_attenders_by_id.par_id#', 'warning_modal');"><i class="fa fa-user-o"></i></a>
                                                        </li>
                                                        <li>
                                                            <a href="#request.self#?fuseaction=objects.workflowpages&tab=1&subtab=2&employee_id=#get_class_attenders_by_id.par_id#" target="_blank"><i class="fa fa-comment-o"></i></a>
                                                        </li>
                                                        <!--- <cfloop query="get_trainer_names">
                                                            <cfif T_ID eq session.ep.userid>
                                                                <li>
                                                                    <select name="joined" id="joined">
                                                                        <option value="0" <cfif get_joined.JOINED eq 0>selected<cfelse></cfif>><cf_get_lang dictionary_id='63441.Katılmadı'></option>
                                                                        <option value="1" <cfif get_joined.JOINED eq 1>selected<cfelse></cfif>><cf_get_lang dictionary_id='62465.Katıldı'></option>
                                                                        <option value="2" <cfif get_joined.JOINED eq 2>selected<cfelse></cfif>><cf_get_lang dictionary_id='40347.Mazeretli'></option>
                                                                        <option value="3" <cfif get_joined.JOINED eq 3>selected<cfelse></cfif>><cf_get_lang dictionary_id='63442.Geç Katıldı'></option>
                                                                    </select>
                                                                </li>
                                                            </cfif>
                                                        </cfloop> --->
                                                    </ul>
                                                </div>
                                            </cfif>
                                        </li>
                                    </ul>
                                    <input type="hidden" name="k_id" id="k_id" value="#get_class_attenders_by_id.par_id#">
                                    <input type="hidden" name="class_attender_id" id="class_attender_id" value="#get_class_attenders_by_id.par_id#">
                                    <input type="hidden" name="train_group_id" id="train_group_id" value="#get_training_groups.train_group_id#">
                                    <input type="hidden" name="class_id" id="class_id" value="#attributes.lesson_id#">
                                </cfif>
                            </cfoutput>
                        </tbody>
                    </cfif>
                    <cfif get_attender_cons.recordcount>
                        <tbody>
                            <cfset counter = 0>
                            <cfoutput query="get_class_attenders_by_id">
                                <cfif len(get_class_attenders_by_id.con_id) and len(get_training_groups.train_group_id) and len(get_training_groups.class_id)>
                                    <ul class="ui-list_type2">
                                        <li>
                                            <cfif get_training_groups.recordcount>
                                                <cfset get_joined = cfc.get_joined(train_group_id: get_training_groups.train_group_id, class_id: get_training_groups.class_id, ATTENDER_ID: get_class_attenders_by_id.con_id)>
                                                <div class="ui-list-img">
                                                    <cfset employee_photo = getComponent.EMPLOYEE_PHOTO(employee_id:get_class_attenders_by_id.con_id)>
                                                    <cfif len(employee_photo.photo)>
                                                        <cfset emp_photo ="../../documents/hr/#employee_photo.PHOTO#">
                                                    <cfelseif employee_photo.sex eq 1>
                                                        <cfset emp_photo ="images/male.jpg">
                                                    <cfelse>
                                                        <cfset emp_photo ="images/female.jpg">
                                                    </cfif>
                                                    <img src='#emp_photo#' />
                                                </div>
                                                <div class="ui-list-text">
                                                    <span class="name">#get_emp_info(get_class_attenders_by_id.con_id,0,0)#</span>
                                                    <ul class="contact-list">
                                                        <cfif len(employee_photo.employee_email)><li><a href="mailto:#employee_photo.employee_email#"><i class="fa fa-envelope-open-o" title="#employee_photo.employee_email#"></i></a></li></cfif>
                                                        <li>
                                                            <a href="javascript://" onclick="cfmodal('#request.self#?fuseaction=objects.popup_emp_det&con_id=#get_class_attenders_by_id.con_id#', 'warning_modal');"><i class="fa fa-user-o"></i></a>
                                                        </li>
                                                        <li>
                                                            <a href="#request.self#?fuseaction=objects.workflowpages&tab=1&subtab=2&employee_id=#get_class_attenders_by_id.con_id#" target="_blank"><i class="fa fa-comment-o"></i></a>
                                                        </li>
                                                        <!--- <cfloop query="get_trainer_names">
                                                            <cfif T_ID eq session.ep.userid>
                                                                <li>
                                                                    <select name="joined" id="joined">
                                                                        <option value="0" <cfif get_joined.JOINED eq 0>selected<cfelse></cfif>><cf_get_lang dictionary_id='63441.Katılmadı'></option>
                                                                        <option value="1" <cfif get_joined.JOINED eq 1>selected<cfelse></cfif>><cf_get_lang dictionary_id='62465.Katıldı'></option>
                                                                        <option value="2" <cfif get_joined.JOINED eq 2>selected<cfelse></cfif>><cf_get_lang dictionary_id='40347.Mazeretli'></option>
                                                                        <option value="3" <cfif get_joined.JOINED eq 3>selected<cfelse></cfif>><cf_get_lang dictionary_id='63442.Geç Katıldı'></option>
                                                                    </select>
                                                                </li>
                                                            </cfif>
                                                        </cfloop> --->
                                                    </ul>
                                                </div>
                                            </cfif>
                                        </li>
                                    </ul>
                                    <input type="hidden" name="k_id" id="k_id" value="#get_class_attenders_by_id.con_id#">
                                    <input type="hidden" name="class_attender_id" id="class_attender_id" value="#get_class_attenders_by_id.con_id#">
                                    <input type="hidden" name="train_group_id" id="train_group_id" value="#get_training_groups.train_group_id#">
                                    <input type="hidden" name="class_id" id="class_id" value="#attributes.lesson_id#">
                                </cfif>
                            </cfoutput>
                        </tbody>
                    </cfif>
                    <cfif not len(get_attender_emps.recordcount) and not len(get_attender_pars.recordcount) and not len(get_attender_cons.recordcount) and not len(get_attender_grps.recordcount)>
                        <tr><td><cfoutput><cf_get_lang dictionary_id='57484.Kayıt Yok'></cfoutput> !</td></tr>
                    </cfif>
                </tbody>
            </table>
            <cf_box_footer>
                <!--- <cf_workcube_buttons
                    is_upd="0"
                    data_action = "/V16/training_management/cfc/training_management:upd_lesson_attenders"
                    next_page="#request.self#?fuseaction=training.lesson&event=det&lesson_id=#attributes.lesson_id#"
                > --->
            </cf_box_footer>
        </cfform>
    </div>
</cf_box>