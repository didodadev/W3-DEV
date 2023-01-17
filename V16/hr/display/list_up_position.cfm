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
<cf_box title="#getLang('','Kariyer Planlama',55976)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform action="" method="post" name="employee_career">
        <cf_box_elements>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                <cfquery name="get_position_cat_name" datasource="#dsn#">
                    SELECT 
                        POSITION_CAT 
                    FROM
                        SETUP_POSITION_CAT
                    WHERE
                        POSITION_CAT_ID=#attributes.position_cat_id#
                </cfquery>
                <div class="form-group require" id="item-position_cat">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='59004.Pozisyon Tipi'>:</label>
                    <div class="col col-8 col-sm-12">
                        <cfoutput>#get_position_cat_name.POSITION_CAT#</cfoutput>
                    </div>                
                </div> 
            </div>
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group require" id="item-position_name">
                    <label class="col col-12 col-sm-12 text-bold"><cf_get_lang dictionary_id='55978.Üst Pozisyonlar'></label>
                </div> 
                <cfoutput query="get_ust_pos_cat">
                    <div class="form-group require" id="item-position_name2">
                        <label class="col col-9 col-sm-12">#POSITION_NAME#</label>
                        <div class="col col-3 col-sm-12">
                            <cfif not listfindnocase(denied_pages,'hr.popup_list_position_cat_requirements')>
                                <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=hr.popup_list_position_cat_requirements&position_cat_id=#CAT_ID#','','ui-draggable-box-small');"><i class="fa fa-magic" title="<cf_get_lang dictionary_id='56341.Yeterlilik Güncelle'>"></i></a>
                            </cfif> 
                        </div>                
                    </div> 
                </cfoutput>
            </div>
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group require" id="item-position_cat">
                    <label class="col col-12 col-sm-12 text-bold"><cf_get_lang dictionary_id='55977.Alt Pozisyonlar'></label>
                </div> 
                <cfoutput query="get_alt_pos_cat">
                    <div class="form-group require" id="item-position_cat2">
                        <label class="col col-9 col-sm-12">#POSITION_NAME#</label>
                        <div class="col col-3 col-sm-12">
                            <cfif not listfindnocase(denied_pages,'hr.popup_list_position_cat_requirements')>
                                <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=hr.popup_list_position_cat_requirements&position_cat_id=#CAT_ID#','','ui-draggable-box-small');"><i class="fa fa-magic" title="<cf_get_lang dictionary_id='56341.Yeterlilik Güncelle'>"></i></a>
                            </cfif>
                        </div>                
                    </div> 
                </cfoutput>
            </div>
        </cf_box_elements>
    </cfform>
</cf_box>
