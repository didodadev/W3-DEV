<cfif listlen(attributes.faction,'.') eq 2>
	<cfset my_faction = listgetat(attributes.faction,2,'.')>
<cfelse>
	<cfset my_faction = attributes.faction>
</cfif>
<cfdump var="#attributes.faction#">
<cfif isdefined("attributes.faction")>
	<cfquery name="GET_" datasource="#DSN#">
		SELECT 
        	LAYOUT_ID, 
            FACTION, 
            LEFT_WIDTH, 
            RIGHT_WIDTH, 
            CENTER_WIDTH, 
            MARGIN, 
            LEFT_DESIGN_ID, 
            RIGHT_DESIGN_ID, 
            CENTER_DESIGN_ID, 
            LEFT_OBJECT_NAME, 
            RIGHT_OBJECT_NAME, 
            CENTER_OBJECT_NAME, 
            RECORD_EMP, 
            RECORD_DATE, 
            RECORD_IP, 
            UPDATE_EMP, 
            UPDATE_IP, 
            UPDATE_DATE, 
            MENU_ID 
        FROM 
    	    MAIN_SITE_LAYOUTS 
        WHERE 
	        FACTION = '#my_faction#' AND MENU_ID = #attributes.menu_id#
	</cfquery>
	<cfquery name="GET_ALTS" datasource="#DSN#">
		SELECT 
        	ROW_ID, 
            OBJECT_POSITION, 
            OBJECT_NAME, 
            FACTION, 
            ORDER_NUMBER, 
            OBJECT_FILE_NAME, 
            MENU_ID, 
            DESIGN_ID 
        FROM 
    	    MAIN_SITE_LAYOUTS_SELECTS 
        WHERE 
	        FACTION = '#my_faction#' AND MENU_ID = #attributes.menu_id# 
        ORDER BY 
        	OBJECT_POSITION DESC,
			ORDER_NUMBER
	</cfquery>
	
	<cfquery name="GET_ROWS" datasource="#DSN#">
		SELECT 
        	*
        FROM 
    	    MAIN_SITE_LAYOUTS_ROWS 
        WHERE 
	        FACTION = '#my_faction#' AND 
			MENU_ID = #attributes.menu_id# AND
			LAYOUT_ID = #GET_.LAYOUT_ID#
        ORDER BY 
        	ROW_NUMBER ASC
	</cfquery>
	
	<cfquery name="GET_SITE_NAME" datasource="#DSN#">
		SELECT MENU_NAME FROM MAIN_MENU_SETTINGS WHERE MENU_ID = #attributes.menu_id#
	</cfquery>
</cfif>
<cfquery name="get_object_design" datasource="#DSN#">
	SELECT 
    	DESIGN_ID, 
        DESIGN_NAME, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP 
    FROM 
	    MAIN_SITE_OBJECT_DESIGN 
    ORDER BY 
    	DESIGN_ID
</cfquery>
<cfset design_list = valuelist(get_object_design.design_id,',')>

