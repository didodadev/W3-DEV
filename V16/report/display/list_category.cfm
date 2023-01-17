<!--- Cok Fazla Secenek Oldugu Icın XML'e alindi --->
<script type="text/javascript">
$(document).ready(function(e)
{
	$('#list_type').empty();
	<cfif xml_list_category_alphabetically eq 1><!--- alfabetik --->
		<cfif session.ep.our_company_info.subscription_contract eq 1>
			$('#list_type').append("<option value='10' <cfif listfind(attributes.list_type,10)> selected</cfif>><cf_get_lang dictionary_id='58832.Abone'></option>");
		</cfif>
		<cfif attributes.search_type eq 2>
			$('#list_type').append("<option value='44' <cfif listfind(attributes.list_type,44)> selected</cfif>><cf_get_lang dictionary_id='58723.Adres'>(<cf_get_lang dictionary_id='40695.Ev'>)</option>");
		</cfif>
		$('#list_type').append("<option value='14' <cfif listfind(attributes.list_type,14)> selected</cfif>><cf_get_lang dictionary_id='58723.Adres'>(<cf_get_lang dictionary_id='57441.Fatura'>)</option>");
		$('#list_type').append("<option value='31' <cfif listfind(attributes.list_type,31)> selected</cfif>><cf_get_lang dictionary_id='29449.Banka Hesabı'></option>");
		$('#list_type').append("<option value='27' <cfif listfind(attributes.list_type,27)> selected</cfif>><cf_get_lang dictionary_id='58813.Cep Telefonu'></option>");
		<cfif attributes.search_type eq 2>
			$('#list_type').append("<option value='28' <cfif listfind(attributes.list_type,28)> selected</cfif>><cf_get_lang dictionary_id='58813.Cep Telefonu'>2</option>");
		</cfif>
		<cfif attributes.search_type eq 1>
			$('#list_type').append("<option value='50' <cfif listfind(attributes.list_type,50)> selected</cfif>><cf_get_lang dictionary_id='57764.Cinsiyet'></option>");
			$('#list_type').append("<option value='52' <cfif listfind(attributes.list_type,52)> selected</cfif>><cf_get_lang dictionary_id='29438.Cikis Tarihi'></option>");
			$('#list_type').append("<option value='53' <cfif listfind(attributes.list_type,53)> selected</cfif>><cf_get_lang dictionary_id='57572.Departman'></option>");
		</cfif>
		<cfif attributes.search_type neq 0>
			$('#list_type').append("<option value='32' <cfif listfind(attributes.list_type,32)> selected</cfif>><cf_get_lang dictionary_id='58727.Doğum Tarihi'></option>");
		</cfif>
		$('#list_type').append("<option value='18' <cfif listfind(attributes.list_type,18)> selected</cfif>><cf_get_lang dictionary_id='57428.Email'></option>");
		$('#list_type').append("<option value='21' <cfif listfind(attributes.list_type,21)> selected</cfif>><cf_get_lang dictionary_id='57488.Fax'></option>");
		<cfif attributes.search_type eq 1>
			$('#list_type').append("<option value='48' <cfif listfind(attributes.list_type,48)> selected</cfif>><cf_get_lang dictionary_id='39931.Gorev'></option>");
		</cfif>
		$('#list_type').append("<option value='46' <cfif listfind(attributes.list_type,46)> selected</cfif>><cf_get_lang dictionary_id='59007.IBAN Kodu'></option>");
		<cfif xml_list_memberid eq 1>
			$('#list_type').append("<option value='40' <cfif listfind(attributes.list_type,40)> selected</cfif>><cf_get_lang dictionary_id='58527.Id'></option>");
		</cfif>
		$('#list_type').append("<option value='17' <cfif listfind(attributes.list_type,17)> selected</cfif>><cf_get_lang dictionary_id='58608.Il'></option>");
		$('#list_type').append("<option value='35' <cfif listfind(attributes.list_type,35)> selected</cfif>><cf_get_lang dictionary_id='58608.Il'>2</option>");
        $('#list_type').append("<option value='57' <cfif listfind(attributes.list_type,57)> selected</cfif>><cf_get_lang dictionary_id='58608.Il'>(<cf_get_lang dictionary_id='57441.Fatura'>)</option>");
        $('#list_type').append("<option value='59' <cfif listfind(attributes.list_type,59)> selected</cfif>><cf_get_lang dictionary_id='58608.Il'>(Vergi Dairesi)</option>");
		$('#list_type').append("<option value='16' <cfif listfind(attributes.list_type,16)> selected</cfif>><cf_get_lang dictionary_id='58638.İlçe'></option>");
		$('#list_type').append("<option value='34' <cfif listfind(attributes.list_type,34)> selected</cfif>><cf_get_lang dictionary_id='58638.İlçe'>2</option>");
        $('#list_type').append("<option value='58' <cfif listfind(attributes.list_type,58)> selected</cfif>><cf_get_lang dictionary_id='58638.İlçe'>(<cf_get_lang dictionary_id='57441.Fatura'>)</option>");
        $('#list_type').append("<option value='60' <cfif listfind(attributes.list_type,60)> selected</cfif>><cf_get_lang dictionary_id='58638.İlçe'>(Vergi Dairesi)</option>");
		<cfif xml_list_branch_related eq 1 and attributes.search_type eq 0>
			 $('#list_type').append("<option value='41' <cfif listfind(attributes.list_type,41)> selected</cfif>><cf_get_lang dictionary_id='39733.İlişkili Şube'>- BSM</option>");
		</cfif>
		<cfif attributes.search_type eq 1>
			 $('#list_type').append("<option value='51' <cfif listfind(attributes.list_type,51)> selected</cfif>><cf_get_lang dictionary_id='38923.İse Giris Tarihi'></option>");
		</cfif>
		$('#list_type').append("<option value='33' <cfif listfind(attributes.list_type,33)> selected</cfif>><cf_get_lang dictionary_id='39176.Kart No'></option>");
		$('#list_type').append("<option value='2' <cfif listfind(attributes.list_type,2)> selected</cfif>><cf_get_lang dictionary_id='57486.Kategori'></option>");
		$('#list_type').append("<option value='25' <cfif listfind(attributes.list_type,25)> selected</cfif>><cf_get_lang dictionary_id='57899.Kaydeden'></option>");
		$('#list_type').append("<option value='23' <cfif listfind(attributes.list_type,23)> selected</cfif>><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></option>");
		$('#list_type').append("<option value='3' <cfif listfind(attributes.list_type,3)> selected</cfif>><cf_get_lang dictionary_id='57751.Kısa Ad'></option>");
		$('#list_type').append("<option value='8' <cfif listfind(attributes.list_type,8)> selected</cfif>><cf_get_lang dictionary_id='39080.Mikro Bölge'></option>");
		$('#list_type').append("<option value='6' <cfif listfind(attributes.list_type,6)> selected</cfif>><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></option>");
		$('#list_type').append("<option value='37' <cfif listfind(attributes.list_type,37)> selected</cfif>><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></option>");
		<cfif attributes.search_type eq 2>
			$('#list_type').append("<option value='36' <cfif listfind(attributes.list_type,36)> selected</cfif>><cf_get_lang dictionary_id='40692.Öneren Üye'></option>");
		</cfif>
		$('#list_type').append("<option value='7' <cfif listfind(attributes.list_type,7)> selected</cfif>><cf_get_lang dictionary_id='57789.Özel Kod'></option>");
		$('#list_type').append("<option value='42' <cfif listfind(attributes.list_type,42)> selected</cfif>><cf_get_lang dictionary_id='57789.Özel Kod'>2</option>");
		$('#list_type').append("<option value='43' <cfif listfind(attributes.list_type,43)> selected</cfif>><cf_get_lang dictionary_id='57789.Özel Kod'>3</option>");
		<cfif attributes.search_type eq 1>
			$('#list_type').append("<option value='54' <cfif listfind(attributes.list_type,54)> selected</cfif>><cf_get_lang dictionary_id='39968.PDKS No'></option>");
			$('#list_type').append("<option value='55' <cfif listfind(attributes.list_type,55)> selected</cfif>><cf_get_lang dictionary_id='29489.PDKS Tipi'></option>");
		</cfif>
		$('#list_type').append("<option value='29' <cfif listfind(attributes.list_type,29)> selected</cfif>><cf_get_lang dictionary_id='58636.Referans Üye'></option>");
		$('#list_type').append("<option value='9' <cfif listfind(attributes.list_type,9)> selected</cfif>><cf_get_lang dictionary_id='57659.Satış Bölgesi'></option>");
		$('#list_type').append("<option value='26' <cfif listfind(attributes.list_type,26)> selected</cfif>><cf_get_lang dictionary_id='57579.Sektör'></option>");
		$('#list_type').append("<option value='68' <cfif listfind(attributes.list_type,68)> selected</cfif>><cf_get_lang dictionary_id='38373.Satış Hesabı'></option>");
		$('#list_type').append("<option value='69' <cfif listfind(attributes.list_type,69)> selected</cfif>><cf_get_lang dictionary_id='38375.Alış Hesabı'></option>");
		
		<cfif attributes.search_type eq 0>
			 $('#list_type').append("<option value='62' <cfif listfind(attributes.list_type,62)> selected</cfif>><cf_get_lang dictionary_id='58847.Marka'></option>");                      
		</cfif>
		<cfif attributes.search_type eq 2>
			$('#list_type').append("<option value='45' <cfif listfind(attributes.list_type,45)> selected</cfif>><cf_get_lang dictionary_id='58132.Semt'> (<cf_get_lang dictionary_id='40695.Ev'>)</option>");
		</cfif>
		$('#list_type').append("<option value='15' <cfif listfind(attributes.list_type,15)> selected</cfif>><cf_get_lang dictionary_id='58132.Semt'> (<cf_get_lang dictionary_id='57441.Fatura'>)</option>");
		$('#list_type').append("<option value='56' <cfif listfind(attributes.list_type,56)> selected</cfif>><cf_get_lang dictionary_id ='29530.Swift Kodu'></option>");
		<cfif attributes.search_type eq 2>
			$('#list_type').append("<option value='47' <cfif listfind(attributes.list_type,47)> selected</cfif>><cf_get_lang dictionary_id='58025.Tc Kimlik No'></option>");
		</cfif>
		$('#list_type').append("<option value='12' <cfif listfind(attributes.list_type,12)> selected</cfif>><cf_get_lang dictionary_id='57499.Telefon'></option>");
		$('#list_type').append("<option value='20' <cfif listfind(attributes.list_type,20)> selected</cfif>><cf_get_lang dictionary_id='57499.Telefon'>2</option>");
		$('#list_type').append("<option value='11' <cfif listfind(attributes.list_type,11)> selected</cfif>><cf_get_lang dictionary_id='57908.Temsilci'></option>");
		$('#list_type').append("<option value='61' <cfif listfind(attributes.list_type,61)> selected</cfif>><cf_get_lang dictionary_id='30124.Temsilci Departmanı'></option>");
		$('#list_type').append("<option value='47' <cfif listfind(attributes.list_type,47)> selected</cfif>><cf_get_lang dictionary_id='58025.Tc Kimlik No'></option>");
		$('#list_type').append("<option value='30' <cfif listfind(attributes.list_type,30)> selected</cfif>><cf_get_lang dictionary_id='58219.Ulke'></option>");
		$('#list_type').append("<option value='4' <cfif listfind(attributes.list_type,4)> selected</cfif>><cf_get_lang dictionary_id='57571.Unvan'></option>");
		<cfif attributes.search_type eq 1>
			$('#list_type').append("<option value='49' <cfif listfind(attributes.list_type,49)> selected</cfif>><cf_get_lang dictionary_id='57571.Unvan'></option>");
		</cfif>
		$('#list_type').append("<option value='1' <cfif listfind(attributes.list_type,1)> selected</cfif>><cf_get_lang dictionary_id='57558.Üye no'></option>");
		$('#list_type').append("<option value='22' <cfif listfind(attributes.list_type,22)> selected</cfif>><cf_get_lang dictionary_id ='39816.Üyelik Başlama Tarihi'></option>");
		$('#list_type').append("<option value='19' <cfif listfind(attributes.list_type,19)> selected</cfif>><cf_get_lang dictionary_id='58762.Vergi Dairesi'></option>");
		$('#list_type').append("<option value='13' <cfif listfind(attributes.list_type,13)> selected</cfif>><cf_get_lang dictionary_id='57752.Vergi No'></option>");
		<cfif attributes.search_type neq 2>
			$('#list_type').append("<option value='5' <cfif listfind(attributes.list_type,5)> selected</cfif>><cf_get_lang dictionary_id='57578.Yetkili'></option>");
		</cfif>
	<cfelse><!--- eski hali --->
		<cfif xml_list_memberid eq 1>
			$('#list_type').append("<option value='40' <cfif listfind(attributes.list_type,40)> selected</cfif>><cf_get_lang dictionary_id='58527.Id'></option>");
		</cfif>
		$('#list_type').append("<option value='1' <cfif listfind(attributes.list_type,1)> selected</cfif>><cf_get_lang dictionary_id='57558.Üye no'></option>");
		$('#list_type').append("<option value='2' <cfif listfind(attributes.list_type,2)> selected</cfif>><cf_get_lang dictionary_id='57486.Kategori'></option>");
		$('#list_type').append("<option value='3' <cfif listfind(attributes.list_type,3)> selected</cfif>><cf_get_lang dictionary_id='57751.Kısa Ad'></option>");
		$('#list_type').append("<option value='4' <cfif listfind(attributes.list_type,4)> selected</cfif>><cf_get_lang dictionary_id='57571.Unvan'></option>");
		<cfif attributes.search_type neq 2>
			$('#list_type').append("<option value='5' <cfif listfind(attributes.list_type,5)> selected</cfif>><cf_get_lang dictionary_id='57578.Yetkili'></option>");
		</cfif>
		<cfif attributes.search_type eq 1>
			$('#list_type').append("<option value='48' <cfif listfind(attributes.list_type,48)> selected</cfif>><cf_get_lang dictionary_id='39931.Gorev'></option>");
			$('#list_type').append("<option value='49' <cfif listfind(attributes.list_type,49)> selected</cfif>><cf_get_lang dictionary_id='57571.Unvan'></option>");
			$('#list_type').append("<option value='50' <cfif listfind(attributes.list_type,50)> selected</cfif>><cf_get_lang dictionary_id='57764.Cinsiyet'></option>");
			$('#list_type').append("<option value='51' <cfif listfind(attributes.list_type,51)> selected</cfif>><cf_get_lang dictionary_id='38923.İse Giris Tarihi'></option>");
			$('#list_type').append("<option value='52' <cfif listfind(attributes.list_type,52)> selected</cfif>><cf_get_lang dictionary_id='39464.Cikis Tarihi'></option>");
			$('#list_type').append("<option value='53' <cfif listfind(attributes.list_type,53)> selected</cfif>><cf_get_lang dictionary_id='57572.Departman'></option>");
			$('#list_type').append("<option value='54' <cfif listfind(attributes.list_type,54)> selected</cfif>><cf_get_lang dictionary_id='39968.PDKS No'></option>");
			$('#list_type').append("<option value='55' <cfif listfind(attributes.list_type,55)> selected</cfif>><cf_get_lang dictionary_id='29489.PDKS Tipi'></option>");
		</cfif>
		$('#list_type').append("<option value='6' <cfif listfind(attributes.list_type,6)> selected</cfif>><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></option>");
		$('#list_type').append("<option value='68' <cfif listfind(attributes.list_type,68)> selected</cfif>><cf_get_lang dictionary_id='38373.Satış Hesabı'></option>");
		$('#list_type').append("<option value='69' <cfif listfind(attributes.list_type,69)> selected</cfif>><cf_get_lang dictionary_id='38375.Alış Hesabı'></option>");
		
			$('#list_type').append("<option value='7' <cfif listfind(attributes.list_type,7)> selected</cfif>><cf_get_lang dictionary_id='57789.Özel Kod'></option>");
		$('#list_type').append("<option value='8' <cfif listfind(attributes.list_type,8)> selected</cfif>><cf_get_lang dictionary_id='39080.Mikro Bölge'></option>");
		$('#list_type').append("<option value='9' <cfif listfind(attributes.list_type,9)> selected</cfif>><cf_get_lang dictionary_id='57659.Satış Bölgesi'></option>");
		$('#list_type').append("<option value='26' <cfif listfind(attributes.list_type,26)> selected</cfif>><cf_get_lang dictionary_id='57579.Sektör'></option>");
		<cfif attributes.search_type eq 0>
			$('#list_type').append("<option value='62' <cfif listfind(attributes.list_type,62)> selected</cfif>><cf_get_lang dictionary_id='58847.Marka'></option>");                      
		</cfif>
		$('#list_type').append("<option value='22' <cfif listfind(attributes.list_type,22)> selected</cfif>><cf_get_lang dictionary_id='39816.Üyelik Başlama Tarihi'></option>");
		$('#list_type').append("<option value='29' <cfif listfind(attributes.list_type,29)> selected</cfif>><cf_get_lang dictionary_id='58636.Referans Üye'></option>");
		$('#list_type').append("<option value='31' <cfif listfind(attributes.list_type,31)> selected</cfif>><cf_get_lang dictionary_id='29449.Banka Hesabı'></option>");
		<cfif xml_list_branch_related eq 1 and attributes.search_type eq 0>
			$('#list_type').append("<option value='41' <cfif listfind(attributes.list_type,41)> selected</cfif>><cf_get_lang dictionary_id='39733.İlişkili Şube'>- BSM</option>");
		</cfif>
		<cfif session.ep.our_company_info.subscription_contract eq 1>
			$('#list_type').append("<option value='10' <cfif listfind(attributes.list_type,10)> selected</cfif>><cf_get_lang dictionary_id='58832.Abone'></option>");
		</cfif>
		$('#list_type').append("<option value='11' <cfif listfind(attributes.list_type,11)> selected</cfif>><cf_get_lang dictionary_id='57908.Temsilci'></option>");
		$('#list_type').append("<option value='47' <cfif listfind(attributes.list_type,47)> selected</cfif>><cf_get_lang dictionary_id='58025.Tc Kimlik No'></option>");
		$('#list_type').append("<option value='12' <cfif listfind(attributes.list_type,12)> selected</cfif>><cf_get_lang dictionary_id='57499.Telefon'></option>");
		$('#list_type').append("<option value='20' <cfif listfind(attributes.list_type,20)> selected</cfif>><cf_get_lang dictionary_id='57499.Telefon'>2</option>");
		$('#list_type').append("<option value='21' <cfif listfind(attributes.list_type,21)> selected</cfif>><cf_get_lang dictionary_id='57488.Fax'></option>");
		$('#list_type').append("<option value='27' <cfif listfind(attributes.list_type,27)> selected</cfif>><cf_get_lang dictionary_id='58813.Cep Telefonu'></option>");
		<cfif attributes.search_type eq 2>
			$('#list_type').append("<option value='28' <cfif listfind(attributes.list_type,28)> selected</cfif>><cf_get_lang dictionary_id='58813.Cep Telefonu'>2</option>");
			$('#list_type').append("<option value='44' <cfif listfind(attributes.list_type,44)> selected</cfif>><cf_get_lang dictionary_id='58723.Adres'>(<cf_get_lang dictionary_id='40695.Ev'>)</option>");
			$('#list_type').append("<option value='45' <cfif listfind(attributes.list_type,45)> selected</cfif>><cf_get_lang dictionary_id='58132.Semt'> (<cf_get_lang dictionary_id='40695.Ev'>)</option>");
		</cfif>
		$('#list_type').append("<option value='14' <cfif listfind(attributes.list_type,14)> selected</cfif>><cf_get_lang dictionary_id='58723.Adres'>(<cf_get_lang dictionary_id='57441.Fatura'>)</option>");
		$('#list_type').append("<option value='19' <cfif listfind(attributes.list_type,19)> selected</cfif>><cf_get_lang dictionary_id='58762.Vergi Dairesi'></option>");
		$('#list_type').append("<option value='13' <cfif listfind(attributes.list_type,13)> selected</cfif>><cf_get_lang dictionary_id='57752.Vergi No'></option>");
		$('#list_type').append("<option value='15' <cfif listfind(attributes.list_type,15)> selected</cfif>><cf_get_lang dictionary_id='58132.Semt'> (<cf_get_lang dictionary_id='57441.Fatura'>)</option>");
		$('#list_type').append("<option value='16' <cfif listfind(attributes.list_type,16)> selected</cfif>><cf_get_lang dictionary_id='58638.İlçe'></option>");
		$('#list_type').append("<option value='17' <cfif listfind(attributes.list_type,17)> selected</cfif>><cf_get_lang dictionary_id='58608.Il'></option>");
		<cfif attributes.search_type eq 2>
			$('#list_type').append("<option value='34' <cfif listfind(attributes.list_type,34)> selected</cfif>><cf_get_lang dictionary_id='58638.İlçe'>2</option>");
			$('#list_type').append("<option value='35' <cfif listfind(attributes.list_type,35)> selected</cfif>><cf_get_lang dictionary_id='58608.Il'>2</option>");
		</cfif>
		$('#list_type').append("<option value='30' <cfif listfind(attributes.list_type,30)> selected</cfif>><cf_get_lang dictionary_id='58219.Ulke'></option>");
		$('#list_type').append("<option value='18' <cfif listfind(attributes.list_type,18)> selected</cfif>><cf_get_lang dictionary_id='57428.Email'></option>");
		$('#list_type').append("<option value='25' <cfif listfind(attributes.list_type,25)> selected</cfif>><cf_get_lang dictionary_id='57899.Kaydeden'></option>");
		$('#list_type').append("<option value='23' <cfif listfind(attributes.list_type,23)> selected</cfif>><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></option>");
		$('#list_type').append("<option value='33' <cfif listfind(attributes.list_type,33)> selected</cfif>><cf_get_lang dictionary_id='39176.Kart No'></option>");
		<cfif attributes.search_type neq 0>
			$('#list_type').append("<option value='32' <cfif listfind(attributes.list_type,32)> selected</cfif>><cf_get_lang dictionary_id='58727.Doğum Tarihi'></option>");
		</cfif>
		$('#list_type').append("<option value='37' <cfif listfind(attributes.list_type,37)> selected</cfif>><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></option>");
		$('#list_type').append("<option value='42' <cfif listfind(attributes.list_type,42)> selected</cfif>><cf_get_lang dictionary_id='57789.Özel Kod'>2</option>");
		$('#list_type').append("<option value='43' <cfif listfind(attributes.list_type,43)> selected</cfif>><cf_get_lang dictionary_id='57789.Özel Kod'>3</option>");
		$('#list_type').append("<option value='46' <cfif listfind(attributes.list_type,46)> selected</cfif>><cf_get_lang dictionary_id='59007.IBAN Kodu'></option>");
		$('#list_type').append("<option value='56' <cfif listfind(attributes.list_type,56)> selected</cfif>><cf_get_lang dictionary_id ='29530.Swift Kodu'></option>");
		<cfif attributes.search_type eq 2>
			$('#list_type').append("<option value='36' <cfif listfind(attributes.list_type,36)> selected</cfif>><cf_get_lang dictionary_id='40692.Öneren Üye'></option>");
			$('#list_type').append("<option value='47' <cfif listfind(attributes.list_type,47)> selected</cfif>><cf_get_lang dictionary_id='58025.Tc Kimlik No'></option>");
		</cfif>
		$('#list_type').append("<option value='61' <cfif listfind(attributes.list_type,61)> selected</cfif>><cf_get_lang dictionary_id='30124.Temsilci Departmanı'></option>");
		$('#list_type').append("<option value='67' <cfif listfind(attributes.list_type,67)> selected</cfif>><cf_get_lang dictionary_id='52268.Üst Şirket'></option>");
	</cfif>
});

