<cfquery name="get_budget_plan" datasource="#dsn#">
    SELECT 
        MAX(BUDGET_PLAN_ID) AS BUDGET_PLAN_ID
    FROM 
        BUDGET_PLAN
</cfquery>
<cfset attributes.BUDGET_PLAN_ID = get_budget_plan.BUDGET_PLAN_ID>
<cfquery name="get_branches" datasource="#dsn#">
	SELECT 
		BRANCH_ID,BRANCH_NAME 
	FROM 
		BRANCH 
	WHERE
		BRANCH_STATUS = 1 
		AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	ORDER BY 
		BRANCH_NAME
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Planlama ve Tahakkuk Fişi Aktarım','43771')#" closable="0">
        <cfform name="budget_plan_import" action="" enctype="multipart/form-data" method="post">
            <cfif get_budget_plan.BUDGET_PLAN_ID eq ''>
                <cfset get_budget_plan.BUDGET_PLAN_ID = 0>
            </cfif>
            <cfinput type="hidden" name="budget_plan_id" value="#get_budget_plan.BUDGET_PLAN_ID+1#">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item_file_format">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32901.Belge Formatı'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <select name="file_format" id="file_format">
                                <option value="iso-8859-9"><cf_get_lang dictionary_id='53845.ISO-8859-9 (Türkçe)'></option>
                                <option value="UTF-8"><cf_get_lang dictionary_id='55929.UTF-8'></option>
                            </select>
                        </div>
                    </div>           
                    <div class="form-group" id="item-uploaded_file">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <input type="file" name="uploaded_file" id="uploaded_file">
                        </div>
                    </div> 
                    <div class="form-group" id="operation_type">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='61806.İşlem Tipi'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <cf_workcube_process_cat module_id="46">
                        </div>
                    </div> 
                    <div class="form-group" id="process">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <cf_workcube_process is_upd='0' is_detail='0' module_id="46">
                        </div>
                    </div> 
                    <div class="form-group" id="class">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <select name="acc_branch_id" id="acc_branch_id">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_branches">
                                    <option value="#BRANCH_ID#">#BRANCH_NAME#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div> 
                    <div class="form-group" id="department">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <cf_wrkdepartmentbranch fieldid='acc_department_id' is_department='1' is_deny_control='0'>
                        </div>
                    </div> 
                    <div class="form-group" id="record-date">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <cfinput name="record_date" id="record_date" type="text" validate="#validate_style#" required="Yes" message="#getLang('','Lütfen Tarih Giriniz','58503')#" value="#dateformat(now(),dateformat_style)#" passthrough="onblur=""change_money_info('add_budget_plan','record_date');""">
                                <span class="input-group-addon">
                                    <cf_wrk_date_image date_field="record_date" call_function="change_money_info">
                                </span>
                            </div>
                        </div>
                    </div> 
                    <div class="form-group" id="line">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57246.Satır Sayısı'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <input type="text" name="line_count_each_document" id="line_count_each_document" />
                        </div>
                    </div> 




                </div>
                
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-format">
                        <label><b><cf_get_lang dictionary_id='58594.Format'></b></label>
                    </div>
                    <div class="form-group" id="item-exp1">
                        <cf_get_lang dictionary_id='57629.Açıklama'>
                        </div>
                    <div class="form-group" id="item-exp2">
                        <cf_get_lang dictionary_id='44246.Dosya uzantısı csv veya txt olacak ve alan araları noktalı virgül (;) ile ayrılacaktır'>
                    </div>
                    <div class="form-group" id="item-exp3">
                        <cf_get_lang dictionary_id='36511.Aktarım işlemi dosyanın 2. satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır'>
                    </div>
                    <div class="form-group" id="item-exp4">
                        <cf_get_lang dictionary_id='44247.Ayıraç noktalı virgul olduğundan notlar içinde olmaması gerekmektedir'>
                    </div>
                    <div class="form-group" id="item-exp5">
                        <cf_get_lang dictionary_id='44750.Küsuratlı değerler için virgül (,) değil nokta (.) kullanılmalıdır'>
                    </div>
                    <div class="form-group" id="item-exp6">
                        <cf_get_lang dictionary_id='56627.Belgede toplam 11 alan olacaktır alanlar sırası ile'>
                    </div>
                    <div class="form-group" id="item-exp7">
                      1-<cf_get_lang dictionary_id='57742.Tarih'></br> 
                      2-<cf_get_lang dictionary_id='57629.Açıklama'></br> 
                      3-<cf_get_lang dictionary_id='56643.Masraf/Gelir Merkezi ID'></br>
                      4-<cf_get_lang dictionary_id='56648.Bütçe Kalemi ID'></br>
                      5-<cf_get_lang dictionary_id='58811.Muhasebe Kodu'></br>
                      6-<cf_get_lang dictionary_id='56657.Aktivite Tipi ID'></br>
                      7-<cf_get_lang dictionary_id='56658.İş Grubu ID'></br>
                      8-<cf_get_lang dictionary_id='56661.Fiziki Varlık ID'></br>
                      9-<cf_get_lang dictionary_id='56662.Kurumsal Üye Kodu veya Özel Kod'></br>
                      10-<cf_get_lang dictionary_id='56665.Bireysel Üye Kodu veya Özel Kod'></br>
                      11-<cf_get_lang dictionary_id='58677.Gelir'></br>
                      12-<cf_get_lang dictionary_id='58678.Gider'></br>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function='control()'>	
            </cf_box_footer>
    
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
function control()
{
	if(!document.getElementById('process_cat').value)
	{
		alert('İşlem Tipi seçiniz');
		return false;
	}
	if(!document.getElementById('line_count_each_document').value)
	{
		alert('Satır Sayısı Giriniz');
		return false;
	}
	if(document.getElementById('line_count_each_document').value > 100)
	{
		alert('Satır Sayısı 100"den büyük olamaz');
		return false;
	}
	if(document.budget_plan_import.uploaded_file.value.length == '')
	{
		alert('<cf_get_lang dictionary_id='54246.Belge Seçmelisiniz'>');
		return false;
	}
	budget_plan_import.action='<cfoutput>#request.self#?fuseaction=settings.emptypopup_add_budget_plan_import</cfoutput>';
	budget_plan_import.submit();
}
</script>
