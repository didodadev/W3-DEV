<cfsetting showdebugoutput="no">
<cfquery name="get_branches" datasource="#dsn#">
	SELECT 
    	BRANCHES_ID, 
        BRANCHES_NAME, 
        BRANCHES_DETAIL, 
        BRANCHES_STATUS, 
        BRANCHES_ROW_TYPE, 
        BRANCHES_ROW_LINE
    FROM 
	    SETUP_APP_BRANCHES
</cfquery>
<cfset line_list=''>
<cfif get_branches.recordcount>
	<cfoutput query="get_branches">
		 <cfif not listfind(line_list,branches_row_line)>
			<cfset line_list=listappend(line_list,branches_row_line)>
		 </cfif>
	</cfoutput>
</cfif>
<cfset line_list=listsort(line_list,"numeric")>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<div class="col col-3 col-md-3 col-sm-3 col-xs-12 scrollContent scroll-x3">
		<cfinclude template="../display/list_cv_branches.cfm">
	</div>
	<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
		<cf_box title="#getLang('','CV Branş Kategorisi Ekle','62893')#" add_href= "#request.self#?fuseaction=settings.list_cv_branches" is_blank="0">
			<cfform action="#request.self#?fuseaction=settings.emptypopup_add_app_branches" method="post" name="branches">
				<input type="hidden" name="branches_line_list" id="branches_line_list" value="<cfif len(line_list)><cfoutput>#line_list#</cfoutput></cfif>">
				<cf_box_elements>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-branches_status_row">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'></label>
							<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
								<input type="checkbox" value="1" name="branches_status" id="branches_status" checked><cf_get_lang_main no='81.Aktif'>
							</div>
						</div>
						<div class="form-group" id="item-branches_name">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43719.Branş Adı'>*</label>
							<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
								<input type="text" name="branches_name" id="branches_name" size="30" value="">
							</div>
						</div>
						<div class="form-group" id="item-branches_row_line">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43720.Görünüm Sırası'></label>
							<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
								<input type="text" name="branches_row_line" id="branches_row_line" value="" maxlength="3" onKeyUp="isNumber(this);" validate="integer">
							</div>
						</div>
						<div class="form-group" id="item-branches_row_type">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43721.Görünüm Tipi'></label>
							<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
								<label><input type="radio" name="branches_row_type" id="branches_row_type_0" value="0"> <cf_get_lang dictionary_id='62857.Checkbox'></label>
								<label><input type="radio" name="branches_row_type" id="branches_row_type_1" value="1"> <cf_get_lang dictionary_id='58032.Çoklu'></label>
							</div>
						</div>
						<div class="form-group" id="item-branches_detail">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42009.Ayrıntı'></label>
							<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
								<textarea name="branches_detail" id="branches_detail" cols="60" rows="2" style="width:200px;height:50px;"></textarea>
							</div>
						</div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<cf_workcube_buttons is_upd='0' add_function="control()">
				</cf_box_footer>
			</cfform>
		</cf_box>
	</div>
</div>

<script type="text/javascript">
	function control()
	{
		if (trim(document.getElementById('branches_name').value)=='')
		{
			alert("<cf_get_lang dictionary_id='43788.Branş Adı Girmelisiniz'>");
			return false;
		}
		if(document.getElementById('branches_row_line').value  == "")
		{
			alert("<cf_get_lang dictionary_id='43786.Görünüm Sırasını Belirleyiniz'>");
			return false;
		}
		else
		{
			if(document.getElementById('branches_line_list').value.length > 0 && list_find(document.getElementById('branches_line_list').value,document.getElementById('branches_row_line').value,','))
				{
					alert('<cf_get_lang dictionary_id='43787.Aynı Görünüm Sırasını Giremezsiniz'>!');
					return false;
				}
		}
		
		if(document.getElementById('branches_row_type_0').checked == false && document.getElementById('branches_row_type_1').checked == false)
		{
			alert("<cf_get_lang dictionary_id='43789.Görünüm Tipini Belirleyiniz'>");
			return false;
		}
		return true;
	}
	
</script>
