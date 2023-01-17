<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_submitted" default="">
<cfparam name="attributes.asset_cat" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department_id" default="">
<cfquery name="GET_BRANCH" datasource="#dsn#">
	SELECT BRANCH_ID, BRANCH_NAME FROM BRANCH ORDER BY BRANCH_NAME
</cfquery>
<cfquery name="GET_ASSETP_CATS" datasource="#dsn#">
	SELECT ASSETP_CATID, ASSETP_CAT FROM ASSET_P_CAT WHERE MOTORIZED_VEHICLE = 1 ORDER BY ASSETP_CAT
</cfquery>
<cfif len(attributes.is_submitted)>
	<cfquery name="GET_ASSETP_VEHICLE" datasource="#dsn#">
		SELECT
			ASSET_P.ASSETP,
			ASSET_P.ASSETP_ID,
			ASSET_P_CAT.ASSETP_CAT,
			DEPARTMENT.DEPARTMENT_HEAD,
			BRANCH.BRANCH_NAME,
			ZONE.ZONE_NAME
		FROM
			ASSET_P,
			ASSET_P_CAT,
			DEPARTMENT,
			BRANCH,
			ZONE
		WHERE
			ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID AND 
			ASSET_P.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
			DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
			ZONE.ZONE_ID = BRANCH.ZONE_ID AND
			ASSET_P_CAT.MOTORIZED_VEHICLE = 1
			<cfif len(attributes.keyword)>AND ASSET_P.ASSETP LIKE '%#attributes.keyword#%'</cfif>
			<cfif len(attributes.asset_cat)>AND ASSET_P.ASSETP_CATID = #attributes.asset_cat#</cfif>
			<cfif len(attributes.branch_id)>AND BRANCH.BRANCH_ID = #attributes.branch_id#</cfif>
			<cfif len(attributes.department_id)>AND DEPARTMENT.DEPARTMENT_ID = #attributes.department_id#</cfif>
		ORDER BY
			ASSET_P.ASSETP
	</cfquery>
	<cfquery name="get_others" datasource="#dsn#">
	SELECT ASSETP_ID, KM_CONTROL_ID,KM_FINISH, EMPLOYEE_ID,RECORD_DATE FROM ASSET_P_KM_CONTROL 
	</cfquery>
	<cfparam name="attributes.totalrecords" default='#get_assetp_vehicle.recordcount#'>
<cfelse>
	<cfparam name="attributes.totalrecords" default='0'>
</cfif>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<script type="text/javascript">
	function gonder(id,name,km,record,driver,driver_id)
	{
	   <cfif isDefined("attributes.field_id")>
			opener.<cfoutput>#attributes.field_id#</cfoutput>.value=id;
		</cfif>
		<cfif isDefined("attributes.field_name")>
			opener.<cfoutput>#attributes.field_name#</cfoutput>.value=name;
		</cfif>
		<cfif isDefined("attributes.field_km")>
			opener.<cfoutput>#attributes.field_km#</cfoutput>.value=km;
		</cfif>
		<cfif isDefined("attributes.field_record")>
			opener.<cfoutput>#attributes.field_record#</cfoutput>.value=record;
		</cfif>
		<cfif isDefined("attributes.field_driver")>
			opener.<cfoutput>#attributes.field_driver#</cfoutput>.value=driver;
		</cfif>
		<cfif isDefined("attributes.field_driver_id")>
			opener.<cfoutput>#attributes.field_driver_id#</cfoutput>.value=driver_id;
		</cfif>
		window.close();
	}
