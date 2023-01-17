<cfquery name="GET_P_CAT" datasource="#dsn#">
		SELECT
			*
		FROM
			ASSET_P_CAT
		WHERE IT_ASSET = 1 	
</cfquery>
<cfquery name="GET_BRANCHS_DEPS" datasource="#dsn#">
	SELECT 
		DEPARTMENT.DEPARTMENT_ID, 
		DEPARTMENT.BRANCH_ID,
		DEPARTMENT.DEPARTMENT_HEAD,
		BRANCH.BRANCH_ID,
		BRANCH.BRANCH_NAME
	FROM 
		BRANCH,
		DEPARTMENT 
	WHERE
		BRANCH.BRANCH_ID=DEPARTMENT.BRANCH_ID
</cfquery>
<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
  <tr>
	<td valign="top"> 
		      <table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%" class="color-border" align="center">
	        		<tr class="color-list" valign="middle"> 
		          		<td height="35" class="headbold"><cf_get_lang no='53.IT Bilgisi'></td>
						</tr>
							<tr class="color-row" valign="top"> 
								<td>
									<table width="537">
									<cfform action="#request.self#?fuseaction=asset.emptypopup_addit_assetp&assetp_id=#asset_id#" method="post" name="asset_care">
										<tr>
											<td width="5"></td>
											<td width="102"><cf_get_lang no='61.işlemci'></td>
											<td width="144"><input type="text" style="width:140" value="" name="IT_PRO" id="IT_PRO"></td>
											<td width="77"><cf_get_lang no='62.Ek Özellik'> 1</td>
											<td width="185"><input type="text" style="width:140" value="" name="IT_PROPERTY1" id="IT_PROPERTY1"></td>
										</tr>
										<tr>
											<td></td>
											<td><cf_get_lang no='63.Bellek'></td>
											<td><input type="text" style="width:140" value="" name="IT_MEMORY" id="IT_MEMORY"></td>
											<td width="77"><cf_get_lang no='62.Ek Özellik'> 2</td>
											<td><input type="text" style="width:140" value="" name="IT_PROPERTY2" id="IT_PROPERTY2"></td>
										</tr>
										<tr>
											<td width="5"></td>	
											<td><cf_get_lang no='64.Hard Disk'></td>
											<td><input type="text" style="width:140" value="" name="IT_HDD" id="IT_HDD"></td>
											<td width="77"><cf_get_lang no='62.Ek Özellik'> 3</td>
											<td><input type="text" style="width:140" value="" name="IT_PROPERTY3" id="IT_PROPERTY3"></td>
									    <tr>
											<td width="5"></td>
											<td><cf_get_lang no='65.Konfigürasyon'></td>
											<td><input type="text" style="width:140" value="" name="IT_CON" id="IT_CON"></td>
											<td width="77"><cf_get_lang no='62.Ek Özellik'> 4</td>
											<td><input type="text" style="width:140" value="" name="IT_PROPERTY4" id="IT_PROPERTY4"></td>
									    <tr>
											<td width="5"></td>
											<td valign="top"></td>
											<td>&nbsp;</td>
											<td width="77"><cf_get_lang no='62.Ek Özellik'> 5</td>
											<td><input type="text" style="width:140" value="" name="IT_PROPERTY5" id="IT_PROPERTY5"></td>
									   </tr>
									    <tr>
											<td width="5"></td>
											<td valign="top"></td>
											<td>&nbsp;</td>
									   </tr>
									    <tr> 
											<td height="35" colspan="5"  style="text-align:right;">
											<cf_workcube_buttons is_upd='0'> 
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											</td>
									   </tr>
						   		</cfform>
							</table>
						  </td>
						</tr>
				  </table>
    			</td>
			  </tr>
		</table>
