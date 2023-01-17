<cfif isdefined("attributes.period_id") and len(attributes.period_id) >
	<cfquery name="get_period" datasource="#DSN#">
		SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = #attributes.period_id#
	</cfquery>
	<cfset db_adres = "#dsn#_#get_period.period_year#_#get_period.our_company_id#">
<cfelse>
	<cfset db_adres = "#dsn2#">
</cfif>
<cfquery name="GET_NOTE" datasource="#db_adres#">
	SELECT * FROM CARI_ACTIONS WHERE ACTION_ID = #attributes.id#
</cfquery>
<cfquery name="GET_CARD" datasource="#dsn2#">
	SELECT
		ACS.CARD_ID
	FROM
		ACCOUNT_CARD ACS
	WHERE
    	<cfif len(GET_NOTE.multi_action_id)>
        	ACS.ACTION_TYPE = 430
            AND ACS.ACTION_ID = #GET_NOTE.multi_action_id#
        <cfelse>
        	ACS.ACTION_TYPE = #GET_NOTE.action_type_id#
            AND ACS.ACTION_ID = #attributes.id#
        </cfif>
</cfquery>
<cfsavecontent variable="right">
	<cfif GET_CARD.recordcount  and isdefined("session.ep.user_level") and listgetat(session.ep.user_level,22)>
		<li><a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=account.popup_list_card_rows&action_id=<cfif len(GET_NOTE.multi_action_id)>#GET_NOTE.multi_action_id#<cfelse>#attributes.id#</cfif>&process_cat=<cfif len(GET_NOTE.multi_action_id)>430<cfelse>43</cfif></cfoutput>');"><i class="icon-fa fa-table" title="<cf_get_lang dictionary_id='59032.Muhasebe Hareketleri'>"></i></a></li>
	</cfif>
</cfsavecontent>

<cf_box title="#getLang('','Cari Virman Detay',34112)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#" right_images="#right#">
	<div class="col col-12 col-xs-12">
		<cfoutput>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
				<div class="form-group">
					<label class="col col-6 col-sm-12"><cf_get_lang dictionary_id ='57879.İşlem Tarihi'>:</label>
					<div class="col col-6 col-sm-12">#dateformat(GET_NOTE.action_date,dateformat_style)#</div>
				</div>
				<div class="form-group">
					<label class="col col-6 col-sm-12"><cf_get_lang dictionary_id='58851.Ödeme Tarihi'>:</label>
					<div class="col col-6 col-sm-12">#dateformat(GET_NOTE.due_date,dateformat_style)#</div>
				</div>
				<div class="form-group">
					<label class="col col-6 col-sm-12"><cf_get_lang dictionary_id ='34114.Borçlu Hesap'>:</label>
					<div class="col col-6 col-sm-12">
						<cfif len(GET_NOTE.to_cmp_id)>
							<cfset member_name=get_par_info(GET_NOTE.to_cmp_id,1,1,0)>
						<cfelseif len(GET_NOTE.to_consumer_id)>
							<cfset member_name=get_cons_info(GET_NOTE.to_consumer_id,0,0)>
						<cfelseif len(GET_NOTE.to_employee_id)>
							<cfset member_name=get_emp_info(GET_NOTE.to_employee_id,0,0)>
						</cfif>
						#member_name#
					</div>
				</div>
				<div class="form-group">
					<label class="col col-6 col-sm-12"><cf_get_lang dictionary_id ='34115.Alacaklı Hesap'>:</label>
					<div class="col col-6 col-sm-12">
						<cfif len(GET_NOTE.from_cmp_id)>
							<cfset member_name_2=get_par_info(GET_NOTE.from_cmp_id,1,1,0)>
						<cfelseif len(GET_NOTE.from_consumer_id)>
							<cfset member_name_2=get_cons_info(GET_NOTE.from_consumer_id,0,0)>
						<cfelseif len(GET_NOTE.from_employee_id)>
							<cfset member_name_2=get_emp_info(GET_NOTE.from_employee_id,0,0)>
						</cfif>#member_name_2#
					</div>
				</div>
			</div>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
				<div class="form-group">
					<label class="col col-6 col-sm-12"><cf_get_lang dictionary_id='57673.Tutar'>:</label>
					<div class="col col-6 col-sm-12">#TLFormat(GET_NOTE.action_value)# #GET_NOTE.action_currency_id#</div>
				</div>
				<div class="form-group">
					<label class="col col-6 col-sm-12"><cf_get_lang dictionary_id ='34116.Diğer Döviz İşlemi'>:</label>
					<div class="col col-6 col-sm-12">#TLFormat(GET_NOTE.other_cash_act_value)# #GET_NOTE.other_money#</div>
				</div>
				<div class="form-group">
					<label class="col col-6 col-sm-12"><cf_get_lang dictionary_id ='57629.Açıklama'>:</label>
					<div class="col col-6 col-sm-12">#GET_NOTE.action_detail#</div>
				</div>
			</div>
		</cfoutput>
	</div>
	<cf_box_footer>
		<cfif len(GET_NOTE.RECORD_EMP)>
			<cf_record_info query_name="GET_NOTE">
		</cfif>
	</cf_box_footer>
</cf_box>
