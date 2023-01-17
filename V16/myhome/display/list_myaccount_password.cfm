<cfinclude template="../query/my_sett.cfm">
<cfquery name="GET_PASSWORD_STYLE" datasource="#DSN#">
	SELECT * FROM PASSWORD_CONTROL WHERE PASSWORD_STATUS = 1
</cfquery>
<cfset pass_control_number=''>
<cfset pass_control_number= get_password_style.password_history_control>
	<!--- kullanıcı bilgileri alınıyor --->
	<cfscript>
    	get_employee_name_tmp = createObject("component","cfc.right_menu_fnc");
		get_employee_name_tmp.dsn = dsn;
		get_employee_name = get_employee_name_tmp.upd_password(session.ep.userid,iif(isdefined("attributes.employee_id"),"attributes.employee_id",DE("")));
    </cfscript> 

<cfif isDefined("strippedForm") AND strippedForm>
	<cfform action="#request.self#?fuseaction=myhome.account_process&id=acc_period" method="POST" name="account">
		<div class="ui-form-list ui-form-block">
			<cfif isdefined("attributes.employee_id")><input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>"></cfif>
		<div class="form-group">
			<label><cf_get_lang dictionary_id="57551.Kullanıcı Adı"></label>
			<input type="text" name="employee_username" id="employee_username"  value="<cfoutput>#get_employee_name.employee_username#</cfoutput>">
		</div>
		<div class="form-group">
			<label><cf_get_lang dictionary_id="30833.Mevcut Şifre"></label>
			<div class="input-group">
				<input type="text" name="employee_password0" id="employee_password0" class="input-type-password">
				<span class="input-group-addon showPassword" onclick="showPasswordClass('employee_password0')"><i class="fa fa-eye"></i></span>
			</div>
		</div>	
		<div class="form-group">
			<label><cf_get_lang dictionary_id="57552.Şifre"></label>
			<div class="input-group">
				<cfinput type="text" name="employee_password1" id="employee_password1" class="input-type-password" value="" maxlength="16" tabindex="3" oncopy="return false" onpaste="return false">
				<span class="input-group-addon showPassword" onclick="showPasswordClass('employee_password1')"><i class="fa fa-eye"></i></span>
			</div>
		</div>
		<div class="form-group">
			<label><cf_get_lang dictionary_id='59013.Şifre Tekrar'></label>
			<div class="input-group">
				<cfinput type="text" name="employee_password2" id="employee_password2" class="input-type-password" value="" maxlength="16" tabindex="4" oncopy="return false" onpaste="return false">
				<span class="input-group-addon showPassword" onclick="showPasswordClass('employee_password2')"><i class="fa fa-eye"></i></span>
			</div>
		</div>
		</div>
		<div class="ui-form-list-btn ui-form-list-btn-type2">
			<div>
				<a href="javascript://" class="ui-btn ui-btn-success" onClick="return gelen();"  tabindex="5"/><cf_get_lang dictionary_id='57464.Güncelle'></a>
			</div>
		</div>
		<div id="SHOW_INFO"></div>
	</cfform>
	<cfif isdefined("attributes.type")> 
		<font color="#FF0000">*<cf_get_lang dictionary_id ='31626.Şifreniz Başarı İle Değiştirildi'>!</font>
	</cfif>
