<cfscript>
	gun = dateformat(now(), 'dd');
	ay = dateformat(now(),'mm');
	yil = dateformat(now(),'yyyy');
	tarih = '#gun#/#ay#/#yil#';
	bugun = date_add('h', -session_base.time_zone, CreateODBCDatetime('#yil#-#ay#-#gun#'));
</cfscript>
<cfset METHODS = createObject('component','V16.objects2.cfc.widget.training')>
<cfset GET_CLASS = METHODS.GET_CLASS(START_DATE : bugun, maxrows:1, widget:"main_training",join:attributes.join)>
<cfif get_class.recordcount and attributes.main_training_theme eq 2>
<cfset start_date_ = date_add('h', session_base.time_zone, get_class.start_date)>
<cfset finish_date_ = date_add('h', session_base.time_zone, get_class.finish_date)>
<cfoutput>
	<div class="slide padding" style="position: relative; margin: 0px -60px;">
		<div class="text">
			<h1>#get_class.class_name#</h1>
			<h4>#dateformat(start_date_,'dd/mm/yyyy')# #timeformat(start_date_,'HH:MM')# - #dateformat(finish_date_,'dd/mm/yyyy')# #timeformat(finish_date_,'HH:MM')#</h4>
			<cfif attributes.join eq 1>
				<a href="##join" data-class_id="#GET_CLASS.CLASS_ID#">
					<span>HEMEN KATILIN</span>
					<i></i>
				</a>
			<cfelse>
				<a href="#GET_CLASS.TRAINING_LINK#">
					<span>HEMEN KATILIN</span>
					<i></i>
				</a>
			</cfif>
		</div>
	</div>
</cfoutput>
</cfif>
<cfif get_class.recordcount and attributes.main_training_theme eq 1>
	<cfoutput query="get_class">
        <cfquery name="GET_TRAINING_CAT_NAME" datasource="#DSN#">
            SELECT TRAINING_CAT FROM TRAINING_CAT WHERE TRAINING_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_class.training_cat_id#">
        </cfquery>
        <cfquery name="GET_SEC_NAME" datasource="#DSN#">
            SELECT SECTION_NAME FROM TRAINING_SEC WHERE TRAINING_SEC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_class.training_sec_id#">
        </cfquery>
        <cfquery name="GET_SEC_NAME_ATTENDER" datasource="#DSN#">
            SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER WHERE CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_class.class_id#"> 
        </cfquery>
        <cfif len(get_class.trainer_emp) and (get_class.trainer_emp neq 0)>
            <cfquery name="GET_EMP_NAME" datasource="#DSN#">
                SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_class.trainer_emp#">
            </cfquery>
        <cfelseif len(get_class.trainer_par) and (get_class.trainer_par neq 0)>
            <cfquery name="GET_PAR_NAME" datasource="#DSN#">
                SELECT COMPANY_PARTNER_NAME , COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_class.trainer_par#">  
            </cfquery>
        <cfelseif len(get_class.trainer_cons) and (get_class.trainer_cons neq 0)>
            <cfquery name="GET_CONS_NAME" datasource="#DSN#">
                SELECT CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#get_class.trainer_cons#">
            </cfquery>
        </cfif>
       	<table align="center" style="width:98%">
			<tr>
				<td class="training_main_name" title="#get_class.class_name#">#get_class.class_name#</td>
			</tr>
			<tr>
				<td>
					<cfset start_date_ = date_add('h', session_base.time_zone, get_class.start_date)>
					<cfset finish_date_ = date_add('h', session_base.time_zone, get_class.finish_date)>
					#dateformat(start_date_,'dd/mm/yyyy')# #timeformat(start_date_,'HH:MM')# - #dateformat(finish_date_,'dd/mm/yyyy')# #timeformat(finish_date_,'HH:MM')#
				</td>
			</tr>
			<tr>
				<td><a href="javascript://" onClick="gizle_goster(training_detay_#class_id#);" title="<cf_get_lang no='5.Detaylar'>">>> <cf_get_lang no='5.Detaylar'></a></td>
			</tr>
		</table>
		<table align="center" id="training_detay_#class_id#" style="display:none;width:98%">
			<tr>
				<td>#get_training_cat_name.training_cat#&nbsp;/&nbsp;#get_sec_name.section_name#</td>
			</tr>
			<tr>
				<td>#get_class.class_target#</td>
			</tr>
			<tr>
				<td><cf_get_lang no='897.Yer'> : #get_class.class_place#</td>
			</tr>
			<tr>
				<td><cf_get_lang no='950.Eğitimci'> :
				<cfif len(get_class.trainer_emp)>
					#get_emp_name.employee_name# #get_emp_name.employee_surname#
				<cfelseif len(get_class.trainer_par)>
					#get_par_name.company_partner_name# #get_par_name.company_partner_surname#
				<cfelseif len(get_class.trainer_cons)>
					#get_cons_name.consumer_name# #get_cons_name.consumer_surname#
				</cfif>
				</td>
			</tr>
		</table>
    </cfoutput>
</cfif>