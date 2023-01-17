<cfsetting showdebugoutput="no">
<cfquery name="get_my_workgroup" datasource="#dsn#">
	SELECT 
    	WORKGROUP_ID, 
        WORKGROUP_NAME, 
        GOAL, 
        ONLINE_HELP, 
        ONLINE_SALES, 
        COMPANY_ID, 
        PROJECT_ID, 
        STATUS, 
        RECORD_EMP, 
        RECORD_DATE,
        RECORD_IP, 
        HIERARCHY, 
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
        SUB_WORKGROUP, 
        SPONSOR_EMP_ID, 
        IS_BUDGET
    FROM 
    	WORK_GROUP 
    WHERE 
	    WORKGROUP_ID = #attributes.WORKGROUP_ID# AND IS_ORG_VIEW = 1
</cfquery>
<cfset grup_uzunlugu = listlen(get_my_workgroup.hierarchy,'.')>
<cfquery name="get_all_workgroup_roles_hepsi" datasource="#dsn#">
	SELECT 
		EMPLOYEES.EMPLOYEE_ID,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		WORKGROUP_EMP_PAR.HIERARCHY,
		WORKGROUP_EMP_PAR.WRK_ROW_ID,
		WORKGROUP_EMP_PAR.IS_REAL,
		WORKGROUP_EMP_PAR.IS_CRITICAL,
		WORKGROUP_EMP_PAR.ROLE_HEAD,
		WORKGROUP_EMP_PAR.ORDER_NO ORDER_NO
	FROM 
		EMPLOYEES, 
		WORKGROUP_EMP_PAR 
	WHERE 
		EMPLOYEES.EMPLOYEE_ID = WORKGROUP_EMP_PAR.EMPLOYEE_ID AND
		WORKGROUP_EMP_PAR.WORKGROUP_ID = #attributes.workgroup_id# AND
		WORKGROUP_EMP_PAR.HIERARCHY IS NOT NULL AND
		WORKGROUP_EMP_PAR.IS_ORG_VIEW = 1
		
	UNION ALL
	
	SELECT 
		-1 AS EMPLOYEE_ID,
		'' AS EMPLOYEE_NAME,
		'' AS EMPLOYEE_SURNAME,
		WORKGROUP_EMP_PAR.HIERARCHY,
		WORKGROUP_EMP_PAR.WRK_ROW_ID,
		WORKGROUP_EMP_PAR.IS_REAL,
		WORKGROUP_EMP_PAR.IS_CRITICAL,
		WORKGROUP_EMP_PAR.ROLE_HEAD,
		WORKGROUP_EMP_PAR.ORDER_NO ORDER_NO	
	FROM 
		WORKGROUP_EMP_PAR 
	WHERE 
		WORKGROUP_EMP_PAR.WORKGROUP_ID = #attributes.workgroup_id# AND 
		WORKGROUP_EMP_PAR.EMPLOYEE_ID IS NULL AND
		WORKGROUP_EMP_PAR.PARTNER_ID IS NULL AND
		WORKGROUP_EMP_PAR.POSITION_CODE IS NULL AND
		WORKGROUP_EMP_PAR.HIERARCHY IS NOT NULL AND
		WORKGROUP_EMP_PAR.IS_ORG_VIEW = 1
	ORDER BY
		ORDER_NO
</cfquery>


<cfset get_all_workgroup_roles = QueryNew("HIERARCHY,WRK_ROW_ID,EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME,IS_REAL,IS_CRITICAL,ORDER_NO,SIRA_NO,YENI_HIERARCHY,ROLE_HEAD","VarChar,Integer,Integer,VarChar,VarChar,Integer,Integer,Integer,Integer,VarChar,VarChar")>
<cfset ROW_OF_QUERY = 0>
<cfset wrk_id_list = ''>

<cfset my_loop_last_hie = ''>
<cfloop query="get_all_workgroup_roles_hepsi">
	<cfif listlen(get_all_workgroup_roles_hepsi.hierarchy,'.') gt listlen(my_loop_last_hie,'.')>
		<cfset my_loop_last_hie = get_all_workgroup_roles_hepsi.hierarchy> 
	</cfif>
