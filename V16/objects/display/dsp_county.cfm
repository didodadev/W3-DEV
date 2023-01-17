<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.index" default="0">
<cfif isdefined("attributes.city_id") and len(attributes.city_id)>
	<cfquery name="GET_CITY" datasource="#DSN#">
		SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID IN (#attributes.city_id#)
	</cfquery>
</cfif>
<cfquery name="GET_COUNTY" datasource="#DSN#">
	SELECT
		SC.COUNTY_ID,
		SC.COUNTY_NAME,
		S.CITY_NAME
	FROM
		SETUP_COUNTY SC,
		SETUP_CITY S
	WHERE
		SC.CITY = S.CITY_ID
		<cfif isdefined("attributes.city_id") and len(attributes.city_id)>AND SC.CITY IN (#attributes.city_id#)</cfif>
		<cfif len(attributes.keyword)>AND SC.COUNTY_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"></cfif>
	ORDER BY
		S.CITY_NAME,
		SC.COUNTY_NAME
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_county.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<script type="text/javascript">
	<cfif not isdefined("attributes.coklu_secim")>
		function gonder(id,name)
		{
		   <cfif isDefined("attributes.field_id")>
				<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value=id;
			</cfif>
			<cfif isDefined("attributes.field_name")>
				<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value=name;
			</cfif>
			<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
		}
	<cfelse>
		function gonder(county_id,county)
		{
			var kontrol =0;
			var  select = <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>[<cfoutput>#attributes.index#</cfoutput>];
			uzunluk=<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length;
			/* for(i=0;i<uzunluk;i++)
			{
				if(<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[i].value==county_id)
				{
					kontrol=1;
				}
			} */
			if(kontrol==0)
			{
				<cfif isDefined("attributes.field_name")>
					x = <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length;
					<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length = parseInt(x + 1);
						var opt = document.createElement('option');
						opt.value = county_id;;
						opt.innerHTML = county;
						select.appendChild(opt);
					<!--- <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[x].value = county_id;
					<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[x].text = county; --->
				</cfif>
			}
		}
	</cfif>
</script>
<cfscript>
	url_string = '';
	if (isdefined('attributes.field_id')) url_string = '#url_string#&field_id=#attributes.field_id#';
	if (isdefined('attributes.field_name')) url_string = '#url_string#&field_name=#attributes.field_name#';
	if (isdefined('attributes.coklu_secim')) url_string = '#url_string#&coklu_secim=#attributes.coklu_secim#';
</cfscript>

<cfsavecontent variable="title_"><cf_get_lang dictionary_id="58608.İl">/<cf_get_lang dictionary_id='58638.İlçe'></cfsavecontent>
<cf_box title="#title_#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfsavecontent variable="header_">
		<cf_get_lang dictionary_id='33335.İlçeler'>
		<cfif isdefined("attributes.city_id") and len(attributes.city_id) and listlen(attributes.city_id,',') lt 2>: <cfoutput>#get_city.city_name#</cfoutput></cfif>
	</cfsavecontent>
	<cfform name="search" method="post" action="#request.self#?fuseaction=objects.popup_dsp_county&#url_string#">
		<input type="hidden" name="field_id" id="field_id" value="<cfoutput>#attributes.field_id#</cfoutput>">
		<input type="hidden" name="field_name" id="field_name" value="<cfoutput>#attributes.field_name#</cfoutput>">
		<cf_box_search title="#header_#" more="0">
			<div class="form-group" id="item-keyword">
				<cfinput type="text" name="keyword" value="#attributes.keyword#" placeholder="#getLang('','Filtre',57460)#" maxlength="255">
			</div>
			<div class="form-group small">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" style="width:25px;" onKeyUp="isNumber(this)" maxlength="3" value="#attributes.maxrows#" validate="integer" range="1," required="yes" message="#message#">
			</div> 
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search' , #attributes.modal_id#)"),DE(""))#">
			</div>
		</cf_box_search>
	</cfform>
	<cf_grid_list>
		<thead>
			<tr>		
				<th width="30"><cf_get_lang dictionary_id='57487.No'></th>
				<th><cf_get_lang dictionary_id='58608.İl'></th>
				<th><cf_get_lang dictionary_id='58638.İlçe'></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_county.recordcount>
				<cfoutput query="get_county" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">		
					<tr>
						<td>#currentrow#</td>
						<td>#city_name#</td>
						<td><a href="javascript://" class="tableyazi"  onClick="gonder('#county_id#','#county_name#')">#county_name#</a></td>
					</tr>		
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="3" height="20"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
	<cfif get_county.recordcount>
		<cfset adres='objects.popup_dsp_county'>
		<cfif isdefined("attributes.keyword")>
			<cfset adres = "#adres#&keyword=#attributes.keyword#">
		</cfif>
		<cfif isdefined("attributes.field_id")>
			<cfset adres = "#adres#&field_id=#attributes.field_id#">
		</cfif>
		<cfif isdefined("attributes.field_name")>
			<cfset adres = "#adres#&field_name=#attributes.field_name#">
		</cfif>
		<cfif isdefined("attributes.coklu_secim")>
			<cfset adres = "#adres#&coklu_secim=#attributes.coklu_secim#">
		</cfif>
		<cfif isdefined("attributes.city_id")>
			<cfset adres = "#adres#&city_id=#attributes.city_id#">
		</cfif>
		<cfif isdefined("attributes.index")>
			<cfset adres = "#adres#&index=#attributes.index#">
		</cfif>
		<cf_paging 
				page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#adres#"
				isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
	</cfif>
</cf_box>
