<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
<cfif isdefined("attributes.is_submit")>
	<cfinclude template="../query/get_tax_exc.cfm">
<cfelse>
	<cfset GET_TAX_EXC.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#GET_TAX_EXC.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.keyword" default="">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform action="#request.self#?fuseaction=ehesap.list_tax_exception" method="post" name="filter_list_tax_exception">
			<input type="hidden" name="is_submit" id="is_submit" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id="57460.Filtre"></cfsavecontent>
					<cfinput type="text" placeholder="#message#" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group">
					<select name="status" id="status">
						<option value=""><cf_get_lang dictionary_id ='57708.Tümü'></option>
						<option value="1" <cfif isDefined("attributes.status") and (attributes.status eq 1)> selected</cfif>><cf_get_lang dictionary_id ='57493.Aktif'></option>
						<option value="0" <cfif isDefined("attributes.status") and (attributes.status eq 0)> selected</cfif>><cf_get_lang dictionary_id ='57494.Pasif'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="53085.Vergi İstisnaları"></cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1">
		<cf_flat_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='58233.Tanım'></th>
					<th nowrap="nowrap"><cf_get_lang dictionary_id='53132.Başlangıç Ay'></th>
					<th nowrap="nowrap"><cf_get_lang dictionary_id='53133.Bitiş Ay'></th>
					<th style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></th>
					<th width="20">%</th>
					<!-- sil -->
					<th width="20" class="header_icn_none text-center">
						<a href="JAVASCRIPT://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=ehesap.list_tax_exception&event=add</cfoutput>','medium')"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
					</th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif GET_TAX_EXC.recordcount>
					<cfoutput QUERY="GET_TAX_EXC"  startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td width="35">#currentrow#</td>
							<td><a href="JAVASCRIPT://" onClick="windowopen('#request.self#?fuseaction=ehesap.list_tax_exception&event=upd&tax_exception_id=#tax_exception_id#','medium')" class="tableyazi">#tax_exception#</a></td>
							<td>#LISTgetat(ay_list(),start_month,',')#</td>
							<td>#LISTgetat(ay_list(),finish_month,',')#</td>
							<td  style="text-align:right;">#TLFormat(AMOUNT)#</td>
							<td>#YUZDE_SINIR#</td>
							<!-- sil -->
							<td align="center"> 
								<a href="JAVASCRIPT://" onClick="windowopen('#request.self#?fuseaction=ehesap.list_tax_exception&event=upd&tax_exception_id=#tax_exception_id#','medium')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a> 
							</td>
							<!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="8"><cfif isdefined("attributes.is_submit")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
		<cfset url_str = "">
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif isdefined("attributes.sal_year") and len(attributes.sal_year)>
			<cfset url_str = "#url_str#&sal_year=#attributes.sal_year#">
		</cfif>
		<cfif isdefined("attributes.is_submit") and len(attributes.is_submit)>
			<cfset url_str = "#url_str#&is_submit=#attributes.is_submit#">
		</cfif>
		<cfif isdefined("attributes.status") and len(attributes.status)>
			<cfset url_str = "#url_str#&status=#attributes.status#">
		</cfif>      
		<cf_paging page="#attributes.page#"
		maxrows="#attributes.maxrows#"
		totalrecords="#attributes.totalrecords#"
		startrow="#attributes.startrow#"
		adres="ehesap.list_tax_exception#url_str#">
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