</cfloop>
<cfset my_loop_last_hie = listlen(my_loop_last_hie,'.')>


<cfquery name="get_all_workgroup_roles_ilk" dbtype="query">
	SELECT * FROM get_all_workgroup_roles_hepsi ORDER BY ORDER_NO
</cfquery>

<cfloop from="2" to="#my_loop_last_hie#" index="k">
	<cfloop query="get_all_workgroup_roles_ilk">
		<cfif listlen(get_all_workgroup_roles_ilk.hierarchy,'.') eq k>
				<cfif k eq 2>
					<cfset eklenecek = 4 - len(get_all_workgroup_roles_ilk.currentrow)>
					<cfset ek = ''>
					<cfif eklenecek gt 0>
						<cfloop from="1" to="#eklenecek#" index="m">
							<cfset ek = ek & '0'>
						</cfloop>
					</cfif>
					<cfset gecici_hie = '#k#' & '.' & '#ek#' & '#get_all_workgroup_roles_ilk.currentrow#'>
				<cfelse>
					<cfset ust_grup_hiearchy = left(get_all_workgroup_roles_ilk.hierarchy,len(get_all_workgroup_roles_ilk.hierarchy) - (len(listlast(get_all_workgroup_roles_ilk.hierarchy,'.')) + 1))>
					<cfset eklenecek = 4 - len(get_all_workgroup_roles_ilk.currentrow)>
					<cfset ek = ''>
					<cfif eklenecek gt 0>
						<cfloop from="1" to="#eklenecek#" index="m">
							<cfset ek = ek & '0'>
						</cfloop>
					</cfif>
					<cfquery name="get_" dbtype="query">
						SELECT HIERARCHY FROM get_all_workgroup_roles WHERE YENI_HIERARCHY = '#ust_grup_hiearchy#'
					</cfquery>
					<cfset gecici_hie = '#get_.HIERARCHY#' & '.' & '#ek#' &'#get_all_workgroup_roles_ilk.currentrow#'>
				</cfif>
				<cfscript>
				ROW_OF_QUERY = ROW_OF_QUERY + 1;
				QueryAddRow(get_all_workgroup_roles,1);
				QuerySetCell(get_all_workgroup_roles,"YENI_HIERARCHY",HIERARCHY,ROW_OF_QUERY);
				QuerySetCell(get_all_workgroup_roles,"WRK_ROW_ID",WRK_ROW_ID,ROW_OF_QUERY);
				QuerySetCell(get_all_workgroup_roles,"EMPLOYEE_ID",EMPLOYEE_ID,ROW_OF_QUERY);
				QuerySetCell(get_all_workgroup_roles,"EMPLOYEE_NAME",EMPLOYEE_NAME,ROW_OF_QUERY);
				QuerySetCell(get_all_workgroup_roles,"EMPLOYEE_SURNAME",EMPLOYEE_SURNAME,ROW_OF_QUERY);
				QuerySetCell(get_all_workgroup_roles,"IS_REAL",IS_REAL,ROW_OF_QUERY);
				QuerySetCell(get_all_workgroup_roles,"IS_CRITICAL",IS_CRITICAL,ROW_OF_QUERY);
				QuerySetCell(get_all_workgroup_roles,"ORDER_NO",ORDER_NO,ROW_OF_QUERY);
				QuerySetCell(get_all_workgroup_roles,"SIRA_NO",ROW_OF_QUERY,ROW_OF_QUERY);
				QuerySetCell(get_all_workgroup_roles,"HIERARCHY",gecici_hie,ROW_OF_QUERY);
				QuerySetCell(get_all_workgroup_roles,"ROLE_HEAD",ROLE_HEAD,ROW_OF_QUERY);
				</cfscript>
		</cfif>
	</cfloop>

</cfloop>

<cfquery name="get_all_workgroup_roles" dbtype="query">
	SELECT * FROM get_all_workgroup_roles ORDER BY HIERARCHY ASC
</cfquery>

