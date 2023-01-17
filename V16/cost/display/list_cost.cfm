<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.search_date1" default='#dateformat(dateadd("d", -1, now()),dateformat_style)#'>
<cfparam name="attributes.search_date2" default='#dateformat(now(),dateformat_style)#'>
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.expense_part_id" default="">
<cfparam name="attributes.expense_cons_id" default="">
<cfparam name="attributes.expense_emp_id" default="">
<cfparam name="attributes.recorder_name" default="">
<cfparam name="attributes.expense_item_id" default="">
<cfparam name="attributes.expense_center_id" default="">
<cfparam name="attributes.activity_type" default="">
<cfparam name="attributes.form_exist" default="">
<cfparam name="attributes.asset_id" default="">
<cfparam name="attributes.asset" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project" default="">
<cfparam name="attributes.graph_type" default="bar">
<cfparam name="attributes.graph_type1" default="bar">
<cfparam name="attributes.graph_type2" default="bar">
<cfset toplam1 = 0>
<cfset toplam2 = 0>
<cfset toplam3 = 0>
<cfset toplam4 = 0>
<cfif len(attributes.search_date1)>
  <cf_date tarih='attributes.search_date1'>
</cfif>
<cfif len(attributes.search_date2)>
  <cf_date tarih='attributes.search_date2'>
</cfif>
<cfset get_queries = createObject("component","V16.cost.cfc.list_cost")>
<cfset get_expense_item =get_queries.GET_EXPENSE_ITEM()>
<cfset get_expense_center =get_queries.GET_EXPENSE_CENTER()>
<cfset get_activity_types =get_queries.GET_ACTIVITY_TYPES()>

<cfif isdefined("attributes.form_exist")>
    <cfset get_expense_item_row_all1 =get_queries.GET_EXPENSE_ITEM_ROW_ALL1(
        keyword:attributes.keyword,
        search_date1:attributes.search_date1,
        search_date2:attributes.search_date2,
        member_type:attributes.member_type,
        expense_part_id:attributes.expense_part_id,
        expense_cons_id:attributes.expense_cons_id,
        expense_emp_id:attributes.expense_emp_id,
        recorder_name:attributes.recorder_name,
        expense_item_id:attributes.expense_item_id,
        expense_center_id:attributes.expense_center_id,
        activity_type:attributes.activity_type,
        asset_id:attributes.asset_id,
        project_id:attributes.project_id,
        project:attributes.project

    )>
    <cfset get_expense_item_row_all2 =get_queries.GET_EXPENSE_ITEM_ROW_ALL2(
        keyword:attributes.keyword,
        search_date1:attributes.search_date1,
        search_date2:attributes.search_date2,
        member_type:attributes.member_type,
        expense_part_id:attributes.expense_part_id,
        expense_cons_id:attributes.expense_cons_id,
        expense_emp_id:attributes.expense_emp_id,
        recorder_name:attributes.recorder_name,
        expense_item_id:attributes.expense_item_id,
        expense_center_id:attributes.expense_center_id,
        activity_type:attributes.activity_type,
        asset_id:attributes.asset_id,
        project_id:attributes.project_id,
        project:attributes.project

    )>
    <cfset get_expense_item_row_all4 =get_queries.GET_EXPENSE_ITEM_ROW_ALL4(
        keyword:attributes.keyword,
        search_date1:attributes.search_date1,
        search_date2:attributes.search_date2,
        member_type:attributes.member_type,
        expense_part_id:attributes.expense_part_id,
        expense_cons_id:attributes.expense_cons_id,
        expense_emp_id:attributes.expense_emp_id,
        recorder_name:attributes.recorder_name,
        expense_item_id:attributes.expense_item_id,
        expense_center_id:attributes.expense_center_id,
        activity_type:attributes.activity_type,
        asset_id:attributes.asset_id,
        project_id:attributes.project_id,
        project:attributes.project

    )>
    <cfset get_expense_item_row_all3 =get_queries.GET_EXPENSE_ITEM_ROW_ALL3(
        keyword:attributes.keyword,
        search_date1:attributes.search_date1,
        search_date2:attributes.search_date2,
        member_type:attributes.member_type,
        expense_part_id:attributes.expense_part_id,
        expense_cons_id:attributes.expense_cons_id,
        expense_emp_id:attributes.expense_emp_id,
        recorder_name:attributes.recorder_name,
        expense_item_id:attributes.expense_item_id,
        expense_center_id:attributes.expense_center_id,
        activity_type:attributes.activity_type,
        asset_id:attributes.asset_id,
        project_id:attributes.project_id,
        project:attributes.project

    )>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
