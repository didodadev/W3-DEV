<cf_xml_page_edit fuseact="account.account_collected_print">
<!---Select  ifadeleri ile ilgili çalışma yapıldı. Egemen Ateş 16.07.2012 --->
<cfquery name="GET_MODULE_ID" datasource="#DSN#">
	SELECT MODULE_ID FROM MODULES WHERE MODULE_SHORT_NAME = 'account'
</cfquery>
<cfquery name="GET_DET_FORM" datasource="#dsn3#">
  	SELECT
		SPF.TEMPLATE_FILE,
		SPF.FORM_ID,
		SPF.NAME,
		SPF.PROCESS_TYPE,
		SPF.MODULE_ID,
		SPFC.PRINT_NAME,
		SPF.IS_DEFAULT
	FROM
		SETUP_PRINT_FILES SPF,
		#dsn_alias#.SETUP_PRINT_FILES_CATS SPFC
	WHERE
		SPF.ACTIVE = 1 AND
		SPF.MODULE_ID = #get_module_id.module_id# AND
		SPFC.PRINT_TYPE = SPF.PROCESS_TYPE
</cfquery>
<cfquery name="get_branchs" datasource="#dsn#">
	SELECT
		BRANCH_ID,BRANCH_NAME
	FROM
		BRANCH
	WHERE
		BRANCH_STATUS = 1
		AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value=" #session.ep.company_id#">
	<cfif session.ep.isBranchAuthorization>
		AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
	</cfif>
	ORDER BY BRANCH_NAME
</cfquery>
<cfquery name="GET_ALL_PROCESS_CAT" datasource="#DSN3#">
	SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT,IS_ACCOUNT FROM SETUP_PROCESS_CAT
</cfquery>
<cfquery name="get_process_cat" dbtype="query">
	SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM GET_ALL_PROCESS_CAT WHERE IS_ACCOUNT = 1 ORDER BY PROCESS_TYPE
</cfquery>
<cfquery name="get_process_cat_process_type" dbtype="query">
	SELECT DISTINCT PROCESS_TYPE FROM GET_ALL_PROCESS_CAT WHERE IS_ACCOUNT = 1 ORDER BY PROCESS_TYPE
</cfquery>
<cfparam name="attributes.empo_id" default="">
<cfparam name="attributes.emp_nameo" default="">
<cfparam name="attributes.action_type_id" default="">
<cfparam name="attributes.action_process_cat" default="">
<cfparam name="attributes.record_date" default="">
<cfparam name="attributes.action_start_date" default="">
<cfparam name="attributes.action_finish_date" default="">
<cfparam name="attributes.acc_branch_id" default="">
<cfif isdefined("attributes.form_submit")>
	<cfif isdefined("attributes.action_start_date") and isdate(attributes.action_start_date)>
		<cf_date tarih = "attributes.action_start_date">
	</cfif>
	<cfif isdefined("attributes.action_finish_date") and isdate(attributes.action_finish_date)>
		<cf_date tarih = "attributes.action_finish_date">
	</cfif>
	<cfif isdefined("attributes.record_date") and isdate(attributes.record_date)>
		<cf_date tarih = "attributes.record_date">
	</cfif>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box title="#getLang('','Toplu Yazdır',50111)#">
