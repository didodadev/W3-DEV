<cfquery name="get_pos_operation" datasource="#dsn3#">
	SELECT
		(SELECT CARD_NO FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID = POS_ID) CARD_NO,
		VOLUME,
		IS_FLAG,
		PERIOD_ID
	FROM 
		POS_OPERATION PO WITH (NOLOCK)
	WHERE
		POS_OPERATION_ID = #attributes.pos_operation_id#
</cfquery>
<cfquery name="getSetupPeriod" datasource="#dsn3#">
	SELECT PERIOD_YEAR FROM #dsn_alias#.SETUP_PERIOD WITH (NOLOCK) WHERE PERIOD_ID = #get_pos_operation.period_id#
</cfquery>
<cfset dsn2_alias_ = '#dsn#_#getSetupPeriod.period_year#_#session.ep.company_id#'>
<cfquery name="get_all_total" datasource="#dsn3#">
	SELECT
		ISNULL(SUM(I.NETTOTAL),0) NETTOTAL
	FROM 
		POS_OPERATION_ROW PO WITH (NOLOCK),
		SUBSCRIPTION_PAYMENT_PLAN_ROW SPR WITH (NOLOCK),
		#dsn2_alias_#.INVOICE I WITH (NOLOCK)
	WHERE 
		POS_OPERATION_ID = #attributes.pos_operation_id#
		AND PO.SUBSCRIPTION_PAYMENT_ROW_ID = SPR.SUBSCRIPTION_PAYMENT_ROW_ID
		AND SPR.INVOICE_ID = I.INVOICE_ID
</cfquery>
<cfset all_total_ = get_all_total.nettotal>
<cfquery name="get_max_id_operation" datasource="#dsn3#">
	SELECT MAX(POS_OPERATION_ACTION_ID) MAX_ID FROM POS_OPERATION_ACTIONS WITH (NOLOCK) WHERE POS_OPERATION_ID = #attributes.pos_operation_id#
</cfquery>
<cfset operation_act_id = get_max_id_operation.max_id>
<cfquery name="get_pos_operation_row_" datasource="#dsn3#">
	SELECT COUNT(*) COUNT_ FROM POS_OPERATION_ROW WITH (NOLOCK) WHERE POS_OPERATION_ID = #attributes.pos_operation_id#
</cfquery>
<cfquery name="get_pos_operation_row" datasource="#dsn3#">
	SELECT COUNT(*) COUNT_ FROM POS_OPERATION_ROW_HISTORY WITH (NOLOCK) WHERE POS_OPERATION_ACTION_ID = <cfif isdefined('operation_act_id') and len(operation_act_id)>#operation_act_id#<cfelse>0</cfif> AND RESPONCE_CODE<>'-2'
</cfquery>
<cfset all_count_ = get_pos_operation_row.count_+get_pos_operation_row_.count_>
<cfquery name="get_pos_operation_row_" datasource="#dsn3#">
	SELECT COUNT(*) COUNT_ FROM POS_OPERATION_ROW_HISTORY WITH (NOLOCK) WHERE POS_OPERATION_ACTION_ID = <cfif isdefined('operation_act_id') and len(operation_act_id)>#operation_act_id#<cfelse>0</cfif> AND RESPONCE_CODE= '-2'
</cfquery>
<cfquery name="get_all_total_" datasource="#dsn3#">
	SELECT
		ISNULL(SUM(I.NETTOTAL),0) NETTOTAL
	FROM 
		POS_OPERATION_ROW_HISTORY PO WITH (NOLOCK),
		SUBSCRIPTION_PAYMENT_PLAN_ROW SPR WITH (NOLOCK),
		#dsn2_alias_#.INVOICE I WITH (NOLOCK)
	WHERE 
		POS_OPERATION_ACTION_ID = <cfif isdefined('operation_act_id') and len(operation_act_id)>#operation_act_id#<cfelse>0</cfif>
		AND PO.SUBSCRIPTION_PAYMENT_ROW_ID = SPR.SUBSCRIPTION_PAYMENT_ROW_ID
		AND SPR.INVOICE_ID = I.INVOICE_ID
