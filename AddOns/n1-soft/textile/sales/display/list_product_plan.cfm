<cfset pagefuseact = "textile.product_plan">

<cfinclude template="../../helpers/stringhelper.cfm">
<cfparam name="attributes.req_id" default="">
<cfparam name="attributes.plan_id" default="">
<cfparam name="attributes.plan_type_id" default="1">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.author_id" default="">
<cfparam name="attributes.date_start" default="">
<cfparam name="attributes.date_end" default="">
<cfparam name="attributes.author_title" default="">
<cfparam name="attributes.project_title" default="">

<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>

<cfobject name="product_plan" component="addons.n1-soft.textile.cfc.product_plan">
<cfset product_plan.dsn3 = dsn3>
<cfset query_product_plan=product_plan.list_productplan(attributes.plan_id,attributes.plan_type_id,attributes.req_id, attributes.project_id, attributes.date_start, attributes.date_end)>


<cfparam name="attributes.totalrecords" default='#query_product_plan.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfform name="list_productplan" method="post">
    <input type="hidden" name="filtered" id="filtered" value="1">

    <cf_big_list_search title="#getLang('textile',12)#">

        <cf_big_list_search_area>

            <div class="row form-inline">
                <div class="form-group" id="form-opp_id">
                    <div class="input-group x-10"><cfinput type="text" name="req_id" id="req_id" value="#attributes.req_id#" placeholder="Plan No "></div>
                </div>
                <div class="form-group x-3_5">
                    <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button>
                    <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
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
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-author_id">
                            <label class="col col-4 col-xs-12">Yetkili</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="author_id" id="author_id" value="#attributes.author_id#">
                                    <input type="text" name="author_title" id="author_title" onfocus="AutoComplete_Create('author_title','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','author_id','','3','135');" value="#attributes.author_title#" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('index.cfm?fuseaction=objects.popup_list_positions&amp;field_emp_id=list_stretching_test.author_id&amp;field_name=list_stretching_test.author_title&amp;select_list=1','list');"></span>
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
            <th style="width:1%;"></th>
            <th style="width:10%;"><cf_get_lang_main no="330.Tarih"></th>
			   <th style="width:10%;"><cf_get_lang no="5"> No</th>
            <th style="width:10%;"><cf_get_lang no="12"> No</th>
			<th style="width:10%;">Müşteri Order No</th>
			<th style="width:10%;">Proje No</th>
            <th style="width:10%;"><cf_get_lang_main no="1036.Ürün Sorumlusu"></th>
            
            <th style="width:10%;"><cf_get_lang_main no="1383.Müşteri Temsilcisi"></th>
            <th style="width:10%;"><cf_get_lang_main no="641.Başlangıç Tarihi"></th>
            <th style="width:10%;"></th>
        </tr>
    </thead>
    <tbody>
        <cfif attributes.totalrecords>
            <cfoutput query="query_product_plan" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <tr>
                <td>#currentrow#</td>
                <td>#dateformat(PLAN_DATE, dateformat_style)#</td>
				  <td>#REQ_NO#</td>
                <td>#PLAN_ID#</td>
				<td>#COMPANY_ORDER_NO#</td>
                <td></td>
                <td>#PROJECT_ID#</td>
                <td></td>
                <td>#dateformat(START_DATE, dateformat_style)#</td>
                <td>
                    <a href="#request.self#?fuseaction=#pagefuseact#&event=upd&plan_id=#plan_id#"><i class="fa fa-edit"></i></a>
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

</cf_big_list>
<cfscript>
    link = "textile.list_productplan&filtered=1";
    link = appendUrl(link, "req_id", attributes.req_id);
    link = appendUrl(link, "project_id", attributes.project_id);
    link = appendUrl(link, "author_id", attributes.author_id);
    link = appendUrl(link, "date_start", attributes.date_start);
    link = appendUrl(link, "date_end", attributes.date_end);
    link = appendUrl(link, "author_title", attributes.author_id);
    link = appendUrl(link, "project_title", attributes.project_title);
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