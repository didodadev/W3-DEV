<cfsetting showdebugoutput="yes">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.budget_name" default="">
<cfparam name="attributes.budget_id" default="">
<cfparam name="attributes.paper_no" default="">
<cfparam name="attributes.budget_action_type" default="">
<cfparam name="attributes.search_date1" default="">
<cfparam name="attributes.search_date2" default="">
<cfparam name="attributes.listing_type" default="2">
<cfparam name="attributes.ch_member_type" default="">
<cfparam name="attributes.ch_company_id" default="">
<cfparam name="attributes.ch_consumer_id" default="">
<cfparam name="attributes.ch_employee_id" default="">
<cfparam name="attributes.ch_company" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<!--- Sevim Çelik : Tahakkuk işlemleri muhasebeye akarım sayfası --->
<cfif len(attributes.search_date1)>
	<cf_date tarih='attributes.search_date1'>
</cfif>
<cfif len(attributes.search_date2)>
	<cf_date tarih='attributes.search_date2'>
</cfif>
<cfquery name="get_process_cat" datasource="#dsn3#">
	SELECT PROCESS_CAT,PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (160,161)
</cfquery>
<cfif isDefined("attributes.form_submitted")>
	<cfquery name="GET_THK_PLAN" datasource="#dsn3#">
		SELECT 
		<cfif isDefined('attributes.is_processed')>	
			SUM(BPR.ROW_TOTAL_EXPENSE) EXPENSE,
			SUM(BPR.ROW_OTHER_TOTAL_EXPENSE) OTHER_EXPENSE,
			BPR.ROW_OTHER_MONEY OTHER_MONEY,
			TPM.RATE2/TPM.RATE1 CURRENCY_MULTIPLIER,
			BPR.ROW_PLAN_DATE DATE,
			BP.PROCESS_CAT,
			BP.PROCESS_TYPE,
			BP.MEMBER_TYPE,
			BP.COMPANY_ID,
			BP.CONSUMER_ID,
			BP.EMPLOYEE_ID,
			BP.PROJECT_ID,
			BP.EXPENSE_CENTER_ID EXP_INC_CENTER_ID,
			BPR.ROW_EXPENSE_ITEM_ID EXPENSE_ITEM_ID,
			BP.ACCOUNT_CODE,
			--BPR.ROW_ACCOUNT_CODE,
			BP.MONTH_ACCOUNT_CODE ROW_ACCOUNT_CODE,
			RR.WRK_ROW_ID,
			RR.TAHAKKUK_PLAN_RELATION_ID
		<cfelse>
			BP.PAPER_NO,
			BP.RECORD_EMP,
			BP.PROCESS_CAT,
			BP.TAHAKKUK_PLAN_ID,
			BP.PROJECT_ID,
			BP.EXPENSE_CENTER_ID EXP_INC_CENTER_ID,
			BP.ACCOUNT_CODE,
			<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
				BPR.TAHAKKUK_PLAN_ID,
				BPR.ROW_PLAN_DATE DATE,
				BP.DETAIL,
				ISNULL(BPR.ROW_EXPENSE_CENTER_ID,BP.EXPENSE_CENTER_ID) EXP_INC_CENTER_ID_2,
				BPR.ROW_EXPENSE_ITEM_ID EXPENSE_ITEM_ID,
				BPR.ROW_TOTAL_EXPENSE EXPENSE,
				BPR.ROW_OTHER_TOTAL_EXPENSE OTHER_EXPENSE,
				-- BPR.ROW_ACCOUNT_CODE,
				BP.MONTH_ACCOUNT_CODE ROW_ACCOUNT_CODE,
				BPR.ROW_OTHER_MONEY,
				BPR.WRK_ROW_ID,
			<cfelse>
				BP.EXPENSE_TOTAL EXPENSE,
				BP.OTHER_EXPENSE_TOTAL OTHER_EXPENSE,
				BP.START_DATE DATE,
				BP.START_DATE,
				BP.FINISH_DATE,
				BP.DETAIL,				
			</cfif>
			BP.OTHER_MONEY
		</cfif>
		FROM
			TAHAKKUK_PLAN BP
			LEFT JOIN #DSN3_ALIAS#.TAHAKKUK_PLAN_MONEY TPM ON TPM.MONEY_TYPE = BP.OTHER_MONEY AND TPM.ACTION_ID = BP.TAHAKKUK_PLAN_ID
			<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
				,TAHAKKUK_PLAN_ROW BPR
				<cfif isDefined('attributes.is_processed')>
				,TAHAKKUK_PLAN_ROW_RELATION RR
				</cfif>
			</cfif>
		WHERE
			<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
				BP.TAHAKKUK_PLAN_ID = BPR.TAHAKKUK_PLAN_ID AND 
			</cfif>
			<cfif isDefined('attributes.is_processed')>
				BPR.WRK_ROW_RELATION_ID = RR.WRK_ROW_ID AND
			</cfif>
			BP.PROCESS_CAT IN (SELECT PROCESS_CAT_ID FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN(160,161))
			<!--- AND BP.PERIOD_ID = #session.ep.period_id# ---->
			<cfif len(attributes.search_date1)>
				<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
					AND BPR.ROW_PLAN_DATE >= #attributes.search_date1#
				<cfelse>
					AND BP.START_DATE >= #attributes.search_date1#
				</cfif>
			</cfif>
			<cfif len(attributes.search_date2)>
				<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
					AND BPR.ROW_PLAN_DATE <= #attributes.search_date2#
				<cfelse>
					AND BP.FINISH_DATE <= #attributes.search_date2#
				</cfif>
			</cfif>
			<cfif isDefined('attributes.is_processed') and attributes.is_processed eq 1>
				AND ISNULL(IS_PROCESS,0) = 1
			<cfelse>
				AND ISNULL(IS_PROCESS,0) = 0
			</cfif>
	<cfif isDefined('attributes.is_processed')>
		GROUP BY
			BPR.ROW_OTHER_MONEY,
			TPM.RATE2/TPM.RATE1,
			BPR.ROW_PLAN_DATE,
			BP.PROCESS_CAT,
			BP.PROCESS_TYPE,
			BP.MEMBER_TYPE,
			BP.COMPANY_ID,
			BP.CONSUMER_ID,
			BP.EMPLOYEE_ID,
			BP.PROJECT_ID,
			BP.EXPENSE_CENTER_ID,
			BPR.ROW_EXPENSE_ITEM_ID,
			BP.ACCOUNT_CODE,
			--BPR.ROW_ACCOUNT_CODE,
			BP.MONTH_ACCOUNT_CODE,
			RR.WRK_ROW_ID,
			RR.TAHAKKUK_PLAN_RELATION_ID
	<cfelse>
		ORDER BY 
			BP.PAPER_NO
	</cfif>
	</cfquery>
