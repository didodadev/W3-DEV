<!--- Özgeçmişim / Diğer Kimlik Bilgilerim (Stage : 3) --->
<cfset get_components = createObject("component", "V16.objects2.career.cfc.data_career")>
<cfset get_app_identy = get_components.get_app_identy()>
<cfparam name="attributes.stage" default="3">

<cfform name="employe_detail" method="post">
	<input type="hidden" name="identity_detail" id="identity_detail" value="<cfif isdefined('attributes.is_identity_detail')><cfoutput>#attributes.is_identity_detail#</cfoutput><cfelse>0</cfif>">
	<input type="hidden" name="stage" id="stage" value="<cfoutput>#attributes.stage#</cfoutput>">
	<div class="row">
		<div class="col-md-12">
			<cfinclude template="../display/add_sol_menu.cfm">
		</div>
	</div>
	<div class="row">
		<div class="col-md-12">
			<p class="font-weight-bold"><cf_get_lang dictionary_id='35124.Özgeçmişim'> \ <cf_get_lang dictionary_id='35925.Diğer Kimlik Detayları'></p>
		</div>
	</div>	
	<div class="row">
		<div class="col-md-6">
			<div class="form-group row">
				<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='57637.Seri No'></label>
				<div class="col-4 col-md-3 col-lg-2 col-xl-2 pr-0">
					<cfinput type="text" class="form-control" name="series" id="series" maxlength="20" value="#get_app_identy.series#">		
				</div>
				<div class="col-8 col-md-5 col-lg-4 col-xl-3">
					<cfinput type="text" class="form-control" name="number" id="number" maxlength="50" value="#get_app_identy.number#">
				</div>
			</div>
			<div class="form-group row">
				<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='58033.Baba Adı'></label>
				<div class="col-12 col-md-8 col-lg-6 col-xl-5">
					<cfinput type="text" class="form-control" name="father" id="father" value="#get_app_identy.father#" maxlength="75">
				</div>
			</div>
			<div class="form-group row">
				<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='34658.Baba İş'></label>
				<div class="col-12 col-md-8 col-lg-6 col-xl-5">
					<cfinput type="text" class="form-control" name="father_job" id="father_job" value="#get_app_identy.father_job#" maxlength="50">
				</div>
			</div>
			<div class="form-group row">
				<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='34660.Önceki Soyadı'></label>
				<div class="col-12 col-md-8 col-lg-6 col-xl-5">
					<cfinput type="text" class="form-control" name="last_surname" id="last_surname" value="#get_app_identy.last_surname#" maxlength="100" >
				</div>
			</div>
		</div>
		<div class="col-md-6">
			<div class="form-group row">
				<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='58441.Kan Grubu'></label>
				<div class="col-12 col-md-8 col-lg-6 col-xl-5">
					<select class="form-control" name="blood_type" id="blood_type">
						<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						<option value="0"<cfif len(get_app_identy.blood_type) and (get_app_identy.blood_type eq 0)>selected</cfif>>0 Rh+</option>
						<option value="1"<cfif len(get_app_identy.blood_type) and (get_app_identy.blood_type eq 1)>selected</cfif>>0 Rh-</option>
						<option value="2"<cfif len(get_app_identy.blood_type) and (get_app_identy.blood_type eq 2)>selected</cfif>>A Rh+</option>
						<option value="3"<cfif len(get_app_identy.blood_type) and (get_app_identy.blood_type eq 3)>selected</cfif>>A Rh-</option>
						<option value="4"<cfif len(get_app_identy.blood_type) and (get_app_identy.blood_type eq 4)>selected</cfif>>B Rh+</option>
						<option value="5"<cfif len(get_app_identy.blood_type) and (get_app_identy.blood_type eq 5)>selected</cfif>>B Rh-</option>
						<option value="6"<cfif len(get_app_identy.blood_type) and (get_app_identy.blood_type eq 6)>selected</cfif>>AB Rh+</option>
						<option value="7"<cfif len(get_app_identy.blood_type) and (get_app_identy.blood_type eq 7)>selected</cfif>>AB Rh-</option>
					</select>
				</div>
			</div>			
			<div class="form-group row">
				<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='58440.Ana Adı'></label>
				<div class="col-12 col-md-8 col-lg-6 col-xl-5">
					<cfinput type="text" class="form-control" name="mother" id="mother" value="#get_app_identy.mother#" maxlength="75">
				</div>
			</div>
			<div class="form-group row">
				<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='34659.Anne İş'></label>
				<div class="col-12 col-md-8 col-lg-6 col-xl-5">
					<cfinput type="text" class="form-control" name="mother_job" id="mother_job" value="#get_app_identy.mother_job#" maxlength="50">
				</div>
			</div>
			<div class="form-group row">
				<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='34661.Dini'></label>
				<div class="col-12 col-md-8 col-lg-6 col-xl-5">
					<cfinput type="text" class="form-control" name="religion" id="religion" value="#get_app_identy.religion#" maxlength="50" >
				</div>
			</div>			
		</div>
	</div>
	<div class="row">
		<div class="col-md-12">
			<p class="font-weight-bold"><cf_get_lang dictionary_id='34662.Nüfusa Kayıtlı Olduğu'></p>
		</div>
	</div>	
	<div class="row">
		<div class="col-md-6">

			<div class="form-group row">
				<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='58638.İlçe'></label>
				<div class="col-12 col-md-8 col-lg-6 col-xl-5">
					<cfinput type="text" class="form-control" name="county" id="county" value="#get_app_identy.county#" maxlength="100">
				</div>
			</div>
			
			<div class="form-group row">
				<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='58735.Mahalle'></label>
				<div class="col-12 col-md-8 col-lg-6 col-xl-5">
					<cfinput type="text" class="form-control" name="ward" id="ward" value="#get_app_identy.ward#" maxlength="100">
				</div>
			</div>

			<div class="form-group row">
				<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='55645.Köy'></label>
				<div class="col-12 col-md-8 col-lg-6 col-xl-5">
					<cfinput type="text" class="form-control" name="village" id="village" value="#get_app_identy.village#" maxlength="100">
				</div>
			</div>
		</div>
		<div class="col-md-6">
			<div class="form-group row">
				<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='34663.Cilt No'></label>
				<div class="col-12 col-md-8 col-lg-6 col-xl-5">
					<cfinput type="text" class="form-control" name="binding" id="binding"  value="#get_app_identy.binding#" maxlength="20">
				</div>
			</div>

			<div class="form-group row">
				<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='34665.Aile Sıra No'></label>
				<div class="col-12 col-md-8 col-lg-6 col-xl-5">
					<cfinput type="text" class="form-control" name="family" id="family" value="#get_app_identy.family#" maxlength="20">
				</div>
			</div>

			<div class="form-group row">
				<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='34667.Sıra No'></label>
				<div class="col-12 col-md-8 col-lg-6 col-xl-5">
					<cfinput type="text" class="form-control" name="cue"  id="cue"  value="#get_app_identy.cue#" maxlength="20">
				</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-md-12">
			<p class="font-weight-bold"><cf_get_lang dictionary_id='55646.Cüzdanın'></p>
		</div>
	</div>	
	<div class="row">
		<div class="col-md-6">
			<div class="form-group row">
				<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='34669.Verildiği Yer'></label>
				<div class="col-12 col-md-8 col-lg-6 col-xl-5">
					<cfinput type="text" class="form-control" name="given_place" id="given_place" value="#get_app_identy.given_place#" maxlength="100">
				</div>
			</div>
			<div class="form-group row">
				<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='34671.Veriliş Nedeni'></label>
				<div class="col-12 col-md-8 col-lg-6 col-xl-5">
					<cfinput type="text" class="form-control" name="given_reason" id="given_reason" value="#get_app_identy.given_reason#" maxlength="300">
				</div>
			</div>
		</div>

		<div class="col-md-6">
			<div class="form-group row">
				<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='34670.Kayıt No'></label>
				<div class="col-12 col-md-8 col-lg-6 col-xl-5">
					<cfinput type="text" class="form-control" name="record_number" id="record_number" value="#get_app_identy.record_number#" maxlength="50">
				</div>
			</div>

			<div class="form-group row">
				<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='34672.Veriliş Tarihi'></label>
				<div class="col-12 col-md-8 col-lg-6 col-xl-5">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='34672.veriliş tarihi'></cfsavecontent>
					<cfinput type="text" class="form-control" name="given_date" id="given_date" value="#dateformat(get_app_identy.given_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#">
					<cf_wrk_date_image date_field="given_date">
				</div>
			</div>
			
		</div>
	</div>
	<div class="row">
		<div class="col-12 d-flex justify-content-start">
			<cfsavecontent variable="alert"><cf_get_lang dictionary_id ='35495.Kaydet ve İlerle'></cfsavecontent>
			<cf_workcube_buttons is_insert='1'	data_action="/V16/objects2/career/cfc/data_career:add_cv_3" next_page="#request.self#" add_function='kontrol()'>

		</div>	
	</div>			
</cfform>


