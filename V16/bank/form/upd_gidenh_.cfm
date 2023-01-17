<!---select ifadeleri düzenlendi e.a 23.07.2012--->
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
<cfif not get_action_detail.recordcount>
    <cfset hata  = 11>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57997.Şube Yetkiniz Uygun Değil'> <cf_get_lang dictionary_id='57998.Veya'> <cf_get_lang dictionary_id='58943.Böyle Bir Kayıt Bulunmamaktadır'> !</cfsavecontent>
    <cfset hata_mesaj  = message>
    <cfinclude template="../../dsp_hata.cfm">
<cfelse>
<cfset account_id=get_action_detail.ACTION_FROM_ACCOUNT_ID>
<cfinclude template="../query/get_action_account.cfm">
<cfquery name="GET_CARD" datasource="#dsn2#">
	SELECT
		ACS.CARD_ID
	FROM
		ACCOUNT_CARD ACS
	WHERE
    	<cfif len(get_action_detail.multi_action_id)>
        	ACS.ACTION_TYPE = 253
        <cfelse>
       		ACS.ACTION_TYPE = 25
        </cfif>
		AND ACS.ACTION_ID = <cfif len(get_action_detail.multi_action_id)>#get_action_detail.multi_action_id#<cfelse>#attributes.id#</cfif>
</cfquery>
<cfsavecontent variable="right">
	<cfif GET_CARD.recordcount  and isdefined("session.ep.user_level") and listgetat(session.ep.user_level,22)>
		<li><a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=account.popup_list_card_rows&action_id=<cfif len(get_action_detail.multi_action_id)>#get_action_detail.multi_action_id#<cfelse>#attributes.id#</cfif>&process_cat=<cfif len(get_action_detail.multi_action_id)>253<cfelse>25</cfif></cfoutput>');"><i class="icon-fa fa-table" title="<cf_get_lang dictionary_id='59032.Muhasebe Hareketleri'>"></i></a></li>
	</cfif>
</cfsavecontent>
<cf_box title="#getLang('main',423)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#" right_images="#right#"><!--- Gelen Havale --->
	<cf_box_elements>
		<cfoutput>
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group">
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
						<label><b><cf_get_lang dictionary_id='57742.Tarih'></b></label>
					</div>
					<div class="col col-9 col-md-6 col-sm-6 col-xs-12">
						<label>: #dateformat(get_action_detail.ACTION_DATE,dateformat_style)#</label>
					</div>
				</div>
				<!--- hangi hesaptan --->
				<div class="form-group">
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
						<label><b><cf_get_lang dictionary_id='57652.Hesap'></b></label>
					</div>
					<div class="col col-9 col-md-6 col-sm-6 col-xs-12">
						<label>: #get_action_account.ACCOUNT_NAME# <cf_get_lang dictionary_id='35541.hesabından'> </label>
					</div>
				</div>
				<!--- hangi cari hesaba --->
			
				<cfif len(get_action_detail.ACTION_TO_COMPANY_ID)>
					<div class="form-group">
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
							<label><b><cf_get_lang dictionary_id="58607.Firma"></b></label>
						</div>
						<div class="col col-9 col-md-6 col-sm-6 col-xs-12">
							<label>: #get_par_info(get_action_detail.ACTION_TO_COMPANY_ID,1,1,0)# <cf_get_lang dictionary_id='48756.cari hesabına'> </label>
						</div>
					</div>
				</cfif>		
				<cfif len(get_action_detail.ACTION_TO_CONSUMER_ID)>
					<div class="form-group">
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
							<label><b><cf_get_lang dictionary_id="57658.Üye"></b></label>
						</div>
						<div class="col col-9 col-md-6 col-sm-6 col-xs-12">
							<label>: #get_cons_info(get_action_detail.ACTION_TO_CONSUMER_ID,0,0)# <cf_get_lang dictionary_id="35541.Hesabından"></label>
						</div>
					</div>
				</cfif>
			
				<cfif len(get_action_detail.ACTION_TO_EMPLOYEE_ID)>
					<div class="form-group">
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
							<label><b><cf_get_lang dictionary_id='57576.Çalışan'></b></label>
						</div>
						<div class="col col-9 col-md-6 col-sm-6 col-xs-12">
							<label>: #get_emp_info(get_action_detail.ACTION_TO_EMPLOYEE_ID,0,0)# <cf_get_lang dictionary_id="35574.Hesabına"> </label>
						</div>
					</div>
				</cfif>
			
				<div class="form-group">
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
						<label><b><cf_get_lang dictionary_id='57673.Tutar'></b></label>
					</div>
					<div class="col col-9 col-md-6 col-sm-6 col-xs-12">
						<label>: #TLFormat(get_action_detail.ACTION_VALUE-get_action_detail.masraf)# #get_action_account.ACCOUNT_CURRENCY_ID#</label>
					</div>
				</div>
			
				<div class="form-group">
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
						<label><b><cf_get_lang dictionary_id='58056.Dövizli Tutar'></b></label>
					</div>
					<div class="col col-9 col-md-6 col-sm-6 col-xs-12">
						<label>: #TLFormat(get_action_detail.OTHER_CASH_ACT_VALUE)# #get_action_detail.OTHER_MONEY#</label>
					</div>
				</div>
			
				<div class="form-group">
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
						<label><b><cf_get_lang dictionary_id="30060.Masraf Tutarı"></b></label>
					</div>
					<div class="col col-9 col-md-6 col-sm-6 col-xs-12">
						<label>: #TLFormat(get_action_detail.masraf)# #get_action_account.ACCOUNT_CURRENCY_ID#</label>
					</div>
				</div>
			
				<div class="form-group">
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
					<label><b><cf_get_lang dictionary_id='57629.Açıklama'></b></label>
					</div>
					<div class="col col-9 col-md-6 col-sm-6 col-xs-12">
						<label>: #get_action_detail.ACTION_DETAIL# </label>
					</div>
				</div>
			</div>
		</cfoutput> 
	</cf_box_elements>
	<cf_box_footer>
		<div class="col col-6">
		<cfif len(get_action_detail.RECORD_EMP)>
			<cf_record_info query_name="get_action_detail">
		</cfif>
		</div>
		<div class="col col-6">
		</div>
	</cf_box_footer>
</cf_box>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
</cfif>
