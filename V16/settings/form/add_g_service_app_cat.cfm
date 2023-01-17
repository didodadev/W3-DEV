<!--- çoklu şirket seçimi ekleneceği için grid kaldırılıp eski haline döndürüldü DT20140503 --->
<!--- <cf_wrk_grid search_header = "#lang_array.item[939]#" table_name="G_SERVICE_APPCAT" sort_column="SERVICECAT" u_id="SERVICECAT_ID" datasource="#dsn#" search_areas = "SERVICECAT">
    <cf_wrk_grid_column name="SERVICECAT_ID" header="#lang_array_main.item[1165]#" display="no" select="yes"/>
    <cf_wrk_grid_column name="SERVICECAT" header="#lang_array_main.item[68]#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="IS_INTERNET" width="100" type="boolean" header="#lang_array.item[1495]#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="RECORD_DATE" header="#lang_array_main.item[215]#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#lang_array.item[1180]#" type="date" mask="date" width="100" select="no" display="yes"/> 
</cf_wrk_grid> --->
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
			<cfform name="service_app_cat" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_g_service_app_cat">
				<cf_box_elements>
					<div class="col col-6 col-md-8 col-sm-8 col-xs-12" index="1" type="column" sort="true">
						<div class="form-group" id="item-is_status">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12">&nbsp</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
									<label><input type="checkbox" value="1" name="is_status" id="is_status" checked><cf_get_lang dictionary_id='57493.Aktif'></label>
								</div>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<label><input type="checkbox" name="is_internet" value="1"><cf_get_lang dictionary_id='43478.İnternette Yayımlansın'></label>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-serviceCat">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42003.Kategori Adı'>*</label>
							<div class="col col-6 col-md-8 col-sm-8 col-xs-12"> 
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58555.Kategori Adı Girmelisiniz'></cfsavecontent>
								<cfinput type="Text" name="serviceCat" size="60" value="" maxlength="50" required="Yes" message="#message#">
							</div>
						</div>
						<div class="form-group" id="item-our_company_id">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58017.İlişkili Şirketler'></label>
							<div class="col col-6 col-md-8 col-sm-8 col-xs-12"> 
								<select name="our_company_id" id="our_company_id" multiple>
									<cfoutput query="Get_Our_Company">
										<option value="#comp_id#">#nick_name#</option>
									</cfoutput>
								</select>
							</div>
						</div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<cf_workcube_buttons is_upd='0' add_function="kontrol()">
				</cf_box_footer>
			</cfform>
		</div>
	</cf_box>
</div>

