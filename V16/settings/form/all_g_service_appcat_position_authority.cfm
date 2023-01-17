<!--- FBS 20091021 Sikayet Alt ve Alt Tree Kategorilerinde Calisanlara Yetki Vermek Icin Olusturulmustur --->

<cf_get_lang_set module_name="settings"><!--- sayfanin en altinda kapanisi var --->
<cfparam name="attributes.position_id" default="">
<cfparam name="attributes.position_code" default="">
<cfparam name="attributes.position_name" default="">
<cfset mode_ = 6>

<cfif isdefined("attributes.submitted")>
	<cfquery name="get_all_appcat_sub" datasource="#dsn#"><!--- Sikayet Alt Kategorileri --->
		SELECT
			GS.SERVICE_SUB_CAT_ID,
			GS.SERVICE_SUB_CAT,
			GSS.SERVICE_SUB_STATUS_ID,
			GSS.SERVICE_SUB_STATUS
		FROM
			G_SERVICE_APPCAT_SUB GS,
			G_SERVICE_APPCAT_SUB_STATUS GSS
		WHERE
			GS.SERVICE_SUB_CAT_ID = GSS.SERVICE_SUB_CAT_ID
		ORDER BY
			GS.SERVICE_SUB_CAT_ID
	</cfquery>
	
	<cfquery name="get_all_appcat_sub_pos" datasource="#dsn#"><!--- Alt Kategori Yetkilileri --->
		SELECT 	SERVICE_SUB_CAT_ID,POSITION_CODE FROM G_SERVICE_APPCAT_SUB_POSTS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#"> ORDER BY SERVICE_SUB_CAT_ID
	</cfquery>
	<cfset appcat_sub_pos_list = listsort(listdeleteduplicates(valuelist(get_all_appcat_sub_pos.service_sub_cat_id,',')),'numeric','ASC',',')>
	
	<cfquery name="get_all_appcat_sub_status_pos" datasource="#dsn#"><!--- Alt Tree Kategori Yetkilileri --->
		SELECT 	SERVICE_SUB_STATUS_ID,POSITION_CODE FROM G_SERVICE_APPCAT_SUB_STATUS_POST WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#"> ORDER BY SERVICE_SUB_STATUS_ID
	</cfquery>
	<cfset appcat_sub_status_pos_list = listsort(listdeleteduplicates(valuelist(get_all_appcat_sub_status_pos.service_sub_status_id,',')),'numeric','ASC',',')>
</cfif>
<br/>
<cfsavecontent  variable="head"><cf_get_lang no='939.Şikayet Kategorileri'><cf_get_lang no='1781.Yetki Verme'></cfsavecontent>
<cf_box title="#head#" >
		
			<cfform name="search_position" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
				<input type="hidden" name="submitted" id="submitted" value="1">
				<cf_box_elements>
					<div class="form-group" >
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='164.Çalışan'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfoutput>
									<input type="hidden" name="position_id" id="position_id" value="#attributes.position_id#">
									<input type="hidden" name="position_code" id="position_code" value="#attributes.position_code#">
									<input type="text" name="position_name" id="position_name" value="#attributes.position_name#" style="width:150px;">
									<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_name=search_position.position_name&field_code=search_position.position_code&field_id=search_position.position_id&select_list=1','list');"></span>
								
								</cfoutput> 
							</div>
						</div>
					</div>
					
					<div class="form-group">
						<cf_wrk_search_button search_function='kontrol()' is_excel='0' button_type="5">

					</div>
			</cf_box_elements>
			</cfform>
		
</cf_box>

<script type="text/javascript">
	function kontrol()
	{
		if(document.search_position.position_name.value =='')
		{	
			document.search_position.position_code.value = '';
			document.search_position.position_id.value = '';
			alert("<cf_get_lang no ='1454.Lütfen Çalışan Seçiniz'>!");
			return false;
		}
	return true; 
	}
</script>

<cfif isdefined("attributes.submitted")>
	<cf_box title="#getlang('','Şikayet Alt Kategorileri','42923')#">

				<cfform name="search_sub" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
					<cfoutput>
					<input type="hidden" name="submitted_1" id="submitted_1" value="1">
					<input type="hidden" name="position_code" id="position_code" value="#attributes.position_code#">
					<input type="hidden" name="position_id" id="position_id" value="#attributes.position_id#">
					<input type="hidden" name="position_name" id="position_name" value="#attributes.position_name#">
					</cfoutput>
					<cfset count_main_ = 0>
					<cfoutput query="get_all_appcat_sub" group="service_sub_cat_id">
						<cfset count_main_ = count_main_ + 1>
						<cfif (count_main_ eq 1) or count_main_ mod mode_ eq 1><tr height="25"></cfif>
							<td width="200">
								<input type="checkbox" name="sub_id" id="sub_id" value="#get_all_appcat_sub.service_sub_cat_id#" <cfif listfind(appcat_sub_pos_list,service_sub_cat_id,',') neq 0>checked</cfif>>
								#get_all_appcat_sub.service_sub_cat#
							</td>
						<cfif count_main_ mod mode_ eq 0></tr></cfif>
					</cfoutput>
					<tr height="35">
						<cfoutput>
						<td colspan="2">&nbsp;</td>
						<td width="200"><input type="checkbox" name="all_sub" id="all_sub" value="1" onClick="hepsini_sec(#count_main_#,1);"><cf_get_lang no='705.Hepsini Seç'></td>						
						<td><cf_workcube_buttons is_upd="0" is_cancel='0' add_function='gonder(#count_main_#,1)'></td>
						</cfoutput>
					</tr>
				</cfform>	
