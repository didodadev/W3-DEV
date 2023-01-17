<cfif not isdefined("attributes.is_record")>
<cfif not len(attributes.TRAINING_ID)>
	<cfset attributes.TRAINING_ID = 0>
</cfif>
<cfset url_str = "">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.employee_ids_form" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.branch" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.comp_id" default="">
<cfif isdefined("attributes.is_submit")>
	<cfset url_str = "#url_str#&is_submit=#attributes.is_submit#">
</cfif>
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.func_id")>
	<cfset url_str = "#url_str#&func_id=#attributes.func_id#">
</cfif>
<cfif isdefined("attributes.organization_step_id")>
	<cfset url_str = "#url_str#&organization_step_id=#attributes.organization_step_id#">
</cfif>
<cfif isdefined("attributes.collar_type")>
	<cfset url_str = "#url_str#&collar_type=#attributes.collar_type#">
</cfif>
<cfif isdefined("attributes.IS_POTENTIAL")>
	<cfset url_str = "#url_str#&IS_POTENTIAL=#attributes.IS_POTENTIAL#">
<cfelse>
	<cfset attributes.is_potential = 0>
</cfif>
<cfif isdefined("attributes.is_attended")>
	<cfset url_str = "#url_str#&is_attended=#attributes.is_attended#">
</cfif>
<cfif len(attributes.branch) and len(attributes.branch_id)>
	<cfset url_str = "#url_str#&branch=#attributes.branch#&branch_id=#attributes.branch_id#">
</cfif>
<cfif len(attributes.comp_id)>
	<cfset url_str = "#url_str#&comp_id=#attributes.comp_id#">
</cfif>
<cfif len(attributes.department) and len(attributes.department_id)>
	<cfset url_str = "#url_str#&department=#attributes.department#&department_id=#attributes.department_id#">
</cfif>
<cfif isdefined("attributes.POSITION_CAT_ID")>
	<cfset url_str = "#url_str#&POSITION_CAT_ID=#attributes.POSITION_CAT_ID#">
<cfelse>
	<cfset attributes.POSITION_CAT_ID = "">
</cfif>
<cfquery name="get_our_company" datasource="#dsn#">
	SELECT COMP_ID,COMPANY_NAME FROM OUR_COMPANY ORDER BY COMPANY_NAME
</cfquery>
<cfinclude template="../query/get_position_cats.cfm">
<cfquery name="get_training_poscats_departments" datasource="#dsn#">
	SELECT TRAIN_POSITION_CATS,TRAIN_DEPARTMENTS FROM TRAINING WHERE TRAIN_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#attributes.TRAINING_ID#">)
</cfquery>
<cfquery name="get_emp_att" datasource="#dsn#">
	SELECT
		EMP_ID
	FROM
		TRAINING_CLASS_ATTENDER
	WHERE
		CLASS_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.class_id#">) AND
		EMP_ID IS NOT NULL AND
		PAR_ID IS NULL AND
		CON_ID IS NULL
	<cfif isdefined("attributes.IS_POTENTIAL") and attributes.IS_POTENTIAL IS 0 and isdefined("attributes.is_attended")>
	UNION
	SELECT DISTINCT
		TCAD.EMP_ID
	FROM
		TRAINING_CLASS_ATTENDANCE_DT TCAD,
		TRAINING_CLASS_ATTENDANCE TCA,
		TRAINING_CLASS_SECTIONS TCS
	WHERE
		TCS.TRAIN_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.training_id#">) AND
		TCS.CLASS_ID = TCA.CLASS_ID AND
		TCA.CLASS_ATTENDANCE_ID = TCAD.CLASS_ATTENDANCE_ID AND
		TCAD.IS_TRAINER = 0
	</cfif>
</cfquery>
<cfif isdefined("attributes.is_submit")>
	<cfif isdefined("attributes.IS_POTENTIAL") AND attributes.IS_POTENTIAL IS 0>
		<cf_relation_segment
			is_upd='1'
			is_form='1'
			field_id='#attributes.TRAINING_ID#'
			table_name='TRAINING'
			action_table_name='RELATION_SEGMENT_TRAINING'
			get_list= 2>
	</cfif>
	<cfinclude template="../query/get_class_potential_attenders.cfm">
