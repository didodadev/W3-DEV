
<cfsetting showdebugoutput="no">
<!--- <cfquery name="GET_EMP_DETAIL" datasource="#DSN#" maxrows="1">
	SELECT LANG1_LEVEL, LANG2_LEVEL FROM EMPLOYEES_DETAIL WHERE LANG1_LEVEL=#attributes.rid# OR LANG1_LEVEL=#attributes.rid#
</cfquery> ---><!--- LANG1_LEVEL dil seviyelerinin kayıt edildigi alan ve branş kategorileri ile bir ilgili yok bu alan kapatıldığı için de burada hata verdiği icin kapatildi. SG20121112--->
<cfquery name="get_branches" datasource="#dsn#">
	SELECT 
    	BRANCHES_ID, 
        BRANCHES_NAME, 
        BRANCHES_DETAIL, 
        BRANCHES_STATUS, 
        BRANCHES_ROW_TYPE, 
        BRANCHES_ROW_LINE, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
	    SETUP_APP_BRANCHES
</cfquery>
<cfquery name="BRANCHES_ROWS" datasource="#dsn#">
	SELECT 
		BRANCHES_ROW_ID, 
        BRANCHES_ID, 
        BRANCHES_NAME_ROW, 
        BRANCHES_DETAIL_ROW, 
        BRANCHES_STATUS_ROW, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
	FROM 
		SETUP_APP_BRANCHES_ROWS
	WHERE 
		BRANCHES_ROW_ID=#url.bid#
</cfquery>
<cfquery name="get_branches_name" datasource="#dsn#">SELECT BRANCHES_NAME FROM SETUP_APP_BRANCHES WHERE BRANCHES_ID = #branches_rows.branches_id#</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
		<cfinclude template="../../settings/display/list_cv_branches.cfm">
	</div>
	<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
		<cf_box title="#getLang('','CV Branş Alt Kategorisi Güncelle','62896')#" add_href= "#request.self#?fuseaction=settings.list_cv_branches" is_blank="0">
			<cfform action="#request.self#?fuseaction=settings.emptypopup_upd_app_branches_rows" method="post" name="branches_row_upd">
				<input type="Hidden" name="branches_row_id" id="branches_row_id" value="<cfoutput>#url.bid#</cfoutput>">
				<input type="hidden" name="branches_id" id="branches_id" value="<cfoutput>#branches_rows.branches_id#</cfoutput>">
				<cf_box_elements>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-branches_status_row">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'></label>
							<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
								<input type="Checkbox" value="1" name="branches_status_row" id="branches_status_row" <cfif branches_rows.branches_status_row eq 1>checked</cfif>><cf_get_lang_main no='81.Aktif'>
							</div>
						</div>
						<div class="form-group" id="item-branches_name">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43719.Branş Adı'></label>
							<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                                <cfinput type="Text" name="branches_name" id="branches_name" size="30" value="#get_branches_name.BRANCHES_NAME#" maxlength="150" disabled="true">
								
							</div>
						</div>
						<div class="form-group" id="item-branches_name_row">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43784.Branş Alt Kategori Adı'>*</label>
							<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
								<input type="Text" name="branches_name_row" id="branches_name_row" size="30" value="<cfoutput>#branches_rows.branches_name_row#</cfoutput>" maxlength="150" required="Yes">
							</div>
						</div>
						<div class="form-group" id="item-branches_detail_row">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42009.Ayrıntı'></label>
							<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
								<Textarea name="branches_detail_row" id="branches_detail_row" cols="60" rows="2" style="width:200px;height:50px;"><cfoutput>#branches_rows.branches_detail_row#</cfoutput></TEXTAREA>
							</div>
						</div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<cf_record_info query_name="branches_rows">
						<cf_workcube_buttons is_upd='1' add_function='control()' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_app_branches_rows&branches_row_id=#url.bid#'>
				</cf_box_footer>
			</cfform>
		</cf_box>
	</div>
	
</div>
<script type="text/javascript">
	function control()
	{
		if (document.getElementById('branches_name_row').value =='')
		{
			alert("<cf_get_lang dictionary_id='43785.Branş Alt Kategori Adını Girmelisiniz'>");
			return false;
		}
		
	}
	
</script>
