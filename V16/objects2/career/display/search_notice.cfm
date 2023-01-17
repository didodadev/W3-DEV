<!--- İlan Arama --->

<cfset get_components = createObject("component", "V16.objects2.career.cfc.data_career")>
<cfset get_cities = get_components.GET_CITY(county_id: 1)>
<cfset get_companies = get_components.GET_COMPANIES()>
<cfset get_positions = get_components.get_positions()>

<cfif isdefined('attributes.is_icon') and attributes.is_icon eq 1> 
	<cfinclude template="list_notices1.cfm">
<cfelse>
	<!--- <cfform name="search_notice" action="#request.self#?fuseaction=objects2.list_notices&is_icon=1"> --->
	<cfform name="search_notice" action="#request.self#">
		<cfinput name="is_icon" type="hidden" value="1">
		<div class="row">
			<div class="col-xl-12">
				<p class="font-weight-bold">Detaylı Arama</p>
			</div>			
		</div>
		<div class="form-group row">
			<label class="col-md-2 col-form-label"><cf_get_lang dictionary_id='57971.Şehir'></label>
			<div class="col-12 col-md-8 col-lg-6 col-xl-2">
				<select class="form-control" name="city" id="city">
					<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
					<cfoutput query="get_cities">
						<option value="#city_id#" <cfif isDefined('attributes.city_id') and attributes.city_id eq city_id>selected</cfif>>#city_name#</option>
					</cfoutput>
				</select>
			</div>
		</div>
		<div class="form-group row">
			<label class="col-md-2 col-form-label"><cf_get_lang dictionary_id='58497.Pozisyon'></label>
			<div class="col-12 col-md-8 col-lg-6 col-xl-2">
				<select class="form-control" name="position_id" id="position_id">
					<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
					<cfoutput query="get_positions">
						<option value="#position_id#" <cfif isDefined('attributes.position_id') and attributes.position_id eq position_id>selected</cfif>>#position_name#</option>
					</cfoutput>
				</select>
			</div>
		</div>
		<div class="form-group row">
			<label class="col-md-2 col-form-label"><cf_get_lang dictionary_id='57574.Şirket'></label>
			<div class="col-12 col-md-8 col-lg-6 col-xl-2">
				<select class="form-control" name="our_company_id" id="our_company_id">
					<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
					<cfoutput query="get_companies">
						<option value="#comp_id#" <cfif isDefined('attributes.our_company_id') and attributes.our_company_id eq comp_id>selected</cfif>>#company_name#</option>
					</cfoutput>
				</select>
			</div>
		</div>
		<div class="form-group row">
			<div class="col-12 col-md-8 col-lg-6 col-xl-2 pl-0">
				<cf_wrk_search_button is_excel='0'>
			</div>
		</div>
	</cfform>
</cfif>