<cfset url_str = "">
<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.search_date1") and len(attributes.search_date1)>
	<cfset url_str = "#url_str#&search_date1=#dateformat(attributes.search_date1,dateformat_style)#">
</cfif>
<cfif isdefined("attributes.search_date2") and len(attributes.search_date2)>
	<cfset url_str = "#url_str#&search_date2=#dateformat(attributes.search_date2,dateformat_style)#">
</cfif>
<cfif isdefined("attributes.employee_id") and len(attributes.employee_id)>
	<cfset url_str = "#url_str#&employee_id=#attributes.employee_id#">
</cfif>
<cfif isdefined("attributes.expense_employee") and len(attributes.expense_employee)>
	<cfset url_str = "#url_str#&expense_employee=#attributes.expense_employee#">
</cfif>
<cfif isdefined("attributes.expense_item_id") and len(attributes.expense_item_id)>
	<cfset url_str = "#url_str#&expense_item_id=#attributes.expense_item_id#">
</cfif>
<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id)>
	<cfset url_str = "#url_str#&expense_center_id=#attributes.expense_center_id#">
</cfif>
<cfif isdefined("attributes.activity_type") and len(attributes.activity_type)>
	<cfset url_str = "#url_str#&activity_type=#attributes.activity_type#">
</cfif>
<cfif isdefined("attributes.form_exist") and len(attributes.form_exist)>
	<cfset url_str = "#url_str#&form_exist=#attributes.form_exist#">
</cfif>
<cfif isdefined("attributes.asset_id") and len(attributes.asset_id)>
	<cfset url_str = "#url_str#&asset_id=#attributes.asset_id#">
</cfif>
<cfif isdefined("attributes.asset") and len(attributes.asset)>
	<cfset url_str = "#url_str#&asset=#attributes.asset#">
</cfif>
<cfif isdefined("attributes.project_id") and len(attributes.project_id)>
	<cfset url_str = "#url_str#&project_id=#attributes.project_id#">
