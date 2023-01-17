<cfquery name="IM_CATS" datasource="#dsn#">
	SELECT * FROM SETUP_IM
</cfquery>
<cfquery name="GET_ID_CARD_CATS" datasource="#dsn#">
	SELECT IDENTYCAT_ID,#DSN#.#dsn#.Get_Dynamic_Language(IDENTYCAT_ID,'#session.ep.language#','SETUP_IDENTYCARD','IDENTYCAT',NULL,NULL,IDENTYCAT ) AS IDENTYCAT FROM SETUP_IDENTYCARD
</cfquery>
<cfquery name="KNOW_LEVELS" datasource="#dsn#">
	SELECT KNOWLEVEL_ID,#dsn#.Get_Dynamic_Language(KNOWLEVEL_ID,'#session.ep.language#','SETUP_KNOWLEVEL','KNOWLEVEL',NULL,NULL,KNOWLEVEL) AS KNOWLEVEL FROM SETUP_KNOWLEVEL
</cfquery>
<cfquery name="MOBIL_CATS" datasource="#dsn#">
	SELECT * FROM SETUP_MOBILCAT ORDER BY MOBILCAT
</cfquery>
<cfquery name="get_edu_level" datasource="#DSN#">
	SELECT EDU_LEVEL_ID,#DSN#.#dsn#.Get_Dynamic_Language(EDU_LEVEL_ID,'#session.ep.language#','SETUP_EDUCATION_LEVEL','EDUCATION_NAME',NULL,NULL,EDUCATION_NAME ) AS EDUCATION_NAME FROM SETUP_EDUCATION_LEVEL
</cfquery>
<cfquery name="get_languages" datasource="#dsn#">
	SELECT LANGUAGE_ID,#dsn#.Get_Dynamic_Language(LANGUAGE_ID,'#session.ep.language#','SETUP_LANGUAGES','LANGUAGE_SET',NULL,NULL,LANGUAGE_SET) AS LANGUAGE_SET FROM SETUP_LANGUAGES
</cfquery>
<cfquery name="get_unv" datasource="#dsn#">
	SELECT SCHOOL_ID, SCHOOL_NAME FROM SETUP_SCHOOL ORDER BY SCHOOL_NAME
</cfquery>
<cfquery name="get_school_part" datasource="#dsn#">
	SELECT PART_ID, PART_NAME FROM SETUP_SCHOOL_PART ORDER BY PART_NAME
</cfquery>
<cfquery name="get_high_school_part" datasource="#dsn#">
	SELECT HIGH_PART_ID, HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART ORDER BY HIGH_PART_NAME
</cfquery>
<cfquery name="get_country" datasource="#dsn#">
	SELECT COUNTRY_ID,COUNTRY_NAME,IS_DEFAULT FROM SETUP_COUNTRY ORDER BY COUNTRY_NAME
</cfquery>
<cfquery name="get_city" datasource="#dsn#">
	SELECT CITY_ID, CITY_NAME FROM SETUP_CITY ORDER BY CITY_NAME
</cfquery>
<cfquery name="get_my_profile" datasource="#DSN#"><!--- CV VARMI YOKMU --->
	SELECT * FROM EMPLOYEES_APP WHERE EMPLOYEE_ID = #session.ep.userid#
</cfquery>
<cfquery name="get_reference_type" datasource="#dsn#">
	SELECT REFERENCE_TYPE_ID,#dsn#.Get_Dynamic_Language(REFERENCE_TYPE_ID,'#session.ep.language#','SETUP_REFERENCE_TYPE','REFERENCE_TYPE',NULL,NULL,REFERENCE_TYPE) AS REFERENCE_TYPE FROM SETUP_REFERENCE_TYPE
</cfquery>
<cfquery name="GET_My_Profile_p" datasource="#dsn#">                        
SELECT 
    W.NAME,
    W.SURNAME ,                            
    W.POSITION_NAME,
    E.PHOTO,  
    E2.SEX                                                     
FROM
    WRK_SESSION AS W
    LEFT JOIN EMPLOYEES AS E ON E.EMPLOYEE_ID = W.USERID
    LEFT JOIN EMPLOYEES_DETAIL AS E2 ON E2.EMPLOYEE_ID = W.USERID                             
WHERE
   W.USERID=#session.ep.userid#