<cfelse>
	<cfset get_class_potantial_attenders.recordcount=0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_class_potantial_attenders.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.trail")>
<cfinclude template="view_class.cfm">
</cfif>
	<table width="98%" height="35" align="center" border="0" cellpadding="0" cellspacing="0">
	<tr>
	<cfform name="add_potential_attenders" method="post" action="#request.self#?fuseaction=training_management.popup_list_notice_positions">
		<input type="hidden" name="is_submit" id="is_submit" value="1">
		<input type="hidden" name="class_id" id="class_id" value="<cfoutput>#attributes.class_id#</cfoutput>">
		<input type="hidden" name="training_id" id="training_id" value="<cfoutput>#attributes.training_id#</cfoutput>">	
		<input type="hidden" name="announce_id" id="announce_id" value="<cfoutput>#attributes.announce_id#</cfoutput>">	
	<td class="headbold"><cf_get_lang no='160.Potansiyel Katilimcilar'></td>
	<td style="text-align:right;">
      <table>
        <tr>			
			<td class="label"><cf_get_lang_main no='48.Filtre'>:</td>
			<td><cfinput type="text" name="keyword" value="#attributes.keyword#" style="width:90px;"></td>
			<cfquery name="get_units" datasource="#dsn#">
				SELECT 
                    * 
                FROM 
                    SETUP_CV_UNIT
			</cfquery>
			<td>
              <select name="func_id" id="func_id" style="width:100px;">
				<option value="">Fonksiyon <cf_get_lang_main no='322.Seçiniz'>
				<cfoutput query="get_units">
					<option value="#get_units.unit_id#" <cfif isdefined("attributes.func_id") and get_units.unit_id eq attributes.func_id>selected</cfif>>#get_units.unit_name# 
				</cfoutput>
			  </select>
            </td>
			<td><cfquery name="get_organization_steps" datasource="#dsn#">
					SELECT 
						ORGANIZATION_STEP_ID,
						ORGANIZATION_STEP_NAME
					FROM
						SETUP_ORGANIZATION_STEPS
				</cfquery>
				<select name="ORGANIZATION_STEP_ID" id="ORGANIZATION_STEP_ID" style="width:100px;">
                    <option value="">Kademe <cf_get_lang_main no='322.Seçiniz'>
                    <cfoutput query="get_organization_steps">
                        <option value="#ORGANIZATION_STEP_ID#"  <cfif isdefined("attributes.organization_step_id") and get_organization_steps.organization_step_id eq attributes.organization_step_id>selected</cfif>>#ORGANIZATION_STEP_NAME# 
                    </cfoutput>
				</select>
            </td>
			<td>
            	<select name="collar_type" id="collar_type" style="width:90px;">
					<option value="">Yaka Tipi <cf_get_lang_main no='322.Seçiniz'></option>
					<option value="1" <cfif isdefined("attributes.collar_type") and attributes.collar_type eq 1>selected</cfif>>Mavi Yaka</option>
					<option value="2" <cfif isdefined("attributes.collar_type") and attributes.collar_type eq 2>selected</cfif>>Beyaz Yaka</option>
				 </select>
            </td>
			<td><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
			<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></td>
			<td><cf_wrk_search_button search_function='form_isle()'></td>
			<!-- sil -->  
			<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
			<!-- sil -->
		</tr> 
      </table>
		</td>
	</tr>
	</table>
      <table cellSpacing="0" cellpadding="0" border="0" width="98%" align="center">    
		<tr class="color-border"> 
          <td> 		  
            <table width="100%" border="0" cellpadding="2" cellspacing="1">
              <!-- sil -->
			  <tr class="color-row">
			  <td colspan="6" align="right">			  		
		       <table height="25">
                <tr>
					<td>Sirket</td>
					<td>
                        <select name="comp_id" id="comp_id" style="width:180px;">
                            <option value="">Sirketler</option>
                            <cfoutput query="get_our_company">
                                <option value="#comp_id#"<cfif attributes.comp_id eq comp_id>selected</cfif>>#company_name#</option>
                            </cfoutput>
                        </select>
					</td>
					<td>Sube</td>
					<td><input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>">
						<input type="text" name="branch" id="branch" value="<cfoutput>#attributes.branch#</cfoutput>"style="width:130px"></td>
					<td><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_id=add_potential_attenders.branch_id&field_branch_name=add_potential_attenders.branch','list');"><img src="../../images/plus_thin.gif" border="0"></a></td>
				 	<td>Departman</td>
				  	<td><input type="hidden" name="department_id" id="department_id" value="<cfoutput>#attributes.department_id#</cfoutput>" style="width:15px">
						<input type="text" name="department" id="department" value="<cfoutput>#attributes.department#</cfoutput>" style="width:130px"></td>
					<td><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_name=add_potential_attenders.department&field_id=add_potential_attenders.department_id','list');"><img src="../../images/plus_thin.gif" border="0"></a></td>
				  <td><select name="POSITION_CAT_ID" id="POSITION_CAT_ID" style="width:160px;">
						<option value=""<cfif attributes.POSITION_CAT_ID is ""> selected</cfif>>Çalışan Pozisyonları></option>
						<cfoutput query="get_position_cats">
						<option value="#POSITION_CAT_ID#"<cfif attributes.POSITION_CAT_ID is POSITION_CAT_ID> selected</cfif>>#POSITION_CAT#</option>
						</cfoutput>
					  </select></td>
				</tr>
				<tr>
					<td colspan="10" style="text-align:right;">
				  	 Katilmadi<input type="checkbox" name="is_attended" id="is_attended" value="1" <cfif isdefined("attributes.is_attended")>checked</cfif>>
					  <select name="IS_POTENTIAL" id="IS_POTENTIAL">
						<option value="0"<cfif attributes.IS_POTENTIAL is 0>selected</cfif>><cf_get_lang no='102.Konuya Bagli'></option>
						<option value="1"<cfif attributes.IS_POTENTIAL is 1>selected</cfif>><cf_get_lang_main no='296.Tm'></option>
					  </select>
                    </td>
				</tr>
            </table>	
			</cfform>	    
			  </td>
			  </tr>
			<!-- sil -->
			  <tr class="color-header" height="22">                 
				<td class="form-title"><cf_get_lang no='161.Potansiyel Katilimci'></td>
				<td class="form-title"><cf_get_lang_main no='162.sirket'></td>
                <td class="form-title"><cf_get_lang no='130.Departman'></td>
                <td width="100" class="form-title"><cf_get_lang_main no='1085.Pozisyon Tipi'></td>
				<td width="14">&nbsp;</td>
                <!-- sil -->
				<td width="3%" align="center"><input type="Checkbox" name="all" id="all" value="1" onclick="hepsi();"></td>
				<!-- sil -->
			  </tr>
			  <cfform name="add_potential_attenders1" method="post" action="#request.self#?fuseaction=training_management.popup_list_notice_positions">
			  <input type="hidden" name="is_record" id="is_record" value="1">
			  <input type="hidden" name="announce_id" id="announce_id" value="<cfoutput>#attributes.announce_id#</cfoutput>">
			  <cfif get_class_potantial_attenders.recordcount>
			  <cfoutput query="get_class_potantial_attenders" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
			  <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_detail_emp&emp_id=#employee_id#','project');" class="tableyazi">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a> 
				</td><td>#NICK_NAME#</td>
				<td>#DEPARTMENT_HEAD#</td>
				<td>#POSITION_CAT#</td>
				<td width="14"><cfif is_master eq 1><img src="/images/b_ok.gif" align="absmiddle"></cfif></td>
				<!-- sil --><td align="center"><input type="checkbox" name="EMPLOYEE_IDS_form" id="EMPLOYEE_IDS_form" value="#EMPLOYEE_ID#" onClick="addOrDelId(#EMPLOYEE_ID#,#currentrow-1#);" <cfif len(attributes.EMPLOYEE_IDS_form)><cfloop list="#attributes.EMPLOYEE_IDS_form#" index="att_emp_id"><cfif EMPLOYEE_ID is att_emp_id>checked</cfif></cfloop></cfif>></td><!-- sil -->
			    
			  </tr>
			  </cfoutput>
			  <tr class="color-list">
				<td colspan="6" style="text-align:right;"><cf_workcube_buttons is_upd='0'></td> 
			  </tr>
			 <cfelse>
			  <tr class="color-list">
				<td colspan="6"><cfif isdefined("is_submit")><cf_get_lang_main no='72.Kayit Bulunamadi'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'>!</cfif></td> 
			  </tr>
			 </cfif> 
			 </cfform>
            </table>
          </td>
        </tr>
      </table>
	<cfif get_class_potantial_attenders.recordcount and (attributes.totalrecords gt attributes.maxrows)>
     <!-- sil -->
	 <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr> 
          <td height="35">
		  <cf_pages 
			  page="#attributes.page#" 
			  maxrows="#attributes.maxrows#" 
			  totalrecords="#attributes.totalrecords#" 
			  startrow="#attributes.startrow#" 
			  adres="training_management.popup_list_class_potential_attenders&training_id=#attributes.training_id#&class_id=#attributes.class_id#&announce_id=#attributes.announce_id##url_str#"></td>
          <td style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayit'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
        </tr>
      </table>
	  <!-- sil -->
	</cfif>
