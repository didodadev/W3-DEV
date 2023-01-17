      <table CELLSPACING="0" CELLPADDING="0" WIDTH="98%" border="0">
        <tr CLASS="color-border">
          <td>
            <table CELLSPACING="1" CELLPADDING="2" WIDTH="100%" border="0">
              <tr CLASS="color-header"  HEIGHT="22">
                <td CLASS="form-title" WIDTH="235" STYLE="cursor:pointer;" onClick="gizle_goster(kredi);"><cf_get_lang no='25.Kredi Kartları'></td>
                <cfoutput>
                  <cfif not listfindnocase(denied_pages,'crm.form_add_cc_comp_popup')><td CLASS="form-title" ALIGN="center" width="15"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=crm.form_add_cc_comp_popup&cpid=#url.cpid#','small')"><img src="/images/plus_square.gif" alt="" border="0"></a></td></cfif>
                </cfoutput> </tr>
              <tr CLASS="color-row" STYLE="display:none;" ID="kredi">
                <td COLSPAN="2" height="20">
                  <cfquery name="GET_CC_COMPANY" datasource="#dsn#">
					SELECT
					  	CC.*, SC.CARDCAT
					FROM
						COMPANY_CC CC, SETUP_CREDITCARD SC
					WHERE
						CC.COMPANY_ID = #URL.CPID# AND CC.COMPANY_CC_TYPE=SC.CARDCAT_ID
                  </cfquery>
                  <cfoutput query="get_cc_company"> <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=crm.form_add_cc_comp_popup&cpid=#url.cpid#&ccid=#COMPANY_CC_ID#','small')"><B>#CARDCAT#</B>/#mid(company_cc_number,1,3)#--------/<B>#company_ex_month# - #company_ex_year#</B></a><br/>
                  </cfoutput>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
