<cfquery name="testCategories" datasource="#dsn#">
	SELECT 
		ID, 
		#dsn#.Get_Dynamic_Language(ID,'#session.ep.language#','TEST_CAT','CATEGORY_NAME',NULL,NULL,CATEGORY_NAME) AS CATEGORY_NAME,
		CATEGORY_DETAIL,
		RECORD_EMP,
		RECORD_DATE,
		UPDATE_EMP,
		UPDATE_DATE
	FROM 
		TEST_CAT
	ORDER BY  ID DESC
</cfquery>
<cfquery name="getCategory" dbtype="query">
	SELECT * FROM testCategories WHERE ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Test Kategorileri','42271')#" add_href="#request.self#?fuseaction=settings.list_test_category" is_blank="0">
        <div class="col col-3 col-md-3 col-sm-3 col-xs-12 scrollContent scroll-x3">
            <cfinclude template="../form/list_test_category.cfm"> 
        </div>
        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
            <cfform name="save_category" id="save_category" action="#request.self#?fuseaction=settings.emptypopup_upd_test_cat&id=#attributes.id#" method="post">
                <cf_box_elements>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                        <div class="form-group" id="item-cat_name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42003.Kategori Adı'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58555.Kategori Adı Girmelisiniz'>!</cfsavecontent>
                                    <cfinput type="text" name="test_name" id="test_name" size="60" value="#getCategory.category_name#" maxlength="250" required="yes" message="#message#">
                                    <span class="input-group-addon">
                                        <cf_language_info
                                        table_name="TEST_CAT"
                                        column_name="CATEGORY_NAME"
                                        column_id_value="#attributes.id#"
                                        maxlength="500"
                                        datasource="#dsn#" 
                                        column_id="ID" 
                                        control_type="0">
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-detail">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <cftextarea name="detail" id="detail" style="width:180px; height:60px" maxlength="400"><cfoutput>#getCategory.category_detail#</cfoutput></cftextarea>  
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <cf_record_info query_name="getCategory">
                    <cf_workcube_buttons is_upd='1' is_cancel='0' is_delete='1' add_function='kontrol()' delete_page_url="#request.self#?fuseaction=settings.del_test_category&id=#attributes.id#">
                </cf_box_footer>
            </cfform>
		</div>
	</cf_box>
</div>

