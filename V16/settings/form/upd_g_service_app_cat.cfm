<cfquery name="get_service" datasource="#dsn#" maxrows="1">
	SELECT SERVICECAT_ID FROM G_SERVICE WHERE SERVICECAT_ID = #attributes.servicecat_id#
</cfquery>
<cfquery name="get_service_appcat" datasource="#dsn#">
	SELECT 
    	SERVICECAT_ID, 
        SERVICECAT,
        IS_INTERNET,
        RECORD_DATE,
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP,
        IS_STATUS,
        OUR_COMPANY_ID 
    FROM 
    	G_SERVICE_APPCAT 
    WHERE 
	    SERVICECAT_ID = #attributes.servicecat_id#
</cfquery>
<cfquery name="Get_Our_Company" datasource="#dsn#">
	SELECT
    	COMP_ID,
        NICK_NAME
    FROM
    	OUR_COMPANY
    ORDER BY
    	NICK_NAME
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Şikayet Kategorileri','42922')#" add_href="#request.self#?fuseaction=settings.form_add_g_service_app_cat" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12 scrollContent scroll-x3">
			<cfinclude template="../display/list_g_service_app_cat.cfm">
		</div>
		<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
			<cfform name="service_app_cat" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_g_service_app_cat">
				<input type="hidden" name="servicecat_id" id="servicecat_id" value="<cfoutput>#attributes.servicecat_id#</cfoutput>">
				<cf_box_elements>
					<div class="col col-6 col-md-8 col-sm-8 col-xs-12" index="1" type="column" sort="true">
						<div class="form-group" id="item-is_status">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12">&nbsp</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
									<label><input type="checkbox" value="1" name="is_status" id="is_status"<cfif get_service_appcat.is_status eq 1>checked</cfif>><cf_get_lang dictionary_id='57493.Aktif'></label>
								</div>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<label><input type="checkbox" name="is_internet" value="1" <cfif get_service_appcat.is_internet eq 1>checked</cfif>><cf_get_lang dictionary_id='43478.İnternette Yayımlansın'></label>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-serviceCat">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42003.Kategori Adı'>*</label>
							<div class="col col-6 col-md-8 col-sm-8 col-xs-12"> 
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='58555.Kategori Adı Girmelisiniz'></cfsavecontent>
									<cfinput type="Text" name="serviceCat" size="60" value="#get_service_appcat.servicecat#" maxlength="50" required="Yes" message="#message#">
									<span class="input-group-addon">
										<cf_language_info 
										table_name="G_SERVICE_APPCAT" 
										column_name="SERVICECAT" 
										column_id_value="#attributes.servicecat_id#" 
										maxlength="500" 
										datasource="#dsn#" 
										column_id="SERVICECAT_ID" 
										control_type="0">
									</span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-our_company_id">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58017.İlişkili Şirketler'></label>
							<div class="col col-6 col-md-8 col-sm-8 col-xs-12"> 
								<select name="our_company_id" id="our_company_id" multiple>
									<cfoutput query="Get_Our_Company">
										<option value="#comp_id#" <cfif listfind(get_service_appcat.our_company_id,comp_id)>selected</cfif>>#nick_name#</option>
									</cfoutput>
								</select>
							</div>
						</div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<cf_record_info query_name="get_service_appcat">
					<cfif get_service.recordcount>
						<cf_workcube_buttons is_upd='1' is_delete='0' add_function="kontrol()">
					<cfelse>
						<cf_workcube_buttons is_upd='1' add_function="kontrol()" delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_g_service_app_cat&servicecat_id=#attributes.servicecat_id#'>
					</cfif>
				</cf_box_footer>
			</cfform>
		</div>
	</cf_box>
</div>

