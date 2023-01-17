<cfif isdefined("attributes.form_submitted")>
    <cfquery name="GET_COUPONS" datasource="#DSN3#">
        SELECT
            *
        FROM 
            COUPONS 
        WHERE 
            1=1 <cfif IsDefined("attributes.keyword") and len(attributes.keyword)> AND COUPON_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"></cfif>
    </cfquery>
<cfelse>
	<cfset get_coupons.recordcount=0>
</cfif>
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)><cf_date tarih = "attributes.start_date"></cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)><cf_date tarih = "attributes.finish_date"></cfif>
<cfparam name="attributes.cat" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_coupons.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search_coupon" action="#request.self#?fuseaction=#url.fuseaction#" method="post">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search>
				<div class="form-group" id="item-keyword">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#message#">
				</div>
				<div class="form-group small" id="item-maxrows">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='63931.Alışveriş Kuponları'></cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id="58577.Sıra"></th>
					<th><cf_get_lang dictionary_id='37470.Kupon no'></th>
					<th><cf_get_lang dictionary_id='37471.Kupon Adı'></th>
					<th><cf_get_lang dictionary_id='63933.Kupon Tipi'></th>
					<th><cf_get_lang dictionary_id='58560.İndirim'>%</th>
					<th><cf_get_lang dictionary_id='63935.Kupon Tutarı'></th>
					<th><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></th>
					<th><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
					<!-- sil --><th width="20" class="header_icn_none"><a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=product.list_coupons&event=add</cfoutput>');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></a></th><!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_coupons.recordcount>
					<cfoutput query="get_coupons" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
						<tr>
							<td>#currentrow#</td>
							<td>#coupon_no#</td>
							<td>#coupon_name#</td> 
							<td><cfif coupon_type eq 1><cf_get_lang dictionary_id='58560.İndirim'><cfelse><cf_get_lang dictionary_id='57673.Tutar'></cfif></td> 
							<td>#rate#</td> 
							<td>#money# <cfif len(money)>#currency#</cfif></td> 
							<td>#dateformat(start_date,dateformat_style)#</td>
							<td>#dateformat(finish_date,dateformat_style)#</td>
							<!-- sil --><td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=product.list_coupons&event=upd&coupon_id=#get_coupons.coupon_id#');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></a></td><!-- sil -->
						</tr>
					</cfoutput> 
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif not get_coupons.recordcount>
		<div class="ui-info-bottom">
            <p><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></p>
        </div>
		</cfif>
		<cfset adres = url.fuseaction>
		<cfif len(attributes.keyword)>
			<cfset adres = '#adres#&keyword=#attributes.keyword#'>
		</cfif>
		<cfif isdefined ('attributes.form_submitted') and len(attributes.form_submitted)>
			<cfset adres = '#adres#&form_submitted=#attributes.form_submitted#'>
		</cfif>
		<cf_paging page="#attributes.page#" 
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#adres#"> 
	</cf_box>
</div>
<script type="text/javascript">
	$('#keyword').focus();
	//document.getElementById('keyword').focus();
</script>
