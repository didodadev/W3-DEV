<cfquery name="get_odenek" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		SETUP_PAYMENT_INTERRUPTION
	WHERE 
		SETUP_PAYMENT_INTERRUPTION.IS_ODENEK = 1 AND
		SETUP_PAYMENT_INTERRUPTION.STATUS = 1 AND
        ISNULL(IS_BES,0) = 0
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		AND COMMENT_PAY LIKE '%#attributes.keyword#%'
	</cfif>
	<cfif not session.ep.ehesap>
		AND (SETUP_PAYMENT_INTERRUPTION.IS_EHESAP IS NULL OR SETUP_PAYMENT_INTERRUPTION.IS_EHESAP = 0)
	</cfif>
	<cfif isDefined("attributes.use_ssk") and len(attributes.use_ssk)>
		AND SSK_STATUE = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.use_ssk#">
	</cfif>
	ORDER BY
		SETUP_PAYMENT_INTERRUPTION.COMMENT_PAY,
		SETUP_PAYMENT_INTERRUPTION.START_SAL_MON DESC,
		SETUP_PAYMENT_INTERRUPTION.END_SAL_MON ASC
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_odenek.recordcount#>
<cfparam name="attributes.row_id_" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_str = "">
<cfparam name="attributes.keyword" default="">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.MODAL_ID")>
	<cfset url_str = "#url_str#&modal_id=#attributes.MODAL_ID#">
</cfif>
<cfif isdefined("attributes.field_id")>
	<cfset url_str = "#url_str#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.from_xml")>
	<cfset url_str = "#url_str#&from_xml=#attributes.from_xml#">