<cfelse>
	<cfset GET_THK_PLAN.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >
<cfparam name="attributes.totalrecords" default="#get_thk_plan.recordcount#">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="list_rows" method="post" action="#request.self#?fuseaction=budget.list_tahakkuk_aktarim">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search more="0">
				<div class="form-group">
					<div class="input-group">
						<label><input type="checkbox" name="is_processed" value="1" id="is_processed" <cfif isDefined('attributes.is_processed') and attributes.is_processed eq 1>checked</cfif>>
						<b><cf_get_lang dictionary_id='61351.İşlem Görenleri Getir'></b></label>
					</div>
				</div>
				<div class="form-group" id="item-islem_tarih1">					
					<div class="input-group">
						<cfsavecontent variable="place"><cf_get_lang dictionary_id='57692.İşlem'> <cf_get_lang dictionary_id='57501.Başlangıç'></cfsavecontent>
						<cfinput type="text" name="search_date1" value="#dateformat(attributes.search_date1,dateformat_style)#" maxlength="10" placeholder="#place#" validate="#validate_style#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="search_date1"></span>
					</div>
				</div>
				<div class="form-group" id="item-islem_tarih2">
					<div class="input-group">
						<cfsavecontent variable="place"><cf_get_lang dictionary_id='57692.İşlem'><cf_get_lang dictionary_id='57502.Bitiş'></cfsavecontent>
						<cfinput type="text" name="search_date2" value="#dateformat(attributes.search_date2,dateformat_style)#" maxlength="10" placeholder="#place#" validate="#validate_style#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="search_date2"></span>
					</div>
				</div>	
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" onKeyUp="isNumber(this)" required="yes" validate="integer" range="1,999" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
		</cfform>       
	</cf_box>
	<cfsavecontent variable="title"><cf_get_lang dictionary_id="56296.Tahakkuk Planları Aktarım"></cfsavecontent>
	<cf_box title="#title#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>             
				<tr>
					<th width="30" rowspan="2"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th rowspan="2"><cf_get_lang dictionary_id='57800.İşlem Tipi'></th>
				<cfif not isDefined('attributes.is_processed')>
					<th rowspan="2"><cf_get_lang dictionary_id='57880.Belge No'></th>
					<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 1)>
						<th rowspan="2"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></th>
						<th rowspan="2"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
					</cfif>
				</cfif>
					<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)>
						<th rowspan="2"><cf_get_lang dictionary_id='57742.Tarih'></th>
					</cfif>
				<cfif not isDefined('attributes.is_processed')>
					<th rowspan="2"><cf_get_lang dictionary_id='57629.Aciklama'></th>
				</cfif>
					<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
						<th rowspan="2" nowrap="nowrap"><cf_get_lang dictionary_id='57416.Proje'></th>
						<th rowspan="2" nowrap="nowrap"><cf_get_lang dictionary_id='58235.Masraf/Gelir Merkezi'></th>
						<th rowspan="2" nowrap="nowrap"><cf_get_lang dictionary_id='58551.Gider Kalemi'></th>
						<th rowspan="2" nowrap="nowrap"><cf_get_lang dictionary_id='61352.Aktarılacak Muhasebe Kodu'></th>
						<th rowspan="2" nowrap="nowrap"><cf_get_lang dictionary_id='61353.Tahakkuk Muhasebe Kodu'></th>
					</cfif>			
					<th style="text-align:center"><cf_get_lang dictionary_id='58905.Sistem Dövizi'></th>
					<th style="text-align:center"><cf_get_lang dictionary_id='58121.İşlem Dövizi'></th>
					<th width="80"><cf_get_lang dictionary_id='57489.Para Birimi'></th>
					<!-- sil -->
					<cfif isDefined('attributes.is_processed')>
						<th class="header_icn_none text-center" nowrap="nowrap">
						</th>
					</cfif>
					<th class="header_icn_none text-center" nowrap="nowrap" rowspan="2">
						<input type="checkbox" name="allSelectRows" id="allSelectRows" onclick="wrk_select_all('allSelectRows','rows_info');">
					</th>
					<!-- sil -->
				</tr>
			</thead>
			<form name="form_gider_islem" method="post" action="<cfoutput>#request.self#?</cfoutput>fuseaction=budget.emptypopup_tahakkuk_aktarim_gider">
			<tbody>
				<cfif get_thk_plan.recordcount>
					<cfset process_cat_list = "">
					<cfset budget_item_id_list = "">
					<cfset exp_inc_center_id_list = "">
					<cfoutput query="get_thk_plan" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(process_cat) and not listfind(process_cat_list,process_cat)>
							<cfset process_cat_list=listappend(process_cat_list,process_cat)>
						</cfif>
						<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
							<cfif len(exp_inc_center_id) and not listfind(exp_inc_center_id_list,exp_inc_center_id)>
								<cfset exp_inc_center_id_list=listappend(exp_inc_center_id_list,exp_inc_center_id)>
							</cfif>
							<cfif len(EXPENSE_ITEM_ID) and not listfind(budget_item_id_list,EXPENSE_ITEM_ID)>
								<cfset budget_item_id_list=listappend(budget_item_id_list,EXPENSE_ITEM_ID)>
							</cfif>
						</cfif>
					</cfoutput>
					<cfif len(process_cat_list)>
						<cfset process_cat_list=listsort(process_cat_list,"numeric","ASC",",")>
						<cfquery name="get_process" datasource="#dsn3#">
							SELECT PROCESS_CAT,PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID IN (#process_cat_list#) ORDER BY PROCESS_CAT_ID
						</cfquery>
						<cfset process_cat_list = listsort(listdeleteduplicates(valuelist(get_process.process_cat_id,',')),'numeric','ASC',',')>
					</cfif>
					<!--- masraf/gelir merkezleri --->
					<cfif len(exp_inc_center_id_list)>
						<cfset exp_inc_center_id_list=listsort(exp_inc_center_id_list,"numeric","ASC",",")>
						<cfquery name="get_exp_inc_center_name" datasource="#dsn2#">
							SELECT 
								EXPENSE,
								EXPENSE_ID
							FROM 
								EXPENSE_CENTER
							WHERE 
								EXPENSE_ID IN (#exp_inc_center_id_list#) 
							ORDER BY 
								EXPENSE_ID
						</cfquery>
						<cfset exp_inc_center_id_list = listsort(listdeleteduplicates(valuelist(get_exp_inc_center_name.expense_id,',')),'numeric','ASC',',')>
					</cfif>
					<!--- butce kalemleri --->
					<cfif len(budget_item_id_list)>
						<cfset budget_item_id_list=listsort(budget_item_id_list,"numeric","ASC",",")>
						<cfquery name="get_exp_detail" datasource="#dsn2#">
							SELECT 
								EXPENSE_ITEM_NAME,
								EXPENSE_ITEM_ID
							FROM 
								EXPENSE_ITEMS
							WHERE 
								EXPENSE_ITEM_ID IN (#budget_item_id_list#) 
							ORDER BY 
								EXPENSE_ITEM_ID
						</cfquery>
						<cfset budget_item_id_list = listsort(listdeleteduplicates(valuelist(get_exp_detail.expense_item_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfoutput query="get_thk_plan" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td>
								<cfif len(process_cat)>
									#get_process.process_cat[listfind(process_cat_list,process_cat,',')]#
								</cfif>
							</td>
						<cfif not isDefined('attributes.is_processed')>
							<td><a href="#request.self#?fuseaction=budget.list_tahakkuk&event=upd&tplan_id=#tahakkuk_plan_id#" class="tableyazi">#PAPER_NO#</a></td>
							<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 1)>
								<td>#dateformat(start_date,dateformat_style)#</td>
								<td>#dateformat(finish_date,dateformat_style)#</td>
							</cfif>
						</cfif>
							<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)>
								<td>#dateformat(date,dateformat_style)#</td>
							</cfif>
						<cfif not isDefined('attributes.is_processed')>
							<td>#detail#</td>
						</cfif>
							<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
								<td><cfif isdefined('project_id') and len(project_id)>#GET_PROJECT_NAME(project_id)#</cfif></td>
								<td>#get_exp_inc_center_name.expense[listfind(exp_inc_center_id_list,exp_inc_center_id,',')]#</td>
								<td>#get_exp_detail.expense_item_name[listfind(budget_item_id_list,EXPENSE_ITEM_ID,',')]#</td>
								<td>#ACCOUNT_CODE#</td>
								<td>#ROW_ACCOUNT_CODE#</td>
							</cfif>					
							<td style="text-align:right;">#TLFormat(EXPENSE)#</td>
							<td style="text-align:right;">#TLFormat(OTHER_EXPENSE)#</td>
							<td>#other_money#</td>
							<!-- sil -->
							<cfif isDefined('attributes.is_processed')>
								<td>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#TAHAKKUK_PLAN_RELATION_ID#&action_table=TAHAKKUK_PLAN_ROW_RELATION&process_cat=#PROCESS_TYPE#','page');"><img src="/images/extre.gif" title="<cf_get_lang dictionary_id='58215.Muhasebe Fişi'>"></a>
								</td>
							</cfif>
							<td>
								<cfif not isDefined('attributes.is_processed')>
									<input type="checkbox" name="rows_info" id="rows_info" value="#CURRENTROW#;#tahakkuk_plan_id#;#wrk_row_id#">
								<cfelse>
									<input type="checkbox" name="rows_info" id="rows_info" value="#CURRENTROW#;#TAHAKKUK_PLAN_RELATION_ID#;#wrk_row_id#">
								</cfif>
							</td>
							<!-- sil -->
						</tr>
					</cfoutput>
					<cfset colspan_info = 14>
					<tr height="40" class="nohover">
						<td colspan="<cfoutput>#colspan_info#</cfoutput>" align="right" style="text-align:right;">
							<cfif not isDefined('attributes.is_processed')>
								<input type="button" value="Gider Kaydı Yap" name="gider_kayit" id="gider_kayit" onclick="gider_islem(1);">
							<cfelse>
								<input type="button" value="Gider Kaydı Sil" name="gider_sil" id="gider_sil" onclick="gider_islem(2);">
							</cfif>
						</td>
						<input type="hidden" name="wrk_row_id_list" id="wrk_row_id_list" value="">
						<input type="hidden" name="plan_id_list" id="plan_id_list" value="">
						<input type="hidden" name="currntrow_list" id="currntrow_list" value="">
						<input type="hidden" name="islem_type" id="islem_type" value="">
						<div id="user_message_div_"></div>
					</tr>
				<cfelse>
					<tr>
						<td colspan="15"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
					</tr>
				</cfif>
			</tbody>
			</form>
		</cf_grid_list>
			<cfset url_str = "">
			<cfif isDefined("attributes.form_submitted")>
				<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
			</cfif>
			<cfif len(attributes.search_date1)>
				<cfset url_str = "#url_str#&search_date1=#dateformat(attributes.search_date1,dateformat_style)#">
			</cfif>
			<cfif len(attributes.search_date2)>
				<cfset url_str = "#url_str#&search_date2=#dateformat(attributes.search_date2,dateformat_style)#">
			</cfif>
			<cfif len(attributes.listing_type)>
				<cfset url_str = "#url_str#&listing_type=#attributes.listing_type#">
			</cfif>
			<cfif isDefined('attributes.is_processed')>
				<cfset url_str = "#url_str#&is_processed=#attributes.is_processed#">
			</cfif>
			<cf_paging 
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="budget.list_tahakkuk_aktarim#url_str#">
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function gider_islem(type)
	{
		var is_selected=0;
		if(document.getElementsByName('rows_info').length > 0)
		{
			var currntrow_list = "";
			var _wrk_row_id_list_ = "";
			var _plan_id_list_ = "";
			if(document.getElementsByName('rows_info').length == 1)
			{
				if(document.getElementById('rows_info').checked==true)
				{
					is_selected=1;
					currntrow_list+=list_getat(document.form_gider_islem.rows_info.value,1,';')+',';
					_plan_id_list_+=list_getat(document.form_gider_islem.rows_info.value,2,';')+',';
					_wrk_row_id_list_+=list_getat(document.form_gider_islem.rows_info.value,3,';')+',';
				}
			}	
			else
			{
				for (i=0;i<document.getElementsByName('rows_info').length;i++)
				{
					if(document.form_gider_islem.rows_info[i].checked==true)
					{ 
						currntrow_list+=list_getat(document.form_gider_islem.rows_info[i].value,1,';')+',';
						_plan_id_list_+=list_getat(document.form_gider_islem.rows_info[i].value,2,';')+',';
						_wrk_row_id_list_+=list_getat(document.form_gider_islem.rows_info[i].value,3,';')+',';
						is_selected=1;
					}
				}		
			}
		}
		if(is_selected == 1)
		{
			if(list_len(_plan_id_list_) > 1)
				_plan_id_list_ = _plan_id_list_.substr(0,_plan_id_list_.length-1);
			if(list_len(_wrk_row_id_list_) > 1)
				_wrk_row_id_list_ = _wrk_row_id_list_.substr(0,_wrk_row_id_list_.length-1);
			if(list_len(currntrow_list) > 1)
				currntrow_list = currntrow_list.substr(0,currntrow_list.length-1);
			//alert('_plan_id_list_= '+_plan_id_list_+' _wrk_row_id_list_= '+_wrk_row_id_list_);
			
			document.getElementById('plan_id_list').value = _plan_id_list_;
			document.getElementById('wrk_row_id_list').value = _wrk_row_id_list_;
			document.getElementById('currntrow_list').value = currntrow_list;
			document.getElementById('islem_type').value = type;
			
			windowopen('','small','p_action_window');
			form_gider_islem.target = 'p_action_window';
			form_gider_islem.submit();
		}
		else
		{
			alert("<cf_get_lang dictionary_id='61354.İşlem için satır seçiniz'> !");
			return false;
		}
	}
</script>