</script>
<table width="98%" border="0" cellspacing="0" cellpadding="0" height="35" class="headbold" align="center">
  <tr><td><cf_get_lang dictionary_id='57414.Araçlar'></td>
	<td style="text-align:right;"><table>
	   <cfform name="search_asset" action="#request.self#?fuseaction=objects.popup_list_ship_vehicles3" method="post">
	 		<input type="hidden" name="field_id" id="field_id" value="<cfoutput>#attributes.field_id#</cfoutput>">
			<input type="hidden" name="field_name" id="field_name" value="<cfoutput>#attributes.field_name#</cfoutput>">
	 	 	<input type="hidden" name="field_km" id="field_km" value="<cfoutput>#attributes.field_km#</cfoutput>">
			<input type="hidden" name="field_record" id="field_record" value="<cfoutput>#attributes.field_record#</cfoutput>">
			<!--- <input type="hidden" name="field_driver" value="<cfoutput>#attributes.field_driver#</cfoutput>"> --->
			<!--- <input type="hidden" name="field_driver_id" value="<cfoutput>#attributes.field_driver_id#</cfoutput>"> --->
	 	 <!-- sil -->
        <tr>
		  <td><input type="hidden" name="is_submitted" id="is_submitted" value="1"><cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'></td>
        </tr>
		 <!-- sil -->
      </table>
	</td>
  </tr>
</table>
<table cellspacing="0" cellpadding="0" width="98%" border="0" align="center">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
        <tr height="22" class="color-row">
			<td style="text-align:right;" colspan="4">
			<table border="0">
			<!-- sil -->
			<tr>
			   <td><cf_get_lang dictionary_id='57460.Filtre'></td>
					<td><cfinput type="Text" maxlength="255" value="#attributes.keyword#" name="keyword"></td>
					<td>
                    <select name="asset_cat" id="asset_cat" style="width:100px;">
                        <option value=""><cf_get_lang dictionary_id='57486.Kategori'></option>
                        <cfoutput query="get_assetp_cats">
                        	<option value="#assetp_catid#" <cfif attributes.asset_cat eq assetp_catid>selected</cfif>>#assetp_cat#</option>
                        </cfoutput>
                    </select>
                    </td>
					<td><cf_get_lang dictionary_id='57453.Şube'></td>
				   <td><select name="branch_id" id="branch_id" style="width:100px;" onChange="redirect(this.value);">
					 <option value=""><cf_get_lang dictionary_id='57453.Şube'></option>
					 <cfoutput query="get_branch">
					 <option value="#branch_id#" <cfif branch_id eq attributes.branch_id>selected</cfif>>#branch_name#</option>
					 </cfoutput>
					 </select></td>
				  <td><cf_get_lang dictionary_id='57572.Departman'></td>
				 <td><select name="department_id" id="department_id" style="width:100px;">
					 <option value=""><cf_get_lang dictionary_id='57572.Departman'></option>
					 </select></td>
				<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></td>
				<td>
					<cf_wrk_search_button search_function='input_control()'>
					<input type="hidden" name="dept_id_selected" id="dept_id_selected" value=""></td>
				</tr>
				</cfform>
				<!-- sil -->
			</table>
			<!--- Arama --->
			</td>
		</tr>
	<tr height="22" class="color-header">		
        <td class="form-title" width="30"><cf_get_lang dictionary_id='57487.No'></td>
		<td width="200" class="form-title"><cf_get_lang dictionary_id='33356.Araç Adı'></td>
		<td width="200" class="form-title"><cf_get_lang dictionary_id='57486.Kategori'></td>
		<td width="200" class="form-title"><cf_get_lang dictionary_id='30031.Lokasyon'></td>
	</tr>
    <cfif len(attributes.is_submitted)>
		<cfif get_assetp_vehicle.recordcount>
		<cfoutput query="get_assetp_vehicle" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfquery dbtype="query" name="maxx" maxrows="1">
				SELECT * FROM get_others WHERE ASSETP_ID = #ASSETP_ID# ORDER BY KM_CONTROL_ID DESC
				</cfquery>
			<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td width="30">#currentrow#</td>
				<td><a href="javascript://" class="tableyazi"  onClick="gonder('#assetp_id#','#assetp#','#tlformat(maxx.km_finish)#','<cfif len(maxx.record_date)>#dateformat(maxx.record_date,dateformat_style)#<cfelse>#dateformat(now(),dateformat_style)#</cfif>','#get_emp_info(maxx.employee_id,0,0)#','#maxx.employee_id#')">#assetp#</a></td>
				<td>#assetp_cat#</td>
				<td>#department_head# / #branch_name#</td>
		</tr>
		</cfoutput>
	<cfelse>
	<tr class="color-row">
		<td colspan="4" height="20"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
	</tr>
	</cfif>
	<cfelse>
          <tr class="color-row">
            <td colspan="4" height="20"><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</td>
          </tr>
	</cfif>
