<cfsetting showdebugoutput="no">
<!-- sil -->
<table height="30">
	<form name="pdf_flash">
	<tr>
		<td><cfoutput><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_convertpdf&special_module=1&module=hr_wg_draw_div&ispdf=1&page_height='+ document.pdf_flash.my_page_height.value +'&page_width=' + document.pdf_flash.my_page_width.value,'small','popup_convertpdf')"><img src="/images/pdf.gif" title="Pdf Yap" border="0"></a></cfoutput></td>
	</tr>
	<hr />
	<input type="hidden" value="35" name="my_page_width" id="my_page_width">
	<input type="hidden" value="35" name="my_page_height" id="my_page_height">
	</form>
</table>
<!-- sil -->
<div id="hr_wg_draw_div">
<cfset my_hierarchy = attributes.hierarchy_code>
<cfset grup_uzunlugu = listlen(my_hierarchy,'.')>
 <cfif grup_uzunlugu gt 1>
	<cfset ust_grup_hiearchy = left(my_hierarchy,len(my_hierarchy) - (len(listlast(my_hierarchy,'.')) + 1))>
	<cfquery name="get_my_workgroup_ust" datasource="#dsn#">
		SELECT 
            WORKGROUP_ID, 
            WORKGROUP_NAME, 
            GOAL, 
            ONLINE_HELP, 
            ONLINE_SALES, 
            COMPANY_ID, 
            PROJECT_ID, 
            OPP_ID, 
            STATUS, 
            RECORD_EMP, 
            RECORD_DATE, 
            RECORD_IP, 
            HIERARCHY, 
            UPPER_WORKGROUP_ID, 
            WORKGROUP_TYPE_ID, 
            MANAGER_POSITION_CODE, 
            IS_ORG_VIEW, 
            MANAGER_ROLE_HEAD, 
            MANAGER_EMP_ID, 
            DEPARTMENT_ID, 
            BRANCH_ID, 
            OUR_COMPANY_ID, 
            HEADQUARTERS_ID, 
            UPDATE_DATE, 
            UPDATE_IP, 
            UPDATE_EMP, 
            PRINT_STEP, 
            SUB_WORKGROUP, 
            SPONSOR_EMP_ID, 
            STATION_ID, 
            IS_BUDGET 
        FROM 
        	WORK_GROUP 
        WHERE 
        	HIERARCHY = '#ust_grup_hiearchy#' AND IS_ORG_VIEW = 1
	</cfquery>
</cfif> 
<cfquery name="get_all_workgroup_roles" datasource="#dsn#">
	SELECT 
		WORKGROUP_ID, 
        WORKGROUP_NAME, 
        GOAL, 
        ONLINE_HELP, 
        ONLINE_SALES, 
        COMPANY_ID, 
        PROJECT_ID, 
        OPP_ID, 
        STATUS, 
        RECORD_EMP, 
        RECORD_DATE, 
        RECORD_IP, 
        HIERARCHY, 
        UPPER_WORKGROUP_ID, 
        WORKGROUP_TYPE_ID, 
        MANAGER_POSITION_CODE, 
        IS_ORG_VIEW, 
        MANAGER_ROLE_HEAD, 
        MANAGER_EMP_ID, 
        DEPARTMENT_ID, 
        BRANCH_ID, 
        OUR_COMPANY_ID, 
        HEADQUARTERS_ID, 
        UPDATE_DATE, 
        UPDATE_IP, 
        UPDATE_EMP, 
        PRINT_STEP, 
        SUB_WORKGROUP, 
        SPONSOR_EMP_ID, 
        STATION_ID, 
        IS_BUDGET 
	FROM 
		WORK_GROUP
	WHERE 
		HIERARCHY LIKE '#my_hierarchy#.%'
	ORDER BY HIERARCHY
</cfquery>

<cfquery name="get_my_workgroup" datasource="#dsn#">
	SELECT 
		WORKGROUP_ID, 
        WORKGROUP_NAME, 
        GOAL, 
        ONLINE_HELP, 
        ONLINE_SALES, 
        COMPANY_ID, 
        PROJECT_ID, 
        OPP_ID, 
        STATUS, 
        RECORD_EMP, 
        RECORD_DATE, 
        RECORD_IP, 
        HIERARCHY, 
        UPPER_WORKGROUP_ID, 
        WORKGROUP_TYPE_ID, 
        MANAGER_POSITION_CODE, 
        IS_ORG_VIEW, 
        MANAGER_ROLE_HEAD, 
        MANAGER_EMP_ID, 
        DEPARTMENT_ID, 
        BRANCH_ID, 
        OUR_COMPANY_ID, 
        HEADQUARTERS_ID, 
        UPDATE_DATE, 
        UPDATE_IP, 
        UPDATE_EMP, 
        PRINT_STEP, 
        SUB_WORKGROUP, 
        SPONSOR_EMP_ID, 
        STATION_ID, 
        IS_BUDGET
	FROM 
		WORK_GROUP
	WHERE 
		HIERARCHY = '#my_hierarchy#'
