<cfquery name="GET_POSITION" datasource="#dsn#">
	SELECT POSITION_ID FROM COMPANY_POSITION WHERE COMPANY_ID = #attributes.cpid#
</cfquery>
<cfquery name="GET_STOCKS" datasource="#dsn#">
	SELECT STOCK_ID, STOCK_NAME FROM SETUP_STOCK_AMOUNT ORDER BY STOCK_ID
</cfquery>
<cfquery name="GET_DUTY_PERIOD" datasource="#dsn#">
	SELECT PERIOD_ID, PERIOD_NAME FROM SETUP_DUTY_PERIOD ORDER BY PERIOD_ID
</cfquery>
<cfquery name="GET_CUSTOMER_POSITION" datasource="#dsn#">
	SELECT COMPANY_POSITION.POSITION_ID,SETUP_CUSTOMER_POSITION.POSITION_NAME 
	FROM 
	SETUP_CUSTOMER_POSITION, COMPANY_POSITION
	WHERE 
	COMPANY_POSITION.POSITION_ID = SETUP_CUSTOMER_POSITION.POSITION_ID AND 
	COMPANY_POSITION.COMPANY_ID = #attributes.cpid#
	ORDER BY SETUP_CUSTOMER_POSITION.POSITION_ID
</cfquery>
<cfquery name="GET_LOCS" datasource="#dsn#">
	SELECT DEPOT_ID, DEPOT_KM, DEPOT_MINUTE FROM COMPANY_DEPOT_DISTANCE WHERE COMPANY_ID = '#attributes.cpid#' ORDER BY DEPOT_ID
</cfquery>
<cfquery name="GET_DEPOTS" datasource="#dsn#">
		SELECT 
			OC.NICK_NAME,
			B.BRANCH_NAME,
			B.BRANCH_ID 	 
		FROM 
			COMPANY_BRANCH_RELATED CBR,
			BRANCH B,
			OUR_COMPANY OC   
		WHERE
			CBR.MUSTERIDURUM IS NOT NULL AND
			CBR.OUR_COMPANY_ID = OC.COMP_ID AND
			CBR.BRANCH_ID = B.BRANCH_ID AND
			CBR.COMPANY_ID = #attributes.cpid# 
		ORDER BY 
			B.BRANCH_ID
	</cfquery>
<cfquery name="GET_INFO" datasource="#dsn#">
	SELECT STOCK_AMOUNT,DUTY_PERIOD FROM COMPANY WHERE COMPANY_ID = '#attributes.cpid#'
</cfquery>
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr class="color-list">
    <td height="35" class="headbold"><cf_get_lang no='294.Lokasyon Bilgileri'></td>
  </tr>
  <tr class="color-row">
    <td valign="top">
      <table>
        <cfform  method="post" name="add_company_location" action="#request.self#?fuseaction=crm.emptypopup_upd_company_location&cpid=#attributes.cpid#">
          <input name="record" id="record" value="<cfoutput>#get_depots.recordCount#</cfoutput>" type="hidden">
          <tr>
            <td><cf_get_lang no='120.Müşterinin Genel Konumu'></td>
            <td rowspan="3" width="170">
              <table border="0" cellpadding="0" cellspacing="0" >
			  <tr>
			  <td>
			  <select name="customer_position" id="customer_position" style="width:150px;height=60;" multiple>
                <cfoutput query="get_customer_position">
                  <option value="#position_id#">#position_name#</option>
                </cfoutput>
              </select>
			  </td>
			  <td valign="top">
			  <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_position_detail&field_name=add_company_location.customer_position','medium');"><img src="/images/plus_thin.gif" border="0" align="top"></a><br/>
			  <a href="javascript://" onClick="kaldir();"><img src="/images/delete_list.gif" border="0" title="Sil" style="cursor=hand" align="top"></a>
				</td>
			  </tr>
			  </table>
		    </td>
            <td width="120"><cf_get_lang no='149.Stok ve Raf Durumu'></td>
            <td><select name="stock_amount" id="stock_amount" style="width:150;">
                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                <cfoutput query="get_stocks">
                  <option value="#stock_id#" <cfif stock_id eq get_info.stock_amount>selected</cfif>>#stock_name#</option>
                </cfoutput>
              </select></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td><cf_get_lang no='123.Müşteri Nöbet Durumu'></td>
            <td><select name="duty_period" id="duty_period" style="width:150px;">
                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                <cfoutput query="get_duty_period">
                  <option value="#period_id#" <cfif get_info.duty_period eq period_id>selected</cfif>>#period_name#</option>
                </cfoutput>
              </select></td>
          </tr>
		  <tr>
		  <td>&nbsp;</td>
		  <td>&nbsp;</td>
		  <td><cf_workcube_buttons is_upd='1' is_delete='0' add_function='hepsini_sec()' is_cancel="0"></td>
		  </tr>
          <cfif get_depots.recordCount>
            <tr>
              <td class="txtboldblue"><cf_get_lang no='232.Depoya Uzaklık'> </td>
			  <td>&nbsp;</td>
            </tr>
            <cfset liste = ValueList(get_depots.branch_id)>
            <cfoutput>
              <cfloop index="i" from="1" to="#ListLen(liste)#">
                <tr>
                  <td>#get_depots.nick_name[i]# / #get_depots.branch_name[i]#<input name="depot_id#i#" id="depot_id#i#" type="hidden" value="#get_depots.branch_id[i]#"></td>
                  <td><cfsavecontent variable="message1"><cf_get_lang dictionary_id="31760.Yanlış Veri Girdiniz">!</cfsavecontent>
				  <cfinput name="depot_km#i#" style="width:60;" value="#get_locs.depot_km[i]#" validate="float" message="#message1#">&nbsp; km.
                    <cfinput name="depot_minute#i#" style="width:60;" value="#get_locs.depot_minute[i]#" validate="float" message="#message1#">&nbsp;dak.</td>
                </tr>
              </cfloop>
            </cfoutput>
          </cfif>
        </cfform>
      </table>
    </td>
  </tr>
</table>
<script language="JavaScript" type="text/javascript">
function hepsini_sec()
{
	select_all('customer_position');
}
function select_all(selected_field){
	var m = eval("document.add_company_location."+selected_field+".length");
	for(i=0;i<m;i++)
	{
		eval("document.add_company_location."+selected_field+"["+i+"].selected=true")
	}
}

function kaldir()
{
	for (i=document.add_company_location.customer_position.options.length-1;i>-1;i--)
	{
		if (document.add_company_location.customer_position.options[i].selected==true)
		{
			document.add_company_location.customer_position.options.remove(i)
		}	
	}
		}
</script>
