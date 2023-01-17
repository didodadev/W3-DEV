<!---
    File: V16\hr\ehesap\form\add_grade_step_params.cfm
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 2021-05-30
    Description: Memur Gösterge Tablosu Ekleme
        
    History:
        
    To Do:

--->
<cfset get_component = createObject("component","V16.hr.ehesap.cfc.grade_step_params") />
<cfset get_grade_step = get_component.GET_EMPLOYEES_GRADE_STEP_PARAMS(start_date:attributes.start_date, finish_date:attributes.finish_date) />

<cfsavecontent variable="message"><cf_get_lang dictionary_id='62925.Memur Gösterge Tablosu'></cfsavecontent>
    <cf_box title="#message#" scroll="1" closable="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="form_add_ratio" method="post" action="V16/hr/ehesap/cfc/grade_step_params.cfc?method=UPD_EMPLOYEES_GRADE_STEP_PARAMS">
            <cf_box_elements>
                <div class="row" type="row">
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" sort="true" index="1">
                        <div class="form-group" id="item-name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57480.Başlık'>*</label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="NAME" id="name" value="#get_grade_step.title#">
                            </div>
                        </div>
                        <div class="form-group" id="item-date">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57655.Başlama Tarihi'>/<cf_get_lang dictionary_id='57700.Bitiş Tarihi'>*</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="startdate" id="startdate" validate="#validate_style#" value="#dateformat(get_grade_step.start_date,dateformat_style)#">
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="startdate"></span>
                                    <span class="input-group-addon no-bg"></span>
                                    <cfinput type="text" name="finishdate" id="finishdate" validate="#validate_style#" value="#dateformat(get_grade_step.finish_date,dateformat_style)#">
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finishdate"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row" type="row">
                    <div class="col col-12 col-xs-12" type="column" sort="true" index="2">
                        <cf_grid_list sort="0">
                            <thead>
                                <tr>
                                    <th><cf_get_lang dictionary_id='54179.Derece'></th>
                                    <th style="text-align:right;"><cf_get_lang dictionary_id='58710.Kademe'> 1</th>
                                    <th style="text-align:right;"><cf_get_lang dictionary_id='58710.Kademe'> 2</th>
                                    <th style="text-align:right;"><cf_get_lang dictionary_id='58710.Kademe'> 3</th>
                                    <th style="text-align:right;"><cf_get_lang dictionary_id='58710.Kademe'> 4</th>
                                    <th style="text-align:right;"><cf_get_lang dictionary_id='58710.Kademe'> 5</th>
                                    <th style="text-align:right;"><cf_get_lang dictionary_id='58710.Kademe'> 6</th>
                                    <th style="text-align:right;"><cf_get_lang dictionary_id='58710.Kademe'> 7</th>
                                    <th style="text-align:right;"><cf_get_lang dictionary_id='58710.Kademe'> 8</th>
                                    <th style="text-align:right;"><cf_get_lang dictionary_id='58710.Kademe'> 9</th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfloop index="i" from="1" to="15">
                                    <cfoutput>
                                        <tr>
                                            <td style="width:25px; text-align: center;">#i#</td>
                                            <cfquery name="row_step"  dbtype="query">
                                                SELECT * FROM get_grade_step WHERE GRADE = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
                                            </cfquery>
                                            <cfinput type="hidden" name="grade_step_params_id_#i#" id="grade_step_params_id_#i#" value="#row_step.grade_step_params_id#">
                                            <cfloop index="j" from="1" to="9">
                                                <td>
                                                    <input type="text" style="width:100%;" name="step_#i#_#j#" id="step_#i#_#j#" value="#TLFormat(evaluate("row_step.step_#j#"))#" onkeyup="return(formatcurrency(this,event));" class="moneybox">
                                                </td> 
                                            </cfloop>
                                        </tr>
                                    </cfoutput>
                                </cfloop>
                            </tbody>
                        </cf_grid_list>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_record_info query_name="get_grade_step">
                <cf_workcube_buttons is_upd='1' add_function='control()' delete_page_url='V16/hr/ehesap/cfc/grade_step_params.cfc?method=DEL_EMPLOYEES_GRADE_STEP_PARAMS&start_date=#get_grade_step.start_date#&finish_date=#get_grade_step.finish_date#'>
            </cf_box_footer>
        </cfform>
    </cf_box>
    <script>
        function control()
        {
            if($("#name").val() == '')
            {
                alert("<cf_get_lang dictionary_id ='57480.Başlık'>");
                return false;
            }
            if($("#startdate").val() == '' || $("#finishdate").val() == '')
            {
                alert("<cf_get_lang dictionary_id='57655.Başlama Tarihi'>/<cf_get_lang dictionary_id='57700.Bitiş Tarihi'>");
                return false;
            }
            for(i=1; i<=15 ; i++)
            {
                for(j=1 ; j<=9 ; j++)
                {
                    if($("#step_"+i+"_"+j).val() != '')
                        $("#step_"+i+"_"+j).val(filterNum($("#step_"+i+"_"+j).val()))
                }
            }
        }
    </script>