<table cellspacing="1" cellpadding="2" width="100%" class="color-list" align="center" height="100%">
	<tr class="color-list">
		<td height="35" class="headbold" colspan="3"><cfoutput>#getLang('settings',1456)#: #my_faction#  (#get_site_name.menu_name#)</cfoutput></td>
 	</tr>
	<tr class="color-row">
		<td valign="top" colspan="3">
			<cfif isdefined("attributes.faction")>
				<cfform action="#request.self#?fuseaction=protein.emptypopup_add_site_layout" name="add_main_" method="post">
					<input type="hidden" name="faction" id="faction" value="<cfoutput>#my_faction#</cfoutput>">
					<input type="hidden" name="menu_id" id="menu_id" value="<cfoutput>#attributes.menu_id#</cfoutput>">
					<input type="hidden" name="layout_id" id="layout_id" value="">
					<input type="hidden" name="is_add" id="is_add" value="">
					<input type="hidden" name="row_id" id="row_id" value="">
					<input type="hidden" name="col_size" id="col_size" value="">
					<input type="hidden" name="col_id" id="col_id" value="">
					<input type="hidden" name="object_id" id="object_id" value="">
					<input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_alts.recordcount#</cfoutput>">
				</cfform>
				<table>
					<tr>
						<td>
							<cfif len(get_.record_emp)><strong><cfoutput>#getLang('main',71)#:</strong>&nbsp;&nbsp;#get_emp_info(get_.record_emp,0,0)# - #dateformat(get_.record_date,'dd/mm/yyyy')#</cfoutput>&nbsp;&nbsp;</cfif><br>
							<cfif len(get_.update_emp)><strong><cfoutput>#getLang('main',479)#:</strong>&nbsp;&nbsp;#get_emp_info(get_.update_emp,0,0)# - #dateformat(get_.update_date,'dd/mm/yyyy')#</cfoutput></cfif>
						</td>
					</tr>
				</table>
				
				<cfif GET_.recordcount>
					<br>
					<table cellspacing="1" cellpadding="2" width="98%" align="center">
						<tr>
							<td colspan="3">
							<input type="button" value="Satır Ekle" onClick="add_layout_row('<cfoutput>#GET_.layout_id#</cfoutput>');"></td>
						</tr>
					</table>
					<br>
					<cfoutput query="GET_ROWS">
					
						<cfquery name="GET_COLS" datasource="#DSN#">
							SELECT 
								(SELECT SUM(COL_SIZE) FROM MAIN_SITE_LAYOUTS_COLS WHERE ROW_ID = MSLC.ROW_ID) AS TOTAL_SIZE,
								MSLC.*
							FROM 
								MAIN_SITE_LAYOUTS_COLS MSLC
							WHERE 
								MSLC.FACTION = '#my_faction#' AND 
								MSLC.MENU_ID = #attributes.menu_id# AND
								MSLC.LAYOUT_ID = #GET_.LAYOUT_ID# AND
								MSLC.ROW_ID = #row_id#
							ORDER BY 
								MSLC.COL_NUMBER ASC
						</cfquery>
					<table cellspacing="1" cellpadding="2" width="98%" align="center" class="color-header">
						<tr class="color-header">
							<td width="175" height="20">
							<input type="button" value="Satır Sil" onClick="del_layout_row('#GET_.layout_id#','#row_id#');">
							&nbsp;&nbsp;
							<input type="button" value="Kolon Ekle" onClick="show_hide('col_info_#row_id#');">
							</td>
							<td>
								<div id="col_info_#row_id#" style="display:none;">
									<input type="button" value="1" onClick="add_layout_col('#GET_.layout_id#','#row_id#','1');">
									<input type="button" value="2" onClick="add_layout_col('#GET_.layout_id#','#row_id#','2');">
									<input type="button" value="3" onClick="add_layout_col('#GET_.layout_id#','#row_id#','3');">
									<input type="button" value="4" onClick="add_layout_col('#GET_.layout_id#','#row_id#','4');">
									
									<input type="button" value="5" onClick="add_layout_col('#GET_.layout_id#','#row_id#','5');">
									<input type="button" value="6" onClick="add_layout_col('#GET_.layout_id#','#row_id#','6');">
									<input type="button" value="7" onClick="add_layout_col('#GET_.layout_id#','#row_id#','7');">
									<input type="button" value="8" onClick="add_layout_col('#GET_.layout_id#','#row_id#','8');">
									
									<input type="button" value="9" onClick="add_layout_col('#GET_.layout_id#','#row_id#','9');">
									<input type="button" value="10" onClick="add_layout_col('#GET_.layout_id#','#row_id#','10');">
									<input type="button" value="11" onClick="add_layout_col('#GET_.layout_id#','#row_id#','11');">
									<input type="button" value="12" onClick="add_layout_col('#GET_.layout_id#','#row_id#','12');">
								</div>
							</td>
						</tr>
						<tr class="color-row" height="25">
							<td colspan="2">
								<cfif GET_COLS.recordcount>
									<table width="100%">
										<tr>
											<cfloop query="GET_COLS">
												<td class="color-list" width="#wrk_round(100/GET_COLS.TOTAL_SIZE*GET_COLS.col_size)#%" valign="top">
													<cfquery name="get_objects" datasource="#dsn#">
														SELECT * FROM MAIN_SITE_LAYOUTS_SELECTS WHERE COL_ID = #GET_COLS.col_id# ORDER BY ORDER_NUMBER ASC
													</cfquery>
													
													<div>
														<input type="button" value="12/#GET_COLS.col_size#" onClick="alert('Bu Kolon Bootstrap 12/#GET_COLS.col_size# bloktur.');">
														<input type="button" value="-" onClick="del_layout_col('#GET_.layout_id#','#GET_COLS.row_id#','#GET_COLS.col_id#');">
														<input type="button" value="+" onClick="add_layout_object('#GET_.layout_id#','#GET_COLS.row_id#','#GET_COLS.col_id#');">
														<br><br>
														<cfloop query="get_objects">
															<a href="javascript://" onClick="del_layout_object('#GET_.layout_id#','#GET_COLS.row_id#','#GET_COLS.col_id#','#get_objects.row_id#');"><img src="/images/delete_list.gif">
															#get_objects.object_name#
															<br>
														</cfloop>
													</div>
												</td>
											</cfloop>
										</tr>
									</table>
								<cfelse>
									Kolon Eklenmedi!
								</cfif>
							</td>
						</tr>
					</table>
					<br>
					</cfoutput>
				</cfif>
			<cfelse>
				<cfoutput>#getLang('settings',1996)#!</cfoutput>
			</cfif>
		</td>
	</tr>