<script type="text/javascript">

function hepsi()
{
	if (add_potential_attenders.all.checked)
		{
	<cfif get_class_potantial_attenders.recordcount gt 1>
		for(i=0;i<add_potential_attenders.EMPLOYEE_IDS.length;i++) add_potential_attenders.EMPLOYEE_IDS[i].checked = true;
	<cfelseif get_class_potantial_attenders.recordcount eq 1>
		add_potential_attenders.EMPLOYEE_IDS.checked = true;
	</cfif>
		}
	else
		{
	<cfif get_class_potantial_attenders.recordcount gt 1>
		for(i=0;i<add_potential_attenders.EMPLOYEE_IDS.length;i++) add_potential_attenders.EMPLOYEE_IDS[i].checked = false;
	<cfelseif get_class_potantial_attenders.recordcount eq 1>
		add_potential_attenders.EMPLOYEE_IDS.checked = false;
	</cfif>
		}
}

<cfif isdefined("attributes.EMPLOYEE_IDS_form") and ListLen(attributes.EMPLOYEE_IDS_form) gt 1>
	checked_ids = new Array(<cfoutput>#attributes.EMPLOYEE_IDS_form#</cfoutput>);
<cfelseif isdefined("attributes.EMPLOYEE_IDS_form") and ListLen(attributes.EMPLOYEE_IDS_form) eq 1>
	checked_ids = new Array();
	checked_ids[0] = <cfoutput>#attributes.EMPLOYEE_IDS_form#</cfoutput>;
<cfelse>
	checked_ids = new Array();
</cfif>
function addOrDelId(id,row)
{
	if (document.add_potential_attenders.EMPLOYEE_IDS[row].checked == true)
		{
			checked_ids.push(id);
		}
	else
		{
			for (i=0; i<=checked_ids.length; i++)
			{
				if (checked_ids[i] == id)
					checked_ids.splice(i,1);
			}
		}
}
/*function gonder()
{
	alert(document.add_potential_attenders.EMPLOYEE_IDS_form);
	if(document.add_potential_attenders.EMPLOYEE_IDS_form !=undefined)
	{
	document.add_potential_attenders.EMPLOYEE_IDS_form.value = checked_ids.toString();
	}	
	return true;
}*/
function form_isle()
	{
	<!--- alert(document.add_potential_attenders.EMPLOYEE_IDS_form); --->
	/*if(document.add_potential_attenders.EMPLOYEE_IDS_form!=undefined)
	{
		document.add_potential_attenders.EMPLOYEE_IDS_form.value = checked_ids.toString();
	}*/
		document.add_potential_attenders.action = '<cfoutput>#request.self#?fuseaction=training_management.popup_list_class_potential_attenders&class_id=#attributes.class_id#&training_id=#attributes.training_id#&announce_id=#attributes.announce_id#</cfoutput>'
		document.add_potential_attenders.submit();
}
</script>
<cfelse>
	<cfloop from="1" to="#listlen(attributes.EMPLOYEE_IDS,',')#" index="i">
		<cfquery name="ADD_ATTENDER" datasource="#DSN#">
			INSERT
			INTO
				TRAINING_CLASS_ANNOUNCE_ATTS
				(
					EMPLOYEE_ID,
					ANNOUNCE_ID
				)
				VALUES
				(
					#listgetat(attributes.EMPLOYEE_IDS,i,',')#,
					#attributes.announce_id#
				)
		</cfquery>
	</cfloop>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
</cfif>
