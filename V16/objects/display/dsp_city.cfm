<!--- Bu sayfanın aynısı OBJECTS 2 klasöründe de bulunmaktadır. Yapılan Değişikler oraya da yansıtılmalıdır. M.E. 20061027--->
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.index" default="0">
<cfquery name="GET_CITY" datasource="#DSN#">
	SELECT
		CITY_NAME,
		CITY_ID,
		PHONE_CODE
	FROM
		SETUP_CITY
	WHERE
		CITY_NAME IS NOT NULL
		<cfif isdefined("attributes.country_id")>AND COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country_id#"></cfif>
		<cfif len(attributes.keyword)>AND CITY_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"></cfif>
	ORDER BY
		CITY_NAME
</cfquery>
<cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfset url_str = "&field_name=#attributes.field_name#&field_id=#attributes.field_id#">
<cfif isdefined("attributes.country_id")>
	<cfset url_str = "#url_str#&country_id=#attributes.country_id#">
</cfif>
<cfif isdefined("attributes.field_phone_code")>
	<cfset url_str = "#url_str#&field_phone_code=#attributes.field_phone_code#">
</cfif>
<cfif isdefined("attributes.field_phone_code2")>
	<cfset url_str = "#url_str#&field_phone_code2=#attributes.field_phone_code2#">
</cfif>
<cfif isdefined("attributes.coklu_secim")>
	<cfset url_str = "#url_str#&coklu_secim=#attributes.coklu_secim#">
</cfif>
<script type="text/javascript">
	<cfif not isdefined("attributes.coklu_secim")>
		function gonder(city_id,city,phone_code)
		{
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value=city;
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value=city_id;
			<cfif isdefined("attributes.field_phone_code")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_phone_code#</cfoutput>.value=phone_code;
			</cfif>
			<cfif isdefined("attributes.field_phone_code2")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_phone_code2#</cfoutput>.value=phone_code;
			</cfif>
			<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
		}
	<cfelse>
		function gonder(city_id,city,phone_code)
		{
			var kontrol =0;
			var  select = <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>[<cfoutput>#attributes.index#</cfoutput>];
			uzunluk=<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length;
			/* for(i=0;i<uzunluk;i++){
				if(<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[i].value==city_id){
					kontrol=1;
				}
			} */
			
			if(kontrol==0)
			{
				<cfif isDefined("attributes.field_name")>
					x = <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length;
					<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length = parseInt(x + 1);
						var opt = document.createElement('option');
						opt.value = city_id;;
						opt.innerHTML = city;
						select.appendChild(opt);

					<!--- <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[x].value = city_id;
					<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[x].text = city; --->
				</cfif>
			}
		}
	</cfif>
</script>

<cf_box title="#getLang('','İl',58608)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="search_form" method="post" action="#request.self#?fuseaction=objects.popup_dsp_city#url_str#">
		<input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
		<cf_box_search more="0">
			<div class="form-group small" id="item-keyword">
				<input type="text" name="keyword" id="keyword" placeholder="<cfoutput>#getLang('','Filtre',57460)#</cfoutput>" value="<cfoutput>#attributes.keyword#</cfoutput>">
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_form' , #attributes.modal_id#)"),DE(""))#">
			</div>
		</cf_box_search>
	</cfform>
	<cf_flat_list>
		<thead>
			<tr>		
				<th><cf_get_lang dictionary_id='57487.No'></th>
				<th><cf_get_lang dictionary_id='58608.İl'></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_city.recordcount and form_varmi eq 1>
				<cfoutput query="get_city">
					<cfset city_name_= Replace(get_city.city_name,"'"," ","all")>
					<tr>
						<td width="30">#currentrow#</td>
						<td><a href="javascript://" class="tableyazi" onClick="gonder('#city_id#','#trim(city_name_)#','#phone_code#')">#city_name_#</a></td>
					</tr>		
				</cfoutput>
				<cfelse>
					<tr>
						<td colspan="2"><cfif form_varmi eq 0><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</cfif></td>
					</tr>
			</cfif>
			<cfif len(attributes.keyword)>
				<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
			</cfif>
		</tbody>
	</cf_flat_list>
</cf_box>
<script type="text/javascript">
	$(document).ready(function(){
    $( "#keyword" ).focus();
});
</script>
