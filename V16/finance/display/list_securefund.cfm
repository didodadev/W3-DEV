<!--- teminat tabloları crm ekranlarnda da kullanılıyor ama sayfalar ortaklaştırılmadı şimdilik,ayrı özellikleri var--->
<cf_get_lang_set module_name="finance">
<cf_xml_page_edit fuseact="finance.list_securefund">
<cfparam name="attributes.securefund_status" default="1">
<cfparam name="attributes.return_status" default="">
<cfparam name="attributes.start_date_1" default="">
<cfparam name="attributes.start_date_2" default="">
<cfparam name="attributes.finish_date_1" default="">
<cfparam name="attributes.finish_date_2" default="">
<cfparam name="attributes.comp_id" default="">
<cfparam name="attributes.special_code" default="">
<cfparam name="attributes.contract_no" default="">
<cfparam name="attributes.contract_id" default="">
<cfparam name="attributes.record_date" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.securefund_cat" default="">
<cfparam name="attributes.action_cat_id" default="">
<cfparam name="attributes.comp_branch_id" default="">

<cfquery name="get_process_cat" datasource="#dsn3#">
	SELECT
		DISTINCT
		SPC.PROCESS_CAT,
		SPC.PROCESS_CAT_ID
	FROM
		SETUP_PROCESS_CAT AS SPC
		<cfif x_process_cat_control>
			LEFT OUTER JOIN SETUP_PROCESS_CAT_ROWS AS SPCR ON SPC.PROCESS_CAT_ID = SPCR.PROCESS_CAT_ID
			LEFT OUTER JOIN #dsn#.EMPLOYEE_POSITIONS AS EP ON (SPCR.POSITION_CODE = EP.POSITION_CODE OR SPCR.POSITION_CAT_ID = EP.POSITION_CAT_ID)
		</cfif>
	WHERE
		SPC.PROCESS_TYPE IN (300,301)
		<cfif x_process_cat_control>
			AND
			(
				( SPC.IS_ALL_USERS = 1 )
				OR
				(
					EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
				)
			)
		</cfif>
</cfquery>

<cfset process_cat_ids = ValueList(get_process_cat.PROCESS_CAT_ID)>

