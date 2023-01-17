<cfinclude template="../query/get_our_companies.cfm">
<cfquery name="GET_OFFER_PAGES_ID" datasource="#DSN3#" maxrows="1">
	SELECT
		PAGE_TYPE
	FROM
		OFFER_PAGES
	WHERE
		PAGE_TYPE=#URL.PAGE_TYPE_ID#
</cfquery> 
<cfquery name="get_page_type" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_PAGE_TYPES 
	WHERE 
		PAGE_TYPE_ID=#URL.PAGE_TYPE_ID#
</cfquery>
<div class="col col-2 col-md-2 col-sm-2 col-xs-12" type="column" index="1" sort="true">
    <cfinclude template="../display/list_page_types.cfm">
</div>
<div class="col col-10 col-md-10 col-sm-10 col-xs-12">
    <cfsavecontent variable="title"><cf_get_lang dictionary_id='42572.Sayfa Tipi Güncelle'></cfsavecontent>
    <cf_box title="#title#" add_href="#request.self#?fuseaction=settings.form_add_page_type" is_blank="0">
        <cfform action="#request.self#?fuseaction=settings.emptypopup_upd_page_type" method="post" name="fHtmlEditor">
            <cf_box_elements>     
                <input type="hidden" name="PAGE_TYPE_ID" id="PAGE_TYPE_ID" value="<cfoutput>#get_page_type.PAGE_TYPE_ID#</cfoutput>">
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58059.Başlık Girmelisiniz'></cfsavecontent>
                            <cfinput type="Text" name="PAGE_TYPE" size="40" value="#get_page_type.page_type#" maxlength="50" required="Yes" message="#message#" style="width:300px;">
                                <span class="input-group-addon">
                                    <cf_language_info
                                        table_name="SETUP_PAGE_TYPES"
                                        column_name="PAGE_TYPE" 
                                        column_id_value="#URL.PAGE_TYPE_ID#" 
                                        maxlength="500" 
                                        datasource="#dsn#" 
                                        column_id="PAGE_TYPE_ID" 
                                        control_type="0">
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43477.İlişkili Şirket'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cf_multiselect_check
                            name="our_company_ids"
                            option_name="nick_name"
                            option_value="comp_id"
                            width="180"
                            value="iif(#listlen(get_page_type.our_company_ids)#,#get_page_type.our_company_ids#,DE(''))"
                            table_name="OUR_COMPANY">
                        </div>                   
                    </div>
                </div>
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="4" sort="true">     
                    <div class="form-group">
                        <div class="col col-12 col-xs-12">
                            <cfset tr_topic = get_page_type.PAGE_TYPE_DETAIL>
                            <cfmodule
                            template="/fckeditor/fckeditor.cfm"
                            toolbarSet="WRKContent"
                            basePath="/fckeditor/"
                            instanceName="detail"
                            valign="top"
                            value="#tr_topic#"
                            width="570"
                            height="350">
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_form_box_footer>
                <cfif len(get_page_type.record_emp)>
                    <cf_record_info query_name="get_page_type" update_date="get_page_type">
                </cfif>
                <cfif get_offer_pages_id.recordcount>
                    <cf_workcube_buttons is_upd='1' is_delete='0'>
                <cfelse>
                    <cfif get_page_type.page_type_id lt 0>
                        <cf_workcube_buttons is_upd='1' is_delete='0'>
                    <cfelse>
                        <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_page_type&page_type_id=#URL.PAGE_TYPE_ID#'>
                    </cfif>
                </cfif>
            </cf_form_box_footer>        
        </cfform>
    </cf_box>
</div>