function ajaxChangeCompany(){
	/*Rapor Tipine göre Liste Kategorisini duzenleme*/	
	var add_options = 0;
	var del_options = 0;
	if(document.getElementById("search_type").value == 1)
		{
			
			document.getElementById("is_show_member_team").disabled=true;	
		}
	else
		{
			document.getElementById("is_show_member_team").disabled=false;
			
		}
	if(list_find("1,2",document.getElementById("search_type").value))
	{
		document.getElementById("company_cat").style.display='none';
		document.getElementById("consumer_cat").style.display='';
		document.getElementById("company_cat_2").style.display='none';
		document.getElementById("consumer_cat_2").style.display='';
		document.getElementById("partner_status_").style.display='none';
		document.getElementById("partner_status3_").style.display='none';
		
		
		if($('#list_type option[value="28"]').val() != "undefined") $('#list_type').append("<option value='28' <cfif listfind(attributes.list_type,28)> selected</cfif>><cf_get_lang dictionary_id='58813.Cep Telefonu'>2</option>");
		if($('#list_type option[value="32"]').val() != "undefined") $('#list_type').append("<option value='32' <cfif listfind(attributes.list_type,32)> selected</cfif>><cf_get_lang dictionary_id='58727.Doğum Tarihi'></option>");
		
		$('#list_type option[value="5"]').remove();
	}
	
	else
	{
		document.getElementById("company_cat").style.display='';
		document.getElementById("consumer_cat").style.display='none';
		document.getElementById("company_cat_2").style.display='';
		document.getElementById("consumer_cat_2").style.display='none';
		document.getElementById("partner_status_").style.display='';
		document.getElementById("partner_status3_").style.display='';
		
		$('#list_type option[value="28"]').remove();
		$('#list_type option[value="32"]').remove();
		$('#list_type').append("<option value='5' <cfif listfind(attributes.list_type,5)> selected</cfif>><cf_get_lang dictionary_id='57578.Yetkili'></option>");
	}
	
	
	if(document.getElementById("search_type").value == 2)
	{
		
		if($('#list_type option[value="44"]').val() != "undefined") $('#list_type').append("<option value='44' <cfif listfind(attributes.list_type,44)> selected</cfif>><cf_get_lang dictionary_id='58723.Adres'>(<cf_get_lang dictionary_id='40695.Ev'>)</option>");
		if($('#list_type option[value="45"]').val() != "undefined") $('#list_type').append("<option value='45' <cfif listfind(attributes.list_type,45)> selected</cfif>><cf_get_lang dictionary_id='58132.Semt'>(<cf_get_lang dictionary_id='40695.Ev'>)</option>");
	}
	else
	{	
		$('#list_type option[value="44"]').remove();
		$('#list_type option[value="45"]').remove();
	}
	
}
</script>
