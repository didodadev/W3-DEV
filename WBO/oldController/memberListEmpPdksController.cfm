<cfset is_member = 1>
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cf_xml_page_edit fuseact="hr.list_emp_pdks">
    <cf_get_lang_set module_name="hr">
    <cfif isdefined("attributes.partner_id") and len(attributes.partner_id) and fusebox.circuit is 'member'>
        <cfquery name="get_partner_info" datasource="#dsn#">
            SELECT COMPANY_PARTNER_NAME,COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID = #attributes.partner_id#
        </cfquery>
    </cfif>
    <cfinclude template="../hr/query/get_position_cats2.cfm">
    <cfquery name="get_pdks_types" datasource="#dsn#">
        SELECT PDKS_TYPE_ID,PDKS_TYPE FROM SETUP_PDKS_TYPES
    </cfquery>
    <cfinclude template="../hr/query/get_emp_codes.cfm">
    <cfset ay_list = "Ocak,Şubat,Mart,Nisan,Mayıs,Haziran,Temmuz,Ağustos,Eylül,Ekim,Kasım,Aralık">
    <cfparam name="attributes.keyword" default="">
    <cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
        <cf_date tarih = "attributes.startdate">
    <cfelse>
        <cfset attributes.startdate = now()>
    </cfif>
    <cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
        <cf_date tarih = "attributes.finishdate">
    <cfelse>
        <cfset attributes.finishdate = attributes.startdate>
    </cfif>
    <cfparam name="attributes.position_cat_id" default="">
    <cfif isdefined("attributes.form_submit")>
		<cfquery name="get_daily_in_out" datasource="#dsn#">
			SELECT
				C.PARTNER_ID AS EMPLOYEE_ID,
				C.COMPANY_PARTNER_NAME,
				C.COMPANY_PARTNER_SURNAME
			FROM
				COMPANY_PARTNER C
			WHERE
				C.PARTNER_ID IN (SELECT PARTNER_ID FROM EMPLOYEE_DAILY_IN_OUT) AND
				C.PARTNER_ID IS NOT NULL 
			<cfif isdefined("attributes.partner_name") and len(attributes.partner_name) and len(attributes.partner_id)>
				AND C.PARTNER_ID=#attributes.partner_id#
			</cfif>
			<cfif len(attributes.keyword)>
				AND ((C.COMPANY_PARTNER_NAME + ' ' + C.COMPANY_PARTNER_SURNAME) LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%' )
			</cfif>
			<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
				AND C.COMPANY_ID = #attributes.company_id#
			</cfif>
			ORDER BY
				C.COMPANY_PARTNER_NAME,
				C.COMPANY_PARTNER_SURNAME
		</cfquery>
    <cfelse>
		<cfset get_daily_in_out.recordcount=0>
    </cfif>
    <cfparam name="attributes.branch_id" default="">
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default='#get_daily_in_out.recordcount#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfif get_daily_in_out.recordcount>
        <cfset main_employee_list = ''>				
        <cfoutput query="get_daily_in_out" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <cfset main_employee_list = listappend(main_employee_list,get_daily_in_out.employee_id,',')>
        </cfoutput>	
        <cfset main_employee_list=listsort(main_employee_list,"numeric","ASC",",")>	
        <cfquery name="get_in_outs" datasource="#dsn#">
			SELECT
				C.PARTNER_ID,
				ED.IN_OUT_ID,
				ED.ROW_ID,
				ED.FILE_ID,
				C.COMPANY_PARTNER_NAME,
				C.COMPANY_PARTNER_SURNAME,
				ED.BRANCH_ID,
				ED.IS_WEEK_REST_DAY,
				ED.START_DATE,
				ED.FINISH_DATE,
				'' AS BRANCH_NAME
			FROM
				EMPLOYEE_DAILY_IN_OUT ED,
				COMPANY_PARTNER C
			WHERE 
				C.PARTNER_ID IN (#main_employee_list#) AND
				ED.PARTNER_ID=C.PARTNER_ID 
			<cfif len(attributes.startdate)>
				AND
				((ED.START_DATE >= #attributes.startdate# AND ED.START_DATE < #DATEADD("d",1,attributes.finishdate)#) OR ED.START_DATE IS NULL)
				AND
				((ED.FINISH_DATE >= #attributes.startdate# AND ED.FINISH_DATE < #DATEADD("d",1,attributes.finishdate)#) OR ED.FINISH_DATE IS NULL)
			</cfif>		
			ORDER BY
				ED.FILE_ID,
				C.COMPANY_PARTNER_NAME,
				C.COMPANY_PARTNER_SURNAME
		</cfquery>
   	</cfif>
    <cfif isdefined("attributes.form_submit")> 	
		<cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
            <cfset url_string = ''>
            <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
                <cfset url_string = '#url_string#&branch_id=#attributes.branch_id#'>
            </cfif>
            <cfif isdefined("attributes.startdate") and len(attributes.startdate)>
                <cfset url_string = '#url_string#&startdate=#dateformat(attributes.startdate,'dd/mm/yyyy')#'>
            </cfif>
            <cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
                <cfset url_string = '#url_string#&finishdate=#dateformat(attributes.finishdate,'dd/mm/yyyy')#'>
            </cfif>
            <cfif isdefined("attributes.employee_id") and len(attributes.employee_name)>
                <cfset url_string = '#url_string#&employee_name=#attributes.employee_name#&employee_id=#attributes.employee_id#'>
            </cfif>
            <cfif isdefined("attributes.partner_id") and len(attributes.partner_name)>
                <cfset url_string = '#url_string#&partner_name=#attributes.partner_name#&partner_id=#attributes.partner_id#'>
            </cfif>
            <cfif isdefined("attributes.form_submit") and len(attributes.form_submit)>
                <cfset url_string = '#url_string#&form_submit=1'>
            </cfif>
            <cfif isdefined("attributes.hierarchy") and len(attributes.hierarchy)>
                <cfset url_string = '#url_string#&hierarchy=#attributes.hierarchy#'>
            </cfif>
            <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
                <cfset url_string = '#url_string#&keyword=#attributes.keyword#'>
            </cfif>
            <cfif isdefined("attributes.pdks_type_id") and len(attributes.pdks_type_id)>
                <cfset url_string = '#url_string#&pdks_type_id=#attributes.pdks_type_id#'>
            </cfif>
            <cfif isdefined("attributes.position_cat_id") and len(attributes.position_cat_id)>
                <cfset url_string = '#url_string#&position_cat_id=#attributes.position_cat_id#'>
            </cfif>
       	</cfif>
  	</cfif>
</cfif>
<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$( document ).ready(function() {
			document.getElementById('keyword').focus();	
		});			
		document.getElementById('keyword').focus();
		function send_all_pdks()
			{
				if(findObj('pdks_emp_list'))
					{
						if(document.getElementsByName('pdks_emp_list').length != undefined && document.getElementsByName('pdks_emp_list').length != 1) /* n tane*/
							{
								emp_list = '';
								emp_count = 0;
								son_tarih_ = '';
								for (i=0; i < document.getElementsByName('pdks_emp_list').length; i++)
									{
										if(emp_count > 999)
											{
											alert("<cf_get_lang no='583.Aynı Anda En Fazla 1000 Kişiye Uyari Gönderebilirsiniz'>!");
											return false;
											}
										if((document.all.pdks_emp_list[i].checked==true))
										{
											var tarih_ = list_getat(document.all.pdks_emp_list[i].value,2,';');
											var kisi_ = list_getat(document.all.pdks_emp_list[i].value,1,';');
											if(son_tarih_!='' && tarih_ != son_tarih_)
												{
												alert("<cf_get_lang no='584.Farklı Günlere Toplu Uyarı Gönderemezsiniz'>!");
												return false;
												}
											else
												{
												son_tarih_ = tarih_;
												if(emp_count==0)
													{
													emp_list = kisi_;
													}
												else
													{
													emp_list = emp_list + ',' + kisi_;
													}
												}
											var emp_count = emp_count + 1;
										}								
									}
								if(emp_count > 0)
								{
									document.getElementById('employee_id_list').value = emp_list;
									document.getElementById('aktif_gun').value = son_tarih_;
								}
								else
								{
									alert("<cf_get_lang no='586.Mail Listesi Oluşturmalısınız'>!");
									return false;
								}
							}
						else
							{
								if((document.getElementById('pdks_emp_list').checked==true))
									{
										var tarih_ = list_getat(document.getElementById('pdks_emp_list').value,2,';');
										var kisi_ = list_getat(document.getElementById('pdks_emp_list').value,1,';');
										document.getElementById('employee_id_list').value = kisi_;
										document.getElementById('aktif_gun').value = tarih_;
									}
								else
									{
										alert("<cf_get_lang no='586.Mail Listesi Oluşturmalısınız'>!");
										return false;
									}
							}
					}
				else
					{
					alert("<cf_get_lang no='586.Mail Listesi Oluşturmalısınız'>!");
					return false;
					}
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_send_pdks_mails&aktif_gun=' + document.getElementById('aktif_gun').value + '&employee_id_list=' + document.getElementById('employee_id_list').value ,'small');			
			}
			
			function check_all_pdks()
			{
				if(findObj('pdks_emp_list'))
					{
						if(document.getElementsByName('pdks_emp_list').length != undefined && document.getElementsByName('pdks_emp_list').length != 1) /* n tane*/
							{
								for (i=0; i < document.getElementsByName('pdks_emp_list').length; i++)
									{
										if((document.all.pdks_emp_list[i].checked==true))
											document.all.pdks_emp_list[i].checked=false;
										else
											document.all.pdks_emp_list[i].checked=true;
									}
							}
						else
							{
								if((document.getElementById('pdks_emp_list').checked==true))
									document.getElementById('pdks_emp_list').checked=false;
								else
									document.getElementById('pdks_emp_list').checked=true;
							}
					}
			}
	</cfif>
</script>

<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'member.list_emp_pdks';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/list_emp_pdks.cfm';
</cfscript>