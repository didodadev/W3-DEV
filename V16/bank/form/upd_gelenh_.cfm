<cf_get_lang_set module_name="bank"><!--- sayfanin en altinda kapanisi var --->
<cfset attributes.TABLE_NAME = "BANK_ACTIONS">
<cfif isdefined("attributes.period_id") and len(attributes.period_id) >
	<cfquery name="get_period" datasource="#DSN#">
		SELECT PERIOD_YEAR,OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID = #attributes.period_id#
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
        	ACS.ACTION_TYPE = 240
        <cfelse>
       		ACS.ACTION_TYPE = 24
        </cfif>
		AND ACS.ACTION_ID = <cfif len(get_action_detail.multi_action_id)>#get_action_detail.multi_action_id#<cfelse>#attributes.id#</cfif>
</cfquery>
<cfsavecontent variable="right">
	<cfif GET_CARD.recordcount  and isdefined("session.ep.user_level") and listgetat(session.ep.user_level,22)>
		<li><a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=account.popup_list_card_rows&action_id=<cfif len(get_action_detail.multi_action_id)>#get_action_detail.multi_action_id#<cfelse>#attributes.id#</cfif>&process_cat=<cfif len(get_action_detail.multi_action_id)>240<cfelse>24</cfif></cfoutput>');"><i class="icon-fa fa-table" title="<cf_get_lang dictionary_id='59032.Muhasebe Hareketleri'>"></i></a></li>
	</cfif>
</cfsavecontent>
<div class="col col-12 col-xs-12">
	<cf_box title="#getLang('','Gelen Havale',57834)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#" right_images="#right#"><!--- Gelen Havale --->
		<cf_box_elements>
			<cfoutput>
				<div class="col col-6 col-md-6 col-xs-12">
					<div class="form-group">
						<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id='57742.Tarih'></b></label>
						<label class="col col-8 col-xs-12">: #dateformat(get_action_detail.ACTION_DATE,dateformat_style)#</label>
					</div>
					<div class="form-group">
						<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id='57519.Cari Hesap'></b></label>
						<label class="col col-8 col-xs-12">: 
							<cfif len(get_action_detail.ACTION_FROM_COMPANY_ID)>
								#get_par_info(get_action_detail.ACTION_FROM_COMPANY_ID,1,1,0)# <cf_get_lang dictionary_id='35575.cari hesabından'>
							<cfelseif LEN(get_action_detail.ACTION_FROM_EMPLOYEE_ID)>
								#get_emp_info(get_action_detail.ACTION_FROM_EMPLOYEE_ID,0,0)# <cf_get_lang dictionary_id="35541.hesabından"> 
							<cfelse>
								#get_cons_info(get_action_detail.ACTION_FROM_CONSUMER_ID,0,0)# <cf_get_lang dictionary_id="35541.hesabından">
							</cfif>
						</label>
					</div>
					<div class="form-group">
						<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id='57652.Hesap'></b></label>
						<label class="col col-8 col-xs-12">: 
						<cfset account_id=get_action_detail.ACTION_TO_ACCOUNT_ID>
						<cfinclude template="../query/get_action_account.cfm">
						#get_action_account.ACCOUNT_NAME#<cf_get_lang dictionary_id='35574.hesabına'></label>
					</div>
					<div class="form-group">
						<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id='57673.Tutar'></b></label>
							<cfif len(get_action_detail.masraf)><cfset masraf = get_action_detail.masraf><cfelse><cfset masraf = 0></cfif>
						<label class="col col-8 col-xs-12">: #TLFormat(get_action_detail.ACTION_VALUE+masraf)# #get_action_account.ACCOUNT_CURRENCY_ID#</label>
					</div>
				</div>
				<div class="col col-6 col-md-6 col-xs-12">
					<div class="form-group">
						<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id='58056.Dövizli Tutar'></b></label>
						<label class="col col-8 col-xs-12">: #TLFormat(get_action_detail.OTHER_CASH_ACT_VALUE)# #get_action_detail.OTHER_MONEY#</label>
					</div>
					<div class="form-group">
						<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id="30060.Masraf Tutarı"></b></label>
						<label class="col col-8 col-xs-12">: #TLFormat(get_action_detail.masraf)# #get_action_account.ACCOUNT_CURRENCY_ID#</label>
					</div>
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
