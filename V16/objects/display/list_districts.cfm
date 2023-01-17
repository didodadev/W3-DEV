<cfparam name="attributes.keyword" default="">
<cfquery name="GET_DISTRICT" datasource="#dsn#">
	SELECT 
		SD.*,
		SC.COUNTY_NAME,
        (SELECT IMS_CODE FROM SETUP_IMS_CODE WHERE IMS_CODE_ID = SD.IMS_CODE_ID) IMS_CODE,
        (SELECT IMS_CODE_NAME FROM SETUP_IMS_CODE WHERE IMS_CODE_ID = SD.IMS_CODE_ID) IMS_CODE_NAME       
	FROM 
		SETUP_DISTRICT SD,
		SETUP_COUNTY SC
	WHERE
		SD.COUNTY_ID = SC.COUNTY_ID
		<cfif isDefined("attributes.county_id") and len(attributes.county_id)>
			AND SC.COUNTY_ID IN (#attributes.county_id#)
		</cfif>
		<cfif len(attributes.keyword)>
			AND (DISTRICT_NAME LIKE '%#attributes.keyword#%' OR SC.COUNTY_NAME LIKE '%#attributes.keyword#%')
		</cfif>
	ORDER BY 
		SC.COUNTY_NAME,
		SD.DISTRICT_NAME
</cfquery>
<cfif isdefined('attributes.team_id')>
    <cfquery name="GET_SALES_ZONES_TEAM" datasource="#DSN#">
    	SELECT SZTD.DISTRICT_ID FROM SALES_ZONES_TEAM_DISTRICT SZTD WHERE SZTD.TEAM_ID = #attributes.team_id#
    </cfquery>
</cfif>
<cfparam name='attributes.totalrecords' default="#get_district.recordcount#">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="title_"><cf_get_lang dictionary_id='43768.Mahalleler'> / <cf_get_lang dictionary_id='43769.Köyler'></cfsavecontent>
	<cf_box title="#title_#" scroll="1" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfoutput>
			<cfif isdefined('attributes.team_id')>
				<cfset action_name="#request.self#?fuseaction=objects.popup_list_districts&team_id=#attributes.team_id#">
			<cfelse>
				<cfset action_name="#request.self#?fuseaction=objects.popup_list_districts">
			</cfif>
		</cfoutput>
		<cfform name="search" method="post" action='#action_name#'>
			<cf_box_search>
				<cfif isDefined("attributes.county_id") and len(attributes.county_id)>
					<cfinput type="hidden" name="county_id" value="#attributes.county_id#">
				</cfif>
				<cfinput type="hidden" name="field_name" value="#attributes.field_name#">
				<cfif isdefined("attributes.field_ims")>
					<cfinput type="hidden" name="field_ims" value="#attributes.field_ims#">
				</cfif>
				<div class="form-group" id="item-keyword">
					<cfinput type="text" name="keyword" placeholder="#getLang('','Filtre',57460)#" value="#attributes.keyword#" maxlength="255">
				</div>	
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
		</cfform>
		<form name="get_county" action="" method="post">
			<cf_grid_list>
				<thead>
					<tr>
						<th width="30"><cf_get_lang dictionary_id='57487.No'></th>
						<th><cf_get_lang dictionary_id='58638.İlçe'></th>
						<th><cf_get_lang dictionary_id='58735.Mahalle'></th>
						<cfif get_district.recordcount><th width="20" class="text-center"><input type="checkbox" name="all_select" id="all_select" onclick="All_Checked()" /></th></cfif>
					</tr>
				</thead>
				<cfif get_district.recordcount>
					<cfoutput query="get_district" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tbody>
						<tr id="#currentrow#">
							<input type="hidden" name="district_id" id="district_id" value="#district_id#" />
							<input type="hidden" name="district_name" id="district_name" value="#district_name#" />
							<input type="hidden" name="county_name" id="county_name" value="#county_name#" />
							<input type="hidden" name="ims_code_id" id="ims_code_id" value="#ims_code_id#" />
							<input type="hidden" name="ims_code" id="ims_code" value="#ims_code#" />
							<input type="hidden" name="ims_code_name" id="ims_code_name" value="#ims_code_name#" />
							<td>#currentrow#</td>
							<td>#county_name#</td>
							<td>#district_name#</a></td>
							<td class="text-center"><input type="checkbox" name="select_id" id="select_id" <cfif isdefined('attributes.team_id')><cfif listfind(valuelist(get_sales_zones_team.district_id),district_id)>checked="checked"</cfif></cfif>/></td>
						</tr>
					</tbody>
					</cfoutput>
					<tfoot>
						<tr>
							<td colspan="4"><input type="button" class="ui-wrk-btn ui-wrk-btn-success" value="<cf_get_lang dictionary_id='57461.Kaydet'>" onClick="add_checked();"></td>
						</tr>
					</tfoot>
				<cfelse>
					<tbody>
						<tr class="color-row">
							<td height="20" colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
						</tr>
					</tbody>
				</cfif>
			</cf_grid_list>
		</form>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset url_str = "">
			<cfif len(attributes.keyword)>
				<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
			</cfif>
			<cfif len(attributes.field_name)>
				<cfset url_str = "#url_str#&field_name=#attributes.field_name#">
			</cfif>
			<cfif isDefined("attributes.county_id") and len(attributes.county_id)>
				<cfset url_str = "#url_str#&county_id=#attributes.county_id#">
			</cfif>
			<cfif isdefined("attributes.field_ims") and len(attributes.field_ims)>
				<cfset url_str = "#url_str#&field_ims=#attributes.field_ims#">
			</cfif> 
			<cfif isdefined('attributes.team_id') and len(attributes.team_id)>
				<cfset url_str="#url_str#&team_id=#attributes.team_id#">
			</cfif>   
			<cfif isDefined("attributes.draggable") and len(attributes.draggable)>
				<cfset url_str = '#url_str#&draggable=#attributes.draggable#'>
			</cfif>
			<cf_paging 
				page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="objects.popup_list_districts#url_str#"
				isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	search.keyword.focus();
		function add_checked()
		{
			counter=0;
			if(document.all.select_id.length != undefined)
			{
					for(i=0;i<document.all.select_id.length;i++) 
					if (get_county.select_id[i].checked == true) 
					{
						counter=counter+1;
						<cfif isDefined("attributes.field_name")>
								x = <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length;
								<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length = parseInt(x + 1);
								<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>. <cfoutput>#attributes.field_name#</cfoutput>.options[x].value = get_county.district_id[i].value;
								<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[x].text = get_county.county_name[i].value+' '+get_county.district_name[i].value;
						</cfif>
						<cfif isdefined("field_ims")>
							<cfif isDefined("attributes.field_ims")>
									x = <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_ims#</cfoutput>.length;
									<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_ims#</cfoutput>.length = parseInt(x + 1);
									<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>. <cfoutput>#attributes.field_ims#</cfoutput>.options[x].value = get_county.ims_code_id[i].value;
									<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_ims#</cfoutput>.options[x].text = get_county.ims_code[i].value+' '+get_county.ims_code_name[i].value;				
							</cfif>
						</cfif>
					}
				if (counter == 0)
				{
					alert("<cf_get_lang dictionary_id='35679.Lütfen Mahalle Seçiniz!'>");
					return false;
				}
			}
			else
			{
				if(get_county.select_id.checked==true)
				{
					<cfif isDefined("attributes.field_name")>
						x = <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length;
						<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length = parseInt(x + 1);
						<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>. <cfoutput>#attributes.field_name#</cfoutput>.options[x].value = document.getElementById('district_id').value;
						<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[x].text = document.getElementById('county_name').value+' '+document.getElementById('district_name').value;
					</cfif>
					<cfif isdefined("field_ims")>
						<cfif isDefined("attributes.field_ims")>
								x = <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_ims#</cfoutput>.length;
								<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_ims#</cfoutput>.length = parseInt(x + 1);
								<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>. <cfoutput>#attributes.field_ims#</cfoutput>.options[x].value = document.getElementById('ims_code_id').value;
								<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_ims#</cfoutput>.options[x].text = document.getElementById('ims_code').value+' '+document.getElementById('ims_code_name').value;				
						</cfif>
					</cfif>
				}
				else
				{
					alert("<cf_get_lang dictionary_id='35679.Lütfen Mahalle Seçiniz!'>");
					return false;
				}
			}
		}
		function All_Checked()
		{
			if(document.getElementById('all_select').checked)
			{
				<cfif get_district.recordcount gt 1  and attributes.maxrows neq 1>	
					for(i=0;i<document.all.select_id.length;i++) document.all.select_id[i].checked = true;
				<cfelseif get_district.recordcount eq 1 or  attributes.maxrows eq 1>
					document.all.select_id.checked = true;
				</cfif>
			}
			else
			{
				<cfif get_district.recordcount gt 1  and attributes.maxrows neq 1>	
					for(i=0;i<document.all.select_id.length;i++) document.all.select_id[i].checked = false;
				<cfelseif get_district.recordcount eq 1 or  attributes.maxrows eq 1>
					document.all.select_id.checked = false;
				</cfif>
			}
		}
</script>