</cfif>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="53082.Ek Ödenek"></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#message#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform action="#request.self#?fuseaction=ehesap.popup_list_odenek" method="post" name="filter_list_tax_exception">
			<cfinput name="row_id_" type="hidden" value="#attributes.row_id_#">
            <cf_box_search>
				<cfif isdefined("field_salaryparam_pay_id")><input type="hidden" name="field_salaryparam_pay_id" id="field_salaryparam_pay_id" value="<cfoutput>#attributes.field_salaryparam_pay_id#</cfoutput>"></cfif>
				<cfif isdefined("field_salaryparam_pay_name")><input type="hidden" name="field_salaryparam_pay_name" id="field_salaryparam_pay_name" value="<cfoutput>#attributes.field_salaryparam_pay_name#</cfoutput>"></cfif>					
				<div class="form-group" id="item-keyword">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" placeholder="#message#" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group small" id="item-maxrows">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
					<cfif isdefined("attributes.modal_id")>
						<cf_wrk_search_button button_type="4" search_function="loadPopupBox('filter_list_tax_exception', #attributes.modal_id#)">
					<cfelse>
						<cf_wrk_search_button button_type="4">
					</cfif>
				</div>
				<!--- <table>
					<tr>
						<td><cf_get_lang dictionary_id='57460.Filtre'></td>
						<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="50"></td>
						<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
						</td>
						<td><cf_wrk_search_button button_type="4" search_function="loadPopupBox('filter_list_tax_exception', #attributes.modal_id#)"></td>
					</tr>
				</table> --->
			</cf_box_search>
		</cfform>
		<cf_flat_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='57630.Tip'></th>
					<th><cf_get_lang dictionary_id='54032.Net/Brüt'></th>
					<th><cf_get_lang dictionary_id='53132.Başlangıç Ay'></th>
					<th><cf_get_lang dictionary_id='53133.Bitiş Ay'></th>
					<th><cf_get_lang dictionary_id='29472.Yöntem'></th>
					<th><cf_get_lang dictionary_id='57635.Miktar'></th>
					<th>&nbsp;</th>
					<th><cf_get_lang dictionary_id='53179.Bordro'></th>
					<th><cf_get_lang dictionary_id='54239.Ayni'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_odenek.recordcount>
					<cfoutput query="get_odenek" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>
							<cfif isdefined("field_salaryparam_pay_id") and isdefined("field_salaryparam_pay_name")>
									<cfif find("'",comment_pay)>
										<cfset comment_pay_ = replace(comment_pay,"'","\'",'all')>
									<cfelse>
										<cfset comment_pay_ = comment_pay>
									</cfif>
									<a href="##" onClick="gonder('#comment_pay_#','#odkes_id#')" class="tableyazi">#comment_pay#</a>
							<cfelse>
								<cfif find('"',comment_pay)>
									<cfset comment_pay_ = replace(comment_pay,'"','\"','all')>
									<a href="##" onClick='<cfif not (isdefined("attributes.draggable") or isdefined("attributes.from_xml"))>opener.</cfif>add_row("#is_damga#","#is_issizlik#","#ssk#","#tax#","#is_kidem#","#show#","#comment_pay_#","#period_pay#","#method_pay#","#session.ep.period_year#","#start_sal_mon#","#end_sal_mon#","#TLFormat(amount_pay,2)#", "#calc_days#","#from_salary#","#attributes.row_id_#","<cfif is_ehesap eq 1>1<cfelse>0</cfif>","<cfif is_ayni_yardim eq 1>1<cfelse>0</cfif>","#SSK_EXEMPTION_RATE#","#TAX_EXEMPTION_RATE#","#TAX_EXEMPTION_VALUE#","#money#","#ODKES_ID#","#SSK_EXEMPTION_TYPE#","#is_income#","#comment_type#","#factor_type#","#is_not_execution#","<cfif is_rd_damga eq 1>1<cfelse>0</cfif>","<cfif is_rd_gelir eq 1>1<cfelse>0</cfif>","<cfif is_rd_ssk eq 1>1<cfelse>0</cfif>");<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '#attributes.modal_id#' );</cfif>' class="tableyazi">#comment_pay#</a>
								<cfelse>
									<cfif find("'",comment_pay)>
										<cfset comment_pay_ = replace(comment_pay,"'","\'",'all')>
									<cfelse>
										<cfset comment_pay_ = comment_pay>
									</cfif>
									<a href="##" onClick="<cfif not (isdefined("attributes.draggable") or isdefined("attributes.from_xml"))>opener.</cfif>add_row('#is_damga#','#is_issizlik#','#ssk#','#tax#','#is_kidem#','#show#','#comment_pay_#','#period_pay#','#method_pay#','#session.ep.period_year#','#start_sal_mon#','#end_sal_mon#','#TLFormat(amount_pay,2)#', '#calc_days#','#from_salary#','#attributes.row_id_#','<cfif is_ehesap eq 1>1<cfelse>0</cfif>','<cfif is_ayni_yardim eq 1>1<cfelse>0</cfif>','#SSK_EXEMPTION_RATE#','#TAX_EXEMPTION_RATE#','#TAX_EXEMPTION_VALUE#','#money#','#ODKES_ID#','#SSK_EXEMPTION_TYPE#','#is_income#','#comment_type#','#factor_type#','#is_not_execution#','<cfif is_rd_damga eq 1>1<cfelse>0</cfif>','<cfif is_rd_gelir eq 1>1<cfelse>0</cfif>','<cfif is_rd_ssk eq 1>1<cfelse>0</cfif>');<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '#attributes.modal_id#' );</cfif>" class="tableyazi">#comment_pay#</a>
								</cfif>
							</cfif>
							</td>
							<td><cfif get_odenek.from_salary eq 1><cf_get_lang dictionary_id ='53131.Brüt'><cfelseif get_odenek.from_salary eq 0><cf_get_lang dictionary_id='58083.Net'></cfif></td>
							<td>#listgetat(ay_list(),START_SAL_MON,",")#</td>
							<td>#listgetat(ay_list(),END_SAL_MON,",")#</td>
							<td><cfif METHOD_PAY EQ 1><cf_get_lang dictionary_id ='53136.Artı'><cfelseif METHOD_PAY EQ 2><cf_get_lang dictionary_id="53514.Yüzde Ay"><cfelseif METHOD_PAY EQ 3><cf_get_lang dictionary_id="53518.Yüzde Gün"><cfelseif METHOD_PAY EQ 4><cf_get_lang dictionary_id="53522.Yüzde Saat"></cfif></td>
							<td  style="text-align:right;">#TLFormat(amount_pay)#</td>
							<td>#money#</td>
							<td align="center"><cfif show eq 1><img border="0" src="/images/b.gif" align="absmiddle"></cfif></td>
							<td align="center"><cfif is_ayni_yardim eq 1><img border="0" src="/images/ok_list.gif" align="absmiddle"></cfif></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="7"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
		<cf_paging page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="ehesap.popup_list_odenek#url_str#"
			isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();

	function gonder(comment_pay,comment_pay_id)
	{
	<cfif isdefined("field_salaryparam_pay_id")>opener.document.<cfoutput>#attributes.field_salaryparam_pay_id#</cfoutput>.value = comment_pay_id;</cfif>					
	<cfif isdefined("field_salaryparam_pay_name")>opener.document.<cfoutput>#attributes.field_salaryparam_pay_name#</cfoutput>.value = comment_pay;</cfif>		
	window.close();
	}

	<cfif isdefined("attributes.from_xml")>
		function add_row(is_damga,is_issizlik,ssk,tax,is_kidem,show,comment_pay, period_pay, method_pay, term, start_sal_mon, end_sal_mon, amount_pay, calc_days,from_salary,row_id_,is_ehesap,is_ayni_yardim,SSK_EXEMPTION_RATE,TAX_EXEMPTION_RATE,TAX_EXEMPTION_VALUE,money,comment_pay_id,SSK_EXEMPTION_TYPE,is_income,comment_type,factor_type,is_not_execution,is_rd_damga,is_rd_gelir,is_rd_ssk)
		{
			opener.document.<cfoutput>#attributes.field_id#</cfoutput>.value = comment_pay_id;	
		}
	</cfif>
</script>