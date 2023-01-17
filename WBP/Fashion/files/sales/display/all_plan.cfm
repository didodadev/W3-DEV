<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">

<!--- <cfif len(attributes.start_date)>AND PLAN_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"></cfif>
<cfif len(attributes.finish_date)>AND PLAN_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"></cfif>
 --->
<cfparam name="attributes.totalrecords" default='#query_product_plan.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="list_#listlast(attributes.fuseaction,'.')#" method="post">
            <input type="hidden" name="filtered" id="filtered" value="1">
            <cf_box_search >
                <div class="form-group" id="form-opp_id">
                    <cfinput type="text" name="req_no" id="req_no" value="#attributes.req_no#" placeholder="Numune No ">
                </div>
                <div class="form-group" id="form-order_no">
                    <cfinput type="text" name="order_no" id="order_no" value="#attributes.order_no#" placeholder="Order No ">
                </div>
                <div class="form-group" id="form-task_emp_id">
                    <div class="input-group x-20">
                        <cfinput type="hidden" name="project_emp_id" id="project_emp_id"  value="#attributes.project_emp_id#">
                        <cfinput type="text" name="emp_name" id="emp_name" placeholder="Görevli " value="#attributes.emp_name#"  onFocus="AutoComplete_Create('emp_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0,0','PARTNER_ID,EMPLOYEE_ID','outsrc_partner_id,project_emp_id','plan','3','250');">
                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="javascript:gonder2('list_fabric_price.emp_name');"></span>
                    </div>
                </div>
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
                <cfif isdefined("attributes.is_revision")>
                <div class="form-group x-10" id="form-task_emp_id">
                    <div class="input-group x-10">
                        <select name="is_revision" id="is_revision">
                            <option value="">İş Durumu</option>
                            <option value="1" <cfif attributes.is_revision eq 1>selected</cfif>><cf_get_lang dictionary_id='62575.Revize İşler'></option>
                            <option value="0" <cfif attributes.is_revision eq 0>selected</cfif>><cf_get_lang dictionary_id='62576.Asıl İşler'></option>
                        </select>
                    </div>
                </div>
                </cfif>
                <div class="form-group" id="form-task_emp_id">
                    <input type="checkbox" name="not_is_task" <cfif isDefined("attributes.not_is_task")>checked</cfif> value="" class="checkbox"> <cf_get_lang dictionary_id='62558.Görev atanmamış kayıtlar'>
                </div>
                <div class="form-group x-3_5">
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
                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='30886.Proje No'></label>
                            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="project_id" id="project_id" value="#attributes.project_id#">
                                    <input type="text" name="project_title" id="project_title" value="#attributes.project_title#" onfocus="AutoComplete_Create('project_title','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_list_projects&amp;project_id=list_stretching_test.project_id&amp;project_head=list_stretching_test.project_title');"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="form_ul_start_date">
                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
                            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'></cfsavecontent>
                                    <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        <div class="form-group" id="form_ul_finish_date">
                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'></cfsavecontent>
                                    <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </cfoutput>
            </cf_box_search_detail>
        </cfform>
    </cf_box>
    <cf_box title="#header#" uidrop="1">
        <cf_grid_list>
            <thead>
                <tr >
                    <th style="width:1%;"></th>
                    <th style="width:15%;"><cf_get_lang dictionary_id='58080.Resim'></th>
                    <th style="width:5%;"><cf_get_lang dictionary_id='57742.Tarih'></th>
                    <th style="width:5%;"><cf_get_lang dictionary_id='57645.Teslim Tarihi'></th>
                    <th style="width:5%;"><cf_get_lang dictionary_id='30886.Proje No'></th>
                    <th style="width:10%"><cf_get_lang dictionary_id='57486.Kategori'></th>
                    <!---<th style="width:5%;">Talep No</th>--->
                    <th style="width:5%;"><cf_get_lang dictionary_id='62561.Müşteri Order No'></th>
                    <th style="width:10%;"><cf_get_lang dictionary_id='58859.Süreç'></th>
                    <th style="width:5%;"><cf_get_lang dictionary_id='58847.Marka'></th>
                    <th style="width:10%;"><cf_get_lang dictionary_id='57457.Müşteri'></th>
                    <th style="width:10%;"><cf_get_lang dictionary_id='58795.Müşteri Temsilcisi'></th>
                    <th style="width:10%;"><cf_get_lang dictionary_id='57569.Görevli'></th>
                    <th style="width:10%;"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></th>
                    <th style="width:10%;"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
                    <th style="width:1%;"></th>
                </tr>
            </thead>
            <tbody>
                <cfset url_="">
                <cfset url_ = "#file_web_path#product/">
                <cfset uploadFolder = application.systemParam.systemParam().upload_folder />
                <cfset path = "#upload_folder#product#dir_seperator#">
                <cfif attributes.totalrecords>
                    <cfoutput query="query_product_plan" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>#currentrow#</td>
                        <td>
                            <cfset assetFileName=asset_file_name>
                            <cfset asset_id=asset_id>
                            <cfset assetcat_id=assetcat_id>
                            <cfset file_path = '#path##assetFileName#'>
                            <cfif len(assetFileName) and FileExists(file_path)>
                                <cfif len(assetFileName) and FileExists("#uploadFolder#product/#assetFileName#")>
                                    <cfset imagePath = "documents/product/#assetFileName#">
                                <cfelse>
                                    <cfset fileSystem.newFolder("#uploadFolder#","thumbnails") /> <!---upload folder --- /documents klasörü ---->
                                    <cfset fileSystem.newFolder("#uploadFolder#thumbnails","icon") />
                                    <cfset fileSystem.newFolder("#uploadFolder#thumbnails","middle") />
                                    <cfset imageOperations = CreateObject("Component","cfc.image_operations") />
                                        <cfif FileExists(file_path)>
                                            <cfloop from="1" to="#imageSettings.count()#" index="row">
                                                <cfset imageOperations.imageCrop(
                                                    imagePath : "#file_path#",
                                                    imageThumbPath : "#uploadFolder#thumbnails/" & imageSettings[row]["folderName"] &"/#getAsset.asset_file_name#",
                                                    imageCropType	:	1, <!--- Orantılı boyutlandır --->
                                                    newWidth : #imageSettings[row]["newWidth"]#,
                                                    newHeight : #imageSettings[row]["newHeight"]#
                                                    ) />
                                            </cfloop>
                                        </cfif>
                                    <cfset imagePath = "documents/product/#getAsset.asset_file_name#" />
                                    <cfset icon = false>
                                </cfif>
                                <cfset icon = false>
                            <cfelse>
                                <cfset imagePath = "images/intranet/no-image.png">
                                <cfset icon = true>
                            </cfif>
                        <div>
                            <div class="image">
                                <cfif icon>
                                    <img src="#imagePath#" style="margin-left: 10px; width:70px; height:50px;" class="img-thumbnail">
                                <cfelse>
                                <cfset ext=lcase(listlast(assetFileName, '.')) />
                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_download_file&<cfif ext eq "jpg" or ext eq "jpeg" or ext eq "png" or ext eq "bmp" or ext eq "pdf" or ext eq "txt" or ext eq "gif">direct_show=1&</cfif>file_name=#url_##assetFileName#&file_control=asset.form_upd_asset&asset_id=#asset_id#&assetcat_id=#assetcat_id#','medium');">
                                        <img src="#imagePath#" style="margin: 10px; width:100px;" class="img-thumbnail">
                                    </a>
                                </cfif>
                            </div>
                        </div>
                    </div>
                    </td>
                        <td>#dateformat(PLAN_DATE, dateformat_style)#</td>
                        <td><cfif len(invoice_date)>#dateformat(date_add('h',session.ep.time_zone,invoice_date),dateformat_style)#</cfif></td>
                        <td>#PROJECT_HEAD#</td>
                        <td>#PRIORITY#</td>
                        <!---<td>#REQ_NO#</td>--->
                        <td>#COMPANY_ORDER_NO#</td>
                        <td>#stage#</td>
                        <td>#SHORT_CODE#</td>
                        <td>#FULLNAME#</td>
                        <td>#get_emp_info(sales_emp_id,0,1)#</td>
                        <td>#get_emp_info(task_emp,0,1)#</td>
                        <td>#dateformat(START_DATE, dateformat_style)#</td>
                        <td>#dateformat(FINISH_DATE, dateformat_style)#</td>
                        <td>
                            <a href="#request.self#?fuseaction=#pagefuseact#&event=upd&plan_id=#plan_id#"><i class="fa fa-edit fa-2x"></i></a>
                        </td>
                    </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="15">
                            <cfif isDefined("attributes.filtered")>
                                <cf_get_lang dictionary_id='57484.Kayıt Yok'>!
                            <cfelse>
                                <cf_get_lang dictionary_id='57701.Filtre Ediniz'>!
                            </cfif>
                        </td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
    </cf_box>

