<!---
form_action : formun action
list_id : kayıt yapılacak list_id
--->
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.keyword2" default="">
<cfparam name="attributes.status" default="">

<cfquery name="get_cv" datasource="#dsn#">
	SELECT
		AP.EMPAPP_ID,
		AP.NAME,
		AP.SURNAME,
		AP.SEX,
		AP.RECORD_DATE
	FROM
		EMPLOYEES_APP AP
	WHERE
		1=1
		<cfif len(attributes.keyword)>
		 AND (AP.NAME LIKE '#attributes.keyword#%')
		</cfif>
		<cfif len(attributes.keyword2)>
		 AND (AP.SURNAME LIKE '#attributes.keyword2#%')
		</cfif>
		<cfif len(attributes.status)>
		 AND AP.APP_STATUS=#attributes.status#
		</cfif>
	ORDER BY 
		NAME
</cfquery>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_cv.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_str = "">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.keyword2)>
	<cfset url_str = "#url_str#&keyword2=#attributes.keyword2#">
</cfif>
<cfif len(attributes.status)>
	<cfset url_str = "#url_str#&status=#attributes.status#">
</cfif>
<cfif isdefined('attributes.form_action')>
	<cfset url_str = "#url_str#&form_action=#attributes.form_action#">
</cfif>
<cfif isdefined('attributes.list_id')>
	<cfset url_str = "#url_str#&list_id=#attributes.list_id#">
</cfif>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="29767.CV"></cfsavecontent>
<div class="col col-12">
    <cf_box title="#message#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cf_medium_list_search>
        <cf_medium_list_search_area>
            <cfform name="empapp_list" action="#request.self#?fuseaction=hr.popup_list_employees_app" method="post">
            <table>
                <input type="hidden" name="list_id" id="list_id" value="<cfoutput>#attributes.list_id#</cfoutput>">
                <input type="hidden" name="form_action" id="form_action" value="<cfoutput>#attributes.form_action#</cfoutput>">
                <tr>
                    <td><cf_get_lang dictionary_id="57631.Ad"></td>
                    <td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>	
                    <td><cf_get_lang dictionary_id="58726.Soyad"></td>
                    <td><cfinput type="text" name="keyword2" style="width:100px;" value="#attributes.keyword2#" maxlength="255"></td>	
                    <td>
                        <select name="status" id="status">
                        <option value="" <cfif attributes.status eq 2>selected</cfif>><cf_get_lang dictionary_id="57708.Tümü"></option>	
                        <option value="1" <cfif attributes.status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                        <option value="0" <cfif attributes.status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>			                        
                        </select>
                    </td>
                    <td><cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    	<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                    </td>
                    <td><cf_wrk_search_button></td>
                </tr>
            </table>
            </cfform>
        </cf_medium_list_search_area>
        </cf_medium_list_search>
        <cf_flat_list>
        <cfform name="add_empapp" action="#request.self#?fuseaction=#attributes.form_action#" method="post">
            <input type="hidden" name="list_id" id="list_id" value="<cfoutput>#attributes.list_id#</cfoutput>">
            <input type="hidden" name="form_action" id="form_action" value="<cfoutput>#attributes.form_action#</cfoutput>">
            <thead>
                <tr>
                    <th width="50"><cf_get_lang_main no='75.No'></th>
                    <th><cf_get_lang dictionary_id="57570.Ad Soyad"></th>
                    <th><cf_get_lang dictionary_id="57709.Okul"></th>
                    <th width="60"><cf_get_lang dictionary_id="57483.Kayıt"></th>
                    <th width="10"><input type="checkbox" name="all_check" id="all_check" value="1" onclick="javascript: hepsi();"></th>
                </tr>
            </thead>
            <tbody>
        	<cfif get_cv.recordcount>
        		<cfoutput query="get_cv" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>#empapp_id#</td>
                        <td>#NAME# #SURNAME#</td>
                        <td>
                            <cfquery name="get_app_edu_info" datasource="#dsn#" maxrows="1">
                                SELECT EDU_NAME,EDU_PART_NAME FROM EMPLOYEES_APP_EDU_INFO WHERE EMPAPP_ID = #empapp_id# ORDER BY EDU_START DESC
                            </cfquery>
                        <cfif get_app_edu_info.recordcount> #get_app_edu_info.edu_name# / #get_app_edu_info.edu_part_name#</cfif>
                        </td>
                        <td>#dateformat(record_date,dateformat_style)#</td>
                        <td width="10"><input type="checkbox" name="empapp_id" id="empapp_id" value="#empapp_id#"></td>
                    </tr>
                </cfoutput>
            <cfelse>
                <tr>
                	<td colspan="7"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                </tr>
            </cfif>
            </tbody>
            <tfoot>
                <tr>
                    <td colspan="6" style="text-align:right;">
                        <cf_workcube_buttons is_upd='0' is_cancel='0' add_function='kontrol()' type_format="1">
                    </td>
                </tr>
             </tfoot>
        </cfform>
        </cf_flat_list>
    </cf_box>   
</div>
<cfif attributes.totalrecords gt attributes.maxrows>
    <table cellpadding="0" cellspacing="0" border="0" width="98%" height="30" align="center">
    <tr>
      <td><cf_paging 
            page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="hr.popup_list_employees_app#url_str#"> </td>
      <!-- sil --><td  style="text-align:right;"> <cfoutput> <cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
    </tr>
    </table>
</cfif>

<script type="text/javascript">
function hepsi()
{
	if (document.add_empapp.all_check.checked)
		{
	<cfif get_cv.recordcount gt 1 and attributes.maxrows gt 1>	
		for(i=0;i<add_empapp.empapp_id.length;i++) add_empapp.empapp_id[i].checked = true;
	<cfelseif get_cv.recordcount eq 1 or attributes.maxrows eq 1>
		add_empapp.empapp_id.checked = true;
	</cfif>
		}
	else
		{
	<cfif get_cv.recordcount gt 1 and attributes.maxrows gt 1>	
		for(i=0;i<add_empapp.empapp_id.length;i++) add_empapp.empapp_id[i].checked = false;
	<cfelseif get_cv.recordcount eq 1>
		add_empapp.empapp_id.checked = false;
	</cfif>
		}
}

function kontrol()
{   
	if(<cfoutput>#get_cv.recordcount#</cfoutput>==1)
	{
	 	if(add_empapp.empapp_id.checked == true)
			return true;
	}
	else
	{
		for(i=0;i<document.add_empapp.empapp_id.length;i++)
		{
			if(add_empapp.empapp_id[i].checked == true)
				return true;
		}
	}
	alert("<cf_get_lang dictionary_id='30942.Listeden Satır Seçmelisiniz!'>");
	return false;
}
</script>