</cfquery> 
<cfloop query="GET_My_Profile_p" startrow=1 endrow="#GET_My_Profile_p.recordcount#">
<cfset My_Name = Name>
<cfset My_Surname = SURNAME>
<cfset My_Position = POSITION_NAME> 
<cfset My_Photo = PHOTO> 
<cfset My_Sex = SEX>  
</cfloop> 
<cfif not get_my_profile.recordcount>
	<cfquery name="GET_HR" datasource="#DSN#">
		SELECT * FROM EMPLOYEES	WHERE EMPLOYEE_ID=#session.ep.userid#
	</cfquery>
	<cfquery name="get_emp_identy" datasource="#DSN#">
		SELECT * FROM EMPLOYEES_IDENTY	WHERE EMPLOYEE_ID = #session.ep.userid#
	</cfquery>
	<cfquery name="GET_HR_DETAIL" datasource="#DSN#">
        SELECT 
			ED.*,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			EI.BIRTH_DATE,
			EI.BIRTH_PLACE,
			EI.SOCIALSECURITY_NO,
			EI.BIRTH_CITY
		FROM 
			EMPLOYEES_DETAIL ED,
			EMPLOYEES E,
			EMPLOYEES_IDENTY EI
		WHERE 
			ED.EMPLOYEE_ID = #session.ep.userid#
			AND E.EMPLOYEE_ID = ED.EMPLOYEE_ID
			AND EI.EMPLOYEE_ID = ED.EMPLOYEE_ID
	</cfquery>	
<cfelse>
	<cfquery name="get_my_profile_identy" datasource="#dsn#">
		SELECT * FROM EMPLOYEES_IDENTY WHERE EMPAPP_ID = #get_my_profile.EMPAPP_ID#
	</cfquery>
</cfif>
<cf_catalystHeader>
<div class="col col-2 col-xs-12 uniqueRow">
    <cf_box>
        <div class="row divBox">
            <div class="profile-userpic text-center">  
                <cfif len(My_Photo)>
                    <img class="img-circle" title="<cfoutput>#My_Position# - #My_Name# #My_Surname#</cfoutput>" src="../documents/hr/<cfoutput>#My_Photo#</cfoutput>" />
                <cfelseif My_Sex eq 1>
                    <img class="img-circle" title="<cfoutput>#My_Name# #My_Surname#</cfoutput>" src="../images/male.jpg" />
                <cfelse>
                    <img class="img-circle" title="<cfoutput>#My_Name# #My_Surname#</cfoutput>" src="../images/female.jpg" />
                </cfif>
                <div class="profile-usertitle-name"><cfoutput>#My_Name# #My_Surname#</cfoutput></div>
                <div class="profile-usertitle-job"><cfoutput>#My_Position#</cfoutput></div>
            </div>
            <div class="profile-usermenu">
                <ul class="navBox acordionUl">
					<li><a style="font-size:15px!important;" href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.my_position"><i class="icn-md catalyst-briefcase" style="font-size:15px!important;" title="<cf_get_lang dictionary_id='30793.Pozisyonum'>"></i>&nbsp;<cf_get_lang dictionary_id='30793.Pozisyonum'></a></li>
                    <li><a style="font-size:15px!important;" href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.my_profile"><i class="icn-md catalyst-book-open" style="font-size:15px!important;" title="<cf_get_lang dictionary_id='49821.Özgeçmiş'>"></i>&nbsp;<cf_get_lang dictionary_id='49821.Özgeçmiş'></a></li>
                    <li><a style="font-size:15px!important;" href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.my_detail"><i class="icn-md catalyst-info" style="font-size:15px!important;" title="<cf_get_lang dictionary_id='31150.Bilgilerim'>"></i>&nbsp;<cf_get_lang dictionary_id='31150.Bilgilerim'></a></li>
                    <li><a style="font-size:15px!important;" href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.dashboard" target="_blank"><i class="icn-md catalyst-pie-chart" style="font-size:15px!important;"></i>&nbsp;<cf_get_lang dictionary_id='63588.Dashboard'></a></li>
                    <li><a style="font-size:15px!important;" href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.hr" target="_blank"><i class="icn-md catalyst-users" style="font-size:15px!important;"></i>&nbsp;<cf_get_lang dictionary_id='47630.IK İşlemleri'></a></li>
                    <li><a style="font-size:15px!important;" href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.other_hr" target="_blank"><i class="icn-md catalyst-plane" style="font-size:15px!important;"></i>&nbsp;<cf_get_lang dictionary_id='48428.Diğer İşlemler'></a></li>
                    <li><a style="font-size:15px!important;" href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.myTeam" target="_blank"><i class="icn-md catalyst-target" style="font-size:15px!important;"></i>&nbsp;<cf_get_lang dictionary_id='61183.Ekibim ve Ben'></a></li>
                    <li><a style="font-size:15px!important;" href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.upd_myweek" target="_blank"><i class="icn-md catalyst-clock" style="font-size:15px!important;"></i>&nbsp;<cf_get_lang dictionary_id='32219.Zaman Yönetimi'></a></li>
                </ul>
            </div>
        </div>
    </cf_box>
