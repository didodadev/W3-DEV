/*<!--- Performans Degerlendirme --->*/
function process_cat_dsp_function()
{
	var calisan_kayit = 1164;
	var calisan_onay = 1165;
	var gorus_bildiren_kayit = 1173;
	var gorus_bildiren_onay = 1174;
	var birinci_amir_kayit = 1166;
	var birinci_amir_onay = 1167;
	var ortak_degerlendirme_kayit = 1168;
	var ortak_degerlendirme_onay = 1169;
	var ikinci_amir_kayit = 1170;
	var ikinci_amir_onay = 1171;
	var session_userid = "<cfoutput>#session.ep.userid#</cfoutput>";
	
	//*Surec asamalari onay ise formdan check_expl(); fonksiyonu cagirilir ve isaretlenmemis soru olup olmadigi kontrol edilir.. 
	if (document.getElementById("process_stage").value == calisan_onay || document.getElementById("process_stage").value == gorus_bildiren_onay || document.getElementById("process_stage").value == birinci_amir_onay || document.getElementById("process_stage").value == ortak_degerlendirme_onay || document.getElementById("process_stage").value == ikinci_amir_onay)
	{
		if(!check_expl()) return false;
	}
	
	var check_valid_0 = 0;
	var check_valid_1 = 0;
	var check_valid_2 = 0;
	var check_valid_3 = 0;
	var check_valid_4 = 0;	
	if((document.getElementById("MANAGER_0_EMP_ID") != undefined && (document.getElementById("valid").value == 1 || document.getElementById("MANAGER_0_EMP_ID").value == "")) || document.getElementById("MANAGER_0_EMP_ID") == undefined)
		var check_valid_0 = 1; //Calisan
	if((document.getElementById("MANAGER_1_EMP_ID") != undefined && (document.getElementById("valid1").value == 1 || document.getElementById("MANAGER_1_EMP_ID").value == "")) || document.getElementById("MANAGER_1_EMP_ID") == undefined)
		var check_valid_1 = 1; //Birinci Amir
	if((document.getElementById("MANAGER_2_EMP_ID") != undefined && (document.getElementById("valid2").value == 1 || document.getElementById("MANAGER_2_EMP_ID").value == "")) || document.getElementById("MANAGER_2_EMP_ID") == undefined)
		var check_valid_2 = 1;  //Ikinci Amir
	if((document.getElementById("MANAGER_3_EMP_ID") != undefined && (document.getElementById("valid3").value == 1 || document.getElementById("MANAGER_3_EMP_ID").value == "")) || document.getElementById("MANAGER_3_EMP_ID") == undefined)
		var check_valid_3 = 1; //Gorus Bildiren
	if((document.getElementById("MANAGER_4_EMP_ID") != undefined && (document.getElementById("valid4").value == 1 || document.getElementById("MANAGER_4_EMP_ID").value == "")) || document.getElementById("MANAGER_4_EMP_ID") == undefined)
		var check_valid_4 = 1; //Ortak Degerlendirme
	
	
	//Calisan Kayit & Onay
	if(document.getElementById("MANAGER_0_EMP_ID") != undefined && document.getElementById("MANAGER_0_EMP_ID").value == session_userid)
	{
		if(document.getElementById("process_stage").value == calisan_kayit || document.getElementById("process_stage").value == calisan_onay)
		{
			if(document.getElementById("process_stage").value == calisan_onay)
				document.getElementById("valid").value = 1;
		}
		else
		{
			alert("<cf_get_lang dictionary_id='41565.Çalışan Kayıt veya Çalışan Onay Aşamalarından Birini Seçmelisiniz'>!");
			return false;
		}
	}
	//Gorus Bildiren Kayit & Onay
	else if(document.getElementById("MANAGER_3_EMP_ID") != undefined && document.getElementById("MANAGER_3_EMP_ID").value == session_userid)
	{
		if(check_valid_0 == 1) // Varsa Calisan Onaylamissa
		{
			if(document.getElementById("process_stage").value == gorus_bildiren_kayit || document.getElementById("process_stage").value == gorus_bildiren_onay)
			{
				if(document.getElementById("process_stage").value == gorus_bildiren_onay)
					document.getElementById("valid3").value = 1;
			}
			else
			{
				alert("<cf_get_lang dictionary_id='41562.Görüş Bildiren Kayıt veya Görüş Bildiren Onay Aşamalarından Birini Seçmelisiniz'>!");
				return false;
			}
		}
		else
		{
			alert("�alisan Onayi Verilmemis!");
			return false;
		}
	}
	//1.Amir Kayit & Onay || Ortak Degerlendirme Kayit & Onay
	else if(document.getElementById("MANAGER_1_EMP_ID") != undefined && document.getElementById("MANAGER_1_EMP_ID").value == session_userid)
	{
		if(check_valid_0 == 1 && check_valid_3 == 1 && check_valid_1 == 1) // Varsa Calisan,1.Amir ve Gorus Bildiren Onaylamissa
		{
			if(document.getElementById("process_stage").value == ortak_degerlendirme_kayit || document.getElementById("process_stage").value == ortak_degerlendirme_onay)
			{
				if(document.getElementById("process_stage").value == ortak_degerlendirme_onay)
					document.getElementById("valid4").value = 1;
			}
			else
			{
				alert("<cf_get_lang dictionary_id='41561.Ortak Değerlendirme Kayıt veya Ortak Değerlendirme Onay Aşamalarından Birini Seçmelisiniz'>!");
				return false;
			}
		}
		else if(check_valid_0 == 1 && check_valid_3 == 1 && check_valid_1 == 0) // Varsa Calisan ve Gorus Bildiren Onaylamissa
		{
			if(document.getElementById("process_stage").value == birinci_amir_kayit || document.getElementById("process_stage").value == birinci_amir_onay)
			{
				if(document.getElementById("process_stage").value == birinci_amir_onay)
					document.getElementById("valid1").value = 1;
			}
			else
			{
				alert("<cf_get_lang dictionary_id='41559.1.Amir Kayıt veya 1.Amir Kayıt Aşamalarından Birini Seçmelisiniz'>!");
				return false;
			}
			
		}
		else //Calisan veya Gorus Bildiren Onaylamamissa
		{
			if(check_valid_3 == 0)
			{
				alert("<cf_get_lang dictionary_id='41557.Görüş Bildiren Onayi Verilmemis'>!");
				return false;
			}
			else
			{
				alert("<cf_get_lang dictionary_id='41555.Çalışan Onayi Verilmemis!'>");
				return false;
			}
		}
	}
	//2.Amir Kayit & Onay
	else if(document.getElementById("MANAGER_2_EMP_ID") != undefined && document.getElementById("MANAGER_2_EMP_ID").value == session_userid)
	{
		if(check_valid_0 == 1 && check_valid_3 == 1 && check_valid_1 == 1 && check_valid_4 == 1) // Varsa Calisan,1.Amir,Gorus Bildiren ve Ortak Degerlendirme Onaylamissa
		{
			if(document.getElementById("process_stage").value == ikinci_amir_kayit || document.getElementById("process_stage").value == ikinci_amir_onay)
			{
				if(document.getElementById("process_stage").value == ikinci_amir_onay)
					document.getElementById("valid2").value = 1;
			}
			else
			{
				alert("<cf_get_lang dictionary_id='41554.İkinci Amir Kayit veya 2.Amir Onay Asamalarindan Birini Seçmelisiniz'>!");
				return false;
			}
		}
		else //Calisan,1.Amir,Ortak Degerlendirme veya Gorus Bildiren Onaylamamissa
		{
			if(check_valid_0 == 0)
			{
				alert("<cf_get_lang dictionary_id='41555.Çalışan Onayi Verilmemis'>!");
				return false;
			}
			if(check_valid_3 == 0)
			{
				alert("<cf_get_lang dictionary_id='41557.Görüş Bildiren Onayi Verilmemiş'>!");
				return false;
			}
			if(check_valid_1 == 0)
			{
				alert("<cf_get_lang dictionary_id='41553.Birinci Amir Onayı Verilmemiş'>!");
				return false;
			}
			else
			{
				alert("<cf_get_lang dictionary_id='41552.Ortak Değerlendirme Onayı Verilmemiş'>!");
				return false;
			}
		}
	}
	return true;
}