</cfquery>

<cfquery name="get_all_workgroup_roles_ters" dbtype="query">
	SELECT * FROM get_all_workgroup_roles ORDER BY HIERARCHY DESC
</cfquery>

<cfset my_top_eklenti = 5>
<cfset kademe_sayisi = 0>
<cfset kademe_carpani = 20>
<cfset kutu_yuksekligi = 100>
<cfset my_default_hie = listlen(get_my_workgroup.hierarchy,'.') + 1>

<cffunction name="draw_div" returntype="string">
	<cfargument name="WORKGROUP_ID" type="numeric" required="true">
	<cfargument name="last_hie" type="numeric" required="true">
	<cfquery name="get_group_bilgi" dbtype="query">
		SELECT * FROM get_all_workgroup_roles WHERE WORKGROUP_ID = #arguments.WORKGROUP_ID#
	</cfquery>
	<cfquery name="get_group_bilgi3" dbtype="query">
		SELECT * FROM get_all_workgroup_roles WHERE WORKGROUP_ID <> #arguments.WORKGROUP_ID# AND HIERARCHY LIKE '#get_group_bilgi.hierarchy#.%'
	</cfquery>
	
	<cfif last_hie neq 0>
		<cfif (listlen(get_group_bilgi.hierarchy,'.') gt last_hie)>
			<cfset my_left = my_left>
		<cfelseif (listlen(get_group_bilgi.hierarchy,'.') lt last_hie)>
			<cfset my_left = my_left + 175>
		<cfelseif (listlen(get_group_bilgi.hierarchy,'.') eq last_hie)>
			<cfset my_left = my_left + 175>
		</cfif>
	<cfelse>
		<cfset my_left = 30>
	</cfif>
	
	<cfscript>
		div_spe = 'border: 1px';
		if(len(get_group_bilgi.MANAGER_EMP_ID)) calisan = '#get_emp_info(get_group_bilgi.manager_emp_id,0,1)#';else calisan = '';
		if(len(get_group_bilgi.MANAGER_ROLE_HEAD))rol = '#get_group_bilgi.MANAGER_ROLE_HEAD#';else rol = '-';
		grup_name = '#get_group_bilgi.WORKGROUP_NAME#';
		if(len(get_group_bilgi.MANAGER_EMP_ID))div_spe = div_spe & ' solid';else div_spe = div_spe & ' dashed';
		div_spe = div_spe &' ##666666;';
		deger = '<div id="cizim_#WORKGROUP_ID#" style="position:absolute;z-index:2;left:#my_left#px;top:#(((listlen(get_group_bilgi.hierarchy,'.') - (my_default_hie-1))* kutu_yuksekligi)+10)+my_top_eklenti#px;width:150px;height:#kutu_yuksekligi#px;">';
		deger = deger & '<table width="150" cellpadding="0" cellspacing="0"><tr><td style="text-align:center;"><img src="/images/cizgi_dik_1pix.gif" height="#15#" width="3"></td></tr><tr>';
		deger = deger & '<td style="height:#kutu_yuksekligi-30#px;#div_spe#">';
		deger = deger & '<table align="center">';
		deger = deger & '<tr align="center"><td>#left(grup_name,25)#</td></tr>';
		deger = deger & '<tr align="center"><td>#calisan#</td></tr>';
		deger = deger & '<tr><td align="center">#rol#</td></tr>';
		deger = deger & '</table></td></tr>';
		if(get_group_bilgi3.recordcount)
			{
			deger = deger & '<tr><td style="text-align:center;"><img src="/images/cizgi_dik_1pix.gif" height="15" width="3"></td></tr>';
			}
		deger = deger & '</table></div>';
		my_son_left = my_left + 150;
	</cfscript>
	<cfreturn deger>
</cffunction>

 <cfif grup_uzunlugu gt 1 and get_my_workgroup_ust.recordcount>
