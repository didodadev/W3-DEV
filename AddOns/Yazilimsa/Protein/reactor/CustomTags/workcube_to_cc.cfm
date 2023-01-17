<!--- 
	-------------------
			Update sayfalarında ilk secilen kisiden sonra silinecek kisiden, sonraki kisinin silinmesi olayı duzeltildi 20071210 BK
			cc2 adinda ucuncu deger eklenmistir FB 20070606
		Son Degisiklikler:Eger acilan popup sayfasi sirasi onemli ise:
			1:employee
			2:kurumsal uye
			3:Bireysel Uye
			Eger Employee ilk acilacak sayfa ise str_paramlist asagidaki gibi tanimlanir custom tag icinde.
			(Hangi sayfa once gelicekse sirayla yukaridakilere uygun gelen sekilde param liste yazilir.)
			str_list_param="1,2,3"
			select_list = "" Popup Turlerinin Belirlenmesi icin Select_list eklendi, zorunlu degil, gonderilmezse str_list_param dikkate alinir FBS 20110331
	----------------------	
	09012004 :
	
	Bu custom tag cagirildigi sayfaya bazi input degerleri gonderir.
	Bu input degerleri gittigi sayfadaki form submit edildikten sonra action tarafinda degerlendirilir ve ilgili tablolara 
	ilgili alanlari gondermemizi saglar.
	Parameters:
 
	to_dsp_name: Selection Title (Yetkili Pozisyonlar)
	cc_dsp_name: Selection Title For CC (Bilgi Verilecekler)
	cc2_dsp_name: Selection Title For CC2 (Onay Ve Uyarılacaklar)
	to_emp_ids : Hidden Value for employee identity numbers
	to_cons_ids : Hidden Value for consumer identity numbers
	to_par_ids : Hidden Value for partner identity numbers
	to_comp_ids : Hidden Value for company identity number
	to_pos_ids : Hidden Value for employeer position identity numbers
	to_grp_ids : Hidden Value for group identity numbers 
	to_wgrp_ids : Hidden Value for workgroup identity numbers
	cc_emp_ids : Hidden Value for employee identity numbers
	cc_cons_ids : Hidden Value for consumer identity numbers
	cc_par_ids : Hidden Value for partner identity numbers
	cc_comp_ids : Hidden Value for company identity number
	cc_pos_ids : Hidden Value for employeer position identity numbers
	cc_grp_ids : Hidden Value for group identity numbers 
	cc_wgrp_ids : Hidden Value for workgroup identity numbers	
	cc2_emp_ids : Hidden Value for employee identity numbers
	cc2_cons_ids : Hidden Value for consumer identity numbers
	cc2_par_ids : Hidden Value for partner identity numbers
	cc2_comp_ids : Hidden Value for company identity number
	cc2_pos_ids : Hidden Value for employeer position identity numbers
	cc2_grp_ids : Hidden Value for group identity numbers 
	cc2_wgrp_ids : Hidden Value for workgroup identity numbers	
	is_update: whether operation  is update or add
	action_id : operation action id if add operation this value equal to 0
	action_table : operation_table
	action_dsn: operation datasource name
	action_id_name: column name using for Where clause 
	form_name : document form name
	from_purchase_offer : satınalma teklif detayındaki teklif istenen alanına print ve teklif ekle iconu eklendi 
	our_comp_id : session company id
	Alan isimleri :
	(str_action_names)
	TO_POS (POSITION_ID),
	TO_POS_CODE (POSITION_CODE),
	TO_EMP,
	TO_COMP,
	TO_PAR,
	TO_CON,
	TO_GRP,
	TO_WRKGROUP,
	CC_POS,
	CC_EMP,
	CC_COMP,
	CC_PAR,
	CC_CON,
	CC_GRP,
	CC_WRKGROUP,
	CC2_POS,
	CC2_EMP,
	CC2_COMP,
	CC2_PAR,
	CC2_CON,
	CC2_GRP,
	CC2_WRKGROUP,
	
	to_title : Eklenen sayfaya yazilacak olan yazi 1: employee name 2 pozisyon partner 1: partner 2 company consomuer defult 1
	cc_title: Eklenen sayfaya yazilacak olan yazi 2: employee name 2 pozisyon partner 1: partner 2 company consomuer defult 1
	cc2_title: Eklenen sayfaya yazilacak olan yazi 3: employee name 2 pozisyon partner 1: partner 2 company consomuer defult 1

	data_type=1 virgullu 2 ise valuelist alinacak.
	Eger data_type eq 2 ise str_alias_names adli bir attribute de olur.	
	For example:
		<cf_workcube_to_cc 
			is_update="1" 
			to_dsp_name="Katilimcilar" 
			cc_dsp_name="Bilgi Verilecekler" 
			cc2_dsp_name="Onay ve Uyarılacaklar"
			form_name="my_form" 
			str_list_param="1,2,3" 
			action_dsn="#DSN#"
			str_action_names="EVENT_TO_POS AS TO_EMP,EVENT_TO_PAR AS TO_PAR"
			action_table="EVENT"
			action_id_name="EVENT_ID"
			action_id="39"
		>	
	 1:employee 2:partner 3:consumer 
	--->

    <!--- 
	Düzenleme 28 01 2009 M.ER
	Eğerki TO_COMP alanı gönderilmiş ve TO_PAR alanı gönderilmemiş ise,sadece Şirketler Listeleniyor...
	
	15.11.2019 Gramoni-Mahmut
	Borsa İstanbul için to_title değeri 3 gönderildiğinde yalnızca üye nickname görüntülenmesi sağlandı.
	
	opener_control eklendi bazi popup acilan yerlere , geldigi sayfadaki fonksiyon calistirilabilir fbs 20120508
	 --->
<cfparam name="attributes.print_all" default="1" /> <!---SatınAlma Teklifinde 'Teklif İstenenlerde' alanındaki printler için sadece ilgili teklifin printinin gelmesi için eklenmiştir. 31072014 FK--->
<cfset main_str_url = "">
<cfset main_str_url_cc = "">
<cfset main_str_url_cc2 = "">
<cfif not isdefined("attributes.to_title")><cfset attributes.to_title = 1></cfif>
<cfif not isdefined("attributes.cc_title")><cfset attributes.cc_title = 1></cfif>
<cfif not isdefined("attributes.cc2_title")><cfset attributes.cc2_title = 1></cfif>

<cfset main_str_url = "&field_emp_id=to_emp_ids&field_pos_id=to_pos_ids&field_pos_code=to_pos_codes&field_par_id=to_par_ids&field_company_id=to_comp_ids&field_cons_id=to_cons_ids">
<cfset main_str_url_cc = "&field_emp_id=cc_emp_ids&field_pos_id=cc_pos_ids&field_pos_code=cc_pos_codes&field_par_id=cc_par_ids&field_company_id=cc_comp_ids&field_cons_id=cc_cons_ids">
<cfset main_str_url_cc2 = "&field_emp_id=cc2_emp_ids&field_pos_id=cc2_pos_ids&field_pos_code=cc2_pos_codes&field_par_id=cc2_par_ids&field_company_id=cc2_comp_ids&field_cons_id=cc2_cons_ids">

<cfset main_prm_list_ct = attributes.str_list_param>
<cfsavecontent  variable="boxTitle"><cf_get_lang dictionary_id='56690.Kişiler'></cfsavecontent>
<cfloop index="klm" from="#listlen(attributes.str_list_param,",")#" to="1"  step="-1">
	<cfset int_ct_index=listgetat(attributes.str_list_param,klm,",")>
	<cfswitch expression="#int_ct_index#">
		<cfcase value="1">
			<cfif listfind(attributes.str_list_param,1)>
				<cfif isdefined('session.pp.userid') or isdefined('session.pda.userid')>
					<cfset str_link_fuse = "objects2.popup_list_positions_multiuser">
				<cfelse>
 					<cfset str_link_fuse = "objects.popup_list_positions_multiuser">
				</cfif>
			</cfif>
			<cfset type_of_custag_input =1>
		</cfcase>
		<cfcase value="2">
			<cfif isdefined('session.pp.userid') or isdefined('session.pda.userid')>
                <cfset str_link_fuse = "objects2.popup_list_pars_multiuser">
            <cfelse>
                <cfset str_link_fuse = "objects.popup_list_pars_multiuser">
            </cfif>
			<cfset type_of_custag_input =2>
		</cfcase>
		<cfcase value="3">
			<cfset str_link_fuse = "objects.popup_list_cons_multiuser">		
			<cfset type_of_custag_input =2>
		</cfcase>
		<cfcase value="10">
			<cfset str_link_fuse = "objects2.popup_list_my_pars">
			<cfset type_of_custag_input =2>
		</cfcase>
	</cfswitch>
</cfloop>
<cfif isDefined("attributes.select_list") and Len(attributes.select_list)>
	<cfset select_list = attributes.select_list>
<cfelse>
	<cfset select_list = attributes.str_list_param>
</cfif>
<cfset cus_tag_max_row_to = 0>
<cfset cus_tag_max_row_cc = 0>
<cfset cus_tag_max_row_cc2 = 0>	
<cfset main_str_url = "#main_str_url#&to_title=#attributes.to_title#">
<cfset main_str_url_cc = "#main_str_url_cc#&to_title=#attributes.cc_title#">
<cfset main_str_url_cc2 = "#main_str_url_cc2#&to_title=#attributes.cc2_title#">
<cfset int_colspan = 0>
<input type="hidden" name="rows" id="rows" value="0">

<cfif isdefined("attributes.form_name") eq "upd_event" or isdefined("attributes.form_name") eq "add_event"> 
<cfif attributes.is_update eq 0>
	<div class="workDevList col col-12 col-xs-12"><!---class="to_cc"--->
		<div class="col col-12 col-xs-12" style="border:1px solid #b3aeae; padding:3%;">
			<cfif isdefined("attributes.to_dsp_name")>
				<div class="col col-6 col-xs-6" style="border-bottom:1px solid #b3aeae;padding-bottom:1%;">
					<a href="javascript://" class="none-decoration" onclick="try{opener_control();}catch(e){};openBoxDraggable('widgetloader?widget_load=listMultiUsers&style=maxi&isbox=1<cfoutput>&title=#boxTitle##main_str_url#&select_list=#select_list#&row_count=tbl_to_names_row_count&table_name=tbl_to_names&table_row_name=workcube_to_row&field_grp_id=to_grp_ids&field_wgrp_id=to_wgrp_ids&function_row_name=workcube_to_delRow</cfoutput>&comp_id_list='+document.getElementById('comp_id_list').value);">
                    <i class="fa fa-plus"></i></a>
					<cfoutput>#attributes.to_dsp_name#</cfoutput>
					<input type="hidden" name="comp_id_list" id="comp_id_list" value=""/>
					<input type="hidden" name="tbl_to_names_row_count" id="tbl_to_names_row_count" value="0">
				</div>
			</cfif>
			<cfif isdefined("attributes.cc_dsp_name")>
				<div class="col col-6 col-xs-6" style="border-bottom:1px solid #b3aeae;padding-bottom:1%;">
					<a href="javascript://" class="none-decoration" onclick="openBoxDraggable('widgetloader?widget_load=listMultiUsers&style=maxi&isbox=1<cfoutput>&title=#boxTitle##main_str_url_cc#&table_name=tbl_cc_names&row_count=tbl_cc_names_row_count&select_list=#select_list#&table_row_name=workcube_cc_row&field_grp_id=cc_grp_ids&field_wgrp_id=cc_wgrp_ids&function_row_name=workcube_cc_delRow</cfoutput>');">
					<i class="fa fa-plus"></i></a>
					<cfoutput>#attributes.cc_dsp_name#</cfoutput>
					<input type="hidden" name="tbl_cc_names_row_count" id="tbl_cc_names_row_count" value="0">
				</div>
			</cfif>
			<cfif isdefined("attributes.cc2_dsp_name")>
				<div style="border-bottom:1px solid #b3aeae;padding-bottom:1%;">
					<a href="javascript://" onclick="openBoxDraggable('widgetloader?widget_load=listMultiUsers&style=maxi&isbox=1<cfoutput>&title=#boxTitle##main_str_url_cc2#&table_name=tbl_cc2_names&row_count=tbl_cc2_names_row_count&select_list=#select_list#&table_row_name=workcube_cc2_row&field_grp_id=cc2_grp_ids&field_wgrp_id=cc2_wgrp_ids&function_row_name=workcube_cc2_delRow</cfoutput>');">
					<i class="fa fa-plus"></i></a>
					<cfoutput>#attributes.cc2_dsp_name#</cfoutput>
					<input type="hidden" name="tbl_cc2_names_row_count" id="tbl_cc2_names_row_count" value="0">
				</div>
			</cfif>
		
		<div class="col col-12 col-xs-12" valign="top">
			<cfif isdefined("attributes.to_dsp_name")>			
				<div class="col col-6 col-xs-6">
					<table id="tbl_to_names"><div class="col col-12 col-xs-12"></div></table>						
				</div>
			</cfif>
			<cfif isdefined("attributes.cc_dsp_name")>
				<div class="col col-6 col-xs-6">
					<table id="tbl_cc_names"><div class="col col-12 col-xs-12"></div></table>					
				</div>				
			</cfif>
			<cfif isdefined("attributes.cc2_dsp_name")>
				<div class="col col-12 col-xs-12">
					<table id="tbl_cc2_names"><div class="col col-12 col-xs-12"></div></table>				
				</div>				
			</cfif>	
		</div>
	</div>
	</div>