<cfform name="page_print_account" method="post" action="#request.self#?fuseaction=account.account_collected_print">
	<input type="hidden" name="form_submit" id="form_submit" value="1" />
    <cf_box_search>
				<div class="form-group" id="item-EMP_NAMEO">
					<div class="col col-12 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="EMPO_ID" id="EMPO_ID"  value="<cfoutput>#attributes.empo_id#</cfoutput>">
							<input type="text" name="EMP_NAMEO" id="EMP_NAMEO"  placeholder=<cfoutput>"#getLang('','Kaydeden',57899)#"</cfoutput> value="<cfoutput>#attributes.emp_nameo#</cfoutput>" style="width:100px;" readonly>
							<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1&field_name=page_print_account.EMP_NAMEO&field_emp_id=page_print_account.EMPO_ID</cfoutput>');"></span>
						</div>
					</div>
				</div>
				<div class="form-group col col-1 col-md-2 col-xs-2">
					<div class="input-group col col-12 col-xs-12">	
						<input value="<cfoutput>#dateformat(attributes.record_date,dateformat_style)#</cfoutput>" placeholder=<cfoutput>"#getLang('','Kayıt Tarihi',57627)#"</cfoutput> type="text" name="record_date" id="record_date" style="width:65px;" validate="#validate_style#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="record_date"></span>
					</div>
				</div>
				<div class="form-group" id="item-order_type">
					<div class="col col-12 col-xs-12">
						<select name="order_type" id="order_type">
							<option value="1" <cfif isDefined('attributes.order_type') and attributes.order_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57926.Azalan Tarih'></option>
							<option value="2" <cfif isDefined('attributes.order_type') and attributes.order_type eq 2>selected</cfif>><cf_get_lang dictionary_id='57925.Artan Tarih'></option>
							<option value="3" <cfif isDefined('attributes.order_type') and attributes.order_type eq 3>selected</cfif>><cf_get_lang dictionary_id='29459.Artan No'></option>
							<option value="4" <cfif isDefined('attributes.order_type') and attributes.order_type eq 4>selected</cfif>><cf_get_lang dictionary_id='29458.Azalan No'></option>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-action_type_id">
					<div class="col col-12 col-xs-12">
						<select name="action_type_id" id="action_type_id" style="width:80px;">
							<option value="" selected><cf_get_lang dictionary_id='57777.İşlemler'></option>
							<option value="10" <cfif isDefined('attributes.action_type_id') and attributes.action_type_id eq 10>selected</cfif>><cf_get_lang dictionary_id='58756.Açılış Fişi'></option>
							<option value="11" <cfif isDefined('attributes.action_type_id') and attributes.action_type_id eq 11>selected</cfif>><cf_get_lang dictionary_id='48950.Tahsil Fişi'></option>
							<option value="12" <cfif isDefined('attributes.action_type_id') and attributes.action_type_id eq 12>selected</cfif>><cf_get_lang dictionary_id='48951.Tediye Fişi'></option>
							<option value="13" <cfif isDefined('attributes.action_type_id') and attributes.action_type_id eq 13> selected</cfif>><cf_get_lang dictionary_id='58452.Mahsup Fişi'></option>
							<option value="14" <cfif isDefined('attributes.action_type_id') and attributes.action_type_id eq 14>selected</cfif>><cf_get_lang dictionary_id='29435.Özel Fiş'></option>
							<option value="15" <cfif isDefined('attributes.action_type_id') and attributes.action_type_id eq 15>selected</cfif>><cf_get_lang dictionary_id='57884.Kur Farkı'></option>
						</select>
					</div>
				</div>	
				<div class="form-group">
					<cf_wrk_search_button search_function='kontrol()' button_type="4"> 
			</div>
				<div class="form-group">
					<cfif isdefined("x_trail") and x_trail eq 1>
						<cf_workcube_file_action  pdf='1' mail='0' doc='0' print='0' trail='1'is_print_req="1"  is_ajax="1" tag_module="account_collected_print_div">
					<cfelse>
						<cf_workcube_file_action  pdf='1' mail='0' doc='0' print='0' trail='0' is_print_req="1" is_ajax="1" tag_module="account_collected_print_div">
					</cfif>
					<a href="javascript://" class="ui-wrk-btn ui-wrk-btn-info" onclick="print_fis()">
						<i class="fa fa-print" title="<cf_get_lang dictionary_id='57474.Yazdır'>" id="list_print_button"></i>
					</a>
				</div>	
			
			
	</cf_box_search>
	<cf_box_search_detail>
		<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group" id="item-form_type">
					<div class="col col-12 col-xs-12">
						<select name="form_type" id="form_type" style="width:150px;">
								<option value=""><cf_get_lang dictionary_id='57792.Modül İçi Yazıcı Belgeleri'></option>
							<cfoutput query="get_det_form">
								<option value="#form_id#" <cfif (isdefined("attributes.form_type") and attributes.form_type eq form_id) or (not isdefined("attributes.form_type") and is_default eq 1)>selected</cfif>>
								#name# - #print_name#
								</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-action_process_cat">
					<div class="col col-12 col-xs-12">
						<select name="action_process_cat" id="action_process_cat" style="width:150px;">
							<option value=""><cf_get_lang dictionary_id ='61806.İşlem Tipi'> <cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_process_cat_process_type">
								<option value="#process_type#-0" <cfif '#process_type#-0' is attributes.action_process_cat>selected</cfif>>#get_process_name(process_type)#</option>
								<cfquery name="get_pro_cat" dbtype="query">
									SELECT
										*
									FROM
										get_process_cat
									WHERE
										PROCESS_TYPE = #get_process_cat_process_type.process_type#
								</cfquery>
								<cfloop query="get_pro_cat">
									<option value="#get_pro_cat.process_type#-#get_pro_cat.process_cat_id#" <cfif attributes.action_process_cat is '#process_type#-#process_cat_id#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#get_pro_cat.process_cat#</option>
								</cfloop>
							</cfoutput>
						</select>
					</div>
				</div>	
				<div class="form-group" id="item-acc_branch_id">
					<div class="col col-12 col-xs-12">
						<select name="acc_branch_id" id="acc_branch_id" style="width:100px;">
							<option value=""><cf_get_lang dictionary_id='57453.Şube'> <cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_branchs">
								<option value="#BRANCH_ID#" <cfif isdefined('attributes.acc_branch_id') and attributes.acc_branch_id eq BRANCH_ID>selected</cfif>>#BRANCH_NAME#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group ">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></label>
					<div class="col col-4 col-xs-12">    
						<div class="input-group">
						<input value="<cfoutput>#dateformat(attributes.action_start_date,dateformat_style)#</cfoutput>" id="action_start_date" type="text" name="action_start_date" style="width:65px;" validate="#validate_style#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="action_start_date"></span>
						</div>
					</div>
					<div class="col col-4 col-xs-12">  
						<div class="input-group">
							<input value="<cfoutput>#dateformat(attributes.action_finish_date,dateformat_style)#</cfoutput>" type="text" id="action_finish_date" name="action_finish_date" style="width:65px;" validate="#validate_style#">
							<span class="input-group-addon"><cf_wrk_date_image date_field="action_finish_date"></span>
						</div>
					</div>
				</div>
			</div>	
	</cf_box_search_detail>
