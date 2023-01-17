<cfparam name="attributes.modal_id" default="">
<cfquery name="get_odenek" datasource="#DSN#">
	SELECT 
		ODKES_ID,
        STATUS,
        COMMENT_PAY,
        AMOUNT_PAY,
        START_SAL_MON,
        END_SAL_MON
	FROM 
		SETUP_PAYMENT_INTERRUPTION
	WHERE 
		IS_BES = 1 AND
		STATUS = 1
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		AND COMMENT_PAY LIKE '%#attributes.keyword#%'
	</cfif>
	ORDER BY
		COMMENT_PAY,
		START_SAL_MON DESC,
		END_SAL_MON ASC
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_odenek.recordcount#>
<cfparam name="attributes.row_id_" default="">
<cfparam name="attributes.add_single" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_str = "">
<cfparam name="attributes.keyword" default="">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="46442.Otomatik BES Uygulaması"></cfsavecontent>
<cf_box title="#message#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cfform action="#request.self#?fuseaction=ehesap.popup_list_bes" method="post" name="list_base">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="50" placeHolder="#getLang('','Filtre','57460')#">
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_form' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
		</cfform>
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='57630.Tip'></th>
					<th><cf_get_lang dictionary_id='53132.Başlangıç Ay'></th>
					<th><cf_get_lang dictionary_id='53133.Bitiş Ay'></th>
					<th><cf_get_lang dictionary_id="45126.BES Oranı"></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_odenek.recordcount>
					<cfoutput query="get_odenek" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>
								<cfif attributes.add_single eq 1>
									<a href="javascript://"  onclick="send_info('#comment_pay#','#START_SAL_MON#','#END_SAL_MON#','#TLFormat(amount_pay,2)#','#odkes_id#') ">#comment_pay#</a>
								<cfelse>
									<cfif find('"',comment_pay)>
										<cfset comment_pay_ = replace(comment_pay,'"','\"','all')>
										<a href="##" onClick='<cfif not isdefined("attributes.draggable")>opener.</cfif>add_row("#comment_pay_#","#session.ep.period_year#","#start_sal_mon#","#end_sal_mon#","#TLFormat(amount_pay,2)#","#attributes.row_id_#","#ODKES_ID#","#attributes.modal_id#");' class="tableyazi">#comment_pay#</a>
									<cfelse>
										<cfif find("'",comment_pay)>
											<cfset comment_pay_ = replace(comment_pay,"'","\'",'all')>
										<cfelse>
											<cfset comment_pay_ = comment_pay>
										</cfif>
										<a href="##" onClick='<cfif not isdefined("attributes.draggable")>opener.</cfif>add_row("#comment_pay_#","#session.ep.period_year#","#start_sal_mon#","#end_sal_mon#","#TLFormat(amount_pay,2)#","#attributes.row_id_#","#ODKES_ID#","#attributes.modal_id#");' class="tableyazi">#comment_pay#</a>
									</cfif>
								</cfif>
							</td>
							<td>#listgetat(ay_list(),START_SAL_MON,",")#</td>
							<td>#listgetat(ay_list(),END_SAL_MON,",")#</td>
							<td style="text-align:right;">#TLFormat(amount_pay)#</td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
	</div>
</cf_box>
<cfif attributes.add_single eq 1>
	<cfif isdefined("attributes.comment_pay")>
		<cfset url_str = "#url_str#&comment_pay=#get_odenek.comment_pay#">
	</cfif>
	<cfif isdefined("attributes.START_SAL_MON")>
		<cfset url_str = "#url_str#&start_sal_mon=#get_odenek.START_SAL_MON#">
	</cfif>
	<cfif isdefined("attributes.END_SAL_MON")>
		<cfset url_str = "#url_str#&end_sal_mon=#get_odenek.END_SAL_MON#">
	</cfif>
	<cfif isdefined("attributes.amount_pay")>
		<cfset url_str = "#url_str#&amount_pay=#get_odenek.amount_pay#">
	</cfif>
	<cfif isdefined("attributes.odkes_id")>
		<cfset url_str = "#url_str#&odkes_id=#get_odenek.odkes_id#">
	</cfif>
</cfif>
<cf_paging page="#attributes.page#"
	maxrows="#attributes.maxrows#"
	totalrecords="#attributes.totalrecords#"
	startrow="#attributes.startrow#"
	adres="ehesap.popup_list_bes#url_str#">
<script type="text/javascript">
	$(document).ready(function(){
    $( "#keyword" ).focus();
});

	function send_info(comment_pay,START_SAL_MON,END_SAL_MON,amount_pay,odkes_id)
{
	<cfif isdefined("attributes.comment_pay")>
		opener.<cfoutput>#attributes.comment_pay#</cfoutput>.value = comment_pay;
	
	</cfif>
	<cfif isdefined("attributes.START_SAL_MON")>
		opener.<cfoutput>#attributes.START_SAL_MON#</cfoutput>.value =START_SAL_MON;
	</cfif>
	<cfif isdefined("attributes.END_SAL_MON")>
		opener.<cfoutput>#attributes.END_SAL_MON#</cfoutput>.value =END_SAL_MON;
	</cfif>
	<cfif isdefined("attributes.amount_pay")>
		opener.<cfoutput>#attributes.amount_pay#</cfoutput>.value =amount_pay;
	</cfif>
	<cfif isdefined("attributes.odkes_id")>
		opener.<cfoutput>#attributes.odkes_id#</cfoutput>.value =odkes_id;
	</cfif>
	window.close();
}
</script>