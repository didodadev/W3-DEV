<cfparam name="attributes.tab_menu" default="protein-product-detail">
<cfquery name="GET_MAIN_MENU" datasource="#DSN#">
	SELECT 
    	*,
		SITE_TYPE	
    FROM 
    	MAIN_MENU_SETTINGS 
    WHERE 
    	MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.menu_id#">
</cfquery>
<cfquery name="GET_DEPARTMENT" datasource="#DSN#">
	SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE IS_STORE <> 2 AND DEPARTMENT_STATUS = 1 <cfif isDefined("attributes.branch_id")> AND BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> </cfif> ORDER BY DEPARTMENT_HEAD
</cfquery>
<cfquery name="GET_USER_GROUPS" datasource="#DSN#">
	SELECT USER_GROUP_ID,USER_GROUP_NAME FROM USER_GROUP ORDER BY USER_GROUP_NAME
</cfquery>
<cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
	SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT
</cfquery>
<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
	SELECT CONSCAT_ID,CONSCAT FROM CONSUMER_CAT ORDER BY CONSCAT
</cfquery>
<cfquery name="GET_POSITION_CATS" datasource="#DSN#">
	SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT WHERE POSITION_CAT_STATUS = 1 ORDER BY POSITION_CAT
</cfquery>
<cfquery name="GET_MAIN_MENU_SELECT" datasource="#DSN#">
	SELECT 
    	MENU_ID,
    	SELECTED_ID, 
        LINK_NAME_TYPE, 
        LINK_NAME, 
        SELECTED_LINK, 
        LINK_AREA, 
        LINK_TYPE,
        LINK_IMAGE,
        LINK_IMAGE_SERVER_ID, 
        ORDER_NO, 
        IS_SESSION, 
        LOGIN_CONTROL 
    FROM 
    	MAIN_MENU_SELECTS 
    WHERE 
    	MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.menu_id#">
</cfquery>
<cfquery name="GET_LANGUAGES" datasource="#DSN#">
	SELECT LANGUAGE_SHORT FROM SETUP_LANGUAGE
</cfquery>


<cfinclude template="../protein_upper.cfm">


<table border="0" cellspacing="0" cellpadding="0" align="center" style="width:98%;">
	<tr>
		<td class="headbold" height="35"><cfoutput>#getLang('main',724)# - #get_main_menu.menu_name#</cfoutput></td>
	</tr>
</table>
<div class="product-tab">
	<ul class="nav-tab">
		<a data-toggle="tab" id="tab-protein-product-detail" href="javascript:pageload('protein-product-detail');" <cfif attributes.tab_menu is 'protein-product-detail'>class="active"</cfif>>Detay</a>
		<a data-toggle="tab" id="tab-protein-pages" href="javascript:pageload('protein-pages');" <cfif attributes.tab_menu is 'protein-pages'>class="active"</cfif>>Sayfalar</a>
		<a data-toggle="tab" id="tab-protein-reviews" href="javascript:pageload('protein-reviews');" <cfif attributes.tab_menu is 'protein-reviews'>class="active"</cfif>>MAP</a>
	</ul>
	<div class="tab-container">
		<div id="protein-product-detail" class="tab-panel<cfif attributes.tab_menu is 'protein-product-detail'> active</cfif>">
		<cfform name="user_group" action="#request.self#?fuseaction=protein.emptypopup_upd_main_menu" method="post" enctype="multipart/form-data" onsubmit="newRows()">
			<cfinput type="hidden" name="menu_id" value="#attributes.menu_id#">
			<cfinclude template="detail.cfm">
		</cfform>
		</div>
		<div id="protein-pages" class="tab-panel<cfif attributes.tab_menu is 'protein-pages'> active</cfif>"><cfinclude template="pages.cfm"></div>
		<div id="protein-reviews" class="tab-panel<cfif attributes.tab_menu is 'protein-reviews'> active</cfif>"><cfinclude template="map.cfm"></div>
	</div>
</div>
<br/>
<script type="text/javascript">
	row_count=0;
	function sil(sy)
	{  
		/*var my_element=eval("user_group.row_kontrol"+sy); */
		var my_element=document.getElementById('row_kontrol'+sy);
		my_element.value=0;

		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
	}
	function sil_sabit(sy)
	{   
		var my_element1=eval("user_group.row_kontrol_sabit_"+sy); 
		my_element1.value=0;

		var my_element1=eval("frm_row_sabit_"+sy);
		my_element1.style.display="none";
	}
	
	function get_value(satir,type)
	{
		if(type == 1)
		{
			document.getElementById('link_name_id'+satir).value = '';
			document.getElementById('link_name'+satir).value = '';
			document.getElementById('link_name_type'+satir).value = 0;
		}
		else
		{
			document.getElementById('link_name_sabit_'+satir).value = '';
			document.getElementById('link_name_id_sabit_'+satir).value = '';
			document.getElementById('link_name_type_sabit_'+satir).value = 0;
		}

	}
	
	function add_row()
	{
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);
					
		document.user_group.record_num.value=row_count;
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');" ><img  src="images/delete_list.gif" border="0"></a>';	
		
