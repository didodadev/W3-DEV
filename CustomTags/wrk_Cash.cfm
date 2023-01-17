<cfparam name="attributes.value" default=""><!----Hangi itemın seçili olmasını istiyorsak ----->
<cfparam name="attributes.disabled" default="0">
<cfparam name="attributes.multiple" default="0">
<cfparam name="attributes.cash_status" default="">
<cfparam name="attributes.is_all_branch" default="3">
<cfparam name="attributes.branch_id" default=""><!----  Form sayfasından  gelen branch_id'ye göre Query'den çeker---->
<cfparam name="attributes.cash_id" default=""><!----  Form sayfasından  gelen cash_id'ye göre Query'den çeker---->
<cfparam name="attributes.acc_code" default=""><!---  muhasebe kodlarına göre query den çeker --->
<cfparam name="attributes.currency_branch" default=""><!--- selectlerin valuesini sıraya göre doldurma( Para Birimleri Aynı sırada Olmalı) --->
<cfparam name="attributes.is_virman" default="0">
<cfparam name="attributes.is_store" default="0">
<cfparam name="attributes.required" default="">
<cfparam name="attributes.onchange" default="">
<cfparam name="attributes.is_option_text" default="1">
<cfparam name="attributes.class" default="">
<cfparam name="attributes.option_text" default="#caller.getLang('main',322)#"><!--- Seçiniz --->
	<cfinvoke 
 		component = "/workdata/get_cash" 
 		method="getComponentFunction" 
 		returnvariable="queryResult">
 		<cfinvokeargument name="cash_status" value="#attributes.cash_status#">
		<cfinvokeargument name="is_all_branch" value="#attributes.is_all_branch#">
		<cfinvokeargument name="is_store" value="#attributes.is_store#">
		<cfinvokeargument name="is_virman" value="#attributes.is_virman#">
		<cfinvokeargument name="branch_id" value="#attributes.branch_id#">
		<cfinvokeargument name="cash_id" value="#attributes.cash_id#">
		<cfinvokeargument name="acc_code" value="#attributes.acc_code#">
		<cfinvokeargument name="use_period" value="#caller.fusebox.use_period#">
	</cfinvoke>
<select id="<cfoutput>#attributes.name#</cfoutput>" name="<cfoutput>#attributes.name#</cfoutput>" <cfif len(attributes.onchange)>onchange="<cfoutput>#attributes.onchange#</cfoutput>"</cfif> <cfif attributes.multiple eq 1>multiple</cfif> <cfif attributes.disabled eq 1>disabled</cfif> <cfif len(attributes.class)>class="<cfoutput>#attributes.class#</cfoutput>"</cfif> <cfif len(attributes.required)>required="<cfoutput>#attributes.required#</cfoutput>"</cfif>>
    <cfif attributes.is_option_text eq 1 and not len(attributes.cash_id)>
		<option value=""><cfoutput>#attributes.option_text#</cfoutput></option>
	</cfif>
	<cfoutput query="queryResult">
		 <cfif attributes.currency_branch eq 0>
			<option value="#CASH_ID#;#cash_currency_id#;#branch_id#" <cfif len(attributes.value) and listfind(attributes.value,CASH_ID,',')>selected</cfif>>#CASH_NAME#&nbsp;#CASH_CURRENCY_ID#<cfif len(attributes.branch_id)>&nbsp;#branch_id#</cfif></option> 
		<cfelseif attributes.currency_branch eq 1>
			<option value="#cash_id#;#branch_id#;#cash_currency_id#" <cfif len(attributes.value) and listfind(attributes.value,CASH_ID,',')>selected</cfif>>#CASH_NAME#&nbsp;#CASH_CURRENCY_ID#<cfif len(attributes.branch_id)>&nbsp;#branch_id#</cfif></option>
		<cfelseif attributes.currency_branch eq 2>
			<option value="#cash_id#;#cash_currency_id#" <cfif len(attributes.value) and listfind(attributes.value,CASH_ID,',')>selected</cfif>>#CASH_NAME#&nbsp;#CASH_CURRENCY_ID#<cfif len(attributes.branch_id)>&nbsp;#branch_id#</cfif></option> 
		<cfelse>
				<option value="#CASH_ID#" <cfif len(attributes.value) and listfind(attributes.value,CASH_ID,',')>selected</cfif>>#CASH_NAME#&nbsp;#CASH_CURRENCY_ID#<cfif len(attributes.branch_id)>&nbsp;#branch_id#</cfif></option> 
		</cfif>
    </cfoutput>
</select>

<!---#CASH_ID#;#CASH_CURRENCY_ID#;#branch_id# value de bu tutuluo
	CASH-STATUS=1 İSE 1 OLANLAR
			   =0 İSE 0 OLANLAR
			   =2 İSE HEPSİ 
			   DEFAULT 1
	IS-ALL_BRANCH=0 İSE 0 OLANLAR
				 =1 İSE 1 OLANLAR
				 =2 İSE NULL OLANLAR
				 =3 İSE HEPSİ 
				 DEFAULT 3 	   
	is_virman = 1 ise  is_all_branch 1 olanlar ya da branch_id=ep.user_location ın ikinci kısmı
	default 0
	store dan gönderilen virman için geçerli
	
	branch_id istenilen branch_id ye göre getirio
	  --->