</cfif>
<cfif isdefined("attributes.project") and len(attributes.project)>
	<cfset url_str = "#url_str#&project=#attributes.project#">
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent  variable="message"><cf_get_lang dictionary_id='54511.Masraflar'>
    </cfsavecontent>
    <cf_box resize="0" title="#message#">
        <cfform name="search_asset" action="#request.self#?fuseaction=cost.list_cost" method="post">
            <input name="form_exist" id="form_exist" type="hidden" value="1">
            <cf_box_search>
                <div class="form-group">
                    <cfsavecontent  variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                    <cfinput type="text" name="keyword"  value="#attributes.keyword#" maxlength="255" placeholder="#message#">
                </div>
                <div class="form-group">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='51309.Harcama Yapan'></cfsavecontent>
                    <div class="input-group">
                        <cfoutput>
                            <input type="hidden" name="expense_part_id" id="expense_part_id" value="#attributes.expense_part_id#">
                            <input type="hidden" name="expense_cons_id" id="expense_cons_id" value="#attributes.expense_cons_id#">
                            <input type="hidden" name="expense_emp_id" id="expense_emp_id" value="#attributes.expense_emp_id#">
                            <input type="hidden" name="member_type" id="member_type" value="#attributes.member_type#">
                            <input type="text" name="recorder_name" id="recorder_name" placeholder="#message#" onFocus="AutoComplete_Create('recorder_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2,3\',0,0,0','EMPLOYEE_ID,PARTNER_ID,CONSUMER_ID,MEMBER_TYPE','expense_emp_id,expense_part_id,expense_cons_id,member_type','','3','110');" value="#attributes.recorder_name#" autocomplete="off">
                            <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=search_asset.expense_emp_id&field_partner=search_asset.expense_part_id&field_consumer=search_asset.expense_cons_id&field_name=search_asset.recorder_name&field_type=search_asset.member_type&select_list=1,2,3&is_form_submitted=1&keyword='+encodeURIComponent(document.search_asset.recorder_name.value),'list');"></span>
                        </cfoutput>  
                    </div>
                </div>
                <div class="form-group large">
                    <div class="input-group">
                        <cfinput type="text" name="search_date1" value="#dateformat(attributes.search_date1,dateformat_style)#" maxlength="10" validate="#validate_style#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="search_date1"></span>
                    </div>
                </div>
                <div class="form-group large">
                    <div class="input-group">
                        <cfinput type="text" name="search_date2" value="#dateformat(attributes.search_date2,dateformat_style)#" maxlength="10" validate="#validate_style#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="search_date2"></span>
                    </div>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
                </div>
                <div class="form-group"><cf_wrk_search_button button_type="4"></div>
            </cf_box_search>
            <cf_box_search_detail>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-presence">
                        <label><cf_get_lang dictionary_id="29452.Varlık"></label>
                        <div class="input-group">
                            <cfif len(attributes.asset) and len(attributes.asset_id)>
                                <input type="hidden" name="asset_id" id="asset_id" value="<cfoutput>#attributes.asset_id#</cfoutput>">
                                <input type="text" name="asset" id="asset" value="<cfoutput>#attributes.asset#</cfoutput>" style="width:120px;">
                            <cfelse>
                                <input type="hidden" name="asset_id" id="asset_id" value="">
                                <input type="text" name="asset" id="asset" value="" style="width:120px;">
                            </cfif>
                            <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps&field_id=search_asset.asset_id&field_name=search_asset.asset&event_id=0','list');"></span>
                        </div>
                    </div>
                    <div class="form-group" id="item-project">
                        <label><cf_get_lang dictionary_id="57416.Proje"></label>
                        <div class="input-group">
                            <cfif len(attributes.project_id) and len(attributes.project)>
                                <input type="hidden" name="project_id" id="project_id" value="<cfoutput>#attributes.project_id#</cfoutput>">
                                <input type="text" name="project" id="project" value="<cfoutput>#attributes.project#</cfoutput>" style="width:120px;">
                            <cfelse>
                                <input type="hidden" name="project_id" id="project_id" value="">
                                <input type="text" name="project" id="project" value="" style="width:120px;">
                            </cfif>
                            <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=search_asset.project_id&project_head=search_asset.project');"></span>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-cost-center">
                        <label><cf_get_lang dictionary_id='58460.Masraf Merkezi'></label>
                        <select name="expense_center_id" id="expense_center_id">
                            <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                            <cfoutput query="get_expense_center">
                                <option value="#expense_id#" <cfif attributes.expense_center_id eq expense_id>selected</cfif>>#expense#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-expense-item">
                        <label><cf_get_lang dictionary_id='58551.Gider Kalemi'></label>
                        <select name="expense_item_id" id="expense_item_id">
                            <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                            <cfoutput query="get_expense_item">
                                <option value="#expense_item_id#" <cfif attributes.expense_item_id eq expense_item_id>selected</cfif>>#expense_item_name#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                    <div class="form-group" id="item-activite-type">
                        <label><cf_get_lang dictionary_id='31172.Aktivite Tipi'></label>
                        <select name="activity_type" id="activity_type">
                            <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                            <cfoutput query="get_activity_types">
                                <option value="#activity_id#" <cfif attributes.activity_type eq activity_id>selected</cfif>>#activity_name#</option>
                            </cfoutput>
                        </select>
                    </div>
                    <div id="detail_search_div" style="display:table-row;"></div>
                </div>
            </cf_box_search_detail>
        </cfform>
    </cf_box>