/*		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="link_name_type' + row_count + '" id="link_name_type' + row_count + '"><option value="0" selected><cf_get_lang no ="2417.Menüden"></option><option value="1"><cf_get_lang no ="2491.Ana Sözlük"></option><option value="2"><cf_get_lang no ="2492.Modül Sözlük"></option></select>';
*/		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="hidden"  value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><input type="hidden" name="link_name_id' + row_count + '" id="link_name_id' + row_count + '"><input type="text" name="link_name' + row_count + '" id="link_name' + row_count + '" style="width:145px;" onChange="get_value('+row_count+',1);" readonly="readonly"> <a href="javascript://" onClick="pencere_ac(' + row_count + ');"><img border="0" alt="<cf_get_lang no="1173.Dil Ekle">" src="/images/plus_thin.gif" align="absmiddle"></a>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="link_name_type' + row_count + '" id="link_name_type' + row_count + '" style="width:20px;" value="0"><input type="text" name="link_name2' + row_count + '" id="link_name2' + row_count + '" onFocus="get_value('+row_count+',1);"  style="width:145px;">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="selected_link' + row_count + '" id="selected_link' + row_count + '" style="width:200px;"><a href="javascript://" onClick="pencere_ac3(' + row_count + ');"><img border="0" src="/images/plus_thin.gif" alt="URL Seç" align="absmiddle"></a>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="link_area' + row_count + '" id="link_area' + row_count + '" style="width:80px;"><option value="-1"><cf_get_lang no ="900.Ana Alan"></option><option value="-2"><cf_get_lang no ="901.Ara Alan"></option><option value="-3"><cf_get_lang no ="2493.Footer Alan"></option></select>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="link_type' + row_count + '" id="link_type' + row_count + '" style="width:100px;"><option value="-1"><cf_get_lang no ="379.Normal"></option><option value="-9"><cf_get_lang no="902.Layer"></option><option value="-2"><cf_get_lang no ="2572.Yeni Pencere"></option><option value="-3"><cf_get_lang no="904.Popup Small"></option><option value="-4"><cf_get_lang no="905.Popup Medium"></option><option value="-5"><cf_get_lang no="906.Popup List"></option><option value="-6"><cf_get_lang no="907.Popup Page"></option><option value="-7"><cf_get_lang no="908.Popup Project"></option><option value="-8"><cf_get_lang no="909.Popup Horizantal"></option><option value="-15">TV</option><option value="-10"><cf_get_lang no ="2420.Güvenli Link"></option><option value="-11"><cf_get_lang no ="2421.Popup Güvenli Link"></option><option value="-12"><cf_get_lang no ="2494.Sayfa Çağır"></option><option value="-13"><cf_get_lang no ="2422.Site Dışı Link"></option></select>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="order_no' + row_count + '" id="order_no' + row_count + '" onKeyup="isNumber(this);" onblur="isNumber(this);" class="moneybox" maxlength="2" style="width:30px;">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="checkbox" value="1" name="is_session_' + row_count + '">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="login_control' + row_count + '" id="login_control' + row_count + '" style="width:100px;"><option value="0"><cf_get_lang no ="2569.Her Durumda"></option><option value="1"><cf_get_lang no ="2570.Üye Girişi Varken"></option><option value="2"><cf_get_lang no ="2571.Üye Girişi Yokken"></option><option value="3"><cf_get_lang_main no="1197.Üye Kategorisi"></option></select>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '&nbsp;';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '&nbsp;';
	}
	
	function newRows()
	{  
		for(i=1;i<=row_count;i++)
		{
			document.user_group.appendChild(document.getElementById('row_kontrol' + i + ''));
			document.user_group.appendChild(document.getElementById('order_no' + i + ''));
			document.user_group.appendChild(document.getElementById('link_area' + i + ''));
			document.user_group.appendChild(document.getElementById('selected_link' + i + ''));
			document.user_group.appendChild(document.getElementById('link_type' + i + ''));
			document.user_group.appendChild(document.getElementById('link_name_type' + i + ''));
			document.user_group.appendChild(document.getElementById('link_name' + i + ''));
			document.user_group.appendChild(document.getElementById('link_name_id' + i + ''));
			document.user_group.appendChild(document.getElementById('link_name2' + i + ''));
			document.user_group.appendChild(document.getElementById('login_control' + i + ''));
		}
	}
	
	function pencere_ac(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=protein.popup_list_lang_number&item_id=user_group.link_name_id' + no + '&item=user_group.link_name' + no+'&field_type=user_group.link_name_type'+no+'&field_name2=user_group.link_name2'+no,'medium');
	}
	function pencere_ac2(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=protein.popup_list_lang_number&item_id=user_group.link_name_id_sabit_' + no + '&item=user_group.link_name_sabit_' + no +'&field_type=user_group.link_name_type_sabit_'+no+'&field_name2=user_group.link_name2_sabit_'+no,'medium');
	}	
	function pencere_ac3(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=protein.popup_list_select_switch<cfif get_main_menu.site_type eq 4>&is_pda=1</cfif>&selected_link=user_group.selected_link' + no,'medium');
	}
	function check(type)
	{
		if(document.getElementById('check_all_' + type).checked)
		{
			for(i=0;i<document.getElementsByName(type + '_ids').length;i++)
			document.getElementsByName(type + '_ids')[i].checked = true;
		}
		else
		{
			for(i=0;i<document.getElementsByName(type + '_ids').length;i++)
			document.getElementsByName(type + '_ids')[i].checked = false;
		}
	}
	//numeric textbox yapıldı.
	/*function fncNumeric(e)
	{
		var key = e.which ? e.which : e.keyCode; 
		var src = e.target ? e.target : e.srcElement; 
		if(!(key>=48 && key<=57))
		{ 
			return false; 
		} 
		else return true; 
	}*/

	function pageload(page)
	{
		hide('protein-product-detail');
		$("#tab-protein-product-detail").removeClass('active');
		$("#protein-product-detail").removeClass('active');
		
		hide('protein-pages');
		$("#tab-protein-pages").removeClass('active');
		$("#protein-pages").removeClass('active');
		
		hide('protein-reviews');
		$("#tab-protein-reviews").removeClass('active');
		$("#protein-reviews").removeClass('active');
		
		show(page);		
		$("#tab-" + page).toggleClass('active');
		$("#" + page).toggleClass('active');		
	}

</script>
