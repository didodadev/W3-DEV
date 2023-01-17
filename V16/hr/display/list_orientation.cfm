<cfset url_str = "">
<cfparam name="is_filtered" default="0">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<!--- <cfif len(attributes.STARTDATE)>
	<cfset url_str = "#url_str#&startdate=#attributes.startdate#">
	<CF_DATE TARIH="attributes.STARTDATE">
</cfif>
<cfif len(attributes.FINISHDATE)>
	<cfset url_str = "#url_str#&finishdate=#attributes.finishdate#">
	<CF_DATE TARIH="attributes.FINISHDATE">
</cfif> --->
<cfif is_filtered>
<cfif len(attributes.STARTDATE)>
	<cf_date tarih="attributes.startdate">
</cfif>
<cfif len(attributes.FINISHDATE)>
	<cf_date tarih="attributes.finishdate">
</cfif>
<cfquery name="GET_ORIENTATION" datasource="#DSN#">
   SELECT 
		* 
   FROM 
		TRAINING_ORIENTATION
  WHERE
		ORIENTATION_ID > 0
		<cfif len(attributes.startdate) and len(attributes.finishdate)>
			AND
			(
				START_DATE >= #attributes.STARTDATE#
				AND
				FINISH_DATE <=  #attributes.FINISHDATE#
			)
		<cfelseif len(attributes.startdate) and not len(attributes.finishdate)>
			AND  >= #attributes.STARTDATE# 
		<cfelseif not len(attributes.startdate) and len(attributes.finishdate)>
			AND FINISH_DATE <= #attributes.FINISHDATE# 
		</cfif>
		<cfif len(attributes.keyword)>
			AND ORIENTATION_HEAD LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
		</cfif>
</cfquery>
<cfelse>
	<cfset GET_ORIENTATION.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#GET_ORIENTATION.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="form1" method="post" action="">
            <input type="hidden" name="is_filtered" id="is_filtered" value="1">
            <cf_box_search>
                <div class="form-group">
                    <cfinput type="text" name="keyword" maxlength="50" placeholder="#getlang(48,'Filtre',57460)#" id="keyword" value="#attributes.keyword#">
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57655.başlama girmelisiniz'></cfsavecontent>
                        <cfinput type="text" name="startdate" id="startdate" placeholder="#getLang(48,'yayın başlama tarihi',62385)#" value="#dateformat(attributes.startdate,dateformat_style)#" style="width:70px;" validate="#validate_style#" maxlength="10"  message="#message#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                        <cfinput type="text" name="finishdate" id="finishdate" placeholder="#getLang(48,'yayın bitiş tarihi',38536)#" value="#dateformat(attributes.finishdate,dateformat_style)#" style="width:70px;" validate="#validate_style#" maxlength="10"  message="#message#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                    </div>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
                    <cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group">
                    <cfsavecontent variable="message_date"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
                    <cf_wrk_search_button button_type="4" search_function="date_check(form1.startdate,form1.finishdate,'#message_date#')">
                    <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>                        
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cf_box title="#getLang(128,'Oryantasyon Eğitimleri',55213)#" uidrop="1" hide_table_column="1">
        <cf_grid_list> 
            <thead>
                <tr>
                    <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='57480.Konu'> </th>
                    <th><cf_get_lang dictionary_id='55201.Katılan'></th>
                    <th><cf_get_lang dictionary_id='57544.Sorumlu'></th>
                    <th><cf_get_lang dictionary_id='57501.Başlama'></th>
                    <th><cf_get_lang dictionary_id='57502.Bitiş'></th>
                    <!-- sil --><th width="20" class="header_icn_none text-center"><a href="javascript://" onClick="openBoxDraggable(<cfoutput>'#request.self#?fuseaction=hr.list_orientation&event=add</cfoutput>');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th><!-- sil -->
                </tr>
            </thead>
            <tbody>
                <cfif GET_ORIENTATION.recordcount>
                    <cfoutput query="GET_ORIENTATION" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td><a href="#request.self#?fuseaction=hr.list_orientation&event=upd&orientation_id=#orientation_id#" class="tableyazi">#ORIENTATION_HEAD#</a></td>
                            <td><cfif len(ATTENDER_EMP)>
                                    <cfquery name="GET_EMP_NAME" datasource="#DSN#">
                                        SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #ATTENDER_EMP#
                                    </cfquery>
                                    <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=training_management.popup_detail_emp&emp_id=#attender_emp#');" class="tableyazi">#GET_EMP_NAME.EMPLOYEE_NAME# #GET_EMP_NAME.EMPLOYEE_SURNAME#</a>
                                </cfif>
                            </td>
                            <td><cfif len(TRAINER_EMP)>
                                    <cfquery name="GET_EMP_NAME" datasource="#DSN#">
                                        SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #TRAINER_EMP#
                                    </cfquery>
                                    <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=training_management.popup_detail_emp&emp_id=#trainer_emp#');" class="tableyazi">#GET_EMP_NAME.EMPLOYEE_NAME# #GET_EMP_NAME.EMPLOYEE_SURNAME#</a>
                                </cfif>
                            </td>
                            <td><cfif LEN(START_DATE)>#dateformat(START_DATE,dateformat_style)#</cfif>
                            </td>
                            <td><cfif LEN(FINISH_DATE)>#dateformat(FINISH_DATE,dateformat_style)#</cfif>
                            </td>
                            <!-- sil --><td width="20" style="text-align: center;"><a href="#request.self#?fuseaction=hr.list_orientation&event=upd&orientation_id=#orientation_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td><!-- sil -->
                        </tr>
                    </cfoutput>
                    <cfelse>
                        <tr>
                            <cfif is_filtered><td colspan="7"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td><cfelse><td colspan="7"><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</td></cfif>
                        </tr>
                </cfif>
            </tbody>
        </cf_grid_list> 
        <cfif isdefined('attributes.is_filtered')>
            <cfset url_str = "#url_str#&is_filtered=#attributes.is_filtered#">
        </cfif>
        <cfif len(attributes.startdate)>
            <cfset url_str = "#url_str#&startdate=#dateformat(attributes.startdate,dateformat_style)#">
        </cfif>
        <cfif len(attributes.finishdate)>
            <cfset url_str = "#url_str#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#">
        </cfif>
        <cf_paging page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="hr.list_orientation#url_str#">
    </cf_box>
</div>
<script type="text/javascript">
    document.getElementById('keyword').focus();
</script>
