<cfquery name="get_kesinti" datasource="#dsn#">
	SELECT
		ISNULL((SELECT C.FULLNAME FROM COMPANY C WHERE C.COMPANY_ID = SETUP_PAYMENT_INTERRUPTION.COMPANY_ID),(SELECT C.CONSUMER_NAME+ ' '+C.CONSUMER_SURNAME FROM CONSUMER C WHERE C.CONSUMER_ID = SETUP_PAYMENT_INTERRUPTION.CONSUMER_ID)) FULLNAME,
		* 
	FROM 
		SETUP_PAYMENT_INTERRUPTION
	WHERE 
		SETUP_PAYMENT_INTERRUPTION.IS_ODENEK = 0 AND
		SETUP_PAYMENT_INTERRUPTION.STATUS = 1 AND
        ISNULL(IS_BES,0) = 0
	<cfif not session.ep.ehesap>
		AND (SETUP_PAYMENT_INTERRUPTION.IS_EHESAP IS NULL OR SETUP_PAYMENT_INTERRUPTION.IS_EHESAP = 0)
	</cfif>
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)> 
		AND COMMENT_PAY LIKE '%#attributes.keyword#%'
	</cfif>
		AND SETUP_PAYMENT_INTERRUPTION.IS_INST_AVANS = 0
	<cfif isdefined("attributes.is_disciplinary_punishment") and len(attributes.is_disciplinary_punishment)>
		AND IS_DISCIPLINARY_PUNISHMENT = 1
	</cfif>
	ORDER BY
		SETUP_PAYMENT_INTERRUPTION.START_SAL_MON DESC,
		SETUP_PAYMENT_INTERRUPTION.END_SAL_MON ASC
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_kesinti.recordcount#">
<cfparam name="attributes.row_id_" default="">
<cfparam name="attributes.type" default="1">
<cfparam name="attributes.field_name" default="">
<cfparam name="attributes.field_id" default="">

<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_str = "">
<cfparam name="attributes.keyword" default="">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.from_xml")>
	<cfset url_str = "#url_str#&from_xml=#attributes.from_xml#">
</cfif>
<cfif isdefined("attributes.field_id")>
	<cfset url_str = "#url_str#&field_id=#attributes.field_id#">
</cfif>

<cf_box title="#getLang('','Kesinti','53083')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform action="#request.self#?fuseaction=ehesap.popup_list_kesinti#url_str#" method="post" name="filter_list_tax_exception">
		<cf_box_search>
			<cfinput type="hidden" name="row_id_" value="#attributes.row_id_#">
			<div class="form-group">
				<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang('','Filtre','57460')#">
			</div>
			<div class="form-group small">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('filter_list_tax_exception' , #attributes.modal_id#)"),DE(""))#">
			</div>
		</cf_box_search>	
	</cfform>
	<cf_grid_list>
		<thead>		
			<tr>
				<th><cf_get_lang dictionary_id='57630.Tip'></th>
				<th><cf_get_lang dictionary_id='53132.Başlangıç Ay'></th>
				<th><cf_get_lang dictionary_id='53133.Bitiş Ay'></th>
				<th><cf_get_lang dictionary_id='29472.Yöntem'></th>
				<th class="text-right"><cf_get_lang dictionary_id='57635.Miktar'></th>
				<th width="20">&nbsp;</th>
			</tr>
		</thead>
		<tbody>
			<cfoutput query="get_kesinti" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<cfif attributes.type eq 2>
						<td><a href="javascript://" onClick="<cfif isdefined("attributes.draggable")><cfelse>opener.</cfif>add_row_interruption('#from_salary#','#show#','#comment_pay#','#period_pay#','#method_pay#','#session.ep.period_year#','#start_sal_mon#','#end_sal_mon#','#TLFormat(amount_pay)#', '#calc_days#','<cfif is_ehesap eq 1>1<cfelse>0</cfif>','#attributes.row_id_#','#account_code#','#company_id#','#fullname#','#account_name#','#consumer_id#','#money#','#acc_type_id#','#tax#','#odkes_id#','#field_name#','#field_id#');<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable('#attributes.modal_id#');</cfif>">#comment_pay#</a></td>
					<cfelse>
						<td><a href="javascript://" onClick="<cfif isdefined("attributes.draggable") or isdefined("attributes.from_xml")><cfelse>opener.</cfif>add_row('#from_salary#','#show#','#comment_pay#','#period_pay#','#method_pay#','#session.ep.period_year#','#start_sal_mon#','#end_sal_mon#','#TLFormat(amount_pay)#', '#calc_days#','<cfif is_ehesap eq 1>1<cfelse>0</cfif>','#attributes.row_id_#','#account_code#','#company_id#','#fullname#','#account_name#','#consumer_id#','#money#','#acc_type_id#','#tax#','#odkes_id#','#is_net_to_gross#');<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable('#attributes.modal_id#');</cfif>">#comment_pay#</a></td>
					</cfif>
					<td>#LISTgetat(ay_list(),start_SAL_MON,",")#</td>
					<td>#LISTgetat(ay_list(),END_SAL_MON,",")#</td>
					<td>
					<cfif get_kesinti.METHOD_PAY EQ 1>
						<cf_get_lang dictionary_id='53134.Eksi'>
					<cfelseif get_kesinti.METHOD_PAY EQ 2>
						<cf_get_lang dictionary_id='58724.Ay'> 
					<cfelseif get_kesinti.METHOD_PAY EQ 3>
						<cf_get_lang dictionary_id='57490.Gün'> 
					<cfelseif get_kesinti.METHOD_PAY EQ 4>
						<cf_get_lang dictionary_id='57491.Saat'> 
					<cfelseif get_kesinti.METHOD_PAY EQ 5>
						<cf_get_lang dictionary_id='53971.Kazanç'> 
					</cfif></td>
					<td  class="text-right">#TLFormat(amount_pay)#</td>
					<td>#money#</td>
				</tr>
			</cfoutput>
			<cfif not get_kesinti.recordcount>
				<tr>
					<td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
	<cfif attributes.totalrecords gt attributes.maxrows>
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="ehesap.popup_list_kesinti#url_str#"
			isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
	</cfif>
</cf_box>


<script>
	<cfif isdefined("attributes.from_xml")>
		function add_row(from_salary, show, comment_pay, period_pay, method_pay, term, start_sal_mon, end_sal_mon, amount_pay, calc_days,is_ehesap,total_get,account_code,company_id,company_name,account_name,consumer_id,money,acc_type_id,satir_tax,odkes_id)
		{
			opener.document.<cfoutput>#attributes.field_id#</cfoutput>.value = odkes_id;	
		}
	</cfif>
</script>