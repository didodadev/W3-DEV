<cfquery name="control_gdpr" datasource="#dsn#">
    SELECT SENSITIVITY_LABEL_ID FROM GDPR_SENSITIVITY_LABEL
     WHERE SENSITIVITY_LABEL_ID  IN (<cfqueryparam cfsqltype='integer' value='#session.ep.dockphone#' list="yes">)  
</cfquery>
<cfquery name="get_gdpr" dbtype="query">
    SELECT SENSITIVITY_LABEL_ID FROM control_gdpr WHERE SENSITIVITY_LABEL_ID IN (<cfqueryparam cfsqltype='integer' value='9' list="yes">)
</cfquery>
<cfif (session.ep.admin neq 1) or (get_gdpr.recordcount eq 0)>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id ='29985.Bu Raporu Görüntülemeye Yetkili Değilsiniz'>!");
		window.history.go(-1);
	</script>
	<cfabort>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent variable="head"><cf_get_lang dictionary_id='61672.Admin Yapma'></cfsavecontent>
    <cf_box title="#head#">
        <cfform name="rapor" action="" method="post">
            <input type="hidden" name="is_form_submitted" value="1">
            <cf_box_search more="0">
                <div class="form-group">
                    <cfsavecontent variable="mess"><cf_get_lang dictionary_id='59140.Position ID'>*</cfsavecontent>
                    <cfsavecontent variable="position_mess"><cf_get_lang dictionary_id='991.Pozisyon ID Boş Olamaz'></cfsavecontent>
                    <cfinput type="text" name="position_id" style="width:130px;" required="yes" message="#position_mess#" placeholder="#mess#">
                </div>
                <div class="form-group">
                    <button class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left"><i class="fa fa-play-circle"></i><cf_get_lang dictionary_id='57911.Çalıştır'></button>
                </div>
                <div class="form-group">
                    <label>
                        <font color="red">
                            <cf_get_lang dictionary_id='988.NOT 1 : Pozisyon ID Değeri; Planlama/Pozisyon Detayına Gidildiğinde, İlgili Sayfada Url"deki "hr.form_upd_position&position_id=" Eşitliğinden Sonraki Değerdir.'>
                            <br />
                            <cf_get_lang dictionary_id='989.NOT 2 : Birden Fazla Pozisyon Id Değeri, Aralarına Virgül (,) Konularak Yazılıp Güncellenebilir.'>
                            
                        </font><!---  --->
                    </label>
                </div>
            </cf_box_search>					
        </cfform>
    </cf_box>
    <cf_box uidrop="1" title="#getlang("","Admin Yetkisi Olan Pozisyonlar",990)#">
        <cfif isDefined("attributes.is_form_submitted") and isDefined("attributes.position_id") and Len(attributes.position_id)>
            <cfquery name="upd_emp_pos" datasource="#dsn#">
                UPDATE EMPLOYEE_POSITIONS SET ADMIN_STATUS=1 WHERE POSITION_ID IN (#attributes.position_id#)
            </cfquery>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12 ui-info-text">
                <p class="bold">(<cfoutput>#attributes.position_id#</cfoutput>) <cf_get_lang dictionary_id='61675.Admin Yetkisi Verildi'>!</p>
            </div>
            <cfset attributes.position_id = "">
            <cfset form.position_id = "">
        </cfif>
        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
            <cf_flat_list>
                <cfquery name="Get_Admin_Authority_Positions" datasource="#dsn#">
                    SELECT POSITION_ID,POSITION_CODE,EMPLOYEE_NAME,EMPLOYEE_SURNAME,POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE ADMIN_STATUS = 1 ORDER BY POSITION_ID
                </cfquery>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='59140.Position ID'></th>
                        <th><cf_get_lang dictionary_id='29515.Position Code'></th>
                        <th><cf_get_lang dictionary_id='61673.Pozisyon Adı'></th>
                        <th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
                    </tr>
                </thead>
                <tbody>
                    <cfif Get_Admin_Authority_Positions.RecordCount>
                        <cfoutput query="Get_Admin_Authority_Positions">
                        <tr class="color-row">
                            <td>#position_id#</td>
                            <td>#position_code#</td>
                            <td>#position_name#</td>
                            <td>#employee_name# #employee_surname#</td>
                        </tr>
                        </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Yok'></td>
                        </tr>
                    </cfif>
                </tbody>
            </cf_flat_list>
        </div>
    </cf_box>

</div>        
<!--- <script language="javascript">
    function upd_admin_status()
    {
        if(document.rapor.position_id.value =='')
        {
            alert("Pozisyon İdsi Boş Olamaz");
            return false;
        }
        return true;
    }
</script> --->
