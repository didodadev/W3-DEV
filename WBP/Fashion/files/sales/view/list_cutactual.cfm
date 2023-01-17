<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.req_no" default="">
<cfparam name="attributes.order_no" default="">
<cfparam name="attributes.project_emp_id" default="">
<cfparam name="attributes.emp_name" default="">
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.not_is_task" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_title" default="">
<cfparam name="attributes.date_start" default="">
<cfparam name="attributes.date_end" default="">

<cfobject name="cutplan" component="WBP.Fashion.files.cfc.cutactual">
<cfif isdefined("attributes.is_filtre")>
    <cfset query_cutplans = cutplan.list_cutactual(
        attributes.req_no,
        attributes.order_no,
        attributes.project_emp_id,
        attributes.emp_name,
        attributes.process_stage,
        attributes.not_is_task,
        attributes.project_id,
        attributes.date_start,
        attributes.date_end
    )>
<cfelse>
    <cfset query_cutplans.recordcount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default='#query_cutplans.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset header = "Kesim Operasyon Listesi">
<cfform name="list_#listlast(attributes.fuseaction,'.')#" method="post">
    <input type="hidden" name="is_filtre" id="is_filtre" value="1">

    <cf_big_list_search title="#header#">

        <cf_big_list_search_area>

            <div class="row form-inline">
                <div class="form-group" id="form-opp_id">
                    <div class="input-group x-10"><cfinput type="text" name="req_no" id="req_no" value="#attributes.req_no#" placeholder="Numune No "></div>
                </div>
				  <div class="form-group" id="form-order_no">
                    <div class="input-group x-10"><cfinput type="text" name="order_no" id="order_no" value="#attributes.order_no#" placeholder="Order No "></div>
                </div>
				 <div class="form-group" id="form-task_emp_id">
                    <div class="input-group x-20">
									<cfinput type="hidden" name="project_emp_id" id="project_emp_id"  value="#attributes.project_emp_id#">
                                     <cfinput type="text" name="emp_name" id="emp_name" placeholder="Görevli " value="#attributes.emp_name#"  onFocus="AutoComplete_Create('emp_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0,0','PARTNER_ID,EMPLOYEE_ID','outsrc_partner_id,project_emp_id','plan','3','250');">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="javascript:gonder2('list_fabric_price.emp_name');"></span>
					</div>
                </div>
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
				 <div class="form-group" id="form-stage">
                    <div class="input-group x-10">
						<cf_multiselect_check
                        name="process_stage"
                        query_name="get_process_type"
                        option_name="stage"
                        option_value="process_row_id"
                        option_text="Süreç"
                        value="#attributes.process_stage#">
					</div>
                </div>
				 <div class="form-group" id="form-task_emp_id">
                    <div class="input-group x-20">
						<input type="checkbox" name="not_is_task" <cfif isDefined("attributes.not_is_task")>checked</cfif> value="" class="checkbox"> Görev atanmamış kayıtlar
					</div>
                </div>
                <div class="form-group x-3_5">
                    <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
                </div>
				
                <div class="form-group">
                    <cf_wrk_search_button>
                    <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                </div>
                <div class="form-group">
                    <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=textile.list_sample_request&event=dashboard"><i class="fa fa-bar-chart fa-2x" aria-hidden="true"></i></a>
                </div>
            </div>

        </cf_big_list_search_area>

        <cf_big_list_search_detail_area>

            <cfoutput>
                <div class="row" type="row">
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-project_id">
                            <label class="col col-4 col-xs-12">Proje No</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="project_id" id="project_id" value="#attributes.project_id#">
                                    <input type="text" name="project_title" id="project_title" value="#attributes.project_title#" onfocus="AutoComplete_Create('project_title','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('index.cfm?fuseaction=objects.popup_list_projects&amp;project_id=list_stretching_test.project_id&amp;project_head=list_stretching_test.project_title','list');"></span>
                                </div>
                            </div>
                        </div>

                    </div>
                   
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        <div class="form-group" id="item-test_date_start">
                            <label class="col col-4 col-xs-12">Başlangıç Tarihi</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang_main no='370.Tarih Değerini Kontrol Ediniz'></cfsavecontent>
                                    <cfinput type="text" name="date_start" id="date_start" value="#dateformat(attributes.date_start,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="date_start"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                        <div class="form-group" id="item-test_date_end">
                            <label class="col col-4 col-xs-12">Bitiş Tarihi</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang_main no='370.Tarih Değerini Kontrol Ediniz'></cfsavecontent>
                                    <cfinput type="text" name="date_end" id="date_end" value="#dateformat(attributes.date_end,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="date_end"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </cfoutput>

        </cf_big_list_search_detail_area>

    </cf_big_list_search>

