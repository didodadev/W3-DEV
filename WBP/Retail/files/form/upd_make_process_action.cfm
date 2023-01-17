
<cfquery name="get_rows" datasource="#dsn_dev#">
	SELECT
    	E.EMPLOYEE_NAME,
        E.EMPLOYEE_SURNAME,
        PR.*,
        STPT.TYPE_NAME,
        D.DEPARTMENT_HEAD
    FROM
    	#dsn_alias#.EMPLOYEES E,
        #dsn_alias#.DEPARTMENT D,
        SEARCH_TABLE_PROCESS_TYPES STPT,
        PROCESS_ROWS PR
    WHERE
    	PR.DEPARTMENT_ID = D.DEPARTMENT_ID AND
        PR.ROW_ID = #attributes.ROW_ID# AND
        PR.RECORD_EMP = E.EMPLOYEE_ID AND
        STPT.TYPE_ID = PR.PROCESS_TYPE
   ORDER BY
   		PR.PROCESS_STARTDATE,
        D.DEPARTMENT_HEAD
</cfquery>
<cfif not isDefined("attributes.draggable")><cf_catalystHeader></cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box id="box_counter" title="#iif(isDefined("attributes.draggable"),"getLang('','Uygulama Güncelle',62681)",DE(''))#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),DE(1),DE(0))#">
        <cfform name="add_pos" id="add_pos" method="post" action="#request.self#?fuseaction=retail.emptypopup_upd_make_process_action">
            <cfinput type="hidden" name="row_id" value="#attributes.row_id#" readonly/>
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-process_startdate">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='62677.Uygulama Başlangıç Tarihi'></label>
                        <div class="col col-8 col-sm-12">
                            <div class="input-group">
                                <cfinput type="text" name="process_startdate" maxlength="10"  required="yes" message="Tarih Giriniz!" value="#dateformat(get_rows.process_startdate,'dd/mm/yyyy')#"  validate="eurodate">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="process_startdate"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-process_finishdate">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='62678.Uygulama Bitiş Tarihi'></label>
                        <div class="col col-8 col-sm-12">
                            <div class="input-group">
                                <cfinput type="text" name="process_finishdate" maxlength="10"  required="yes" message="Tarih Giriniz!" value="#dateformat(get_rows.process_finishdate,'dd/mm/yyyy')#"  validate="eurodate">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="process_finishdate"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-action_startdate">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='62679.Yapılış Başlangıç Tarihi'></label>
                        <div class="col col-8 col-sm-12">
                            <div class="input-group">
                                <cfinput type="text" name="action_startdate" maxlength="10" value="#dateformat(get_rows.action_startdate,'dd/mm/yyyy')#"  validate="eurodate" required="yes" message="Tarih Giriniz!">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="action_startdate"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-action_finishdate">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='62680.Yapılış Bitiş Tarihi'></label>
                        <div class="col col-8 col-sm-12">
                            <div class="input-group">
                                <cfinput type="text" name="action_finishdate" maxlength="10" value="#dateformat(get_rows.action_finishdate,'dd/mm/yyyy')#"  validate="eurodate" required="yes" message="Tarih Giriniz!">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="action_finishdate"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-payment_date">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58851.Ödeme Tarihi'></label>
                        <div class="col col-8 col-sm-12">
                            <div class="input-group">
                                <cfinput type="text" name="payment_date" maxlength="10" value="#dateformat(get_rows.payment_date,'dd/mm/yyyy')#"  validate="eurodate" required="yes" message="Tarih Giriniz!">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="payment_date"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </table>
            </cf_box_elements>
            <cf_box_footer>
                <cf_record_info query_name="get_rows">
                <cf_workcube_buttons  is_upd="1" is_delete="1" delete_page_url="index.cfm?fuseaction=retail.popup_make_process_action&event=delRow&row_id=#attributes.row_id#">
            </cf_box_footer>
        </cfform>    
    </cf_box>
</div>


