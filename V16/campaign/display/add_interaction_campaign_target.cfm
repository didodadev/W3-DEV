<!---E.A SELECT İFADELERİ DÜZENLENDİ 24082012--->
<cfform name="add_interaction" method="post" action="#request.self#?fuseaction=campaign.emptypopup_add_interaction_targets&event=add">
    <cf_box_elements>
        <input type="hidden" name="consumer_ids" id="consumer_ids" value="" />
        <input type="hidden" name="partner_ids" id="partner_ids" value="" />
        <input type="hidden" name="camp_id" id="camp_id" value="<cfoutput>#attributes.camp_id#</cfoutput>" />
        <div class="form-group col col-3 col-xs-12">
            <label class="col col-3"><cf_get_lang dictionary_id='57629.Açıklama'></label>
            <div class="col col-9">
                <input type="text" name="interaction_detail" id="interaction_detail" value="">
            </div>
        </div>
        <cfquery name="GET_COMMETHOD" datasource="#DSN#">
            SELECT COMMETHOD_ID, COMMETHOD FROM SETUP_COMMETHOD ORDER BY COMMETHOD
        </cfquery>
        <div class="form-group col col-3 col-xs-12">
            <select name="app_cat" id="app_cat" >
                <option value=""><cf_get_lang dictionary_id='58090.İletişim Yöntemi'></option>
                <cfoutput query="get_commethod">
                    <option value="#commethod_id#">#commethod#</option>
                </cfoutput>			  
            </select>
        </div>
        <cfquery name="get_interaction_cat" datasource="#dsn#">
            SELECT 
                INTERACTIONCAT_ID,
                INTERACTIONCAT
            FROM 
                SETUP_INTERACTION_CAT 
            ORDER BY 
                INTERACTIONCAT
        </cfquery>
        <div class="form-group col col-3 col-xs-12">			
            <select name="interaction_cat" id="interaction_cat">
                <option value=""><cf_get_lang dictionary_id='57486.Kategori'></option>
                <cfoutput query="get_interaction_cat">
                    <option value="#interactioncat_id#">#interactioncat#</option>
                </cfoutput>
            </select>
        </div>
        <cfquery name="get_process_intraction" datasource="#dsn#">
            SELECT
                PTR.STAGE,
                PTR.PROCESS_ROW_ID 
            FROM
                PROCESS_TYPE_ROWS PTR,
                PROCESS_TYPE_OUR_COMPANY PTO,
                PROCESS_TYPE PT
            WHERE
                PT.IS_ACTIVE = 1 AND
                PTR.PROCESS_ID = PT.PROCESS_ID AND
                PT.PROCESS_ID = PTO.PROCESS_ID AND
                PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%call.popup_add_helpdesk,%">
        </cfquery>
        <div class="form-group col col-3 col-xs-12">
            <select name="interaction_process" id="interaction_process">
                <option value=""><cf_get_lang dictionary_id='57756.Durum'></option>
                <cfoutput query="get_process_intraction">
                    <option value="#process_row_id#">#stage#</option>
                </cfoutput>
            </select>
        </div>
    </cf_box_elements>
    <cf_box_footer>
        <cf_workcube_buttons type_format='1' is_upd='0' is_delete='0' is_cancel='0' add_function='addInteraction()'>
    </cf_box_footer>
</cfform>

