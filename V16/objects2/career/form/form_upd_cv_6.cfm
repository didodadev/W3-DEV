<!--- Özgeçmişim / Çalışma Tercihlerim (Stage : 6) --->
<cfif not isdefined("session.cp.userid")>
	<cflocation url="#request.self#?fuseaction=objects2.kariyer_login" addtoken="no">
</cfif>
<cfset get_components = createObject("component", "V16.objects2.career.cfc.data_career")>
<cfset get_app_unit = get_components.get_app_unit()>
<cfset get_cv_unit = get_components.get_cv_unit()>
<cfset get_cv_unit_max = get_components.get_cv_unit_max()>
<cfset get_city = get_components.get_city()>
<cfset get_app = get_components.get_app()>

<cfparam name="attributes.stage" default="6"><!--- hangi sayfa olduğunu belirleyen değer--->

<cfform name="employe_detail" method="post">
<input type="hidden" name="stage" id="stage" value="<cfoutput>#attributes.stage#</cfoutput>">
<div class="row">
	<div class="col-md-12">
		<cfinclude template="../display/add_sol_menu.cfm">
	</div>
</div>
<div class="row">
	<div class="col-md-12">
		<p class="font-weight-bold"><cf_get_lang dictionary_id='31446.Özgeçmişim'> \ <cf_get_lang dictionary_id='35474.Çalışmak İstenilen Birim'> \ <cf_get_lang dictionary_id='57453.Şube'></p>
	</div>
</div>
<div class="row">
	<div class="col-md-3">
		<p class="font-weight-bold"><cf_get_lang dictionary_id='35474.Çalışmak İstenilen Birim'></p>
	</div>
	<div class="col-md-4">
		(<cf_get_lang dictionary_id='35185.Öncelik Sıralarını Yandaki Kutulara Yazınız'>... 1,2,3 gibi)
	</div>
</div>
<div class="form-group row">	
	<div class="col-12 col-md-3 col-lg-3 col-xl-2">
		<cfif get_cv_unit.recordcount>
			<cfset liste = valuelist(get_app_unit.unit_id)>
			<cfset liste_row = valuelist(get_app_unit.unit_row)>					
			<cfoutput query="get_cv_unit">
			<cfif get_cv_unit.currentrow-1 mod 3 eq 0></cfif>
			#get_cv_unit.unit_name#
	</div>
	<div class="col-12 col-md-3 col-lg-2 col-xl-1">			
		<cfif listfind(liste,get_cv_unit.unit_id,',')>
		<input type="text" class="form-control" name="unit#get_cv_unit.unit_id#" id="unit#get_cv_unit.unit_id#" value="#listgetat(liste_row,listfind(liste,get_cv_unit.unit_id,','),',')#" maxlength="1" onchange="seviye_kontrol(this)" onBlur="isNumber(this)">
	</div>
	<div class="col-12 col-md-3 col-lg-2 col-xl-2">
			<cfelse>
				<input type="text" class="form-control" name="unit#get_cv_unit.unit_id#" id="unit#get_cv_unit.unit_id#" value="" maxlength="1"  onchange="seviye_kontrol(this)" onBlur="isNumber(this)">
			</cfif>			
			<cfif get_cv_unit.currentrow mod 3 eq 0 and get_cv_unit.currentrow-1 neq 0></cfif>	  
			</cfoutput>
		<cfelse>
			<cf_get_lang dictionary_id='31702.Sisteme kayıtlı birim yok'>.
		</cfif>
	</div>	
</div>
<div class="row">
	<div class="col-md-12">
		<p class="font-weight-bold"><cf_get_lang dictionary_id='32327.Çalışmak İstediği Yer'></p>
	</div>
	<div class="col-12 col-md-6 col-lg-5 col-xl-3 mb-3">
		<select class="form-control" name="prefered_city" id="prefered_city" multiple>
			<option value="" <cfif listfind(get_app.prefered_city,'',',') or not len(get_app.prefered_city)>selected</cfif>><cf_get_lang dictionary_id='31704.Tüm Türkiye'></option>
			<cfoutput query="get_city">
				<option value="#city_id#" <cfif listlen(get_app.prefered_city,',') gt 0 and listgetat(get_app.prefered_city,1,',') eq get_city.city_id>selected</cfif>>#city_name#</option>
			</cfoutput>
		</select>
	</div>
