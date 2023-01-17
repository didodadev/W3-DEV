<!--- TC Kimlik numarası girdigimiz yerlerde kullanılmak uzere duzenlenmistir. BK 20100622 --->
<cfparam name="attributes.fieldId" default=''>
<cfparam name="attributes.tc_identity_number" default=''>
<cfparam name="attributes.on_blur_control" default='0'>
<cfparam name="attributes.width_info" default='165'>
<cfparam name="attributes.onFocus" default=''>
<cfparam name="attributes.maxlength" default='11'>
<cfparam name="attributes.tc_identity_required" default='no'>
<cfparam name="attributes.is_verify" default='no'><!--- Doğrulama yapması isteniyorsa 1 gönderilir. --->
<cfparam name="attributes.consumer_name" default='no'><!--- Doğrulama için isim zorunlu olduğu için ismin tutulduğu alan adı yazılmalı --->
<cfparam name="attributes.consumer_surname" default='no'><!--- Doğrulama için soyad zorunlu olduğu için soyadın tutulduğu alan adı yazılmalı --->
<cfparam name="attributes.birth_date" default='no'><!--- Doğrulama için doğum tarihi zorunlu olduğu için doğum tarihinin tutulduğu alan adı yazılmalı --->
<cfparam name="attributes.use_gib" default="0"><!--- gib tckn sorgulama için 1 yapılmalı --->
<!--- gdpr “1,2,3,4,5,6,7,8,9” --->
<cfparam name="attributes.gdpr" default="">
<cfif attributes.use_gib eq "1">
	<cfinclude template="/WEX/gib/internalapi.cfm" runOnce="true">
	<cfset is_gib_activate_result = is_gib_activate()>
<cfelse>
	<cfset is_gib_activate_result = 0>
</cfif>
<cfobject name="gdpr_" type="component" component="workdata.get_gdpr_control">
    <cfset caller.__control_gdpr = gdpr_.getComponentFunction()>
    <cfset control_gdpr = caller.__control_gdpr>
    <cfif isdefined('attributes.gdpr') and len(attributes.gdpr)>
        <cfset attributes.tc_identity_number_ = '#attributes.tc_identity_number#'>
        <cfset caller.__get_gdpr = gdpr_.getComponentFunctionGDPR(gdpr_ : attributes.gdpr)>
        <cfset get_gdpr = caller.__get_gdpr>
        <cfif get_gdpr.recordcount>
            <cfset attributes.tc_identity_number = '#attributes.tc_identity_number_#'>
            <cfoutput><input type="hidden" name="#attributes.fieldId#_" id="#attributes.fieldId#_" value="#attributes.tc_identity_number#"></cfoutput>
            <cfset attributes.fieldId = '#attributes.fieldId#'>
        <cfelse>
            <script>
                $(window).load(function(){ $('[name="<cfoutput>#attributes.fieldId#</cfoutput>"]').attr("readonly", true);$('[name="<cfoutput>#attributes.fieldId#</cfoutput>"]').attr('onclick','power()');$('[name="<cfoutput>#attributes.fieldId#_</cfoutput>"]').attr("readonly", true);$('[name="<cfoutput>#attributes.fieldId#_</cfoutput>"]').attr('onclick','power()');
            })
            </script>
			<cfset attributes.tc_identity_number = "#mid(attributes.tc_identity_number_,1,2)#*******">
			<cfoutput><input type="hidden" name="#attributes.fieldId#" id="#attributes.fieldId#" value="#attributes.tc_identity_number_#"></cfoutput>
			<cfset attributes.fieldId = '#attributes.fieldId#_'>
        </cfif>
    </cfif>
<cfoutput>
	<input type="hidden" name="is_verify" id="is_verify" value="">
	<cfif attributes.tc_identity_required and attributes.is_verify eq 0 and is_gib_activate_result eq 0>
		<input type="text" name="#attributes.fieldId#" id="#attributes.fieldId#" style="width:#attributes.width_info#px;" value="#attributes.tc_identity_number#" onBlur="isTCNUMBER(this);" onkeyup="isNumber(this)" maxlength="#attributes.maxlength#" autocomplete="off" <cfif len(attributes.onFocus)>onfocus="#attributes.onFocus#"</cfif>>
	<cfelse>
		<cfif attributes.is_verify eq 1 or is_gib_activate_result eq 1>
			<div class="input-group">
		</cfif>
		<input type="text" name="#attributes.fieldId#" id="#attributes.fieldId#" style="width:#attributes.width_info#px;" value="#attributes.tc_identity_number#" <cfif attributes.on_blur_control eq 1>onBlur="kontrol_tcno_verify();"</cfif> onkeyup="isNumber(this)" maxlength="#attributes.maxlength#" autocomplete="off" <cfif len(attributes.onFocus)>onfocus="#attributes.onFocus#"</cfif>>
	</cfif>
	<cfif attributes.is_verify eq 1 and is_gib_activate_result eq 1>
		<span class="input-group-addon" >
			<i class="fa fa-info-circle" title="TC Kimlik No Doğrula" border="0" align="absmiddle" onclick="kontrol_tcno_verify();"></i>
			<i class="icon-search btnPointer show" onclick="mukellefSorgula()"></i>
		</span>
		</div>
		<div id="TC_IDENTY_KONTROL"></div>
	<cfelseif attributes.is_verify eq 1>
		<span class="input-group-addon"  onclick="kontrol_tcno_verify();">
			<i class="fa fa-info-circle" title="TC Kimlik No Doğrula" border="0" align="absmiddle"></i>
		</span>
		</div>
		<div id="TC_IDENTY_KONTROL"></div>
	<cfelseif is_gib_activate_result eq 1>
		<span class="input-group-addon">
			<i class="icon-search btnPointer show" onclick="mukellefSorgula()"></i>
		</span>
		</div>
	</cfif>
	<script type="text/javascript">
		function kontrol_tcno_verify()
		{
			if(document.getElementById('#attributes.fieldId#').value == '' || document.getElementById('#attributes.consumer_name#').value == '' || document.getElementById('#attributes.consumer_surname#').value == '' || document.getElementById('#attributes.birth_date#').value == '')
			{
				alert("#caller.getLang('main',2176)#");
				return false;
			}
			AjaxPageLoad('#request.self#?fuseaction=objects2.emptypopup_verify_tc_identyno&tc_number='+document.getElementById('#attributes.fieldId#').value+'&consumer_name='+document.getElementById('#attributes.consumer_name#').value+'&consumer_surname='+document.getElementById('#attributes.consumer_surname#').value+'&birth_date='+document.getElementById('#attributes.birth_date#').value+'','TC_IDENTY_KONTROL',1);
		}
	</script>
</cfoutput>
