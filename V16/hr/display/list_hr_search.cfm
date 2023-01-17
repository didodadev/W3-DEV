<cfscript>
	duty_type = QueryNew("DUTY_TYPE_ID, DUTY_TYPE_NAME");
	QueryAddRow(duty_type,9);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",2,1);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#getLang('main',164)#",1); //çalışan
	QuerySetCell(duty_type,"DUTY_TYPE_ID",1,2);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#getLang('hr',1320)#",2);//işveren vekili
	QuerySetCell(duty_type,"DUTY_TYPE_ID",0,3);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#getLang('hr',1321)#",3);//işveren
	QuerySetCell(duty_type,"DUTY_TYPE_ID",3,4);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#getLang('hr',807)#",4); //sendikalı
	QuerySetCell(duty_type,"DUTY_TYPE_ID",4,5);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#getLang('hr',808)#",5); //sözleşmeli
	QuerySetCell(duty_type,"DUTY_TYPE_ID",5,6);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#getLang('hr',809)#",6); //kapsam dışı
	QuerySetCell(duty_type,"DUTY_TYPE_ID",6,7);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#getLang('hr',811)#",7); //kısmi istihdam
	QuerySetCell(duty_type,"DUTY_TYPE_ID",7,8);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#getLang('ehesap',253)#",8);//Taşeron
	QuerySetCell(duty_type,"DUTY_TYPE_ID",8,9);//derece-kademe
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#getLang('ehesap',1233)#/#getLang('main',1298)#",9);
</cfscript>
<cfform name="employees" action="#request.self#?fuseaction=#url.fuseaction#">
	<input type="hidden" name="form_submitted" id="form_submitted" value="1" />
	<cf_box>
		<cf_box_search>
        	<cfoutput>
                    <div class="form-group">
                        <input type="text" name="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang('main',48)#">
                    </div>
                    <div class="form-group">
                        <input type="text" name="keyword2" value="#attributes.keyword2#" maxlength="50" placeholder="#getLang('main',1075)#">
                    </div>
                    <div class="form-group">
                        <input type="text" name="hierarchy" value="#attributes.hierarchy#" maxlength="50" placeholder="#getLang('main',377)#">
                    </div>
                    <div class="form-group">
                        <select name="emp_status" id="emp_status">
                            <option value="1" <cfif isDefined("attributes.emp_status")and (attributes.emp_status eq 1)>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                            <option value="-1" <cfif isDefined("attributes.emp_status")and(attributes.emp_status eq -1)>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                            <option value="0" <cfif isDefined("attributes.emp_status")and (attributes.emp_status eq 0)>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                        </select>
                    </div>
                    <div class="form-group small">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
                    </div>
                    <div class="form-group">
                        <cf_wrk_search_button button_type="4">
                        <!--- <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'> --->
                    </div>
                    <div class="form-group" id="form_ul_add_employee_quick">
                        <a class="ui-btn ui-btn-gray2" href="<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_hr&event=add_rapid"><cf_get_lang dictionary_id="49390.Hızlı Çalışan Ekle"></a>						
                    </div>
			</cfoutput>
		</cf_box_search>
		<cf_box_search_detail>
            <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-branch_id">
                    <label><cf_get_lang dictionary_id='57453.Şube'></label>
                    <select name="branch_id" id="branch_id" onChange="showDepartment(this.value)">
                        <option value="all" <cfif isdefined("attributes.branch_id") and attributes.branch_id is 'all'>selected</cfif>><cf_get_lang dictionary_id='57453.Şube'></option>
                        <cfoutput query="get_branches" group="NICK_NAME">
                            <optgroup label="#get_branches.NICK_NAME#"></optgroup>
                            <cfoutput>
                                <option value="#get_branches.BRANCH_ID#"<cfif isdefined("attributes.branch_id") and (attributes.branch_id eq get_branches.branch_id)> selected</cfif>>#get_branches.BRANCH_NAME#</option>
                            </cfoutput>
                        </cfoutput>
                    </select>
                </div>
                <cfoutput>
                <div class="form-group" id="item-department">
                    <label><cf_get_lang dictionary_id='57572.Departman'></label>
                    <div id="DEPARTMENT_PLACE">					
                        <select name="department" id="department">
                            <option value=""><cf_get_lang dictionary_id='57572.Departman'></option>
                            <cfif isdefined('attributes.branch_id') and isnumeric(attributes.branch_id)>
                                <cfloop query="get_department">
                                    <option value="#department_id#"<cfif isdefined('attributes.department') and (attributes.department eq get_department.department_id)>selected</cfif>>#department_head#</option>
                                </cfloop>
                            </cfif>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-position_cat_id">
                    <label><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></label>
                    <select name="position_cat_id" id="position_cat_id">
                        <option value=""><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'>
                        <cfloop query="GET_POSITION_CATS_">
                            <option value="#position_cat_id#"<cfif attributes.position_cat_id eq position_cat_id> selected</cfif>>#position_cat#</option>
                        </cfloop>
                    </select>
                </div>
                </cfoutput>
            </div>
            <cfoutput>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                	<div class="form-group" id="item-title_id">
                        <label><cf_get_lang dictionary_id ='55168.Ünvanlar'></label>
                        <select name="title_id" id="title_id">
                            <option value=""><cf_get_lang dictionary_id ='55168.Ünvanlar'></option>
                            <cfloop query="titles">
                                <option value="#title_id#" <cfif attributes.title_id eq title_id>selected</cfif>>#title#</option>
                            </cfloop>
                        </select>
                    </div>
                    <div class="form-group" id="item-process_stage">
                        <label><cf_get_lang dictionary_id='57482.Aşama'></label>
                        <select name="process_stage" id="process_stage">
                            <option value=""><cf_get_lang dictionary_id='57482.Aşama'></option>
                            <cfloop query="get_process_stage">
                                <option value="#process_row_id#" <cfif isdefined("attributes.process_stage") and (attributes.process_stage eq process_row_id)>selected</cfif>>#stage#</option>
                            </cfloop>
                        </select>
                    </div>
                    <div class="form-group" id="item-duty_type">
                        <label><cf_get_lang dictionary_id='55891.Çalışan Tipi'></label>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="55891.Çalışan Tipi"></cfsavecontent>					
                        <cf_multiselect_check 
                            query_name="duty_type"  
                            name="duty_type"
                            width="135" 
                            option_value="DUTY_TYPE_ID"
                            option_name="DUTY_TYPE_NAME"
                            value="#attributes.duty_type#"
                                option_text="#message#">
                    </div>
                </div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                	<div class="form-group" id="item-func_id">
                        <label><cf_get_lang dictionary_id='58701.Fonksiyon'></label>
                        <select name="func_id" id="func_id">
                            <option value=""><cf_get_lang dictionary_id='58701.Fonksiyon'></option>
                            <cfloop query="get_units">
                                <option value="#unit_id#" <cfif attributes.func_id eq unit_id>selected</cfif>>#unit_name#</option>
                            </cfloop>
                        </select>
                    </div>
                    <div class="form-group" id="item-organization_step_id">
                        <label><cf_get_lang dictionary_id='58710.Kademe'></label>
                        <select name="organization_step_id" id="organization_step_id">
                            <option value=""><cf_get_lang dictionary_id='58710.Kademe'></option>
                            <cfloop query="get_organization_steps">
                                <option value="#organization_step_id#" <cfif attributes.organization_step_id eq organization_step_id>selected</cfif>>#ORGANIZATION_STEP_NAME#</option>
                            </cfloop>
                        </select>
                    </div>
                	<div class="form-group" id="item-collar_type">
                        <label><cf_get_lang dictionary_id='56063.Yaka Tipi'></label>
                        <select name="collar_type" id="collar_type">
                            <option value=""><cf_get_lang dictionary_id='56063.Yaka Tipi'></option>
                            <option value="1"<cfif attributes.collar_type eq 1> selected</cfif>><cf_get_lang dictionary_id='56065.Mavi Yaka'></option> 
                            <option value="2"<cfif attributes.collar_type eq 2> selected</cfif>><cf_get_lang dictionary_id='56066.Beyaz Yaka'></option>
                        </select>
                    </div>
                </div>
            </cfoutput>
		</cf_box_search_detail>
	</cf_box>
</cfform>
