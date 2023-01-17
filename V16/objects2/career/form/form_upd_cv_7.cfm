<!--- Özgeçmişim / Kabul (Stage : 7) --->
<cfset get_components = createObject("component", "V16.objects2.career.cfc.data_career")>
<cfset get_app = get_components.get_app()>
<cfset get_app_identy = get_components.get_app_identy()>
<cfset get_app_unit = get_components.get_app_unit()>
<!--- <cfif not isdefined("session.cp.userid")>
  <cflocation url="#request.self#?fuseaction=objects2.kariyer_login" addtoken="no">
</cfif> --->

<cfparam name="attributes.stage" default="7">
<cfform name="employe_detail" method="post" enctype="multipart/form-data">
	<input type="hidden" name="stage" id="stage" value="<cfoutput>#attributes.stage#</cfoutput>">
	<div class="row">
		<div class="col-md-12">
			<cfinclude template="../display/add_sol_menu.cfm">
		</div>
	</div>		
	<div class="row">
		<div class="col-xl-12">
			<p class="font-weight-bold"><cf_get_lang dictionary_id='31446.Özgeçmişim'> \ <cf_get_lang dictionary_id='53121.Kabul'> <cf_get_lang dictionary_id='57989.ve'> <cf_get_lang dictionary_id='57500.Onay'></p>
		</div>
		<div class="col-xl-12">
			<p class="font-weight-bold"><cf_get_lang dictionary_id='58515.Aktif / Pasif'></p>
		</div>
		<div class="col-xl-12">
			<p>Özgeçmişinizin <font style="font-weight:bold;">aktif</font> veya <font style="font-weight:bold;">pasif</font> olmasını bu bölümden belirleyebilirsiniz.</p>    			
		</div>
		<div class="col-xl-12 pl-0">
			<div class="col-xl-4">
				<input type="radio" name="app_status" id="app_status" value="1" <cfif get_app.app_status eq 1>checked</cfif>> <cf_get_lang dictionary_id='57493.Aktif'>
			</div>
			<div class="col-xl-4">
				<input type="radio" name="app_status" id="app_status" value="0" <cfif get_app.app_status eq 0 or not len(get_app.app_status)>checked</cfif>> <cf_get_lang dictionary_id='57494.Pasif'>
			</div>
		</div>
		<div class="col-xl-12 d-flex justify-content-start mt-3">
			<cfsavecontent variable="alert"><cf_get_lang dictionary_id='35495.Kaydet ve İlerle'></cfsavecontent>
			<!--- 	<cf_workcube_buttons is_upd='0' insert_info='#alert#' add_function='kontrol()' is_cancel='0'> --->
			<cf_workcube_buttons is_insert='1'	data_action="/V16/objects2/career/cfc/data_career:add_cv_7" next_page="#request.self#" add_function='kontrol()'>
		</div>
	</div>	
</cfform>
<script type="text/javascript">
	eksik_var=0;
	<cfif not len(get_app.sex)>eksik_var=1;</cfif>
	<cfif not len(get_app.homeaddress)>eksik_var=1;</cfif>
	<cfif not len(get_app.mobil) and not len(get_app.mobil2) and not len(get_app.hometel) and not len(get_app.worktel)>eksik_var=1;</cfif>
	<cfif not len(get_app.military_status)>eksik_var=1;</cfif>
	<cfif not len(get_app_identy.birth_date)>eksik_var=1;</cfif>
	<cfif not len(get_app_identy.birth_place)>eksik_var=1;</cfif>
	<cfif not len(get_app_identy.married)>eksik_var=1;</cfif>
	<cfif not len(get_app_unit.recordcount)>eksik_var=1;</cfif>
	function kontrol()
	{
		if(eksik_var==1 && document.getElementById('app_status')[0].checked)
		{
			alert("<cf_get_lang no='884.Eksik bilgileri eklemeden özgeçminizi aktif yapamazsınız'>!")
			return false;
		}
		return true;
	}
</script>

