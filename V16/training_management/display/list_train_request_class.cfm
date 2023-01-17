<cfparam name="attributes.request_type" default="1">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.modal_id" default="">
<cfif attributes.request_type eq 1>
	<cfquery name="GET_CLASS" datasource="#DSN#">
		SELECT START_DATE FROM TRAINING_CLASS WHERE CLASS_ID=#attributes.class_id#
	</cfquery>
</cfif>
<cfquery name="GET_EMP_REQ" datasource="#DSN#">
	SELECT
		TRR.REQUEST_ROW_ID,
		TRR.EMPLOYEE_ID,
		TRR.IS_CHIEF_VALID,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
	FROM
	<cfif attributes.request_type eq 1> 
		TRAINING_REQUEST TR,
	</cfif>
		TRAINING_REQUEST_ROWS  TRR,
		EMPLOYEE_POSITIONS E,
		DEPARTMENT D,
		BRANCH B,
		OUR_COMPANY COMP
	WHERE
		E.EMPLOYEE_ID=TRR.EMPLOYEE_ID AND
		E.DEPARTMENT_ID = D.DEPARTMENT_ID AND 
		D.BRANCH_ID = B.BRANCH_ID AND
		B.COMPANY_ID = COMP.COMP_ID AND
		B.BRANCH_ID IN (
					SELECT
						BRANCH_ID
					FROM
						EMPLOYEE_POSITION_BRANCHES
					WHERE
						POSITION_CODE = #SESSION.EP.POSITION_CODE#	
					) AND
		TRR.EMPLOYEE_ID NOT IN (SELECT
									EMP_ID
								FROM
									TRAINING_CLASS_ATTENDER
								WHERE
									CLASS_ID=#attributes.class_id# AND
									EMP_ID IS NOT NULL
								)
	<cfif len(attributes.keyword)>
		AND	(E.EMPLOYEE_NAME LIKE '%#attributes.keyword#%' OR E.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%')
	</cfif>
		<cfif attributes.request_type eq 1>
			AND TRR.TRAINING_ID IN (SELECT TRAIN_ID FROM TRAINING_CLASS_SECTIONS WHERE CLASS_ID=#attributes.class_id#)
			AND TR.TRAIN_REQUEST_ID = TRR.TRAIN_REQUEST_ID
			AND TR.FORM_VALID=1
			AND (
					(TR.SECOND_BOSS_CODE IS NULL AND TRR.FIRST_BOSS_VALID_ROW=1)
					OR (TR.THIRD_BOSS_CODE IS NULL AND TRR.SECOND_BOSS_VALID_ROW=1)
					OR (TR.FOURTH_BOSS_CODE IS NULL AND TRR.THIRD_BOSS_VALID_ROW=1)
					OR (TR.FIFTH_BOSS_CODE IS NULL AND TRR.FOURTH_BOSS_VALID_ROW=1)
					OR TRR.FIFTH_BOSS_VALID_ROW =1
				)
			<cfif isdefined("GET_CLASS.START_DATE") and len(GET_CLASS.START_DATE)>
				AND TR.REQUEST_YEAR = #dateformat(GET_CLASS.START_DATE,'yyyy')#
			</cfif>
		<cfelseif attributes.request_type eq 2> 
			AND	CLASS_ID=#attributes.class_id#
			AND TRAIN_REQUEST_ID IS NULL
			AND ANNOUNCE_ID IS NULL
			AND IS_CHIEF_VALID IN (1,0)
		<cfelseif attributes.request_type eq 3>
			AND ANNOUNCE_ID IN (SELECT ANNOUNCE_ID FROM TRAINING_CLASS_ANNOUNCE_CLASSES WHERE CLASS_ID=#attributes.class_id#)
			AND TRAIN_REQUEST_ID IS NULL
			AND IS_CHIEF_VALID IN (1,0)
		</cfif>
	ORDER BY
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#GET_EMP_REQ.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_str="">
<cfif isdefined("attributes.class_id")>
	<cfset url_str = "#url_str#&class_id=#attributes.class_id#">
</cfif>
<cfif isdefined("attributes.keyword")>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cf_box title="#getLang('','Eğitimi Talep Edenler',46423)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="add_potential_attenders" method="post" action="#request.self#?fuseaction=training_management.popup_list_train_request_class">
        <input type="hidden" name="class_id" id="class_id" value="<cfoutput>#attributes.class_id#</cfoutput>">
        <div class="ui-form-list flex-list">
            <div class="form-group medium">
                <cfinput type="text" name="keyword" value="#attributes.keyword#" placeholder="Filtre">
            </div>
            <div class="form-group" id="item-request_type">
                <select name="request_type" id="request_type" style="width:150px">
                    <option value="1" <cfif attributes.request_type eq 1>selected</cfif>><cf_get_lang no='454.Yıllık Talepler'></option>
                    <option value="2" <cfif attributes.request_type eq 2>selected</cfif>><cf_get_lang no='400.Eğitim Talepleri'></option>
                    <option value="3" <cfif attributes.request_type eq 3>selected</cfif>><cf_get_lang no='455.Duyuru Talepleri'></option>			
                </select>
            </div>
            <div class="form-group small">
                <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
            </div>
            <div class="form-group">
                <cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_potential_attenders' , '#attributes.modal_id#')"),DE(""))#">
            </div>
        </div>
    </cfform>
    <cf_grid_list>
        <cfform name="add_attenders" method="post" action="#request.self#?fuseaction=training_management.emptypopup_train_req_add_attenders">
            <cf_box_elements>
                <thead>
                    <tr>
                        <th width="15"><cf_get_lang_main no='75.No'></th>
                        <th><cf_get_lang_main no='158.Adı Soyadı'></th>
                        <th width="15"><input type="Checkbox" name="all_ch" id="all_ch" value="1" onclick="hepsi();"></th>
                    </tr>
                </thead>
                <tbody>
                    <input type="hidden" name="class_id" id="class_id" value="<cfoutput>#attributes.class_id#</cfoutput>">
                    <cfif GET_EMP_REQ.RECORDCOUNT>
                        <cfoutput query="GET_EMP_REQ" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <tr>
                                <td>#currentrow#</td>
                                <td width="100%"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_detail_emp&emp_id=#EMPLOYEE_ID#','project');" class="tableyazi">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a></td>
                                <td width="15"><cfif IS_CHIEF_VALID eq 1><input type="checkbox" name="employee_ids" id="employee_ids" value="#employee_id#-#REQUEST_ROW_ID#"><cfelseif IS_CHIEF_VALID eq 0>Beklemede</cfif></td>
                            </tr>
                        </cfoutput>
                    <tr>
                        <td colspan="3" style="text-align:right;"><cf_workcube_buttons is_upd='0' add_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_potential_attenders' , '#attributes.modal_id#')"),DE(""))#"></td>
                    </tr>
                    <cfelse>
                        <tr>
                            <td colspan="10"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
                        </tr>
                    </cfif>
                </tbody>
            </cf_box_elements>
        </cfform>
    </cf_grid_list>
    <cf_box_footer>
        <cf_paging 
            page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="training_management.popup_list_train_request_class#url_str#">
    </cf_box_footer>
</cf_box>
<script type="text/javascript">
    function hepsi()
    {
        if (add_attenders.all_ch.checked)
        {
            <cfif GET_EMP_REQ.recordcount gt 1>	
                for(i=0;i<add_attenders.employee_ids.length;i++) add_attenders.employee_ids[i].checked = true;
            <cfelseif GET_EMP_REQ.recordcount eq 1>
                add_attenders.employee_ids.checked = true;
            </cfif>
        }
        else
        {
            <cfif GET_EMP_REQ.recordcount gt 1>	
                for(i=0;i<add_attenders.employee_ids.length;i++) add_attenders.employee_ids[i].checked = false;
            <cfelseif GET_EMP_REQ.recordcount eq 1>
                add_attenders.employee_ids.checked = false;
            </cfif>
        }
    }
</script>