</table>
<script>
function del_layout_object(layout_id_,row_id_,col_id_,object_id_)
{
	if(confirm('Obje Silmek İstediğinize Emin misiniz?'))
	{
		document.add_main_.is_add.value = '6';
		document.add_main_.layout_id.value = layout_id_;
		document.add_main_.row_id.value = row_id_;
		document.add_main_.col_id.value = col_id_;
		document.add_main_.object_id.value = object_id_;
		document.add_main_.submit();
	}
	else
	{
		//nothing
	}
}

function add_layout_object(layout_id_,row_id_,col_id_)
{
	adress = '<cfoutput>#request.self#?fuseaction=protein.popup_select_site_files&menu_id=#attributes.menu_id#&faction=#faction#&col_id=</cfoutput>' + col_id_;
	windowopen(adress,'list');
}

function add_layout_col(layout_id_,row_id_,size_)
{
	document.add_main_.is_add.value = '4';
	document.add_main_.layout_id.value = layout_id_;
	document.add_main_.row_id.value = row_id_;
	document.add_main_.col_size.value = size_;
	document.add_main_.submit();
}

function del_layout_col(layout_id_,row_id_,col_id_)
{
	if(confirm('Kolon Silmek İstediğinize Emin misiniz?'))
	{
		document.add_main_.is_add.value = '5';
		document.add_main_.layout_id.value = layout_id_;
		document.add_main_.row_id.value = row_id_;
		document.add_main_.col_id.value = col_id_;
		document.add_main_.submit();
	}
	else
	{
		//nothing
	}
}

function add_layout_row(layout_id_)
{
	document.add_main_.is_add.value = '2';
	document.add_main_.layout_id.value = layout_id_;
	document.add_main_.submit();
}

function del_layout_row(layout_id_,row_id_)
{
	if(confirm('Satır Silmek İstediğinize Emin misiniz?'))
	{
		document.add_main_.is_add.value = '3';
		document.add_main_.layout_id.value = layout_id_;
		document.add_main_.row_id.value = row_id_;
		document.add_main_.submit();
	}
	else
	{
		//nothing
	}
}
</script>