<cfelse>
	<cfquery name="GET_VALUES" datasource="#attributes.action_dsn#">
		SELECT 
			#attributes.str_action_names#
		FROM 
			#attributes.action_table# 
		WHERE 
			#attributes.action_id_name# = #attributes.action_id#
            <cfif isdefined('attributes.our_comp_id')>
            	AND OUR_COMPANY_ID = #attributes.our_comp_id#
            </cfif>
	</cfquery>
    <div class="workDevList col col-12 col-xs-12">
		<div class="col col-12 col-xs-12" style="border:1px solid #b3aeae; padding:3%;">
			<cfif isdefined("attributes.to_dsp_name")>
				<div class="col col-6 col-xs-6" style="border-bottom:1px solid #b3aeae;padding-bottom:1%;">
					<input type="hidden" name="comp_id_list" id="comp_id_list" value="" />
					<a href="javascript://" class="none-decoration" onclick="try{opener_control();}catch(e){};openBoxDraggable('widgetloader?widget_load=listMultiUsers&style=maxi&isbox=1<cfoutput>&title=#boxTitle##main_str_url#&select_list=#select_list#&row_count=tbl_to_names_row_count&table_name=tbl_to_names&table_row_name=workcube_to_row&field_grp_id=to_grp_ids&field_wgrp_id=to_wgrp_ids&function_row_name=workcube_to_delRow</cfoutput>&comp_id_list='+document.getElementById('comp_id_list').value);">
					<i class="fa fa-plus"></i></a>
					<cfoutput>#attributes.to_dsp_name#</cfoutput>
				</div>					
			</cfif>
			<cfif isdefined("attributes.cc_dsp_name")>
				<div class="col col-6 col-xs-6" style="border-bottom:1px solid #b3aeae;padding-bottom:1%;">
					<a href="javascript://" class="none-decoration" onclick="openBoxDraggable('widgetloader?widget_load=listMultiUsers&style=maxi&isbox=1<cfoutput>&title=#boxTitle##main_str_url_cc#&table_name=tbl_cc_names&row_count=tbl_cc_names_row_count&select_list=#select_list#&table_row_name=workcube_cc_row&field_grp_id=cc_grp_ids&field_wgrp_id=cc_wgrp_ids&function_row_name=workcube_cc_delRow</cfoutput>');">
					<i class="fa fa-plus"></i></a>
					<cfoutput>#attributes.cc_dsp_name#</cfoutput>
				</div>					
			</cfif>
			<cfif isdefined("attributes.cc2_dsp_name")>
				<div class="col col-6 col-xs-6" style="border-bottom:1px solid #b3aeae;padding-bottom:1%;">
					<a href="javascript://" onclick="openBoxDraggable('widgetloader?widget_load=listMultiUsers&style=maxi&isbox=1<cfoutput>&title=#boxTitle##main_str_url_cc2#&table_name=tbl_cc2_names&row_count=tbl_cc2_names_row_count&select_list=#select_list#&table_row_name=workcube_cc2_row&field_grp_id=cc2_grp_ids&field_wgrp_id=cc2_wgrp_ids&function_row_name=workcube_cc2_delRow</cfoutput>');">
					<i class="fa fa-plus"></i></a>
					<cfoutput>#attributes.cc2_dsp_name#</cfoutput>
				</div>					
			</cfif>				
		

		<div class="col col-12 col-xs-12">
		<cfif isdefined("attributes.to_dsp_name")>			
			<div class="col col-6 col-xs-6">
				<cfset to_list = "">
				<cfif isdefined("get_values.to_emp")>
					<cfif attributes.data_type eq 1>
						<cfset int_emp_list = ListSort(get_values.to_emp,"textnocase")>
					<cfelseif attributes.data_type eq 2>
						<cfset int_emp_list = ListSort(ValueList(get_values.to_emp),"numeric","asc")>
					</cfif>
				<cfelse>
					<cfset int_emp_list="">
				</cfif>
				<cfif isdefined("get_values.to_pos")>
					<cfif attributes.data_type eq 1>
						<cfset int_pos_list=ListSort(get_values.to_pos,"textnocase")>
					<cfelseif attributes.data_type eq 2>
						<cfset int_pos_list=ListSort(ValueList(get_values.to_pos),"numeric","asc")>
					</cfif>
				<cfelse>
					<cfset int_pos_list="">
				</cfif>
				<cfif isdefined("get_values.to_pos_code")>
					<cfif attributes.data_type eq 1>
						<cfset int_poscode_list = ListSort(get_values.to_pos_code,"textnocase")>
					<cfelseif attributes.data_type eq 2>
						<cfset int_poscode_list = ListSort(ValueList(get_values.to_pos_code),"numeric","asc")>
					</cfif>
				<cfelse>
					<cfset int_poscode_list="">
				</cfif>
				<cfif isdefined("get_values.to_par")>
					<cfif attributes.data_type eq 1>
						<cfset int_par_list = ListSort(get_values.to_par,"textnocase")>
					<cfelseif attributes.data_type eq 2>
						<cfset int_par_list = ListSort(ValueList(get_values.to_par),"numeric","asc")>
					</cfif>
				<cfelse>
					<cfset int_par_list="">
				</cfif>
				
				<cfif isdefined("get_values.to_comp")>
					<cfif attributes.data_type eq 1>
						<cfset int_comp_list = ListSort(get_values.to_comp,"textnocase")>
					<cfelseif attributes.data_type eq 2>
						<cfset int_comp_list = ListSort(ValueList(get_values.to_comp),"numeric","asc")>
					</cfif>									
				<cfelse>
					<cfset int_comp_list="">
				</cfif>
				<cfif isdefined("get_values.to_con")>
					<cfif attributes.data_type eq 1>
						<cfset int_con_list = ListSort(get_values.to_con,"textnocase")>
					<cfelseif attributes.data_type eq 2>
						<cfset int_con_list = ListSort(ValueList(get_values.to_con),"numeric","asc")>
					</cfif>									
				<cfelse>
					<cfset int_con_list="">
				</cfif>
				<cfif isdefined("get_values.to_group")>
					<cfif attributes.data_type eq 1>
						<cfset int_grp_list = ListSort(get_values.to_group,"textnocase")>
					<cfelseif attributes.data_type eq 2>
						<cfset int_grp_list = ListSort(ValueList(get_values.to_group),"numeric","asc")>
					</cfif>									
				<cfelse>
					<cfset int_grp_list="">
				</cfif>
				<cfif isdefined("get_values.to_wrkgroup")>
					<cfif attributes.data_type eq 1>
						<cfset int_wgrp_list = ListSort(get_values.to_wrkgroup,"textnocase")>
					<cfelseif attributes.data_type eq 2>
						<cfset int_wgrp_list = ListSort(ValueList(get_values.to_wrkgroup),"numeric","asc")>
					</cfif>									
				<cfelse>
					<cfset int_wgrp_list="">
				</cfif>
				<cfif listlen(int_emp_list) or listlen(int_pos_list) or listlen(int_poscode_list)>
					<cfquery name="GET_EMP_LIST" datasource="#CALLER.DSN#">
						SELECT 
						<cfif attributes.to_title eq 1>
							EMPLOYEES.EMPLOYEE_NAME NAME,
							EMPLOYEES.EMPLOYEE_SURNAME SURNAME,
							EMPLOYEE_POSITIONS.POSITION_NAME TITLE,
						<cfelse>
							EMPLOYEE_POSITIONS.POSITION_NAME NAME,
							'' SURNAME,
							'' TITLE,
						</cfif>
							1 ORDER_ID,
							EMPLOYEES.EMPLOYEE_ID ID_1,
							EMPLOYEE_POSITIONS.POSITION_ID ID_2,
							EMPLOYEE_POSITIONS.POSITION_CODE ID_3,
							-1 ID_4,
							-1 ID_5,
							-1 ID_6,
							'to_emp_ids' input1,
							'to_pos_ids' input2,
							'to_pos_codes' input3,
							'to_par_ids' input4,
							'to_comp_ids' input5,
							'to_cons_ids' input6
						FROM
							EMPLOYEES LEFT JOIN
							EMPLOYEE_POSITIONS 
							ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID
							AND EMPLOYEE_POSITIONS.IS_MASTER = 1 
						WHERE 
							<cfif listlen(int_emp_list)>EMPLOYEES.EMPLOYEE_ID IN(#int_emp_list#)</cfif>
							<cfif listlen(int_pos_list)>EMPLOYEE_POSITIONS.POSITION_ID IN (#int_pos_list#)</cfif> 
							<cfif listlen(int_poscode_list)>EMPLOYEE_POSITIONS.POSITION_CODE IN (#int_poscode_list#)</cfif>
						ORDER BY
							NAME,
							SURNAME,
							TITLE
					</cfquery>
				</cfif>
				<cfif listlen(int_par_list) or  listlen(int_comp_list)><!--- Burada Degisiklik olucak.. --->
					<cfquery name="GET_COMP_LIST"  datasource="#CALLER.DSN#">
						<cfif listlen(int_comp_list) and not listlen(int_par_list)><!--- Sadece Companyler ise.. --->
                            SELECT 
                                FULLNAME NAME, 
                                '' SURNAME,
                                '' TITLE,
								2 ORDER_ID,
                                -1 ID_1,
                                -1 ID_2,
                                -1 ID_3,
                                '' ID_4,
                                COMPANY_ID  ID_5,
                                -1 ID_6
                                ,'to_emp_ids' input1,
                                'to_pos_ids' input2,
                                'to_pos_codes' input3,
                                'to_par_ids' input4,
                                'to_comp_ids' input5,
                                'to_cons_ids' input6
                            FROM
                                COMPANY 
                            WHERE 
                                COMPANY.COMPANY_ID IN (#int_comp_list#)
						<cfelse><!--- company ile beraber partnerlarda listeleniyorsa.. --->
                            SELECT 
                            <cfif attributes.to_title eq 1>
                                COMPANY_PARTNER_NAME NAME,
                                COMPANY_PARTNER_SURNAME SURNAME,
                                NICKNAME TITLE,
                            <cfelse>
                                FULLNAME NAME, 
                                '' SURNAME,
                                '' TITLE,
                            </cfif>
								2 ORDER_ID,
                                -1 ID_1,
                                -1 ID_2,
                                -1 ID_3,
                                COMPANY_PARTNER.PARTNER_ID ID_4,
                                COMPANY_PARTNER.COMPANY_ID ID_5,
                                -1 ID_6
                                ,'to_emp_ids' input1,
                                'to_pos_ids' input2,
                                'to_pos_codes' input3,
                                'to_par_ids' input4,
                                'to_comp_ids' input5,
                                'to_cons_ids' input6
                            FROM
                                COMPANY_PARTNER,
                                COMPANY 
                            WHERE 
                                COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID  AND 
                           	<cfif listlen(int_par_list)>
                                COMPANY_PARTNER.PARTNER_ID IN (#int_par_list#)
                            <cfelseif listlen(int_comp_list)>
                                COMPANY.COMPANY_ID IN (#int_comp_list#)
							</cfif>
						</cfif>
						ORDER BY
							NAME,
							SURNAME,
							TITLE
					</cfquery>
				</cfif>
				<cfif listlen(int_con_list)>
					<cfquery name="GET_CON_LIST"  datasource="#CALLER.DSN#">
						SELECT 
							CONSUMER_NAME NAME,
							CONSUMER_SURNAME SURNAME,
							'' TITLE,
							3 ORDER_ID,
							-1 ID_1,
							-1 ID_2,
							-1 ID_3,
							-1 ID_4,
							-1 ID_5,
							CONSUMER_ID ID_6,
							'to_emp_ids' input1,
							'to_pos_ids' input2, 
							'to_pos_codes' input3,
							'to_par_ids' input4,
							'to_comp_ids' input5,
							'to_cons_ids' input6
						FROM
							CONSUMER 
						WHERE 
							CONSUMER_ID IN (#int_con_list#)
						ORDER BY
							NAME,
							SURNAME,
							TITLE
					</cfquery>
				</cfif>
				<cfif listlen(int_emp_list) or listlen(int_pos_list) or listlen(int_poscode_list) or listlen(int_par_list) or listlen(int_con_list) or listlen(int_comp_list)>
					<cfquery name="GET_ALL_PEOPLE" dbtype="query">
						<cfif listlen(int_emp_list) or listlen(int_pos_list) or listlen(int_poscode_list)>
							SELECT
								<cfif caller.database_type is 'MSSQL'>
								NAME + ' ' + SURNAME NAME,
								<cfelseif caller.database_type is 'DB2'>
								NAME || ' ' || SURNAME NAME,
								</cfif>
								TITLE,
								ORDER_ID,
								ID_1,
								ID_2,
								ID_3,
								ID_4,
								ID_5,
								ID_6,
								input1,
								input2,
								input3,
								input4,
								input5,
								input6
							FROM
								GET_EMP_LIST
						</cfif>
						<cfif listlen(int_par_list) or listlen(int_comp_list)>
							<cfif listlen(int_emp_list) or listlen(int_pos_list) or listlen(int_poscode_list)>
							UNION
							</cfif>
							SELECT 
								<cfif caller.database_type is 'MSSQL'>
								NAME + ' ' + SURNAME NAME,
								<cfelseif caller.database_type is 'DB2'>
								NAME || ' ' || SURNAME NAME,
								</cfif>
								TITLE,
								ORDER_ID,
								ID_1,
								ID_2,
								ID_3,
								ID_4,
								ID_5,
								ID_6,
								input1,
								input2,
								input3,
								input4,
								input5,
								input6
							FROM
								GET_COMP_LIST
						</cfif>
						<cfif listlen(int_con_list)>
							<cfif listlen(int_emp_list) or listlen(int_pos_list) or listlen(int_poscode_list) or listlen(int_par_list)>
							UNION
							</cfif>
							SELECT
								<cfif caller.database_type is 'MSSQL'>
								NAME + ' ' + SURNAME NAME,
								<cfelseif caller.database_type is 'DB2'>
								NAME || ' ' || SURNAME NAME,
								</cfif>
								TITLE,
								ORDER_ID,
								ID_1,
								ID_2,
								ID_3,
								ID_4,
								ID_5,
								ID_6,
								input1,
								input2,
								input3,
								input4,
								input5,
								input6
							FROM
								GET_CON_LIST															
						</cfif>
						<cfif listlen(int_emp_list) or listlen(int_pos_list) or listlen(int_poscode_list)>
							ORDER BY
								ORDER_ID
						<cfelseif listlen(int_par_list) or listlen(int_comp_list)>
							ORDER BY
								ORDER_ID
						<cfelseif listlen(int_con_list)>
							ORDER BY
								ORDER_ID
						</cfif>
					</cfquery>
				<cfelse>
					<cfset get_all_people.recordcount=0>
				</cfif>
				<table id="tbl_to_names" name="tbl_to_names" cellspacing="0">
					<div class="col col-12 col-xs-12">
					<cfset int_row=0>
					<cfif isdefined("get_all_people") and get_all_people.recordcount>
                    	<cfif isdefined('attributes.from_purchase_offer')>
		                    <cfset member_id = "">
                            <cfquery name="GET_FOR_OFFER_IDS" datasource="#caller.DSN3#">
                                SELECT 
                                    FOR_OFFER_ID,
                                    OFFER_ID,
                                    OFFER_NUMBER,
                                    OFFER_TO_PARTNER,
                                    OFFER_TO,
                                    OFFER_TO_CONSUMER
                                FROM 
                                    OFFER 
                                WHERE 
                                    FOR_OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
                            </cfquery>
                        </cfif>
						<cfoutput query="get_all_people">
							<cfset int_row=currentrow>
							<div class="col col-12 col-xs-12" id="workcube_to_row#int_row#" name="workcube_to_row#int_row#" style="border-bottom:1px solid ##b3aeae;padding-top:3%;padding-bottom:3%;">
								<cfif isdefined('attributes.from_purchase_offer')>
									<cfif id_4 neq -1><cfset member_id = "partner_ids=#id_4#"></cfif>
									<cfif id_5 neq -1><cfset member_id = "#member_id#&company_ids=#id_5#"></cfif>
									<cfif id_6 neq -1><cfset member_id = "consumer_ids=#id_6#"></cfif>
									<cfif len(member_id)><!--- cariden daha önce teklif istenip istenmedigini kontrol eder  --->
										<cfquery name="GET_FOR_OFFER_ID" dbtype="query">
											SELECT 
												FOR_OFFER_ID,
												OFFER_ID,
												OFFER_NUMBER
											FROM 
												GET_FOR_OFFER_IDS 
											WHERE 
												FOR_OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND 
												<cfif id_4 neq -1>
													OFFER_TO_PARTNER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#id_4#,%">
												<cfelseif id_5 neq -1>
													OFFER_TO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#id_5#,%">
												<cfelseif id_6 neq -1>
													OFFER_TO_CONSUMER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#id_6#,%">
												</cfif>
										</cfquery>
									</cfif>
                                </cfif>
								<div class="col col-12 col-xs-12" nowrap="nowrap" style="vertical-align:top;">
                                	<input type="hidden" name="#input1#" id="#input1#" value="<cfif ID_1 neq -1>#ID_1#</cfif>">
									<input type="hidden" name="#input2#" id="#input2#" value="<cfif ID_2 neq -1>#ID_2#</cfif>">
									<input type="hidden" name="#input3#" id="#input3#" value="<cfif ID_3 neq -1>#ID_3#</cfif>">
									<input type="hidden" name="#input4#" id="#input4#" value="<cfif ID_4 neq -1>#ID_4#</cfif>">
									<input type="hidden" name="#input5#" id="#input5#" value="<cfif ID_5 neq -1>#ID_5#</cfif>">
									<input type="hidden" name="#input6#" id="#input6#" value="<cfif ID_6 neq -1>#ID_6#</cfif>">
									<cfif len(ID_1)>
                                    	 <cfset int_id=ID_1>
                                    <cfelseif len(ID_2)>
                                    	<cfset int_id=ID_2>
                                    <cfelse>
                                    	 <cfset int_id=ID_5>
                                    </cfif>
                                    <cfif not (isdefined('attributes.from_purchase_offer') and len(member_id) and get_for_offer_id.recordcount)>
                                        <a href="javascript://" class="none-decoration" onclick="workcube_to_delRow(#int_row#,#int_id#);"><i class="fa fa-minus"></i></a>								
                                    </cfif>
									<cfscript>
										custag_link_str = '';
										//custag_detay='';
										if(isDefined('session.ep.userid'))
										{
											if(ID_1 neq -1) custag_link_str = 'objects.popup_emp_det&emp_id=' & ID_1;
											if(ID_6 neq -1) custag_link_str = 'objects.popup_con_det&con_id=' &  ID_6 ;
											if(ID_4 neq -1)
											{
											 	custag_link_str = 'objects.popup_com_det&company_id='&  ID_5 & '&partner_id=' & ID_4;
										 	}
										}
										else
										{
											if(ID_1 neq -1) custag_link_str = 'objects2.popup_emp_det&emp_id=' & ID_1;
											if(ID_6 neq -1) custag_link_str = 'objects2.popup_con_det&con_id=' &  ID_6 ;
											if(ID_4 neq -1)
											{
											 	custag_link_str = 'objects2.popup_com_det&company_id='&  ID_5 & '&partner_id=' & ID_4;
										 	}										
										}				
									</cfscript>
									<cfif isdefined('session.ep.userid')>
										<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#custag_link_str#','list');" class="tableyazi">#name#</a>
									<cfelseif isdefined('session.pp.userid')>
										#name#
									<cfelse>
										<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#custag_link_str#','list');" class="tableyazi">#name#</a>									
									</cfif>
									<cfif len(title)>(#title#)</cfif>
								</div>
								<!--- satınalma teklifi : print ve teklif ekleme sayfalarina default cari degerlerini getirir --->
								<cfif isdefined('attributes.from_purchase_offer')>
									<div class="col col-12 col-xs-12" nowrap="nowrap" style="vertical-align:top;">
                                    	<cfif isDefined('caller.x_multiple_sub_offers') and caller.x_multiple_sub_offers eq 1>
                                            <cfloop query="get_for_offer_id">
                                                <a href="#request.self#?fuseaction=purchase.list_offer&event=upd&offer_id=#get_for_offer_id.offer_id#" class="tableyazi">#get_for_offer_id.offer_number#</a><br/>
                                            </cfloop>
                                        <cfelse>
                                            <a href="#request.self#?fuseaction=purchase.list_offer&event=upd&offer_id=#get_for_offer_id.offer_id#" class="tableyazi">#get_for_offer_id.offer_number#</a><br/>
                                        </cfif>
                                    </div>
									<td style="vertical-align:top;"><a href="javascript://" class="tableyazi" onclick="control_related_offer(#get_for_offer_id.recordcount#,'#member_id#')"><i class="fa fa-plus"></i></a></td>
									<cfif attributes.print_all eq 2 and not get_for_offer_id.recordcount>
										<td style="vertical-align:top;"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.action_id#&print_type=90&keyword=#member_id#','page');"><img src="/images/print2.gif" border="0" title="<cf_get_lang_main no='62.Yazdır'>"></a></td>
									<cfelse>
										<td style="vertical-align:top;"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=<cfif attributes.print_all is 1>#attributes.action_id#<cfelse>#get_for_offer_id.offer_id#</cfif>&print_type=90&keyword=#member_id#','page');"><img src="/images/print2.gif" border="0" title="<cf_get_lang_main no='62.Yazdır'>"></a></td>
									</cfif>
								</cfif>
								<!--- satınalma teklifi : print ve ekleme sayfalarina default cari degerlerini getirir --->
							</div>							
						</cfoutput>
					</cfif>
					<input type="hidden" name="tbl_to_names_row_count" id="tbl_to_names_row_count" value="<cfoutput>#int_row#</cfoutput>">	
				</div>						
			</table>
			</div>
		</cfif>
    	<cfif isdefined("attributes.cc_dsp_name")>
			<div class="col col-6 col-xs-6">
				<cfif isdefined("get_values.cc_emp")>
					<cfif attributes.data_type eq 1><cfset int_emp_list = ListSort(get_values.cc_emp,"textnocase")>
					<cfelseif attributes.data_type eq 2><cfset int_emp_list = ListSort(ValueList(get_values.cc_emp),"numeric","asc")>
					</cfif>						
				<cfelse>
					<cfset int_emp_list="">
                </cfif>
                
				<cfif isdefined("get_values.cc_pos")>
					<cfif attributes.data_type eq 1><cfset int_pos_list = ListSort(get_values.cc_pos,"textnocase")>
					<cfelseif attributes.data_type eq 2><cfset int_pos_list = ListSort(ValueList(get_values.cc_pos),"numeric","asc")>
					</cfif>						
				<cfelse>
					<cfset int_pos_list="">
               	</cfif>
				
				<cfif isdefined("get_values.cc_pos_code")>
					<cfif attributes.data_type eq 1><cfset int_poscode_list = ListSort(get_values.cc_pos_code,"textnocase")>
					<cfelseif attributes.data_type eq 2><cfset int_poscode_list = ListSort(ValueList(get_values.cc_pos_code),"numeric","asc")>
					</cfif>						
				<cfelse>
					<cfset int_poscode_list="">
               	</cfif>
                
				<cfif isdefined("get_values.cc_par")>
					<cfif attributes.data_type eq 1><cfset int_par_list = ListSort(get_values.cc_par,"textnocase")>
					<cfelseif attributes.data_type eq 2><cfset int_par_list = ListSort(ValueList(get_values.cc_par),"numeric","asc")>
					</cfif>						
				<cfelse>
					<cfset int_par_list="">
                </cfif>
				
				<cfif isdefined("get_values.cc_comp")>
					<cfif attributes.data_type eq 1><cfset int_comp_list = ListSort(get_values.cc_comp,"textnocase")>
					<cfelseif attributes.data_type eq 2><cfset int_comp_list = ListSort(ValueList(get_values.cc_comp),"numeric","asc")>
					</cfif>
				<cfelse>
					<cfset int_comp_list="">
               	</cfif>
                
				<cfif isdefined("get_values.cc_con")>
					<cfif attributes.data_type eq 1><cfset int_con_list = ListSort(get_values.cc_con,"textnocase")>
					<cfelseif attributes.data_type eq 2><cfset int_con_list = ListSort(ValueList(get_values.cc_con),"numeric","asc")>
					</cfif>
				<cfelse>
					<cfset int_con_list="">
                </cfif>
                
				<cfif isdefined("get_values.cc_wrkgroup")>
					<cfif attributes.data_type eq 1><cfset int_wgrp_list = ListSort(get_values.cc_wrkgroup,"textnocase")>
					<cfelseif attributes.data_type eq 2><cfset int_wgrp_list = ListSort(ValueList(get_values.cc_wrkgroup),"numeric","asc")>
					</cfif>							
				<cfelse>
					<cfset int_wgrp_list="">
                </cfif>
                
				<cfif isdefined("get_values.cc_group")>
					<cfif attributes.data_type eq 1><cfset int_grp_list = ListSort(get_values.cc_group,"textnocase")>
					<cfelseif attributes.data_type eq 2><cfset int_grp_list = ListSort(ValueList(get_values.cc_group),"numeric","asc")>
					</cfif>							
				<cfelse>
					<cfset int_grp_list="">
                </cfif>
                
				<cfif listlen(int_emp_list) or listlen(int_pos_list) or listlen(int_poscode_list)>
					<cfquery name="GET_EMP_LIST_CC" datasource="#caller.dsn#">
						SELECT 
						<cfif attributes.to_title eq 1>
							EMPLOYEE_NAME NAME, 
							EMPLOYEE_SURNAME SURNAME, 
							POSITION_NAME TITLE,
						<cfelse>
							POSITION_NAME NAME,
							'' SURNAME,
							'' TITLE,
						</cfif> 
							1 ORDER_ID,
							EMPLOYEE_ID ID_1,
							POSITION_ID ID_2,
							POSITION_CODE ID_3,
							-1 ID_4,
							-1 ID_5,
							-1 ID_6,
							'cc_emp_ids' input1,
							'cc_pos_ids' input2,
							'cc_pos_codes' input3,
							'cc_par_ids' input4,
							'cc_comp_ids' input5,
							'cc_cons_ids' input6
						FROM
							EMPLOYEE_POSITIONS 
						WHERE 
							<cfif listlen(int_emp_list)>EMPLOYEE_ID IN (#int_emp_list#) AND IS_MASTER = 1</cfif> 
							<cfif listlen(int_pos_list)>POSITION_ID IN (#int_pos_list#)</cfif> 
							<cfif listlen(int_poscode_list)>POSITION_CODE IN (#int_poscode_list#)</cfif>
						ORDER BY
							NAME,
							SURNAME,
							TITLE
					</cfquery>
				<cfelse>
					<cfset get_emp_list_cc.recordcount = 0>
				</cfif>
				<cfif listlen(int_par_list)>
					<cfquery name="GET_COMP_LIST_CC"  datasource="#caller.dsn#">
						SELECT 
						<cfif attributes.cc_title eq 1>
							COMPANY_PARTNER_NAME NAME,
							COMPANY_PARTNER_SURNAME SURNAME,
							NICKNAME TITLE,
						<cfelse>
							FULLNAME NAME,
							'' SURNAME,
							'' TITLE,
						</cfif>
							2 ORDER_ID,
							-1 ID_1,
							-1 ID_2,
							-1 ID_3,
							COMPANY_PARTNER.PARTNER_ID ID_4,
							COMPANY_PARTNER.COMPANY_ID ID_5,
							-1 ID_6,
							'cc_emp_ids' input1,
							'cc_pos_ids' input2,
							'cc_pos_codes' input3,
							'cc_par_ids' input4,
							'cc_comp_ids' input5,
							'cc_cons_ids' input6
						FROM 
							COMPANY_PARTNER,
							COMPANY 
						WHERE 
							COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID  AND 
							COMPANY_PARTNER.PARTNER_ID IN (#int_par_list#)
						ORDER BY
							NAME,
							SURNAME,
							TITLE
					</cfquery>
				<cfelse>
					<cfset get_comp_list_cc.recordcount = 0>							
				</cfif>
				<cfif listlen(int_con_list)>
					<cfquery name="GET_CON_LIST_CC"  datasource="#caller.dsn#">
						SELECT 
							CONSUMER_NAME NAME,
							CONSUMER_SURNAME SURNAME,
							'' TITLE,
							3 ORDER_ID,
							-1 ID_1,
							-1 ID_2,
							-1 ID_3,
							-1 ID_4,
							-1 ID_5,
							CONSUMER_ID ID_6,
							'cc_emp_ids' input1,
							'cc_pos_ids' input2,
							'cc_pos_codes' input3,
							'cc_par_ids' input4,
							'cc_comp_ids' input5,
							'cc_cons_ids' input6
						 FROM
							CONSUMER 
						WHERE 
							CONSUMER_ID IN (#int_con_list#)
						ORDER BY
							NAME,
							SURNAME,
							TITLE
					</cfquery>
				<cfelse>
					<cfset get_con_list_cc.recordcount = 0>		
				</cfif>
			<cfif get_emp_list_cc.recordcount or get_comp_list_cc.recordcount or get_con_list_cc.recordcount>
				<cfquery name="GET_ALL_PEOPLE_CC" dbtype="query">
					<cfif get_emp_list_cc.recordcount>
						SELECT
						<cfif caller.database_type is 'MSSQL'>
							NAME + ' ' + SURNAME NAME,
						<cfelseif caller.database_type is 'DB2'>
							NAME || ' ' || SURNAME NAME,
						</cfif>
							TITLE,
							ORDER_ID,
							ID_1,
							ID_2,
							ID_3,
							ID_4,
							ID_5,
							ID_6,
							input1,
							input2,
							input3,
							input4,
							input5,
							input6
						FROM
							get_emp_list_cc
					</cfif>
					<cfif get_comp_list_cc.recordcount>
						<cfif get_emp_list_cc.recordcount>
						UNION 
						</cfif>
						SELECT
						<cfif caller.database_type is 'MSSQL'>
							NAME + ' ' + SURNAME NAME,
						<cfelseif caller.database_type is 'DB2'>
							NAME || ' ' || SURNAME NAME,
						</cfif>
							TITLE,
							ORDER_ID,
							ID_1,
							ID_2,
							ID_3,
							ID_4,
							ID_5,
							ID_6,
							input1,
							input2,
							input3,
							input4,
							input5,
							input6
						FROM
							get_comp_list_cc
					</cfif>
					<cfif get_con_list_cc.recordcount>
						<cfif get_emp_list_cc.recordcount or get_comp_list_cc.recordcount>
						UNION
						</cfif>
						SELECT
							<cfif caller.database_type is 'MSSQL'>
							NAME + ' ' + SURNAME NAME,
							<cfelseif caller.database_type is 'DB2'>
							NAME || ' ' || SURNAME NAME,
							</cfif>
							TITLE,
							ORDER_ID,
							ID_1,
							ID_2,
							ID_3,
							ID_4,
							ID_5,
							ID_6,
							input1,
							input2,
							input3,
							input4,
							input5,
							input6
						FROM
							get_con_list_cc												
					</cfif>
					<cfif get_emp_list_cc.recordcount>
						ORDER BY
							ORDER_ID
					<cfelseif get_comp_list_cc.recordcount>
						ORDER BY
							ORDER_ID
					<cfelseif get_con_list_cc.recordcount>
						ORDER BY
							ORDER_ID
					</cfif>
				</cfquery>
			<cfelse>
				<cfset get_all_people_cc.recordcount=0>
			</cfif>
				<cfset int_row = 0>
				<table id="tbl_cc_names" name="tbl_cc_names">
					<div class="col col-12 col-xs-12">
				<cfif get_all_people_cc.recordcount>
					<cfoutput query="get_all_people_cc">
						<cfset int_row=currentrow-1>
						<div class="col col-12 col-xs-12" id="workcube_cc_row#int_row#" name="workcube_cc_row#int_row#" style="border-bottom: 1px solid ##b3aeae;padding:3% 0 3% 0;">
							<div class="col col-12 col-xs-12">
								<input type="hidden" name="#input1#" id="#input1#" value="<cfif ID_1 neq -1>#ID_1#</cfif>">
								<input type="hidden" name="#input2#" id="#input2#" value="<cfif ID_2 neq -1>#ID_2#</cfif>">
								<input type="hidden" name="#input3#" id="#input3#" value="<cfif ID_3 neq -1>#ID_3#</cfif>">
								<input type="hidden" name="#input4#" id="#input4#" value="<cfif ID_4 neq -1>#ID_4#</cfif>">
								<input type="hidden" name="#input5#" id="#input5#" value="<cfif ID_5 neq -1>#ID_5#</cfif>">
								<input type="hidden" name="#input6#" id="#input6#" value="<cfif ID_6 neq -1>#ID_6#</cfif>">
									<cfif len(ID_1)>
                                    	 <cfset int_id=ID_1>
                                    <cfelseif len(ID_2)>
                                    	<cfset int_id=ID_2>
                                    <cfelse>
                                    	 <cfset int_id=ID_5>
                                    </cfif>
                              	<a href="javascript://" class="none-decoration" onclick="workcube_cc_delRow(#int_row#,#int_id#);"><i class="fa fa-minus"></i></a>
								<cfscript>
									custag_link_str = '';
									//custag_detay='';
									// if(ID_1 neq -1) custag_link_str = 'objects.popup_emp_det&emp_id=' & ID_1;
									// if(ID_6 neq -1) custag_link_str = 'objects.popup_con_det&con_id=' &  ID_6 ;
									if(isDefined('session.ep.userid'))
									{
										if(ID_1 neq -1) custag_link_str = 'objects.popup_emp_det&emp_id=' & ID_1;
										if(ID_6 neq -1) custag_link_str = 'objects.popup_con_det&con_id=' &  ID_6 ;
										if(ID_4 neq -1)
										{
										 	custag_link_str = 'objects.popup_com_det&company_id='&  ID_5 & '&partner_id=' & ID_4;
									 	}
									}
									else
									{
										if(ID_1 neq -1) custag_link_str = 'objects2.popup_emp_det&emp_id=' & ID_1;
										if(ID_6 neq -1) custag_link_str = 'objects2.popup_con_det&con_id=' &  ID_6 ;	
										if(ID_4 neq -1)
										{
										 	custag_link_str = 'objects2.popup_com_det&company_id='&  ID_5 & '&partner_id=' & ID_4;
									 	}									
									}
									
								</cfscript>
								<!---<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=#custag_link_str#','list');" class="tableyazi">#name#</a>--->
								<cfif isdefined('session.ep.userid')>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#custag_link_str#','list');" class="tableyazi">#name#</a>
								<cfelseif isdefined('session.pp.userid')>
									#name#
								<cfelse>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#custag_link_str#','list');" class="tableyazi">#name#</a>									
								</cfif>
								<cfif len(title)>(#title#)</cfif>
							</div>
						</div>							
					</cfoutput>
				</cfif>
				<cfset cus_tag_max_row_cc = get_all_people_cc.recordcount>
                <input type="hidden" name="tbl_cc_names_row_count" id="tbl_cc_names_row_count" value="<cfoutput>#int_row#</cfoutput>">
                <cfif get_all_people_cc.recordcount>
                    <div id="hepsini_sil_id2">
                        <div class="col col-12 col-xs-12" style="padding-top:15%;"><a style="color:red;" href="javascript://" onclick="hepsini_sil(2)"><cfoutput>#caller.getLang('main',2239)#</cfoutput></a></div><!---Hepsini Sil--->
					</div>
                </cfif>
			</div>
		</table>
		</div>
    	</cfif>
		<cfif isdefined("attributes.cc2_dsp_name")>
		<div class="col col-12 col-xs-12">
				<cfif isdefined("get_values.cc2_emp")>
					<cfif attributes.data_type eq 1><cfset int_emp_list = ListSort(get_values.cc2_emp,"textnocase")>
					<cfelseif attributes.data_type eq 2><cfset int_emp_list = ListSort(ValueList(get_values.cc2_emp),"numeric","asc")>
					</cfif>						
				<cfelse>
					<cfset int_emp_list="">
                </cfif>
				
				<cfif isdefined("get_values.cc2_pos")>
					<cfif attributes.data_type eq 1><cfset int_pos_list = ListSort(get_values.cc2_pos,"textnocase")>
					<cfelseif attributes.data_type eq 2><cfset int_pos_list = ListSort(ValueList(get_values.cc2_pos),"numeric","asc")>
					</cfif>						
				<cfelse>
					<cfset int_pos_list="">
               	</cfif>
				
				<cfif isdefined("get_values.cc2_pos_code")>
					<cfif attributes.data_type eq 1><cfset int_poscode_list = ListSort(get_values.cc2_pos_code,"textnocase")>
					<cfelseif attributes.data_type eq 2><cfset int_poscode_list = ListSort(ValueList(get_values.cc2_pos_code),"numeric","asc")>
					</cfif>						
				<cfelse>
					<cfset int_poscode_list="">
               	</cfif>
				
				<cfif isdefined("get_values.CC2_PAR")>
					<cfif attributes.data_type eq 1><cfset int_par_list = ListSort(get_values.CC2_PAR,"textnocase")>
					<cfelseif attributes.data_type eq 2><cfset int_par_list = ListSort(ValueList(get_values.CC2_PAR),"numeric","asc")>
					</cfif>						
				<cfelse><cfset int_par_list=""></cfif>
				
				<cfif isdefined("get_values.cc2_comp")>
					<cfif attributes.data_type eq 1><cfset int_comp_list = ListSort(get_values.cc2_comp,"textnocase")>
					<cfelseif attributes.data_type eq 2><cfset int_comp_list = ListSort(ValueList(get_values.cc2_comp),"numeric","asc")>
					</cfif>
				<cfelse>
					<cfset int_comp_list="">
               	</cfif>
				
				<cfif isdefined("get_values.cc2_con")>
					<cfif attributes.data_type eq 1><cfset int_con_list = ListSort(get_values.cc2_con,"textnocase")>
					<cfelseif attributes.data_type eq 2><cfset int_con_list = ListSort(ValueList(get_values.cc2_con),"numeric","asc")>
					</cfif>
				<cfelse>
					<cfset int_con_list="">
               	</cfif>
				
				<cfif isdefined("get_values.cc2_wrkgroup")>
					<cfif attributes.data_type eq 1><cfset int_wgrp_list = ListSort(get_values.cc2_wrkgroup,"textnocase")>
					<cfelseif attributes.data_type eq 2><cfset int_wgrp_list = ListSort(ValueList(get_values.cc2_wrkgroup),"numeric","asc")>
					</cfif>							
				<cfelse>
					<cfset int_wgrp_list="">
               	</cfif>
				
				<cfif isdefined("get_values.cc2_group")>
					<cfif attributes.data_type eq 1><cfset int_grp_list = ListSort(get_values.cc2_group,"textnocase")>
					<cfelseif attributes.data_type eq 2><cfset int_grp_list = ListSort(ValueList(get_values.cc2_group),"numeric","asc")>
					</cfif>							
				<cfelse>
					<cfset int_grp_list="">
                </cfif>
				
				<cfif listlen(int_emp_list) or listlen(int_pos_list) or listlen(int_poscode_list)>
					<cfquery name="GET_EMP_LIST_CC2"  datasource="#caller.dsn#">
						SELECT 
						<cfif attributes.to_title eq 1>
							EMPLOYEE_NAME NAME, 
							EMPLOYEE_SURNAME SURNAME,
							POSITION_NAME TITLE,
						<cfelse>
							POSITION_NAME NAME,
							'' SURNAME,
							'' TITLE,
						</cfif> 
							1 ORDER_ID,
							EMPLOYEE_ID ID_1,
							POSITION_ID ID_2,
							POSITION_CODE ID_3,
							-1 ID_4,
							-1 ID_5,
							-1 ID_6,
							'cc2_emp_ids' input1,
							'cc2_pos_ids' input2,
							'cc2_pos_codes' input3,
							'cc2_par_ids' input4,
							'cc2_comp_ids' input5,
							'cc2_cons_ids' input6
						FROM
							EMPLOYEE_POSITIONS 
						WHERE 
							<cfif listlen(int_emp_list)>EMPLOYEE_ID IN (#int_emp_list#) AND IS_MASTER = 1</cfif> 
							<cfif listlen(int_pos_list)>POSITION_ID IN (#int_pos_list#)</cfif> 
							<cfif listlen(int_poscode_list)>POSITION_CODE IN (#int_poscode_list#)</cfif>
					</cfquery>
				<cfelse>
					<cfset get_emp_list_cc2.recordcount =0>
				</cfif>
				<cfif listlen(int_par_list)>
					<cfquery name="GET_COMP_LIST_CC2" datasource="#caller.dsn#">
						SELECT 
							<cfif attributes.cc2_title eq 1>
								COMPANY_PARTNER_NAME NAME,
								COMPANY_PARTNER_SURNAME SURNAME,
								NICKNAME TITLE,
							<cfelse>
								FULLNAME NAME, 
								'' SURNAME,
								'' TITLE,
							</cfif>
							2 ORDER_ID,
							-1 ID_1,
							-1 ID_2,
							-1 ID_3,
							COMPANY_PARTNER.PARTNER_ID ID_4,
							COMPANY_PARTNER.COMPANY_ID ID_5,
							-1 ID_6,
							'cc2_emp_ids' input1,
							'cc2_pos_ids' input2,
							'cc2_pos_codes' input3,
							'cc2_par_ids' input4,
							'cc2_comp_ids' input5,
							'cc2_cons_ids' input6
						FROM 
							COMPANY_PARTNER,
							COMPANY 
						WHERE 
							COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID  AND 
							COMPANY_PARTNER.PARTNER_ID IN (#int_par_list#)
					</cfquery>
				<cfelse>
					<cfset get_comp_list_cc2.recordcount =0>							
				</cfif>
				<cfif listlen(int_con_list)>
					<cfquery name="GET_CON_LIST_CC2" datasource="#caller.dsn#">
						SELECT 
							CONSUMER_NAME NAME,
							CONSUMER_SURNAME SURNAME,
							'' TITLE,
							3 ORDER_ID,
							-1 ID_1,
							-1 ID_2,
							-1 ID_3,
							-1 ID_4,
							-1 ID_5,
							CONSUMER_ID ID_6,
							'cc2_emp_ids' input1,
							'cc2_pos_ids' input2,
							'cc2_pos_codes' input3,
							'cc2_par_ids' input4,
							'cc2_comp_ids' input5,
							'cc2_cons_ids' input6
						FROM
							CONSUMER 
						WHERE 
							CONSUMER_ID IN (#int_con_list#)
					</cfquery>
				<cfelse>
					<cfset get_con_list_cc2.recordcount =0>							
				</cfif>
			<cfif get_con_list_cc2.recordcount or get_comp_list_cc2.recordcount or get_emp_list_cc2.recordcount>
				<cfquery name="GET_ALL_PEOPLE_CC2" dbtype="query">
					<cfif get_emp_list_cc2.recordcount>
						SELECT
							<cfif caller.database_type is 'MSSQL'>
							NAME + ' ' + SURNAME NAME,
							<cfelseif caller.database_type is 'DB2'>
							NAME || ' ' || SURNAME NAME,
							</cfif>
							TITLE,
							ORDER_ID,
							ID_1,
							ID_2,
							ID_3,
							ID_4,
							ID_5,
							ID_6,
							input1,
							input2,
							input3,
							input4,
							input5,
							input6
						FROM
							get_emp_list_cc2
					</cfif>
					<cfif get_comp_list_cc2.recordcount>
						<cfif get_emp_list_cc2.recordcount>
						UNION 
						</cfif>
						SELECT
							<cfif caller.database_type is 'MSSQL'>
							NAME + ' ' + SURNAME NAME,
							<cfelseif caller.database_type is 'DB2'>
							NAME || ' ' || SURNAME NAME,
							</cfif>
							TITLE,
							ORDER_ID,
							ID_1,
							ID_2,
							ID_3,
							ID_4,
							ID_5,
							ID_6,
							input1,
							input2,
							input3,
							input4,

							input5,
							input6
						FROM
							get_comp_list_cc2
					</cfif>
					<cfif get_con_list_cc2.recordcount>
						<cfif get_emp_list_cc2.recordcount or get_comp_list_cc2.recordcount>
						UNION
						</cfif>
						SELECT
							<cfif caller.database_type is 'MSSQL'>
							NAME + ' ' + SURNAME NAME,
							<cfelseif caller.database_type is 'DB2'>
							NAME || ' ' || SURNAME NAME,
							</cfif>
							TITLE,
							ORDER_ID,
							ID_1,
							ID_2,
							ID_3,
							ID_4,
							ID_5,
							ID_6,
							input1,
							input2,
							input3,
							input4,
							input5,
							input6
						FROM
							get_con_list_cc2												
					</cfif>
					<cfif get_emp_list_cc2.recordcount>
						ORDER BY
							ORDER_ID
					<cfelseif get_comp_list_cc2.recordcount>
						ORDER BY
							ORDER_ID	
					<cfelseif get_con_list_cc2.recordcount>
						ORDER BY
							ORDER_ID
					</cfif>
				</cfquery>
			<cfelse>
				<cfset get_all_people_cc2.recordcount=0>
			</cfif>
				<cfset int_row = 0>
				<table id="tbl_cc2_names" name="tbl_cc2_names">
				<cfif get_all_people_cc2.recordcount>
					<cfoutput query="get_all_people_cc2">
						<cfset int_row=currentrow-1>
						<tr id="workcube_cc2_row#int_row#" name="workcube_cc2_row#int_row#"  style="display='';">
							<td><input type="hidden" name="#input1#" id="#input1#" value="<cfif ID_1 neq -1>#ID_1#</cfif>">
								<input type="hidden" name="#input2#" id="#input2#" value="<cfif ID_2 neq -1>#ID_2#</cfif>">
								<input type="hidden" name="#input3#" id="#input3#" value="<cfif ID_3 neq -1>#ID_3#</cfif>">
								<input type="hidden" name="#input4#" id="#input4#" value="<cfif ID_4 neq -1>#ID_4#</cfif>">
								<input type="hidden" name="#input5#" id="#input5#" value="<cfif ID_5 neq -1>#ID_5#</cfif>">
								<input type="hidden" name="#input6#" id="#input6#" value="<cfif ID_6 neq -1>#ID_6#</cfif>">
									<cfif len(ID_1)>
                                    	 <cfset int_id=ID_1>
                                    <cfelseif len(ID_2)>
                                    	<cfset int_id=ID_2>
                                    <cfelse>
                                    	 <cfset int_id=ID_5>
                                    </cfif>
								<a href="javascript://" onclick="workcube_cc2_delRow(#int_row#,#int_id#);"><i class="fa fa-minus"></i></a>
							</td>
							<td>
								<cfscript>
									custag_link_str = '';
									//custag_detay='';
									//if(ID_1 neq -1) custag_link_str = 'objects.popup_emp_det&emp_id=' & ID_1;
									//if(ID_6 neq -1) custag_link_str = 'objects.popup_con_det&con_id=' &  ID_6 ;
									if(isDefined('session.ep.userid'))
									{
										if(ID_1 neq -1) custag_link_str = 'objects.popup_emp_det&emp_id=' & ID_1;
										if(ID_6 neq -1) custag_link_str = 'objects.popup_con_det&con_id=' &  ID_6 ;
										if(ID_4 neq -1)
										{
										 	custag_link_str = 'objects.popup_com_det&company_id='&  ID_5 & '&partner_id=' & ID_4;
										}
									}
									else
									{
										if(ID_1 neq -1) custag_link_str = 'objects2.popup_emp_det&emp_id=' & ID_1;
										if(ID_6 neq -1) custag_link_str = 'objects2.popup_con_det&con_id=' &  ID_6 ;
										if(ID_4 neq -1)
										{
										 	custag_link_str = 'objects2.popup_com_det&company_id='&  ID_5 & '&partner_id=' & ID_4;
										}										
									}
									
								</cfscript>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#custag_link_str#','list');"  class="tableyazi">#name#</a>
								
								<cfif len(title)>(#title#)</cfif>
							</td>
						</tr>							
					</cfoutput>
				</cfif>
                <cfset cus_tag_max_row_cc2 = get_all_people_cc2.recordcount>
				<input type="hidden" name="tbl_cc2_names_row_count" id="tbl_cc2_names_row_count" value="<cfoutput>#int_row#</cfoutput>">
                <cfif get_all_people_cc2.recordcount>
                    <tr id="hepsini_sil_id3">
                        <td colspan="3"><a href="javascript://" onclick="hepsini_sil(3)"><cfoutput>#caller.getLang('main',2239)#</cfoutput></a></td><!---Hepsini Sil--->
                    </tr>
                </cfif>
            </table>
		</div>				
		</cfif>
	</div>
</div>
    <cfif (isdefined("get_all_people") and get_all_people.recordcount) and (isdefined('attributes.from_purchase_offer') and not get_for_offer_ids.recordcount)>
        <tr id="hepsini_sil_id">
            <td colspan="3"><a href="javascript://" onclick="hepsini_sil(1)"><cfoutput>#caller.getLang('main',2239)#</cfoutput></a></td><!---Hepsini Sil--->
        </tr>
    </cfif>
	</div>
</cfif>
<cfelse>

	<cfif attributes.is_update eq 0>
	<table class="ajax_list">
	<thead>
		<cfif isdefined("attributes.to_dsp_name")>
			<tr>
				<th width="20">
					<a href="javascript://" class="none-decoration" onclick="try{opener_control();}catch(e){};openBoxDraggable('widgetloader?widget_load=listMultiUsers&style=maxi&isbox=1<cfoutput>&title=#boxTitle##main_str_url#&select_list=#select_list#&row_count=tbl_to_names_row_count&table_name=tbl_to_names&table_row_name=workcube_to_row&field_grp_id=to_grp_ids&field_wgrp_id=to_wgrp_ids&function_row_name=workcube_to_delRow</cfoutput>&comp_id_list='+document.getElementById('comp_id_list').value);"><i class="fa fa-plus"></i></a>
				</th>
				<th><cfoutput>#attributes.to_dsp_name#</cfoutput></th>
				<input type="hidden" name="comp_id_list" id="comp_id_list" value=""/>
				<input type="hidden" name="tbl_to_names_row_count" id="tbl_to_names_row_count" value="0">
			</tr>
		</cfif>
		<cfif isdefined("attributes.cc_dsp_name")>
			<tr>
				<th width="20">
					<a href="javascript://" class="none-decoration" onclick="openBoxDraggable('widgetloader?widget_load=listMultiUsers&style=maxi&isbox=1<cfoutput>&title=#boxTitle##main_str_url_cc#&table_name=tbl_cc_names&row_count=tbl_cc_names_row_count&select_list=#select_list#&table_row_name=workcube_cc_row&field_grp_id=cc_grp_ids&field_wgrp_id=cc_wgrp_ids&function_row_name=workcube_cc_delRow</cfoutput>');">
					<i class="fa fa-plus"></i></a>
				</th>
				<th><cfoutput>#attributes.cc_dsp_name#</cfoutput></th>
				<input type="hidden" name="tbl_cc_names_row_count" id="tbl_cc_names_row_count" value="0">
			</tr>
		</cfif>
		<cfif isdefined("attributes.cc2_dsp_name")>
			<tr>
				<th width="20">
					<a href="javascript://" onclick="openBoxDraggable('widgetloader?widget_load=listMultiUsers&style=maxi&isbox=1<cfoutput>&title=#boxTitle##main_str_url_cc2#&table_name=tbl_cc2_names&row_count=tbl_cc2_names_row_count&select_list=#select_list#&table_row_name=workcube_cc2_row&field_grp_id=cc2_grp_ids&field_wgrp_id=cc2_wgrp_ids&function_row_name=workcube_cc2_delRow</cfoutput>');">
					<i class="fa fa-plus"></i></a>
				</th>
				<th><cfoutput>#attributes.cc2_dsp_name#</cfoutput></th>
				<input type="hidden" name="tbl_cc2_names_row_count" id="tbl_cc2_names_row_count" value="0">
			</tr>
		</cfif>
	</thead>
		 <!---class="to_cc"--->
			<cfif isdefined("attributes.to_dsp_name")>			
				<tbody id="tbl_to_names" width="100%"></tbody>	
			</cfif>
			<cfif isdefined("attributes.cc_dsp_name")>
				<tbody id="tbl_cc_names" width="100%"></tbody>			
			</cfif>
			<cfif isdefined("attributes.cc2_dsp_name")>
				<tbody id="tbl_cc2_names" width="100%"></tbody>		
			</cfif>
	</table>
	<cfelse>
		<cfquery name="GET_VALUES" datasource="#attributes.action_dsn#">
			SELECT 
				#attributes.str_action_names#
			FROM 
				#attributes.action_table# 
			WHERE 
				#attributes.action_id_name# = #attributes.action_id#
				<cfif isdefined('attributes.our_comp_id')>
					AND OUR_COMPANY_ID = #attributes.our_comp_id#
				</cfif>
		</cfquery>
		<table class="ajax_list">
		<thead>
			<tr>
				<cfif isdefined("attributes.to_dsp_name")>
					<cfif not isDefined("attributes.is_detail")>
						<th width="20">
							<input type="hidden" name="comp_id_list" id="comp_id_list" value="" />
							<a href="javascript://" class="none-decoration" onclick="try{opener_control();}catch(e){};openBoxDraggable('widgetloader?widget_load=listMultiUsers&style=maxi&isbox=1<cfoutput>&title=#boxTitle#&#main_str_url#&select_list=#select_list#&row_count=tbl_to_names_row_count&table_name=tbl_to_names&table_row_name=workcube_to_row&field_grp_id=to_grp_ids&field_wgrp_id=to_wgrp_ids&function_row_name=workcube_to_delRow</cfoutput>&comp_id_list='+document.getElementById('comp_id_list').value);">
							<i class="fa fa-plus"></i></a>
						</th>
					</cfif>					
					<th><cfoutput>#attributes.to_dsp_name#</cfoutput></th>					
				</cfif>
				<cfif isdefined("attributes.cc_dsp_name")>
					<cfif not isDefined("attributes.is_detail")>
						<th width="20">
							<a href="javascript://" class="none-decoration" onclick="openBoxDraggable('widgetloader?widget_load=listMultiUsers&style=maxi&isbox=1<cfoutput>&title=#boxTitle##main_str_url_cc#&table_name=tbl_cc_names&row_count=tbl_cc_names_row_count&select_list=#select_list#&table_row_name=workcube_cc_row&field_grp_id=cc_grp_ids&field_wgrp_id=cc_wgrp_ids&function_row_name=workcube_cc_delRow</cfoutput>');">
							<i class="fa fa-plus"></i></a>
						</th>	
					</cfif>		
					<th><cfoutput>#attributes.cc_dsp_name#</cfoutput></th>			
				</cfif>
				<cfif isdefined("attributes.cc2_dsp_name")>
					<th width="20">
						<a href="javascript://" onclick="openBoxDraggable('widgetloader?widget_load=listMultiUsers&style=maxi&isbox=1<cfoutput>&title=#boxTitle##main_str_url_cc2#&table_name=tbl_cc2_names&row_count=tbl_cc2_names_row_count&select_list=#select_list#&table_row_name=workcube_cc2_row&field_grp_id=cc2_grp_ids&field_wgrp_id=cc2_wgrp_ids&function_row_name=workcube_cc2_delRow</cfoutput>');">
						<i class="fa fa-plus"></i></a>
					</th>					
					<th><cfoutput>#attributes.cc2_dsp_name#</cfoutput></th>
				</cfif>	
			</tr>
		</thead>
		
		
					<cfif isdefined("attributes.to_dsp_name")>	
							<cfset to_list = "">
							<cfif isdefined("get_values.to_emp")>
								<cfif attributes.data_type eq 1>
									<cfset int_emp_list = ListSort(get_values.to_emp,"textnocase")>
								<cfelseif attributes.data_type eq 2>
									<cfset int_emp_list = ListSort(ValueList(get_values.to_emp),"numeric","asc")>
								</cfif>
							<cfelse>
								<cfset int_emp_list="">
							</cfif>
							<cfif isdefined("get_values.to_pos")>
								<cfif attributes.data_type eq 1>
									<cfset int_pos_list=ListSort(get_values.to_pos,"textnocase")>
								<cfelseif attributes.data_type eq 2>
									<cfset int_pos_list=ListSort(ValueList(get_values.to_pos),"numeric","asc")>
								</cfif>
							<cfelse>
								<cfset int_pos_list="">
							</cfif>
							<cfif isdefined("get_values.to_pos_code")>
								<cfif attributes.data_type eq 1>
									<cfset int_poscode_list = ListSort(get_values.to_pos_code,"textnocase")>
								<cfelseif attributes.data_type eq 2>
									<cfset int_poscode_list = ListSort(ValueList(get_values.to_pos_code),"numeric","asc")>
								</cfif>
							<cfelse>
								<cfset int_poscode_list="">
							</cfif>
							<cfif isdefined("get_values.to_par")>
								<cfif attributes.data_type eq 1>
									<cfset int_par_list = ListSort(get_values.to_par,"textnocase")>
								<cfelseif attributes.data_type eq 2>
									<cfset int_par_list = ListSort(ValueList(get_values.to_par),"numeric","asc")>
								</cfif>
							<cfelse>
								<cfset int_par_list="">
							</cfif>
							
							<cfif isdefined("get_values.to_comp")>
								<cfif attributes.data_type eq 1>
									<cfset int_comp_list = ListSort(get_values.to_comp,"textnocase")>
								<cfelseif attributes.data_type eq 2>
									<cfset int_comp_list = ListSort(ValueList(get_values.to_comp),"numeric","asc")>
								</cfif>									
							<cfelse>
								<cfset int_comp_list="">
							</cfif>
							<cfif isdefined("get_values.to_con")>
								<cfif attributes.data_type eq 1>
									<cfset int_con_list = ListSort(get_values.to_con,"textnocase")>
								<cfelseif attributes.data_type eq 2>
									<cfset int_con_list = ListSort(ValueList(get_values.to_con),"numeric","asc")>
								</cfif>									
							<cfelse>
								<cfset int_con_list="">
							</cfif>
							<cfif isdefined("get_values.to_group")>
								<cfif attributes.data_type eq 1>
									<cfset int_grp_list = ListSort(get_values.to_group,"textnocase")>
								<cfelseif attributes.data_type eq 2>
									<cfset int_grp_list = ListSort(ValueList(get_values.to_group),"numeric","asc")>
								</cfif>									
							<cfelse>
								<cfset int_grp_list="">
							</cfif>
							<cfif isdefined("get_values.to_wrkgroup")>
								<cfif attributes.data_type eq 1>
									<cfset int_wgrp_list = ListSort(get_values.to_wrkgroup,"textnocase")>
								<cfelseif attributes.data_type eq 2>
									<cfset int_wgrp_list = ListSort(ValueList(get_values.to_wrkgroup),"numeric","asc")>
								</cfif>									
							<cfelse>
								<cfset int_wgrp_list="">
							</cfif>
							<cfif listlen(int_emp_list) or listlen(int_pos_list) or listlen(int_poscode_list)>
								<cfquery name="GET_EMP_LIST" datasource="#CALLER.DSN#">
									SELECT 
									<cfif attributes.to_title eq 1>
										EMPLOYEES.EMPLOYEE_NAME NAME,
										EMPLOYEES.EMPLOYEE_SURNAME SURNAME,
										EMPLOYEE_POSITIONS.POSITION_NAME TITLE,
									<cfelse>
										EMPLOYEE_POSITIONS.POSITION_NAME NAME,
										'' SURNAME,
										'' TITLE,
									</cfif>
										1 ORDER_ID,
										EMPLOYEES.EMPLOYEE_ID ID_1,
										EMPLOYEE_POSITIONS.POSITION_ID ID_2,
										EMPLOYEE_POSITIONS.POSITION_CODE ID_3,
										-1 ID_4,
										-1 ID_5,
										-1 ID_6,
										'to_emp_ids' input1,
										'to_pos_ids' input2,
										'to_pos_codes' input3,
										'to_par_ids' input4,
										'to_comp_ids' input5,
										'to_cons_ids' input6
									FROM
										EMPLOYEES LEFT JOIN
										EMPLOYEE_POSITIONS 
										ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID
										AND EMPLOYEE_POSITIONS.IS_MASTER = 1 
									WHERE 
										<cfif listlen(int_emp_list)>EMPLOYEES.EMPLOYEE_ID IN(#int_emp_list#)</cfif>
										<cfif listlen(int_pos_list)>EMPLOYEE_POSITIONS.POSITION_ID IN (#int_pos_list#)</cfif> 
										<cfif listlen(int_poscode_list)>EMPLOYEE_POSITIONS.POSITION_CODE IN (#int_poscode_list#)</cfif>
									ORDER BY
										NAME,
										SURNAME,
										TITLE
								</cfquery>
							</cfif>
							<cfif listlen(int_par_list) or  listlen(int_comp_list)><!--- Burada Degisiklik olucak.. --->
								<cfquery name="GET_COMP_LIST"  datasource="#CALLER.DSN#">
									<cfif listlen(int_comp_list) and not listlen(int_par_list)><!--- Sadece Companyler ise.. --->
										SELECT 
											FULLNAME NAME, 
											'' SURNAME,
											'' TITLE,
											2 ORDER_ID,
											-1 ID_1,
											-1 ID_2,
											-1 ID_3,
											'' ID_4,
											COMPANY_ID  ID_5,
											-1 ID_6
											,'to_emp_ids' input1,
											'to_pos_ids' input2,
											'to_pos_codes' input3,
											'to_par_ids' input4,
											'to_comp_ids' input5,
											'to_cons_ids' input6
										FROM
											COMPANY 
										WHERE 
											COMPANY.COMPANY_ID IN (#int_comp_list#)
									<cfelse><!--- company ile beraber partnerlarda listeleniyorsa.. --->
										SELECT 
										<cfif attributes.to_title eq 1>
											COMPANY_PARTNER_NAME NAME,
											COMPANY_PARTNER_SURNAME SURNAME,
											NICKNAME TITLE,
										<cfelseif attributes.to_title eq 3>
											NICKNAME NAME,
											'' SURNAME,
											'' TITLE,
										<cfelse>
											FULLNAME NAME, 
											'' SURNAME,
											'' TITLE,
										</cfif>
											2 ORDER_ID,
											-1 ID_1,
											-1 ID_2,
											-1 ID_3,
											COMPANY_PARTNER.PARTNER_ID ID_4,
											COMPANY_PARTNER.COMPANY_ID ID_5,
											-1 ID_6
											,'to_emp_ids' input1,
											'to_pos_ids' input2,
											'to_pos_codes' input3,
											'to_par_ids' input4,
											'to_comp_ids' input5,
											'to_cons_ids' input6
										FROM
											COMPANY_PARTNER,
											COMPANY 
										WHERE 
											COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID  AND 
										<cfif listlen(int_par_list)>
											COMPANY_PARTNER.PARTNER_ID IN (#int_par_list#)
										<cfelseif listlen(int_comp_list)>
											COMPANY.COMPANY_ID IN (#int_comp_list#)
										</cfif>
									</cfif>
									ORDER BY
										NAME,
										SURNAME,
										TITLE
								</cfquery>
							</cfif>
							<cfif listlen(int_con_list)>
								<cfquery name="GET_CON_LIST"  datasource="#CALLER.DSN#">
									SELECT 
										CONSUMER_NAME NAME,
										CONSUMER_SURNAME SURNAME,
										'' TITLE,
										3 ORDER_ID,
										-1 ID_1,
										-1 ID_2,
										-1 ID_3,
										-1 ID_4,
										-1 ID_5,
										CONSUMER_ID ID_6,
										'to_emp_ids' input1,
										'to_pos_ids' input2, 
										'to_pos_codes' input3,
										'to_par_ids' input4,
										'to_comp_ids' input5,
										'to_cons_ids' input6
									FROM
										CONSUMER 
									WHERE 
										CONSUMER_ID IN (#int_con_list#)
									ORDER BY
										NAME,
										SURNAME,
										TITLE
								</cfquery>
							</cfif>
							<cfif listlen(int_emp_list) or listlen(int_pos_list) or listlen(int_poscode_list) or listlen(int_par_list) or listlen(int_con_list) or listlen(int_comp_list)>
								<cfquery name="GET_ALL_PEOPLE" dbtype="query">
									<cfif listlen(int_emp_list) or listlen(int_pos_list) or listlen(int_poscode_list)>
										SELECT
											<cfif caller.database_type is 'MSSQL'>
											NAME + ' ' + SURNAME NAME,
											<cfelseif caller.database_type is 'DB2'>
											NAME || ' ' || SURNAME NAME,
											</cfif>
											TITLE,
											ORDER_ID,
											ID_1,
											ID_2,
											ID_3,
											ID_4,
											ID_5,
											ID_6,
											input1,
											input2,
											input3,
											input4,
											input5,
											input6
										FROM
											GET_EMP_LIST
									</cfif>
									<cfif listlen(int_par_list) or listlen(int_comp_list)>
										<cfif listlen(int_emp_list) or listlen(int_pos_list) or listlen(int_poscode_list)>
										UNION
										</cfif>
										SELECT 
											<cfif caller.database_type is 'MSSQL'>
											NAME + ' ' + SURNAME NAME,
											<cfelseif caller.database_type is 'DB2'>
											NAME || ' ' || SURNAME NAME,
											</cfif>
											TITLE,
											ORDER_ID,
											ID_1,
											ID_2,
											ID_3,
											ID_4,
											ID_5,
											ID_6,
											input1,
											input2,
											input3,
											input4,
											input5,
											input6
										FROM
											GET_COMP_LIST
									</cfif>
									<cfif listlen(int_con_list)>
										<cfif listlen(int_emp_list) or listlen(int_pos_list) or listlen(int_poscode_list) or listlen(int_par_list)>
										UNION
										</cfif>
										SELECT
											<cfif caller.database_type is 'MSSQL'>
											NAME + ' ' + SURNAME NAME,
											<cfelseif caller.database_type is 'DB2'>
											NAME || ' ' || SURNAME NAME,
											</cfif>
											TITLE,
											ORDER_ID,
											ID_1,
											ID_2,
											ID_3,
											ID_4,
											ID_5,
											ID_6,
											input1,
											input2,
											input3,
											input4,
											input5,
											input6
										FROM
											GET_CON_LIST															
									</cfif>
									<cfif listlen(int_emp_list) or listlen(int_pos_list) or listlen(int_poscode_list)>
										ORDER BY
											ORDER_ID
									<cfelseif listlen(int_par_list) or listlen(int_comp_list)>
										ORDER BY
											ORDER_ID
									<cfelseif listlen(int_con_list)>
										ORDER BY
											ORDER_ID
									</cfif>
								</cfquery>
							<cfelse>
								<cfset get_all_people.recordcount=0>
							</cfif>
							<tbody id="tbl_to_names" name="tbl_to_names" cellspacing="0">
								<cfset int_row=0>
								<cfif isdefined("get_all_people") and get_all_people.recordcount>
									<cfif isdefined('attributes.from_purchase_offer')>
										<cfset member_id = "">
										<cfquery name="GET_FOR_OFFER_IDS" datasource="#caller.DSN3#">
											SELECT 
												FOR_OFFER_ID,
												OFFER_ID,
												OFFER_NUMBER,
												OFFER_TO_PARTNER,
												OFFER_TO,
												OFFER_TO_CONSUMER
											FROM 
												OFFER 
											WHERE 
												FOR_OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
										</cfquery>
									</cfif>
									<cfoutput query="get_all_people">
										<cfset int_row=currentrow>
										<tr id="workcube_to_row#int_row#" name="workcube_to_row#int_row#" style="" height="18">
											<cfif isdefined('attributes.from_purchase_offer')>
												<cfif id_4 neq -1><cfset member_id = "partner_ids=#id_4#"></cfif>
												<cfif id_5 neq -1><cfset member_id = "#member_id#&company_ids=#id_5#"></cfif>
												<cfif id_6 neq -1><cfset member_id = "consumer_ids=#id_6#"></cfif>
												<cfif len(member_id)><!--- cariden daha önce teklif istenip istenmedigini kontrol eder  --->
													<cfquery name="GET_FOR_OFFER_ID" dbtype="query">
														SELECT 
															FOR_OFFER_ID,
															OFFER_ID,
															OFFER_NUMBER
														FROM 
															GET_FOR_OFFER_IDS 
														WHERE 
															FOR_OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND 
															<cfif id_4 neq -1>
																OFFER_TO_PARTNER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#id_4#,%">
															<cfelseif id_5 neq -1>
																OFFER_TO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#id_5#,%">
															<cfelseif id_6 neq -1>
																OFFER_TO_CONSUMER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#id_6#,%">
															</cfif>
													</cfquery>
												</cfif>
											</cfif>
										<cfif not isDefined("attributes.is_detail")>
											<td nowrap="nowrap" style="vertical-align:top;">
												<input type="hidden" name="#input1#" id="#input1#" value="<cfif ID_1 neq -1>#ID_1#</cfif>">
												<input type="hidden" name="#input2#" id="#input2#" value="<cfif ID_2 neq -1>#ID_2#</cfif>">
												<input type="hidden" name="#input3#" id="#input3#" value="<cfif ID_3 neq -1>#ID_3#</cfif>">
												<input type="hidden" name="#input4#" id="#input4#" value="<cfif ID_4 neq -1>#ID_4#</cfif>">
												<input type="hidden" name="#input5#" id="#input5#" value="<cfif ID_5 neq -1>#ID_5#</cfif>">
												<input type="hidden" name="#input6#" id="#input6#" value="<cfif ID_6 neq -1>#ID_6#</cfif>">
												<cfif len(ID_1)>
													<cfset int_id=ID_1>
												<cfelseif len(ID_2)>
													<cfset int_id=ID_2>
												<cfelse>
													<cfset int_id=ID_5>
												</cfif>
												<cfif not (isdefined('attributes.from_purchase_offer') and len(member_id) and get_for_offer_id.recordcount) and not isDefined("attributes.is_detail")>
													<a href="javascript://" class="none-decoration" onclick="workcube_to_delRow(#int_row#,#int_id#);"><i class="fa fa-minus"></i></a>								
												</cfif>
											</td>
										</cfif>
											<td>
												<cfscript>
													custag_link_str = '';
													//custag_detay='';
													if(isDefined('session.ep.userid'))
													{
														if(ID_1 neq -1) custag_link_str = 'objects.popup_emp_det&emp_id=' & ID_1;
														if(ID_6 neq -1) custag_link_str = 'objects.popup_con_det&con_id=' &  ID_6 ;
														if(ID_4 neq -1)
														{
															custag_link_str = 'objects.popup_com_det&company_id='&  ID_5 & '&partner_id=' & ID_4;
														}
													}
													else
													{
														if(ID_1 neq -1) custag_link_str = 'objects2.popup_emp_det&emp_id=' & ID_1;
														if(ID_6 neq -1) custag_link_str = 'objects2.popup_con_det&con_id=' &  ID_6 ;
														if(ID_4 neq -1)
														{
															custag_link_str = 'objects2.popup_com_det&company_id='&  ID_5 & '&partner_id=' & ID_4;
														}										
													}				
												</cfscript>
												<cfif isdefined('session.ep.userid')>
													<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#custag_link_str#','list');" class="tableyazi">#name#</a>
												<cfelseif isdefined('session.pp.userid')>
													#name#
												<cfelse>
													<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#custag_link_str#','list');" class="tableyazi">#name#</a>									
												</cfif>
												<cfif len(title)>(#title#)</cfif>
											</td>
											<!--- satınalma teklifi : print ve teklif ekleme sayfalarina default cari degerlerini getirir --->
											<cfif isdefined('attributes.from_purchase_offer')>
												<td nowrap="nowrap" style="vertical-align:top;">
													<cfif isDefined('caller.x_multiple_sub_offers') and caller.x_multiple_sub_offers eq 1>
														<cfloop query="get_for_offer_id">
															<a href="#request.self#?fuseaction=purchase.list_offer&event=upd&offer_id=#get_for_offer_id.offer_id#" class="tableyazi">#get_for_offer_id.offer_number#</a><br/>
														</cfloop>
													<cfelse>
														<a href="#request.self#?fuseaction=purchase.list_offer&event=upd&offer_id=#get_for_offer_id.offer_id#" class="tableyazi">#get_for_offer_id.offer_number#</a><br/>
													</cfif>
												</td>
												<td style="vertical-align:top;"><a href="javascript://" class="tableyazi" onclick="control_related_offer(#get_for_offer_id.recordcount#,'#member_id#')"><i class="fa fa-plus"></i></a></td>
												<cfif attributes.print_all eq 2 and not get_for_offer_id.recordcount>
													<td style="vertical-align:top;"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.action_id#&print_type=90&keyword=#member_id#','page');"><img src="/images/print2.gif" border="0" title="<cf_get_lang_main no='62.Yazdır'>"></a></td>
												<cfelse>
													<td style="vertical-align:top;"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=<cfif attributes.print_all is 1>#attributes.action_id#<cfelse>#get_for_offer_id.offer_id#</cfif>&print_type=90&keyword=#member_id#','page');"><img src="/images/print2.gif" border="0" title="<cf_get_lang_main no='62.Yazdır'>"></a></td>
												</cfif>
											</cfif>
											<!--- satınalma teklifi : print ve ekleme sayfalarina default cari degerlerini getirir --->
										</tr>							
									</cfoutput>
								</cfif>
								<input type="hidden" name="tbl_to_names_row_count" id="tbl_to_names_row_count" value="<cfoutput>#int_row#</cfoutput>">
							</tbody>						
						
					</cfif>
					<cfif isdefined("attributes.cc_dsp_name")>
							<cfif isdefined("get_values.cc_emp")>
								<cfif attributes.data_type eq 1><cfset int_emp_list = ListSort(get_values.cc_emp,"textnocase")>
								<cfelseif attributes.data_type eq 2><cfset int_emp_list = ListSort(ValueList(get_values.cc_emp),"numeric","asc")>
								</cfif>						
							<cfelse>
								<cfset int_emp_list="">
							</cfif>
							
							<cfif isdefined("get_values.cc_pos")>
								<cfif attributes.data_type eq 1><cfset int_pos_list = ListSort(get_values.cc_pos,"textnocase")>
								<cfelseif attributes.data_type eq 2><cfset int_pos_list = ListSort(ValueList(get_values.cc_pos),"numeric","asc")>
								</cfif>						
							<cfelse>
								<cfset int_pos_list="">
							</cfif>
							
							<cfif isdefined("get_values.cc_pos_code")>
								<cfif attributes.data_type eq 1><cfset int_poscode_list = ListSort(get_values.cc_pos_code,"textnocase")>
								<cfelseif attributes.data_type eq 2><cfset int_poscode_list = ListSort(ValueList(get_values.cc_pos_code),"numeric","asc")>
								</cfif>						
							<cfelse>
								<cfset int_poscode_list="">
							</cfif>
							
							<cfif isdefined("get_values.cc_par")>
								<cfif attributes.data_type eq 1><cfset int_par_list = ListSort(get_values.cc_par,"textnocase")>
								<cfelseif attributes.data_type eq 2><cfset int_par_list = ListSort(ValueList(get_values.cc_par),"numeric","asc")>
								</cfif>						
							<cfelse>
								<cfset int_par_list="">
							</cfif>
							
							<cfif isdefined("get_values.cc_comp")>
								<cfif attributes.data_type eq 1><cfset int_comp_list = ListSort(get_values.cc_comp,"textnocase")>
								<cfelseif attributes.data_type eq 2><cfset int_comp_list = ListSort(ValueList(get_values.cc_comp),"numeric","asc")>
								</cfif>
							<cfelse>
								<cfset int_comp_list="">
							</cfif>
							
							<cfif isdefined("get_values.cc_con")>
								<cfif attributes.data_type eq 1><cfset int_con_list = ListSort(get_values.cc_con,"textnocase")>
								<cfelseif attributes.data_type eq 2><cfset int_con_list = ListSort(ValueList(get_values.cc_con),"numeric","asc")>
								</cfif>
							<cfelse>
								<cfset int_con_list="">
							</cfif>
							
							<cfif isdefined("get_values.cc_wrkgroup")>
								<cfif attributes.data_type eq 1><cfset int_wgrp_list = ListSort(get_values.cc_wrkgroup,"textnocase")>
								<cfelseif attributes.data_type eq 2><cfset int_wgrp_list = ListSort(ValueList(get_values.cc_wrkgroup),"numeric","asc")>
								</cfif>							
							<cfelse>
								<cfset int_wgrp_list="">
							</cfif>
							
							<cfif isdefined("get_values.cc_group")>
								<cfif attributes.data_type eq 1><cfset int_grp_list = ListSort(get_values.cc_group,"textnocase")>
								<cfelseif attributes.data_type eq 2><cfset int_grp_list = ListSort(ValueList(get_values.cc_group),"numeric","asc")>
								</cfif>							
							<cfelse>
								<cfset int_grp_list="">
							</cfif>
							
							<cfif listlen(int_emp_list) or listlen(int_pos_list) or listlen(int_poscode_list)>
								<cfquery name="GET_EMP_LIST_CC" datasource="#caller.dsn#">
									SELECT 
									<cfif attributes.to_title eq 1>
										EMPLOYEE_NAME NAME, 
										EMPLOYEE_SURNAME SURNAME, 
										POSITION_NAME TITLE,
									<cfelse>
										POSITION_NAME NAME,
										'' SURNAME,
										'' TITLE,
									</cfif> 
										1 ORDER_ID,
										EMPLOYEE_ID ID_1,
										POSITION_ID ID_2,
										POSITION_CODE ID_3,
										-1 ID_4,
										-1 ID_5,
										-1 ID_6,
										'cc_emp_ids' input1,
										'cc_pos_ids' input2,
										'cc_pos_codes' input3,
										'cc_par_ids' input4,
										'cc_comp_ids' input5,
										'cc_cons_ids' input6
									FROM
										EMPLOYEE_POSITIONS 
									WHERE 
										<cfif listlen(int_emp_list)>EMPLOYEE_ID IN (#int_emp_list#) AND IS_MASTER = 1</cfif> 
										<cfif listlen(int_pos_list)>POSITION_ID IN (#int_pos_list#)</cfif> 
										<cfif listlen(int_poscode_list)>POSITION_CODE IN (#int_poscode_list#)</cfif>
									ORDER BY
										NAME,
										SURNAME,
										TITLE
								</cfquery>
							<cfelse>
								<cfset get_emp_list_cc.recordcount = 0>
							</cfif>
							<cfif listlen(int_par_list)>
								<cfquery name="GET_COMP_LIST_CC"  datasource="#caller.dsn#">
									SELECT 
									<cfif attributes.cc_title eq 1>
										COMPANY_PARTNER_NAME NAME,
										COMPANY_PARTNER_SURNAME SURNAME,
										NICKNAME TITLE,
									<cfelse>
										FULLNAME NAME,
										'' SURNAME,
										'' TITLE,
									</cfif>
										2 ORDER_ID,
										-1 ID_1,
										-1 ID_2,
										-1 ID_3,
										COMPANY_PARTNER.PARTNER_ID ID_4,
										COMPANY_PARTNER.COMPANY_ID ID_5,
										-1 ID_6,
										'cc_emp_ids' input1,
										'cc_pos_ids' input2,
										'cc_pos_codes' input3,
										'cc_par_ids' input4,
										'cc_comp_ids' input5,
										'cc_cons_ids' input6
									FROM 
										COMPANY_PARTNER,
										COMPANY 
									WHERE 
										COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID  AND 
										COMPANY_PARTNER.PARTNER_ID IN (#int_par_list#)
									ORDER BY
										NAME,
										SURNAME,
										TITLE
								</cfquery>
							<cfelse>
								<cfset get_comp_list_cc.recordcount = 0>							
							</cfif>
							<cfif listlen(int_con_list)>
								<cfquery name="GET_CON_LIST_CC"  datasource="#caller.dsn#">
									SELECT 
										CONSUMER_NAME NAME,
										CONSUMER_SURNAME SURNAME,
										'' TITLE,
										3 ORDER_ID,
										-1 ID_1,
										-1 ID_2,
										-1 ID_3,
										-1 ID_4,
										-1 ID_5,
										CONSUMER_ID ID_6,
										'cc_emp_ids' input1,
										'cc_pos_ids' input2,
										'cc_pos_codes' input3,
										'cc_par_ids' input4,
										'cc_comp_ids' input5,
										'cc_cons_ids' input6
									FROM
										CONSUMER 
									WHERE 
										CONSUMER_ID IN (#int_con_list#)
									ORDER BY
										NAME,
										SURNAME,
										TITLE
								</cfquery>
							<cfelse>
								<cfset get_con_list_cc.recordcount = 0>		
							</cfif>
						<cfif get_emp_list_cc.recordcount or get_comp_list_cc.recordcount or get_con_list_cc.recordcount>
							<cfquery name="GET_ALL_PEOPLE_CC" dbtype="query">
								<cfif get_emp_list_cc.recordcount>
									SELECT
									<cfif caller.database_type is 'MSSQL'>
										NAME + ' ' + SURNAME NAME,
									<cfelseif caller.database_type is 'DB2'>
										NAME || ' ' || SURNAME NAME,
									</cfif>
										TITLE,
										ORDER_ID,
										ID_1,
										ID_2,
										ID_3,
										ID_4,
										ID_5,
										ID_6,
										input1,
										input2,
										input3,
										input4,
										input5,
										input6
									FROM
										get_emp_list_cc
								</cfif>
								<cfif get_comp_list_cc.recordcount>
									<cfif get_emp_list_cc.recordcount>
									UNION 
									</cfif>
									SELECT
									<cfif caller.database_type is 'MSSQL'>
										NAME + ' ' + SURNAME NAME,
									<cfelseif caller.database_type is 'DB2'>
										NAME || ' ' || SURNAME NAME,
									</cfif>
										TITLE,
										ORDER_ID,
										ID_1,
										ID_2,
										ID_3,
										ID_4,
										ID_5,
										ID_6,
										input1,
										input2,
										input3,
										input4,
										input5,
										input6
									FROM
										get_comp_list_cc
								</cfif>
								<cfif get_con_list_cc.recordcount>
									<cfif get_emp_list_cc.recordcount or get_comp_list_cc.recordcount>
									UNION
									</cfif>
									SELECT
										<cfif caller.database_type is 'MSSQL'>
										NAME + ' ' + SURNAME NAME,
										<cfelseif caller.database_type is 'DB2'>
										NAME || ' ' || SURNAME NAME,
										</cfif>
										TITLE,
										ORDER_ID,
										ID_1,
										ID_2,
										ID_3,
										ID_4,
										ID_5,
										ID_6,
										input1,
										input2,
										input3,
										input4,
										input5,
										input6
									FROM
										get_con_list_cc												
								</cfif>
								<cfif get_emp_list_cc.recordcount>
									ORDER BY
										ORDER_ID
								<cfelseif get_comp_list_cc.recordcount>
									ORDER BY
										ORDER_ID
								<cfelseif get_con_list_cc.recordcount>
									ORDER BY
										ORDER_ID
								</cfif>
							</cfquery>
						<cfelse>
							<cfset get_all_people_cc.recordcount=0>
						</cfif>
						<cfset int_row = 0>
						<tbody id="tbl_cc_names" name="tbl_cc_names">
							<cfif get_all_people_cc.recordcount>
								<cfoutput query="get_all_people_cc">
									<cfset int_row=currentrow-1>
									<tr id="workcube_cc_row#int_row#" name="workcube_cc_row#int_row#"  style="display='';">
										<cfif not isDefined("attributes.is_detail")>
											<td>
												<input type="hidden" name="#input1#" id="#input1#" value="<cfif ID_1 neq -1>#ID_1#</cfif>">
												<input type="hidden" name="#input2#" id="#input2#" value="<cfif ID_2 neq -1>#ID_2#</cfif>">
												<input type="hidden" name="#input3#" id="#input3#" value="<cfif ID_3 neq -1>#ID_3#</cfif>">
												<input type="hidden" name="#input4#" id="#input4#" value="<cfif ID_4 neq -1>#ID_4#</cfif>">
												<input type="hidden" name="#input5#" id="#input5#" value="<cfif ID_5 neq -1>#ID_5#</cfif>">
												<input type="hidden" name="#input6#" id="#input6#" value="<cfif ID_6 neq -1>#ID_6#</cfif>">
													<cfif len(ID_1)>
														<cfset int_id=ID_1>
													<cfelseif len(ID_2)>
														<cfset int_id=ID_2>
													<cfelse>
														<cfset int_id=ID_5>
													</cfif>
												<a href="javascript://" class="none-decoration" onclick="workcube_cc_delRow(#int_row#,#int_id#);"><i class="fa fa-minus"></i></a>
											</td>
										</cfif>
										<td>
											<cfscript>
												custag_link_str = '';
												//custag_detay='';
												// if(ID_1 neq -1) custag_link_str = 'objects.popup_emp_det&emp_id=' & ID_1;
												// if(ID_6 neq -1) custag_link_str = 'objects.popup_con_det&con_id=' &  ID_6 ;
												if(isDefined('session.ep.userid'))
												{
													if(ID_1 neq -1) custag_link_str = 'objects.popup_emp_det&emp_id=' & ID_1;
													if(ID_6 neq -1) custag_link_str = 'objects.popup_con_det&con_id=' &  ID_6 ;
													if(ID_4 neq -1)
													{
														custag_link_str = 'objects.popup_com_det&company_id='&  ID_5 & '&partner_id=' & ID_4;
													}
												}
												else
												{
													if(ID_1 neq -1) custag_link_str = 'objects2.popup_emp_det&emp_id=' & ID_1;
													if(ID_6 neq -1) custag_link_str = 'objects2.popup_con_det&con_id=' &  ID_6 ;	
													if(ID_4 neq -1)
													{
														custag_link_str = 'objects2.popup_com_det&company_id='&  ID_5 & '&partner_id=' & ID_4;
													}									
												}
												
											</cfscript>
											<!---<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=#custag_link_str#','list');" class="tableyazi">#name#</a>--->
											<cfif isdefined('session.ep.userid')>
												<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#custag_link_str#','list');" class="tableyazi">#name#</a>
											<cfelseif isdefined('session.pp.userid')>
												#name#
											<cfelse>
												<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#custag_link_str#','list');" class="tableyazi">#name#</a>									
											</cfif>
											<cfif len(title)>(#title#)</cfif>
										</td>
									</tr>							
								</cfoutput>
							</cfif>
							<cfset cus_tag_max_row_cc = get_all_people_cc.recordcount>
							<input type="hidden" name="tbl_cc_names_row_count" id="tbl_cc_names_row_count" value="<cfoutput>#int_row#</cfoutput>">
							<cfif not isdefined('attributes.is_detail')>
								<cfif get_all_people_cc.recordcount>
									<tr id="hepsini_sil_id2">
										<td colspan="3"><a href="javascript://" onclick="hepsini_sil(2)"><cfoutput>#caller.getLang('main',2239)#</cfoutput></a></td><!---Hepsini Sil--->
									</tr>
								</cfif>
							</cfif>
						</tbody>
					
					</cfif>
					<cfif isdefined("attributes.cc2_dsp_name")>
							<cfif isdefined("get_values.cc2_emp")>
								<cfif attributes.data_type eq 1><cfset int_emp_list = ListSort(get_values.cc2_emp,"textnocase")>
								<cfelseif attributes.data_type eq 2><cfset int_emp_list = ListSort(ValueList(get_values.cc2_emp),"numeric","asc")>
								</cfif>						
							<cfelse>
								<cfset int_emp_list="">
							</cfif>
							
							<cfif isdefined("get_values.cc2_pos")>
								<cfif attributes.data_type eq 1><cfset int_pos_list = ListSort(get_values.cc2_pos,"textnocase")>
								<cfelseif attributes.data_type eq 2><cfset int_pos_list = ListSort(ValueList(get_values.cc2_pos),"numeric","asc")>
								</cfif>						
							<cfelse>
								<cfset int_pos_list="">
							</cfif>
							
							<cfif isdefined("get_values.cc2_pos_code")>
								<cfif attributes.data_type eq 1><cfset int_poscode_list = ListSort(get_values.cc2_pos_code,"textnocase")>
								<cfelseif attributes.data_type eq 2><cfset int_poscode_list = ListSort(ValueList(get_values.cc2_pos_code),"numeric","asc")>
								</cfif>						
							<cfelse>
								<cfset int_poscode_list="">
							</cfif>
							
							<cfif isdefined("get_values.CC2_PAR")>
								<cfif attributes.data_type eq 1><cfset int_par_list = ListSort(get_values.CC2_PAR,"textnocase")>
								<cfelseif attributes.data_type eq 2><cfset int_par_list = ListSort(ValueList(get_values.CC2_PAR),"numeric","asc")>
								</cfif>						
							<cfelse><cfset int_par_list=""></cfif>
							
							<cfif isdefined("get_values.cc2_comp")>
								<cfif attributes.data_type eq 1><cfset int_comp_list = ListSort(get_values.cc2_comp,"textnocase")>
								<cfelseif attributes.data_type eq 2><cfset int_comp_list = ListSort(ValueList(get_values.cc2_comp),"numeric","asc")>
								</cfif>
							<cfelse>
								<cfset int_comp_list="">
							</cfif>
							
							<cfif isdefined("get_values.cc2_con")>
								<cfif attributes.data_type eq 1><cfset int_con_list = ListSort(get_values.cc2_con,"textnocase")>
								<cfelseif attributes.data_type eq 2><cfset int_con_list = ListSort(ValueList(get_values.cc2_con),"numeric","asc")>
								</cfif>
							<cfelse>
								<cfset int_con_list="">
							</cfif>
							
							<cfif isdefined("get_values.cc2_wrkgroup")>
								<cfif attributes.data_type eq 1><cfset int_wgrp_list = ListSort(get_values.cc2_wrkgroup,"textnocase")>
								<cfelseif attributes.data_type eq 2><cfset int_wgrp_list = ListSort(ValueList(get_values.cc2_wrkgroup),"numeric","asc")>
								</cfif>							
							<cfelse>
								<cfset int_wgrp_list="">
							</cfif>
							
							<cfif isdefined("get_values.cc2_group")>
								<cfif attributes.data_type eq 1><cfset int_grp_list = ListSort(get_values.cc2_group,"textnocase")>
								<cfelseif attributes.data_type eq 2><cfset int_grp_list = ListSort(ValueList(get_values.cc2_group),"numeric","asc")>
								</cfif>							
							<cfelse>
								<cfset int_grp_list="">
							</cfif>
							
							<cfif listlen(int_emp_list) or listlen(int_pos_list) or listlen(int_poscode_list)>
								<cfquery name="GET_EMP_LIST_CC2"  datasource="#caller.dsn#">
									SELECT 
									<cfif attributes.to_title eq 1>
										EMPLOYEE_NAME NAME, 
										EMPLOYEE_SURNAME SURNAME,
										POSITION_NAME TITLE,
									<cfelse>
										POSITION_NAME NAME,
										'' SURNAME,
										'' TITLE,
									</cfif> 
										1 ORDER_ID,
										EMPLOYEE_ID ID_1,
										POSITION_ID ID_2,
										POSITION_CODE ID_3,
										-1 ID_4,
										-1 ID_5,
										-1 ID_6,
										'cc2_emp_ids' input1,
										'cc2_pos_ids' input2,
										'cc2_pos_codes' input3,
										'cc2_par_ids' input4,
										'cc2_comp_ids' input5,
										'cc2_cons_ids' input6
									FROM
										EMPLOYEE_POSITIONS 
									WHERE 
										<cfif listlen(int_emp_list)>EMPLOYEE_ID IN (#int_emp_list#) AND IS_MASTER = 1</cfif> 
										<cfif listlen(int_pos_list)>POSITION_ID IN (#int_pos_list#)</cfif> 
										<cfif listlen(int_poscode_list)>POSITION_CODE IN (#int_poscode_list#)</cfif>
								</cfquery>
							<cfelse>
								<cfset get_emp_list_cc2.recordcount =0>
							</cfif>
							<cfif listlen(int_par_list)>
								<cfquery name="GET_COMP_LIST_CC2" datasource="#caller.dsn#">
									SELECT 
										<cfif attributes.cc2_title eq 1>
											COMPANY_PARTNER_NAME NAME,
											COMPANY_PARTNER_SURNAME SURNAME,
											NICKNAME TITLE,
										<cfelse>
											FULLNAME NAME, 
											'' SURNAME,
											'' TITLE,
										</cfif>
										2 ORDER_ID,
										-1 ID_1,
										-1 ID_2,
										-1 ID_3,
										COMPANY_PARTNER.PARTNER_ID ID_4,
										COMPANY_PARTNER.COMPANY_ID ID_5,
										-1 ID_6,
										'cc2_emp_ids' input1,
										'cc2_pos_ids' input2,
										'cc2_pos_codes' input3,
										'cc2_par_ids' input4,
										'cc2_comp_ids' input5,
										'cc2_cons_ids' input6
									FROM 
										COMPANY_PARTNER,
										COMPANY 
									WHERE 
										COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID  AND 
										COMPANY_PARTNER.PARTNER_ID IN (#int_par_list#)
								</cfquery>
							<cfelse>
								<cfset get_comp_list_cc2.recordcount =0>							
							</cfif>
							<cfif listlen(int_con_list)>
								<cfquery name="GET_CON_LIST_CC2" datasource="#caller.dsn#">
									SELECT 
										CONSUMER_NAME NAME,
										CONSUMER_SURNAME SURNAME,
										'' TITLE,
										3 ORDER_ID,
										-1 ID_1,
										-1 ID_2,
										-1 ID_3,
										-1 ID_4,
										-1 ID_5,
										CONSUMER_ID ID_6,
										'cc2_emp_ids' input1,
										'cc2_pos_ids' input2,
										'cc2_pos_codes' input3,
										'cc2_par_ids' input4,
										'cc2_comp_ids' input5,
										'cc2_cons_ids' input6
									FROM
										CONSUMER 
									WHERE 
										CONSUMER_ID IN (#int_con_list#)
								</cfquery>
							<cfelse>
								<cfset get_con_list_cc2.recordcount =0>							
							</cfif>
						<cfif get_con_list_cc2.recordcount or get_comp_list_cc2.recordcount or get_emp_list_cc2.recordcount>
							<cfquery name="GET_ALL_PEOPLE_CC2" dbtype="query">
								<cfif get_emp_list_cc2.recordcount>
									SELECT
										<cfif caller.database_type is 'MSSQL'>
										NAME + ' ' + SURNAME NAME,
										<cfelseif caller.database_type is 'DB2'>
										NAME || ' ' || SURNAME NAME,
										</cfif>
										TITLE,
										ORDER_ID,
										ID_1,
										ID_2,
										ID_3,
										ID_4,
										ID_5,
										ID_6,
										input1,
										input2,
										input3,
										input4,
										input5,
										input6
									FROM
										get_emp_list_cc2
								</cfif>
								<cfif get_comp_list_cc2.recordcount>
									<cfif get_emp_list_cc2.recordcount>
									UNION 
									</cfif>
									SELECT
										<cfif caller.database_type is 'MSSQL'>
										NAME + ' ' + SURNAME NAME,
										<cfelseif caller.database_type is 'DB2'>
										NAME || ' ' || SURNAME NAME,
										</cfif>
										TITLE,
										ORDER_ID,
										ID_1,
										ID_2,
										ID_3,
										ID_4,
										ID_5,
										ID_6,
										input1,
										input2,
										input3,
										input4,
			
										input5,
										input6
									FROM
										get_comp_list_cc2
								</cfif>
								<cfif get_con_list_cc2.recordcount>
									<cfif get_emp_list_cc2.recordcount or get_comp_list_cc2.recordcount>
									UNION
									</cfif>
									SELECT
										<cfif caller.database_type is 'MSSQL'>
										NAME + ' ' + SURNAME NAME,
										<cfelseif caller.database_type is 'DB2'>
										NAME || ' ' || SURNAME NAME,
										</cfif>
										TITLE,
										ORDER_ID,
										ID_1,
										ID_2,
										ID_3,
										ID_4,
										ID_5,
										ID_6,
										input1,
										input2,
										input3,
										input4,
										input5,
										input6
									FROM
										get_con_list_cc2												
								</cfif>
								<cfif get_emp_list_cc2.recordcount>
									ORDER BY
										ORDER_ID
								<cfelseif get_comp_list_cc2.recordcount>
									ORDER BY
										ORDER_ID	
								<cfelseif get_con_list_cc2.recordcount>
									ORDER BY
										ORDER_ID
								</cfif>
							</cfquery>
						<cfelse>
							<cfset get_all_people_cc2.recordcount=0>
						</cfif>
						<cfset int_row = 0>
						<tbody id="tbl_cc2_names" name="tbl_cc2_names">
							<cfif get_all_people_cc2.recordcount>
								<cfoutput query="get_all_people_cc2">
									<cfset int_row=currentrow-1>
									<tr id="workcube_cc2_row#int_row#" name="workcube_cc2_row#int_row#"  style="display='';">
										<td><input type="hidden" name="#input1#" id="#input1#" value="<cfif ID_1 neq -1>#ID_1#</cfif>">
											<input type="hidden" name="#input2#" id="#input2#" value="<cfif ID_2 neq -1>#ID_2#</cfif>">
											<input type="hidden" name="#input3#" id="#input3#" value="<cfif ID_3 neq -1>#ID_3#</cfif>">
											<input type="hidden" name="#input4#" id="#input4#" value="<cfif ID_4 neq -1>#ID_4#</cfif>">
											<input type="hidden" name="#input5#" id="#input5#" value="<cfif ID_5 neq -1>#ID_5#</cfif>">
											<input type="hidden" name="#input6#" id="#input6#" value="<cfif ID_6 neq -1>#ID_6#</cfif>">
												<cfif len(ID_1)>
													<cfset int_id=ID_1>
												<cfelseif len(ID_2)>
													<cfset int_id=ID_2>
												<cfelse>
													<cfset int_id=ID_5>
												</cfif>
											<a href="javascript://" onclick="workcube_cc2_delRow(#int_row#,#int_id#);"><i class="fa fa-minus"></i></a>
										</td>
										<td>
											<cfscript>
												custag_link_str = '';
												//custag_detay='';
												//if(ID_1 neq -1) custag_link_str = 'objects.popup_emp_det&emp_id=' & ID_1;
												//if(ID_6 neq -1) custag_link_str = 'objects.popup_con_det&con_id=' &  ID_6 ;
												if(isDefined('session.ep.userid'))
												{
													if(ID_1 neq -1) custag_link_str = 'objects.popup_emp_det&emp_id=' & ID_1;
													if(ID_6 neq -1) custag_link_str = 'objects.popup_con_det&con_id=' &  ID_6 ;
													if(ID_4 neq -1)
													{
														custag_link_str = 'objects.popup_com_det&company_id='&  ID_5 & '&partner_id=' & ID_4;
													}
												}
												else
												{
													if(ID_1 neq -1) custag_link_str = 'objects2.popup_emp_det&emp_id=' & ID_1;
													if(ID_6 neq -1) custag_link_str = 'objects2.popup_con_det&con_id=' &  ID_6 ;
													if(ID_4 neq -1)
													{
														custag_link_str = 'objects2.popup_com_det&company_id='&  ID_5 & '&partner_id=' & ID_4;
													}										
												}
												
											</cfscript>
											<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#custag_link_str#','list');"  class="tableyazi">#name#</a>
											
											<cfif len(title)>(#title#)</cfif>
										</td>
									</tr>							
								</cfoutput>
							</cfif>
							<cfset cus_tag_max_row_cc2 = get_all_people_cc2.recordcount>
							<input type="hidden" name="tbl_cc2_names_row_count" id="tbl_cc2_names_row_count" value="<cfoutput>#int_row#</cfoutput>">
							<cfif get_all_people_cc2.recordcount>
								<tr id="hepsini_sil_id3">
									<td colspan="3"><a href="javascript://" onclick="hepsini_sil(3)"><cfoutput>#caller.getLang('main',2239)#</cfoutput></a></td><!---Hepsini Sil--->
								</tr>
							</cfif>
						</tbody>
					</cfif>
			<cfif (isdefined("get_all_people") and get_all_people.recordcount) and (isdefined('attributes.from_purchase_offer') and not get_for_offer_ids.recordcount)>
				<tr id="hepsini_sil_id">
					<td colspan="3"><a href="javascript://" onclick="hepsini_sil(1)"><cfoutput>#caller.getLang('main',2239)#</cfoutput></a></td><!---Hepsini Sil--->
				</tr>
			</cfif>
		</table>
	</cfif>

</cfif>
<script type="text/javascript">
	<cfif isdefined("attributes.to_dsp_name")>
		cus_tag_max_row_to=<cfoutput>#cus_tag_max_row_to#</cfoutput>;
		function workcube_to_delRow(yer,int_row)
		{ 
			var ver = navigator.appVersion;
			<cfif type_of_custag_input eq 1>
				flag_custag=document.all.to_pos_ids.length;
			<cfelseif type_of_custag_input eq 2>
				flag_custag=document.all.to_par_ids.length;
			<cfelseif type_of_custag_input eq 3>
				flag_custag=document.all.to_cons_ids.length;
			</cfif>
			if(flag_custag > 0)
			{
				if (ver.indexOf("MSIE") != -1)
				{
					try{document.all.to_pos_ids[yer-1].value = '';}catch(e){}
					try{document.all.to_pos_codes[yer-1].value = '';}catch(e){}
					try{document.all.to_emp_ids[yer-1].value = '';}catch(e){}
					try{document.all.to_comp_ids[yer-1].value = '';}catch(e){}
					try{document.all.to_par_ids[yer-1].value = '';}catch(e){}
					try{document.all.to_cons_ids[yer-1].value = '';}catch(e){}
					try{document.all.to_wgrp_ids[yer-1].value = '';}catch(e){}
				}
				else
				{
					for(var i=0;i<document.all.to_emp_ids.lenght;i++)
					{
						if(document.all.to_emp_ids[i].value==int_row)
						{
							try{document.all.to_pos_ids[i].value = '';}catch(e){}
							try{document.all.to_pos_codes[i].value = '';}catch(e){}
							try{document.all.to_emp_ids[i].value = '';}catch(e){}
							try{document.all.to_comp_ids[i].value = '';}catch(e){}
							try{document.all.to_par_ids[i].value = '';}catch(e){}
							try{document.all.to_cons_ids[i].value = '';}catch(e){}
							try{document.all.to_wgrp_ids[i].value = '';}catch(e){}
							break;
						}	
					}
					try
					{
						for(var i=0;i<document.all.to_comp_ids.length;i++)
						{
							if(document.all.to_comp_ids[i].value==int_row)
							{
								try{document.all.to_comp_ids[i].value = '';}catch(e){}
								try{document.all.to_par_ids[i].value = '';}catch(e){}
								break;
							}
						}
					}catch(e){}
				}
			}
			else
			{
				try{document.all.to_pos_ids.value = '';}catch(e){}
				try{document.all.to_pos_codes.value = '';}catch(e){}
				try{document.all.to_emp_ids.value = '';}catch(e){}
				try{document.all.to_comp_ids.value = '';}catch(e){}
				try{document.all.to_par_ids.value = '';}catch(e){}
				try{document.all.to_cons_ids.value = '';}catch(e){}
				try{document.all.to_wgrp_ids.value = '';}catch(e){}
			}
			var my_element = document.getElementById('workcube_to_row' + yer);
			my_element.parentNode.removeChild(my_element);
			document.getElementById('tbl_to_names_row_count').value = yer - 1;
		}

	</cfif>
	<cfif isdefined("attributes.cc_dsp_name")>
		cus_tag_max_row_cc=<cfoutput>#cus_tag_max_row_cc#</cfoutput>;	
		function workcube_cc_delRow(yer,int_row)
		{
		
			var ver = navigator.appVersion;
			<cfif type_of_custag_input eq 1>
				flag_custag=document.all.cc_pos_ids.length;
			<cfelseif type_of_custag_input eq 2>
				flag_custag=document.all.cc_par_ids.length;		
			<cfelseif type_of_custag_input eq 3>		
				flag_custag=document.all.cc_cons_ids.length;		
			</cfif>
			
			if( flag_custag > 0)
			{
				if (ver.indexOf("MSIE") != -1)
				{
					try{document.all.cc_pos_ids[yer].value = '';}catch(e){}
					try{document.all.cc_pos_codes[yer].value = '';}catch(e){}
					try{document.all.cc_emp_ids[yer].value = '';}catch(e){}
					try{document.all.cc_comp_ids[yer].value = '';}catch(e){}
					try{document.all.cc_par_ids[yer].value = '';}catch(e){}
					try{document.all.cc_cons_ids[yer].value = '';}catch(e){}
					try{document.all.cc_wgrp_ids[yer].value = '';}catch(e){}
				}
				else
				{
					for(var i=0;i<document.all.cc_emp_ids.length;i++)
					{
					
							if(document.all.cc_emp_ids[i].value==int_row)
							{
								try{document.all.cc_pos_ids[i].value = '';}catch(e){}
								try{document.all.cc_pos_codes[i].value = '';}catch(e){}
								try{document.all.cc_emp_ids[i].value = '';}catch(e){}
								try{document.all.cc_comp_ids[i].value = '';}catch(e){}
								try{document.all.cc_par_ids[i].value = '';}catch(e){}
								try{document.all.cc_cons_ids[i].value = '';}catch(e){}
								try{document.all.cc_wgrp_ids[i].value = '';}catch(e){}
								break;
							}
					}
					try
					{
						for(var i=0;i<document.all.cc_comp_ids.length;i++)
						{
							if(document.all.cc_comp_ids[i].value==int_row)
								{
									try{document.all.cc_comp_ids[i].value = '';}catch(e){}
									try{document.all.cc_par_ids[i].value = '';}catch(e){}
									break;
								}
						}
					}catch(e){}
				}
			}
			else
			{
				try{document.all.cc_pos_ids.value = '';}catch(e){}
				try{document.all.cc_pos_codes.value = '';}catch(e){}			
				try{document.all.cc_emp_ids.value = '';}catch(e){}
				try{document.all.cc_comp_ids.value = '';}catch(e){}
				try{document.all.cc_par_ids.value = '';}catch(e){}
				try{document.all.cc_cons_ids.value = '';}catch(e){}
				try{document.all.cc_wgrp_ids.value = '';}catch(e){}
			}
		var my_element = document.getElementById('workcube_cc_row' + yer);
		my_element.parentNode.removeChild(my_element);
		}
	</cfif>
	<cfif isdefined("attributes.cc2_dsp_name")>
		cus_tag_max_row_cc2=<cfoutput>#cus_tag_max_row_cc2#</cfoutput>;	
		function workcube_cc2_delRow(yer,int_row)
		{
			var ver = navigator.appVersion;
			<cfif type_of_custag_input eq 1>
				flag_custag=document.all.cc2_pos_ids.length;
			<cfelseif type_of_custag_input eq 2>
				flag_custag=document.all.cc2_par_ids.length;		
			<cfelseif type_of_custag_input eq 3>		
				flag_custag=document.all.cc2_cons_ids.length;		
			</cfif>
			if( flag_custag > 0)
			{
				if (ver.indexOf("MSIE") != -1)
				{
					try{document.all.cc2_pos_ids[yer].value = '';}catch(e){}
					try{document.all.cc2_pos_codes[yer].value = '';}catch(e){}
					try{document.all.cc2_emp_ids[yer].value = '';}catch(e){}
					try{document.all.cc2_comp_ids[yer].value = '';}catch(e){}
					try{document.all.cc2_par_ids[yer].value = '';}catch(e){}
					try{document.all.cc2_cons_ids[yer].value = '';}catch(e){}
					try{document.all.cc2_wgrp_ids[yer].value = '';}catch(e){}
				}
				else
				{
					for(var i=0;i<document.all.cc2_emp_ids.lenght;i++)
					{
						if(document.all.cc2_emp_ids[i].value==int_row)
						{
							try{document.all.cc2_pos_ids[i].value = '';}catch(e){}
							try{document.all.cc2_pos_codes[i].value = '';}catch(e){}
							try{document.all.cc2_emp_ids[i].value = '';}catch(e){}
							try{document.all.cc2_comp_ids[i].value = '';}catch(e){}
							try{document.all.cc2_par_ids[i].value = '';}catch(e){}
							try{document.all.cc2_cons_ids[i].value = '';}catch(e){}
							try{document.all.cc2_wgrp_ids[i].value = '';}catch(e){}
							break;
						}	
					}
					try
					{
						for(var i=0;i<document.all.cc2_comp_ids.length;i++)
						{
							if(document.all.cc2_comp_ids[i].value==int_row)
							{
								try{document.all.cc2_comp_ids[i].value = '';}catch(e){}
								try{document.all.cc2_par_ids[i].value = '';}catch(e){}
								break;
							}
						}
					}catch(e){}
				}
			}
			else
			{
				try{document.all.cc2_pos_ids.value = '';}catch(e){}
				try{document.all.cc2_pos_codes.value = '';}catch(e){}			
				try{document.all.cc2_emp_ids.value = '';}catch(e){}
				try{document.all.cc2_comp_ids.value = '';}catch(e){}
				try{document.all.cc2_par_ids.value = '';}catch(e){}
				try{document.all.cc2_cons_ids.value = '';}catch(e){}
				try{document.all.cc2_wgrp_ids.value = '';}catch(e){}
			}
			var my_element = document.getElementById('workcube_cc2_row' + yer);
			my_element.parentNode.removeChild(my_element);
		}
	
	</cfif>
function control_related_offer(a,b)//cariden daha once teklif istenip istenmedigini kontrol eder
{
	<cfif isDefined('caller.x_multiple_sub_offers') and caller.x_multiple_sub_offers eq 1> 
		<cfif isdefined("attributes.action_id")>
			window.location.href='<cfoutput>#request.self#?fuseaction=purchase.list_offer&event=add&for_offer_id=#attributes.action_id#&</cfoutput>'+b;
		</cfif>		
	<cfelse>
		if(a >= 1)
		{
			alert("<cf_get_lang no='54.Cariden Daha Önce Teklif İstenmiştir'> !");
			return false;
		}
		else
		{
			<cfif isdefined("attributes.action_id")>
				window.location.href='<cfoutput>#request.self#?fuseaction=purchase.list_offer&event=add&for_offer_id=#attributes.action_id#&</cfoutput>'+b;
			</cfif>
		}
	</cfif>
}
function hepsini_sil(option)
{
	if(option == 1)
	{
		for(i=1;i<=document.getElementById('tbl_to_names_row_count').value;i++)
		{
				var my_element = document.getElementById('workcube_to_row' + i);
				my_element.parentNode.removeChild(my_element);
		}
		document.getElementById('hepsini_sil_id').style.display='none';
	}
	else if(option == 2)
	{
		for(i=0;i<=document.getElementById('tbl_cc_names_row_count').value;i++)
		{
				var my_element = document.getElementById('workcube_cc_row' + i);
				my_element.parentNode.removeChild(my_element);
		}
		document.getElementById('hepsini_sil_id2').style.display='none';
	}
	else
	{
		for(i=0;i<=document.getElementById('tbl_cc2_names_row_count').value;i++)
		{
				var my_element = document.getElementById('workcube_cc2_row' + i);
				my_element.parentNode.removeChild(my_element);
		}
		document.getElementById('hepsini_sil_id3').style.display='none';
	}
}
</script>