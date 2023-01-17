<cfquery name="GET_EMP_SCHOOL" datasource="#DSN#" maxrows="1">
	SELECT
		LAST_SCHOOL
	FROM
		EMPLOYEES_DETAIL
	WHERE
		LAST_SCHOOL=#attributes.ID#
	UNION ALL
	SELECT
		EDU_ID
	FROM
		EMPLOYEES_APP_EDU_INFO
	WHERE
		EDU_ID=#attributes.ID#
</cfquery>
<cf_box title="#getLang('', 'Okul Bilgisi Güncelle', 42295)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform action="#request.self#?fuseaction=settings.emptypopup_upd_school" method="post" name="upd_school">
        <cf_box_elements>
            <div class="col col-12">
                <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <label><cf_get_lang dictionary_id='44803.Okul Tipi'></label>
                    </div>
                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                        <cfquery name="CATEGORIES" datasource="#dsn#">
                            SELECT 
                                * 
                            FROM 
                                SETUP_SCHOOL
                            WHERE 
                                SCHOOL_ID=#URL.ID#
                        </cfquery>
                        <input type="Hidden" name="SCHOOL_ID" id="SCHOOL_ID" value="<cfoutput>#URL.ID#</cfoutput>">
                        <select name="school_type" id="school_type">
                            <option value="0" <cfif categories.school_type eq 0>selected</cfif>><cf_get_lang dictionary_id='44806.Devlet'></option>
                            <option value="1" <cfif categories.school_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57979.Özel'></option>
                            <option value="2" <cfif categories.school_type eq 2>selected</cfif>><cf_get_lang dictionary_id='44805.Vakıf Meslek Yüksek'></option>
                        </select>
                    </div>
                </div>
                <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <label><cf_get_lang dictionary_id='58820.Başlık'>*</label>
                    </div>
                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58059.Başlık Girmelisiniz'></cfsavecontent>
                        <cfinput type="Text" name="title" value="#categories.SCHOOL_NAME#" maxlength="150" required="Yes" message="#message#">
                    </div>
                </div>
                <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <label><cf_get_lang dictionary_id='36199.Açıklama'></label>
                    </div>
                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                        <textarea name="title_detail" id="title_detail"><cfoutput>#categories.DETAIL#</cfoutput></textarea>
                    </div>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cfif get_emp_school.recordcount>
                <cf_workcube_buttons is_upd='1' is_delete='0' add_function="kontrol()">
            <cfelse>
                <cf_workcube_buttons is_upd='1' del_function="del()" add_function="kontrol()">
            </cfif>
        </cf_box_footer>
    </cfform>
</cf_box>
<script>
    function kontrol(){
        <cfif isdefined("attributes.draggable")>
            loadPopupBox('upd_school' , 'upd_school_box');
            return false;
        </cfif>
    }
    function del(){
        <cfif isdefined("attributes.draggable")>
            openBoxDraggable('<cfoutput>#request.self#?fuseaction=settings.emptypopup_school_del&school_id=#url.id#</cfoutput>','del_school_box','ui-draggable-box-small');
        </cfif>
    }
</script>