<cfquery name="get_all_workgroup_roles_ters" dbtype="query">
	SELECT * FROM get_all_workgroup_roles ORDER BY HIERARCHY DESC
</cfquery>


<cfset my_top_eklenti = 30>
<cfset kademe_sayisi = 0>
<cfset kademe_carpani = 20>
<cfset kutu_yuksekligi = 75>
<cfset my_default_hie = listlen(get_my_workgroup.hierarchy,'.') + 1>
<cfset my_default_hie2 = listlen(get_my_workgroup.hierarchy,'.')>
<!-- sil -->
<form name="pdf_flash">
<input type="hidden" value="35" name="my_page_width" id="my_page_width">
<input type="hidden" value="35" name="my_page_height" id="my_page_height">
</form>
<!-- sil -->
<table width="100%">
<tr >
	<!-- sil --><td width="25"><cfoutput><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_convertpdf&special_module=1&module=hr_wg_draw_div&ispdf=1&page_height='+ document.pdf_flash.my_page_height.value +'&page_width=' + document.pdf_flash.my_page_width.value,'small','popup_convertpdf')"><img src="/images/pdf.gif" title="Pdf Yap" border="0"></a></cfoutput></td><!-- sil -->
</tr>
</table>
<div id="hr_wg_draw_div">
<div id="main_group" align="center" style="position:absolute;z-index:2;width:200px;height:75px;left:250px;top:<cfoutput>#13+my_top_eklenti#</cfoutput>px;">
	<table cellpadding="0" cellspacing="0" width="200" height="75">
		<tr>
			<td class="formbold" height="57" style="text-align:center;border: 1px <cfif len(get_my_workgroup.MANAGER_EMP_ID)>solid<cfelse>dashed</cfif> #666666;">
				<cfoutput>#get_my_workgroup.WORKGROUP_NAME#
				<cfif len(get_my_workgroup.MANAGER_EMP_ID)><font class="formbold"><br/>#get_emp_info(get_my_workgroup.MANAGER_EMP_ID,0,1)#</cfif> <br/> #get_my_workgroup.manager_role_head#</font></cfoutput>
			</td>
		</tr>
		<tr><td style="text-align:center;" height="15"><img src="/images/cizgi_dik_1pix.gif" style="height:15px; width:3px;"></td></tr>
	</table>
