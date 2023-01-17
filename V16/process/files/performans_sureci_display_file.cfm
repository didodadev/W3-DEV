<!--- Performans degerlendirme sureci  Surec asamalari kontrol edilir Senay 20061013
*Acik form tipi surec isleme asamalari
	--Calisan kayit
	--Calisan Onay
	--Gorus Bildiren Kayit
	--Gorus Bildiren Onay
	--1.amir kayit
	--1.amir onay
	--Ortak degerlendirme kayit
	--Ortak degerlendirme onay
	--2.amir kayit
	--2.amir onay
*Yari acik form tipi asamalar
	--Gorus Bildiren Kayit
	--Gorus Bildiren Onay
	--1.amir kayit
	--1.amir onay
	--Ortak degerlendirme kayit
	--Ortak degerlendirme onay
	--2.amir kayit
	--2.amir onay
--->
function process_cat_dsp_function()
{
	var calisan_kayit = 23;
	var calisan_onay = 155;
	var gorus_bildiren_kayit = 160;
	var gorus_bildiren_onay = 161;
	var birinci_amir_kayit = 156;
	var birinci_amir_onay = 157;
	var ortak_degerlendirme_kayit = 193;
	var ortak_degerlendirme_onay = 194;
	var ikinci_amir_kayit = 158;
	var ikinci_amir_onay = 159;
	
	//*Surec asamalari onay ise formdan check_expl(); fonksiyonu cagirilir ve isaretlenmemis soru olup olmadigi kontrol edilir.. 
	if (document.add_perform.process_stage.value == calisan_onay || document.add_perform.process_stage.value == gorus_bildiren_onay || document.add_perform.process_stage.value == birinci_amir_onay || document.add_perform.process_stage.value == ortak_degerlendirme_onay || document.add_perform.process_stage.value == ikinci_amir_onay)
	{
		if(!check_expl()) return false;
	}
	if(document.add_perform.form_open_type.value == 1)//*Acik form tipi 
	{
		if (document.add_perform.process_stage.value == ortak_degerlendirme_kayit || document.add_perform.process_stage.value == ortak_degerlendirme_onay)//*Ortak degerlendirme kayit veya onay sureci secilirse calisan ve amir onayi var mi kontrol edilir varsa true dondur..
		{   
			if (document.add_perform.valid1.value != 1 && document.add_perform.MANAGER_1_EMP_ID!=undefined && document.add_perform.MANAGER_1_EMP_ID.value == <cfoutput>#session.ep.userid#</cfoutput>)
			{
				alert("1. Amir Kayıt veya 1. Amir Onay Sürecinin Seçilmesi Gerekiyor!");
				return false;
			}
			else if(document.add_perform.EMP_ID.value == <cfoutput>#session.ep.userid#</cfoutput>)
			{
				alert("Çalışan Kayıt veya Çalışan Onay Sürecinin Seçilmesi Gerekiyor!");
				return false;
			}
			else if(document.add_perform.MANAGER_3_EMP_ID!=undefined && document.add_perform.MANAGER_3_EMP_ID.value == <cfoutput>#session.ep.userid#</cfoutput>)
			{
				alert("Görüş Bildiren Kayıt veya Görüş Bildiren Onay Sürecinin Seçilmesi Gerekiyor!");
				return false;
			}
			else if(document.add_perform.MANAGER_2_EMP_ID!=undefined && document.add_perform.MANAGER_2_EMP_ID.value == <cfoutput>#session.ep.userid#</cfoutput>)
			{
				alert("2. Amir Kayıt veya 2. Amir Onay Sürecinin Seçilmesi Gerekiyor!");
				return false;
			}
			if (document.add_perform.MANAGER_1_EMP_ID!=undefined && document.add_perform.MANAGER_1_EMP_ID.value == <cfoutput>#session.ep.userid#</cfoutput> && document.add_perform.process_stage.value == ortak_degerlendirme_onay && document.add_perform.valid.value == 1 && document.add_perform.valid1.value == 1)
			{
				document.add_perform.valid4.value = 1; 
			}
		}
		else if (document.add_perform.EMP_ID.value == <cfoutput>#session.ep.userid#</cfoutput> )/* && document.add_perform.process_stage.value != '91' && document.add_perform.process_stage.value !='92')*/
		{ 
			if (document.add_perform.process_stage.value == calisan_onay)
			{
				document.add_perform.valid.value = 1;
			}
			if (document.add_perform.process_stage.value != calisan_kayit && document.add_perform.process_stage.value != calisan_onay)
			{
				alert('Çalışan Kayıt veya Onay Süreç Aşamalarını Seçebilirsiniz!');
				return false;
			}
		}
		else if (document.add_perform.MANAGER_3_EMP_ID!=undefined && document.add_perform.MANAGER_3_EMP_ID.value == <cfoutput>#session.ep.userid#</cfoutput> )//*&& document.add_perform.process_stage.value != '93' && document.add_perform.process_stage.value !='94')
		{	
			if (document.add_perform.process_stage.value ==gorus_bildiren_onay)
			{
				document.add_perform.valid3.value = 1;
			}
			if (document.add_perform.process_stage.value != gorus_bildiren_kayit && document.add_perform.process_stage.value !=gorus_bildiren_onay)
			{
				alert('Görüş Bildiren Kayıt veya Onay Süreç Aşamalarını Seçebilirsiniz!');
				return false;
			}
		}
		else if (document.add_perform.MANAGER_1_EMP_ID!=undefined && document.add_perform.MANAGER_1_EMP_ID.value == <cfoutput>#session.ep.userid#</cfoutput> && document.add_perform.valid1.value != 1 ) //*&& document.add_perform.process_stage.value != '95' && document.add_perform.process_stage.value !='97')
		{	
			if (document.add_perform.process_stage.value == birinci_amir_onay)
			{ 
				document.add_perform.valid1.value = 1;
			}
			if (document.add_perform.process_stage.value != birinci_amir_kayit && document.add_perform.process_stage.value != birinci_amir_onay)
			{
				alert('1.Amir Kayıt veya Onay Süreç Aşamalarını Seçebilirsiniz!');
				return false;
			}
			if(document.add_perform.MANAGER_3_EMP_ID!=undefined && document.add_perform.MANAGER_3_EMP_ID.value != '' && document.add_perform.valid3.value != 1)
			{
				alert("Görüş Bildiren Onayı Verilmemiş!");
				return false;
			}
		}
		else if (document.add_perform.MANAGER_2_EMP_ID!=undefined && document.add_perform.MANAGER_2_EMP_ID.value == <cfoutput>#session.ep.userid#</cfoutput> ) //*&& document.add_perform.process_stage.value != '100' && document.add_perform.process_stage.value !='101')
		{	
			if (document.add_perform.process_stage.value == ikinci_amir_onay)
			{
				document.add_perform.valid2.value= 1;
			}
			if (document.add_perform.process_stage.value != ikinci_amir_kayit && document.add_perform.process_stage.value != ikinci_amir_onay)
			{
				alert('2.Amir Kayıt veya Onay Süreç Aşamalarını Seçebilirsiniz!');
				return false;
			}
			if (document.add_perform.valid4.value != 1)
			{
				alert("Ortak Değerlendirme Onayı Verilmemiş!");
				return false;
			}
			if(document.add_perform.valid1.value != 1)
			{
				alert("1.Amir Onayı Verilmemiş!");
				return false;
			}
		}
		else if(document.add_perform.MANAGER_1_EMP_ID!=undefined && document.add_perform.MANAGER_1_EMP_ID.value == <cfoutput>#session.ep.userid#</cfoutput> && (document.add_perform.process_stage.value != ortak_degerlendirme_kayit || document.add_perform.process_stage.value != ortak_degerlendirme_onay || document.add_perform.process_stage.value != birinci_amir_kayit && document.add_perform.process_stage.value != birinci_amir_onay))
		{
			if (document.add_perform.valid1.value == 1)
			{
				alert("Ort. Değerlendirme Kayıt Ve Onay Secebilirsiniz!");
				return false;
			}
			if (document.add_perform.valid1.value != 1)
			{
				alert("1.Amir Kayıt ve Onay Secebilirsiniz!");
				return false;
			}
		}
	}
	else if (document.add_perform.form_open_type.value == 2)
	{
		if (document.add_perform.process_stage.value == calisan_kayit || document.add_perform.process_stage.value == calisan_onay || document.add_perform.process_stage.value == ortak_degerlendirme_kayit || document.add_perform.process_stage.value == ortak_degerlendirme_onay)
		{
			if(document.add_perform.MANAGER_1_EMP_ID!=undefined && document.add_perform.MANAGER_1_EMP_ID.value == <cfoutput>#session.ep.userid#</cfoutput>)
			{
				alert('1.Amir Kayıt veya 1.Amir Onay Süreç Aşamalarının Seçilmesi Gerekiyor!');
				return false;
			}
			else if(document.add_perform.MANAGER_2_EMP_ID!=undefined && document.add_perform.MANAGER_2_EMP_ID.value == <cfoutput>#session.ep.userid#</cfoutput>)
			{
				alert('2.Amir Kayıt veya 2.Amir Onay Süreç Aşamalarının Seçilmesi Gerekiyor!');
				return false;
			}
		}
		if  (document.add_perform.MANAGER_3_EMP_ID!=undefined && document.add_perform.MANAGER_3_EMP_ID.value == <cfoutput>#session.ep.userid#</cfoutput> )//* && document.add_perform.process_stage.value != '93' && document.add_perform.process_stage.value !='94')
		{
			if (document.add_perform.process_stage.value ==gorus_bildiren_onay)
			{
				document.add_perform.valid3.value= 1;
			}
			if (document.add_perform.process_stage.value != gorus_bildiren_kayit && document.add_perform.process_stage.value !=gorus_bildiren_onay)
			{
				alert('Görüş Bildiren Kayıt veya Onay Süreç Aşamalarını Seçebilirsiniz!');
				return false;
			}
		}
		else if (document.add_perform.MANAGER_1_EMP_ID!=undefined && document.add_perform.MANAGER_1_EMP_ID.value == <cfoutput>#session.ep.userid#</cfoutput>)//* && document.add_perform.process_stage.value != '95' && document.add_perform.process_stage.value !='97')
		{	
			if (document.add_perform.process_stage.value == birinci_amir_onay)
			{
				document.add_perform.valid1.value= 1;
			}
			if (document.add_perform.process_stage.value != birinci_amir_kayit && document.add_perform.process_stage.value != birinci_amir_onay)
			{
			  alert('1.Amir Kayıt veya Onay Süreç Aşamalarını Seçebilirsiniz!');
			  return false;
			}
		}
		else if (document.add_perform.MANAGER_2_EMP_ID!=undefined && document.add_perform.MANAGER_2_EMP_ID.value == <cfoutput>#session.ep.userid#</cfoutput>) //*&& document.add_perform.process_stage.value != '100' && document.add_perform.process_stage.value !='101')
		{	
			if (document.add_perform.process_stage.value == ikinci_amir_onay)
			{
				document.add_perform.valid2.value= 1;
			}
			if (document.add_perform.process_stage.value != ikinci_amir_kayit && document.add_perform.process_stage.value != ikinci_amir_onay)
			{
				alert('2.Amir Kayıt veya Onay Süreç Aşamalarını Seçebilirsiniz!');
				return false;
			}
			if (document.add_perform.valid1.value != 1)
			{
				alert('1.Amir Onayı Verilmemiş');
				return false;
			}
		}
	}
	return true;
}