<div id="ust_group" align="center" style="position:absolute;z-index:2;width:150px;height:75px;left:250px;top:<cfoutput>#8+my_top_eklenti+(kutu_yuksekligi-75)#</cfoutput>px;">
	<table cellpadding="0" cellspacing="0" width="200" height="75">
		<tr>
			<td align="center" height="60" style="border: 1px <cfif len(get_my_workgroup_ust.MANAGER_EMP_ID)>solid<cfelse>dashed</cfif> #666666;">
				<cfoutput><cfif len(get_my_workgroup_ust.manager_role_head)>#get_my_workgroup_ust.manager_role_head#<cfelse>#get_my_workgroup_ust.WORKGROUP_NAME#</cfif>
				<cfif len(get_my_workgroup_ust.MANAGER_EMP_ID)><font class="formbold"><br/>#get_emp_info(get_my_workgroup_ust.MANAGER_EMP_ID,0,0)#</cfif></font></cfoutput>
			</td>
		</tr>
		<tr><td  style="text-align:center;" height="15"><img src="/images/cizgi_dik_1pix.gif" height="15" width="3"></td></tr>
	</table>
</div>
<cfset my_top_eklenti = my_top_eklenti + 70>
</cfif>


<div id="main_group" align="center" style="position:absolute;z-index:2;width:150px;height:75px;left:10px;top:<cfoutput>#13+my_top_eklenti+(kutu_yuksekligi-75)#</cfoutput>px;">
	<table cellpadding="0" cellspacing="0" width="150" height="75">
		<tr>
			<td class="formbold" height="60" style="text-align:center;border: 1px <cfif len(get_my_workgroup.MANAGER_EMP_ID)>solid<cfelse>dashed</cfif> #666666;">
				<cfoutput>#get_my_workgroup.WORKGROUP_NAME#
				<cfif len(get_my_workgroup.MANAGER_EMP_ID)><br/>#get_emp_info(get_my_workgroup.MANAGER_EMP_ID,0,0)#</cfif> <br/> #get_my_workgroup.manager_role_head#</cfoutput>
			</td>
		</tr>
		<tr><td  style="text-align:center;" height="15"><img src="/images/cizgi_dik_1pix.gif" height="15" width="3"></td></tr>
	</table>
</div>