<cfif isdefined('attributes.is_submitted')>
	<cfif isdefined("attributes.start_date_1") and len(attributes.start_date_1)><cf_date tarih="attributes.start_date_1"></cfif>
	<cfif isdefined("attributes.start_date_2") and len(attributes.start_date_2)><cf_date tarih="attributes.start_date_2"></cfif>
	<cfif isdefined("attributes.finish_date_1") and len(attributes.finish_date_1)><cf_date tarih="attributes.finish_date_1"></cfif>
	<cfif isdefined("attributes.finish_date_2") and len(attributes.finish_date_2)><cf_date tarih="attributes.finish_date_2"></cfif>
	<cfif isdefined("attributes.record_date") and len(attributes.record_date)><cf_date tarih="attributes.record_date"></cfif>	
	<cfquery name="GET_COMPANY_SECUREFUND" datasource="#DSN#">
		SELECT 
			CS.*,
			ISNULL(CS.EXPENSE_TOTAL,0) EXPENSE_TOTAL_,
			OC.COMPANY_NAME,
			SS.SECUREFUND_CAT
		FROM 
			COMPANY_SECUREFUND CS,
			OUR_COMPANY OC,
			SETUP_SECUREFUND SS,
			COMPANY C

		WHERE 
			ISNULL(CS.IS_CRM,0) = 0 AND<!--- Crm modulunde kullanilanlarla ayirmak amaciyla eklendi --->
			CS.OUR_COMPANY_ID = OC.COMP_ID AND 
			CS.COMPANY_ID = C.COMPANY_ID AND
			SS.SECUREFUND_CAT_ID = CS.SECUREFUND_CAT_ID AND
			CS.OUR_COMPANY_ID = #session.ep.company_id#
			<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
				AND (
						SS.SECUREFUND_CAT LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
						CS.REALESTATE_DETAIL LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
					)
			</cfif>
			<cfif isdefined("attributes.give_take") and len(attributes.give_take)>
				AND CS.GIVE_TAKE = #attributes.give_take#
			</cfif>
			<cfif isdate(attributes.record_date) and len(attributes.record_date)>
				AND CS.RECORD_DATE >= #attributes.record_date# 
			</cfif>
			<cfif isdate(attributes.start_date_1) and len(attributes.start_date_1)>
				AND CS.START_DATE >= #attributes.start_date_1#
			</cfif>
			<cfif isdate(attributes.start_date_2) and len(attributes.start_date_2)>
				AND CS.START_DATE < #date_add('d',1,attributes.start_date_2)#
			</cfif>
			<cfif isdate(attributes.finish_date_1) and len(attributes.finish_date_1)>
				AND CS.FINISH_DATE >= #attributes.finish_date_1#
			</cfif>
			<cfif isdate(attributes.finish_date_2) and len(attributes.finish_date_2)>
				AND CS.FINISH_DATE < #date_add('d',1,attributes.finish_date_2)#
			</cfif>
			<cfif isDefined("attributes.member_type") and attributes.member_type eq 'partner' and len(attributes.company_id) and len(attributes.member)>
				AND CS.COMPANY_ID = #attributes.company_id#
			</cfif>
			<cfif isDefined("attributes.member_type") and attributes.member_type eq 'consumer' and len(attributes.member_id) and len(attributes.member)>
				AND CS.CONSUMER_ID = #attributes.member_id#
			</cfif>
			<cfif isdefined('attributes.comp_id') and len(attributes.comp_id)>
				AND	COMP_ID = #attributes.comp_id#
			</cfif>	
			<cfif isdefined('attributes.contract_id') and len(attributes.contract_id)>
				AND	CS.CONTRACT_ID = #attributes.contract_id#
			</cfif>	
			<cfif isdefined('attributes.bank_id') and len(attributes.bank_id)>
				AND	CS.BANK_ID = #attributes.bank_id#
			</cfif>
			<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
				AND	CS.BANK_BRANCH_ID = #attributes.branch_id# 
			</cfif>
			<cfif session.ep.isBranchAuthorization eq 0 and isdefined('attributes.comp_branch_id') and len(attributes.comp_branch_id)>
				AND	CS.OURCOMP_BRANCH = #attributes.comp_branch_id#
			<cfelseif session.ep.isBranchAuthorization>
				AND CS.OURCOMP_BRANCH = #listlast(session.ep.user_location,'-')# 
			</cfif>
			<cfif isdefined('attributes.project_id') and len(attributes.project_id) and len(attributes.project_head)>
				AND	CS.PROJECT_ID = #attributes.project_id# 
			</cfif>
			<cfif isdefined('attributes.securefund_cat') and len(attributes.securefund_cat) >
				AND	CS.SECUREFUND_CAT_ID = #attributes.securefund_cat# 
			</cfif>
			<cfif isdefined('attributes.action_cat_id') and len(attributes.action_cat_id) >
				AND	CS.ACTION_CAT_ID = #attributes.action_cat_id# 
			</cfif>
			<cfif x_process_cat_control>
				AND	CS.ACTION_CAT_ID IN (#process_cat_ids#)
			</cfif>
			<cfif isdefined('attributes.special_code') and len(attributes.special_code) >
				AND	C.OZEL_KOD LIKE '%#attributes.special_code#%' 
			</cfif>
			<cfif isdefined('return_status') and return_status eq 1>
				AND CS.GIVE_TAKE=1 AND RETURN_PROCESS_CAT IS NOT NULL
			<cfelseif isdefined('return_status') and return_status eq 0>
				AND CS.GIVE_TAKE=0 AND RETURN_PROCESS_CAT IS NOT NULL
			<cfelseif isdefined('return_status') and return_status eq 2>
				AND CS.GIVE_TAKE=0 AND RETURN_PROCESS_CAT IS NULL
			</cfif>															
			<cfif isDefined('attributes.securefund_status') and len(attributes.securefund_status)>AND SECUREFUND_STATUS = #attributes.securefund_status#</cfif>
		ORDER BY 
			CS.RECORD_DATE DESC
	</cfquery>
<cfelse>
	<cfset get_company_securefund.recordcount = 0>
</cfif>
<cfquery name="GET_BANK_BRANCHES" datasource="#DSN3#">
	SELECT 
		BANK_BRANCH_ID,
		BANK_BRANCH_NAME,
		BANK_NAME
	FROM 
		BANK_BRANCH 
	WHERE 
		BANK_ID IS NOT NULL
	ORDER BY
		BANK_NAME
</cfquery>
<cfquery name="GET_COMPANY_" datasource="#DSN#">
	SELECT COMP_ID,NICK_NAME FROM OUR_COMPANY ORDER BY COMPANY_NAME
</cfquery>
<cfquery name="GET_CAT" datasource="#DSN#">
	SELECT SECUREFUND_CAT_ID,SECUREFUND_CAT FROM SETUP_SECUREFUND ORDER BY SECUREFUND_CAT
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_company_securefund.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="search" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.list_securefund">
			<input type="hidden" name="is_submitted" id="is_submitted" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" name="keyword" placeholder="#getLang(48,'Filtre',57460)#" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group">
					<cfsavecontent variable="ozel_kod"><cf_get_lang dictionary_id='57658.Özel Kod'><cf_get_lang dictionary_id='57789.Özel Kod'></cfsavecontent>
					<cfinput type="text" name="special_code" id="special_code" placeholder="#ozel_kod#" value="#attributes.special_code#" maxlength="50">
				</div>
				<div class="form-group medium">
					<select name="securefund_cat" id="securefund_cat">
						<option value=""><cf_get_lang dictionary_id='57486.Kategori'></option> 
						<cfoutput query="get_cat">
							<option value="#securefund_cat_id#" <cfif attributes.securefund_cat eq securefund_cat_id>selected</cfif>>#securefund_cat#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="give_take" id="give_take">
						<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
						<option value="0" <cfif isdefined("attributes.give_take") and (attributes.give_take eq 0)>selected</cfif>><cf_get_lang dictionary_id='58488.alınan'></option>
						<option value="1" <cfif isdefined("attributes.give_take") and (attributes.give_take eq 1)>selected</cfif>><cf_get_lang dictionary_id='58490.verilen'></option>
						<option value="2" <cfif isdefined("attributes.give_take") and (attributes.give_take eq 2)>selected</cfif>><cf_get_lang dictionary_id='62327.iade edilmeyen'></option>
					</select>
				</div>
				<div class="form-group">
					<select name="securefund_status" id="securefund_status">
						<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
						<option value="1" <cfif attributes.securefund_status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="0" <cfif attributes.securefund_status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
					</select>
				</div>
				<div class="form-group">
					<select name="return_status" id="return_status">
						<option value=""><cf_get_lang dictionary_id='57756.Durum'></option>
						<option value="1" <cfif attributes.return_status eq 1>selected</cfif>><cf_get_lang dictionary_id="54419.İade Alındı"></option>
						<option value="0" <cfif attributes.return_status eq 0>selected</cfif>><cf_get_lang dictionary_id="54420.İade Edildi"></option>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" id="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
			</cf_box_search>
			<cf_box_search_detail>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<cfif session.ep.isBranchAuthorization eq 0>
							<div class="form-group" id="item-comp_id">
								<label class="col col-12"><cf_get_lang dictionary_id='57574.Şirketimiz'></label>
								<div class="col col-12">
									<select name="comp_id" id="comp_id" onchange="showDepartment(this.value)">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfoutput query="get_company_">
											<option value="#comp_id#"
												<cfif len(attributes.comp_id)>
													<cfif attributes.comp_id eq comp_id>
														selected
													</cfif>
												<cfelse>
													<cfif session.ep.company_id eq comp_id>
														selected
													</cfif>
												</cfif>
												>
												#nick_name#
											</option>
										</cfoutput>
									</select>
								</div> 
							</div>
						<cfelse>
						</cfif>
							<div class="form-group" id="item-action_cat_id">
								<label class="col col-12 col-xs-12"><cfoutput>#getLang(388,'İşlem Tipi',40683)#</cfoutput></label>
								<div class="col col-12">
									<select name="action_cat_id" id="action_cat_id">
										<option value=""><cfoutput>#getLang(322,'Seçiniz',57734)#</cfoutput></option>
										<cfoutput query="get_process_cat">
											<option value="#process_cat_id#" <cfif attributes.action_cat_id eq process_cat_id>selected</cfif>>#process_cat#</option>
										</cfoutput>
									</select>
								</div>
							</div>
						<div class="form-group" id="item-DEPARTMENT_PLACE">
							<label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
							<div class="col col-12">
								<select name="DEPARTMENT_PLACE" id="DEPARTMENT_PLACE">
									<div width="310" id="DEPARTMENT_PLACE"></div> 
								</select> 
							</div>    
						</div>  
						<div class="form-group" id="item-bank_branch_id">
							<label class="col col-12"><cf_get_lang dictionary_id='57521.Banka'></label>
							<div class="col col-12">
								<select name="branch_id" id="branch_id">
									<option value=""><cf_get_lang dictionary_id='57521.Banka'></option>
									<cfoutput query="get_bank_branches">
										<option value="#bank_branch_id#" <cfif isdefined('attributes.branch_id') and attributes.branch_id eq bank_branch_id>selected</cfif>>#bank_name# - #bank_branch_name#</option>
									</cfoutput>
								</select> 
							</div>    
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<cfoutput>
						<div class="form-group" id="item-company_id">
							<label class="col col-12"><cf_get_lang dictionary_id = '57519.Cari Hesap'></label>
							<div class="col col-12">
								<div class="input-group">
									<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined('attributes.company_id')>#attributes.company_id#</cfif>">
									<input type="hidden" name="member_type" id="member_type" value="<cfif isdefined('attributes.member_type')>#attributes.member_type#</cfif>">
									<input type="hidden" name="member_id" id="member_id" value="<cfif isdefined('attributes.member_id')>#attributes.member_id#</cfif>">
									<input name="member" type="text" id="member" onfocus="AutoComplete_Create('member','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',0,0,0','COMPANY_ID,MEMBER_TYPE,PARTNER_CODE','company_id,member_type,member_id','','3','250');"  value="<cfif isdefined('attributes.member')>#attributes.member#</cfif>" autocomplete="off">
									<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_all_pars&field_comp_id=search.company_id&field_type=search.member_type&field_id=search.member_id&field_comp_name=search.member&field_name=search.member&select_list=2,3');" title="<cf_get_lang dictionary_id = '57519.Cari Hesap'>"></span>
								</div>
							</div>    
						</div>						
						</cfoutput>
						<div class="form-group" id="item-project_id">
							<label class="col col-12"><cf_get_lang dictionary_id='57416.Proje'></label>
							<div class="col col-12">
								<div class="input-group">
									<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id')><cfoutput>#attributes.project_id#</cfoutput></cfif>">
									<input type="text" name="project_head" id="project_head" value="<cfif isdefined('attributes.project_head') and  len(attributes.project_head)><cfoutput>#attributes.project_head#</cfoutput></cfif>" onfocus="AutoComplete_Create('project_head','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','search','3','120')" autocomplete="off">
									<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=search.project_id&project_head=search.project_head');" title="<cf_get_lang dictionary_id='57416.Proje'>"></span>
								</div>
							</div>    
						</div>
						<div class="form-group" id="item-record_date">
							<label class="col col-12"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></label>
							<div class="col col-12">
								<div class="input-group">
									<input name="record_date" id="record_date" value="<cfif len(attributes.record_date)><cfoutput>#dateformat(attributes.record_date,dateformat_style)#</cfoutput></cfif>" type="text">
									<span class="input-group-addon"><cf_wrk_date_image date_field="record_date"></span>
								</div>
							</div>    
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
						<div class="form-group" id="item-start_date_1">
							<label class="col col-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
							<div class="col col-12">
								<div class="input-group">
									<input name="start_date_1" id="start_date_1" value="<cfif len(attributes.start_date_1)><cfoutput>#dateformat(attributes.start_date_1,dateformat_style)#</cfoutput></cfif>" type="text">
									<span class="input-group-addon"><cf_wrk_date_image date_field="start_date_1"></span>
									<span class="input-group-addon no-bg"></span>
									<input name="start_date_2" id="start_date_2" value="<cfif len(attributes.start_date_2)><cfoutput>#dateformat(attributes.start_date_2,dateformat_style)#</cfoutput></cfif>" type="text">
									<span class="input-group-addon"><cf_wrk_date_image date_field="start_date_2"></span>
								</div>
							</div>    
						</div>
						<div class="form-group" id="item-finish_date_1">
							<label class="col col-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
							<div class="col col-12">
								<div class="input-group">
									<input name="finish_date_1" id="finish_date_1" value="<cfif len(attributes.finish_date_1)><cfoutput>#dateformat(attributes.finish_date_1,dateformat_style)#</cfoutput></cfif>" type="text">
									<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date_1"></span>
									<span class="input-group-addon no-bg"></span>
									<input name="finish_date_2" id="finish_date_2" value="<cfif len(attributes.finish_date_2)><cfoutput>#dateformat(attributes.finish_date_2,dateformat_style)#</cfoutput></cfif>" type="text">
									<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date_2"></span>
								</div>
							</div>    
						</div>
					</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(264,'Teminatlar',57676)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th> 
					<th width="20"><cf_get_lang dictionary_id='57880.Belge No'></th> 
					<th><cf_get_lang dictionary_id='57658.Üye'></th>
					<th><a><i class="fa fa-handshake-o" title="<cf_get_lang dictionary_id='29522.Sözleşme'>" style='color:#44b6ae!important'></i></a></th>
					<th><cf_get_lang dictionary_id='58488.Alınan'>/ <cf_get_lang dictionary_id='58490.Verilen'></tdh>
					<th><cf_get_lang dictionary_id ='57756.Durum'></th>
					<th><cf_get_lang dictionary_id='58689.Teminat'></th>
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<th><cf_get_lang dictionary_id='57521.Banka'></th>
					<th><cf_get_lang dictionary_id='57453.Sube'></th>
					<th><cf_get_lang dictionary_id='57416.Proje'></th>
					<th><cf_get_lang dictionary_id='57673.Tutar'></th>
					<th><cf_get_lang dictionary_id ='57489.Para Br'></th>
					<th><cf_get_lang dictionary_id ='58905.Sistem Dövizi'> <cf_get_lang dictionary_id='57673.Tutar'></th>
					<th><cf_get_lang dictionary_id ='58905.Sistem Dövizi'></th>
					<cfif is_masraf eq 1>
						<th><cf_get_lang dictionary_id ='58930.Masraf'></th>
						<th><cf_get_lang dictionary_id ='57489.Para Br'></th>
					</cfif>
					<cfif is_komisyon eq 1>
						<th><cf_get_lang dictionary_id ='58791.Komisyon'>(%)</th>
					</cfif>
					<th><cf_get_lang dictionary_id='57655.Başlama Tarihi'></th>
					<th><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>				 
					<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
					<th><a><i class="fa fa-plug" title="<cf_get_lang dictionary_id='54637.Şirketim'>"></i></a></th>
					<!-- sil --><th width="20" class="header_icn_none text-center"><a  href="<cfoutput>#request.self#</cfoutput>?fuseaction=finance.list_securefund&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th><!-- sil -->
				</tr>
			</thead>
				<cfif get_company_securefund.recordcount>
					<cfset company_list = ''>
					<cfset cons_list =''>
					<cfset bank_list = ''>
					<cfset branch_list = ''>
					<cfset project_id_list = ''>
					<cfset tutar_list = "">		
					<cfset money_list = "">
					<cfset debt_total_ = 0>
					<cfset masraf_tutar_list = "">		
					<cfset masraf_money_list = "">
					<cfoutput query="get_company_securefund" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(consumer_id) and not listfindnocase(cons_list,consumer_id)>
							<cfset cons_list = listappend(cons_list,consumer_id,',')>
						</cfif>
						<cfif len(company_id) and not listfindnocase(company_list,company_id)>
							<cfset company_list = listappend(company_list,company_id,',')>
						</cfif>
						<cfif len(bank_branch_id) and not listfindnocase(branch_list,bank_branch_id)>
							<cfset branch_list = listappend(branch_list,bank_branch_id,',')>
						</cfif>	
						<cfif len(project_id) and not listfind(project_id_list,project_id)>
							<cfset project_id_list = listappend(project_id_list,project_id)>
						</cfif>
						<cfset doviz_yeri = listfind(money_list,get_company_securefund.money_cat,',')>
						<cfif doviz_yeri>
							<cfset tutar_list = listsetat(tutar_list,doviz_yeri,securefund_total+listgetat(tutar_list,doviz_yeri,','),',')>
						<cfelse>
							<cfset tutar_list = listappend(tutar_list,securefund_total,',')>
							<cfset money_list = listappend(money_list,get_company_securefund.money_cat,',')>
						</cfif>	
						<cfif is_masraf eq 1>
							<cfset masraf_doviz_yeri = listfind(masraf_money_list,get_company_securefund.money_cat_expense,',')>
							<cfif masraf_doviz_yeri>
								<cfset masraf_tutar_list = listsetat(masraf_tutar_list,masraf_doviz_yeri,expense_total_+listgetat(masraf_tutar_list,masraf_doviz_yeri,','),',')>
							<cfelse>
								<cfset masraf_tutar_list = listappend(masraf_tutar_list,expense_total_,',')>
								<cfset masraf_money_list = listappend(masraf_money_list,get_company_securefund.money_cat_expense,',')>
							</cfif>
						</cfif>
						<cfset debt_total_ = debt_total_+action_value>	
					</cfoutput>
					<cfif len(cons_list)>
						<cfset cons_list = listsort (listdeleteduplicates(cons_list),"numeric","ASC",",")>
						<cfquery name="get_cons" datasource="#DSN#">
							SELECT CONSUMER_ID,CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#cons_list#) ORDER BY CONSUMER_ID
						</cfquery>
					</cfif>
					<cfif len(company_list)>
						<cfset company_list = listsort(listdeleteduplicates(company_list),"numeric","ASC",",")>
						<cfquery name="get_comp" datasource="#DSN#">
							SELECT COMPANY_ID, NICKNAME, FULLNAME FROM COMPANY WHERE COMPANY_ID IN (#company_list#) ORDER BY COMPANY_ID
						</cfquery>
					</cfif>
					<cfif len(bank_list)>
						<cfset bank_list = listsort (listdeleteduplicates(bank_list),"numeric","ASC",",")>
						<cfquery name="get_bank" datasource="#DSN#">
							SELECT BANK_ID,BANK_NAME FROM SETUP_BANK_TYPES WHERE BANK_ID IN (#bank_list#) ORDER BY BANK_ID
						</cfquery>
					</cfif>
					<cfif len(branch_list)>
						<cfset branch_list = listsort (listdeleteduplicates(branch_list),"numeric","ASC",",")>
						<cfquery name="get_branch" datasource="#DSN3#">
							SELECT BANK_BRANCH_ID,BANK_BRANCH_NAME,BANK_NAME FROM BANK_BRANCH WHERE BANK_BRANCH_ID IN (#branch_list#) ORDER BY BANK_BRANCH_ID
						</cfquery>
					</cfif>
					<tbody>
						<cfif len(project_id_list)>
							<cfset project_id_list=listsort(project_id_list,"numeric","ASC",",")>
							<cfquery name="get_pro_name" datasource="#dsn#">
								SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_id_list#) ORDER BY PROJECT_ID
							</cfquery>
							<cfset project_id_list = listsort(listdeleteduplicates(valuelist(get_pro_name.project_id,',')),'numeric','ASC',',')>
						</cfif> 					
						<cfoutput query="get_company_securefund" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<tr>
								<td>#currentrow#</td>
								<td><a href="#request.self#?fuseaction=finance.list_securefund&event=upd&securefund_id=#securefund_id#">#paper_no#</a></td>
								<td>
									<cfif len(company_id)>
										<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','medium');">
										#get_comp.fullname[listfind(company_list,company_id,',')]#</a>
									<cfelseif len(consumer_id)>
										<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id= #consumer_id#','medium');">
										#get_cons.consumer_name[listfind(cons_list,consumer_id,',')]# #get_cons.consumer_surname[listfind(cons_list,consumer_id,',')]#</a>
									</cfif>
								</td>
								<td><cfif len(contract_id)><a href="#request.self#?fuseaction=contract.list_related_contracts&event=upd&contract_id=#contract_id#" target="_blank"><i class="fa fa-handshake-o" title="<cf_get_lang dictionary_id="29522.Sözleşme">" style="color:##FB0808!important"></i></a></cfif></td>
								<td><cfif give_take eq 0><cf_get_lang dictionary_id='58488.Alınan'><cfelse><cf_get_lang dictionary_id='58490.Verilen'></cfif></td>
								<td>
									<cfif len(get_company_securefund.return_process_cat)><cf_get_lang dictionary_id="29418.İade"><cfif get_company_securefund.GIVE_TAKE EQ 1><cf_get_lang dictionary_id="54412.Alındı"><cfelse><cf_get_lang dictionary_id="54418.Edildi"></cfif></cfif>
								</td>
								<td>#securefund_cat#</td>
								<td>#left(realestate_detail,100)#<cfif len(realestate_detail) gt 100>...</cfif></td>
								<td width="150"><cfif len(bank_branch_id)>#get_branch.bank_name[listfind(branch_list,bank_branch_id,',')]#<cfelse>#bank#</cfif></td>
								<td width="150"><cfif len(bank_branch_id)>#get_branch.bank_branch_name[listfind(branch_list,bank_branch_id,',')]#<cfelse>#bank_branch#</cfif></td>
								<td><cfif len(project_id_list) and len(project_id)>#get_pro_name.project_head[listfind(project_id_list,project_id,',')]#</cfif></td>
								<td class="moneybox">#TLFormat(securefund_total)# </td>
								<td>&nbsp;#money_cat#</td>
								<td class="moneybox">#TLFormat(action_value)# </td>
								<td>&nbsp;#session.ep.money#</td>
								<cfif is_masraf eq 1>
									<td class="moneybox">#TLFormat(expense_total_)#</td>
									<td>#money_cat_expense#</td>
								</cfif>
								<cfif is_komisyon eq 1>
									<td class="moneybox">#commission_rate#</td>
								</cfif>
								<td>#dateformat(start_date,dateformat_style)#</td>
								<td>#dateformat(finish_date,dateformat_style)#</td>
								<td>#dateformat(record_date,dateformat_style)#</td>
								<td><a><i class="fa fa-plug" title="#get_company_.nick_name#" style="color:##44b6ae!important"></i></a></td>
								<!-- sil --><td><a href="#request.self#?fuseaction=finance.list_securefund&event=upd&securefund_id=#securefund_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td><!-- sil -->
							</tr>
						</cfoutput>
					</tbody>
					<tfoot>
						<cfoutput>
							<tr>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td class="txtbold moneybox"><cf_get_lang dictionary_id='57492.Toplam'></td>
								<td class="txtbold moneybox">			
									<cfloop from="1" to="#listlen(money_list)#" index="i">
										#TLFormat(listgetat(tutar_list,i,',') )#<br/>
									</cfloop>
								</td>
								<td class="txtbold">
									<cfloop from="1" to="#listlen(money_list)#" index="i">
										#listgetat(money_list,i,',')#<br/>
									</cfloop>			
								</td>
								<td class="txtbold moneybox">#TLFormat(debt_total_)#</td>
								<td class="txtbold">#session.ep.money#</td>
								<cfif is_masraf eq 1>
									<td class="txtbold moneybox">			
										<cfloop from="1" to="#listlen(masraf_money_list)#" index="i">
											#TLFormat(listgetat(masraf_tutar_list,i,',') )#<br/>
										</cfloop>
									</td>
									<td class="txtbold">
										<cfloop from="1" to="#listlen(masraf_money_list)#" index="i">
											#listgetat(masraf_money_list,i,',')#<br/>
										</cfloop>			
									</td>
								</cfif>
								<cfif is_komisyon eq 1>
									<td></td>
								</cfif>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
							</tr>
						</cfoutput>
					</tfoot> 
				<cfelse>
					<tbody>
						<tr>
							<td colspan="23"><cfif isdefined('attributes.is_submitted') and len(attributes.is_submitted)><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
						</tr>
					</tbody>    
				</cfif>
			</tbody>
		</cf_grid_list>

		<cfset url_str = "#fusebox.circuit#.list_securefund">
		<cfparam name="attributes.keyword" default="">
		<cfif len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif isdefined("attributes.give_take") and len(attributes.give_take)>
			<cfset url_str = "#url_str#&give_take=#attributes.give_take#">
		</cfif>
		<cfif isDefined('attributes.comp_id') and len(attributes.comp_id)>
			<cfset url_str = '#url_str#&comp_id=#attributes.comp_id#'>
		</cfif>
		<cfif isDefined('attributes.branch_id') and len(attributes.branch_id)>
			<cfset url_str = '#url_str#&branch_id=#attributes.branch_id#'>
		</cfif>		
		<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
			<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
		</cfif>
		<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
			<cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
		</cfif>
		<cfif isdefined("attributes.record_date") and len(attributes.record_date)>
			<cfset url_str = "#url_str#&record_date=#dateformat(attributes.record_date,dateformat_style)#">
		</cfif>
		<cfif isdefined("attributes.is_submitted") and len(attributes.is_submitted)>
			<cfset url_str = "#url_str#&is_submitted=#attributes.is_submitted#">
		</cfif>
		<cfif isdefined("attributes.member_type") and len(attributes.member_type)>
			<cfset url_str = "#url_str#&member_type=#attributes.member_type#">
		</cfif>
		<cfif isdefined("attributes.member_id") and len(attributes.member_id)>
			<cfset url_str = "#url_str#&member_id=#attributes.member_id#">
		</cfif>
		<cfif isdefined("attributes.member") and len(attributes.member)>
			<cfset url_str = "#url_str#&member=#attributes.member#">
		</cfif>
		<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
			<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
		</cfif>
		<cfif isdefined("attributes.project_id") and len(attributes.project_id)>
			<cfset url_str = "#url_str#&project_id=#attributes.project_id#">
		</cfif>
		<cfif isdefined("attributes.project_head") and len(attributes.project_head)>
			<cfset url_str = "#url_str#&project_head=#attributes.project_head#">
		</cfif>
		<cfif isdefined("attributes.securefund_cat") and len(attributes.securefund_cat)>
			<cfset url_str = "#url_str#&securefund_cat=#attributes.securefund_cat#">
		</cfif>
		<cfif isdefined("attributes.action_cat_id") and len(attributes.action_cat_id)>
			<cfset url_str = "#url_str#&action_cat_id=#attributes.action_cat_id#">
		</cfif>
		<cfif isdefined("attributes.special_code") and len(attributes.special_code)>
			<cfset url_str = "#url_str#&special_code=#attributes.special_code#">
		</cfif>
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="#url_str#"> 
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	<cfif not len(attributes.comp_id)>
	showDepartment(<cfoutput>#session.ep.company_id#</cfoutput>);
	<cfelse>
	showDepartment(<cfoutput>#attributes.comp_id#</cfoutput>);
	</cfif>
	function showDepartment(no)	
	{
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=finance.popup_ajax_list_departments&our_company_id="+no+"<cfif len(attributes.comp_branch_id)>&submitted_branch=<cfoutput>#attributes.comp_branch_id#</cfoutput></cfif>";

		AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Şubeler');
	}
	
</script>
