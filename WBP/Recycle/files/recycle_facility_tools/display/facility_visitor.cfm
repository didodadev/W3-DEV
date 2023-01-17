<cfinclude template="../../header.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.start_date" default="#dateformat(dateAdd('d',-7,now()),'dd/mm/yyyy')#">
<!---<cfparam name="attributes.start_date" default="#dateformat(now(),'dd/mm/yyyy')#">--->
<cfparam name="attributes.finish_date" default="#dateformat(dateAdd('d',+1,now()),'dd/mm/yyyy')#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_str = "">
<cfparam name="attributes.keyword" default="">

<cf_date tarih = "attributes.start_date">
<cf_date tarih = "attributes.finish_date">


<cfif isDefined("attributes.form_submitted")>
    <cfset facility_visitor = createObject("component","WBP/Recycle/files/recycle_facility_tools/cfc/facility_visitor") />
			
	<cfset getFacilityVisitor = facility_visitor.getFacilityVisitor(
		keyword: attributes.keyword,
		process_stage = attributes.process_stage,
		start_date = attributes.start_date,
		finish_date = attributes.finish_date
    ) />

<cfelse>
	<cfset getFacilityVisitor.recordcount=0>
</cfif>
<cfparam name="attributes.totalrecords" default=#getFacilityVisitor.recordcount#>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="visitorRegisterForm" id="visitorRegisterForm" method="post" action="#request.self#?fuseaction=recycle.facility_visitor">
			<cf_box_search>
				<input type="hidden" name="dsn" id="dsn" value="<cfoutput>#dsn#</cfoutput>">
				<input type="hidden" name="form_submitted" id="form_submitted" value="1">
				<div class="form-group">
					<cfsavecontent variable="place"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255" placeholder="#place#">
				</div>
				<div class="form-group">
					<cf_workcube_process is_upd='0' select_value="#attributes.process_stage#" process_cat_width='250' is_detail='0' is_select_text = "1">
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
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='62978.Tesis Ziyaretçileri'></cfsavecontent>
	<cf_box title="#head#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='55657.Sıra No'></th>
					<th><cf_get_lang dictionary_id='58859.Süreç'></th>
					<th><cf_get_lang dictionary_id='37187.Ziyaretçi'> <cf_get_lang dictionary_id='32370.Adı Soyadı'></th>
					<th><cf_get_lang dictionary_id='54265.TC No'></th>
					<th><cf_get_lang dictionary_id='58607.Firma'></th>
					<th><cf_get_lang dictionary_id='49372.Telefon Numarası'></th>
					<th><cf_get_lang dictionary_id='55484.E-Mail'></th>
					<th><cf_get_lang dictionary_id='34029.Ziyaret Edilen'></th>
					<th><cf_get_lang dictionary_id='52370.Ziyaret Tarihi'></th>
					<th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=recycle.facility_visitor&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
				</tr>
			</thead>
			<tbody>
				<cfif getFacilityVisitor.recordcount>
					<cfoutput query="getFacilityVisitor" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td><cf_workcube_process type="color-status" process_stage="#PROCESS_STAGE#"></td>
							<td>#VISITOR_NAME#</td>
							<td>#TC_IDENTITY_NUMBER#</td>
							<td>#len(FULLNAME) ? FULLNAME : CONSUMER_NAME & ' ' & CONSUMER_SURNAME#</td>
							<td>#PHONE_NUMBER#</td>
							<td>#EMAIL_ADDRESS#</td>
							<td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
							<td>#dateformat(VISIT_TIME,dateformat_style)# #timeformat(VISIT_TIME,timeformat_style)#</td>
							<td><a href="#request.self#?fuseaction=recycle.facility_visitor&event=upd&refinery_visitor_register_id=#REFINERY_VISITOR_REGISTER_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="10"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>

		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfif len(attributes.keyword)>
				<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
			</cfif>
			<cfif len(attributes.form_submitted)>
				<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
			</cfif>
			<cfif len(attributes.process_stage)>
				<cfset url_str = "#url_str#&process_stage=#attributes.process_stage#">
			</cfif>
			<cfif len(attributes.start_date)>
				<cfset url_str = "#url_str#&start_date=#dateFormat(attributes.start_date,'dd/mm/yyyy')#">
			</cfif>
			<cf_paging page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="recycle.facility_visitor#url_str#">
        </cfif>
	</cf_box>
</div>