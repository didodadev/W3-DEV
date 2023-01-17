<cfset url_str = "">
<cfparam name="attributes.keyword" default="">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>

<cfquery name="GET_ORIENTATION" datasource="#DSN#">
   SELECT 
     * 
   FROM 
     TRAINING_ORIENTATION
   WHERE
      ATTENDER_EMP = #attributes.EMPLOYEE_ID#
 <cfif len(attributes.keyword)>
       AND
	 ORIENTATION_HEAD LIKE '%#attributes.keyword#%'  
 </cfif>
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#GET_ORIENTATION.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="55209.Oryantasyon"></cfsavecontent>
<cf_box title="#message#" scroll="1" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="form1" method="post" action="#request.self#?fuseaction=	hr.popup_list_employee_orientations">
        <cf_box_search more="0">
            <input type="hidden" name="EMPLOYEE_ID" id="EMPLOYEE_ID" value="<cfif isdefined("attributes.EMPLOYEE_ID")><cfoutput>#attributes.EMPLOYEE_ID#</cfoutput></cfif>">
            <div class="ui-form-list flex-list">
                <div class="form-group medium">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" placeholder="#message#" name="keyword" id="keyword" value="#attributes.keyword#">
                </div>
                <div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" >
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function='#iif(isdefined("attributes.draggable"),DE("loadPopupBox('form1' , #attributes.modal_id#)"),DE(""))#'>
				</div>
            </div>
        </cf_box_search>
    </cfform>
    <cf_flat_list>
        <thead>
            <tr>
                <th><cf_get_lang dictionary_id='57480.Konu'></th>
                <th width="150"><cf_get_lang dictionary_id='55201.Katılan'></th>
                <th width="150"><cf_get_lang dictionary_id='57544.Sorumlu'></th>
                <th width="100"><cf_get_lang dictionary_id='57655.Başlama Tarihi'></th>
                <th width="60"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
            </tr>
        </thead>	
        <tbody>      
        <cfif GET_ORIENTATION.recordcount>
            <cfoutput query="GET_ORIENTATION" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr>
                    <td>
                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.list_orientation&event=upd&orientation_id=#orientation_id#','medium');" class="tableyazi">#ORIENTATION_HEAD#</a>
                    </td>
                    <td>
                    <cfif len(ATTENDER_EMP)>
                        <cfquery name="GET_EMP_NAME" datasource="#DSN#">
                            SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #ATTENDER_EMP#
                        </cfquery>
                        #GET_EMP_NAME.EMPLOYEE_NAME# #GET_EMP_NAME.EMPLOYEE_SURNAME#
                    </cfif>
                    </td>
                <td>
                <cfif len(TRAINER_EMP)>
                    <cfquery name="GET_EMP_NAME" datasource="#DSN#">
                        SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #TRAINER_EMP#
                    </cfquery>
                    #GET_EMP_NAME.EMPLOYEE_NAME# #GET_EMP_NAME.EMPLOYEE_SURNAME#
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
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
            </tr>
        </cfif>
        </tbody>
    </cf_flat_list>
</cf_box>
<cfif attributes.totalrecords gt attributes.maxrows>
    <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
            <td height="35"><cf_paging page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="training_management.list_training_orientation#url_str#"></td>
            <!-- sil --><td  style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
        </tr>
    </table>
</cfif>
<script>
    function kontrol(){
        alert("form1");
    }
</script>