<cfinclude template="../../header.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.start_date" default="#dateformat(session.ep.period_start_date,'dd/mm/yyyy')#">
<cfparam name="attributes.finish_date" default="#dateformat(session.ep.period_finish_date,'dd/mm/yyyy')#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_str = "">
<cfparam name="attributes.keyword" default="">

<cf_date tarih = "attributes.start_date">
<cf_date tarih = "attributes.finish_date">


<cfif isDefined("attributes.form_submitted")>
    <cfset carbon_footprint = createObject("component","WBP/Recycle/files/carbon_footprint/cfc/carbon_footprint") />
			
	<cfset getCarbonFootprintReport = carbon_footprint.getCarbonFootprintReport(
		keyword: attributes.keyword,
		start_date = attributes.start_date,
		finish_date = attributes.finish_date,
		page = attributes.page,
		pageSize = attributes.maxrows
    ) />

<cfelse>
	<cfset getCarbonFootprintReport.recordcount=0>
	<cfset getCarbonFootprintReport.totalrows=0>
</cfif>
<cfparam name="attributes.totalrecords" default=#getCarbonFootprintReport.totalrows#>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="carbonFootprintForm" id="carbonFootprintForm" method="post" action="#request.self#?fuseaction=recycle.carbon_footprint_analysis">
			<cf_box_search>
				<input type="hidden" name="dsn" id="dsn" value="<cfoutput>#dsn#</cfoutput>">
				<input type="hidden" name="form_submitted" id="form_submitted" value="1">
				<div class="form-group">
					<cfsavecontent variable="place"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255" placeholder="#place#">
				</div>
				<div class="form-group">

					<div class="form-group" id="item-start_date">
						<label class><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'>:</label>
						<div class="col col-12"> 
							<div class="input-group">
								<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih Değerlerini Kontrol Ediniz'>!</cfsavecontent>
									<cfinput type="text" name="start_date" id="start_date" maxlength="10" value="#dateformat(attributes.start_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" message="#message#">
								<cfelse>
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih Değerlerini Kontrol Ediniz'>!</cfsavecontent>
									<cfinput type="text" name="start_date" id="start_date" maxlength="10" value="" style="width:65px;" validate="#validate_style#" message="#message#">
								</cfif>
								<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-finish_date">
						<label class><cf_get_lang dictionary_id='57700.Bitiş Tarihi'>:</label>
						<div class="col col-12"> 
							<div class="input-group">
								<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih Değerlerini Kontrol Ediniz'>!</cfsavecontent>
									<cfinput type="text" name="finish_date" id="finish_date" maxlength="10" value="#dateformat(attributes.finish_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" message="#message#">
								<cfelse>
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih Değerlerini Kontrol Ediniz'>!</cfsavecontent>
									<cfinput type="text" name="finish_date" id="finish_date" maxlength="10" value="" style="width:65px;" validate="#validate_style#" message="#message#">
								</cfif>
								<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
							</div>
						</div>
					</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı'>!</cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','Alışlardan Kaynaklanan Karbon Footprint',63703)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='55657.Sıra No'></th>
					<th><cf_get_lang dictionary_id='57657.Ürün'></th>
					<th><cf_get_lang dictionary_id='57635.Miktar'></th>
					<th><cf_get_lang dictionary_id='63704.Birim Emisyon'></th>
					<th><cf_get_lang dictionary_id='63705.Toplam Emisyon'></th>
				</tr>
			</thead>
			<tbody>
				<cfif getCarbonFootprintReport.recordcount>
					<cfoutput query="getCarbonFootprintReport">
						<tr>
							<td>#rownum#</td>
							<td>#product_name#</td>
							<td class="text-right">#TLFormat(total_amount)#</td>
							<td class="text-right">#TLFormat(emission,8)# kg CO2</td>
							<td class="text-right">#TLFormat(total_emission,8)# kg CO2</td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="10"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
					</tr>
				</cfif>
			</tbody>
			<cfif getCarbonFootprintReport.recordcount>
				<tfoot>
					<tr>
						<td colspan = "4"></td>
						<td class="text-right"><cfoutput>#TLFormat(getCarbonFootprintReport.all_total_emission,8)# kg CO2</cfoutput></td>
					</tr>
				</tfoot>
			</cfif>
		</cf_grid_list>

		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfif len(attributes.keyword)>
				<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
			</cfif>
			<cfif len(attributes.form_submitted)>
				<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
			</cfif>
			<cfif len(attributes.start_date)>
				<cfset url_str = "#url_str#&start_date=#dateFormat(attributes.start_date,'dd/mm/yyyy')#">
			</cfif>
			<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="recycle.carbon_footprint_analysis#url_str#">
		</cfif>
	</cf_box>
</div>