<div id="yatay_cizgi_top" style="position:absolute;z-index:5;width:1px;height:3px;left:20px;top:<cfoutput>#my_top_eklenti+85+(kutu_yuksekligi-75)#</cfoutput>px;"><img src="/images/cizgi_yan_1pix.gif" width="100%" height="3"></div>
<cfset last_hie = 0>
<cfoutput query="get_all_workgroup_roles">#draw_div(get_all_workgroup_roles.WORKGROUP_ID,last_hie)#<cfset last_hie = listlen(get_all_workgroup_roles.hierarchy,'.')></cfoutput>
<br/>
<cfset top_deger = 0>
<cfloop query="get_all_workgroup_roles_ters">
	<cfif get_all_workgroup_roles_ters.currentrow eq 1>
		<cfset toplam_height = (listlen(get_all_workgroup_roles_ters.hierarchy,'.') * kutu_yuksekligi) + (listlen(get_all_workgroup_roles_ters.hierarchy,'.') * 25) + 85 + my_top_eklenti + 125>
	</cfif>
		
	<cfset my_layer_eklenti = 0>
	<cfquery name="get_group_ozel" dbtype="query">
		SELECT * FROM get_all_workgroup_roles WHERE WORKGROUP_ID <> #get_all_workgroup_roles_ters.WORKGROUP_ID# AND HIERARCHY LIKE '#get_all_workgroup_roles_ters.hierarchy#.%' ORDER BY HIERARCHY DESC
	</cfquery>
	<cfset group_hie = listlen(get_all_workgroup_roles_ters.HIERARCHY,'.')>
	<cfset ust_id = get_all_workgroup_roles_ters.WORKGROUP_ID>
	<cfset ozel_list = 0>
	<cfset my_wrk_id = ''>
	<cfset my_first_wrk_id = ''>
	<cfloop query="get_group_ozel">
		<cfif get_group_ozel.currentrow eq get_group_ozel.recordcount>
			<cfset my_first_wrk_id = '#get_group_ozel.WORKGROUP_ID#'>
		</cfif>
		<cfif (listlen(get_group_ozel.hierarchy,'.') - group_hie) eq 1>
			<cfif ozel_list eq 0>
				<div id="yatay_cizgi_<cfoutput>#ust_id#</cfoutput>" style="position:absolute;z-index:2;width:1;height:3px;left:20px;top:<cfoutput>#15+my_top_eklenti#</cfoutput>px;"><img src="/images/cizgi_yan_1pix.gif" width="100%" height="3"></div>
				<cfset my_wrk_id = '#get_group_ozel.WORKGROUP_ID#'>
			</cfif>
			<cfset ozel_list = ozel_list + 1>
		</cfif>
	</cfloop>
		<cfif ozel_list>
			<script type="text/javascript">
				my_yeni_sayi = <cfoutput>#ozel_list#</cfoutput>;
				my_j_layer_eklenti = <cfoutput>#my_layer_eklenti#</cfoutput>;
				my_top_eklenti = <cfoutput>#my_top_eklenti#</cfoutput>;
				my_sag_son = parseInt(document.getElementById('cizim_<cfoutput>#my_wrk_id#</cfoutput>').style.left) + 150;
				my_top = parseInt(document.getElementById('cizim_<cfoutput>#my_wrk_id#</cfoutput>').style.top) - 125;
				my_left_bas = my_sag_son - ((my_yeni_sayi * 150) + ((my_yeni_sayi-1)*25));
				my_second_left = parseInt(document.getElementById('cizim_<cfoutput>#my_first_wrk_id#</cfoutput>').style.left);
				
				if(my_yeni_sayi==1)
					my_orta = my_left_bas;
				else
					my_orta = ((my_sag_son + my_left_bas) / 2)-75;
					
				document.getElementById('cizim_<cfoutput>#ust_id#</cfoutput>').style.left = my_orta  + 'px';
				
				document.getElementById('yatay_cizgi_<cfoutput>#ust_id#</cfoutput>').style.left = my_second_left+75  + 'px';
				if(my_yeni_sayi>1)
					{
					document.getElementById('yatay_cizgi_<cfoutput>#ust_id#</cfoutput>').style.width = my_sag_son - my_second_left - 150 + 'px';
					}
				else
					{
					document.getElementById('yatay_cizgi_<cfoutput>#ust_id#</cfoutput>').style.width = 0 + 'px';
					}
				document.getElementById('yatay_cizgi_<cfoutput>#ust_id#</cfoutput>').style.top = <cfoutput>#kutu_yuksekligi#</cfoutput> * (<cfoutput>#group_hie+1#-(#my_default_hie-1#)</cfoutput>) + 10 + my_top_eklenti + my_j_layer_eklenti + 'px';
			</script>
		</cfif>
		<cfif (top_deger eq 0) and (group_hie eq my_default_hie)>
			<cfset top_deger = 1>
			<script type="text/javascript">
				my_top_cizgi_son = parseInt(document.getElementById('cizim_<cfoutput>#ust_id#</cfoutput>').style.left);
			</script>
		</cfif>
		<cfif get_all_workgroup_roles_ters.currentrow eq get_all_workgroup_roles_ters.recordcount>
			<script type="text/javascript">
				document.getElementById('yatay_cizgi_top').style.left = parseInt(document.getElementById('cizim_<cfoutput>#ust_id#</cfoutput>').style.left) + 75 + 'px';
				document.getElementById('main_group').style.left = ((<cfoutput>#my_son_left#</cfoutput> - parseInt(document.getElementById('cizim_<cfoutput>#ust_id#</cfoutput>').style.left)) / 2) + parseInt(document.getElementById('cizim_<cfoutput>#ust_id#</cfoutput>').style.left) - 75 + 'px';
				<cfif grup_uzunlugu gt 1 and get_my_workgroup_ust.recordcount>
					document.getElementById('ust_group').style.left = ((<cfoutput>#my_son_left#</cfoutput> - parseInt(document.getElementById('cizim_<cfoutput>#ust_id#</cfoutput>').style.left)) / 2) + parseInt(document.getElementById('cizim_<cfoutput>#ust_id#</cfoutput>').style.left) - 75 + 'px';
				</cfif>
				document.getElementById('yatay_cizgi_top').style.width = my_top_cizgi_son - (parseInt(document.getElementById('cizim_<cfoutput>#ust_id#</cfoutput>').style.left)) + 'px';
				document.pdf_flash.my_page_width.value = (<cfoutput>#my_son_left#</cfoutput> + 150) / 35;
				document.pdf_flash.my_page_height.value = <cfoutput>#toplam_height#</cfoutput> / 20;
				if(document.pdf_flash.my_page_width.value < 21)
					document.pdf_flash.my_page_width.value = '21';
				if(document.pdf_flash.my_page_height.value < 29)
					document.pdf_flash.my_page_height.value = '29';
			</script>
		</cfif>
</cfloop>
</div>
