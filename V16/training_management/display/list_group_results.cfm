<cfquery name="get_classes" datasource="#dsn#">
  SELECT
    TCGC.CLASS_ID
  FROM
    TRAINING_CLASS_GROUP_CLASSES TCGC,
	TRAINING_CLASS_GROUPS TCG
  WHERE
    TCGC.TRAIN_GROUP_ID = TCG.TRAIN_GROUP_ID
	  AND
	TCG.TRAIN_GROUP_ID = #attributes.TRAIN_GROUP_ID#
</cfquery>
<cfset class_list = valuelist(get_classes.CLASS_ID)>
<cfif len(class_list)>
<cfquery name="GET_CLASS_RESULTS" datasource="#dsn#">
	SELECT
		*
	FROM
		TRAINING_CLASS_RESULTS
	WHERE
		CLASS_ID IN  (#class_list#)
</cfquery>
</cfif> 
<cfform name="add_class_results" method="post" action="#request.self#?fuseaction=training_management.emptypopup_upd_class_results">
  <!---<input type="hidden" name="class_id" value="<cfoutput>#class_id#</cfoutput>">--->
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
  <tr class="color-border">
    <td>
<table width="100%" border="0" cellspacing="1" cellpadding="2" height="100%">
  <tr class="color-list">
    <td height="35" class="headbold"><cf_get_lang no='9.Test Sonuçları'></td>
  </tr>
  <tr class="color-row">
    <td valign="top">
	<br/>
				<table border="0">
                      <tr class="txtboldblue">
                        <td height="25"><cf_get_lang_main no='158.Ad Soyad'></td>
                        <!--- <td>Yoklama*</td> --->
                        <td><cf_get_lang no='247.Ön Test S'></td>
                        <td><cf_get_lang no='248.Son Test S'></td>
                        <!--- <td>Mazeret</td> --->
                      </tr>
					 <cfif len(class_list)>
					  <cfoutput query="GET_CLASS_RESULTS">
					  <cfset attributes.employee_id = EMP_ID>	
					  <cfinclude template="../query/get_employee.cfm">
                      <tr>
                        <td>
							<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#attributes.employee_id#','medium');" class="tableyazi">#get_emp_info(EMP_ID,0,1)#</a>
							<input type="hidden" name="EMP_ID_#EMP_ID#" id="EMP_ID_#EMP_ID#" value="#EMP_ID#">
						</td>
                        <td align="center"><!---<input type="text" name="PRETEST_POINT_#EMP_ID#" style="width:60px" value="#PRETEST_POINT#">--->#PRETEST_POINT#</td>
                        <td align="center"><!---<input type="text" name="FINALTEST_POINT_#EMP_ID#" style="width:60px" value="#FINALTEST_POINT#">--->#FINALTEST_POINT#</td>
                      </tr>
					  </cfoutput>
					  </cfif>
                      
                      <!---<tr>
                        <td colspan="5" height="35" align="right">
							<cf_workcube_buttons is_upd='1' is_delete='0'>
						</td>
                      </tr>--->
                    </table>
	</td>
  </tr>
</table>
	</td>
  </tr>
</table>			
</cfform>

<script type="text/javascript">
function gizle(id1){
if(id1.style.display=='')
 	id1.style.display='none';
else
	id1.style.display='';
}
</script>

