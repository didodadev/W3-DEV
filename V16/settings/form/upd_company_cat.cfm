<cfinclude template="../query/get_our_companies.cfm">
<cfquery name="GET_SITE_MENU" datasource="#DSN#">
	SELECT MENU_ID,SITE_DOMAIN,OUR_COMPANY_ID FROM MAIN_MENU_SETTINGS WHERE SITE_DOMAIN IS NOT NULL
</cfquery>
<cfquery name="GET_CATEGORY_SITE_DOMAIN" datasource="#DSN#">
	SELECT 
    	CATEGORY_ID, 
		MENU_ID,
        MEMBER_TYPE 
    FROM 
	    CATEGORY_SITE_DOMAIN 
    WHERE 
    	MEMBER_TYPE = 'Company' AND 
        CATEGORY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>
<cfquery name="GET_COMPANY_CAT_OUR_COMPANIES" datasource="#DSN#">
	SELECT 
    	ID, 
        COMPANYCAT_ID, 
        OUR_COMPANY_ID 
    FROM 
	    COMPANY_CAT_OUR_COMPANY 
    WHERE 
    	COMPANYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>
<cfset our_comp_list = valuelist(get_company_cat_our_companies.our_company_id)>
<cfquery name="GET_MEMBER_TYPE" datasource="#DSN#" maxrows="1">
	SELECT
		COMPANYCAT_ID
	FROM
		COMPANY
	WHERE
		COMPANYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
</cfquery>
<script type="text/javascript">
	function form_kontrol(alan,msg,min_n,max_n)
	{
		if(!checkElementLengthRange(alan, 'Mesaj bölümüne en fazla 147 karakter girebilirsiniz.', 1, 147)) return false;
	}
	
	function checkElementLengthRange(target, msg, min_n, max_n) {	
		if (!(target.value.length>=min_n && target.value.length<=max_n)){
			alert(msg);
			target.focus();
			return false;
		}
		return true;
	}
</script>


<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='58039.Kurumsal Üye Kategorileri'></cfsavecontent>
	<cf_box title="#head#" add_href="#request.self#?fuseaction=settings.form_add_company_cat" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
			<cfinclude template="../display/list_company_cat.cfm">
    	</div>
    	<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
            <cfform action="#request.self#?fuseaction=settings.emptypopup_company_cat_upd" method="post" name="company_cat">
                <input type="hidden" name="counter" id="counter">
                <input type="Hidden" name="companycat_id" id="companycat_id" value="<cfoutput>#attributes.id#</cfoutput>">
                <cfquery name="CATEGORY" datasource="#DSN#">
                    SELECT 
                        COMPANYCAT_ID, 
                        #dsn#.Get_Dynamic_Language(COMPANYCAT_ID,'#session.ep.language#','COMPANY_CAT','COMPANYCAT',NULL,NULL,COMPANYCAT) AS COMPANYCAT,
                        #dsn#.Get_Dynamic_Language(COMPANYCAT_ID,'#session.ep.language#','COMPANY_CAT','DETAIL',NULL,NULL,DETAIL) AS DETAIL,
                        IS_ACTIVE, 
                        COMPANYCAT_TYPE, 
                        IS_VIEW, 
                        RECORD_EMP, 
                        RECORD_DATE, 
                        RECORD_IP, 
                        UPDATE_DATE, 
                        UPDATE_EMP, 
                        UPDATE_IP 
                    FROM 
                        COMPANY_CAT 
                    WHERE 
                        COMPANYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
                </cfquery>
        		<cf_box_elements>
          			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
						<div class="form-group" id="comp_type">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
                                    <input type="radio" name="comp_type" id="comp_type" value="0" <cfif category.companycat_type eq 0>checked</cfif>><cf_get_lang dictionary_id='57457.Müşteri'>
                                    <input type="radio" name="comp_type" id="comp_type" value="1" <cfif category.companycat_type eq 1>checked</cfif>><cf_get_lang dictionary_id='29533.Tedarikçi'>
								</div>	
							</div>
						</div>
						<div class="form-group" id="companyCat">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42003.Kategori Adı'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58555.Kategori Adı Girmelisiniz'>!</cfsavecontent>
                                    <cfinput type="Text" name="companyCat" id="companyCat" size="40"  value="#category.companyCat#" maxlength="43" required="Yes" message="#message#">
                                    <span class="input-group-addon">
                                        <cf_language_info 
                                            table_name="COMPANY_CAT" 
                                            column_name="COMPANYCAT" 
                                            column_id_value="#attributes.id#" 
                                            maxlength="500" 
                                            datasource="#dsn#" 
                                            column_id="COMPANYCAT_ID" 
                                            control_type="0">
                                    </span>
                                </div>
                            </div>
						</div>
                        <div class="form-group" id="related_comp">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43477.İlişkili Şirket'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cf_multiselect_check
                                    name="our_company_ids"
                                    option_name="nick_name"
                                    option_value="comp_id"
                                    table_name="OUR_COMPANY"
                                    value="iif(#listlen(our_comp_list)#,#our_comp_list#,DE(''))">
                            </div>
						</div>
						<div class="form-group" id="detail">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <textarea name="detail" id="detail" maxlength="100" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="100 Karakterden Fazla Yazmayınız!"><cfoutput>#category.detail#</cfoutput></textarea>
                                    <span class="input-group-addon">
                                        <cf_language_info 
                                            table_name="COMPANY_CAT" 
                                            column_name="DETAIL" 
                                            column_id_value="#attributes.id#" 
                                            maxlength="500" 
                                            datasource="#dsn#" 
                                            column_id="COMPANYCAT_ID" 
                                            control_type="0">
                                    </span>
                                </div>
                            </div>
						</div>
                        <div class="form-group" id="is_view">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43339.İnternet ve Extranet'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="Checkbox" name="is_view" id="is_view" value="1" <cfif get_site_menu.recordcount>onClick="gizle_goster(is_site_display);"</cfif><cfif category.is_view eq 1> checked</cfif>><cf_get_lang dictionary_id='43093.Gözüksün'>
                                <cfset attributes.companyCAT_ID = attributes.id>
                                <cfinclude template="../query/get_companycat_used.cfm">
                            </div>
						</div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
                    <cf_record_info query_name="category">
                    <cfif get_member_type.recordcount>
                        <cf_workcube_buttons is_upd='1' is_delete='0' add_function="kontrol()">
                    <cfelse>
                        <cfif companycat_used.recordcount>
                            <cf_workcube_buttons is_upd='1' is_delete='0' add_function="kontrol()">
                        <cfelse>
                            <cf_workcube_buttons is_upd='1' add_function="kontrol()" delete_page_url='#request.self#?fuseaction=settings.emptypopup_company_cat_del&companycat_id=#URL.ID#'>
                        </cfif> 
                    </cfif>
                </cf_box_footer>
			</cfform>
				
    	</div>
  	</cf_box>
</div>
