<!--- cari hesap tipleri çoklu seçilsin parametresine göre yetki kontrolleri yapılıyor. Tüm modüllerde ortak kullanılıyor --->
<cfset hr_type_list = ''>
<cfset ehesap_type_list = ''>
<cfset other_type_list = ''>
<cfif not isdefined("arguments.module_power_user_hr")>
	<cfset module_power_user_hr = get_module_power_user(67)>
<cfelse>
	<cfset module_power_user_hr = arguments.module_power_user_hr>
</cfif>
<cfif not isdefined("arguments.module_power_user_ehesap")>
	<cfset module_power_user_ehesap = get_module_power_user(48)>
<cfelse>
	<cfset module_power_user_ehesap = arguments.module_power_user_ehesap>
</cfif>
<cfquery name="get_acc_types_" datasource="#dsn#">
	SELECT 
    	ISNULL(IS_EHESAP_USER,0) IS_EHESAP_USER,
        ISNULL(IS_HR_USER,0) IS_HR_USER,
        ACC_TYPE_ID 
    FROM 
    	SETUP_ACC_TYPE
    WHERE
    	ACC_TYPE_ID NOT IN(SELECT ACC_TYPE_ID FROM SETUP_ACC_TYPE_POSID)
    UNION ALL 
	SELECT 
    	ISNULL(IS_EHESAP_USER,0) IS_EHESAP_USER,
        ISNULL(IS_HR_USER,0) IS_HR_USER,
        ACC_TYPE_ID 
    FROM 
    	SETUP_ACC_TYPE SAT
    WHERE
    	ACC_TYPE_ID IN(SELECT ACC_TYPE_ID FROM SETUP_ACC_TYPE_POSID SP INNER JOIN EMPLOYEE_POSITIONS EP ON SP.POSITION_ID = EP.POSITION_ID WHERE POSITION_CODE = #session.ep.position_code#)
</cfquery>
<cfoutput query="get_acc_types_">
	<cfif is_hr_user eq 1>
		<cfset hr_type_list = listappend(hr_type_list,get_acc_types_.acc_type_id)>
	</cfif>
	<cfif is_ehesap_user eq 1>
		<cfset ehesap_type_list = listappend(ehesap_type_list,get_acc_types_.acc_type_id)>
	</cfif>
	<cfif is_hr_user eq 0 and is_ehesap_user eq 0>
		<cfset other_type_list = listappend(other_type_list,get_acc_types_.acc_type_id)>
	</cfif>
</cfoutput>
<cfif module_power_user_hr>
	<cfset kontrol_type = 0>
<cfelse>
	<cfset kontrol_type = 1>
</cfif>
<cfif module_power_user_ehesap>
	<cfset kontrol_type2 = 0>
<cfelse>
	<cfset kontrol_type2 = 1>
</cfif>
<!--- Yetkili pozisyon seçili olan cari hesap tiplerini görmemeli SG 20150407 ** query de düzenleme yapıldı PY 1019--->
<cfquery name="get_type_pos_control" datasource="#dsn#">
    SELECT 
        ACC_TYPE_ID 
    FROM 
		SETUP_ACC_TYPE SAT
    WHERE
        ACC_TYPE_ID IN(SELECT ACC_TYPE_ID FROM SETUP_ACC_TYPE_POSID SP INNER JOIN EMPLOYEE_POSITIONS EP ON SP.POSITION_ID = EP.POSITION_ID) AND <!--- yetkili pozisyon seçili olan hesap tipleri--->
        ACC_TYPE_ID NOT IN(SELECT ACC_TYPE_ID FROM SETUP_ACC_TYPE_POSID SP INNER JOIN EMPLOYEE_POSITIONS EP ON SP.POSITION_ID = EP.POSITION_ID WHERE POSITION_CODE = #session.ep.position_code#)<!--- çalışanın yetkili olarak ekli olduğu hesap tipleri hariç--->	
</cfquery>
<cfif not isdefined("ch_alias")><cfset ch_alias = ''></cfif>
<cfoutput>
	<cfsavecontent variable="control_acc_type_list">
		(
			<cfif len(hr_type_list) or len(ehesap_type_list)>
				(
					<cfif len(hr_type_list)>
						(
							<cfif module_power_user_hr>
								#ch_alias#ACC_TYPE_ID IN(#hr_type_list#)
							<cfelse>
								#ch_alias#ACC_TYPE_ID NOT IN(#hr_type_list#)
								<cfif len(valuelist(get_type_pos_control.acc_type_id))>    
								AND #ch_alias#ACC_TYPE_ID NOT IN(#valuelist(get_type_pos_control.acc_type_id)#)
                                </cfif>                         
							</cfif>
						)
					</cfif>
					<cfif isdefined("kontrol_type") and len(ehesap_type_list) and len(hr_type_list)>
						<cfif kontrol_type eq 0 and kontrol_type2 eq 0>OR<cfelse>AND</cfif>
					</cfif>
					<cfif len(ehesap_type_list)>
						(
							<cfif module_power_user_ehesap>
								#ch_alias#ACC_TYPE_ID IN(#ehesap_type_list#)
							<cfelse>
								#ch_alias#ACC_TYPE_ID NOT IN(#ehesap_type_list#)
								<cfif len(valuelist(get_type_pos_control.acc_type_id))>    
								AND #ch_alias#ACC_TYPE_ID NOT IN(#valuelist(get_type_pos_control.acc_type_id)#)
                                </cfif>                           
							</cfif>
						)
					</cfif>
				)
			</cfif>
			<cfif len(other_type_list) and (len(ehesap_type_list) or len(hr_type_list))>
				OR
			</cfif>
			<cfif len(other_type_list)>
				#ch_alias#ACC_TYPE_ID IN(#other_type_list#)
			</cfif>
			<cfif len(hr_type_list) or len(ehesap_type_list) or len(other_type_list)>
				<cfif ch_alias eq 'CH.'>
					<!---
						acc_type_id şimdiye kadar employee kayıtları için kullanılıyordu, artık company ve consumer için de kullanılıyor ancak bunlar konusunda bir yetkilendirme henüz geliştirilmedi.
						bu yüzden bu kayıtların gelebilmesi için bu kontrol eklendi. Çalışandaki gibi yetkilendirme yapıldığında, bu blok düzenlenmeli.
						Durgan20191014
					--->
					OR (#ch_alias#ACC_TYPE_ID IS NULL OR ISNULL(#ch_alias#FROM_EMPLOYEE_ID,#ch_alias#TO_EMPLOYEE_ID) IS NULL)
				<cfelse>
                	OR #ch_alias#ACC_TYPE_ID IS NULL
				</cfif>
			</cfif>
		)
	</cfsavecontent>
</cfoutput>