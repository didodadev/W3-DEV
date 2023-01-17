<table width="650" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
  <!-- sil -->
  <tr>
  	<td align="right">   
   	 <cf_workcube_file_action pdf='0' mail='0' doc='0' print='1'>    
	</td>
  </tr>
  <!-- sil -->
  <tr class="txtbold">
    <td style="text-align:right;"><cf_get_lang_main no='330.Tarih'>: <cfoutput>#dateformat(now(),dateformat_style)#</cfoutput><img title="" border="0" width="100" height="0"></td>
  </tr>
</table>
<!--- popup_list_train_joiners --->
<!---  --->
<cfinclude template="../query/get_class.cfm">
<cfset attributes.training_id = get_class.training_id>
<cfif LEN(get_class.start_date)>
  <cfset start_date = date_add('h', session.ep.time_zone, get_class.start_date)>
</cfif>
<cfif LEN(get_class.finish_date)>
  <cfset finish_date = date_add('h', session.ep.time_zone, get_class.finish_date)>
</cfif>

<table width="650" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
  <tr>
    <td class="headbold"><cf_get_lang_main no='7.Eğitim'>:&nbsp;<cfoutput>#get_class.class_name#</cfoutput></td>
  </tr>
</table>
<table width="650" border="0" align="center">
  <cfif get_class.online eq 1>
    <!--- get_class.INT_OR_EXT eq 1 OR  --->
    <tr>
      <td class="txtbold" width="165"><cf_get_lang no='29.Eğitim Şekli'></td>
      <td width="480">:
        <!--- <cfif get_class.INT_OR_EXT eq 1><cf_get_lang no='168.Dış Eğitim'>,</cfif> --->
        <cfif get_class.online eq 1>
          <cf_get_lang_main no='2218.online'>
        </cfif>
      </td>
    </tr>
  </cfif>
  <tr>
    <td class="txtbold" nowrap><cf_get_lang_main no='89.başlama'> - <cf_get_lang_main no='90.bitis'></td>
    <td>:
      <cfif LEN(get_class.finish_date)>
        <cfoutput>#dateformat(start_date,dateformat_style)# #timeformat(start_date,timeformat_style)#</cfoutput>
      </cfif>
      -
      <cfif LEN(get_class.finish_date)>
        <cfoutput> #dateformat(finish_date,dateformat_style)# #timeformat(finish_date,timeformat_style)#</cfoutput>
      </cfif>
    </td>
  </tr>
  <tr>
    <td class="txtbold" nowrap><cf_get_lang no='169.Toplam Gün'> - <cf_get_lang_main no='79.Saat'></td>
    <td>: <cfoutput>#get_class.DATE_NO# - #get_class.HOUR_NO#</cfoutput></td>
  </tr>
  <tr>
    <td class="txtbold" nowrap><cf_get_lang no='23.Eğitimci'></td>
    <td>: 
		<!--- <cfif len(get_class.TRAINER_EMP) AND (get_class.TRAINER_EMP NEQ 0)>
		  <cfquery name="get_emp_name" datasource="#dsn#">
			 SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #get_class.TRAINER_EMP#
		  </cfquery>
		  <cfoutput>#get_emp_name.EMPLOYEE_NAME# #get_emp_name.EMPLOYEE_SURNAME#</cfoutput>
	    <cfelseif len(get_class.TRAINER_PAR) AND (get_class.TRAINER_PAR NEQ 0)>
		  <cfquery name="get_par_name" datasource="#dsn#">
			SELECT COMPANY_PARTNER_NAME , COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID = #get_class.trainer_par#
		  </cfquery>
		  <cfoutput>#get_par_name.COMPANY_PARTNER_NAME# #get_par_name.COMPANY_PARTNER_SURNAME#</cfoutput>
		</cfif> --->
	</td>
  </tr>
  <tr>
    <td class="txtbold" nowrap><cf_get_lang no='35.Eğitim Yeri Sorumlusu'></td>
    <td>: <cfoutput>#get_class.CLASS_PLACE_MANAGER#</cfoutput> </td>
  </tr>