</div>
<div id="yatay_cizgi_top" style="position:absolute;z-index:5;width:1px;height:3px;left:20px;top:<cfoutput>#85+my_top_eklenti#</cfoutput>px;"><img src="/images/cizgi_yan_1pix.gif" width="100%" height="3"></div>
<cfset last_hie = 0>
<cfoutput query="get_all_workgroup_roles">#draw_div(get_all_workgroup_roles.WRK_ROW_ID,last_hie)#<cfset last_hie = listlen(get_all_workgroup_roles.hierarchy,'.')></cfoutput>
<br/>
<cfset top_deger = 0>
<cfset ilk_sira_ = 0>
<cfloop query="get_all_workgroup_roles_ters">
	<cfif get_all_workgroup_roles_ters.currentrow eq 1>
		<cfset toplam_height = (listlen(get_all_workgroup_roles_ters.hierarchy,'.') * kutu_yuksekligi) + (listlen(get_all_workgroup_roles_ters.hierarchy,'.') * 25) + 85 + my_top_eklenti + 125>
	</cfif>
	<cfif listlen(yeni_hierarchy,'.') eq 2>
		<cfset ilk_sira_ = ilk_sira_ + 1>
	</cfif>
	<cfset my_layer_eklenti = 0>
	<cfquery name="get_group_ozel" dbtype="query">
		SELECT * FROM get_all_workgroup_roles_ters WHERE WRK_ROW_ID <> #get_all_workgroup_roles_ters.WRK_ROW_ID# AND HIERARCHY LIKE '#get_all_workgroup_roles_ters.HIERARCHY#.%' ORDER BY HIERARCHY DESC
	</cfquery>
	<cfset group_hie = listlen(get_all_workgroup_roles_ters.YENI_HIERARCHY,'.')>
	<cfset group_hie2 = listlen(get_all_workgroup_roles_ters.HIERARCHY,'.')>
	<cfset ust_id = get_all_workgroup_roles_ters.WRK_ROW_ID>
	<cfset ozel_list = 0>
	<cfset my_wrk_id = ''>
	<cfset my_first_wrk_id = ''>
	<cfset sira_ = 0>
	<cfloop query="get_group_ozel">
		<cfset sira_ = sira_ + 1>
		<cfif sira_ eq get_group_ozel.recordcount>
			<cfset my_first_wrk_id = '#get_group_ozel.WRK_ROW_ID#'>
		</cfif>
		<cfif (listlen(get_group_ozel.YENI_HIERARCHY,'.') - group_hie) eq 1>
			<cfif ozel_list eq 0>
				<div id="yatay_cizgi_<cfoutput>#ust_id#</cfoutput>" style="position:absolute;z-index:2;width:1;height:3px;left:20px;top:<cfoutput>#15+my_top_eklenti#</cfoutput>px;"><img src="/images/cizgi_yan_1pix.gif" width="100%" height="3"></div>
				<cfset my_wrk_id = '#get_group_ozel.WRK_ROW_ID#'>
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
					
				document.getElementById('cizim_<cfoutput>#ust_id#</cfoutput>').style.left = my_orta + 'px';
				
				document.getElementById('yatay_cizgi_<cfoutput>#ust_id#</cfoutput>').style.left = my_second_left + 75 + 'px';
				if(my_yeni_sayi>1)
					{
					document.getElementById('yatay_cizgi_<cfoutput>#ust_id#</cfoutput>').style.width = my_sag_son - my_second_left - 150 + 'px';
				  	}
				else
					{
					document.getElementById('yatay_cizgi_<cfoutput>#ust_id#</cfoutput>').style.width = 0 + 'px';
					}
				  document.getElementById('yatay_cizgi_<cfoutput>#ust_id#</cfoutput>').style.top = parseInt(document.getElementById('cizim_<cfoutput>#my_first_wrk_id#</cfoutput>').style.top) + 'px';
			</script>
		</cfif>
		<cfif (top_deger eq 0) and (group_hie eq my_default_hie)>
			<cfset top_deger = 1>
			<script type="text/javascript">
				my_top_cizgi_son = parseInt(cizim_<cfoutput>#ust_id#</cfoutput>.style.left);
			</script>
		</cfif>
		<cfif get_all_workgroup_roles_ters.currentrow eq get_all_workgroup_roles_ters.recordcount>
			<script type="text/javascript">
				<cfif ilk_sira_ eq 1>
					document.getElementById('yatay_cizgi_top').style.left = parseInt(document.getElementById('cizim_<cfoutput>#ust_id#</cfoutput>').style.left) + 75 + 'px';
					document.getElementById('main_group').style.left = ((<cfoutput>#my_son_left#</cfoutput> - parseInt(document.getElementById('cizim_<cfoutput>#ust_id#</cfoutput>').style.left)) / 2) + parseInt(document.getElementById('cizim_<cfoutput>#ust_id#</cfoutput>').style.left) - 75 + 'px';
					<cfif get_all_workgroup_roles_ters.recordcount gt 1 and listlen(get_all_workgroup_roles_ters.YENI_HIERARCHY[currentrow-1],'.') neq group_hie>
						document.getElementById('main_group').style.left = parseInt(document.getElementById('cizim_<cfoutput>#ust_id#</cfoutput>').style.left)- 25 + 'px';
					</cfif>
					document.getElementById('yatay_cizgi_top').style.width = my_top_cizgi_son - (parseInt(document.getElementById('cizim_<cfoutput>#ust_id#</cfoutput>').style.left)) + 'px';
				<cfelse>
					document.getElementById('yatay_cizgi_top').style.left = parseInt(document.getElementById('cizim_<cfoutput>#ust_id#</cfoutput>').style.left) + 75 + 'px';
					document.getElementById('yatay_cizgi_top').style.width = my_top_cizgi_son - (parseInt(document.getElementById('cizim_<cfoutput>#ust_id#</cfoutput>').style.left)) + 'px';
				</cfif>
					document.pdf_flash.my_page_width.value = (<cfoutput>#my_son_left#</cfoutput> + 150) / 35;
					document.pdf_flash.my_page_height.value = <cfoutput>#toplam_height#</cfoutput> / 20;
			</script>
		</cfif>
</cfloop> 


<cffunction name="draw_div" returntype="string">
	<cfargument name="WRK_ROW_ID" type="numeric" required="true">
	<cfargument name="last_hie" type="numeric" required="true">
	<cfquery name="get_group_bilgi" dbtype="query">
		SELECT * FROM get_all_workgroup_roles WHERE WRK_ROW_ID = #arguments.WRK_ROW_ID#
	</cfquery>
	<cfquery name="get_group_bilgi3" dbtype="query">
		SELECT * FROM get_all_workgroup_roles WHERE WRK_ROW_ID <> #arguments.WRK_ROW_ID# AND HIERARCHY LIKE '#get_group_bilgi.hierarchy#.%'
	</cfquery>
	<cfset aktif_kademe = listlen(get_group_bilgi.yeni_hierarchy,'.')-1>
	<cfset my_kademe = 0>
	
	<cfset my_grup_uzunlugu = listlen(get_group_bilgi.yeni_hierarchy,'.')>
	
	<cfif my_kademe gt aktif_kademe>
		<cfset kademe_eklentisi = ((my_kademe - aktif_kademe) * kutu_yuksekligi)>
	<cfelse>
		<cfset kademe_eklentisi = 0>
	</cfif>
	<cfif last_hie neq 0>
		<cfif (listlen(get_group_bilgi.hierarchy,'.') gt last_hie)>
			<cfset my_left = my_left>
		<cfelseif (listlen(get_group_bilgi.hierarchy,'.') lt last_hie)>
			<cfset my_left = my_left + 300>
		<cfelseif (listlen(get_group_bilgi.hierarchy,'.') eq last_hie)>
			<cfset my_left = my_left + 300>
		</cfif>
	<cfelse>
		<cfset my_left = 50>
	</cfif>
	
	
	<cfset my_top = (((listlen(get_group_bilgi.yeni_hierarchy,'.') - (my_default_hie-1))* kutu_yuksekligi)+10)+my_top_eklenti>
	<cfscript>
		if(get_group_bilgi.is_real eq 1)
			vekil = "";
		else if(get_group_bilgi.is_real eq 0)
			vekil = "(V.)";
		else
			vekil = "";
		div_spe = 'border: 1px';
		if(len(get_group_bilgi.EMPLOYEE_NAME))div_spe = div_spe & ' solid';else div_spe = div_spe & ' dashed';
		if(get_group_bilgi.is_critical eq 0)div_spe = div_spe &' ##666666;';else div_spe = div_spe &' red;';
		if(get_all_workgroup_roles.recordcount == 1)
		{
		   var t_width = 200;
		}
			else t_width = 150;
		deger = '<div id="cizim_#get_group_bilgi.WRK_ROW_ID#" style="position:absolute;z-index:2;left:#my_left#px;top:#my_top#px;width:200px;height:#kutu_yuksekligi+kademe_eklentisi#px;">';
		deger = deger & '<table width="#t_width#" cellpadding="0" cellspacing="0"><tr><td style="text-align:center;"><img src="/images/cizgi_dik_1pix.gif" height="#15+kademe_eklentisi#" width="3"></td></tr><tr>';
		deger = deger & '<td style="height:#kutu_yuksekligi-30#px;#div_spe#">';
		deger = deger & '<table align="center">';
		deger = deger & '<tr align="center"><td><a href="javascript://" onclick="windowopen(''#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_group_bilgi.EMPLOYEE_ID#'',''medium'');">#get_group_bilgi.EMPLOYEE_NAME# #get_group_bilgi.EMPLOYEE_SURNAME#</a>&nbsp;<b>#vekil#</b></td></tr>';
		deger = deger & '<tr><td>#get_group_bilgi.role_head#</td></tr>';
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
</div>