</cfquery>
<cfset all_total_ = all_total_ + get_all_total_.nettotal>
<cfif len(operation_act_id)>
	<cfquery name="get_pos_operation_history_paid" datasource="#dsn3#">
		SELECT COUNT(*) COUNT_,ISNULL(SUM(INVOICE_NET_TOTAL),0) AMOUNT FROM POS_OPERATION_ROW_HISTORY WITH (NOLOCK) WHERE POS_OPERATION_ACTION_ID = #operation_act_id# AND IS_PAID = 1 AND POS_OPERATION_ID = #attributes.pos_operation_id#
	</cfquery>
    <cfquery name="get_pos_operation_history_not_payment" datasource="#dsn3#">
		SELECT COUNT(*) COUNT_,ISNULL(SUM(INVOICE_NET_TOTAL),0) AMOUNT FROM POS_OPERATION_ROW_HISTORY WITH (NOLOCK) WHERE POS_OPERATION_ACTION_ID = #operation_act_id# AND RESPONCE_CODE = '00' AND IS_PAYMENT = 0
	</cfquery>
	<cfquery name="get_pos_operation_history" datasource="#dsn3#">
		SELECT COUNT(*) COUNT_,ISNULL(SUM(INVOICE_NET_TOTAL),0) AMOUNT FROM POS_OPERATION_ROW_HISTORY WITH (NOLOCK) WHERE POS_OPERATION_ACTION_ID = #operation_act_id# AND IS_PAID = 0 AND RESPONCE_CODE NOT IN('-2','-3') AND POS_OPERATION_ID = #attributes.pos_operation_id#
	</cfquery>
<cfelse>
	<cfset get_pos_operation_history_paid.count_ = 0>
	<cfset get_pos_operation_history_paid.amount = 0>
	<cfset get_pos_operation_history_not_payment.count_ = 0>
	<cfset get_pos_operation_history_not_payment.amount = 0>
	<cfset get_pos_operation_history.count_ = 0>
	<cfset get_pos_operation_history.amount = 0>
</cfif>
<cfparam name="attributes.modal_id" default="">
<cf_box title="#get_pos_operation.card_no#"popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfoutput>
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<div class="form-group">
				<label class="col col-8 col-xs-12"><cf_get_lang dictionary_id="51631.Operasyon Satırı"><cf_get_lang dictionary_id="58829.Kayıt Sayısı"></label>
				<label class="col col-4 col-xs-12">#all_count_#</label>
			</div>
			<div class="form-group">
				<label class="col col-8 col-xs-12"><cf_get_lang dictionary_id="51631.Operasyon Satırı"><cf_get_lang dictionary_id="57673.Tutar"></label>
				<label class="col col-4 col-xs-12">#tlformat(all_total_)#</label>
			</div>
			<div class="form-group">
				<label class="col col-8 col-xs-12"><cf_get_lang dictionary_id="55387.Başarılı"><cf_get_lang dictionary_id="58829.Kayıt Sayısı"></label>
				<label class="col col-4 col-xs-12">#get_pos_operation_history_paid.count_#</label>
			</div>
			<div class="form-group">
				<label class="col col-8 col-xs-12"><cf_get_lang dictionary_id="55387.Başarılı"><cf_get_lang dictionary_id="57673.Tutar"></label>
				<label class="col col-4 col-xs-12">#tlformat(get_pos_operation_history_paid.amount)#</label>
			</div>
			<div class="form-group">
				<label class="col col-8 col-xs-12"><cf_get_lang dictionary_id= "58197.Başarısız"><cf_get_lang dictionary_id="58829.Kayıt Sayısı"></label>
				<label class="col col-4 col-xs-12">#get_pos_operation_history.count_#</label>
			</div>
		</div>
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<div class="form-group">
				<label class="col col-8 col-xs-12"><cf_get_lang dictionary_id= "58197.Başarısız"><cf_get_lang dictionary_id="57673.Tutar"></label>
				<label class="col col-4 col-xs-12">#tlformat(get_pos_operation_history.amount)#</label>
			</div>
			<div class="form-group">
				<label class="col col-8 col-xs-12"><cf_get_lang dictionary_id= "51632.Tahsilat Kaydı Olmayan İşlemler"><cf_get_lang dictionary_id="58829.Kayıt Sayısı"></label>
				<label class="col col-4 col-xs-12">#get_pos_operation_history_not_payment.count_#</label>
			</div>
			<div class="form-group">
				<label class="col col-8 col-xs-12"><cf_get_lang dictionary_id= "51632.Tahsilat Kaydı Olmayan İşlemler"><cf_get_lang dictionary_id="57673.Tutar"></label>
				<label class="col col-4 col-xs-12">#tlformat(get_pos_operation_history_not_payment.amount)#</label>
			</div>
			<div class="form-group">
				<label class="col col-8 col-xs-12"><cf_get_lang dictionary_id= "58444.Kalan"><cf_get_lang dictionary_id="58829.Kayıt Sayısı"></label>
				<label class="col col-4 col-xs-12">#all_count_-get_pos_operation_history_paid.count_-get_pos_operation_history.count_#</label>
			</div>
			<div class="form-group">
				<label class="col col-8 col-xs-12"><cf_get_lang dictionary_id= "58444.Kalan"><cf_get_lang dictionary_id="57673.Tutar"></label>
				<label class="col col-4 col-xs-12">#tlformat(wrk_round(all_total_-get_pos_operation_history_paid.amount-get_pos_operation_history.amount))#</label>
			</div>
		</div>
	</cfoutput>
</cf_box>
