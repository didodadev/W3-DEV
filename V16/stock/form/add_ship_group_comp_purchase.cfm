<cfquery name="get_pro_cat_1" datasource="#dsn3#">
	SELECT PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN  (75,77,76,73,74)
</cfquery>
<cfquery name="get_period" datasource="#dsn#">
	SELECT 
    	PERIOD_ID, 
        PERIOD, 
        PERIOD_YEAR, 
        OUR_COMPANY_ID, 
        OTHER_MONEY, 
        RECORD_DATE, 
        RECORD_IP,
        RECORD_EMP, 
        UPDATE_DATE,
        UPDATE_IP, 
        UPDATE_EMP, 
        PROCESS_DATE
    FROM 
    	SETUP_PERIOD 
    WHERE 
	    OUR_COMPANY_ID = #session.ep.company_id# AND PERIOD_YEAR = #SESSION.EP.PERIOD_YEAR#
</cfquery>
<cfquery  name="get_comp_money"  datasource="#dsn#">
	SELECT
		OC.COMP_ID,
		OC.NICK_NAME
	FROM
		SETUP_MONEY SM,
		OUR_COMPANY OC
	WHERE
		OC.COMP_ID=SM.COMPANY_ID AND
		SM.MONEY_STATUS=1 AND
		SM.RATE1=SM.RATE2 AND
		SM.MONEY = '#session.ep.money#' AND		
		OC.COMP_ID = #attributes.OUR_COMPANY_ID#
</cfquery>
<cf_box title="#getlang('','','30069')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform action="#request.self#?fuseaction=stock.emptypopup_add_ship_group_comp" name="add_irs" method="post">
        <cf_box_elements>
	<input type="hidden" name="ship_id" id="ship_id" value="<cfoutput>#attributes.ship_id#</cfoutput>">
	<input type="hidden" name="old_period_id" id="old_period_id" value="<cfoutput>#attributes.old_period_id#</cfoutput>">
            <div class="col col-12 col-md-12 col-sm-12 column" id="column-1">
            	<div class="form-group" id="item-process_cat">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61806.İşlem Tipi'></label>
                <div class="col col-8 col-sm-12">
                    <select name="process_cat" id="process_cat" style="width:150px;" >
						<cfoutput query="get_pro_cat_1">
							<option value="#PROCESS_CAT_ID#">#process_cat#</option>
						</cfoutput>
					</select>                 
                </div>         
            </div>
                <div class="form-group" id="item-period">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='54483.Periyot'></label>
                    <div class="col col-8 col-sm-12">
                        <select  name="period_id" id="period_id" style="width:150px;" >
						<cfoutput query="get_period">
							<option value="#PERIOD_ID#">#PERIOD#</option>
						</cfoutput>
					</select>                 
                    </div>         
                </div>
                <div class="form-group" id="item-department">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58763.depo'>*</label>
                    <div class="col col-8 col-sm-12">
                        <cf_wrkdepartmentlocation
						returnInputValue="location_id,txt_departman_,department_id,branch_id"
						returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
						fieldName="txt_departman_"
						fieldid="location_id"
						department_fldId="department_id"
						branch_fldId="branch_id"
						user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
						width="150">                 
                    </div>         
                </div>
                <div class="form-group" id="item-deliver_get">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57775.teslim alan'></label>
                <div class="col col-8 col-sm-12">
                    <div class="input-group">
                        <input type="hidden" name="deliver_get_id" id="deliver_get_id"  value="">
                        <cfinput type="text" name="deliver_get" style="width:150px;" readonly>
                        <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1&field_name=add_irs.deliver_get&field_emp_id2=add_irs.deliver_get_id</cfoutput>','medium')"></span>
                    </div>     
                </div>                
            </div>
            </div>
            <cfquery name="get_comp_id" datasource="#DSN#" maxrows="1">
    SELECT 
        C.COMPANY_ID,
        CP.PARTNER_ID,
        C.COMPANY_ADDRESS								
    FROM 
        COMPANY C,
        COMPANY_PARTNER CP 
    WHERE 
        C.OUR_COMPANY_ID=#attributes.OUR_COMPANY_ID#
        AND CP.COMPANY_PARTNER_STATUS = 1
        AND CP.COMPANY_ID = C.COMPANY_ID
</cfquery>
            <cfif get_comp_id.recordcount>
                <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_comp_id.COMPANY_ID#</cfoutput>">
                <input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#get_comp_id.PARTNER_ID#</cfoutput>">
                <input type="hidden" name="comp_address" id="comp_address" value="<cfoutput>#get_comp_id.COMPANY_ADDRESS#</cfoutput>">
            </cfif>
</cf_box_elements>
    		<cf_box_footer>			
			<cfif get_comp_id.recordcount >
				<cfif get_comp_money.recordcount>
					<cf_workcube_buttons is_upd='0'>
				<cfelse>
					<font color="red"><cf_get_lang dictionary_id ='45999.Firma Sistem Para Birimi Farklıdır'>!</font>
				</cfif>
			<cfelse>
				<font color="red"><cf_get_lang dictionary_id ='45629.Firmanızı Kurumsal Üye Olarak Ekleyiniz'>!</font>
			</cfif>
		</cf_box_footer>
	</cfform>
</cf_box>