<cfelse>
	<div class="col col-12 col-xs-12">
		<cf_box title="#getLang('','Şifre Yenileme',61972)#">
			<cfform action="#request.self#?fuseaction=myhome.account_process&id=acc_period" method="POST" name="account">
				<cf_box_elements vertical="1">
					<div class="col col-4 col-xs-12">
						<cfif isdefined("attributes.employee_id")><input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>"></cfif>
						<div class="form-group">
							<label class="font-grey-300 col col-4 col-sm-12"><cf_get_lang dictionary_id="57551.Kullanıcı Adı"></label>
							<div class="col col-8 com-sm-12">
								<input type="text" name="employee_username" id="employee_username"  value="<cfoutput>#get_employee_name.employee_username#</cfoutput>">
							</div>
						</div>
						<div class="form-group">
							<label class="font-grey-300 col col-4 col-sm-12"><cf_get_lang dictionary_id="30833.Mevcut Şifre"></label>
							<div class="col col-8 com-sm-12">
								<div class="input-group">
									<input type="text" name="employee_password0" id="employee_password0" class="input-type-password">
									<span class="input-group-addon showPassword" onclick="showPasswordClass('employee_password0')"><i class="fa fa-eye"></i></span>
								</div>
							</div>
						</div>	
						<div class="form-group">
							<label class="font-grey-300 col col-4 col-sm-12"><cf_get_lang dictionary_id="57552.Şifre"></label>
							<div class="col col-8 com-sm-12">
								<div class="input-group">
									<cfinput type="text" name="employee_password1" id="employee_password1" class="input-type-password" value="" maxlength="16" tabindex="3" oncopy="return false" onpaste="return false">
									<span class="input-group-addon showPassword" onclick="showPasswordClass('employee_password1')"><i class="fa fa-eye"></i></span>
								</div>
							</div>
						</div>
						<div class="form-group">
							<label class="font-grey-300 col col-4 col-sm-12"><cf_get_lang dictionary_id='59013.Şifre Tekrar'></label>
							<div class="col col-8 com-sm-12">
								<div class="input-group">
									<cfinput type="text" name="employee_password2" id="employee_password2" class="input-type-password" value="" maxlength="16" tabindex="4" oncopy="return false" onpaste="return false">
									<span class="input-group-addon showPassword" onclick="showPasswordClass('employee_password2')"><i class="fa fa-eye"></i></span>
								</div>
							</div>
						</div>	
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<div class="col col-12">
							<div id="SHOW_INFO"></div>
							<cf_workcube_buttons is_upd="1" is_delete="0" add_function="gelen()">
							<!--- <input type="button" class="btn btn-primary" value="<cf_get_lang dictionary_id='57464.Güncelle'>" onClick="return gelen();"  tabindex="5"/> --->
						</div>
						<cfif isdefined("attributes.type")> 
							<div class="form-group text-right">
								<font color="#FF0000">*<cf_get_lang dictionary_id ='31626.Şifreniz Başarı İle Değiştirildi'>!</font>
							</div>
						</cfif>
					</div>
				</cf_box_footer>
			</cfform>
		</cf_box>
	</div>
<script type="text/javascript">
	<cfif isDefined("session.ep.must_password_change") and session.ep.must_password_change eq 1>
		alert("<cf_get_lang dictionary_id='61460.Şifrenizin periyodik yenileme zamanı gelmiştir, devam etmeden önce şifrenizi değiştirmeniz gerekmektedir!'>");
	</cfif>
