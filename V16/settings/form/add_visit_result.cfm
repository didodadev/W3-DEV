<cfquery name="GET_VISIT_TYPE" datasource="#dsn#">
	SELECT VISIT_TYPE_ID,VISIT_TYPE FROM SETUP_VISIT_TYPES
</cfquery>
<cfquery name="GET_VISIT_RESULTS" datasource="#dsn#">
	SELECT 
        SVR.VISIT_TYPE_ID,
        SVR.VISIT_RESULT_ID,
        #dsn#.Get_Dynamic_Language(SVR.VISIT_RESULT_ID,'#session.ep.language#','SETUP_VISIT_RESULT','VISIT_RESULT',NULL,NULL,VISIT_RESULT) AS VISIT_RESULT,
        SVR.VISIT_RESULT_DETAIL,
        #dsn#.Get_Dynamic_Language(SVR.VISIT_TYPE_ID,'#session.ep.language#','SETUP_VISIT_TYPES','VISIT_TYPE',NULL,NULL,VISIT_TYPE) AS VISIT_TYPE
    FROM 
        SETUP_VISIT_RESULT SVR
    LEFT JOIN SETUP_VISIT_TYPES SVT ON SVR.VISIT_TYPE_ID = SVT.VISIT_TYPE_ID
    WHERE 
        SVR.IS_ACTIVE = 1
	ORDER BY SVT.VISIT_TYPE ASC ,SVR.VISIT_RESULT ASC
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <div class="col col-3 col-md-3 col-sm-3 col-xs-12 ">
        <cf_box title="#getLang('','','58437')#"  >
            <div class="scrollContent scroll-x3">
            <ul class="ui-list">
                <cfif GET_VISIT_RESULTS.recordcount>
                    <cfset previous_type = 0>
                    <cfoutput query="GET_VISIT_RESULTS">
                        <cfset index = currentrow>
                        <cfif visit_type_id neq previous_type>
                            <li>
                                <li>
                                    <a>
                                        <div class="ui-list-left"> 
                                            <span class="ui-list-icon ctl-coffee-cup"></span>
                                            #visit_type#
                                        </div>
                                        <div class="ui-list-right">
                                            
                                        </div>   
                                    </a>
                                </li>
                            </cfif>
                                <ul>
                                    <cfset previous_type = GET_VISIT_RESULTS.visit_type_id[currentrow]>
                                    <li>
                                        <a href="index.cfm?fuseaction=settings.form_upd_visit_result&result_id=#visit_result_id#">
                                            <div class="ui-list-left">
                                                <span class="ui-list-icon ctl-coffee-cup" title="<cf_get_lang dictionary_id='43783.Bran?? Alt Kategorisi G??ncelle'>"></span>
                                                #visit_result#
                                            </div>
                                        </a>
                                    </li>  
                                </ul>
                            </li>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td width="380"><cf_get_lang dictionary_id='57484.Kay??t Yok'>!</td>
                    </tr>
                </cfif>
            </ul>
        </div>
        </cf_box>
    </div>
    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
        <cf_box title="#getLang('','','58437')#" >
            <cfform name="add_visit_result" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_visit_result">
                <cf_box_elements>
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12" index="1" type="column" sort="true">
                        <div class="form-group" id="item-svisit_why">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='34030.Ziyaret Nedeni'> *</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                            <select name="visit_type" id="visit_type">
                                    <option value=""><cf_get_lang dictionary_id='57734.Se??iniz'></option>
                                    <cfoutput query="get_visit_type">
                                        <option value="#visit_type_id#">#visit_type#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-visit_result">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58437.Ziyaret Sonucu'> *</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" name="visit_result" id="visit_result" >
                            </div>
                        </div>
                        <div class="form-group" id="item-visit_result_detail">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='36199.A????klama'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <textarea name="visit_result_detail" id="visit_result_detail" ></textarea>
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <cf_workcube_buttons is_cancel='0' is_upd="0" add_function="kontrol()">
                </cf_box_footer>
                <script type="text/javascript">
                    function kontrol()
                    {
                        if(!checkIfSelected('visit_type')){
                        alert('Ziyaret nedeni se??iniz!');
                        return false;
                        }
                        if(document.getElementById('visit_result').value == ''){
                        alert('Ziyaret Sonucu Giriniz!');
                        return false;
                        }
                    }
                    function checkIfSelected(select_box_id)
                    {
                        var select_box = document.getElementById(select_box_id);
                        if(select_box.selectedIndex > 0 ){
                            return true;
                        }
                        else
                            return false;
                    }
                </script>
            </cfform>   
        </cf_box>
    </div>
</div>