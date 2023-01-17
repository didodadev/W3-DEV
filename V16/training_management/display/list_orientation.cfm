<cfparam name="attributes.keyword" default="">
<cfset url_str = "">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>

<cfquery name="GET_ORIENTATION" datasource="#DSN#">
	SELECT 
		ATTENDER_EMP,
		TRAINER_EMP,
		START_DATE,
		FINISH_DATE,
		ORIENTATION_ID,
		ORIENTATION_HEAD
	FROM 
		TRAINING_ORIENTATION,
		EMPLOYEES
	WHERE
		TRAINING_ORIENTATION.ATTENDER_EMP = EMPLOYEES.EMPLOYEE_ID
	<cfif len(attributes.keyword)>
	AND
		(
		TRAINING_ORIENTATION.ORIENTATION_HEAD LIKE '%#attributes.keyword#%'  
	OR
		EMPLOYEES.EMPLOYEE_NAME LIKE '%#attributes.keyword#%'  
	OR
		EMPLOYEES.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'  
		)
	</cfif>
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#GET_ORIENTATION.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" height="35">
        <tr>
          <td class="headbold"> 
		    <cf_get_lang no='58.Oryantasyon'>
          </td>
          <td valign="bottom" style="text-align:right;">
            <table>
              <cfform name="form1" method="post" action="">
                <tr>
                  <td class="label"><cf_get_lang_main no='48.Filtre'>:</td>
                  <td><cfinput type="text" name="keyword" value="#attributes.keyword#"></td>
                  <td>
					<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
			  </td>
                  <td><cf_wrk_search_button></td>
                </tr>
              </cfform>
            </table>
          </td>
        </tr>
      </table>
      <table cellSpacing="0" cellpadding="0" border="0" width="98%" align="center">
        <tr class="color-border">
          <td>
            <table cellspacing="1" cellpadding="2" width="100%" border="0">
              <tr class="color-header">
                <td height="22" class="form-title"><cf_get_lang_main no='68.Konu'> </td>
                <!--- <td class="form-title" ><cf_get_lang no='32.Amaç'></td> --->
				<td class="form-title" width="150"><cf_get_lang no='154.Katılan'></td>
				<td class="form-title" width="150"><cf_get_lang_main no='132.Sorumlu'></td>
                <td class="form-title" width="85"><cf_get_lang_main no='243.Baş Tarihi'></td>
				<td class="form-title" width="60"><cf_get_lang_main no='288.Bit Tarihi'></td>
				<td width="15"><a href="javascript://" onClick="windowopen(<cfoutput>'#request.self#?fuseaction=training_management.popup_add_training_orientation</cfoutput>','small');"><img src="/images/plus_square.gif" title="<cf_get_lang_main no='170.Ekle'>" border="0"></a></td>
              </tr>
              <cfif GET_ORIENTATION.recordcount>
                <cfoutput query="GET_ORIENTATION" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                  <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                    <td>
					 <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_upd_training_orientation&orientation_id=#orientation_id#','medium');" class="tableyazi">#ORIENTATION_HEAD#</a>
					</td>
					<td>
					  <cfif len(ATTENDER_EMP)>
					    <cfquery name="GET_EMP_NAME" datasource="#DSN#">
						   SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #ATTENDER_EMP#
						</cfquery>
					    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_detail_emp&emp_id=#attender_emp#','project');" class="tableyazi">#GET_EMP_NAME.EMPLOYEE_NAME# #GET_EMP_NAME.EMPLOYEE_SURNAME#</a>
					  </cfif>
					</td>
					<td>
					  <cfif len(TRAINER_EMP)>
					    <cfquery name="GET_EMP_NAME" datasource="#DSN#">
						   SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #TRAINER_EMP#
						</cfquery>
					    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_detail_emp&emp_id=#trainer_emp#','project');" class="tableyazi">#GET_EMP_NAME.EMPLOYEE_NAME# #GET_EMP_NAME.EMPLOYEE_SURNAME#</a>
					  </cfif>
					</td>
                    <td>
					 <cfif LEN(START_DATE)>
					   #dateformat(START_DATE,dateformat_style)#
					 </cfif>
					</td>
					<td>
					  <cfif LEN(FINISH_DATE)>
					   #dateformat(FINISH_DATE,dateformat_style)#
					 </cfif>
					</td>
					<td align="center"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_upd_training_orientation&orientation_id=#orientation_id#','small');"><img src="/images/update_list.gif" border="0"></a></td>
					
                  </tr>
                </cfoutput>
                <cfelse>
                <tr class="color-row" height="20">
                  <td colspan="6"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
                </tr>
              </cfif>
            </table>
          </td>
        </tr>
      </table>
      <cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
        <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
          <tr>
            <td height="35">
			<cf_pages 
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="training_management.list_training_orientation#url_str#"></td>
            <!-- sil --><td style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
          </tr>
        </table>
      </cfif>
<br/>