</cfform>

<cf_big_list>
    <thead>
        <tr>
            <th>Resim</th>
            <th>Kesim No</th>
            <th>Tarih</th>
            <th>Numune Talep No</th>
            <th>Müşteri Order No</th>
            <th>Süreç</th>
            <th>Müşteri</th>
            <th>Proje No</th>
            <th>Görevli</th>
            <th>Başlangıç Tarihi</th>
            <th>Bitiş Tarihi</th>
            <th>&nbsp;</th>
        </tr>
    </thead>
    <tbody>
        <cfif query_cutplans.recordcount>
        <cfoutput query="query_cutplans" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <tr>
                
                <td>
                <div>
                    <div class="image">
                        <cfif len(MEASURE_FILENAME)>
                            <img src="documents/assets/#MEASURE_FILENAME#" style="margin-left: 10px; width:70px; height:50px;" class="img-thumbnail">
                        <cfelse>
                        <img src="images/intranet/no-image.png" style="margin-left: 10px; width:70px; height:50px;" class="img-thumbnail">
                        </cfif>
                    </div>
                </div>
                </td>
                <td><a style="color: blue;" href="#request.self#?fuseaction=#attributes.fuseaction#&event=add&id=#CUTACTUAL_ID#">KP-#CUTACTUAL_ID#</a></td>
                <td>#dateFormat( PLAN_DATE, dateformat_style )#</td>
                <td>#REQ_NO#</td>
                <td>#ORDER_NUMBEr#</td>
                <td>#STAGE#</td>
                <td>#COMPANY_NAME#</td>
                <td>#PROJECT_HEAD#</td>
                <td>#EMP_NAME#</td>
                <td>#dateformat(START_DATE, dateformat_style)#</td>
                <td>#dateformat(FINISH_DATE, dateformat_style)#</td>
                <td><a href="#request.self#?fuseaction=#attributes.fuseaction#&event=add&id=#CUTACTUAL_ID#"><i class="fa fa-edit fa-2x"></i></a></td>
            </tr>
        </cfoutput>
        <cfelse>
            <tr>
                <td colspan="12"><cfif isdefined("attributes.is_filtre")><cf_get_lang_main no='72.Kayıt Yok'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'>!</cfif></td>
            </tr>
        </cfif>
    </tbody>
</cf_big_list>
<cfset url_str = "&is_filtre=1">
<cfif len(attributes.req_no)>
    <cfset url_str = url_str & "&req_no=" & attributes.req_no> 
</cfif>
<cfif len(attributes.order_no)>
    <cfset url_str = url_str & "&order_no=" & attributes.order_no> 
</cfif>
<cfif len(attributes.project_emp_id)>
    <cfset url_str = url_str & "&project_emp_id=" & attributes.project_emp_id> 
</cfif>
<cfif len(attributes.emp_name)>
    <cfset url_str = url_str & "&emp_name=" & attributes.emp_name> 
</cfif>
<cfif len(attributes.process_stage)>
    <cfset url_str = url_str & "&process_stage=" & attributes.process_stage> 
</cfif>
<cfif len(attributes.project_id)>
    <cfset url_str = url_str & "&project_id=" & attributes.project_id> 
</cfif>
<cfif len(attributes.not_is_task)>
    <cfset url_str = url_str & "&not_is_task=" & attributes.not_is_task> 
</cfif>
<cfif len(attributes.project_title)>
    <cfset url_str = url_str & "&project_title=" & attributes.project_title> 
</cfif>
<cfif len(attributes.date_start)>
    <cfset url_str = url_str & "&date_start=" & attributes.date_start> 
</cfif>
<cfif len(attributes.date_end)>
    <cfset url_str = url_str & "&date_end=" & attributes.date_end> 
</cfif>
<cfif query_cutplans.recordcount and ( attributes.totalrecords gt attributes.maxrows )>
    <table width="98%" align="center" height="35" cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <cf_paging page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="textile.cutplan#url_str#">
            </td>
        </tr>
    </table>
</cfif>
<script>
    $(document).ready(function() {
        $("#big_list_search_image .icon-pluss").hide();
    });
</script>