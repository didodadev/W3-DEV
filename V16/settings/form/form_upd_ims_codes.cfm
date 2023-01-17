<cfquery name="GET_IMS_CODES" datasource="#DSN#">
	SELECT 
    	IMS_CODE_ID, 
        IMS_CODE, 
        IMS_CODE_NAME, 
        IMS_CODE_501, 
        IMS_CODE_501_NAME, 
        IMS_CODE_DESC, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	SETUP_IMS_CODE 
    WHERE 
	    IMS_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ims_id#">
</cfquery>
<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('','','58134')#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform action="#request.self#?fuseaction=settings.emptypopup_ims_codes_upd" method="post" name="content_cat">
        <input type="hidden" name="ims_id" id="ims_id" value="<cfoutput>#attributes.ims_id#</cfoutput>">
        <input type="hidden" name="modal_id" id="modal_id" value="<cfoutput>#attributes.modal_id#</cfoutput>">
        <cf_box_elements>
            <div class="col col-8 col-md-8 col-sm-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-ims_name">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45857.IMS Bölge Adı'> (1001)*</label>
                    <div class="col col-8 col-xs-12"><cfsavecontent variable="message1"><cf_get_lang dictionary_id='45857.IMS Bölge Adı'><cf_get_lang dictionary_id='57613.Girmelisiniz'></cfsavecontent>
                    <cfinput type="Text" name="ims_name"   maxlength="50" required="Yes" value="#get_ims_codes.ims_code_name#" message="#message1#"></div>
                </div>
                <div class="form-group" id="item-ims_code">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49657.IMS Bölge Kodu'> (1001)*</label>
                    <div class="col col-8 col-xs-12"><cfsavecontent variable="message2"><cf_get_lang dictionary_id='52468.IMS Bölge Kodu Giriniz'></cfsavecontent>
                    <cfinput type="Text" name="ims_code"   maxlength="50" required="Yes" message="#message2#" value="#get_ims_codes.ims_code#"></div>
                </div>
                <div class="form-group" id="item-ims_name_501">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45857.IMS Bölge Adı'> (501)*</label>
                    <div class="col col-8 col-xs-12"><cfsavecontent variable="message1"><cf_get_lang dictionary_id='45857.IMS Bölge Adı'><cf_get_lang dictionary_id='57613.Girmelisiniz'></cfsavecontent>
                    <cfinput type="Text" name="ims_name_501"   maxlength="50" required="Yes" message="#message1#" value="#get_ims_codes.IMS_CODE_501_NAME#"></div>
                </div>
                <div class="form-group" id="item-ims_code_501">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49657.IMS Bölge Kodu'> (501)*</label>
                    <div class="col col-8 col-xs-12"><cfsavecontent variable="message2"><cf_get_lang dictionary_id='52468.IMS Bölge Kodu Giriniz'></cfsavecontent>
                    <cfinput type="Text" name="ims_code_501"   maxlength="50" required="Yes" message="#message2#" value="#get_ims_codes.IMS_CODE_501#"></div>
                </div>
                <div class="form-group"id="item-ims_desc">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='52254.IMS'><cf_get_lang dictionary_id='57771.Detay'></label>
                    <div class="col col-8 col-xs-12"><textarea name="ims_desc" id="ims_desc" ><cfoutput>#get_ims_codes.ims_code_desc#</cfoutput></textarea></div>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <div class="col col-8 col-xs-12">
                <cfoutput>
                    <cf_record_info query_name="get_ims_codes" record_emp="RECORD_EMP" udate_emp="UPDATE_EMP">
                </cfoutput>
            </div>
            <div class="col col-4"><cf_workcube_buttons is_upd='1' is_delete='0'></div>
        </cf_box_footer>
    </cfform>   
</cf_box>
