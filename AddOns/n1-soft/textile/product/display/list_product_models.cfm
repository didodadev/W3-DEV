<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_obm" default="1">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.project_emp_id" default="">
<cfparam name="attributes.emp_name" default="">
<cfparam name="attributes.company_order_no" default="">


<cfif isDefined("attributes.not_is_task")>
	<cfset is_task=0>
<cfelse>
	<cfset is_task=1>
</cfif>

<cfif isdefined("attributes.form_submitted")>
    <cfquery name="get_product_models" datasource="#dsn1#">
        SELECT
			R.REQ_NO,
			R.REQ_ID,
			R.PROJECT_ID,
            MODEL_ID,
			MODEL_CODE,
			MODEL_NAME,
            PRODUCT_BRANDS.BRAND_NAME,
			PRODUCT_BRANDS_MODEL.EMP_ID,
			C.FULLNAME,
			C.COMPANY_ID,
			PROCESS_TYPE_ROWS.STAGE,
			TPP.PLAN_ID,
			PRO_PROJECTS.PROJECT_HEAD
        FROM
			#dsn3#.TEXTILE_SAMPLE_REQUEST R
			left JOIN #dsn#.COMPANY C on R.COMPANY_ID=C.COMPANY_ID
			LEFT JOIN #dsn#.PRO_PROJECTS ON PRO_PROJECTS.PROJECT_ID=R.PROJECT_ID,
			#dsn3#.TEXTILE_PRODUCT_PLAN TPP
			left JOIN #dsn#.PROCESS_TYPE_ROWS ON PROCESS_TYPE_ROWS.PROCESS_ROW_ID=TPP.STAGE_ID
            LEFT JOIN PRODUCT_BRANDS_MODEL ON TPP.REQUEST_ID=PRODUCT_BRANDS_MODEL.REQUEST_ID
			LEFT JOIN PRODUCT_BRANDS ON PRODUCT_BRANDS_MODEL.BRAND_ID = PRODUCT_BRANDS.BRAND_ID
			
        WHERE
			R.REQ_ID=TPP.REQUEST_ID AND PLAN_TYPE_ID=6<!---model tasarım talepleri işlem tipi--->
        <cfif len(attributes.keyword)>
            AND (MODEL_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> 
					OR BRAND_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
					OR R.REQ_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				)
        </cfif>
		<cfif isDefined("attributes.company_order_no") and len(attributes.company_order_no)>
					AND R.COMPANY_ORDER_NO='#attributes.company_order_no#'
		</cfif>
			<cfif len(attributes.project_emp_id) and len(attributes.emp_name)>
				AND PRODUCT_BRANDS_MODEL.EMP_ID=#attributes.project_emp_id#
			</cfif>
			<cfif Listlen(attributes.process_stage)>
				AND (PRODUCT_BRANDS_MODEL.STAGE_ID IN(#attributes.process_stage#)
					OR TPP.STAGE_ID IN(#attributes.process_stage#)
				)
			</cfif>
			<cfif isDefined("is_task") and is_task eq 0>
				AND PRODUCT_BRANDS_MODEL.EMP_ID IS NULL
			</cfif>
        ORDER BY
		<cfif isdefined("attributes.is_obm") and attributes.is_obm eq 0>
			MODEL_CODE
		<cfelse>
			MODEL_NAME
		</cfif>
    </cfquery>
<cfelse>
	<cfset get_product_models.recordcount = 0>
</cfif>

<cfquery name="get_process_type" datasource="#dsn#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%textile.list_product_models%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_product_models.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="search_model" action="#request.self#?fuseaction=textile.list_product_models" method="post">
<input type="hidden" name="form_submitted" id="form_submitted" value="1">
<cf_big_list_search title="#getLang('textile',18)#"> 
	<cf_big_list_search_area>
    	<div class="row">
        	<div class="col col-12 form-inline">
            	<div class="form-group">
                	<div class="input-group">
                    	<cfinput type="text" name="keyword" id="keyword" placeholder="#getlang('main',48)#" style="width:100px;" value="#attributes.keyword#" maxlength="50">
                    </div>
                </div>
				 <div class="form-group" id="form-order_no">
                    <div class="input-group"><cfinput type="text" name="company_order_no" id="company_order_no" value="#attributes.company_order_no#" placeholder="Order No "></div>
                </div>
				<div class="form-group" id="form_ul_process_stage">
                <div class="input-group" >
                    <cf_multiselect_check
                        name="process_stage"
                        query_name="get_process_type"
                        option_name="stage"
                        option_value="process_row_id"
                        option_text="Süreç"
                        value="#attributes.process_stage#">
                </div>

				 <div class="form-group" id="form_ul_record_employee">
                        <div class="input-group">
							  <cfinput type="hidden" name="project_emp_id" id="project_emp_id"  value="#attributes.project_emp_id#">
                              <cfinput type="text" name="emp_name" id="emp_name" value="#attributes.emp_name#" placeholder="Tasarımcı"  onFocus="AutoComplete_Create('emp_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0,0','PARTNER_ID,EMPLOYEE_ID','outsrc_partner_id,project_emp_id','plan','3','250');">
                              <span class="input-group-addon icon-ellipsis btnPointer" onclick="javascript:gonder2('search_model.emp_name');"></span>
						</div>
			  	</div>
				<div class="form-group" id="form-task_emp_id">
                    <div class="input-group x-20">
						<input type="checkbox" name="not_is_task" <cfif isDefined("attributes.not_is_task")>checked</cfif> value="" class="checkbox">Tasarımcı Atanmayan kayıtları listele
					</div>
                </div>
            </div>
                <!--- <div class="form-group">
                	<div class="input-group">
                    	<select name="is_obm" id="is_obm" style="width:75">
                            <option value="">Sıralama</option>
                            <option value="1" <cfif attributes.is_obm eq 1>selected</cfif>>Isme Gore</option>
                            <option value="0" <cfif attributes.is_obm eq 0>selected</cfif>>Koda Gore</option>
                        </select>
                    </div>
                </div>
               <td><cf_get_lang_main no='1435.Marka'>
              
                    <cf_wrkProductBrand
                        width="100"
                        compenent_name="getProductBrand"               
                        boxwidth="240"
                        boxheight="150"
                        brand_ID="#attributes.brand_id#">
                </td>--->
                <div class="form-group">
                	<div class="input-group x-3_5">
                    	<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                    </div>
                </div>
                <div class="form-group">
                	<div class="input-group">
                    	<cf_wrk_search_button>
						<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                    </div>
                </div>
            </div>
        </div>
	</cf_big_list_search_area>
</cf_big_list_search>
</cfform>
<cf_big_list>
	<thead>
		<tr>
			<th width="35"><cf_get_lang_main no='1165.Sıra'></th>
			<th>Numune No</th>
			<th style="width:20%;">Müşteri </td>
				<th style="width:10%;">Müşteri Order No</th>
			<th style="width:10%;">Proje No</th>
           <!--- <th width="50">ID</th>--->
			<th width="70"><cf_get_lang_main no='813.Model'><cf_get_lang_main no='1173.Kod'></th>
			<th><cf_get_lang_main no='813.Model'><cf_get_lang_main no='485.Adı'></th>
			<th style="width:5%;">Süreç</th>
            <th>Tasarımcı</th>
			
			<th></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_product_models.recordcount>
			<cfoutput query="get_product_models" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td>#currentrow#</td>
					<td>#req_no#</td>
					<td>#FULLNAME#</td>
					<td>#COMPANY_ORDER_NO#</td>
					 <td>#PROJECT_HEAD#</td>
                   <!--- <td><a href="javascript://" class="tableyazi"  onClick="windowopen('#request.self#?fuseaction=textile.list_product_models&event=upd&req_id=#req_id#&model_id=#get_product_models.model_id#','medium');">#model_id#</a></td>--->
					<td width="70">#model_code#</td>
					<td><a href="javascript://" class="tableyazi"  onClick="windowopen('#request.self#?fuseaction=textile.list_product_models&event=upd&req_id=#req_id#&plan_id=#plan_id#&model_id=#get_product_models.model_id#','medium');">#model_name#</a></td>
                    <td>#stage#</td>
					<td>#get_emp_info(emp_id,0,0)#</td>
					<!-- sil -->
					<td>
					<cfif len(model_id)>
						<a href="javascript://"  onClick="windowopen('#request.self#?fuseaction=textile.list_product_models&event=upd&req_id=#req_id#&plan_id=#plan_id#&model_id=#get_product_models.model_id#','medium');"><img src="/images/update_list.gif" title="<cf_get_lang_main no='52.Guncelle'>"></a></td>
					<cfelse>
						<a href="javascript://"  onClick="windowopen('#request.self#?fuseaction=textile.list_product_models&event=add&req_id=#req_id#&plan_id=#plan_id#','medium');"><img src="/images/plus_list.gif" title="<cf_get_lang_main no='52.Guncelle'>"></a></td>
					</cfif>
					<!-- sil -->
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="6"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'> !</cfif></td>
			</tr>
		</cfif>
	</tbody>
</cf_big_list>
<cfset url_str = "">
<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
	<cfif isdefined ("attributes.is_obm") and len (attributes.is_obm)>
		<cfset url_str ="#url_str#&is_obm=#attributes.is_obm#">
    </cfif>
	<cfif isdefined ("attributes.form_submitted") and len(attributes.form_submitted)>
        <cfset url_str ="#url_str#&form_submitted=#attributes.form_submitted#">
    </cfif>
    <cfif isdefined ("attributes.brand_id") and len(attributes.brand_id)>
        <cfset url_str ="#url_str#&form_submitted=#attributes.brand_id#">
    </cfif>
    <cf_paging page="#attributes.page#" 
        maxrows="#attributes.maxrows#"
        totalrecords="#attributes.totalrecords#"
        startrow="#attributes.startrow#"
        adres="product.list_product_models#url_str#">
<script type="text/javascript">
	$('#keyword').focus();
	//document.getElementById('keyword').focus();
	 function gonder2(str_alan_1)
                    {
                        str_list = '';
                           /* str_list = str_list+'branch_id='+document.getElementById("branch_id").value;
                            str_list = str_list+'&department_id='+document.getElementById("department").value;*/
                        windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_model.project_emp_id&'+str_list+'&field_name=search_model.emp_name <cfif isdefined("xml_only_employee") and xml_only_employee eq 0>&field_partner=search_model.outsrc_partner_id</cfif>&select_list=1,2&is_form_submitted=1&keyword='+encodeURIComponent(search_model.emp_name.value),'list');
                    }
</script>
 