</div>
<div class="col col-7 col-md-7 col-sm-7 col-xs-12">
    <cfsavecontent variable="header"><cf_get_lang dictionary_id="58930.Maseaf"> <cf_get_lang dictionary_id="57771.Detay"></cfsavecontent>
    <cf_box title="#header#" uidrop="1" hide_table_column="1">
        <!-- sil -->
        <cf_flat_list>
            <thead>
                <tr>
                    <th width="25"><cf_get_lang dictionary_id="57487.No"></th>
                    <th><cf_get_lang dictionary_id='58551.Gider Kalemi'></th>
                    <th width="150" style="text-align:right;"><cf_get_lang dictionary_id="57673.Tutar"></th>
                </tr>
            </thead>
            <tbody>
            <cfif len(attributes.form_exist)>
                <cfif  get_expense_item_row_all1.recordcount>
                    <cfoutput query="get_expense_item_row_all1">
                        <tr>
                            <td>#currentrow#</td>
                            <td>#expense_item_name#</td>
                            <td style="text-align:right;">#tlformat(toplam)#</td>
                            <cfset toplam1 = toplam1 + toplam>
                        </tr>
                    </cfoutput>
                   
                <cfelse>
                    <tr>
                        <td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
                    </tr>
                </cfif>
            <cfelse>
                <tr>
                    <td colspan="3"><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</td>
                </tr>
            </cfif>
            </tbody>
            
        </cf_flat_list>
        <cfif len(attributes.form_exist)>
            <cfif  get_expense_item_row_all1.recordcount>
            <div class="ui-info-bottom flex-end">
                <p><b><cf_get_lang dictionary_id="57492.Toplam"> <cf_get_lang dictionary_id="57673.Tutar">:</b> <cfoutput>#tlformat(toplam1)#</cfoutput></p>
            </div>
            </cfif>
        </cfif>
        <cf_flat_list>
            <thead>	
                <tr>
                    <th width="25"><cf_get_lang dictionary_id="57487.No"></th>
                    <th><cf_get_lang dictionary_id="58460.Masraf Mekrezi"></th>
                    <th width="150" style="text-align:right;"><cf_get_lang dictionary_id="57673.Tutar"></th>
                </tr>
            </thead>
            <tbody>
            <cfif len(attributes.form_exist)>
                    <cfif  get_expense_item_row_all2.recordcount>
                    <cfoutput query="get_expense_item_row_all2">
                        <tr>
                            <td>#currentrow#</td>
                            <td>#expense#</td>
                            <td style="text-align:right;">#tlformat(toplam)#</td>
                            <cfset toplam2 = toplam2 + toplam>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
                    </tr>
                </cfif>
            <cfelse>
                <tr>
                    <td colspan="3"><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</td>
                </tr>
            </cfif>
            </tbody>				
        </cf_flat_list> 
        <cfif len(attributes.form_exist)>
            <cfif  get_expense_item_row_all2.recordcount> 
                <div class="ui-info-bottom flex-end">
                    <p><b><cf_get_lang dictionary_id="57492.Toplam"> <cf_get_lang dictionary_id="57673.Tutar">:</b> <cfoutput>#tlformat(toplam2)#</cfoutput></p>
                </div>
            </cfif>
        </cfif>
        <cf_flat_list>
            <thead>
                <tr>
                    <th width="25"><cf_get_lang dictionary_id="57487.No"></th>
                    <th><cf_get_lang dictionary_id= "32999.Bütçe Kategorisi"></th>
                    <th width="150" style="text-align:right;"><cf_get_lang dictionary_id="57673.Tutar"></th>
                </tr>
            </thead>
            <tbody>
                <cfif len(attributes.form_exist)>
                    <cfif  get_expense_item_row_all3.recordcount>
                        <cfoutput query="get_expense_item_row_all3">
                            <tr>
                                <td>#currentrow#</td>
                                <td>#expense_cat_name#</td>
                                <td style="text-align:right;">#tlformat(toplam)#</td>
                                <cfset toplam3 = toplam3 + toplam>
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
                        </tr>
                    </cfif>
                <cfelse>
                    <tr>
                        <td colspan="3"><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</td>
                    </tr>
                </cfif>
            </tbody>
        </cf_flat_list>
        <cfif len(attributes.form_exist)>
            <cfif  get_expense_item_row_all3.recordcount>
                <div class="ui-info-bottom flex-end">
                    <p><b><cf_get_lang dictionary_id="57492.Toplam"> <cf_get_lang dictionary_id="57673.Tutar">:</b> <cfoutput>#tlformat(toplam3)#</cfoutput></p>
                </div>
            </cfif>
        </cfif>
        <cf_flat_list>
            <thead>
                <tr>
                    <th width="25"><cf_get_lang dictionary_id="57487.No"></th>
                    <th><cf_get_lang dictionary_id="31172.Aktivite Tipi"></th>
                    <th width="150" style="text-align:right;"><cf_get_lang dictionary_id="57673.Tutar"></th>
                </tr>
            </thead>
            <tbody>
                <cfif len(attributes.form_exist)>
                    <cfif  get_expense_item_row_all4.recordcount>
                        <cfoutput query="get_expense_item_row_all4">
                            <tr>
                                <td>#currentrow#</td>
                                <td>#ACTIVITY_NAME#</td>
                                <td style="text-align:right;">#tlformat(toplam)#</td>
                                <cfset toplam4 = toplam4 + toplam>
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
                        </tr>
                    </cfif>
                <cfelse>
                    <tr>
                        <td colspan="3"><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</td>
                    </tr>
                </cfif>
            </tbody>
        </cf_flat_list>
        <cfif len(attributes.form_exist)>
            <cfif  get_expense_item_row_all4.recordcount>
                <div class="ui-info-bottom flex-end">
                    <p><b><cf_get_lang dictionary_id="57492.Toplam"> <cf_get_lang dictionary_id="57673.Tutar">:</b> <cfoutput>#tlformat(toplam4)#</cfoutput></p>
                </div>
            </cfif>
        </cfif>
        <!-- sil -->
    </cf_box>
