<cfscript>
	bu_ay_basi = CreateDate(year(now()),12,1);
	bu_ay_sonu = DaysInMonth(bu_ay_basi);
</cfscript>
<cfparam name="attributes.comp_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.pos_cat" default="">
<cfparam name="attributes.title_id" default="">
<cfparam name="attributes.func_id" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.startdate" default="1/1/#session.ep.period_year#">
<cfparam name="attributes.finishdate" default="#bu_ay_sonu#/12/#session.ep.period_year#">
<cfif len(attributes.startdate) and isdate(attributes.startdate) >
	<cf_date tarih="attributes.startdate">
<cfelse>
	<cfset attributes.startdate = "">
</cfif>
<cfif len(attributes.finishdate) and isdate(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
<cfelse>
	<cfset attributes.finishdate="">
</cfif>
<cfif isdefined("attributes.is_submitted")>
	<cfquery name="get_emp_req_tra" datasource="#DSN#">
    	SELECT DISTINCT    
        	EP.EMPLOYEE_ID, 
            EP.EMPLOYEE_NAME, 
            EP.EMPLOYEE_SURNAME,
            EP.POSITION_CODE, 
            ST.TITLE,
            D.DEPARTMENT_HEAD, 
            D.DEPARTMENT_ID, 
            B.BRANCH_NAME,
            SPC.POSITION_CAT,
            SCU.UNIT_NAME,
            OC.COMPANY_NAME
		FROM        
        	EMPLOYEE_POSITIONS EP
			LEFT JOIN SETUP_TITLE ST ON EP.TITLE_ID = ST.TITLE_ID 
			LEFT JOIN EMPLOYEES_IN_OUT EIO ON EP.EMPLOYEE_ID = EIO.EMPLOYEE_ID
			LEFT JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = EP.POSITION_CAT_ID
			LEFT JOIN DEPARTMENT D ON EP.DEPARTMENT_ID = D.DEPARTMENT_ID
			LEFT JOIN BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
            LEFT JOIN OUR_COMPANY OC ON OC.COMP_ID = B.COMPANY_ID
			LEFT JOIN SETUP_CV_UNIT SCU ON SCU.UNIT_ID = EP.FUNC_ID,
            (SELECT 
       			*,
       			ISNULL((SELECT TOP 1 RELATION_FIELD_ID FROM RELATION_SEGMENT_TRAINING WHERE RELATION_ACTION = 1 AND RELATION_FIELD_ID IN (SELECT TRAINING_ID FROM TRAINING_CLASS WHERE CLASS_ID = #attributes.class_id#)),0) AS IS_COMPANY,
      	 		ISNULL((SELECT TOP 1 RELATION_FIELD_ID FROM RELATION_SEGMENT_TRAINING WHERE RELATION_ACTION = 2 AND RELATION_FIELD_ID IN (SELECT TRAINING_ID FROM TRAINING_CLASS WHERE CLASS_ID = #attributes.class_id#)),0) AS IS_DEPARTMENT,
	   			ISNULL((SELECT TOP 1 RELATION_FIELD_ID FROM RELATION_SEGMENT_TRAINING WHERE RELATION_ACTION = 3 AND RELATION_FIELD_ID IN (SELECT TRAINING_ID FROM TRAINING_CLASS WHERE CLASS_ID = #attributes.class_id#)),0) AS IS_POS_CAT,
	   			ISNULL((SELECT TOP 1 RELATION_FIELD_ID FROM RELATION_SEGMENT_TRAINING WHERE RELATION_ACTION = 5 AND RELATION_FIELD_ID IN (SELECT TRAINING_ID FROM TRAINING_CLASS WHERE CLASS_ID = #attributes.class_id#)),0) AS IS_FUNC,
	   			ISNULL((SELECT TOP 1 RELATION_FIELD_ID FROM RELATION_SEGMENT_TRAINING WHERE RELATION_ACTION = 6 AND RELATION_FIELD_ID IN (SELECT TRAINING_ID FROM TRAINING_CLASS WHERE CLASS_ID = #attributes.class_id#)),0) AS IS_ORG_STEP,
       			ISNULL((SELECT TOP 1 RELATION_FIELD_ID FROM RELATION_SEGMENT_TRAINING WHERE RELATION_ACTION = 7 AND RELATION_FIELD_ID IN (SELECT TRAINING_ID FROM TRAINING_CLASS WHERE CLASS_ID = #attributes.class_id#)),0) AS IS_BRANCH
			FROM 
       			TRAINING
			) T1
		WHERE     
        	EP.EMPLOYEE_ID IS NOT NULL 
            AND EP.EMPLOYEE_ID <> 0 
            AND EP.IS_MASTER = 1
            AND ((IS_COMPANY > 0 AND OC.COMP_ID IN (SELECT DISTINCT RELATION_ACTION_ID FROM RELATION_SEGMENT_TRAINING WHERE RELATION_ACTION = 1 AND RELATION_FIELD_ID IN (SELECT TRAINING_ID FROM TRAINING_CLASS WHERE CLASS_ID = #attributes.class_id#))) OR IS_COMPANY = 0)
			AND ((IS_DEPARTMENT > 0 AND D.DEPARTMENT_ID IN (SELECT DISTINCT RELATION_ACTION_ID FROM RELATION_SEGMENT_TRAINING WHERE RELATION_ACTION = 2 AND RELATION_FIELD_ID IN (SELECT TRAINING_ID FROM TRAINING_CLASS WHERE CLASS_ID = #attributes.class_id#))) OR IS_DEPARTMENT = 0)
			AND ((IS_POS_CAT > 0 AND EP.POSITION_CAT_ID IN (SELECT DISTINCT RELATION_ACTION_ID FROM RELATION_SEGMENT_TRAINING WHERE RELATION_ACTION = 3 AND RELATION_FIELD_ID IN (SELECT TRAINING_ID FROM TRAINING_CLASS WHERE CLASS_ID = #attributes.class_id#))) OR IS_POS_CAT = 0)
			AND ((IS_FUNC > 0 AND EP.FUNC_ID IN (SELECT DISTINCT RELATION_ACTION_ID FROM RELATION_SEGMENT_TRAINING WHERE RELATION_ACTION = 5 AND RELATION_FIELD_ID IN (SELECT TRAINING_ID FROM TRAINING_CLASS WHERE CLASS_ID = #attributes.class_id#))) OR IS_FUNC = 0)
			AND ((IS_ORG_STEP > 0 AND EP.ORGANIZATION_STEP_ID IN (SELECT DISTINCT RELATION_ACTION_ID FROM RELATION_SEGMENT_TRAINING WHERE RELATION_ACTION = 6 AND RELATION_FIELD_ID IN (SELECT TRAINING_ID FROM TRAINING_CLASS WHERE CLASS_ID = #attributes.class_id#))) OR IS_ORG_STEP = 0)
			AND ((IS_BRANCH > 0 AND B.BRANCH_ID IN (SELECT DISTINCT RELATION_ACTION_ID FROM RELATION_SEGMENT_TRAINING WHERE RELATION_ACTION = 7 AND RELATION_FIELD_ID IN (SELECT TRAINING_ID FROM TRAINING_CLASS WHERE CLASS_ID = #attributes.class_id#))) OR IS_BRANCH = 0)
            <cfif len(attributes.keyword)>
				AND ((EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME) LIKE '%#attributes.keyword#%')
			</cfif>
            <cfif len(attributes.comp_id)>
				AND OC.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#">
			</cfif>
            <cfif len(attributes.branch_id)>
				AND B.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
			</cfif>
            <cfif len(attributes.department)>
				AND D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#">
			</cfif>
            <cfif len(attributes.pos_cat)>
				AND EP.POSITION_CAT_ID IN (#attributes.pos_cat#) 
			</cfif>
            <cfif len(attributes.title_id)>
				AND EP.TITLE_ID IN (#attributes.title_id#) 
			</cfif>
            <cfif len(attributes.func_id)>
				AND EP.FUNC_ID IN (#attributes.func_id#) 
			</cfif>
            <cfif isdefined('attributes.startdate') and isdate(attributes.startdate) and isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
            AND (
            	(EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                 EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">)
                OR
                (EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                 EIO.FINISH_DATE IS NULL)
                OR
                 (EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                  EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">)
                OR
                 (EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                  EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">)
            )
            </cfif>
            AND EP.EMPLOYEE_ID NOT IN
           		(SELECT TCA.EMP_ID
                 FROM
                 	TRAINING_CLASS TC 
                    INNER JOIN TRAINING T ON TC.TRAINING_ID = T.TRAIN_ID 
                    INNER JOIN TRAINING_CLASS_ATTENDER TCA ON TC.CLASS_ID = TCA.CLASS_ID
              	 WHERE    
                 	(TCA.STATUS <> 0 OR TCA.STATUS IS NULL) 
                 	<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
                    	AND TC.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
                    	AND TC.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
                	</cfif>
                    <cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
                    	AND TC.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                    	AND TC.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                	</cfif>
                    AND T.TRAIN_ID IN  
                    	(SELECT TRAINING_ID FROM TRAINING_CLASS WHERE CLASS_ID = #attributes.class_id#))
      	ORDER BY EMPLOYEE_NAME
    </cfquery>
<cfelse>
	<cfset get_emp_req_tra.recordcount=0>
</cfif>
<cfquery name="get_company" datasource="#dsn#">
	SELECT COMP_ID,NICK_NAME FROM OUR_COMPANY ORDER BY NICK_NAME
</cfquery>
<cfquery name="get_branchs" datasource="#dsn#">
	SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE <cfif isdefined('attributes.comp_id') and len(attributes.comp_id)>COMPANY_ID IN(#attributes.comp_id#)<cfelse>1=0</cfif>ORDER BY BRANCH_NAME
</cfquery>
<cfquery name="get_position_cats" datasource="#dsn#">
	SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT 
</cfquery>
<cfquery name="get_titles" datasource="#dsn#">
	SELECT TITLE_ID,TITLE FROM SETUP_TITLE WHERE IS_ACTIVE = 1 ORDER BY TITLE 
</cfquery>
<cfquery name="get_units" datasource="#dsn#">
	SELECT UNIT_ID,UNIT_NAME FROM SETUP_CV_UNIT ORDER BY UNIT_NAME 
</cfquery>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_emp_req_tra.recordcount#">	
<cfparam name="attributes.page" default=1>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_string = ''>
<cfset url_string = "#url_string#&class_id=#attributes.class_id#">
<cfif isdefined("attributes.is_submitted")>
	<cfset url_string = "#url_string#&is_submitted=#attributes.is_submitted#">
</cfif>
<cfif isdefined("attributes.startdate")>
	<cfset url_string = "#url_string#&startdate=#dateformat(attributes.startdate,dateformat_style)#">
</cfif>
<cfif isdefined("attributes.finishdate")>
	<cfset url_string = "#url_string#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#">
</cfif>
<cfif isdefined("attributes.comp_id")>
	<cfset url_string = "#url_string#&comp_id=#attributes.comp_id#">
</cfif>
<cfif isdefined("attributes.branch_id")>
	<cfset url_string = "#url_string#&branch_id=#attributes.branch_id#">
</cfif>
<cfif isdefined("attributes.department")>
	<cfset url_string = "#url_string#&department=#attributes.department#">
</cfif>
<cfif isdefined("attributes.pos_cat")>
	<cfset url_string = "#url_string#&pos_cat=#attributes.pos_cat#">
</cfif>
<cfif isdefined("attributes.title_id")>
	<cfset url_string = "#url_string#&title_id=#attributes.title_id#">
</cfif>
<cfif isdefined("attributes.func_id")>
	<cfset url_string = "#url_string#&func_id=#attributes.func_id#">
</cfif>
<cfif isdefined("attributes.keyword")>
	<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
</cfif>
<cfform name="search" id="search" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
<input type="hidden" name="is_submitted" id="is_submitted" value="1">
<input type="hidden" name="class_id" id="class_id" value="<cfoutput>#attributes.class_id#</cfoutput>">
<cf_big_list_search title="Eğitimi Alması Gerekenler">
    <cf_big_list_search_area>
    	<div class="row form-inline">
				<div class="form-group" id="item-keyword">
					<div class="input-group x-12">
						<cfinput type="Text" style="width:80px;" maxlength="255" value="#attributes.keyword#" name="keyword" id="keyword" placeholder="#getLang('main',48)#">
					</div>
				</div>
            	<div class="form-group" id="item-comp_id">
					<div class="input-group x-12">
						<select name="comp_id" id="comp_id" onchange="showBranch(this.value)">
							<option value=""><cf_get_lang_main no='162.Şirket'></option>
							<cfoutput query="get_company">
								<option value="#COMP_ID#" <cfif isdefined("attributes.comp_id") and attributes.comp_id eq comp_id>selected</cfif>>#NICK_NAME#</option>
							</cfoutput>
						</select>
                	</div>
				</div>
				<div class="form-group" id="item-startdate">
					<div class="input-group x-12">
						<cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no='641.Başlangıç Tarihi'></cfsavecontent>
						<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
							<cfinput type="text" name="startdate" id="startdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#"  value="#dateformat(attributes.startdate,dateformat_style)#">
						<cfelse>
							<cfinput type="text" name="startdate" id="startdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#" >
						</cfif>
						<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
					</div>
				</div>	
				<div class="form-group" id="item-finishdate">
					<div class="input-group x-12">
						<cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no='288.Bitiş Tarihi'></cfsavecontent>
						<cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
							<cfinput type="text" name="finishdate" id="finishdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.finishdate,dateformat_style)#">
						<cfelse>
							<cfinput type="text" name="finishdate" id="finishdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#" >
						</cfif>
						<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
					</div>
				</div>
            	<div class="form-group x-3_5">
					<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button>
				</div>
            </div>
        </div>
	</cf_big_list_search_area>
       <cf_big_list_search_detail_area>
        	<div class="row form-inline">
				<div class="form-group" id="item-branch_id">
					<div class="input-group x-12">
						<div width="120" id="BRANCH_PLACE">
							<select name="branch_id" id="branch_id" style="width:140px;" onchange="showDepartment(this.value)">
								<option value=""><cf_get_lang_main no='41.Şube'></option>
								<cfif isdefined('attributes.comp_id') and len(attributes.comp_id)>
								<cfoutput query="get_branchs">
									<option value="#branch_id#" <cfif isdefined("attributes.branch_id") and attributes.branch_id eq branch_id>selected</cfif>>#branch_name#</option>
								</cfoutput>
								</cfif>
							</select>
						</div>
					</div>
				</div>	
				<div class="form-group" id="item-department">
					<div class="input-group x-12">
						<div width="120" id="DEPARTMENT_PLACE">
							<select name="department" id="department" style="width:140px;">
								<option value=""><cf_get_lang_main no='160.Departman'></option>
								<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
									<cfquery name="get_department" datasource="#dsn#">
										SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE BRANCH_ID = #attributes.branch_id# AND DEPARTMENT_STATUS =1 ORDER BY DEPARTMENT_HEAD
									</cfquery>
									<cfoutput query="get_department">
										<option value="#DEPARTMENT_ID#"<cfif isdefined('attributes.department') and attributes.department eq get_department.department_id>selected</cfif>>#DEPARTMENT_HEAD#</option>
									</cfoutput>
								</cfif>
							</select>
						</div>
					</div>
				</div>	
				<div class="form-group" id="item-POSITION_CAT">
					<div class="input-group x-12">
						<div style="position:relative; z-index:1;">
						<cf_multiselect_check
							name="pos_cat"
							query_name="get_position_cats"
							width="115"
							option_text="#getLang('main',1592)#"
							option_value="POSITION_CAT_ID"
							option_name="POSITION_CAT"
							value="#iif(isdefined("attributes.pos_cat"),"attributes.pos_cat",DE(""))#">
						</div>
					</div>
				</div>	
				<div class="form-group" id="item-TITLE">
					<div class="input-group x-12">
						<div style="position:relative; z-index:1;">
						<cf_multiselect_check
							name="title_id"
							query_name="get_titles"
							width="115"
							option_text="#getLang('main',159)#"
							option_value="TITLE_ID"
							option_name="TITLE"
							value="#iif(isdefined("attributes.title_id"),"attributes.title_id",DE(""))#">
						</div>
					</div>
				</div>	
				<div class="form-group" id="item-UNIT_NAME">
					<div class="input-group x-12">
						<div style="position:relative; z-index:1;">
						<cf_multiselect_check
							name="func_id"
							query_name="get_units"
							width="115"
							option_text="#getLang('main',1289)#"
							option_value="UNIT_ID"
							option_name="UNIT_NAME"
							value="#iif(isdefined("attributes.func_id"),"attributes.func_id",DE(""))#">
						</div>
					</div>
				</div>	
			</div>
        </cf_big_list_search_detail_area>
    </cf_big_list_search>
</cfform>
<cf_medium_list>
	<thead>
		<tr>
			<th width="15"></th>
			<th width="120"><cf_get_lang_main no='158.Ad Soyad'></th>
			<th width="120"><cf_get_lang_main no='41.Şube'></th>
            <th width="80"><cf_get_lang_main no='160.Departman'></th>
            <th width="100"><cf_get_lang_main no='1592.Pozisyon Tipi'></th>
            <th width="100"><cf_get_lang_main no='159.Ünvan'></th>
			<th width="120"><cf_get_lang_main no='1289.Fonksiyon'></th>
			<cfif get_emp_req_tra.recordcount><th width="70" style="width:70px;" align="center"><input type="checkbox" name="allSelecthemand" id="allSelecthemand" onClick="wrk_select_all('allSelecthemand','row_demand_accept');"></cfif>
		</tr>
	</thead>
    <form action="" method="post" name="train_reqs">
    	<cfif get_emp_req_tra.recordcount>
            <tbody>
                <cfoutput query="get_emp_req_tra" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td width="25"><cf_online id="#employee_id#" zone="ep"></td>
                        <td><a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&department_id=#department_id#&emp_id=#employee_id#&pos_id=#position_code##url_string#','medium')">#employee_name# #employee_surname#</a></td>
                        <td>#branch_name#</td>
                        <td>#department_head#</td>
                        <td>#POSITION_CAT#</td>
                        <td>#title#</td>
                        <td>#UNIT_NAME#</td>
                        <td><input type="checkbox" name="row_demand_accept" id="row_demand_accept" value="#EMPLOYEE_ID#;#attributes.class_id#;ac"></td>
                    </tr>
                </cfoutput>
            </tbody>
            <tfoot>
        	<tr height="25">
                <td colspan="9" style="text-align:right;">
                    <input type="button" name="mail" id="mail" value="<cf_get_lang_main no='49.Kaydet'>" onclick="KatilimciDurumuKaydet();">
                    <input type="hidden" name="id_list" id="id_list" value="">
                    <input type="hidden" name="katilimci_kaydet" id="katilimci_kaydet" value="">
                </td>
            </tr>
        </tfoot>
        <cfelse>
            <tbody>
                <tr>
                    <td colspan="9" align="left"><cfif isdefined("attributes.is_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz '> !</cfif></td>
                </tr>
            </tbody>
        </cfif>       
    </form>
</cf_medium_list>
<cfif (attributes.totalrecords gt attributes.maxrows)>
	<table width="99%" align="center">
		<tr> 
			<td height="35">
				<cf_pages page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="training_management.popup_list_emp_req_tra#url_string#"> 
			</td>
			<!-- sil --><td style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
		</tr>
	</table>
</cfif>

<script type="text/javascript">
	function showBranch(comp_id)	
	{
		var comp_id = document.getElementById('comp_id').value;
		if (comp_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&comp_id="+comp_id;
			AjaxPageLoad(send_address,'BRANCH_PLACE',1,'<cf_get_lang no="684.İlişkili Şubeler">');
		}
		else {
			var myList = document.getElementById("branch_id");
			myList.options.length = 0;
			var txtFld = document.createElement("option");
			txtFld.value='';
			txtFld.appendChild(document.createTextNode('<cf_get_lang_main no="41.Şube">'));
			myList.appendChild(txtFld);
			var myList = document.getElementById("department");
			myList.options.length = 0;
			var txtFld = document.createElement("option");
			txtFld.value='';
			txtFld.appendChild(document.createTextNode('<cf_get_lang_main no="160.Departman">'));
			myList.appendChild(txtFld);
			}
		//departman bilgileri sıfırla
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id=0";
		AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'<cf_get_lang no="685.İlişkili Departmanlar">');
	}
	function showDepartment(branch_id)	
	{
		var branch_id = document.getElementById("branch_id").value;
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
			AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
		}
		else
		{
			var myList = document.getElementById("department");
			myList.options.length = 0;
			var txtFld = document.createElement("option");
			txtFld.value='';
			txtFld.appendChild(document.createTextNode('<cf_get_lang_main no="160.Departman">'));
			myList.appendChild(txtFld);
		}
	}
	function KatilimciDurumuKaydet(){
		var is_selected=0;
		if(document.getElementsByName('row_demand_accept').length > 0){
			var id_list="";
			if(document.getElementsByName('row_demand_accept').length ==1){
				if(document.getElementById('row_demand_accept').checked==true){
					is_selected=1;
					id_list+=document.train_reqs.row_demand_accept.value+',';
				}
			} else {
				for (i=0;i<document.getElementsByName('row_demand_accept').length;i++){
					if(document.train_reqs.row_demand_accept[i].checked==true){ 
						id_list+=document.train_reqs.row_demand_accept[i].value+',';
						is_selected=1;	
					}
				}
			}
		}
		if(is_selected==1){
			if(list_len(id_list,',') > 1){
				id_list = id_list.substr(0,id_list.length-1);
				document.getElementById('id_list').value=id_list;
				document.getElementById('katilimci_kaydet').value=1;
				katilimci_kaydet_ = document.getElementById('katilimci_kaydet').value;
				if(confirm("<cf_get_lang_main no='123.Kaydetmek İstediğinizden Emin Misiniz?'> ?")){
					train_reqs.action='<cfoutput>#request.self#?fuseaction=training_management.emptypopup_add_reqs_attenders&fsactn=training_management.popup_list_emp_req_tra#url_string#</cfoutput>&id_list='+document.getElementById('id_list').value;
					train_reqs.submit();
					wrk_opener_reload();
				}
			}
		} else {
			alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='1983.Katılımcı'>");
			return false;
		}
	}
</script>
