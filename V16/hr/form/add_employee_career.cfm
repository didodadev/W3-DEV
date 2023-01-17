<cfquery datasource="#dsn#" name="get_alt_pos_cat">
	SELECT 
		EC.RELATED_POS_CAT_ID AS CAT_ID,
		EC.STEP_NO AS STEP_NO,
		SPC.POSITION_CAT AS POSITION_NAME
	FROM
		EMPLOYEE_CAREER EC,
		SETUP_POSITION_CAT SPC
	WHERE
		EC.POSITION_CAT_ID=#attributes.position_cat_id#
		AND STATE=0
		AND SPC.POSITION_CAT_ID=EC.RELATED_POS_CAT_ID
	ORDER BY STEP_NO
</cfquery>
<cfquery datasource="#dsn#" name="get_ust_pos_cat">
	SELECT 
		EC.RELATED_POS_CAT_ID AS CAT_ID,
		EC.STEP_NO AS STEP_NO,
		SPC.POSITION_CAT AS POSITION_NAME
	FROM
		EMPLOYEE_CAREER EC,
		SETUP_POSITION_CAT SPC
	WHERE
		EC.POSITION_CAT_ID=#attributes.position_cat_id#
		AND STATE=1
		AND SPC.POSITION_CAT_ID=EC.RELATED_POS_CAT_ID
	ORDER BY STEP_NO
</cfquery>
<cfparam name="attributes.modal_id" default="">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('hr',891)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#"><!---Kariyer Planlama'--->
        <cfform action="" method="post" name="employee_career">
                <!--- <input type="hidden" name="position_cat_id" value="<cfoutput>#attributes.position_cat_id#</cfoutput>"> --->
                    <cfquery name="get_position_cat_name" datasource="#dsn#">
                        SELECT 
                            POSITION_CAT 
                        FROM
                            SETUP_POSITION_CAT
                        WHERE
                            POSITION_CAT_ID=#attributes.position_cat_id#
                    </cfquery>
                    <cf_box_elements>
                        <div class="form-group margin-left-10 bold">
                            <cf_get_lang dictionary_id='59004.Pozisyon Tipi'>: <cfoutput>#get_position_cat_name.POSITION_CAT#</cfoutput>
                        </div>
                    </cf_box_elements>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <cf_grid_list>
                            <thead>
                                <tr>
                                    <th width="15" class="text-center"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_pos_cats&pcat_id=#attributes.position_cat_id#&is_ust=1</cfoutput>');closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>')"><i class="fa fa-plus"></i></a></th>
                                    <th colspan="3"><cf_get_lang dictionary_id='55978.Üst Pozisyonlar'> </th>
                                </tr>
                            </thead>
                            <tbody>
                            <cfoutput query="get_ust_pos_cat">
                                <tr>
                                    <td width="15" class="text-center"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.emptypopup_del_employee_career&pcat_id=#attributes.position_cat_id#&is_ust=1&step_no=#STEP_NO#&rel_pos_id=#CAT_ID#','small');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
                                    <td>#POSITION_NAME#</td>
                                    <td width="15"><cfif currentrow neq get_ust_pos_cat.recordcount><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=hr.emptypopup_add_step_no&type=0&pcat_id=#attributes.position_cat_id#&is_ust=1&step_no=#STEP_NO#&rel_pos_id=#CAT_ID#','#attributes.modal_id#')"><i class="fa fa-caret-down" title="<cf_get_lang dictionary_id='55781.Aşağı'>"></i></a><cfelse>&nbsp;</cfif></td>
                                    <td width="15"><cfif currentrow neq 1><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=hr.emptypopup_add_step_no&type=1&pcat_id=#attributes.position_cat_id#&is_ust=1&step_no=#STEP_NO#&rel_pos_id=#CAT_ID#','#attributes.modal_id#')"><i class="fa fa-caret-up" title="<cf_get_lang dictionary_id='55780.Yukarı'>"></i></a><cfelse>&nbsp;</cfif></td>
                                </tr>
                            </cfoutput>
                            </tbody>
                        </cf_grid_list> 
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">

                        <cf_grid_list>
                            <thead>
                                <tr> 
                                <th width="15" class="text-center"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_pos_cats&pcat_id=#attributes.position_cat_id#&is_ust=0</cfoutput>');closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>')"><i class="fa fa-plus"></i></a></th>
                                <th colspan="3"><cf_get_lang dictionary_id='55977.Alt Pozisyonlar'></th>
                                </tr>
                            </thead>
                            <tbody>
                            <cfoutput query="get_alt_pos_cat">
                                <tr>
                                    <td width="15" class="text-center"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.emptypopup_del_employee_career&pcat_id=#attributes.position_cat_id#&is_ust=0&step_no=#STEP_NO#&rel_pos_id=#CAT_ID#','small');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
                                    <td>#POSITION_NAME#</td>
                                    <td width="15"><cfif currentrow neq get_alt_pos_cat.recordcount><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=hr.emptypopup_add_step_no&type=0&pcat_id=#attributes.position_cat_id#&is_ust=0&step_no=#STEP_NO#&rel_pos_id=#CAT_ID#','#attributes.modal_id#')"><i class="fa fa-caret-down" title="<cf_get_lang dictionary_id='55781.Aşağı'>"></i></a><cfelse>&nbsp;</cfif></td>
                                    <td width="15"><cfif currentrow neq 1><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=hr.emptypopup_add_step_no&type=1&pcat_id=#attributes.position_cat_id#&is_ust=0&step_no=#STEP_NO#&rel_pos_id=#CAT_ID#','#attributes.modal_id#')"><i class="fa fa-caret-up" title="<cf_get_lang dictionary_id='55780.Yukarı'>"></i></a><cfelse>&nbsp;</cfif></td>
                                </tr>
                            </cfoutput>
                            </tbody>
                        </cf_grid_list>
                    </div>

        </cfform>
    </cf_box>
</div>