</div>
<script src="JS/Chart.min.js"></script>
<div class="col col-5 col-md-5 col-sm-5 col-xs-12">
    <cf_box closable="0" title="#getLang(1139,'Gider Kalemi',58551)#" any><!---Gider Kalemi--->
        <cfform action=""  name="form_src" method="post">
           <cf_box_elements>
                <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <label><cf_get_lang dictionary_id='57950.Grafik Formatı'></label>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <select name="graph_type" id="graph_type" onchange="if (this.options[this.selectedIndex].value != 'NULL') { window.open(this.options[this.selectedIndex].value,'_self') }">
                            <cfoutput>
                                <option value="#request.self#?fuseaction=cost.list_cost&graph_type=bar&#url_str#&graph_type1=#attributes.graph_type1#" <cfif attributes.graph_type eq "bar">selected</cfif>><cf_get_lang dictionary_id='57663.Bar'></option>
                                <option value="#request.self#?fuseaction=cost.list_cost&graph_type=pie&#url_str#&graph_type1=#attributes.graph_type1#" <cfif attributes.graph_type eq "pie">selected</cfif>><cf_get_lang dictionary_id='57668.Pay'></option>
                                <option value="#request.self#?fuseaction=cost.list_cost&graph_type=line&#url_str#&graph_type1=#attributes.graph_type1#" <cfif attributes.graph_type eq "line">selected</cfif>><cf_get_lang dictionary_id='51320.Line'></option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
            </cf_box_elements>

            <cfif len(attributes.form_exist)>
                    <cfoutput query="get_expense_item_row_all1">
                        <cfif (toplam eq 0) or (toplam eq "")>
                            <cfset toplamin_degeri = 0>
                        <cfelse>
                            <cfset toplamin_degeri = toplam>
                        </cfif>
                    <cfset 'item_#currentrow#' = "#expense_item_name#">
                    <cfset 'value_#currentrow#' = "#toplamin_degeri#">
                    </cfoutput>
                    <div class="scroll"><canvas id="myChartAll1" style="height:auto;width:100%;"></canvas></div>
                        <script>
                            var ctx1 = document.getElementById('myChartAll1');
                            var myChartAll1 = new Chart(ctx1, {
                                type: '<cfoutput>#attributes.graph_type#</cfoutput>',
                                data: {
                                        labels: [<cfloop from="1" to="#get_expense_item_row_all1.recordcount#" index="jj">
                                                <cfoutput>"#Left(evaluate("item_#jj#"),15)#"</cfoutput>,</cfloop>],
                                        datasets: [{
                                        label: "<cfoutput>#getLang(1139,'Gider Kalemi',58551)#</cfoutput>",
                                        backgroundColor: [<cfloop from="1" to="#get_expense_item_row_all1.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                        data: [<cfloop from="1" to="#get_expense_item_row_all1.recordcount#" index="jj"><cfoutput>"#wrk_round(evaluate("value_#jj#"))#"</cfoutput>,</cfloop>],
                                            }]
                                        },
                                options: {}
                            });
                        </script>
                        
                <cfelse>
                    <cf_get_lang dictionary_id="57701.Filtre Ediniz !"> 
                </cfif>
                    
        </cfform>
    </cf_box>
    <cf_box closable="0"  title="#getLang(25,'Masraf/Gelir Merkezleri',51329)#" any><!---masraf Merkezleri--->
        <cfform action=""  name="form_src1" method="post">
            <table>
                <cf_box_elements>
                    <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                            <label><cf_get_lang dictionary_id='57950.Grafik Formatı'></label>
                        </div>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                            <cfoutput>
                                <select name="graph_type1" id="graph_type1" onchange="if (this.options[this.selectedIndex].value != 'NULL') { window.open(this.options[this.selectedIndex].value,'_self') }">
                                <option value="#request.self#?fuseaction=cost.list_cost&graph_type1=pie&#url_str#&graph_type=#attributes.graph_type#" <cfif attributes.graph_type1 eq "pie">selected</cfif>><cf_get_lang dictionary_id='57668.Pay'></option>
                                <option value="#request.self#?fuseaction=cost.list_cost&graph_type1=bar&#url_str#&graph_type=#attributes.graph_type#" <cfif attributes.graph_type1 eq "bar">selected</cfif>><cf_get_lang dictionary_id='57663.Bar'></option>
                                <option value="#request.self#?fuseaction=cost.list_cost&graph_type1=line&#url_str#&graph_type=#attributes.graph_type#" <cfif attributes.graph_type1 eq "line">selected</cfif>><cf_get_lang dictionary_id='51320.Line'></option>
                            </cfoutput>
                        </div>
                    </div>
                </cf_box_elements>
            </table>
            
            <cfif len(attributes.form_exist)>
                <cfoutput query="get_expense_item_row_all2">
                    <cfif (toplam eq 0) or (toplam eq "")>
                        <cfset toplamin_degeri = 0>
                    <cfelse>
                        <cfset toplamin_degeri = toplam>
                    </cfif>
                <cfset 'item_#currentrow#' = "#expense#">
                <cfset 'value_#currentrow#' = "#toplamin_degeri#">
                </cfoutput>
                <canvas id="myChartAll2" style="height:auto;width:100%;"></canvas>
                    <script>
                        var ctx2 = document.getElementById('myChartAll2');
                        var myChartAll2 = new Chart(ctx2, {
                            type: '<cfoutput>#attributes.graph_type1#</cfoutput>',
                            data: {
                                    labels: [<cfloop from="1" to="#get_expense_item_row_all2.recordcount#" index="jj">
                                            <cfoutput>"#Left(evaluate("item_#jj#"),15)#"</cfoutput>,</cfloop>],
                                    datasets: [{
                                    label: "<cfoutput>#getLang('cost',25)#</cfoutput>",
                                    backgroundColor: [<cfloop from="1" to="#get_expense_item_row_all2.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                    data: [<cfloop from="1" to="#get_expense_item_row_all2.recordcount#" index="jj"><cfoutput>"#wrk_round(evaluate("value_#jj#"))#"</cfoutput>,</cfloop>],
                                        }]
                                    },
                            options: {}
                        });
                    </script>
                    
            <cfelse>
                <cf_get_lang dictionary_id="57701.Filtre Ediniz !"> 
            </cfif> 
                       
        </cfform>
    </cf_box>
    <cfsavecontent  variable="head"><cf_get_lang dictionary_id='32999.Bütçe Kategorisi'>
    </cfsavecontent>
    <cf_box closable="0"  title="#head#" any>
        <cfform action=""  name="form_src2" method="post">
            <cf_box_elements>
                <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <label><cf_get_lang dictionary_id='57950.Grafik Formatı'></label>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <cfoutput>
                            <select name="graph_type2" id="graph_type2" onchange="if (this.options[this.selectedIndex].value != 'NULL') { window.open(this.options[this.selectedIndex].value,'_self') }">
                            <option value="#request.self#?fuseaction=cost.list_cost&graph_type2=pie&#url_str#&graph_type=#attributes.graph_type#" <cfif attributes.graph_type2 eq "pie">selected</cfif>><cf_get_lang dictionary_id='57668.Pay'></option>
                            <option value="#request.self#?fuseaction=cost.list_cost&graph_type2=bar&#url_str#&graph_type=#attributes.graph_type#" <cfif attributes.graph_type2 eq "bar">selected</cfif>><cf_get_lang dictionary_id='57663.Bar'></option>
                            <option value="#request.self#?fuseaction=cost.list_cost&graph_type2=line&#url_str#&graph_type=#attributes.graph_type#" <cfif attributes.graph_type2 eq "line">selected</cfif>><cf_get_lang dictionary_id='51320.Line'></option>
                            </select>
                        </cfoutput>
                    </div>
                </div>
            </cf_box_elements>
          
                        <cfif len(attributes.form_exist)>
                                    <cfoutput query="get_expense_item_row_all3">
                                        <cfif (toplam eq 0) or (toplam eq "")>
                                            <cfset toplamin_degeri = 0>
                                        <cfelse>
                                            <cfset toplamin_degeri = toplam>
                                        </cfif>
                                    <cfset 'item_#currentrow#' = "#expense_cat_name#">
                                    <cfset 'value_#currentrow#' = "#toplamin_degeri#">
                                    </cfoutput>
                                    <canvas id="myChartAll3" style="height:auto;width:100%;"></canvas>
                                        <script>
                                            var ctx3 = document.getElementById('myChartAll3');
                                            var myChartAll3 = new Chart(ctx3, {
                                                type: '<cfoutput>#attributes.graph_type2#</cfoutput>',
                                                data: {
                                                        labels: [<cfloop from="1" to="#get_expense_item_row_all3.recordcount#" index="jj">
                                                                <cfoutput>"#Left(evaluate("item_#jj#"),15)#"</cfoutput>,</cfloop>],
                                                        datasets: [{
                                                        label: "<cf_get_lang dictionary_id= '32999.Bütçe Kategorisi'>",
                                                        backgroundColor: [<cfloop from="1" to="#get_expense_item_row_all3.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                                        data: [<cfloop from="1" to="#get_expense_item_row_all3.recordcount#" index="jj"><cfoutput>"#wrk_round(evaluate("value_#jj#"))#"</cfoutput>,</cfloop>],
                                                            }]
                                                        },
                                                options: {}
                                            });
                                        </script>
                                        
                                <cfelse>
                                    <cf_get_lang dictionary_id="57701.Filtre Ediniz !"> 
                                </cfif>
                        
        </cfform>
    </cf_box>
    <cfsavecontent  variable="head"><cf_get_lang dictionary_id='31172.Aktivite Tipi'>
    </cfsavecontent>
    <cf_box closable="0"  title="#head#" any>
        <cfform action=""  name="form_src2" method="post">
            <cf_box_elements>
                <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <label><cf_get_lang dictionary_id='57950.Grafik Formatı'></label>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <cfoutput>
                            <select name="graph_type2" id="graph_type2" onchange="if (this.options[this.selectedIndex].value != 'NULL') { window.open(this.options[this.selectedIndex].value,'_self') }">
                            <option value="#request.self#?fuseaction=cost.list_cost&graph_type2=pie&#url_str#&graph_type=#attributes.graph_type#" <cfif attributes.graph_type2 eq "pie">selected</cfif>><cf_get_lang dictionary_id='57668.Pay'></option>
                            <option value="#request.self#?fuseaction=cost.list_cost&graph_type2=bar&#url_str#&graph_type=#attributes.graph_type#" <cfif attributes.graph_type2 eq "bar">selected</cfif>><cf_get_lang dictionary_id='57663.Bar'></option>
                            <option value="#request.self#?fuseaction=cost.list_cost&graph_type2=line&#url_str#&graph_type=#attributes.graph_type#" <cfif attributes.graph_type2 eq "line">selected</cfif>><cf_get_lang dictionary_id='51320.Line'></option>
                            </select>
                        </cfoutput>
                    </div>
                </div>
            </cf_box_elements>
          
                        <cfif len(attributes.form_exist)>
                                    <cfoutput query="get_expense_item_row_all4">
                                        <cfif (toplam eq 0) or (toplam eq "")>
                                            <cfset toplamin_degeri = 0>
                                        <cfelse>
                                            <cfset toplamin_degeri = toplam>
                                        </cfif>
                                    <cfset 'item_#currentrow#' = "#activity_name#">
                                    <cfset 'value_#currentrow#' = "#toplamin_degeri#">
                                    </cfoutput>
                                    <canvas id="myChartAll4" style="height:auto;width:100%;"></canvas>
                                        <script>
                                            var ctx4 = document.getElementById('myChartAll4');
                                            var myChartAll4 = new Chart(ctx4, {
                                                type: '<cfoutput>#attributes.graph_type2#</cfoutput>',
                                                data: {
                                                        labels: [<cfloop from="1" to="#get_expense_item_row_all4.recordcount#" index="jj">
                                                                <cfoutput>"#Left(evaluate("item_#jj#"),15)#"</cfoutput>,</cfloop>],
                                                        datasets: [{
                                                        label: "<cf_get_lang dictionary_id='31172.Aktivite Tipi'>",
                                                        backgroundColor: [<cfloop from="1" to="#get_expense_item_row_all4.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                                        data: [<cfloop from="1" to="#get_expense_item_row_all4.recordcount#" index="jj"><cfoutput>"#wrk_round(evaluate("value_#jj#"))#"</cfoutput>,</cfloop>],
                                                            }]
                                                        },
                                                options: {}
                                            });
                                        </script>
                                        
                                <cfelse>
                                    <cf_get_lang dictionary_id="57701.Filtre Ediniz !"> 
                                </cfif>
                        
        </cfform>
    </cf_box>
</div>
