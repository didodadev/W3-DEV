<cf_get_lang_set module_name="ehesap"><!--- sayfanin en altinda kapanisi var --->
<cfquery name="get_kesinti" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_PAYMENT_INTERRUPTION
	WHERE 
		SETUP_PAYMENT_INTERRUPTION.IS_ODENEK = 0 AND
		SETUP_PAYMENT_INTERRUPTION.STATUS = 1
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)> 
			AND COMMENT_PAY LIKE '%#attributes.keyword#%'
		</cfif>
		AND SETUP_PAYMENT_INTERRUPTION.IS_INST_AVANS = 1
	ORDER BY
		SETUP_PAYMENT_INTERRUPTION.START_SAL_MON DESC,
		SETUP_PAYMENT_INTERRUPTION.END_SAL_MON ASC
</cfquery>
<script type="text/javascript">
	function gonder(avans_type,amount,COMMENT_PAY,odkes_id)
	{
	    <cfif isDefined("attributes.avans_type")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.avans_type#</cfoutput>.value=avans_type;
		</cfif>
		<cfif isDefined("attributes.amount")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.amount#</cfoutput>.value=amount_pay;
		</cfif>
		
		
		<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
</script>
<cfset url_str = "">
<cfif isdefined("attributes.avans_type")>
	<cfset url_str = "#url_str#&avans_type=#attributes.avans_type#">
</cfif>
<cfif isdefined("attributes.amount")>
	<cfset url_str = "#url_str#&amount=#attributes.amount#">
</cfif>

<cfparam name="attributes.keyword" default="">
<cfsavecontent variable="ay1"><cf_get_lang dictionary_id='57592.Ocak'></cfsavecontent>
<cfsavecontent variable="ay2"><cf_get_lang dictionary_id='57593.Şubat'></cfsavecontent>
<cfsavecontent variable="ay3"><cf_get_lang dictionary_id='57594.Mart'></cfsavecontent>
<cfsavecontent variable="ay4"><cf_get_lang dictionary_id='57595.Nisan'></cfsavecontent>
<cfsavecontent variable="ay5"><cf_get_lang dictionary_id='57596.Mayıs'></cfsavecontent>
<cfsavecontent variable="ay6"><cf_get_lang dictionary_id='57597.Haziran'></cfsavecontent>
<cfsavecontent variable="ay7"><cf_get_lang dictionary_id='57598.Temmuz'></cfsavecontent>
<cfsavecontent variable="ay8"><cf_get_lang dictionary_id='57599.Ağustos'></cfsavecontent>
<cfsavecontent variable="ay9"><cf_get_lang dictionary_id='57600.Eylül'></cfsavecontent>
<cfsavecontent variable="ay10"><cf_get_lang dictionary_id='57601.Ekim'></cfsavecontent>
<cfsavecontent variable="ay11"><cf_get_lang dictionary_id='57602.Kasım'></cfsavecontent>
<cfsavecontent variable="ay12"><cf_get_lang dictionary_id='57603.Aralık'></cfsavecontent>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_kesinti.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfsavecontent variable="message"><cf_get_lang dictionary_id="53083.Kesinti"></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#message#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	
		<cfform action="#request.self#?fuseaction=#fusebox.circuit#.popup_list_kesinti_taksitli" method="post" name="filter_list_tax_exception">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" name="keyword" id="keyword" autocomplete="off" value="#attributes.keyword#" maxlength="255" style="width:50px;" placeholder="#getLang(48,'Keyword',47046)#">
				</div>
				
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4"  search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('filter_list_tax_exception' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
		</cfform>


		<cf_flat_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='57630.Tip'></th>
					<th><cf_get_lang dictionary_id='53132.Başlangıç Ay'></th>
					<th><cf_get_lang dictionary_id='53133.Bitiş Ay'></th>
					<th><cf_get_lang dictionary_id='29472.Yöntem'></th>
					<th style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></th>
					<th></th>
				</tr>
			</thead>
			<tbody>
				<cfoutput QUERY="get_kesinti" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
					
						<td><a href="##" onClick="<cfif isdefined("attributes.draggable")><cfelse>opener.</cfif>add_row('#from_salary#','#show#','#comment_pay#','#period_pay#','#method_pay#','#year(now())#','#start_sal_mon#','#end_sal_mon#','#TLFormat(amount_pay)#', '#calc_days#','#odkes_id#','#money#');	<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>" class="tableyazi">#comment_pay#</a></td>
						<td>#LISTgetat(ay_list(),start_SAL_MON,",")#</td>
						<td>#LISTgetat(ay_list(),start_SAL_MON,",")#</td>
						<td>#LISTgetat(ay_list(),END_SAL_MON,",")#</td>
						<td><cfif get_kesinti.METHOD_PAY EQ 1><cf_get_lang dictionary_id='53134.Eksi'><cfelseif get_kesinti.METHOD_PAY EQ 2><cf_get_lang dictionary_id='53135.Yüzde'></cfif></td>
						<td style="text-align:right;">#TLFormat(amount_pay)#</td>
						<td>#money#</td>
						</tr>
				</cfoutput>
				<cfif not get_kesinti.recordcount>
					<tr>
						<td colspan="6">
							<cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!
						</td>
					</tr>
				</cfif>
			</tbody>
		<cf_flat_list>
		<cfif isdefined("attributes.keyword")>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cf_paging page="#attributes.page#" 
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="#fusebox.circuit#.popup_list_kesinti_taksitli#url_str#"
					isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
			
		</cfif>
	</cf_box>
</div>

<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