</div>
<cfscript>
    link = "textile.#listlast(attributes.fuseaction,'.')#&filtered=1";
    link = appendUrl(link, "req_id", attributes.req_id);
    link = appendUrl(link, "project_id", attributes.project_id);
    link = appendUrl(link, "author_id", attributes.author_id);
    link = appendUrl(link, "date_start", attributes.date_start);
    link = appendUrl(Link, "start_date", attributes.start_date);
    link = appendUrl(Link, "finish_date", attributes.finish_date);
    link = appendUrl(link, "date_end", attributes.date_end);
    link = appendUrl(link, "author_title", attributes.author_id);
    link = appendUrl(link, "project_title", attributes.project_title);
	link = appendUrl(link, "order_no", attributes.order_no);
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
		function gonder2(str_alan_1)
			{
				str_list = '';
				   /* str_list = str_list+'branch_id='+document.getElementById("branch_id").value;
					str_list = str_list+'&department_id='+document.getElementById("department").value;*/
				openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=list_<cfoutput>#listlast(attributes.fuseaction,".")#</cfoutput>.project_emp_id&'+str_list+'&field_name=list_<cfoutput>#listlast(attributes.fuseaction,".")#</cfoutput>.emp_name <cfif isdefined("xml_only_employee") and xml_only_employee eq 0>&field_partner=list_<cfoutput>#listlast(attributes.fuseaction,".")#</cfoutput>.outsrc_partner_id</cfif>&select_list=1,2&is_form_submitted=1');
			}
	</script>
		
	<script>
		$(document).ready(function() {
			$("#big_list_search_image .icon-pluss").hide();
		});
	</script>