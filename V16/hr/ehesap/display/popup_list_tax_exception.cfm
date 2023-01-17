<cfparam name="attributes.modal_id" default="">
<cfquery name="get_tax_exc" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		TAX_EXCEPTION
	WHERE
		STATUS = 1
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND TAX_EXCEPTION LIKE '%#attributes.keyword#%'
	</cfif>
	ORDER BY
		TAX_EXCEPTION.START_MONTH DESC,
		TAX_EXCEPTION.FINISH_MONTH ASC
</cfquery>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#GET_TAX_EXC.recordcount#>
<cfparam name="attributes.row_id_" default="">
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
<cfsavecontent variable="message"><cf_get_lang dictionary_id="53085.Vergi İstisnaları"></cfsavecontent>
<cf_box title="#message#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	
	<cfform action="#request.self#?fuseaction=ehesap.popup_list_tax_exception" method="post" name="filter_list_tax_exception">
		<cf_box_search>
			<div class="form-group"><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="50" placeholder="#getLang('','filtre',57460)#"></div>
			<div class="form-group">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
			</div>
			<div class="form-group"><cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_form' , #attributes.modal_id#)"),DE(""))#"></div>
		</cf_box_search>
	</cfform>
	
	<cf_grid_list>
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='57630.Tip'></th>
				<th><cf_get_lang dictionary_id='53132.Başlangıç Ay'></th>
				<th><cf_get_lang dictionary_id='53133.Bitiş Ay'></th>
				<th><cf_get_lang dictionary_id='57635.Miktar'></th>
				<th><cf_get_lang dictionary_id='58714.SGK'></th>
				<th width="30">%</th>
			</tr>
		</thead>
		<tbody>
			<cfif GET_TAX_EXC.recordcount>
				<cfoutput QUERY="GET_TAX_EXC"  startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfif is_all_pay eq 1>
						<cfset tamamini_ode = 1>
					<cfelse>
						<cfset tamamini_ode = 0>
					</cfif>
					<cfif is_ssk eq 1>
						<cfset is_ssk_ = 1>
					<cfelse>
						<cfset is_ssk_ = 0>
					</cfif>
					<cfif is_isveren eq 1>
						<cfset is_isveren_ = 1>
					<cfelse>
						<cfset is_isveren_ = 0>
					</cfif>
					<tr>
						<td><a href="##" onClick="<cfif not(isdefined("attributes.draggable") or isdefined("attributes.from_xml"))>opener.</cfif>add_row('#tax_exception#','#session.ep.period_year#','#start_month#','#finish_month#','#TLFormat(amount)#', '#calc_days#', '#yuzde_sinir#','#tamamini_ode#','#is_isveren_#','#is_ssk_#','#exception_type#','#attributes.row_id_#','#tax_exception_id#','#attributes.modal_id#');" class="tableyazi">#tax_exception#</a></td>
						<td>#LISTgetat(ay_list(),start_month,",")#</td>
						<td>#LISTgetat(ay_list(),finish_month,",")#</td>
						<td  style="text-align:right;">#TLFormat(amount)#</td>
						<td><cfif is_ssk_ eq 1>Dahil<cfelse>Yok</cfif></td>
						<td>#yuzde_sinir#</td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
				<td colspan="7">
					<cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!
				</td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
</cf_box>
<cfif attributes.totalrecords gt attributes.maxrows>
	<table width="99%" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
		<tr>
			<td>
				<cf_pages page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="ehesap.popup_list_tax_exception#url_str#">
				</td>
				<!-- sil --><td  style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput> </td><!-- sil -->
		</tr>
	</table>
</cfif>
<script>
	<cfif isdefined("attributes.from_xml")>
		function add_row(tax_exception, term, start_sal_mon, end_sal_mon, amount, calc_days, yuzde_sinir,tamamini_ode,is_isveren,is_ssk,exception_type,row_id_,tax_exception_id,modal_id_)
		{
			opener.document.<cfoutput>#attributes.field_id#</cfoutput>.value = tax_exception_id;	
		}
	</cfif>
</script>