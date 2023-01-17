<cfquery name="get_emps" datasource="#DSN#">
	SELECT 
	  EMPLOYEE_NAME,
	  EMPLOYEE_SURNAME,
	  POSITION_CODE,
	  POSITION_CAT_ID,
	  EMPLOYEE_ID 
	FROM 
	  EMPLOYEE_POSITIONS
	ORDER BY
	  EMPLOYEE_NAME
</cfquery>
<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
  <tr>
    <td  height="35"class="headbold"><cf_get_lang_main no='1463.Çalışanlar'></td>
  </tr>
</table>
        <table width="98%" height="100%" cellpadding="2" cellspacing="1" border="0" class="color-border" align="center">
		 <cfform name="emps" method="post" action="#request.self#?fuseaction=settings.user_permission">
          <tr height="22" class="color-header">
            <td width="150" class="form-title"><cf_get_lang_main no='1592.Pozisyon Kategorisi'></td>
            <td class="form-title"><cf_get_lang_main no='164.Çalışan'></td>
            <td></td>

          </tr>
          <cfif get_emps.RECORDCOUNT>
            <cfoutput query="get_emps">
              <tr class="color-row" height="20">
               
                <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#EMPLOYEE_ID#','medium')" class="tableyazi">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a></td>
                <td>
                  <cfquery name="GET_POS_CAT_NAME" datasource="#DSN#">
                  SELECT POSITION_CAT FROM SETUP_POSITION_CAT WHERE POSITION_CAT_ID = #POSITION_CAT_ID#
                  </cfquery>
                  #GET_POS_CAT_NAME.POSITION_CAT# 
				</td>
			    <td width="10">
				  <cfif isDefined("URL.ID")>
				  <cfquery name="CONTROL" datasource="#DSN#">
				     SELECT 
					   POSITION_CODE 
					 FROM 
					   EMPLOYEE_POSITIONS_DENIED 
					 WHERE
					   DENIED_PAGE_ID = #URL.ID# 
					     AND
					   POSITION_CODE = #POSITION_CODE#
				  </cfquery>
				 </cfif>
				<input type="checkbox" name="emps_id" id="emps_id" value="#POSITION_CODE#" <cfif  isDefined("URL.ID") AND CONTROL.RECORDCOUNT>CHECKED</cfif>>
                </td>
                <input type="hidden" name="emp_names" id="emp_names" value="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#">
              </tr>
            </cfoutput>
            <cfelse>
            <tr class="color-row" height="20">
              <td colspan="3"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
            </tr>			
          </cfif>
		      <tr>
      <td height="25" colspan="3" align="right" class="color-list" style="text-align:right;">
        <input  type="button" value="<cf_get_lang_main no='1281.Seç'>" style="width:65px;" onClick="sec();">
      </td>
    </tr>
  </cfform>
</table>
<br/>
<script type="text/javascript">
  function sec()
  {
  text_ = "";
  value_ = "";
	for (i=0; i < emps.emps_id.length; i++)
		{
		if (emps.emps_id[i].checked) 
			{
			value_ = value_ + emps.emps_id[i].value + ",";
			text_ = text_ + emps.emp_names[i].value + "<br/>";
			}
		}

	/*sondaki virgülü at*/
	if (value_.length != 0)
		{
		value_ = value_.substr(0,value_.length-1);
		}
	
		opener.<cfoutput>#attributes.field_id#</cfoutput>.value = "," + value_ + ",";
		opener.<cfoutput>#attributes.field_td#</cfoutput>.innerHTML = text_;
		
	window.close();	
	return true;
  }
</script>