</cf_box>
<cf_box title="#getlang('','Şikayet Alt Tree Kategorileri','42924')#">

				<cfform name="search_sub_status" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
					<cfoutput>
					<input type="hidden" name="submitted_2" id="submitted_2" value="1">
					<input type="hidden" name="position_code" id="position_code" value="#attributes.position_code#">
					<input type="hidden" name="position_id" id="position_id" value="#attributes.position_id#">
					<input type="hidden" name="position_name" id="position_name" value="#attributes.position_name#">
					</cfoutput>
					<cfoutput query="get_all_appcat_sub" group="service_sub_cat_id">
						<tr height="25">
							<td colspan="6">#get_all_appcat_sub.service_sub_cat#</td>
						</tr>
						<tr height="25">
							<cfset count_ = 0>
							<cfoutput>
								<cfset count_ = count_ + 1>
								<td width="200">
									<input type="checkbox" name="sub_status_id" id="sub_status_id" value="#get_all_appcat_sub.service_sub_status_id#" <cfif listfind(appcat_sub_status_pos_list,service_sub_status_id,',') neq 0>checked</cfif>>
									#get_all_appcat_sub.service_sub_status#
								</td>
								<cfif count_ mod mode_ eq 0></tr></cfif>
							</cfoutput>
					</cfoutput>
					<tr height="35">
						<cfoutput>
						<td colspan="2">&nbsp;</td>
						<td width="200"><input type="checkbox" name="all_sub_status" id="all_sub_status" value="1" onClick="hepsini_sec(#get_all_appcat_sub.recordcount#,2);"><cf_get_lang no='705.Hepsini Seç'></td>						
						<td><cf_workcube_buttons is_upd="0" is_cancel='0' add_function='gonder(#get_all_appcat_sub.recordcount#,2)'></td>
						</cfoutput>
					</tr>
				</cfform>
</cf_box>
	<script type="text/javascript">
		function gonder(toplam,a)
		{
			deger_1 = 0;
			deger_2 = 0;
			for(dgr=0; dgr < toplam; dgr++)
			{
				if(toplam != 1)
				{
					if(a == 1 && document.search_sub.sub_id[dgr].checked == true)
					{
						deger_1++;
						break;							
					}
					if(a == 2 && document.search_sub_status.sub_status_id[dgr].checked == true)
					{
						deger_2++;
						break;							
					}
				}
				else
				{
					if(a == 1 && document.search_sub.sub_id.checked == true)
					{
						deger_1++;
						break;							
					}
					if(a == 2 && document.search_sub_status.sub_status_id.checked == true)
					{
						deger_2++;
						break;							
					}
				}
			}
			if((a == 1 && deger_1 == 0) || (a == 2 && deger_2 == 0))
			{
				alert("<cf_get_lang no ='2023.Kaydetmek İçin En Az Bir Seçim Yapmalısınız'> !");
				return false;
			}
			
			if(confirm("<cf_get_lang no ='2024.Bu Çalışana Ait Değiklikleri Onaylıyor Musunuz'>?"))
				return true;
			else
				return false;	
		}
		
		function hepsini_sec(total,y)
		{
			if((y == 1 && document.search_sub.all_sub.checked == true) || (y == 2 && document.search_sub_status.all_sub_status.checked == true))
			{	
				for(say=0;say < total;say++)
					if(y == 1)
					{
						if(total != 1)
							document.search_sub.sub_id[say].checked = true;
						else
							document.search_sub.sub_id.checked = true;	
					}
					else
					{
						if(total != 1)	
							document.search_sub_status.sub_status_id[say].checked = true;
						else
							document.search_sub_status.sub_status_id.checked = true;
					}
			}
			else
			{
				for(say=0;say < total;say++)
					if(y == 1)
					{
						if(total != 1)
							document.search_sub.sub_id[say].checked = false;
						else
							document.search_sub.sub_id.checked = false;
					}
					else
					{
						if(total != 1)
							document.search_sub_status.sub_status_id[say].checked = false;
						else
							document.search_sub_status.sub_status_id.checked = false;
					}
			}
			return false;
		}
	</script>
</cfif>

<cfif isdefined("attributes.submitted_1") and attributes.submitted_1 eq 1>
	<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="del_all_sub_pos" datasource="#dsn#">
			DELETE FROM G_SERVICE_APPCAT_SUB_POSTS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#">
		</cfquery>
		<cfloop list="#attributes.sub_id#" index="sub">
			<cfquery name="add_sub_pos" datasource="#dsn#">
				INSERT INTO
					G_SERVICE_APPCAT_SUB_POSTS
				(
					SERVICE_SUB_CAT_ID,
					POSITION_CODE
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#sub#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#">
				)
			</cfquery>
		</cfloop>
	</cftransaction>
	</cflock>
</cfif>
<cfif isdefined("attributes.submitted_2") and attributes.submitted_2 eq 1>
	<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="del_all_sub_status_pos" datasource="#dsn#">
			DELETE FROM G_SERVICE_APPCAT_SUB_STATUS_POST WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#">
		</cfquery>
		<cfloop list="#attributes.sub_status_id#" index="status">
			<cfquery name="add_sub_pos" datasource="#dsn#">
				INSERT INTO
					G_SERVICE_APPCAT_SUB_STATUS_POST
				(
					SERVICE_SUB_STATUS_ID,
					POSITION_CODE
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#status#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#">
				)
			</cfquery>
		</cfloop>
	</cftransaction>
	</cflock>
</cfif>

<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
