<cfset pagefuseact = "textile.stretching_test">

<cfinclude template="../../helpers/stringhelper.cfm">
<cfparam name="attributes.opp_id" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.author_id" default="">
<cfparam name="attributes.test_date_start" default="">
<cfparam name="attributes.test_date_end" default="">
<cfparam name="attributes.author_title" default="">
<cfparam name="attributes.project_title" default="">
<cfparam name="attributes.process_stage" default="">

<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>

<cfobject name="stretching_test" component="WBP.Fashion.files.cfc.stretching_test">
<cfset stretching_test.dsn3 = dsn3>
<cfset query_stretching_test = stretching_test.list_stretching_test(attributes.opp_id, attributes.project_id, attributes.author_id, attributes.test_date_start, attributes.test_date_end, attributes.process_stage)>


<cfparam name="attributes.totalrecords" default='#query_stretching_test.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="list_stretching_test" method="post">
            <input type="hidden" name="filtered" id="filtered" value="1">
            <cf_box_search>
                <div class="form-group"><cfinput type="text" name="opp_id" id="opp_id" value="#attributes.opp_id#" placeholder="#getLang('','Test No','36503')#"></div>
                <cfquery name="get_process_type" datasource="#dsn#">
                    SELECT
                        PTR.STAGE,
                        PTR.PROCESS_ROW_ID
                    FROM
                        PROCESS_TYPE_ROWS PTR,
                        PROCESS_TYPE_OUR_COMPANY PTO,
                        PROCESS_TYPE PT
                    WHERE
                        PT.IS_ACTIVE = 1 AND
                        PT.PROCESS_ID = PTR.PROCESS_ID AND
                        PT.PROCESS_ID = PTO.PROCESS_ID AND
                        PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                        PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.fuseaction#%">
                    ORDER BY
                        PTR.LINE_NUMBER
                </cfquery>
                <div class="form-group medium" id="form-stage">
                    <cf_multiselect_check
                    name="process_stage"
                    query_name="get_process_type"
                    option_name="stage"
                    option_value="process_row_id"
                    option_text="#getLang('','Süreç','58859')#"
                    value="#attributes.process_stage#">
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                    <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                </div>
            </cf_box_search>
            <cf_box_search_detail>
                <cfoutput>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-project_id">
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12"><label><cf_get_lang dictionary_id='30886.Proje No'></label></div>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="project_id" id="project_id" value="#attributes.project_id#">
                                    <input type="text" name="project_title" id="project_title" value="#attributes.project_title#" onfocus="AutoComplete_Create('project_title','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_list_projects&amp;project_id=list_stretching_test.project_id&amp;project_head=list_stretching_test.project_title');"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-author_id">
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12"><label><cf_get_lang dictionary_id='57569.Görevli'></label></div>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="author_id" id="author_id" value="#attributes.author_id#">
                                    <input type="text" name="author_title" id="author_title" onfocus="AutoComplete_Create('author_title','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','author_id','','3','135');" value="#attributes.author_title#" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_list_positions&amp;field_emp_id=list_stretching_test.author_id&amp;field_name=list_stretching_test.author_title&amp;select_list=1');"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        <div class="form-group" id="item-test_date_start">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="test_date_start" id="test_date_start" value="#dateformat(attributes.test_date_start,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#getLang('','Tarih Değerini Kontrol Ediniz','57782')#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="test_date_start"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                        <div class="form-group" id="item-test_date_end">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="test_date_end" id="test_date_end" value="#dateformat(attributes.test_date_end,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#getLang('','Tarih Değerini Kontrol Ediniz','57782')#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="test_date_end"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </cfoutput>
            </cf_box_search_detail>
        </cfform>
    </cf_box>

<cfquery name="CEKME" datasource="#dsn#">
SELECT FULLNAME, PRO.COMPANY_ID, PRI.PRIORITY , INVOICE_DATE, EMPLOYEE_NAME, EMPLOYEE_SURNAME, * FROM #dsn3#.TEXTILE_STRETCHING_TEST_HEAD STH
left join PRO_PROJECTS PRO on PRO.PROJECT_ID = STH.PROJECT_ID
left join COMPANY COM on COM.COMPANY_ID = PRO.COMPANY_ID
left join SETUP_PRIORITY PRI on PRI.PRIORITY_ID = PRO.PRO_PRIORITY_ID
left join #dsn3#.TEXTILE_SAMPLE_REQUEST TSR on TSR.PROJECT_ID =PRO.PROJECT_ID
LEFT JOIN EMPLOYEES EMP ON EMP.EMPLOYEE_ID = STH.EMP_ID
ORDER BY STH.RECORD_DATE DESC
</cfquery>