</div>
<div class="row">
	<div class="col-md-12">
		<div class="form-group row">
			<label class="col-12 col-md-3 col-lg-3 col-xl-2 col-form-label"><strong><cf_get_lang dictionary_id='31705.Seyahat Edebilir misiniz'>?</strong></label>
			<div class="col-12 col-md-8 col-lg-6 col-xl-4 mt-1 pt-1 pl-0">
				<div class="col-12">
					<input type="radio" name="is_trip" id="is_trip" value="1" <cfif get_app.is_trip IS 1 OR get_app.is_trip IS "">checked</cfif>> <cf_get_lang dictionary_id='57495.Evet'>
				</div>
				<div class="col-12">
					<input type="radio" name="is_trip" id="is_trip" value="0" <cfif get_app.is_trip IS 0>checked</cfif>> <cf_get_lang dictionary_id='57496.Hayır'><br/><br/>
				</div>
			</div>		
		</div>
	</div>			
</div>
<div class="row">
	<div class="col-md-12">
		<div class="form-group row">
			<label class="col-12 col-md-3 col-lg-3 col-xl-2 col-form-label"><strong><cf_get_lang dictionary_id='31706.İstenilen Ücret (Net)'></strong></label>
			<div class="col-7 col-sm-4 col-md-3 col-lg-3 col-xl-2">
				<cfinput type="text" class="form-control text-right" name="expected_price" id="expected_price"  value="#TLFormat(get_app.expected_price)#" passThrough="onkeyup=""return(FormatCurrency(this,event));""">
			</div>
			<div class="col-5 col-sm-3 col-md-2 col-lg-2 col-xl-1">
				<cfquery name="GET_MONEY" datasource="#DSN#">
					SELECT
						MONEY
					FROM
						SETUP_MONEY
					WHERE
						PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.period_id#">
				</cfquery>
				<select class="form-control" name="expected_money_type" id="expected_money_type">
					<cfoutput query="get_money">
						<option value="#money#"<cfif money is get_app.expected_money_type> selected</cfif>>#money#</option>
					</cfoutput>
				</select>		
			</div>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-md-12">
		<p class="font-weight-bold"><cf_get_lang dictionary_id='55326.Eklemek İstedikleriniz'></p>
	</div>
	<div class="col-12 col-md-6 col-lg-5 col-xl-5">
		<textarea class="form-control" name="applicant_notes" id="applicant_notes" maxlength="300" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);"><cfoutput>#get_app.applicant_notes#</cfoutput></textarea>
	</div>
</div>
<div class="row">
	<div class="col-md-12">
		<cfsavecontent variable="alert"><cf_get_lang dictionary_id='35495.Kaydet ve İlerle'></cfsavecontent>
		<!--- <cf_workcube_buttons is_upd='0' insert_info='#alert#' add_function='kontrol()' is_cancel='0'> --->
		<cf_workcube_buttons is_insert='1'	data_action="/V16/objects2/career/cfc/data_career:add_cv_6" next_page="#request.self#" add_function='kontrol()'>
	</div>
</div>
</cfform>

<script type="text/javascript">
	<cfoutput>
		<cfif get_cv_unit_max.recordcount>
			unit_count=#get_cv_unit_max.max_id#;
		<cfelse>
			unit_count=0;
		</cfif>
	</cfoutput>
	function seviye_kontrol(nesne)
	{
		for(var j=1;j<=unit_count;j++)
		{
			var diger_nesne = eval("document.getElementById('unit"+j+"')");
			if(diger_nesne!=undefined && diger_nesne!=nesne)
			{
				if(diger_nesne.value.length!=0 && nesne.value==diger_nesne.value)
				{
					alert("<cf_get_lang no='868.İki tane aynı seviye giremezsiniz'>!");
					diger_nesne.value='';
				}
			}
		}
	}
</script>
