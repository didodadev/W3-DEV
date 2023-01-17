<cfsetting showdebugoutput="no">
<cfquery name="get_branches" datasource="#dsn#">
	SELECT 
	    BRANCHES_ID, 
        BRANCHES_NAME, 
        BRANCHES_DETAIL, 
        BRANCHES_STATUS
    FROM 
    	SETUP_APP_BRANCHES
</cfquery>
<cfquery name="get_branches_name" datasource="#dsn#">SELECT BRANCHES_NAME FROM SETUP_APP_BRANCHES WHERE BRANCHES_ID = #url.branches_id#</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12"  id="subAdd" >
	<div class="col col-3 col-md-3 col-sm-3 col-xs-12 scrollContent scroll-x3">
		<cfinclude template="../display/list_cv_branches.cfm">
	</div>
	<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
		<cf_box title="#getLang('','CV Branş Alt Kategorisi Ekle','62895')#" add_href= "#request.self#?fuseaction=settings.list_cv_branches" is_blank="0">
            <cfform action="#request.self#?fuseaction=settings.emptypopup_add_app_branches_rows" method="post" name="branches_row_add">
                <input type="hidden" name="branches_id" id="branches_id" value="<cfoutput>#url.branches_id#</cfoutput>">
                <cf_box_elements>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-branches_status_row">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'></label>
                            <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                                <input type="Checkbox" value="1" name="branches_status_row" id="branches_status_row" checked><cf_get_lang_main no='81.Aktif'>
                            </div>
                        </div>
                        <div class="form-group" id="item-BRANCHES_NAME">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43719.Branş Adı'> *</label>
                            <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                                <cfoutput>#get_branches_name.BRANCHES_NAME#</cfoutput>
                            </div>
                        </div>
                        <div class="form-group" id="item-branches_name_row">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43784.Branş Alt Kategori Adı'> *</label>
                            <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                                <input type="Text" name="branches_name_row" id="branches_name_row" size="30" value="" maxlength="150" required="Yes" >
                            </div>
                        </div>
                        <div class="form-group" id="item-branches_detail_row">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42009.Ayrıntı'></label>
                            <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                                <Textarea name="branches_detail_row" id="branches_detail_row" cols="60" rows="2" style="width:200px;height:50px;"></TEXTAREA>
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <cf_workcube_buttons is_upd='0' add_function='control()'>
                </cf_box_footer>
            </cfform>
        </cf_box>
    </div>
</div>
           
<script type="text/javascript">
	function control()
	{
		if (trim(document.branches_row_add.branches_name_row.value)=='')
		{
			alert("<cf_get_lang dictionary_id='43785.Branş Alt Kategori Adını Girmelisiniz'>");
			return false;
		}
		return true;
    }
</script>