<cf_box  title="#getLang('','Çekme Testi','41292')#" uidrop="1">
    <cf_grid_list>
        <thead>
            <tr>
                <!---<th style="width:1%;">SN</th>--->
                <th style="width:3%;"><cf_get_lang dictionary_id='36503.Test No'></th>
                <th style="width:3%;"><cf_get_lang dictionary_id='30886.Proje No'></th>
                <th style="width:4%;"><cf_get_lang dictionary_id='57742.Tarih'></th>
                <th style="width:4%;"><cf_get_lang dictionary_id='57645.Teslim Tarihi'></th>
                <th style="width:10%;"><cf_get_lang dictionary_id='57486.Kategori'></th>
                <th style="width:15%;"><cf_get_lang dictionary_id='57457.Müşteri'></th>
                <th style="width:10%;"><cf_get_lang dictionary_id='58847.Marka'></th>
                <th style="width:10%;"><cf_get_lang dictionary_id='57569.Görevli'></th>
                <th style="width:10%;"><cf_get_lang dictionary_id='58859.Süreç'></th>
                <th style="width:4%;"><cf_get_lang dictionary_id='62618.İşin Başlama Tarihi'></th>
                <th style="width:4%;"><cf_get_lang dictionary_id='62619.İşin Bitiş Tarihi'></th>
                <th style="width:1%;"></th>
            </tr>
        </thead>
        <tbody>
        <cfif CEKME.recordCount>
            <cfoutput query="CEKME">
                <tr>
                    <td><a style="color: blue !important;" href="#request.self#?fuseaction=#pagefuseact#&event=upd&st_id=#STRETCHING_TEST_ID#">ÇT-#CEKME.STRETCHING_TEST_ID#</a></td>
                    <td>#PROJECT_HEAD#</td>
                    <td>#dateformat(INVOICE_DATE, dateformat_style)#</td>
                    <td>#dateformat(RECORD_DATE, dateformat_style)#</td>
                    <td>#PRIORITY#</td>
                    <td>#FULLNAME#</td>
                    <td>#SHORT_CODE#</td>
                    <td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
                    <td>#query_stretching_test.STAGE#</td>
                    <td>#dateformat(START_DATE, dateformat_style)#</td>
                    <td>#dateformat(FINISH_DATE, dateformat_style)#</td>
                    <td><a href="#request.self#?fuseaction=#pagefuseact#&event=upd&st_id=#STRETCHING_TEST_ID#"><i class="fa fa-edit"></i></a></td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td colspan="12">
                    <cfif isDefined("attributes.filtered")>
                        <cf_get_lang dictionary_id='57484.Kayıt Yok'> !
                    <cfelse>
                        <cf_get_lang dictionary_id='57701.Filtre Ediniz'> !
                    </cfif>
                </td>
            </tr>
        </cfif>
        </tbody>
        <!---- 
        <tbody>
        <cfif attributes.totalrecords>
                <cfoutput query="query_stretching_test" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr>
                    <td>#currentrow#</td>
                    <td><a style="color: blue !important;" href="#request.self#?fuseaction=#pagefuseact#&event=upd&st_id=#STRETCHING_TEST_ID#">ÇT-#STRETCHING_TEST_ID#</a></td>
                    <td>#PROJECT_HEAD#</td>
                    <td></td>
                    <td>#WASHING_ID#</td>
                    <td>#FULLNAME#</td>
                    <td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
                    <td>#STAGE#</td>
                    <td>#dateformat(TEST_DATE, dateformat_style)#</td>
                    <td>
                        <a href="#request.self#?fuseaction=#pagefuseact#&event=upd&st_id=#STRETCHING_TEST_ID#"><i class="fa fa-edit"></i></a>
                    </td>
                </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="8">
                        <cfif isDefined("attributes.filtered")>
                            <cf_get_lang_main no='72.Kayıt Yok'>!
                        <cfelse>
                            <cf_get_lang_main no='289.Filtre Ediniz'>!
                        </cfif>
                    </td>
                </tr>
            </cfif>
        </tbody>
    ---->
    </cf_grid_list>
</cf_box>

</div>

<cfscript>
    link = "textile.stretching_test&filtered=1";
    link = appendUrl(link, "opp_id", attributes.opp_id);
    link = appendUrl(link, "project_id", attributes.project_id);
    link = appendUrl(link, "author_id", attributes.author_id);
    link = appendUrl(link, "test_date_start", attributes.test_date_start);
    link = appendUrl(link, "test_date_end", attributes.test_date_end);
    link = appendUrl(link, "author_title", attributes.author_id);
    link = appendUrl(link, "project_title", attributes.project_title);
    link = appendUrl(link, "process_stage", attributes.process_stage);
</cfscript>
<table width="98%" align="center" height="35" cellpadding="0" cellspacing="0">
    <tr>
        <td>
        <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            adres="#link#">
        </td>
    </tr>
</table>
<script>
function triggerPlusIcon() {
    document.location.href = <cfoutput>"#request.self#?fuseaction=#attributes.fuseaction#&event=add";</cfoutput>
}
</script>