</table>

<!---  --->
<!--- <cfinclude template="view_class.cfm"> --->
<br/>
<table  width="650" cellspacing="0"  align="center" cellpadding="0">
  <tr>
    <td valign="top">
      <table cellSpacing="0" cellpadding="0" border="0" width="100%" align="center">
        <tr class="color-border">
          <td>
            <table cellspacing="1" cellpadding="2" width="100%" border="0" height="100%">
              <tr class="color-header" height="22">
                <td class="form-title"><cf_get_lang_main no='75.No'></td>
                <td class="form-title"><cf_get_lang_main no='158.Ad Soyad'></td>
                <td class="form-title"><cf_get_lang_main no='41.Şube'></td>
                <td class="form-title"><cf_get_lang_main no='161.Görev'></td>
                <td class="form-title"><cf_get_lang_main no='1545.İmza'></td>
              </tr>
              <cfquery name="get_emp_att" datasource="#dsn#">
				  SELECT 
					  EMP_ID,
					  PAR_ID,
					  CON_ID,
					  GRP_ID 
				  FROM 
					  TRAINING_CLASS_ATTENDER 
				  WHERE 
					  CLASS_ID=#attributes.CLASS_ID#
				  <!--- AND 
					  EMP_ID IS NOT NULL --->
              </cfquery>
              <cfset attributes.employee_ids=ValueList(get_emp_att.emp_id)>
              <cfset attributes.partner_ids=ValueList(get_emp_att.par_id)>
              <cfset attributes.consumer_ids=ValueList(get_emp_att.con_id)>
              <cfset attributes.group_ids=ValueList(get_emp_att.grp_id)>
			  <cfinclude template="../query/get_class_attenders.cfm">
              <cfif len(attributes.employee_ids) and get_class_attender.RECORDCOUNT>
                <cfoutput query="get_class_attender">
                  <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                    <td>#currentrow#</td>
                    <td>
						<!--- <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_detail_emp&emp_id=#emp_id#','project');" class="tableyazi">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a> --->
						<cfif type eq 'employee'>
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_detail_emp&emp_id=#get_class_attender.ids#','project');" class="tableyazi">#ad#&nbsp;#soyad#</a>
						<cfelseif type eq 'partner'>
						<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#get_class_attender.ids#','medium');" class="tableyazi">#ad#&nbsp;#soyad#</a>
						<cfelseif type eq 'consumer'>
						<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_class_attender.ids#','medium');" class="tableyazi">#ad#&nbsp;#soyad#</a>
						<cfelse>
						#ad#&nbsp;#soyad#
						</cfif>
					</td>
                    <td>#BRANCH_NAME#</td>
                    <td>#POSITION#</td>
                    <td></td>
                  </tr>
                </cfoutput>
                <cfelse>
                <tr class="color-list">
                  <td colspan="5"> <cf_get_lang_main no='72.Kayıt Bulunamadı'>! </td>
                </tr>
              </cfif>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<br/>

<table width="650" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
  <tr class="color-border">
    <td>
            <table cellspacing="1" cellpadding="2" width="100%" border="0" height="100%">
              <tr class="color-header" height="22">
                <td class="form-title" colspan="5">Mazeret İzni Alanlar</td>
              </tr>
              <tr class="color-header" height="22">
                <td class="form-title"><cf_get_lang_main no='75.No'></td>
                <td class="form-title"><cf_get_lang_main no='158.Ad Soyad'></td>
                <td class="form-title"><cf_get_lang_main no='41.Şube'></td>
                <td class="form-title"><cf_get_lang_main no='161.Görev'></td>
                <td class="form-title"><cf_get_lang_main no='1545.İmza'></td>
              </tr>
            </table>
	</td>
  </tr>
</table>