</table>
</td>
</tr>
</table>
<!-- sil -->
<cfif attributes.maxrows lt attributes.totalrecords>
	<cfset url_string = "">
	<cfif isdefined("field_id")>
		<cfset url_string = "#url_string#&field_id=#attributes.field_id#">
	</cfif>
	<cfif isdefined("field_name")>
		<cfset url_string = "#url_string#&field_name=#attributes.field_name#">
	</cfif>
	<cfif isdefined("keyword")>
		<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
	</cfif>
	<cfif isdefined("asset_cat")>
		<cfset url_string = "#url_string#&asset_cat=#attributes.asset_cat#">
	</cfif>
	<cfif isdefined("is_submitted")>
		<cfset url_string = "#url_string#&is_submitted=#attributes.is_submitted#">
	</cfif>
	<cfif isdefined("branch_id")>
		<cfset url_string = "#url_string#&branch_id=#attributes.branch_id#">
	</cfif>
	<cfif isdefined("department_id")>
		<cfset url_string = "#url_string#&department_id=#attributes.department_id#">
	</cfif>
<table width="98%" border="0" cellpadding="0" cellspacing="0" height="35" align="center">
  <tr> 
    <td>
	<cf_pages 
		page="#attributes.page#" 
		maxrows="#attributes.maxrows#" 
		totalrecords="#attributes.totalrecords#" 
		startrow="#attributes.startrow#" 
		adres="logistic.popup_list_ship_vehicles#url_string#">
	</td>
    <td  style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang dictionary_id='57581.Sayfa'>#attributes.page#/#lastpage#</cfoutput></td>
  </tr>
</table>
</cfif>
<script type="text/javascript">
	function input_control()
		{
		document.search_asset.dept_id_selected.value = document.search_asset.department_id.selectedIndex;
		return true;
		}

	var groups=document.search_asset.branch_id.options.length
	var group=new Array(groups)
	for (i=0; i<groups; i++)
		group[i]=new Array()
		group[0][0]=new Option("Departman","");
		<cfset branch = ArrayNew(1)>
	<cfoutput query="get_branch">
		<cfset branch[currentrow]=#branch_id#>
	</cfoutput>
	<cfloop from="1" to="#ArrayLen(branch)#" index="indexer">
		<cfquery name="dep_names" datasource="#dsn#">
			SELECT * FROM DEPARTMENT WHERE BRANCH_ID = #branch[indexer]# ORDER BY DEPARTMENT_HEAD
		</cfquery>
		<cfif dep_names.recordcount>
		<cfset deg = 0>
		<cfoutput>group[#indexer#][#deg#]=new Option("Departman","");</cfoutput>
			<cfoutput query="dep_names">
				<cfset deg = currentrow>
					<cfif dep_names.recordcount>
						group[#indexer#][#deg#]=new Option("#department_head#","#department_id#");
					</cfif>
			</cfoutput>
		<cfelse>
		<cfset deg = 0>
		<cfoutput>
		group[#indexer#][#deg#]=new Option("<cf_get_lang dictionary_id='58836.Lutfen Departman Seciniz'>","");
		</cfoutput>
	</cfif>
	</cfloop>
	
	var temp = document.search_asset.department_id
	function redirect(x)
	{
		for (m=temp.options.length-1;m>0;m--)
		temp.options[m]=null
		for (i=0;i<group[x].length;i++)
		{
			temp.options[i]=new Option(group[x][i].text,group[x][i].value)
		}
	}
	
	<cfif len(attributes.branch_id)>
		redirect(document.search_asset.branch_id.selectedIndex);
		document.search_asset.department_id.selectedIndex = <cfoutput>#attributes.dept_id_selected#</cfoutput>
	</cfif>
</script>
<!-- sil -->
