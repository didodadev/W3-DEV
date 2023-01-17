<cf_box title="#getlang('','Üye Analiz Formu Dönem Güncelle',835)#" add_href="#request.self#?fuseaction=settings.form_add_member_analysis_period" is_blank="0">
    <cfform name="member_analysis_period" method="post" action="#request.self#?fuseaction=settings.emptypopup_member_analysis_period_upd">
        <cf_box_elements>
            <cfquery name="get_period" datasource="#dsn#">
                SELECT 
                   TERM_ID,RECORD_DATE,	RECORD_EMP,	RECORD_IP,	UPDATE_DATE,UPDATE_EMP,	UPDATE_IP,
                   #dsn#.Get_Dynamic_Language(SETUP_MEMBER_ANALYSIS_TERM.TERM_ID,'#session.ep.language#','SETUP_MEMBER_ANALYSIS_TERM','TERM',NULL,NULL,SETUP_MEMBER_ANALYSIS_TERM.TERM) AS TERM
                     
                FROM 
                    SETUP_MEMBER_ANALYSIS_TERM
                WHERE 
                    TERM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
            </cfquery>
            <cfinput type="hidden" name="term_id" id="term_id" value="#url.id#">
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                    <div class="form-group">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58472.Dönem'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" name="period" id="period" style="width:200px;" value="#get_period.term#" maxlength="20" required="yes">
                                <span class="input-group-addon">
                                    <cf_language_info 
                                        table_name="SETUP_MEMBER_ANALYSIS_TERM" 
                                        column_name="TERM" 
                                        column_id_value="#attributes.id#" 
                                        maxlength="500" 
                                        datasource="#dsn#" 
                                        column_id="TERM_ID" 
                                        control_type="0">
                                </span>                                      
                            </div>
                        </div>                               
                    </div>
                    
            </div>
                                                                                                                            
        </cf_box_elements>
        <cf_box_footer>
            <div class="col col-6">
                <cfoutput>                    
                     <cf_record_info query_name='get_period'>
                </cfoutput>
            </div>
            <div class="col col-6">
                <cf_workcube_buttons add_function="kontrol()" type_format='1' is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_member_analysis_period_del&term_id=#url.id#'>
            </div>
        </cf_box_footer>                       
    </cfform>
</cf_box>

<script>
    function kontrol(){
        if(document.member_analysis_period.period.value == "")
            {
                alert("<cf_get_lang dictionary_id='49186.Dönem girmelisiniz'>!");
                return false;
            }		
	}
</script>