<cfquery name="get_saved_report" datasource="#dsn#">
	SELECT 
		SAVED_REPORTS.REPORT_NAME,
		SAVED_REPORTS.REPORT_DETAIL,
		SAVED_REPORTS.RECORD_DATE,
		SAVED_REPORTS.RECORD_EMP,
    SAVED_REPORTS.UPDATE_EMP,
    SAVED_REPORTS.UPDATE_DATE
	FROM
		SAVED_REPORTS
	WHERE
		SAVED_REPORTS.SR_ID = #ATTRIBUTES.SR_ID#
</cfquery>
<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('','Kayıtlı Rapor Güncelle',39779)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
  <cfform enctype="multipart/form-data" action="#request.self#?fuseaction=report.emptypopup_upd_saved_report" method="post" name="add_report">
    <input type="hidden" name="counter" id="counter" value="">
		<input type="hidden" name="sr_id" id="sr_id" value="<cfoutput>#attributes.sr_id#</cfoutput>">
    <cf_box_elements>
      <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
        <div class="form-group require" id="item-Report_Name">
          <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57434.Rapor'></label>
          <div class="col col-8 col-sm-12">
            <cfinput type="text" name="Report_Name" value="#get_saved_report.report_name#" required="yes" message="#getLang('','Rapor Adı girmelisiniz',38811)#" maxlength="100">
          </div>                
        </div> 
        <div class="form-group require" id="item-report_detail">
          <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
          <div class="col col-8 col-sm-12">
            <textarea name="report_detail" id="report_detail" style="width:200px;height:40px;" maxlength="250" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#getLang('','Fazla karakter sayısı',29484)#</cfoutput>"><cfoutput>#get_saved_report.report_detail#</cfoutput></textarea>
          </div>                
        </div>
      </div>
    </cf_box_elements>
	  <cf_box_footer>
        <cf_record_info query_name="get_saved_report" record_emp="RECORD_EMP" update_emp="UPDATE_EMP">
        <cf_workcube_buttons is_upd='1' del_function="#isDefined('attributes.draggable') ? 'deleteFunc()' : ''#" add_function='kontrol()'>
    </cf_box_footer>
    <!--- <td align="right" style="text-align:right;"><cfoutput>#get_emp_info(get_saved_report.RECORD_EMP,0,0)# #dateformat(date_add('h',session.ep.time_zone,get_saved_report.RECORD_DATE),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,get_saved_report.RECORD_DATE),timeformat_style)#</cfoutput></td> --->
  </cfform>
</cf_box>
<script type="text/javascript">
  function kontrol() {
    <cfif isdefined("attributes.draggable")>loadPopupBox('add_report' , <cfoutput>#attributes.modal_id#</cfoutput>);<cfelse>return true;</cfif>
  }
  <cfif isDefined('attributes.draggable')>
      function deleteFunc() {
          openBoxDraggable('<cfoutput>#request.self#?fuseaction=report.emptypopup_del_saved_report&sr_id=#attributes.sr_id#</cfoutput>',<cfoutput>#attributes.modal_id#</cfoutput>);
      }
  </cfif>
</script>
