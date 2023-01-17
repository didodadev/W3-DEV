<cf_get_lang_set module_name="cash"><!--- sayfanin en altinda kapanisi var --->
	<cfset attributes.TABLE_NAME = "CASH_ACTIONS">
	<cfif isdefined("attributes.period_id") and len(attributes.period_id) >
		<cfquery name="get_period" datasource="#DSN#">
			SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = #attributes.period_id#
		</cfquery>
		<cfset db_adres = "#dsn#_#get_period.period_year#_#get_period.our_company_id#">
	<cfelse>
		<cfset db_adres = "#dsn2#">
	</cfif>
	<cfinclude template="../query/get_action_detail.cfm">
	<cfquery name="GET_CARD" datasource="#dsn2#">
		SELECT
			ACS.CARD_ID
		FROM
			ACCOUNT_CARD ACS
		WHERE
			<cfif len(get_action_detail.multi_action_id)>
				ACS.ACTION_TYPE = 310
				AND ACS.ACTION_ID =  #get_action_detail.multi_action_id#
			<cfelse>
				ACS.ACTION_TYPE = 31
				AND ACS.ACTION_ID =  #get_action_detail.ACTION_ID#
			</cfif>
	</cfquery>
	<cfsavecontent variable="right">
		<cfif GET_CARD.recordcount  and isdefined("session.ep.user_level") and listgetat(session.ep.user_level,22)>
			<li><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=account.popup_list_card_rows&action_id=<cfif len(get_action_detail.multi_action_id)>#get_action_detail.multi_action_id#<cfelse>#get_action_detail.ACTION_ID#</cfif>&process_cat=<cfif len(get_action_detail.multi_action_id)>310<cfelse>31</cfif></cfoutput>','page');" title="<cf_get_lang dictionary_id='59032.Muhasebe Hareketleri'>"><i class="icon-fa fa-table"></i></a></li>
		</cfif>
		</cfsavecontent>
	<cfif not get_action_detail.recordcount>
		<cfset hata  = 11>
		<cfsavecontent variable="message"><cf_get_lang dictionary_id='57997.Şube Yetkiniz Uygun Değil'> <cf_get_lang dictionary_id='57998.Veya'> <cf_get_lang dictionary_id='58943.Böyle Bir Kayıt Bulunmamaktadır'> !</cfsavecontent>
		<cfset hata_mesaj  = message>
		<cfinclude template="../../dsp_hata.cfm">
	<cfelse>
<div class="col col-12 col-xs-12">
	<cf_box title='#getLang('cash',64)#' right_images="#right#" scroll="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#"> 
		<cf_box_elements>
			<cfoutput>
				<div class="col col-4 col-md-8 col-xs-12">
					<div class="form-group">
						<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id='35570.Makbuz No'></b></label>
						<label class="col col-8 col-xs-12">: #get_action_detail.paper_no# </label>
					</div>
				</div>
				<div class="col col-4 col-md-8 col-xs-12">
					<div class="form-group">
						<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id='57742.Tarih'></b></label>
						<label  class="col col-8 col-xs-12">: #dateformat(get_action_detail.ACTION_DATE,dateformat_style)#</label>
					</div>
				</div>
				<div class="col col-4 col-md-8 col-xs-12">
					<div class="form-group">
						<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id='33483.Tahsil Eden'></b></label>
						<label  class="col col-8 col-xs-12">: #get_emp_info(get_action_detail.REVENUE_COLLECTOR_ID,0,0)#</label>
					</div>
				</div>
				<div class="col col-4 col-md-8 col-xs-12">
					<cfif len(get_action_detail.CASH_ACTION_FROM_COMPANY_ID)>
						<div class="form-group">
							<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id='57519.Cari Hesap'></b></label>
							<label  class="col col-8 col-xs-12">: #get_par_info(get_action_detail.CASH_ACTION_FROM_COMPANY_ID,1,1,0)#</label>
						</div>
					<cfelseif len(get_action_detail.CASH_ACTION_FROM_CONSUMER_ID)>
						<div class="form-group">
							<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id='57519.Cari Hesap'></b></label>
							<label class="col col-8 col-xs-12">: #get_cons_info(get_action_detail.CASH_ACTION_FROM_CONSUMER_ID,0,0)#</label>
						</div>
					<cfelse>
						<div class="form-group">
							<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id='57576.Çalışan'></b></label>
							<label class="col col-8 col-xs-12">: #get_emp_info(get_action_detail.CASH_ACTION_FROM_EMPLOYEE_ID,0,0)#</label>
						</div>
					</cfif>
				</div>
				<div class="col col-4 col-md-8 col-xs-12">
					<div class="form-group">
						<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id='57520.Kasa'></b></label>
						<label  class="col col-8 col-xs-12">
							<cfset cash_id=get_action_detail.CASH_ACTION_TO_CASH_ID>
							<cfinclude template="../query/get_action_cash.cfm">
							: #get_action_cash.CASH_NAME# 
						</label>
					</div>
				</div>
				<div class="col col-4 col-md-8 col-xs-12">
					<div class="form-group">
						<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id='57673.Tutar'></b></label>
						<label  class="col col-8 col-xs-12">: #TLFormat(get_action_detail.CASH_ACTION_VALUE)# #get_action_detail.CASH_ACTION_CURRENCY_ID# </label>
					</div>
				</div>
				<div class="col col-4 col-md-8 col-xs-12">
					<div class="form-group">
						<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id='58056.Dövizli Tutar'></b></label>
						<label class="col col-8 col-xs-12">: #TLFormat(get_action_detail.OTHER_CASH_ACT_VALUE)#&nbsp;#get_action_detail.OTHER_MONEY# </label>
					</div>
				</div>
				<div class="col col-4 col-md-8 col-xs-12">
				<div class="form-group">
					<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id='57629.Açıklama'></b></label>
					<label class="col col-8 col-xs-12">: #get_action_detail.ACTION_DETAIL#</label>
				</div>
			</div>
			</cfoutput>
		</cf_box_elements>
		<cf_box_footer>
			<cfif len(get_action_detail.RECORD_EMP)>
				<cf_record_info query_name="get_action_detail">
			</cfif>
		</cf_box_footer>	
	</cf_box>
</div>
	<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
	</cfif>
	