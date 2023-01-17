<!--- Ana dosya --->
<cf_xml_page_edit fuseact="hr.form_upd_emp">
<cfif isDefined("x_employment_assets_pages")>
	<cfset attributes.x_employment_assets_pages_ = x_employment_assets_pages>
<cfelse>
	<cfset attributes.x_employment_assets_pages_ = 0>
</cfif>
<cfif not isnumeric(attributes.employee_id)>
	<cfset hata = 10>
	<cfinclude template="../../dsp_hata.cfm">
	<cfabort>
</cfif>
<cfset names="yes">
<cfset kontrol_branch = 1>
<cfinclude template="../query/get_hr.cfm"> 
<cfif get_hr.recordcount>
	<cfinclude template="../query/get_position_master.cfm">

	<cfinclude template="../../objects/display/imageprocess/imcontrol.cfm">
	<cfset session.resim=1>
	<cfset emp_id = employee_id>
	<cfquery name="get_test_time" datasource="#dsn#">
		SELECT TEST_TIME,TEST_DETAIL,CAUTION_TIME,CAUTION_EMP FROM EMPLOYEES_DETAIL WHERE EMPLOYEE_ID = #attributes.employee_id#
	</cfquery>

	<cfquery name="GET_REQS" datasource="#DSN#">
		SELECT * FROM EMPLOYEE_REQUIREMENTS WHERE EMPLOYEE_ID = #attributes.employee_id#
	</cfquery>

	<cfset salary_flag = 1>
	<cfif not SESSION.EP.EHESAP>
		<cfinclude template="../query/get_emp_branches.cfm">
	</cfif>
	<cfif not get_position.recordcount>
		<cfquery name="check_in_out" datasource="#dsn#" maxrows="1">
			SELECT BRANCH_ID FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = #attributes.employee_id# ORDER BY IN_OUT_ID DESC
		</cfquery>
		<cfif check_in_out.recordcount>
			<cfif (not session.ep.ehesap) and (not listFindNoCase(emp_branch_list,check_in_out.branch_id))>
				<cfset salary_flag = 0>
			</cfif>	
		<cfelse>
			<cfset salary_flag = 0>
		</cfif>
	</cfif>
	<cfset employee = GET_HR.employee_name & ' ' & GET_HR.employee_surname>
	<cfif not isDefined("attributes.isAjax")><!--- Organizasyon Yönetimi sayfasında gözükmemesi için --->
		<cf_catalystHeader>
			<div style="display:none;z-index:999;" id="history"></div>
			<div style="display:none;z-index:999;" id="emp_test_time"></div>
			<div style="display:none;z-index:999;" id="info"></div>
	</cfif> 
		<div <cfif isDefined("attributes.isAjax") and len(attributes.isAjax) eq 1> class="col col-12 col-xs-12 uniqueRow" <cfelse>  class="col col-9 col-xs-12 uniqueRow" </cfif>>
        	<!---Geniş alan: içerik---> 
            <cfinclude template="form_upd_emp_content.cfm">
        </div>
		<cfif not isDefined("attributes.isAjax")><!--- Organizasyon Yönetimi sayfasında gözükmemesi için --->
			<div class="col col-3 col-xs-12 uniqueRow">
				<!--- Yan kısım--->
				<cfinclude template="form_upd_emp_side.cfm">
			</div>
		</cfif>
		<script type="text/javascript">
			function open_tab(url,id) {
				document.getElementById(id).style.display ='';	
				document.getElementById(id).style.width ='500px';	
				$("#"+id).css('margin-left',$("#tabMenu").position().left);
				$("#"+id).css('margin-top',$("#tabMenu").position().top);
				$("#"+id).css('position','absolute');	
				
				AjaxPageLoad(url,id,1);
				return false;
			}
            function nakil_tarih_change()
            {
                document.getElementById('entry_date').value = date_add('d',1,document.getElementById('finish_date').value);
                var finishdate = document.getElementById('finish_date').value;
            }
			function is_check(deger)
            {
                if(deger == 18)
                {
                    document.cari.action = "";
                    gizle1.style.display = '';
                    gizle2.style.display = '';
                    gizle3.style.display = '';
                    gizle4.style.display = '';
                    gizle5.style.display = '';
                    gizle6.style.display = '';
                    gizle7.style.display = '';
                    gizle_kod_grubu.style.display = '';
                    document.cari.action = "<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_fire</cfoutput>";//nakil ise direk kayıt ekranına yönlendir
                }
                else 
                {
                    document.cari.action = "";
                    gizle1.style.display = 'none';
                    gizle2.style.display = 'none';
                    gizle3.style.display = 'none';
                    gizle4.style.display = 'none';
                    gizle5.style.display = 'none';
                    gizle6.style.display = 'none';
                    gizle7.style.display = 'none';
                    gizle_kod_grubu.style.display = 'none';
                    document.cari.action = "<cfoutput>#request.self#?fuseaction=ehesap.popup_form_fire2</cfoutput>";//nakil değil ise ücret işlemlerinin yapıldığı ekrana yönlendir
                }
            }
		</script>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='58943.Böyle Bir Kayıt Bulunmamaktadır'> !");
		history.back();
	</script>
</cfif>