</cfform>
</cf_box>
</div>
<cfif isdefined("attributes.form_type") and isdefined("attributes.form_submit")>
<div id="account_collected_print_div">
	<cfquery name="GET_FORM" datasource="#DSN3#">
		SELECT
			TEMPLATE_FILE,
			FORM_ID,
			NAME,
			PROCESS_TYPE,
			MODULE_ID,
			IS_STANDART
		FROM
			SETUP_PRINT_FILES
		WHERE
			FORM_ID = #attributes.form_type#
	</cfquery>
	<cfquery name="GET_ACCOUNT" datasource="#DSN2#">
		SELECT
			CARD_ID
		FROM
			ACCOUNT_CARD
		WHERE
			CARD_ID IS NOT NULL
			<cfif len(attributes.empo_id)>
				AND RECORD_EMP = #attributes.empo_id#
			</cfif>
			<cfif isdate(attributes.action_start_date) and isdate(attributes.action_finish_date)>
				AND ACTION_DATE BETWEEN #attributes.action_start_date# AND #attributes.action_finish_date#
			<cfelseif isdate(attributes.action_start_date)>
				AND ACTION_DATE >= #attributes.action_start_date#
			<cfelseif isdate(attributes.action_finish_date)>
				AND ACTION_DATE <= #attributes.action_finish_date#
			</cfif>
			<cfif isDefined("attributes.action_type_id") and len(attributes.action_type_id)>
				AND CARD_TYPE=#attributes.action_type_id#
			</cfif>
			<cfif isDefined("attributes.action_process_cat") and len(attributes.action_process_cat)><!--- fişin baglı oldugu işlemin kategorisi --->
				<cfif listlen(attributes.action_process_cat,'-') eq 1 or (listlen(attributes.action_process_cat,'-') gt 1 and listlast(attributes.action_process_cat,'-') eq 0)>
					AND ACTION_TYPE=#listfirst(attributes.action_process_cat,'-')#
				<cfelse>
					AND ACTION_CAT_ID=#listlast(attributes.action_process_cat,'-')#
				</cfif>
			</cfif>
            <cfif isdefined("attributes.acc_branch_id") and len(attributes.acc_branch_id)>
                AND CARD_ID IN
                    (
                        SELECT
                            ACCR.CARD_ID
                        FROM
                            ACCOUNT_CARD_ROWS ACCR
                        WHERE
                            ACCR.CARD_ID = CARD_ID
                            AND ACCR.ACC_BRANCH_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.acc_branch_id#">
                    )
            </cfif>
			<cfif isdate(attributes.record_date)>
				AND RECORD_DATE >= #attributes.record_date#
				AND RECORD_DATE < #DATEADD("d",1,attributes.record_date)#
			</cfif>
			<cfif isDefined('attributes.order_type') and attributes.order_type eq 2>
				ORDER BY ACTION_DATE
			<cfelseif isDefined('attributes.order_type') and attributes.order_type eq 3>
				ORDER BY BILL_NO
			<cfelseif isDefined('attributes.order_type') and attributes.order_type eq 4>
				ORDER BY BILL_NO DESC
			<cfelse>
				ORDER BY ACTION_DATE DESC
			</cfif>
	</cfquery>
	<cfset fis_list = valuelist(GET_ACCOUNT.CARD_ID,',')>
	<cfloop list="#fis_list#" index="i">
		<cfquery name="account_" datasource="#DSN2#">
			SELECT
				CARD_ID,
				ACTION_ID,
				ACTION_TYPE
			FROM
				ACCOUNT_CARD
			WHERE
				CARD_ID = #i#
		</cfquery>
		<cfif account_.recordcount>
			<cfif len(account_.ACTION_TYPE) and len(account_.ACTION_ID)>
				<cfset attributes.action_id = account_.ACTION_ID>
				<cfset attributes.action_type = account_.ACTION_TYPE>
				<cfset attributes.card_id = account_.CARD_ID>
			<cfelse>
				<cfset attributes.action_type = "">
				<cfset attributes.action_id = account_.CARD_ID>
			</cfif>
			<!--- Bu Bölüm loop içinde dönecek --->
			<div class="printThis">
				<cfif get_form.is_standart eq 1>
					<cfinclude template="/#get_form.template_file#">
				<cfelse>
					<cfinclude template="/documents/settings/#get_form.template_file#">
					<cfif i neq ListLast(fis_list)>
						<div style="page-break-after: always"></div>
					</cfif>
				</cfif>
			</div>
			<!--- Bu Bölüm loop içinde dönecek --->
		</cfif>
	</cfloop>
	</div>

</cfif>
<script type="text/javascript">

	function kontrol()
	{
		y = document.page_print_account.action_type_id.selectedIndex;
		x = document.page_print_account.form_type.selectedIndex;
		if (document.page_print_account.form_type[x].value == "")
		{
			alert('<cfoutput><cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='47566.Baskı Formu'></cfoutput>');
			return false;
		}
		if((document.page_print_account.EMPO_ID.value=="") && (document.page_print_account.action_start_date.value=="") && (document.page_print_account.action_finish_date.value=="") && (document.page_print_account.record_date.value==""))
			{
			alert('<cf_get_lang dictionary_id='63587.Girilmesi zorunlu alan'> : <cf_get_lang dictionary_id='57742.Tarih'>   <cf_get_lang dictionary_id='57998.veya'>  <cf_get_lang dictionary_id='57899.Kaydeden'>');
			return false;
			}
		return true;
	}
	function print_fis(){
		$('.printThis').printThis();
	}
</script>

