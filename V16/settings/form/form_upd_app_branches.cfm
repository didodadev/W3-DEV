<cfsetting showdebugoutput="no">
<!--- <cfdump var="#url#" abort> --->
<!---<cfquery name="GET_EMP_DETAIL" datasource="#DSN#" maxrows="1">
	SELECT LANG1_LEVEL, LANG2_LEVEL FROM EMPLOYEES_DETAIL WHERE LANG1_LEVEL=#attributes.ID# OR LANG1_LEVEL=#attributes.ID#
</cfquery>---><!--- LANG1_LEVEL dil seviyelerinin kayıt edildigi alan ve branş kategorileri ile bir ilgili yok bu alan kapatıldığı için de burada hata verdiği icin kapatildi. SG20121112--->
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
        UPDATE_DATE, 
        UPDATE_EMP
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
		<cf_box title="#getLang('','CV Branş Kategorisi Güncelle','62894')#" add_href= "#request.self#?fuseaction=settings.list_cv_branches" is_blank="0">
            <cfform action="#request.self#?fuseaction=settings.emptypopup_upd_app_branches" method="post" name="branches_upd">
                <cf_box_elements>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <cfquery name="BRANCHES" datasource="#dsn#">
                            SELECT 
                                BRANCHES_ID, 
                                #dsn#.Get_Dynamic_Language(BRANCHES_ID,'#session.ep.language#','SETUP_APP_BRANCHES','BRANCHES_NAME',NULL,NULL,BRANCHES_NAME) AS BRANCHES_NAME, 
                                #dsn#.Get_Dynamic_Language(BRANCHES_ID,'#session.ep.language#','SETUP_APP_BRANCHES','BRANCHES_DETAIL',NULL,NULL,BRANCHES_DETAIL) AS BRANCHES_DETAIL, 
                                BRANCHES_STATUS, 
                                BRANCHES_ROW_TYPE, 
                                BRANCHES_ROW_LINE, 
                                RECORD_DATE, 
                                RECORD_EMP, 
                                UPDATE_DATE, 
                                UPDATE_EMP
                            FROM 
                                SETUP_APP_BRANCHES 
                            WHERE 
                                BRANCHES_ID=#url.BRANCHES_ID#
                        </cfquery>
                        <cfif len(branches.branches_row_line)>
                            <cfif isdefined("line_list") and len(line_list)>
                                <cfset line_list = listdeleteat(line_list,listfind(line_list,branches.branches_row_line,','),',')>
                            </cfif>
                        </cfif>
                        <input type="Hidden" name="branches_line_list" id="branches_line_list" value="<cfif isdefined("line_list") and len(line_list)><cfoutput>#line_list#</cfoutput></cfif>">
                        <input type="Hidden" name="branches_id" id="branches_id" value="<cfoutput>#url.BRANCHES_ID#</cfoutput>">
                        <div class="form-group" id="item-branches_status">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'></label>
                            <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                                <input type="Checkbox" value="1" name="branches_status" id="branches_status" <cfif branches.branches_status eq 1>checked</cfif>><cf_get_lang_main no='81.Aktif'>
                            </div>
                        </div>
                        <div class="form-group" id="item-branches_name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43719.Branş Adı'> *</label>
                            <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <input type="Text" name="branches_name" id="branches_name" size="30" value="<cfoutput>#branches.branches_name#</cfoutput>" maxlength="150" required="Yes">
                                    <span class="input-group-addon">
                                        <cf_language_info 
                                        table_name="SETUP_APP_BRANCHES" 
                                        column_name="BRANCHES_NAME" 
                                        column_id_value="#url.BRANCHES_ID#" 
                                        maxlength="500" 
                                        datasource="#dsn#" 
                                        column_id="BRANCHES_ID" 
                                        control_type="0">
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-branches_row_line">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43720.Görünüm Sırası'></label>
                            <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" name="branches_row_line" id="branches_row_line" value="<cfif len(branches.branches_row_line)><cfoutput>#branches.branches_row_line#</cfoutput></cfif>" maxlength="3" onKeyUp="isNumber(this);" validate="integer">
                            </div>
                        </div>
                        <div class="form-group" id="item-branches_row_type">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43721.Görünüm Tipi'></label>
                            <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                                <label><input type="radio" name="branches_row_type" id="branches_row_type_0" value="0" <cfif len(branches.branches_row_type) and branches.branches_row_type eq 0>checked</cfif>> <cf_get_lang dictionary_id='62857.Checkbox'></label>
                                <label><input type="radio" name="branches_row_type" id="branches_row_type_1" value="1" <cfif len(branches.branches_row_type) and branches.branches_row_type eq 1>checked</cfif>> <cf_get_lang dictionary_id='58032.Çoklu'></label>
                            </div>
                        </div>
                        <div class="form-group" id="item-branches_detail">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42009.Ayrıntı'></label>
                            <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <input type="Text" name="branches_detail" id="branches_detail" size="30" value="<cfoutput>#branches.branches_detail#</cfoutput>" maxlength="150" required="Yes">
                                    <span class="input-group-addon">
                                        <cf_language_info 
                                        table_name="SETUP_APP_BRANCHES" 
                                        column_name="BRANCHES_DETAIL" 
                                        column_id_value="#url.BRANCHES_ID#" 
                                        maxlength="500" 
                                        datasource="#dsn#" 
                                        column_id="BRANCHES_ID" 
                                        control_type="0">
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <cf_record_info query_name="branches">
                    <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_app_branches&branches_id=#url.BRANCHES_ID#' add_function='control()'>
                </cf_box_footer>
            </cfform>
        </cf_box>
    </div>
</div>
<script type="text/javascript">
	function control()
	{
		if(document.getElementById('branches_row_line').value.length == 0)
		{
			alert("<cf_get_lang dictionary_id='43786.Görünüm Sırasını Belirleyiniz'>");
			return false;
		}
		else
		{
			if(document.getElementById('branches_line_list').value.length > 0 && list_find(document.getElementById('branches_line_list').value,document.getElementById('branches_row_line').value,','))
				{
					alert("<cf_get_lang dictionary_id='43787.Aynı Görünüm Sırasını Giremezsiniz'>!");
					return false;
				}
		}
		if (trim(document.getElementById('branches_name').value)=='')
		{
			alert("<cf_get_lang dictionary_id='43788.Branş Adı Girmelisiniz'>");
			return false;
		}
		if(document.getElementById('branches_row_type_0').checked == false && document.getElementById('branches_row_type_1').checked == false)
		{
			alert("<cf_get_lang dictionary_id='43789.Görünüm Tipini Belirleyiniz'>");
			return false;
		}
		return true;
	}
	
</script>