</script>
</cfif>
<script type="text/javascript">
document.getElementById('employee_password0').focus();
function gelen()
{
	var pass_cont_=0;
	var emp_user=document.getElementById('employee_username');
	var emp_pas0=document.getElementById('employee_password0');
	var emp_pas1=document.getElementById('employee_password1');
	var emp_pas2=document.getElementById('employee_password2');
	control_ifade_ = document.getElementById('employee_password1').value;
	var gel = $('#employee_password1').val();
	
	if (emp_user.value.length == 0)
	{
		alert("<cf_get_lang dictionary_id='52868.Kullanıcı Adı Girmelisiniz!'>");
		document.getElementById('emp_user').focus();
		return false;
	}
	
	if ((emp_user.value.length > 0 && emp_pas0.value.length == 0) || (emp_pas1.value.length > 0 && emp_pas0.value.length == 0))
	{
		alert("<cf_get_lang dictionary_id='45140.Lütfen Mevcut Şifrenizi Giriniz!'>");
		document.getElementById('employee_password0').focus();
		return false;
	}
	if (emp_pas0.value.length == 0 || emp_pas1.value.length == 0 || emp_pas0.value.indexOf(" ") != -1  || emp_pas1.value.indexOf(" ") != -1)
	{
		alert("<cf_get_lang dictionary_id='30481.Şifrenizi Girmediniz'>	 <cf_get_lang dictionary_id='38682.Şifre boşluk karakterini içeremez.'>");
		document.getElementById('employee_password0').focus();
		return false;
	}	
	
	if(emp_pas1.value == emp_user.value)
	{
		alert("<cf_get_lang dictionary_id='30952.Şifre Kullanıcı Adıyla Aynı Olamaz'>!");
		document.getElementById('employee_password1').focus();		
		return false;
	}
	
	if (emp_pas1.value.length > 0)
	{
		if(emp_pas0.value == emp_pas1.value)
		{
			alert("<cf_get_lang dictionary_id='35765.Lütfen farklı bir şifre giriniz'>!");
			document.getElementById('employee_password1').focus();			
			return false;
		}
	}

	if (document.getElementById('employee_password1').value != document.getElementById('employee_password2').value)
	{
		alert("<cf_get_lang dictionary_id='30944.Girilen İki Şifre Uyuşmuyor'>!");
		document.getElementById('employee_password1').focus();		
		return false;
	}	
	
	var uzunluk=gel.length;
	var lowercase = "abcdefghijklmnopqrstuvwxyz";	
	var uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	var number="0123456789";

	var ozel="!]'^%&([=?_<£)#$½{\|.:,;/*-+}>";

	var sayac_kucuk=0;
	var sayac_ozel=0;

	var containsNumberCase = contains(control_ifade_,number);
	var containsLowerCase = contains(control_ifade_,lowercase);
	var containsUpperCase = contains(control_ifade_,uppercase);
	var ozl = contains(control_ifade_,ozel);


	if((emp_pas1.value !="") || (emp_pas2.value!="")) 
	{
	   <cfif get_password_style.recordcount>
		  <cfoutput>
			if(uzunluk<#get_password_style.password_length#)
			{
				alert("<cf_get_lang dictionary_id='30949.Şifre Karakter Sayısı Az'>! <cf_get_lang dictionary_id='30951.Şifrede Olması Gereken Karakter Sayısı'> : #get_password_style.password_length#");
				document.getElementById('employee_password0').focus();				
				return false;
			} 
	
			if(#get_password_style.password_number_length#>containsNumberCase)
			{
				alert("<cf_get_lang dictionary_id='30948.Şifrede Olması Gereken Rakam Sayısı'> : #get_password_style.password_number_length#");
				document.getElementById('employee_password1').focus();				
				return false;
			}
	
			if(#get_password_style.password_lowercase_length#>containsLowerCase)
			{
				alert("<cf_get_lang dictionary_id='30947.Şifrede Olması Gereken Küçük Harf Sayısı'> :#get_password_style.password_lowercase_length#");
				document.getElementById('employee_password1').focus();				
				return false;
			}
	
			if(#get_password_style.password_uppercase_length#>containsUpperCase)
			{
				alert("<cf_get_lang dictionary_id='30946.Şifrede Olması Gereken Büyük Harf Sayısı'> : #get_password_style.password_uppercase_length#");
				document.getElementById('employee_password1').focus();				
				return false;
			}
				
			if(#get_password_style.password_special_length#>ozl)
			{
				alert("<cf_get_lang dictionary_id='30945.Şifrede Olması Gereken Özel Karakter Sayısı'> : #get_password_style.password_special_length#");
				document.getElementById('employee_password1').focus();				
				return false;
			}
	
		  </cfoutput>
	   </cfif>
    }
	
	var ext_params_ = emp_user.value + '¶' + '<cfoutput><cfif isdefined("attributes.employee_id")>#attributes.employee_id#<cfelse>#session.ep.userid#</cfif></cfoutput>';
	var username_control = wrk_safe_query('employee_username_control','dsn',0,ext_params_);
	if(username_control.recordcount > 0)
	{
		alert("<cf_get_lang dictionary_id='31986.Kullanıcı Adı Kullanılıyor'> !");
		document.getElementById('emp_user').focus();		
		return false;
	}
	var ext_params2_ = emp_pas0.value + '¶' + '<cfoutput><cfif isdefined("attributes.employee_id")>#attributes.employee_id#<cfelse>#session.ep.userid#</cfif></cfoutput>';
	var password_control = wrk_safe_query('employee_password_control','dsn',0,ext_params2_);
	if(password_control.recordcount == 0)
	{
		alert("<cf_get_lang dictionary_id='30475.Şifrenizi Yanlış Girdiniz'> !");
		document.getElementById('employee_password0').focus();		
		return false;
	}
	
	if(emp_pas0.value.length > 0)
	{
		<cfif get_password_style.recordcount>
			if(<cfoutput>#get_password_style.PASSWORD_HISTORY_CONTROL#</cfoutput> > 0)
			{
				var ext_params_ = emp_pas1.value + '¶' + '<cfoutput><cfif isdefined("attributes.employee_id")>#attributes.employee_id#<cfelse>#session.ep.userid#</cfif></cfoutput>';
				var password_control = wrk_safe_query('employee_old_password_control','dsn',0,ext_params_);
					
				var kayit_ = password_control.recordcount;
				if(kayit_ > 0)
				{
					for (i = 0;i < kayit_; i++)
						{
							var deger1_ = String(password_control.NEW_PASSWORD[i]);
							var deger2_ = String(password_control.SON_GELEN[i]);
							if(deger1_ == deger2_ && i < <cfoutput>#get_password_style.password_history_control#</cfoutput>)
							{
							alert('<cf_get_lang dictionary_id='35765.Lütfen farklı bir şifre giriniz'>. <cf_get_lang dictionary_id='43845.Eski Şifre Kontrol Sayısı'> : <cfoutput>#get_password_style.password_history_control#</cfoutput>');
							document.getElementById('employee_password0').focus();
							return false;
							}
						}
				}
			}
		</cfif>
	}
   AjaxFormSubmit('account','SHOW_INFO',1,'Güncelleniyor','Güncellendi');
}

function contains(deger,validChars)						
{
	var sayac=0;				             
	for (i = 0; i < deger.length; i++)
	{
		var char = deger.charAt(i);
		if (validChars.indexOf(char) > -1)    
			sayac++;
	}
	return(sayac);				
}
</script>
