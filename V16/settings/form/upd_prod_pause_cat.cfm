<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='36733.Duraklama Kategorileri'></cfsavecontent>
	<cf_box title="#head#" add_href="#request.self#?fuseaction=settings.form_add_prod_pause_cat" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
			<cfinclude template="../display/list_prod_pause_cat.cfm">
    	</div>
    	<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
            <cfform name="prod_pause_cat" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_prod_pause_cat">
                <input type="Hidden" name="prodPauseCat_ID" id="prodPauseCat_ID" value="<cfoutput>#attributes.ID#</cfoutput>">
                <input type="hidden" id="id" name="id" value="<cfoutput>#attributes.id#</cfoutput>" />
                <cfquery name="get_cat" datasource="#dsn3#">
                    SELECT 
                        PROD_PAUSE_CAT_ID,
                        #dsn#.Get_Dynamic_Language(PROD_PAUSE_CAT_ID,'#session.ep.language#','SETUP_PROD_PAUSE_CAT','PROD_PAUSE_CAT',NULL,NULL,PROD_PAUSE_CAT) AS PROD_PAUSE_CAT,  
                        IS_ACTIVE, 
                        IS_WORKING_TIME, 
                        RECORD_DATE, 
                        RECORD_EMP, 
                        RECORD_IP, 
                        UPDATE_DATE, 
                        UPDATE_EMP, 
                        UPDATE_IP 
                    FROM 
                        SETUP_PROD_PAUSE_CAT 
                    WHERE 
                        PROD_PAUSE_CAT_ID = #attributes.Id#
                </cfquery>
        		<cf_box_elements>
          			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                        <div class="form-group" id="item-is_active">
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12"> &nbsp </div>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                    <input type="checkbox" name="is_active" id="is_active" value="1" <cfif get_cat.is_active eq 1>checked</cfif>><cf_get_lang dictionary_id='57493.Aktif'>

                                </div>
                                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                    <input type="checkbox" name="is_working_time" id="is_working_time" value="1" <cfif get_cat.is_working_time eq 1>checked</cfif>><cf_get_lang dictionary_id='61992.Çalışma Zamanı Dahil'>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-pauseCat">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29475.Duraklama Kategorisi'>*</label>
                            <div class="col col-8 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58555.Kategori Adı Girmelisiniz'>!</cfsavecontent>
                                <div class="input-group">
                                    <cfinput type="Text" name="pauseCat" id="pauseCat" size="60" value="#get_cat.prod_pause_cat#" maxlength="50" required="Yes" message="#message#" style="width:150px;">
                                    <span class="input-group-addon">
                                        <cf_language_info
                                        table_name="SETUP_PROD_PAUSE_CAT" 
                                        column_name="PROD_PAUSE_CAT" 
                                        column_id_value="#attributes.Id#" 
                                        maxlength="500" 
                                        datasource="#dsn3#" 
                                        column_id="PROD_PAUSE_CAT_ID" 
                                        control_type="2">
                                    </span>
                                </div>
                            </div>
                        </div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
                    <cf_record_info query_name="get_cat">
                    <cf_workcube_buttons is_upd='1' is_delete='0' add_function="kontrol()">
				</cf_box_footer>
			</cfform>
    	</div>
  	</cf_box>
</div>












