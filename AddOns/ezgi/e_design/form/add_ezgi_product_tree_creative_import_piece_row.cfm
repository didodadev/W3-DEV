<cfquery name="get_colors" datasource="#dsn3#">
	SELECT * FROM EZGI_COLORS ORDER BY COLOR_NAME
</cfquery>
<cfquery name="get_design_main_row" datasource="#dsn3#">
	SELECT * FROM EZGI_DESIGN_MAIN_ROW WHERE DESIGN_MAIN_ROW_ID = #attributes.design_main_row_id#
</cfquery>
<br />
<cf_form_box title="#getLang('main',2848)# #getLang('main',1156)#">
	<cfform name="add_design_import_piece_row" method="post" action="#request.self#?fuseaction=prod.emptypopup_add_ezgi_product_tree_creative_import_piece_row" enctype="multipart/form-data">
    	<cfoutput>
    	<cfinput type="hidden" name="design_main_row_id" value="#attributes.design_main_row_id#">
    	<br />
		<table>
            <tr>
                <td width="120"><cf_get_lang no ='429.Modül'> <cf_get_lang_main no ='485.Adı'></td>
                <td width="250">#get_design_main_row.DESIGN_MAIN_NAME#</td>
            </tr>
            <tr>
                <td><cf_get_lang_main no='1118.Aktarım Türü'></td>
                <td>
                    <select name="file_type" id="file_type" style="width:200px;" onchange="file_type_();">
                        <option value="1">Excel</option>
                        <option value="2">Autocad</option>
                        <option value="3">TopSolid</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td><cfoutput>#getLang('product',752)#</cfoutput></td>
                <td>
                    <select name="file_format" id="file_format" style="width:200px;">
                        <option value="UTF-8">UTF-8</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang_main no='56.Belge'>*</td>
                <td><input type="file" name="uploaded_file" id="uploaded_file" style="width:200px;"></td>
            </tr>
     	</table>
        <br />
		<table id="autocad" style="display:none">
            <tr>
				<td colspan="2">
                	<strong><cf_get_lang_main no='1182.Format'> :</strong><br/>
					<cfoutput>#getLang('settings',2999)# #getLang('main',3024)# #getLang('settings',3057)#</cfoutput>;<br/>
                 	<cfoutput>#getLang('main',2848)# #getLang('main',75)#</cfoutput> 			: 
					<cfoutput>#getLang('main',2848)# #getLang('main',3025)#(#getLang('main',2004)#) </cfoutput><br />
                    <cfoutput>#getLang('settings',1133)# #getLang('main',2848)# ID</cfoutput> 	: 
					<cfoutput>(#getLang('main',2004)#) </cfoutput> <br />
                    <cfoutput>#getLang('main',2848)# #getLang('main',3002)# ID </cfoutput>		: 
                    <cfoutput>#getLang('main',3027)#</cfoutput> <br />
                    <cfoutput>#getLang('main',3028)#</cfoutput>		: 
                    <cfoutput>(#getLang('main',2004)#)</cfoutput>	<br />
                    <cfoutput>#getLang('main',2848)# #getLang('main',2878)# ID </cfoutput>  	: 
                    <cfoutput>#getLang('main',3029)#</cfoutput><br />
                    <cfoutput>#getLang('main',3030)#</cfoutput>			: 
                    <cfoutput>#getLang('main',3031)# (#getLang('main',2004)#) </cfoutput><br />
                    <cfoutput>#getLang('main',3032)#</cfoutput>			: 
                    <cfoutput>#getLang('main',3031)# (#getLang('main',2004)#) </cfoutput> <br />
                    <cfoutput>#getLang('main',3033)#</cfoutput>			: 
                    <cfoutput>#getLang('main',3034)#</cfoutput><br />
                    <cfoutput>#getLang('main',2903)# #getLang('main',75)#</cfoutput>		: 
                    <cfoutput>#getLang('main',3035)# </cfoutput><br />
                    <cfoutput>1. #getLang('main',3036)# PVC </cfoutput> 	: 
                    <cfoutput>#getLang('main',3037)#</cfoutput><br />
                    <cfoutput>1. #getLang('main',3036)# STOCK_ID </cfoutput> : 
                    <cfoutput>(#getLang('main',3038)#)</cfoutput><br />
                    <cfoutput>2. #getLang('main',3036)# PVC </cfoutput> 	: 
                    <cfoutput>#getLang('main',3037)#</cfoutput><br />
                    <cfoutput>2. #getLang('main',3036)# STOCK_ID </cfoutput> : 
                    <cfoutput>(#getLang('main',3038)#)</cfoutput> <br />
                    <cfoutput>1. #getLang('main',3039)# PVC </cfoutput> 	: 
                    <cfoutput>#getLang('main',3037)#</cfoutput><br />
                    <cfoutput>1. #getLang('main',3039)# STOCK_ID </cfoutput> : 
                    <cfoutput>(#getLang('main',3038)#)</cfoutput><br />
                    <cfoutput>2. #getLang('main',3039)# PVC </cfoutput> 	: 
                    <cfoutput>#getLang('main',3037)#</cfoutput><br />
                    <cfoutput>2. #getLang('main',3039)# STOCK_ID </cfoutput> :
                    <cfoutput>(#getLang('main',3038)#)</cfoutput> <br /><br />
                    <span style="color:red"><cf_get_lang_main no='1187.Dikkat'> : <cf_get_lang_main no='3023.En ve Boyda küsürat varsa (.) nokta ile belirtilmeli (,) virgül asla kullanılmamalıdır.'></span><br />
					<strong><cf_get_lang_main no='1555.Örnek'>:</strong><br/>
                    A;B;C;D;E;F;G;H;I;J;K;L;M;N;O;P;Q<br />
                    3;3;7;1;;800;745;1;1;1;297;1;297;0;;1;297<br />
					4;83;;1;;1000;710.5;;;;;;;;;;<br />
				</td>
			</tr>
        </table>
        <table id="excel">
            <tr>
				<td colspan="2">
                	<strong><cf_get_lang_main no='1182.Format'> :</strong><br/>
					<cfoutput>#getLang('settings',2999)# #getLang('main',3024)# #getLang('settings',3057)#</cfoutput>;<br/>
                 	<cfoutput>#getLang('main',2848)# #getLang('main',75)#</cfoutput> 			: 
					<cfoutput>#getLang('main',2848)# #getLang('main',3025)#(#getLang('main',2004)#) </cfoutput><br />
                    <cfoutput>#getLang('settings',1133)# #getLang('main',485)#</cfoutput> 		: 
                    <cfoutput>#getLang('main',3026)# (#getLang('main',2004)#)</cfoutput> <br />
                    <cfoutput>#getLang('main',2848)# #getLang('main',2914)#</cfoutput>		: 
                    <cfoutput>#getLang('main',3027)#</cfoutput><br />
                    <cfoutput>#getLang('main',3028)#</cfoutput>		:
                    <cfoutput>(#getLang('main',2004)#)</cfoutput><br />
                    <cfoutput>#getLang('main',3040)#</cfoutput>		: 
                    <cfoutput>#getLang('main',3031)# #getLang('main',3029)#</cfoutput><br />
                    <cfoutput>#getLang('main',3030)#</cfoutput>			: 
                    <cfoutput>#getLang('main',3031)# (#getLang('main',2004)#)</cfoutput><br />
                    <cfoutput>#getLang('main',3032)#</cfoutput>			: 
                    <cfoutput>#getLang('main',3031)# (#getLang('main',2004)#)</cfoutput> <br />
                    <cfoutput>#getLang('main',3033)#</cfoutput>			:
                    <cfoutput>#getLang('main',3034)#</cfoutput><br />
                    <cfoutput>#getLang('main',2903)# #getLang('main',75)#</cfoutput>	: 
                    <cfoutput>#getLang('main',3035)#</cfoutput><br />
                    <cfoutput>1. #getLang('main',3036)# PVC </cfoutput> 	: 
                    <cfoutput>#getLang('main',3037)#</cfoutput><br />
                    <cfoutput>1. #getLang('main',3036)# STOCK_ID </cfoutput> : 
                    <cfoutput>(#getLang('main',3038)#)</cfoutput><br />
                    <cfoutput>2. #getLang('main',3036)# PVC </cfoutput> 	: 
                    <cfoutput>#getLang('main',3037)#</cfoutput><br />
                    <cfoutput>2. #getLang('main',3036)# STOCK_ID </cfoutput> : 
                    <cfoutput>(#getLang('main',3038)#)</cfoutput> <br />
                    <cfoutput>1. #getLang('main',3039)# PVC </cfoutput> 	: 
                    <cfoutput>#getLang('main',3037)#</cfoutput><br />
                    <cfoutput>1. #getLang('main',3039)# STOCK_ID </cfoutput> : 
                    <cfoutput>(#getLang('main',3038)#)</cfoutput><br />
                    <cfoutput>2. #getLang('main',3039)# PVC </cfoutput> 	: 
                    <cfoutput>#getLang('main',3037)#</cfoutput><br />
                    <cfoutput>2. #getLang('main',3039)# STOCK_ID </cfoutput> :
                    <cfoutput>(#getLang('main',3038)#)</cfoutput> <br /><br />
                    <span style="color:red"><cf_get_lang_main no='1187.Dikkat'> : <cf_get_lang_main no='3023.En ve Boyda küsürat varsa (.) nokta ile belirtilmeli (,) virgül asla kullanılmamalıdır.'></span><br />
					<strong><cf_get_lang_main no='1555.Örnek'>:</strong><br/>
                    A;B;C;D;E;F;G;H;I;J;K;L;M;N;O;P;Q<br />
                    <cfoutput>3;#getLang('main',3041)#;Wenge;1;18;800;745;1;1;1;PVC Barok 22*0,4;1;;0;;1;PVC Nil 22*0,8</cfoutput><br />
					<cfoutput>4;#getLang('campaign',76)#;;2;;1000;710.5;;;;;;;;;;</cfoutput><br />
				</td>
			</tr>
        </table>
        <table id="topsolid"  style="display:none">
            <tr>
				<td colspan="2">
                	<strong><cf_get_lang_main no='1182.Format'> :</strong><br/>
					<cfoutput>#getLang('settings',2999)# #getLang('main',3024)# #getLang('settings',3057)#</cfoutput>;<br/>
                 	<cfoutput>#getLang('main',2848)# #getLang('main',75)#</cfoutput> 			: 
					<cfoutput>#getLang('main',2848)# #getLang('main',3025)#(#getLang('main',2004)#) </cfoutput><br />
                    <cfoutput>#getLang('settings',1133)# #getLang('main',485)#</cfoutput> 		: 
                    <cfoutput>#getLang('settings',1133)# #getLang('main',2848)# ID - #getLang('main',3026)# (#getLang('main',2004)#)</cfoutput> <br />
                    <cfoutput>#getLang('main',2848)# #getLang('main',3002)# ID </cfoutput>		: 
                    <cfoutput>#getLang('main',3027)#</cfoutput><br />
                    <cfoutput>#getLang('main',3028)#</cfoutput>		: 
                    <cfoutput>(#getLang('main',2004)#)</cfoutput><br />
                    <cfoutput>#getLang('main',3040)#</cfoutput>		:
                    <cfoutput>#getLang('main',3031)# #getLang('main',3029)#</cfoutput><br />
                    <cfoutput>#getLang('main',3030)#</cfoutput>		:
                    <cfoutput>#getLang('main',3031)# (#getLang('main',2004)#)</cfoutput><br />
                    <cfoutput>#getLang('main',3032)#</cfoutput>		: 
                    <cfoutput>#getLang('main',3031)# (#getLang('main',2004)#)</cfoutput><br />
                    <cfoutput>#getLang('main',3033)#</cfoutput>		:
                    <cfoutput>#getLang('main',3034)#</cfoutput><br />
                    <cfoutput>#getLang('main',2903)# #getLang('main',75)#</cfoutput>	: 
                    <cfoutput>#getLang('main',3035)#</cfoutput><br />
                    <cfoutput>1. #getLang('main',3036)# PVC </cfoutput> 	: 
                    <cfoutput>#getLang('main',3037)#</cfoutput><br />
                    <cfoutput>1. #getLang('main',3036)# STOCK_ID </cfoutput> : 
                    <cfoutput>(#getLang('main',3038)#)</cfoutput><br />
                    <cfoutput>2. #getLang('main',3036)# PVC </cfoutput> 	: 
                    <cfoutput>#getLang('main',3037)#</cfoutput><br />
                    <cfoutput>2. #getLang('main',3036)# STOCK_ID </cfoutput> : 
                    <cfoutput>(#getLang('main',3038)#)</cfoutput> <br />
                    <cfoutput>1. #getLang('main',3039)# PVC </cfoutput> 	: 
                    <cfoutput>#getLang('main',3037)#</cfoutput><br />
                    <cfoutput>1. #getLang('main',3039)# STOCK_ID </cfoutput> : 
                    <cfoutput>(#getLang('main',3038)#)</cfoutput><br />
                    <cfoutput>2. #getLang('main',3039)# PVC </cfoutput> 	: 
                    <cfoutput>#getLang('main',3037)#</cfoutput><br />
                    <cfoutput>2. #getLang('main',3039)# STOCK_ID </cfoutput> :
                    <cfoutput>(#getLang('main',3038)#)</cfoutput> <br /><br />
                    <span style="color:red"><cf_get_lang_main no='1187.Dikkat'> : <cf_get_lang_main no='3023.En ve Boyda küsürat varsa (.) nokta ile belirtilmeli (,) virgül asla kullanılmamalıdır.'></span><br />
					<strong><cf_get_lang_main no='1555.Örnek'>:</strong><br/>
                    A;B;C;D;E;F;G;H;I;J;K;L;M;N;O;P;Q<br />
                    <cfoutput>3;32-#getLang('main',3041)#;8;1;18;800;745;1;1;1;;1;;0;;1;297</cfoutput><br />
					<cfoutput>4;25-#getLang('campaign',76)#;;2;;1000;710.5;;;;;;;;;;</cfoutput><br />
				</td>
			</tr>
        </table>
	    <cf_form_box_footer>
		    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
	    </cf_form_box_footer>
        </cfoutput>
	</cfform>
</cf_form_box>
<script type="text/javascript">
	function file_type_()
	{
		if(document.getElementById('file_type').value == 1)
		{
			document.getElementById('excel').style.display = '';
			document.getElementById('autocad').style.display = 'none';
			document.getElementById('topsolid').style.display = 'none';
		}
		else if(document.getElementById('file_type').value == 2)
		{
			document.getElementById('excel').style.display = 'none';
			document.getElementById('autocad').style.display = '';
			document.getElementById('topsolid').style.display = 'none';
		}
		else if(document.getElementById('file_type').value == 3)
		{
			document.getElementById('excel').style.display = 'none';
			document.getElementById('autocad').style.display = 'none';
			document.getElementById('topsolid').style.display = '';
		}
	}
</script>