</div>
<div class="col col-10 col-xs-12 uniqueRow">  
	<cfif not get_my_profile.recordcount><!--- CV kayıtı yoksa bu bloğa yani ekleme bloğuna gir. --->
		<cfinclude template="add_cv.cfm">
	<cfelse><!--- Varsa buraya yani güncelleme bloğuna gir --->
		<cfinclude template="upd_cv.cfm">
	</cfif>	
</div>	
<cfif not get_my_profile.recordcount>
<script type="text/javascript">
	<!---özürlü seviyesi select pasif aktif yapma--->
	function pencere_ac()
	{
		x = document.employe_detail.homecountry.selectedIndex;
		if (document.employe_detail.homecountry[x].value == "")
		{
			alert("<cf_get_lang dictionary_id='31309.İlk Olarak Ülke Seçiniz'>");
		}	
		else if(document.employe_detail.homecity.value == "")
		{
			alert("<cf_get_lang dictionary_id='31644.İl Seçiniz'>!");
		}
		else
		{
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=employe_detail.county_id&field_name=employe_detail.homecounty&city_id=' + document.employe_detail.homecity.value);
		}
	}
	function pencere_ac_city()
	{
		x = document.employe_detail.homecountry.selectedIndex;
		if (document.employe_detail.homecountry[x].value == "")
		{
			alert("<cf_get_lang dictionary_id='56176.İlk Olarak Ülke Seçiniz'> !");
		}	
		else
		{
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_city&field_id=employe_detail.homecity&field_name=employe_detail.homecity_name&country_id=' + document.employe_detail.homecountry.value);
		}
	}
	
	<cfoutput>
		<cfif get_cv_unit.recordcount>
			unit_count=#get_cv_unit.recordcount#;
		<cfelse>
			unit_count=0;
		</cfif>
	</cfoutput>
	
	function tecilli_fonk(gelen)
	{
		if (gelen == 4)
		{
			Tecilli.style.display='';
			Yapti.style.display='none';
			Muaf.style.display='none';
		}
		else if(gelen == 1)
		{
			Yapti.style.display='';
			Tecilli.style.display='none';
			Muaf.style.display='none';
		}
		else if(gelen == 2)
		{
			Muaf.style.display='';
			Tecilli.style.display='none';
			Yapti.style.display='none';
		}
		else
		{
			Tecilli.style.display='none';
			Yapti.style.display='none';
			Muaf.style.display='none';
		}
	}
	
	function gizle(id1)
	{
	 if(id1.style.display=='')
		id1.style.display='none';
	 else
		id1.style.display='';
	}
	rowCount = 0 ;
	satir_say = 0;
	
	function sil(sv)
	{
		var my_element=document.getElementById("rowCount"+sv);
		my_element.value=0;
		var my_element = document.getElementById('frm_row'+sv);
		my_element.style.display="none";
		satir_say--;
	}
	
	function sil_exp(sv)
	{
		var my_element=document.getElementById("row_kontrol"+sv);
		my_element.value=0;
		var my_element = document.getElementById('frm_row'+sv);
		my_element.style.display="none";
		satir_say--;
	}
	
	function relative_sil(sv)
	{
		var my_element=document.getElementById("rowCount"+sv);
		my_element.value=0;
		var my_element = document.getElementById('frm_row'+sv);
		my_element.style.display="none";
		satir_say--;
/*		alan=document.getElementById('relative_sil'+satir);
		alan.value=1;
		alan = document.getElementById('name_relative'+satir);
		alan.value="";
		alan = document.getElementById('surname_relative'+satir);
		alan.value="";
*/	}
	
	function addRow_()
	{
		rowCount++;
		satir_say++;
		employe_detail.rowCount.value = rowCount;
		var newRow;
		var newCell;
		newRow = document.getElementById("table_list").insertRow(document.getElementById("table_list").rows.length);
		newRow.setAttribute("name","frm_row" + rowCount);
		newRow.setAttribute("id","frm_row" + rowCount);
		newRow.setAttribute("NAME","frm_row" + rowCount);
		newRow.setAttribute("ID","frm_row" + rowCount);
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" value="1" id="rowCount' + rowCount +'" name="rowCount' + rowCount +'"><a href="javascript://" onclick="relative_sil(' + rowCount + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="name_relative' + rowCount + '" value=""></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="surname_relative' + rowCount + '"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="relative_level' + rowCount + '"><option value="1"><cf_get_lang dictionary_id="31327.Baba"></option><option value="2"><cf_get_lang dictionary_id="31328.Anne"></option><option value="3"><cf_get_lang dictionary_id="31329.Eşi"></option><option value="4"><cf_get_lang dictionary_id="31330.Oğlu"></option><option value="5"><cf_get_lang dictionary_id="31331.Kızı"></option><option value="6"><cf_get_lang dictionary_id="31449.Kardeşi"></option></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("id","birth_date_relative" + rowCount + "_td");
		newCell.innerHTML = '<input type="text" id="birth_date_relative' + rowCount +'" name="birth_date_relative' + rowCount +'" class="text" maxlength="10" value="">';
		wrk_date_image('birth_date_relative' + rowCount);
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="birth_place_relative' + rowCount + '" value=""></div>';
		/*newCell = newRow.insertCell();
		newCell.innerHTML = '<input type="text" name="tc_identy_no_relative' + rowCount + '" value="">';*/
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="education_relative' + rowCount + '"><option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option><cfoutput query="get_edu_level"><option value="#EDU_LEVEL_ID#" >#EDUCATION_NAME#</option></cfoutput></select></div><div class="form-group"><label><input type="checkbox" name="education_status_relative' + rowCount + '" value="1"><cf_get_lang dictionary_id="31332.Okuyor"></label></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="job_relative' + rowCount + '" value="">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="company_relative' + rowCount + '" value="">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="job_position_relative' + rowCount + '" value="">';
	}
	
	function control_last()
	{
        <cfif attributes.fuseaction neq 'myhome.my_profile'>
			employe_detail.expected_price.value = filterNum(employe_detail.expected_price.value);
			if(process_cat_control())
			{
				openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_dsp_app_prerecords&employee_name=' + employe_detail.name.value + '&employee_surname=' + employe_detail.surname.value +'&identycard_no=' + employe_detail.identycard_no.value + '&tax_number=' + employe_detail.tax_number.value);
				return false;
			}
			else
				return false;
        </cfif>
	}
	</script>
	<cfelse>
	<script type="text/javascript">
	document.all.upload_status.style.display = 'none';
		<!---özürlü seviyesi select pasif aktif yapma--->
		function seviye()
		{
			if(document.employe_detail.defected_level.disabled==true)
			{document.employe_detail.defected_level.disabled=false;}
			else
			{document.employe_detail.defected_level.disabled=true;}
		}
	function pencere_ac()
	{
		x = document.employe_detail.homecountry.selectedIndex;
		if (document.employe_detail.homecountry[x].value == "")
		{
			alert("<cf_get_lang dictionary_id='56176.İlk Olarak Ülke Seçiniz'> ");
		}	
		else if(document.employe_detail.homecity.value == "")
		{
			alert("<cf_get_lang dictionary_id='31644.İl Seçiniz'>!");
		}
		else
		{
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=employe_detail.county_id&field_name=employe_detail.homecounty&city_id=' + document.employe_detail.homecity.value);
		}
	}
	function pencere_ac_city()
	{
		x = document.employe_detail.homecountry.selectedIndex;
		if (document.employe_detail.homecountry[x].value == "")
		{
			alert("<cf_get_lang dictionary_id='56176.İlk Olarak Ülke Seçiniz'>!");
		}	
		else
		{
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_city&field_id=employe_detail.homecity&field_name=employe_detail.homecity_name&country_id=' + document.employe_detail.homecountry.value);
		}
	}
	
	//departmanlar
	<cfoutput>
		<cfif get_cv_unit.recordcount>
			unit_count=#get_cv_unit.recordcount#;
		<cfelse>
			unit_count=0;
		</cfif>
	</cfoutput>
	function seviye_kontrol(nesne)
	{
		for(var j=1;j<=unit_count;j++)
		{
			diger_nesne=eval("document.employe_detail.unit"+j);
			if(diger_nesne!=nesne)
			{
				if(nesne.value==diger_nesne.value && diger_nesne.value.length!=0)
				{
					alert("<cf_get_lang dictionary_id='31645.İki tane aynı seviye giremezsiniz'>!");
					diger_nesne.value='';
				}
			}
		}
	}
	function kontrol()
	{
		unformat_fields();
		var obj =  document.employe_detail.photo.value;
		if ((obj != "") && !((obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'jpg')   || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'gif') || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'png')))
		{
			 alert("<cf_get_lang dictionary_id='31646.Lütfen bir resim dosyası(gif,jpg veya png) giriniz'>!!");        
			return false;
		}
	}
	function tecilli_fonk(gelen)
	{
		if (gelen == 4)
		{
			Tecilli.style.display='';
			Yapti.style.display='none';
			Muaf.style.display='none';
		}
		else if(gelen == 1)
		{
			Yapti.style.display='';
			Tecilli.style.display='none';
			Muaf.style.display='none';
		}
		else if(gelen == 2)
		{
			Muaf.style.display='';
			Tecilli.style.display='none';
			Yapti.style.display='none';
		}
		else
		{
			Tecilli.style.display='none';
			Yapti.style.display='none';
			Muaf.style.display='none';
		}
	}

	
	function addRow()
	{
		rowCount++;
		employe_detail.rowCount.value = rowCount;
		var newRow;
		var newCell;
		newRow = document.getElementById("table_list").insertRow(document.getElementById("table_list").rows.length);
		newRow.setAttribute("name","frm_row" + rowCount);
		newRow.setAttribute("id","frm_row" + rowCount);
		newRow.setAttribute("NAME","frm_row" + rowCount);
		newRow.setAttribute("ID","frm_row" + rowCount);
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" value="1" id="rowCount' + rowCount +'" name="rowCount' + rowCount +'"><a href="javascript://" onclick="relative_sil(' + rowCount + ');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id ='57463.sil'>" title="<cf_get_lang dictionary_id ='57463.sil'>"></i></a>';		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="name_relative' + rowCount + '" value=""></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="surname_relative' + rowCount + '"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="relative_level' + rowCount + '" style="width:55px;"><option value="1"><cf_get_lang dictionary_id="31327.Babası"></option><option value="2"><cf_get_lang dictionary_id="31328.Annesi"></option><option value="3"><cf_get_lang dictionary_id="31329.Eşi"></option><option value="4"><cf_get_lang dictionary_id="31330.Oğlu"></option><option value="5"><cf_get_lang dictionary_id="31331.Kızı"></option><option value="6"><cf_get_lang dictionary_id="31449.Kardeşi"></option></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		
		newCell.setAttribute("id","birth_date_relative" + rowCount + "_td");
		newCell.innerHTML = '<input type="text" id="birth_date_relative' + rowCount +'" name="birth_date_relative' + rowCount +'" class="text" maxlength="10" value="">';
		wrk_date_image('birth_date_relative' + rowCount);
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="birth_place_relative' + rowCount + '" value=""></div>';
		/*newCell = newRow.insertCell();
		newCell.innerHTML = '<input type="text" name="tc_identy_no_relative' + rowCount + '" value="">';*/
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="education_relative' + rowCount + '"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option><cfoutput query="get_edu_level"><option value="#EDU_LEVEL_ID#" >#EDUCATION_NAME#</option></cfoutput></select><input type="checkbox" name="education_status_relative' + rowCount + '" value="1"><cf_get_lang dictionary_id="31332.Okuyor"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="job_relative' + rowCount + '" value=""></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="company_relative' + rowCount + '" value=""></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="job_position_relative' + rowCount + '" value=""></div>';
	}
	function unformat_fields()
	{
		employe_detail.expected_price.value=filterNum(employe_detail.expected_price.value);
	}
</script>
</cfif>
