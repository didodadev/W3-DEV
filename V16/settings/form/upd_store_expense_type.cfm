<cfquery name="GET_EXPENSE_TYPE" datasource="#dsn#">
    SELECT 
        EXPENSE_TYPE_ID, 
        #dsn#.Get_Dynamic_Language(EXPENSE_TYPE_ID,'#session.ep.language#','STORE_EXPENSE_TYPE','EXPENSE_TYPE',NULL,NULL,EXPENSE_TYPE) AS EXPENSE_TYPE,
        EXPENSE_TYPE_DETAIL, 
        ACCOUNT_CODE, 
        RECORD_DATE, 
        RECORD_IP, 
        RECORD_EMP, 
        UPDATE_DATE, 
        UPDATE_IP, 
        UPDATE_EMP 
    FROM 
        STORE_EXPENSE_TYPE 
    WHERE 
        EXPENSE_TYPE_ID = #ATTRIBUTES.EXPENSE_TYPE_ID#
</cfquery>
<cfquery name="GET_STORE_EXPENSE" datasource="#DSN2#">
    SELECT
        EXPENSE_TYPE_ID
    FROM
        STORE_EXPENSE
    WHERE
        EXPENSE_TYPE_ID = #attributes.expense_type_id#
</cfquery>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Şube Harcama Tipleri',42769)#" add_href="#request.self#?fuseaction=settings.form_add_store_expense_type" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
			<cfinclude template="../display/list_store_expense_type.cfm">
    	</div>
    	<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
            <cfform method="post" name="upd_expense_type" action="#request.self#?fuseaction=settings.emptypopup_upd_store_expense_type&expense_type_id=#attributes.expense_type_id#">
                <input type="hidden" name="expense_type_id" id="expense_type_id" value="<cfoutput>#attributes.expense_type_id#</cfoutput>">
        		<cf_box_elements>
          			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
						<div class="form-group" id="cat-name">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'>*</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="Text" name="expense_type" maxlength="100" required="Yes" message="#getLang('','Kategori Adı Girmelisiniz',58555)#!" value="#get_expense_type.expense_type#">							
                                    <span class="input-group-addon">
                                        <cf_language_info 
                                        table_name="STORE_EXPENSE_TYPE" 
                                        column_name="EXPENSE_TYPE" 
                                        column_id_value="#attributes.expense_type_id#" 
                                        maxlength="500" 
                                        datasource="#dsn#" 
                                        column_id="EXPENSE_TYPE_ID" 
                                        control_type="0">
                                    </span>
                                </div>
							</div>	
						</div>
                        <div class="form-group" id="account-detail">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'><cfif session.ep.period_is_integrated eq 1>*</cfif></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="account_code" value="#get_expense_type.account_code#" readonly maxlength="50">
                                    <span class="input-group-addon icon-ellipsis btnPointer" alt="<cf_get_lang dictionary_id='57582.Ekle'>" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_expense_type.account_code');"></span>
                                </div>
                            </div>
						</div>
						<div class="form-group" id="account-name">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <textarea name="expense_type_detail" id="expense_type_detail" maxlength="100"><cfif len(get_expense_type.expense_type_detail)><cfoutput>#get_expense_type.expense_type_detail#</cfoutput></cfif></textarea>
                            </div>
						</div>
					</div>
				</cf_box_elements>
                <cf_box_footer>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <cf_record_info query_name="get_expense_type">
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <cfif get_store_expense.recordcount>
                            <cf_workcube_buttons is_upd='1' is_delete='0' add_function='sayfa_kontrol()'>
                        <cfelse>
                            <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_store_expense_type&expense_type_id=#attributes.expense_type_id#&head=#get_expense_type.account_code#' add_function='sayfa_kontrol()'></td>
                        </cfif>
                    </div>
				</cf_box_footer>
			</cfform>
    	</div>
  	</cf_box>
</div>
<script type="text/javascript">

	function sayfa_kontrol()
	{
		if (session.ep.period_is_integrated == 1)
		{
			if (document.add_expense_type.account_code =='')
			{
				alert("<cf_get_lang dictionary_id ='43840.Lütfen Muhasebe Kodu Seçiniz'> !");
				return false;
			}
		}
        return true;
    }
</script>