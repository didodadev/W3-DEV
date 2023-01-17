<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.expense_center_id" default="">
<cfparam name="attributes.expense_center" default="">
<cfparam name="attributes.expense_item_id" default="">
<cfparam name="attributes.expense_item" default="">
<cfparam name="attributes.activity_type" default="">
<cfparam name="attributes.search_date1" default="">
<cfparam name="attributes.search_date2" default="">
<cfif len(attributes.search_date1)>
	<cf_date tarih='attributes.search_date1'>
</cfif>
<cfif len(attributes.search_date2)>
	<cf_date tarih='attributes.search_date2'>
</cfif>
<cfquery name="GET_BUDGET_DETAIL" datasource="#dsn#">
	SELECT BUDGET_NAME FROM BUDGET WHERE BUDGET_ID = #attributes.budget_id#
</cfquery>
<cfquery name="GET_ACTIVITY_TYPES" datasource="#dsn#">
	SELECT ACTIVITY_ID,ACTIVITY_NAME FROM SETUP_ACTIVITY ORDER BY ACTIVITY_NAME
</cfquery>
<cfif isDefined("attributes.form_submitted")>
	<cfquery name="GET_BUDGET_PLAN" datasource="#dsn#">
		SELECT 
			BP.PAPER_NO,
			BP.OTHER_MONEY,
			BPR.*
		FROM
			BUDGET_PLAN BP,
			BUDGET_PLAN_ROW BPR
		WHERE
			BP.BUDGET_ID = #attributes.budget_id# AND
			BP.BUDGET_PLAN_ID = BPR.BUDGET_PLAN_ID
		<cfif len(attributes.keyword)>
			AND BP.PAPER_NO LIKE '%#attributes.keyword#%'
		</cfif>
		<cfif len(attributes.expense_item_id) and len(attributes.expense_item)>
			AND BPR.BUDGET_ITEM_ID = #attributes.expense_item_id#
		</cfif>
		<cfif len(attributes.expense_center_id) and len(attributes.expense_center)>
			AND BPR.EXP_INC_CENTER_ID = #attributes.expense_center_id#
		</cfif>
		<cfif len(attributes.activity_type)>
			AND BPR.ACTIVITY_TYPE_ID = #attributes.activity_type#
		</cfif>
		<cfif len(attributes.search_date1) and len(attributes.search_date2)>
			AND BPR.PLAN_DATE BETWEEN #attributes.search_date1# and #attributes.search_date2#
		</cfif>
		ORDER BY 
			BP.PAPER_NO
	</cfquery>
	<cfparam name="attributes.totalrecords" default="#get_budget_plan.recordcount#">
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >
<cfsavecontent variable="head_">
<cfoutput><a href="#request.self#?fuseaction=budget.list_budgets&event=det&budget_id=#attributes.budget_id#"><cf_get_lang_main no='147.Bütçe'>: #GET_BUDGET_DETAIL.BUDGET_NAME#</a></cfoutput>
</cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="add_expense" id="add_expense" method="post" action="#request.self#?fuseaction=budget.list_budget_plan_row">
        <input type="hidden" name="budget_id" id="budget_id" value="<cfoutput>#attributes.budget_id#</cfoutput>">
        <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <cf_box_search>  
                <div class="form-group"><cf_get_lang_main no='48.Filtre'></div>
                <div class="form-group"><cfinput type="text" name="keyword" style="width:80px;" value="#attributes.keyword#"></div>
                <div class="form-group small"><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></div>
                <div class="form-group"><cf_wrk_search_button button_type="4"></div>
                <div class="form-group"><a class="ui-btn ui-btn-gray2" href="<cfoutput>#request.self#?fuseaction=budget.list_budgets&event=det&budget_id=#attributes.budget_id#</cfoutput>"><i class="fa fa-arrow-left"></i></a></div>
            </cf_box_search> 
            <cf_box_search_detail>
                <div class="form-group"><select name="activity_type" id="activity_type">
                        <option value=""><cf_get_lang no='90.Aktivite Tipi'></option>
                        <cfoutput query="get_activity_types">
                            <option value="#activity_id#" <cfif attributes.activity_type eq activity_id>selected</cfif>>#activity_name#</option>
                        </cfoutput>
                    </select>
                </div>
                <cfoutput>
                <div class="form-group"><cf_get_lang dictionary_id='58551.Gider Kalemi'></div>
                <div class="form-group"> <div class="input-group"> <input type="hidden" name="expense_item_id" id="expense_item_id" value="<cfif len(attributes.expense_item_id) and len(attributes.expense_item)>#attributes.expense_item_id#</cfif>">
                    <cfinput type="text" name="expense_item" value="#attributes.expense_item#" style="width:125px;">
                    <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='58551.Gider Kalemi'>" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_exp_item&field_id=add_expense.expense_item_id&field_name=add_expense.expense_item','list');"></span>
                </div></div>
                <div class="form-group"><cf_get_lang dictionary_id='58235.Masraf/Gelir Merkezi'></div>
                <div class="form-group"><div class="input-group"><input name="expense_center_id" id="expense_center_id" type="hidden" value="<cfif len(attributes.expense_center)>#attributes.expense_center_id#</cfif>">
                    <cfinput name="expense_center"  style="width:125px;"  type="text" value="#attributes.expense_center#">
                    <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='58235.Masraf/Gelir Merkezi'>" onClick="windowopen('#request.self#?fuseaction=objects.popup_expense_center&field_name=add_expense.expense_center&field_id=add_expense.expense_center_id&is_invoice=1','list');"></span>
                </div> </div>
                <div class="form-group"> <div class="input-group">
                    <cfinput type="text" name="search_date1" value="#dateformat(attributes.search_date1,dateformat_style)#" maxlength="10" validate="#validate_style#" style="width:65px;">
                    <span class="input-group-addon"><cf_wrk_date_image date_field="search_date1"></span>
                    </div></div><div class="form-group"><div class="input-group">
                    <cfinput type="text" name="search_date2" value="#dateformat(attributes.search_date2,dateformat_style)#" maxlength="10" validate="#validate_style#" style="width:65px;">
                    <span class="input-group-addon"><cf_wrk_date_image date_field="search_date2"></span>
                </div> </div>
                </cfoutput>
            </cf_box_search_detail>
        </cfform>   
    </cf_box>
    <cf_box title='#head_#' uidrop="1" hide_table_column="1" scroll="1">                 
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang_main no='468.Belge No'></th>
                    <th><cf_get_lang_main no='330.Tarih'></th>
                    <th><cf_get_lang_main no='217.Açıklama'></th>
                    <th><cf_get_lang no='15.Masraf Merkezi Kodu'></th>
                    <th><cf_get_lang_main no='1048.Masraf Merkezi'></th>
                    <th><cf_get_lang_main no='822.Bütçe Kalemi'></th>
                    <th><cf_get_lang_main no='1399.Muhasebe Kodu'></th>
                    <th><cf_get_lang no='90.Aktivite Tipi'></th>
                    <th><cf_get_lang no='93.İlgili'></th>
                    <th width="80" style="text-align:right;"><cf_get_lang_main no='1265.Gelir'></th>
                    <th width="80" style="text-align:right;"><cf_get_lang_main no='1266.Gider'></th>
                    <th width="80" style="text-align:right;"><cf_get_lang_main no='1171.Fark'></th>
                    <th width="80" style="text-align:right;"><cf_get_lang no='67.İşlem Dövizi Gelir'></th>
                    <th width="80" style="text-align:right;"><cf_get_lang no='66.İşlem Dövizi Gider'></th>
                    <th width="80" style="text-align:right;"><cf_get_lang no='65.İşlem Dövizi Fark'></th>
                    <!-- sil -->
					<th width="20" class="header_icn_none"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=budget.list_budgets&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
					<!-- sil -->
                </tr>
            </thead>
            <tbody>
                <cfif isdefined("attributes.form_submitted") and get_budget_plan.recordcount>
                <cfset activity_type_id_list = "">
                <cfset expense_center_id_list = "">
                <cfset budget_item_id_list = "">
                <cfoutput query="get_budget_plan" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <cfif len(ACTIVITY_TYPE_ID) and not listfind(activity_type_id_list,ACTIVITY_TYPE_ID)>
                        <cfset activity_type_id_list=listappend(activity_type_id_list,ACTIVITY_TYPE_ID)>
                    </cfif>
                    <cfif len(EXP_INC_CENTER_ID) and not listfind(expense_center_id_list,EXP_INC_CENTER_ID)>
                        <cfset expense_center_id_list=listappend(expense_center_id_list,EXP_INC_CENTER_ID)>
                    </cfif>
                    <cfif len(BUDGET_ITEM_ID) and not listfind(budget_item_id_list,BUDGET_ITEM_ID)>
                        <cfset budget_item_id_list=listappend(budget_item_id_list,BUDGET_ITEM_ID)>
                    </cfif>
                </cfoutput>
                <cfif len(activity_type_id_list)>
                    <cfset activity_type_id_list=listsort(activity_type_id_list,"numeric","ASC",",")>
                    <cfquery name="get_act_detail" datasource="#dsn#">
                        SELECT ACTIVITY_NAME FROM SETUP_ACTIVITY WHERE ACTIVITY_ID IN (#activity_type_id_list#) ORDER BY ACTIVITY_ID
                    </cfquery>
                </cfif>
                <cfif len(expense_center_id_list)>
                    <cfset expense_center_id_list=listsort(expense_center_id_list,"numeric","ASC",",")>
                    <cfquery name="get_exp_detail" datasource="#dsn2#">
                        SELECT EXPENSE, EXPENSE_CODE FROM EXPENSE_CENTER WHERE EXPENSE_ID IN (#expense_center_id_list#) ORDER BY EXPENSE_ID
                    </cfquery>
                </cfif>
                <cfif len(budget_item_id_list)>
                    <cfset budget_item_id_list=listsort(budget_item_id_list,"numeric","ASC",",")>
                    <cfquery name="get_budget_item_detail" datasource="#dsn2#">
                        SELECT EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID IN (#budget_item_id_list#) ORDER BY EXPENSE_ITEM_ID
                    </cfquery>
                </cfif>
                    <cfoutput query="get_budget_plan" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#PAPER_NO#</td>
                            <td>#dateformat(PLAN_DATE,dateformat_style)#</td>
                            <td>#DETAIL#</td>
                            <td>#get_exp_detail.EXPENSE_CODE[listfind(expense_center_id_list,EXP_INC_CENTER_ID,',')]#</td>
                            <td>#get_exp_detail.EXPENSE[listfind(expense_center_id_list,EXP_INC_CENTER_ID,',')]#</td>
                            <td>#get_budget_item_detail.EXPENSE_ITEM_NAME[listfind(budget_item_id_list,BUDGET_ITEM_ID,',')]#</td>
                            <td>#BUDGET_ACCOUNT_CODE#</td>
                            <td><cfif len(ACTIVITY_TYPE_ID)>#get_act_detail.ACTIVITY_NAME[listfind(activity_type_id_list,ACTIVITY_TYPE_ID,',')]#</cfif></td>
                            <td>
                                <cfif len(RELATED_EMP_ID)>
                                    <cfif RELATED_EMP_TYPE eq 'partner'>#get_par_info(RELATED_EMP_ID,0,-1,0)#<cfelseif RELATED_EMP_TYPE eq 'consumer'>#get_cons_info(RELATED_EMP_ID,0,1)#<cfelseif RELATED_EMP_TYPE eq 'employee'>#get_emp_info(RELATED_EMP_ID,0,1)#</cfif>
                                </cfif>
                            </td>
                            <td style="text-align:right;">#TLFormat(ROW_TOTAL_INCOME)#</td>
                            <td style="text-align:right;">#TLFormat(ROW_TOTAL_EXPENSE)#</td>
                            <td style="text-align:right;">#TLFormat(ROW_TOTAL_DIFF)#</td>
                            <td style="text-align:right;">#TLFormat(OTHER_ROW_TOTAL_INCOME)# #OTHER_MONEY#</td>
                            <td style="text-align:right;">#TLFormat(OTHER_ROW_TOTAL_EXPENSE)# #OTHER_MONEY#</td>
                            <td style="text-align:right;">#TLFormat(OTHER_ROW_TOTAL_DIFF)# #OTHER_MONEY#</td>
                            <td><a href="#request.self#?fuseaction=budget.list_plan_rows&event=upd&budget_plan_id=#BUDGET_PLAN_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="16"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz '> !</cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
        <cfif attributes.totalrecords gt attributes.maxrows>
            <cfset url_str = "">
            <cfif len(attributes.keyword)>
                <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
            </cfif>
            <cfif len(attributes.expense_center_id)>
                <cfset url_str = "#url_str#&expense_center_id=#attributes.expense_center_id#">
            </cfif>
            <cfif len(attributes.expense_center)>
                <cfset url_str = "#url_str#&expense_center=#attributes.expense_center#">
            </cfif>
            <cfif len(attributes.expense_item_id)>
                <cfset url_str = "#url_str#&expense_item_id=#attributes.expense_item_id#">
            </cfif>
            <cfif len(attributes.expense_item)>
                <cfset url_str = "#url_str#&expense_item=#attributes.expense_item#">
            </cfif>
            <cfif len(attributes.activity_type)>
                <cfset url_str = "#url_str#&activity_type=#attributes.activity_type#">
            </cfif>
            <cfif isDefined("attributes.form_submitted")>
                <cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
            </cfif>
            <cfif len(attributes.search_date1)>
                <cfset url_str = "#url_str#&search_date1=#attributes.search_date1#">
            </cfif>
            <cfif len(attributes.search_date2)>
                <cfset url_str = "#url_str#&search_date2=#attributes.search_date2#">
            </cfif>
            <cf_paging
                page="#attributes.page#" 
                maxrows="#attributes.maxrows#" 
                totalrecords="#attributes.totalrecords#" 
                startrow="#attributes.startrow#" 
                adres="budget.list_budget_plan_row&budget_id=#attributes.budget_id##url_str#">
        </cfif>
    </cf_box>
</div>
